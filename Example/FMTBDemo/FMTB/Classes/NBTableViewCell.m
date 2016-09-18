//
//  NBTableViewCell.m
//  NBTableView
//
//  Created by 刘彬 on 16/3/10.
//  Copyright © 2016年 NewBee. All rights reserved.
//

#import "NBTableViewCell.h"
#import "NBTableViewItem.h"
#import "NBActionBar.h"

@interface NBTableViewCell ()<NBActionBarDelegate>

// cell的actionbar
@property (nonatomic, strong) NBActionBar *actionBar;

@property (nonatomic, assign) BOOL loaded; // 是否已经初始化

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSAttributedString *titleAttrbuteString;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *detailText;


@property (nonatomic, strong) UIFont          *font;
@property (nonatomic, strong) UIColor         *color;
@property (nonatomic, assign) NSTextAlignment textAlignment;

@property (nonatomic, strong) UIView *separateLine;
@property (nonatomic, assign) BOOL hideSeparateLine;
@property (nonatomic, strong) UIColor *separateLineColor;
@property (nonatomic, assign) CGFloat separateLineHeight;
@property (nonatomic, assign) CGFloat separateLineLeftPadding;
@property (nonatomic, assign) CGFloat separateLineRightPadding;

@property (nonatomic, assign) CGFloat contentViewMargin;
@property (nonatomic, assign) CGFloat backgroundImageMargin;

@property (nonatomic, strong) UIView *normalBackgroundView;
@property (nonatomic, strong) UIImage *normalBackgroundImage;
@property (nonatomic, strong) UIImageView *normalBackgroundImageView;
@property (nonatomic, strong) UIColor *normalBackgroundColor;

@property (nonatomic, strong) UIView *highlightedBackgroundView;
@property (nonatomic, strong) UIImage *highlightedBackgroundImage;
@property (nonatomic, strong) UIImageView *highlightedBackgroundImageView;
@property (nonatomic, strong) UIColor *highlightedBackgroundColor;

@end

@implementation NBTableViewCell

@synthesize item                       = _item;
@synthesize separateLineColor          = _separateLineColor;
@synthesize separateLineHeight         = _separateLineHeight;
@synthesize separateLineLeftPadding    = _separateLineLeftPadding;
@synthesize separateLineRightPadding   = _separateLineRightPadding;
@synthesize hideSeparateLine           = _hideSeparateLine;
@synthesize normalBackgroundView       = _normalBackgroundView;
@synthesize normalBackgroundColor      = _normalBackgroundColor;
@synthesize highlightedBackgroundView  = _highlightedBackgroundView;
@synthesize highlightedBackgroundColor = _highlightedBackgroundColor;

- (void)awakeFromNib{
    [super awakeFromNib];
    // Fix the bug in iOS7 - initial constraints warning
    self.contentView.bounds = [UIScreen mainScreen].bounds;
}

#pragma mark - life cycle

- (void)cellDidLoad{
    // 子类继承实现，控件初始化写在这里
    if (!self.loaded) {
        self.loaded = YES;
        // 添加分隔线
        [self addSubview:self.separateLine];
        self.backgroundView         = self.normalBackgroundView;
        self.selectedBackgroundView = self.highlightedBackgroundView;
    }
}

