<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006~2018 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------
use think\facade\Route;

Route::get('think', function () {
    return 'hello,ThinkPHP6!';
});

Route::get('hello/:name', 'index/hello');

Route::post('reg','UserController/reg');
Route::post('login','UserController/login');
Route::post('token','UserController/token');
Route::get('search/:phone','UserController/search');
Route::post('upload','UserController/upload');

Route::post('query','BindController/query');
Route::post('querymore','BindController/queryMore');
Route::post('change','BindController/change');
Route::post('send','BindController/send');

Route::post('record','RecordController/query');
Route::post('push','RecordController/push');