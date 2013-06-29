<?php
exit(0);
require 'lib/Abstract_User_Controller.php';

class IndexController extends sabay\Abstract_User_Controller
{
    public $article='UIndex';

    public function init()
    {
    }

    public function indexAction()
    {
        print "111";
    }
}
