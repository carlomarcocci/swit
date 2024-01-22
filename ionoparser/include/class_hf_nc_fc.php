<?php

class hf_nc_fc {
/**
 * Classe per la gestione dei forecast e nowcast di hf
 * per il progetti swesnet
 */

    public  $filename;                  /// input file name 
    public  $fname;                     /// input file name 
    public  $station;                   /// nome della stazione
    public  $myconn;
    public $isPostgres;             /// true if upe pg
    public $db;                     /// database name
    public $datetime;               /// data passata da inputfile

    public  $dt;                             /// data letta nel file
    public  $coordinate_system;                        /// file datefime
    public  $delta_lat;
    public  $delta_long;
    public  $max_lat;
    public  $max_long;
    public  $min_lat;
    public  $min_long;
    public  $time_reference_system;
    public  $units;
    public  $dt_valid;

    public  $json_a = array();          /// array dove viene esploso il json file
    public  $json_f;                    /// json file 
    public  $jfile;                      /// json file 

    function __construct($fn, $myc, $statio, $fname, $dt, $isPg, $db){
        $this -> filename   = $fn;
        $this -> myconn     = $myc;
        $this -> station    = $statio;
        $this -> fname      = $fname;
        $this -> datetime   = $dt;
        $this -> isPostgres = ($isPg == 'pg' ? 1 : 0);
        $this -> db         = $db;
    }

    function read_file(){
    /**
     * Funzione che popola la classe leggendo il file json
     * 
     */
        $linenum = 0;
        $this->json_f = file_get_contents($this -> filename);
        if ($this->json_f === false) {
            $out = array(
                "err_code" => -1,
                "err_message" => "REMOVED_OR_EMPTY_FILE"
            );
            return $out;
        }
        else {
            $this->json_f = str_replace("NaN","-9999",$this->json_f);
        }

        $this -> json_a = json_decode($this->json_f, true);
        if ($this -> json_a === null) {
            switch (json_last_error()) {
                case JSON_ERROR_NONE:
                    $out = array(
                        "err_code" => -1,
                        "err_message" => "NO_JSON_ERROR"
                    );
                break;
                case JSON_ERROR_DEPTH:
                    $out = array(
                        "err_code" => -1,
                        "err_message" => "MAXSTACK_JSON_ERROR"
                    );
                break;
                case JSON_ERROR_STATE_MISMATCH:
                    $out = array(
                        "err_code" => -1,
                        "err_message" => "UNDERFLOW_JSON_ERROR"
                    );
                break;
                case JSON_ERROR_CTRL_CHAR:
                    $out = array(
                        "err_code" => -1,
                        "err_message" => "CHARCONTROL_JSON_ERROR"
                    );
                break;
                case JSON_ERROR_SYNTAX:
                    $out = array(
                        "err_code" => -1,
                        "err_message" => "SYNTAX_JSON_ERROR"
                    );
                break;
                case JSON_ERROR_UTF8:
                    $out = array(
                        "err_code" => -1,
                        "err_message" => "UTF8_JSON_ERROR"
                    );
                break;
                default:
                    $out = array(
                        "err_code" => -1,
                        "err_message" => "UNKNOWN_JSON_ERROR"
                    );
                break;
            }
            return $out;
        }

        $this -> delta_lat              = $this->json_a['metadata']['spatial_coverage']['delta_lat'];
        $this -> delta_long             = $this->json_a['metadata']['spatial_coverage']['delta_long'];
        $this -> max_lat                = $this->json_a['metadata']['spatial_coverage']['max_lat'];
        $this -> max_long               = $this->json_a['metadata']['spatial_coverage']['max_long'];
        $this -> min_lat                = $this->json_a['metadata']['spatial_coverage']['min_lat'];
        $this -> min_long               = $this->json_a['metadata']['spatial_coverage']['min_long'];
        $this -> time_reference_system  = $this->json_a['metadata']['time_reference_system'];
        $this -> dt                     = fn_fileNameToDate($this->json_a['metadata']['execution_time'], 'TE0');
        $this -> dt_valid               = fn_fileNameToDate($this->json_a['metadata']['valid_time'], 'TE0');

        $l = 0;
        for ($j = $this -> max_lat; $j >= $this -> min_lat; $j-= $this -> delta_lat) {
            $k =0;
            for ($i = $this -> min_long; $i <=$this -> max_long; $i = $i+=$this -> delta_long) {
                if ($this->json_a['data'][$l][$k] != -9999 ){
                    $list[] = ['lat' => round($j,2), 'lon' => round($i, 2), 'val' => round($this->json_a['data'][$l][$k],6)];
                }
                $k++;
            }
            $l++;
        }
        $this->jfile = json_encode($list, JSON_NUMERIC_CHECK);
        $out = array(
            "err_code" => 0,
            "err_message" => "File paesed"
        );
        return $out;
    } // end function
    
