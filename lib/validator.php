<?php
namespace sabay;
require_once 'lib/GetText.php';
include_once 'lib/xmlutils.php';

class FormValidator
{
    protected $controller;
    private $currentField;
    private $currentFieldAttrs;
    private $_aData;
    /**
     * @var GetText_
     */
    protected $gettext = null;

    /**
     * Копия массива meta, для использовния валидаторами.
     */
    protected $meta;

    /**
     * @var SCMF
     */
    protected $config = null;
    protected $xmlutils;

    protected $urlRegExp = '(https?://)?([a-zа-я0-9\-]+\.)+[a-zрф]{2,4}(:[0-9]+)*[a-z0-9.,?\'\\+&amp;:/%$#=~_\-]*';

    public function __construct($config, $controller = null, $messageFile = '')
    {
        $this->config = $config;
        $this->controller = $controller;
        $this->gettext = new \sabay\GetText($messageFile != '' ? $messageFile
                                                         : get_class($this),
                                      'ru',
                                      'CommonValidator');
        $this->xmlutils = new XMLUtils();

    }

    public function Validate($meta, $data, &$filtredarray = null)
    {
        $this->meta = &$meta;
        $this->_aData = &$data;

        $messages = array();
        foreach ($meta as $k => $v) {
            $name = $v[0];
            $attrs = $v[1];
            $this->currentField = $name;
            $this->currentFieldAttrs = $attrs;
            if (isset($attrs['type']) && ($attrs['type'] == 7 || $attrs['type'] == 14)) {
                if (isset($filtredarray)) {
                    $filtredarray[$name]['error'] = null;
                    $filtredarray[$name]["old_{$name}"] = isset($data["old_{$name}"])
                                                          ? trim($data["old_{$name}"]) : '';
                    if ($filtredarray[$name]["old_{$name}"] == '') {
                        $filtredarray[$name]["old_{$name}"] = isset($data[$name]) && is_string($data[$name])
                                                              ? $data[$name] : '';
                    }
                    $filtredarray[$name]["clr_{$name}"] = isset($data["clr_{$name}"])
                                                          ? $data["clr_{$name}"] : '';
                    $filtredarray[$name]["temp_{$name}"] = isset($data["temp_{$name}"])
                                                          ? $data["temp_{$name}"] : '';
                }
            }
            $isempty = $this->isEmpty($name);
            if ($isempty) {
                if (isset($attrs['required'])) {
                    if (
                        !isset($this->currentFieldAttrs['type'])
                        || ($this->currentFieldAttrs['type'] != 7 && $this->currentFieldAttrs['type'] != 14)
                        || ($filtredarray[$name]["old_{$name}"] == '')
                    ) {
                        array_push($messages, array($name, $attrs['required']));
                    }
                }
                if (
                    isset($filtredarray)
                    && (
                        !isset($this->currentFieldAttrs['type'])
                        || ($this->currentFieldAttrs['type'] != 7 && $this->currentFieldAttrs['type'] != 14)
                    )
                ) {
                    $filtredarray[$name] = null;
                }
                continue;
            } elseif (isset($attrs['filters'])) {
                foreach ($attrs['filters'] as $filter) {
                    $func = $filter[0];
                    if (mb_substr($func, 0, 1) == '@') {
                        $func = mb_substr($func, 1);
                        foreach ($data[$name] as $i => $dataItem) {
                            $filter[0] = $data[$name][$i];
                            $data[$name][$i] = $this->filter($func, $filter);
                        }
                    } else {
                        $filter[0] = $data[$name];
                        $data[$name] = $this->filter($func, $filter);
                    }
                }
            }
            if (isset($data[$name]) && is_string($data[$name])) {
                $data[$name] = trim($data[$name]);
            }
            $isempty = $this->isEmpty($name);
            if ($isempty) {
                if (isset($attrs['required'])) {
                    array_push($messages, array($name, $attrs['required']));
                }
                if (isset($filtredarray)) {
                    $filtredarray[$name] = null;
                }
                continue;
            } elseif (isset($attrs['validators'])) {
                foreach ($attrs['validators'] as $v_) {
                    $v_name = array_shift($v_);
                    $v_err_mess = array_shift($v_);
                    if ($v_name == '->') {
                        foreach ($data[$name] as $subkey => &$subarray) {
                            $rrr = $this->Validate($v_err_mess, &$subarray, $filtredarray[$name]);
                            $this->_aData = &$data;
                            if (is_array($rrr) && ! empty($rrr)) {
                                $messages[$name][$subkey] = $rrr;
                            }
                        }
                    } else
                        if (mb_substr($v_name, 0, 1) == '@') {
                            array_unshift($v_, $data, '');
                            $v_name = mb_substr($v_name, 1);
                            $errorIndexes = array();
                            foreach ($data[$name] as $i => $dataItem) {
                                $v_[1] = $dataItem;
                                if (! $this->validator($v_name, $v_))
                                    $errorIndexes[] = $i;
                            }
                            if (count($errorIndexes)) {
                                array_push($messages, array($name, $v_err_mess, $errorIndexes));
                            }
                        } else {
                            array_unshift($v_, $data, isset($data[$name]) ? $data[$name] : null);
                            $flag = $this->validator($v_name, $v_);
                            if (!$flag)
                                array_push($messages, array($name, $v_err_mess));
                        }
                }
            }
            if (isset($filtredarray) && isset($data[$name])) {
                if (isset($this->currentFieldAttrs['type']) && ($this->currentFieldAttrs['type'] == 7 || $this->currentFieldAttrs['type'] == 14)) {
                    $filtredarray[$name] = array_merge($filtredarray[$name], $data[$name]);
                } else {
                    $filtredarray[$name] = $data[$name];
                }
            }
        }
        return $messages;
    }

