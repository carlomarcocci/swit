<?php

/** @file
 * Funzioni
 */

function fn_weektow2datetime ($week, $tow){
/*
    la classe datetime di php non supporta i millisecondi
    substr($this -> xmlFile['filename'], 0, strpos($this -> xmlFile['filename'], "_"));
*/ 
    if (strpos($tow, ".") != null) {
        $millisec = substr($tow, strpos($tow, "."), strlen($tow));
        $tow = substr($tow, 0, strpos($tow, "."));
     } else {
        $millisec = ".00";
     }
    $date = date_create(START_GPS_TIME);
    date_add($date, date_interval_create_from_date_string($week.' weeks'));
    date_add($date, date_interval_create_from_date_string($tow.' seconds'));
    return $date -> format('Y-m-d H:i:s').$millisec;
}

function fn_weektow2datetimeNom ($week, $tow){
/*
    restituisce la data senza i millisecondi
    substr($this -> xmlFile['filename'], 0, strpos($this -> xmlFile['filename'], "_"));
*/ 
    return substr(fn_weektow2datetime ($week, $tow), 0, 19);
}

function fn_fileNameToDate ($str, $format){
    $ret='';
    try{
        switch ($format){
            case "NG0":
            /**
            *    restituisce la data a partire dal formato nome file di novatelgps
            *    station_YYMMGGHHNN dove
            *    ex DMC0S_1903152345.EST
            */
                $ret= "20".substr($str, 0, 2)."-".substr($str, 2, 2)."-".substr($str, 4, 2).' '.substr($str, 6, 2).":".substr($str, 8, 2).':00';
            break;
            case "TE0":
            /**
            *    restituisce la data a partire dal formato nome file json di tec
            *    station_YYYYMMGGTHHNNSS dove
            *    ex INGV_TEC_NC_MED_10min.EGGNSS.20200120T235000.json 
            */
                $ret= substr($str, 0, 4)."-".substr($str, 4, 2)."-".substr($str, 6, 2).' '.substr($str, 9, 2).":".substr($str, 11, 2).":".substr($str, 13, 2);
            break;
            case "NM0":
                /**
                *    restituisce la data a partire dal formato nome file di novatelmulti
                *    station_YYYY_D_HH_MM dove
                *       YYYY anno
                *       D giorno della settimana
                *       HH ore
                *       MM minuti
                *       -- non ci sono i secondi
                *    ex KIL0_2071_3_12_45.RWD
                */
//echo "wn: ".substr($str,0,4). " day: ".substr($str,5,1). "hour: ".str_replace('_', ':', substr($str,7,5))."\n";
                $date = date_create(START_GPS_TIME);
                date_add($date, date_interval_create_from_date_string(substr($str,0,4). ' weeks'));
                date_add($date, date_interval_create_from_date_string(substr($str,5,1). ' days'));
                $ret= $date -> format('Y-m-d').' '.str_replace('_', ':', substr($str,7,5));
            break;
            case "AI0": // da scrivere codice errrato !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                /**
                *    restituisce la data a partire dal formato nome file di septentrio
                *    station_YYJJJAMM.txt dove
                *       YY anno
                *       JJJ giorno giuliano
                *       A ore, una singola lettera a partire da "a"="00"
                *       MM minuti
                *       -- non ci sono i secondi
                *    ex DMC0P_354j00.17_.ismr
                */
                $jjday  = substr($str,2,3);
                $ores   = strtolower(substr($str,5,1));
                $min    = substr($str,6,2);
                $yr     = substr($str,0,2);
                if (is_numeric($jjday) AND is_numeric($min)){
                    $jjday  = $jjday - 1;
                    $ore    = ord($ores) - ord('a');
                    $date   = date_create("20".$yr."-01-01");
                    date_add($date, date_interval_create_from_date_string($jjday. ' day'));
                    $date -> add(new DateInterval("PT{$ore}H"));
                    $date -> add(new DateInterval("PT{$min}M"));                
                    $ret= $date -> format('Y-m-d H:i:s');
                } else{
                    $ret= '';
                }
            break;
            case "AI1":
            /**
            *    restituisce la data a partire dal formato nome file sao
            *    station_YYYYJJJHHNNSS dove
                *       YYYY anno
                *       JJJ giorno giuliano
                *       HH ore
                *       MM minuti
                *       SS secondi
                *       -- non ci sono i secondi
            *    ex RM041_2019254074500_sao.xml
            */
  //               $ret= "20".substr($str, 0, 2)."-".substr($str, 2, 2)."-".substr($str, 4, 2).' '.substr($str, 6, 2).":".substr($str, 8, 2).':00';
                $year   = substr($str,0,4);
                $jjday  = substr($str,4,3);
                $ore    = strtolower(substr($str,7,2));
                $min    = substr($str,9,2);
                $sec    = substr($str,11,2);
                if ($sec == ''){
                    $sec='00';
                }
                if (is_numeric($jjday) AND is_numeric($year) AND is_numeric($ore) AND is_numeric($min) AND is_numeric($sec)){
                    $jjday  = $jjday - 1;
                    $date   = date_create($year."-01-01");
                    date_add($date, date_interval_create_from_date_string($jjday. ' day'));
                    $date -> add(new DateInterval("PT{$ore}H"));
                    $date -> add(new DateInterval("PT{$min}M"));
                    $date -> add(new DateInterval("PT{$sec}S"));
                    $ret= $date -> format('Y-m-d H:i:s');
                } else{
//echo "YY; ".$year." jjday:".$jjday." ore:".$ore." min:".$min."\n";                    
                    $ret= '';
                }
            break;
            case "AI2":
            /**
            *    restituisce la data a partire dal formato nome file di novatelgps
            *    station_YYYYMMGGHHNN dove
            *    ex DMC0S_1903152345.EST
            */
                $ret= substr($str, 0, 4)."-".substr($str, 4, 2)."-".substr($str, 6, 2).' '.substr($str, 8, 2).":".substr($str, 10, 2).':00';
            break;
            case "DP0":
                /*
                *    restituisce la data a partire dal formato nome file di dps vecchio formato
                *    station_YJJJAMMS.sao, dove
                *       Y anno  primi sondaggi sono del 1997 fino al 2005, nessuna ambiguita 
                *       JJJ giorno giuliano
                *       A ore, una singola lettera a partire da "a"="00"
                *       MM minuti
                *       S una lettera indicante i secondi dell'inizio del sondaggio A= 0-4 secondi e cosi via
                *         nella lettura i secondi vengono tralasciati e  messi sempre a 00
                *    ex ROOLD_9222X25A.SAO
                */
                $jjday  = substr($str,1,3);
                $ores   = strtolower(substr($str,4,1));
                $min    = substr($str,5,2);
                $yr     = substr($str,0,1);
                if (is_numeric($jjday) AND is_numeric($min)){
                    $jjday  = $jjday - 1;
                    $ore    = ord($ores) - ord('a');
                    if ($yr == '7' OR $yr == '8' OR $yr == '9'){
                        $date   = date_create("199".$yr."-01-01");
                    }
                    else{
                        $date   = date_create("200".$yr."-01-01");
                    }
                    date_add($date, date_interval_create_from_date_string($jjday. ' day'));
                    $date -> add(new DateInterval("PT{$ore}H"));
                    $date -> add(new DateInterval("PT{$min}M"));                
                    $ret= $date -> format('Y-m-d H:i:s');
                } else{
                    $ret= '';
                }
            break;
           case "SE0":
                /**
                *    restituisce la data a partire dal formato nome file di septentrio
                *    station_JJJAMM.YY_ dove
                *       YY anno
                *       JJJ giorno giuliano
                *       A ore, una singola lettera a partire da "a"="00"
                *       MM minuti
                *       -- non ci sono i secondi
                *    ex DMC0P_354j00.17_.ismr
                */
                $jjday  = substr($str,0,3);
//                $ores   = substr($str,3,1);
                $ores   = strtolower(substr($str,3,1));
                $min    = substr($str,4,2);
                if (is_numeric($jjday) AND is_numeric($min)){
                    $jjday  = $jjday - 1;
                    $ore    = ord($ores) - ord('a');
                    $date   = date_create("20".substr($str,7,2)."-01-01");
                    date_add($date, date_interval_create_from_date_string($jjday. ' day'));
                    $date -> add(new DateInterval("PT{$ore}H"));
                    $date -> add(new DateInterval("PT{$min}M"));                
                    $ret= $date -> format('Y-m-d H:i:s');
                } else{
//echo "notnum jjday:".$jjday." ores:".$ores." min:".$min."\n";                    
                    $ret= '';
                }
            break;
            default:
                $ret= '';
            break;
	} // switch
	return $ret;
    }
    catch (Exception $e) {
        return '';
    }
}

