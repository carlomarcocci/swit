<?php

class dps_sao_file {
/**
 * Classe per la gestione delle misure effettuate dalla ionosnoda dps
 */

    public $datetimeinfile;              /// datetime della misura

    public $filename;              /// input file name 
    public $station;               /// nome della stazione
    public $datetime;              /// datetime della misura
    public $producer;              /// programma che ha prodotto i dati
    public $myconn;
    public $isPostgres;             /// true if upe pg
    public $db;                     /// database name

    public $foF2;                   /// foF2 del primo blocco
    public $MUFF2;                  /// MUF(3000)F2 del primo blocco
    public $MF2;                   /// M(3000)F2 del primo blocco
    public $fxI;                   /// fxI del primo blocco
    public $foF1;                  /// foF1 del primo blocco
//    public $ftEs;                  /// ftEs del primo blocco
    public $hEs;                    /// h'Es del primo blocco
 
    public $foEs;                   /// frequenza critica strato E sporadico
    public $foE;                    /// frequenza critica dello strato E misurato
    public $hF;                    /// frequenza critica dello strato F
    public $hF2;                    /// frequenza critica dello strato F2
    public $hE;                    /// frequenza critica dello strato E

    public $tec;
    public $traceF2_json;
    public $traceF1_json;
    public $traceE_json;
    public $traceEs_json;
    public $density_json;

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
     * Funzione che popola la classe leggendo il file di input prodotto dalla dps
     */
        $groups = array();
        $out = array(
            "err_code" => "",
            "err_message" => ""
        );
        if ($fh = fopen($this -> filename, 'r')) {
            if (!feof($fh)) {
                // legge le prime due righe con il numero dei valori per ogni gruppoi
                $groups[0] = [0 => 80];
                $groups[0] = array_filter(array_merge($groups[0],array_map('trim', str_split(fgets($fh),3))), function ($d){return $d != '';});
                $groups[0] = array_filter(array_merge($groups[0], array_map('trim', str_split(fgets($fh),3))), function ($d){return $d != '';});
                
                // cicla sui valori in group[0] per leggere correttamente il resto del file
                // cicla sui valori in group[0] per leggere correttamente il resto del file
                for ($i = 1; $i < 80; $i++) {
                    if ($groups[0][$i] != 0){
                        $numline = ceil(WORDLEN[$i] * $groups[0][$i] / 120);  // il numero delle righe da leggere 
                        $ap = array_filter(array_map('trim', str_split(fgets($fh),WORDLEN[$i])), function ($d){return $d != '';});
                        for  ($r = 1; $r < $numline; $r++) {
                            $ap = array_filter(array_merge($ap, array_map('trim', str_split(fgets($fh),WORDLEN[$i]))), function ($d){return $d != '';});
                        } 
                        $groups += [ $i => $ap];
                    } 
                }
                
                // definizione delle variabili di interesse a partire dall'array groups
                // gruppo 2 descrittivo
                $this -> producer = trim(substr($groups[2][0],28, 12));
                
                // groups 3 datetime
                $appo                   = fn_array_value_by_range($groups[3], 2, 9);
                $appo                   = $appo.fn_array_value_by_range($groups[3], 13, 19);
                $this -> datetimeinfile = fn_fileNameToDate($appo, 'AI1');

                // gruppo 4 parametri ionosferici
                //  foF2
                if (array_key_exists('0', $groups[4])) {
                    $lettera = $groups[4][0];
                    if (is_numeric($lettera)){
                        if ((float)$lettera >= 9999){
                            $this -> foF2       = null;
                        } else {
                            $this -> foF2       = $lettera;
                        }
                    } else {
                        $out['err_message'] = "ERROR_ON_FIELD:\tfoF2; ".$this -> filename;
                        $out['err_code'] = -1;;
                        return $out;
                    }
                }

                //  MUFF2
                if (array_key_exists('3', $groups[4])) {
                    $lettera = $groups[4][3];
                    if (is_numeric($lettera)){
                        if ((float)$lettera >= 9999){
                            $this -> MUFF2      = null;
                        } else {
                            $this -> MUFF2      = $lettera;
                        }
                    } else {
                        $out['err_message'] = "ERROR_ON_FIELD:\tMUFF2; ".$this -> filename;
                        $out['err_code'] = -1;;
                        return $out;
                    }
                }
                //  foF1
                if (array_key_exists('1', $groups[4])) {
                    $lettera = $groups[4][1];
                    if (is_numeric($lettera)){
                        if ((float)$lettera >= 9999){
                            $this -> foF1       = null;
                        } else {
                            $this -> foF1       = $lettera;
                        }
                    } else {
                        $out['err_message'] = "ERROR_ON_FIELD:\tfof1; ".$this -> filename;
                        $out['err_code'] = -1;;
                        return $out;
                    }
                }
                //  MF2
                if (array_key_exists('2', $groups[4])) {
                    $lettera = $groups[4][2];
                    if (is_numeric($lettera)){
                        if ((float)$lettera >= 9999){
                            $this -> MF2      = null;
                        } else {
                            $this -> MF2      = $lettera;
                        }
                    } else {
                        $out['err_message'] = "ERROR_ON_FIELD:\tMF2; ".$this -> filename;
                        $out['err_code'] = -1;;
                        return $out;
                    }
                }
                //  foEs
                if (array_key_exists('5', $groups[4])) {
                    $lettera = $groups[4][5];
                    if (is_numeric($lettera)){
                        if ((float)$lettera >= 9999){
                            $this -> foEs      = null;
                        } else {
                            $this -> foEs      = $lettera;
                        }
                    } else {
                        $out['err_message'] = "ERROR_ON_FIELD:\tfoEs; ".$this -> filename;
                        $out['err_code'] = -1;;
                        return $out;
                    }
                }
                //  foE
                if (array_key_exists('8', $groups[4])) {
                    $lettera = $groups[4][8];
                    if (is_numeric($lettera)){
                        if ((float)$lettera >= 9999){
                            $this -> foE      = null;
                        } else {
                            $this -> foE      = $lettera;
                        }
                    } else {
                        $out['err_message'] = "ERROR_ON_FIELD:\tfoE; ".$this -> filename;
                        $out['err_code'] = -1;;
                        return $out;
                    }
                }
                //  fxI
                if (array_key_exists('9', $groups[4])) {
                    $lettera = $groups[4][9];
                    if (is_numeric($lettera)){
                        if ((float)$lettera >= 9999){
                            $this -> fxI      = null;
                        } else {
                            $this -> fxI      = $lettera;
                        }
                    } else {
                        $out['err_message'] = "ERROR_ON_FIELD:\tfxI; ".$this -> filename;
                        $out['err_code'] = -1;;
                        return $out;
                    }
                }
                //  hF
                if (array_key_exists('10', $groups[4])) {
                    $lettera = $groups[4][10];
                    if (is_numeric($lettera)){
                        if ((float)$lettera >= 9999){
                            $this -> hF      = null;
                        } else {
                            $this -> hF      = $lettera;
                        }
                    } else {
                        $out['err_message'] = "ERROR_ON_FIELD:\thF; ".$this -> filename;
                        $out['err_code'] = -1;;
                        return $out;
                    }
                }
                //  hF2
                if (array_key_exists('11', $groups[4])) {
                    $lettera = $groups[4][11];
                    if (is_numeric($lettera)){
                        if ((float)$lettera >= 9999){
                            $this -> hF2      = null;
                        } else {
                            $this -> hF2      = $lettera;
                        }
                    } else {
                        $out['err_message'] = "ERROR_ON_FIELD:\thF2; ".$this -> filename;
                        $out['err_code'] = -1;;
                        return $out;
                    }
                }
                //  hE
                if (array_key_exists('12', $groups[4])) {
                    $lettera = $groups[4][12];
                    if (is_numeric($lettera)){
                        if ((float)$lettera >= 9999){
                            $this -> hE      = null;
                        } else {
                            $this -> hE      = $lettera;
                        }
                    } else {
                        $out['err_message'] = "ERROR_ON_FIELD:\thE; ".$this -> filename;
                        $out['err_code'] = -1;;
                        return $out;
                    }
                }
                //  hEs
                if (array_key_exists('13', $groups[4])) {
                    $lettera = $groups[4][13];
                    if (is_numeric($lettera)){
                        if ((float)$lettera >= 9999){
                            $this -> hEs      = null;
                        } else {
                            $this -> hEs      = $lettera;
                        }
                    } else {
                        $out['err_message'] = "ERROR_ON_FIELD:\thEs; ".$this -> filename;
                        $out['err_code'] = -1;;
                        return $out;
                    }
                }
                //  tec
                if (array_key_exists('38', $groups[4])) {      
                    $lettera = $groups[4][38];
                    if (is_numeric($lettera)){
                        if ((float)$lettera >= 9999){
                            $this -> tec      = null;
                        } else {
                            $this -> tec      = $lettera;
                        }
                    } else {
                        $out['err_message'] = "ERROR_ON_FIELD:\ttec; ".$this -> filename;
                        $out['err_code'] = -1;;
                        return $out;
                    }
                }
                
                // tracce ricostruite
                // traceF2 gruppo 7 altezze virtuali strato F2 ricostruiti (km)
                if ($groups[0][7] > 0) {
                    if ($groups[0][7] <> $groups[0][11]){
                        echo "ERROR: group_7: ".$groups[0][7]." group_11: ".$groups[0][11]."\n";
                    }
                    for ($i = 0; $i < $groups[0][7]; $i++){
                        $appo_F2[$i] = array(
                                        'h' => $groups[7][$i],
                                        'f' => $groups[11][$i]
                                        );
                    }
                    $this -> traceF2_json = json_encode($appo_F2, JSON_NUMERIC_CHECK);
                }
                // traceF1 gruppo 12 altezze virtuali strato F1 ricostruiti (km)
                if ($groups[0][12] > 0) {
                    if ($groups[0][12] <> $groups[0][16]){
                        echo "ERROR: group_12: ".$groups[0][12]." group_16: ".$groups[0][16]."\n";
                    }
                    for ($i = 0; $i < $groups[0][12]; $i++){
                        $appo_F1[$i] = array(
                                        'h' => $groups[12][$i],
                                        'f' => $groups[16][$i]
                                        );
                    }
                    $this -> traceF1_json = json_encode($appo_F1, JSON_NUMERIC_CHECK);
                }
                // trace£ gruppo 17 altezze virtuali strato E ricostruiti (km)
                if ($groups[0][17] > 0) {
                    for ($i = 0; $i < $groups[0][17]; $i++){
                        $appo_E[$i] = array(
                                        'h' => $groups[17][$i],
                                        'f' => $groups[21][$i]
                                        );
                    }
                    $this -> traceE_json = json_encode($appo_E, JSON_NUMERIC_CHECK);
                }
                // traceEs gruppo  altezze virtuali strato F1 ricostruiti (km)
                if ($groups[0][43] > 0) {
                    for ($i = 0; $i < $groups[0][43]; $i++){
                        $appo_Es[$i] = array(
                                        'h' => $groups[43][$i],
                                        'f' => $groups[46][$i]
                                        );
                    }
                    $this -> traceEs_json = json_encode($appo_Es, JSON_NUMERIC_CHECK);
                }
                if ($groups[0][51] > 0) {
                    for ($i = 0; $i < $groups[0][51]; $i++){
                        $appo_density[$i] = array(
                                        'h' => $groups[51][$i],
                                        'f' => $groups[52][$i]
                                        );
                    }
                    $this -> density_json = json_encode($appo_density, JSON_NUMERIC_CHECK);
                }
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
            echo "ERROR DB CONNECTION ";
            $stmt->closeCursor();
            $stmt = null;
            return ;
       }
        $stmt->closeCursor();
        $stmt = null;

        // se la rabella di stazione non esiste va creata
        if ($out[0]['ntab'] == 0) {
            // il nome della tabella non puo essere passato col prepare cone variabile di pdo
            $sql = createAisDpsTable($this -> station, $this->isPostgres);
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
                echo "ERROR DB CONNECTION ";
//                retrn ;
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
                echo "ERROR DB CONNECTION ";
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
            echo "ERROR DB CONNECTION ";
            $stmt->closeCursor();
            $stmt = null;
            return ;
        }
        $stmt->closeCursor();
        $stmt = null;
        
        // insert or update row
        $insertUpdate=$out[0]['nrow'];
        if ($insertUpdate == 0) {
            $sql = "INSERT INTO ".$this->station."_auto (".
                    "dt,".
                    " producer,".
                    " fof2,".
                    " muf3000f2,".
                    " m3000f2,".
                    " fxi,".
                    " fof1,".
                    " h_es,".
                    " foes,".
                    " foe,".
                    " hf,".
                    " hf2,".
                    " he,".
                    " tec,".
                    " trace_f2,".
                    " trace_f1,".
                    " trace_e,".
                    " trace_es,".
                    " profile,".
                   " modified)".
            " VALUES (".
                    ":m_dt, ".
                    ":m_producer,".
                    ":m_fof2,".
                    ":m_muff2,".
                    ":m_mf2,".
                    ":m_fxi,".
                    ":m_fof1,".
                    ":m_hes,".
                    ":m_foes,".
                    ":m_foe,".
                    ":m_hf,".
                    ":m_hf2,".
                    ":m_he,".
                    ":m_tec,".
                    ":m_trace_f2,".
                    ":m_trace_f1,".
                    ":m_trace_e,".
                    ":m_trace_es,".
                    ":m_profile,".
                    ":m_modified)";
        } else {
            /// aggiungo il separatore per il nome del file
            $fname = " " . $fname;

            $sql = "UPDATE ".$this->station."_auto SET ".
                      "producer =             :m_producer,".
                      "fof2 =               :m_fof2,".
                      "muf3000f2 =        :m_muff2,".
                      "m3000f2 =             :m_mf2,".
                      "fxi =             :m_fxi,".
                      "fof1 =             :m_fof1,".
                      "h_es =             :m_hes,".
                      "foes =             :m_foes,".
                      "foe =             :m_foe,".
                      "hf =             :m_hf,".
                      "hf2 =             :m_hf2,".
                      "he =             :m_he,".
                      "tec =             :m_tec,".
                      "trace_f2 =             :m_trace_f2,".
                      "trace_f1 =             :m_trace_f1,".
                      "trace_e =             :m_trace_e,".
                      "trace_es =             :m_trace_es,".
                      "profile =             :m_profile,".
                      "modified =             :m_modified ".
                  " WHERE dt = :m_dt";
        }
        //$arrar = array(
        $appo = array(
                    ':m_dt'             => isset($this -> datetimeinfile) ? $this -> datetimeinfile : null,
                    ':m_producer'       => $this -> producer,
                    ':m_fof2'           => $this -> foF2,
                    ':m_muff2'          => $this -> MUFF2,
                    ':m_mf2'            => $this -> MF2,
                    ':m_fxi'            => $this -> fxI,
                    ':m_fof1'           => $this -> foF1,
                    ':m_hes'            => $this -> hEs,
                    ':m_foes'           => $this -> foEs,
                    ':m_foe'            => $this -> foE,
                    ':m_hf'             => $this -> hF,
                    ':m_hf2'            => $this -> hF2,
                    ':m_he'             => $this -> hE,
                    ':m_tec'            => $this -> tec,
                    ':m_trace_f2'       => $this -> traceF2_json,
                    ':m_trace_f1'       => $this -> traceF1_json,
                    ':m_trace_e'        => $this -> traceE_json,
                    ':m_trace_es'       => $this -> traceEs_json,
                    ':m_profile'        => $this -> density_json,
                    ':m_modified'       => date('Y-m-d H:i:s')
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
