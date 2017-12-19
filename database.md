数据库设计
===========================================

>auto-code-building，Ruby on rails项目数据库设计

### 一、User

```js
id  ruby默认添加的ID
user_type 0表示普通用户，1表示管理员
user_name  登录名（区别于真实姓名）
pwd  密码
```

### 二、Project

```js
id  ruby默认添加的ID
author 所属用户，对应User中的id
project_name  项目名称
project_url  项目Github地址
```

### 三、Commits

```js
关联Project表
id  ruby默认添加的ID
project 所属项目，对应Project中的id
loginfo  build信息
```
