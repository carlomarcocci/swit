<?php

class novatel_line {
/**
 * Classe per la gestione delle misurazione degli acquisitori monocostellazione
 * gps della Novatel
 */

    public $inputstr;              /// stringa passata in input e contentente una riga del file
    public $datetime;              /// datetime della misura
    
//    Week, GPS TOW ,PRN, RxStatus,   Az  ,  Elv ,L1 CNo, S4 , S4 Cor,1SecSigma,3SecSigma,10SecSigma,30SecSigma,60SecSigma, Code-Carrier, C-CStdev, TEC45, TECRate45, TEC30, TECRate30, TEC15, TECRate15, TEC0, TECRate0,L1 LockTime,ChanStatus,L2 LockTime, L2 CNo
    public $prn;
    public $rxstatus;
    public $az;
    public $elv;
    public $l1_cno;
    public $s4;
    public $s4_cor;
    public $n1secsigma;
    public $n3secsigma;
    public $n10secsigma;
    public $n30secsigma;
    public $n60secsigma;
    public $code_carrier;
    public $c_cstdev;
    public $tec45;
    public $tecrate45;
    public $tec30;
    public $tecrate30;
    public $tec15;
    public $tecrate15;
    public $tec0;
    public $tecrate0;
    public $l1_locktime;
    public $chanstatus;
    public $l2_locktime;
    public $l2_cno;

    function __construct($str){
        $this -> inputstr = $str;
        /// load array with values in csv format
        $dataline = str_getcsv(str_replace(' ', '', $str));
        /// load member from array
        $this -> datetime       = fn_weektow2datetime($dataline[0], $dataline[1]);
        $this -> prn            = $dataline[2];
        $this -> rxstatus       = $dataline[3];
        $this -> az             = $dataline[4];
        $this -> elv            = $dataline[5];
        $this -> l1_cno         = $dataline[6];
        $this -> s4             = $dataline[7];
        $this -> s4_cor         = $dataline[8];
        $this -> n1secsigma     = $dataline[9];
        $this -> n3secsigma     = $dataline[10];
        $this -> n10secsigma    = $dataline[11];
        $this -> n30secsigma    = $dataline[12];
        $this -> n60secsigma    = $dataline[13];
        $this -> code_carrier   = $dataline[14];
        $this -> c_cstdev       = $dataline[15];
        $this -> tec45          = $dataline[16];
        $this -> tecrate45      = $dataline[17];
        $this -> tec30          = $dataline[18];
        $this -> tecrate30      = $dataline[19];
        $this -> tec15          = $dataline[20];
        $this -> tecrate15      = $dataline[21];
        $this -> tec0           = $dataline[22];
        $this -> tecrate0       = $dataline[23];
        $this -> l1_locktime    = $dataline[24];
        $this -> chanstatus     = $dataline[25];
        $this -> l2_locktime    = $dataline[26];
        $this -> l2_cno         = $dataline[27];
    } // function

    function print_row(){
        $row="";
        
        $row += $this -> datetime; //       = fn_weektow2datetime($dataline[0], $dataline[1]);
        $row += $this -> datetime; //       = fn_weektow2datetime($dataline[0], $dataline[1]);
        $row += ", " . $this -> prn;
        $row += ", " . $this -> rxstatus;
        $row += ", " . $this -> az;
        $row += ", " . $this -> elv;
        $row += ", " . $this -> l1_cno;
        $row += ", " . $this -> s4;
        $row += ", " . $this -> s4_cor;
        $row += ", " . $this -> n1secsigma;
        $row += ", " . $this -> n3secsigma;
        $row += ", " . $this -> n10secsigma;
        $row += ", " . $this -> n30secsigma;
        $row += ", " . $this -> n60secsigma;
        $row += ", " . $this -> code_carrier;
        $row += ", " . $this -> c_cstdev;
        $row += ", " . $this -> tec45;
        $row += ", " . $this -> tecrate45;
        $row += ", " . $this -> tec30;
        $row += ", " . $this -> tecrate30;
        $row += ", " . $this -> tec15;
        $row += ", " . $this -> tecrate15;
        $row += ", " . $this -> tec0;
        $row += ", " . $this -> tecrate0;
        $row += ", " . $this -> l1_locktime;
        $row += ", " . $this -> chanstatus;
        $row += ", " . $this -> l2_locktime;
        $row += ", " . $this -> l2_cno;
        return $row;
    }

} // class

class novatel_file {
/**
 * Classe per la gestione delle misurazione degli acquisitori monocostellazione
 * gps della Novatel
 */

    public $filename;              /// input file name 
    public $fname;              /// input file name 
    public $station;               /// nome della stazione
    public $ismr_line = array();
    public $myconn;
    public  $host;
    public  $db;
    public $isPostgres;             /// true if upe pg

