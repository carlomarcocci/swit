<?php

class tec_file {
/**
 * Classe per la gestione delle valutazioni di tec per pecasus
 * 
 */

    public  $filename;                  /// input file name 
    public  $fname;                     /// input file name 
    public  $station;                   /// nome della stazione
    public  $R12_eff;                   /// 
    public  $RGEC_mean;                 /// 
    public  $RGEC_std;                  /// 
    public  $f_horizon;                 /// forecasting horizon
    public  $TEC_mean;                  /// tec mean sul file di nc
    public  $TEC_std;                   /// tec std sul file di nc
    public  $refresh_rate;              /// refresh_rate per il calcolo del json
    public  $refresh_rate_u;              /// refresh_rate per il calcolo del json
    public  $dt;                        /// file datefime
    public  $min_lat;                   /// lat di partenza per le misure
    public  $max_lat;                   /// lat di fine per le misure
    public  $step_lat;                  /// step di incremento per le misure
    public  $min_lon;                   /// lon di partenza per le misure
    public  $max_lon;                   /// lon di fine per le misure
    public  $step_lon;                  /// step di incremento per le misure
    public  $json_a = array();          /// array dove viene esploso il json file
    public  $json_f;                    /// json file 
    public  $json;                      /// json file 
    public  $myconn;

    public  $ltfName = 'ltf_gl';        /// nome dell'inico file dei forecast
    public  $nc_ltfName = 'nc_gl';      /// nome dell'inico file dei nc collegato al forecast

    function __construct($fn,$myc, $statio, $fname, $dti){
        $this -> filename   = $fn;
        $this -> fname      = $fname;
        $this -> station    = $statio;
        $this -> myconn     = $myc;
        $this -> dt         = $dti;
//print_r($this);die();    
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

        $this -> min_lat    = $this->json_a['metadata']['spatial_coverage']['min_lat'];
        $this -> max_lat    = $this->json_a['metadata']['spatial_coverage']['max_lat'];
        $this -> step_lat   = $this->json_a['metadata']['spatial_coverage']['delta_lat'];
        $this -> min_lon    = $this->json_a['metadata']['spatial_coverage']['min_lon'];
        $this -> max_lon    = $this->json_a['metadata']['spatial_coverage']['max_lon'];
        $this -> step_lon   = $this->json_a['metadata']['spatial_coverage']['delta_lon'];
        if (array_key_exists('R12_eff', $this->json_a['metadata'])) {
            $this -> R12_eff = $this->json_a['metadata']['R12_eff'];
            if ($this -> R12_eff == -9999) {
                $this -> R12_eff = null;
            }
        }
        if (array_key_exists('forecasting_horizon', $this->json_a['metadata'])) {
            $this -> f_horizon = explode(' ', $this->json_a['metadata']['forecasting_horizon'])[0];
            if ($this -> f_horizon == -9999) {
                $this -> f_horizon = null;
            }
        }
        if (array_key_exists('RGEC_mean', $this->json_a['metadata'])) {
            $this -> RGEC_mean = round($this->json_a['metadata']['RGEC_mean'],2);
            if ($this -> RGEC_mean == -9999) {
                $this -> RGEC_mean = null;
            }
        }
        if (array_key_exists('RGEC_std', $this->json_a['metadata'])) {
            $this -> RGEC_std = round($this->json_a['metadata']['RGEC_std'],2);
            if ($this -> RGEC_std == -9999) {
                $this -> RGEC_std = null;
            }
        }
        if (array_key_exists('TEC_mean', $this->json_a['metadata'])) {
            $this -> TEC_mean = round($apponame = $this->json_a['metadata']['TEC_mean'],2);
            if ($this -> TEC_mean == -9999) {
                $this -> TEC_mean = null;
            }
        }
        if (array_key_exists('TEC_std', $this->json_a['metadata'])) {
            $this -> TEC_std = round($apponame = $this->json_a['metadata']['TEC_std'],2);
            if ($this -> TEC_std == -9999) {
                $this -> TEC_std = null;
            }
        }
        if (array_key_exists('refresh_rate', $this->json_a['metadata'])) {
            $luppolo = $this->json_a['metadata']['refresh_rate'];
            // se il file è del tipo nc_eu vecchia versione non ha lo spazio separatore
            if ($this->json_a['metadata']['refresh_rate'] == '10min'){
                $this -> refresh_rate   = 10;
                $this -> refresh_rate_u = 'minutes';
            }
            else{
                $this -> refresh_rate   = explode(' ',  $this->json_a['metadata']['refresh_rate'])[0];
                $this -> refresh_rate_u = explode(' ',  $this->json_a['metadata']['refresh_rate'])[1];
            }
        }

        $l = 0;
        for ($j = $this -> max_lat; $j >= $this -> min_lat; $j-= $this -> step_lat) {
            $k =0;
            for ($i = $this -> min_lon; $i <=$this -> max_lon; $i = $i+=$this -> step_lon) {
                if ($this->json_a['data'][$l][$k] != -9999 ){
                    $list[] = ['lat' => round($j,2), 'lon' => round($i, 2), 'tec' => round($this->json_a['data'][$l][$k],2)];
                }
                $k++;
            }
            $l++;
        }
        switch ($this -> refresh_rate_u) {
            case "minutes":
                $date   = date_create($this->dt);
                $mm = $date->format('i');
                $mmod = ($mm % $this -> refresh_rate);
                $deltat = $this -> refresh_rate - ($mm % $this -> refresh_rate);
                if ($mmod !== 0) {
                    $date -> add(new DateInterval("PT{$deltat}M"));
                }
                $this -> dt = $date -> format('Y-m-d H:i:s');
                break;
            case "hours":
                $date   = date_create($this->dt);
                $mm = $date->format('H');
                $mmod = ($mm % $this -> refresh_rate);
                $deltat = $this -> refresh_rate - ($mm % $this -> refresh_rate);
                if ($mmod !== 0) {
                    $date -> add(new DateInterval("PT{$deltat}H"));
                }
                $this -> dt = $date -> format('Y-m-d H:i:s');
                $this -> refresh_rate = $this -> refresh_rate * 60;
                break;
        }
        $this->json = json_encode($list, JSON_NUMERIC_CHECK);
        $out = array(
            "err_code" => 0,
            "err_message" => "File paesed"
        );
        return $out;
    } // end function
    
