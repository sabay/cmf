<?php
require_once 'lib/Abstract_Controller.php';
include_once 'lib/Session.php';
require_once 'lib/xmlbox.php';
require_once 'models/User.php';
require_once 'models/CmfRole.php';
include_once 'models/CmfScript.php';

class LoginController extends sabay\Abstract_Controller
{
    public $userId=0;
    public $session_id=0;
    private $message='';

    public function init()
    {

        $this->session = new \sabay\Session($this->config,'___UID');
        $this->session->get($this);
        $this->message = '';
    }

    public function indexAction()
    {
        if ($this->Param('act') == 'logout') {
            $redirect = $this->Param('redirect');
            if ($redirect == '') {
                $redirect = '/login/';
            }
            $this->session->logout($this->session_id,$redirect);
            exit;
        }
        if($this->Param('act') == 'login'){
            $this->userId=0;
            if(
                preg_match("/\S/", $this->Param('email'))
                && preg_match("/\S/", $this->Param('pass'))
            ){
                $user = new User($this->config);
                $profile=$user->login($this->Param('email'),$this->Param('pass'));
                if(is_array($profile)){
                    $this->session->createSession($profile['user_id'],0,$profile);
                    $this->userId=$profile['user_id'];
                } else {
                    $this->error = '<error type="email">Не верный логин или пароль</error>';
                }
            } else {
                $this->error = '<error type="email">Укажите e-mail адрес и пароль</error>';
            }
        }
        if ($this->userId >0) {
            $this->article='UIndex';
            $cmfScript= new \CmfScript($this->config);
            $this->scriptInfo= $cmfScript->scriptInfo($this->article);
            if ($cmfScript->GetRights($this->userId,$this->scriptInfo['id'])) {
                header('Location: '.$this->config->get('General','HTTP_ROOT').'/'); // ?????????????
                exit;
            } else {
                $this->error = '<error type="email">У Вас не достаточно прав для доступа в корневой раздел</error>';
            }
        }
        $this->error .= '<email>'.$this->paramQ('email').'</email>';
        $this->dump();
    }

    protected function dump()
    {
        $page=new \sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->startSection('data');
        $page->addBlock($this->error);
        $page->stopSection();
        $page->Transform('/login.xsl');
    }
}
