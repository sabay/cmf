<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" encoding="utf-8"/>

<xsl:template name="uppercase"><xsl:param name="input"/><xsl:value-of select="translate(substring($input,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/><xsl:value-of select="substring($input,2)"/></xsl:template>

<xsl:template match="col" mode="default_value">'<xsl:value-of select="@name" />' => <xsl:value-of select="@admin_default" /><xsl:if test="position() != last()">,
                                     </xsl:if></xsl:template>

<xsl:template match="config/table" xml:space="preserve"><xsl:variable name="ucname"><xsl:choose><xsl:when test="@classname"><xsl:value-of select="@classname"/></xsl:when><xsl:otherwise><xsl:call-template name="uppercase"><xsl:with-param name="input"  select="@name" /></xsl:call-template></xsl:otherwise></xsl:choose></xsl:variable>-----------------------|src/admin/<xsl:value-of select="$ucname"/>Controller.php|
<xsl:text disable-output-escaping="yes">&lt;</xsl:text>?php
require 'lib/Abstract_Admin_Controller.php';
require_once 'lib/validator.php';
require_once 'lib/xmlbox.php';
require_once 'models/<xsl:value-of select="$ucname"/>.php';
require_once 'models/User.php';
    <xsl:if test="col[@translate='y']">
require_once 'models/Localization.php';
    </xsl:if>
class <xsl:value-of select="$ucname"/>Controller extends sabay\Abstract_Admin_Controller
{
    /**
     * @var User
     */
    protected $_user   = null;
    /**
     * @var <xsl:value-of select="$ucname"/>
     */
    protected $item    = null;
    /**
     * @var FormValidator
     */
    protected $fv      = null;
    protected $scriptName = '<xsl:value-of select="$ucname"/>';
    <xsl:if test="col[@translate='y']">
    /**
    *  @var Localization
    */
    protected $Localization = null;
    </xsl:if>
    protected $defaultValues = array();

    public function init()
    {
        $this->item   = new <xsl:value-of select="$ucname"/>($this->config);
        $this->fv     = new \sabay\FormValidator($this->config, $this, '<xsl:value-of select="$ucname" />Validator');
        $this->errors = array();
        $this->_user  = new User($this->config, $this->userId);
        <xsl:if test="col[@input='y']">$this->values2 = array(); // for collecting errors values in list input submiting</xsl:if>
        $this->enums = $this->item->getMetaEnums();
        $this->popup = null;
    <xsl:if test="col[@translate='y']">
        $this->Localization = new Localization($this->config);
    </xsl:if>
        $this->list_xsl = "admin/list.xsl";
        $this->edit_xsl = "admin/new.xsl";
        $this->new_xsl  = "admin/new.xsl";
        $this->defaultValues = array(<xsl:apply-templates select="col[@admin_default]" mode="default_value" />);
    }

