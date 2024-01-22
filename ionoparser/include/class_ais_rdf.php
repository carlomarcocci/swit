<?php
/************************************************************************/
/****Classe per la gestione dei file RDF prodotti dalla ionosnoda AIS****/

class ais_rdf_file
{
    public $filename;               /// input file name 
    public $station;                /// nome della stazione
    public $stalat;                 /// latitudine della stazione
    public $stalon;                 /// longitudine della stazione
    public $isPostgres;             /// true if upe pg
    public $db;                     /// database name

    public $freq_start;             /// sounding starting frequency
    public $freq_end;               /// sounding ending frequency
    public $freq_step;              /// sounding step frequency
    public $height_start;           /// echo starting height
    public $height_end;             /// echo ending height
    public $height_step;            /// echo step height
    public $att_int;                /// internal attenuation
    public $att_ext;                /// external attenuation
    public $math_ampli;             /// mathematical amplification
    public $high;                   /// filter parameter, high
    public $low;                    /// filter parameter, low
    public $int_n;                  /// integrations number
    public $dsp_ver;                /// Digital Sygnal Processing version
    public $comment_man;            /// manual comment
    public $comment;                /// comment
    public $station_code;           /// URSI code for station
    public $dt;                     /// datetime della misura
    public $lat;                    /// station lat set on ionosonda
    public $lon;                    /// station lon set on ionosonda
    public $lat_mag;                /// magnetic lat set on ionosonda
    public $lon_mag;                /// magnetic lon set on ionosonda
    public $freq_gyro;              /// gyrofrequency
    public $mag_inclination;         // magnetic declination
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

