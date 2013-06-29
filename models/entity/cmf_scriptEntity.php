<?php
require_once 'lib/Entity.php';
require_once 'lib/files.php';

class cmf_scriptEntity extends Entity
{
    static public $_meta = array(
        'cmf_script_id' => array('cmf_script_id',
                array('name'      => 'N',
                      'type'      => 0,
                      'primary'   => 'y',
                      'visuality' => 'y')
        ),
        'parent_id' => array('parent_id',
                array('name'      => 'N',
                      'type'      => 3,
                      'parent'    => 'y')
        ),
        'article' => array('article',
                array('name'      => 'Псевдоним скрипта',
                      'type'      => 1)
        ),
        'name' => array('name',
                array('name'      => 'Название cкрипта',
                      'type'      => 1,
                      'visuality' => 'y',
                      'size'      => '90')
        ),
        'url' => array('url',
                array('name'      => 'Путь к скрипту',
                      'type'      => 1,
                      'visuality' => 'y',
                      'size'      => '90')
        ),
        'description' => array('description',
                array('name'      => 'Краткое описание',
                      'type'      => 2,
                      'rows'      => '7',
                      'cols'      => '90')
        ),
        'title' => array('title',
                array('name'      => 'Заголовок страницы',
                      'type'      => 1,
                      'size'      => '90')
        ),
        'tabname' => array('tabname',
                array('name'      => 'Заголовок табулятора (ред.)',
                      'type'      => 1,
                      'size'      => '90')
        ),
        'image' => array('image',
                array('name'      => 'Картинка',
                      'type'      => 7)
        ),
        'background' => array('background',
                array('name'      => 'Цвет фона',
                      'type'      => 1,
                      'size'      => '7')
        ),
        'type' => array('type',
                array('name'      => 'Тип',
                      'type'      => 10,
                      'visuality' => 'y',
                      'size'      => '90',
                      'multioptions' => 'type')
        ),
        'status' => array('status',
                array('name'      => 'Вкл',
                      'type'      => 8)
        ),
        'realstatus' => array('realstatus',
                array('name'      => 'auto Статус - Вкл/Выкл',
                      'type'      => 8,
                      'internal'  => 'y')
        ),
        'ordering' => array('ordering',
                array('name'      => 'Порядок сортировки',
                      'type'      => 11,
                      'internal'  => 'y')
        ),
        'lastnode' => array('lastnode',
                array('name'      => 'лист дерева',
                      'type'      => 8,
                      'internal'  => 'y')
        ));

    static public $_meta_select = array('_id' => 'cmf_script_id', 'name', 'url', 'type', '_state' => 'status', 'realstatus', '_last' => 'lastnode');
    public $_meta_short_list = array('_id' => 'N', 'name' => 'Название cкрипта', 'url' => 'Путь к скрипту', '_strtype' => 'Тип');
    protected $_meta_enums = array(
        'type' => array(
                '0' => ' в главное меню ', 
                '1' => ' показывать справа', 
                '2' => ' новый'));


    protected $_meta_default = array('status' => 0,
                        'realstatus' => 0,
                        'lastnode' => 0);

    

    

    

    

    

    public $imagePath = '/adm/';
    public $xmls = array();

    public function getMeta()
    {
        return self::$_meta;
    }

    public static function getColumnMeta($name)
    {
        return self::$_meta[$name];
    }

    public static function getArrayColumnMeta($name)
    {
        return self::$_meta[$name][1]['validators'][0][1];
    }

    public function getMetaEnums()
    {
        $gettext = new \sabay\GetText(get_class($this) . 'Validator',
                                'ru');
        $translatedEnums = array();
        foreach ($this->_meta_enums as $i => $enum) {
            foreach ($enum as $j => $text) {
                $message = $gettext->getText($text);
                if ($message) {
                    $text = $message;
                }
                $translatedEnums[$i][$j] = $text;
            }
        }
        return $translatedEnums;
    }

