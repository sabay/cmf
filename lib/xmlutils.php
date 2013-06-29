<?php
namespace sabay;
class XMLUtils{
    function Array2xmlQ($a, $convertNonAssocArrays = false)
    {
        $xw = new \xmlWriter();
        $xw->openMemory();
        $xw->setIndent(true);
        if($convertNonAssocArrays){
            $this->_Array2XMLItemize($xw,$a);
        } else {
            $this->_Array2XML($xw,$a);
        }
        return $xw->outputMemory(true);
    }

    /**
     * Оборачивает все элементы не ассоц. массивов в <item item_id="ключ">
     * @param Object $xw XML wrapper
     * @param Array $a Массив
     * @return
     */
    function _Array2XMLItemize($xw, $a)
    {
        if (is_array($a))
            foreach ($a as $k=>$v) {
                if (is_int($k) && is_array($v)) {
                    $xw->startElement('item');
                    $xw->writeAttribute('item_id', $k);
                    $this->_Array2XMLItemize($xw, $v);
                    $xw->endElement();
                } else if(is_int($k) && !is_array($v)){
                    $xw->startElement('item');
                    $xw->writeAttribute('item_id', $k);
                    $xw->text($v);
                    $xw->endElement();
                } elseif (is_array($v)) {
                    $xw->startElement($k);
                    $this->_Array2XMLItemize($xw, $v);
                    $xw->endElement();
                } else
                    $xw->writeElement($k, $v);
            }
    }

    function _Array2XML($xw,$a)
    {
        if(is_array($a))
        foreach($a as $k => $v) {
            if (is_int($k))
                $this->_Array2XML($xw,$v);
            elseif (is_array($v))
              {
                $xw->startElement ($k);
                $this->_Array2XML($xw,$v);
                $xw->endElement();
              }
            else
                $xw->writeElement ($k,$v);
        }
    }

    function Meta2XML($src)
    {
        $xw = new \xmlWriter();
        $xw->openMemory();
        $xw->setIndent(true);
        foreach ($src as $k=>$v)
        {
                $xw->startElement ('col');
                $xw->writeAttribute('name',$v[0]);
                $this->_Form2XML($xw,$v[1]);
                $xw->endElement(); // </row>
        }
        return $xw->outputMemory(true);
    }

    function Enumerator(&$arr, $cur, $field=null)
    {
        $xw = new \xmlWriter();
        $xw->openMemory();
        $xw->setIndent(true);
        if($field)
        {
                foreach ($arr as $k=>$it)
                {
                 $xw->startElement ('option');
                 $xw->writeAttribute('value',$k);
                 if (!is_null($cur) && $k == $cur) $xw->writeAttribute('selected','selected');
                 $xw->text($it[$field]);
                 $xw->endElement();
                }
        }
        else
        {
                foreach ($arr as $k=>$it)
                {
                 $xw->startElement ('option');
                 $xw->writeAttribute('value',$k);
                 if (!is_null($cur) && $k == $cur) $xw->writeAttribute('selected','selected');
                 $xw->text($it);
                 $xw->endElement();
                }
        }
        return $xw->outputMemory(true);
    }

    function Form2XML($src)
    {
        $xw = new \xmlWriter();
        $xw->openMemory();
        $xw->setIndent(true);
        $this->_Form2XML($xw,$src);
        return $xw->outputMemory(true);
    }

    function _Form2XML($xw,$a)
    {
        foreach($a as $k => $v) {
            if (is_int($k))
              {
                $xw->startElement ('row');
                if(is_array($v)) $this->_Form2XML($xw,$v);
                else $xw->text($v);
                $xw->endElement();
              }
            elseif (is_array($v))
              {
                $xw->startElement ($k);
                $this->_Form2XML($xw,$v);
                $xw->endElement();
              }
            else
                $xw->writeElement ($k,$v);
        }
    }

    function getFlatXML($src,$rootTagName = 'root', $rowTagName = 'row')
    {
        $xw = new \xmlWriter();
        $xw->openMemory();
        $xw->setIndent(true);
        //$xw->startDocument('1.0','UTF-8');
        $xw->startElement ($rootTagName);

        foreach ($src as $k=>$v) {
            $xw->startElement ($rowTagName);
            foreach($v as $vk=>$vv) {
                $xw->writeElement ($vk,$vv);
            }
            $xw->endElement(); // </row>
        }
        $xw->endElement(); // </root>
        return $xw->outputMemory(true);
    }

    function getXML($src,$options)
    {
        $xw = new \xmlWriter();
        $xw->openMemory();
        $xw->setIndent(true);
        //$xw->startDocument('1.0','UTF-8');

        if (isset($options['rootTag']))  $rootTagName = $options['rootTag'];
        else $rootTagName = 'root';

        if (isset($options['rowTag']))  $rowTagName= $options['rowTag'];
        else $rowTagName= 'row';

        $xw->startElement ($rootTagName);
        foreach ($src as $k=>$v) {
            $xw->startElement ($rowTagName);

            foreach($options['attributes'] as $vk=>$vv) {
                if(is_int($vk)) $xw->writeAttribute($vv,$v[$vv]);
                else $xw->writeAttribute ($vv,$v[$vk]);
            }

            foreach($options['elements'] as $vk=>$vv) {
                if(is_int($vk)) $xw->writeElement ($vv,$v[$vv]);
                else $xw->writeElement ($vv,$v[$vk]);
            }
            $xw->endElement(); // </row>
        }
        $xw->endElement(); // </root>
        return $xw->outputMemory(true);
    }

}
