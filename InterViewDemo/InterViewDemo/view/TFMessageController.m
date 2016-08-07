//
//  TFMessageController.m
//  InterViewDemo
//
//  Created by yangxiaofei on 16/8/4.
//  Copyright (c) 2016年 yangxiaofei. All rights reserved.
//

#import "TFMessageController.h"
#import "TFContentController.h"
#import "TFDataItem.h"
#import "TFDataStoreTool.h"
#import "TFDataFrameItem.h"

@interface TFMessageController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *contentView;
@property (weak, nonatomic) IBOutlet UITextField *nameView;

/**
 存放所有模型的数组
 */
@property (nonatomic,strong) NSMutableArray *items;
/**
 存放所有图片的数组
 */
@property (nonatomic,strong) NSMutableArray *images;

/*内容控制器*/
@property (nonatomic,strong) TFContentController *contentVC;

@end


@implementation TFMessageController

- (NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (NSMutableArray *)images{
    if (_images == nil) {
        _images = [NSMutableArray array];
//        _allimages  =arrays;
    }
    return _images;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    //给contentView设置代理
    self.contentView.delegate = self;
}

- (IBAction)album:(id)sender {
    NSLog(@"选取本地相册里面的图片");
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    //设置相册类型，即弹出相册哪一部分的内容，直接是相机还是相册
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    //模态方式弹出本地相册
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - 调用本地相册的代理
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@",info);
    //选中的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSURL *url = info[UIImagePickerControllerReferenceURL];
    
    //截取id，唯一标志，作为存储的id
    NSString *urlstr = url.absoluteString;
    //    assets-library://asset/asset.JPG?id=9E94EE17-5B40-443B-9364-74CC0EE24A8D&ext=JPG
    NSLog(@"%@",urlstr);
    NSRange range1 = [urlstr rangeOfString:@"id="];
    NSString *codeStr = [urlstr substringFromIndex:range1.location + range1.length];
    NSRange range2 = [codeStr rangeOfString:@"&"];
    NSString *Id = [codeStr substringToIndex:range2.location];
    //    914A687E-6844-44B2-9B06-F5F2BA0374D8
//    NSLog(@"%@",Id);
    //将选中的图片保存
    
    /*每次编译沙盒的路径都会改变，所以不能直接保存带有沙盒路径的路径名字，只能保存图片名字*/
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    //filePath，取图片的时候的路径名字
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", Id]];   // 保存文件的名称
    [UIImagePNGRepresentation(image) writeToFile: filePath    atomically:YES];
//    NSLog(@"---%@",filePath);
    [self.images addObject:Id];
      
    //推出控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)takePicture:(id)sender {
    NSLog(@"照相");
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    
//    //设置相册类型，即弹出相册哪一部分的内容，直接是相机还是相册
//    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    
//    //模态方式弹出本地相册
//    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    NSLog(@"将所有的数据缓存到本地");
    
    //1. 获取到name的text
    NSString *name = self.nameView.text;
    //2. 获取到内容的text
    NSString *content = self.contentView.text;
    //3. 获取到所有的图片
#warning 先假设已经获取到所有的图片，已经保存到了数组中
    TFDataItem *item = [[TFDataItem alloc] init];
    item.name = name;
    item.content = content;
    item.images = [self.images mutableCopy];
    //清空原来的缓存
    [self.images removeAllObjects];
    
    //添加到数组中
    [self.items addObject:item];
    if (self.nameView.text.length != 0) {
        //数据缓存
        [[TFDataStoreTool sharedTFDataStoreTool] save:item];
    }else{
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"昵称为空，请重新输入" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alter show];
    }
    
    //清空控件的内容
    self.nameView.text = nil;
    self.contentView.text = nil;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.view endEditing:YES];
    
    //弹出UIDatePicker 代码
    NSLog(@"弹出新的控制器");
    //以模态窗口的形势弹出
    TFContentController *contentVC = [[TFContentController alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textchange) name:UITextViewTextDidChangeNotification object:contentVC.contentView];
    
    contentVC.hidesBottomBarWhenPushed = YES;
    
    self.contentVC = contentVC;
    /*
     在这里将TFContentController的textfield － contentView未知原因并没有分配内存，所以直接给其赋值失败，只能采用间接的方式，即先给控制器的NSString属性赋值，在控制器的viewdidload（contentView在这个方法里面才创建成功）方法给其赋值
     */
    if (self.contentView.text.length != 0) {
        contentVC.context = self.contentView.text;
    }

    [self.navigationController pushViewController:contentVC animated:YES];
    return NO;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //取出数据，并且输出数组的个数
    id object = [[TFDataStoreTool sharedTFDataStoreTool] getdata];
    NSArray *items = (NSArray *)object;
    NSLog(@"%lu",(unsigned long)items.count);
}

- (void)textchange
{
    self.contentView.text = self.contentVC.contentView.text;
}

#pragma mark - UIAlertView的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"取消");
        [self.nameView resignFirstResponder];
    }else
    {
        NSLog(@"确定");
        [self.nameView becomeFirstResponder];
    }
}

@end
