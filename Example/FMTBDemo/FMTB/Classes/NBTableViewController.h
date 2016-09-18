//
//  NBTableViewController.h
//  NBTableView
//
//  Created by 刘彬 on 16/3/10.
//  Copyright © 2016年 NewBee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBTableViewAdaptor.h"

/*!
 *  @brief 包含tableview的viewController基类
 */
@interface NBTableViewController : UIViewController<NBTableViewAdaptorDelegate>

// tableView
@property (nonatomic, strong) UITableView *tableView;

// tableView数据适配器
@property (nonatomic, strong) NBTableViewAdaptor *tableViewAdaptor;

@end
