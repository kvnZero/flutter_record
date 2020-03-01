<?php
namespace app\controller;

use app\BaseController;
use app\model\Bind;
use think\facade\Db;

class BindController extends BaseController
{
    /**
     * Post(userid)
     * return code:
     * 200: has a bind record
     * 404: Bind not found
     */
    public function query()
    {
        $request = request();
        $uid = $request->param('user_id');
        $bind = Bind::where('user_id_from',$uid)->whereOr('user_id_to',$uid)->find();
        if($bind == NULL){
            return json($data=['status'=>404,'message'=>'没有找到对应请求'],$code=200);
        }else{
            return json($data=['status'=>200,'bind'=>$bind],$code=200);
        }
    }

    /**
     * Post(bind)
     * return code:
     * 200: has a bind record
     * 404: Bind not found
     */
    public function queryMore()
    {
        $request = request();
        $bid = $request->param('bind_id');
        $bind = Bind::find($bid)->with('userFrom')->select();
        if($bind == NULL){
            return json($data=['status'=>404,'message'=>'没有找到对应请求'],$code=200);
        }else{
            return json($data=['status'=>200,'bind'=>$bind],$code=200);
        }
    }

    /**
     * Post(user_id_from & user_id_to)
     * return code:
     * 201: has bind record
     * 200: send succeed
     * 400: send error
     */
    public function send()
    {
        $request = request();
        $user_id_from = $request->param('user_id_from');
        $user_id_to = $request->param('user_id_to');
        if($user_id_from == $user_id_to){
            return json($data=['status'=>402,'message'=>'不可以和自己连接'],$code=200);
        }
        $text = $request->param('text');
        $bind =  Bind::where('user_id_from',$user_id_from)->where('user_id_to',$user_id_to)->find();
        if($bind != NULL){
            switch ($bind['status']) {
                case 0:
                    return json($data=['status'=>402,'message'=>'已经发送过请求啦'],$code=200);
                    break;
                case 1:
                    return json($data=['status'=>402,'message'=>'已经连接'],$code=200);
                    break;
                case 2:
                    $bind->status = 0;
                    $bind->save();
                    return json($data=['status'=>402,'message'=>'已经重新请求啦'],$code=200);
                    break;
            }
        }
        $bindfrom = Bind::where('user_id_to|user_id_from',$user_id_from)->find();
        if($bindfrom != NULL){
            switch ($bindfrom['status']) {
                case 0:
                    return json($data=['status'=>402,'message'=>'你正在请求或者被请求中...'],$code=200);
                    break;
                case 1:
                    return json($data=['status'=>402,'message'=>'你已经处于链接状态'],$code=200);
                    break;
                case 2:
                    if($user_id_from==$bindfrom['user_id_from']){
                        $bindfrom->delete();
                    }
            }
        }
        $bindto = Bind::where('user_id_to|user_id_from',$user_id_to)->find();
        if($bindto !== NULL){
            switch ($bindto['status']) {
                case 0:
                    return json($data=['status'=>402,'message'=>'对方正在被请求中...'],$code=200);
                    break;
                case 1:
                    return json($data=['status'=>402,'message'=>'对方已经处于链接状态'],$code=200);
                    break;
            }
        }
        $bind = new Bind;
        $bind->user_id_from = $user_id_from;
        $bind->user_id_to = $user_id_to;
        $bind->text = $text;
        if($bind->save()){
            return json($data=['status'=>200,'message'=>'发送请求成功','bind'=>$bind],$code=200);
        }else{
            return json($data=['status'=>400,'message'=>'发送请求失败'],$code=200);
        }
    }

    /**
     * Post(bind_id & type)
     * return code:
     * 200: change succeed
     * 400: change error
     * 404: not found
     */
    public function change()
    {
        $request = request();
        $bid = $request->param('bind_id');
        $status = $request->param('type');
        $bind = Bind::where('id',$bid)->find();
        if($bind==NULL){
            return json($data=['status'=>404,'message'=>'没有找到对应记录'],$code=200);
        }
        switch ($status) {
            case '-1':
                $bind->delete();
                return json($data=['status'=>200,'message'=>'删除成功'],$code=200);
                break;                
            default:
                $bind->status = $status;
                if($bind->save()){
                    return json($data=['status'=>200,'message'=>'修改成功','bind'=>$bind],$code=200);
                }else{
                    return json($data=['status'=>400,'message'=>'修改失败'],$code=200);
                }
                break;
        }

    }
}
