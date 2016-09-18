//
//  NBActionBar.m
//  NBTableView
//
//  Created by 刘彬 on 16/3/26.
//  Copyright © 2016年 NewBee. All rights reserved.
//

#import "NBActionBar.h"

@interface NBActionBar ()

@property (nonatomic, strong, readwrite) UISegmentedControl *navigationControl;

@end

@implementation NBActionBar

- (id)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        [self sizeToFit];
    }

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleActionBarDone:)];
    
    self.navigationControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"Previous", @""), NSLocalizedString(@"Next", @""), nil]];
    self.navigationControl.momentary = YES;
    [self.navigationControl addTarget:self action:@selector(handleActionBarPreviousNext:) forControlEvents:UIControlEventValueChanged];
    
    [self.navigationControl setImage:[UIImage imageNamed:@"UIButtonBarArrowLeft"] forSegmentAtIndex:0];
    [self.navigationControl setImage:[UIImage imageNamed:@"UIButtonBarArrowRight"] forSegmentAtIndex:1];
    
    [self.navigationControl setDividerImage:[[UIImage alloc] init]
                        forLeftSegmentState:UIControlStateNormal
                          rightSegmentState:UIControlStateNormal
                                 barMetrics:UIBarMetricsDefault];
    
    [self.navigationControl setBackgroundImage:[UIImage imageNamed:@"Transparent"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationControl setWidth:40.0f forSegmentAtIndex:0];
    [self.navigationControl setWidth:40.0f forSegmentAtIndex:1];
    [self.navigationControl setContentOffset:CGSizeMake(-4, 0) forSegmentAtIndex:0];
    
    UIBarButtonItem *prevNextWrapper = [[UIBarButtonItem alloc] initWithCustomView:self.navigationControl];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self setItems:[NSArray arrayWithObjects:prevNextWrapper, flexible, doneButton, nil]];
    self.actionBarDelegate = delegate;
    
    return self;
}

/*!
 *  @brief 响应上一项或者下一项点击
 */
- (void)handleActionBarPreviousNext:(UISegmentedControl *)segmentedControl
{
    if ([self.actionBarDelegate respondsToSelector:@selector(actionBar:navigationControlValueChanged:)])
        [self.actionBarDelegate actionBar:self navigationControlValueChanged:segmentedControl];
}

/*!
 *  @brief 响应完成点击
 */
- (void)handleActionBarDone:(UIBarButtonItem *)doneButtonItem
{
    if ([self.actionBarDelegate respondsToSelector:@selector(actionBar:doneButtonPressed:)])
        [self.actionBarDelegate actionBar:self doneButtonPressed:doneButtonItem];
}

@end