    public function indexAction()
    {
        $profile = $this->_user->getProfile();
        $select = $this->db->select()
                           ->from(array('a'=>'<xsl:value-of select="@name"/>'), 'count(*)')<xsl:if test="@order">
                           ->order('<xsl:value-of select="@order"/>')</xsl:if>;

        $pagesize = $this->Param('pagesize');
        if (!$pagesize) {
            $pagesize = 50;
        }

        $count = $this->Param('count');
        $pnum = $this->Param('p');

        $s = $this->Param('s');

        $values = Array();

        <xsl:if test="col[@filt='y']">if (isset($_COOKIE['filter_values'])) {
            $values = unserialize($_COOKIE['filter_values']);
        }

//        $this->cmf->setFilter($select, $values, $this->item->_meta_filter);
</xsl:if>
        $this->setCustomFilter($select);

        foreach (<xsl:value-of select="$ucname"/>::$_meta_order as $name => $order) {
            if (
                isset($order[2])
                <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> is_array($order[2])
            ) {
                $select->joinLeft($order[2][0], $order[2][1], array());
            }
        }

        if (!$count) {
            $count = $this->db->fetchOne($select);
        }

        $pcount = ceil($count/$pagesize);
        if ($pnum > $pcount) {
            $pnum = $pcount;
        }
        if ($pnum == 0) {
            $pnum = 1;
        }

        $select->reset('columns');
        $select->columns(<xsl:value-of select="$ucname"/>::$_meta_select);
<xsl:if test="col[@type='11']">
        $select->order('<xsl:value-of select="col[@type='11']/@name"/>');
</xsl:if>
        foreach (<xsl:value-of select="$ucname"/>::$_meta_order as $name => $order) {
            if (
                isset($order[2])
                <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> is_array($order[2])
            ) {
                $select->columns(array($name => $order[0]));
            }
        }
        $this->setCustomFields($select);
        if (isset($s) <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> $s) {
            list($s_name, $s_order) = explode(':',$s);
            $select->order(<xsl:value-of select="$ucname"/>::$_meta_order[$s_name][$s_order]);
        }

        $select->limit($pagesize, $pagesize*($pnum-1));
        $stmt = $select->query();
        $rows = $stmt->fetchAll();

        $this->fv->PreVisible(<xsl:value-of select="$ucname"/>::$_meta, $rows, $this->enums);

        $rows_xml = $this->xmlutils->getXML($rows, array('rootTag'    => 'rows',
                                                    'rowTag'     => 'row',
                                                    'attributes' => array('_id'    => 'id'<xsl:if test="col[@isstate='y']">,
                                                                          '_state' =>'status'</xsl:if>),
                                                    'elements'   => array_keys($this->item->_meta_short_list)));

        $short_list=$this->item->Order2Xml($s);

        <xsl:if test="col[@filt='y']">$this->fv->MakeEnums($this->item->_meta_filter, $this->enums);</xsl:if>

        $values_xml = $this->xmlutils->Array2xmlQ($values);
        $values_xml .= $this->fv->MultiOptions($this->item->_meta_filter, $values<xsl:if test="col[@filt='y'][@type=10]">, $this->enums</xsl:if>);
        <xsl:if test="col[@filt='y']">$filter = $this->item->Filter2XML();</xsl:if>

        $this->HeaderNoCache();

        <xsl:if test="col[@input='y']">$values_xml2 = $this->fv->ValuesXML($this->values2);// old value collector  for inputs in list mode
        $errors_xml = "";  // error collector for inputs in list mode
        foreach ($this->errors as $d => $m) {
            if (!empty($m)) {
                for ($i=0; $i<xsl:text disable-output-escaping="yes">&lt;</xsl:text>sizeof($m); $i++) {
                    $errors_xml .= $this->fv->ErrorsXML(array($d => $m[$i]));
                }
            }
        }
</xsl:if>

        $page = new sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->addNamedBlock('head', $this->xmlutils->Array2xmlQ($profile));
        $page->addBlock($this->cmfScript->MakeLeftMenu());
        $input_mode = "n";
        if (isset($this->item->_meta_input) <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> sizeof($this->item->_meta_input) > 0) {
            $input_mode = "y";
        }

        $page->startSection('data', array('pagesize' => $pagesize,<xsl:if test="@imagepath">
                                          'imgpath'  => $this->item->imagePath,</xsl:if>
                                          'input'    => $input_mode,
                                          'popup'    => $this->popup,
                                          <xsl:if test="col[@type='11']">'ordering' => 'y'</xsl:if>));
        $page->addTag('pager', '', array('count' => $count,
                                         'page' => $pnum,
                                         'pcount' => $pcount));
        $page->addNamedBlock('name', $this->scriptName);

        $page->addNamedBlock('cols', $short_list);

        <xsl:if test="col[@filt='y']">$page->startSection('filter');
        $page->addBlock($filter);
        $page->addNamedBlock('values', $values_xml);
        $page->stopSection();
</xsl:if>

        $page->addBlock($rows_xml);
        <xsl:if test="col[@input='y']">$page->addNamedBlock('row_values', $values_xml2);
        $page->addNamedBlock('errors', $errors_xml);
</xsl:if>

        $page->stopSection();
        $page->Transform($this->list_xsl);
    }

