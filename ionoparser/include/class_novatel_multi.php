<?php

class novam_line {
/**
 * \brief Classe per la gestione delle misurazione dei novatel multicostellazione
 * della Novatel. 
 * 
 * I membri della classe si basano su quelli della septentrio, usata come template seguendo il criterio:
 * se il campo esiste prende il nome che he nella classe septentrio altrimenti viene inserito, se non presente, o rimosso
 * Caratterisctica di questi ricevitori è la produzione di 6 file per misurazione, due per ogniil campo esiste prende il nome che he nella classe septentrio altrimenti viene inserito, se non presente, o rimosso
 * Caratterisctica di questi ricevitori è la produzione di 6 file per misurazione, due per ogni  
 * Vieme creato un array di righe con chiave univoca data da dt e svid, viene popolata con la lettura 
 * swquenziale dei 3 file ottenuti dal binario riempendo i valori letti per quel tempo e quel satellite
 */

    public $satgrp;                /// id della costellazione
    public $datetime;              /// datetime della misura

 public $input_line;
   
    public $SVID;                   // Col 2. PRN
    public $Freq;                   // Col 3 Frequency: GLONASS frequency channel (-7 to +6)
    public $azimuth;                // Col 6
    public $elevation;           // Col 7
    public $averageL1;           // Col 7.
    public $totalS4L1;      //              Col 8.
    public $correctionS4L1;      //         Col 9.
    public $phi01l1;      //                Col 10.
    public $phi03l1;      //                Col 11.
    public $phi10l1;      //                Col 12.
    public $phi30l1;      //                Col 13.
    public $phi60l1slant;      //            Col 14.
    public $avgCCDL1;      //                  Col 15.
    public $sigmaCCDL1;      //              Col 16.
    public $tec45 ;      //                  Col 17.
    public $dtec60_45;      //              Col 18.
    public $tec30;      //                  Col 19.
    public $dtec45_30;      //              Col 20.
    public $tec15;      //                  Col 21.
    public $dtec30_15;      //              Col 22.
    public $tec0;      //                   Col 23.
    public $dtec0;      //                  Col 24.

    public $tec45_2c;                       ///  tec second frequency combination
    public $dtec60_45_2c;                   ///  tec second frequency combination
    public $tec30_2c;                       ///  tec second frequency combination
    public $dtec45_30_2c;                   ///  tec second frequency combination
    public $tec15_2c;                       ///  tec second frequency combination
    public $dtec30_15_2c;                   ///  tec second frequency combination
    public $tec0_2c;                        ///  tec second frequency combination
    public $dtec0_2c;                       ///  tec second frequency combination

    public $locktimeL1;      //             Col 25.
//    public $reserved;      //               Col 26.
//    public $secondlocktime;      //            Col 27.
//    public $avgcn2freqTEC;      //          Col 28.
//    public $SI_L1_29;      //               Col 29.
//    public $SI_L1_30;      //               Col 30.
//    public $pL1;      //                    Col 31.
    public $avg_c_n0_l2c;      //           Col 32.
    public $totalS4_L2C;      //            Col 33.
    public $correctionS4_L2C;      //       Col 34.
    public $phi01_l2c;      //              Col 35.
    public $phi03_l2c;      //              Col 36.
    public $phi10_l2c;      //              Col 37.
    public $phi30_l2c;      //              Col 38.
    public $phi60_l2c;      //              Col 39.
    public $avgccd_l2c;      //             Col 40. 
    public $sigmaccd_l2c;      //           Col 41. 
    public $locktime_l2c;      //           Col 42. 
//    public $SI_L2C_43;      //              Col 43. 
//    public $SI_L2C_44;      //              Col 44. 
//    public $p_l2c;      //                  Col 45. 
    public $avg_c_n0_l5;      //            Col 46. 
    public $totalS4_L5;      //             Col 47. 
    public $correctionS4_L5;      //        Col 48. 
    public $phi01_l5;      //               Col 49. 
    public $phi03_l5;      //               Col 50. 
    public $phi10_l5 ;      //              Col 51. 
    public $phi30_l5;      //               Col 52. 
    public $phi60_l5;      //               Col 53. 
    public $avgccd_l5;      //              Col 54. 
    public $sigmaccd_l5;      //            Col 55. 
    public $locktime_l5;      //            Col 56. 
//    public $SI_L5_57;      //               Col 57. 
//    public $SI_L5_58;      //               Col 58. 
//    public $p_l5;      //                   Col 59. 
//    public $t_l1;      //                   Col 60. 
//    public $t_l2c;      //                  Col 61. 
//    public $t_l5;      //                   Col 62. 

    function __construct($wn, $sg, $str){
        $this -> satgrp = $sg;
        $this -> input_line = $str;
        //$this -> readtecline($wn, $sg, $str);
    }

