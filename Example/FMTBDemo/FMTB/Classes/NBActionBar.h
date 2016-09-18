//
//  NBActionBar.h
//  NBTableView
//
//  Created by 刘彬 on 16/3/26.
//  Copyright © 2016年 NewBee. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NBActionBarDelegate;

/*!
 *  @brief 响应类控件的actionbar
 */
@interface NBActionBar : UIToolbar

@property (nonatomic, strong, readonly) UISegmentedControl *navigationControl;
@property (nonatomic, weak) id<NBActionBarDelegate> actionBarDelegate;

- (id)initWithDelegate:(id)delegate;

@end

@protocol NBActionBarDelegate <NSObject>

- (void)actionBar:(NBActionBar *)actionBar navigationControlValueChanged:(UISegmentedControl *)navigationControl;
- (void)actionBar:(NBActionBar *)actionBar doneButtonPressed:(UIBarButtonItem *)doneButtonItem;

@end
