<?php
namespace app\controller;

use app\BaseController;
use app\model\User;
use app\model\Bind;
use think\exception\ValidateException;
class UserController extends BaseController
{
    /**
     * Post(phone & password)
     * return code:
     * 200: login succeed & return User info
     * 400: Password eroor
     * 404: User not found
     */
    public function login()
    {
        $request = request();
        $phone = $request->param('phone');
        $password = md5(md5($request->param('password')).md5($phone));
        $user = $this->v_hasUser($phone);
        if($user == false){
            return json($data=['status'=>404,'message'=>'账号不存在'],$code=200);
        }
        if($user->password == $password){
            $user->token = (String) md5(random_int(10000,99999)+time());
            $user->save();
            unset($user['password']);
            $bind = Bind::where('user_id_from',$user->id)->whereOr('user_id_to',$user->id)->find();
            $otherUser=null;
            if($bind!=null){
                $queryId = $bind->user_id_from;
                if($queryId==$user->id){
                    $queryId = $bind->user_id_to;
                }
                $otherUser = User::where('id',$queryId)->find();
                if($otherUser!=null){
                    unset($otherUser['password']);
                }
            }
            return json($data=['status'=>200,'message'=>'登录成功','user'=>$user,'otheruser'=>$otherUser,'bind'=>$bind],$code=200);
        }else{
            return json($data=['status'=>401,'message'=>'密码错误'],$code=200);
        }
    }

    /**
     * Post(phone & password)
     * return code:
     * 200: login succeed & return User info
     * 400: overdue Token
     * 404: token not found
     */
    public function token()
    {
        $request = request();
        $token = $request->param('token');
        $user = User::where('token',$token)->find();
        if($user == NULL){
            return json($data=['status'=>404,'message'=>'token不存在'],$code=200);
            // exit(json_encode(['code'=>400,'message'=>'error']));
        }
        if((time()-strtotime($user->update_time))<604800){
            //未超过一周
            unset($user['password']);
            // $bind = Bind::whereOr(['user_id_to'=>$user->id,'user_id_from'=>$user->id])->where('status',1)->find();
            $bind = Bind::where('user_id_to|user_id_from',$user->id)->where('status',1)->find();
            $otherUser=null;
            if($bind!=null){
                $queryId = $bind->user_id_from;
                if($queryId==$user->id){
                    $queryId = $bind->user_id_to;
                }
                $otherUser = User::where('id',$queryId)->find();
                if($otherUser!=null){
                    unset($otherUser['password']);
                }
            }
            return json($data=['status'=>200,'message'=>'登录成功','user'=>$user,'otheruser'=>$otherUser,'bind'=>$bind],$code=200);
        }else{
            //超过一周需要重新登陆
            return json($data=['status'=>401,'message'=>'token过期'],$code=200);
        }
    }

    /**
     * Post(phone & password & nickname & code)
     * return code:
     * 200: reg succeed & return User info
     * 400: code eroor
     * 403: can't save data (reg eroor)
     * 205: User is reg
     */
    public function reg()
    {
        $request = request();
        // $code = Code::where('phone',$request->param('username'))
        // ->where('code',$request->param('code'))
        // ->whereTime('update_time','-1 hours')
        // ->order('update_time', 'desc')
        // ->find();
        // if($code==null){
            // return json($data=['status'=>400,'message'=>'注册失败'],$code=200);
        // }
        // $code->delete();
        $phone = $request->param('phone');
        $password = $request->param('password');
        $nickname = $request->param('nickname');
        // || strlen(trim($phone))!=11
        if(empty($phone) || empty($password) || empty($nickname)){
            return json($data=['status'=>404,'message'=>'参数错误'],$code=404);
        }
        if($this->v_hasUser($phone)!=false){
            return json($data=['status'=>205,'message'=>'账号存在'],$code=200);
        }
        $user = new User;
        $user->phone = $phone;
        $user->nickname = $nickname;
        $user->password = md5(md5($password).md5($phone));
        if($user->save()){
            return json($data=['status'=>200,'message'=>'注册成功','user'=>$user],$code=200);
        }else{
            return json($data=['status'=>400,'message'=>'注册失败'],$code=200);
        }
    }
    /**
     * get(phone)
     * return:
     * User model or false
     */
    public function search(String $phone)
    {
        $user = User::where('phone',$phone)->find();
        if($user!=null){
            unset($user['password']);
            unset($user['token']);
            return json($data=['status'=>200,'user'=>$user],$code=200);
        }
        return json($data=['status'=>404,'message'=>'没有找到该用户'],$code=200);
    }

    public function upload(){
        $request = request();
        $file = $request->file('file');
        $nickname = $request->param('nickname');
        $uid = $request->param('user_id');
        $user = User::where('id',$uid)->find();
        if($user==null){
            return json($data=['status'=>404,'message'=>'没有找到该用户'],$code=200);
        }
        if($file){
            try{
                validate(['imgFile'=>[
                'fileSize' => 410241024,
                'fileExt' => 'jpg,jpeg,png,bmp,gif',
                'fileMime' => 'image/jpeg,image/png,image/gif', //这个一定要加上，很重要我认为！
                ]])->check(['imgFile' => $file]);
            }catch(ValidateException $e){
                return json($data=['status'=>400,'message'=>'文件格式错误'],$code=200);
            }
            $savename = \think\facade\Filesystem::disk('public')->putFile('avater', $file);
            $user->avater = 'http://192.168.1.5:8000/storage/'.$savename;
            if($user->save()){ 
                return json($data=['status'=>200,'message'=>'更新成功','url'=>$user->avater],$code=200);
            }else{
                return json($data=['status'=>400,'message'=>'更新失败'],$code=200);
            }
        }
        if($nickname){
            $user->nickname = $nickname;
            if($user->save()){ 
                return json($data=['status'=>200,'message'=>'更新成功','nickname'=>$user->nickname],$code=200);
            }else{
                return json($data=['status'=>400,'message'=>'更新失败'],$code=200);
            }
        }
        
    }

    /**
     * get(phone)
     * return:
     * User model or false
     */
    public function v_hasUser(String $phone)
    {
        $user = User::where('phone',$phone)->find();
        return $user==Null ? false : $user;
    }

}
