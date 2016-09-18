//
//  NBTableViewSection.m
//  NBTableView
//
//  Created by 刘彬 on 16/3/11.
//  Copyright © 2016年 NewBee. All rights reserved.
//

#import "NBTableViewSection.h"
#import "NBTableViewAdaptor.h"
#import <float.h>

CGFloat const NBTableViewSectionHeaderHeightAutomatic = DBL_MAX;
CGFloat const NBTableViewSectionFooterHeightAutomatic = DBL_MAX;

@interface NBTableViewSection ()

@property (strong, readwrite, nonatomic) NSMutableArray<NBTableViewItem *> *mutableItems;

@end

@implementation NBTableViewSection

#pragma mark Creating and Initializing Sections
+ (instancetype)section{
    return [[self alloc] init];
}

+ (instancetype)sectionWithHeaderTitle:(NSString *)headerTitle{
    return [[self alloc ] initWithHeaderTitle:headerTitle];
}

+ (instancetype)sectionWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle{
    return [[self alloc] initWithHeaderTitle:headerTitle footerTitle:footerTitle];
}

+ (instancetype)sectionWithHeaderView:(UIView *)headerView{
    return [[self alloc] initWithHeaderView:headerView footerView:nil];
}

+ (instancetype)sectionWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView{
    return [[self alloc] initWithHeaderView:headerView footerView:footerView];
}

- (id)init{
    self = [super init];
    if (self){
        _headerHeight = NBTableViewSectionHeaderHeightAutomatic;
        _footerHeight = NBTableViewSectionFooterHeightAutomatic;
    }
    return self;
}

- (id)initWithHeaderTitle:(NSString *)headerTitle{
    return [self initWithHeaderTitle:headerTitle footerTitle:nil];
}

- (id)initWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle{
    self = [self init];
    if (!self)
        return nil;
    
    self.headerTitle = headerTitle;
    self.footerTitle = footerTitle;
    
    return self;
}

- (id)initWithHeaderView:(UIView *)headerView{
    return [self initWithHeaderView:headerView footerView:nil];
}

- (id)initWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView{
    self = [self init];
    if (!self)
        return nil;
    
    self.headerView = headerView;
    self.footerView = footerView;
    
    return self;
}

#pragma mark Managing items
- (void)addItem:(NBTableViewItem *)item
{
    if ([item isKindOfClass:[NBTableViewItem class]]){
        ((NBTableViewItem *)item).section = self;
        [self.mutableItems addObject:item];
    }
}

- (void)addItemsFromArray:(NSArray<NBTableViewItem *> *)array
{
    for (id item in array) {
        if ([item isKindOfClass:[NBTableViewItem class]]){
            ((NBTableViewItem *)item).section = self;
            [self.mutableItems addObject:item];
        }
    }
}

- (void)insertItem:(NBTableViewItem *)item atIndex:(NSUInteger)index
{
    if ([item isKindOfClass:[NBTableViewItem class]]){
        ((NBTableViewItem *)item).section = self;
        [self.mutableItems insertObject:item atIndex:index];
    }
}

- (void)insertItems:(NSArray<NBTableViewItem *> *)items atIndexes:(NSIndexSet *)indexes
{
    for (id item in items) {
        if ([item isKindOfClass:[NBTableViewItem class]]) {
            ((NBTableViewItem *)item).section = self;
        }
        [self.mutableItems insertObjects:items atIndexes:indexes];
    }
}

- (void)removeItem:(NBTableViewItem *)item inRange:(NSRange)range
{
    [self.mutableItems removeObject:item inRange:range];
}

- (void)removeLastItem
{
    [self.mutableItems removeLastObject];
}

- (void)removeItemAtIndex:(NSUInteger)index
{
    [self.mutableItems removeObjectAtIndex:index];
}

- (void)removeItem:(NBTableViewItem *)item
{
    [self.mutableItems removeObject:item];
}

- (void)removeAllItems
{
    [self.mutableItems removeAllObjects];
}

- (void)removeItemIdenticalTo:(NBTableViewItem *)item inRange:(NSRange)range
{
    [self.mutableItems removeObjectIdenticalTo:item inRange:range];
}

- (void)removeItemIdenticalTo:(NBTableViewItem *)item
{
    [self.mutableItems removeObjectIdenticalTo:item];
}

- (void)removeItemsInArray:(NSArray<NBTableViewItem *> *)otherArray
{
    [self.mutableItems removeObjectsInArray:otherArray];
}

- (void)removeItemsInRange:(NSRange)range
{
    [self.mutableItems removeObjectsInRange:range];
}

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes
{
    [self.mutableItems removeObjectsAtIndexes:indexes];
}

- (void)replaceItemAtIndex:(NSUInteger)index withItem:(NBTableViewItem *)item
{
    if ([item isKindOfClass:[NBTableViewItem class]]) {
        ((NBTableViewItem *)item).section = self;
        [self.mutableItems replaceObjectAtIndex:index withObject:item];
    }
}

- (void)replaceItemsWithItemsFromArray:(NSArray<NBTableViewItem *> *)otherArray
{
    [self removeAllItems];
    [self addItemsFromArray:otherArray];
}

- (void)replaceItemsInRange:(NSRange)range withItemsFromArray:(NSArray<NBTableViewItem *> *)otherArray range:(NSRange)otherRange
{
    for (id item in otherArray) {
        if ([item isKindOfClass:[NBTableViewItem class]]) {
            ((NBTableViewItem *)item).section = self;
        }
    }
    
    [self.mutableItems replaceObjectsInRange:range withObjectsFromArray:otherArray range:otherRange];
}

- (void)replaceItemsInRange:(NSRange)range withItemsFromArray:(NSArray<NBTableViewItem *> *)otherArray
{
    for (id item in otherArray) {
        if ([item isKindOfClass:[NBTableViewItem class]]) {
            ((NBTableViewItem *)item).section = self;
        }
    }
    
    [self.mutableItems replaceObjectsInRange:range withObjectsFromArray:otherArray];
}

- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray<NBTableViewItem *> *)items
{
    for (id item in items) {
        if ([item isKindOfClass:[NBTableViewItem class]]) {
            ((NBTableViewItem *)item).section = self;
        }
    }
    
    [self.mutableItems replaceObjectsAtIndexes:indexes withObjects:items];
}

- (void)exchangeItemAtIndex:(NSUInteger)idx1 withItemAtIndex:(NSUInteger)idx2
{
    [self.mutableItems exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)sortItemsUsingFunction:(NSInteger (*)(NBTableViewItem *item1, NBTableViewItem *item2, void *))compare context:(void *)context
{
    [self.mutableItems sortUsingFunction:compare context:context];
}

- (void)sortItemsUsingSelector:(SEL)comparator
{
    [self.mutableItems sortUsingSelector:comparator];
}

- (void)reloadSectionWithAnimation:(UITableViewRowAnimation)animation
{
    [self.tableViewAdaptor.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.indexAtTableView] withRowAnimation:animation];
}

#pragma mark - getter
- (NSUInteger)indexAtTableView{
    NBTableViewAdaptor *tableViewAdaptor = self.tableViewAdaptor;
    return [tableViewAdaptor.sections indexOfObject:self];
}

- (NSArray<NBTableViewItem *> *)items{
    return self.mutableItems;
}

- (NSMutableArray<NBTableViewItem *> *)mutableItems{
    if (_mutableItems == nil) {
        _mutableItems = [NSMutableArray array];
    }
    return _mutableItems;
}

@end
