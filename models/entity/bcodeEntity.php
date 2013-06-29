<?php
require_once 'lib/Entity.php';


class bcodeEntity extends Entity
{
    static public $_meta = array(
        'bcode_id' => array('bcode_id',
                array('name'      => 'Id',
                      'type'      => 0,
                      'primary'   => 'y',
                      'visuality' => 'y')
        ),
        'block_id' => array('block_id',
                array('name'      => 'Блок',
                      'type'      => 6,
                      'parent'    => 'y',
                      'multioptions' => 'block_id',
                      'ref'       => array('table' => 'block',
                                           'field' => 'block_id',
                                           'visual'=> 'name',
                                           'order' => ''))
        ),
        'name' => array('name',
                array('name'      => 'Название',
                      'type'      => 1,
                      'visuality' => 'y',
                      'size'      => '90')
        ),
        'groupname' => array('groupname',
                array('name'      => 'алиас для групирования',
                      'type'      => 1,
                      'visuality' => 'y',
                      'size'      => '90')
        ),
        'percent' => array('percent',
                array('name'      => 'Процент',
                      'type'      => 3,
                      'visuality' => 'y',
                      'size'      => '90')
        ),
        'redirpercent' => array('redirpercent',
                array('name'      => 'Процент покупного трафа',
                      'type'      => 3,
                      'visuality' => 'y',
                      'size'      => '90')
        ),
        'top_js' => array('top_js',
                array('name'      => 'Верхняя часть кода',
                      'type'      => 2,
                      'visuality' => 'y',
                      'size'      => '90')
        ),
        'bottom_js' => array('bottom_js',
                array('name'      => 'Нижняя часть кода',
                      'type'      => 2,
                      'visuality' => 'y',
                      'size'      => '90')
        ),
        'partner_system_id' => array('partner_system_id',
                array('name'      => 'Партнерка',
                      'type'      => 6,
                      'multioptions' => 'partner_system_id',
                      'ref'       => array('table' => 'partner_system',
                                           'field' => 'partner_system_id',
                                           'visual'=> 'name',
                                           'order' => ''))
        ),
        'divname' => array('divname',
                array('name'      => 'ID Дива',
                      'type'      => 1,
                      'size'      => '90')
        ));

    static public $_meta_select = array('_id' => 'bcode_id', 'name', 'groupname', 'percent', 'redirpercent', 'top_js', 'bottom_js');
    public $_meta_short_list = array('_id' => array('Id', 'bcode_id'), 'name' => array('Название', 'name'), 'groupname' => array('алиас для групирования', 'groupname'), 'percent' => array('Процент', 'percent'), 'redirpercent' => array('Процент покупного трафа', 'redirpercent'), 'top_js' => array('Верхняя часть кода', 'top_js'), 'bottom_js' => array('Нижняя часть кода', 'bottom_js'));
    protected $_meta_enums = array();


    protected $_meta_default = array();

    static public $_meta_order = array('_id' => Array('a.bcode_id', 'a.bcode_id desc'),
            'name' => Array('a.name', 'a.name desc'),
            'groupname' => Array('a.groupname', 'a.groupname desc'),
            'percent' => Array('a.percent', 'a.percent desc'),
            'redirpercent' => Array('a.redirpercent', 'a.redirpercent desc'),
            'top_js' => Array('a.top_js', 'a.top_js desc'),
            'bottom_js' => Array('a.bottom_js', 'a.bottom_js desc'));

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
        $this->db->insert('bcode',
                          array(
                        'block_id'=>$pid,'name' => $this->getname(),
                                'groupname' => $this->getgroupname(),
                                'percent' => $this->getpercent(),
                                'redirpercent' => $this->getredirpercent(),
                                'top_js' => $this->gettop_js(),
                                'bottom_js' => $this->getbottom_js(),
                                'partner_system_id' => $this->getpartner_system_id(),
                                'divname' => $this->getdivname()));

        $this->id = $this->db->lastInsertId('bcode', 'bcode_id');
        

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
        return $this->db->fetchRow('select * from bcode where bcode_id = ?', $this->id);
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
        
        $this->db->update('bcode',
                          array('name' => $this->getname(),
                                'groupname' => $this->getgroupname(),
                                'percent' => $this->getpercent(),
                                'redirpercent' => $this->getredirpercent(),
                                'top_js' => $this->gettop_js(),
                                'bottom_js' => $this->getbottom_js(),
                                'partner_system_id' => $this->getpartner_system_id(),
                                'divname' => $this->getdivname()),
                          $this->db->quoteInto('bcode_id = ?', $this->id));

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
        $this->db->delete('bcode', $this->db->quoteInto('bcode_id = ?', $this->id));
        
        if ($this->existEvent('_postDelete')) {
            $this->_postDelete();
        }
    }








}
