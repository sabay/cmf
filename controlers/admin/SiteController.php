<?php
require 'lib/Abstract_Admin_Controller.php';
require_once 'lib/validator.php';
require_once 'lib/xmlbox.php';
require_once 'models/Site.php';
require_once 'models/User.php';
    
class SiteController extends sabay\Abstract_Admin_Controller
{
    /**
     * @var User
     */
    protected $_user   = null;
    /**
     * @var Site
     */
    protected $item    = null;
    /**
     * @var FormValidator
     */
    protected $fv      = null;
    protected $scriptName = 'Site';
    
    protected $defaultValues = array();

    public function init()
    {
        $this->item   = new Site($this->config);
        $this->fv     = new \sabay\FormValidator($this->config, $this, 'SiteValidator');
        $this->errors = array();
        $this->_user  = new User($this->config, $this->userId);
        
        $this->enums = $this->item->getMetaEnums();
        $this->popup = null;
    
        $this->list_xsl = "admin/site/list.xsl";
        $this->edit_xsl = "admin/new.xsl";
        $this->new_xsl  = "admin/new.xsl";
        $this->defaultValues = array();
    }

    public function indexAction()
    {
        $profile = $this->_user->getProfile();
        $select = $this->db->select()
                           ->from(array('a'=>'site'), array('cnt'=>'count(*)','sumpercent'=>'sum(redirpercent)'));

        $pagesize = $this->Param('pagesize');
        if (!$pagesize) {
            $pagesize = 50;
        }

        $count = $this->Param('count');
        $pnum = $this->Param('p');

        $s = $this->Param('s');

        $values = Array();

        
        $this->setCustomFilter($select);

        foreach (Site::$_meta_order as $name => $order) {
            if (
                isset($order[2])
                && is_array($order[2])
            ) {
                $select->joinLeft($order[2][0], $order[2][1], array());
            }
        }

        $tmpr=$this->db->fetchRow($select);
        $sumpercent = $tmpr['sumpercent'];
        $count = $tmpr['cnt'];

        $pcount = ceil($count/$pagesize);
        if ($pnum > $pcount) {
            $pnum = $pcount;
        }
        if ($pnum == 0) {
            $pnum = 1;
        }

        $select->reset('columns');
        $select->columns(Site::$_meta_select);

        foreach (Site::$_meta_order as $name => $order) {
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
            $select->order(Site::$_meta_order[$s_name][$s_order]);
        }

        $select->limit($pagesize, $pagesize*($pnum-1));
        $stmt = $select->query();
        $rows = $stmt->fetchAll();

        $this->fv->PreVisible(Site::$_meta, $rows, $this->enums);

        $rows_xml = $this->xmlutils->getXML($rows, array('rootTag'    => 'rows',
                                                    'rowTag'     => 'row',
                                                    'attributes' => array('_id'    => 'id',
                                                                          '_state' =>'status'),
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
                                          'sumpercent' => $sumpercent
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

    
        $this->fv->PiceImages(Site::$_meta, $values);
        $this->fv->MakeEnums(Site::$_meta, $this->enums);

        $meta = $this->xmlutils->Meta2XML(Site::$_meta);

        $values_xml = $this->xmlutils->Form2XML($values);
        $values_xml .= $this->fv->MultiOptions(Site::$_meta, $values);
        $errors_xml = $this->fv->ErrorsXML($this->errors);

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
        $this->fv->MakeEnums(Site::$_meta, $this->enums);
        $meta = $this->xmlutils->Meta2XML(Site::$_meta);
        $values_xml = $this->fv->MultiOptions(Site::$_meta, $values);
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
        $this->errors = $this->fv->Validate(Site::$_meta, array_merge($_REQUEST, $_FILES), $fields);
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
        $this->errors = $this->fv->Validate(Site::$_meta, array_merge($_REQUEST, $_FILES), $fields);
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
