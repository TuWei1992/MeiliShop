//
//  MSReturnViewController.m
//  MeiliShop
//
//  Created by 2014-763 on 15/2/6.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MSReturnViewController.h"
#import "MSCellInfoModel.h"
#import "MSRefundListInfo.h"
#import "MSRefundInfo.h"
#import "MSRefundAddress.h"
#import "MSRefundGoods.h"
#import "MSRefundOrder.h"
#import "MSBuyer.h"

#import "MSOrderListInfoDescCell.h"
#import "MSOrderListItemDetailCell.h"
#import "MSOrderListFooterCell.h"
#import "MSRefundOrderListOperateCell.h"
#import "MSOrderListInfoTipCell.h"

#define kCellPartCount 4
#define kTopTabBarHeight 40
#define kChildVcCount 5

@interface MSReturnViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *cellInfos;
@property (nonatomic, strong) NSArray *cellInfos2;
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
static NSString *RefundOrderListOperateCellID = @"RefundOrderListOperateCell";
static NSString *OrderListInfoTipCellID = @"OrderListInfoTipCell";

@implementation MSReturnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置子控制器
    [self setUpChildVc];
    
    // 设置cellInfo
    [self setUpCellInfo];
}

- (void)setUpChildVc {
    [self addOneChildVc:[[UITableViewController alloc] init] title:@"待审核"];
    [self addOneChildVc:[[UITableViewController alloc] init] title:@"退款中"];
    [self addOneChildVc:[[UITableViewController alloc] init] title:@"已成功"];
    [self addOneChildVc:[[UITableViewController alloc] init] title:@"待发货"];
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
    MSCellInfoModel *cellInfoOperate = [MSCellInfoModel cellInfoWithNibName:@"MSRefundOrderListOperateCell" reuseIdentifier:RefundOrderListOperateCellID height:45];
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
    if (self.selectedIndex >= 3) {
        params[@"refund_status"] = @(self.selectedIndex+2);
    } else {
        params[@"refund_status"] = @(self.selectedIndex+1);
    }
    
    [self.mgr GET:@"http://shop-mobapi.bizfe.meilishuo.com/refund/list_info" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        MSRefundListInfo *listInfo = [MSRefundListInfo objectWithKeyValues:dict];
        
        [self.orders[self.selectedIndex] removeAllObjects];
        [self.orders[self.selectedIndex] addObjectsFromArray:listInfo.info];
        
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
    if (self.selectedIndex >= 3) {
        params[@"refund_status"] = @(self.selectedIndex+2);
    } else {
        params[@"refund_status"] = @(self.selectedIndex+1);
    }
    params[@"page"] = self.currentPages[self.selectedIndex];
    
    [self.mgr GET:@"http://shop-mobapi.bizfe.meilishuo.com/refund/list_info" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        MSRefundListInfo *listInfo = [MSRefundListInfo objectWithKeyValues:dict];
        [self.orders[self.selectedIndex] addObjectsFromArray:listInfo.info];
        
        self.maxPages[self.selectedIndex] = [NSNumber numberWithInteger:((listInfo.total_num - 1) / 10)];
        
        UITableViewController *selectedViewController = (UITableViewController *)self.selectedViewController;
        [selectedViewController.tableView reloadData];
        
        [selectedViewController.tableView footerEndRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MSLog(@"%@",error);
    }];
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


#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.orders[self.selectedIndex] count] * kCellPartCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MSCellInfoModel *cellInfo;
    if (self.selectedIndex == 0) {
        cellInfo = self.cellInfos[indexPath.row % kCellPartCount];
    } else {
        cellInfo = self.cellInfos2[indexPath.row % kCellPartCount];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInfo.reuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellInfo.nibName owner:self options:nil][0];
    }
    
    if ([cell isKindOfClass:[MSOrderListInfoDescCell class]]) {
        MSOrderListInfoDescCell *descCell = (MSOrderListInfoDescCell *)cell;
        descCell.refundInfo = self.orders[self.selectedIndex][indexPath.row / kCellPartCount];
    }
    if ([cell isKindOfClass:[MSOrderListItemDetailCell class]]) {
        MSOrderListItemDetailCell *detailCell = (MSOrderListItemDetailCell *)cell;
        MSRefundInfo *info = self.orders[self.selectedIndex][indexPath.row / kCellPartCount];
        detailCell.refundGoods = info.goods;
    }
    if ([cell isKindOfClass:[MSOrderListFooterCell class]]) {
        MSOrderListFooterCell *footerCell = (MSOrderListFooterCell *)cell;
        footerCell.refundInfo = self.orders[self.selectedIndex][indexPath.row / kCellPartCount];
    }
    if ([cell isKindOfClass:[MSOrderListInfoTipCell class]]) {
        MSOrderListInfoTipCell *tipCell = (MSOrderListInfoTipCell *)cell;
        switch (self.selectedIndex) {
            case 1:
                tipCell.refund_status = @"当前状态:退款处理中";
                break;
            case 2:
                tipCell.refund_status = @"当前状态:退款成功";
                break;
            case 3:
                tipCell.refund_status = @"当前状态:等待买家发货";
                break;
            case 4:
                tipCell.refund_status = @"当前状态:退款关闭";
                break;
            default:
                break;
        }
    }

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MSCellInfoModel *cellInfo;
    if (self.selectedIndex == 0) {
        cellInfo = self.cellInfos[indexPath.row % kCellPartCount];
    } else {
        cellInfo = self.cellInfos2[indexPath.row % kCellPartCount];
    }
    return cellInfo.height;
}

@end
