<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" encoding="utf-8"/>

<xsl:template name="uppercase"><xsl:param name="input"/><xsl:value-of select="translate(substring($input,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/><xsl:value-of select="substring($input,2)"/></xsl:template>

<xsl:template match="config/table" xml:space="preserve"><xsl:variable name="ucname"><xsl:choose><xsl:when test="@classname"><xsl:value-of select="@classname"/></xsl:when><xsl:otherwise><xsl:call-template name="uppercase"><xsl:with-param name="input"  select="@name" /></xsl:call-template></xsl:otherwise></xsl:choose></xsl:variable>-----------------------|src/admin/<xsl:value-of select="$ucname"/>Controller.php|
<xsl:text disable-output-escaping="yes">&lt;</xsl:text>?php
require 'lib/Abstract_Admin_Controller.php';
require_once 'lib/validator.php';
require_once 'lib/xmlbox.php';
require_once 'models/<xsl:value-of select="$ucname"/>.php';
        <xsl:if test="@parentclassname">
require_once 'models/<xsl:value-of select="@parentclassname"/>.php';
        </xsl:if>
require_once 'models/User.php';
    <xsl:if test="col[@translate='y']">
require_once 'models/Localization.php';
    </xsl:if>

class <xsl:value-of select="$ucname"/>Controller extends sabay\Abstract_Admin_Controller
{
    /**
     * @var User
     */
    protected $_user    = null;
    protected $pid      = null;
    /**
     * @var <xsl:value-of select="$ucname"/>
     */
    protected $item     = null;
    protected $scriptName = '<xsl:value-of select="$ucname"/>';
    protected $list_xsl = 'admin/childlist.xsl';
    protected $edit_xsl = 'admin/childnew.xsl';
    protected $new_xsl = 'admin/childnew.xsl';
     <xsl:if test="col[@translate='y']">
    /**
    *  @var Localization
    */
    protected $Localization = null;
     </xsl:if>

    public function init()
    {
        $this->item   = new <xsl:value-of select="$ucname"/>($this->config);
        $this->fv     = new \sabay\FormValidator($this->config, $this, '<xsl:value-of select="$ucname" />Validator');
        $this->errors = array();
        $this->_user  = new User($this->config, $this->userId);

        $this->enums = $this->item->getMetaEnums();
        $this->pid = $this->Param('pid');
    <xsl:if test="col[@translate='y']">
        $this->Localization = new Localization($this->config);
    </xsl:if>
    }

    public function indexAction()
    {
        $profile = $this->_user->getProfile();

        $pagesize = intval($this->Param('pagesize'));
        if (!$pagesize || ($pagesize == 0) || ($pagesize <xsl:text disable-output-escaping="yes">&lt;</xsl:text> 0)) {
            $pagesize = 50;
        }
        $count = intval($this->Param('count'));
        $pnum = intval($this->Param('p'));
        $s = $this->Param('s');

        if (!$count) {
            $count = $this->db->fetchOne('SELECT COUNT(*) FROM <xsl:value-of select="@name"/> WHERE <xsl:value-of select="col[@parent='y']/@name"/>=?', $this->pid);
        }
        $pcount = ceil($count/$pagesize);
        if ($pnum > $pcount) {
            $pnum = $pcount;
        }
        if ($pnum == 0) {
            $pnum = 1;
        }

        $select = $this->db->select()
                           ->from(array('a'=>'<xsl:value-of select="@name"/>'), <xsl:value-of select="$ucname"/>::$_meta_select)
                           ->where('a.<xsl:value-of select="col[@parent='y']/@name"/>=?', $this->pid)
<xsl:if test="@order">     ->order('<xsl:value-of select="@order"/>')</xsl:if>;

        foreach (<xsl:value-of select="$ucname"/>::$_meta_order as $name => $order) {
            if (
                isset($order[2])
                <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> is_array($order[2])
            ) {
                $select->joinLeft($order[2][0], $order[2][1], array());
            }
        }

        if (isset($s) <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> $s) {
            list($s_name, $s_order) = explode(':', $s);
            $select->order(<xsl:value-of select="$ucname"/>::$_meta_order[$s_name][$s_order]);
        }
        $select->limit($pagesize, $pagesize*($pnum-1));

        $stmt = $select->query();

        $short_list = $this->item->Order2Xml($s);

        $rows = $stmt->fetchAll();
        $this->fv->PreVisible(<xsl:value-of select="$ucname"/>::$_meta, $rows, $this->enums);
        $rows_xml = $this->xmlutils
                         ->getXML($rows,
                                  array('rootTag'    => 'rows',
                                        'rowTag'     => 'row',
                                        'attributes' => array('_id' => 'id'<xsl:if test="col[@isstate='y']">, '_state' => 'status'</xsl:if>),
                                        'elements'   => array_keys($this->item->_meta_short_list)));
        $this->HeaderNoCache();
        $page = new sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->addNamedBlock('head', $this->xmlutils->Array2xmlQ($profile));
        $page->addBlock($this->cmfScript->MakeLeftMenu());
        $page->startSection('data', array('pid'      => $this->pid,
                                          'pagesize' => $pagesize));
        $page->addTag('pager', '', array('count'  => $count,
                                         'page'   => $pnum,
                                         'pcount' => $pcount));
        $page->addBlock($this->cmfScript->getUpTabs($this->script_id));
        $page->addNamedBlock('name', $this->scriptName);
        <xsl:if test="@parentclassname">
        $page->addNamedBlock('mainTitle', <xsl:value-of select="@parentclassname"/>::getMainTitle($this->cmf, $this->pid));
        </xsl:if>
        $page->addNamedBlock('cols', $short_list);
        $page->addBlock($rows_xml);
        $page->stopSection();
        $page->Transform($this->list_xsl);
    }

