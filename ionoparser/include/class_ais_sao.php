<?php
/************************************************************************/
/****Classe per la gestione dei file SAO prodotti da autoscala****/

class ais_sao_file
{
    public $filename;               /// input file name 

    public $station;           /// URSI code for station
    public $dt;           /// URSI code for station
    public $myconn;
    public $isPostgres;             /// true if upe pg
    public $db;                     /// database name

    public $trace_xml;
    public $trace_arr=array();
    public $trace_json;

    function __construct($fn,$myc, $statio, $fname, $fdt, $isPg, $fdb){
        $this -> filename       = $fn;
        $this -> fname          = $fname;
        $this -> station        = $statio;
        $this -> dt             = $fdt;
        $this -> db             = $fdb;
        $this -> isPostgres = ($isPg == 'pg' ? 1 : 0);
        $this -> myconn         = $myc;
    }

    function read_file(){
    /**
     * Funzione che popola la classe leggendo il file di input prodotto da autoscala 
     */

        if ($fn = fopen($this->filename, 'r')) {
            //$line = file($fn);   // apro il file come array e poi estraggo l'header (primo riga) e il corpo (seconda riga)
            try{
                $this -> trace_xml = simplexml_load_file($this->filename) or die("Error: Cannot create object");
            }
            catch(Exception $e){
                $out = array(
                    "err_code" => 1,
                    "err_message" => $e->getMessage()
                );
                return $out;
            }
            
            // lettura delle altezze
            $xml = $this -> trace_xml->SAORecord->TraceList;
            if (empty($xml)) {
               $out = array(
                    "err_code" => 10,
                    "err_message" => 'OK_NO_PROFILE'
                );
                return $out;
            }
            foreach($xml->children() as $child) {
                $trace_arr_tmp=array();
                $appRangeList       = preg_replace("/[[:blank:]]+/",",", str_replace("\n", "",$child->RangeList['0']));
                $appFrequencyList   = preg_replace("/[[:blank:]]+/",",", str_replace("\n", "",$child->FrequencyList['0']));
                if (substr($appRangeList, 0, 1)==","){
                    $appRangeList = substr($appRangeList,1); 
                }
                if (substr($appRangeList,-1)==","){
                    $appRangeList = substr($appRangeList,0,-1);
                }
                if (substr($appFrequencyList, 0, 1)==","){
                    $appFrequencyList = substr($appFrequencyList,1);
                }
                if (substr($appFrequencyList,-1)==","){
                    $appFrequencyList = substr($appFrequencyList,0,-1);
                }
                // creazione degli array
                $arr = explode(',', $appRangeList);
                $i=0;
                foreach($arr as $k) {
                    //$this -> trace_arr[$k] = 'null';
                    $trace_arr_tmp[$i] = array('h' => $k, 'f' => '');
                    $i++;
                }
                $arr = explode(',', $appFrequencyList);
                $i=0;
                foreach ($trace_arr_tmp as $a) {
                    //$this -> trace_arr[key($this -> trace_arr)] = $arr1[$i];
                    //$trace_arr_tmp[$i]['freq'] = $arr[$i];
                    $trace_arr_tmp[$i]['f'] = $arr[$i];
                    $i++;
                }
                $this->trace_arr = array_merge($trace_arr_tmp, $this->trace_arr);
            }
            // sort by h 
            usort($this->trace_arr, function($a, $b) {
                return $a['h'] <=> $b['h'];
            });
            $this -> trace_json = json_encode($this->trace_arr, JSON_NUMERIC_CHECK);
            fclose($fn);
            $out = array(
                "err_code" => 0,
                "err_message" => "File parsed"
            );
        } else {
            $out = array(
                "err_code" => -1,
                "err_message" => "Can't open file"
            );
        }
        return $out;
    }


    /********************************/
    /***Funzione che popola il DB****/

