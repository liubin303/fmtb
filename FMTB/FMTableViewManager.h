//
//  FMTableViewManager.h
//  FMTB
//
//  Created by 刘彬 on 16/9/21.
//  Copyright © 2016年 刘彬. All rights reserved.
//


#import <Foundation/Foundation.h>

@class FMTableViewManager;
@class FMTableViewSection;

@protocol FMTableViewManagerDelegate <NSObject>

@required
- (void)tableViewManager:(FMTableViewManager *)manager didFinishLoadWithData:(id)dataModel error:(NSError *)error;

@end

/*!
 @class
 @abstract tableView数据管理器
 */
@interface FMTableViewManager : NSObject

@property (nonatomic, strong) NSMutableArray<FMTableViewSection *> *sections;
@property (nonatomic, weak) id<FMTableViewManagerDelegate> delegate;
@property (nonatomic, weak) id cellResponder;
@property (nonatomic, assign, readonly) BOOL isLoading;

/*!
 *  @brief  加载数据，子类重载
 */
- (void)loadData __attribute__((objc_requires_super));

/*!
 *  @brief  重新加载数据，子类重写
 */
- (void)reloadData;

/*!
 *  @brief  构建数据，子类重写
 */
- (void)constructData;

/*!
 *  @brief  数据构建完成通知ViewController
 *
 *  @param dataModel 数据模型
 *  @param error     错误信息
 */
- (void)didFinishLoadData:(id)dataModel error:(NSError *)error __attribute__((objc_requires_super));

@end



