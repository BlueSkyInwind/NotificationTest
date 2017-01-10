//
//  ViewController.m
//  NotificationTest
//
//  Created by Wangyongxin on 2017/1/5.
//  Copyright © 2017年 Wangyongxin. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self pushNotification_IOS_10_Body:@"2017 , 你好啊" promptTone:nil soundName:@"caodi.m4a"  imageName:@"reminder.JPG" movieName:nil Identifier:@"happy new year"];

}

/**
  IOS 10的通知   推送消息 支持的音频 <= 5M(现有的系统偶尔会出现播放不出来的BUG)  图片 <= 10M  视频 <= 50M  ，这些后面都要带上格式；

 @param body 消息内容
 @param promptTone 提示音
 @param soundName 音频
 @param imageName 图片
 @param movieName 视频
 @param identifier 消息标识
 */
-(void)pushNotification_IOS_10_Body:(NSString *)body
                         promptTone:(NSString *)promptTone
                          soundName:(NSString *)soundName
                          imageName:(NSString *)imageName
                          movieName:(NSString *)movieName
                         Identifier:(NSString *)identifier {
    
    UNUserNotificationCenter * center  = [UNUserNotificationCenter currentNotificationCenter];
    
    UNMutableNotificationContent * content = [[UNMutableNotificationContent alloc]init];
    
    content.body = body;
    //通知的提示音
    if ([promptTone containsString:@"."]) {
        
        UNNotificationSound *sound = [UNNotificationSound soundNamed:promptTone];
        content.sound = sound;
        
    }
    
    UNNotificationAttachment *imageAtt;
    UNNotificationAttachment *movieAtt;
    UNNotificationAttachment *soundAtt;

    if ([imageName containsString:@"."]) {
        
        NSArray * arr = [imageName componentsSeparatedByString:@"."];
        
        NSError * error;
        
        NSString * path = [[NSBundle mainBundle]pathForResource:arr[0] ofType:arr[1]];
        
        imageAtt = [UNNotificationAttachment attachmentWithIdentifier:@"imageAtt" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
        
        if (error) {
            NSLog(@"attachment error %@", error);
        }
        //获取通知下拉放大图片
        content.launchImageName = imageName;
    }
    
    if ([soundName containsString:@"."]) {
        
        NSArray * arr = [soundName componentsSeparatedByString:@"."];
        
        NSError * error;
        
        NSString * path = [[NSBundle mainBundle]pathForResource:arr[0] ofType:arr[1]];
        
        soundAtt = [UNNotificationAttachment attachmentWithIdentifier:@"soundAtt" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
        
        if (error) {
            NSLog(@"attachment error %@", error);
        }
    }
    
//    if ([movieName containsString:@"."]) {
//        
//        NSArray * arr = [movieName componentsSeparatedByString:@"."];
//        
//        NSError * error;
//        
//        NSString * path = [[NSBundle mainBundle]pathForResource:arr[0] ofType:arr[1]];
//        
//        movieAtt = [UNNotificationAttachment attachmentWithIdentifier:@"movieAtt" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
//        
//        if (error) {
//            NSLog(@"attachment error %@", error);
//        }
//    }

    
    NSMutableArray * array = [NSMutableArray array];
    [array addObject:soundAtt];
    [array addObject:imageAtt];
//  [array addObject:movieAtt];
    
    content.attachments = array;
    
    //添加通知下拉动作按钮
    NSMutableArray * actionMutableArray = [NSMutableArray array];
    UNNotificationAction * actionA = [UNNotificationAction actionWithIdentifier:@"identifierNeedUnlock" title:@"需要解锁" options:UNNotificationActionOptionAuthenticationRequired];
    UNNotificationAction * actionB = [UNNotificationAction actionWithIdentifier:@"identifierRed" title:@"红色显示" options:UNNotificationActionOptionDestructive];
    [actionMutableArray addObjectsFromArray:@[actionA,actionB]];
    
    if (actionMutableArray.count > 1) {
        
        UNNotificationCategory * category = [UNNotificationCategory categoryWithIdentifier:@"categoryNoOperationAction" actions:actionMutableArray intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        [center setNotificationCategories:[NSSet setWithObjects:category, nil]];
        content.categoryIdentifier = @"categoryNoOperationAction";
    }
    
    //UNTimeIntervalNotificationTrigger   延时推送
    //UNCalendarNotificationTrigger       定时推送
    //UNLocationNotificationTrigger       位置变化推送

    UNTimeIntervalNotificationTrigger * tirgger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
    
    UNNotificationRequest * request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:tirgger];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
        NSLog(@"%@本地推送 :( 报错 %@",identifier,error);
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
