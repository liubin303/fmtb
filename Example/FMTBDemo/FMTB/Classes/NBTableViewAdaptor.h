//
//  NBTableViewAdaptor.h
//  NBTableView
//
//  Created by 刘彬 on 16/3/10.
//  Copyright © 2016年 NewBee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NBTableViewItem.h"
#import "NBTableViewSection.h"

@protocol NBTableViewAdaptorDelegate <UITableViewDelegate>

@optional
///-----------------------------
/// @brief Select Item Method
///-----------------------------
- (void)tableView:(UITableView *)tableView didSelectItem:(NBTableViewItem*)item rowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectItem:(NBTableViewItem*)item cell:(UITableViewCell *)cell;

///-----------------------------
/// @brief Edit Item Method
///-----------------------------
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forItem:(NBTableViewItem*)item atIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView *)tableView canEditItem:(NBTableViewItem*)item atIndexPath:(NSIndexPath *)indexPath;

///-----------------------------
/// @brief Display Item Method
///-----------------------------
- (void)tableView:(UITableView *)tableView willLayoutCellSubviews:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView willLoadCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didLoadCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

///-----------------------------
/// @brief Load Data Method
///-----------------------------
- (BOOL)tableViewDataIsLoading:(UITableView *)tableView;
- (void)tableViewTriggerRefresh:(UITableView *)tableView;
- (void)tableViewLoadMoreData:(UITableView *)tableView;

@end


/**
 *  tableView适配器
 */
@interface NBTableViewAdaptor : NSObject<UITableViewDataSource,UITableViewDelegate>

// tableview
@property (nonatomic, strong          ) UITableView                *tableView;
// 下拉刷新控制
@property (nonatomic, assign          ) BOOL                       dragRefreshEnable;
// 上拉刷新控制
@property (nonatomic, assign          ) BOOL                       loadMoreEnable;
// 处理tableview的代理
@property (nonatomic, weak            ) id<NBTableViewAdaptorDelegate> delegate;
// cell显示所需数据集合
@property (nonatomic, strong, readonly) NSArray<NBTableViewSection *>  *sections;

///-----------------------------
/// @name Initializes Methoh
///-----------------------------
+ (instancetype)adaptorWithTableView:(UITableView *)tableView;
- (id)initWithTableView:(UITableView *)tableView;

// 重置section
- (void)resetSections:(NSArray<NBTableViewSection*> *)sections;

///-----------------------------
/// @name Adding sections
///-----------------------------
- (void)addSection:(NBTableViewSection *)section;

- (void)addSectionsFromArray:(NSArray<NBTableViewSection*> *)array;

- (void)insertSection:(NBTableViewSection *)section atIndex:(NSUInteger)index;

- (void)insertSections:(NSArray<NBTableViewSection*> *)sections atIndexes:(NSIndexSet *)indexes;

///-----------------------------
/// @name Removing Sections
///-----------------------------

- (void)removeSection:(NBTableViewSection *)section;

- (void)removeAllSections;

- (void)removeSectionIdenticalTo:(NBTableViewSection *)section inRange:(NSRange)range;

- (void)removeSectionIdenticalTo:(NBTableViewSection *)section;

- (void)removeSectionsInArray:(NSArray<NBTableViewSection*> *)otherArray;

- (void)removeSectionsInRange:(NSRange)range;

- (void)removeSection:(NBTableViewSection *)section inRange:(NSRange)range;

- (void)removeLastSection;

- (void)removeSectionAtIndex:(NSUInteger)index;

- (void)removeSectionsAtIndexes:(NSIndexSet *)indexes;

///-----------------------------
/// @name Replacing Sections
///-----------------------------

- (void)replaceSectionAtIndex:(NSUInteger)index withSection:(NBTableViewSection *)section;

- (void)replaceSectionsWithSectionsFromArray:(NSArray<NBTableViewSection*> *)otherArray;

- (void)replaceSectionsAtIndexes:(NSIndexSet *)indexes withSections:(NSArray<NBTableViewSection*> *)sections;

- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray<NBTableViewSection*> *)otherArray range:(NSRange)otherRange;

- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray<NBTableViewSection*> *)otherArray;

///-----------------------------
/// @name Rearranging Sections
///-----------------------------

- (void)exchangeSectionAtIndex:(NSUInteger)idx1 withSectionAtIndex:(NSUInteger)idx2;

- (void)sortSectionsUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context;

- (void)sortSectionsUsingSelector:(SEL)comparator;

- (void)finishLoadingData;

@end