function fn_date2fileName ($str, $format){
//echo "\n__".$str."__\n";
    $ret='';
    if (fn_isDateTime($str)) {
        switch ($format){
            case "AI0":
                /**
                *    restituisce la data a partire dal formato nome file di septentrio
                *    station_YYJJJAMM.txt dove
                *       YY anno
                *       JJJ giorno giuliano
                *       A ore, una singola lettera a partire da "a"="00"
                *       MM minuti
                *       -- non ci sono i secondi
                *    ex DMC0P_354j00.17_.ismr
                */
                $dt     = strtotime($str);
                $yr     = date("Y", $dt);
                $month  = date("m", $dt);
                $day    = date("d", $dt);
                $hour   = date("H", $dt);
                $min    = date("i", $dt);
                $sec    = date("s", $dt);
                $jjday  = unixtojd($dt) - unixtojd(strtotime($yr."-01-01 00:00")) +1;
                $hlett  = chr(ord('A') + $hour);
                
                $ret    =   substr($yr, -2) .
                            str_repeat("0", 3-strlen($jjday)).$jjday.
                            $hlett.
                            str_repeat("0", 2-strlen($min)).$min;
            break;
            case "AI1":
            /**
            *    restituisce la data a partire dal formato nome file sao
            *    station_YYYYJJJHHNNSS dove
                *       YYYY anno
                *       JJJ giorno giuliano
                *       HH ore
                *       MM minuti
                *       SS secondi
                *       -- non ci sono i secondi
            *    ex RM041_2019254074500_sao.xml
            */
                $dt     = strtotime($str);
                $yr     = date("Y", $dt);
                $month  = date("m", $dt);
                $day    = date("d", $dt);
                $hour   = date("H", $dt);
                $min    = date("i", $dt);
                $sec    = date("s", $dt);
                $jjday  = unixtojd($dt) - unixtojd(strtotime($yr."-01-01 00:00")) +1;
                $hlett  = chr(ord('A') + $hour);
                
                $ret    =   $yr.
                            str_repeat("0", 3-strlen($jjday)).$jjday.
                            $hlett.str_repeat("0", 2-strlen($hour)).$hour.
                            $hlett.str_repeat("0", 2-strlen($min)).$min.
                            $hlett.str_repeat("0", 2-strlen($sec)).$sec;
           
            break;
            case "AI2":
            /**
            *    restituisce la data a partire dal formato nome file di novatelgps
            *    station_YYYYMMGGHHNN dove
            *    ex DMC0S_1903152345.EST
            */
                $dt     = strtotime($str);
                $yr     = date("Y", $dt);
                $month  = date("m", $dt);
                $day    = date("d", $dt);
                $hour   = date("H", $dt);
                $min    = date("i", $dt);
                $sec    = date("s", $dt);
                $jjday  = unixtojd($dt) - unixtojd(strtotime($yr."-01-01 00:00")) +1;
                $hlett  = chr(ord('A') + $hour);
                
                $ret    =   $yr.
                            str_repeat("0", 2-strlen($month)) . $month.
                            str_repeat("0", 2-strlen($day)) . $day.
                            str_repeat("0", 2-strlen($hour)) . $hour.
                            str_repeat("0", 2-strlen($min)) . $min.
                            str_repeat("0", 2-strlen($sec)).$sec;
            break;
            case "DP0":
                /*
                *    restituisce la data a partire dal formato nome file di dps vecchio formato
                *    station_YJJJAMMS.sao, dove
                *       Y anno  primi sondaggi sono del 1997 fino al 2005, nessuna ambiguita 
                *       JJJ giorno giuliano
                *       A ore, una singola lettera a partire da "a"="00"
                *       MM minuti
                *       S una lettera indicante i secondi dell'inizio del sondaggio A= 0-4 secondi e cosi via
                *         nella lettura i secondi vengono tralasciati e  messi sempre a 00
                *    ex ROOLD_9222X25A.SAO
                */
                $dt     = strtotime($str);
                $yr     = date("Y", $dt);
                $month  = date("m", $dt);
                $day    = date("d", $dt);
                $hour   = date("H", $dt);
                $min    = date("i", $dt);
                $jjday  = unixtojd($dt) - unixtojd(strtotime($yr."-01-01 00:00")) +1;
                $hlett  = chr(ord('A') + $hour);
                
                $ret    =   substr($yr, -1).
                            str_repeat("0", 3-strlen($jjday)).$jjday.
                            $hlett.str_repeat("0", 2-strlen($min)).$min.
                            "A";
            break;
            default:
                $ret= '';
            break;
	    } // switch
	    return $ret;
    } // if is datetime
    else {
        return '';
    }
}


