//
//  FMTableViewAdaptor.m
//  FMTB
//
//  Created by 刘彬 on 16/9/20.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "FMTableViewAdaptor.h"
#import "FMTableViewSection.h"
#import "FMBaseCellModel.h"
#import "FMBaseTableViewCell.h"
#import "MJRefresh.h"

#define kSectionDefaultHeight (22)

@interface FMTableViewAdaptor ()

@property (nonatomic, strong) NSMutableArray<FMTableViewSection*> *sections;
@property (nonatomic, strong) MJRefreshNormalHeader       *refreshView;
@property (nonatomic, strong) MJRefreshAutoNormalFooter   *loadMoreView;

@end

@implementation FMTableViewAdaptor

- (void)dealloc{
    self.delegate = nil;
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

#pragma mark - Initializing method
- (id)init{
    // 因为adaptor必须依赖tableview，所以这里把init入口关闭,防止后面tableview空指针
    @throw [NSException exceptionWithName:NSGenericException reason:@"init not supported, use initWithTableView: instead." userInfo:nil];
    return nil;
}

- (id)initWithTableView:(UITableView *)tableView{
    self = [super init];
    if (self){
        tableView.delegate = self;
        tableView.dataSource = self;
        self.tableView = tableView;
        self.sections = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex{
    if (self.sections.count <= sectionIndex) {
        return 0;
    }
    return [self.sections objectAtIndex:sectionIndex].items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FMTableViewSection *section = [self.sections objectAtIndex:indexPath.section];
    FMBaseCellModel *cellModel = [section.items objectAtIndex:indexPath.row];
    // 注册cell
    Class cellClass = cellModel.cellClass;
    NSString *cellIdentifier = [self identifierForCellAtIndexPath:indexPath];
    if (cellModel.useNib == YES) {
        // dequeue时会调用 cell 的 -(void)awakeFromNib
        UINib *nib = [UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    } else {
        // dequeue时会调用 cell 的 - (id)initWithStyle:withReuseableCellIdentifier:
        [tableView registerClass:cellClass forCellReuseIdentifier:cellIdentifier];
    }
    /*
     * 注意：如为了兼容FDTemplateLayoutCell，必须要先注册cell
     * 使用dequeueReuseableCellWithIdentifier:可不注册，但是必须对获取回来的cell进行判断是否为空，若空则手动创建新的cell；
     * 使用dequeueReuseableCellWithIdentifier:forIndexPath:必须注册，但返回的cell可省略空值判断的步骤。
     */
    FMBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    // 这里再检查一下是否已经加载过cell
    if (!cell.loaded) {
        if ([self.delegate conformsToProtocol:@protocol(FMTableViewAdaptorDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willLoadCell:forRowAtIndexPath:)]){
            [self.delegate tableView:tableView willLoadCell:cell forRowAtIndexPath:indexPath];
        }
        
        [cell cellDidLoad];

        if ([self.delegate conformsToProtocol:@protocol(FMTableViewAdaptorDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didLoadCell:forRowAtIndexPath:)]){
            [self.delegate tableView:tableView didLoadCell:cell forRowAtIndexPath:indexPath];
        }
    }
    cell.parentTableView = tableView;
    cell.parentAdaptor = self;
    cell.parentsection = section;
    cell.object = cellModel;
    return cell;
}

#pragma mark - section config
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *titles;
    for (FMTableViewSection *section in self.sections) {
        if (section.indexTitle) {
            titles = [NSMutableArray array];
            break;
        }
    }
    if (titles) {
        for (FMTableViewSection *section in self.sections) {
            [titles addObject:section.indexTitle.length > 0 ? section.indexTitle : @""];
        }
    }
    
    return titles;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex{
    if (self.sections.count <= sectionIndex) {
        return nil;
    }
    FMTableViewSection *section = [self.sections objectAtIndex:sectionIndex];
    return section.headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)sectionIndex{
    if (self.sections.count <= sectionIndex) {
        return nil;
    }
    FMTableViewSection *section = [self.sections objectAtIndex:sectionIndex];
    return section.footerTitle;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex{
    if (self.sections.count <= sectionIndex) {
        return nil;
    }
    FMTableViewSection *section = [self.sections objectAtIndex:sectionIndex];
    
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [self.delegate tableView:tableView viewForHeaderInSection:sectionIndex];
    }
    return section.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)sectionIndex{
    if (self.sections.count <= sectionIndex) {
        return nil;
    }
    FMTableViewSection *section = [self.sections objectAtIndex:sectionIndex];
    
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [self.delegate tableView:tableView viewForFooterInSection:sectionIndex];
    }
    
    return section.footerView;
}

#pragma mark - move cell
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.sections.count <= indexPath.section) {
        return NO;
    }
    FMTableViewSection *section = [self.sections objectAtIndex:indexPath.section];
    FMBaseCellModel *cellModel = [section.items objectAtIndex:indexPath.row];
    return cellModel.moveHandler != nil;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    FMTableViewSection *sourceSection = [self.sections objectAtIndex:sourceIndexPath.section];
    FMBaseCellModel *cellModel = [sourceSection.items objectAtIndex:sourceIndexPath.row];
    [sourceSection removeItemAtIndex:sourceIndexPath.row];
    
    FMTableViewSection *destinationSection = [self.sections objectAtIndex:destinationIndexPath.section];
    [destinationSection insertItem:cellModel atIndex:destinationIndexPath.row];
    
    if (cellModel.moveCompletionHandler){
        cellModel.moveCompletionHandler(cellModel, sourceIndexPath, destinationIndexPath);
    }
}

#pragma mark - edit cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < [self.sections count]) {
        FMTableViewSection *section = [self.sections objectAtIndex:indexPath.section];
        if (indexPath.row < [section.items count]) {
            FMBaseCellModel *cellModel = [section.items objectAtIndex:indexPath.row];
            if ([cellModel isKindOfClass:[FMBaseCellModel class]]) {
                return cellModel.editingStyle != UITableViewCellEditingStyleNone || cellModel.moveHandler;
            }
        }
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    FMTableViewSection *section = [self.sections objectAtIndex:indexPath.section];
    FMBaseCellModel *cellModel = [section.items objectAtIndex:indexPath.row];
    // 删除
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // 先把cell删除
        [section removeItemAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        // 更新后面的cell的索引
        for (NSInteger i = indexPath.row; i < section.items.count; i++) {
            FMBaseCellModel *afterItem = [[section items] objectAtIndex:i];
            FMBaseTableViewCell *cell = (FMBaseTableViewCell *)[tableView cellForRowAtIndexPath:afterItem.indexPath];
            NSIndexPath *indexPath = cell.indexPath;
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
            afterItem.indexPath = newIndexPath;
            cell.indexPath = newIndexPath;
        }
        // 执行回调block
        if (cellModel.deletionHandler) {
            cellModel.deletionHandler(cellModel);
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:commitEditingStyle:forItem:atIndexPath:)]) {
        [self.delegate tableView:tableView commitEditingStyle:editingStyle forItem:cellModel atIndexPath:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    FMTableViewSection *section = [self.sections objectAtIndex:indexPath.section];
    FMBaseCellModel *cellModel = [section.items objectAtIndex:indexPath.row];
    
    if (![cellModel isKindOfClass:[FMBaseCellModel class]]){
        return UITableViewCellEditingStyleNone;
    }
    
    // Forward to UITableView delegate
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]){
        return [self.delegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }
    
    return cellModel.editingStyle;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    FMTableViewSection *section = [self.sections objectAtIndex:indexPath.section];
    FMBaseCellModel *cellModel = [section.items objectAtIndex:indexPath.row];
    // Forward to UITableView delegate
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)]){
        return [self.delegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }
    return cellModel.deleteButtonTitle.length > 0 ? cellModel.deleteButtonTitle : @"删除";
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    // Forward to UITableView delegate
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)])
    return [self.delegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    
    return YES;
}

- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    // Forward to UITableView delegate
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)])
    [self.delegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    // Forward to UITableView delegate
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)])
    [self.delegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
}

#pragma mark - display cell
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[FMBaseTableViewCell class]]) {
        [(FMBaseTableViewCell *)cell cellWillAppear];
    }
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [self.delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    if ([cell isKindOfClass:[FMBaseTableViewCell class]]) {
        [(FMBaseTableViewCell *)cell cellDidDisappear];
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

#pragma mark - height support
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FMTableViewSection *section = [self.sections objectAtIndex:indexPath.section];
    FMBaseCellModel *cellModel = [section.items objectAtIndex:indexPath.row];
    
    // 优先取cell内部计算的行高
    if ([cellModel.cellClass tableView:tableView heightForRowWithCellModel:cellModel] > 0) {
        return [cellModel.cellClass tableView:tableView heightForRowWithCellModel:cellModel];
    }

    // 再取cellModel设置的高度
    if (cellModel.cellHeight > 0) {
        return cellModel.cellHeight;
    }
    // 再取tableView统一设置的高度
    if (tableView.rowHeight > 0) {
        return tableView.rowHeight;
    }
    
    // 最后取VC计算的高度
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex{
    if (self.sections.count <= sectionIndex) {
        return 0;
    }
    FMTableViewSection *section = [self.sections objectAtIndex:sectionIndex];
    if (section.headerHeight != FMTableViewSectionHeaderHeightAutomatic) {
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
            
            CGSize headerRect = CGSizeMake(headerWidth,FMTableViewSectionHeaderHeightAutomatic);
            
            CGRect headerFrame = [section.headerTitle boundingRectWithSize:headerRect
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                attributes:@{ NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline] }
                                                                   context:nil];
            
            headerHeight = headerFrame.size.height;
            
            return headerHeight + 10.0f;
        }
    }
    
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]){
        return [self.delegate tableView:tableView heightForHeaderInSection:sectionIndex];
    }
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)sectionIndex{
    if (self.sections.count <= sectionIndex) {
        return 0;
    }
    FMTableViewSection *section = [self.sections objectAtIndex:sectionIndex];
    
    if (section.footerHeight != FMTableViewSectionFooterHeightAutomatic) {
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
            
            CGSize footerRect = CGSizeMake(footerWidth, FMTableViewSectionFooterHeightAutomatic);
            
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

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.sections.count <= indexPath.section) {
        return UITableViewAutomaticDimension;
    }
    FMTableViewSection *section = [self.sections objectAtIndex:indexPath.section];
    FMBaseCellModel *cellModel = [section.items objectAtIndex:indexPath.row];
    
    // 优先取cell内部计算的行高
    if ([cellModel.cellClass tableView:tableView heightForRowWithCellModel:cellModel] > 0) {
        return [cellModel.cellClass tableView:tableView heightForRowWithCellModel:cellModel];
    }
    
    // 再取cellModel设置的高度
    if (cellModel.cellHeight > 0) {
        return cellModel.cellHeight;
    }
    // 再取tableView统一设置的高度
    if (tableView.rowHeight > 0) {
        return tableView.rowHeight;
    }
    
    // 最后取VC计算的高度
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    return UITableViewAutomaticDimension;
}

