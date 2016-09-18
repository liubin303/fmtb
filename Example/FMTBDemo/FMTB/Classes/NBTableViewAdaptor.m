//
//  NBTableViewAdaptor.m
//  NBTableView
//
//  Created by 刘彬 on 16/3/10.
//  Copyright © 2016年 NewBee. All rights reserved.
//

#import "NBTableViewAdaptor.h"
#import "NBTableViewCell.h"
#import <objc/runtime.h>
#import "MJRefresh.h"

#define kSectionDefaultHeight (22)

@interface NBTableViewAdaptor ()

@property (nonatomic, strong) NSMutableArray<NBTableViewSection*> *mutableSections;

@property (nonatomic, strong) MJRefreshNormalHeader *refreshView;
@property (nonatomic, strong) MJRefreshAutoNormalFooter   *loadMoreView;

@end

@implementation NBTableViewAdaptor

- (void)dealloc{
    self.delegate = nil;
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

#pragma mark Creating and Initializing Sections
+ (instancetype)adaptorWithTableView:(UITableView *)tableView{
    return [[self alloc] initWithTableView:tableView];
}

- (id)init{
    // 因为adaptor必须依赖tableview，所以这里把init入口关闭,防止后面tableview空指针
    @throw [NSException exceptionWithName:NSGenericException reason:@"init not supported, use adaptorWithTableView: or initWithTableView: instead." userInfo:nil];
    return nil;
}

- (id)initWithTableView:(UITableView *)tableView{
    self = [super init];
    if (self){
        tableView.delegate = self;
        tableView.dataSource = self;
        self.tableView = tableView;
//        self.dragRefreshEnable = NO;
//        self.loadMoreEnable = NO;
    }
    return self;
}

#pragma mark - TableView DataSource
///-----------------------------
/// @name Base DataSource
///-----------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mutableSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex{
    if (self.mutableSections.count <= sectionIndex) {
        return 0;
    }
    return [self.mutableSections objectAtIndex:sectionIndex].items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    NBTableViewItem *item = [section.items objectAtIndex:indexPath.row];
    // 注册cell
    Class cellClass = item.cellClass;
    NSString *cellIdentifier = [self identifierForCellAtIndexPath:indexPath];
    if (item.useNib == YES) {
        // dequeue时会调用 cell 的 -(void)awakeFromNib
        UINib *nib = [UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    } else {
        // dequeue时会调用 cell 的 - (id)initWithStyle:withReuseableCellIdentifier:
        [tableView registerClass:cellClass forCellReuseIdentifier:cellIdentifier];
    }
    /*
     * 注意：为了兼容FDTemplateLayoutCell，必须要先注册cell
     * 使用dequeueReuseableCellWithIdentifier:可不注册，但是必须对获取回来的cell进行判断是否为空，若空则手动创建新的cell；
     * 使用dequeueReuseableCellWithIdentifier:forIndexPath:必须注册，但返回的cell可省略空值判断的步骤。
     */
    NBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    void (^loadCell)(NBTableViewCell *cell) = ^(NBTableViewCell *cell) {
        if ([self.delegate conformsToProtocol:@protocol(NBTableViewAdaptorDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willLoadCell:forRowAtIndexPath:)]){
            [self.delegate tableView:tableView willLoadCell:cell forRowAtIndexPath:indexPath];
        }

        [cell cellDidLoad];

        if ([self.delegate conformsToProtocol:@protocol(NBTableViewAdaptorDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didLoadCell:forRowAtIndexPath:)]){
            [self.delegate tableView:tableView didLoadCell:cell forRowAtIndexPath:indexPath];
        }
    };
    // cell为空的时候
//    if (cell == nil) {
//        Class cellClass = item.cellClass;
//        if (item.useNib == YES) {
//            UINib *nib = [UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil];
//            cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
//            [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
//        } else {
//            cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//            [tableView registerClass:cellClass forCellReuseIdentifier:cellIdentifier];
//        }
//        loadCell(cell);
//    }
    // 这里再检查一下是否已经加载过cell
    if (!cell.loaded) {
        loadCell(cell);
    }
    // 这里必须要在willappear之前设置item，防止willappear出现空指针或数据没更新
    cell.rowIndex = indexPath.row;
    cell.sectionIndex = indexPath.section;
    cell.parentTableView = tableView;
    cell.tableViewAdaptor = self;
    cell.section = section;
    cell.item = item;
    return cell;
}

///-----------------------------
/// @name Section Config
///-----------------------------
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *titles;
    for (NBTableViewSection *section in self.mutableSections) {
        if (section.indexTitle) {
            titles = [NSMutableArray array];
            break;
        }
    }
    if (titles) {
        for (NBTableViewSection *section in self.mutableSections) {
            [titles addObject:section.indexTitle ? section.indexTitle : @""];
        }
    }
    
    return titles;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex{
    if (self.mutableSections.count <= sectionIndex) {
        return nil;
    }
    NBTableViewSection *section = [self.mutableSections objectAtIndex:sectionIndex];
    return section.headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)sectionIndex{
    if (self.mutableSections.count <= sectionIndex) {
        return nil;
    }
    NBTableViewSection *section = [self.mutableSections objectAtIndex:sectionIndex];
    return section.footerTitle;
}

///-----------------------------
/// @name Move Cell
///-----------------------------
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.mutableSections.count <= indexPath.section) {
        return NO;
    }
    NBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    NBTableViewItem *item = [section.items objectAtIndex:indexPath.row];
    return item.moveHandler != nil;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NBTableViewSection *sourceSection = [self.mutableSections objectAtIndex:sourceIndexPath.section];
    NBTableViewItem *item = [sourceSection.items objectAtIndex:sourceIndexPath.row];
    [sourceSection removeItemAtIndex:sourceIndexPath.row];
    
    NBTableViewSection *destinationSection = [self.mutableSections objectAtIndex:destinationIndexPath.section];
    [destinationSection insertItem:item atIndex:destinationIndexPath.row];
    
    if (item.moveCompletionHandler){
        item.moveCompletionHandler(item, sourceIndexPath, destinationIndexPath);
    }
}

