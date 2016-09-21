//
//  FMBaseTableViewCell.m
//  FMTB
//
//  Created by 刘彬 on 16/9/20.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "FMBaseTableViewCell.h"
#import "FMBaseCellModel.h"
#import "FMTableViewSection.h"

@interface FMBaseTableViewCell ()

@property (nonatomic, assign) BOOL loaded;

// 分割线
@property (nonatomic, strong) UIView *separateLine;
@property (nonatomic, assign) BOOL hideSeparateLine;
@property (nonatomic, strong) UIColor *separateLineColor;
@property (nonatomic, assign) CGFloat separateLineHeight;
@property (nonatomic, assign) CGFloat separateLineLeftPadding;
@property (nonatomic, assign) CGFloat separateLineRightPadding;

// 间距
@property (nonatomic, assign) CGFloat contentViewMargin;
@property (nonatomic, assign) CGFloat backgroundImageMargin;

// 背景
@property (nonatomic, strong) UIView *normalBackgroundView;
@property (nonatomic, strong) UIColor *normalBackgroundColor;

@property (nonatomic, strong) UIImageView *normalBackgroundImageView;
@property (nonatomic, strong) UIImage *normalBackgroundImage;


// 选中背景
@property (nonatomic, strong) UIView *highlightedBackgroundView;
@property (nonatomic, strong) UIColor *highlightedBackgroundColor;

@property (nonatomic, strong) UIImageView *highlightedBackgroundImageView;
@property (nonatomic, strong) UIImage *highlightedBackgroundImage;

@end

@implementation FMBaseTableViewCell

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
        [self.contentView addSubview:self.separateLine];
        // 添加背景
        self.backgroundView         = self.normalBackgroundView;
        self.selectedBackgroundView = self.highlightedBackgroundView;
    }
}

- (void)cellWillAppear{
    // 设置背景图片、颜色
    if (self.normalBackgroundImage) {
        self.normalBackgroundImageView.backgroundColor = [UIColor clearColor];
        [self addBackgroundImage];
    } else{
        self.normalBackgroundView.backgroundColor = self.normalBackgroundColor;
    }
    if (self.highlightedBackgroundImage) {
        self.highlightedBackgroundView.backgroundColor = [UIColor clearColor];
        [self addSelectedBackgroundImage];
    } else{
        self.highlightedBackgroundView.backgroundColor = self.highlightedBackgroundColor;
    }
    // 设置分割线和背景的frame
    CGRect contentFrame = self.bounds;
    contentFrame.origin.x = contentFrame.origin.x + self.contentViewMargin;
    contentFrame.size.width = contentFrame.size.width - self.contentViewMargin * 2;
    self.contentView.frame = contentFrame;
    
    self.separateLine.frame = CGRectMake(self.separateLineLeftPadding, contentFrame.size.height-self.separateLineHeight, contentFrame.size.width -self.separateLineLeftPadding - self.separateLineRightPadding, self.separateLineHeight);
    
    CGRect backgroundFrame = self.normalBackgroundImageView.frame;
    backgroundFrame.origin.x = self.object.backgroundImageMargin;
    backgroundFrame.size.width = self.backgroundView.frame.size.width - self.object.backgroundImageMargin * 2;
    backgroundFrame.size.height = self.backgroundView.frame.size.height - self.separateLineHeight;
    self.normalBackgroundImageView.frame = backgroundFrame;
    self.highlightedBackgroundImageView.frame = backgroundFrame;
}

- (void)cellDidDisappear{
    
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

#pragma mark - manage height
// 如果需要自己计算高度可以重写这个方法
+ (CGFloat)tableView:(UITableView*)tableView heightForRowWithCellModel:(FMBaseCellModel *)item{
    return 0;
}

#pragma mark - getter & setter
- (void)setObject:(id<FMCellModelBasicProtocol>)object{
    if (_object != object) {
        _object = object;
        self.contentViewMargin          = _object.contentViewMargin;
        self.backgroundImageMargin      = _object.backgroundImageMargin;
        self.selectionStyle             = _object.selectionStyle;
        self.accessoryType              = _object.accessoryType;
        self.accessoryView              = _object.accessoryView;
        self.userInteractionEnabled     = _object.userInteractionEnabled;
        self.hideSeparateLine           = _object.hiddenSeparateLine;
        self.separateLineColor          = _object.separateLineColor;
        self.separateLineLeftPadding    = _object.separateLineLeftPadding;
        self.separateLineRightPadding   = _object.separateLineRightPadding;
        self.separateLineHeight         = _object.separateLineHeight;
        self.normalBackgroundColor      = _object.normalBackgroundColor;
        self.highlightedBackgroundColor = _object.selectedBackgroundColor;
        self.normalBackgroundImage      = _object.normalBackgroundImage;
        self.highlightedBackgroundImage = _object.selectedBackgroundImage;
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
    if (_separateLineColor == nil) {
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
        _separateLineHeight = 0.5/[UIScreen mainScreen].scale;
    }
    return _separateLineHeight;
}

- (void)setSeparateLineHeight:(CGFloat)separateLineHeight {
    if (separateLineHeight != _separateLineHeight) {
        _separateLineHeight = separateLineHeight/[UIScreen mainScreen].scale;
    }
}

- (void)setHideSeparateLine:(BOOL)hideSeparateLine {
    _hideSeparateLine = hideSeparateLine;
    self.separateLine.hidden = _hideSeparateLine;
}

@end