#pragma mark - select cell
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    FMTableViewSection *section = [self.sections objectAtIndex:indexPath.section];
    id item = [section.items objectAtIndex:indexPath.row];
    if ([item respondsToSelector:@selector(setAccessoryButtonTapHandler:)]) {
        FMBaseCellModel *actionItem = (FMBaseCellModel *)item;
        if (actionItem.accessoryButtonTapHandler)
        actionItem.accessoryButtonTapHandler(item);
    }
    
    // Forward to UITableView delegate
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)]){
        [self.delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    // Forward to UITableView delegate
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:)])
    return [self.delegate tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    // Forward to UITableView delegate
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didHighlightRowAtIndexPath:)])
    [self.delegate tableView:tableView didHighlightRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    // Forward to UITableView delegate
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didUnhighlightRowAtIndexPath:)])
    [self.delegate tableView:tableView didUnhighlightRowAtIndexPath:indexPath];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Forward to UITableView delegate
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)])
    return [self.delegate tableView:tableView willSelectRowAtIndexPath:indexPath];
    
    return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Forward to UITableView delegate
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)])
    return [self.delegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FMTableViewSection *section = [self.sections objectAtIndex:indexPath.section];
    id item = [section.items objectAtIndex:indexPath.row];
    if ([item respondsToSelector:@selector(setSelectionHandler:)]) {
        FMBaseCellModel *actionItem = (FMBaseCellModel *)item;
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
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Forward to UITableView delegate
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)])
    [self.delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

// Moving/reordering
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    FMTableViewSection *sourceSection = [self.sections objectAtIndex:sourceIndexPath.section];
    FMBaseCellModel *cellModel = [sourceSection.items objectAtIndex:sourceIndexPath.row];
    if (cellModel.moveHandler) {
        BOOL allowed = cellModel.moveHandler(cellModel, sourceIndexPath, proposedDestinationIndexPath);
        if (!allowed)
        return sourceIndexPath;
    }
    
    // Forward to UITableView delegate
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)])
    return [self.delegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
    
    return proposedDestinationIndexPath;
}