function fn_bkup_path($dt){
    /** Dato un datetime restituisce il path di backup dei files o "" se dt 
    *   non è una data
    */
    $date = date_create($dt);
    return date_format($date,"Y/m/d/");
}

function fn_isDateTime($date, $format = 'Y-m-d H:i:s')
{
	$d = DateTime::createFromFormat($format, $date);
    return $d && $d->format($format) == $date;
}

function fn_yesterday($dt){
    $date = date_create($dt);
    $date -> sub(new DateInterval("P1D"));
    return $date -> format('Y-m-d H:i:s');

}

function fn_test_json($json) {
    // Define the errors.
    $constants = get_defined_constants(true);
    $json_errors = array();
    foreach ($constants["json"] as $name => $value) {
        if (!strncmp($name, "JSON_ERROR_", 11)) {
            $json_errors[$value] = $name;
        }
    }

    // Show the errors for different depths.
    foreach (range(4, 3, -1) as $depth) {
        var_dump(json_decode($json, true, $depth));
        echo 'Last error: ', $json_errors[json_last_error()], PHP_EOL, PHP_EOL;
    }    
}

function fn_array_value_by_range($arra, $from, $to){
    $appo='';
    for ($i=$from; $i<$to; $i++){
        $appo = $appo . $arra[$i];
    }
    return $appo;
    
}

function fn_debug_query(&$stat, &$ar, &$ou){
    $stat->debugDumpParams();
    echo "-- ----------------------------------\n";
    echo "  IMPUT QUERY\n";
    print_r($ar);
    echo "-- ----------------------------------\n";
    echo "  OUTPUT QUERY\n";
    print_r($ou);
}

function fn_debug_query_e(&$query, &$ar, &$ou, &$e){
    echo "\n\n----------------------------------\n";
    echo "\n\n query\n\n";
    echo $query;
    echo "\n\n ReturnFromDB\n";
    print_r($ou);
    echo "\n\n exception\n\n";
    print_r($e);
//    echo "\n\n debugDumpParams\n";
//    $stat->debugDumpParams();
}

function createAisAutoTable($sta, $isPG){
            $sql = "CREATE TABLE ".$sta."_auto"." (".
                "dt              timestamp NOT  NULL,".
                "station         varchar(255)   NULL DEFAULT NULL,".
                "fromfile        text           NULL DEFAULT NULL,".
                "producer        varchar(255)   NULL DEFAULT NULL,".
                "evaluated       boolean        NULL DEFAULT NULL ,".
                "fof2            decimal(3,1)   NULL DEFAULT NULL,".
                "fof2_eval       boolean        NULL DEFAULT NULL,".
                "muf3000f2       decimal(3,1)   NULL DEFAULT NULL,".
                "muf3000f2_eval  boolean        NULL DEFAULT NULL,".
                "m3000f2         decimal(3,2)   NULL DEFAULT NULL,".
                "m3000f2_eval    boolean        NULL DEFAULT NULL,".
                "fxi             decimal(3,1)   NULL DEFAULT NULL,".
                "fxi_eval        boolean        NULL DEFAULT NULL,".
                "fof1            decimal(3,1)   NULL DEFAULT NULL,".
                "fof1_eval       boolean        NULL DEFAULT NULL,".
                "ftes            decimal(3,1)   NULL DEFAULT NULL,".
                "ftes_eval       boolean        NULL DEFAULT NULL,".
                "h_es            int            NULL DEFAULT NULL,".
                "h_es_eval       boolean        NULL DEFAULT NULL,".
                "aip_hmf2        int            NULL DEFAULT NULL,".
                "aip_fof2        decimal(3,1)   NULL DEFAULT NULL,".
                "aip_fof1        decimal(3,1)   NULL DEFAULT NULL,".
                "aip_hmf1        int            NULL DEFAULT NULL,".
                "aip_d1          decimal(3,1)   NULL DEFAULT NULL,".
                "aip_foe         decimal(2,1)   NULL DEFAULT NULL,".
                "aip_hme         int            NULL DEFAULT NULL,".
                "aip_yme         int            NULL DEFAULT NULL,".
                "aip_h_ve        int            NULL DEFAULT NULL,".
                "aip_ewidth      int            NULL DEFAULT NULL,".
                "aip_deln_ve     decimal(3,1)   NULL DEFAULT NULL,".
                "aip_b0          decimal(4,1)   NULL DEFAULT NULL,".
                "aip_b1          decimal(3,1)   NULL DEFAULT NULL,".
                "tec_bottom      decimal(6,3)   NULL DEFAULT NULL,".
                "tec_top         decimal(6,3)   NULL DEFAULT NULL,".
                "profile        json".(($isPG == 1) ? "b" : "")." NULL      NULL DEFAULT NULL,".
                "trace          json".(($isPG == 1) ? "b" : "")." NULL      NULL DEFAULT NULL,".
                "modified       timestamp       NOT NULL,".
                "PRIMARY KEY  (dt)".
                ");";
    return $sql;
}

function createAisAutoView($sta, $isPG){
        $sql ="  CREATE OR REPLACE VIEW  ws".$sta."_auto AS ".
        " SELECT ".
            " d.*, ".
            " fn_median('" .$sta . "_auto'::regclass, 'd.fof2'::text, (0)::double precision, (100)::double precision, d.dt, 14, 27) AS fof2_med_27_days ".
        " FROM ".$sta."_auto AS d ".
        ";";
    return $sql;
} 

