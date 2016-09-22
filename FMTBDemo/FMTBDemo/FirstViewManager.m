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
    FMTableViewSection *section1 = [FMTableViewSection sectionWithHeaderTitle:@"section title "];

    FMIconWithTitleCellModel *item = [self generateItemWithImage:@"icon_usercenter_about" title:@"关于"];
    item.cellTag = FirstViewCellTag1;
    item.normalBackgroundColor = [UIColor greenColor];
    item.selectedBackgroundColor = [UIColor darkGrayColor];
    item.customArrowImage = [UIImage imageNamed:@"arrowright_icon"];
    [section1 addItem:item];
    
    item = [self generateItemWithImage:@"icon_usercenter_account" title:@"账户"];
    item.cellTag = FirstViewCellTag2;
    item.normalBackgroundColor = [UIColor yellowColor];
    item.selectedBackgroundColor = [UIColor orangeColor];
    item.customArrowImage = [UIImage imageNamed:@"cms_entry"];
    [section1 addItem:item];
    
    item = [self generateItemWithImage:@"icon_usercenter_favorite" title:@"收藏"];
    item.cellTag = FirstViewCellTag3;
    item.normalBackgroundImage = [UIImage imageNamed:@"bg_cell"];
    item.selectedBackgroundImage = [UIImage imageNamed:@"bg_cell"];
    item.customArrowImage = [UIImage imageNamed:@"selectred_icon"];
    [section1 addItem:item];
    
    item = [self generateItemWithImage:@"icon_usercenter_feedback" title:@"反馈"];
    item.cellTag = FirstViewCellTag4;
    [section1 addItem:item];
    
    item = [self generateItemWithImage:@"icon_usercenter_help" title:@"帮助"];
    item.cellTag = FirstViewCellTag5;
    [section1 addItem:item];
    
    item = [self generateItemWithImage:@"icon_usercenter_service" title:@"服务"];
    item.cellTag = FirstViewCellTag6;
    [section1 addItem:item];
    
    FMSpaceCellModel *spaceItem = [[FMSpaceCellModel alloc] initWithDefault];
    spaceItem.cellHeight = 20;
    spaceItem.hiddenSeparateLine = YES;

    [section1 addItem:spaceItem];
    
    [self.sections addObjectsFromArray:@[section1,section1,section1]];
}

- (FMIconWithTitleCellModel *)generateItemWithImage:(NSString *)imageName title:(NSString *)title{
    FMIconWithTitleCellModel *iconWithTitleItem = [[FMIconWithTitleCellModel alloc] initWithDefault];
    iconWithTitleItem.icon = [UIImage imageNamed:imageName];
    iconWithTitleItem.title = title;
    return iconWithTitleItem;
}


@end
