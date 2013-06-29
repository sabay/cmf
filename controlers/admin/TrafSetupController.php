<?php
require 'lib/Abstract_Admin_Controller.php';
require_once 'lib/validator.php';
require_once 'lib/xmlbox.php';
require_once 'models/Site.php';
require_once 'models/User.php';
    
class trafSetupController extends sabay\Abstract_Admin_Controller
{
    /**
     * @var User
     */
    protected $_user   = null;
    /**
     * @var Site
     */
    protected $item    = null;
    protected $apply      = 0;
    /**
     * @var FormValidator
     */
    protected $fv      = null;
    protected $scriptName = 'trafSetup';
    
    protected $defaultValues = array();

    public function init()
    {
        $this->item   = new Site($this->config);
        $this->fv     = new \sabay\FormValidator($this->config, $this, 'SiteValidator');
        $this->errors = array();
        $this->_user  = new User($this->config, $this->userId);
        
        $this->enums = $this->item->getMetaEnums();
        $this->apply= 0;
    
        $this->list_xsl = "admin/trafsetup/list.xsl";
        $this->edit_xsl = "admin/new.xsl";
        $this->new_xsl  = "admin/new.xsl";
        $this->defaultValues = array();
    }

    public function indexAction()
    {
        $profile = $this->_user->getProfile();
        $selectedDate = $this->Param('date');
        $site_id = $this->Param('pid');

        if(!$selectedDate) $selectedDate=$this->db->fetchOne('select date_format(curdate() -1,"%Y-%m-%d")');

        $intrafftmp=$this->db->fetchAll('select block_id,code_id,sum(click) as clicks from in_traff where date=? and click>0 group by block_id,code_id',$selectedDate);
        foreach($intrafftmp  as $row){
            $intraff[$row['code_id']]=$row['clicks'];
        }

        $codeclickstmp=$this->db->fetchAll('select bcode_id as code_id,cnt as clicks from code_clicks where date=?',$selectedDate);
        foreach($codeclickstmp  as $row){
        $codeclicks[$row['code_id']]=$row['clicks'];
        }


        $codeclickstmp=$this->db->fetchAll('select bc.bcode_id as code_id,ps.clicks as clicks from bcode bc inner join partner_stat ps on(ps.date=? and ps.partner_system_id=bc.partner_system_id and ps.divname=bc.divname)',$selectedDate);
        foreach($codeclickstmp  as $row){
        if(! isset($codeclicks[$row['code_id']]) ) 
            {
                $codeclicks[$row['code_id']]=$row['clicks'];
            }
        }


        $blockstat=array();
        $blockstattmp=$this->db->fetchAll('select block_id,code_id,sum(shows) as shows from CODE_BLOCK_STAT where date=? group by block_id,code_id',$selectedDate);
        foreach($blockstattmp  as $row){
            $codestat[$row['code_id']]=$row['shows'];
            if(isset($blockstat[$row['block_id']]))$blockstat[$row['block_id']]+=$row['shows'];
                else $blockstat[$row['block_id']]=$row['shows'];
        }
        $select = $this->db->select()
                           ->from(array('a'=>'block'), array('block_id','name', 'bredirpercent'=>'redirpercent'))
                           ->join(array('c'=>'bcode'),"c.block_id=a.block_id", array('bcode_id','cname'=>'name','vprset'=>'percent','mprset'=>'mpercent', 'credirpercent'=>'redirpercent'))
                           ->where("a.site_id=?",$site_id)
                           ->order(array('block_id','bcode_id'));
        
        $stmt = $select->query();
        $rows = $stmt->fetchAll();
        $vprfull=array();
        foreach($rows  as &$row){
             if(isset($vprfull[$row['block_id']]))$vprfull[$row['block_id']]+=$row['vprset'];
                 else $vprfull[$row['block_id']]=$row['vprset']+0.0000001;
        }

        foreach($rows  as &$row){
            $row['fullcount']=isset($blockstat[$row['block_id']])?$blockstat[$row['block_id']]:0.000001;
            $row['codecount']=isset($codestat[$row['bcode_id']])?$codestat[$row['bcode_id']]:0;
            $row['vpr'] =sprintf("%.2f",$row['codecount']/$row['fullcount']  *100);
            $row['clicks'] = isset($codeclicks[$row['bcode_id']])?$codeclicks[$row['bcode_id']]:0;
            $row['mclicks'] = isset($intraff[$row['bcode_id']])?$intraff[$row['bcode_id']]:0; 
            $row['cclicks'] = $row['clicks'] - $row['mclicks'];
            $row['mpr']= sprintf("%.2f",$row['mclicks']/($row['cclicks']+0.000001));

            $row['calckclicks']=sprintf("%.2f",($row['cclicks'] * ($row['vprset']/$vprfull[$row['block_id']]) / ($row['vpr']+0.00001)) * ($row['mprset']+0));
//             $row['calckclicks_formula']="({$row['cclicks']} * ({$row['vprset']}/{$vprfull[$row['block_id']]}) / {$row['vpr']}) * {$row['mprset']}";
            if($this->apply) {
                $this->db->query('update bcode set redirpercent=? where bcode_id=?',array($row['calckclicks'], $row['bcode_id']) );
            }
        }

        if($this->apply) {
                $this->db->query('create temporary table btablecorrect select b.block_id,sum(c.redirpercent) as redirpercent from block b inner join bcode c on (c.block_id=b.block_id and b.site_id=?) group by b.block_id',$site_id);
                $this->db->query('update block b inner join btablecorrect c on(b.block_id=c.block_id) set b.redirpercent=c.redirpercent');
                $this->db->query('create temporary table sitetablecorrect select b.site_id,sum(b.redirpercent) as redirpercent from block b where b.site_id=? group by b.site_id',$site_id);
                $this->db->query('update site s inner join sitetablecorrect c on (s.site_id=c.site_id) set s.redirpercent=c.redirpercent');
        }

        $this->fv->PreVisible(Site::$_meta, $rows, $this->enums);

        $rows_xml = $this->xmlutils->getXML($rows, array('rootTag'    => 'rows',
                                                    'rowTag'     => 'row',
                                                    'attributes' => array('bcode_id'    => 'id'),
                                                    'elements'   => array('bcode_id','name','cname','fullcount','codecount','vpr','clicks','mclicks','cclicks' ,'mpr','vprset','mprset','calckclicks' ,'bredirpercent' , 'credirpercent')));
        $this->HeaderNoCache();

        $_meta_short_list = 
            array('id','Block','Code','Full views','Views','V%','Clicks','M_Clicks','C_Clicks','m%','Set v%','Set m%','M_Clicks reslt', 'old code%' ,'old block%');
        $short_list=$this->Order2XML($_meta_short_list,0);


        $page = new sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->addNamedBlock('head', $this->xmlutils->Array2xmlQ($profile));
        $page->addBlock($this->cmfScript->MakeLeftMenu());
 
        $page->startSection('data', array('pid'=>$site_id, 'date'=>$selectedDate ));
        $page->addNamedBlock('name', $this->scriptName);
        $page->addNamedBlock('cols', $short_list);
     

        $page->addBlock($rows_xml);
        

        $page->stopSection();
        $page->Transform($this->list_xsl);
    }

