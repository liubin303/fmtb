//
//  FMSpaceCell.m
//  FMTBExample
//
//  Created by 刘彬 on 16/9/20.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "FMSpaceCell.h"

@implementation FMSpaceCellModel

- (id)initWithDefault{
    if (self = [super initWithDefault]) {
        self.cellClass = [FMSpaceCell class];
        self.cellHeight = 10;
        self.normalBackgroundColor = [UIColor lightGrayColor];
        self.hiddenRightArrow = YES;
        self.hiddenSeparateLine = YES;
        self.userInteractionEnabled = NO;
    }
    return self;
}

@end

@implementation FMSpaceCell

- (void)cellDidLoad{
    [super cellDidLoad];
}

- (void)cellWillAppear{
    [super cellWillAppear];
}

@end
