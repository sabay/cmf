<?php
require_once 'models/entity/cmf_user_role_linkEntity.php';

class CmfURole extends cmf_user_role_linkEntity
{
    const ADMIN                       = 1;
    const EDITOR                      = 2;
    const WEBMASTER                   = 3;

    public function addRole($roleId, $userId)
    {
        $this->insertIgnoreDuplicate($userId, array('cmf_role_id' => $roleId));

    }
}