- (void)cellWillAppear{
    [self updateActionBarNavigationControl];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.numberOfLines   = 0; // 不限制行数
    self.textLabel.textAlignment   = self.textAlignment;
    if (self.title.length > 0) {
        self.textLabel.text            = self.title;
        self.textLabel.font            = self.font;
        self.textLabel.textColor       = self.color;
    }
    if (self.titleAttrbuteString) {
        self.textLabel.attributedText = self.titleAttrbuteString;
        
    }
    if (self.detailText.length > 0) {
        self.detailTextLabel.text = self.detailText;
    }
    if (self.image) {
        self.imageView.image = self.image;
    }
    self.normalBackgroundView.backgroundColor = self.normalBackgroundColor;
    self.highlightedBackgroundView.backgroundColor = self.highlightedBackgroundColor;
    if (self.normalBackgroundImage) {
        self.normalBackgroundImageView.backgroundColor = [UIColor clearColor];
        [self addBackgroundImage];
    }
    if (self.highlightedBackgroundImage) {
        self.highlightedBackgroundView.backgroundColor = [UIColor clearColor];
        [self addSelectedBackgroundImage];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect contentFrame = self.contentView.frame;
    contentFrame.origin.x = contentFrame.origin.x + self.contentViewMargin;
    contentFrame.size.width = contentFrame.size.width - self.contentViewMargin * 2;
    self.contentView.frame = contentFrame;
    
    self.separateLine.frame = CGRectMake(self.separateLineLeftPadding, self.nb_height-self.separateLineHeight, self.nb_width -self.separateLineLeftPadding - self.separateLineRightPadding, self.separateLineHeight);
    
    if (self.contentViewMargin > 0) {
        if (self.image) {
            self.imageView.frame = CGRectMake(self.contentViewMargin, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height);
            self.textLabel.frame = CGRectMake(self.contentViewMargin + self.imageView.frame.size.width + kNormalPadding, self.textLabel.frame.origin.y, self.textLabel.frame.size.width-self.contentViewMargin, self.textLabel.frame.size.height);
        } else {
            self.textLabel.frame = CGRectMake(self.contentViewMargin, self.textLabel.frame.origin.y, contentFrame.size.width-2*self.contentViewMargin, self.textLabel.frame.size.height);
        }
    } else {
        if (self.image) {
            self.imageView.frame = CGRectMake(kNormalPadding, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height);
            self.textLabel.frame = CGRectMake(kNormalPadding + self.imageView.frame.size.width + kNormalPadding, self.textLabel.frame.origin.y, self.textLabel.frame.size.width-kNormalPadding, self.textLabel.frame.size.height);
        } else {
            self.textLabel.frame = CGRectMake(kNormalPadding, self.textLabel.frame.origin.y, contentFrame.size.width-2*kNormalPadding, self.textLabel.frame.size.height);
        }
    }
    
    CGRect backgroundFrame = self.normalBackgroundImageView.frame;
    backgroundFrame.origin.x = self.item.backgroundImageMargin;
    backgroundFrame.size.width = self.backgroundView.frame.size.width - self.item.backgroundImageMargin * 2;
    //0.5像素线条不完整的情况
    if(self.normalBackgroundImageView){
        backgroundFrame.size.height = self.backgroundView.frame.size.height - 0.5;
    }
    self.normalBackgroundImageView.frame = backgroundFrame;
    self.highlightedBackgroundImageView.frame = backgroundFrame;
}

- (void)cellDidDisappear{
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
}

- (CGFloat)maxTitleWidthInSectionAllItems{
    CGFloat width = 0;
    for (NBTableViewItem *item in self.section.items) {
        if (![NSString nb_isEmpty:item.title]) {
            CGSize size = [item.title nb_sizeWithFont:item.titleFont maxWidth:150];
            width = MAX(width, size.width);
        }
    }
    return width;
}

- (void)layoutDetailView:(UIView *)view{
    CGFloat cellOffset = kNormalPadding;
    
    if (self.contentViewMargin > 0) {
        cellOffset = self.contentViewMargin;
    }
    CGRect imageFrame = self.imageView.frame;
    CGRect titleFrame = self.textLabel.frame;
    CGRect viewFrame = CGRectMake(0, titleFrame.origin.y, 0, titleFrame.size.height > 0 ? titleFrame.size.height : self.height);
    
    // 有图片
    if (self.image) {
        viewFrame.origin.x = CGRectGetMaxX(imageFrame) + kNormalPadding;
    }
    // 有标题
    if (self.title) {
        if (self.image) {
            viewFrame.origin.x = titleFrame.origin.x + [self.title nb_sizeWithFont:self.font maxWidth:150].width + kNormalPadding;
        } else {
            viewFrame.origin.x = titleFrame.origin.x + [self maxTitleWidthInSectionAllItems] + kNormalPadding;
        }
    }
    
    if (viewFrame.origin.x == 0) {
        viewFrame.origin.x = cellOffset;
    }
    viewFrame.size.width = self.contentView.frame.size.width - viewFrame.origin.x - cellOffset;
    view.frame = viewFrame;
}

#pragma mark - private method
- (void)addBackgroundImage {
    if (self.normalBackgroundImageView == nil) {
        self.normalBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.backgroundView.bounds.size.width, self.backgroundView.bounds.size.height + 1)];
        self.normalBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.normalBackgroundView addSubview:self.normalBackgroundImageView];
    }
    self.normalBackgroundImageView.image = self.normalBackgroundImage;
}

