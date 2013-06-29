<?php
ini_set("display_errors","1");
error_reporting(E_ALL);
require('handlers.php');
set_include_path(get_include_path() . PATH_SEPARATOR . __DIR__. '/lib'. PATH_SEPARATOR . __DIR__.'/lib/Zend');

require ('lib/Config.php');
try{
    $myRoot = __DIR__;
    $config=new sabay\Config($myRoot);

    // Для запуска из коммандной строки
    if(isset($argv)){
        $_REQUEST['p_']=$argv[1];
        $_SERVER['HTTP_HOST']=$config->get('General', 'ROOTDOMAIN');
    }

    $host       = $_SERVER['HTTP_HOST'];
    $host_parts = explode('.', $host);
    $uri_parts  = explode('/', trim($_REQUEST['p_'], '/'));

    $__prefix = 'controlers/';

    if(empty($uri_parts[0]))
    {
        require ($__prefix . 'IndexController.php');
        $cnclass=new IndexController($config);
        $cnclass->dispatch(array());
    }
    else
    {
            $controler=ucfirst($uri_parts[0]).'Controller';
            if (is_file($__prefix . $controler. '.php')) {
                    $path = $__prefix . $controler . '.php';
                    array_shift($uri_parts);
                    require ($path);
                    $cnclass=new $controler($config);
                    $cnclass->dispatch($uri_parts);

            } elseif (is_dir($__prefix . $uri_parts[0])) {
                    if (empty($uri_parts[1])) $controler='IndexController';
                    else $controler=ucfirst($uri_parts[1]).'Controller';
                    if (is_file($__prefix . $uri_parts[0] . '/' . $controler . '.php')) {
                            $path = $__prefix . $uri_parts[0] . '/' .$controler. '.php';
                            array_shift($uri_parts);
                            array_shift($uri_parts);
                            require ($path);
                            $cnclass=new $controler($config);
                            $cnclass->dispatch($uri_parts);
                    } else {
                            $path = $__prefix . $uri_parts[0] . '/IndexController.php';
                            array_shift($uri_parts);
                            require ($path);
                            $cnclass=new IndexController($config);
                            $cnclass->dispatch($uri_parts);
                    }
            }
            else
            {
                    require ($__prefix . 'IndexController.php');
                    $cnclass=new IndexController($config);
                    $cnclass->dispatch($uri_parts);
            }
    }
}
catch(Exception $e)
{
        tizer_exception_handler($e);
}