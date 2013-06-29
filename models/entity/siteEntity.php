<?php
require_once 'lib/Entity.php';


class siteEntity extends Entity
{
    static public $_meta = array(
        'site_id' => array('site_id',
                array('name'      => 'Id',
                      'type'      => 0,
                      'primary'   => 'y',
                      'visuality' => 'y')
        ),
        'url' => array('url',
                array('name'      => 'Url',
                      'type'      => 1,
                      'visuality' => 'y',
                      'size'      => '90',
                      'required'  => 'Не может быть пустым')
        ),
        'status' => array('status',
                array('name'      => 'Вкл',
                      'type'      => 8)
        ),
        'redirpercent' => array('redirpercent',
                array('name'      => 'Процент покупного трафа',
                      'type'      => 3,
                      'visuality' => 'y',
                      'size'      => '90')
        ));

    static public $_meta_select = array('_id' => 'site_id', 'url', '_state' => 'status', 'redirpercent');
    public $_meta_short_list = array('_id' => array('Id', 'site_id'), 'url' => array('Url', 'url'), 'redirpercent' => array('Процент покупного трафа', 'redirpercent'));
    protected $_meta_enums = array();


    protected $_meta_default = array('status' => 0);

    static public $_meta_order = array('_id' => Array('a.site_id', 'a.site_id desc'),
            'url' => Array('a.url', 'a.url desc'),
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
        $this->db->insert('site',
                          array('url' => $this->geturl(),
                                'status' => $this->getstatus(),
                                'redirpercent' => $this->getredirpercent()));

        $this->id = $this->db->lastInsertId('site', 'site_id');
        

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
        return $this->db->fetchRow('select * from site where site_id = ?', $this->id);
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
        
        $this->db->update('site',
                          array('url' => $this->geturl(),
                                'status' => $this->getstatus(),
                                'redirpercent' => $this->getredirpercent()),
                          $this->db->quoteInto('site_id = ?', $this->id));

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
        $this->db->delete('site', $this->db->quoteInto('site_id = ?', $this->id));
        
        if ($this->existEvent('_postDelete')) {
            $this->_postDelete();
        }
    }








}