function createDps4dRawTable($sta, $isPG){
            $sql = "CREATE TABLE ".$sta."_raw"." (".
                "dt             timestamp       NOT  NULL,".
                "fromfile       text            NULL DEFAULT NULL,".
                "producer       varchar(255)    NULL DEFAULT NULL,".
                "rxid           int             NULL DEFAULT NULL,".
                "txid           int             NULL DEFAULT NULL,".
                "start_f        float           NULL DEFAULT NULL,".
                "coarse_step_f  float           NULL DEFAULT NULL,".
                "stop_f         float           NULL DEFAULT NULL,".
                "o_x_option     float           NULL DEFAULT NULL,".
                "pulsereprate   float           NULL DEFAULT NULL,".
                "range_start    float           NULL DEFAULT NULL,".
                "range_increment    float       NULL DEFAULT NULL,".
                "number_heights     int         NULL DEFAULT NULL,".
                "number_range_bins  int         NULL DEFAULT NULL,".
                "base_gain          float       NULL DEFAULT NULL,".
                "const_gain         float       NULL DEFAULT NULL,".
                "frequency_group_len float      NULL DEFAULT NULL,".
                "freq_group_number_per_block float  NULL DEFAULT NULL,".
                "ionogram           jsonb       NULL DEFAULT NULL,".
                "inserted           timestamp   DEFAULT current_timestamp,".
                "modified           timestamp   DEFAULT current_timestamp,".
                "PRIMARY KEY  (dt)".
                ");";
    return $sql;
}


function createAisRevTable($sta, $isPG){
            $sql =" CREATE TABLE ".$sta."_rev (".
                " dt                timestamp,".
                " fof2              float           NULL DEFAULT NULL,".
                " fof2_qual         char(1)         NULL DEFAULT NULL,".
                " fof2_desc         char(1)         NULL DEFAULT NULL,".
                " muf3000f2         float           NULL DEFAULT NULL,".
                " muf3000f2_qual    char(1)         NULL DEFAULT NULL,".
                " muf3000f2_desc    char(1)         NULL DEFAULT NULL,".
                " m3000f2           float           NULL DEFAULT NULL,".
                " m3000f2_qual      char(1)         NULL DEFAULT NULL,".
                " m3000f2_desc      char(1)         NULL DEFAULT NULL,".
                " fof1              float           NULL DEFAULT NULL,".
                " fof1_qual         char(1)         NULL DEFAULT NULL,".
                " fof1_desc         char(1)         NULL DEFAULT NULL,".
                " muf3000f1         float           NULL DEFAULT NULL,".
                " muf3000f1_qual    char(1)         NULL DEFAULT NULL,".
                " muf3000f1_desc    char(1)         NULL DEFAULT NULL,".
                " h_f2              float           NULL DEFAULT NULL,".
                " h_f2_qual         char(1)         NULL DEFAULT NULL,".
                " h_f2_desc         char(1)         NULL DEFAULT NULL,".
                " h_f               float           NULL DEFAULT NULL,".
                " h_f_qual          char(1)         NULL DEFAULT NULL,".
                " h_f_desc          char(1)         NULL DEFAULT NULL,".
                " h_e               float           NULL DEFAULT NULL,".
                " h_e_qual          char(1)         NULL DEFAULT NULL,".
                " h_e_desc          char(1)         NULL DEFAULT NULL,".
                " foe               float           NULL DEFAULT NULL,".
                " foe_qual          char(1)         NULL DEFAULT NULL,".
                " foe_desc          char(1)         NULL DEFAULT NULL,".
                " h_es              float           NULL DEFAULT NULL,".
                " h_es_qual         char(1)         NULL DEFAULT NULL,".
                " h_es_desc         char(1)         NULL DEFAULT NULL,".
                " foes              float           NULL DEFAULT NULL,".
                " foes_qual         char(1)         NULL DEFAULT NULL,".
                " foes_desc         char(1)         NULL DEFAULT NULL,".
                " fbes              float           NULL DEFAULT NULL,".
                " fbes_qual         char(1)         NULL DEFAULT NULL,".
                " fbes_desc         char(1)         NULL DEFAULT NULL,".
                " fmin              float           NULL DEFAULT NULL,".
                " fmin_qual         char(1)         NULL DEFAULT NULL,".
                " fmin_desc         char(1)         NULL DEFAULT NULL,".
                " fxi               float           NULL DEFAULT NULL,".
                " fxi_qual          char(1)         NULL DEFAULT NULL,".
                " fxi_desc          char(1)         NULL DEFAULT NULL,".
                " type_es           varchar(5)      NULL DEFAULT NULL,".
                " modified          timestamp       NOT NULL ,".
                " PRIMARY KEY  (dt)".
                " );";

    return $sql;
}

function createAisDpsTable($sta, $isPG){
            $sql =" CREATE TABLE ".$sta."_auto (".
                " dt            timestamp,".
                " producer      varchar(255)    DEFAULT NULL,".
                "fromfile        text           NULL DEFAULT NULL,".
                " fof2          float           DEFAULT NULL,".
                " muf3000f2     float           DEFAULT NULL,".
                " m3000f2       float           DEFAULT NULL,".
                " fxi           float           DEFAULT NULL,".
                " fof1          float           DEFAULT NULL,".
                " h_es          float           DEFAULT NULL,".
                " foes          float           DEFAULT NULL,".
                " foe           float           DEFAULT NULL,".
                " hf            float           DEFAULT NULL,".
                " hf2           float           DEFAULT NULL,".
                " he            float           DEFAULT NULL,".
                " tec           float           DEFAULT NULL,".
                " trace         json".(($isPG == 1) ? "b" : "")." NULL      NULL DEFAULT NULL,".
                " trace_f2      json".(($isPG == 1) ? "b" : "")." NULL      NULL DEFAULT NULL,".
                " trace_f1      json".(($isPG == 1) ? "b" : "")." NULL      NULL DEFAULT NULL,".
                " trace_e       json".(($isPG == 1) ? "b" : "")." NULL      NULL DEFAULT NULL,".
                " trace_es      json".(($isPG == 1) ? "b" : "")." NULL      NULL DEFAULT NULL,".
                " profile       json".(($isPG == 1) ? "b" : "")." NULL      NULL DEFAULT NULL,".
                " modified      timestamp       NOT NULL ,".
                " PRIMARY KEY  (dt)".
                " );";

    return $sql;
}

