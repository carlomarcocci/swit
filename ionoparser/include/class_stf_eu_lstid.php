<?php

class stf_eu_lstid_file {
/**
 * Classe per la gestione dei forecast e nowcast di hf
 * per il progetti swesnet
 */

    public  $filename;                  /// input file name 
    public  $fname;                     /// input file name 
    public  $station;                   /// nome della stazione
    public  $myconn;
    public  $isPostgres;                /// true if upe pg
    public  $db;                        /// database name
    public  $datetime;                  /// data passata da inputfile
    public  $json_a;
    public  $json_f;

    public $dt;
    public $dt_run;
    public $lstid_occurrence_probability;
    public $lstid_high_precision_prediction;
    public $lstid_balanced_prediction;
    public $lstid_high_sensitivity_prediction;
    public $input_availability_score;
    public $input_availability_alert;
    public $ie;
    public $ie_variation;
    public $ie_3h_exp_mov_avg;
    public $ie_12h_exp_mov_avg;
    public $iu;
    public $iu_variation;
    public $iu_3h_exp_mov_avg;
    public $iu_12h_exp_mov_avg;
    public $hf_int;
    public $hf_int_2h_exp_mov_avg;
    public $f_107_adj;
    public $hp_30;
    public $solar_zenith_angle;
    public $newell;
    public $imf_bz;
    public $imf_speed;
    public $imf_rho;
    public $spectral_contribution_at;
    public $spectral_contribution_ff;
    public $spectral_contribution_jr;
    public $spectral_contribution_pq;
    public $spectral_contribution_ro;
    public $spectral_contribution_vt;
    public $azimuth_at;
    public $azimuth_ff;
    public $azimuth_jr;
    public $azimuth_pq;
    public $azimuth_ro;
    public $azimuth_vt;
    public $velocity_at;
    public $velocity_ff;
    public $velocity_jr;
    public $velocity_pq;
    public $velocity_ro;
    public $velocity_vt;

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

        $this -> dt                     				= $this->json_a['data']['dt'];
		$this -> dt_run									= $this->json_a['data']['dt_run'];
		$this -> lstid_occurrence_probability			= $this->json_a['data']['lstid_occurrence_probability'];
		$this -> lstid_high_precision_prediction		= $this->json_a['data']['lstid_high_precision_prediction'];
		$this -> lstid_balanced_prediction              = $this->json_a['data']['lstid_balanced_prediction'];
		$this -> lstid_high_sensitivity_prediction      = $this->json_a['data']['lstid_high_sensitivity_prediction'];
		$this -> input_availability_score               = $this->json_a['data']['input_availability_score'];
        $this -> input_availability_alert               = $this->json_a['data']['input_availability_alert'];
		$this -> ie                                     = $this->json_a['data']['ie'];
		$this -> ie_variation                           = $this->json_a['data']['ie_variation'];
		$this -> ie_3h_exp_mov_avg                      = $this->json_a['data']['ie_3h_exp_mov_avg']; 
		$this -> ie_12h_exp_mov_avg                     = $this->json_a['data']['ie_12h_exp_mov_avg'];
		$this -> iu                                     = $this->json_a['data']['iu'];
		$this -> iu_variation                           = $this->json_a['data']['iu_variation'];
		$this -> iu_3h_exp_mov_avg                      = $this->json_a['data']['iu_3h_exp_mov_avg'];
		$this -> iu_12h_exp_mov_avg                     = $this->json_a['data']['iu_12h_exp_mov_avg'];
		$this -> hf_int                                 = $this->json_a['data']['hf_int'];
		$this -> hf_int_2h_exp_mov_avg                  = $this->json_a['data']['hf_int_2h_exp_mov_avg'];
		$this -> f_107_adj                    			= $this->json_a['data']['f_107_adj'];
		$this -> hp_30                    				= $this->json_a['data']['hp_30'];
		$this -> solar_zenith_angle                     = $this->json_a['data']['solar_zenith_angle'];
		$this -> newell                    				= $this->json_a['data']['newell'];
		$this -> imf_bz                    				= $this->json_a['data']['imf_bz'];
		$this -> imf_speed                    			= $this->json_a['data']['imf_speed'];
		$this -> imf_rho                    			= $this->json_a['data']['imf_rho'];
		$this -> spectral_contribution_at				= $this->json_a['data']['spectral_contribution_at'];
		$this -> spectral_contribution_ff				= $this->json_a['data']['spectral_contribution_ff'];
		$this -> spectral_contribution_jr				= $this->json_a['data']['spectral_contribution_jr'];
		$this -> spectral_contribution_pq				= $this->json_a['data']['spectral_contribution_pq'];
		$this -> spectral_contribution_ro				= $this->json_a['data']['spectral_contribution_ro'];
		$this -> spectral_contribution_vt				= $this->json_a['data']['spectral_contribution_vt'];
		$this -> azimuth_at								= $this->json_a['data']['azimuth_at'];
		$this -> azimuth_ff								= $this->json_a['data']['azimuth_ff'];
		$this -> azimuth_jr								= $this->json_a['data']['azimuth_jr'];
		$this -> azimuth_pq								= $this->json_a['data']['azimuth_pq'];
		$this -> azimuth_ro								= $this->json_a['data']['azimuth_ro'];
		$this -> azimuth_vt								= $this->json_a['data']['azimuth_vt'];
		$this -> velocity_at							= $this->json_a['data']['velocity_at'];
		$this -> velocity_ff							= $this->json_a['data']['velocity_ff'];
		$this -> velocity_jr							= $this->json_a['data']['velocity_jr'];
		$this -> velocity_pq							= $this->json_a['data']['velocity_pq'];
		$this -> velocity_ro							= $this->json_a['data']['velocity_ro'];
		$this -> velocity_vt							= $this->json_a['data']['velocity_vt'];

