<?php
require_once 'lib/Entity.php';

class user_ownerEntity extends Entity
{
    static public $_meta = array(
        'user_owner_id' => array('user_owner_id',
                array('name'      => 'Id',
                      'type'      => 0,
                      'primary'   => 'y')
        ),
        'user_id' => array('user_id',
                array('name'      => 'Пользователь',
                      'type'      => 6,
                      'multioptions' => 'user_id',
                      'ref'       => array('table' => 'user',
                                           'field' => 'user_id',
                                           'visual'=> 'email',
                                           'order' => ''))
        ),
        'owner_id' => array('owner_id',
                array('name'      => 'Управляющий',
                      'type'      => 6,
                      'multioptions' => 'owner_id',
                      'ref'       => array('table' => 'user',
                                           'field' => 'user_id',
                                           'visual'=> 'email',
                                           'order' => ''))
        ),
        'owner_role_id' => array('owner_role_id',
                array('name'      => 'Роль управляющего',
                      'type'      => 6,
                      'multioptions' => 'owner_role_id',
                      'ref'       => array('table' => 'cmf_role',
                                           'field' => 'cmf_role_id',
                                           'visual'=> 'name',
                                           'order' => ''))
        ));

    static public $_meta_select = array();
    public $_meta_short_list = array();
    protected $_meta_enums = array();


    protected $_meta_default = array();

    static public $_meta_order = array();

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
        $this->db->insert('user_owner',
                          array('user_id' => $this->getuser_id(),
                                'owner_id' => $this->getowner_id(),
                                'owner_role_id' => $this->getowner_role_id()));

        $this->id = $this->db->lastInsertId('user_owner', 'user_owner_id');
        

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
        return $this->db->fetchRow('select * from user_owner where user_owner_id = ?', $this->id);
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
        
        $this->db->update('user_owner',
                          array('user_id' => $this->getuser_id(),
                                'owner_id' => $this->getowner_id(),
                                'owner_role_id' => $this->getowner_role_id()),
                          $this->db->quoteInto('user_owner_id = ?', $this->id));

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
        $this->db->delete('user_owner', $this->db->quoteInto('user_owner_id = ?', $this->id));
        
        if ($this->existEvent('_postDelete')) {
            $this->_postDelete();
        }
    }








}
