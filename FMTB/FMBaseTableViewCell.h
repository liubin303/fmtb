//
//  FMBaseTableViewCell.h
//  FMTB
//
//  Created by 刘彬 on 16/9/20.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FMCellModelBasicProtocol;
@class FMTableViewAdaptor;
@class FMTableViewSection;
@class FMBaseCellModel;

@interface FMBaseTableViewCell : UITableViewCell

// 所属tableView
@property (nonatomic, weak) UITableView *parentTableView;
// 所属adaptor
@property (nonatomic, weak) FMTableViewAdaptor *parentAdaptor;
// 所属section
@property (nonatomic, weak) FMTableViewSection *parentsection;
// 位置
@property (nonatomic, strong) NSIndexPath *indexPath;
// cellModel
@property (nonatomic, strong) id<FMCellModelBasicProtocol> object;
// 是否已载入
@property (nonatomic, assign, readonly) BOOL loaded;


///-----------------------------
/// @ life cycle
///-----------------------------
- (void)cellDidLoad __attribute__((objc_requires_super));
- (void)cellWillAppear __attribute__((objc_requires_super));
- (void)cellDidDisappear __attribute__((objc_requires_super));
- (void)setObject:(id<FMCellModelBasicProtocol>)object __attribute__((objc_requires_super));
+ (CGFloat)tableView:(UITableView*)tableView heightForRowWithCellModel:(FMBaseCellModel*)item;
;
@end
