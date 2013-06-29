<?php
require_once 'lib/Entity.php';

class cmf_user_role_linkEntity extends Entity
{
    static public $_meta = array(
        'cmf_user_role_link_id' => array('cmf_user_role_link_id',
                array('name'      => 'Id',
                      'type'      => 0,
                      'primary'   => 'y',
                      'visuality' => 'y')
        ),
        'user_id' => array('user_id',
                array('name'      => 'Пользователь',
                      'type'      => 6,
                      'parent'    => 'y',
                      'visuality' => 'y',
                      'multioptions' => 'user_id',
                      'ref'       => array('table' => 'user',
                                           'field' => 'user_id',
                                           'visual'=> 'email',
                                           'order' => ''))
        ),
        'cmf_role_id' => array('cmf_role_id',
                array('name'      => 'Роль',
                      'type'      => 6,
                      'visuality' => 'y',
                      'multioptions' => 'cmf_role_id',
                      'ref'       => array('table' => 'cmf_role',
                                           'field' => 'cmf_role_id',
                                           'visual'=> 'name',
                                           'order' => ''))
        ));

    static public $_meta_select = array('_id' => 'cmf_user_role_link_id', 'user_id', 'cmf_role_id');
    public $_meta_short_list = array('_id' => array('Id', 'cmf_user_role_link_id'), '_struser_id' => array('Пользователь', 'user_id'), '_strcmf_role_id' => array('Роль', 'cmf_role_id'));
    protected $_meta_enums = array();


    protected $_meta_default = array();

    static public $_meta_order = array('_id' => Array('a.cmf_user_role_link_id', 'a.cmf_user_role_link_id desc'),
            '_struser_id' => Array('o_2.email', 'o_2.email desc', Array(Array('o_2' => 'user'), 'a.user_id = o_2.user_id')),
            '_strcmf_role_id' => Array('o_3.name', 'o_3.name desc', Array(Array('o_3' => 'cmf_role'), 'a.cmf_role_id = o_3.cmf_role_id')));

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
        $this->db->insert('cmf_user_role_link',
                          array(
                        'user_id'=>$pid,'cmf_role_id' => $this->getcmf_role_id()));

        $this->id = $this->db->lastInsertId('cmf_user_role_link', 'cmf_user_role_link_id');
        

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
        return $this->db->fetchRow('select * from cmf_user_role_link where cmf_user_role_link_id = ?', $this->id);
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
        
        $this->db->update('cmf_user_role_link',
                          array('cmf_role_id' => $this->getcmf_role_id()),
                          $this->db->quoteInto('cmf_user_role_link_id = ?', $this->id));

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
        $this->db->delete('cmf_user_role_link', $this->db->quoteInto('cmf_user_role_link_id = ?', $this->id));
        
        if ($this->existEvent('_postDelete')) {
            $this->_postDelete();
        }
    }








}