///-----------------------------
/// @name Edit Cell
///-----------------------------
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < [self.mutableSections count]) {
        NBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
        if (indexPath.row < [section.items count]) {
            NBTableViewItem *item = [section.items objectAtIndex:indexPath.row];
            if ([item isKindOfClass:[NBTableViewItem class]]) {
                return item.editingStyle != UITableViewCellEditingStyleNone || item.moveHandler;
            }
        }
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    NBTableViewItem *item = [section.items objectAtIndex:indexPath.row];
    // 删除
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (item.deletionHandlerWithCompletion) {
            item.deletionHandlerWithCompletion(item, ^{
                if (item.shouldDeleteRightNow) {
                    [section removeItemAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    for (NSInteger i = indexPath.row; i < section.items.count; i++) {
                        NBTableViewItem *afterItem = [[section items] objectAtIndex:i];
                        NBTableViewCell *cell = (NBTableViewCell *)[tableView cellForRowAtIndexPath:afterItem.indexPath];
                        cell.rowIndex--;
                    }
                }
            });
        } else {
            if (item.deletionHandler) {
                item.deletionHandler(item);
            }
            if (item.shouldDeleteRightNow) {
                [section removeItemAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                for (NSInteger i = indexPath.row; i < section.items.count; i++) {
                    NBTableViewItem *afterItem = [[section items] objectAtIndex:i];
                    NBTableViewCell *cell = (NBTableViewCell *)[tableView cellForRowAtIndexPath:afterItem.indexPath];
                    cell.rowIndex--;
                }
            }
        }
    }
    
    // 插入
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        if (item.insertionHandler) {
            item.insertionHandler(item);
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:commitEditingStyle:forItem:atIndexPath:)]) {
        [self.delegate tableView:tableView commitEditingStyle:editingStyle forItem:item atIndexPath:indexPath];
    }
}

