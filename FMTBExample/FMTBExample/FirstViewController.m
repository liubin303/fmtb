//
//  FirstViewController.m
//  FMTBExample
//
//  Created by 刘彬 on 16/9/20.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "FirstViewController.h"
#import "FMSpaceCell.h"
#import "FMIconWithTitleCell.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor grayColor];
    self.tableViewAdaptor.dragRefreshEnable = YES;
    [self buildTableView];
}

- (void)buildTableView{
    [self.tableViewAdaptor removeAllSections];
    
    FMTableViewSection *section = [FMTableViewSection section];
    
    FMSpaceCellModel *spaceItem = [[FMSpaceCellModel alloc] initWithDefault];
    spaceItem.cellHeight = 20;
    spaceItem.normalBackgroundColor = [UIColor redColor];
    spaceItem.hiddenSeparateLine = YES;
    [section addItem:spaceItem];
    
    FMIconWithTitleCellModel *item = [self generateItemWithImage:@"icon_usercenter_about" title:@"关于"];
    [section addItem:item];
    item = [self generateItemWithImage:@"icon_usercenter_account" title:@"账户"];
    [section addItem:item];
    item = [self generateItemWithImage:@"icon_usercenter_favorite" title:@"收藏"];
    [section addItem:item];
    item = [self generateItemWithImage:@"icon_usercenter_feedback" title:@"反馈"];
    [section addItem:item];
    item = [self generateItemWithImage:@"icon_usercenter_help" title:@"帮助"];
    [section addItem:item];
    item = [self generateItemWithImage:@"icon_usercenter_sevice" title:@"服务"];
    [section addItem:item];
    [section addItem:spaceItem];
    
    [self.tableViewAdaptor resetSections:@[section]];
    [self.tableView reloadData];
}

- (FMIconWithTitleCellModel *)generateItemWithImage:(NSString *)imageName title:(NSString *)title{
    FMIconWithTitleCellModel *iconWithTitleItem = [[FMIconWithTitleCellModel alloc] initWithDefault];
    iconWithTitleItem.icon = imageName;
    iconWithTitleItem.title = title;
    return iconWithTitleItem;
}


@end