    function push2db() {
        /// controllo dell esistenza della stazione e sua eventuale creazione
        ///
        if ($this->isPostgres) {
            $sql = "SELECT COUNT(*) ntab FROM information_schema.tables WHERE table_catalog = :dbname AND table_name = :tablename;";
        } else{
            $sql = "SELECT COUNT(*) ntab FROM information_schema.tables WHERE table_schema = :dbname AND table_name = :tablename;";
        }
        try{
            $stmt = $this -> myconn -> conn -> prepare($sql, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
            $appo = array(
                    ':dbname'       => strval($this -> db),
                    ':tablename'    => strval($this -> station)."_auto"
                );
            $stmt->execute( $appo);
            $out = $stmt -> fetchAll();
        }
        catch (PDOException $e) {
            fn_debug_query_e($sql, $appo, $out, $e);
            echo "ERROR CONNECTIN DB ";
            $stmt->closeCursor();
            $stmt = null;
            return ;
        }
        $stmt->closeCursor();
        $stmt = null;
        if ($out[0]['ntab'] == 0) {
            // il nome della tabella non puo essere passato col prepare cone variabile di pdo
            $sql = createAisAutoTable($this -> station, $this->isPostgres);
            try{
                //$stmt = $this -> myconn -> conn -> prepare($sql, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
                $stmt = $this -> myconn -> conn -> prepare($sql);
                $stmt->execute();
                $out = $stmt -> fetchAll();
                $stmt->closeCursor();
            }
            catch (PDOException $e) {
                fn_debug_query_e($sql, $appo, $out, $e);
                $stmt->closeCursor();
                echo "ERROR CONNECTIN DB ";
                return ;
            }
            $sql = createAisAutoView($this -> station, $this->isPostgres);
            try{
                //$stmt = $this -> myconn -> conn -> prepare($sql, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
                $stmt = $this -> myconn -> conn -> prepare($sql);
                $stmt->execute();
                $out = $stmt -> fetchAll();
                $stmt->closeCursor();
            }
            catch (PDOException $e) {
                fn_debug_query_e($sql, $appo, $out, $e);
                $stmt->closeCursor();
                echo "ERROR CONNECTIN DB ";
                return ;
            }
        }
        /// tolgo il path dal nome del file
        $fname = pathinfo($this->filename)['filename'];
        /// setto utc per poter inserire il modified corretto nel db
        date_default_timezone_set("UTC");
        $sql = "SELECT COUNT(*) nrow FROM ".$this->station."_auto WHERE dt = :rdt;";
        try{
            $stmt = $this -> myconn -> conn -> prepare($sql, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
            $appo = array(
                    ':rdt'    => $this -> dt
                );
            $stmt->execute( $appo);
            $out = $stmt -> fetchAll();
        }
        catch (PDOException $e) {
            fn_debug_query_e($sql, $appo, $this, $e);
            echo "ERROR CONNECTIN DB ";
            $stmt->closeCursor();
            $stmt = null;
            return ;
        }
        $stmt->closeCursor();
        $stmt = null;
        $insertUpdate=$out[0]['nrow'];

        if ($insertUpdate == 0) {
            $sql = "INSERT INTO ".$this->station."_auto (".
                  "dt,".
                  "fromfile,".
                  "trace,".
                  "modified)".
            " VALUES (".
                ":datetime,".
                ":filename,".
                ":trace_json,".
                ":modified)";
        } else {
            /// aggiungo il separatore per il nome del file
            $fname = " " . $fname;

            $sql = "UPDATE ".$this->station."_auto SET ".
                      "fromfile = fromfile || ' ' || :filename,".
                      "trace =              :trace_json,".
                      "modified =           :modified".
                  " WHERE dt = :datetime";
        }
        $appo = array(
                ':datetime'         => isset($this -> dt) ? $this -> dt : null,
                ':filename'         => isset($fname) ? $fname : null,
                ':trace_json'       => strval($this->trace_json),
                ':modified'         => date('Y-m-d H:i:s')
                );
        try {
            $stmt = $this->myconn->conn->prepare($sql, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
            $stmt->execute($appo);
            $outapp = $stmt->fetchAll();
            $out = $outapp['0'];
            if ($insertUpdate == 0) {
                $out = array(
                    'err_code'      => 0,
                    'err_message'   => "OK_LOADED ". $this->station .  " ". $this->dt
                );
            }else{
                $out = array(
                    'err_code'      => 0,
                    'err_message'   => "OK_UPDATED ". $this->station .  " ". $this->dt
                );
            }
        }
        catch (PDOException $e){
            $out = array(
                'err_code' => 20,
                'err_mssage' => $e->getMessage()
            );
            fn_debug_query_e($sql, $appo, $this, $e);
            $stmt -> closeCursor();
        }
        $stmt -> closeCursor();
        return $out;

    } // function

} //chiusura classe
