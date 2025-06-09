<?php

class dps4d_xml_file {
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
    **/
        $groups = array();
        $out = array(
            "err_code" => "",
            "err_message" => ""
        );
        // enable user error handling        
        libxml_use_internal_errors(true);
        // read file xml
        if ( $file_xml = simplexml_load_file($this->filename)){
            $ardate =  $pieces = explode(" ", $file_xml->SAORecord->SystemInfo->StartTime);
            $this -> datetimeinfile = str_replace('.', '-', $ardate[0]) . ' ' . explode('.', $ardate[2])[0];
            $this -> producer = (string) $file_xml->SAORecord->SystemInfo->AutoScaler['Name'] ;
            $this -> foF2 = fn_read_ursi_saoXml($file_xml->SAORecord->CharacteristicList, 'foF2');
            $this -> MUFF2= fn_read_ursi_saoXml($file_xml->SAORecord->CharacteristicList, 'MUF(D)');
            $this -> foF1 = fn_read_ursi_saoXml($file_xml->SAORecord->CharacteristicList, 'foF1');
            $this -> MF2  = fn_read_ursi_saoXml($file_xml->SAORecord->CharacteristicList, 'M(D)');
            $this -> foEs = fn_read_ursi_saoXml($file_xml->SAORecord->CharacteristicList, 'foEs');
            $this -> foE  = fn_read_ursi_saoXml($file_xml->SAORecord->CharacteristicList, 'foE');
            $this -> fxI  = fn_read_ursi_saoXml($file_xml->SAORecord->CharacteristicList, 'fxI');
            $this -> hF   = fn_read_ursi_saoXml($file_xml->SAORecord->CharacteristicList, 'h`F');
            $this -> hF2  = fn_read_ursi_saoXml($file_xml->SAORecord->CharacteristicList, 'h`F2');
            $this -> hE   =  fn_read_ursi_saoXml($file_xml->SAORecord->CharacteristicList, 'h`E');
            $this -> hEs  = fn_read_ursi_saoXml($file_xml->SAORecord->CharacteristicList, 'h`Es');
            $this -> tec  = fn_read_ursi_saoXml($file_xml->SAORecord->CharacteristicList, 'TEC');

            // start trace reading
            $xml = $file_xml->SAORecord->TraceList;
            foreach($xml->children() as $child) {
                switch ($child['0']['Layer']) {
                    case 'F2' :
                        $this -> traceF2_json = fn_trace_xml2json_saoXml($child->FrequencyList['0'], $child->RangeList['0']);
                        break;
                    case 'F1' :
                        $this -> traceF1_json = fn_trace_xml2json_saoXml($child->FrequencyList['0'], $child->RangeList['0']);
                        break;
                    case 'E' :
                        $this -> traceE_json = fn_trace_xml2json_saoXml($child->FrequencyList['0'], $child->RangeList['0']);
                        break;
                    case 'Es' :
                        $this -> traceEs_json = fn_trace_xml2json_saoXml($child->FrequencyList['0'], $child->RangeList['0']);
                        break;
                } // swutch case
            } // foreach child
            // profileList
            if (isset($file_xml->SAORecord->ProfileList)) {
                foreach($file_xml->SAORecord->ProfileList ->children() as $child) {
                    // print_r($child->Tabulated->AltitudeList);
                    // $this -> density_json = fn_trace_xml2json_saoXml($child->Tabulated->AltitudeList['0'], $child->Tabulated->ProfileValueList['0']);
                    $this -> density_json = fn_trace_xml2json_saoXml($child->Tabulated->ProfileValueList['0'], $child->Tabulated->AltitudeList['0']);
                } // foreach profile ihild
            } 
            
        }
        else{
            print_r(libxml_get_errors());
            foreach (libxml_get_errors() as $errXml){
                print_r($errXml);
            }
        }; // if load file xml
//print_r($this);
//die();
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
                echo "ERROR CONNECTIN DB ";
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
                    ':rdt'    => $this -> datetimeinfile
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
                      "fxi =              :m_fxi,".
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
                    ':m_producer'       => isset($this->producer) ? $this->producer : null,
                    ':m_fof2'           => isset($this->foF2)   && $this->foF2  != "" ? $this->foF2 : null,
                    ':m_muff2'          => isset($this->MUFF2)  && $this->MUFF2 != "" ? $this->MUFF2 : null,
                    ':m_mf2'            => isset($this->MF2)    && $this->MF2   != "" ? $this->MF2 : null,
                    ':m_fxi'            => isset($this->fxI)    && $this->fxI   != "" ? $this->fxI : null,
                    ':m_fof1'           => isset($this->foF1)   && $this->foF1  != "" ? $this->foF1 : null,
                    ':m_hes'            => isset($this->hEs)    && $this->hEs   != "" ? $this->hEs : null,
                    ':m_foes'           => isset($this->foEs)   && $this->foEs  != "" ? $this->foEs : null,
                    ':m_foe'            => isset($this->foE)    && $this->foE   != "" ? $this->foE : null,
                    ':m_hf'             => isset($this->hF)     && $this->hF    != "" ? $this->hF : null,
                    ':m_hf2'            => isset($this->hF2)    && $this->hF2   != "" ? $this->hF2 : null,
                    ':m_he'             => isset($this->hE)     && $this->hE    != "" ? $this->hE : null,
                    ':m_tec'            => isset($this->tec)    && $this->tec   != "" ? $this->tec : null,
                    ':m_trace_f2'       => isset($this->traceF2_json) ? $this->traceF2_json : null,
                    ':m_trace_f1'       => isset($this->traceF1_json) ? $this->traceF1_json : null,
                    ':m_trace_e'        => isset($this->traceE_json) ? $this->traceE_json : null,
                    ':m_trace_es'       => isset($this->traceEs_json) ? $this->traceEs_json : null,
                    ':m_profile'        => isset($this->density_json) ? $this->density_json : null,
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
