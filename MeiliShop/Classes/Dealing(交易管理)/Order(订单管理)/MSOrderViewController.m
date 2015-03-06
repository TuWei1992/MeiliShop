//
//  MSOrderViewController.m
//  MeiliShop
//
//  Created by 2014-763 on 15/2/9.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MSOrderViewController.h"
#import "MSCellInfoModel.h"
#import "MSListInfo.h"
#import "MSInfo.h"
#import "MSAddress.h"
#import "MSGoods.h"
#import "MSOrder.h"
#import "MSUserInfo.h"

#import "MSOrderListInfoDescCell.h"
#import "MSOrderListItemDetailCell.h"
#import "MSOrderListOperateCell.h"
#import "MSOrderListFooterCell.h"
#import "MSOrderListInfoTipCell.h"

#define kCellPartCount 4
#define kTopTabBarHeight 40
#define kChildVcCount 5

@interface MSOrderViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *cellInfos;
@property (nonatomic, strong) NSArray *cellInfos2;
@property (nonatomic, strong) NSMutableArray *currentCellInfos;
@property (nonatomic, strong) AFHTTPRequestOperationManager *mgr;
@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, strong) NSMutableArray *loadState;
@property (nonatomic, strong) NSMutableArray *noOrdersViews;
@property (nonatomic, strong) NSMutableArray *showedNoOrdersState;
@property (nonatomic, strong) NSMutableArray *currentPages;
@property (nonatomic, strong) NSMutableArray *maxPages;
@end

static NSString *OrderListInfoDescCellID = @"OrderListInfoDescCell";
static NSString *OrderListItemDetailCellID = @"OrderListItemDetailCell";
static NSString *OrderListFooterCellID = @"OrderListFooterCell";
static NSString *OrderListOperateCellID = @"OrderListOperateCell";
static NSString *OrderListInfoTipCellID = @"OrderListInfoTipCell";

@implementation MSOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置子控制器
    [self setUpChildVc];

    // 设置cellInfo
    [self setUpCellInfo];
}

- (void)setUpChildVc {
    [self addOneChildVc:[[UITableViewController alloc] init] title:@"待付款"];
    [self addOneChildVc:[[UITableViewController alloc] init] title:@"待发货"];
    [self addOneChildVc:[[UITableViewController alloc] init] title:@"待收货"];
    [self addOneChildVc:[[UITableViewController alloc] init] title:@"已完成"];
    [self addOneChildVc:[[UITableViewController alloc] init] title:@"已关闭"];
}

- (void)addOneChildVc:(UIViewController *)vc title:(NSString *)title {
    // 添加拖拽刷新
    UITableViewController *tableVc = (UITableViewController *)vc;
    [tableVc.tableView addHeaderWithTarget:self action:@selector(loadNewOrder)];
    [tableVc.tableView addFooterWithTarget:self action:@selector(loadMoreOrder)];
    
    vc.tabBarItem.title = title;
    [self addChildViewController:vc];
}


- (void)setUpCellInfo {
    MSCellInfoModel *cellInfoDesc = [MSCellInfoModel cellInfoWithNibName:@"MSOrderListInfoDescCell" reuseIdentifier:OrderListInfoDescCellID height:45];
    MSCellInfoModel *cellInfoDetail = [MSCellInfoModel cellInfoWithNibName:@"MSOrderListItemDetailCell" reuseIdentifier:OrderListItemDetailCellID height:100];
    MSCellInfoModel *cellInfoFooter = [MSCellInfoModel cellInfoWithNibName:@"MSOrderListFooterCell" reuseIdentifier:OrderListFooterCellID height:30];
    MSCellInfoModel *cellInfoOperate = [MSCellInfoModel cellInfoWithNibName:@"MSOrderListOperateCell" reuseIdentifier:OrderListOperateCellID height:45];
    MSCellInfoModel *cellInfoTip = [MSCellInfoModel cellInfoWithNibName:@"MSOrderListInfoTipCell" reuseIdentifier:OrderListInfoTipCellID height:35];
    self.cellInfos = @[cellInfoDesc, cellInfoDetail, cellInfoFooter, cellInfoOperate];
    self.cellInfos2 = @[cellInfoDesc, cellInfoDetail, cellInfoFooter, cellInfoTip];
    
    for (UITableViewController *childVc in self.childViewControllers) {
        for (MSCellInfoModel *cellInfo in self.cellInfos) {
            [[childVc tableView] registerNib:[UINib nibWithNibName:cellInfo.nibName bundle:nil] forCellReuseIdentifier:cellInfo.reuseIdentifier];
        }
        for (MSCellInfoModel *cellInfo in self.cellInfos2) {
            [[childVc tableView] registerNib:[UINib nibWithNibName:cellInfo.nibName bundle:nil] forCellReuseIdentifier:cellInfo.reuseIdentifier];
        }
    }
}


