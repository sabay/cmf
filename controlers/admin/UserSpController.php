<?php
require 'UserController.php';

class UserSpController extends UserController
{
 protected $scriptName = 'UserSp';
 protected $article = 'USER';

 public function init() {
   parent::init();
   $this->popup="spopup";
   $this->list_xsl ="admin/popup.xsl";
 }

 // public function editAction($id=null,$values=array()) {}

 // public function updateAction() {}

 public function deleteAction() {}

 public function saveindexAction() {}


 //public function newAction($values=array()) {}

// public function insertAction() {}


}