    function __construct($fn, $myc, $st, $fname, $isPg, $db, $ext){
        $this -> filename   = $fn;
        $this -> fname      = $fname;
        $this -> station    = $st;
        $this -> myconn     = $myc;
        $this -> isPostgres = ($isPg == 'pg' ? 1 : 0);
        $this -> db         = $db;
        $this -> isPostgres = ($isPg == 'pg' ? 1 : 0);
        /// extract S60 file to parse it
        $output =   null;
        $retval =   null;
        if ($ext == 's60'){
            $output =   null;
            $retval =   null;
            // extract est file from S60
            exec ("wine ./bin/ParseIsmrWin.exe all {$this->filename} {$this->filename}.es", $output, $retval);
            /// from windows to unix text format
            if (file_exists("{$this->filename}.es")){
            //    exec(" tr -d \'\\15\\32\'< {$this->filename}.es > {$this->filename}.EST ");   
                exec("cat {$this->filename}.es > {$this->filename}.EST");
            }
        }
        /// here EST file only
   }

    function read_file(){
    /**
     * Funzione che popola la classe leggendo il file EXT ottenuto dall'esecuzione del 
     * programma wine ParseIsmr.exe sui file di misura S60
     */
        $out = array(
            "err_code" => "",
            "err_message" => ""
        );
        
        $linenum = 0;
        $fna = explode('.', $this->filename);
        $fnn = strtolower(end($fna));
      
        if ($fnn == 'est') {
            $fnn = $this->filename;
        } else{
            $fnn = $this->filename.'.EST';
        }
        if ($fh = fopen($fnn , 'r')) {
          // lettura dei dati
          // lettura dei dati
            $line   = fgets($fh); // salta la prima linea di intestazione
            $line   = fgets($fh); // legge la prima linea di dati
            while (!feof($fh) && (strlen($line) >10)){
                // $station;                
                $this -> ismr_line[$linenum] = new novatel_line($line);
                $line   = fgets($fh);
                $linenum++;
            } // end while
            fclose($fh);
        } else{
            $out = array(
                "err_code" => -1,
                "err_message" => "Error: Can't read file"
            );
        }
        // cleaning temp files
        if (file_exists("{$this->filename}.es")){
             exec(" rm -f  {$this->filename}.es");
             exec(" rm -f  {$this->filename}.EST");
        }
        return $out;
} // end function
    