- (void)loadNewOrder {
    if ([self.currentPages[self.selectedIndex] integerValue] != 0) {
        self.currentPages[self.selectedIndex] = [NSNumber numberWithInteger:0];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"status"] = @(self.selectedIndex+1);
    
    [self.mgr GET:@"http://shop-mobapi.bizfe.meilishuo.com/order/list_info" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        MSListInfo *listInfo = [MSListInfo objectWithKeyValues:dict];
        
        [self.orders[self.selectedIndex] removeAllObjects];
        [self.orders[self.selectedIndex] addObjectsFromArray:listInfo.info];
        
        // 设置所有的cell信息
        [self.currentCellInfos[self.selectedIndex] removeAllObjects];
        [self setUpCurrentCellInfos];
        
        self.maxPages[self.selectedIndex] = [NSNumber numberWithInteger:((listInfo.total_num - 1) / 10)];
        
        UITableViewController *selectedViewController = (UITableViewController *)self.selectedViewController;
        [selectedViewController.tableView reloadData];
        
        [selectedViewController.tableView headerEndRefreshing];
        
        if ([self.orders[self.selectedIndex] count] == 0 && ![self.showedNoOrdersState[self.selectedIndex] boolValue]) { // 没有订单, 并且没有显示提示视图
            UITableViewController *selectedViewController = (UITableViewController *)self.selectedViewController;
            UIView *noOrderView = [[NSBundle mainBundle] loadNibNamed:@"Order" owner:nil options:nil][0];
            [selectedViewController.tableView addSubview:noOrderView];
            [noOrderView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(selectedViewController.tableView).with.offset(0);
                make.centerY.equalTo(selectedViewController.tableView).with.offset(-24.5);
                make.height.mas_equalTo(245);
                make.width.mas_equalTo(200);
            }];
            self.noOrdersViews[self.selectedIndex] = noOrderView;
            self.showedNoOrdersState[self.selectedIndex] = @(YES);
            selectedViewController.tableView.footerHidden = YES;
        } else {
            if ([self.orders[self.selectedIndex] count] != 0) {
                [self.noOrdersViews[self.selectedIndex] removeFromSuperview];
                self.showedNoOrdersState[self.selectedIndex] = @(NO);
                selectedViewController.tableView.footerHidden = NO;
                if ([self.maxPages[self.selectedIndex] integerValue] == 0) {
                    selectedViewController.tableView.footerHidden = YES;
                } else {
                    selectedViewController.tableView.footerHidden = NO;
                }
            }
        }

     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MSLog(@"%@",error);
     }];
}


- (void)loadMoreOrder {
    UITableViewController *selectedViewController = (UITableViewController *)self.selectedViewController;
    NSInteger currentPage = [self.currentPages[self.selectedIndex] integerValue];
    self.currentPages[self.selectedIndex] = [NSNumber numberWithInteger:++currentPage];
    if (self.maxPages[self.selectedIndex] == self.currentPages[self.selectedIndex]) {
        selectedViewController.tableView.footerHidden = YES;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"status"] = @(self.selectedIndex+1);
    params[@"page"] = self.currentPages[self.selectedIndex];
    
    [self.mgr GET:@"http://shop-mobapi.bizfe.meilishuo.com/order/list_info" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        MSListInfo *listInfo = [MSListInfo objectWithKeyValues:dict];
        [self.orders[self.selectedIndex] addObjectsFromArray:listInfo.info];
        
        // 设置所有的cell信息
        [self.currentCellInfos[self.selectedIndex] removeAllObjects];
        [self setUpCurrentCellInfos];

        self.maxPages[self.selectedIndex] = [NSNumber numberWithInteger:((listInfo.total_num - 1) / 10)];

        UITableViewController *selectedViewController = (UITableViewController *)self.selectedViewController;
        [selectedViewController.tableView reloadData];
        
        [selectedViewController.tableView footerEndRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MSLog(@"%@",error);
    }];
}