    public function editAction($id=null,$values=array())
    {
        if (!$id) {
            $id = $this->Param('id');
        }

        $p = $this->Param('p');

        $profile = $this->_user->getProfile();
        $this->HeaderNoCache();
        if (empty($values)) {
            $values = $this->item->_load($id);
        }
        $this->fv->PiceImages(<xsl:value-of select="$ucname"/>::$_meta, $values);
        $this->fv->MakeEnums(<xsl:value-of select="$ucname"/>::$_meta, $this->enums);
        $meta = $this->xmlutils->Meta2XML(<xsl:value-of select="$ucname"/>::$_meta);
    <xsl:if test="col[@translate='y']">
        $traslations = $this->Localization->getTranslations(<xsl:value-of select="$ucname"/>::$_meta_translate, $id);
    </xsl:if>
        $values_xml = $this->xmlutils->Form2XML($values);
        $values_xml .= $this->fv->MultiOptions(<xsl:value-of select="$ucname"/>::$_meta, $values);
        $errors_xml = $this->fv->ErrorsXML($this->errors);

        $page = new sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->addNamedBlock('head',$this->xmlutils->Array2xmlQ($profile));
        $page->addBlock($this->cmfScript->MakeLeftMenu());
        $page->startSection('data', array('edit' => '',
                                          'id'   => $id,
                                          'pid'  => $this->pid,
                                          'p'    => $p<xsl:if test="@imagepath">,
                                          'imgpath' => $this->item->imagePath</xsl:if>));
        $page->addNamedBlock('name', $this->scriptName);
        <xsl:if test="@parentclassname">
        $page->addNamedBlock('mainTitle', <xsl:value-of select="@parentclassname"/>::getMainTitle($this->cmf, $this->pid));
        </xsl:if>
        $page->addNamedBlock('values', $values_xml);
        $page->addBlock($this->xmlutils
                         ->getXML($this->item->xmls,
                                  array('rootTag'    => 'xmls',
                                        'rowTag'     => 'xmlitem',
                                        'attributes' => array('type' => 'id'),
                                        'elements'   => array('name' => 'name'))));
        $page->addNamedBlock('meta', $meta);
        $page->addNamedBlock('errors', $errors_xml);
    <xsl:if test="col[@translate='y']">
        $page->addNamedBlock('translation', $this->xmlutils->Array2xmlQ($traslations, true));
        $page->addNamedBlock('translation_meta', $this->xmlutils->Array2xmlQ(<xsl:value-of select="$ucname"/>::$_meta_translate, true));
    </xsl:if>
        $page->stopSection();

        $page->Transform($this->edit_xsl);
    }

    public function newAction($values=array())
    {
        $profile = $this->_user->getProfile();

        $p = $this->Param('p');

        $this->HeaderNoCache();
        $this->fv->MakeEnums(<xsl:value-of select="$ucname"/>::$_meta, $this->enums);
        $meta = $this->xmlutils->Meta2XML(<xsl:value-of select="$ucname"/>::$_meta);
        $values_xml = $this->fv->MultiOptions(<xsl:value-of select="$ucname"/>::$_meta, $values);
        $values_xml .= $this->xmlutils->Array2xmlQ($values);
        $errors_xml = $this->fv->ErrorsXML($this->errors);

        $page = new sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->addNamedBlock('head', $this->xmlutils->Array2xmlQ($profile));
        $page->addBlock($this->cmfScript->MakeLeftMenu());
        $page->startSection('data', array('new' => '', 'pid' => $this->pid, 'p' => $p));
        $page->addNamedBlock('name', $this->scriptName);
        <xsl:if test="@parentclassname">
        $page->addNamedBlock('mainTitle', <xsl:value-of select="@parentclassname"/>::getMainTitle($this->cmf, $this->pid));
        </xsl:if>
        $page->addNamedBlock('values', $values_xml);
        $page->addNamedBlock('meta', $meta);
        $page->addNamedBlock('errors', $errors_xml);
        $page->stopSection();

        $page->Transform($this->new_xsl);
   }

