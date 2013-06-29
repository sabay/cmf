<?php
require 'lib/Abstract_Admin_Controller.php';
require_once 'lib/validator.php';
require_once 'lib/xmlbox.php';
require_once 'models/Session_.php';
require_once 'models/User.php';
    
class Session_Controller extends sabay\Abstract_Admin_Controller
{
    /**
     * @var User
     */
    protected $_user   = null;
    /**
     * @var Session_
     */
    protected $item    = null;
    /**
     * @var FormValidator
     */
    protected $fv      = null;
    protected $scriptName = 'Session_';
    
    protected $defaultValues = array();

    public function init()
    {
        $this->item   = new Session_($this->cmf);
        $this->fv     = new \sabay\FormValidator($this->cmf, $this, 'Session_Validator');
        $this->errors = array();
        $this->_user  = new User($this->cmf, $this->userId);
        
        $this->enums = $this->item->getMetaEnums();
        $this->popup = null;
    
        $this->list_xsl = "admin/list.xsl";
        $this->edit_xsl = "admin/new.xsl";
        $this->new_xsl  = "admin/new.xsl";
        $this->defaultValues = array();
    }

    public function indexAction()
    {
        $profile = $this->_user->getProfile();
        $select = $this->db->select()
                           ->from(array('a'=>'session_'), 'count(*)');

        $pagesize = $this->Param('pagesize');
        if (!$pagesize) {
            $pagesize = 50;
        }

        $count = $this->Param('count');
        $pnum = $this->Param('p');

        $s = $this->Param('s');

        $values = Array();

        
        $this->setCustomFilter($select);

        foreach (Session_::$_meta_order as $name => $order) {
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
        $select->columns(Session_::$_meta_select);

        foreach (Session_::$_meta_order as $name => $order) {
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
            $select->order(Session_::$_meta_order[$s_name][$s_order]);
        }

        $select->limit($pagesize, $pagesize*($pnum-1));
        $stmt = $select->query();
        $rows = $stmt->fetchAll();

        $this->fv->PreVisible(Session_::$_meta, $rows, $this->enums);

        $rows_xml = $this->cmf->getXML($rows, array('rootTag'    => 'rows',
                                                    'rowTag'     => 'row',
                                                    'attributes' => array('_id'    => 'id'),
                                                    'elements'   => array_keys($this->item->_meta_short_list)));

        $short_list=$this->item->Order2Xml($s);

        

        $values_xml = $this->cmf->Array2XmlQ($values);
        $values_xml .= $this->fv->MultiOptions($this->item->_meta_filter, $values);
        

        $this->cmf->HeaderNoCache();

        

        $page = new XMLBox(true);
        $page->addNamedBlock('head', $this->cmf->Array2XmlQ($profile));
        $page->addBlock($this->cmf->MakeLeftMenu());
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
        $this->cmf->Transform($this->list_xsl, $page->getXML());
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

        $this->cmf->HeaderNoCache();
        if (empty($values)) {
            $values = $this->item->_load($id);
        }

    
        $this->fv->PiceImages(Session_::$_meta, $values);
        $this->fv->MakeEnums(Session_::$_meta, $this->enums);

        $meta = $this->cmf->Meta2XML(Session_::$_meta);

        $values_xml = $this->cmf->Form2XML($values);
        $values_xml .= $this->fv->MultiOptions(Session_::$_meta, $values);
        $errors_xml = $this->fv->ErrorsXML($this->errors);

        $page = new XMLBox(true);
        $page->addNamedBlock('head', $this->cmf->Array2XmlQ($profile));
        $page->addBlock($this->cmf->MakeLeftMenu());
        $page->startSection('data', array('edit'    => '',
                                          'id'      => $id,
                                          'p'       => $p));
        $this->addEditFields($id, $page);
        $page->addBlock($this->cmf->GetTabs());
        $page->addNamedBlock('name', $this->scriptName);
        $page->addNamedBlock('values', $values_xml);
        $page->addNamedBlock('meta', $meta);
        $page->addNamedBlock('errors', $errors_xml);
    
        $page->stopSection();

        $this->cmf->Transform($this->edit_xsl, $page->getXML());
    }

    public function newAction($values = array())
    {
        if (!$values) {
            $values = $this->defaultValues;
        }
        $p = $this->Param('p');
        $profile = $this->_user->getProfile();
        $this->cmf->HeaderNoCache();
        $this->fv->MakeEnums(Session_::$_meta, $this->enums);
        $meta = $this->cmf->Meta2XML(Session_::$_meta);
        $values_xml = $this->fv->MultiOptions(Session_::$_meta, $values);
        $values_xml .= $this->cmf->Form2XML($values);
        $errors_xml = $this->fv->ErrorsXML($this->errors);

        $page = new XMLBox(true);
        $page->addNamedBlock('head',$this->cmf->Array2XmlQ($profile));
        $page->addBlock($this->cmf->MakeLeftMenu());
        $page->startSection('data', array('new' => '',
                                          'p'   => $p));
        $page->addNamedBlock('name', $this->scriptName);
        $page->addNamedBlock('values', $values_xml);
        $page->addNamedBlock('meta', $meta);
        $page->addNamedBlock('errors', $errors_xml);
        $page->stopSection();

        $this->cmf->Transform($this->new_xsl, $page->getXML());
    }

    public function insertAction()
    {
        $fields = array();
        $this->errors = $this->fv->Validate(Session_::$_meta, array_merge($_REQUEST, $_FILES), $fields);
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
        $this->errors = $this->fv->Validate(Session_::$_meta, array_merge($_REQUEST, $_FILES), $fields);
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
