<?php
require_once 'lib/Entity.php';


class blockEntity extends Entity
{
    static public $_meta = array(
        'block_id' => array('block_id',
                array('name'      => 'Id',
                      'type'      => 0,
                      'primary'   => 'y',
                      'visuality' => 'y')
        ),
        'user_id' => array('user_id',
                array('name'      => 'Пользователь',
                      'type'      => 6,
                      'visuality' => 'y',
                      'popup'     => 'y',
                      'controller'=> 'User',
                      'multioptions' => 'user_id',
                      'ref'       => array('table' => 'user',
                                           'field' => 'user_id',
                                           'visual'=> 'email',
                                           'order' => 'email'))
        ),
        'site_id' => array('site_id',
                array('name'      => 'Сайт',
                      'type'      => 6,
                      'visuality' => 'y',
                      'multioptions' => 'site_id',
                      'ref'       => array('table' => 'site',
                                           'field' => 'site_id',
                                           'visual'=> 'url',
                                           'order' => 'url'))
        ),
        'name' => array('name',
                array('name'      => 'Название',
                      'type'      => 1,
                      'visuality' => 'y',
                      'size'      => '90',
                      'required'  => 'Не может быть пустым')
        ),
        'redirpercent' => array('redirpercent',
                array('name'      => 'Процент покупного трафа',
                      'type'      => 3,
                      'visuality' => 'y',
                      'size'      => '90')
        ));

    static public $_meta_select = array('_id' => 'block_id', 'user_id', 'site_id', 'name', 'redirpercent');
    public $_meta_short_list = array('_id' => array('Id', 'block_id'), '_struser_id' => array('Пользователь', 'user_id'), '_strsite_id' => array('Сайт', 'site_id'), 'name' => array('Название', 'name'), 'redirpercent' => array('Процент покупного трафа', 'redirpercent'));
    protected $_meta_enums = array();


    protected $_meta_default = array();

    static public $_meta_order = array('_id' => Array('a.block_id', 'a.block_id desc'),
            '_struser_id' => Array('o_2.email', 'o_2.email desc', Array(Array('o_2' => 'user'), 'a.user_id = o_2.user_id')),
            '_strsite_id' => Array('o_3.url', 'o_3.url desc', Array(Array('o_3' => 'site'), 'a.site_id = o_3.site_id')),
            'name' => Array('a.name', 'a.name desc'),
            'redirpercent' => Array('a.redirpercent', 'a.redirpercent desc'));

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
        $this->db->insert('block',
                          array('user_id' => $this->getuser_id(),
                                'site_id' => $this->getsite_id(),
                                'name' => $this->getname(),
                                'redirpercent' => $this->getredirpercent()));

        $this->id = $this->db->lastInsertId('block', 'block_id');
        

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
        return $this->db->fetchRow('select * from block where block_id = ?', $this->id);
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
        
        $this->db->update('block',
                          array('user_id' => $this->getuser_id(),
                                'site_id' => $this->getsite_id(),
                                'name' => $this->getname(),
                                'redirpercent' => $this->getredirpercent()),
                          $this->db->quoteInto('block_id = ?', $this->id));

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
        $this->db->delete('block', $this->db->quoteInto('block_id = ?', $this->id));
        
        if ($this->existEvent('_postDelete')) {
            $this->_postDelete();
        }
    }








}
