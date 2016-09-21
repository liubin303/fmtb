//
//  FirstViewManager.m
//  FMTBExample
//
//  Created by 刘彬 on 16/9/21.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "FirstViewManager.h"
#import "FMSpaceCell.h"
#import "FMIconWithTitleCell.h"

@implementation FirstViewManager

- (void)loadData{
    [super loadData];
    [self didFinishLoadData:nil error:nil];
}

- (void)reloadData{
    [self loadData];
}

- (void)constructData{
    [self.sections removeAllObjects];
    FMTableViewSection *section1 = [FMTableViewSection sectionWithHeaderTitle:@"first section"];
    
    FMSpaceCellModel *spaceItem = [[FMSpaceCellModel alloc] initWithDefault];
    spaceItem.cellHeight = 20;
    spaceItem.normalBackgroundColor = [UIColor redColor];
    spaceItem.hiddenSeparateLine = YES;
    [section1 addItem:spaceItem];
    
    FMIconWithTitleCellModel *item = [self generateItemWithImage:@"icon_usercenter_about" title:@"关于"];
    item.cellTag = FirstViewCellTag1;
    [section1 addItem:item];
    
    item = [self generateItemWithImage:@"icon_usercenter_account" title:@"账户"];
    item.cellTag = FirstViewCellTag2;
    [section1 addItem:item];
    
//    item = [self generateItemWithImage:@"icon_usercenter_favorite" title:@"收藏"];
//    item.cellTag = FirstViewCellTag3;
//    [section1 addItem:item];
//    
//    item = [self generateItemWithImage:@"icon_usercenter_feedback" title:@"反馈"];
//    item.cellTag = FirstViewCellTag4;
//    [section1 addItem:item];
//    
//    item = [self generateItemWithImage:@"icon_usercenter_help" title:@"帮助"];
//    item.cellTag = FirstViewCellTag5;
//    [section1 addItem:item];
//    
//    item = [self generateItemWithImage:@"icon_usercenter_sevice" title:@"服务"];
//    item.cellTag = FirstViewCellTag6;
//    [section1 addItem:item];
//    [section1 addItem:spaceItem];
    
    FMTableViewSection *section2 = [FMTableViewSection sectionWithHeaderTitle:@"second section"];
    
    item = [self generateItemWithImage:@"icon_usercenter_about" title:@"关于"];
    item.cellTag = FirstViewCellTag1;
    [section2 addItem:item];
    [section2 addItem:spaceItem];
    
//    item = [self generateItemWithImage:@"icon_usercenter_account" title:@"账户"];
//    item.cellTag = FirstViewCellTag2;
//    [section2 addItem:item];
//    [section2 addItem:spaceItem];
//    
//    item = [self generateItemWithImage:@"icon_usercenter_favorite" title:@"收藏"];
//    item.cellTag = FirstViewCellTag3;
//    [section2 addItem:item];
//    [section2 addItem:spaceItem];
//    
//    item = [self generateItemWithImage:@"icon_usercenter_feedback" title:@"反馈"];
//    item.cellTag = FirstViewCellTag4;
//    [section2 addItem:item];
//    [section2 addItem:spaceItem];
//    
//    item = [self generateItemWithImage:@"icon_usercenter_help" title:@"帮助"];
//    item.cellTag = FirstViewCellTag5;
//    [section2 addItem:item];
//    [section2 addItem:spaceItem];
//    
//    item = [self generateItemWithImage:@"icon_usercenter_sevice" title:@"服务"];
//    item.cellTag = FirstViewCellTag6;
//    [section2 addItem:item];
    
    [self.sections addObjectsFromArray:@[section1,section2]];
}

- (FMIconWithTitleCellModel *)generateItemWithImage:(NSString *)imageName title:(NSString *)title{
    FMIconWithTitleCellModel *iconWithTitleItem = [[FMIconWithTitleCellModel alloc] initWithDefault];
    iconWithTitleItem.icon = [UIImage imageNamed:imageName];
    iconWithTitleItem.title = title;
    return iconWithTitleItem;
}


@end