    /**
     * Добавляет кастомный валидатор к полю
     * @param Array $meta Массив meta
     * @param String $fieldName Имя поля
     * @param String $validatorName Название валидатора
     * @param String $errorMessage Сообщение об ошибке
     */
    public function addCustomValidator(&$meta, $fieldName, $validatorName, $errorMessage)
    {
        if (isset($meta[$fieldName])) {
            $validator = func_get_args();
            array_shift($validator);
            array_shift($validator);
            $meta[$fieldName][1]['validators'][$validatorName] = $validator;
        }
    }

    protected function filter($func, $params)
    {
        if (mb_substr($func, 0, 1) == '#') {
            $func = mb_substr($func, 1);
            if ($this->controller) {
                return call_user_func_array(array($this->controller, $func), $params);
            } else {
                return call_user_func_array($func, $params);
            }
        } else {
            return call_user_func_array(array($this, $func), $params);
        }
    }

    protected function validator($v_name, $v_)
    {
        if (substr($v_name, 0, 1) == '#') {
            $v_name = mb_substr($v_name, 1);
            if ($this->controller) {
                return call_user_func_array(array($this->controller, $v_name), $v_);
            } else {
                return call_user_func_array($v_name, $v_);
            }
        } else {
            return call_user_func_array(array($this, $v_name), $v_);
        }
    }

    function FromJSON($txt)
    {
        return json_decode('[' . $txt . ']', true);
    }

    function PreVisible($meta, &$rows, &$enums)
    {

        foreach ($meta as $k => $v) {
            $name = $v[0];
            $attrs = $v[1];
            if (array_key_exists('visuality', $attrs)) {
                if ($attrs['type'] == 6) {
                    foreach ($rows as &$row) {
                        if (!isset($row["_str{$name}"])) {
                            $row["_str{$name}"] = $this->config->DB()->fetchOne(
                                "SELECT {$attrs['ref']['visual']}
                                 FROM {$attrs['ref']['table']}
                                 WHERE {$attrs['ref']['field']} = ?",
                                $row[$name]
                            );
                        }
                    }
                } elseif ($attrs['type'] == 10) {
                    foreach ($rows as &$row) {
                        if(!array_key_exists($row[$name], $enums[$name]))
                            $row['_str' . $name] = 'Ошибочный ключ!';
                        else $row['_str' . $name] = isset($row[$name])
                                             ? $enums[$name][$row[$name]]
                                             : '';
                    }
                }
            }
        }
    }

    function PiceImages($meta, &$row)
    {
        foreach ($meta as $k => $v) {
            $name = $v[0];
            $attrs = $v[1];
            if (isset($attrs['type'])) {
                if (isset($row[$name]) && $row[$name]) {
                    if ($attrs['type'] == 7) {
                        $r = is_array($row[$name])
                            ? explode('#', $row[$name]["old_{$name}"])
                            : explode('#', $row[$name]);
                        if (isset($r[1])) {
                            $row[$name] = array('full' => $row[$name],
                                                'src'  => $r[0],
                                                'w'    => $r[1],
                                                'h'    => $r[2]);
                        }
                        if (isset($attrs['dir'])) {
                            $row[$name]['dir'] = $attrs['dir'];
                        }
                    } elseif ($attrs['type'] == 14) {
                        $r = is_array($row[$name])
                            ? explode('#', $row[$name]["old_{$name}"])
                            : explode('#', $row[$name]);
                        $r = array_pad($r, 2, '');
                        if (isset($r[1])) {
                            $row[$name] = array('full' => $row[$name],
                                            'href' => $r[0],
                                            'size' => $r[1]);
                        }
                    }
                }
            }
        }
    }