- (void)addSelectedBackgroundImage{
    if (self.highlightedBackgroundImageView == nil) {
        self.highlightedBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.selectedBackgroundView.bounds.size.width, self.selectedBackgroundView.bounds.size.height + 1)];
        self.highlightedBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.highlightedBackgroundView addSubview:self.highlightedBackgroundImageView];
    }
    self.highlightedBackgroundImageView.image = self.highlightedBackgroundImage;
}

#pragma mark - public method
#pragma mark - manage height
// 如果需要自己计算高度可以重写这个方法
+ (CGFloat)tableView:(UITableView*)tableView heightForRowByItem:(NBTableViewItem*)item{
    return 0;
}

// If you are not using auto layout, override this method, enable it by setting
// "fd_enforceFrameLayout" to YES.
//- (CGSize)sizeThatFits:(CGSize)size {
//    CGFloat totalHeight = 0;
//    totalHeight += [self.titleLabel sizeThatFits:size].height;
//    totalHeight += [self.detailLabel sizeThatFits:size].height;
//    totalHeight += 40; // margins
//    return CGSizeMake(size.width, totalHeight);
//}

#pragma mark - manage actionBar
- (void)updateActionBarNavigationControl {
    [self.actionBar.navigationControl setEnabled:[self indexPathForPreviousResponder] != nil forSegmentAtIndex:0];
    [self.actionBar.navigationControl setEnabled:[self indexPathForNextResponder] != nil forSegmentAtIndex:1];
}

- (UIResponder *)responder {
    return nil;
}

/*!
 *  @brief  上一个可响应的控件的位置
 */
- (NSIndexPath *)indexPathForPreviousResponder {
    for (NSInteger i = self.section.indexAtTableView; i >= 0; i--) {
        NSIndexPath *indexPath = [self indexPathForPreviousResponderInSectionIndex:i];
        if (indexPath)
            return indexPath;
    }
    return nil;
}

- (NSIndexPath *)indexPathForPreviousResponderInSectionIndex:(NSUInteger)sectionIndex {
    NBTableViewSection *section = [self.tableViewAdaptor.sections objectAtIndex:sectionIndex];
    NSUInteger indexInSection =  [section isEqual:self.section] ? [section.items indexOfObject:self.item] : section.items.count;
    for (NSInteger i = indexInSection - 1; i >= 0; i--) {
        NBTableViewItem *item = [section.items objectAtIndex:i];
        if ([item isKindOfClass:[NBTableViewItem class]]) {
            if ([item.cellClass canFocusWithItem:item]) {
                return [NSIndexPath indexPathForRow:i inSection:sectionIndex];
            }
        }
    }
    return nil;
}

/*!
 *  @brief  下一个可响应的控件的位置
 */
- (NSIndexPath *)indexPathForNextResponder {
    for (NSInteger i = self.section.indexAtTableView; i < self.tableViewAdaptor.sections.count; i++) {
        NSIndexPath *indexPath = [self indexPathForNextResponderInSectionIndex:i];
        if (indexPath) {
            return indexPath;
        }
    }
    return nil;
}