    protected function saveAll()
    {
        $selectedDate = $this->Param('date');
        if(!$selectedDate) $selectedDate=$this->db->fetchOne('select date_format(curdate() -1,"%Y-%m-%d")');
        $clicks= $this->Param('clicks');
        foreach($clicks as $k=>$v){
            $this->db->query('replace into code_clicks(date, bcode_id, cnt) values (?,?,?)',array($selectedDate, $k, $v) );
        }

        $clicks= $this->Param('vprset');
        foreach($clicks as $k=>$v){
            $this->db->query('update bcode set percent=? where bcode_id=?',array($v, $k) );
        }

        $clicks= $this->Param('mprset');
        foreach($clicks as $k=>$v){
            $this->db->query('update bcode set mpercent=? where bcode_id=?',array($v, $k) );
        }
    }


    protected function saveAllAction()
    {
        $this->saveAll();
        $this->indexAction();
    }

    protected function applyAllAction()
    {
        $this->saveAll();
        $this->apply=1;
        $this->indexAction();
    }


    protected function setCustomFields($select)
    {
    }

    public function editAction($id=null, $values=array())
    {
        if (!$id) {
            $id=$this->Param('id');
        }
        $p = $this->Param('p');
        $profile = $this->_user->getProfile();

        $this->HeaderNoCache();
        if (empty($values)) {
            $values = $this->item->_load($id);
        }

    
        $this->fv->PiceImages(Site::$_meta, $values);
        $this->fv->MakeEnums(Site::$_meta, $this->enums);

        $meta = $this->xmlutils->Meta2XML(Site::$_meta);

        $values_xml = $this->xmlutils->Form2XML($values);
        $values_xml .= $this->fv->MultiOptions(Site::$_meta, $values);
        $errors_xml = $this->fv->ErrorsXML($this->errors);

        $page = new sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->addNamedBlock('head', $this->xmlutils->Array2xmlQ($profile));
        $page->addBlock($this->cmfScript->MakeLeftMenu());
        $page->startSection('data', array('edit'    => '',
                                          'id'      => $id,
                                          'p'       => $p));
        $this->addEditFields($id, $page);
        $page->addBlock($this->cmfScript->GetTabs($this->script_id));
        $page->addNamedBlock('name', $this->scriptName);
        $page->addNamedBlock('values', $values_xml);
        $page->addNamedBlock('meta', $meta);
        $page->addNamedBlock('errors', $errors_xml);
    
        $page->stopSection();

        $page->Transform($this->edit_xsl);
    }

