<?php
require_once 'lib/GetText.php';

class EntityError extends Exception
{
    public $type;
    function __construct ($text, $type = 0)
    {
        $this->message = $text;
        $this->type = $type;
    }
}

class Entity
{
    /**
     * @var SCMF
     */
    protected $config = null;

    /**
     * @var Zend_Db_Adapter_Pdo_Mysql
     */
    protected $db = null;
    protected $_aData = array();
    protected $classname = '';
    protected $id = null;

    private static $_isReady = array();
    private static $_events = array();
    private static $_setters = array();
    private static $_getters = array();

    protected $_meta_default = array();

    protected $_bitfields = array();

    public static $_metaFieldsDataTypesPhp = array(
        0 => 'integer',
        1 => 'string',
        2 => 'string',
        3 => 'integer',
        4 => 'float',
        5 => 'string',
        6 => 'integer',
        7 => 'string',
        8 => 'integer',
        9 => 'integer',
        10 => 'integer',
        11 => 'integer',
        12 => 'datetimestring',
        //13 => 'integer',
        14 => 'string',
        15 => 'integer'
    );

    public function __construct ($config)
    {

        $this->config = $config;
        $this->db = $config->DB();
        $this->classname = get_class($this);
        if (! array_key_exists($this->classname, self::$_isReady)) {
            self::$_setters[$this->classname] = Array();
            self::$_getters[$this->classname] = Array();
            self::$_events[$this->classname] = Array();

            foreach (get_class_methods($this) as $v) {
                $type = substr($v, 0, 4);
                switch ($type) {
                    case '_set':
                        self::$_setters[$this->classname][$v] = 1;
                        break;
                    case '_get':
                        self::$_getters[$this->classname][$v] = 1;
                        break;
                    case '_pos':
                    case '_pre':
                        self::$_events[$this->classname][$v] = 1;
                        break;
                }
            }

            self::$_isReady[$this->classname] = true;
        }
    }

    function __call ($m, $args)
    {
        if (strlen($m) < 4)
            throw new EntityError('Invalid method name:' . $m);
        $method = '_' . $m;
        if (array_key_exists($method, self::$_setters[$this->classname])) {
            call_user_func_array(array($this, $method), $args);
        } elseif (array_key_exists($method, self::$_getters[$this->classname])) {
            return call_user_func_array(array($this, $method), $args);
        } else {
            $type = substr($m, 0, 3);
            $name = substr($m, 3);
            switch ($type) {
                case 'set':
                    $this->_aData[strtolower($name)] = $args[0];
                    break;
                case 'get':
                    $value = null;
                    if (array_key_exists(strtolower($name), $this->_aData)) {
                        $value = $this->_aData[strtolower($name)];
                    }
                    if (is_null($value) && isset($this->_meta_default[strtolower($name)])) {
                        $value = $this->_meta_default[strtolower($name)];
                    }
                    return $value;
                    break;
                default:
                    throw new EntityError('Invalid method name:' . $m);
            }
        }
    }

    function Param ($name)
    {
        return array_key_exists($name, $this->_aData) ? $this->_aData[$name] : null;
    }

    function existEvent ($name)
    {
        return array_key_exists($name, self::$_events[$this->classname]) ? true : false;
    }

    function dump ()
    {
        print_r($this);
        print_r(self::$_events[$this->classname]);
        print_r(self::$_setters[$this->classname]);
        print_r(self::$_getters[$this->classname]);
    }

    public function getId ()
    {
        return $this->id;
    }

    public function Order2XML ($s)
    {
        if (isset($s) && $s)
            list ($s_name, $s_order) = explode(':', $s);

        if (isset($s_order) && $s_order > 0)
            $s_order = 1;
        else
            $s_order = 0;

        $xw = new xmlWriter();
        $xw->openMemory();
        $xw->setIndent(true);
        $pos = 0;

        foreach ($this->_meta_short_list as $k => $v) {
            $xw->startElement('col');
            $xw->writeAttribute('name', $k);
            $xw->writeAttribute('realname', $v[1]);
            if (isset($s_name) && $s_name == $k)
                $xw->writeAttribute('sort', $s_order);
            if (isset($this->_meta_input) && is_array($this->_meta_input))
                for ($j = 0; $j < sizeof($this->_meta_input); $j ++)
                    if ($k == $this->_meta_input[$j][0]) {
                        $k_real = $this->_meta_input[$j][1];
                        if (is_array($k_real)) {
                            //$xw->writeAttribute('realname',$k_real['name']);
                            $xw->writeAttribute('type', $k_real['type']);
                        }
                    }
            $xw->text($v[0]);
            $xw->endElement();
        }
        return $xw->outputMemory(true);
    }