// Indentation

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Forward to UITableView delegate
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)])
    return [self.delegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    
    return 0;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]){
        [self.delegate scrollViewDidScroll:self.tableView];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    // Forward to UIScrollView delegate
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidZoom:)])
    [self.delegate scrollViewDidZoom:self.tableView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // Forward to UIScrollView delegate
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
    [self.delegate scrollViewWillBeginDragging:self.tableView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    // Forward to UIScrollView delegate
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
    [self.delegate scrollViewWillEndDragging:self.tableView withVelocity:velocity targetContentOffset:targetContentOffset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    // Forward to UIScrollView delegate
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate scrollViewDidEndDragging:self.tableView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    // Forward to UIScrollView delegate
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
    [self.delegate scrollViewWillBeginDecelerating:self.tableView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // Forward to UIScrollView delegate
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
    [self.delegate scrollViewDidEndDecelerating:self.tableView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    // Forward to UIScrollView delegate
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
    [self.delegate scrollViewDidEndScrollingAnimation:self.tableView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    // Forward to UIScrollView delegate
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)])
    return [self.delegate viewForZoomingInScrollView:self.tableView];
    
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    // Forward to UIScrollView delegate
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)])
    [self.delegate scrollViewWillBeginZooming:self.tableView withView:view];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    // Forward to UIScrollView delegate
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)])
    [self.delegate scrollViewDidEndZooming:self.tableView withView:view atScale:scale];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    // Forward to UIScrollView delegate
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)])
    return [self.delegate scrollViewShouldScrollToTop:self.tableView];
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    // Forward to UIScrollView delegate
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
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

#pragma mark - Managing sections

- (void)resetSections:(NSArray<FMTableViewSection*> *)sections{
    [self replaceSectionsWithSectionsFromArray:sections];
}

- (void)addSection:(FMTableViewSection *)section{
    section.tableViewAdaptor = self;
    [self.sections addObject:section];
}

- (void)addSectionsFromArray:(NSArray<FMTableViewSection*> *)array{
    for (FMTableViewSection *section in array){
        section.tableViewAdaptor = self;
    }
    [self.sections addObjectsFromArray:array];
}

- (void)insertSection:(FMTableViewSection *)section atIndex:(NSUInteger)index{
    section.tableViewAdaptor = self;
    [self.sections insertObject:section atIndex:index];
}

- (void)insertSections:(NSArray<FMTableViewSection*> *)sections atIndexes:(NSIndexSet *)indexes{
    for (FMTableViewSection *section in sections){
        section.tableViewAdaptor = self;
    }
    [self.sections insertObjects:sections atIndexes:indexes];
}

- (void)removeSection:(FMTableViewSection *)section{
    [self.sections removeObject:section];
}

- (void)removeAllSections{
    [self.sections removeAllObjects];
}

- (void)removeSectionIdenticalTo:(FMTableViewSection *)section inRange:(NSRange)range{
    [self.sections removeObjectIdenticalTo:section inRange:range];
}

- (void)removeSectionIdenticalTo:(FMTableViewSection *)section{
    [self.sections removeObjectIdenticalTo:section];
}

- (void)removeSectionsInArray:(NSArray<FMTableViewSection*> *)otherArray{
    [self.sections removeObjectsInArray:otherArray];
}

- (void)removeSectionsInRange:(NSRange)range{
    [self.sections removeObjectsInRange:range];
}

