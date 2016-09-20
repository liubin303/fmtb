//
//  FMTableViewSection.m
//  FMTB
//
//  Created by 刘彬 on 16/9/20.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "FMTableViewSection.h"
#import "FMBaseCellModel.h"
#import "FMTableViewAdaptor.h"

CGFloat const FMTableViewSectionHeaderHeightAutomatic = DBL_MAX;
CGFloat const FMTableViewSectionFooterHeightAutomatic = DBL_MAX;

@interface FMTableViewSection ()

@property (nonatomic, strong) NSMutableArray<FMBaseCellModel *> *items;

@end

@implementation FMTableViewSection

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
        _headerHeight = FMTableViewSectionHeaderHeightAutomatic;
        _footerHeight = FMTableViewSectionFooterHeightAutomatic;
        _items = [[NSMutableArray alloc] init];
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
- (void)addItem:(FMBaseCellModel *)item
{
    if ([item isKindOfClass:[FMBaseCellModel class]]){
        item.parentSection = self;
        [self.items addObject:item];
    }
}

- (void)addItemsFromArray:(NSArray<FMBaseCellModel *> *)array
{
    for (id item in array) {
        if ([item isKindOfClass:[FMBaseCellModel class]]){
            ((FMBaseCellModel *)item).parentSection = self;
            [self.items addObject:item];
        }
    }
}

- (void)insertItem:(FMBaseCellModel *)item atIndex:(NSUInteger)index
{
    if ([item isKindOfClass:[FMBaseCellModel class]]){
        ((FMBaseCellModel *)item).parentSection = self;
        [self.items insertObject:item atIndex:index];
    }
}

- (void)insertItems:(NSArray<FMBaseCellModel *> *)items atIndexes:(NSIndexSet *)indexes
{
    for (id item in items) {
        if ([item isKindOfClass:[FMBaseCellModel class]]) {
            ((FMBaseCellModel *)item).parentSection = self;
        }
        [self.items insertObjects:items atIndexes:indexes];
    }
}

- (void)removeItem:(FMBaseCellModel *)item inRange:(NSRange)range
{
    [self.items removeObject:item inRange:range];
}

- (void)removeLastItem
{
    [self.items removeLastObject];
}

- (void)removeItemAtIndex:(NSUInteger)index
{
    [self.items removeObjectAtIndex:index];
}

- (void)removeItem:(FMBaseCellModel *)item
{
    [self.items removeObject:item];
}

- (void)removeAllItems
{
    [self.items removeAllObjects];
}

- (void)removeItemIdenticalTo:(FMBaseCellModel *)item inRange:(NSRange)range
{
    [self.items removeObjectIdenticalTo:item inRange:range];
}

- (void)removeItemIdenticalTo:(FMBaseCellModel *)item
{
    [self.items removeObjectIdenticalTo:item];
}

- (void)removeItemsInArray:(NSArray<FMBaseCellModel *> *)otherArray
{
    [self.items removeObjectsInArray:otherArray];
}

- (void)removeItemsInRange:(NSRange)range
{
    [self.items removeObjectsInRange:range];
}

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes
{
    [self.items removeObjectsAtIndexes:indexes];
}

- (void)replaceItemAtIndex:(NSUInteger)index withItem:(FMBaseCellModel *)item
{
    if ([item isKindOfClass:[FMBaseCellModel class]]) {
        ((FMBaseCellModel *)item).parentSection = self;
        [self.items replaceObjectAtIndex:index withObject:item];
    }
}

- (void)replaceItemsWithItemsFromArray:(NSArray<FMBaseCellModel *> *)otherArray
{
    [self removeAllItems];
    [self addItemsFromArray:otherArray];
}

- (void)replaceItemsInRange:(NSRange)range withItemsFromArray:(NSArray<FMBaseCellModel *> *)otherArray range:(NSRange)otherRange
{
    for (id item in otherArray) {
        if ([item isKindOfClass:[FMBaseCellModel class]]) {
            ((FMBaseCellModel *)item).parentSection = self;
        }
    }
    
    [self.items replaceObjectsInRange:range withObjectsFromArray:otherArray range:otherRange];
}

- (void)replaceItemsInRange:(NSRange)range withItemsFromArray:(NSArray<FMBaseCellModel *> *)otherArray
{
    for (id item in otherArray) {
        if ([item isKindOfClass:[FMBaseCellModel class]]) {
            ((FMBaseCellModel *)item).parentSection = self;
        }
    }
    
    [self.items replaceObjectsInRange:range withObjectsFromArray:otherArray];
}

- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray<FMBaseCellModel *> *)items
{
    for (id item in items) {
        if ([item isKindOfClass:[FMBaseCellModel class]]) {
            ((FMBaseCellModel *)item).parentSection = self;
        }
    }
    
    [self.items replaceObjectsAtIndexes:indexes withObjects:items];
}

- (void)exchangeItemAtIndex:(NSUInteger)idx1 withItemAtIndex:(NSUInteger)idx2
{
    [self.items exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)sortItemsUsingFunction:(NSInteger (*)(FMBaseCellModel *item1, FMBaseCellModel *item2, void *))compare context:(void *)context
{
    [self.items sortUsingFunction:compare context:context];
}

- (void)sortItemsUsingSelector:(SEL)comparator
{
    [self.items sortUsingSelector:comparator];
}

- (void)reloadSectionWithAnimation:(UITableViewRowAnimation)animation
{
    [self.tableViewAdaptor.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.indexAtTableView] withRowAnimation:animation];
}

#pragma mark - getter
- (NSUInteger)indexAtTableView{
    FMTableViewAdaptor *tableViewAdaptor = self.tableViewAdaptor;
    return [tableViewAdaptor.sections indexOfObject:self];
}

@end