#pragma mark - TableView Delegate
///-----------------------------
/// @name Display customization
///-----------------------------
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[NBTableViewCell class]]) {
        [(NBTableViewCell *)cell cellWillAppear];
    }
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [self.delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    if ([cell isKindOfClass:[NBTableViewCell class]]) {
        [(NBTableViewCell *)cell cellDidDisappear];
    }
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)]) {
        [self.delegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]) {
        [self.delegate tableView:tableView willDisplayHeaderView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:)]) {
        [self.delegate tableView:tableView willDisplayFooterView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didEndDisplayingHeaderView:forSection:)]) {
        [self.delegate tableView:tableView didEndDisplayingHeaderView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didEndDisplayingFooterView:forSection:)]) {
        [self.delegate tableView:tableView didEndDisplayingFooterView:view forSection:section];
    }
}

///-----------------------------
/// @name height support
///-----------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 行高优先级依次为：tableView.rowHeight->cell内部计算的行高->item的cellHeight->vc实现的自动计算行高的delegate
    
    NBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    NBTableViewItem *item = [section.items objectAtIndex:indexPath.row];

    if (tableView.rowHeight > 0) {
        return tableView.rowHeight;
    }
    
//    SEL sel = @selector(tableView:heightForRowByItem:);
//    // 用class_respondsToSelector检查cellItem本类但不检查父类有无方法的重载 ，这个方法有bug，先在父类中返回0处理下，后期优化
    if ([item.cellClass tableView:tableView heightForRowByItem:item] > 0) {
        return [item.cellClass tableView:tableView heightForRowByItem:item];
    }
    if (item.cellHeight > 0) {
        return item.cellHeight;
    }

    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        // 注册cell
        Class cellClass = item.cellClass;
        NSString *cellIdentifier = [self identifierForCellAtIndexPath:indexPath];
        if (item.useNib == YES) {
            // dequeue时会调用 cell 的 -(void)awakeFromNib
            UINib *nib = [UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        } else {
            // dequeue时会调用 cell 的 - (id)initWithStyle:withReuseableCellIdentifier:
            [tableView registerClass:cellClass forCellReuseIdentifier:cellIdentifier];
        }
        return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    return 0;
}

// section height取值优先级：section.headerHeight->section.headerView.height->section.headerTitle.height-delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex{
    if (self.mutableSections.count <= sectionIndex) {
        return UITableViewAutomaticDimension;
    }
    NBTableViewSection *section = [self.mutableSections objectAtIndex:sectionIndex];
    if (section.headerHeight != NBTableViewSectionHeaderHeightAutomatic) {
        return section.headerHeight;
    }
    
    if (section.headerView) {
        return section.headerView.frame.size.height;
    } else if (section.headerTitle.length) {
        if (self.tableView.style != UITableViewStyleGrouped) {
            return kSectionDefaultHeight;
        } else {
            CGFloat headerHeight = 0;
            CGFloat headerWidth = CGRectGetWidth(CGRectIntegral(tableView.bounds)) - 40.0f; // 40 = 20pt horizontal padding on each side
            
            CGSize headerRect = CGSizeMake(headerWidth, NBTableViewSectionHeaderHeightAutomatic);
            
            CGRect headerFrame = [section.headerTitle boundingRectWithSize:headerRect
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                attributes:@{ NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline] }
                                                                   context:nil];
            
            headerHeight = headerFrame.size.height;
            
            return headerHeight + 20.0f;
        }
    }

    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]){
        return [self.delegate tableView:tableView heightForHeaderInSection:sectionIndex];
    }
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)sectionIndex{
    if (self.mutableSections.count <= sectionIndex) {
        return UITableViewAutomaticDimension;
    }
    NBTableViewSection *section = [self.mutableSections objectAtIndex:sectionIndex];
    
    if (section.footerHeight != NBTableViewSectionFooterHeightAutomatic) {
        return section.footerHeight;
    }
    
    if (section.footerView) {
        return section.footerView.frame.size.height;
    } else if (section.footerTitle.length) {
        if (self.tableView.style != UITableViewStyleGrouped) {
            return kSectionDefaultHeight;
        } else {
            CGFloat footerHeight = 0;
            CGFloat footerWidth = CGRectGetWidth(CGRectIntegral(tableView.bounds)) - 40.0f; // 40 = 20pt horizontal padding on each side
            
            CGSize footerRect = CGSizeMake(footerWidth, NBTableViewSectionFooterHeightAutomatic);
            
            CGRect footerFrame = [section.footerTitle boundingRectWithSize:footerRect
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                attributes:@{ NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote] }
                                                                   context:nil];
            
            footerHeight = footerFrame.size.height;
            
            return footerHeight + 10.0f;
        }
    }

    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]){
        return [self.delegate tableView:tableView heightForFooterInSection:sectionIndex];
    }
    return UITableViewAutomaticDimension;
}