    public function newAction($values = array())
    {
        if (!$values) {
            $values = $this->defaultValues;
        }
        $p = $this->Param('p');
        $profile = $this->_user->getProfile();
        $this->HeaderNoCache();
        $this->fv->MakeEnums(Site::$_meta, $this->enums);
        $meta = $this->xmlutils->Meta2XML(Site::$_meta);
        $values_xml = $this->fv->MultiOptions(Site::$_meta, $values);
        $values_xml .= $this->xmlutils->Form2XML($values);
        $errors_xml = $this->fv->ErrorsXML($this->errors);

        $page = new sabay\XMLBox($this->config);
        $page->addNamedBlock('root',$this->config->get('General','HTTP_ROOT'));
        $page->addNamedBlock('head',$this->xmlutils->Array2xmlQ($profile));
        $page->addBlock($this->cmfScript->MakeLeftMenu());
        $page->startSection('data', array('new' => '',
                                          'p'   => $p));
        $page->addNamedBlock('name', $this->scriptName);
        $page->addNamedBlock('values', $values_xml);
        $page->addNamedBlock('meta', $meta);
        $page->addNamedBlock('errors', $errors_xml);
        $page->stopSection();

        $page->Transform($this->new_xsl);
    }

    public function insertAction()
    {
        $fields = array();
        $this->errors = $this->fv->Validate(Site::$_meta, array_merge($_REQUEST, $_FILES), $fields);
        if (empty($this->errors)) {
            try {
                $id = $this->item->insert($fields);
                $this->postInsert($id, $fields);
                $this->editAction($id);
            } catch (EntityError $e) {
                $this->newAction($fields);
            }
        } else {
            $this->newAction($fields);
        }
    }

    public function updateAction()
    {
        $fields = array();
        $this->errors = $this->fv->Validate(Site::$_meta, array_merge($_REQUEST, $_FILES), $fields);
        if (empty($this->errors)) {
            try {
                $this->item->update($this->Param('id'), $fields);
                $this->postUpdate($fields);
                $this->editAction();
            } catch(EntityError $e) {
                $this->editAction(null, $fields);
            }
        } else {
            $this->editAction(null, $fields);
        }
    }

    public function deleteAction()
    {
        try {
            $ids = $this->Param('id');
            if (is_array($ids)) {
                foreach ($ids as $id) {
                    $this->item->delete($id);
                }
            }
        } catch(EntityError $e) {
        }
        $this->indexAction();
    }

    public function cancelAction()
    {
        $this->editAction($this->Param('id'));
    }

    public function returnAction()
    {
        $this->indexAction();
    }

    protected function postInsert($id, $fields)
    {
    }

    protected function postUpdate($fields)
    {
    }


/** sorting actions **/

    public function sortAction()
    {

        unset($_COOKIE['s']);
        $s = $_GET['s'];
        $_COOKIE['s'] = $s;
        $_REQUEST['s'] = $s;
        if (isset($s) && $s) {
            setcookie('s', $s , time()+1209600, "/site/admin/{$this->scriptName}/");  //set sorting cookie for 2 weeks
        }
        $this->indexAction();
    }

/** pagesize actions **/

    public function pagesizeAction()
    {
        unset($_COOKIE['pagesize']);
        $s = array_key_exists('pagesize',$_POST) ? $_POST['pagesize'] : 50;
        $_COOKIE['pagesize'] = $s;
        $_REQUEST['pagesize'] = $s;
        if (isset($s) && $s) {
            setcookie('pagesize', $s , time()+1209600, "/site/admin/{$this->scriptName}/");  //set pagesize cookie for 2 weeks
        }
        $this->indexAction();
    }

    public function Order2XML ($arr,$s)
    {
        if (isset($s) && $s)
            list ($s_name, $s_order) = explode(':', $s);

        if (isset($s_order) && $s_order > 0)
            $s_order = 1;
        else
            $s_order = 0;

        $xw = new xmlWriter();
        $xw->openMemory();
        $xw->setIndent(true);
        $pos = 0;

        foreach ($arr as $k => $v) {
            $xw->startElement('col');
            $xw->writeAttribute('name', $k);
            $xw->writeAttribute('realname', $v[1]);
            if (isset($s_name) && $s_name == $k)
                $xw->writeAttribute('sort', $s_order);
            $xw->text($v);
            $xw->endElement();
        }
        return $xw->outputMemory(true);
    }
}
