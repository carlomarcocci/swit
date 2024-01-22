<?php

class ais_rev_line {
/**
i * Classe per la gestione delle valutazioni manuali dei parametri iososferici letti manualmente dall'operatore
 */

    public $datetime;               /// datetime della misura
    public $foF2;                   /// codice 00 
    public $foF2_qual;               /// codice 00 due caratteri di commento
    public $foF2_desc;               /// codice 00 due caratteri di commento
    public $M3000F2;                /// codice 93
    public $M3000F2_qual;            /// codice 93 due caratteri di commento
    public $M3000F2_desc;            /// codice 93 due caratteri di commento
    public $MUF3000F2;              /// codiec 07
    public $MUF3000F2_qual;          /// codiec 07 due caratteri di commento
    public $MUF3000F2_desc;          /// codiec 07 due caratteri di commento
    public $foF1;                   /// codice 10
    public $foF1_qual;               /// codice 10 due caratteri di commento
    public $foF1_desc;               /// codice 10 due caratteri di commento
    public $MUF3000F1;              /// codice 17
    public $MUF3000F1_qual;          /// codice 17 due caratteri di commento
    public $MUF3000F1_desc;          /// codice 17 due caratteri di commento
    public $h_F2;                   /// codice 04
    public $h_F2_qual;               /// codice 04 due caratteri di commento
    public $h_F2_desc;               /// codice 04 due caratteri di commento
    public $h_F;                    /// codice 16
    public $h_F_qual;                /// codice 16 due caratteri di commento
    public $h_F_desc;                /// codice 16 due caratteri di commento
    public $h_E;                    /// codice 24
    public $h_E_qual;                /// codice 24 due caratteri di commento
    public $h_E_desc;                /// codice 24 due caratteri di commento
    public $foE;                    /// codice 20
    public $foE_qual;                /// codice 20 due caratteri di commento
    public $foE_desc;                /// codice 20 due caratteri di commento
    public $h_Es;                   /// codice 34
    public $h_Es_qual;               /// codice 34 due caratteri di commento
    public $h_Es_desc;               /// codice 34 due caratteri di commento
    public $foEs;                   /// codice 30
    public $foEs_qual;               /// codice 30 due caratteri di commento
    public $foEs_desc;               /// codice 30 due caratteri di commento
    public $fbEs;                   /// codice 32
    public $fbEs_qual;               /// codice 32 due caratteri di commento
    public $fbEs_desc;               /// codice 32 due caratteri di commento
    public $fmin;                   /// codice 42
    public $fmin_qual;               /// codice 42 due caratteri di commento
    public $fmin_desc;               /// codice 42 due caratteri di commento
    public $fxI;                    /// codice 51
    public $fxI_qual;                /// codice 51 due caratteri di commento
    public $fxI_desc;                /// codice 51 due caratteri di commento
    public $Type_Es;                /// codice 36

    function __construct($dt){
        $this -> datetime = $dt;
    }
} // end class ais_rev_line

