//
//  FMBaseCellModel.h
//  FMTB
//
//  Created by 刘彬 on 16/9/20.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMCellModelBasicProtocol.h"

@interface FMBaseCellModel : NSObject<FMCellModelBasicProtocol>

///-----------------------------
/// @ Initializes Methoh
///-----------------------------
- (id)initWithDefault __attribute__((objc_requires_super));

///-----------------------------
/// @ Operation Cell
///-----------------------------
- (void)selectRowAnimated:(BOOL)animated;
- (void)selectRowAnimated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
- (void)deselectRowAnimated:(BOOL)animated;
- (void)reloadRowWithAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRowWithAnimation:(UITableViewRowAnimation)animation;

@end
