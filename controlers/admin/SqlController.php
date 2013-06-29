<?php
require 'lib/Abstract_Admin_Controller.php';
require_once 'lib/validator.php';
require_once 'lib/xmlbox.php';
require_once 'models/CmfRole.php';
require_once 'models/User.php';
    

class SqlController extends sabay\Abstract_Admin_Controller
{
    protected $article  = 'MYSQLEDITOR';
    protected $user     = null;

    public function init()
    {
        $this->user = new User($this->config, $this->userId);
    }

    public function indexAction()
    {
        $this->pageBox = new \sabay\XMLBox($this->config);
        $this->pageBox->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $this->pageBox->addNamedBlock('head', $this->getProfile());
        $this->pageBox->addBlock($this->cmfScript->MakeLeftMenu());

        $this->pageBox->startSection('data');
        $this->pageBox->addTag('query', $this->Param('query'));
        $this->pageBox->startSection('table');
        if ($this->Param('e') == 'execute') {
            try {
                $this->db->query($this->Param('query'));
            } catch (Exception $e) {
                $this->pageBox->addTag('pre', $e->getMessage() . "\n");
            }
        } elseif ($this->Param('e') == 'select') {
            try {
                $rowset = $this->db->fetchAll($this->Param('query'));
            } catch (Zend_Db_Exception $e) {
                $this->pageBox->addTag('pre', $e->getMessage() . "\n");
                $rowset = array();
            }
            $this->pageBox->startSection('table', array('border' => '1'));
            $first = true;
            foreach ($rowset as $row) {
                if ($first) {
                    $this->pageBox->startSection('tr', array('bgcolor' => '#A0A0A0'));
                    foreach ($row as $k => $v) {
                        $this->pageBox->addTag('th', $k);
                    }
                    $this->pageBox->stopSection();
                    $first = false;
                }
                $this->pageBox->startSection('tr');
                foreach ($row as $v) {
                    $this->pageBox->addTag('td', $v);
                }
                $this->pageBox->stopSection();
            }
            $this->pageBox->stopSection();
        }
        $this->pageBox->stopSection();
        $this->pageBox->stopSection();
        $this->HeaderNoCache();
        $this->pageBox->Transform('admin/sql.xsl');
    }
}
