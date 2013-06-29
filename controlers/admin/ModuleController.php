<?php
require 'lib/Abstract_Admin_Controller.php';
require_once 'lib/validator.php';
require_once 'lib/xmlbox.php';
require_once 'models/Module.php';
require_once 'models/User.php';
    
class ModuleController extends sabay\Abstract_Admin_Controller
{
    /**
     * @var User
     */
    protected $_user   = null;
    /**
     * @var Module
     */
    protected $item    = null;
    /**
     * @var FormValidator
     */
    protected $fv      = null;
    protected $scriptName = 'Module';
    
    protected $defaultValues = array();

    public function init()
    {
        $this->item   = new Module($this->config);
        $this->fv     = new \sabay\FormValidator($this->config, $this, 'ModuleValidator');
        $this->errors = array();
        $this->_user  = new User($this->config, $this->userId);
        
        $this->enums = $this->item->getMetaEnums();
        $this->popup = null;
    
        $this->list_xsl = "admin/list.xsl";
        $this->edit_xsl = "admin/module/new.xsl";
        $this->new_xsl  = "admin/new.xsl";
        $this->defaultValues = array();
    }

    public function indexAction()
    {
        $profile = $this->_user->getProfile();
        $select = $this->db->select()
                           ->from(array('a'=>'module'), 'count(*)');

        $pagesize = $this->Param('pagesize');
        if (!$pagesize) {
            $pagesize = 50;
        }

        $count = $this->Param('count');
        $pnum = $this->Param('p');

        $s = $this->Param('s');

        $values = Array();

        
        $this->setCustomFilter($select);

        foreach (Module::$_meta_order as $name => $order) {
            if (
                isset($order[2])
                && is_array($order[2])
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
        $select->columns(Module::$_meta_select);

        foreach (Module::$_meta_order as $name => $order) {
            if (
                isset($order[2])
                && is_array($order[2])
            ) {
                $select->columns(array($name => $order[0]));
            }
        }
        $this->setCustomFields($select);
        if (isset($s) && $s) {
            list($s_name, $s_order) = explode(':',$s);
            $select->order(Module::$_meta_order[$s_name][$s_order]);
        }

        $select->limit($pagesize, $pagesize*($pnum-1));
        $stmt = $select->query();
        $rows = $stmt->fetchAll();

        $this->fv->PreVisible(Module::$_meta, $rows, $this->enums);

        $rows_xml = $this->xmlutils->getXML($rows, array('rootTag'    => 'rows',
                                                    'rowTag'     => 'row',
                                                    'attributes' => array('_id'    => 'id'),
                                                    'elements'   => array_keys($this->item->_meta_short_list)));

        $short_list=$this->item->Order2Xml($s);

        

        $values_xml = $this->xmlutils->Array2xmlQ($values);
        $values_xml .= $this->fv->MultiOptions($this->item->_meta_filter, $values);
        

        $this->HeaderNoCache();

        

        $page = new sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->addNamedBlock('head', $this->xmlutils->Array2xmlQ($profile));
        $page->addBlock($this->cmfScript->MakeLeftMenu());
        $input_mode = "n";
        if (isset($this->item->_meta_input) && sizeof($this->item->_meta_input) > 0) {
            $input_mode = "y";
        }

        $page->startSection('data', array('pagesize' => $pagesize,
                                          'input'    => $input_mode,
                                          'popup'    => $this->popup,
                                          ));
        $page->addTag('pager', '', array('count' => $count,
                                         'page' => $pnum,
                                         'pcount' => $pcount));
        $page->addNamedBlock('name', $this->scriptName);

        $page->addNamedBlock('cols', $short_list);

        

        $page->addBlock($rows_xml);
        

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

    
        $this->fv->PiceImages(Module::$_meta, $values);
        $this->fv->MakeEnums(Module::$_meta, $this->enums);

        $meta = $this->xmlutils->Meta2XML(Module::$_meta);

        $values_xml = $this->xmlutils->Form2XML($values);
        $values_xml .= $this->fv->MultiOptions(Module::$_meta, $values);
        $errors_xml = $this->fv->ErrorsXML($this->errors);

        $script_tree=$this->visibleTree($id,0);
        $page = new sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->addNamedBlock('head', $this->xmlutils->Array2xmlQ($profile));
        $page->addBlock($this->cmfScript->MakeLeftMenu());
        $page->startSection('data', array('edit'    => '',
                                          'id'      => $id,
                                          'p'       => $p));
        $this->addEditFields($id, $page);
        $page->addBlock($this->cmfScript->GetTabs($this->scriptInfo['id']));
        $page->addNamedBlock('name', $this->scriptName);
        $page->addNamedBlock('values', $values_xml);
        $page->addNamedBlock('meta', $meta);
        $page->addNamedBlock('errors', $errors_xml);
        $page->addNamedBlock('scripttree',$script_tree);
    
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
        $this->fv->MakeEnums(Module::$_meta, $this->enums);
        $meta = $this->xmlutils->Meta2XML(Module::$_meta);
        $values_xml = $this->fv->MultiOptions(Module::$_meta, $values);
        $values_xml .= $this->xmlutils->Form2XML($values);
        $errors_xml = $this->fv->ErrorsXML($this->errors);

        $page = new sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->addNamedBlock('head',$this->xmlutils->Array2xmlQ($profile));
        $page->addBlock($this->cmfScript->MakeLeftMenu());
        $page->startSection('data', array('new' => '',
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
        $this->errors = $this->fv->Validate(Module::$_meta, array_merge($_REQUEST, $_FILES), $fields);
        if (empty($this->errors)) {
            try {
                $id = $this->item->insert($fields);
                $this->cmfScript->clearRightsCache();
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
        $this->errors = $this->fv->Validate(Module::$_meta, array_merge($_REQUEST, $_FILES), $fields);
        if (empty($this->errors)) {
            try {
                $this->item->update($this->Param('id'), $fields);
                $cidarray=$this->Param('cid');
                $id=$this->Param('id');
                $this->db->delete('module_scripts', $this->db->quoteInto('module_id=?',$id) );
                if(is_array($cidarray)) {
                    foreach($cidarray as $k=>$v)
                    {
                            $this->db->insert('module_scripts',array('module_id'=>$id,'cmf_script_id'=>$v));
                    }
                }
                $this->cmfScript->clearRightsCache();
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
 
   function visibleTree($id)
   {
        $xw = new xmlWriter();
        $xw->openMemory();
        $xw->setIndent(true);
        $xw->startElement ('rows');
        $this->_visibleTree($xw,$id,0,0);
        $xw->endElement();
        return $xw->outputMemory(true);
   }

  function _visibleTree($xw,$id,$parent,$level)
  {
     $stmt = $this->db->query(
        'SELECT s.cmf_script_id AS id, s.name, s.lastnode AS last, IF(m.cmf_script_id, 1, 0) AS chk, s.type
         FROM cmf_script s left
         JOIN module_scripts m
            ON (m.module_id = ? AND s.cmf_script_id = m.cmf_script_id)
         WHERE s.parent_id = ?
         ORDER BY IF(s.type = 3, 0, 1), s.ordering',
        array($id,$parent)
     );
     $rows=$stmt->fetchAll();
     foreach($rows as &$row)
     {
        $xw->startElement ('row');
        $xw->writeAttribute('id',$row['id']);
        $xw->writeAttribute('chk',$row['chk']);
        $xw->writeAttribute('level',$level);
        $xw->writeElement ('name',$row['name']);
        $xw->writeElement('type', $row['type']);
        if(!$row['last']) $this->_visibleTree($xw,$id,$row['id'],$level+1);
        $xw->endElement(); // </row>
     }
  }


/** sorting actions **/

    public function sortAction()
    {

        unset($_COOKIE['s']);
        $s = $_GET['s'];
        $_COOKIE['s'] = $s;
        $_REQUEST['s'] = $s;
        if (isset($s) && $s) {
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
        if (isset($s) && $s) {
            setcookie('pagesize', $s , time()+1209600, "/site/admin/{$this->scriptName}/");  //set pagesize cookie for 2 weeks
        }
        $this->indexAction();
    }





    protected function addEditFields($id, $page)
    {
    }
}
