//
//  FMIconWithTitleCell.m
//  FMTBExample
//
//  Created by 刘彬 on 16/9/20.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "FMIconWithTitleCell.h"

@implementation FMIconWithTitleCellModel

- (id)initWithDefault
{
    self = [super initWithDefault];
    if (self) {
        self.cellClass = [FMIconWithTitleCell class];
        self.titleFont = [UIFont systemFontOfSize:14];
        self.titleColor = [UIColor blackColor];
        self.titleAlignment = NSTextAlignmentLeft;
        self.hiddenSeparateLine = NO;
        self.cellHeight = 44;
    }
    
    return self;
}

@end

@interface FMIconWithTitleCell ()

@property (nonatomic, strong) FMIconWithTitleCellModel *cellModel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation FMIconWithTitleCell

- (void)cellDidLoad{
    [super cellDidLoad];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
}

- (void)cellWillAppear{
    [super cellWillAppear];
}

- (void)setObject:(id<FMCellModelBasicProtocol>)object{
    [super setObject:object];
    _cellModel = object;
    self.iconImageView.image = self.cellModel.icon;
    self.titleLabel.text = self.cellModel.title;
    self.titleLabel.textColor = self.cellModel.titleColor;
    self.titleLabel.font = self.cellModel.titleFont;
    self.titleLabel.textAlignment = self.cellModel.titleAlignment;
    
    if (self.cellModel.icon) {
        CGRect iconFrame = CGRectMake(10, 10, self.cellModel.icon.size.width, self.cellModel.icon.size.height);
        self.iconImageView.frame = iconFrame;
    }
    CGRect titleFrame = CGRectMake(10 + self.cellModel.icon.size.width + (self.cellModel.icon ? 10 : 0), (self.bounds.size.height-20)/2, [[UIScreen mainScreen] bounds].size.width - 10 - (self.cellModel.icon ? 10 : 0) - self.cellModel.icon.size.width -10, 20);
    self.titleLabel.frame = titleFrame;
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowWithCellModel:(FMBaseCellModel *)item{
    FMIconWithTitleCellModel *cellModel = (FMIconWithTitleCellModel *)item;
    if (cellModel.icon) {
        return cellModel.icon.size.height+20;
    }
    return 44;
}

#pragma mark - getter
- (UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    }
    return _iconImageView;
}


- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+10, (44-20)/2, [[UIScreen mainScreen] bounds].size.width - 10 - 10 - 40 -10, 20)];
    }
    return _titleLabel;
}

@end
