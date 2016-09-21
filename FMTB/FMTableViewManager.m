//
//  FMTableViewManager.m
//  FMTB
//
//  Created by 刘彬 on 16/9/21.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "FMTableViewManager.h"

@interface FMTableViewManager ()

@property (nonatomic, assign) BOOL isLoading;

@end

@implementation FMTableViewManager

#pragma mark - generate data
- (void)loadData {
    if (self.isLoading) {
        return;
    }
    self.isLoading = YES;
}

- (void)reloadData {

    // 子类实现
}

- (void)constructData {
    // 子类实现
}

- (void)didFinishLoadData:(id)dataModel error:(NSError *)error {
    self.isLoading = NO;
    [self constructData];
    if([self.delegate respondsToSelector:@selector(tableViewManager:didFinishLoadWithData:error:)]){
        [self.delegate tableViewManager:self didFinishLoadWithData:dataModel error:error];
    }
}

#pragma mark - setter/getter
- (NSMutableArray *)sections{
    if (_sections == nil) {
        _sections = [NSMutableArray array];
    }
    return _sections;
}

- (BOOL)isLoading {
    return _isLoading;
}


@end