function createAisDpsView_TOREMOVE($sta, $isPG){
        $sql ="  CREATE OR REPLACE VIEW  ws".$sta." AS ".
        " SELECT ".
            " d.dt, ".
            " d.station, ".
            " d.fromfile, ".
            " d.producer, ".
            " d.evaluated, ".
            " d.fof2, ".
            " d.fof2_eval, ".
            " d.muf3000f2, ".
            " d.muf3000f2_eval, ".
            " d.m3000f2, ".
            " d.m3000f2_eval, ".
            " d.fxi, ".
            " d.fxi_eval, ".
            " d.fof1, ".
            " d.fof1_eval, ".
            " d.ftes, ".
            " d.ftes_eval, ".
            " d.h_es, ".
            " d.h_es_eval, ".
            " d.aip_hmf2, ".
            " d.aip_fof2, ".
            " d.aip_fof1, ".
            " d.aip_hmf1, ".
            " d.aip_d1, ".
            " d.aip_foe, ".
            " d.aip_hme, ".
            " d.aip_yme, ".
            " d.aip_h_ve, ".
            " d.aip_ewidth, ".
            " d.aip_deln_ve, ".
            " d.aip_b0, ".
            " d.aip_b1, ".
            " d.tec_bottom, ".
            " d.tec_top, ".
            " d.profile, ".
            " d.trace, ".
            " d.modified, ".
            " fn_median('" .$sta . "'::regclass, 'd.fof2'::text, (0)::double precision, (100)::double precision, d.dt, 14, 27) AS fof2_med_27_days ".
        " FROM ".$sta." AS d ".
        ";";
    return $sql;
}


function createHf_ncfcTableRIMOSSA($sta, $isPG){
            $sql =" CREATE TABLE ".$sta."_auto (".
                " dt                    timestamp,".
                "fromfile        text           NULL DEFAULT NULL,".
                " alert_moderate        json".(($isPG == 1) ? "b" : "")." NULL      NULL DEFAULT NULL,".
                " aproduct_descriptionlert_strong          json".(($isPG == 1) ? "b" : "")." NULL      NULL DEFAULT NULL,".
                " contact               varchar(1024)  DEFAULT NULL,".
                " producer              varchar(1024)  DEFAULT NULL,".
                " product               varchar(1024)  DEFAULT NULL,".
                " product_description   varchar(1024)  DEFAULT NULL,".
                " coordinate_system     varchar(1024)  DEFAULT NULL,".
                " delta_lat             float           DEFAULT NULL,".
                " delta_long            float           DEFAULT NULL,".
                " max_lat               float           DEFAULT NULL,".
                " max_long              float           DEFAULT NULL,".
                " min_lat               float           DEFAULT NULL,".
                " min_long              float           DEFAULT NULL,".
                " unit                  varchar(1024)  DEFAULT NULL,".
                " time_reference_system varchar(1024)  DEFAULT NULL,".
                " units                 varchar(1024)  DEFAULT NULL,".
                " jfile                 json".(($isPG == 1) ? "b" : "")." NULL      NULL DEFAULT NULL,".
                " modified              timestamp       NOT NULL ,".
                " PRIMARY KEY  (dt)".
                " );";
    return $sql;
}

function createHf_ncfcTable($sta, $isPG){
            $sql =" CREATE TABLE ".$sta." (".
                " dt                    timestamp,".
                " dt_valid              timestamp,".
                "fromfile               text           NULL DEFAULT NULL,".
                " jfile                 json".(($isPG == 1) ? "b" : "")." NULL      NULL DEFAULT NULL,".
                " modified              timestamp       NOT NULL ,".
                " PRIMARY KEY  (dt, dt_valid)".
                " );";
    return $sql;
}

function createGpsTable($sta, $isPG){
            $sql =" CREATE TABLE ".$sta." (".
            'dt             timestamp NOT NULL,'.
            'svid           integer         NOT NULL,'.
            'rxstate        char(8)         DEFAULT NULL,'.
            'azimuth        float           DEFAULT NULL,'.
            'elevation      float           DEFAULT NULL,'.
            'averagel1      float           DEFAULT NULL,'.
            'totals4l1      float           DEFAULT NULL,'.
            'corrections4l1 floar           DEFAULT NULL,'.
            'phi01l1        float           DEFAULT NULL,'.
            'phi03l1        float           DEFAULT NULL,'.
            'phi10l1        float           DEFAULT NULL,'.
            'phi30l1        float           DEFAULT NULL,'.
            'phi60l1slant   float           DEFAULT NULL,'.
            'avgccdl1       float           DEFAULT NULL,'.
            'sigmaccdl1     float           DEFAULT NULL,'. 
            'tec45          float           DEFAULT NULL,'.
            'dtec60_45      float           DEFAULT NULL,'.
            'tec30          float           DEFAULT NULL,'.
            'dtec45_30      float           DEFAULT NULL,'.
            ' tec15          float           DEFAULT NULL,'.
            'dtec30_15      float           DEFAULT NULL,'.
            'tec0           float           DEFAULT NULL,'.
            'dtec0          float           DEFAULT NULL,'.
            'locktimel1     float           DEFAULT NULL,'.
            'chanstatus     char(8)         DEFAULT NULL,'.
            'secondlocktime    float           DEFAULT NULL,'.
            'avgcn2freqtec  float           DEFAULT NULL,'.
            'fk_file        integer         DEFAULT NULL,'.
            'modified timestamp             NOT NULL,'.
            'PRIMARY KEY (dt, svid),'.
            'CONSTRAINT foreign_file,'.
            '   FOREIGN KEY (fk_file),'.
            '   REFERENCES file (id)'.
    ')';
    //            " jfile                 json".(($isPG == 1) ? "b" : "")." NULL      NULL DEFAULT NULL,".
    return $sql;
}

