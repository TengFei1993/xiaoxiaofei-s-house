//
//  TFDataStoreTool.m
//  InterViewDemo
//
//  Created by yangxiaofei on 16/8/4.
//  Copyright (c) 2016年 yangxiaofei. All rights reserved.
//

#import "TFDataStoreTool.h"
#import <sqlite3.h>
#import "TFDataItem.h"

@interface TFDataStoreTool ()

@property (nonatomic,copy) NSString *path;

@property (nonatomic,strong) NSMutableArray *items;

@end

@implementation TFDataStoreTool
singleton_implementation(TFDataStoreTool);

static sqlite3 *_db;

- (NSMutableArray *)items
{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

//在这个类第一次运行的时候，创建数据库文件
+ (void) initialize
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"db.sqlite"];
    
    // 1. 打开数据库
    if(sqlite3_open(dbPath.UTF8String, &_db) == SQLITE_OK){ //打开成功
        
        //sql语句 表1
        const char *sql1 = "create table if not exists t_DataItem (id integer primary key AUTOINCREMENT,name text,content text,foreign key(id) references t_image(id));";
        char *error1;
        sqlite3_exec(_db, sql1, NULL, NULL, &error1);
        
        //表2
        const char *sql2 = "create table if not exists t_image(id integer primary key AUTOINCREMENT,id2 text,url text);";
        char *error2;
        sqlite3_exec(_db, sql2, NULL, NULL, &error2);
        if (error1 && error2) { // 创表失败
            NSLog(@"创表失败");
        }else{ // 创表成功
            NSLog(@"创表成功");
        }
    }else{ //打开失败
        NSLog(@"创建数据库文件失败");
    }
}

/*
//懒加载
- (NSString *)path{
    if (!_path) {
        NSString *cachepath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        _path = [cachepath stringByAppendingPathComponent:@"db.sqlite"];
    }
    return _path;
}
 */

- (void) save:(TFDataItem *) object
{
//    [NSKeyedArchiver archiveRootObject:object toFile:self.path];
    //采用SQLite3的方式做数据本地化
    //增加数据
    //
//    if (object.images.count) {
        for (int i = 0; i < object.images.count; i++) {
            //获取图片的url
            NSString *url = object.images[i];
            NSString *sql1 = [NSString stringWithFormat:@"insert into t_image (id2,url) values ('%@','%@');",object.name,url];
            char *error;
            sqlite3_exec(_db, sql1.UTF8String, NULL, NULL, &error);
            if (error) {
                NSLog(@"t-diamge插入失败");
            }else{
                NSLog(@"插入成功");
            }
        }
//    }
    //获取到表t_image中id2列的最大值
    NSString *sql2 = [NSString stringWithFormat:@"insert into t_DataItem (name,content) values ('%@','%@');",object.name,object.content];
    char *error1;
    sqlite3_exec(_db, sql2.UTF8String, NULL, NULL, &error1);
    if (error1) {
        NSLog(@"t-data插入失败");
    }else{
        NSLog(@"插入成功");
        
    }
    
}

/*模糊查询，返回一个数组*/
- (NSArray *)getdata;
{
    //每次开始查询前，先看有没有最新数据，有的话就查询，没有的话就不用查询
    int count = 0;
    NSString *totalSql = @"select count(*) from t_DataItem;";
    sqlite3_stmt *stmt0;
    if (sqlite3_prepare_v2(_db, totalSql.UTF8String, -1, &stmt0, NULL) == SQLITE_OK) {
        //开始查询
        while (sqlite3_step(stmt0) == SQLITE_ROW) {
            //获取记录数
            count = sqlite3_column_int(stmt0, 0);
//            NSLog(@"count:%d",count);
//            NSLog(@"yuanlaigeshu%d",self.items.count);
        }
    }
//    NSString *ss = [NSString stringWithFormat:@"select *from t_DataItem where t_DataItem.id > %ld;",count-self.items.count+1];
    if (count > self.items.count) { //有新数据，开始查询,应该从新数据开始查询
        NSString *sql1 = [NSString stringWithFormat:@"select * from t_DataItem where t_DataItem.id > %ld;",self.items.count];;
        //1. 创建一个句柄1
        sqlite3_stmt *stmt1;
        //2. 准备查询
        if (sqlite3_prepare_v2(_db, sql1.UTF8String, -1, &stmt1, NULL) == SQLITE_OK) {
            //准备好了，开始查询
            //用一个循环开始
            while (sqlite3_step(stmt1) == SQLITE_ROW) {
                //找到一条记录
                //模型
                //主键数据
    //            int i = sqlite3_column_int(stmt1, 0);
                TFDataItem *item = [[TFDataItem alloc] init];
                NSString *name = [NSString stringWithUTF8String:sqlite3_column_text(stmt1, 1)];
                NSString *content = [NSString stringWithUTF8String:sqlite3_column_text(stmt1, 2)];
                item.name = name;
                item.content = content;
                
                //2表
                NSString *sql2 = [NSString stringWithFormat:@"select url from t_image,t_DataItem where t_DataItem.name = t_image.id2 and t_DataItem.name = '%@';",name];
                //1. 句柄2
                sqlite3_stmt *stmt2;
                //2. 准备
                if (sqlite3_prepare_v2(_db, sql2.UTF8String, -1, &stmt2, NULL) == SQLITE_OK) {
                    //开始
                    //存放图片数组的数组
                    NSMutableArray *imageArr = [NSMutableArray array];
                    while (sqlite3_step(stmt2) == SQLITE_ROW) {
                        //找到所有的记录
                        NSString *url = [NSString stringWithUTF8String:sqlite3_column_text(stmt2, 0)];
                        NSLog(@"url%@",url);
                        
                        [imageArr addObject:url];
                    }
                    item.images = [imageArr mutableCopy];
                    [imageArr removeAllObjects];
                }
                //将所有的模型放进数组
                [self.items addObject:item];
            }
        }
    }
    return self.items;
}

@end
