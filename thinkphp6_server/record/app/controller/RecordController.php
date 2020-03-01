<?php
namespace app\controller;

use app\BaseController;
use app\model\Record;
use app\model\Bind;
class RecordController extends BaseController
{
    public function query()
    {
        $request = request();
        $bid = $request->param('bind_id');
        $uid = $request->param('user_id');
        $record = Record::where('bind_id',$bid)->order('record_time','desc')->select();
        $data = [];
        foreach ($record as $value) {
            $value['show'] = $uid==$value['user_id'] ? 'left' : 'right';
            $value['record_time'] = date('yy-m-d',strtotime($value['record_time']));
            $data[] = $value;
        }
        return json($data=['status'=>200,'data'=>$data],$code=200);
    }
    public function push()
    {
        $request = request();
        $bid = $request->param('bind_id');
        $uid = $request->param('user_id');
        $text = $request->param('text');
        $time = $request->param('time');
        $bind = Bind::where('id',$bid)->find();
        if($bind!=null){
            if($bind['status']==1){
                $record = new Record;
                $record->bind_id = $bid;
                $record->user_id = $uid;
                $record->body = $text;
                $record->record_time = $time;
                if($record->save()){
                    return json($data=['status'=>200,'message'=>'记录成功'],$code=200);
                }else{
                    return json($data=['status'=>400,'message'=>'记录失败'],$code=200);
                }
            }else{
                return json($data=['status'=>401,'message'=>'未处于连接状态'],$code=200);
            }
        }
        return json($data=['status'=>404,'message'=>'没有找到这个连接'],$code=200);
    }
}