function createSepentrioTable($sta, $isPG){
    $sql =" CREATE TABLE ".$sta." (".
            "dt                 timestamp       NOT NULL,".
            "svid               integer         NOT NULL,".
            "rxstate            char(8)         DEFAULT NULL,".
            "azimuth            float           DEFAULT NULL,".
            "elevation          float           DEFAULT NULL,".
            "averagel1          float           DEFAULT NULL,".
            "totals4l1          float           DEFAULT NULL,".
            "corrections4l1     float           DEFAULT NULL,".
            "phi01l1            float           DEFAULT NULL,".
            "phi03l1            float           DEFAULT NULL,".
            "phi10l1            float           DEFAULT NULL,".
            "phi30l1            float           DEFAULT NULL,".
            "phi60l1slant       float           DEFAULT NULL,".
            "avgccdl1           float           DEFAULT NULL,".
            "sigmaccdl1         float           DEFAULT NULL,".
            "tec45              float           DEFAULT NULL,".
            "dtec60_45          float           DEFAULT NULL,".
            "tec30              float           DEFAULT NULL,".
            "dtec45_30          float           DEFAULT NULL,".
            "tec15              float           DEFAULT NULL,".
            "dtec30_15          float           DEFAULT NULL,".
            "tec0               float           DEFAULT NULL,".
            "dtec0              float           DEFAULT NULL,".
            "locktimel1         integer         DEFAULT NULL,".
            "reserved           varchar(50)     DEFAULT NULL,".
            "secondlocktime        float           DEFAULT NULL,".
            "avgcn2freqtec      float           DEFAULT NULL,".
            "si_l1_29           float           DEFAULT NULL,".
            "si_l1_30           float           DEFAULT NULL,".
            "pl1                float           DEFAULT NULL,".
            "avg_c_n0_l2c       float           DEFAULT NULL,".
            "totals4_l2c        float           DEFAULT NULL,".
            "correctionS4_l2c   float           DEFAULT NULL,".
            "phi01_l2c          float           DEFAULT NULL,".
            "phi03_l2c          float           DEFAULT NULL,".
            "phi10_l2c          float           DEFAULT NULL,".
            "phi30_l2c          float           DEFAULT NULL,".
            "phi60_l2c          float           DEFAULT NULL,".
            "avgccd_l2c         float           DEFAULT NULL,".
            "sigmaccd_l2c       float           DEFAULT NULL,".
            "locktime_l2c       float           DEFAULT NULL,".
            "si_l2c_43          float           DEFAULT NULL,".
            "si_l2c_44          float           DEFAULT NULL,".
            "p_l2c              float           DEFAULT NULL,".
            "avg_c_n0_l5        float           DEFAULT NULL,".
            "totals4_l5         float           DEFAULT NULL,".
            "corrections4_l5    float           DEFAULT NULL,".
            "phi01_l5           float           DEFAULT NULL,".
            "phi03_l5           float           DEFAULT NULL,".
            "phi10_l5           float           DEFAULT NULL,".
            "phi30_l5           float           DEFAULT NULL,".
            "phi60_l5           float           DEFAULT NULL,".
            "avgccd_l5          float           DEFAULT NULL,".
            "sigmaccd_l5        float           DEFAULT NULL,".
            "locktime_l5        float           DEFAULT NULL,".
            "si_l5_57           float           DEFAULT NULL,".
            "si_l5_58           float           DEFAULT NULL,".
            "p_l5               float           DEFAULT NULL,".
            "t_l1               float           DEFAULT NULL,".
            "t_l2c              float           DEFAULT NULL,".
            "t_l5               float           DEFAULT NULL,".
            "modified           timestamp       NOT NULL," .
            "PRIMARY KEY  (dt, svid)".
        "); ";
    return $sql;
}

function createSepentrioView($sta, $isPG){
        $sql ="  CREATE OR REPLACE VIEW  ws".$sta." AS ".
        " SELECT ".
        " d.*, ".
        " fn_ismr_latlon(1, s.lat, s.lon, azimuth, elevation)             AS ipp_lat, ".
        " fn_ismr_latlon( 0, s.lat, s.lon, azimuth, elevation)             AS ipp_lon, ".
        " fn_s4_l1_vert(totalS4L1, correctionS4L1, pl1, elevation)        AS s4_l1_vert, ".
        " fn_phi60_l1_vert(phi60l1slant, elevation)                       AS phi60_l1_vert, ".
        " fn_stec(tec0, tec15, tec30, tec45)                              AS stec, ".
        " fn_vtec(tec0, tec15, tec30, tec45, elevation)                   AS vtec, ".
        " fn_s4_l1_slant(totalS4L1, correctionS4L1)                       AS s4_l1_slant, ".
        " fn_s4_l2_vert(totalS4_L2C, correctionS4_L2C, p_l2c, elevation)  AS s4_l2_vert, ".
        " fn_phi60_l2_vert(phi60_l2c, elevation)                          AS phi60_l2_vert, ".
        " fn_s4_l2_slant(totalS4_L2C, correctionS4_L2C)                   AS s4_l2_slant, ".
        " fn_phi60_l5_vert(phi60_l5, elevation)                           AS phi60_l5_vert, ".
        " fn_s4_l5_slant(totalS4_L5, correctionS4_L5)                     AS s4_l5_slant, ".
        " c.nmp_code::text ||
          CASE
              WHEN length(t.prn::character(2)) = 1 THEN '0'::text || t.prn
              ELSE ''::text || t.prn
          END AS prn ".
        " FROM ".$sta." d ".
        "     JOIN  station s         ON s.code = '".$sta."' ".
        "     JOIN satellite t        ON t.svid = d.svid ".
        "     JOIN constellation c    ON c.id = t.fk_constellation ".
        ";";
    return $sql;
}