    public function insert($params=null)
    {
        $this->_aData = array();
        
        if ($params !== null) {
            $this->_aData = array_merge($this->_aData, $params);
        }
        if ($this->existEvent('_preInsert')) {
            $this->_preInsert();
        }
        $this->db->insert('cmf_script',
                          array('parent_id' => $this->getparent_id(),
                                'article' => $this->getarticle(),
                                'name' => $this->getname(),
                                'url' => $this->geturl(),
                                'description' => $this->getdescription(),
                                'title' => $this->gettitle(),
                                'tabname' => $this->gettabname(),
                                'background' => $this->getbackground(),
                                'type' => $this->gettype(),
                                'status' => $this->getstatus()));

        $this->id = $this->db->lastInsertId('cmf_script', 'cmf_script_id');
        $this->setordering($this->db->fetchOne('SELECT max(ordering) FROM cmf_script WHERE parent_id = ?', $this->getparent_id())+1);
        
        $fileutils= new \sabay\Files($this->config);
        $picture = $this->getimage();
        if (is_array($picture)) {
            if ($picture['temp_image']) {
                $fileParts = explode('#', $picture['old_image']);
                $oldFileName = array_shift($fileParts);
                $ext = explode('.', $oldFileName);
                $ext = array_pop($ext);
                $newFileName = $this->id . '_' . substr(time(), -3, 3) . '.' . $ext;
                $dir = $this->config->root() . '/images' . $this->imagePath;
                system('mv ' . $dir . $oldFileName . ' ' . $dir . $newFileName);
                $this->setimage(implode('#', array_merge(array($newFileName), $fileParts)));
            } else {
                $this->setimage($fileutils->PicturePost($picture, $picture['old_image'],
                                $this->id . '_' . substr(time(), -3, 3), $this->imagePath));
            }
            if ($picture['clr_image']) {
                $fileutils->UnlinkFile($picture['old_image'], $this->imagePath);
                $this->setimage(null);
            } elseif (
               ($this->getimage() != $picture['old_image'])
               && $this->existEvent('_postUpdateimage')
            ) {
                $this->_postUpdateimage();
            }
        }

        $this->setrealstatus($this->getstatus());

        $this->db->update('cmf_script',
                          array('image' => $this->getimage(),
                                'realstatus' => $this->getrealstatus(),
                                'ordering' => $this->getordering()),
                          $this->db->quoteInto('cmf_script_id = ?', $this->id));
        $this->db->update('cmf_script', array('lastnode'=>0),
                          $this->db->quoteInto('cmf_script_id = ?',
                          $this->getparent_id()));

        if ($this->existEvent('_postInsert')) {
            $this->_postInsert();
        }
        return $this->id;
    }

    public function _load($id=null)
    {
        if ($id !== null) {
            $this->id = $id;
        }
        return $this->db->fetchRow('select * from cmf_script where cmf_script_id = ?', $this->id);
    }