    function MakeEnums($meta, &$enums)
    {
        foreach ($meta as $k => $v) {
            $name = $v[0];
            $attrs = $v[1];
            if (isset($attrs['ref']) && ! array_key_exists('popup', $attrs)
//                && ($this->config->getParam($attrs, 'visual', 'select') == 'select')
            ) {
                $enums[$name] = $this->config->DB()->fetchPairs(
                    'SELECT ' . $attrs['ref']['field'] . ', ' . $attrs['ref']['visual']
                    . ' FROM ' . $attrs['ref']['table']
                    .(array_key_exists('where',$attrs['ref']) ? ' WHERE '.$attrs['ref']['where'] : '')
                    . ' ORDER BY '
                    . (isset($attrs['ref']['order']) && $attrs['ref']['order']
                        ? $attrs['ref']['order']
                        : $attrs['ref']['visual']));
            }
        }
    }

    function MultiOptions($meta, $fields, $enums = null)
    {
        $ret = '<multioptions>';
        foreach ($meta as $k => $v) {
            $name = $v[0];
            $attrs = $v[1];
            if (isset($attrs['multioptions'])) {
                if (
                    array_key_exists('popup', $attrs)
                ) {
                    $enum_name = $attrs['multioptions'];
                    $this->controller->enums[$enum_name] = $this->config->DB()->fetchPairs(
                        'SELECT ' . $attrs['ref']['field'] . ', ' . $attrs['ref']['visual']
                        . ' FROM ' . $attrs['ref']['table']
                        . ' WHERE ' . $attrs['ref']['field'] . ' = ? '
                        . (isset($attrs['ref']['order']) ? "ORDER BY {$attrs['ref']['order']}" : ''),
                        isset($fields[$name]) ? $fields[$name] : 0);
                }
                if (!array_key_exists('ref', $attrs)) {
                    $enum_name = $attrs['multioptions'];
                    $xenum_name = $attrs['multioptions'];
                    $xenum_name = str_replace('f_','',$xenum_name);
                    if($enums && $xenum_name != '' && array_key_exists($xenum_name, $enums))
                        $this->controller->enums[$enum_name] = $enums[$xenum_name];
                }
                if (is_array($attrs['multioptions'])) {
                    $enum_name = $attrs['multioptions'][0];
                    $field_name = $attrs['multioptions'][1];
                    if (isset($this->controller->enums[$enum_name])) {
                        $ret .= '<' . $enum_name . '>'
                             . $this->xmlutils->Enumerator($this->controller->enums[$enum_name],
                                                      isset($fields[$name]) ? $fields[$name] : null,
                                                      $field_name)
                             . '</' . $enum_name . '>';
                    }
                } else {
                    $enum_name = $attrs['multioptions'];
                    if (isset($this->controller->enums[$enum_name])) {
                        $ret .= '<' . $enum_name . '>'
                             . $this->xmlutils->Enumerator($this->controller->enums[$enum_name],
                                                      isset($fields[$name]) ? $fields[$name] : null)
                             . '</' . $enum_name . '>';
                    }
                }
            }
        }
        $ret .= '</multioptions>';
        return $ret;
    }

    function ErrorsHumanReadable($mess)
    {
        foreach ($mess as &$err) {
            $message = $this->gettext->getText($err[1]);

            if ($message != '') {
                $err[1] = $message;
            }
        }

        return $mess;
    }

    function ToXML($mess, $messageList = null)
    {
        $ret = '';
        foreach ($mess as $v) {
            if ($messageList) {
                if (array_key_exists($v[1], $messageList)) {
                    $v[1] = $messageList[$v[1]];
                }
            } else {
                $message = $this->gettext->getText($v[1]);
                if ($message != '') {
                    $v[1] = $message;
                }
            }
            if (isset($v[2]) && $v[2] == 'popup') {
                $v[1] .= '<popup/>';
            }
            $ret .= '<error name="' . $v[0] . '">' . $v[1] . '</error>';
        }
        return $ret;
    }

