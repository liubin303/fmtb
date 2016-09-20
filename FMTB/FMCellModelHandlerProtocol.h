//
//  FMCellModelHandlerProtocol.h
//  FMTB
//
//  Created by 刘彬 on 16/9/20.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @brief cell响应交互的block
 */
@protocol FMCellModelHandlerProtocol <NSObject>

/*!
 *  @brief 点击回调
 */
@property (nonatomic, copy) void (^selectionHandler)(id item);

/*!
 *  @brief 点击指示器按钮回调
 */
@property (nonatomic, copy) void (^accessoryButtonTapHandler)(id item);

/*!
 *  @brief 插入回调
 */
@property (nonatomic, copy) void (^insertionHandler)(id item);
@property (nonatomic, copy) void (^deletionHandler)(id item);
@property (nonatomic, copy) void (^deletionHandlerWithCompletion)(id item, void (^)(void));
@property (nonatomic, copy) BOOL (^moveHandler)(id item, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);
@property (nonatomic, copy) void (^moveCompletionHandler)(id item, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);

@property (nonatomic, copy) void (^cutHandler)(id item);
@property (nonatomic, copy) void (^copyHandler)(id item);
@property (nonatomic, copy) void (^pasteHandler)(id item);

/*!
 *  @brief <#Description#>
 */
@property (nonatomic, copy) void (^actionBarNavButtonTapHandler)(id item);

/*!
 *  @brief <#Description#>
 */
@property (nonatomic, copy) void (^actionBarDoneButtonTapHandler)(id item);

@end