    public function update($id=null, $params=null)
    {
        if ($id !== null) {
            $this->id = $id;
        }
        if ($id !== null) {
            $this->_aData = $this->_load($id);
        }
        if ($params !== null) {
            $this->_aData = array_merge($this->_aData, $params);
        }
        if ($this->existEvent('_preUpdate')) {
            $this->_preUpdate();
        }
        
        $fileutils= new \sabay\Files($this->config);
        $picture = $this->getimage();
        if (is_array($picture)) {
            if ($picture['temp_image']) {
                $fileParts = explode('#', $picture['old_image']);
                $oldFileName = array_shift($fileParts);
                $ext = explode('.', $oldFileName);
                $ext = array_pop($ext);
                $newFileName = $this->id . '_' . substr(time(), -3, 3) . '.' . $ext;
                $dir = $this->config->root() . '/images' . $this->imagePath;
                system('mv ' . $dir . $oldFileName . ' ' . $dir . $newFileName);
                $this->setimage(implode('#', array_merge(array($newFileName), $fileParts)));
            } else {
                $this->setimage($fileutils->PicturePost($picture, $picture['old_image'],
                                $this->id . '_' . substr(time(), -3, 3), $this->imagePath));
            }
            if ($picture['clr_image']) {
                $fileutils->UnlinkFile($picture['old_image'], $this->imagePath);
                $this->setimage(null);
            } elseif (
               ($this->getimage() != $picture['old_image'])
               && $this->existEvent('_postUpdateimage')
            ) {
                $this->_postUpdateimage();
            }
        }

        $this->setrealstatus($this->getstatus());

        $this->db->update('cmf_script',
                          array('article' => $this->getarticle(),
                                'name' => $this->getname(),
                                'url' => $this->geturl(),
                                'description' => $this->getdescription(),
                                'title' => $this->gettitle(),
                                'tabname' => $this->gettabname(),
                                'image' => $this->getimage(),
                                'background' => $this->getbackground(),
                                'type' => $this->gettype(),
                                'status' => $this->getstatus()),
                          $this->db->quoteInto('cmf_script_id = ?', $this->id));

        if ($this->existEvent('_postUpdate')) {
            $this->_postUpdate();
        }
    }

    public function delete($id=null)
    {
        if ($id !== null) {
            $this->id = $id;
        }
        if ($this->existEvent('_preDelete')) {
            $this->_preDelete();
        }
        $pid = $this->db->fetchOne('select parent_id from cmf_script where cmf_script_id = ?', $this->id);
        $childcount = $this->db->fetchOne('select count(*) from cmf_script where parent_id = ?', $pid);
        if ($childcount == 1) {
            $this->db->update('cmf_script',
                              array('lastnode' => 1),
                              $this->db->quoteInto('cmf_script_id = ?', $pid));
        }
        $this->db->delete('cmf_script', $this->db->quoteInto('cmf_script_id = ?', $this->id));
        $this->_delSubTree($this->id);
        if ($this->existEvent('_postDelete')) {
            $this->_postDelete();
        }
    }






    public function _delSubTree($id)
    {
        $select = $this->db->select()
                       ->from('cmf_script', array('id' => 'cmf_script_id'))
                       ->where('parent_id = ?', $id);
        $rows = $this->db->fetchAll($select);
        foreach($rows as $row) {
            $this->_delSubTree($row['id']);
            $this->db->delete('cmf_script', $this->db->quoteInto('cmf_script_id = ?', $row['id']));
        }
    }

    public function _calkRealStatus($id)
    {
        $pid = $id;
        $realstate = 1;
        while ($pid > 0) {
            $row = $this->db->fetchRow('SELECT parent_id as pid, status as state FROM cmf_script WHERE cmf_script_id=?', $pid);
            if ($row['state']!=1) {
                $realstate = 0;
            }
            $pid = $row['pid'];
        }
        return $realstate;
    }

    public function _SetTreeRealStatus($id,$state)
    {
        $select = $this->db->select()
                       ->from('cmf_script',array('id'=>'cmf_script_id','status'=>'status'))
                       ->where('parent_id=?',$id);
        $rows = $this->db->fetchAll($select);
        foreach ($rows as $row) {
            if ($row["status"]) {
                $this->_SetTreeRealStatus($row['id'], $state);
            }
            if ($state) {
                $this->db->query('update cmf_script set realstatus=status where cmf_script_id=?', $row['id']);
            } else {
                $this->db->query('update cmf_script set realstatus=0 where cmf_script_id=?', $row['id']);
            }
        }
    }