        if ($fn = fopen($this->filename, 'r')) {
            //$line = file($fn);   // apro il file come array e poi estraggo l'header (primo riga) e il corpo (seconda riga)
            if (!feof($fn)) {
                $line = fgets($fn);   // apro il file come array e poi estraggo l'header, primo riga, e il corpo, seconda riga

                //$head = explode(' ', $line); //header è ora un array di elementi
                $this -> freq_start         = trim(substr($line, 0,6));
                $this -> freq_end           = trim(substr($line, 7,6));
                $this -> freq_step          = trim(substr($line, 14,5));
                $this -> height_start       = trim(substr($line, 20,5));
                $this -> height_end         = trim(substr($line, 26,5));
                $this -> height_step        = trim(substr($line, 32,3));
                $this -> att_int            = trim(substr($line, 36,2));
                $this -> att_ext            = trim(substr($line, 39,2));
                $this -> math_ampli         = trim(substr($line, 42,1));
                $this -> high               = hexdec(trim(substr($line, 44,4)));
                $this -> low                = hexdec(trim(substr($line, 49,4)));
                $this -> int_n              = trim(substr($line, 54,2));
                $this -> dsp_ver            = trim(substr($line, 57,1));  // 12
                $this -> comment_nam        = trim(substr($line, 59,6)); // 13
                $this -> comment            = trim(substr($line, 66,55)); // 14
                $this -> station_code       = trim(substr($line, 122,5));  // 15

                $date                       = date_create(trim(substr($line, 128,4)) . "-" .
                                                          trim(substr($line, 133,2)) . "-" .
                                                          trim(substr($line, 136,2)) . " " .
                                                          trim(substr($line, 143,5))
                                                          );
                $this -> dt                 = $date -> format('Y-m-d H:i:s');
                $this -> lat                = trim(substr($line, 149,5));  // [21];
                $this -> lon                = trim(substr($line, 155,5));  // [22];
                $this -> lat_mag            = trim(substr($line, 162,5));  // [23];
                $this -> lon_mag            = trim(substr($line, 167,5));  // [24];
                $this -> freq_gyro          = trim(substr($line, 173,4));  // [25];
                $this -> mag_inclination    = trim(substr($line, 178,5));  // [26];
            }
            if (!feof($fn)) {
                $body = fgets($fn);   // apro il file come array e poi estraggo l'header (primo riga) e il corpo (seconda riga)            

            /********Parsing Body********/
            //$body   = $line[1];
                $n_freq     = ($this->freq_end - $this->freq_start) / ($this->freq_step) + 1; //numero di valori di frequenza
                $n_height   = ($this->height_end - $this->height_start) / ($this->height_step) + 1; //numero di valori di altitudine
                $k = 0;
                for ($j = 0; $j < $n_freq; ++$j) {
                    for ($i = 0; $i < $n_height; ++$i) {
       //array in cui ogni elemento è un array associativo con coppie chiave->valore per frequenza, altitudine, intensità echo (approssimati alla seconda cifra decimale)
                        //$list[$k] = ['f' => round(($this->freq_start) + ($this->freq_step) * $j, 2), 'h' => round(90 + 4.5 * $i, 2), 'm' => ord(substr($body, $k))];
                        $list[] = ['h' => round(90 + 4.5 * $i, 2), 'f' => round(($this->freq_start) + ($this->freq_step) * $j, 2), 'm' => ord(substr($body, $k))];
                        $k = $k + 1;
                    }
                }
                usort($list, function($a, $b) {
                    return $a['h'] <=> $b['h'];
                });
                $this->model_json = json_encode($list, JSON_NUMERIC_CHECK); //encode del file json 
            }
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

    function check_values(){
        $this -> freq_start         = (is_numeric($this -> freq_start) ? $this -> freq_start : null);             /// sounding starting frequency
        $this -> freq_end           = (is_numeric($this -> freq_end) ? $this -> freq_end : null);         /// sounding ending frequency
        $this -> freq_step          = (is_numeric($this -> freq_step) ? $this -> freq_step : null);         /// sounding step frequency
        $this -> height_start       = (is_numeric($this -> height_start) ? $this -> height_start : null);           /// echo starting height
        $this -> height_end         = (is_numeric($this -> height_end) ? $this -> height_end : null) ;             /// echo ending height
        $this -> height_step        = (is_numeric($this -> height_step) ? $this -> height_step : null);            /// echo step height
        $this -> att_int            = (is_numeric($this -> att_int) ? $this -> att_int : null);                /// internal attenuation
        $this -> att_ext            = (is_numeric($this -> att_ext) ? $this -> att_ext : null);                /// external attenuation
        $this -> math_ampli         = (is_numeric($this -> math_ampli) ? $this -> math_ampli : null);             /// mathematical amplification
        $this -> high               = (is_numeric($this -> high) ? $this -> high : null);                   /// filter parameter, high
        $this -> low                = (is_numeric($this -> low) ? $this -> low : null);                    /// filter parameter, low
        $this -> int_n              = (is_numeric($this -> int_n) ? $this -> int_n : null);                  /// integrations number
        $this -> dsp_ver            = (is_numeric($this -> dsp_ver) ? $this -> dsp_ver : null);                /// Digital Sygnal Processing version
        $this -> comment_man;            /// manual comment
        $this -> comment;                /// comment
        $this -> freq_gyro          = (is_numeric($this -> freq_gyro) ? $this -> freq_gyro : null);              /// gyrofrequency
        $this -> mag_inclination    = (is_numeric($this -> mag_inclination) ? $this -> mag_inclination : null);         // magnetic declination
        $this -> model_json;
        if (substr($this->comment, 0,10) == 'xxxxxxxxxx'){
            $this->comment = NULL;
        }

   }

    function push2db() {        
        /** Funzione per il popolamento e la creazione della tabella rdf
        *   senza utilizzo di sp per eseguirla su pg
        */

        /// Correzione dei campi letti dal file 
        $this->check_values();
    
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
                    ':tablename'    => strval($this -> station)."_rdf"
                );
            $stmt->execute( $appo);
            $out = $stmt -> fetchAll();
        }
        catch (PDOException $e) {
            fn_debug_query($stmt, $appo, $out);
            echo "ERROR CONNECTIN DB ";
            $stmt->closeCursor();
            return ;
        }
        $stmt->closeCursor();
        if ($out[0]['ntab'] == 0) {
            // il nome della tabella non puo essere passato col prepare cone variabile di pdo
            $sql = "CREATE TABLE ".$this -> station."_rdf"." (".
            "dt                 timestamp NOT NULL, ".
            "filename       	varchar(255) NOT NULL, ".
            "comment        	varchar(55) NULL, ".
            "freq_start     	float NOT NULL, ".
            "freq_end       	float NOT NULL, ".
            "freq_step      	float NOT NULL, ".
            "height_start   	float NOT NULL, ".
            "height_end     	float NOT NULL, ".
            "height_step    	float NOT NULL, ".
            "att_int        	int NOT NULL, ".
            "att_ext        	int NOT NULL, ".
            "math_ampli     	int DEFAULT NULL, ".
            "high           	int NOT NULL, ".
            "low            	int NOT NULL, ".
            "int_n          	int NOT NULL, ".
            "dsp_ver       	 	int DEFAULT NULL, ".
            "comment_man    	varchar(6) DEFAULT NULL, ".
            "freq_gyro      	float NOT NULL, ".
            "mag_inclination    float NOT NULL, ".
            "ionogram         	jsonb DEFAULT NULL, ".
            "modified      timestamp NOT NULL , ".
            "PRIMARY KEY  (dt) ".
            ");";
            try{
                //$stmt = $this -> myconn -> conn -> prepare($sql, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
                $stmt = $this -> myconn -> conn -> prepare($sql);
                $stmt->execute();
           	    $out = $stmt -> fetchAll();
        	} 
            catch (PDOException $e) {
                //fn_debug_query_e($sql, $appo, $out. $e);
                echo "ERROR CONNECTIN DB ";
                return ;
            }
            $stmt->closeCursor();
        }
        date_default_timezone_set("UTC");
        // il nome della tabella non puo essere passato col prepare cone variabile di pdo
        $sql = "INSERT INTO ".$this -> station."_rdf (".
                "filename," .
                "dt," . 
                "comment," . 
                "freq_start," . 
                "freq_end," .
                "freq_step," . 
                "height_start," . 
                "height_end," . 
                "height_step," .
                "att_int," . 
                "att_ext," . 
                "math_ampli," . 
                "high," . 
                "low," .
                "int_n," .
                "dsp_ver," . 
                "comment_man," .
                "freq_gyro," . 
                "mag_inclination," . 
                "ionogram,".
                "modified)".
            " VALUES(".
                ":filename," .
                ":dt," . 
                ":comment," . 
                ":freq_start," . 
                ":freq_end," .
                ":freq_step," . 
                ":height_start," . 
                ":height_end," . 
                ":height_step," .
                ":att_int," . 
                ":att_ext," . 
                ":math_ampli," . 
                ":high," . 
                ":low," .
                ":int_n," .
                ":dsp_ver," . 
                ":comment_man," .
                ":freq_gyro," . 
                ":mag_inclination," . 
                ":ionogram,".
                ":modified)";
       try {
            $stmt = $this->myconn->conn->prepare($sql, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
            $appo = array(
                ':filename'         => strval($this->filename),
                ':dt'               => strval($this->dt),
               ':comment'           => strval($this->comment),
                ':freq_start'       => strval($this->freq_start),
                ':freq_end'         => strval($this->freq_end),
                ':freq_step'        => strval($this->freq_step),
                ':height_start'     => strval($this->height_start),
                ':height_end'       => strval($this->height_end),
                ':height_step'      => strval($this->height_step),
                ':att_int'          => strval($this->att_int),
                ':att_ext'          => strval($this->att_ext),
                ':math_ampli'       => isset($this->math_ampli) ? $this->math_ampli : null ,
                ':high'             => strval($this->high),
                ':low'              => strval($this->low),
                ':int_n'            => strval($this->int_n),
                ':dsp_ver'          => isset($this->dsp_ver) ? $this->dsp_ver : null,
                ':comment_man'      => strval($this->comment_man),
                ':freq_gyro'        => strval($this->freq_gyro),
                ':mag_inclination'  => strval($this->mag_inclination),
                ':ionogram'         => strval($this->model_json),
                ':modified'         => date('Y-m-d H:i:s')
            );
            $stmt->execute($appo);
            $outapp = $stmt->fetchAll();
            $out = $outapp['0'];
            $out = array(
                "err_code"      => 0,
                "err_message"   => "OK_INSERTED ". $this->station .  " ". $this->dt
            );
        }
        catch (PDOException $e)
        {
            if ($e->getCode() == 23505) {
                $out = array(
                    "err_code"      => 0,
                    "err_message"   => "OK_DUPE ". $this->station .  " ". $this->dt. " duplicate row"
                );
                $stmt -> closeCursor();
                return $out;
            }
            else{
                $out = array(
                    "err_code" => 20,
                    "err_message" => $e->getMessage()
                );
                fn_debug_query_e($sql, $appo, $outapp, $e);
                $stmt -> closeCursor();
                return $out;
            }
        }
        $stmt -> closeCursor();
        return $out;
    } // function

} //chiusura classe