    function push2db(){
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
                    ':tablename'    => strval($this -> station)
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

        // se la rabella di stazione non esiste va creata
        if ($out[0]['ntab'] == 0) {
            // il nome della tabella non puo essere passato col prepare cone variabile di pdo
            $sql = createHf_ncfcTable($this -> station, $this->isPostgres);
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
//                retrn ;
            }
        }
        /// tolgo il path dal nome del file
        $fname = pathinfo($this->filename)['filename'];
        /// setto utc per poter inserire il modified corretto nel db
        date_default_timezone_set("UTC");
        $sql = "SELECT COUNT(*) nrow FROM ".$this->station." WHERE dt = :rdt AND dt_valid = :rdt_valid;";
        try{
            $stmt = $this -> myconn -> conn -> prepare($sql, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
            $appo = array(
                    ':rdt'          => $this -> dt,
                    ':rdt_valid'    => $this -> dt_valid
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
        // insert or update row
        $insertUpdate=$out[0]['nrow'];
        if ($insertUpdate == 0) {
            $sql = "INSERT INTO ".$this->station." (".
                    "dt,".
                    "dt_valid,".
                    " fromfile,".
                    " jfile,".
                    " modified)".
            " VALUES (".
                     ":m_dt,".
                     ":m_dt_valid,".
                    " :m_fromfile,".
                    " :m_jfile,".
                   " :m_modified);";
        } else {
            /// aggiungo il separatore per il nome del file
            $fname = " " . $fname;

            $sql = "UPDATE ".$this->station." SET ".
                        " fromfile                          = fromfile || ' ' || :m_fromfile,".
                        " jfile                             = :m_jfile,".
                        " modified                          = :m_modified".
                  " WHERE dt = :m_dt AND dt_valid = :m_dt_valid ";
        }
        $appo = array(
                    ':m_dt'                     => isset($this -> dt) ? $this -> dt : null,
                    ':m_dt_valid'               => isset($this -> dt_valid) ? $this -> dt_valid : null,
                    ':m_fromfile'               => isset($fname) ? $fname : null,
                    ':m_jfile'                  => isset($this->jfile) ? $this->jfile : null,
                    ':m_modified'               => date('Y-m-d H:i:s')
            );
        try {
            $stmt = $this->myconn->conn->prepare($sql, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
            $stmt->execute($appo);
            $outapp = $stmt->fetchAll();
           // $out = $outapp['0'];
//print_r($outapp);die();
//            if ($insertUpdate == 0) {
                $out = array(
                    'err_code'      => 0,
                    'err_message'   => "OK_LOADED ". $this->station .  " ". $this->datetime
                );
/*            }else{
                $out = array(
                    'err_code'      => 0,
                    'err_message'   => "OK_UPDATED ". $this->station .  " ". $this->datetime
                );
            } */
        }
        catch (PDOException $e){
            if ($e->errorInfo[0] == '23505'){
                $out = array(
                    "err_code" => 1,
                    "err_message" => "OK_DUPE ".$this->station
                );
            }else{
                $out = array(
                    "err_code" => -1,
                    "err_message" => $e->code
                );
            }
        }
/*

            $out = array(
                'err_code' => 20,
                'err_mssage' => $e->getMessage()
            );
            fn_debug_query_e($sql, $appo, $this, $e);
            $stmt -> closeCursor();
        } */
        return $out;
 
    } // function

}
