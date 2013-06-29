<?php
require 'lib/Abstract_Admin_Controller.php';
class IndexController extends sabay\Abstract_Admin_Controller
{
    public function init()
    {
        parent::init();
        $id=intval($this->Param('id'));
        if(!$id) $id=1;
        $this->cmfScript->GetPath($id);
        $this->script_id = $id;
/*        $this->cmf->setArticleById($id);
        $this->userId = $this->cmf->Session();
        if (!$this->cmf->GetRights($this->userId)) {
            header('Location: /site/admin/login/');
            exit;
        }
*/
    }
    public function indexAction()
    {
        $page=new sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->addNamedBlock('head', $this->getProfile());
        $page->addBlock($this->cmfScript->MakeLeftMenu());
        $page->startSection('data');
        $page->stopSection();
        $page->Transform('admin/index.xsl');
    }
}

