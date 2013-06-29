<?php
require_once 'lib/Entity.php';


class userEntity extends Entity
{
    static public $_meta = array(
        'user_id' => array('user_id',
                array('name'      => 'N',
                      'type'      => 0,
                      'primary'   => 'y',
                      'visuality' => 'y')
        ),
        'email' => array('email',
                array('name'      => 'Email',
                      'type'      => 5,
                      'visuality' => 'y',
                      'size'      => '90')
        ),
        'password' => array('password',
                array('name'      => 'Пароль',
                      'type'      => 1,
                      'visuality' => 'y',
                      'size'      => '90')
        ),
        'password_change_date' => array('password_change_date',
                array('name'      => 'Дата смены пароля',
                      'type'      => 12,
                      'calendar'  => 'y')
        ),
        'surname' => array('surname',
                array('name'      => 'Фамилия',
                      'type'      => 1,
                      'visuality' => 'y',
                      'size'      => '90',
                      'required'  => 'Фамилия обязательно',
                      'validators'=> array(
                                array('hasLength', 'surname_length', 1, 255)
                      ),
                      'filters'   => array(
                                array('stripTags')
                      ))
        ),
        'name' => array('name',
                array('name'      => 'Имя',
                      'type'      => 1,
                      'visuality' => 'y',
                      'size'      => '90',
                      'required'  => 'Имя обязательно',
                      'validators'=> array(
                                array('hasLength', 'name_length', 1, 255)
                      ),
                      'filters'   => array(
                                array('stripTags')
                      ))
        ),
        'nickname' => array('nickname',
                array('name'      => 'Nickname',
                      'type'      => 1,
                      'visuality' => 'y',
                      'size'      => '90')
        ),
        'company_name' => array('company_name',
                array('name'      => 'Компания/проект',
                      'type'      => 1,
                      'size'      => '90')
        ));

    static public $_meta_select = array('_id' => 'user_id', 'email', 'password', 'surname', 'name', 'nickname');
    public $_meta_short_list = array('_id' => array('N', 'user_id'), 'email' => array('Email', 'email'), 'password' => array('Пароль', 'password'), 'surname' => array('Фамилия', 'surname'), 'name' => array('Имя', 'name'), 'nickname' => array('Nickname', 'nickname'));
    protected $_meta_enums = array();


    protected $_meta_default = array();

    static public $_meta_order = array('_id' => Array('a.user_id', 'a.user_id desc'),
            'email' => Array('a.email', 'a.email desc'),
            'password' => Array('a.password', 'a.password desc'),
            'surname' => Array('a.surname', 'a.surname desc'),
            'name' => Array('a.name', 'a.name desc'),
            'nickname' => Array('a.nickname', 'a.nickname desc'));

    public $_meta_filter = array(
        array('f_email', array(
            'name'  => 'Email',
            'where' => 'a.email LIKE ?',
            'visual'=> 'text-short'
            )
        ));

    

    

    

    public $imagePath = '/docs/';
    public $xmls = array();

    public function getMeta()
    {
        return self::$_meta;
    }

    public static function getColumnMeta($name)
    {
        return self::$_meta[$name];
    }

    public static function getArrayColumnMeta($name)
    {
        return self::$_meta[$name][1]['validators'][0][1];
    }

    public function getMetaEnums()
    {
        $gettext = new \sabay\GetText(get_class($this) . 'Validator',
                                'ru');
        $translatedEnums = array();
        foreach ($this->_meta_enums as $i => $enum) {
            foreach ($enum as $j => $text) {
                $message = $gettext->getText($text);
                if ($message) {
                    $text = $message;
                }
                $translatedEnums[$i][$j] = $text;
            }
        }
        return $translatedEnums;
    }

    public function insert($params=null)
    {
        $this->_aData = array();
        
        if ($params !== null) {
            $this->_aData = array_merge($this->_aData, $params);
        }
        if ($this->existEvent('_preInsert')) {
            $this->_preInsert();
        }
        $this->db->insert('user',
                          array('email' => $this->getemail(),
                                'password' => $this->getpassword(),
                                'password_change_date' => $this->getpassword_change_date(),
                                'surname' => $this->getsurname(),
                                'name' => $this->getname(),
                                'nickname' => $this->getnickname(),
                                'company_name' => $this->getcompany_name()));

        $this->id = $this->db->lastInsertId('user', 'user_id');
        

        if ($this->existEvent('_postInsert')) {
            $this->_postInsert();
        }
        return $this->id;
    }

    public function _load($id=null)
    {
        if ($id !== null) {
            $this->id = $id;
        }
        return $this->db->fetchRow('select * from user where user_id = ?', $this->id);
    }

    public function update($id=null, $params=null)
    {
        if ($id !== null) {
            $this->id = $id;
        }
        if ($id !== null) {
            $this->_aData = $this->_load($id);
        }
        if ($params !== null) {
            $this->_aData = array_merge($this->_aData, $params);
        }
        if ($this->existEvent('_preUpdate')) {
            $this->_preUpdate();
        }
        
        $this->db->update('user',
                          array('email' => $this->getemail(),
                                'password' => $this->getpassword(),
                                'password_change_date' => $this->getpassword_change_date(),
                                'surname' => $this->getsurname(),
                                'name' => $this->getname(),
                                'nickname' => $this->getnickname(),
                                'company_name' => $this->getcompany_name()),
                          $this->db->quoteInto('user_id = ?', $this->id));

        if ($this->existEvent('_postUpdate')) {
            $this->_postUpdate();
        }
    }

    public function delete($id=null)
    {
        if ($id !== null) {
            $this->id = $id;
        }
        if ($this->existEvent('_preDelete')) {
            $this->_preDelete();
        }
        $this->db->delete('user', $this->db->quoteInto('user_id = ?', $this->id));
        
        if ($this->existEvent('_postDelete')) {
            $this->_postDelete();
        }
    }


    static public function getMainTitle(&$cmf, $id)
    {
        return $cmf->db->fetchOne('select email from user where user_id =?',  $id);
    }







}
