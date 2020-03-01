<?php
declare (strict_types = 1);

namespace app\model;

use think\Model;

/**
 * @mixin think\Model
 */
class Bind extends Model
{
    public function UserFrom()
    {
        return $this->hasOne(User::class,'id','user_id_from')->bind(['nickname', 'avater']);
    }
    public function UserTo()
    {
        return $this->hasOne(User::class,'id','user_id_to');
    }
}
