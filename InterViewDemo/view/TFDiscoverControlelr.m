//
//  TFDiscoverControlelr.m
//  InterViewDemo
//
//  Created by yangxiaofei on 16/8/4.
//  Copyright (c) 2016年 yangxiaofei. All rights reserved.
//

#import "TFDiscoverControlelr.h"
#import "TFDataStoreTool.h"
#import "TFTableViewCell.h"
#import "TFDataFrameItem.h"
#import "TFDataItem.h"
#import "MJRefresh.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface TFDiscoverControlelr ()<UITableViewDataSource,UITableViewDelegate>

//@property (nonatomic,strong) NSMutableArray *items;

@property (nonatomic,strong) NSMutableArray *frameItems;

@property (nonatomic,weak) UITableView *tableview;

@end

@implementation TFDiscoverControlelr

//- (NSMutableArray *)items
//{
//    if (!_items) {
//        _items = (NSMutableArray *)[[TFDataStoreTool sharedTFDataStoreTool] getdata];
//    }
//    return _items;
//}

- (NSMutableArray *)frameItems
{
    if (!_frameItems) {
        _frameItems = [NSMutableArray array];
    }
    return _frameItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
     使用UIScrollerView和继承自它的view的时候，系统会自动为他们在顶部增加一段距离，将下面的属性设置成NO就可以了
     */
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    //添加tableview
    [self addtableView];

    //添加头部刷新
    [self.tableview addHeaderWithTarget:self action:@selector(headerRereshing)];
    //进入控制器前首先加载数据
    [self.tableview headerBeginRefreshing];
}

//刷新数据
- (void)headerRereshing
{
    [self getMoreData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableview headerEndRefreshing];
    });
}


//- (void)getData
//{
//    NSArray *items = (NSArray *)[[TFDataStoreTool sharedTFDataStoreTool] getdata];
//    for (int i = 0; i < items.count; i++) {
//        TFDataFrameItem *frameitem = [[TFDataFrameItem alloc] init];
//        TFDataItem *item = items[i];
//        frameitem.item = item;
//        [self.frameItems addObject:frameitem];
//    }
//}

//加载最新数据
- (void)getMoreData
{
    //请求到的最新的数据
    NSMutableArray *array = (NSMutableArray *)[[TFDataStoreTool sharedTFDataStoreTool] getdata];
//    NSLog(@"array%ld",array.count);
//    NSLog(@"frame%ld",self.frameItems.count);
    if (array.count > self.frameItems.count) { //有新数据
            //遍历最新数组
            for (NSInteger i = self.frameItems.count; i<array.count; i++){
                TFDataFrameItem *frameitem = [[TFDataFrameItem alloc] init];
                //取出下标对应的模型
                TFDataItem *item = array[i];
                frameitem.item = item;
                [self.frameItems insertObject:frameitem atIndex:0];
            }
        [self.tableview reloadData];
    }
}

- (void)addtableView
{
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-44) style:UITableViewStylePlain];
    _tableview = tableview;
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.backgroundColor = [UIColor lightGrayColor];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
}

#pragma mark - UITabbleView的数据源和代理方法
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.frameItems.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFTableViewCell *cell = [TFTableViewCell cellWithTableview:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    //获取模型
    TFDataFrameItem *frameItem = self.frameItems[indexPath.row];
    cell.dataframeItem = frameItem;
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFDataFrameItem *frame = self.frameItems[indexPath.row];
    
    return frame.cellhieght;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
