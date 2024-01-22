<?php

class ais_auto_file {
/**
 * Classe per la gestione delle misure effettuate dalla ionosnoda ais
 */

    public $stationinfile;               /// nome della stazione
    public $datetimeinfile;              /// datetime della misura

    public $filename;              /// input file name 
    public $station;               /// nome della stazione
    public $stalat;                /// latitudine della stazione
    public $stalon;                /// longitudine della stazione
    public $datetime;              /// datetime della misura
    public $producer;              /// programma che ha prodotto i dati
    public $myconn;
    public $isPostgres;             /// true if upe pg
    public $db;                     /// database name

    public $foF2;                  /// foF2 del primo blocco
    public $foF2_eval;                  /// foF2 del primo blocco
    public $MUFF2;                 /// MUF(3000)F2 del primo blocco
    public $MUFF2_eval;                 /// MUF(3000)F2 del primo blocco
    public $MF2;                   /// M(3000)F2 del primo blocco
    public $MF2_eval;                   /// M(3000)F2 del primo blocco
    public $fxI;                   /// fxI del primo blocco
    public $fxI_eval;                   /// fxI del primo blocco
    public $foF1;                  /// foF1 del primo blocco
    public $foF1_eval;                  /// foF1 del primo blocco
    public $ftEs;                  /// ftEs del primo blocco
    public $ftEs_eval;                  /// ftEs del primo blocco
    public $hEs;                    /// h'Es del primo blocco
    public $hEs_eval;                    /// h'Es del primo blocco
    public $nodata_AIP;             /// se non ci sono dati AIP
    public $hmF2_AIP;
    public $foF2_AIP;
    public $foF1_AIP;
    public $hmF1_AIP;
    public $D1_AIP;
    public $foE_AIP;
    public $hmE_AIP;
    public $ymE_AIP;
    public $h_vE_AIP;
    public $Ewidth_AIP;
    public $DelN_vE_AIP;
    public $B0_AIP;
    public $B1_AIP;
    public $tec_bottom;
    public $tec_top;
    public $model_list = array();
    public $model_json;

    function __construct($fn,$myc, $statio, $fname, $isPg, $db){
        $this -> filename   = $fn;
        $this -> fname      = $fname;
        $this -> station    = $statio;
        $this -> myconn     = $myc;
        $this -> isPostgres = ($isPg == 'pg' ? 1 : 0);
        $this -> db         = $db;
    }

