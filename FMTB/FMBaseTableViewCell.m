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
@property (nonatomic, assign) BOOL hiddenSeparateLine;
@property (nonatomic, strong) UIColor *separateLineColor;
@property (nonatomic, assign) CGFloat separateLineHeight;
@property (nonatomic, assign) CGFloat separateLineLeftPadding;
@property (nonatomic, assign) CGFloat separateLineRightPadding;

// 右边箭头
@property (nonatomic, strong) UIImageView *rightArrowImageView;
@property (nonatomic, assign) BOOL hiddenRightArrow;
@property (nonatomic, assign) CGFloat rightArrowRightPadding;
@property (nonatomic, strong) UIImage *customArrowImage;

// 间距
@property (nonatomic, assign) CGFloat contentViewMargin;
@property (nonatomic, assign) CGFloat backgroundImageMargin;

// 背景
@property (nonatomic, strong) UIView *normalBackgroundView;
@property (nonatomic, strong) UIView *highlightedBackgroundView;
@property (nonatomic, strong) UIColor *normalBackgroundColor;
@property (nonatomic, strong) UIColor *highlightedBackgroundColor;

// 背景图片
@property (nonatomic, strong) UIImageView *normalBackgroundImageView;
@property (nonatomic, strong) UIImageView *highlightedBackgroundImageView;
@property (nonatomic, strong) UIImage *normalBackgroundImage;
@property (nonatomic, strong) UIImage *highlightedBackgroundImage;

@end

@implementation FMBaseTableViewCell

@synthesize loaded                     = _loaded;

@synthesize hiddenSeparateLine         = _hiddenSeparateLine;
@synthesize separateLineColor          = _separateLineColor;
@synthesize separateLineHeight         = _separateLineHeight;
@synthesize separateLineLeftPadding    = _separateLineLeftPadding;
@synthesize separateLineRightPadding   = _separateLineRightPadding;

@synthesize hiddenRightArrow           = _hiddenRightArrow;
@synthesize rightArrowRightPadding     = _rightArrowRightPadding;
@synthesize customArrowImage           = _customArrowImage;

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
        self.contentView.exclusiveTouch = YES;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 添加分隔线
        [self.contentView addSubview:self.separateLine];
        // 添加箭头
        [self.contentView addSubview:self.rightArrowImageView];
        // 添加背景
        self.backgroundView         = self.normalBackgroundView;
        self.selectedBackgroundView = self.highlightedBackgroundView;
        
        // 添加背景图
        [self addBackgroundImage];
        [self addSelectedBackgroundImage];
    }
}

- (void)cellWillAppear{
    // 设置背景图片、颜色
    self.backgroundView.backgroundColor = self.normalBackgroundColor;
    self.selectedBackgroundView.backgroundColor = self.highlightedBackgroundColor;
    self.normalBackgroundImageView.image = self.normalBackgroundImage;
    self.highlightedBackgroundImageView.image = self.highlightedBackgroundImage;
    
    // 设置分割线和背景的frame
    CGRect contentFrame = self.bounds;
    contentFrame.origin.x = contentFrame.origin.x + self.contentViewMargin;
    contentFrame.size.width = contentFrame.size.width - self.contentViewMargin * 2;
    self.contentView.frame = contentFrame;
    
    self.separateLine.frame = CGRectMake(self.separateLineLeftPadding, self.frame.size.height-self.separateLineHeight, self.frame.size.width -self.separateLineLeftPadding - self.separateLineRightPadding, self.separateLineHeight);
    
    self.rightArrowImageView.frame = CGRectMake(contentFrame.size.width - self.rightArrowRightPadding - self.customArrowImage.size.width, (contentFrame.size.height-self.customArrowImage.size.height)/2, self.customArrowImage.size.width, self.customArrowImage.size.height);
    
    CGRect backgroundViewFrame = self.normalBackgroundView.frame;
    backgroundViewFrame.origin.x = self.object.contentViewMargin;
    backgroundViewFrame.size.width = self.backgroundView.frame.size.width - self.object.contentViewMargin * 2;
    backgroundViewFrame.size.height = self.backgroundView.frame.size.height - self.separateLineHeight;
    self.normalBackgroundView.frame = backgroundViewFrame;
    self.highlightedBackgroundView.frame = backgroundViewFrame;
    
    CGRect backgroundImageFrame = self.normalBackgroundImageView.frame;
    backgroundImageFrame.origin.x = self.object.backgroundImageMargin;
    backgroundImageFrame.size.width = self.backgroundView.frame.size.width - self.object.backgroundImageMargin * 2;
    backgroundImageFrame.size.height = self.backgroundView.frame.size.height - self.separateLineHeight;
    self.normalBackgroundImageView.frame = backgroundImageFrame;
    self.highlightedBackgroundImageView.frame = backgroundImageFrame;
}