// Estimated height support

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.mutableSections.count <= indexPath.section) {
        return UITableViewAutomaticDimension;
    }
    NBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    NBTableViewItem *item = [section.items objectAtIndex:indexPath.row];

    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:estimatedHeightForRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
    }
    
    if (tableView.rowHeight > 0) {
        return tableView.rowHeight;
    }
    
    if ([item.cellClass tableView:tableView heightForRowByItem:item] > 0) {
        return [item.cellClass tableView:tableView heightForRowByItem:item];
    }
    if (item.cellHeight > 0) {
        return item.cellHeight;
    }

    return UITableViewAutomaticDimension;
}

// Section header & footer information. Views are preferred over title should you decide to provide both

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex{
    if (self.mutableSections.count <= sectionIndex) {
        return nil;
    }
    NBTableViewSection *section = [self.mutableSections objectAtIndex:sectionIndex];

    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [self.delegate tableView:tableView viewForHeaderInSection:sectionIndex];
    }
    return section.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)sectionIndex{
    if (self.mutableSections.count <= sectionIndex) {
        return nil;
    }
    NBTableViewSection *section = [self.mutableSections objectAtIndex:sectionIndex];

    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [self.delegate tableView:tableView viewForFooterInSection:sectionIndex];
    }
    
    return section.footerView;
}

// Accessories (disclosures).

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    id item = [section.items objectAtIndex:indexPath.row];
    if ([item respondsToSelector:@selector(setAccessoryButtonTapHandler:)]) {
        NBTableViewItem *actionItem = (NBTableViewItem *)item;
        if (actionItem.accessoryButtonTapHandler)
            actionItem.accessoryButtonTapHandler(item);
    }
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)]){
        [self.delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

// Selection

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:)])
        return [self.delegate tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didHighlightRowAtIndexPath:)])
        [self.delegate tableView:tableView didHighlightRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didUnhighlightRowAtIndexPath:)])
        [self.delegate tableView:tableView didUnhighlightRowAtIndexPath:indexPath];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)])
        return [self.delegate tableView:tableView willSelectRowAtIndexPath:indexPath];
    
    return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)])
        return [self.delegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    id item = [section.items objectAtIndex:indexPath.row];
    if ([item respondsToSelector:@selector(setSelectionHandler:)]) {
        NBTableViewItem *actionItem = (NBTableViewItem *)item;
        if (actionItem.selectionHandler) {
            actionItem.selectionHandler(item);
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didSelectItem:rowAtIndexPath:)]) {
        [self.delegate tableView:tableView didSelectItem:item rowAtIndexPath:indexPath];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didSelectItem:cell:)]) {
        [self.delegate tableView:tableView didSelectItem:item cell:[tableView cellForRowAtIndexPath:indexPath]];
    }
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    // 马上恢复之前的颜色，并且不挡住分割线
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)])
        [self.delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

// Editing

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    NBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    NBTableViewItem *item = [section.items objectAtIndex:indexPath.row];
    
    if (![item isKindOfClass:[NBTableViewItem class]]){
        return UITableViewCellEditingStyleNone;
    }
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]){
        return [self.delegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }
    
    return item.editingStyle;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    NBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    NBTableViewItem *item = [section.items objectAtIndex:indexPath.row];
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)]){
        return [self.delegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }
    
    return item.deleteButtonTitle.length > 0 ? item.deleteButtonTitle : @"删除";
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)])
        return [self.delegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    
    return YES;
}

- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)])
        [self.delegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)])
        [self.delegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
}

// Moving/reordering

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    NBTableViewSection *sourceSection = [self.mutableSections objectAtIndex:sourceIndexPath.section];
    NBTableViewItem *item = [sourceSection.items objectAtIndex:sourceIndexPath.row];
    if (item.moveHandler) {
        BOOL allowed = item.moveHandler(item, sourceIndexPath, proposedDestinationIndexPath);
        if (!allowed)
            return sourceIndexPath;
    }
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)])
        return [self.delegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
    
    return proposedDestinationIndexPath;
}

// Indentation

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)])
        return [self.delegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    
    return 0;
}

// Copy/Paste.  All three methods must be implemented by the delegate.

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    NBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    id anItem = [section.items objectAtIndex:indexPath.row];
    if ([anItem respondsToSelector:@selector(setCopyHandler:)]) {
        NBTableViewItem *item = anItem;
        if (item.copyHandler || item.pasteHandler)
            return YES;
    }
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:)])
        return [self.delegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
    
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    NBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    id anItem = [section.items objectAtIndex:indexPath.row];
    if ([anItem respondsToSelector:@selector(setCopyHandler:)]) {
        NBTableViewItem *item = anItem;
        if (item.copyHandler && action == @selector(copy:))
            return YES;
        
        if (item.pasteHandler && action == @selector(paste:))
            return YES;
        
        if (item.cutHandler && action == @selector(cut:))
            return YES;
    }
    
    // Forward to UITableViewDelegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:)])
        return [self.delegate tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
    
    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    NBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    NBTableViewItem *item = [section.items objectAtIndex:indexPath.row];
    
    if (action == @selector(copy:)) {
        if (item.copyHandler)
            item.copyHandler(item);
    }
    
    if (action == @selector(paste:)) {
        if (item.pasteHandler)
            item.pasteHandler(item);
    }
    
    if (action == @selector(cut:)) {
        if (item.cutHandler)
            item.cutHandler(item);
    }
    
    // Forward to UITableView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:)])
        [self.delegate tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]){
        [self.delegate scrollViewDidScroll:self.tableView];
    }
//    if (self.dragRefreshEnable) {
//        [self.refreshView egoRefreshScrollViewDidScroll:scrollView];
//    }
//    if (self.loadMoreEnable) {
//        [self.loadMoreView loadMoreScrollViewDidScroll:scrollView];
//    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidZoom:)])
        [self.delegate scrollViewDidZoom:self.tableView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
        [self.delegate scrollViewWillBeginDragging:self.tableView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
        [self.delegate scrollViewWillEndDragging:self.tableView withVelocity:velocity targetContentOffset:targetContentOffset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate scrollViewDidEndDragging:self.tableView willDecelerate:decelerate];
    }
//    if (self.dragRefreshEnable) {
//        [self.refreshView egoRefreshScrollViewDidEndDragging:scrollView];
//    }
//    if (self.loadMoreEnable) {
//        [self.loadMoreView loadMoreScrollViewDidEndDragging:scrollView];
//    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
        [self.delegate scrollViewWillBeginDecelerating:self.tableView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
        [self.delegate scrollViewDidEndDecelerating:self.tableView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
        [self.delegate scrollViewDidEndScrollingAnimation:self.tableView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)])
        return [self.delegate viewForZoomingInScrollView:self.tableView];
    
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)])
        [self.delegate scrollViewWillBeginZooming:self.tableView withView:view];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)])
        [self.delegate scrollViewDidEndZooming:self.tableView withView:view atScale:scale];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)])
        return [self.delegate scrollViewShouldScrollToTop:self.tableView];
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidScrollToTop:)])
        [self.delegate scrollViewDidScrollToTop:self.tableView];
}

