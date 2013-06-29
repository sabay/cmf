<?php
require_once 'lib/Entity.php';

class cmf_xmls_articleEntity extends Entity
{
    static public $_meta = array(
        'type' => array('type',
                array('name'      => 'Тип',
                      'type'      => 3,
                      'primary'   => 'y',
                      'visuality' => 'y')
        ),
        'article' => array('article',
                array('name'      => 'ARTICLE',
                      'type'      => 6,
                      'visuality' => 'y',
                      'multioptions' => 'article',
                      'ref'       => array('table' => 'cmf_script',
                                           'field' => 'article',
                                           'visual'=> 'name',
                                           'order' => ''))
        ),
        'edit' => array('edit',
                array('name'      => 'Шаблон пути для редактирования',
                      'type'      => 1,
                      'visuality' => 'y',
                      'size'      => '90')
        ),
        'view' => array('view',
                array('name'      => 'Шаблон пути для просмотра',
                      'type'      => 1,
                      'visuality' => 'y',
                      'size'      => '90')
        ));

    static public $_meta_select = array('_id' => 'type', 'article', 'edit', 'view');
    public $_meta_short_list = array('_id' => array('Тип', 'type'), '_strarticle' => array('ARTICLE', 'article'), 'edit' => array('Шаблон пути для редактирования', 'edit'), 'view' => array('Шаблон пути для просмотра', 'view'));
    protected $_meta_enums = array();


    protected $_meta_default = array();

    static public $_meta_order = array('_id' => Array('a.type', 'a.type desc'),
            '_strarticle' => Array('o_2.name', 'o_2.name desc', Array(Array('o_2' => 'cmf_script'), 'a.article = o_2.article')),
            'edit' => Array('a.edit', 'a.edit desc'),
            'view' => Array('a.view', 'a.view desc'));

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
        $this->db->insert('cmf_xmls_article',
                          array('article' => $this->getarticle(),
                                'edit' => $this->getedit(),
                                'view' => $this->getview()));

        $this->id = $this->db->lastInsertId('cmf_xmls_article', 'type');
        

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
        return $this->db->fetchRow('select * from cmf_xmls_article where type = ?', $this->id);
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
        
        $this->db->update('cmf_xmls_article',
                          array('article' => $this->getarticle(),
                                'edit' => $this->getedit(),
                                'view' => $this->getview()),
                          $this->db->quoteInto('type = ?', $this->id));

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
        $this->db->delete('cmf_xmls_article', $this->db->quoteInto('type = ?', $this->id));
        
        if ($this->existEvent('_postDelete')) {
            $this->_postDelete();
        }
    }








}