class ais_rev_file {
/**
 * Classe per la gestione del file di letture manuali da ionogramma
 * 
 */
    public  $filename;              /// input file name 
    public  $fname;              /// input file name 
    public  $station;               /// nome della stazione
#    public  $datetime;              /// datetime della misura
    public  $dt;              /// datetime della misura
    public  $ais_line = array();
    public  $myconn;
    public  $host;
    public  $db;
    public $isPostgres;             /// true if pg
    public  $n_line = array();                      /// riga della tabella del db, chiave univoca (dt, SVID)

//new ais_rev_file($this->filename, $this->myconn, $this->codestation, $this->name.".".$this->extension, $this->datetime, $this->isPostgres, $this->db)
    function __construct($fn,$myc, $statio, $fname, $dt, $isPg, $db){
        $this -> filename   = $fn;
        $this -> myconn     = $myc;
        $this -> fname      = $fname;
        $this -> station    = $statio;
        $this -> dt         = $dt;
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
            while (!feof($fh)){
                // le righe dei file vecchi sono di lunghezza variabile, con queste due righe
                // diventano tutte di 75 caratteri e tolgo LF e CR
                $line = str_replace("\n", '', str_replace("\r", '', $line)); // remove new lines and carriage return
                $line = str_pad($line, 75);
                                                $yr = ((substr($line, 5,2) >60) ? '19' : '20').substr($line, 5,2);
                $dt_str = $yr."-".substr($line, 7,2)."-".substr($line, 9,2);
                $hour = (substr($line, 0,2) ==11) ? '0' : '12';
                try{
                    $nowdt = new DateTime($dt_str);
                    /// controllo sulla data della misura: se la differenza della data attuale da quella della riga 
                    /// precedente di piu di un giorno segnala l'errore
                    if (!isset($daybf)){
                        $daybf = $nowdt;
                    }
                    $interval = $nowdt->diff($daybf);
                    if ( abs($interval->days) > 31){
                        //echo "\tERROR_VALUE_DT line: ".$line;
                        echo "\tnow ".$nowdt->format('Y-m-d H:i:s')." last ".$daybf->format('Y-m-d H:i:s')." diffdays ".abs($interval->days)." line ".$linenum."\n";
                    } else{
                        /// la riga con problemi non viene inserita
                        for ($i = 13; $i <= 70; $i+=5){
                            $nowdt = new DateTime($dt_str." ".(($hour <= 9) ? '0' : ''). $hour.":00:00");
                            /// gestione della dat in localtime fino al 2002 incluso
                            if ($yr < 2003){
                                $dt = new DateTime($nowdt->format('Y-m-d H:i:s'));
                                $dt->sub(new DateInterval('PT1H'));
                                $now = $dt->format('Y-m-d H:i:s');
                            }else{
                                $dt = new DateTime($nowdt->format('Y-m-d H:i:s'), new DateTimeZone('UTC'));
                                $now = $dt->format('Y-m-d H:i:s');
                                //$now = $nowdt->format('Y-m-d H:i:s');
                            }

                            //echo $hour."\t".trim(substr($line, $i,3))." testo ".trim(substr($line, $i+3,2))." now ".$now."\n";
                            // se la riga esiste la popola nella sua parte, altrimeti la crea
                            if (!array_key_exists($now, $this -> n_line)) {
                                $this -> n_line[$now] = new ais_rev_line($now);
                            }
                            switch (substr($line, 11,2)) {
                                // foF2
                                case "00": 
                                    $this -> n_line[$now] -> foF2       = trim(substr($line, $i,3));
                                    $this -> n_line[$now] -> foF2_qual  = trim(substr($line, $i+3,1));
                                    if (($this -> n_line[$now] -> foF2_qual == '')){
                                         $this -> n_line[$now] -> foF2_qual = null;
                                    }
                                    $this -> n_line[$now] -> foF2_desc  = trim(substr($line, $i+4,1));
                                    if (($this -> n_line[$now] -> foF2_desc == '')){
                                         $this -> n_line[$now] -> foF2_desc = null;
                                    }                                    
                                    if (($this -> n_line[$now] -> foF2 == '')){
                                         $this -> n_line[$now] -> foF2 = null;
                                    } else{
                                         $this -> n_line[$now] -> foF2 = $this -> n_line[$now] -> foF2 * 0.1;
                                    }
                                break;
                                // M3000F2
                                case "03":
                                    $this -> n_line[$now] -> M3000F2        = trim(substr($line, $i,3));
                                    $this -> n_line[$now] -> M3000F2_qual   = trim(substr($line, $i+3,1));
                                    if (($this -> n_line[$now] -> M3000F2_qual == '')){
                                         $this -> n_line[$now] -> M3000F2_qual = null;
                                    }                                    
                                    $this -> n_line[$now] -> M3000F2_desc   = trim(substr($line, $i+4,1));
                                    if (($this -> n_line[$now] -> M3000F2_desc == '')){
                                         $this -> n_line[$now] -> M3000F2_desc = null;
                                    }                                    
                                    if (($this -> n_line[$now] -> M3000F2 == '')){
                                         $this -> n_line[$now] -> M3000F2 = null;
                                    } else{
                                         $this -> n_line[$now] -> M3000F2 =  $this -> n_line[$now] -> M3000F2 *0.01;
                                    }
                                break;
                                // MUF3000F2
                                case "07":
                                    $this -> n_line[$now] -> MUF3000F2      = trim(substr($line, $i,3));
                                    $this -> n_line[$now] -> MUF3000F2_qual = trim(substr($line, $i+3,1));
                                    if (($this -> n_line[$now] -> MUF3000F2_qual == '')){
                                         $this -> n_line[$now] -> MUF3000F2_qual = null;
                                    }                                    
                                    $this -> n_line[$now] -> MUF3000F2_desc = trim(substr($line, $i+4,1));
                                    if (($this -> n_line[$now] -> MUF3000F2_desc == '')){
                                         $this -> n_line[$now] -> MUF3000F2_desc = null;
                                    }                                    
                                    if (($this -> n_line[$now] -> MUF3000F2 == '')){
                                         $this -> n_line[$now] -> MUF3000F2 = null;
                                    } else{
                                        $this -> n_line[$now] -> MUF3000F2 = $this -> n_line[$now] -> MUF3000F2 *0.1;
                                    }
                                break;
                                // foF1
                                case "10":
                                    $this -> n_line[$now] -> foF1       = trim(substr($line, $i,3));
                                    $this -> n_line[$now] -> foF1_qual  = trim(substr($line, $i+3,1));
                                    if (($this -> n_line[$now] -> foF1_qual == '')){
                                         $this -> n_line[$now] -> foF1_qual = null;
                                    }                                    
                                    $this -> n_line[$now] -> foF1_desc  = trim(substr($line, $i+4,1));
                                    if (($this -> n_line[$now] -> foF1_desc == '')){
                                         $this -> n_line[$now] -> foF1_desc = null;
                                    }                                    
                                    if (($this -> n_line[$now] -> foF1 == '')){
                                         $this -> n_line[$now] -> foF1 = null;
                                    } else{
                                        $this -> n_line[$now] -> foF1 = $this -> n_line[$now] -> foF1 *0.01;
                                    }
                                break;
                                // MUF3000F1
                                case "17":
                                    $this -> n_line[$now] -> MUF3000F1      = trim(substr($line, $i,3));
                                    $this -> n_line[$now] -> MUF3000F1_qual = trim(substr($line, $i+3,1));
                                    if (($this -> n_line[$now] -> MUF3000F1_qual == '')){
                                         $this -> n_line[$now] -> MUF3000F1_qual = null;
                                    }                                    
                                    $this -> n_line[$now] -> MUF3000F1_desc = trim(substr($line, $i+4,1));
                                    if (($this -> n_line[$now] -> MUF3000F1_desc == '')){
                                         $this -> n_line[$now] -> MUF3000F1_desc = null;
                                    }                                    
                                    if (($this -> n_line[$now] -> MUF3000F1 == '')){
                                         $this -> n_line[$now] -> MUF3000F1 = null;
                                    } else{
                                        $this -> n_line[$now] -> MUF3000F1 = $this -> n_line[$now] -> MUF3000F1 *0.1;
                                    }
                                break;
                                // h_F2
                                case "04":
                                    $this -> n_line[$now] -> h_F2     = trim(substr($line, $i,3));
                                    $this -> n_line[$now] -> h_F2_qual = trim(substr($line, $i+3,1));
                                    if (($this -> n_line[$now] -> h_F2_qual == '')){
                                         $this -> n_line[$now] -> h_F2_qual = null;
                                    }                                    
                                    $this -> n_line[$now] -> h_F2_desc = trim(substr($line, $i+4,1));
                                    if (($this -> n_line[$now] -> h_F2_desc == '')){
                                         $this -> n_line[$now] -> h_F2_desc = null;
                                    }                                    
                                    if (($this -> n_line[$now] -> h_F2 == '')){
                                         $this -> n_line[$now] -> h_F2 = null;
                                    }
                                break;
                                // h_F
                                case "16":
                                    $this -> n_line[$now] -> h_F        = trim(substr($line, $i,3));
                                    $this -> n_line[$now] -> h_F_qual   = trim(substr($line, $i+3,1));
                                    if (($this -> n_line[$now] -> h_F_qual == '')){
                                         $this -> n_line[$now] -> h_F_qual = null;
                                    }                                    
                                    $this -> n_line[$now] -> h_F_desc   = trim(substr($line, $i+4,1));
                                    if (($this -> n_line[$now] -> h_F_desc == '')){
                                         $this -> n_line[$now] -> h_F_desc = null;
                                    }                                    
                                    if (($this -> n_line[$now] -> h_F == '')){
                                         $this -> n_line[$now] -> h_F = null;
                                    }
                                break;
                                // h_E
                                case "24":
                                    $this -> n_line[$now] -> h_E        = trim(substr($line, $i,3));
                                    $this -> n_line[$now] -> h_E_qual   = trim(substr($line, $i+3,1));
                                    if (($this -> n_line[$now] -> h_E_qual == '')){
                                         $this -> n_line[$now] -> h_E_qual = null;
                                    }                                    
                                    $this -> n_line[$now] -> h_E_desc   = trim(substr($line, $i+4,1));
                                    if (($this -> n_line[$now] -> h_E_desc == '')){
                                         $this -> n_line[$now] -> h_E_desc = null;
                                    }                                    
                                    if (($this -> n_line[$now] -> h_E == '')){
                                         $this -> n_line[$now] -> h_E = null;
                                    }
                                break;
                                // foE
                                case "20":
                                    $this -> n_line[$now] -> foE        = trim(substr($line, $i,3));
                                    $this -> n_line[$now] -> foE_qual   = trim(substr($line, $i+3,1));
                                    if (($this -> n_line[$now] -> foE_qual == '')){
                                         $this -> n_line[$now] -> foE_qual = null;
                                    }                                    
                                    $this -> n_line[$now] -> foE_desc   = trim(substr($line, $i+4,1));
                                    if (($this -> n_line[$now] -> foE_desc == '')){
                                         $this -> n_line[$now] -> foE_desc = null;
                                    }                                    
                                    if (($this -> n_line[$now] -> foE == '')){
                                         $this -> n_line[$now] -> foE = null;
                                    } else{
                                        $this -> n_line[$now] -> foE = $this -> n_line[$now] -> foE * 0.01;
                                    }
                                break;
                                // h_Es
                                case "34":
                                    $this -> n_line[$now] -> h_Es     = trim(substr($line, $i,3));
                                    $this -> n_line[$now] -> h_Es_qual = trim(substr($line, $i+3,1));
                                    if (($this -> n_line[$now] -> h_Es_qual == '')){
                                         $this -> n_line[$now] -> h_Es_qual = null;
                                    }                                    
                                    $this -> n_line[$now] -> h_Es_desc = trim(substr($line, $i+4,1));
                                    if (($this -> n_line[$now] -> h_Es_desc == '')){
                                         $this -> n_line[$now] -> h_Es_desc = null;
                                    }                                    
                                    if (($this -> n_line[$now] -> h_Es == '')){
                                         $this -> n_line[$now] -> h_Es = null;
                                    }
                                break;
                                // foEs
                                case "30":
                                    $this -> n_line[$now] -> foEs       = trim(substr($line, $i,3));
                                    $this -> n_line[$now] -> foEs_qual  = trim(substr($line, $i+3,1));
                                    if (($this -> n_line[$now] -> foEs_qual == '')){
                                         $this -> n_line[$now] -> foEs_qual = null;
                                    }                                    
                                    $this -> n_line[$now] -> foEs_desc  = trim(substr($line, $i+4,1));
                                    if (($this -> n_line[$now] -> foEs_desc == '')){
                                         $this -> n_line[$now] -> foEs_desc = null;
                                    }                                    
                                    if (($this -> n_line[$now] -> foEs == '')){
                                         $this -> n_line[$now] -> foEs = null;
                                    } else{
                                        $this -> n_line[$now] -> foEs =$this -> n_line[$now] -> foEs =$this -> n_line[$now] -> foEs *0.1;
                                    }
                                break;
                                // fbEs
                                case "32":
                                    $this -> n_line[$now] -> fbEs       = trim(substr($line, $i,3));
                                    $this -> n_line[$now] -> fbEs_qual  = trim(substr($line, $i+3,1));
                                    if (($this -> n_line[$now] -> fbEs_qual == '')){
                                         $this -> n_line[$now] -> fbEs_qual = null;
                                    }                                    
                                    $this -> n_line[$now] -> fbEs_desc  = trim(substr($line, $i+4,1));
                                    if (($this -> n_line[$now] -> fbEs_desc == '')){
                                         $this -> n_line[$now] -> fbEs_desc = null;
                                    }                                    
                                    if (($this -> n_line[$now] -> fbEs == '')){
                                         $this -> n_line[$now] -> fbEs = null;
                                    } else{
                                        $this -> n_line[$now] -> fbEs = $this -> n_line[$now] -> fbEs *0.1;
                                    }
                                break;
                                // fmin
                                case "42":
                                    $this -> n_line[$now] -> fmin       = trim(substr($line, $i,3));
                                    $this -> n_line[$now] -> fmin_qual  = trim(substr($line, $i+3,1));
                                    if (($this -> n_line[$now] -> fmin_qual == '')){
                                         $this -> n_line[$now] -> fmin_qual = null;
                                    }                                    
                                    $this -> n_line[$now] -> fmin_desc  = trim(substr($line, $i+4,1));
                                    if (($this -> n_line[$now] -> fmin_desc == '')){
                                         $this -> n_line[$now] -> fmin_desc = null;
                                    }                                    
                                    if (($this -> n_line[$now] -> fmin == '')){
                                        $this -> n_line[$now] -> fmin = null;
                                    } else{
                                        $this -> n_line[$now] -> fmin = $this -> n_line[$now] -> fmin *0.1;
                                    }
                                break;
                                // fxI
                                case "51":
                                    $this -> n_line[$now] -> fxI        = trim(substr($line, $i,3));
                                    $this -> n_line[$now] -> fxI_qual   = trim(substr($line, $i+3,1));
                                    if (($this -> n_line[$now] -> fxI_qual == '')){
                                         $this -> n_line[$now] -> fxI_qual = null;
                                    }                                    
                                    $this -> n_line[$now] -> fxI_desc   = trim(substr($line, $i+4,1));
                                    if (($this -> n_line[$now] -> fxI_desc == '')){
                                         $this -> n_line[$now] -> fxI_desc = null;
                                    }                                    
                                    if (($this -> n_line[$now] -> fxI == '')){
                                        $this -> n_line[$now] -> fxI = null;
                                    } else{
                                        $this -> n_line[$now] -> fxI = $this -> n_line[$now] -> fxI *0.1;
                                    }
                                break;
                                // Type_Es
                                case "36":
                                    $this -> n_line[$now] -> Type_Es        = trim(substr($line, $i,5));
                                    if (($this -> n_line[$now] -> Type_Es == '')){
                                         $this -> n_line[$now] -> Type_Es = null;
                                    }
                                break;
                            }
                            $hour+=1;
                        }
                        //$daybf = new DateTime($nowdt->format('Y-m-d H:i:s'), new DateTimeZone('UTC'));
                        $daybf = $nowdt;
                    } // else di data errata
                } catch (Exception $e) {
                    echo "\tERROR_ON_DT ".$dt_str. " line: ".$line;
                }
                $line   = fgets($fh);
                $linenum++;
            } // end while 
            // finito di leggere il file
            fclose($fh);
            foreach ($this -> n_line as $row){
                if (    is_null($row -> foF2) AND
                                ($row -> foF2_qual == '') AND
                                ($row -> foF2_desc == '') AND
                        is_null($row -> M3000F2) AND
                                ($row -> M3000F2_qual == '') AND
                                ($row -> M3000F2_desc == '') AND
                        is_null($row -> MUF3000F2) AND
                                ($row -> MUF3000F2_qual == '') AND
                                ($row -> MUF3000F2_desc == '') AND
                        is_null($row -> foF1) AND
                                ($row -> foF1_qual == '') AND
                                ($row -> foF1_desc == '') AND
                        is_null($row -> MUF3000F1) AND
                                ($row -> MUF3000F1_qual == '') AND
                                ($row -> MUF3000F1_desc == '') AND
                        is_null($row -> h_F2) AND
                                ($row -> h_F2_qual == '') AND
                                ($row -> h_F2_desc == '') AND
                        is_null($row -> h_F) AND
                                ($row -> h_F_qual == '') AND
                                ($row -> h_F_desc == '') AND
                        is_null($row -> h_E) AND
                                ($row -> h_E_qual == '') AND
                                ($row -> h_E_desc == '') AND
                        is_null($row -> foE) AND
                                ($row -> foE_qual == '') AND
                                ($row -> foE_desc == '') AND
                        is_null($row -> h_Es) AND
                                ($row -> h_Es_qual == '') AND
                                ($row -> h_Es_desc == '') AND
                        is_null($row -> foEs) AND
                                ($row -> foEs_qual == '') AND
                                ($row -> foEs_desc == '') AND
                        is_null($row -> fbEs) AND
                                ($row -> fbEs_qual == '') AND
                                ($row -> fbEs_desc == '') AND
                        is_null($row -> fmin) AND
                                ($row -> fmin_qual == '') AND
                                ($row -> fmin_desc == '') AND
                        is_null($row -> fxI) AND
                                ($row -> fxI_qual == '') AND
                                ($row -> fxI_desc == '') AND
                        is_null($row -> Type_Es)
                    ) 
                {
//echo "\n rimossa ".$row -> datetime."\n";
/*
                printf("%s%b", "_",         (is_null($row -> foF2) ),"\n");
                printf("%s%b", "_",         ($row ->        foF2_qual == ''),"\n");
                printf("%s%b", "_",        ($row ->         foF2_desc == ''),"\n");
                printf("%s%b", "_",        is_null($row ->  M3000F2),"\n");
                printf("%s%b", "_",                ($row -> M3000F2_qual == ''),"\n");
                printf("%s%b", "_",                ($row -> M3000F2_desc == ''),"\n");
                      printf("%s%b", "_",          is_null($row -> MUF3000F2),"\n");
                      printf("%s%b", "m300qual_",          ($row ->     MUF3000F2_qual == ''),"\n");
                      printf("%s%b", "_",          ($row ->     MUF3000F2_desc == ''),"\n");
                      printf("%s%b", "_",          is_null($row -> foF1) ,"\n");
                      printf("%s%b", "_",          ($row -> foF1_qual == '') ,"\n");
                      printf("%s%b", "_",          ($row -> foF1_desc == '') ,"\n");
                      printf("%s%b", "_",          is_null($row -> MUF3000F1) ,"\n");
                      printf("%s%b", "_",          ($row -> MUF3000F1_qual == '') ,"\n");
                      printf("%s%b", "_",          ($row -> MUF3000F1_desc == '') ,"\n");
                      printf("%s%b", "_",          is_null($row -> h_F2) ,"\n");
                      printf("%s%b", "_",          ($row -> h_F2_qual == '') ,"\n");
                      printf("%s%b", "_",          ($row -> h_F2_desc == '') ,"\n");
                      printf("%s%b", "_",          is_null($row -> h_F) ,"\n");
                      printf("%s%b", "_",          ($row -> h_F_qual == '') ,"\n");
                      printf("%s%b", "_",          ($row -> h_F_desc == '') ,"\n");
                      printf("%s%b", "_",          is_null($row -> h_E) ,"\n");
                      printf("%s%b", "_",          ($row -> h_E_qual == '') ,"\n");
                      printf("%s%b", "_",          ($row -> h_E_desc == '') ,"\n");
                      printf("%s%b", "_",          is_null($row -> foE) ,"\n");
                      printf("%s%b", "_",          ($row -> foE_qual == '') ,"\n");
                      printf("%s%b", "_",          ($row -> foE_desc == '') ,"\n");
                      printf("%s%b", "_",          is_null($row -> h_Es) ,"\n");
                      printf("%s%b", "_",          ($row -> h_Es_qual == '') ,"\n");
                      printf("%s%b", "_",          ($row -> h_Es_desc == '') ,"\n");
                      printf("%s%b", "_",          is_null($row -> foEs) ,"\n");
                      printf("%s%b", "_",          ($row -> foEs_qual == '') ,"\n");
                      printf("%s%b", "_",          ($row -> foEs_desc == '') ,"\n");
                      printf("%s%b", "_",          is_null($row -> fbEs) ,"\n");
                      printf("%s%b", "_",          ($row -> fbEs_qual == '') ,"\n");
                      printf("%s%b", "_",          ($row -> fbEs_desc == '') ,"\n");
                      printf("%s%b", "_",          is_null($row -> fmin) ,"\n");
                      printf("%s%b", "_",          ($row -> fmin_qual == '') ,"\n");
                      printf("%s%b", "_",          ($row -> fmin_desc == '') ,"\n");
                      printf("%s%b", "_",          is_null($row -> fxI) ,"\n");
                      printf("%s%b", "_",          ($row -> fxI_qual == '') ,"\n");
                      printf("%s%b", "_",          ($row -> fxI_desc == '') ,"\n");
                      printf("%s%b", "_",          is_null($row -> Type_Es) ,"\n");
*/                    
                    unset($this -> n_line[$row -> datetime]);
                }
                       
                        
            } // foreach
        } else{
            $out = array(
                "err_code" => -1,
                "err_message" => "Can't open file"
            );
        } // di fileopen
//print_r($this); //die();
        return $out;
    } // end function

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
                    ':tablename'    => strval($this -> station)."_rev"
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
//print_r($this);die();
        // se la rabella di stazione non esiste va creata
        if ($out[0]['ntab'] == 0) {
           // creazione tabella 
            $sqlf   = createAisRevTable($this->station, $this->isPostgres);
            try{
                $stmt = $this->myconn->conn->prepare($sqlf);
                $stmt->execute(); 
//                $out = $stmt->fetchAll();
            }
            catch (PDOException $e){
                //$stmt->debugDumpParams();
                $ret_val = array(
                    "err_code" => -1,
                    "err_message" => $e->getMessage()
                );
                return $ret_val;
            }
        }
        //  qui la tabella esiste 
        $nrow       = 0;
        $nrowok     = 0;
        $nrowdupe   = 0;
        $sqlr = " INSERT INTO ". $this -> station. "_rev (".
                    "dt,".
                    "fof2,".
                    "fof2_qual,".
                    "fof2_desc,".
                    "m3000f2,".
                    "m3000f2_qual,".
                    "m3000f2_desc,".
                    "muf3000f2,".
                    "muf3000f2_qual,".
                    "muf3000f2_desc,".
                    "fof1,".
                    "fof1_qual,".
                    "fof1_desc,".
                    "muf3000f1,".
                    "muf3000f1_qual,".
                    "muf3000f1_desc,".
                    "h_f2,".
                    "h_f2_qual,".
                    "h_f2_desc,".
                    "h_f,".
                    "h_f_qual,".
                    "h_f_desc,".
                    "h_e,".
                    "h_e_qual,".
                    "h_e_desc,".
                    "foe,".
                    "foe_qual,".
                    "foe_desc,".
                    "h_es,".
                    "h_es_qual,".
                    "h_es_desc,".
                    "foes,".
                    "foes_qual,".
                    "foes_desc,".
                    "fbes,".
                    "fbes_qual,".
                    "fbes_desc,".
                    "fmin,".
                    "fmin_qual,".
                    "fmin_desc,".
                    "fxi,".
                    "fxi_qual,".
                    "fxi_desc,".
                    "type_es,".
                    "modified)".
                " VALUES(".
                    ":dt,".
                    ":fof2,".
                    ":fof2_qual,".
                    ":fof2_desc,".
                    ":m3000f2,".
                    ":m3000f2_qual,".
                    ":m3000f2_desc,".
                    ":muf3000f2,".
                    ":muf3000f2_qual,".
                    ":muf3000f2_desc,".
                    ":fof1,".
                    ":fof1_qual,".
                    ":fof1_desc,".
                    ":muf3000f1,".
                    ":muf3000f1_qual,".
                    ":muf3000f1_desc,".
                    ":h_f2,".
                    ":h_f2_qual,".
                    ":h_f2_desc,".
                    ":h_f,".
                    ":h_f_qual,".
                    ":h_f_desc,".
                    ":h_e,".
                    ":h_e_qual,".
                    ":h_e_desc,".
                    ":foe,".
                    ":foe_qual,".
                    ":foe_desc,".
                    ":h_es,".
                    ":h_es_qual,".
                    ":h_es_desc,".
                    ":foes,".
                    ":foes_qual,".
                    ":foes_desc,".
                    ":fbes,".
                    ":fbes_qual,".
                    ":fbes_desc,".
                    ":fmin,".
                    ":fmin_qual,".
                    ":fmin_desc,".
                    ":fxi,".
                    ":fxi_qual,".
                    ":fxi_desc,".
                    ":type_es,".
                    ":modified);";

        $nrowerr    = 0;
        foreach ($this -> n_line as $row) {
            $nrow++;
            try{
                $stmtr = $this->myconn->conn->prepare($sqlr);
                $arrar = array(
                    ':dt'               => $row -> datetime,
                    ':fof2'             => $row -> foF2,
                    ':fof2_qual'        => $row -> foF2_qual,
                    ':fof2_desc'        => $row -> foF2_desc,
                    ':m3000f2'          => $row -> M3000F2,
                    ':m3000f2_qual'     => $row -> M3000F2_qual,
                    ':m3000f2_desc'     => $row -> M3000F2_desc,
                    ':muf3000f2'        => $row -> MUF3000F2,
                    ':muf3000f2_qual'   => $row -> MUF3000F2_qual,
                    ':muf3000f2_desc'   => $row -> MUF3000F2_desc,
                    ':fof1'             => $row -> foF1,
                    ':fof1_qual'        => $row -> foF1_qual,
                    ':fof1_desc'        => $row -> foF1_desc,
                    ':muf3000f1'        => $row -> MUF3000F1,
                    ':muf3000f1_qual'   => $row -> MUF3000F1_qual,
                    ':muf3000f1_desc'   => $row -> MUF3000F1_desc,
                    ':h_f2'             => $row -> h_F2,
                    ':h_f2_qual'        => $row -> h_F2_qual,
                    ':h_f2_desc'        => $row -> h_F2_desc,
                    ':h_f'              => $row -> h_F,
                    ':h_f_qual'         => $row -> h_F_qual,
                    ':h_f_desc'         => $row -> h_F_desc,
                    ':h_e'              => $row -> h_E,
                    ':h_e_qual'         => $row -> h_E_qual,
                    ':h_e_desc'         => $row -> h_E_desc,
                    ':foe'              => $row -> foE,
                    ':foe_qual'         => $row -> foE_qual,
                    ':foe_desc'         => $row -> foE_desc,
                    ':h_es'             => $row -> h_Es,
                    ':h_es_qual'        => $row -> h_Es_qual,
                    ':h_es_desc'        => $row -> h_Es_desc,
                    ':foes'             => $row -> foEs,
                    ':foes_qual'        => $row -> foEs_qual,
                    ':foes_desc'        => $row -> foEs_desc,
                    ':fbes'             => $row -> fbEs,
                    ':fbes_qual'        => $row -> fbEs_qual,
                    ':fbes_desc'        => $row -> fbEs_desc,
                    ':fmin'             => $row -> fmin,
                    ':fmin_qual'        => $row -> fmin_qual,
                    ':fmin_desc'        => $row -> fmin_desc,
                    ':fxi'              => $row -> fxI,
                    ':fxi_qual'         => $row -> fxI_qual,
                    ':fxi_desc'         => $row -> fxI_desc,
                    ':type_es'          => $row -> Type_Es,
                    ':modified'         => date('Y-m-d H:i:s')
                    );
                $stmtr->execute($arrar);
                //$outr = $stmtr -> fetchAll();
            }
            catch (PDOException $e){
                // riga duplicata
                //if ($e->errorInfo[0] == '23000'){
                if ($e->errorInfo[0] == '23505'){
                    $nrowdupe++;
                    $nrowok--;
                }else{
                    $ret_val = array(
                        "err_code" => -1,
                        "err_message" => $e->getMessage()
                    );
                    //$stmtr->debugDumpParams();
                    $nrowerr++; /// errore nell'insert della riga
                    //return $ret_val;
                    fn_debug_query_e($sql, $appo, $outapp, $e);
                }
            }
            $stmtr->closeCursor();
            // riga inserita correttamente o riga duplicata
            $nrowok++;
        } // foreach
        if ($nrow == $nrowok){
            $ret_val = array(
                "err_code" => 0,
                "err_message" => "OK_LOADED nrows ".$nrowok." ".$this->station
            );
        } elseif ($nrow == ($nrowok + $nrowdupe)){
            $ret_val = array(
                "err_code" => 1,
                "err_message" => "OK_DUPE tot: ".strval($nrow)." dup: ".strval($nrowdupe)."\t".$this->station
            );
        } else {
            $ret_val = array(
                "err_code" => 2,
                "err_message" => "generic error insert class_ais_measure_rev"
            );
        }
        return $ret_val;
    } // function
}

?>