- (void)setUpCurrentCellInfos {
    NSArray *cellInfo;
    if (self.selectedIndex < 3) {
        cellInfo = self.cellInfos;
    } else {
        cellInfo = self.cellInfos2;
    }
    for (MSInfo *info in self.orders[self.selectedIndex]) {
        [self.currentCellInfos[self.selectedIndex] addObject:cellInfo[0]];
        for (int i = 0; i < info.goods.count; i++) {
            [self.currentCellInfos[self.selectedIndex] addObject:cellInfo[1]];
        }
        [self.currentCellInfos[self.selectedIndex] addObject:cellInfo[2]];
        [self.currentCellInfos[self.selectedIndex] addObject:cellInfo[3]];
    }
}

// 传入indexPath.row,返回当前cell的订单在数组中的下标
- (NSInteger)indexOfOrders:(NSInteger)row {
    NSInteger temp = 0;
    NSInteger index = 0;
    for (MSInfo *info in self.orders[self.selectedIndex]) {
        temp += 3;
        for (int i = 0; i < info.goods.count; i++) {
            temp += 1;
        }
        if (row < temp) {
            break;
        }
        index++;
    }
    return index;
}

// 传入indexPath.row,返回当前goodsCell在goods数组中的下标
- (NSInteger)indexOfGoods:(NSInteger)row {
    NSInteger temp = 0;
    NSInteger temp2 = 0;
    NSInteger index = 0;
    for (MSInfo *info in self.orders[self.selectedIndex]) {
        temp2 = temp;
        temp += 3;
        for (int i = 0; i < info.goods.count; i++) {
            temp += 1;
        }
        if (row < temp) {
            break;
        }
    }
    index = row - (temp2+1);
    return index;
}


