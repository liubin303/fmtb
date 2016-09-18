//
//  FMBaseCellModelProtocol.h
//  Pods
//
//  Created by gwc on 16/9/18.
//  Copyright © 2016年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMCellModelRenderProtocol.h"
#import "FMCellModelHandlerProtocol.h"
#import "FMTableViewSection.h"

/*!
 *  @brief cell属性
 */
@protocol FMCellModelBasicProtocol <NSObject,FMCellModelRenderProtocol,FMCellModelHandlerProtocol>

/*!
 *  @brief cell的类
 */
@property (nonatomic, strong) Class cellClass;

/*!
 *  @brief 类型标识，一般是枚举类型
 */
@property (nonatomic, assign) NSInteger cellTag;

/*!
 *  @brief 复用字符串标识
 */
@property (nonatomic, copy) NSString *cellIdentifier;

/*!
 *  @brief 是否允许交互
 */
@property (nonatomic, assign) BOOL userInteractionEnabled;

/*!
 *  @brief 是否使用xib
 */
@property (nonatomic, assign) BOOL useNib;

/*!
 *  @brief cell的交互响应对象
 */
@property (nonatomic, assign) id cellResponder;

/*!
 *  @brief cell所属的section
 */
@property (nonatomic, weak) FMTableViewSection *parentSection;

/*!
 *  @brief cell所在的位置
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