    protected function setCustomFilter($select)
    {
    }

    protected function setCustomFields($select)
    {
    }

    public function editAction($id=null, $values=array())
    {
        if (!$id) {
            $id=$this->Param('id');
        }
        $p = $this->Param('p');
        $profile = $this->_user->getProfile();

        $this->HeaderNoCache();
        if (empty($values)) {
            $values = $this->item->_load($id);
        }

    <xsl:if test="col[@translate='y']">
        $traslations = $this->Localization->getTranslations(<xsl:value-of select="$ucname"/>::$_meta_translate, $id);
    </xsl:if>
        $this->fv->PiceImages(<xsl:value-of select="$ucname"/>::$_meta, $values);
        $this->fv->MakeEnums(<xsl:value-of select="$ucname"/>::$_meta, $this->enums);

        $meta = $this->xmlutils->Meta2XML(<xsl:value-of select="$ucname"/>::$_meta);

        $values_xml = $this->xmlutils->Form2XML($values);
        $values_xml .= $this->fv->MultiOptions(<xsl:value-of select="$ucname"/>::$_meta, $values);
        $errors_xml = $this->fv->ErrorsXML($this->errors);

        $page = new sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->addNamedBlock('head', $this->xmlutils->Array2xmlQ($profile));
        $page->addBlock($this->cmfScript->MakeLeftMenu());
        $page->startSection('data', array('edit'    => '',
                                          'id'      => $id,
                                          'p'       => $p<xsl:if test="@imagepath">,
                                          'imgpath' => $this->item->imagePath</xsl:if>));
        $this->addEditFields($id, $page);
        $page->addBlock($this->cmfScript->GetTabs($this->script_id));
        $page->addNamedBlock('name', $this->scriptName);
        $page->addNamedBlock('values', $values_xml);
        $page->addNamedBlock('meta', $meta);
        $page->addNamedBlock('errors', $errors_xml);
    <xsl:if test="col[@translate='y']">
        $page->addNamedBlock('translation', $this->xmlutils->Array2xmlQ($traslations, true));
        $page->addNamedBlock('translation_meta', $this->xmlutils->Array2xmlQ(<xsl:value-of select="$ucname"/>::$_meta_translate, true));
    </xsl:if>
        $page->stopSection();

        $page->Transform($this->edit_xsl);
    }

    public function newAction($values = array())
    {
        if (!$values) {
            $values = $this->defaultValues;
        }
        $p = $this->Param('p');
        $profile = $this->_user->getProfile();
        $this->HeaderNoCache();
        $this->fv->MakeEnums(<xsl:value-of select="$ucname"/>::$_meta, $this->enums);
        $meta = $this->xmlutils->Meta2XML(<xsl:value-of select="$ucname"/>::$_meta);
        $values_xml = $this->fv->MultiOptions(<xsl:value-of select="$ucname"/>::$_meta, $values);
        $values_xml .= $this->xmlutils->Form2XML($values);
        $errors_xml = $this->fv->ErrorsXML($this->errors);

        $page = new sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->addNamedBlock('head',$this->xmlutils->Array2xmlQ($profile));
        $page->addBlock($this->cmfScript->MakeLeftMenu());
        $page->startSection('data', array('new' => ''<xsl:if test="@imagepath">,
                                          'imgpath' => $this->item->imagePath</xsl:if>,
                                          'p'   => $p));
        $page->addNamedBlock('name', $this->scriptName);
        $page->addNamedBlock('values', $values_xml);
        $page->addNamedBlock('meta', $meta);
        $page->addNamedBlock('errors', $errors_xml);
        $page->stopSection();

        $page->Transform($this->new_xsl);
    }

