<?php
/** @file
 * Programma per il parse dei file ais e ismr e il loro inserimento in un db mysql
 */

    foreach (glob("include/*.php") as $f){
        include $f;
    }

    define("MYDEBUG", "1") ;
    define("START_GPS_TIME", "1980-01-06 00:00:00") ;
    define('WORDLEN', array(
                        0 => 3,
                        1 => 7,
                        2 => 120,
                        3 => 1,
                        4 => 8,
                        5 => 2,
                        6 => 7,
                        7 => 8,
                        8 => 8,
                        9 => 3,
                        10 => 1,
                        11 => 8,
                        12 => 8,
                        13 => 8,
                        14 => 3,
                        15 => 1,
                        16 => 8,
                        17 => 8,
                        18 => 8,
                        19 => 3,
                        20 => 1,
                        21 => 8,
                        22 => 8,
                        23 => 3,
                        24 => 1,
                        25 => 8,
                        26 => 8,
                        27 => 3,
                        28 => 1,
                        29 => 8,
                        30 => 8,
                        31 => 3,
                        32 => 1,
                        33 => 8,
                        34 => 3,
                        35 => 3,
                        36 => 3,
                        37 => 11,
                        38 => 11,
                        39 => 11,
                        40 => 20,
                        41 => 1,
                        42 => 11,
                        43 => 8,
                        44 => 3,
                        45 => 1,
                        46 => 8,
                        47 => 8,
                        48 => 3,
                        49 => 1,
                        50 => 8,
                        51 => 8,
                        52 => 8,
                        53 => 8,
                        54 => 1,
                        55=> 1,
                        56 => 1
                        ));

    $help="syntax: php ".$argv[0]." -f<filename> | -v (rebuild view)  ";

    // db connection variable check
    if (getenv('IPARSER_SWIT_HOST') == ''){
        echo "variable IPARSER_SWIT_HOST not set\n"; echo '__'.getenv('IPARSER_SWIT_HOST').'__';
        die();
    }
    if (getenv('IPARSER_SWIT_PORT') == ''){
        echo "variable IPARSER_SWIT_PORT not set\n";
        die();
    }
    if (getenv('IPARSER_SWIT_PASS') == ''){
        echo "variable IPARSER_SWIT_PASS not set\n";
        die();
    }
 
    $options = getopt("f:v:h:");
    
    if (array_key_exists("v", $options)){
        fn_createAllView($options["v"]);
    } else{
        if (! array_key_exists("f", $options)){
            echo "option -f missing\n";
            echo $help;
            die();
        } else{
            $filename   = $options["f"];
            $inputfile  = new input_file($filename);
            $inputfile -> parseFile();
        }
    }
?>
