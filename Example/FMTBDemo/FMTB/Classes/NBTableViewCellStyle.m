//
//  NBTableViewCellStyle.m
//  NBTableView
//
//  Created by 刘彬 on 16/3/27.
//  Copyright © 2016年 NewBee. All rights reserved.
//

#import "NBTableViewCellStyle.h"

@interface NBTableViewCellStyle ()

@end

@implementation NBTableViewCellStyle

- (id)copyWithZone:(NSZone *)zone {
    NBTableViewCellStyle *style = [[self class] allocWithZone:zone];
    if (style) {
        style.cellHeight                = self.cellHeight;
        style.contentViewMargin         = self.contentViewMargin;
        style.backgroundImageMargin     = self.backgroundImageMargin;
        
        style.backgroundColor           = self.backgroundColor;
        style.selectedBackgroundColor   = self.selectedBackgroundColor;
        
        style.backgroundImages          = [NSMutableDictionary dictionaryWithDictionary:[self.backgroundImages copyWithZone:zone]];
        style.selectedBackgroundImages  = [NSMutableDictionary dictionaryWithDictionary:[self.selectedBackgroundImages copyWithZone:zone]];
        style.separateLineColor         = self.separateLineColor;
        style.separateLineHeight        = self.separateLineHeight;
        style.separateLineLeftPadding   = self.separateLineLeftPadding;
        style.separateLineRightPadding  = self.separateLineRightPadding;
    }
    return style;
}

- (BOOL)hasCustomBackgroundImage {
    return [self backgroundImageForCellType:NBCellLocationAny]
    || [self backgroundImageForCellType:NBCellLocationFirst]
    || [self backgroundImageForCellType:NBCellLocationMiddle]
    || [self backgroundImageForCellType:NBCellLocationLast]
    || [self backgroundImageForCellType:NBCellLocationSingle];
}

- (UIImage *)backgroundImageForCellType:(NBCellLocationType)cellType {
    UIImage *image = [self.backgroundImages objectForKey:@(cellType)];
    if (!image && cellType != NBCellLocationAny) {
        image = [self.backgroundImages objectForKey:@(NBCellLocationAny)];
    }
    return image;
}

- (void)setBackgroundImage:(UIImage *)image forCellType:(NBCellLocationType)cellType {
    if (image) {
        [self.backgroundImages setObject:image forKey:@(cellType)];
    }
}

- (BOOL)hasCustomSelectedBackgroundImage {
    return [self selectedBackgroundImageForCellType:NBCellLocationAny]
    ||[self selectedBackgroundImageForCellType:NBCellLocationFirst]
    || [self selectedBackgroundImageForCellType:NBCellLocationMiddle]
    || [self selectedBackgroundImageForCellType:NBCellLocationLast]
    || [self selectedBackgroundImageForCellType:NBCellLocationSingle];
}

- (UIImage *)selectedBackgroundImageForCellType:(NBCellLocationType)cellType {
    UIImage *image = [self.selectedBackgroundImages objectForKey:@(cellType)];
    if (!image && cellType != NBCellLocationAny) {
        image = [self.selectedBackgroundImages objectForKey:@(NBCellLocationAny)];
    }
    return image;
}

- (void)setSelectedBackgroundImage:(UIImage *)image forCellType:(NBCellLocationType)cellType {
    if (image) {
        [self.selectedBackgroundImages setObject:image forKey:@(cellType)];
    }
}

#pragma mark - getter
- (NSMutableDictionary *)backgroundImages{
    if (_backgroundImages == nil){
        _backgroundImages = [[NSMutableDictionary alloc] init];
    }
    return _backgroundImages;
}

- (NSMutableDictionary *)selectedBackgroundImages{
    if (_selectedBackgroundImages == nil){
        _selectedBackgroundImages = [[NSMutableDictionary alloc] init];
    }
    return _selectedBackgroundImages;
}

@end