    public function Filter2XML ()
    {
        $xw = new xmlWriter();
        $xw->openMemory();
        $xw->setIndent(true);
        foreach ($this->_meta_filter as $k => $v) {
            $xw->startElement('filt');
            $xw->writeAttribute('name', $v[0]);
            $param = $v[1];
            $xw->writeElement('name', $param['name']);
            $xw->writeElement('visual', $param['visual']);
            $xw->endElement(); // </row>
        }
        return $xw->outputMemory(true);
    }

    /**
     * Генерирует объект пейджера
     * @param array Массив параметров пейджера
     */
    public function makePager (&$pager, $checkPsize = true, $allSize = 100000)
    {
        if (!isset($pager['psize'])) {
            $pager['psize'] = isset($_COOKIE["{$pager['script']}_pp"]) ? $_COOKIE["{$pager['script']}_pp"] : 50;
        }
        $ppArray = array(20, 50, 100, 1000, 5000, 'all');
        if (!isset($pager['psize']) || ($checkPsize && !in_array($pager['psize'], $ppArray))) {
            $pager['psize'] = 50;
        }
        /*if ($pager['psize'] == 'all') {
            $pager['psize'] = 5000;
        }*/

        if ($pager['psize'] != 'all') {
            while ($pager['psize'] > $pager['count']) {
                if (($i = array_search($pager['psize'], $ppArray)) > 0) {
                    $pager['psize'] = $ppArray[$i - 1];
                } else {
                    break;
                }
            }
        }

        if ($pager['psize'] == 'all') {
            $pager['pcount'] = 1;
            $pager['psize'] = $allSize;
        } else {
            $pager['pcount'] = ceil($pager['count'] / $pager['psize']);
        }

        if ($pager['page'] > $pager['pcount']) {
            $pager['page'] = $pager['pcount'];
        }
        if ($pager['page'] < 1) {
            $pager['page'] = 1;
        }

        $pager['offset'] = (int)(($pager['page'] - 1) * $pager['psize']);
        $pager['limit_string'] = " limit {$pager['psize']} offset {$pager['offset']}";
    }

    public function _load($id = null)
    {
    }

    public function toString($id)
    {
        return serialize($this->_load($id));
    }

    public function fromString($data)
    {
        $this->_aData = unserialize($data);
    }

    public function insertIgnoreDuplicate($pid, $data = null)
    {
        try {
            if (is_array($pid)) {
                $this->insert($pid);
            } else {
                $this->insert($pid, $data);
            }
        } catch (Zend_Db_Exception $e) {
            if (stripos($e->getMessage(), 'Duplicate entry') === false) {
                throw $e;
            }
        }
    }

    /**
     * Возвращает SQL строку для группировки записей по типу интервала
     * @param String $interval Интервал day/week/month
     * @param String $tableName Название таблицы, опционально
     * @return String SQL строка
     */
    protected function getIntervalGroupingSQLString($interval, $tableName = '')
    {
        $intervalString = '';

        switch($interval){
            case 'day':
            default:
                $intervalString = 'date_format('.($tableName?$tableName.'.':'').'date, "%Y%m%d")';
                break;
            case 'week':
                $intervalString = 'date_format('.($tableName?$tableName.'.':'').'date, "%Y%u")';
                break;
            case 'month':
                $intervalString = 'date_format('.($tableName?$tableName.'.':'').'date, "%Y%m")';
                break;
        }

        return $intervalString;
    }

    protected function calculateBitFields()
    {
        foreach ($this->_bitfields as $field => $attrs) {
            $result = 0;
            $count = count($attrs);
            foreach ($attrs as $i => $attr) {
                $result |= ((bool)call_user_func(array($this, "get{$attr}"))) << $i;
            }
            call_user_func(array($this, "set{$field}"), $result);
        }
    }
  
    protected function getTotalName()
    {
        $gettext = new GetText_('Stat', $this->config->getLanguageCode());
        return $gettext->getText('stat_total');
    }
}