<?php
require 'lib/Abstract_Admin_Controller.php';
require_once 'lib/validator.php';
require_once 'lib/xmlbox.php';
require_once 'models/CmfRole.php';
require_once 'models/User.php';
    
class CmfRoleController extends sabay\Abstract_Admin_Controller
{
    /**
     * @var User
     */
    protected $_user   = null;
    /**
     * @var CmfRole
     */
    protected $item    = null;
    /**
     * @var FormValidator
     */
    protected $fv      = null;
    protected $scriptName = 'CmfRole';
    
    protected $defaultValues = array();

    public function init()
    {
        $this->item   = new CmfRole($this->config);
        $this->fv     = new \sabay\FormValidator($this->config, $this, 'CmfRoleValidator');
        $this->errors = array();
        $this->_user  = new User($this->config, $this->userId);
        
        $this->enums = $this->item->getMetaEnums();
        $this->popup = null;
    
        $this->list_xsl = "admin/list.xsl";
        $this->edit_xsl = "admin/role/new.xsl";
        $this->new_xsl  = "admin/role/new.xsl";
        $this->defaultValues = array();
    }

    public function indexAction()
    {
        $profile = $this->_user->getProfile();
        $select = $this->db->select()
                           ->from(array('a'=>'cmf_role'), 'count(*)');

        $pagesize = $this->Param('pagesize');
        if (!$pagesize) {
            $pagesize = 50;
        }

        $count = $this->Param('count');
        $pnum = $this->Param('p');

        $s = $this->Param('s');

        $values = Array();

        
        $this->setCustomFilter($select);

        foreach (CmfRole::$_meta_order as $name => $order) {
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
        $select->columns(CmfRole::$_meta_select);

        foreach (CmfRole::$_meta_order as $name => $order) {
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
            $select->order(CmfRole::$_meta_order[$s_name][$s_order]);
        }

        $select->limit($pagesize, $pagesize*($pnum-1));
        $stmt = $select->query();
        $rows = $stmt->fetchAll();

        $this->fv->PreVisible(CmfRole::$_meta, $rows, $this->enums);

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
    
        $this->fv->PiceImages(CmfRole::$_meta, $values);
        $this->fv->MakeEnums(CmfRole::$_meta, $this->enums);

        $meta = $this->xmlutils->Meta2XML(CmfRole::$_meta);

        $values_xml = $this->xmlutils->Form2XML($values);
        $values_xml .= $this->fv->MultiOptions(CmfRole::$_meta, $values);
        $errors_xml = $this->fv->ErrorsXML($this->errors);

        $rows = $this->db->fetchAll('SELECT m.module_id as id, m.name,s.is_editor,s.restriction_id FROM  module m left join cmf_role_module_link s on (m.module_id=s.module_id and s.cmf_role_id=?)',$id);

        $page = new sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->addNamedBlock('head', $this->xmlutils->Array2xmlQ($profile));
        $page->addBlock($this->cmfScript->MakeLeftMenu());
        $page->startSection('data', array('edit'    => '',
                                          'id'      => $id,
                                          'p'       => $p));
        $this->addEditFields($id, $page);
        $page->addBlock($this->cmfScript->GetTabs($this->script_id));
        $page->addNamedBlock('name', $this->scriptName);
        $page->addNamedBlock('values', $values_xml);
        $page->addNamedBlock('meta', $meta);
        $page->addNamedBlock('errors', $errors_xml);
        $page->addBlock($this->xmlutils->getFlatXML($rows ,'fullist', 'row'));

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
        $this->fv->MakeEnums(CmfRole::$_meta, $this->enums);
        $meta = $this->xmlutils->Meta2XML(CmfRole::$_meta);
        $values_xml = $this->fv->MultiOptions(CmfRole::$_meta, $values);
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
        $this->errors = $this->fv->Validate(CmfRole::$_meta, array_merge($_REQUEST, $_FILES), $fields);
        if (empty($this->errors)) {
            try {
                $id = $this->item->insert($fields);
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
        $this->errors = $this->fv->Validate(CmfRole::$_meta, array_merge($_REQUEST, $_FILES), $fields);
        if (empty($this->errors)) {
            try {
                $this->item->update($this->Param('id'), $fields);
                $this->_rsaveAction();
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
                    $this->db->delete('cmf_role_module_link', $this->db->quoteInto('cmf_role_id=?',$id));
                }
            $this->cmfScript->clearRightsCache();
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


 function _rsaveAction() {
   $id=$this->Param('id');
   $this->db->query('DELETE FROM cmf_role_module_link WHERE cmf_role_id = ?', $id);
    $isEditorList = $this->Param('is_editor');
    if(is_array($this->Param('module_id'))) {
      foreach ($this->Param('module_id') as $moduleId) {
        $this->db->query('INSERT INTO cmf_role_module_link (cmf_role_id, module_id, is_editor, restriction_id) VALUES (?, ?, ?, ?)', array($id, $moduleId, isset($isEditorList[$moduleId]),isset($moduleId)));
      }
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