    function read_file(){
    /**
     * Funzione che popola la classe leggendo il file di input prodotto da autoscala 
     */
        $out = array(
            "err_code" => "",
            "err_message" => ""
        );
        if ($fh = fopen($this -> filename, 'r')) {
            if (!feof($fh)) {
                $line = strtoupper(fgets($fh));
                $this -> datetime = substr($line, strpos($line, "DATE: ")+6,4).'-'.
                    substr($line, strpos($line, "DATE: ")+11,2).'-'.
                    substr($line, strpos($line, "DATE: ")+14,2).'T'.
                    substr($line, strpos($line, "(UT): ")+6,5);
                $this -> stalat         = trim(substr($line, strpos($line, "(LAT:")+5,6));
                $this -> stalon         = trim(substr($line, strpos($line, "LON:")+4,6));
                $this -> stationinfile  = strtolower(trim(substr(mb_convert_encoding($line, "UTF-8"), 0, strpos($line, " "))));
            } else {
                $out['err_message'] = "ERROR_ON_READ:\trow1";
                $out['err_code'] = -1;;
                return $out;
            };
            if (!feof($fh)) {
                $line = fgets($fh);
                $this -> producer = str_replace(array("\n", "\t", "\r"), '', $line);
            } else {
                $out['err_message'] = "ERROR_ON_READ: \t row2";
                $out['err_code'] = -1;;
                return $out;
            };
            /// foF2
            if (!feof($fh)) {
                $line = fgets($fh);
                $lettora = trim(substr($line, 15, 7));
                if (is_numeric($lettora)){
                    $this -> foF2       = $lettora;
                    $this -> foF2_eval  = 1;
                } elseif ($lettora == 'N/A'){
                    $this -> foF2       = null;
                    $this -> foF2_eval  = 0;
                } elseif($lettora == 'NO'){
                    $this -> foF2       = null; 
                    $this -> foF2_eval  = 1;
                } else {
                    $out['err_message'] = "ERROR_ON_FIELD:\tfoF2; ".$this -> filename;
                    $out['err_code'] = -1;;
                    return $out;
                }
            } else {
                $out['err_message'] = "ERROR_ON_READ: \t row3";
                $out['err_code'] = -1;;
                return $out;
            };
            /// MUFF2
            if (!feof($fh)) {
                $line = fgets($fh);
                $lettora = trim(substr($line, 15, 7));
                if (is_numeric($lettora)){
                    $this -> MUFF2       = $lettora;
                    $this -> MUFF2_eval  = 1;
                } elseif ($lettora == 'N/A'){
                    $this -> MUFF2       = null;
                    $this -> MUFF2_eval  = 0;
                } elseif($lettora == 'NO'){
                    $this -> MUF2       = null;
                    $this -> MUF2_eval  = 1;
                } else {
                    $out['err_message'] = "ERROR_ON_FIELD:\tMUFF2; ".$this -> filename;
                    $out['err_code'] = -1;;
                    return $out;
                }
            } else {
                $out['err_message'] = "ERROR_ON_READ: \t row4";
                $out['err_code'] = -1;;
                return $out;
            };
            /// MF2
            if (!feof($fh)) {
                $line = fgets($fh);
                $lettora = trim(substr($line, 15, 7));
                if (is_numeric($lettora)){
                    $this -> MF2       = $lettora;
                    $this -> MF2_eval  = 1;
                } elseif ($lettora == 'N/A'){
                    $this -> MF2       = null;
                    $this -> MF2_eval  = 0;
                } elseif($lettora == 'NO'){
                    $this -> MF2       = null;
                    $this -> MF2_eval  = 1;
                } else {
                    $out['err_message'] = "ERROR_ON_FIELD:\tMF2; ".$this -> filename;
                    $out['err_code'] = -1;;
                    return $out;
                }
            } else {
                $out['err_message'] = "ERROR_ON_READ: \t row5";
                $out['err_code'] = -1;;
                return $out;
            };
            /// fxI
            if (!feof($fh)) {
                $line = fgets($fh);
                $lettora = trim(substr($line, 15, 7));
                if (is_numeric($lettora)){
                    $this -> fxI       = $lettora;
                    $this -> fxI_eval  = 1;
                } elseif ($lettora == 'N/A'){
                    $this -> fxI       = null;
                    $this -> fxI_eval  = 0;
                } elseif($lettora == 'NO'){
                    $this -> fxI       = null;
                    $this -> fxI_eval  = 1;
                } else {
                    $out['err_message'] = "ERROR_ON_FIELD:\tfxI; ".$this -> filename;
                    $out['err_code'] = -1;;
                    return $out;
                }
            } else {
                $out['err_message'] = "ERROR_ON_READ: \t row6";
                $out['err_code'] = -1;;
                return $out;
            };
            /// foF1
            if (!feof($fh)) {
                $line = fgets($fh);
                $lettora = trim(substr($line, 15, 7));
                if (is_numeric($lettora)){
                    $this -> foF1      = $lettora;
                    $this -> foF1_eval = 1;
                } elseif ($lettora == 'N/A'){
                    $this -> foF1      = null;
                    $this -> foF1_eval = 0;
                } elseif($lettora == 'NO'){
                    $this -> foF1      = null;
                    $this -> foF1_eval = 1;
                } else {
                    $out['err_message'] = "ERROR_ON_FIELD:\tfoF1; ".$this -> filename;
                    $out['err_code'] = -1;;
                    return $out;
                }
            } else {
                $out['err_message'] = "ERROR_ON_READ: \t row7";
                $out['err_code'] = -1;;
                return $out;
            };
            /// ftEs
            if (!feof($fh)) {
                $line = fgets($fh);
                $lettora = trim(substr($line, 15, 7));
                if (is_numeric($lettora)){
                    $this -> ftEs       = $lettora;
                    $this -> ftEs_eval  = 1;
                } elseif ($lettora == 'N/A'){
                    $this -> ftEs       = null;
                    $this -> ftEs_eval  = 0;
                } elseif($lettora == 'NO'){
                    $this -> ftEs       = null;
                    $this -> ftEs_eval  = 1;
                } else {
                    $out['err_message'] = "ERROR_ON_FIELD:\tftEs; ".$this -> filename;
                    $out['err_code'] = -1;;
                    return $out;
                }
            } else {
                $out['err_message'] = "ERROR_ON_READ: \t row8";
                $out['err_code'] = -1;;
                return $out;
            };
            /// hEs
            if (!feof($fh)) {
                $line = fgets($fh);
                $lettora = trim(substr($line, 14, 7));
                if (is_numeric($lettora)){
                    $this -> hEs       = $lettora;
                    $this -> hEs_eval  = 1;
                } elseif ($lettora == 'N/A'){
                    $this -> hEs       = null;
                    $this -> hEs_eval  = 0;
                } elseif($lettora == 'NO'){
                    $this -> hEs       = null;
                    $this -> hEs_eval  = 1;
                } else {
                    $out['err_message'] = "ERROR_ON_FIELD:\thEs; ".$this -> filename;
                    $out['err_code'] = -1;;
                    return $out;
                }
            } else {
                $out['err_message'] = "ERROR_ON_READ: \t row9";
                $out['err_code'] = -1;;
                return $out;
            };
            // salto due righe per raggiungere il blocco AIP
            if (!feof($fh)){
                $line = fgets($fh);
            } else{
                $out['err_message'] = "ERROR_ON_READ: \t row10";
                $out['err_code'] = -1;;
            }
            if (!feof($fh)){
                $line = fgets($fh);
            } else{
                $out['err_message'] = "ERROR_ON_READ: \t row11";
                $out['err_code'] = -1;;
            }
            if (!feof($fh)){
                $line = fgets($fh);
                $this -> nodata_AIP    = (substr($line, 0, 15) == 'NO DATA FOR AIP');
            } else{
                $out['err_message'] = "ERROR_ON_READ: \t row12";
                $out['err_code'] = -1;;
            }
            if (isset($this -> nodata_AIP)) { 
                $this -> hmF2_AIP    = (is_numeric(trim(substr($line, 9, 7))) ? trim(substr($line, 9, 7)): null) ;
                if (!feof($fh)) {
                    $line = fgets($fh);
                    $this -> foF2_AIP    = (is_numeric(trim(substr($line, 9, 7))) ? trim(substr($line, 9, 7)): null);
                } else {
                    $out['err_message'] = "ERROR_ON_READ: \t row13";
                    $out['err_code'] = -1;;
                };
                if (!feof($fh)) {
                    $line = fgets($fh);
                    $this -> foF1_AIP    = (is_numeric(trim(substr($line, 9, 7))) ? trim(substr($line, 9, 7)): null);
                } else {
                    $out['err_message'] = "ERROR_ON_READ: \t row14";
                    $out['err_code'] = -1;;
                };
                if (!feof($fh)) {
                    $line = fgets($fh);
                    $this -> hmF1_AIP    = (is_numeric(trim(substr($line, 9, 7))) ? trim(substr($line, 9, 7)): null);
                } else {
                    $out['err_message'] = "ERROR_ON_READ: \t row15";
                    $out['err_code'] = -1;;
                };
                if (!feof($fh)) {
                    $line = fgets($fh);
                    $this -> D1_AIP    = (is_numeric(trim(substr($line, 9, 7))) ? trim(substr($line, 9, 7)) : null);
                } else {
                    $out['err_message'] = "ERROR_ON_READ: \t row16";
                    $out['err_code'] = -1;;
                };
                if (!feof($fh)) {
                    $line = fgets($fh);
                    $this -> foE_AIP    = (is_numeric(trim(substr($line, 9, 7))) ? trim(substr($line, 9, 7)) : null);
                } else {
                    $out['err_message'] = "ERROR_ON_READ: \t row17";
                    $out['err_code'] = -1;;
                };
                if (!feof($fh)) {
                    $line = fgets($fh);
                    $this -> hmE_AIP    = (is_numeric(trim(substr($line, 9, 7))) ? trim(substr($line, 9, 7)): null);
                } else {
                    $out['err_message'] = "ERROR_ON_READ: \t row18";
                    $out['err_code'] = -1;;
                };
                if (!feof($fh)) {
                    $line = fgets($fh);
                    $this -> ymE_AIP    = (is_numeric(trim(substr($line, 9, 7))) ? trim(substr($line, 9, 7)): null);
                } else {
                    $out['err_message'] = "ERROR_ON_READ: \t row19";
                    $out['err_code'] = -1;;
                };
                if (!feof($fh)) {
                    $line = fgets($fh);
                    $this -> h_vE_AIP    = (is_numeric(trim(substr($line, 9, 7))) ? trim(substr($line, 9, 7)): null);
                } else {
                    $out['err_message'] = "ERROR_ON_READ: \t row20";
                    $out['err_code'] = -1;;
                };
                if (!feof($fh)) {
                    $line = fgets($fh);
                    $this -> Ewidth_AIP    = (is_numeric(trim(substr($line, 9, 7))) ? trim(substr($line, 9, 7)): null);
                } else {
                    $out['err_message'] = "ERROR_ON_READ: \t row21";
                    $out['err_code'] = -1;
                };
                if (!feof($fh)) {
                    $line = fgets($fh);
                    $this -> DelN_vE_AIP    = (is_numeric(trim(substr($line, 9, 7))) ? trim(substr($line, 9, 7)): null);
                } else {
                    $out['err_message'] = "ERROR_ON_READ: \t row22";
                    $out['err_code'] = -1;;
                };
                if (!feof($fh)) {
                    $line = fgets($fh);
                    $this -> B0_AIP    = (is_numeric(trim(substr($line, 9, 7))) ? trim(substr($line, 9, 7)): null);
                } else {
                    $out['err_message'] = "ERROR_ON_READ: \t row23";
                    $out['err_code'] = -1;;
                };
                if (!feof($fh)) {
                    $line = fgets($fh);
                    $this -> B1_AIP    = (is_numeric(trim(substr($line, 9, 7))) ? trim(substr($line, 9, 7)): null);
                } else {
                    $out['err_message'] = "ERROR_ON_READ: \t row24";
                    $out['err_code'] = -1;;
                };
                // scorre due righe nella lettura
                if (feof($fh)) {
                    $out['err_message'] = "ERROR_ON_READ: \t row25";
                    $out['err_code'] = -1;;
                };
                if (feof($fh)) {
                    $out['err_message'] = "ERROR_ON_READ: \t row26";
                    $out['err_code'] = -1;;
                };
                if (!feof($fh)) {
                    $line = fgets($fh);
                } else {
                    $out['err_message'] = "ERROR_ON_READ: \t row27";
                    $out['err_code'] = -1;;
                };
                if (!feof($fh)) {
                    $line = fgets($fh);
                } else {
                    $out['err_message'] = "ERROR_ON_READ: \t row28";
                    $out['err_code'] = -1;;
                };
               // lettura del profilo
                while (!feof($fh)){
                    $line   = fgets($fh);
                    $km     = (int)trim(substr($line, 0, 4));
                    $fp     = trim(substr($line, 12, 6));
                    if ($fp != ''){
                        //$this -> model_list[$km] = $fp;
                        $this -> model_list[] = array('h' => $km, 'f' => $fp);
                    }
                    if (substr($line, 19, 17) == 'TEC bottomside = '){
                        $this -> tec_bottom = trim(substr($line, 36, 7));
                    }
                    if (substr($line, 19, 11) == 'TEC TOPSIDE'){
                        $this -> tec_top = trim(substr($line, 73, 7)); 
                    }
                }
                usort($this->model_list, function($a, $b) {
                    return $a['h'] <=> $b['h'];
                });
                $this -> model_json = json_encode($this->model_list, JSON_NUMERIC_CHECK);
            } /// di nodata_AIS
            fclose($fh);
            $out = array(
                "err_code" => 0,
                "err_message" => "File paesed"
            );
        } else {
            $out = array(
                "err_code" => -1,
                "err_message" => "Cant open file"
            );
        } // di openfile
        return $out;
   }

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
        }
        /// tolgo il path dal nome del file
        $fname = pathinfo($this->filename)['filename'];
        /// setto utc per poter inserire il modified corretto nel db
        date_default_timezone_set("UTC");
        $sql = "SELECT COUNT(*) nrow FROM ".$this->station."_auto WHERE dt = :rdt;";
        try{
            $stmt = $this -> myconn -> conn -> prepare($sql, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
            $appo = array(
                    ':rdt'    => $this -> datetime
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
                  "station,".
                  "fromfile,".
                  "producer,".
                  "fof2,".
                  "fof2_eval,".
                  "muf3000f2,".
                  "muf3000f2_eval,".
                  "m3000f2,".
                  "m3000f2_eval,".
                  "fxi,".
                  "fxi_eval,".
                  "fof1,".
                  "fof1_eval,".
                  "ftes,".
                  "ftes_eval,".
                  "h_es,".
                  "h_es_eval,".
                  "aip_hmf2,".
                  "aip_fof2,".
                  "aip_fof1,".
                  "aip_hmf1,".
                  "aip_d1,".
                  "aip_foe,".
                  "aip_hme,".
                  "aip_yme,".
                  "aip_h_ve,".
                  "aip_ewidth,".
                  "aip_deln_ve,".
                  "aip_b0,".
                  "aip_b1,".
                  "tec_bottom,".
                  "tec_top,".
                  "profile,".
                  "modified)".
            " VALUES (".
                ":datetime,".
                ":stationinfile,".
                ":filename,".
                ":producer,".
                ":foF2,".
                ":foF2_eval,".
                ":MUFF2,".
                ":MUFF2_eval,".
                ":MF2,".
                ":MF2_eval,".
                ":fxI,".
                ":fxI_eval,".
                ":foF1,".
                ":foF1_eval,".
                ":ftEs,".
                ":ftEs_eval,".
                ":hEs,".
                ":hEs_eval,".
                ":hmF2_AIP,".
                ":foF2_AIP,".
                ":foF1_AIP,".
                ":hmF1_AIP,".
                ":D1_AIP,".
                ":foE_AIP,".
                ":hmE_AIP,".
                ":ymE_AIP,".
                ":h_vE_AIP,".
                ":Ewidth_AIP,".
                ":DelN_vE_AIP,".
                ":B0_AIP,".
                ":B1_AIP,".
                ":tec_bottom,".
                ":tec_top,".
                ":model_json,".
                ":modified)";
        } else {
            /// aggiungo il separatore per il nome del file
            $fname = " " . $fname;

            $sql = "UPDATE ".$this->station."_auto SET ".
                      "station =            :stationinfile,". 
                      "fromfile = fromfile || ' ' || :filename,". 
                      "producer =           :producer,".       
                      "fof2 =               :foF2,".          
                      "fof2_eval =          :foF2_eval,".     
                      "muf3000f2 =          :MUFF2,".         
                      "muf3000f2_eval =     :MUFF2_eval,".    
                      "m3000f2 =            :MF2,".           
                      "m3000f2_eval =       :MF2_eval,".      
                      "fxi =                :fxI,".           
                      "fxi_eval =           :fxI_eval,".      
                      "fof1 =               :foF1,".          
                      "fof1_eval =          :foF1_eval,".     
                      "ftes =               :ftEs,".          
                      "ftes_eval =          :ftEs_eval,".     
                      "h_es =               :hEs,".           
                      "h_es_eval =          :hEs_eval,".      
                      "aip_hmf2 =           :hmF2_AIP,".      
                      "aip_fof2 =           :foF2_AIP,".      
                      "aip_fof1 =           :foF1_AIP,".      
                      "aip_hmf1 =           :hmF1_AIP,".      
                      "aip_d1 =             :D1_AIP,".        
                      "aip_foe =            :foE_AIP,".       
                      "aip_hme =            :hmE_AIP,".       
                      "aip_yme =            :ymE_AIP,".       
                      "aip_h_ve =           :h_vE_AIP,".      
                      "aip_ewidth =         :Ewidth_AIP,".    
                      "aip_deln_ve =        :DelN_vE_AIP,".   
                      "aip_b0 =             :B0_AIP,".        
                      "aip_b1 =             :B1_AIP,".        
                      "tec_bottom =         :tec_bottom,".    
                      "tec_top =            :tec_top,".       
                      "profile =            :model_json,".    
                      "modified =           :modified".
                  " WHERE dt = :datetime";
        }
        $appo = array(
                ':datetime'         => isset($this -> datetime) ? $this -> datetime : null,
                ':stationinfile'    => isset($this -> stationinfile) ? $this -> stationinfile : null,
                ':filename'         => isset($fname) ? $fname : null,
                ':producer'         => isset($this -> producer) ? $this -> producer : null,
                ':foF2'             => isset($this -> foF2) ? $this -> foF2 : null,
                ':foF2_eval'        => isset($this -> foF2_eval) ? $this -> foF2_eval : null,
                ':MUFF2'            => isset($this -> MUFF2) ? $this -> MUFF2 : null,
                ':MUFF2_eval'       => isset($this -> MUFF2_eval) ? $this -> MUFF2_eval : null,
                ':MF2'              => isset($this -> MF2) ? $this -> MF2 : null,
                ':MF2_eval'         => isset($this -> MF2_eval) ? $this -> MF2_eval : null,
                ':fxI'              => isset($this -> fxI) ? $this -> fxI : null,
                ':fxI_eval'         => isset($this -> fxI_eval) ? $this -> fxI_eval : null,
                ':foF1'             => isset($this -> foF1) ? $this -> foF1 : null,
                ':foF1_eval'        => isset($this -> foF1_eval) ? $this -> foF1_eval : null,
                ':ftEs'             => isset($this -> ftEs) ? $this -> ftEs : null,
                ':ftEs_eval'        => isset($this -> ftEs_eval) ? $this -> ftEs_eval : null,
                ':hEs'              => isset($this -> hEs) ? $this -> hEs : null,
                ':hEs_eval'         => isset($this -> hEs_eval) ? $this -> hEs_eval : null,
                ':hmF2_AIP'         => isset($this -> hmF2_AIP) ? $this -> hmF2_AIP : null,
                ':foF2_AIP'         => isset($this -> foF2_AIP) ? $this -> foF2_AIP : null,
                ':foF1_AIP'         => isset($this -> foF1_AIP) ? $this -> foF1_AIP : null,
                ':hmF1_AIP'         => isset($this -> hmF1_AIP) ? $this -> hmF1_AIP : null,
                ':D1_AIP'           => isset($this -> D1_AIP) ? $this -> D1_AIP : null,
                ':foE_AIP'          => isset($this -> foE_AIP) ? $this -> foE_AIP : null,
                ':hmE_AIP'          => isset($this -> hmE_AIP) ? $this -> hmE_AIP : null,
                ':ymE_AIP'          => isset($this -> ymE_AIP) ? $this -> ymE_AIP : null,
                ':h_vE_AIP'         => isset($this -> h_vE_AIP) ? $this -> h_vE_AIP : null,
                ':Ewidth_AIP'       => isset($this -> Ewidth_AIP) ? $this -> Ewidth_AIP : null,
                ':DelN_vE_AIP'      => isset($this -> DelN_vE_AIP) ? $this -> DelN_vE_AIP : null,
                ':B0_AIP'           => isset($this -> B0_AIP) ? $this -> B0_AIP : null,
                ':B1_AIP'           => isset($this -> B1_AIP) ? $this -> B1_AIP : null,
                ':tec_bottom'       => isset($this -> tec_bottom) ? $this -> tec_bottom : null,
                ':tec_top'          => isset($this -> tec_top) ? $this -> tec_top : null,
                ':model_json'       => isset($this -> model_json) ? $this -> model_json : null,
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
                    'err_message'   => "OK_LOADED ". $this->station .  " ". $this->datetime
                );
            }else{
                $out = array(
                    'err_code'      => 0,
                    'err_message'   => "OK_UPDATED ". $this->station .  " ". $this->datetime
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
        return $out;
    } // function
    
}

?>