    function readtecline($wn, $satgrp, $str, $svid){
        /// load array with values in csv format
        $dataline = str_getcsv(trim($str));
        if (is_null($this -> datetime) ){
            $this -> datetime           = fn_weektow2datetime($wn, $dataline[0]);
            $this -> SVID               = $svid;
            $this -> Freq               = $dataline[2]; // nuovo campo rispotto a septentrio
            $this -> azimuth            = $dataline[5];
            $this -> elevation         = $dataline[6];
        }
        /** qui si controlla la coppia di frequenze che, a seconda del gruppo di satellidi, 
        *   determina se il tec è primario o secondario
        *   GALILEO: coppia freq    1 2 tec prima conf
        *                           altrimenti tec seconda conf
        *   GPS      coppia freq    1 4 tec prima conf
        *                           elseif 1 7 tec seconda conf
        *                           else dati inutilizzabili
        *   GLONASS      coppia freq    1 4 tec prima conf
        *                           else tec seconda conf
        * per compatibilità con i file Septentrio, per i file di scintillazione:
        *
        * GPS si considerano solo le frequenze L1CA, L2C, L5Q
        * GLONASS si considerano solo le frequenze L1CA, L2CA
        * GALILEO si considerano solo le frequenze E1, E5a, E5b

        */
        if ($satgrp == 0) {         /// GPS                                            
            if ($dataline[3] == 1 AND $dataline[4] == 4){
                $this -> tec45          = $dataline[13];
                $this -> dtec60_45      = $dataline[14];
                $this -> tec30          = $dataline[11];
                $this -> dtec45_30      = $dataline[12];
                $this -> tec15          = $dataline[9];
                $this -> dtec30_15      = $dataline[10];
                $this -> tec0           = $dataline[15];
                $this -> dtec0          = $dataline[16];
                /// prima conf per il tec
            }
            elseif ($dataline[3] == 1 AND $dataline[4] == 7) {
                $this -> tec45_2c       = $dataline[13];
                $this -> dtec60_45_2c   = $dataline[14];
                $this -> tec30_2c       = $dataline[11];
                $this -> dtec45_30_2c   = $dataline[12];
                $this -> tec15_2c       = $dataline[9];
                $this -> dtec30_15_2c   = $dataline[10];
                $this -> tec0_2c        = $dataline[15];
                $this -> dtec0_2c       = $dataline[16];
               /// seconda conf per il tec
            };
        }
        elseif ($satgrp == 1) {     /// GLONASS
            if ($dataline[3] == 1 AND $dataline[4] == 4){
                $this -> tec45          = $dataline[13];
                $this -> dtec60_45      = $dataline[14];
                $this -> tec30          = $dataline[11];
                $this -> dtec45_30      = $dataline[12];
                $this -> tec15          = $dataline[9];
                $this -> dtec30_15      = $dataline[10];
                $this -> tec0           = $dataline[15];
                $this -> dtec0          = $dataline[16];
                /// prima conf per il tec
            }
            else {
                $this -> tec45_2c       = $dataline[13];
                $this -> dtec60_45_2c   = $dataline[14];
                $this -> tec30_2c       = $dataline[11];
                $this -> dtec45_30_2c   = $dataline[12];
                $this -> tec15_2c       = $dataline[9];
                $this -> dtec30_15_2c   = $dataline[10];
                $this -> tec0_2c        = $dataline[15];
                $this -> dtec0_2c       = $dataline[16];
               /// seconda conf per il tec
            };
        }
        elseif ($this -> satgrp == 5) {     /// GALILEO
            if ($dataline[3] == 1 AND $dataline[4] == 2){
                $this -> tec45          = $dataline[13];
                $this -> dtec60_45      = $dataline[14];
                $this -> tec30          = $dataline[11];
                $this -> dtec45_30      = $dataline[12];
                $this -> tec15          = $dataline[9];
                $this -> dtec30_15      = $dataline[10];
                $this -> tec0           = $dataline[15];
                $this -> dtec0          = $dataline[16];
                /// prima conf per il tec
            }
            else {
                $this -> tec45_2c       = $dataline[13];
                $this -> dtec60_45_2c   = $dataline[14];
                $this -> tec30_2c       = $dataline[11];
                $this -> dtec45_30_2c   = $dataline[12];
                $this -> tec15_2c       = $dataline[9];
                $this -> dtec30_15_2c   = $dataline[10];
                $this -> tec0_2c        = $dataline[15];
                $this -> dtec0_2c       = $dataline[16];
               /// seconda conf per il tec
            };
        }
    } // function readtecline

