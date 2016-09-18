//
//  FMBaseCellModel.h
//  Pods
//
//  Created by gwc on 16/9/18.
//
//

#import <Foundation/Foundation.h>
#import "FMCellModelBasicProtocol.h"

@interface FMBaseCellModel : NSObject<FMCellModelBasicProtocol>


//
//


//
//// 是否需要立即删除cell
//@property (nonatomic, assign          ) BOOL shouldDeleteRightNow;




//@property (nonatomic, strong          ) UIColor                       *contentViewBackgroundColor;
//

`


///-----------------------------
/// @name Initializes Methoh
///-----------------------------
//+ (instancetype)item;
//- (id)initWithDefault;

///-----------------------------
/// @name Operation Cell
///-----------------------------
//- (void)selectRowAnimated:(BOOL)animated;
//- (void)selectRowAnimated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
//- (void)deselectRowAnimated:(BOOL)animated;
//- (void)reloadRowWithAnimation:(UITableViewRowAnimation)animation;
//- (void)deleteRowWithAnimation:(UITableViewRowAnimation)animation;

@end