function creteNovatelMultiTable($sta, $isPG){
            $sql =" CREATE TABLE ".$sta." (".
            "dt                 timestamp       NOT NULL,".
            "svid               integer        NOT NULL,".
            "azimuth            float           DEFAULT NULL,".
            "elevation          float           DEFAULT NULL,".
            "averagel1          float           DEFAULT NULL,".
            "totals4l1          float           DEFAULT NULL,".
            "corrections4l1     float           DEFAULT NULL,".
            "phi01l1            float           DEFAULT NULL,".
            "phi03l1            float           DEFAULT NULL,".
            "phi10l1            float           DEFAULT NULL,".
            "phi30l1            float           DEFAULT NULL,".
            "phi60l1slant       float           DEFAULT NULL,".
            "avgccdl1           float           DEFAULT NULL,".
            "sigmaccdl1         float           DEFAULT NULL,".
            "tec45              float           DEFAULT NULL,".
            "dtec60_45          float           DEFAULT NULL,".
            "tec30              float           DEFAULT NULL,".
            "dtec45_30          float           DEFAULT NULL,".
            "tec15              float           DEFAULT NULL,".
            "dtec30_15          float           DEFAULT NULL,".
            "tec0               float           DEFAULT NULL,".
            "dtec0              float           DEFAULT NULL,".
            "locktimel1         float           DEFAULT NULL,".
            "avg_c_n0_l2c       float           DEFAULT NULL,".
            "totals4_l2c        float           DEFAULT NULL,".
            "correctionS4_L2C   float           DEFAULT NULL,".
            "phi01_l2c          float           DEFAULT NULL,".
            "phi03_l2c          float           DEFAULT NULL,".
            "phi10_l2c          float           DEFAULT NULL,".
            "phi30_l2c          float           DEFAULT NULL,".
            "phi60_l2c          float           DEFAULT NULL,".
            "avgccd_l2c         float           DEFAULT NULL,".
            "sigmaccd_l2c       float           DEFAULT NULL,".
            "locktime_l2c       float           DEFAULT NULL,".
            "avg_c_n0_l5        float           DEFAULT NULL,".
            "totals4_l5         float           DEFAULT NULL,".
            "corrections4_l5    float           DEFAULT NULL,".
            "phi01_l5           float           DEFAULT NULL,".
            "phi03_l5           float           DEFAULT NULL,".
            "phi10_l5           float           DEFAULT NULL,".
            "phi30_l5           float           DEFAULT NULL,".
            "phi60_l5           float           DEFAULT NULL,".
            "avgccd_l5          float           DEFAULT NULL,".
            "sigmaccd_l5        float           DEFAULT NULL,".
            "locktime_l5        float           DEFAULT NULL,".
            "tec45_2c           float           DEFAULT NULL,".
            "dtec60_45_2c       float           DEFAULT NULL,".
            "tec30_2c           float           DEFAULT NULL,".
            "dtec45_30_2c       float           DEFAULT NULL,".
            "tec15_2c           float           DEFAULT NULL,".
            "dtec30_15_2c       float           DEFAULT NULL,".
            "tec0_2c            float           DEFAULT NULL,".
            "dtec0_2c           float           DEFAULT NULL,".
            "modified           timestamp       NOT NULL," .
            "PRIMARY KEY  (dt, svid)".
    ")";
    return $sql;
}

function createNovatelMultiView($sta, $isPG){
        $sql ="  CREATE OR REPLACE VIEW  ws".$sta." AS ".
        " SELECT ".
        " d.*, ".
        " fn_ismr_latlon( 1, s.lat, s.lon, azimuth, elevation)             AS ipp_lat,".
        " fn_ismr_latlon( 0, s.lat, s.lon, azimuth, elevation)             AS ipp_lon,".
        " fn_s4_l1_vert(totalS4L1, correctionS4L1, 2.6, elevation)        AS s4_l1_vert,".
        " fn_phi60_l1_vert(phi60l1slant, elevation)                       AS phi60_l1_vert,".
        " fn_stec(tec0, tec15, tec30, tec45)                              AS stec,".
        " fn_vtec(tec0, tec15, tec30, tec45, elevation)                   AS vtec,".
        " fn_s4_l1_slant(totalS4L1, correctionS4L1)                       AS s4_l1_slant,".
        " fn_s4_l2_vert(totalS4_L2C, correctionS4_L2C, 2.6, elevation)    AS s4_l2_vert,".
        " fn_phi60_l2_vert(phi60_l2c, elevation)                          AS phi60_l2_vert,".
        " fn_s4_l2_slant(totalS4_L2C, correctionS4_L2C)                   AS s4_l2_slant,".
        " fn_phi60_l5_vert(phi60_l5, elevation)                           AS phi60_l5_vert,".
        " fn_s4_l5_slant(totalS4_L5, correctionS4_L5)                     AS s4_l5_slant,".
        " c.nmp_code::text ||
          CASE
              WHEN length(t.prn::character(2)) = 1 THEN '0'::text || t.prn
              ELSE ''::text || t.prn
          END AS prn ".
        " FROM ".$sta." d ".
        "     JOIN  station s         ON s.code = '".$sta."' ".
        "     JOIN satellite t        ON t.svid = d.svid ".
        "     JOIN constellation c    ON c.id = t.fk_constellation ".
        ";";
    return $sql;
}

function createNovatelGpsTable($sta, $isPG){
    $sql =" CREATE TABLE ".$sta." (".
            "dt             timestamp NOT NULL,".
            "svid           int     NOT NULL,".
            "rxstate        char(8),".
            "azimuth        float NULL,".
            "elevation      float NULL,".
            "averagel1      float NULL,".
            "totals4l1      float NULL,".
            "corrections4l1 float NULL,".
            "phi01l1        float NULL,".
            "phi03l1        float NULL,".
            "phi10l1        float NULL,".
            "phi30l1        float NULL,".
            "phi60l1slant   float NULL,".
            "avgccdl1       float NULL,".
            "sigmaccdl1     float NULL,".
            "tec45          float NULL,".
            "dtec60_45      float NULL,".
            "tec30          float NULL,".
            "dtec45_30      float NULL,".
            "tec15          float NULL,".
            "dtec30_15      float NULL,".
            "tec0           float NULL,".
            "dtec0          float NULL,".
            "locktimel1     float NULL,".
            "chanstatus     char(8) NULL,".
            "secondlocktime float NULL,".
            "avgcn2freqtec  float NULL,".
            "modified       timestamp NOT NULL," .
            "PRIMARY KEY  (dt, svid)".
    ")";
     return $sql;
}