    function readobsline($wn, $satgrp, $str, $svid){
        /// load array with values in csv format
        $dataline = str_getcsv(trim($str));
        if (is_null($this -> datetime) ){
            $this -> datetime           = fn_weektow2datetime($wn, $dataline[0]);
//            $this -> SVID               = $dataline[1];
            $this -> SVID               = $svid;
            $this -> Freq               = $dataline[2]; // nuovo campo rispotto a septentrio
            $this -> azimuth            = $dataline[4];
            $this -> elevation          = $dataline[5];
        }
        /** In questo caso la molteplicità va con il SigType, a seconda del suo valore e della classe di satelliti a cui la misura
        *   appartiene viene deciso il campo da popolare:
        *   
        *   GPS     : 1 = L1CA,     4 = L2Y,  5 = L2C, 6 = L2P,    7 = L5Q
        *   GALILEO : 1 = E1,       2 = E5A,  3 = E5B, 4 = ALTBOC, 5 = E6                        altrimenti tec seconda conf
        *   GLONASS : 1 = L1CA,     3 = L2CA, 4 = L2P
        *
        */
        
        if ($satgrp == 0) {         /// GPS                                            
            if ($dataline[3] == 1){
                // GPS TOW , PRN, Freq, SigType, Az , Elv , CNo , Lock Time, CMC Avg, CMC Std , S4 , S4 Cor, 1SecSigma, 3SecSigma, 10SecSigma, 30SecSigma, 60SecSigma 
                $this -> averageL1          = $dataline[6];
                $this -> locktimeL1         = $dataline[7];
                $this -> avgCCDL1           = $dataline[8];
                $this -> sigmaCCDL1         = $dataline[9];
                $this -> totalS4L1          = $dataline[10];
                $this -> correctionS4L1     = $dataline[11];
                $this -> phi01l1            = $dataline[12];
                $this -> phi03l1            = $dataline[13];
                $this -> phi10l1            = $dataline[14];
                $this -> phi30l1            = $dataline[15];
                $this -> phi60l1slant       = $dataline[16];
                /// prima freq per gli obs
            }
            elseif ($dataline[3] == 5) {
//echo "dataline 6  _".$dataline[6]."_\n";
                $this -> avg_c_n0_l2c       = $dataline[6];
                $this -> locktime_l2c       = $dataline[7];
                $this -> avgccd_l2c         = $dataline[8];
                $this -> sigmaccd_l2c       = $dataline[9];
                $this -> totalS4_L2C        = $dataline[10];
                $this -> correctionS4_L2C   = $dataline[11];
                $this -> phi01_l2c          = $dataline[12];
                $this -> phi03_l2c          = $dataline[13];
                $this -> phi10_l2c          = $dataline[14];
                $this -> phi30_l2c          = $dataline[15];
                $this -> phi60_l2c          = $dataline[16];
                /// freq 5 per gli obs             
            }
            elseif ($dataline[3] == 7) {
                $this -> avg_c_n0_l5       = $dataline[6];
                $this -> locktime_l5       = $dataline[7];
                $this -> avgccd_l5       = $dataline[8];
                $this -> sigmaccd_l5        = $dataline[9];
                $this -> totalS4_L5        = $dataline[10];
                $this -> correctionS4_L5    = $dataline[11];
                $this -> phi01_l5          = $dataline[12];
                $this -> phi03_l5          = $dataline[13];
                $this -> phi10_l5          = $dataline[14];
                $this -> phi30_l5          = $dataline[15];
                $this -> phi60_l5          = $dataline[16];
                /// freq 4 per gli obs             
             }
            elseif ($dataline[3] == 4) {
                /// frequenza scartata 
             }
            elseif ($dataline[3] == 6) {
                /// frequenza scartata 
             }
        }
        elseif ($satgrp == 1) {     /// GLONASS
            if ($dataline[3] == 1) {
                $this -> averageL1      = $dataline[6];
                $this -> locktimeL1      = $dataline[7];
                $this -> avgCCDL1       = $dataline[8];
                $this -> sigmaCCDL1        = $dataline[9];
                $this -> totalS4L1        = $dataline[10];
                $this -> correctionS4L1    = $dataline[11];
                $this -> phi01l1          = $dataline[12];
                $this -> phi03l1          = $dataline[13];
                $this -> phi10l1          = $dataline[14];
                $this -> phi30l1          = $dataline[15];
                $this -> phi60l1slant          = $dataline[16];
                /// freq 4 per gli obs             
            }
            elseif ($dataline[3] == 3) {
                $this -> avg_c_n0_l2c       = $dataline[6];
                $this -> locktime_l2c       = $dataline[7];
                $this -> avgccd_l2c         = $dataline[8];
                $this -> sigmaccd_l2c       = $dataline[9];
                $this -> totalS4_L2C        = $dataline[10];
                $this -> correctionS4_L2C   = $dataline[11];
                $this -> phi01_l2c          = $dataline[12];
                $this -> phi03_l2c          = $dataline[13];
                $this -> phi10_l2c          = $dataline[14];
                $this -> phi30_l2c          = $dataline[15];
                $this -> phi60_l2c          = $dataline[16];
               /// freq 4 per gli obs             
            }
            elseif ($dataline[3] == 4) {
                /// scartata
            }
        }
        elseif ($satgrp == 5) {     /// GALILEO
            if ($dataline[3] == 1){
                $this -> averageL1          = $dataline[6];
                $this -> locktimeL1         = $dataline[7];
                $this -> avgCCDL1           = $dataline[8];
                $this -> sigmaCCDL1         = $dataline[9];
                $this -> totalS4L1          = $dataline[10];
                $this -> correctionS4L1     = $dataline[11];
                $this -> phi01l1            = $dataline[12];
                $this -> phi03l1            = $dataline[13];
                $this -> phi10l1            = $dataline[14];
                $this -> phi30l1            = $dataline[15];
                $this -> phi60l1slant       = $dataline[16];
                /// prima freq per gli obs
            }
            elseif ($dataline[3] == 2) {
                $this -> avg_c_n0_l2c       = $dataline[6];
                $this -> locktime_l2c       = $dataline[7];
                $this -> avgccd_l2c         = $dataline[8];
                $this -> sigmaccd_l2c       = $dataline[9];
                $this -> totalS4_L2C        = $dataline[10];
                $this -> correctionS4_L2C   = $dataline[11];
                $this -> phi01_l2c          = $dataline[12];
                $this -> phi03_l2c          = $dataline[13];
                $this -> phi10_l2c          = $dataline[14];
                $this -> phi30_l2c          = $dataline[15];
                $this -> phi60_l2c          = $dataline[16];
                /// freq 5 per gli obs             
            }
            elseif ($dataline[3] == 3) {
                $this -> avg_c_n0_l5       = $dataline[6];
                $this -> locktime_l5       = $dataline[7];
                $this -> avgccd_l5       = $dataline[8];
                $this -> sigmaccd_l5        = $dataline[9];
                $this -> totalS4_L5        = $dataline[10];
                $this -> correctionS4_L5    = $dataline[11];
                $this -> phi01_l5          = $dataline[12];
                $this -> phi03_l5          = $dataline[13];
                $this -> phi10_l5          = $dataline[14];
                $this -> phi30_l5          = $dataline[15];
                $this -> phi60_l5          = $dataline[16];
                /// freq 4 per gli obs             
            }
            elseif ($dataline[3] == 4) {
                /// scartata
            }
            elseif ($dataline[3] == 5) {
                /// scartata
            }

               /// freq 4 per gli obs             
             }
    } // function readobsline
} // class