    function ErrorsXML($mess, $messageList = null)
    {
        $xw = new \xmlWriter();
        $xw->openMemory();
        $xw->setIndent(true);
        foreach ($mess as $k => $v) {
            if (is_int($k)) {
                if ($messageList && isset($messageList[$v[1]])) {
                    $v[1] = $messageList[$v[1]];
                } else {
                    $message = $this->gettext->getText($v[1]);
                    if ($message != '') {
                        $v[1] = $message;
                    }
                }
                $xw->startElement('error');
                $xw->writeAttribute('id', $k);
                $xw->writeAttribute('name', $v[0]);
                $xw->text($v[1]);
                $xw->endElement();
            } else {
                $xw->startElement($k);
                foreach ($v as $k_ => $v_) {
                    $xw->startElement('row');
                    $xw->writeAttribute('id', $k_);
                    $this->_ErrorsXML($xw, $v_);
                    $xw->endElement();
                }
                $xw->endElement();
            }
        }
        return $xw->outputMemory(true);
    }

    function _ErrorsXML($xw, $a)
    {
        foreach ($a as $k => $v) {
            $xw->startElement('error');
            $xw->writeAttribute('id', $k);
            $xw->writeAttribute('name', $v[0]);
            $xw->text($v[1]);
            $xw->endElement();
        }
    }

    public function ErrorsText($mess)
    {
        $result = array();
        foreach ($mess as $v) {
            $message = $this->gettext->getText($v[1]);
            $result[] = $message != '' ? $message : $v[1];
        }
        return $result;
    }

    public function isEmpty($name)
    {
        if (array_key_exists('type', $this->currentFieldAttrs)) {
            switch ($this->currentFieldAttrs['type']) {
                case 7:
                case 14:
                    return !(
                        isset($this->_aData[$name]['error'])
                        && ($this->_aData[$name]['error'] === UPLOAD_ERR_OK)
                    );
            }
        }
        if (!isset($this->_aData[$name])) {
            return true;
        }
        return is_array($this->_aData[$name])
            ? (count($this->_aData[$name]) == 0)
            : preg_match('/^\s*$/', $this->_aData[$name]);
    }

    public function inSql($fields, $value, $sql, $additionalParameters = false)
    {
        if(!$additionalParameters){
            $flag = $this->config->DB()->fetchOne($sql, $value);
            return $flag ? true : false;
        }

        $sqlParameters = array();

        if(is_array($additionalParameters)){
            if(array_key_exists('fields', $additionalParameters)){
                foreach ($additionalParameters['fields'] as $fieldsName){
                    if(array_key_exists($fieldsName, $fields)){
                        $sqlParameters[] = $fields[$fieldsName];
                    } else {
                        $sqlParameters[] = null;
                    }
                }
            }

            if(array_key_exists('values', $additionalParameters)){
                foreach ($additionalParameters['values'] as $fieldsValue){
                    $sqlParameters[] = $fieldsValue;
                }
            }

            $sqlParameters[] = $value;
        } else {
            $sqlParameters = array($additionalParameters, $value);
        }
        $flag = $this->config->DB()->fetchOne($sql, $sqlParameters);
        return $flag ? true : false;
    }

    public function notinSql($fields, $value, $sql, $additionalParameters = false)
    {
        $flag = $this->inSql($fields, $value, $sql, $additionalParameters);
        return $flag ? false : true;
    }

    public function notDuplicateChild($fields, $value, $sql)
    {
        return !(bool)$this->config->DB()->fetchOne(
            $sql, array($value, $this->controller->Param('pid'),
                        (int)$this->controller->Param('id')));
    }

    public function isNumber($fields, $value)
    {
        return is_numeric($value);
    }

    public function isInteger($fields, $value)
    {
        return is_numeric($value) && (intval($value) == $value);
    }

    public function isFloat($fields, $value)
    {
        return $this->isNumber($fields, $value);
    }

    public function isPositivePlus($fields, $value)
    {
        return floatval($value)>0;
    }

    public function isEq($fields, $value, $name)
    {
        return $value == $fields[$name];
    }

    public function isRegExp($fields, $value, $regexp)
    {
        return preg_match($regexp, $value);
    }