   public function insertAction()
   {
        $fields = array();
        $this->errors = $this->fv->Validate(<xsl:value-of select="$ucname"/>::$_meta,
                                            array_merge($_REQUEST, $_FILES), $fields);
        if (empty($this->errors)) {
            try {
                $id = $this->item->insert($this->pid, $fields);
                $this->postInsert($id, $fields);
                $this->editAction($id);
            } catch (EntityError $e) {
                $this->newAction($fields);
            }
        } else {
            $this->newAction($fields);
        }
   }

    public function updateAction()
    {
        $fields = array();
        $this->errors = $this->fv->Validate(<xsl:value-of select="$ucname"/>::$_meta,
                                            array_merge($_REQUEST, $_FILES), $fields);
        if (empty($this->errors)) {
            try {
                $this->item->update($this->pid, $this->Param('id'), $fields);
                $this->postUpdate($fields);
                $this->editAction();
            } catch (EntityError $e) {
                $this->editAction(null,$fields);
            }
        } else {
            $this->editAction(null,$fields);
        }
    }

    public function deleteAction()
    {
        try {
            $ids = $this->Param('id');
            if (is_array($ids)) {
                foreach ($ids as $id) {
                    $this->item->delete($this->pid, $id);
                }
            }
        } catch (EntityError $e) {
            print_r($e);
        }
        $this->indexAction();
    }

    public function cancelAction()
    {
        $this->editAction($this->Param('id'));
    }


    public function returnAction()
    {
        $this->indexAction();
    }
    
    protected function postInsert($id, $fields)
    {
    }
    
    protected function postUpdate($fields)
    {
    }
<xsl:if test="col[@autocomplete='y']">
    public function suggestAction()
    {
        if (isset(<xsl:value-of select="$ucname"/>::$_meta[$this->Param('field')])) {
            $field = <xsl:value-of select="$ucname"/>::$_meta[$this->Param('field')];
        } else {
            return;
        }
        $result = $this->db->select()
                       ->from($field[1]['ref']['table'],
                              array($field[1]['ref']['field'], $field[1]['ref']['visual']))
                       ->where("{$field[1]['ref']['visual']} LIKE ?", $this->Param('q') . '%')
                       ->order($field[1]['ref']['order'])
                       ->query()->fetchAll();
        header('Content-Type: text/javascript; charset=utf-8');
        print json_encode($result);
    }
</xsl:if>
<xsl:if test="col[@translate='y']">
    public function ajxTranslateAction()
    {
        $name_table = trim($this->ParamQ('tname'));
        $name_field = trim($this->ParamQ('fname'));
        $record_id = intval($this->Param('rid'));

        $traslations = $this->Localization->getAllTranslations($name_table, $name_field, $record_id);

        $page = new sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->startSection('data', array('id' => $record_id));
        $page->addTag('name_table', $name_table);
        $page->addTag('name_field', $name_field);
        $page->addTag('record_id', $record_id);
        $page->addNamedBlock('translation', $this->xmlutils->Array2xmlQ($traslations, true));
        $page->stopSection();

        $page->Transform('admin/_translation.xsl');
    }

    public function ajxSaveTranslateAction()
    {
        $name_table = trim($this->ParamQ('name_table'));
        $name_field = trim($this->ParamQ('name_field'));
        $record_id = intval($this->ParamQ('record_id'));
        $languages = trim($this->Param('languages'));
        $lang = explode(';', $languages);
        $this->Localization->clearTranslation($name_table, $name_field, $record_id);

        foreach ($lang as $value) {
            $input = trim($this->Param("lang_$value"));
            if ($input != '')
                $this->Localization->saveTranslation($name_table, $name_field, $record_id, $value,  $input);
        }

        $page = new sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->startSection('data', array('mode'    => 'flag'));
        $traslations = $this->Localization->showTranslations($name_table, $name_field, $record_id);
        $page->addNamedBlock('translation', $this->xmlutils->Array2xmlQ($traslations, true));
        $page->stopSection();

        $page->Transform('admin/_translation.xsl');
    }
</xsl:if>
}
-----------------------
</xsl:template>
<xsl:template match="/config"><xsl:apply-templates select="table[not(@nogen) and @parentscript and not(@treechild)]"/></xsl:template>
</xsl:stylesheet>