class novam_file {
/**
 * \brief Classe per la gestione delle misurazione dei novatel multicostellazione
 * della Novatel. 
 * 
 * I membri della classe si basano su quelli della septentrio, usata come template seguendo il criterio:
 * se il campo esiste prende il nome che he nella classe septentrio altrimenti viene inserito, se non presente, o rimosso
 * Caratterisctica di questi ricevitori è la produzione di 6 file per misurazione, due per ogniil campo esiste prende il nome che he nella classe septentrio altrimenti viene inserito, se non presente, o rimosso
 * Caratterisctica di questi ricevitori è la produzione di 6 file per misurazione, due per ogni  
 * Vieme creato un array di righe con chiave univoca data da dt e svid, viene popolata con la lettura 
 * swquenziale dei 3 file ottenuti dal binario riempendo i valori letti per quel tempo e quel satellite
 * 
 */

    public  $filename;                              /// nome del file binario del novatel multi 
    public  $fname;                              /// nome del file binario del novatel multi 
    public  $station;                               /// nome della stazione
    public  $myconn;                                /// connessione
    public  $host;
    public  $db;
    // postgres
    public $isPostgres;             /// true if upe pg
    // novatel multiline
    public  $satList = array("R", "G", "E");        /// lista dei satelliti letti dai files
    public  $listSvid = array();        /// lista dei satelliti con i codici SVID
    public  $n_line = array();                      /// riga della tabella del db, chiave univoca (dt, SVID)

    public $nfTec = "REDTEC_";                      /// Prefisso del nome del file prodotto per TEC
    public $nfObs = "REDOBS_";                      /// Prefisso del nome del file prodotto per OBS