    public function isBetween($fields, $value, $min, $max, $inclusive = false)
    {
        if ($inclusive) {
            if ($min > $value || $value > $max) {
                return false;
            }
        } else {
            if ($min >= $value || $value >= $max) {
                return false;
            }
        }
        return true;
    }

    public function isGt($fields, $value, $min, $inclusive = false)
    {
        $min = isset($fields[$min]) ? $fields[$min] : null;
        if ($inclusive) {
            return $value >= $min;
        } else {
            return $value > $min;
        }
    }

    public function isEmail($fields, $email)
    {
        return preg_match('/\A(?:[a-z0-9!#$%&\'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&\'*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+(?:[A-Z]{2}|asia|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum|travel)\b)\Z/i', $email) ? true : false;
    }

    public function isUrl($fields, $url)
    {
        return preg_match('"^' . $this->urlRegExp . '$"ui', $url);
    }

    public function isDate($fields, $value)
    {
        return preg_match('/^\d{2}\.\d{2}\.\d{4}$/u', $value);
    }

    public function isIsoDate($fields, $value)
    {
        return preg_match('/^\d{4}-\d{2}-\d{2}$/u', $value);
    }

    public function hasLength($fields, $value, $minLength, $maxLength)
    {
        $len = mb_strlen($value);
        return ($len >= $minLength) && ($len <= $maxLength);
    }

    /**
     * Проверяет строку на наличие заглавных букв и если их больше необходимого - возвращает false
     * @param object $fields Массив полей
     * @param object $value Значение
     * @param object $allowedAmounOfCapitals Разрешенное количество заглавных букв
     * @return boolean Результат проверки
     */
    public function hasCapitalsLess($fields, $value, $allowedAmounOfCapitals)
    {
        if(is_string($value)){
            $valueLowercase = mb_strtolower($value);
            $valueLength = mb_strlen($value);

            $totalCapitals = 0;
            for ($i = 0; $i < $valueLength; $i++) {
                if ($value[$i] != $valueLowercase[$i]) {
                    $totalCapitals++;
                }
            }

            if($totalCapitals <= $allowedAmounOfCapitals){
                return true;
            }else{
                return false;
            }
        }else{
            return false;
        }
    }

    public function maxImageSize($fields, $value, $size)
    {
        return $value['size'] <= $size * 1024;
    }

    protected function imageDimensions($image, $dimensionId, $dimensionValue)
    {
        $tmpDir = getenv('upload_tmp_dir');
        $tmpFileName = $tmpDir.$image['tmp_name'];

        if (! file_exists($tmpFileName)) {
            return false;
        }

        $size = null;

        error_reporting(0);
        $old_error_handler = set_error_handler(array($this, "imageMimeTypeGetImageSizeErrorHandler"));
        $size = getimagesize($tmpFileName);
        restore_error_handler();
        error_reporting(E_ALL);

        if (is_null($size)) {
            if (file_exists($tmpFileName)) {
                unlink($tmpFileName);
            }

            return false;
        }

        return $size[$dimensionId] >= $dimensionValue;
    }

    public function imageWidth($fields, $value, $width)
    {
        return $this->imageDimensions($value, 0, $width);
    }

    public function imageHeight($fields, $value, $height)
    {
        return $this->imageDimensions($value, 1, $height);
    }

    public function imageMimeType($fields, $value)
    {
        $tmpDir = getenv('upload_tmp_dir');
        $tmpFileName = $tmpDir.$value['tmp_name'];

        if(!file_exists($tmpFileName)){
            return false;
        }

        $size = null;

        error_reporting(0);
        $old_error_handler = set_error_handler(array($this, "imageMimeTypeGetImageSizeErrorHandler"));
        $size = getimagesize($tmpFileName);
        restore_error_handler();
        error_reporting(E_ALL);

        if(is_null($size)){
            if(file_exists($tmpFileName)){
                unlink($tmpFileName);
            }
            return false;
        }

        return in_array($size['mime'], array('image/gif', 'image/jpeg', 'image/jpg', 'image/png'));
    }

    protected function imageMimeTypeGetImageSizeErrorHandler()
    {}

    public function imageMimeTypePlus($fields, $value)
    {

        $size = getimagesize(getenv('upload_tmp_dir') . $value['tmp_name']);
        return in_array($size['mime'], array('image/gif', 'image/jpeg', 'image/jpg', 'image/png', 'image/tiff'));
    }

