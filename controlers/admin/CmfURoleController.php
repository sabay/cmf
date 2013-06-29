<?php
require 'lib/Abstract_Admin_Controller.php';
require_once 'lib/validator.php';
require_once 'lib/xmlbox.php';
require_once 'models/CmfURole.php';
        
require_once 'models/User.php';
    

class CmfURoleController extends sabay\Abstract_Admin_Controller
{
    /**
     * @var User
     */
    protected $_user    = null;
    protected $pid      = null;
    /**
     * @var CmfURole
     */
    protected $item     = null;
    protected $scriptName = 'CmfURole';
    protected $list_xsl = 'admin/childlist.xsl';
    protected $edit_xsl = 'admin/childnew.xsl';
    protected $new_xsl = 'admin/childnew.xsl';
     

    public function init()
    {
        $this->item   = new CmfURole($this->config);
        $this->fv     = new \sabay\FormValidator($this->config, $this, 'CmfURoleValidator');
        $this->errors = array();
        $this->_user  = new User($this->config, $this->userId);

        $this->enums = $this->item->getMetaEnums();
        $this->pid = $this->Param('pid');
    
    }

    public function indexAction()
    {
        $profile = $this->_user->getProfile();

        $pagesize = intval($this->Param('pagesize'));
        if (!$pagesize || ($pagesize == 0) || ($pagesize < 0)) {
            $pagesize = 50;
        }
        $count = intval($this->Param('count'));
        $pnum = intval($this->Param('p'));
        $s = $this->Param('s');

        if (!$count) {
            $count = $this->db->fetchOne('SELECT COUNT(*) FROM cmf_user_role_link WHERE user_id=?', $this->pid);
        }
        $pcount = ceil($count/$pagesize);
        if ($pnum > $pcount) {
            $pnum = $pcount;
        }
        if ($pnum == 0) {
            $pnum = 1;
        }

        $select = $this->db->select()
                           ->from(array('a'=>'cmf_user_role_link'), CmfURole::$_meta_select)
                           ->where('a.user_id=?', $this->pid)
;

        foreach (CmfURole::$_meta_order as $name => $order) {
            if (
                isset($order[2])
                && is_array($order[2])
            ) {
                $select->joinLeft($order[2][0], $order[2][1], array());
            }
        }

        if (isset($s) && $s) {
            list($s_name, $s_order) = explode(':', $s);
            $select->order(CmfURole::$_meta_order[$s_name][$s_order]);
        }
        $select->limit($pagesize, $pagesize*($pnum-1));

        $stmt = $select->query();

        $short_list = $this->item->Order2Xml($s);

        $rows = $stmt->fetchAll();
        $this->fv->PreVisible(CmfURole::$_meta, $rows, $this->enums);
        $rows_xml = $this->xmlutils
                         ->getXML($rows,
                                  array('rootTag'    => 'rows',
                                        'rowTag'     => 'row',
                                        'attributes' => array('_id' => 'id'),
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
        $page->addBlock($this->cmfScript->getUpTabs($this->scriptInfo['id']));
        $page->addNamedBlock('name', $this->scriptName);
        
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

        $this->fv->PiceImages(CmfURole::$_meta, $values);
        $this->fv->MakeEnums(CmfURole::$_meta, $this->enums);
        $meta = $this->xmlutils->Meta2XML(CmfURole::$_meta);

        $values_xml = $this->xmlutils->Form2XML($values);
        $values_xml .= $this->fv->MultiOptions(CmfURole::$_meta, $values);
        $errors_xml = $this->fv->ErrorsXML($this->errors);

        $page = new sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->addNamedBlock('head',$this->xmlutils->Array2xmlQ($profile));
        $page->addBlock($this->cmfScript->MakeLeftMenu());
        $page->startSection('data', array('edit' => '',
                                          'id'   => $id,
                                          'pid'  => $this->pid,
                                          'p'    => $p));
        $page->addNamedBlock('name', $this->scriptName);
        
        $page->addNamedBlock('values', $values_xml);
        $page->addBlock($this->xmlutils
                         ->getXML($this->item->xmls,
                                  array('rootTag'    => 'xmls',
                                        'rowTag'     => 'xmlitem',
                                        'attributes' => array('type' => 'id'),
                                        'elements'   => array('name' => 'name'))));
        $page->addNamedBlock('meta', $meta);
        $page->addNamedBlock('errors', $errors_xml);
    
        $page->stopSection();

        $page->Transform($this->edit_xsl);
    }

    public function newAction($values=array())
    {
        $profile = $this->_user->getProfile();

        $p = $this->Param('p');

        $this->HeaderNoCache();
        $this->fv->MakeEnums(CmfURole::$_meta, $this->enums);
        $meta = $this->xmlutils->Meta2XML(CmfURole::$_meta);
        $values_xml = $this->fv->MultiOptions(CmfURole::$_meta, $values);
        $values_xml .= $this->xmlutils->Array2xmlQ($values);
        $errors_xml = $this->fv->ErrorsXML($this->errors);

        $page = new sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->addNamedBlock('head', $this->xmlutils->Array2xmlQ($profile));
        $page->addBlock($this->cmfScript->MakeLeftMenu());
        $page->startSection('data', array('new' => '', 'pid' => $this->pid, 'p' => $p));
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
        $this->errors = $this->fv->Validate(CmfURole::$_meta,
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
        $this->errors = $this->fv->Validate(CmfURole::$_meta,
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


}