    function __construct($fn,$myc, $statio, $fname, $isPg, $db){
        $this -> filename   = $fn;
        $this -> fname      = $fname;
        $this -> station    = $statio;
        $this -> myconn     = $myc;
        $this -> listSvid   = $this->listSVID();
        $this -> isPostgres = ($isPg == 'pg' ? 1 : 0);
        $this -> db         = $db;
        /// estrai i file txt dal binario
        foreach ($this->satList as $lettera) {
            exec('wine ./bin/ParseReduced.exe '.$lettera." ".$this->filename." ".$lettera.'_o >/dev/null 2>&1');  /// estrai i file tec e obs dal binario passato
            if (file_exists('REDTEC_'.$lettera.'_o')){
                exec(' tr -d \'\\15\\32\'< REDTEC_'.$lettera.'_o>'.$this->nfTec.$lettera.'_out ');    /// da windows a unix text format
            }
            else{
                echo " MISSING FILE REDTEC_".$lettera."_o    FROM ".$this->filename."\t";
            }
            if (file_exists('REDOBS_'.$lettera.'_o')){
                exec(' tr -d \'\\15\\32\'< REDOBS_'.$lettera.'_o > REDOBS_'.$lettera.'_out ');    /// da windows a unix text format
            }
            else{
                echo " MISSING FILE REDOBS_".$lettera."_o    FROM ".$this->filename."\t";
            }
        }
        exec(' rm -f ./*_o');    /// rimuove i file temporanei
    }

    function __destruct() {
        exec(' rm -f ./*_out');    /// rimuove i file parsati
    }


    function load_data_from_tecfile($fn, $cLetter){
    /**
     * Funzione che popola la classe leggendo il file tec prodotti dai programma ParseReduced.exe per i file binari del novatel multiconstellation
     * 
     */
        $line="";
        if ($fh = fopen($fn, 'r')) {
            while (!feof($fh) AND (!strpos($line,"atellite System"))) {
                $line = fgets($fh);
            }
            $line       = str_replace("Satellite System:", "",$line);   // tolgo il titolo della riga
            $satrow     = str_replace(' ', '', str_getcsv($line));
            foreach ($satrow as $sat) {
                //$pos = strpos($sat, "=");
                //$this -> satTable[substr($sat, 0, strpos($sat, "="))] = substr($sat, strpos($sat, "=")+1, strlen($sat));
            }
            
            while (!feof($fh) AND (!strpos($line,"PS Week:"))) {
                $line = fgets($fh);
            }
            // weeknumber e sat id locale, specigica per il sistema di satelliti utilizzato
            // va utilizzato per determinare lo svid globale definito nel db
            $wn                 = str_replace(' ', '', substr($line, strpos($line, "GPS Week:")+9, 5));
            $satGroupID         = str_replace(' ', '', substr($line, strpos($line, "Satellite System: ")+18, 1));
            /// satGroupID non è proprio del file rwx ma di come si sono estratti i dati quindi proprio del file red che stiamo leggendo
            // scorre il file fino all'inizio dei dati
            while (!feof($fh) AND (!strpos($line,"PS TOW,"))) {
                $line = fgets($fh);
            }
            // inizia la lettura dei dati
            $line = str_replace(' ', '', fgets($fh));
            while (!feof($fh) AND (strlen($line) >10)){
                $linearr = str_getcsv($line);
                // rowID= WN . TOW . SVID
                //$rowID = $wn . str_replace('.', '', $linearr[0]) .  $linearr[1];

                /// legge l'id del gruppo sul file e insieme al prn lo passa alla funzione
                /// che calcola lo svid dalla lista presa dal db
                $rowSVID    = $this -> getsvid($satGroupID, $linearr[1]);
                $rowID      = $wn . str_replace('.', '', $linearr[0]) .  $rowSVID;
                // se la riga esiste la popola nella sua parte, altrimeti la crea
                if (array_key_exists($rowID, $this -> n_line)) {
                    $this -> n_line[$rowID] -> readtecline($wn, $satGroupID, $line, $rowSVID);
                }
                else {
                    $this -> n_line[$rowID] = new novam_line($wn, $satGroupID, $line);
                    $this -> n_line[$rowID] -> readtecline($wn, $satGroupID, $line, $rowSVID);
                    $this -> n_line[$rowID] -> input_line = "TEC_" . $this -> n_line[$rowID] -> input_line;
                }
                $line   = str_replace(' ', '', fgets($fh));
            } // end while 

            fclose($fh);
            $out = array(
                "err_code" => 0,
                "err_message" => "tec read"
            );
        } else{
            $out = array(
                "err_code" => -1,
                "err_message" => "Error: Can't read file tec"
            );

        } // end fopen
        return $out;
    } // end function load_data_from_tecfile