#pragma mark refresh & loadMore
- (void)headerRefresh{
    if ([self.delegate respondsToSelector:@selector(tableViewTriggerRefresh:)]) {
        [self.delegate tableViewTriggerRefresh:self.tableView];
    }
}

- (void)footerLoadMore{
    if ([self.delegate respondsToSelector:@selector(tableViewLoadMoreData:)]) {
        [self.delegate tableViewLoadMoreData:self.tableView];
    }
}

- (void)finishLoadingData{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - Managing sections

- (void)resetSections:(NSArray<NBTableViewSection*> *)sections{
    [self replaceSectionsWithSectionsFromArray:sections];
}

- (void)addSection:(NBTableViewSection *)section{
    section.tableViewAdaptor = self;
    [self.mutableSections addObject:section];
}

- (void)addSectionsFromArray:(NSArray<NBTableViewSection*> *)array{
    for (NBTableViewSection *section in array){
        section.tableViewAdaptor = self;
    }
    [self.mutableSections addObjectsFromArray:array];
}

- (void)insertSection:(NBTableViewSection *)section atIndex:(NSUInteger)index{
    section.tableViewAdaptor = self;
    [self.mutableSections insertObject:section atIndex:index];
}

- (void)insertSections:(NSArray<NBTableViewSection*> *)sections atIndexes:(NSIndexSet *)indexes{
    for (NBTableViewSection *section in sections){
        section.tableViewAdaptor = self;
    }
    [self.mutableSections insertObjects:sections atIndexes:indexes];
}

- (void)removeSection:(NBTableViewSection *)section{
    [self.mutableSections removeObject:section];
}

- (void)removeAllSections{
    [self.mutableSections removeAllObjects];
}

- (void)removeSectionIdenticalTo:(NBTableViewSection *)section inRange:(NSRange)range{
    [self.mutableSections removeObjectIdenticalTo:section inRange:range];
}

- (void)removeSectionIdenticalTo:(NBTableViewSection *)section{
    [self.mutableSections removeObjectIdenticalTo:section];
}

- (void)removeSectionsInArray:(NSArray<NBTableViewSection*> *)otherArray{
    [self.mutableSections removeObjectsInArray:otherArray];
}

- (void)removeSectionsInRange:(NSRange)range{
    [self.mutableSections removeObjectsInRange:range];
}

- (void)removeSection:(NBTableViewSection *)section inRange:(NSRange)range{
    [self.mutableSections removeObject:section inRange:range];
}

- (void)removeLastSection{
    [self.mutableSections removeLastObject];
}

- (void)removeSectionAtIndex:(NSUInteger)index{
    [self.mutableSections removeObjectAtIndex:index];
}

- (void)removeSectionsAtIndexes:(NSIndexSet *)indexes{
    [self.mutableSections removeObjectsAtIndexes:indexes];
}

- (void)replaceSectionAtIndex:(NSUInteger)index withSection:(NBTableViewSection *)section{
    section.tableViewAdaptor = self;
    [self.mutableSections replaceObjectAtIndex:index withObject:section];
}

- (void)replaceSectionsWithSectionsFromArray:(NSArray<NBTableViewSection*> *)otherArray{
    [self removeAllSections];
    [self addSectionsFromArray:otherArray];
}

- (void)replaceSectionsAtIndexes:(NSIndexSet *)indexes withSections:(NSArray<NBTableViewSection*> *)sections{
    for (NBTableViewSection *section in sections){
        section.tableViewAdaptor = self;
    }
    [self.mutableSections replaceObjectsAtIndexes:indexes withObjects:sections];
}

- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray<NBTableViewSection*> *)otherArray range:(NSRange)otherRange{
    for (NBTableViewSection *section in otherArray){
        section.tableViewAdaptor = self;
    }
    [self.mutableSections replaceObjectsInRange:range withObjectsFromArray:otherArray range:otherRange];
}

- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray<NBTableViewSection*> *)otherArray{
    [self.mutableSections replaceObjectsInRange:range withObjectsFromArray:otherArray];
}

- (void)exchangeSectionAtIndex:(NSUInteger)idx1 withSectionAtIndex:(NSUInteger)idx2{
    [self.mutableSections exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)sortSectionsUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context{
    [self.mutableSections sortUsingFunction:compare context:context];
}

- (void)sortSectionsUsingSelector:(SEL)comparator{
    [self.mutableSections sortUsingSelector:comparator];
}

#pragma mark - private mtthod
- (NSString *)identifierForCellAtIndexPath:(NSIndexPath *)indexPath{
    NBTableViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    NBTableViewItem *item = [section.items objectAtIndex:indexPath.row];
    NSString *cellIdentifier = [NSString stringWithFormat:@"NBTableViewAdaptor_%@", [item class]];
    if ([item respondsToSelector:@selector(cellIdentifier)] && item.cellIdentifier) {
        cellIdentifier = item.cellIdentifier;
    }
    return cellIdentifier;
}

#pragma mark - getter & setter
- (NSArray<NBTableViewSection*>  *)sections{
    return self.mutableSections;
}

- (NSMutableArray<NBTableViewSection*>  *)mutableSections{
    if (_mutableSections == nil) {
        _mutableSections = [NSMutableArray array];
    }
    return _mutableSections;
}

- (MJRefreshNormalHeader *)refreshView{
    if (_refreshView == nil) {
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
        _refreshView = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        
        // 设置文字
        [_refreshView setTitle:@"继续下拉刷新" forState:MJRefreshStateIdle];
        [_refreshView setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
        [_refreshView setTitle:@"正在加载 ..." forState:MJRefreshStateRefreshing];
        
        // 设置字体
        _refreshView.stateLabel.font = Normal_Font;
        _refreshView.lastUpdatedTimeLabel.font = Normal_Font;
        
        // 设置颜色
        _refreshView.stateLabel.textColor = COLOR_NORMAL_TEXT;
        _refreshView.lastUpdatedTimeLabel.textColor = COLOR_NORMAL_TEXT;
    }
    return _refreshView;
}

- (MJRefreshAutoFooter *)loadMoreView{
    if (_loadMoreView == nil) {
        _loadMoreView = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadMore)];
        
        // 设置文字
        [_loadMoreView setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
        [_loadMoreView setTitle:@"正在加载 ..." forState:MJRefreshStateRefreshing];
        [_loadMoreView setTitle:@"已经到底了" forState:MJRefreshStateNoMoreData];
        
        // 设置字体
        _loadMoreView.stateLabel.font = Normal_Font;
        
        // 设置颜色
        _loadMoreView.stateLabel.textColor = COLOR_NORMAL_TEXT;
    }
    return _loadMoreView;
}

- (void)setDragRefreshEnable:(BOOL)dragRefreshEnable
{
    _dragRefreshEnable = dragRefreshEnable;
    if (_dragRefreshEnable) {
        self.tableView.mj_header = self.refreshView;
    }else{
        self.tableView.mj_header = nil;
    }
}

- (void)setLoadMoreEnable:(BOOL)loadMoreEnable
{
    _loadMoreEnable = loadMoreEnable;
    if (_loadMoreEnable) {
        self.tableView.mj_footer = self.loadMoreView;
    }else{
        self.tableView.mj_footer = nil;
    }
}

@end