    public function swfMimeType($fields, $value)
    {
        $tmpDir = getenv('upload_tmp_dir');
        $tmpFileName = $tmpDir.$value['tmp_name'];

        if(!file_exists($tmpFileName)){
            return false;
        }

        $size = null;

        error_reporting(0);
        $old_error_handler = set_error_handler(array($this, "imageMimeTypeGetImageSizeErrorHandler"));
        $size = filesize($tmpFileName);
        restore_error_handler();
        error_reporting(E_ALL);

        if(is_null($size)){
            if(file_exists($tmpFileName)){
                unlink($tmpFileName);
            }
            return false;
        }
        $xmime = isset($value['type']) ? $value['type'] : 'hren-type';

/*      work only in php 5.3
        $finfo = finfo_open(FILEINFO_MIME);
        $xmime = finfo_file($finfo, $tmpFileName);
        finfo_close($finfo);
*/
        return in_array($xmime, array('application/x-shockwave-flash'));
    }

    public function maxFileSize($fields, $value, $size)
    {
        $tmpDir = getenv('upload_tmp_dir');
        $tmpFileName = $tmpDir.$value['tmp_name'];

        if(!file_exists($tmpFileName)){
            return false;
        }

        $fsize = null;

        error_reporting(0);
        $old_error_handler = set_error_handler(array($this, "imageMimeTypeGetImageSizeErrorHandler"));
        $fsize = filesize($tmpFileName);
        restore_error_handler();
        error_reporting(E_ALL);

        if(is_null($fsize)){
            if(file_exists($tmpFileName)){
                unlink($tmpFileName);
            }
            return false;
        }

        return $fsize <= $size * 1024;
    }

    public function isOption($fields, $value, $enum)
    {
        if (isset($this->controller) && isset($this->controller->enums[$enum])) {
            return isset($this->controller->enums[$enum][$value]);
        }
        return true;
    }

    public function isUrlList($fields, $value)
    {
        $oneUrl = '(http\://)?([a-z0-9\-а-я]+\.)+[a-zрф]{2,4}(\:[0-9]+)*/?';
        return preg_match("!^($oneUrl(\s*[ ,;]\s*$oneUrl)*)?[ ,;]*$!ui", $value);
    }

    public function wordLength($fields, $value, $maxLength)
    {
        return !preg_match("/[^-\s]{{$maxLength}}/iu", $value);
    }
    public function hashValidator($fields, $value)
    {
/*        $changeLog = new ChangeLog($this->cmf);
        return (bool)($change = $changeLog->loadByMd5($value));*/
    }

    public function isColor($fields, $value)
    {
        return preg_match('/^#?[\da-f]+$/i', $value);
    }

    /** FILTERS **/
    public function int($value)
    {
        return (int)$value;
    }

    public function float($value)
    {
        return (float)str_replace(',', '.', $value);
    }

    public function file($value)
    {
        return in_array($value, $_FILES) && ($value['error'] == UPLOAD_ERR_OK)
            ? $value
            : null;
    }

    public function stripTags($value, $params = '')
    {
        return strip_tags($value, $params);
    }

    public function unique($value)
    {
        return is_array($value) ? array_unique($value) : array();
    }

    public function checkbox($value)
    {
        return $value ? 1 : 0;
    }

    public function trim($value)
    {
        return trim($value);
    }

    public function toLower($value)
    {
        return mb_strtolower($value);
    }

    public function host($value)
    {
        return ($host = parse_url($value, PHP_URL_HOST))
            ? $host
            : parse_url('http://' . $value, PHP_URL_HOST);
    }

    public function fullUrl($value)
    {
        return !$this->isUrl(array(), $value) || parse_url($value, PHP_URL_HOST)
            ? $value
            : 'http://' . $value;
    }

    public function color($value)
    {
        return strpos($value, '#') !== 0 ? '#' . $value : $value;
    }

    public function replace($value, $what, $replace)
    {
        return str_replace($what, $replace, $value);
    }

    public function encodeUrl($value)
    {
        require_once "lib/IDNA2.php";
        $idna = new Net_IDNA2;

        if (preg_match("/xn--/i", $value)) {
            $value = $idna->decode($value);
        }
        return preg_replace('"([^a-zа-я0-9.,?\'\\+&amp;:/%$#=~_\-]+)"uie', "urlencode('\\1')", $value);
    }

    public function htmlspecialchars_decode($value)
    {
        return htmlspecialchars_decode($value);
    }

    public function getUrlRegExp()
    {
        return $this->urlRegExp;
    }
}