    function load_data_from_obsfile($fn, $cLetter){
    /**
     * Funzione che popola la classe leggendo il file obs prodotti dai programma ParseReduced.exe 
     * per i file binari del novatel multiconstellation
     * 
     */
        $line="";
        if ($fh = fopen($fn, 'r')) {
            while (!feof($fh) AND (!strpos($line,"atellite System"))) {
                $line = fgets($fh);
            }
            $line       = str_replace("Satellite System:", "",$line);   // tolgo il titolo della riga
            $satrow     = str_replace(' ', '', str_getcsv($line));
            //foreach ($satrow as $sat) {
            //  $pos = strpos($sat, "=");
            //  $this -> satTable[substr($sat, 0, strpos($sat, "="))] = substr($sat, strpos($sat, "=")+1, strlen($sat));
            //}
            
            while (!feof($fh) AND (!strpos($line,"PS Week:"))) {
                $line = fgets($fh);
            }
            // weeknumber e sat id locale, specigica per il sistema di satelliti utilizzato
            // va utilizzato per determinare lo svid globale definito nel db
            $wn                 = str_replace(' ', '', substr($line, strpos($line, "GPS Week:")+9, 5));
            $satGroupID         = str_replace(' ', '', substr($line, strpos($line, "Satellite System: ")+18, 1));
            /// satGroupID non è proprio del file rwx ma di come si sono estratti i dati quindi proprio del file red che stiamo leggendo
            // scorre il file fino all'inizio dei dati
            while (!feof($fh) AND (!strpos($line,"PS TOW ,"))) {
                $line = fgets($fh);
            }
            // inizia la lettura dei dati
            $line = str_replace("\r", '', str_replace("\n", '', str_replace(" ", '', fgets($fh))));
            while (!feof($fh) AND (strlen($line) >10)){
                $linearr = str_getcsv($line);
                // rowID= WN . TOW . SVID
                /// legge l'id del gruppo sul file e insieme al prn lo passa alla funzione
                /// che calcola lo svid dalla lista presa dal db
                $rowSVID    = $this -> getsvid($satGroupID, $linearr[1]);
                $rowID      = $wn . str_replace('.', '', $linearr[0]) .  $rowSVID;

                // $rowID = $wn . str_replace('.', '', $linearr[0]) .  $linearr[1];
                // se la riga esiste la popola nella sua parte, altrimeti la crea
                if (array_key_exists($rowID, $this -> n_line)) {
                    $this -> n_line[$rowID] -> readobsline($wn, $satGroupID, $line, $rowSVID);
                }
                else {
                    $this -> n_line[$rowID] = new novam_line($wn, $satGroupID, $line);
                    $this -> n_line[$rowID] -> readobsline($wn, $satGroupID, $line, $rowSVID);
                    $this -> n_line[$rowID] -> input_line = "OBS_" . $this -> n_line[$rowID] -> input_line;
                }
                $line = str_replace("\r", '', str_replace("\n", '', str_replace(" ", '', fgets($fh))));
            } // end while 
            fclose($fh);
            $out = array(
                "err_code" => 0,
                "err_message" => "obs read"
            );
        } else{
            $out = array(
                "err_code" => -1,
                "err_message" => "Error: Can't read file obs"
            );
        
        } // end fopen
        return $out;
    } // end$ function load_data_from_obsfile
    
    function listSVID(){
    /** 
    *   Restituisce un array con la lista degli svid e i nomi delle costellazioni
    */
        $sql =  "SELECT s.svid, s.prn, c.id cid, c.code, c.name, c.nmp_code " .
                "FROM satellite s JOIN constellation c ON c.id = s.fk_constellation;";
        try{
            $stmt = $this->myconn->conn->query($sql);
            $out = $stmt -> fetchAll();
        }
        catch (PDOException $e)
        {
            return array();
        }
        $stmt->closeCursor();
        foreach ($out as $ll){
            $lippa[$ll["svid"]] = array(
                    "svid"      => $ll["svid"],
                    "prn"       => $ll["prn"],
                    "cid"       => $ll["cid"],
                    "code"      => $ll["code"],
                    "name"      => $ll["name"],
                    "nmp_code"  => $ll["nmp_code"]
                );
            
        }
        return $lippa;
    }

    function read_file() {
    /** Funzione che cicla sui file out generati dal programma windows e chiama
    *   le funzioni che li parsano e li caricano nella classe
    */
        $out = array(
            "err_code" => 0,
            "err_message" => "File tec obs parsed"
        ); 
        foreach ($this->satList as $lettera) {
            if (file_exists('./'.$this->nfTec.$lettera.'_out')){ 
                $outl = $this -> load_data_from_tecfile('./'.$this->nfTec.$lettera.'_out', $lettera);                
                if ($outl['err_code'] != 0){
                    $out = array(
                        "err_code" => -1,
                        "err_message" => "Error parsini tec or obs file"
                    );
                }
            }
            if (file_exists('./'.$this->nfObs.$lettera.'_out')){ 
                $outl = $this -> load_data_from_obsfile('./'.$this->nfObs.$lettera.'_out', $lettera);
                if ($outl['err_code'] != 0){
                    $out = array(
                        "err_code" => -1,
                        "err_message" => "Error parsini tec or obs file"
                    );
                }
            }
        } // foreach
        return $out;
    } // end function read_file
    
