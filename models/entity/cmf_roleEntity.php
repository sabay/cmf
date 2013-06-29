<?php
require_once 'lib/Entity.php';

class cmf_roleEntity extends Entity
{
    static public $_meta = array(
        'cmf_role_id' => array('cmf_role_id',
                array('name'      => 'Id',
                      'type'      => 0,
                      'primary'   => 'y',
                      'visuality' => 'y')
        ),
        'name' => array('name',
                array('name'      => 'Название роли',
                      'type'      => 1,
                      'visuality' => 'y',
                      'size'      => '90',
                      'required'  => 'Название роли обязательно')
        ),
        'visualname' => array('visualname',
                array('name'      => 'Отображаемое название роли',
                      'type'      => 1,
                      'size'      => '90')
        ),
        'cmf_url' => array('cmf_url',
                array('name'      => 'Стартовая страница',
                      'type'      => 1,
                      'visuality' => 'y',
                      'size'      => '90')
        ),
        'scripts' => array('scripts',
                array('name'      => 'Модули')
        ));

    static public $_meta_select = array('_id' => 'cmf_role_id', 'name', 'cmf_url');
    public $_meta_short_list = array('_id' => array('Id', 'cmf_role_id'), 'name' => array('Название роли', 'name'), 'cmf_url' => array('Стартовая страница', 'cmf_url'));
    protected $_meta_enums = array();


    protected $_meta_default = array();

    static public $_meta_order = array('_id' => Array('a.cmf_role_id', 'a.cmf_role_id desc'),
            'name' => Array('a.name', 'a.name desc'),
            'cmf_url' => Array('a.cmf_url', 'a.cmf_url desc'));

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
        $this->db->insert('cmf_role',
                          array('name' => $this->getname(),
                                'visualname' => $this->getvisualname(),
                                'cmf_url' => $this->getcmf_url()));

        $this->id = $this->db->lastInsertId('cmf_role', 'cmf_role_id');
        

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
        return $this->db->fetchRow('select * from cmf_role where cmf_role_id = ?', $this->id);
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
        
        $this->db->update('cmf_role',
                          array('name' => $this->getname(),
                                'visualname' => $this->getvisualname(),
                                'cmf_url' => $this->getcmf_url()),
                          $this->db->quoteInto('cmf_role_id = ?', $this->id));

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
        $this->db->delete('cmf_role', $this->db->quoteInto('cmf_role_id = ?', $this->id));
        
        if ($this->existEvent('_postDelete')) {
            $this->_postDelete();
        }
    }








}
