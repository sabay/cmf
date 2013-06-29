<?
namespace sabay;
require 'lib/Abstract_Controller.php';
require 'lib/xmlbox.php';
include_once 'lib/Session.php';
include_once 'lib/xmlutils.php';
include_once 'models/CmfScript.php';

class Abstract_User_Controller extends Abstract_Controller
{
    public $userId = 0;
    public $session_id=0;
    protected $scriptInfo = null;
    protected $session = null;

    public function __construct($config)
    {
        $this->cmfScript= new \CmfScript($config);
        $this->db=$config->DB();
        if(!isset($this->article))
            $this->article = 'U'.str_replace('Controller', '', get_class($this));
        $this->scriptInfo= $this->cmfScript->scriptInfo($this->article);
        $this->script_id = $this->scriptInfo['id'];
        $this->xmlutils = new XMLUtils();
        parent::__construct($config);
        if(!isset($this->cmfScript->PATH_ARRAY)){
            $this->cmfScript->GetPath($this->script_id);
        }
        $this->session = new \sabay\Session($config,'___UID');
        $this->session->get($this);
        if (!$this->cmfScript->GetRights($this->userId, $this->script_id)) {
            header('Location: '.$config->get('General','HTTP_ROOT').'/login/');
            exit;
        }
    }

    protected function getProfile()
    {
        return "";//$this->cmf->Array2xmlQ($this->cmf->getProfile());
    }

    public function redirectToIndex()
    {
        header('location: '.$config->get('General','HTTP_ROOT').'/'.$this->article.'/');
        exit;
    }

/** pagesize actions **/

 public function pagesizeAction() {
    unset($_COOKIE['pagesize']);
    $s=array_key_exists('pagesize',$_POST)? $_POST['pagesize']:50;
    $_COOKIE['pagesize'] = $s;
    $_REQUEST['pagesize'] = $s;
    if(isset($s) && $s){
        setcookie('pagesize', $s , time()+1209600, '/'.$config->get('General','HTTP_ROOT').'/'.$this->scriptName.'/');  //set pagesize cookie for 2 weeks
    }
        $this->indexAction();

 }

}