        $out = array(
            "err_code" => 0,
            "err_message" => "File parsed"
        );
        return $out;
    } // end function
    
    function push2db(){
       /// controllo dell esistenza della stazione e sua eventuale creazione
        ///
        if ($this->isPostgres) {
            $sql = "SELECT COUNT(*) AS ntab FROM information_schema.tables WHERE table_catalog = :dbname AND table_name = :tablename;";
        } else{
            $sql = "SELECT COUNT(*) AS ntab FROM information_schema.tables WHERE table_schema = :dbname AND table_name = :tablename;";
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
            echo "ERROR CONNECTING DB ";
            $stmt->closeCursor();
            $stmt = null;
            return ;
        }
        $stmt->closeCursor();
        $stmt = null;

        // se la rabella di stazione non esiste va creata
        if ($out[0]['ntab'] == 0) {
            // il nome della tabella non puo essere passato col prepare cone variabile di pdo
            $sql = createStfEuLstid($this -> station, $this->isPostgres);
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
        }
        /// tolgo il path dal nome del file
        $fname = pathinfo($this->filename)['filename'];
        /// setto utc per poter inserire il modified corretto nel db
        date_default_timezone_set("UTC");
        $sql = "SELECT COUNT(*) nrow FROM ".$this->station." WHERE dt = :rdt;";
        try{
            $stmt = $this -> myconn -> conn -> prepare($sql, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
            $appo = array(
                    ':rdt'          => $this -> dt
                );
            $stmt->execute( $appo);
            $out = $stmt -> fetchAll();
        }
        catch (PDOException $e) {
            fn_debug_query_e($sql, $appo, $this, $e);
            echo "ERROR CONNECTING DB ";
            $stmt->closeCursor();
            $stmt = null;
            return ;
        }
        $stmt->closeCursor();
        $stmt = null;
        // insert or update row
        $insertUpdate=$out[0]['nrow'];
        if ($insertUpdate == 0) {
            $sql = "INSERT INTO ".$this->station." (".
	                  " dt,".            
			          " dt_run,".				
	                  " fromfile,".
			          " lstid_occurrence_probability,".	
			          " lstid_high_precision_prediction,".
			          " lstid_balanced_prediction,".           
			          " lstid_high_sensitivity_prediction,".
			          " input_availability_score,".             
			          " input_availability_alert,".             
			          " ie,".
			          " ie_variation,".          
			          " ie_3h_exp_mov_avg,".                
			          " ie_12h_exp_mov_avg,".                
			          " iu,".
			          " iu_variation,".          
			          " iu_3h_exp_mov_avg,".               
			          " iu_12h_exp_mov_avg,".      
			          " hf_int,".                            
			          " hf_int_2h_exp_mov_avg,".                 	
			          " f_107_adj,".                    			
			          " hp_30,".                 
			          " solar_zenith_angle,".           
			          " newell,".                   
			          " imf_bz,".                   
			          " imf_speed,".                
			          " imf_rho,".                   	
			          " spectral_contribution_at,".
			          " spectral_contribution_ff,".
			          " spectral_contribution_jr,".
			          " spectral_contribution_pq,".
			          " spectral_contribution_ro,".
			          " spectral_contribution_vt,".
			          " azimuth_at,".	
			          " azimuth_ff,".	
			          " azimuth_jr,".	
			          " azimuth_pq,".	
			          " azimuth_ro,".	
			          " azimuth_vt,".	
			          " velocity_at,".		
			          " velocity_ff,".		
			          " velocity_jr,".		
			          " velocity_pq,".		
			          " velocity_ro,".		
			          " velocity_vt,".  
                      " modified)".
            " VALUES (".
	                  " :m_dt,".            
			          " :m_dt_run,".				
	                  " :m_fromfile,".
			          " :m_lstid_occurrence_probability,".	
			          " :m_lstid_high_precision_prediction,".
			          " :m_lstid_balanced_prediction,".           
			          " :m_lstid_high_sensitivity_prediction,".
			          " :m_input_availability_score,".             
			          " :m_input_availability_alert,".             
			          " :m_ie,".
			          " :m_ie_variation,".          
			          " :m_ie_3h_exp_mov_avg,".                
			          " :m_ie_12h_exp_mov_avg,".                
			          " :m_iu,".
			          " :m_iu_variation,".          
			          " :m_iu_3h_exp_mov_avg,".               
			          " :m_iu_12h_exp_mov_avg,".      
			          " :m_hf_int,".                            
			          " :m_hf_int_2h_exp_mov_avg,".                 	
			          " :m_f_107_adj,".                    			
			          " :m_hp_30,".                 
			          " :m_solar_zenith_angle,".           
			          " :m_newell,".                   
			          " :m_imf_bz,".                   
			          " :m_imf_speed,".                
			          " :m_imf_rho,".                   	
			          " :m_spectral_contribution_at,".
			          " :m_spectral_contribution_ff,".
			          " :m_spectral_contribution_jr,".
			          " :m_spectral_contribution_pq,".
			          " :m_spectral_contribution_ro,".
			          " :m_spectral_contribution_vt,".
			          " :m_azimuth_at,".	
			          " :m_azimuth_ff,".	
			          " :m_azimuth_jr,".	
			          " :m_azimuth_pq,".	
			          " :m_azimuth_ro,".	
			          " :m_azimuth_vt,".	
			          " :m_velocity_at,".		
			          " :m_velocity_ff,".		
			          " :m_velocity_jr,".		
			          " :m_velocity_pq,".		
			          " :m_velocity_ro,".		
			          " :m_velocity_vt,".		  
                      " :m_modified);";
        } else {
            /// aggiungo il separatore per il nome del file
            $fname = " " . $fname;

            $sql = "UPDATE ".$this->station." SET ".
                          " fromfile                          = fromfile || ' ' || :m_fromfile,".
			              " dt_run                            = :m_dt_run,".										
			              " lstid_occurrence_probability      = :m_lstid_occurrence_probability,".	
			              " lstid_high_precision_prediction   = :m_lstid_high_precision_prediction,".
			              " lstid_balanced_prediction         = :m_lstid_balanced_prediction,".           
			              " lstid_high_sensitivity_prediction = :m_lstid_high_sensitivity_prediction,".
			              " input_availability_score          = :m_input_availability_score,".             
			              " input_availability_alert          = :m_input_availability_alert,".             
			              " ie                                = :m_ie,".									
			              " ie_variation                      = :m_ie_variation,".			          
			              " ie_3h_exp_mov_avg                 = :m_ie_3h_exp_mov_avg,". 	               
			              " ie_12h_exp_mov_avg                = :m_ie_12h_exp_mov_avg,". 		               
			              " iu                                = :m_iu,".									
			              " iu_variation                      = :m_iu_variation,".  	        			
			              " iu_3h_exp_mov_avg                 = :m_iu_3h_exp_mov_avg,".  	             	
			              " iu_12h_exp_mov_avg                = :m_iu_12h_exp_mov_avg,".  	    			
			              " hf_int                            = :m_hf_int,".      			                		      
			              " hf_int_2h_exp_mov_avg             = :m_hf_int_2h_exp_mov_avg,".      	           	
			              " f_107_adj                         = :m_f_107_adj,".     			               				
			              " hp_30                             = :m_hp_30,".   				              
			              " solar_zenith_angle                = :m_solar_zenith_angle,".    	       	
			              " newell                            = :m_newell,".     				        	      
			              " imf_bz                            = :m_imf_bz,".     			              	
			              " imf_speed                         = :m_imf_speed,".     			           
			              " imf_rho                           = :m_imf_rho,".    				            	   	
			              " spectral_contribution_at          = :m_spectral_contribution_at,".			
			              " spectral_contribution_ff          = :m_spectral_contribution_ff,".			
			              " spectral_contribution_jr          = :m_spectral_contribution_jr,".			
			              " spectral_contribution_pq          = :m_spectral_contribution_pq,".					
			              " spectral_contribution_ro          = :m_spectral_contribution_ro,".			
			              " spectral_contribution_vt          = :m_spectral_contribution_vt,".				
			              " azimuth_at                        = :m_azimuth_at,".							
			              " azimuth_ff                        = :m_azimuth_ff,".						
			              " azimuth_jr                        = :m_azimuth_jr,".						
			              " azimuth_pq                        = :m_azimuth_pq,".							
			              " azimuth_ro                        = :m_azimuth_ro,".							
			              " azimuth_vt                        = :m_azimuth_vt,".							
			              " velocity_at                       = :m_velocity_at,".							
			              " velocity_ff                       = :m_velocity_ff,".							
			              " velocity_jr                       = :m_velocity_jr,".							
			              " velocity_pq                       = :m_velocity_pq,".							
			              " velocity_ro                       = :m_velocity_ro,".							
			              " velocity_vt                       = :m_velocity_vt,".	
                          " modified                          = :m_modified".
                          " WHERE dt = :m_dt";
        }
        $stmt = $this->myconn->conn->prepare($sql, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
        $appo = array(
            ':m_dt'                    					=> isset($this -> dt) ? $this -> dt : null,
		    ':m_dt_run'									=> isset($this -> dt_run) ? $this -> dt_run : null,
            ':m_fromfile'	                    		=> isset($fname) ? $fname : null,
		    ':m_lstid_occurrence_probability'			=> isset($this -> lstid_occurrence_probability) ? $this -> lstid_occurrence_probability : null,
		    ':m_lstid_high_precision_prediction'		=> isset($this -> lstid_high_precision_prediction) ? $this -> lstid_high_precision_prediction : null,
		    ':m_lstid_balanced_prediction'              => isset($this -> lstid_balanced_prediction) ? $this -> lstid_balanced_prediction : null,
		    ':m_lstid_high_sensitivity_prediction'      => isset($this -> lstid_high_sensitivity_prediction) ? $this -> lstid_high_sensitivity_prediction : null,
		    ':m_input_availability_score'               => isset($this -> input_availability_score) ? $this -> input_availability_score : null,
		    ':m_input_availability_alert'               => $this->input_availability_alert ? 1 : 0,
		    ':m_ie'                                     => isset($this -> ie) ? $this -> ie : null,
		    ':m_ie_variation'                           => isset($this -> ie_variation) ? $this -> ie_variation : null,
		    ':m_ie_3h_exp_mov_avg'                      => isset($this -> ie_3h_exp_mov_avg) ? $this -> ie_3h_exp_mov_avg : null, 
		    ':m_ie_12h_exp_mov_avg'                     => isset($this -> ie_12h_exp_mov_avg) ? $this -> ie_12h_exp_mov_avg : null,
		    ':m_iu'                                     => isset($this -> iu) ? $this -> iu : null,
		    ':m_iu_variation'                           => isset($this -> iu_variation) ? $this -> iu_variation : null,
		    ':m_iu_3h_exp_mov_avg'                      => isset($this -> iu_3h_exp_mov_avg) ? $this -> iu_3h_exp_mov_avg : null,
		    ':m_iu_12h_exp_mov_avg'                    	=> isset($this -> iu_12h_exp_mov_avg) ? $this -> iu_12h_exp_mov_avg : null,
		    ':m_hf_int'                                	=> isset($this -> hf_int) ? $this -> hf_int : null,
		    ':m_hf_int_2h_exp_mov_avg'                 	=> isset($this -> hf_int_2h_exp_mov_avg) ? $this -> hf_int_2h_exp_mov_avg : null,
		    ':m_f_107_adj'                    			=> isset($this -> f_107_adj) ? $this -> f_107_adj : null,
		    ':m_hp_30'                    				=> isset($this -> hp_30) ? $this -> hp_30 : null,
		    ':m_solar_zenith_angle'                    	=> isset($this -> solar_zenith_angle) ? $this -> solar_zenith_angle : null,
		    ':m_newell'                    				=> isset($this -> newell) ? $this -> newell : null,
		    ':m_imf_bz'                    				=> isset($this -> imf_bz) ? $this -> imf_bz : null,
		    ':m_imf_speed'                    			=> isset($this -> imf_speed) ? $this -> imf_speed : null,
		    ':m_imf_rho'                   				=> isset($this -> imf_rho) ? $this -> imf_rho : null,
		    ':m_spectral_contribution_at'				=> isset($this -> spectral_contribution_at) ? $this -> spectral_contribution_at : null,
		    ':m_spectral_contribution_ff'				=> isset($this -> spectral_contribution_ff) ? $this -> spectral_contribution_ff : null,
		    ':m_spectral_contribution_jr'				=> isset($this -> spectral_contribution_jr) ? $this -> spectral_contribution_jr : null,
		    ':m_spectral_contribution_pq'				=> isset($this -> spectral_contribution_pq) ? $this -> spectral_contribution_pq : null,
		    ':m_spectral_contribution_ro'				=> isset($this -> spectral_contribution_ro) ? $this -> spectral_contribution_ro : null,
		    ':m_spectral_contribution_vt'				=> isset($this -> spectral_contribution_vt) ? $this -> spectral_contribution_vt : null,
		    ':m_azimuth_at'								=> isset($this -> azimuth_at) ? $this -> azimuth_at : null,
		    ':m_azimuth_ff'								=> isset($this -> azimuth_ff) ? $this -> azimuth_ff : null,
		    ':m_azimuth_jr'								=> isset($this -> azimuth_jr) ? $this -> azimuth_jr : null,
		    ':m_azimuth_pq'								=> isset($this -> azimuth_pq) ? $this -> azimuth_pq : null,
		    ':m_azimuth_ro'								=> isset($this -> azimuth_ro) ? $this -> azimuth_ro : null,
		    ':m_azimuth_vt'								=> isset($this -> azimuth_vt) ? $this -> azimuth_vt : null,
		    ':m_velocity_at'							=> isset($this -> velocity_at) ? $this -> velocity_at : null,
		    ':m_velocity_ff'							=> isset($this -> velocity_ff) ? $this -> velocity_ff : null,
		    ':m_velocity_jr'							=> isset($this -> velocity_jr) ? $this -> velocity_jr : null,
		    ':m_velocity_pq'							=> isset($this -> velocity_pq) ? $this -> velocity_pq : null,
		    ':m_velocity_ro'							=> isset($this -> velocity_ro) ? $this -> velocity_ro : null,
		    ':m_velocity_vt'							=> isset($this -> velocity_vt) ? $this -> velocity_vt : null,
		    ':m_modified'               				=> date('Y-m-d H:i:s')
            );

        try {
            $stmt->execute($appo);
            if ($insertUpdate == 0) {
                $out = array(
                    "err_code" => 0,
                    "err_message" => "OK_LOADED ".$this->station .  " ". $this->dt
                );
            } else {
                $out = array(
                    "err_code" => 0,
                    "err_message" => "OK_UPDATED ".$this->station .  " ". $this->dt
                );                
            }
        }
        catch (PDOException $e){
            if ($e->errorInfo[0] == '23505'){
                $out = array(
                    "err_code" => 1,
                    "err_message" => "OK_DUPE ".$this->station
                );
            }else{
                $out = array(
                    "err_code" => -1,
                    "err_message" => $e->getMessage()
                );                
                //echo "SQL Error: " . $e->getMessage();
                //echo "\nFull SQL: " . $sql;
                //echo "\nParams: " . print_r($appo, true);
                //return array("err_code" => -1, "err_message" => $e->getMessage());
            }
        }

        return $out;
 
    } // function

}