    function push2db(){
        $sqlf   ="SELECT COUNT(*) numsta FROM information_schema.tables WHERE table_name = :stat";
        //$sqlf   ="SELECT COUNT(*) numsta FROM station WHERE code = :stat";
        try{              
            //$stmtf = $this->myconn->conn->prepare($sqlf, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
            $arraf = array(
                    ':stat'          => $this->station
                    );
            $stmtf = $this->myconn->conn->prepare($sqlf);
            $stmtf->execute($arraf);
            //$stmtf->execute($arraf);
            $outf = $stmtf -> fetchAll();
        }
        catch (PDOException $e)
        {
            //echo $e->getMessage();
            //$ret_val = 1;
            //die();
            $ret_val = array( 
                "err_code" => 20,
                "err_message" => $e->getMessage()
            );
            return $ret_val;
        }
        $nsta  = $outf[0]['numsta'];
        $stmtf->closeCursor();
        $stmtf = null;
        // se la rabella di stazione non esiste va creata
        if ($nsta == 0){
            // tabelle di due tipi: ltf con parametri aggiuntivi
            // e nc con il solo file json
            if ($this->station == $this->ltfName) {
                $sqlf   =" CREATE TABLE ".$this->station." (".
                    " dt            timestamp,".
                    " refresh_rate  float       DEFAULT NULL,".
                    " tec_mean      float       DEFAULT NULL,".
                    " tec_std       float       DEFAULT NULL,".
                    " f_horizon     int         DEFAULT NULL,".
                    " r12_eff       float       DEFAULT NULL,".
                    " rgec_mean     float       DEFAULT NULL,".
                    " rgec_std      float       DEFAULT NULL,".
                    " jfile         jsonb,".
                    " PRIMARY KEY  (dt)".
                    " );";
            }
            else{
                $sqlf   =" CREATE TABLE ".$this->station." (".
                    " dt        timestamp,".
                    " refresh_rate  float       DEFAULT NULL,".
                    " tec_mean      float       DEFAULT NULL,".
                    " tec_std       float       DEFAULT NULL,".
                    " jfile         jsonb,".
                    " PRIMARY KEY  (dt)".
                    " );";
            }
            try{
                $stmt = $this->myconn->conn->prepare($sqlf);
                $stmt->execute(); 
//                $out = $stmt->fetchAll();
            }
            catch (PDOException $e)
            {
                //$stmt->debugDumpParams();
                $ret_val = array(
                    "err_code" => -1,
                    "err_message" => $e->getMessage()
                );
                return $ret_val;
            }
        }
        // la tabella esiste: inserisce
        // se è una LTF deve inserire con un campo in piu
        // se unvece im NC deve fare l'upd<ate della LFT corrispondente, stessa ora giorno precedente
        $toupdate=0;
        if ($this->station == $this->ltfName) {
            $sqlr = "INSERT INTO $this->station(dt, refresh_rate, tec_mean, tec_std, f_horizon, r12_eff, jfile) VALUES(:m_dt, :m_refresh_rate, :m_tec_mean, :m_tec_std, :m_f_horizon, :m_r12_eff, :m_json)";
            $arrar = array(     
                    ':m_dt'             => $this->dt,
                    ':m_refresh_rate'  => $this->refresh_rate,
                    ':m_tec_mean'       => $this->TEC_mean,
                    ':m_tec_std'        => $this->TEC_std,
                    ':m_f_horizon'      => $this->f_horizon,
                    ':m_r12_eff'        => $this->R12_eff,
                    ':m_json'           => $this->json
            );
        }else{
            $sqlr = "INSERT INTO $this->station(dt, refresh_rate, tec_mean, tec_std, jfile) VALUES(:m_dt, :m_refresh_rate, :m_tec_mean, :m_tec_std, :m_json)";
            $arrar = array(     
                    ':m_dt'             => $this->dt,
                    ':m_refresh_rate'  => $this->refresh_rate,
                    ':m_tec_mean'       => $this->TEC_mean,
                    ':m_tec_std'        => $this->TEC_std,
                    ':m_json'           => $this->json
            );
        }
        try{
            $stmtr = $this->myconn->conn->prepare($sqlr);
            $stmtr->execute($arrar);
            $out = $stmtr->fetchAll();
            $ret_val = array(
                "err_code" => 0,
                "err_message" => "OK_LOADED ".$this->station
            );
            $toupdate=1;
        }
        catch (PDOException $e)
        {
            if ($e->errorInfo[0] == '23505'){
                $ret_val = array(
                    "err_code" => 1,
                    "err_message" => "OK_DUPE ".$this->station
                );
            }else{
if (MYDEBUG){print_r($e); $stmtr->debugDumpParams(); }
                $ret_val = array(
                    "err_code" => -1,
                    //"err_message" => $e->errorInfo[2]
                    "err_message" => $e->code
                );                
            }
        }
        // upfate della tabella di LFT da parte di NC_GL
//echo $this->station."_",$toupdate."\n";        
        if ($this->station == $this->nc_ltfName AND $toupdate) { 
            $sqlr = "UPDATE $this->ltfName ".
                    " SET   rgec_mean   = :m_rgec_mean,".
                    "       rgec_std    = :m_rgec_std ".
                    " WHERE dt          = :m_dt;";
            $arrar = array(
                    ':m_dt'             => $this->dt,
                    ':m_rgec_mean'      => $this->RGEC_mean,
                    ':m_rgec_std'       => $this->RGEC_std
            );
                
        try{
                $stmt = $this->myconn->conn->prepare($sqlr);
                $stmt->execute($arrar);
                $out = $stmt->fetchAll();
                $ret_val = array(
                    "err_code" => 0,
                    "err_message" => "OK_LOADED_UPD_LTF ".$this->station
                );
//echo "num_righe_".$stmt->rowCount()."___".$this->RGEC_mean."_".$this->RGEC_std."\n";
//if (MYDEBUG){print_r($e); $stmt->debugDumpParams(); }
            }
            catch (PDOException $e) {
                if ($e->errorInfo[0] == '23505'){
                    $ret_val = array(
                        "err_code" => 1,
                        "err_message" => "OK_LOADED_NO_LTF "
                    );
                }
                elseif ($e->errorInfo[0] == '42P01'){
                    $ret_val = array(
                        "err_code" => 1,
                        "err_message" => "OK_LOADED_NO_LTF "
                    );
               }else{
//$stmt->debugDumpParams();
//print_r($e);die();                    
                    $ret_val = array(
                        "err_code" => -1,
                        "err_message" => $e->errorInfo[2]
                    );                
                }
            }
        } // if NC_GL
        
        return $ret_val;
    } // function

/*    function backupfile($dir){
        $pat='/backup/'.$dir.(($dir == '') ? '' : '/').$this->station.'/'.$this->bkup;
        exec('mkdir -p '.$pat);
        exec('mv '.$this->filename.' '.$pat);
    } */

}