- (void)clickWithAnimation:(UIButton *)buttonItem {
    [super clickWithAnimation:buttonItem];
    
    // 复位
    UITableViewController *selectedViewController = (UITableViewController *)self.selectedViewController;
    selectedViewController.tableView.contentOffset = CGPointMake(0, 0);
    
    // 第一次载入时自动加载数据
    if ([self.loadState[buttonItem.tag] boolValue] == NO) {
        UITableViewController *selectedViewController = (UITableViewController *)self.selectedViewController;
        [selectedViewController.tableView headerBeginRefreshing];
        self.loadState[buttonItem.tag] = @(YES);
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)maxPages {
    if (!_maxPages) {
        _maxPages = [NSMutableArray array];
        for (int i = 0; i < kChildVcCount; i++) {
            NSInteger maxPages = 0;
            [_maxPages addObject:@(maxPages)];
        }
    }
    return _maxPages;
}

- (NSMutableArray *)currentPages {
    if (!_currentPages) {
        _currentPages = [NSMutableArray array];
        for (int i = 0; i < kChildVcCount; i++) {
            NSInteger currentPage = 0;
            [_currentPages addObject:@(currentPage)];
        }
    }
    return _currentPages;
}

- (NSMutableArray *)showedNoOrdersState {
    if (!_showedNoOrdersState) {
        _showedNoOrdersState = [NSMutableArray array];
        for (int i = 0; i < kChildVcCount; i++) {
            BOOL showedNoOrdersState = NO;
            [_showedNoOrdersState addObject:@(showedNoOrdersState)];
        }
    }
    return _showedNoOrdersState;
}

- (NSMutableArray *)noOrdersViews {
    if (!_noOrdersViews) {
        _noOrdersViews = [NSMutableArray array];
        for (int i = 0; i < kChildVcCount; i++) {
            [_noOrdersViews addObject:[[UIView alloc] init]];
        }
    }
    return _noOrdersViews;
}

- (NSMutableArray *)orders {
    if (!_orders) {
        _orders = [NSMutableArray array];
        for (int i = 0; i < kChildVcCount; i++) {
            [_orders addObject:[NSMutableArray array]];
        }
    }
    return _orders;
}

- (NSMutableArray *)loadState {
    if (!_loadState) {
        _loadState = [NSMutableArray array];
        for (int i = 0; i < kChildVcCount; i++) {
            BOOL loadState = NO;
            [_loadState addObject:@(loadState)];
        }
    }
    return _loadState;
}

- (AFHTTPRequestOperationManager *)mgr {
    if (!_mgr) {
        _mgr = [AFHTTPRequestOperationManager manager];
        _mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
        _mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _mgr;
}

- (NSArray *)cellInfos {
    if (!_cellInfos) {
        _cellInfos = [NSArray array];
    }
    return _cellInfos;
}

- (NSArray *)cellInfos2 {
    if (!_cellInfos2) {
        _cellInfos2 = [NSArray array];
    }
    return _cellInfos2;
}

- (NSMutableArray *)currentCellInfos {
    if (!_currentCellInfos) {
        _currentCellInfos = [NSMutableArray array];
        for (int i = 0; i < kChildVcCount; i++) {
            [_currentCellInfos addObject:[NSMutableArray array]];
        }
    }
    return _currentCellInfos;
}


#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.currentCellInfos[self.selectedIndex] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MSCellInfoModel *cellInfo = self.currentCellInfos[self.selectedIndex][indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInfo.reuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellInfo.nibName owner:self options:nil][0];
    }
    
    if ([cell isKindOfClass:[MSOrderListInfoDescCell class]]) {
        MSOrderListInfoDescCell *descCell = (MSOrderListInfoDescCell *)cell;
        descCell.info = self.orders[self.selectedIndex][[self indexOfOrders:indexPath.row]];
    }
    if ([cell isKindOfClass:[MSOrderListItemDetailCell class]]) {
        MSOrderListItemDetailCell *detailCell = (MSOrderListItemDetailCell *)cell;
        MSInfo *info = self.orders[self.selectedIndex][[self indexOfOrders:indexPath.row]];
        
        detailCell.goods = info.goods[[self indexOfGoods:indexPath.row]];
    }
    if ([cell isKindOfClass:[MSOrderListFooterCell class]]) {
        MSOrderListFooterCell *showMoreCell = (MSOrderListFooterCell *)cell;
        showMoreCell.info = self.orders[self.selectedIndex][[self indexOfOrders:indexPath.row]];
    }
    if ([cell isKindOfClass:[MSOrderListOperateCell class]]) {
        MSOrderListOperateCell *operateCell = (MSOrderListOperateCell *)cell;
        operateCell.info = self.orders[self.selectedIndex][[self indexOfOrders:indexPath.row]];
    }
    
    if ([cell isKindOfClass:[MSOrderListOperateCell class]]) {
        if (self.selectedIndex == 3 ||self.selectedIndex == 4) {
            [(MSOrderListOperateCell *)cell button].hidden = YES;
        } else {
            [(MSOrderListOperateCell *)cell button].hidden = NO;
            NSArray *titles = @[@"通知付款", @"发货", @"提醒收货"];
            [[(MSOrderListOperateCell *)cell button] setTitle:titles[self.selectedIndex] forState:UIControlStateNormal];
        }
    }
    if ([cell isKindOfClass:[MSOrderListInfoTipCell class]]) {
        MSOrderListInfoTipCell *tipCell = (MSOrderListInfoTipCell *)cell;
        switch (self.selectedIndex) {
            case 3:
                tipCell.refund_status = @"当前状态:已完成";
                break;
            case 4:
                tipCell.refund_status = @"当前状态:已关闭";
                break;
            default:
                break;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MSCellInfoModel *cellInfo = self.currentCellInfos[self.selectedIndex][indexPath.row];
    return cellInfo.height;
}

@end
