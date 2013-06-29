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
require_once 'models/User.php';
    <xsl:if test="col[@translate='y']">
require_once 'models/Localization.php';
    </xsl:if>

class <xsl:value-of select="$ucname"/>Controller extends sabay\Abstract_Admin_Controller
{
    /**
     * @var User
     */
    protected $user    = null;
    /**
     * @var <xsl:value-of select="$ucname"/>
     */
    protected $item    = null;
    protected $scriptName = '<xsl:value-of select="$ucname"/>';
    protected $rootId  = 0;

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

        $this->enums  = $this->item->getMetaEnums();
    <xsl:if test="col[@translate='y']">
        $this->Localization = new Localization($this->config);
    </xsl:if>
        $this->list_xsl = "admin/treelist.xsl";
        $this->edit_xsl = "admin/treenew.xsl";
        $this->new_xsl  = "admin/treenew.xsl";
    }

    public function indexAction()
    {
        $profile = $this->_user->getProfile();

        $short_list = $this->xmlutils->Array2XmlQ($this->item->_meta_short_list);

        $parhash = array();
        $this->item->_getOpenLeafs($this->Param('id'), $parhash);
        $rows_xml = $this->visibleTree(0, 0, $parhash,
                                       array('rootTag'    => 'rows',
                                             'rowTag'     => 'row',
                                             'attributes' => array('_id'        =>'id',<xsl:if test="col[@isstate]">
                                                                   '_state'     =>'state',</xsl:if><xsl:if test="col[@isrealstate]">
                                                                   'realstatus' =>'rstate',</xsl:if>
                                                                   '_last'      =>'lastnode'),
                                             'elements'   => array_keys($this->item->_meta_short_list)));
        $this->HeaderNoCache();

        $page = new \sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->addNamedBlock('head', $this->xmlutils->Array2XmlQ($profile));
        $page->addBlock($this->cmfScript->MakeLeftMenu());
        $page->startSection('data', array(<xsl:if test="@imagepath">'imgpath' => $this->item->imagePath</xsl:if>));
        $page->addNamedBlock('name', $this->scriptName);
        $page->addNamedBlock('cols', $short_list);
        $page->addBlock($rows_xml);
        $page->stopSection();
        $page->Transform($this->list_xsl);
    }

    public function editAction($id=null,$values=array())
    {
        if (!$id) {
            $id=$this->Param('id');
        }
        $profile = $this->_user->getProfile();
        $this->HeaderNoCache();
        if (empty($values)) {
            $values=$this->item->_load($id);
        }
        $this->fv->PiceImages(<xsl:value-of select="$ucname"/>::$_meta, $values);
        $this->fv->MakeEnums(<xsl:value-of select="$ucname"/>::$_meta, $this->enums);
        $meta=$this->xmlutils->Meta2XML(<xsl:value-of select="$ucname"/>::$_meta);
    <xsl:if test="col[@translate='y']">
        $traslations = $this->Localization->getTranslations(<xsl:value-of select="$ucname"/>::$_meta_translate, $id);
    </xsl:if>
        $values_xml = $this->xmlutils->Array2XmlQ($values);
        $values_xml .= $this->fv->MultiOptions(<xsl:value-of select="$ucname"/>::$_meta, $values);
        $errors_xml = $this->fv->ToXML($this->errors);

        $page=new \sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->addNamedBlock('head', $this->xmlutils->Array2XmlQ($profile));
        $page->addBlock($this->cmfScript->MakeLeftMenu());
        $page->startSection('data', array('edit' => 'y','id' => $id<xsl:if test="@imagepath">, 'imgpath' => $this->item->imagePath</xsl:if>));
        $page->addNamedBlock('name', $this->scriptName);
        $page->addNamedBlock('values', $values_xml);
        $page->addNamedBlock('meta', $meta);
        $page->addNamedBlock('errors', $errors_xml);
    <xsl:if test="col[@translate='y']">
        $page->addNamedBlock('translation', $this->xmlutils->Array2XmlQ($traslations, true));
        $page->addNamedBlock('translation_meta', $this->xmlutils->Array2XmlQ(<xsl:value-of select="$ucname"/>::$_meta_translate, true));
    </xsl:if>
        $page->stopSection();
        $page->Transform($this->edit_xsl);
    }

    public function newAction($values = array())
    {
        $profile = $this->_user->getProfile();
        $this->HeaderNoCache();
        $this->fv->MakeEnums(<xsl:value-of select="$ucname"/>::$_meta, $this->enums);
        $meta = $this->xmlutils->Meta2XML(<xsl:value-of select="$ucname"/>::$_meta);
        $values_xml = $this->fv->MultiOptions(<xsl:value-of select="$ucname"/>::$_meta, $values);
        $values_xml .= $this->xmlutils->Array2XmlQ($values);
        $errors_xml = $this->fv->ToXML($this->errors);
        $page = new \sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->addNamedBlock('head',$this->xmlutils->Array2XmlQ($profile));
        $page->addBlock($this->cmfScript->MakeLeftMenu());
        $page->startSection('data', array('pid' => intval($this->Param('pid')),
                                          'new' => 'y'<xsl:if test="@imagepath">,
                                          'imgpath' => $this->item->imagePath</xsl:if>));
        $page->addNamedBlock('name', $this->scriptName);
        $page->addNamedBlock('values', $values_xml);
        $page->addNamedBlock('meta', $meta);
        $page->addNamedBlock('errors', $errors_xml);
        $page->stopSection();
        $page->Transform($this->new_xsl);
    }

    public function insertAction()
    {
        $fields=array();

        if(!array_key_exists('<xsl:value-of select="col[@isstate='y']/@name"/>',$fields)||is_null($fields["<xsl:value-of select="col[@isstate='y']/@name"/>"]))$fields["<xsl:value-of select="col[@isstate='y']/@name"/>"]=0;

        $this->errors = $this->fv->Validate(<xsl:value-of select="$ucname"/>::$_meta, array_merge($_REQUEST, $_FILES), $fields);
        if (empty($this->errors)) {
            try {
                $id = $this->item->insert($fields);

                $select = $this->db->select()
                                   ->from(array('a'=>'<xsl:value-of select="@name"/>'), '<xsl:value-of select="col[@parent='y']/@name"/>')
                                   ->where('a.<xsl:value-of select="col[@primary='y']/@name"/>=?', $id);
                $parentId = $this->db->fetchOne($select);

                $lastnode = 0;

                $this->db->update('<xsl:value-of select="@name"/>', array('lastnode' => $lastnode),
                $this->db->quoteInto('<xsl:value-of select="col[@primary='y']/@name"/> = ?', $parentId));

                $this->editAction($id);
            } catch(EntityError $e) {
                $this->newAction($fields);
            }
        } else {
            $this->newAction($fields);
        }
    }

    public function updateAction()
    {
        $fields = array();
        if(!array_key_exists('<xsl:value-of select="col[@isstate='y']/@name"/>',$fields)||is_null($fields["<xsl:value-of select="col[@isstate='y']/@name"/>"]))$fields["<xsl:value-of select="col[@isstate='y']/@name"/>"]=0;
        $this->errors = $this->fv->Validate(<xsl:value-of select="$ucname"/>::$_meta, array_merge($_REQUEST, $_FILES), $fields);
        if (empty($this->errors)) {
            try {
                $this->item->update($this->Param('id'), $fields);
                $this->editAction();
            } catch(EntityError $e) {
                $this->editAction(null, $fields);
            }
        } else {
            $this->editAction(null, $fields);
        }
    }

    public function cancelAction()
    {
        $this->editAction($this->Param('id'));
    }

    public function returnAction()
    {
        $this->indexAction();
    }

    public function delAction()
    {
        try {
            $select = $this->db->select()
                               ->from(array('a'=>'<xsl:value-of select="@name"/>'), '<xsl:value-of select="col[@parent='y']/@name"/>')
                               ->where('a.<xsl:value-of select="col[@primary='y']/@name"/> = ?', $this->Param('id'));
            $parentId = $this->db->fetchOne($select);

            $this->item->delete($this->Param('id'));

            $select = $this->db->select()
                               ->from(array('a'=>'<xsl:value-of select="@name"/>'), 'count(*)')
                               ->where('a.<xsl:value-of select="col[@parent='y']/@name"/> = ?', $parentId);

            $count = $this->db->fetchOne($select);
            $lastnode = ($count>0) ? 0 : 1;

            $this->db->update('<xsl:value-of select="@name"/>', array('lastnode' => $lastnode),
            $this->db->quoteInto('<xsl:value-of select="col[@primary='y']/@name"/> = ?', $parentId));

            $_REQUEST['id'] = isset($parentId) ? $parentId : $this->Param('id');
        } catch(EntityError $e) {
        }

        $this->indexAction();
    }

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

     public function showMoveAction()
     {
         $profile=$this->getProfile();

         $short_list=$this->xmlutils->Array2XmlQ($this->item->_meta_short_list);

         $parhash=array();
         $id = $this->Param('id');
         $this->item->_getOpenLeafs(($id)?$id:$this->rootId,$parhash);
         $rows_xml=$this->visibleTree($this->rootId , 0, $parhash,
                array(  'rootTag'=>'rows',
                        'rowTag'=>'row',
                        'attributes' => array('_id'=>'id',
                            '_state'=>'state',
                            'realstatus'=>'rstate',
                            '_last'=>'lastnode'),
                        'elements' => array_keys($this->item->_meta_short_list)));
         $this->HeaderNoCache();

         $page=new \sabay\XMLBox($this->config);
         $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
         $page->addNamedBlock('head',$profile);

         $page->startSection('data',
            array(
                'imgpath' => $this->item->imagePath,
                'id' => $id
            ));

         $item = $this->item->_load($id);
         $page->addNamedBlock('title', "{$item['name']} [{$id}]");

         $page->addNamedBlock('name',$this->scriptName);
         $page->addNamedBlock('cols',$short_list);
         $page->addBlock($rows_xml);
         $page->stopSection();
         $page->Transform('admin/treepopup.xsl');
    }


    public function moveTreeAction() {
          $fromid = intval($this->Param('fromid'));
          $toid = intval($this->Param('toid'));

            $new = $this->db->fetchOne('select MAX(<xsl:value-of select="col[@type=11]/@name"/>) from <xsl:value-of select="@name"/>
                where <xsl:value-of select="col[@parent='y']/@name"/> = ?',  array($toid));

          $this->item->updateMove($fromid,
            array(
                '<xsl:value-of select="col[@parent='y']/@name"/>' => $toid,
                '<xsl:value-of select="col[@type=11]/@name"/>' => intval($new) + 1));
          $this->indexAction();
    }

    public function vsAction()
    {
        $this->item->vs($this->Param('id'));
        $this->indexAction();
    }

    protected function visibleTree($parent, $level, <xsl:text disable-output-escaping="yes">&amp;</xsl:text>$parhash, $options)
    {
        if (isset($options['rootTag'])) {
            $rootTagName = $options['rootTag'];
        } else {
            $rootTagName = 'root';
        }
        if (!isset($options['rowTag'])) {
            $options['rowTag']= 'row';
        }
        $xw = new xmlWriter();
        $xw->openMemory();
        $xw->setIndent(true);
        $xw->startElement($rootTagName);
        $this->_visibleTree($xw, $parent, $level, <xsl:text disable-output-escaping="yes">&amp;</xsl:text>$parhash, $options);
        $xw->endElement(); // root
        return $xw->outputMemory(true);
    }

    function _visibleTree($xw, $parent, $level, <xsl:text disable-output-escaping="yes">&amp;</xsl:text>$parhash, <xsl:text disable-output-escaping="yes">&amp;</xsl:text>$options)
    {
        $select = $this->db->select()
                           ->from(array('a'=>'<xsl:value-of select="@name"/>'),<xsl:value-of select="$ucname"/>::$_meta_select)
                           ->where('a.<xsl:value-of select="col[@parent='y']/@name"/>=?', $parent)<xsl:choose>
                            <xsl:when test="col[@type=11]">
                           ->order('a.<xsl:value-of select="col[@type=11]/@name"/>')</xsl:when><xsl:otherwise>
                           ->order('a.<xsl:value-of select="col[@primary]/@name" />')</xsl:otherwise></xsl:choose>;
        $this->setCustomFilter($select);

        $stmt = $select->query();
        $short_list = $this->xmlutils->Array2XmlQ($this->item->_meta_short_list);
        $rows = $stmt->fetchAll();
        $this->fv->PreVisible(<xsl:value-of select="$ucname"/>::$_meta, $rows, $this->enums);
        foreach ($rows as <xsl:text disable-output-escaping="yes">&amp;</xsl:text>$row) {
            $xw->startElement ($options['rowTag']);
            $xw->writeAttribute('level',$level);
            foreach ($options['attributes'] as $vk => $vv) {
                if (is_int($vk)) {
                    $xw->writeAttribute($vv,$row[$vv]);
                    if (($vv == 'id') <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> in_array($row[$vv],$parhash)) {
                        $xw->writeAttribute('openleaf', 1);
                    }
                } else {
                    $xw->writeAttribute ($vv,$row[$vk]);
                    if (($vv == 'id') <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> in_array($row[$vk],$parhash)) {
                        $xw->writeAttribute('openleaf', 1);
                    }
                }
        }

        foreach ($options['elements'] as $vk => $vv) {
            if (is_int($vk)) {
                $xw->writeElement ($vv,$row[$vv]);
            } else {
                $xw->writeElement ($vv,$row[$vk]);
            }
        }
        if (!$row['_last']) {
            $this->_visibleTree($xw, $row['_id'], $level+1, $parhash, $options);
        }
        $xw->endElement(); // row
     }
  }
<xsl:if test="col[@translate='y']">
    public function ajxTranslateAction()
    {
        $name_table = trim($this->ParamQ('tname'));
        $name_field = trim($this->ParamQ('fname'));
        $record_id = intval($this->Param('rid'));

        $traslations = $this->Localization->getAllTranslations($name_table, $name_field, $record_id);

        $page = new \sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->startSection('data', array('id' => $record_id));
        $page->addTag('name_table', $name_table);
        $page->addTag('name_field', $name_field);
        $page->addTag('record_id', $record_id);
        $page->addNamedBlock('translation', $this->xmlutils->Array2XmlQ($traslations, true));
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

        $page = new \sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->startSection('data', array('mode'    => 'flag'));
        $traslations = $this->Localization->showTranslations($name_table, $name_field, $record_id);
        $page->addNamedBlock('translation', $this->xmlutils->Array2XmlQ($traslations, true));
        $page->stopSection();

        $page->Transform('admin/_translation.xsl');
    }
</xsl:if>

    protected function setCustomFilter($select)
    {
    }
}
-----------------------
</xsl:template>
<xsl:template match="/config"><xsl:apply-templates select="table[not(@nogen) and @treechild]"/></xsl:template>
</xsl:stylesheet>