    public function insertAction()
    {
        $fields = array();
        $this->errors = $this->fv->Validate(<xsl:value-of select="$ucname"/>::$_meta, array_merge($_REQUEST, $_FILES), $fields);
        if (empty($this->errors)) {
            try {
                $id = $this->item->insert($fields);
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
        $this->errors = $this->fv->Validate(<xsl:value-of select="$ucname"/>::$_meta, array_merge($_REQUEST, $_FILES), $fields);
        if (empty($this->errors)) {
            try {
                $this->item->update($this->Param('id'), $fields);
                $this->postUpdate($fields);
                $this->editAction();
            } catch(EntityError $e) {
                $this->editAction(null, $fields);
            }
        } else {
            $this->editAction(null, $fields);
        }
    }

    public function deleteAction()
    {
        try {
            $ids = $this->Param('id');
            if (is_array($ids)) {
                foreach ($ids as $id) {
                    $this->item->delete($id);
                }
            }
        } catch(EntityError $e) {
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

<xsl:if test="col[@filt='y']">
/** filter actions **/

    public function filterAction()
    {
        $values = array();
        $this->fv->Validate($this->item->_meta_filter, $_REQUEST, $values);
        $values_serial = serialize($values);

        $_COOKIE['filter_values'] = $values_serial;
        setcookie('filter_values', $values_serial , null, "/site/admin/{$this->scriptName}/");  //set filter cookie for this session only
        $_REQUEST['count'] = null;
        $this->indexAction();
    }

    public function clearfilterAction()
    {
        unset($_COOKIE['filter_values']);
        setcookie('filter_values', "" , null, "/site/admin/{$this->scriptName}/");
        $_REQUEST['count'] = null;
        $this->indexAction();
    }
</xsl:if>
/** sorting actions **/

    public function sortAction()
    {

        unset($_COOKIE['s']);
        $s = $_GET['s'];
        $_COOKIE['s'] = $s;
        $_REQUEST['s'] = $s;
        if (isset($s) <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> $s) {
            setcookie('s', $s , time()+1209600, "/site/admin/{$this->scriptName}/");  //set sorting cookie for 2 weeks
        }
        $this->indexAction();
    }

/** pagesize actions **/

    public function pagesizeAction()
    {
        unset($_COOKIE['pagesize']);
        $s = array_key_exists('pagesize',$_POST) ? $_POST['pagesize'] : 50;
        $_COOKIE['pagesize'] = $s;
        $_REQUEST['pagesize'] = $s;
        if (isset($s) <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> $s) {
            setcookie('pagesize', $s , time()+1209600, "/site/admin/{$this->scriptName}/");  //set pagesize cookie for 2 weeks
        }
        $this->indexAction();
    }
<xsl:if test="col[@input='y']">

/** save inputs in list mode actions **/

    public function saveindexAction()
    {
        try {
            $fields = array();
            $cc = $this->Param($this->scriptName);
            foreach ($cc as  $x => $d) {
                $q = Array();
                for ($i=0; $i<xsl:text disable-output-escaping="yes">&lt;</xsl:text>sizeof($this->item->_meta_input); $i++) {
                    $fieldname = $this->item->_meta_input[$i][1]['name'];
                    $q[$fieldname] = $d[$fieldname];
                }
                $err = $this->fv->Validate($this->item->_meta_input, $q, $fields);
                if (!empty($err)) {
                    $this->errors[$x] = $err;$this->values2[$x] = $q;
                } else {
                    $this->item->update($x, $fields);
                }
            }
            $this->indexAction();
        } catch(EntityError $e) {
            $this->indexAction();
        }
    }
</xsl:if>
<xsl:if test="col[@type='11']">

    public function upAction()
    {
        $this->item->up($this->Param('id'));
        $this->indexAction();
    }

    public function dnAction()
    {
        $this->item->dn($this->Param('id'));
        $this->indexAction();
    }
</xsl:if>
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

    protected function addEditFields($id, $page)
    {
    }
}
-----------------------
</xsl:template>
<xsl:template match="/config"><xsl:apply-templates select="table[not(@nogen) and not(@parentscript)]"/></xsl:template>
</xsl:stylesheet>
