<?php

class input_file {
/**
 * \brief Classe per la gestione del generico file letto dal parser
 * Ha solo le info sul file, la stazione e la data a cui si riferisce
 * 
 */

    public $filename;               /// id della costellazione
    public $name;                   /// id della costellazione
    public $extension;              /// id della costellazione
    public $dtformat;               /// formato della data nel nome del file
    public $datetime;               /// datetime della misura
    public $filestation;            /// datetime della misura
    public $codestation;            /// datetime della misura
    public $bkupOn;                 /// path per oò bkup dei file dati
    public $bkup_prefix='';         /// eventuale prefisso al nome della dir di backup, usato per ais rivisti, viene inserito dopo il mome stazione
    public $parseOn;                /// variabile bool per definire se va fatto o meno il nkup
    public $bkuppat ='';            /// path per oò bkup dei file dati
    public $dt_start;            /// path per oò bkup dei file dati
    public $dt_len;            /// path per oò bkup dei file dati
    public $file_type;            /// file type da db swit
    public $parser_ref;            /// file class name da db swit

    public  $sw_conn;                               /// connessione
    public  $sw_host;                               /// host db pg swit
    public  $sw_port;                               /// port number
    public  $sw_db;                                 /// database name
    public  $sw_user;                                 /// database name
    public  $sw_pass;                                 /// database name

    public  $myconn;                                /// connessione
    public  $host;                                  /// hist mysql
    public  $port;                                    /// port number
    public  $db;
    public  $db_type;
    public  $user;
    public  $pass;


