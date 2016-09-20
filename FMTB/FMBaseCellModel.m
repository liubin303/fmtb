//
//  FMBaseCellModel.m
//  FMTB
//
//  Created by 刘彬 on 16/9/20.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "FMBaseCellModel.h"
#import "FMBaseTableViewCell.h"
#import "FMTableViewSection.h"
#import "FMTableViewAdaptor.h"

@implementation FMBaseCellModel

@synthesize cellClass = _cellClass;
@synthesize cellIdentifier = _cellIdentifier;
@synthesize cellTag = _cellTag;
@synthesize userInteractionEnabled = _userInteractionEnabled;
@synthesize useNib = _useNib;
@synthesize cellResponder = _cellResponder;
@synthesize parentSection = _parentSection;
@synthesize indexPath = _indexPath;

@synthesize cellHeight = _cellHeight;
@synthesize contentViewMargin = _contentViewMargin;
@synthesize backgroundImageMargin = _backgroundImageMargin;
@synthesize accessoryType = _accessoryType;
@synthesize accessoryView = _accessoryView;
@synthesize selectionStyle = _selectionStyle;
@synthesize editingStyle = _editingStyle;
@synthesize deleteButtonTitle = _deleteButtonTitle;
@synthesize hiddenSeparateLine = _hiddenSeparateLine;
@synthesize separateLineColor = _separateLineColor;
@synthesize separateLineHeight = _separateLineHeight;
@synthesize separateLineLeftPadding = _separateLineLeftPadding;
@synthesize separateLineRightPadding = _separateLineRightPadding;
@synthesize normalBackgroundColor = _normalBackgroundColor;
@synthesize selectedBackgroundColor = _selectedBackgroundColor;
@synthesize normalBackgroundImage = _normalBackgroundImage;
@synthesize selectedBackgroundImage = _selectedBackgroundImage;

@synthesize selectionHandler = _selectionHandler;
@synthesize accessoryButtonTapHandler = _accessoryButtonTapHandler;
@synthesize deletionHandler = _deletionHandler;
@synthesize moveHandler = _moveHandler;
@synthesize moveCompletionHandler = _moveCompletionHandler;

#pragma mark - Initializing Item
- (id)init{
    self = [super init];
    if (self) {
        self.cellClass                = [self class];
        self.cellIdentifier           = NSStringFromClass([self class]);
        self.cellHeight               = 0;
        self.userInteractionEnabled   = YES;
        self.selectionStyle           = UITableViewCellSelectionStyleNone;
        self.accessoryType            = UITableViewCellAccessoryDisclosureIndicator;
        self.accessoryView            = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cell_arrow_gray"]];
        self.editingStyle             = UITableViewCellEditingStyleNone;
        self.hiddenSeparateLine       = NO;
        self.separateLineColor        = [UIColor blackColor];
        self.separateLineHeight       = 1;
        self.separateLineLeftPadding  = 0;
        self.separateLineRightPadding = 0;
        self.normalBackgroundColor    = [UIColor whiteColor];
        self.selectedBackgroundColor  = [UIColor lightGrayColor];
    }
    return self;
}

- (id)initWithDefault{
    self = [self init];
    if (self){
        // 子类实现
    }
    return self;
}

- (void)selectRowAnimated:(BOOL)animated{
    [self selectRowAnimated:animated scrollPosition:UITableViewScrollPositionNone];
}

- (void)selectRowAnimated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition{
    [self.parentSection.tableViewAdaptor.tableView selectRowAtIndexPath:self.indexPath animated:animated scrollPosition:scrollPosition];
}

- (void)deselectRowAnimated:(BOOL)animated{
    [self.parentSection.tableViewAdaptor.tableView deselectRowAtIndexPath:self.indexPath animated:animated];
}

- (void)reloadRowWithAnimation:(UITableViewRowAnimation)animation{
    [self.parentSection.tableViewAdaptor.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:animation];
}

- (void)deleteRowWithAnimation:(UITableViewRowAnimation)animation{
    FMTableViewSection *section = self.parentSection;
    NSInteger row = self.indexPath.row;
    [section removeItemAtIndex:self.indexPath.row];
    [section.tableViewAdaptor.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section.indexAtTableView]] withRowAnimation:animation];
}

#pragma mark - getter
- (NSIndexPath *)indexPath{
    return [NSIndexPath indexPathForRow:[self.parentSection.items indexOfObject:self] inSection:self.parentSection.indexAtTableView];
}


@end
