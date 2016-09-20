//
//  FMTableViewController.h
//  FMTB
//
//  Created by 刘彬 on 16/9/20.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMTableViewAdaptor.h"
@interface FMTableViewController : UIViewController<FMTableViewAdaptorDelegate>

// tableView
@property (nonatomic, strong) UITableView *tableView;

// tableView数据适配器
@property (nonatomic, strong) FMTableViewAdaptor *tableViewAdaptor;

@end