function createNovatelGpsView($sta, $isPG){
        $sql ="  CREATE OR REPLACE VIEW  ws".$sta." AS ".
        " SELECT ".
        " d.*, ".
        " fn_ismr_latlon( 1, s.lat, s.lon, azimuth, elevation)             AS ipp_lat,".
        " fn_ismr_latlon( 0, s.lat, s.lon, azimuth, elevation)             AS ipp_lon,".
        " fn_s4_l1_vert(totalS4L1, correctionS4L1, 2.6, elevation)        AS s4_l1_vert,".
        " fn_phi60_l1_vert(phi60l1slant, elevation)                       AS phi60_l1_vert,".
        " fn_stec(tec0, tec15, tec30, tec45)                              AS stec,".
        " fn_vtec(tec0, tec15, tec30, tec45, elevation)                   AS vtec,".
        " fn_s4_l1_slant(totalS4L1, correctionS4L1)                       AS s4_l1_slant,".
        " c.nmp_code::text ||
          CASE
              WHEN length(t.prn::character(2)) = 1 THEN '0'::text || t.prn
              ELSE ''::text || t.prn
          END AS prn ".
        " FROM ".$sta." d ".
        "     JOIN  station s         ON s.code = '".$sta."' ".
        "     JOIN satellite t        ON t.svid = d.svid ".
        "     JOIN constellation c    ON c.id = t.fk_constellation ".
        ";";
    return $sql;
}

function fn_isdef($val){
    $val = trim($val);
    if (isset($val)){
        if ($val === ""){
                return null;
        } else {
            return $val;
        }
    } else{
        return null;
    }
    null;
}

function fn_createAllView($db){
    echo "CICCIO: ".$db-"\n";
}

function fn_s60___d($fn){
    exec('/usr/bin/wine ./bin/ParseIsmrWin.exe all '.$fn.' ./outta.es', $output, $retval);
 print_r($output); print_r($retval);die();
}

function fn_trace_xml2json_saoXml($freq, $range){
    $trace_arr_tmp = array();
    $appFrequencyList   = preg_replace("/[[:blank:]]+/",",", str_replace("\n", "",$freq));
    $appRangeList       = preg_replace("/[[:blank:]]+/",",", str_replace("\n", "",$range));
    // correct starting ending string
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
        $trace_arr_tmp[$i]['f'] = $arr[$i];
        $i++;
    }
    #$this->trace_arr = array_merge($trace_arr_tmp, $this->trace_arr);
    // sort by h
    usort($trace_arr_tmp, function($a, $b) {
        return $a['h'] <=> $b['h'];
    });
    return (json_encode($trace_arr_tmp, JSON_NUMERIC_CHECK));
}

function fn_read_ursi_saoXml(SimpleXMLElement $node, $fname){
    $elemVal='';
    foreach ($node->URSI as $elem) {
        $elemName = (string) $elem['Name'];
        if ( $elemName == $fname) {
            $elemVal = (string) $elem['Val'];
            break;
        }
    }
    return($elemVal);
}

function fn_isNull($str): bool
{
    if (!isset($str) || is_null($str)) {
        return true;
    }
    if (is_string($str) && trim($str) === '') {
        return true;
    }
    return false;
}

function binCodDec($byte) {
    if ( is_numeric($byte) ) {
        $high = 10 * (($byte & 0xf0) >> 4);
        $low = $byte & 0x0f;
        return $high + $low;
    } else {
        return null;
    }
}

function createStfEuLstid($sta, $isPG){
            $sql =" CREATE TABLE ".$sta." (".
                    " dt timestamp PRIMARY KEY, ".
                    " dt_run timestamp NOT NULL, ".
                    " fromfile text NOT NULL,".
                    " lstid_occurrence_probability float NOT NULL, ".
                    " lstid_high_precision_prediction float NOT NULL, ".
                    " lstid_balanced_prediction integer NOT NULL, ".
                    " lstid_high_sensitivity_prediction integer NOT NULL, ".
                    " input_availability_score float NOT NULL, ".
                    " input_availability_alert boolean NOT NULL DEFAULT 'FALSE', ".
                    " ie float DEFAULT NULL, ".
                    " ie_variation integer DEFAULT NULL, ".
                    " ie_3h_exp_mov_avg float DEFAULT NULL, ".
                    " ie_12h_exp_mov_avg float DEFAULT NULL, ".
                    " iu float DEFAULT NULL, ".
                    " iu_variation integer DEFAULT NULL, ".
                    " iu_3h_exp_mov_avg float DEFAULT NULL, ".
                    " iu_12h_exp_mov_avg float DEFAULT NULL, ".
                    " hf_int float DEFAULT NULL, ".
                    " hf_int_2h_exp_mov_avg float DEFAULT NULL, ".
                    " f_107_adj float DEFAULT NULL, ".
                    " hp_30 float DEFAULT NULL, ".
                    " dst float DEFAULT NULL, ".
                    " solar_zenith_angle float DEFAULT NULL, ".
                    " newell float DEFAULT NULL, ".
                    " imf_bz float DEFAULT NULL, ".
                    " imf_speed float DEFAULT NULL, ".
                    " imf_rho float DEFAULT NULL, ".
                    " spectral_contribution_at float DEFAULT NULL, ".
                    " spectral_contribution_ff float DEFAULT NULL, ".
                    " spectral_contribution_jr float DEFAULT NULL, ".
                    " spectral_contribution_pq float DEFAULT NULL, ".
                    " spectral_contribution_ro float DEFAULT NULL, ".
                    " spectral_contribution_vt float DEFAULT NULL, ".
                    " azimuth_at float DEFAULT NULL, ".
                    " azimuth_ff float DEFAULT NULL, ".
                    " azimuth_jr float DEFAULT NULL, ".
                    " azimuth_pq float DEFAULT NULL, ".
                    " azimuth_ro float DEFAULT NULL, ".
                    " azimuth_vt float DEFAULT NULL, ".
                    " velocity_at float DEFAULT NULL, ".
                    " velocity_ff float DEFAULT NULL, ".
                    " velocity_jr float DEFAULT NULL, ".
                    " velocity_pq float DEFAULT NULL, ".
                    " velocity_ro float DEFAULT NULL, ".
                    " velocity_vt float DEFAULT NULL, ".
                    " modified timestamp NOT NULL ".
                    " );";

    return $sql;
}

?>