- (void)removeSection:(FMTableViewSection *)section inRange:(NSRange)range{
    [self.sections removeObject:section inRange:range];
}

- (void)removeLastSection{
    [self.sections removeLastObject];
}

- (void)removeSectionAtIndex:(NSUInteger)index{
    [self.sections removeObjectAtIndex:index];
}

- (void)removeSectionsAtIndexes:(NSIndexSet *)indexes{
    [self.sections removeObjectsAtIndexes:indexes];
}

- (void)replaceSectionAtIndex:(NSUInteger)index withSection:(FMTableViewSection *)section{
    section.tableViewAdaptor = self;
    [self.sections replaceObjectAtIndex:index withObject:section];
}

- (void)replaceSectionsWithSectionsFromArray:(NSArray<FMTableViewSection*> *)otherArray{
    [self removeAllSections];
    [self addSectionsFromArray:otherArray];
}

- (void)replaceSectionsAtIndexes:(NSIndexSet *)indexes withSections:(NSArray<FMTableViewSection*> *)sections{
    for (FMTableViewSection *section in sections){
        section.tableViewAdaptor = self;
    }
    [self.sections replaceObjectsAtIndexes:indexes withObjects:sections];
}

- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray<FMTableViewSection*> *)otherArray range:(NSRange)otherRange{
    for (FMTableViewSection *section in otherArray){
        section.tableViewAdaptor = self;
    }
    [self.sections replaceObjectsInRange:range withObjectsFromArray:otherArray range:otherRange];
}

- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray<FMTableViewSection*> *)otherArray{
    [self.sections replaceObjectsInRange:range withObjectsFromArray:otherArray];
}

- (void)exchangeSectionAtIndex:(NSUInteger)idx1 withSectionAtIndex:(NSUInteger)idx2{
    [self.sections exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)sortSectionsUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context{
    [self.sections sortUsingFunction:compare context:context];
}

- (void)sortSectionsUsingSelector:(SEL)comparator{
    [self.sections sortUsingSelector:comparator];
}

#pragma mark - private mtthod
- (NSString *)identifierForCellAtIndexPath:(NSIndexPath *)indexPath{
    FMTableViewSection *section = [self.sections objectAtIndex:indexPath.section];
    FMBaseCellModel *cellModel = [section.items objectAtIndex:indexPath.row];
    NSString *cellIdentifier = [NSString stringWithFormat:@"FMTBCELL_%@", [cellModel.cellClass class]];
    if ([cellModel respondsToSelector:@selector(cellIdentifier)] && cellModel.cellIdentifier) {
        cellIdentifier = cellModel.cellIdentifier;
    }
    return cellIdentifier;
}

#pragma mark - getter & setter
- (MJRefreshNormalHeader *)refreshView{
    if (_refreshView == nil) {
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
        _refreshView = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        
        // 设置文字
        [_refreshView setTitle:@"继续下拉刷新" forState:MJRefreshStateIdle];
        [_refreshView setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
        [_refreshView setTitle:@"正在加载 ..." forState:MJRefreshStateRefreshing];
        
        // 设置字体
        _refreshView.stateLabel.font = [UIFont systemFontOfSize:14];
        _refreshView.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
        
        // 设置颜色
        _refreshView.stateLabel.textColor = [UIColor lightGrayColor];
        _refreshView.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
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
        _loadMoreView.stateLabel.font = [UIFont systemFontOfSize:14];
        
        // 设置颜色
        _loadMoreView.stateLabel.textColor = [UIColor lightGrayColor];
    }
    return _loadMoreView;
}

- (void)setDragRefreshEnable:(BOOL)dragRefreshEnable
{
    _dragRefreshEnable = dragRefreshEnable;
    if (_dragRefreshEnable) {
        self.tableView.header = self.refreshView;
    }else{
        self.tableView.header = nil;
    }
}

- (void)setLoadMoreEnable:(BOOL)loadMoreEnable
{
    _loadMoreEnable = loadMoreEnable;
    if (_loadMoreEnable) {
        self.tableView.footer = self.loadMoreView;
    }else{
        self.tableView.footer = nil;
    }
}

@end
