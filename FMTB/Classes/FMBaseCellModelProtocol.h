//
//  FMBaseCellModelProtocol.h
//  Pods
//
//  Created by gwc on 16/9/18.
//  Copyright © 2016年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMCellModelDisplayProtocol.h"
#import "FMCellModelRenderProtocol.h"
#import "FMCellModelHandlerProtocol.h"

/*!
 *  @brief cell相关属性
 */
@protocol NBTableViewCellModelProtocol <NSObject,FMCellModelDisplayProtocol,FMCellModelRenderProtocol,FMCellModelHandlerProtocol>



@end
