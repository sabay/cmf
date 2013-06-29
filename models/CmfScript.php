<?php
require_once 'models/entity/cmf_scriptEntity.php';
include_once 'lib/xmlutils.php';

class CmfScript extends cmf_scriptEntity
{

    function scriptInfo($article)
    {

      return $this->db->fetchRow(
            'SELECT cmf_script_id as id, name
             FROM cmf_script
             WHERE article = ? AND status = 1',$article);

     }
// ---------------
  
    function clearRightsCache(){
        $this->db->query('truncate table cmf_role_combination');
        $this->db->query('truncate table cmf_rights');
    }

    function GetRights($userId, $script_id)
    {
        $cmf_role_combination_id='';
        $roles = $this->db->fetchAll('select cmf_role_id from cmf_user_role_link where user_id=? order by cmf_role_id',$userId);
        foreach($roles as $v){
             $cmf_role_combination_id.=$v['cmf_role_id'].';';
        }
        $cmf_role_combination_id=md5($cmf_role_combination_id);
        $this->userRights($cmf_role_combination_id,$userId);

        $rights = $this->db->fetchRow(
            'SELECT 1 as r, restriction_id, is_editor
             FROM cmf_rights
             WHERE cmf_script_id = ? and cmf_role_combination_id=?',
            array($script_id, $cmf_role_combination_id));
        $this->restriction = $rights['restriction_id'];
        $this->W = $rights['is_editor'];
        return ($userId && $rights['r']);

    }

    function userRights($cmf_role_combination_id,$userId)
    {
        if(!$this->db->fetchOne('select 1 from cmf_role_combination where cmf_role_combination_id=?',$cmf_role_combination_id)) {
            $this->db->query(
                'INSERT INTO cmf_rights
                SELECT \''.$cmf_role_combination_id.'\' as cmf_role_combination_id,ms.cmf_script_id, rm.restriction_id, rm.is_editor
                FROM cmf_user_role_link rl
                JOIN cmf_role r
                    ON rl.user_id = ? AND rl.cmf_role_id = r.cmf_role_id
                JOIN cmf_role_module_link rm
                    ON r.cmf_role_id = rm.cmf_role_id
                JOIN module_scripts ms
                    ON rm.module_id = ms.module_id
                ON DUPLICATE KEY UPDATE
                    restriction_id = IF(VALUES(restriction_id) > 0, 1, 0),
                    is_editor = IF(VALUES(is_editor) > 0, 1, cmf_rights.is_editor)',
                $userId);
            $this->db->query('insert into cmf_role_combination(cmf_role_combination_id) values(?)',$cmf_role_combination_id );
        }
   
    }
// -----------
    function MakeLeftMenu($parent_id=1,$level=0)
    {
        $xmlutils= new sabay\XMLUtils();
        $menu="<year>" . (date('Y')) . '</year><gentime>' . (date('d.m.Y H:i:s')) . '</gentime>';
        $row = $this->db->fetchAll('select s.cmf_script_id as id,s.name,s.url,s.description,s.background,s.image, s.article,s.tabname from cmf_script s /* inner join cmf_rights r on (s.cmf_script_id=r.cmf_script_id and s.parent_id=? and s.status=1)*/ where s.type=0 and s.realstatus=1 and s.parent_id=? order by ordering', $parent_id);
        foreach($row as $v)
        {
            if(isset($this->PATH_ARRAY[$level]) && $v['id']== $this->PATH_ARRAY[$level]) $v['sel']=1;
            if(($level>0 && $level<3 ) || isset($v['sel'])){
                $menu.='<menu>'.$xmlutils->Array2xmlQ($v).$this->MakeLeftMenu($v['id'],$level+1).'</menu>';
            }
            else {
                $menu.='<menu>'.$xmlutils->Array2xmlQ($v).'</menu>';
            }
        }
        return $menu;
    }

    function GetPath($id)
    {
        $PARR=array();
        $PATH='';
        do
        {
            $row=$this->db->fetchRow('SELECT parent_id, name, url FROM cmf_script WHERE cmf_script_id=?',$id);
            $PATH='/ '.$row['name'].$PATH;
            array_push($PARR,$id);
            $id=$row['parent_id'];
        }while(isset($row['parent_id']) && $row['parent_id'] && $row['parent_id'] !=1);
        $PARR=array_reverse($PARR);
        $this->PATH=$PATH;
        $this->PATH_ARRAY=$PARR;
    }

    function getTabs($id = NULL)
    {
/*        if (! $id)
            $id = $this->script_id;*/
        $prow = $this->db->fetchAll('
            select
                name, url, tabname
            from cmf_script
            where cmf_script_id=? and realstatus=1 ', array($id));

        $crows = $this->db->fetchAll('
            select
                name, url, tabname
            from cmf_script
            where parent_id=? and realstatus=1
            order by ordering', array($id));
        $rows = array_merge($prow, $crows);
        $xmlutils= new sabay\XMLUtils();
        return $xmlutils->getFlatXML($rows, 'tabs', 'tab');
    }

    function getUpTabs($id)
    {

        $pid = $this->db->fetchOne('
            select parent_id
            from cmf_script where cmf_script_id=?', $id);

        $prow = $this->db->fetchAll('
            select
                name, url, 0 as cur, tabname
            from cmf_script
            where cmf_script_id=? and realstatus=1
            ', array($pid));
        $crows = $this->db->fetchAll('
            select
                name, url, if(cmf_script_id=?,1,0) as cur, tabname
            from cmf_script
            where parent_id=? and realstatus=1
            order by ordering', array($id , $pid));
        $rows = array_merge($prow, $crows);
        $xmlutils= new sabay\XMLUtils();
        return $xmlutils->getFlatXML($rows, 'tabs', 'tab');
    }
}