    public function _getOpenLeafs($id=0,&$hash)
    {
        if (!$id) {
            return $hash;
        }

        $select = $this->db->select()
                       ->from('cmf_script', array('pid' => 'parent_id'))
                       ->where('cmf_script_id=?', $id);
        $rows = $this->db->fetchAll($select);
        foreach ($rows as $row) {
            if ($row["pid"]) {
                $this->_getOpenLeafs($row["pid"], $hash);
            }

            $select = $this->db->select()
                           ->from('cmf_script', array('id' => 'cmf_script_id'))
                           ->where('parent_id = ?', $id);
            $rows = $this->db->fetchAll($select);
            foreach ($rows as $row) {
                array_push($hash, $row['id']);
            }
        }

        return $hash;
    }

    public function vs($id=null)
    {
        if ($id !== null) {
            $this->id = $id;
        }

        $this->db->query('UPDATE cmf_script
                          SET status = NOT(IFNULL(status, FALSE)),
                              realstatus = status
                          WHERE cmf_script_id = ?', $this->id);

        $this->_SetTreeRealStatus($this->id, $this->getrealstatus());
    }

    public function _preUpdate($id=null, $params=null)
    {
        if ($id !== null) {
            $this->id = $id;
        }
        if($params && is_array($params) && array_key_exists('status',$params))
    {
            $select = $this->db->select()
                       ->from('cmf_script', array('status' => 'status'))
                       ->where('cmf_script_id = ?', $this->id);
            $old = $this->db->fetchRow($select);
            if($params['status'] != $old['status']) $this->vs($id);
    }
    }

    public function updateMove($id=null, $params=null)
    {
        if ($id !== null) {
            $this->id = $id;
        }
        $a = $this->_load($id);
        $old_parent_id = $a['parent_id'];
        $parent_id = $params['parent_id'];
        $ordering = $params['ordering'];

        $cnt = $this->db->fetchOne('select count(*) from cmf_script
        where parent_id = ? and cmf_script_id != ?',
            array(
                $old_parent_id,
                $id));
       if( $cnt==0 )
            $this->db->query('update cmf_script set lastnode=1
            where cmf_script_id = ?', $old_parent_id);

        $this->db->query('update cmf_script set parent_id = ?, ordering = ?
        where cmf_script_id = ?',
        array(
            $parent_id,
            $ordering,
            $id
            ));
        $this->db->query('update cmf_script set lastnode = 0
        where cmf_script_id = ?', array($parent_id));
    }





    public function up($id=null)
    {
        if ($id !== null) {
            $this->id = $id;
        }

        $old = $this->db->fetchRow('select * from cmf_script where cmf_script_id =?',  $this->id);

        $parent_id = $old['parent_id'];
        $_id = $old['cmf_script_id'];
        $order = $old['ordering'];

        $new = $this->db->fetchRow('select * from cmf_script
            where ordering < ?
                and parent_id = ?
            order by ordering DESC limit 1',  array($order, $parent_id));
                $prev =    $new['ordering'];
        $new_id = @$new['cmf_script_id'];

        if($new && $prev <  $old['ordering'])
        {
            $this->db->query('UPDATE cmf_script set ordering=? WHERE cmf_script_id=?', array($prev, $_id));
            $this->db->query('UPDATE cmf_script set ordering=? WHERE cmf_script_id = ?', array($order, $new_id));
        }

    }

    public function dn($id = null)
    {
        if ($id !== null) {
            $this->id=$id;
        }

        $old = $this->db->fetchRow('select * from cmf_script where cmf_script_id =?',  $this->id);

        $parent_id = $old['parent_id'];
        $_id = $old['cmf_script_id'];
        $order = $old['ordering'];

        $new = $this->db->fetchRow('select * from cmf_script
            where ordering > ?
                and parent_id = ?
            order by ordering ASC limit 1',  array($order, $parent_id));
                $next =    $new['ordering'];
        $new_id = @$new['cmf_script_id'];

        if($new && $next >  $old['ordering'])
        {
            $this->db->query('UPDATE cmf_script set ordering=? WHERE cmf_script_id=?', array($next, $_id));
            $this->db->query('UPDATE cmf_script set ordering=? WHERE cmf_script_id = ?', array($order, $new_id));
        }

    }
}
