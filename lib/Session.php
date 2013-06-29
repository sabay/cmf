<?php
namespace sabay;
class Session
{

    private $config;
    private $name;
    private $storage;

    function __construct($config=null,$name='___UID')
    {
        $this->config=$config;
        $this->name=$name;
        $this->storage=$this->config->DB();
    }

    function get(& $controler){
         $controler->session_id = $this->Param($this->name,0);
         $controler->userId = 0;

         if(strlen(trim($controler->session_id))>0){
             $sess = $this->storage->fetchRow(
                'SELECT 1 as isreal, se.user_id, se.object_
                 FROM session_ se
                 WHERE se.session_id = ?', $controler->session_id);
             $controler->userId = $sess['user_id'];

         }
         return $controler->session_id;
    }

    function logout($session_id,$redirect)
    {
        setcookie($this->name, 0 , null, '/',
                      '.' . $this->config->get('General', 'ROOTDOMAIN'));
        header('location: '.$this->config->get('General','HTTP_ROOT').$redirect);
        exit(0);
    }


    function createSession($userId, $remember, $options)
    {
        $session_id = md5(uniqid(getmypid().$userId));
        $data = array(
                'session_id'=>$session_id,
                'data'=> new \Zend_Db_Expr('NOW()'),
                'user_id' => $userId,
                'object_'=>serialize($options));
        try {
            $this->storage->insert('session_', $data);
        } catch (Zend_Db_Statement_Mysqli_Exception $e) {
            if (stripos($e->getMessage(), 'Duplicate entry') !== false) {
                // duplicate post, just skip
                return $session_id;
            }
            throw $e;
        }
        $long_life_ = 60 * 60 * 24 * 14; //2 weeks
        if ($remember)
            setcookie('___UID', $session_id, time() + $long_life_, '/', '.' . $this->config->get('General', 'ROOTDOMAIN'));
        else
            setcookie('___UID', $session_id, null, '/', '.' . $this->config->get('General', 'ROOTDOMAIN'));
        return $session_id;
    }
    
    function Param($name,$val='')
    {
        return isset($_COOKIE[$name])?$_COOKIE[$name]:$val;
    }

}
