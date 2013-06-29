<?php
require_once 'models/entity/userEntity.php';

class User extends userEntity
{

    function login($email,$pass){
        return $this->db->fetchRow('select * from user where email = ? and password=?',
                                    array(trim($email), md5(trim($pass))));
    }
}
