<?php
/************************************************************************/
/**** Parsing binary file SBF from dps4d ****/

class dps4d_sbf_file
{
    public $filename;               /// input file name 
    public $station;                /// nome della stazione
    public $isPostgres;             /// true if upe pg
    public $db;                     /// database name

    public $station_code;           /// URSI code for station
    public $dt;                     /// datetime della misura
    
    public $RXid;
    public $TXid;
    public $start_f;
    public $coarse_step_f;
    public $stop_f;
    public $O_X_option;
    public $PulseRepRate;
    public $Range_start;
    public $Range_increment;
    public $Number_heights;
    public $number_range_bins;
    public $Base_gain;
    public $Const_gain;
    public $frequency_group_len;
    public $freq_group_number_per_block;
    public $json_content;


//    function __construct($fn,$myc, $statio, $fname, $isPg, $db){
    function __construct($fn, $myc, $statio, $fname, $dt, $isPg, $db){
        $this -> filename   = $fn;
        $this -> fname      = $fname;
        $this -> station    = $statio;
        $this -> myconn     = $myc;
        $this -> isPostgres = ($isPg == 'pg' ? 1 : 0);
        $this -> db         = $db;
//print_r($this); die();
    }

    function read_file(){
    /**
     * Read SBF file 
     */
        $out = array(
            "err_code" => "",
            "err_message" => "");
        if ($fn = file_get_contents($this->filename)) {
            $numero_blocchi = strlen($fn) / 4096;
            if ( strlen($fn) % 4096 != 0) {
                $out = array(
                    "err_code" => 2,
                    "err_message" => "File corrupted");
            }
            else {
                $block = 0;
/*                $ciccio[] = binCodDec(ord($fn[$block ]));
                $ciccio[] = binCodDec(ord($fn[$block +1 ]));
                $ciccio[] = binCodDec(ord($fn[$block +2 ]));
echo "\n__\n";
print_r($ciccio);die();*/
                $d_yy = binCodDec(ord($fn[$block + 3]));
                $d_mm = binCodDec(ord($fn[$block + 6]));
                $d_dd = binCodDec(ord($fn[$block + 7]));
                $d_hh = binCodDec(ord($fn[$block + 8]));
                $d_nn = binCodDec(ord($fn[$block + 9]));
                $d_ss = binCodDec(ord($fn[$block + 10]));
                
                $this -> dt =   "20".
                                ($d_yy < 10 ? '0' : ''). $d_yy."-".
                                ($d_mm < 10 ? '0' : ''). $d_mm."-".
                               ($d_dd < 10 ? '0' : ''). $d_dd." ".
                               ($d_hh < 10 ? '0' : ''). $d_hh.":".
                                ($d_nn < 10 ? '0' : ''). $d_nn.":".
                                ($d_ss < 10 ? '0' : ''). $d_ss;

                $this -> RXid = $fn[$block + 11] . $fn[$block + 12] . $fn[$block + 13];

                $this -> TXid = $fn[$block + 14] . $fn[$block + 15] . $fn[$block + 16];

                $this -> start_f = (10000 * binCodDec(ord($fn[$block + 19])) + 100 * binCodDec(ord($fn[$block + 20])) + binCodDec(ord($fn[$block + 21]))) / 10000.0;
                $this -> coarse_step_f = (100 * binCodDec(ord($fn[$block + 22])) + binCodDec(ord($fn[$block + 23]))) / 1000.0;
                $this -> stop_f = (10000 * binCodDec(ord($fn[$block + 24])) + 100 * binCodDec(ord($fn[$block + 25])) + binCodDec(ord($fn[$block + 26]))) / 10000.0;

                $this -> O_X_option = binCodDec(ord($fn[$block + 31]));
                $this -> PulseRepRate = 100 * binCodDec(ord($fn[$block + 33])) + binCodDec(ord($fn[$block + 34]));
                $this -> Range_start = (100 * binCodDec(ord($fn[$block + 35])) + binCodDec(ord($fn[$block + 36])));
                $this -> Range_increment = binCodDec(ord($fn[$block + 37]));
                if ($this -> Range_increment == 2) {
                    $this -> Range_increment = 2.5;
                }
                $this -> Number_heights = 100 * binCodDec(ord($fn[$block + 38])) + binCodDec(ord($fn[$block + 39]));
                // Calcolo info dipendenti da Number_heights
                if ($this -> Number_heights == 512) {
                    $freq_group_per_block_previsti = 8;
                    $freq_group_len_prevista = 504;
                    $this -> number_range_bins = 498;
                } elseif ($this -> Number_heights == 256) {
                    $freq_group_per_block_previsti = 15;
                    $freq_group_len_prevista = 262;
                    $this -> number_range_bins = 256;
                } elseif ($this -> Number_heights == 128) {
                    $freq_group_per_block_previsti = 30;
                    $freq_group_len_prevista = 134;
                    $this -> number_range_bins = 128;
                } else {
                    $out = array(
                        "err_code" => 2,
                        "err_message" => "unrecognize elevation");
                    return $out;
                }
                $this -> Base_gain = binCodDec(ord($fn[$block + 42]));
                $this -> Const_gain = binCodDec(ord($fn[$block + 48]));

                // $this -> ionolist = [];
                $this -> frequency_group_len = 0x0f & $fn[60]; // Leggo il low nibble del primo byte del PRELUDE
                if ($this -> frequency_group_len == 3) {
                    $this -> frequency_group_len = 504;
                } elseif ($this -> frequency_group_len == 2) {
                    $this -> frequency_group_len = 262;
                } elseif ($this -> frequency_group_len == 1) {
                    $this -> frequency_group_len = 134;
                }
                // Test coerenza lunghezza freq group
                if ($this -> frequency_group_len != $freq_group_len_prevista) {
                    $out = array(
                        "err_code" => 2,
                        "err_message" => "frequency_group_len <>  freq_group_len_prevista");
                    return $out;
                }
                // Numero di frequency group per ogni blocco. ATTENZIONE l'ultimo blocco puo essere incompleto
                $this -> freq_group_number_per_block = floor(4096 / $this -> frequency_group_len);

                // ######## LETTURA ECHI 
                // for1 cicla sui blocchi del file
                $list  = []; // list of measuure
                for ($block_num = 0; $block_num < $numero_blocchi; $block_num++) {
                    $block_address = 4096 * $block_num;
                    $init_byte = 1;
                    $index = $block_address + 60;
                    // list di freq
                    $listBlock = [];
                    $precFreq = 0;

                    // for2 on freq group
                    // ATTENTION ad fpr each f there are 2 freq group: 
                    //  one for O and one for X 
                    //  because of that the temporary list must be for f and not for fgroup
                    for ($freq_group_num = 0; 
                        $freq_group_num < $this -> freq_group_number_per_block
                            AND $init_byte != 14    // finite freq
                            AND $init_byte != 0     // fine file
                        ; 
                        $freq_group_num++)
                    {
                        // read data
                        $polzz = intdiv($init_byte, 10);
                        $index      = $block_address + 60 + $freq_group_num * $freq_group_len_prevista;
                        $init_byte  = binCodDec(ord($fn[$index]));
                        $polarizzazione     = (intdiv($init_byte, 10) == 3) ? 'O' : 'X';
                        $additional_gain = ord($fn[$index + 3]) & 0x0f;
                        $freq = (100 * binCodDec(ord($fn[$index + 1])) + binCodDec(ord($fn[$index + 2]))) / 100;
                        // for3
                        $range = $this -> Range_start;
                        for ($i = 0; $i < $this -> number_range_bins; $i++) {
                            $energy = 3 * (ord($fn[$index + 6 + $i]) & 0xf8) >> 3;
                            $el_found = false;
                            //foreach ($listBlock as $indx => $field) {
                            foreach ($listBlock as &$item) {
                                if ($item['f'] === $freq && $item['h'] === $range) {
                                    // update
                                    if ($polarizzazione == "O"){
                                        $item['o'] = $energy;
                                    }
                                    elseif ($polarizzazione == "X"){
                                        $item['x'] = $energy;
                                    }
                                    else {
                                    }
                                    $el_found = true;
                                    break; // found it faster exit
                                } // found
                            } // foreach
                            if (!$el_found) { // if not found add element
                                if ($polarizzazione == "O"){
                                    $listBlock[] = [
                                        'f' => $freq,
                                        'h' => $range,
                                        'g' => $additional_gain,
                                        'o' => $energy,
                                        'x' => "NUL"
                                    ];
                                }
                                elseif ($polarizzazione == "X"){
                                    $listBlock[]= [
                                        'f' => $freq,
                                        'h' => $range,
                                        'g' => $additional_gain,
                                        'o' => "NUL",
                                        'x' => $energy
                                    ];
                                }
                                else{
                                    echo "\n ERROR ne o ne x \n";die();
                                }
                            } // if not found
                            $range += $this -> Range_increment;
                        } // for3
                        // if the second freq group for the same f read
                        if ($freq == $precFreq) {
                            $list = array_merge($list, $listBlock);
                            $listBlock = [];
                        }
                        $precFreq = $freq;
                    } // for 2
                } // for 1
            } // if len file % 4096
            usort($list, function($a, $b) {
                return $a['h'] <=> $b['h'];
            });
            $this-> json_content = json_encode($list, JSON_NUMERIC_CHECK); //encode del file json
        } // if read file
        return $out;
    } // end funct

