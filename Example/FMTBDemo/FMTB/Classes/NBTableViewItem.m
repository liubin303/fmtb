//
//  NBTableViewItem.m
//  NBTableView
//
//  Created by 刘彬 on 16/3/11.
//  Copyright © 2016年 NewBee. All rights reserved.
//

#import "NBTableViewItem.h"
#import "NBTableViewCell.h"
#import "NBTableViewAdaptor.h"

@implementation NBTableViewItem

#pragma mark Creating and Initializing Item
+ (instancetype)item{
    return [[self alloc] init];
}

- (id)init{
    self = [super init];
    if (self) {
        self.cellClass                = [NBTableViewCell class];
        self.cellIdentifier           = NSStringFromClass([self class]);
        self.cellHeight               = 0;
        self.userInteractionEnabled   = YES;
        self.selectionStyle           = UITableViewCellSelectionStyleNone;
        self.accessoryType            = UITableViewCellAccessoryNone;
        self.editingStyle             = UITableViewCellEditingStyleNone;
        self.hiddenSeparateLine       = NO;
        self.separateLineColor        = COLOR_TABLE_LINE;
        self.separateLineHeight       = 0.5;
        self.separateLineLeftPadding  = 0;
        self.separateLineRightPadding = 0;
        self.backgroundColor          = COLOR_SYSTEM_WHITE;
        self.selectedBackgroundColor  = COLOR_TABLE_CELL_SELECTED;
        self.titleFont                     = Big_Font;
        self.titleColor                    = COLOR_NORMAL_TEXT;
        self.textAlignment            = NSTextAlignmentLeft;
    }
    return self;
}

- (id)initWithDefault{
    self = [self init];
    if (self){
    }
    return self;
}

// 先取item自己的，没有设置的话然后取section设置统一样式
- (CGFloat)cellHeight{
    if (_cellHeight <= 0) {
        if (self.section.cellStyle != nil) {
            _cellHeight = self.section.cellStyle.cellHeight;
        }
    }
    return _cellHeight;
}
- (CGFloat)contentViewMargin{
    if (_contentViewMargin <= 0) {
        if (self.section.cellStyle != nil) {
            _contentViewMargin = self.section.cellStyle.contentViewMargin;
        }
    }
    return _contentViewMargin;
}
- (CGFloat)backgroundImageMargin{
    if (_backgroundImageMargin <= 0) {
        if (self.section.cellStyle != nil) {
            _backgroundImageMargin = self.section.cellStyle.backgroundImageMargin;
        }
    }
    return _backgroundImageMargin;
}

- (UIColor *)backgroundColor{
    if (_backgroundColor == COLOR_SYSTEM_WHITE) {
        if (self.section.cellStyle != nil && self.section.cellStyle.backgroundColor != nil) {
            _backgroundColor = self.section.cellStyle.backgroundColor;
        }
    }
    return _backgroundColor;
}
- (UIColor *)selectedBackgroundColor{
    if (_selectedBackgroundColor == COLOR_TABLE_CELL_SELECTED) {
        if (self.section.cellStyle != nil && self.section.cellStyle.backgroundColor != nil) {
            _selectedBackgroundColor = self.section.cellStyle.selectedBackgroundColor;
        }
    }
    return _selectedBackgroundColor;
}
- (UIImage *)backgroundImage{
    if (_backgroundImage == nil) {
        if ([self.section.cellStyle hasCustomBackgroundImage]) {
            _backgroundImage = [self.section.cellStyle backgroundImageForCellType:[self cellType]];
        }
    }
    return _backgroundImage;
}
- (UIImage *)selectedBackgroundImage{
    if (_selectedBackgroundImage == nil) {
        if ([self.section.cellStyle hasCustomSelectedBackgroundImage]) {
            _selectedBackgroundImage = [self.section.cellStyle selectedBackgroundImageForCellType:[self cellType]];
        }
    }
    return _selectedBackgroundImage;
}

- (NBTableViewCellType)cellType{
    if (self.indexPath.row == 0 && self.section.items.count == 1) {
        return NBTableViewCellTypeSingle;
    }
    
    if (self.indexPath.row == 0 && self.section.items.count > 1) {
        return NBTableViewCellTypeFirst;
    }
    
    if (self.indexPath.row > 0 && self.indexPath.row < self.section.items.count - 1 && self.section.items.count > 2) {
        return NBTableViewCellTypeMiddle;
    }
    
    if (self.indexPath.row == self.section.items.count - 1 && self.section.items.count > 1) {
        return NBTableViewCellTypeLast;
    }
    return NBTableViewCellTypeAny;
}

- (UIColor *)separateLineColor{
    if (_separateLineColor == COLOR_TABLE_LINE && self.section.cellStyle.separateLineColor) {
        _separateLineColor = self.section.cellStyle.separateLineColor;
    }
    return _separateLineColor;
}
- (CGFloat)separateLineHeight{
    if (_separateLineHeight == 0.5 && self.section.cellStyle.separateLineHeight > 0) {
        _separateLineHeight = self.section.cellStyle.separateLineHeight;
    }
    return _separateLineHeight;
}
- (CGFloat)separateLineLeftPadding{
    if (_separateLineLeftPadding == 0 && self.section.cellStyle.separateLineLeftPadding > 0) {
        _separateLineLeftPadding = self.section.cellStyle.separateLineLeftPadding;
    }
    return _separateLineLeftPadding;
}
- (CGFloat)separateLineRightPadding{
    if (_separateLineRightPadding == 0 && self.section.cellStyle.separateLineRightPadding > 0) {
        _separateLineRightPadding = self.section.cellStyle.separateLineRightPadding;
    }
    return _separateLineRightPadding;
}

#pragma mark Manipulating table view row
- (void)selectRowAnimated:(BOOL)animated{
    [self selectRowAnimated:animated scrollPosition:UITableViewScrollPositionNone];
}

- (void)selectRowAnimated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition{
    [self.section.tableViewAdaptor.tableView selectRowAtIndexPath:self.indexPath animated:animated scrollPosition:scrollPosition];
}

- (void)deselectRowAnimated:(BOOL)animated{
    [self.section.tableViewAdaptor.tableView deselectRowAtIndexPath:self.indexPath animated:animated];
}

- (void)reloadRowWithAnimation:(UITableViewRowAnimation)animation{
    [self.section.tableViewAdaptor.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:animation];
}

- (void)deleteRowWithAnimation:(UITableViewRowAnimation)animation{
    NBTableViewSection *section = self.section;
    NSInteger row = self.indexPath.row;
    [section removeItemAtIndex:self.indexPath.row];
    [section.tableViewAdaptor.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section.indexAtTableView]] withRowAnimation:animation];
}

#pragma mark - getter
- (NSIndexPath *)indexPath{
    return [NSIndexPath indexPathForRow:[self.section.items indexOfObject:self] inSection:self.section.indexAtTableView];
}

@end
