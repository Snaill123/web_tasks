﻿## 留言板 version2 ~~ ##
 

> 修改了第一版的bug
留言板采用yml文件存储数据，实现了留言的新增，查看，删除和按id和
author进行查找的功能

## 代码编写bug调试与感想 ##

> 刚开始感觉无从下手，后来仔细看了即便sinatra的文档，了解路由和页面渲染的基本概念后开始着手，各种细节问题不断，比如数据怎么传给erb页面，我都是使用的全局变量，本来打算使用数据库存储，后来还是改为较简单的yml文件充数了，第一次作业的时候采用的hash存储学生信息，这次用类来定义，对于数组中的按类的属性进行排序还是有点迷，不过对ruby的语法了解的深了不少（主要是一直有语法报错🙃）这一版实现了基本功能，不足之处挺多的：没有考虑中文乱码，也没有考虑各种异常输入情况，下一步打算尝试下留言编辑和回复删除的留言功能
