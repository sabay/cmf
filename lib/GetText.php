<?php
namespace sabay;

class GetText {
    protected $errorList = array();
    protected $rootDir   = '';

    public function __construct($name, $langCode = '', $addList = array())
    {
        $this->rootDir = realpath(dirname(__FILE__) . '/../');
        $this->loadMessageList('Common', $langCode);
        if ($addList && !is_array($addList)) {
            $addList = array($addList);
        }
        foreach ($addList as $add) {
            $this->loadMessageList($add, $langCode);
        }
        $this->loadMessageList($name, $langCode);
    }

    public function getErrorList()
    {
        return $this->errorList;
    }

    public function getText($text)
    {
        return isset($this->errorList[$text]) ? $this->errorList[$text] : $text;
    }

    public function setText($code, $text)
    {
        $this->errorList[$code] = $text;
    }

    protected function loadMessageList($name, $langCode)
    {
        if (file_exists("{$this->rootDir}/msg/$name.php")) {
            include "{$this->rootDir}/msg/$name.php";
            $this->errorList = array_merge($this->errorList, $messageList);
        }
        if (file_exists("{$this->rootDir}/msg/{$langCode}/$name.php")) {
            include "{$this->rootDir}/msg/{$langCode}/$name.php";
            $this->errorList = array_merge($this->errorList, $messageList);
        }
    }
}