    //function __construct($fn, $hs, $pn, $bk, $prs){
    function __construct($fn){
        $path_parts             = pathinfo($fn);
        $statf                  = stat($fn);

        $this -> filename       = $fn;
        $this -> name           = $path_parts['filename'];
        $this -> extension      = strtolower($path_parts['extension']);
        $this -> dirname        = $path_parts['dirname'];
        
//$this -> filestation    = strtolower(substr($this->name,0,5 ));
        // config connessione a swit db
        $this -> sw_host    = getenv('IPARSER_SWIT_HOST');
        $this -> sw_port    = getenv('IPARSER_SWIT_PORT');
        $this -> sw_db      = getenv('IPARSER_SWIT_DB');
        $this -> sw_user    = getenv('IPARSER_SWIT_USER');
        $this -> sw_pass    = getenv('IPARSER_SWIT_PASS');

        $this -> sw_conn = new pgPdoUsr($this -> sw_host, $this -> sw_port, $this -> sw_db, $this -> sw_user, $this -> sw_pass);
        $sql =  "SELECT  a.code AS acode, ".
                        " a.dt_start        AS adt_start, ".
                        " a.fk_dt_format    AS adt_format, ".
                        " a.db_host         AS adb_host, ".
                        " a.db_port         AS adb_port, ".
                        " a.db_type         AS adb_type, ".
                        " a.db_name         AS adb_name, ".
                        " a.db_user         AS adb_user, ".
                        " a.db_pass         AS adb_pass, ".
                        " a.to_parse        AS ato_parse, ".
                        " a.to_store        AS ato_store, ".
                        " a.bkup_dir        AS abkup_dir, ".
                        " a.fk_file_type    AS afile_type, ".
                        " b.code            AS bcode, ".
                        " b.dt_len          AS bdt_len, ".
                        " t.parser_ref      AS parser_ref ".
                    " FROM file_input a ".
                        " JOIN dt_format b ON a.fk_dt_format = b.code ".
                        " JOIN file_type t ON a.fk_file_type = t.code ".
                    ' WHERE LOWER(SUBSTRING(:filename, a.code_start + 1, a.code_length)) = a.filecode '.
                        " AND :exten SIMILAR TO a.extension;";
        try{
            /// ricerca nella tabella dei source i primi 5 caratteri del file
            /// le righe restituite possono essere anche piu di una, la differenza
            /// la fa il formato della data e la posizione da cui si inizia a leggerla
            /// questo per gestire i casi, soprattutto del passato, in cui la stessa
            /// stazione ha diversi formati di datetime (odio sempre tutti)
            $stmt = $this -> sw_conn -> conn -> prepare($sql, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
            $appo = array(
                    ':filename'     => strval($this->name),
                    ':exten'        => strval($this->extension)
                );
            $stmt->execute( $appo);
            $out = $stmt -> fetchAll();
                
        }
        catch (PDOException $e) {
            fn_debug_query($stmt, $appo, $out);                
            echo "CANT_READ_FILE_SWIT_TABLE ";
            $this -> backupfile('station_missed');
            return ;
        }
        /// if file name match in swit
        if (count($out)>0){
            $this->codestation      = $out[0]['acode'];
            $this -> dt_start       = $out[0]['adt_start'];
            $this -> host           = $out[0]['adb_host'];
            $this -> port           = $out[0]['adb_port'];
            $this -> db             = $out[0]['adb_name'];
            $this -> user           = $out[0]['adb_user'];
            $this -> pass           = $out[0]['adb_pass'];
            $this -> db_type        = $out[0]['adb_type'];
            $this -> parseOn        = $out[0]['ato_parse'];
            $this -> bkupOn         = $out[0]['ato_store'];
            $this -> bkup_prefix    = $out[0]['abkup_dir'];
            $this -> file_type      = $out[0]['afile_type'];
            $this -> dtformat       = $out[0]['bcode'];
            $this -> dt_len         = $out[0]['bdt_len'];
            $this -> parser_ref     = $out[0]['parser_ref'];
            $this -> datetime       = fn_fileNameToDate(substr($this->name."." .$this->extension,  $this->dt_start, $this->dt_len), $this->dtformat);
        }
        else {
            echo "KO_FILENAME_NOTFOUND_IN_SWITDB ";
            exec('mkdir -p /backup/err_notinswit; mv -f '.$this->filename.' '.'/backup/err_notinswit/');
            die(); 
        }
        $this->bkuppat  = fn_bkup_path($this->datetime);
        $stmt->closeCursor();
        /// se la porta è minore di 4000 allora il server è mysql altrimenti pg
        switch ($this -> db_type) {
            case 'my':
                /// mysql connection
                $this -> myconn = new MySqlPdo($this -> host, $this -> port, $this -> db, $this -> user, $this -> pass);
                break;
            case 'pg':
                /// postgresql connection
                $this -> myconn = new pgPdoUsr($this -> host, $this -> port, $this -> db, $this -> user, $this -> pass);
                break;
            default:
                echo "KO_ERROR_ON_TYPEDB".$this->db;
                return;
        }
    } // func costructor

    function __destruct() {
        exec(' rm -f ./outta.* 2>/dev/null');    /// rimuove i file parsati
        exec(' rm -f ./RED* 2>/dev/null');    /// rimuove i file parsati
    }

    function backupfile($dir){
        $output =   null;
        $retval =   null;
        $pat =  '/backup/'.
                $dir.(($dir == '') ? '' : '/').
                $this->bkup_prefix.(($this->bkup_prefix == '') ? '' : '/').
                (isset($this->codestation) ? strtolower($this->codestation) : 'err_notinswit').'/'.
                $this -> bkuppat;
        if ($this->bkupOn){
            exec('mkdir -p '.$pat, $output, $retval);
            if ($this->extension == 'gz'){
                exec('mv -f '.$this->filename.' '.$pat, $output, $retval);
            }
            else{
                exec('gzip -qf '.$this->filename.' && mv -f '.$this->filename.'.gz '.$pat, $output, $retval);
            }
        } else{
            exec('rm -f '.$this->filename, $output, $retval);
        }
        if ($retval <> 0){
            echo "\n --------------backup error \n";
            print_r($output);
            print_r($retval);
        }       
    }

    function parseFile(){
        if ($this -> parseOn){
        //    $reflectionClass = new ReflectionClass($this->parser_ref);
        //    $myfile = $reflectionClass->newInstanceArgs($this->filename, $this->myconn, $this->codestation, $this->name.".".$this->extension, $this->db_type, $this->db );

            switch ($this->file_type) {
                case "nov_multi":
                    $myfile = new novam_file($this->filename, $this->myconn, $this->codestation, $this->name.".".$this->extension, $this->db_type, $this->db);
                break;
                case "ais_auto":
                    $myfile = new ais_auto_file($this->filename, $this->myconn, $this->codestation, $this->name.".".$this->extension, $this->db_type, $this->db);
                break;
                case "ais_rdf":
                    $myfile = new ais_rdf_file($this->filename, $this->myconn, $this->codestation, $this->name.".".$this->extension, $this->db_type, $this->db);
               break;
               case "ais_sao":
                    $myfile = new ais_sao_file($this->filename, $this->myconn, $this->codestation, $this->name.".".$this->extension, $this->datetime, $this->db_type, $this->db);
                break;
                case "dps_auto":
                    $myfile = new dps_sao_file($this->filename, $this->myconn, $this->codestation, $this->name.".".$this->extension, $this->datetime, $this->db_type, $this->db);
                break;
               case "ais_rev":
                    $myfile = new ais_rev_file($this->filename, $this->myconn, $this->codestation, $this->name.".".$this->extension, $this->datetime, $this->db_type, $this->db);
                break;
        case "ismr_sept":
                    $myfile = new septentrio_file($this->filename, $this->myconn, $this->codestation, $this->name.'.'.$this->extension, $this->db_type, $this->db);
                break;
                case "tec_ncfc":
                    $myfile = new tec_file($this->filename, $this->myconn, $this->codestation, $this->name.".".$this->extension, $this -> datetime);
                break;
                case "nov_gps":
                    $myfile = new novatel_file($this->filename, $this->myconn, $this->codestation, $this->name.".".$this->extension, $this->db_type, $this->db,$this -> extension);
                break;
                case "hf_ncfc":
                    $myfile = new hf_nc_fc($this->filename, $this->myconn, $this->codestation, $this->name.".".$this->extension, $this->datetime, $this->db_type, $this->db);
                break;
                case "dps4d_xml":
                    $myfile = new dps4d_xml_file($this->filename, $this->myconn, $this->codestation, $this->name.".".$this->extension, $this->datetime, $this->db_type, $this->db);
                break;
                default:
                    echo "KO_NO_FILETYPE";
                    $this -> backupfile('filetype_error');
                break;
            } // switch
            // read file
            try{
                $ret_load = $myfile -> read_file();
            }
            catch(Exception $e){
                echo "KO_ERROR_READ_FILE\n";
                $this -> backupfile('parse_error');
            }
            // if read then push
            if ($ret_load['err_code'] == 0) {
                $ret_load = $myfile -> push2db();
                    // 
                    if (in_array($ret_load['err_code'], array('0', '1'))){
                        echo $ret_load['err_message'];
                        $this -> backupfile('');
                    } elseif (in_array($ret_load['err_code'], array('1'))){
                    // riga gia presente nel db per i json file
                        echo $ret_load['err_message']." ";
                        $this -> backupfile('');
                    } elseif (in_array($ret_load['err_code'], array('2'))){
                    // stazione non trovata e quindi backup nella dir apposita
                        echo $ret_load['err_message']." ";
                        $this -> backupfile('station_missed');
                    } else{
                        // tutto il resto è error
                        echo "KO_UNDEFINED_ERROR"; //non ricordo perche
                        $this -> backupfile('errors_parse');
                    }
                } elseif ($ret_load['err_code'] == 10) {
                    echo $ret_load['err_message'];
                    $this -> backupfile('');
                } else{
                    // errore di lettura del file di qualunque tipo
                    echo $ret_load['err_message'];
                    $this -> backupfile('errors');
                }
            }
            else{
                echo "OK_NOPARSE_BK ";
                $this -> backupfile('');
            } // toParse
    } // funxtion parse
}
?>
