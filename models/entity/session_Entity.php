<?php
require_once 'lib/Entity.php';

class session_Entity extends Entity
{
    static public $_meta = array(
        'session_id' => array('session_id',
                array('name'      => 'N',
                      'type'      => 3,
                      'primary'   => 'y',
                      'visuality' => 'y')
        ),
        'data' => array('data',
                array('name'      => 'Время последнего обращения',
                      'type'      => 12)
        ),
        'user_id' => array('user_id',
                array('name'      => 'Пользователь',
                      'type'      => 6,
                      'visuality' => 'y',
                      'multioptions' => 'user_id',
                      'ref'       => array('table' => 'user',
                                           'field' => 'user_id',
                                           'visual'=> 'email',
                                           'order' => ''))
        ),
        'object_' => array('object_',
                array('name'      => 'Данные',
                      'type'      => 2,
                      'rows'      => '5',
                      'cols'      => '90')
        ));

    static public $_meta_select = array('_id' => 'session_id', 'user_id');
    public $_meta_short_list = array('_id' => array('N', 'session_id'), '_struser_id' => array('Пользователь', 'user_id'));
    protected $_meta_enums = array();


    protected $_meta_default = array();

    static public $_meta_order = array('_id' => Array('a.session_id', 'a.session_id desc'),
            '_struser_id' => Array('o_2.email', 'o_2.email desc', Array(Array('o_2' => 'user'), 'a.user_id = o_2.user_id')));

    public $_meta_filter = array();

    

    

    

    public $imagePath = '';
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
        $this->db->insert('session_',
                          array('data' => $this->getdata(),
                                'user_id' => $this->getuser_id(),
                                'object_' => $this->getobject_()));

        $this->id = $this->db->lastInsertId('session_', 'session_id');
        

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
        return $this->db->fetchRow('select * from session_ where session_id = ?', $this->id);
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
        
        $this->db->update('session_',
                          array('data' => $this->getdata(),
                                'user_id' => $this->getuser_id(),
                                'object_' => $this->getobject_()),
                          $this->db->quoteInto('session_id = ?', $this->id));

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
        $this->db->delete('session_', $this->db->quoteInto('session_id = ?', $this->id));
        
        if ($this->existEvent('_postDelete')) {
            $this->_postDelete();
        }
    }








}
