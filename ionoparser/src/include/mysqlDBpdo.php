<?php

class MySqlPdo {
    private $host;
    private $port;
    private $user;
    private $pass;
    private $db;

    public $conn;

    public function __construct($host, $pn, $db, $usr, $pass){
        // set host and db
        $this -> host       = $host;
        $this -> port       = $pn;
        $this -> user       = $usr;
        $this -> pass       = $pass;
        $this -> db         = $db;
        // Set DSN
        /// se la porta + da mtysql altrimenti setto postgres
        $dsn            = 'mysql:host=' . $this->host . ';port=' . $this->port . ';dbname=' . $this->db;
        //$dsn = 'mysql:host=' . $this->host . ';dbname=' . $this->db;
        // Set options
        $options = array(
            PDO::ATTR_PERSISTENT            => true,
            //PDO::ATTR_AUTOCOMMIT            => true, 
            PDO::ATTR_ERRMODE               => PDO::ERRMODE_EXCEPTION,
            PDO::MYSQL_ATTR_INIT_COMMAND    => 'SET NAMES UTF8'
        );
        // Create a new PDO instanace
//print_r($this); die();
        try{
            $this->conn = new PDO($dsn, $this->user, $this->pass, $options);
//            $this->conn->setAttribute(PDO::ATTR_AUTOCOMMIT,1);
        }
        // Catch any errors
        catch(PDOException $e){
            $this->error = $e->getMessage();
            echo "Error pdoconn: ".$this->error."\n";
            exit;
        } 
//$this->selectdb();
//print_r($this);die();
    }

    public function closeConnection(){
      $this -> conn = null;
    }
    
    public function selectdb(){

        $sql = "select * from information_schema.tables where table_name= :pstation";
        //$sql = "CALL sp_test(:usrname, :usrhost)";
        $stmt = $this->conn->prepare($sql, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
        $stmt->execute(array(':pstation' => 'station'));
        $out = $stmt -> fetchAll();
        print_r($out);die();
        
    }
}
?>
