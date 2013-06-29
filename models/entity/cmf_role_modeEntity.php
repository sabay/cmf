<?php
require_once 'lib/Entity.php';

class cmf_role_modeEntity extends Entity
{
    static public $_meta = array(
        'cmf_role_mode_id' => array('cmf_role_mode_id',
                array('name'      => 'Id',
                      'type'      => 0,
                      'primary'   => 'y',
                      'visuality' => 'y')
        ),
        'cmf_role_id' => array('cmf_role_id',
                array('name'      => 'Базовая роль',
                      'type'      => 6,
                      'parent'    => 'y',
                      'multioptions' => 'cmf_role_id',
                      'ref'       => array('table' => 'cmf_role',
                                           'field' => 'cmf_role_id',
                                           'visual'=> 'name',
                                           'order' => ''))
        ),
        'mode_role_id' => array('mode_role_id',
                array('name'      => 'Доступный режим',
                      'type'      => 6,
                      'visuality' => 'y',
                      'multioptions' => 'mode_role_id',
                      'ref'       => array('table' => 'cmf_role',
                                           'field' => 'cmf_role_id',
                                           'visual'=> 'name',
                                           'order' => ''))
        ));

    static public $_meta_select = array('_id' => 'cmf_role_mode_id', 'mode_role_id');
    public $_meta_short_list = array('_id' => array('Id', 'cmf_role_mode_id'), '_strmode_role_id' => array('Доступный режим', 'mode_role_id'));
    protected $_meta_enums = array();


    protected $_meta_default = array();

    static public $_meta_order = array('_id' => Array('a.cmf_role_mode_id', 'a.cmf_role_mode_id desc'),
            '_strmode_role_id' => Array('o_2.name', 'o_2.name desc', Array(Array('o_2' => 'cmf_role'), 'a.mode_role_id = o_2.cmf_role_id')));

    public $_meta_filter = array();

    

    

    

    public $imagePath = '';
    public $xmls = array();
    protected $pid = null;

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

    public function insert($pid, $params=null)
    {
        $this->pid = $pid;
        $this->_aData = array();
        
        if ($params !== null) {
            $this->_aData = array_merge($this->_aData, $params);
        }
        if ($this->existEvent('_preInsert')) {
            $this->_preInsert();
        }
        $this->db->insert('cmf_role_mode',
                          array(
                        'cmf_role_id'=>$pid,'mode_role_id' => $this->getmode_role_id()));

        $this->id = $this->db->lastInsertId('cmf_role_mode', 'cmf_role_mode_id');
        

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
        return $this->db->fetchRow('select * from cmf_role_mode where cmf_role_mode_id = ?', $this->id);
    }

    public function update($pid, $id=null, $params=null)
    {
        $this->pid = $pid;
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
        
        $this->db->update('cmf_role_mode',
                          array('mode_role_id' => $this->getmode_role_id()),
                          $this->db->quoteInto('cmf_role_mode_id = ?', $this->id));

        if ($this->existEvent('_postUpdate')) {
            $this->_postUpdate();
        }
    }

    public function delete($pid, $id=null)
    {
        if ($id !== null) {
            $this->id = $id;
        }
        if ($this->existEvent('_preDelete')) {
            $this->_preDelete();
        }
        $this->db->delete('cmf_role_mode', $this->db->quoteInto('cmf_role_mode_id = ?', $this->id));
        
        if ($this->existEvent('_postDelete')) {
            $this->_postDelete();
        }
    }








}
