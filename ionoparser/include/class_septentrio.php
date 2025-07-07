<?php

class septentrio_line {
/**
 * Classe per la gestione delle misurazione dei septemptrio multicostellazione
 * gps della Novatel, file REDOBS
 */

    public $inputstr;              /// stringa passata in input e contentente una riga del file
    public $datetime;              /// datetime della misura
    
//  Week, GPS TOW ,PRN, RxStatus,   Az  ,  Elv ,L1 CNo, S4 , S4 Cor,1SecSigma,3SecSigma,10SecSigma,30SecSigma,60SecSigma, Code-Carrier, C-CStdev, TEC45, TECRate45, TEC30, TECRate30, TEC15, TECRate15, TEC0, TECRate0,L1 LockTime,ChanStatus,L2 LockTime, L2 CNo
//  GPS TOW, PRN, Freq, SigType, Az , Elv , CNo , Lock Time, CMC Avg, CMC Std , S4 , S4 Cor, 1SecSigma, 3SecSigma, 10SecSigma, 30SecSigma, 60SecSigma 
//  GPS TOW, PRN, Freq, PrimSig, SecSig, Azimuth, Elev, SecSig Lock Time, SecSig CNo,TEC15, TECRate15, TEC30, TECRate30, TEC45, TECRate45, TECTOW, TECRateTOW

// WN                     Col 
// TOW                    Col 2.
    public $SVID;       //  Col 3.
    public $RxState;     //           Col 4.
    public $azimuth;      //          Col 5.
    public $elevation;      //              Col 6.
    public $averageL1;      //              Col 7.
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
    public $locktimeL1;      //             Col 25.
    public $reserved;      //               Col 26.
    public $asecondlocktime;      //            Col 27.
    public $avgcn2freqTEC;      //          Col 28.
    public $SI_L1_29;      //               Col 29.
    public $SI_L1_30;      //               Col 30.
    public $pL1;      //                    Col 31.
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
    public $SI_L2C_43;      //              Col 43. 
    public $SI_L2C_44;      //              Col 44. 
    public $p_l2c;      //                  Col 45. 
    public $avg_c_n0_l5;      //            Col 46. 
    public $totalS4_L5;      //             Col 47. 
    public $correctionS4_L5;      //        Col 48. 
    public $phi01_l5;      //               Col 49. 
    public $phi03_l5;      //               Col 50. 
    public $phi10_l5 ;      //              Col 51. 
    public $phi30_l5;      //               Col 52. 
    public $phi60_l5;      //               Col 53. 
    public $avgccd_l5;      //              Col 54. 
    public $igmaccd_l5;      //            Col 55. 
    public $locktime_l5;      //            Col 56. 
    public $SI_L5_57;      //               Col 57. 
    public $SI_L5_58;      //               Col 58. 
    public $p_l5;      //                   Col 59. 
    public $t_l1;      //                   Col 60. 
    public $t_l2c;      //                  Col 61. 
    public $t_l5;      //                   Col 62. 

