<?php
namespace sabay;
abstract class Abstract_Controller
{
    protected $config= null;

    public function __construct($config)
    {
        $this->config = $config;
        $this->init();
    }

    /**
     * Initialize object
     *
     * Called from {@link __construct()} as final step of object instantiation.
     *
     * @return void
     */
    public function init()
    {
    }

    public function setConfig($config_)
    {
        $this->config=$config_;
    }

    public function dispatch($parts)
    {
        $action='indexAction';
        if(isset($parts[0]))
        {
            if(in_array($parts[0].'Action', get_class_methods($this)))
            {
                $action=$parts[0].'Action';
                array_shift($parts);
            }
        }
        $this->parts=$parts;
        $this->path=implode('/',$parts);
        call_user_func(array($this, $action));
    }


    function Header()
    {
        header('Content-type: text/html; charset=utf-8');
    }

    function HeaderNoCache()
    {
        header('Content-type: text/html; charset=utf-8');
        header('Pragma: no-cache');
        header('Cache-Control: private, no-cache');
    }

    /**
     * Возвращает значение объекта $name из $_REQUEST, либо значение $elseValue
     *
     * @param string $name Название переменной в запросе
     * @param mixed $elseValue Значение которое возвратится, если основное значение не найдено (по умолчанию null)
     * @return string Значение переменной, либо значение elseValue
     */
    public function Param($name, $elseValue = null)
    {
        return isset($_REQUEST[$name])?$_REQUEST[$name]:$elseValue;
    }

    function ParamQ($name, $elseValue = null)
    {
        return isset($_REQUEST[$name]) ? htmlspecialchars($_REQUEST[$name], ENT_NOQUOTES) : $elseValue;
    }

}
