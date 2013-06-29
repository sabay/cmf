<?php
namespace sabay;
class Config
{
    private $myroot;
    private static $instance = null;

    private $data = array(
        'DB' => array(
            'DBName' => 'cms_cms',
            'Username' => 'cms_cms',
            'Password' => 'qwe7890',
            'Hostname' => 'localhost',
            'Adapter' => 'Mysqli'
        ),
        'Debug' => array(
            //'emailForErrors' => 'gazelle@adlabs.ru'
            'dbProfiling'   => true
        ),
        'System' => array(
            'smtp_server'       => 'localhost',
            'default_mail_from' => 'robot@sabay.ru',
            'php_path'          => '/usr/bin/php'
        ),
        'MailTTL' => array(
            'registration_ticket_expire' => 14,
            'change_mail_expire' => 2
        ),
        'General' => array(
            'ROOTDOMAIN' => 'cms.sabay.ru',
            'HTTP_ROOT' => '',
            'support_mail' => 'asabay@gmail.com',
            'SYSTEM_NAME' => 'New CMF'
        ),
        'Spam' => array(
            //'debug_mail' => 'asabay@gmail.com'
        ),
        'Redis' => array(
            'Server' => 'phpredis.luxup.ru',
            'Port'   => 6382
        )

    );

    /**
     * @return Config
     */
    public static function Instance()
    {
        if (is_null(self::$instance))
            self::$instance = new self();

        return self::$instance;
    }

    public function __construct($root = null)
    {
        $this->myroot=$root;
        $this->db = null;
    }

    public function root()
    {
        return $this->myroot;
    }

    public function DB()
    {
        include_once('Zend/Db.php');
        if(is_null($this->db)){
             $this->db = \Zend_Db::factory($this->data['DB']['Adapter'], array(
                'host'     => $this->data['DB']['Hostname'],
                'username' => $this->data['DB']['Username'],
                'password' => $this->data['DB']['Password'],
                'dbname'   => $this->data['DB']['DBName']));
             $this->db->setFetchMode(\Zend_Db::FETCH_ASSOC);
             $this->db->query('SET OPTION CHARACTER SET utf8');
        }

        if ($this->get('Debug','dbProfiling') == true) {
            $this->db->getProfiler()->setEnabled(true);
        }
        return $this->db;
    }

    public function get($section, $param)
    {
        if (isset($this->data[$section]) && isset($this->data[$section][$param]))
            return $this->data[$section][$param];
        return null;
    }

    public function set($section, $param, $value)
    {
        if (!isset($this->data[$section]))
            $this->data[$section] = array();
        $this->data[$section][$param] = $value;
    }
}