    function __construct($str){
        $this -> inputstr = $str;
        /// load array with values in csv format
        $dataline = str_getcsv(str_replace(' ', '', $str));
        $dataline = array_map('trim', $dataline);
        /// load member from array
        $this -> datetime          = fn_weektow2datetimeNom($dataline[0], $dataline[1]);
        $this -> SVID              = $dataline[2];
        $this -> RxState           = ($dataline[3]=='' || $dataline[3]=='nan')  ? NULL : $dataline[3];
        $this -> azimuth           = ($dataline[4]=='' || $dataline[4]=='nan')  ? NULL : $dataline[4];
        $this -> elevation         = ($dataline[5]=='' || $dataline[5]=='nan')  ? NULL : $dataline[5];
        $this -> averageL1         = ($dataline[6]=='' || $dataline[6]=='nan')  ? NULL : $dataline[6];
        $this -> totalS4L1         = ($dataline[7]=='' || $dataline[7]=='nan')  ? NULL : $dataline[7];
        $this -> correctionS4L1    = ($dataline[8]=='' || $dataline[8]=='nan')  ? NULL : $dataline[8];
        $this -> phi01l1           = ($dataline[8]=='' || $dataline[9]=='nan')  ? NULL : $dataline[9];
        $this -> phi03l1           = ($dataline[10]=='' || $dataline[10]=='nan')  ? NULL : $dataline[10];
        $this -> phi10l1           = ($dataline[11]=='' || $dataline[11]=='nan')  ? NULL : $dataline[11];
        $this -> phi30l1           = ($dataline[12]=='' || $dataline[12]=='nan')  ? NULL : $dataline[12];
        $this -> phi60l1slant      = ($dataline[15]=='' || $dataline[13]=='nan')  ? NULL : $dataline[13];
        $this -> avgCCDL1          = ($dataline[14]=='' || $dataline[14]=='nan')  ? NULL : $dataline[14];
        $this -> sigmaCCDL1        = ($dataline[15]=='' || $dataline[15]=='nan')  ? NULL : $dataline[15];
        $this -> tec45             = ($dataline[16]=='' || $dataline[16]=='nan')  ? NULL : $dataline[16];
        $this -> dtec60_45         = ($dataline[17]=='' || $dataline[17]=='nan')  ? NULL : $dataline[17];
        $this -> tec30             = ($dataline[18]=='' || $dataline[18]=='nan')  ? NULL : $dataline[18];
        $this -> dtec45_30         = ($dataline[19]=='' || $dataline[19]=='nan')  ? NULL : $dataline[19];
        $this -> tec15             = ($dataline[20]=='' || $dataline[20]=='nan')  ? NULL : $dataline[20];
        $this -> dtec30_15         = ($dataline[21]=='' || $dataline[21]=='nan')  ? NULL : $dataline[21];
        $this -> tec0              = ($dataline[22]=='' || $dataline[22]=='nan')  ? NULL : $dataline[22];
        $this -> dtec0             = ($dataline[23]=='' || $dataline[23]=='nan')  ? NULL : $dataline[23];
        $this -> locktimeL1        = ($dataline[24]=='' || $dataline[24]=='nan')  ? NULL : $dataline[24];
        $this -> reserved          = ($dataline[25]=='' || $dataline[25]=='nan')  ? NULL : $dataline[25];
        $this -> asecondlocktime   = ($dataline[26]=='' || $dataline[26]=='nan')  ? NULL : $dataline[26];
        $this -> avgcn2freqTEC     = ($dataline[27]=='' || $dataline[27]=='nan')  ? NULL : $dataline[27];
        $this -> SI_L1_29          = ($dataline[28]=='' || $dataline[28]=='nan')  ? NULL : $dataline[28];
        $this -> SI_L1_30          = ($dataline[29]=='' || $dataline[29]=='nan')  ? NULL : $dataline[29];
        $this -> pL1               = ($dataline[30]=='' || $dataline[30]=='nan')  ? NULL : $dataline[30];
        $this -> avg_c_n0_l2c      = ($dataline[31]=='' || $dataline[31]=='nan')  ? NULL : $dataline[31];
        $this -> totalS4_L2C       = ($dataline[32]=='' || $dataline[32]=='nan')  ? NULL : $dataline[32];
        $this -> correctionS4_L2C  = ($dataline[33]=='' || $dataline[33]=='nan')  ? NULL : $dataline[33];
        $this -> phi01_l2c         = ($dataline[34]=='' || $dataline[34]=='nan')  ? NULL : $dataline[34];
        $this -> phi03_l2c         = ($dataline[35]=='' || $dataline[35]=='nan')  ? NULL : $dataline[35];
        $this -> phi10_l2c         = ($dataline[36]=='' || $dataline[36]=='nan')  ? NULL : $dataline[36];
        $this -> phi30_l2c         = ($dataline[37]=='' || $dataline[37]=='nan')  ? NULL : $dataline[37];
        $this -> phi60_l2c         = ($dataline[38]=='' || $dataline[38]=='nan')  ? NULL : $dataline[38];
        $this -> avgccd_l2c        = ($dataline[39]=='' || $dataline[39]=='nan')  ? NULL : $dataline[39];
        $this -> sigmaccd_l2c      = ($dataline[40]=='' || $dataline[40]=='nan')  ? NULL : $dataline[40];
        $this -> locktime_l2c      = ($dataline[41]=='' || $dataline[41]=='nan')  ? NULL : $dataline[41];
        $this -> SI_L2C_43         = ($dataline[41]=='' || $dataline[42]=='nan')  ? NULL : $dataline[42];
        $this -> SI_L2C_44         = ($dataline[43]=='' || $dataline[43]=='nan')  ? NULL : $dataline[43];
        $this -> p_l2c             = ($dataline[44]=='' || $dataline[44]=='nan')  ? NULL : $dataline[44];
        $this -> avg_c_n0_l5       = ($dataline[45]=='' || $dataline[45]=='nan')  ? NULL : $dataline[45];
        $this -> totalS4_L5        = ($dataline[46]=='' || $dataline[46]=='nan')  ? NULL : $dataline[46];
        $this -> correctionS4_L5   = ($dataline[47]=='' || $dataline[47]=='nan')  ? NULL : $dataline[47];
        $this -> phi01_l5          = ($dataline[48]=='' || $dataline[48]=='nan')  ? NULL : $dataline[48];
        $this -> phi03_l5          = ($dataline[49]=='' || $dataline[49]=='nan')  ? NULL : $dataline[49];
        $this -> phi10_l5          = ($dataline[50]=='' || $dataline[50]=='nan')  ? NULL : $dataline[50];
        $this -> phi30_l5          = ($dataline[51]=='' || $dataline[51]=='nan')  ? NULL : $dataline[51];
        $this -> phi60_l5          = ($dataline[52]=='' || $dataline[52]=='nan')  ? NULL : $dataline[52];
        $this -> avgccd_l5         = ($dataline[53]=='' || $dataline[53]=='nan')  ? NULL : $dataline[53];
        $this -> sigmaccd_l5       = ($dataline[54]=='' || $dataline[54]=='nan')  ? NULL : $dataline[54];
        $this -> locktime_l5       = ($dataline[55]=='' || $dataline[55]=='nan')  ? NULL : $dataline[55];
        $this -> SI_L5_57          = ($dataline[56]=='' || $dataline[56]=='nan')  ? NULL : $dataline[56];
        $this -> SI_L5_58          = ($dataline[57]=='' || $dataline[57]=='nan')  ? NULL : $dataline[57];
        $this -> p_l5              = ($dataline[58]=='' || $dataline[58]=='nan')  ? NULL : $dataline[58];
        $this -> t_l1              = ($dataline[59]=='' || $dataline[59]=='nan')  ? NULL : $dataline[59];
        $this -> t_l2c             = ($dataline[60]=='' || $dataline[60]=='nan')  ? NULL : $dataline[60];
        $this -> t_l5              = ($dataline[61]=='' || $dataline[61]=='nan')  ? NULL : $dataline[61];
    } // function