    function push2db() {        
        /** Funzione per il popolamento e la creazione della tabella raw
        *   senza utilizzo di sp per eseguirla su pg
        */

        /// removed mysql option
        $sql = "SELECT COUNT(*) ntab FROM information_schema.tables WHERE table_catalog = :dbname AND table_name = :tablename;";
        try{
            $stmt = $this -> myconn -> conn -> prepare($sql, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
            $appo = array(
                    ':dbname'       => strval($this -> db),
                    ':tablename'    => strval($this -> station)."_raw"
                );
            $stmt->execute( $appo);
            $out = $stmt -> fetchAll();
        }
        catch (PDOException $e) {
            $stmt->debugDumpParams();
            print_r($e);
            $stmt->closeCursor();
            return ;
        }
        $stmt->closeCursor();
        if ($out[0]['ntab'] == 0) {
            // il nome della tabella non puo essere passato col prepare cone variabile di pdo
            $sql = createDps4dRawTable($this -> station, $this->isPostgres);
            try{
                $stmt = $this -> myconn -> conn -> prepare($sql);
                $stmt->execute();
           	    $out = $stmt -> fetchAll();
        	} 
            catch (PDOException $e) {
                $stmt->debugDumpParams();
                print_r($e);
                echo "ERROR DB CONNECTION ";
                return ;
            }
            $stmt->closeCursor();
        }
        date_default_timezone_set("UTC");
        // il nome della tabella non puo essere passato col prepare cone variabile di pdo
        $sql = "INSERT INTO ".$this -> station."_raw (".
                "dt," . 
                "fromfile," .
                "rxid," . 
                "txid," . 
                "start_f," . 
                "coarse_step_f," . 
                "stop_f," . 
                "o_x_option," . 
                "pulsereprate," . 
                "range_start," . 
                "range_increment," . 
                "number_heights," . 
                "number_range_bins," . 
                "base_gain," . 
                "const_gain," . 
                "frequency_group_len," . 
                "freq_group_number_per_block," . 
                "ionogram,".
                "modified)".
            " VALUES(".
                ":dt," . 
                ":filename," .
                ":rxid," . 
                ":txid," . 
                ":start_f," . 
                ":coarse_step_f," . 
                ":stop_f," . 
                ":o_x_option," . 
                ":pulsereprate," . 
                ":range_start," . 
                ":range_increment," . 
                ":number_heights," . 
                ":number_range_bins," . 
                ":base_gain," . 
                ":const_gain," . 
                ":frequency_group_len," . 
                ":freq_group_number_per_block," . 
                ":ionogram,".
                ":modified)";
       try {
            $stmt = $this->myconn->conn->prepare($sql, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
            $appo = array(
                ':dt'                           => strval($this->dt),
                 ':filename'                    => strval($this->filename),
                ':rxid'                         => strval($this->RXid),
                ':txid'                         => strval($this->TXid),
                ':start_f'                      => strval($this->start_f),
                ':coarse_step_f'                => strval($this->coarse_step_f),
                ':stop_f'                       => strval($this->stop_f),
                ':o_x_option'                   => strval($this->O_X_option),
                ':pulsereprate'                 => strval($this->PulseRepRate),
                ':range_start'                  => strval($this->Range_start),
                ':range_increment'              => strval($this->Range_increment),
                ':number_heights'               => strval($this->Number_heights),
                ':number_range_bins'            => strval($this->number_range_bins),
                ':base_gain'                    => strval($this->Base_gain),
                ':const_gain'                   => strval($this->Const_gain),
                ':frequency_group_len'          => strval($this->frequency_group_len),
                ':freq_group_number_per_block'  => strval($this->freq_group_number_per_block),
                ':ionogram'                     => strval($this->json_content),
                ':modified'                     => date('Y-m-d H:i:s')
            );
            $stmt->execute($appo);
            $outapp = $stmt->fetchAll();
            $out = $outapp['0'];
            $out = array(
                "err_code"      => 0,
                "err_message"   => "OK_LOADED ". $this->station .  " ". $this->dt
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
                //print_r($e);
                //$stmt->debugDumpParams();
                $stmt -> closeCursor();
                return $out;
            }
        }
        $stmt -> closeCursor();
        return $out;
    } // function

} //chiusura classe