    function push2db(){
       ///
        /// controllo dell esistenza della tabella della stazione e sua eventuale creazione
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
        /// se la rabella di stazione non esiste va creata
        if ($out[0]['ntab'] == 0) {
            // il nome della tabella non puo essere passato col prepare cone variabile di pdo
            $sql = creteNovatelMultiTable($this -> station, $this->isPostgres);
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
            $sql = createNovatelMultiView($this -> station, $this->isPostgres);
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
        } // table and view created
        $nrow       = 0;
        $nrowok     = 0;
        $nrowdupe   = 0;
        $nrowerr    = 0;
        foreach ($this -> n_line as $row) {
            $nrow++;
            $sqlr = "INSERT INTO ".$this -> station." (".
                        "dt, svid, azimuth, elevation, averagel1, totals4l1, corrections4l1, phi01l1, phi03l1, phi10l1, phi30l1, phi60l1slant, avgccdl1, sigmaccdl1, tec45, dtec60_45, tec30, dtec45_30, tec15, dtec30_15, tec0, dtec0, locktimel1, avg_c_n0_l2c, totals4_l2c, correctionS4_L2C, phi01_l2c, phi03_l2c, phi10_l2c, phi30_l2c, phi60_l2c, avgccd_l2c, sigmaccd_l2c, locktime_l2c, avg_c_n0_l5, totals4_l5, corrections4_l5, phi01_l5, phi03_l5, phi10_l5, phi30_l5, phi60_l5, avgccd_l5, sigmaccd_l5, locktime_l5, tec45_2c, dtec60_45_2c, tec30_2c, dtec45_30_2c, tec15_2c, dtec30_15_2c, tec0_2c, dtec0_2c, modified) VALUES (".
                ":datetime,".
                ":svid,".
                ":az,".
                ":elv,".
                ":averageL1,".
                ":totalS4L1,".
                ":correctionS4L1,".
                ":phi01l1,".
                ":phi03l1,".
                ":phi10l1,".
                ":phi30l1,".
                ":phi60l1slant,".
                ":avgCCDL1,".
                ":sigmaCCDL1,".
                ":tec45,".
                ":dtec60_45,".
                ":tec30,".
                ":dtec45_30,".
                ":tec15,".
                ":dtec30_15,".
                ":tec0,".
                ":dtec0,".
                ":locktimeL1,".
                ":avg_c_n0_l2c,".
                ":totalS4_L2C,".
                ":correctionS4_L2C,".
                ":phi01_l2c,".
                ":phi03_l2c,".
                ":phi10_l2c,".
                ":phi30_l2c,".
                ":phi60_l2c,".
                ":avgccd_l2c,".
                ":sigmaccd_l2c,".
                ":locktime_l2c,".
                ":avg_c_n0_l5,".
                ":totalS4_L5,".
                ":correctionS4_L5,".
                ":phi01_l5,".
                ":phi03_l5,".
                ":phi10_l5,".
                ":phi30_l5,".
                ":phi60_l5,".
                ":avgccd_l5,".
                ":sigmaccd_l5,".
                ":locktime_l5,".
                ":tec45_2c,".
                ":dtec60_45_2c,".
                ":tec30_2c,".
                ":dtec45_30_2c,".
                ":tec15_2c,".
                ":dtec30_15_2c,".
                ":tec0_2c,".
                ":dtec0_2c,".
                ":modified)";
            $appor = array(
                ':datetime'         => isset($row->datetime) ? $row-> datetime: null,
                ':svid'             => isset($row->SVID) ? $row->SVID: null,
                ':az'               => isset($row->azimuth) ? $row->azimuth : null,
               ':elv'               => isset($row->elevation) ? $row->elevation : null,
                ':averageL1'        => isset($row->averageL1) ? $row->averageL1 : null,
                ':totalS4L1'        => isset($row->totalS4L1) ? $row->totalS4L1 : null,
                ':correctionS4L1'   => isset($row->correctionS4L1) ? $row->correctionS4L1 : null,
                ':phi01l1'          => isset($row->phi01l1) ? $row->phi01l1 : null,
                ':phi03l1'          => isset($row->phi03l1) ? $row->phi03l1 : null,
                ':phi10l1'          => isset($row->phi10l1) ? $row->phi10l1 : null,
                ':phi30l1'          => isset($row->phi30l1) ? $row->phi30l1 : null,
                ':phi60l1slant'     => isset($row->phi60l1slant) ? $row->phi60l1slant : null,
                ':avgCCDL1'         => isset($row->avgCCDL1) ? $row->avgCCDL1 : null,
                ':sigmaCCDL1'       => isset($row->sigmaCCDL1) ? $row->sigmaCCDL1 : null,
                ':tec45'            => isset($row->tec45) ? $row->tec45 : null,
                ':dtec60_45'        => isset($row->dtec60_45) ? $row->dtec60_45 : null,
                ':tec30'            => isset($row->tec30) ? $row->tec30 : null,
                ':dtec45_30'        => isset($row->dtec45_30) ? $row->dtec45_30: null,
                ':tec15'            => isset($row->tec15) ? $row->tec15 : null,
                ':dtec30_15'        => isset($row->dtec30_15) ? $row->dtec30_15 : null,
                ':tec0'             => isset($row->tec0) ? $row->tec0 : null,
                ':dtec0'            => isset($row->dtec0) ? $row->dtec0 : null,
                ':locktimeL1'       => isset($row->locktimeL1) ? $row->locktimeL1 : null,
                ':avg_c_n0_l2c'     => isset($row-> avg_c_n0_l2c) ? $row->avg_c_n0_l2c : null,
                ':totalS4_L2C'      => isset($row->totalS4_L2C) ? $row->totalS4_L2C : null,
                ':correctionS4_L2C' => isset($row->correctionS4_L2C) ? $row->correctionS4_L2C : null,
                ':phi01_l2c'        => isset($row->phi01_l2c) ? $row->phi01_l2c : null,
                ':phi03_l2c'        => isset($row->phi03_l2c) ? $row->phi03_l2c : null,
                ':phi10_l2c'        => isset($row->phi10_l2c) ? $row->phi10_l2c : null,
                ':phi30_l2c'        => isset($row->phi30_l2c) ? $row->phi30_l2c : null,
                ':phi60_l2c'        => isset($row->phi60_l2c) ? $row->phi60_l2c : null,
                ':avgccd_l2c'       => isset($row->avgccd_l2c) ? $row->avgccd_l2c : null,
                ':sigmaccd_l2c'     => isset($row->sigmaccd_l2c) ? $row->sigmaccd_l2c : null,
                ':locktime_l2c'     => isset($row->locktime_l2c) ? $row->locktime_l2c : null,
                ':avg_c_n0_l5'      => isset($row->avg_c_n0_l5) ? $row->avg_c_n0_l5 : null,
                ':totalS4_L5'       => isset($row->totalS4_L5) ? $row->totalS4_L5 : null,
                ':correctionS4_L5'  => isset($row->correctionS4_L5) ? $row->correctionS4_L5 : null,
                ':phi01_l5'         => isset($row->phi01_l5) ? $row->phi01_l5 : null,
                ':phi03_l5'         => isset($row->phi03_l5) ? $row->phi03_l5 : null,
                ':phi10_l5'         => isset($row->phi10_l5) ? $row->phi10_l5 : null,
                ':phi30_l5'         => isset($row->phi30_l5) ? $row->phi30_l5 : null,
                ':phi60_l5'         => isset($row->phi60_l5) ? $row->phi60_l5 : null,
                ':avgccd_l5'        => isset($row->avgccd_l5) ? $row->avgccd_l5 : null,
                ':sigmaccd_l5'      => isset($row->sigmaccd_l5) ? $row->sigmaccd_l5 : null,
                ':locktime_l5'      => isset($row->locktime_l5) ? $row->locktime_l5: null,
               ':tec45_2c'          => isset($row->tec45_2c) ? $row->tec45_2c : null,
                ':dtec60_45_2c'     => isset($row->dtec60_45_2c) ? $row->dtec60_45_2c : null,
                ':tec30_2c'         => isset($row->tec30_2c) ? $row->tec30_2c : null,
                ':dtec45_30_2c'     => isset($row->dtec45_30_2c) ? $row->dtec45_30_2c : null,
                ':tec15_2c'         => isset($row->tec15_2c) ? $row->tec15_2c : null,
                ':dtec30_15_2c'     => isset($row->dtec30_15_2c) ? $row->dtec30_15_2c : null,
                ':tec0_2c'          => isset($row->tec0_2c) ? $row->tec0_2c : null,
                ':dtec0_2c'         => isset($row->dtec0_2c) ? $row->dtec0_2c : null,
                ':modified'         => date('Y-m-d H:i:s')                        
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
                    //echo "\t".$outr[0]['err_message']."\n";
                    $nrowdupe++; ;          /// riga duplicata
                } else{
                    $nrowerr++;
//print_r($e);
//print_r($row); 
//$stmtr->debugDumpParams();die();
//die();
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
                "err_message" => "generic error insert class_novatel_gps"
            );
        }
        return $ret_val;
    } // function

    function getsvid($cn, $prn){
        foreach($this->listSvid as $ll){
            if ($ll["prn"] == $prn AND $ll["cid"] == $cn){
                return ($ll["svid"]);    
            }
        }        
        return 0;
    }
}
?>