    function print_row(){
        $row="";
        
        $row += ", " . $this -> l2_cno;
        return $row;
    }

} // class

class septentrio_file {
/**
 * Classe per la gestione delle misurazione degli acquisitori multicostellazione septentrio
 * 
 */

    public  $filename;              /// input file name 
    public  $fname;              /// input file name 
    public  $station;               /// nome della stazione
    public  $datetime;              /// datetime della misura
    public  $sept_line = array();
    public  $myconn;
    public  $host;
    public  $db;

// postgres
    public $isPostgres;             /// true if upe pg

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
     * Funzione che popola la classe leggendo il file ismr prodotti dai septemptrio
     * 
     */
        $out = array(
            "err_code" => "",
            "err_message" => ""
        );     
        $linenum = 0;
        if ($fh = fopen($this -> filename, 'r')) {
            // lettura dei dati
            $line   = fgets($fh); // legge la prima linea di dati
            while (!feof($fh) && (strlen($line) >10)){
                $this -> sept_line[$linenum] = new septentrio_line($line);
                $line   = fgets($fh);
                $linenum++;
            } // end while
            fclose($fh);
        } else{
            $out = array(
                "err_code" => -1,
                "err_message" => "Cant open file"
            );
        }
        return $out;
    } // end function
    
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
            echo "ERROR DB CONNECTION ";
            $stmt->closeCursor();
            $stmt = null;
            return ;
        }
        $stmt->closeCursor();
        $stmt = null;
        /// se la rabella di stazione non esiste va creata
        if ($out[0]['ntab'] == 0) {
            // il nome della tabella non puo essere passato col prepare cone variabile di pdo
            $sql = createSepentrioTable($this -> station, $this->isPostgres);
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
            $sql = createSepentrioView($this -> station, $this->isPostgres);
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
        
        // insert or update row
        
        $nrow       = 0;
        $nrowok     = 0;
        $nrowdupe   = 0;
        $nrowerr    = 0;
        foreach ($this -> sept_line as $row) {
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
                        "reserved,".
                        "secondlocktime,".
                        "avgcn2freqtec,".
                        "si_l1_29 ,".
                        "si_l1_30 ,".
                        "pl1 ,".
                        "avg_c_n0_l2c,".
                        "totals4_l2c,".
                        "corrections4_l2c,".
                        "phi01_l2c,".
                        "phi03_l2c,".
                        "phi10_l2c,".
                        "phi30_l2c,".
                        "phi60_l2c,".
                        "avgccd_l2c,".
                        "sigmaccd_l2c,".
                        "locktime_l2c,".
                        "si_l2c_43,".
                        "si_l2c_44,".
                        "p_l2c,".
                        "avg_c_n0_l5,".
                        "totals4_l5,".
                        "corrections4_l5,".
                        "phi01_l5,".
                        "phi03_l5,".
                        "phi10_l5,".
                        "phi30_l5,".
                        "phi60_l5,".
                        "avgccd_l5,".
                        "sigmaccd_l5,".
                        "locktime_l5,".
                        "si_l5_57     ,".
                        "si_l5_58,".
                        "p_l5,".
                        "t_l1,".
                        "t_l2c,".
                        "t_l5,".
                        "modified)            ".
                " VALUES (".
                        ":datetime,".
                        ":svid,".
                        ":rxstatus,".
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
                        ":reserved,".
                        ":asecondlocktime,".
                        ":avgcn2freqTEC,".
                        ":SI_L1_29,".
                        ":SI_L1_30,".
                        ":pL1,".
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
                        ":SI_L2C_43,".
                        ":SI_L2C_44,".
                        ":p_l2c,".
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
                        ":SI_L5_57,".
                        ":SI_L5_58,".
                        ":p_l5,".
                        ":t_l1,".
                        ":t_l2c,".
                        ":t_l5,".
                        ":modified)";
               $appor = array(
                    ':datetime'         => isset($row->datetime )           ? $row->datetime : null,
                    ':svid'             => isset($row->SVID )               ? $row->SVID : null,
                    ':rxstatus'         => isset($row->RxState )            ? $row->RxState : null,
                    ':az'               => isset($row->azimuth )            ? $row->azimuth : null,
                    ':elv'              => isset($row->elevation )          ? $row->elevation : null,
                    ':averageL1'        => isset($row->averageL1 )          ? $row->averageL1 : null,
                    ':totalS4L1'        => isset($row->totalS4L1 )          ? $row->totalS4L1 : null,
                    ':correctionS4L1'   => isset($row->correctionS4L1 )     ? $row->correctionS4L1 : null,
                    ':phi01l1'          => isset($row->phi01l1 )            ? $row->phi01l1 : null,
                    ':phi03l1'          => isset($row->phi03l1 )            ? $row->phi03l1 : null,
                    ':phi10l1'          => isset($row->phi10l1 )            ? $row->phi10l1 : null,
                    ':phi30l1'          => isset($row->phi30l1 )            ? $row->phi30l1 : null,
                    ':phi60l1slant'     => isset($row->phi60l1slant )       ? $row->phi60l1slant : null,
                    ':avgCCDL1'         => isset($row->avgCCDL1 )           ? $row->avgCCDL1 : null,
                    ':sigmaCCDL1'       => isset($row->sigmaCCDL1 )         ? $row->sigmaCCDL1 : null,
                    ':tec45'            => isset($row->tec45 )              ? $row->tec45 : null,
                    ':dtec60_45'        => isset($row->dtec60_45 )          ? $row->dtec60_45 : null,
                    ':tec30'            => isset($row->tec30 )              ? $row->tec30 : null,
                    ':dtec45_30'        => isset($row->dtec45_30 )          ? $row->dtec45_30 : null,
                    ':tec15'            => isset($row->tec15 )              ? $row->tec15 : null,
                    ':dtec30_15'        => isset($row-> dtec30_15)          ?  $row-> dtec30_15 : null,
                    ':tec0'             => isset($row-> tec0)               ? $row->tec0 : null,
                    ':dtec0'            => isset($row-> dtec0)              ? $row->dtec0 : null,
                    ':locktimeL1'       => isset($row->locktimeL1 )         ? $row->locktimeL1 : null,
                    ':reserved'         => isset($row->reserved )           ? $row->reserved : null,
                    ':asecondlocktime'  => isset($row->asecondlocktime )    ? $row->asecondlocktime : null,
                    ':avgcn2freqTEC'    => isset($row->avgcn2freqTEC )      ? $row->avgcn2freqTEC : null,
                    ':SI_L1_29'         => isset($row->SI_L1_29 )           ? $row->SI_L1_29 : null,
                    ':SI_L1_30'         => isset($row->SI_L1_30 )           ? $row->SI_L1_30 : null,
                    ':pL1'              => isset($row->pL1 )                ? $row->pL1 : null,
                    ':avg_c_n0_l2c'     => isset($row->avg_c_n0_l2c )       ? $row->avg_c_n0_l2c : null,
                    ':totalS4_L2C'      => isset($row->totalS4_L2C )        ? $row->totalS4_L2C : null,
                    ':correctionS4_L2C' => isset($row->correctionS4_L2C )   ? $row->correctionS4_L2C : null,
                    ':phi01_l2c'        => isset($row->phi01_l2c )          ? $row->phi01_l2c : null,
                    ':phi03_l2c'        => isset($row->phi03_l2c )          ? $row->phi03_l2c : null,
                    ':phi10_l2c'        => isset($row->phi10_l2c )          ? $row->phi10_l2c : null,
                    ':phi30_l2c'        => isset($row->phi30_l2c )          ? $row->phi30_l2c : null,
                    ':phi60_l2c'        => isset($row->phi60_l2c )          ? $row->phi60_l2c : null,
                    ':avgccd_l2c'       => isset($row->avgccd_l2c )         ? $row->avgccd_l2c : null,
                    ':sigmaccd_l2c'     => isset($row->sigmaccd_l2c )       ? $row->sigmaccd_l2c : null,
                    ':locktime_l2c'     => isset($row->locktime_l2c )       ? $row->locktime_l2c : null,
                    ':SI_L2C_43'        => isset($row->SI_L2C_43 )          ? $row->SI_L2C_43 : null,
                    ':SI_L2C_44'        => isset($row->SI_L2C_44 )          ? $row->SI_L2C_44 : null,
                    ':p_l2c'            => isset($row->p_l2c )              ? $row->p_l2c : null,
                    ':avg_c_n0_l5'      => isset($row->avg_c_n0_l5 )        ? $row->avg_c_n0_l5 : null,
                    ':totalS4_L5'       => isset($row->totalS4_L5 )         ? $row->totalS4_L5 : null,
                    ':correctionS4_L5'  => isset($row->correctionS4_L5 )    ? $row->correctionS4_L5 : null,
                    ':phi01_l5'         => isset($row->phi01_l5 )           ? $row->phi01_l5 : null,
                    ':phi03_l5'         => isset($row->phi03_l5 )           ? $row->phi03_l5 : null,
                    ':phi10_l5'         => isset($row->phi10_l5 )           ? $row->phi10_l5 : null,
                    ':phi30_l5'         => isset($row->phi30_l5 )           ? $row->phi30_l5 : null,
                    ':phi60_l5'         => isset($row->phi60_l5 )           ? $row->phi60_l5 : null,
                    ':avgccd_l5'        => isset($row->avgccd_l5 )          ? $row->avgccd_l5 : null,
                    ':sigmaccd_l5'      => isset($row->sigmaccd_l5 )        ? $row->sigmaccd_l5 : null,
                    ':locktime_l5'      => isset($row->locktime_l5 )        ? $row->locktime_l5 : null,
                    ':SI_L5_57'         => isset($row->SI_L5_57 )           ? $row->SI_L5_57 : null,
                    ':SI_L5_58'         => isset($row->SI_L5_58 )           ? $row->SI_L5_58 : null,
                    ':p_l5'             => isset($row->p_l5 )               ? $row->p_l5 : null,
                    ':t_l1'             => isset($row->t_l1 )               ? $row->t_l1 : null,
                    ':t_l2c'            => isset($row->t_l2c )              ? $row->t_l2c : null,
                    ':t_l5'             => isset($row->t_l5 )               ? $row->t_l5 : null,
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

}
?>
