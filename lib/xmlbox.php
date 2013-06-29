<?php
namespace sabay;
class XMLBox{
    private $xw;
    private $part;
    private $config;

    function __construct($config=null,$indent=false, $part=false, $doNotStartRoot = false)
    {

        $this->config=$config;
        $this->part = $part;
        $this->xw = new \xmlWriter();
        $this->xw->openMemory();
        $this->xw->setIndent($indent);
        if (!$this->part) {
            $this->xw->startDocument('1.0','UTF-8');
            if(!$doNotStartRoot) {
                $this->xw->startElement('page');
            }
        }
    }

    function startSection($name,$attrs=array())
    {
        $this->xw->startElement($name);
        foreach ($attrs as $k => $v) {
            $this->xw->writeAttribute($k,$v);
        }
    }

    function stopSection()
    {
        $this->xw->endElement();
    }

    function addNamedBlock($name, $data, $attrs=array())
    {
        $this->xw->startElement ($name);
        foreach ($attrs as $k => $v) {
            $this->xw->writeAttribute($k,$v);
        }
        $this->xw->writeRaw($data);
        $this->xw->endElement();
    }

    function addBlock($data)
    {
        $this->xw->writeRaw($data);
    }

    function addTag($name, $value='', $attrs=array())
    {
        $this->xw->startElement ($name);
        foreach ($attrs as $k => $v) {
            $this->xw->writeAttribute($k,$v);
        }
        if ($value !== '') {
            $this->xw->text($value);
        }
        $this->xw->endElement();
    }

    function getXML()
    {
        if (!$this->part) {
            $this->xw->endElement();
        }
        return $this->xw->outputMemory(true);
    }

    function Transform($xslfile,$xml = null, $toString = false)
    {
        if($xml === null) {
          $xml=$this->getXML();
        }
//        if($this->Param('_DBG')){header("Content-type: text/xml");print $xml;exit;}
        $doc = new \DOMDocument();
        $xslt = new \xsltProcessor;
        if($this->config != null){
            $doc->load($this->config->root().'/templates/'.$xslfile);
        }
        else{
            $doc->load('/templates/'.$xslfile);
        }
        $xslt->importStyleSheet($doc);
        $doc->loadXML($xml);
        $html = $xslt->transformToXML($doc);

        unset($xslt);
        unset($doc);
        if ($toString)
           return $html;
        else {
            print $html;
            return false;
        }
    }

}