    function push2db(){
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
        /// se la rabella di stazione non esiste va creata
        if ($out[0]['ntab'] == 0) {
            // il nome della tabella non puo essere passato col prepare cone variabile di pdo
            $sql = createNovatelGpsTable($this -> station, $this->isPostgres);
            try{
                $stmt = $this -> myconn -> conn -> prepare($sql);
                $stmt->execute();
                // $out = $stmt -> fetchAll();
                $stmt->closeCursor();
                $stmt = null;
            }
            catch (PDOException $e) {
                fn_debug_query_e($sql, $appo, $out, $e);
                $stmt->closeCursor();
                echo "ERROR CREATE TABLE ";
            }
            $sql = createNovatelGpsView($this -> station, $this->isPostgres);
            try{
                $stmt = $this -> myconn -> conn -> prepare($sql);
                $stmt->execute();
                $stmt->closeCursor();
                $stmt = null;
            }
            catch (PDOException $e) {
                fn_debug_query_e($sql, $appo, $out, $e);
                $stmt->closeCursor();
                echo "ERROR CREATE VIEW ";
            }
        } // create tabella e vista
        /// tolgo il path dal nome del file
        $fname = pathinfo($this->filename)['filename'];
        /// setto utc per poter inserire il modified corretto nel db
        date_default_timezone_set("UTC");

        // insert row

        $nrow       = 0;
        $nrowok     = 0;
        $nrowdupe   = 0;
        $nrowerr    = 0;
        foreach ($this -> ismr_line as $row) {
            $nrow++;
            $sqlr = "INSERT INTO ".$this -> station." (".
                        "dt,".
                        "svid,".
                        "rxstate,".
                        "azimuth,".
                        "elevation,".
                        "averagel1,".
                        "totals4l1,".
                        "corrections4l1,".
                        "phi01l1,".
                        "phi03l1,".
                        "phi10l1,".
                        "phi30l1,".
                        "phi60l1slant,".
                        "avgccdl1,".
                        "sigmaccdl1,".
                        "tec45,".
                        "dtec60_45,".
                        "tec30,".
                        "dtec45_30,".
                        "tec15,".
                        "dtec30_15,".
                        "tec0,".
                        "dtec0,".
                        "locktimel1,".
                        "chanstatus,".
                        "secondlocktime,".
                        "avgcn2freqtec,".
                        "modified)            ".
                " VALUES (".
                    ":datetime,".
                    ":prn,".
                    ":rxstatus,".
                    ":az,".
                    ":elv,".
                    ":l1_cno,".
                    ":s4,".
                    ":s4_cor,".
                    ":n1secsigma,".
                    ":n3secsigma,".
                    ":n10secsigma,".
                    ":n30secsigma,".
                    ":n60secsigma,".
                    ":code_carrier,".
                    ":c_cstdev,".
                    ":tec45,".
                    ":tecrate45,".
                    ":tec30,".
                    ":tecrate30,".
                    ":tec15,".
                    ":tecrate15,".
                    ":tec0,".
                    ":tecrate0,".
                    ":l1_locktime,".
                    ":chanstatus,".
                    ":l2_locktime,".
                    ":l2_cno,".
                    ":modified)";
               $appor = array(
                     ':datetime'    => fn_isdef($row->datetime ) ? $row->datetime : null,
                    ':prn'          => fn_isdef($row->prn ) ? $row->prn : null,
                    ':rxstatus'     => fn_isdef($row->rxstatus ) ? $row->rxstatus : null,
                    ':az'           => fn_isdef($row->az ) ? $row->az : null,
                    ':elv'          => fn_isdef($row->elv ) ? $row->elv : null,
                    ':l1_cno'       => fn_isdef($row->l1_cno ) ? $row->l1_cno : null,
                    ':s4'           => fn_isdef($row->s4 ) ? $row->s4 : null,
                    ':s4_cor'       => fn_isdef($row->s4_cor ) ? $row->s4_cor : null,
                    ':n1secsigma'   => fn_isdef($row->n1secsigma ) ? $row->n1secsigma : null,
                    ':n3secsigma'   => fn_isdef($row->n3secsigma ) ? $row->n3secsigma : null,
                    ':n10secsigma'  => fn_isdef($row->n10secsigma ) ? $row->n10secsigma : null,
                    ':n30secsigma'  => fn_isdef($row->n30secsigma ) ? $row->n30secsigma : null,
                    ':n60secsigma'  => fn_isdef($row->n60secsigma ) ? $row->n60secsigma : null,
                    ':code_carrier' => fn_isdef($row->code_carrier ) ? $row->code_carrier : null,
                    ':c_cstdev'     => fn_isdef($row->c_cstdev ) ? $row->c_cstdev : null,
                    ':tec45'        => fn_isdef($row->tec45 ) ? $row->tec45 : null,
                    ':tecrate45'    => fn_isdef($row->tecrate45 ) ? $row->tecrate45 : null,
                    ':tec30'        => fn_isdef($row->tec30 ) ? $row->tec30 : null,
                    ':tecrate30'    => fn_isdef($row->tecrate30 ) ? $row->tecrate30 : null,
                    ':tec15'        => fn_isdef($row-> tec15 ) ? $row->tec15 : null,
                    ':tecrate15'    => fn_isdef($row->tecrate15 ) ? $row->tecrate15 : null,
                    ':tec0'         => fn_isdef($row->tec0 ) ? $row->tec0 : null,
                    ':tecrate0'     => fn_isdef($row->tecrate0 ) ? $row->tecrate0 : null,
                    ':l1_locktime'  => fn_isdef($row->l1_locktime ) ? $row->l1_locktime : null,
                    ':chanstatus'   => fn_isdef($row->chanstatus ) ? $row->chanstatus : null,
                    ':l2_locktime'  => fn_isdef($row->l2_locktime ) ? $row->l2_locktime : null,
                    ':l2_cno'       => fn_isdef($row->l2_cno ) ? $row->l2_cno : null,
                    ':modified'     => date('Y-m-d H:i:s')
                );
            try{
                $stmtr = $this->myconn->conn->prepare($sqlr, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
                $stmtr->execute($appor);
                $outr = $stmtr->fetchAll();
                $nrowok++;
                $stmtr->closeCursor();
            }
            catch (PDOException $e){
                $myErrorCode = 'ok';
                switch ($e->getCode()) {
                    case 23505:
                        $myErrorCode = 'duplicate';
                        break;
                    case 1064:
                        $myErrorCode = 'duplicate';
                        break;
                    default:
                        $myErrorCode = 'error';
                        break;
                }
                if ($myErrorCode == 'duplicate'){
                    $nrowdupe++; ;          /// riga duplicata
                } else{
                    $nrowerr++;
                }
                $stmtr->closeCursor();
            } // catch
        } // foreach rows
        if ($nrow == $nrowok){
            $ret_val = array(
                "err_code" => 0,
                "err_message" => "OK_LOADED nrows ".$nrowok." ".$this->station
            );
        } elseif ($nrow == ($nrowok + $nrowdupe)){
            //$ret_val = 1;
            $ret_val = array(
                "err_code" => 1,
                "err_message" => "OK_DUPE tot: ".strval($nrow)." dup: ".strval($nrowdupe)."\t".$this->station
            );
        } else {
            //$ret_val = 2;
            $ret_val = array(
                "err_code" => 2,
                "err_message" => "GENERIC_ERR_INSERT class_novatel_gps"
            );
        }
        return $ret_val;
    } // function
}
?>
