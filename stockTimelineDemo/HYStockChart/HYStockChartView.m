//
//  HYStockChartView.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.

//  Date,Open,High,Low,Close,Volume,Adj Close

#import "HYStockChartView.h"
#import "Masonry.h"
#import "HYTimeLineView.h"
#import "HYTimeLineGroupModel.h"
#import "MJExtension.h"
#import "HYStockChartGloablVariable.h"
#import "HYStockChartProfileModel.h"
#import "HYStockChartConstant.h"

@interface HYStockChartView ()

@property(nonatomic,strong) HYTimeLineView *timeLineView;   //分时线view

@property(nonatomic,assign) HYStockChartCenterViewType currentCenterViewType;

@end

@implementation HYStockChartView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

#pragma mark timeLineView的get方法
-(HYTimeLineView *)timeLineView
{
    if (!_timeLineView) {
        _timeLineView = [HYTimeLineView new];
        _timeLineView.centerViewType = HYStockChartCenterViewTypeTimeLine;
        
        [self addSubview:_timeLineView];
       
        [_timeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.mas_top);
//            make.bottom.equalTo(self).offset(-10);
            make.height.mas_equalTo(120);
        }];
    }
    return _timeLineView;
}

#pragma mark - set方法
#pragma mark items的set方法
-(void)setItemModels:(NSArray *)itemModels
{
    _itemModels = itemModels;
    if (itemModels) {
        HYStockChartViewItemModel *firstModel = [itemModels firstObject];
        self.currentCenterViewType = firstModel.centerViewType;
    }
}

#pragma mark 设置股票简介模型
-(void)setStockChartProfileModel:(HYStockChartProfileModel *)stockChartProfileModel
{
    _stockChartProfileModel = stockChartProfileModel;
    [HYStockChartGloablVariable setStockChineseName:stockChartProfileModel.ChineseName.length > 0 ? stockChartProfileModel.ChineseName : stockChartProfileModel.Name];
   
    [HYStockChartGloablVariable setStockSymbol:stockChartProfileModel.Symbol];
    [HYStockChartGloablVariable setStockType:stockChartProfileModel.stockType];
}

#pragma mark dataSource的设置方法
-(void)setDataSource:(id<HYStockChartViewDataSource>)dataSource
{
    _dataSource = dataSource;
}

/**
 *  重新加载数据
 */
-(void)reloadData
{
//    self.segmentView.selectedIndex = self.segmentView.selectedIndex;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(stockDatasWithIndex:)]) {
        id stockData = [self.dataSource stockDatasWithIndex:0];
        
        if (stockData == nil) {
            return;
        }
        
        HYStockChartViewItemModel *itemModel = self.itemModels[0];
        HYStockChartCenterViewType type = itemModel.centerViewType;
        if (type != self.currentCenterViewType) {
            //移除原来的view，设置新的view
            self.currentCenterViewType = type;
//            if(HYStockChartCenterViewTypeTimeLine == type){
//                self.timeLineView.hidden = NO;
//            }else{
//                self.timeLineView.hidden = YES;
//            }
        }
        
        if (type == HYStockChartCenterViewTypeTimeLine) {
            NSAssert([stockData isKindOfClass:[HYTimeLineGroupModel class]], @"数据必须是HYTimeLineGroupModel类型!!!");
            HYTimeLineGroupModel *groupTimeLineModel = (HYTimeLineGroupModel *)stockData;
            if (type == HYStockChartCenterViewTypeTimeLine) {
                self.timeLineView.timeLineGroupModel = groupTimeLineModel;
                [self.timeLineView reDraw];
            }
        }
    }
}

@end


/************************ItemModel类************************/
@implementation HYStockChartViewItemModel
+(instancetype)itemModelWithTitle:(NSString *)title type:(HYStockChartCenterViewType)type
{
    HYStockChartViewItemModel *itemModel = [[HYStockChartViewItemModel alloc] init];
    itemModel.title = title;
    itemModel.centerViewType = type;
    return itemModel;
}
@end
