<?php
require 'lib/Abstract_Admin_Controller.php';
require_once 'lib/validator.php';
require_once 'lib/xmlbox.php';
require_once 'models/CmfScript.php';
require_once 'models/User.php';
    

class CmfScriptController extends sabay\Abstract_Admin_Controller
{
    /**
     * @var User
     */
    protected $user    = null;
    /**
     * @var CmfScript
     */
    protected $item    = null;
    protected $scriptName = 'CmfScript';
    protected $rootId  = 0;

    

    public function init()
    {
        $this->item   = new CmfScript($this->config);
        $this->fv     = new \sabay\FormValidator($this->config, $this, 'CmfScriptValidator');
        $this->errors = array();
        $this->_user  = new User($this->config, $this->userId);

        $this->enums  = $this->item->getMetaEnums();
    
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
                                             'attributes' => array('_id'        =>'id',
                                                                   '_state'     =>'state',
                                                                   'realstatus' =>'rstate',
                                                                   '_last'      =>'lastnode'),
                                             'elements'   => array_keys($this->item->_meta_short_list)));
        $this->HeaderNoCache();

        $page = new \sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->addNamedBlock('head', $this->xmlutils->Array2XmlQ($profile));
        $page->addBlock($this->cmfScript->MakeLeftMenu());
        $page->startSection('data', array('imgpath' => $this->item->imagePath));
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
        $this->fv->PiceImages(CmfScript::$_meta, $values);
        $this->fv->MakeEnums(CmfScript::$_meta, $this->enums);
        $meta=$this->xmlutils->Meta2XML(CmfScript::$_meta);
    
        $values_xml = $this->xmlutils->Array2XmlQ($values);
        $values_xml .= $this->fv->MultiOptions(CmfScript::$_meta, $values);
        $errors_xml = $this->fv->ToXML($this->errors);

        $page=new \sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->addNamedBlock('head', $this->xmlutils->Array2XmlQ($profile));
        $page->addBlock($this->cmfScript->MakeLeftMenu());
        $page->startSection('data', array('edit' => 'y','id' => $id, 'imgpath' => $this->item->imagePath));
        $page->addNamedBlock('name', $this->scriptName);
        $page->addNamedBlock('values', $values_xml);
        $page->addNamedBlock('meta', $meta);
        $page->addNamedBlock('errors', $errors_xml);
    
        $page->stopSection();
        $page->Transform($this->edit_xsl);
    }

    public function newAction($values = array())
    {
        $profile = $this->_user->getProfile();
        $this->HeaderNoCache();
        $this->fv->MakeEnums(CmfScript::$_meta, $this->enums);
        $meta = $this->xmlutils->Meta2XML(CmfScript::$_meta);
        $values_xml = $this->fv->MultiOptions(CmfScript::$_meta, $values);
        $values_xml .= $this->xmlutils->Array2XmlQ($values);
        $errors_xml = $this->fv->ToXML($this->errors);
        $page = new \sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->addNamedBlock('head',$this->xmlutils->Array2XmlQ($profile));
        $page->addBlock($this->cmfScript->MakeLeftMenu());
        $page->startSection('data', array('pid' => intval($this->Param('pid')),
                                          'new' => 'y',
                                          'imgpath' => $this->item->imagePath));
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

        if(!array_key_exists('status',$fields)||is_null($fields["status"]))$fields["status"]=0;

        $this->errors = $this->fv->Validate(CmfScript::$_meta, array_merge($_REQUEST, $_FILES), $fields);
        if (empty($this->errors)) {
            try {
                $id = $this->item->insert($fields);

                $select = $this->db->select()
                                   ->from(array('a'=>'cmf_script'), 'parent_id')
                                   ->where('a.cmf_script_id=?', $id);
                $parentId = $this->db->fetchOne($select);

                $lastnode = 0;

                $this->db->update('cmf_script', array('lastnode' => $lastnode),
                $this->db->quoteInto('cmf_script_id = ?', $parentId));

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
        if(!array_key_exists('status',$fields)||is_null($fields["status"]))$fields["status"]=0;
        $this->errors = $this->fv->Validate(CmfScript::$_meta, array_merge($_REQUEST, $_FILES), $fields);
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
                               ->from(array('a'=>'cmf_script'), 'parent_id')
                               ->where('a.cmf_script_id = ?', $this->Param('id'));
            $parentId = $this->db->fetchOne($select);

            $this->item->delete($this->Param('id'));

            $select = $this->db->select()
                               ->from(array('a'=>'cmf_script'), 'count(*)')
                               ->where('a.parent_id = ?', $parentId);

            $count = $this->db->fetchOne($select);
            $lastnode = ($count>0) ? 0 : 1;

            $this->db->update('cmf_script', array('lastnode' => $lastnode),
            $this->db->quoteInto('cmf_script_id = ?', $parentId));

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

            $new = $this->db->fetchOne('select MAX(ordering) from cmf_script
                where parent_id = ?',  array($toid));

          $this->item->updateMove($fromid,
            array(
                'parent_id' => $toid,
                'ordering' => intval($new) + 1));
          $this->indexAction();
    }

    public function vsAction()
    {
        $this->item->vs($this->Param('id'));
        $this->indexAction();
    }

    protected function visibleTree($parent, $level, &$parhash, $options)
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
        $this->_visibleTree($xw, $parent, $level, &$parhash, $options);
        $xw->endElement(); // root
        return $xw->outputMemory(true);
    }

    function _visibleTree($xw, $parent, $level, &$parhash, &$options)
    {
        $select = $this->db->select()
                           ->from(array('a'=>'cmf_script'),CmfScript::$_meta_select)
                           ->where('a.parent_id=?', $parent)
                           ->order('a.ordering');
        $this->setCustomFilter($select);

        $stmt = $select->query();
        $short_list = $this->xmlutils->Array2XmlQ($this->item->_meta_short_list);
        $rows = $stmt->fetchAll();
        $this->fv->PreVisible(CmfScript::$_meta, $rows, $this->enums);
        foreach ($rows as &$row) {
            $xw->startElement ($options['rowTag']);
            $xw->writeAttribute('level',$level);
            foreach ($options['attributes'] as $vk => $vv) {
                if (is_int($vk)) {
                    $xw->writeAttribute($vv,$row[$vv]);
                    if (($vv == 'id') && in_array($row[$vv],$parhash)) {
                        $xw->writeAttribute('openleaf', 1);
                    }
                } else {
                    $xw->writeAttribute ($vv,$row[$vk]);
                    if (($vv == 'id') && in_array($row[$vk],$parhash)) {
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


    protected function setCustomFilter($select)
    {
    }
}
