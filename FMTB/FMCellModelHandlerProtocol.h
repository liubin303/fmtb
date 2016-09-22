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
 *  @brief 删除回调
 */
@property (nonatomic, copy) void (^deletionHandler)(id item);


@end