- (void)cellDidDisappear{
    
}

#pragma mark - private method
- (void)addBackgroundImage {
    if (self.normalBackgroundImageView == nil) {
        self.normalBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.backgroundView.bounds.size.width, self.backgroundView.bounds.size.height)];
        self.normalBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.normalBackgroundView addSubview:self.normalBackgroundImageView];
    }
    self.normalBackgroundImageView.image = self.normalBackgroundImage;
}

- (void)addSelectedBackgroundImage{
    if (self.highlightedBackgroundImageView == nil) {
        self.highlightedBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.selectedBackgroundView.bounds.size.width, self.selectedBackgroundView.bounds.size.height)];
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

- (void)prepareForReuse{
    [super prepareForReuse];
    self.contentViewMargin          = 0;
    self.backgroundImageMargin      = 0;
    self.selectionStyle             = UITableViewCellSelectionStyleDefault;
    self.userInteractionEnabled     = YES;
    self.hiddenSeparateLine         = NO;
    self.separateLineColor          = [UIColor blackColor];
    self.separateLineLeftPadding    = 0;
    self.separateLineRightPadding   = 0;
    self.separateLineHeight         = 1;
    self.hiddenRightArrow           = NO;
    self.rightArrowRightPadding     = 10;
    self.customArrowImage           = [UIImage imageNamed:[@"FMTB.bundle" stringByAppendingPathComponent:@"icon_cell_arrow_gray.png"]];
    self.normalBackgroundColor      = [UIColor whiteColor];
    self.normalBackgroundImage      = nil;
    self.highlightedBackgroundColor = [UIColor grayColor];
    self.highlightedBackgroundImage = nil;
}

#pragma mark - getter & setter
- (void)setObject:(id<FMCellModelBasicProtocol>)object{
    _object = object;
    if ([object conformsToProtocol:@protocol(FMCellModelBasicProtocol)]) {
        self.contentViewMargin          = _object.contentViewMargin;
        self.backgroundImageMargin      = _object.backgroundImageMargin;
        self.selectionStyle             = _object.selectionStyle;
        self.userInteractionEnabled     = _object.userInteractionEnabled;
        self.hiddenSeparateLine         = _object.hiddenSeparateLine;
        self.separateLineColor          = _object.separateLineColor;
        self.separateLineLeftPadding    = _object.separateLineLeftPadding;
        self.separateLineRightPadding   = _object.separateLineRightPadding;
        self.separateLineHeight         = _object.separateLineHeight;
        self.hiddenRightArrow           = _object.hiddenRightArrow;
        self.rightArrowRightPadding     = _object.rightArrowRightPadding;
        self.customArrowImage           = _object.customArrowImage;
        self.normalBackgroundColor      = _object.normalBackgroundColor;
        self.normalBackgroundImage      = _object.normalBackgroundImage;
        self.highlightedBackgroundColor = _object.selectedBackgroundColor;
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
        _separateLineHeight = 1/[UIScreen mainScreen].scale;
    }
    return _separateLineHeight;
}

- (void)setSeparateLineHeight:(CGFloat)separateLineHeight {
    if (separateLineHeight != _separateLineHeight) {
        _separateLineHeight = separateLineHeight/[UIScreen mainScreen].scale;
    }
}

- (void)setHiddenSeparateLine:(BOOL)hiddenSeparateLine {
    _hiddenSeparateLine = hiddenSeparateLine;
    self.separateLine.hidden = _hiddenSeparateLine;
}

- (UIImageView *)rightArrowImageView{
    if (_rightArrowImageView == nil) {
        _rightArrowImageView = [[UIImageView alloc] init];
    }
    return _rightArrowImageView;
}

- (void)setHiddenRightArrow:(BOOL)hiddenRightArrow{
    _hiddenRightArrow = hiddenRightArrow;
    self.rightArrowImageView.hidden = _hiddenRightArrow;
}

- (void)setRightArrowRightPadding:(CGFloat)rightArrowRightPadding{
    _rightArrowRightPadding = ceil(rightArrowRightPadding);
}

- (CGFloat)rightArrowRightPadding{
    if (_rightArrowRightPadding < 0) {
        _rightArrowRightPadding = 0;
    }
    return _rightArrowRightPadding;
}

- (void)setCustomArrowImage:(UIImage *)customArrowImage{
    if (customArrowImage == nil) {
        customArrowImage = [UIImage imageNamed:[@"FMTB.bundle" stringByAppendingPathComponent:@"icon_cell_arrow_gray.png"]];
    }
    _customArrowImage = customArrowImage;
    self.rightArrowImageView.image = _customArrowImage;
}

@end