- (NSIndexPath *)indexPathForNextResponderInSectionIndex:(NSUInteger)sectionIndex {
    NBTableViewSection *section = [self.tableViewAdaptor.sections objectAtIndex:sectionIndex];
    NSUInteger indexInSection =  [section isEqual:self.section] ? [section.items indexOfObject:self.item] : -1;
    for (NSInteger i = indexInSection + 1; i < section.items.count; i++) {
        NBTableViewItem *item = [section.items objectAtIndex:i];
        if ([item isKindOfClass:[NBTableViewItem class]]) {
            if ([item.cellClass canFocusWithItem:item]) {
                return [NSIndexPath indexPathForRow:i inSection:sectionIndex];
            }
        }
    }
    return nil;
}

#pragma mark actionBar delegate
- (void)actionBar:(NBActionBar *)actionBar navigationControlValueChanged:(UISegmentedControl *)navigationControl {
    NSIndexPath *indexPath = navigationControl.selectedSegmentIndex == 0 ? [self indexPathForPreviousResponder] : [self indexPathForNextResponder];
    if (indexPath) {
        NBTableViewCell *cell = (NBTableViewCell *)[self.parentTableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            [self.parentTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        cell = (NBTableViewCell *)[self.parentTableView cellForRowAtIndexPath:indexPath];
        [cell.responder becomeFirstResponder];
    }
    if (self.item.actionBarNavButtonTapHandler) {
        self.item.actionBarNavButtonTapHandler(self.item);
    }
}

- (void)actionBar:(NBActionBar *)actionBar doneButtonPressed:(UIBarButtonItem *)doneButtonItem {
    if (self.item.actionBarDoneButtonTapHandler) {
        self.item.actionBarDoneButtonTapHandler(self.item);
    }
    
    [self endEditing:YES];
}

#pragma mark - getter & setter
- (void)setItem:(NBTableViewItem *)item{
    if (_item != item) {
        _item = item;
        self.title                      = _item.title;
        self.titleAttrbuteString        = _item.titleAttrbuteString;
        self.font                       = _item.titleFont;
        self.color                      = _item.titleColor;
        self.textAlignment              = _item.textAlignment;
        self.detailText                 = _item.detailText;
        self.image                      = _item.image;
        self.contentViewMargin          = _item.contentViewMargin;
        self.backgroundImageMargin      = _item.backgroundImageMargin;
        self.selectionStyle             = _item.selectionStyle;
        self.accessoryType              = _item.accessoryType;
        self.accessoryView              = _item.accessoryView;
        self.userInteractionEnabled     = _item.userInteractionEnabled;
        self.hideSeparateLine           = _item.hiddenSeparateLine;
        self.separateLineColor          = _item.separateLineColor;
        self.separateLineLeftPadding    = _item.separateLineLeftPadding;
        self.separateLineRightPadding   = _item.separateLineRightPadding;
        self.separateLineHeight         = _item.separateLineHeight;
        self.normalBackgroundColor      = _item.backgroundColor;
        self.highlightedBackgroundColor = _item.selectedBackgroundColor;
        self.normalBackgroundImage      = _item.backgroundImage;
        self.highlightedBackgroundImage = _item.selectedBackgroundImage;
        if(item.contentViewBackgroundColor){
            self.contentView.backgroundColor =  item.contentViewBackgroundColor;
            self.backgroundColor = item.contentViewBackgroundColor;
        }
    }
}


- (UIView *)normalBackgroundView{
    if (_normalBackgroundView == nil) {
        UIView *normalBackgroundView          = [[UIView alloc] init];
        normalBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _normalBackgroundView = normalBackgroundView;
    }
    return _normalBackgroundView;
}
//
//- (UIColor *)highlightedBackgroundColor{
//    if (_highlightedBackgroundColor == nil) {
//        switch (self.selectionStyle) {
//            case UITableViewCellSelectionStyleNone: {
//                _highlightedBackgroundColor = self.normalBackgroundColor;
//                break;
//            }
//            case UITableViewCellSelectionStyleBlue: {
//                _highlightedBackgroundColor = [UIColor blueColor];
//                break;
//            }
//            case UITableViewCellSelectionStyleGray: {
//                _highlightedBackgroundColor = COLOR_TABLE_CELL_SELECTED;
//                break;
//            }
//            case UITableViewCellSelectionStyleDefault: {
//                _highlightedBackgroundColor = COLOR_TABLE_CELL_SELECTED;
//                break;
//            }
//            default: {
//                _highlightedBackgroundColor = COLOR_TABLE_CELL_SELECTED;
//                break;
//            }
//        }
//    }
//    return _highlightedBackgroundColor;
//}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor{
    if (highlightedBackgroundColor != _highlightedBackgroundColor) {
        _highlightedBackgroundColor = highlightedBackgroundColor;
    }
}

- (UIView *)highlightedBackgroundView{
    if (_highlightedBackgroundView == nil) {
        UIView *highlightedBackgroundView          = [[UIView alloc] init];
        highlightedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _highlightedBackgroundView = highlightedBackgroundView;
    }
    return _highlightedBackgroundView;
}

- (UIView *)separateLine{
    if (_separateLine == nil) {
        _separateLine = [[UIView alloc] init];
        _separateLine.backgroundColor = [UIColor blackColor];
    }
    return _separateLine;
}

- (UIColor *)separateLineColor{
    if (_separateLineColor) {
        _separateLineColor = [UIColor blackColor];
    }
    return _separateLineColor;
}

- (void)setSeparateLineColor:(UIColor *)separateLineColor{
    if (separateLineColor) {
        _separateLineColor                = separateLineColor;
        self.separateLine.backgroundColor = _separateLineColor;
    }
}

- (CGFloat)separateLineLeftPadding {
    if (_separateLineLeftPadding < 0) {
        _separateLineLeftPadding = 0;
    }
    return _separateLineLeftPadding;
}

- (void)setSeparateLineLeftPadding:(CGFloat)separateLineLeftPadding {
    separateLineLeftPadding = ceil(separateLineLeftPadding);
    if (separateLineLeftPadding != _separateLineLeftPadding) {
        _separateLineLeftPadding = separateLineLeftPadding;
    }
}

- (CGFloat)separateLineRightPadding {
    if (_separateLineRightPadding < 0) {
        _separateLineRightPadding = 0;
    }
    return _separateLineRightPadding;
}

- (void)setSeparateLineRightPadding:(CGFloat)separateLineRightPadding {
    separateLineRightPadding = ceil(separateLineRightPadding);
    if (separateLineRightPadding != _separateLineRightPadding) {
        _separateLineRightPadding = separateLineRightPadding;
    }
}

- (CGFloat)separateLineHeight {
    if (_separateLineHeight < 0) {
        _separateLineHeight = 0;
    }
    return _separateLineHeight;
}

- (void)setSeparateLineHeight:(CGFloat)separateLineHeight {
//    separateLineHeight = separateLineHeight; // 防止小数，出现渲染异常
    if (separateLineHeight != _separateLineHeight) {
        _separateLineHeight = separateLineHeight;
    }
}

- (void)setHideSeparateLine:(BOOL)hideSeparateLine {
    _hideSeparateLine = hideSeparateLine;
    self.separateLine.hidden = _hideSeparateLine;
}

- (NBActionBar *)actionBar {
    if (_actionBar == nil) {
        _actionBar = [[NBActionBar alloc] initWithDelegate:self];
    }
    return _actionBar;
}

- (NBTableViewCellType)type
{
    if (self.rowIndex == 0 && self.section.items.count == 1) {
        return NBTableViewCellTypeSingle;
    }
    
    if (self.rowIndex == 0 && self.section.items.count > 1) {
        return NBTableViewCellTypeFirst;
    }
    
    if (self.rowIndex > 0 && self.rowIndex < self.section.items.count - 1 && self.section.items.count > 2) {
        return NBTableViewCellTypeMiddle;
    }
    
    if (self.rowIndex == self.section.items.count - 1 && self.section.items.count > 1) {
        return NBTableViewCellTypeLast;
    }
    
    return NBTableViewCellTypeAny;
}

+ (BOOL)canFocusWithItem:(NBTableViewItem *)item{
    return NO;
}

@end
