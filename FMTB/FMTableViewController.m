//
//  FMTableViewController.m
//  FMTB
//
//  Created by 刘彬 on 16/9/20.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "FMTableViewController.h"

@interface FMTableViewController ()

@end

@implementation FMTableViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if (self.automaticallyAdjustsScrollViewInsets && self.navigationController.navigationBar.translucent) {
        if ([self.navigationController isNavigationBarHidden]) {
            self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        } else {
            self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        }
    }
}

- (void)dealloc{
    _tableView.dataSource = nil;
    _tableView.delegate   = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark getter
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView                  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _tableView.backgroundColor  = [UIColor whiteColor];
        _tableView.backgroundView   = nil;
        _tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
        _tableView.exclusiveTouch   = YES;// 排除多点触控时出现未知异常响应
    }
    return _tableView;
}

- (FMTableViewAdaptor *)tableViewAdaptor{
    if (_tableViewAdaptor == nil) {
        _tableViewAdaptor = [[FMTableViewAdaptor alloc] initWithTableView:self.tableView];
        _tableViewAdaptor.delegate = self;
    }
    return _tableViewAdaptor;
}
@end
