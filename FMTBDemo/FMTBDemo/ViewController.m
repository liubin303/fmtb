//
//  ViewController.m
//  FMTBDemo
//
//  Created by 刘彬 on 16/9/21.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "ViewController.h"
#import "FMSpaceCell.h"
#import "FMIconWithTitleCell.h"
#import "FirstViewManager.h"

@interface ViewController ()<FMTableViewAdaptorDelegate,FMTableViewManagerDelegate>

@property (nonatomic, strong) FirstViewManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableViewAdaptor.dragRefreshEnable = YES;
    // 可以定制tableview的样式
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.manager loadData];
}

#pragma mark - FMTableViewManagerDelegate
- (void)tableViewManager:(FMTableViewManager *)manager didFinishLoadWithData:(id)dataModel error:(NSError *)error{
    [self.tableViewAdaptor finishLoadingData];
    if (error) {
        NSLog(@"出错了");
    } else{
        [self.tableViewAdaptor resetSections:self.manager.sections];
        [self.tableView reloadData];
    }
}

#pragma mark - FMTableViewAdaptorDelegate
- (BOOL)tableViewDataIsLoading:(UITableView *)tableView{
    return self.manager.isLoading;
}

- (void)tableViewLoadMoreData:(UITableView *)tableView{
    NSLog(@"开始加载更多");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.manager loadData];
    });
}

- (void)tableViewTriggerRefresh:(UITableView *)tableView{
    NSLog(@"开始刷新");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.manager reloadData];
    });
}

- (void)tableView:(UITableView *)tableView didSelectItem:(FMBaseCellModel *)item cell:(UITableViewCell *)cell{
    switch (item.cellTag) {
        case FirstViewCellTag1:{
            NSLog(@"select 1");
            break;
        }
        case FirstViewCellTag2:{
            NSLog(@"select 2");
            break;
        }
        case FirstViewCellTag3:{
            NSLog(@"select 3");
            break;
        }
        case FirstViewCellTag4:{
            NSLog(@"select 4");
            break;
        }
        case FirstViewCellTag5:{
            NSLog(@"select 5");
            break;
        }
        case FirstViewCellTag6:{
            NSLog(@"select 6");
            break;
        }
            
        default:
            break;
    }
}

- (FirstViewManager *)manager{
    if (_manager == nil) {
        _manager = [[FirstViewManager alloc] init];
        _manager.delegate = self;
        _manager.cellResponder = self;
    }
    return _manager;
}

@end
