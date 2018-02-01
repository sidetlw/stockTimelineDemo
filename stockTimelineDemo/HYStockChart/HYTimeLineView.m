//
//  HYTimeLineView.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/8.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYTimeLineView.h"
#import "HYTimeLineAboveView.h"
#import "Masonry.h"
#import "HYStockChartConstant.h"
#import "HYTimeLineAbovePositionModel.h"
#import "UIColor+HYStockChart.h"

#define kBtnTag 1000
@interface HYTimeLineView()<HYTimeLineAboveViewDelegate>

@property(nonatomic,strong) HYTimeLineAboveView *aboveView;
@property (nonatomic,strong) UIView *rightView;
@property (nonatomic,strong) UIView *lastLineView;


@property(nonatomic,strong) UIView *timeLineContainerView;

@property(nonatomic,strong) NSArray *timeLineModels;

@property(nonatomic,strong) UIView *verticalView;


@property (nonatomic,weak)UIButton *lastBtn;

//水平线
@property(nonatomic,strong) UIView *horizontalView;
@property(nonatomic,assign) CGFloat offsetMaxPrice;
@end

#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;
@implementation HYTimeLineView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.aboveViewRatio = 1.0;
    }
    return self;
}

-(UIView*)lastLineView
{
    if (!_lastLineView) {
        _lastLineView = [UIView new];
        _lastLineView.backgroundColor = [UIColor colorWithRGBHex:0x999999];
        [self.timeLineContainerView addSubview:_lastLineView];
        [_lastLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.aboveView.mas_right).offset(25);
            make.bottom.equalTo(self.aboveView.mas_bottom).offset(-19);
            make.top.equalTo(self.aboveView.mas_top).offset(20);
            make.width.mas_equalTo(0.5);
        }];
        
       UIView* _lastLineView2 = [UIView new];
        _lastLineView2.backgroundColor = [UIColor colorWithRGBHex:0x999999];
        [self.timeLineContainerView addSubview:_lastLineView2];
        [_lastLineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.aboveView.mas_right).offset(35);
            make.bottom.equalTo(self.aboveView.mas_bottom).offset(-19);
            make.top.equalTo(self.aboveView.mas_top).offset(20);
            make.width.mas_equalTo(0.5);
        }];
        
        UIView* _lastLineViewBottom = [UIView new];
        _lastLineViewBottom.backgroundColor = [UIColor colorWithRGBHex:0x999999];
        [self.timeLineContainerView addSubview:_lastLineViewBottom];
        [_lastLineViewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.aboveView.mas_left);
            make.bottom.equalTo(self.aboveView.mas_bottom).offset(-19);
            make.right.equalTo(self.rightView.mas_right);
            make.height.mas_equalTo(0.5);
        }];

    }
    return _lastLineView;
}

#pragma mark- 右边3个最高平均和最低值
-(UIView* )rightView
{
    if (!_rightView) {
        _rightView = [UIView new];
        _rightView.backgroundColor = [UIColor clearColor];
        [self.timeLineContainerView addSubview:_rightView];
        [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.aboveView.mas_right).offset(40);
            make.top.equalTo(self.aboveView.mas_top);
            make.bottom.equalTo(self.aboveView.mas_bottom).offset(-20);
            make.width.mas_equalTo(31.0);
//            make.right.equalTo(self.timeLineContainerView).offset(-20).priorityMedium();
//            make.height.equalTo(self.aboveView);
        }];
        
        [self.timeLineGroupModel.timeModels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            HYTimeLineModel *timeLineModel = (HYTimeLineModel *)obj;
            self.offsetMaxPrice = self.offsetMaxPrice >fabs(self.timeLineGroupModel.lastDayEndPrice-timeLineModel.currentPrice)?self.offsetMaxPrice:fabs(self.timeLineGroupModel.lastDayEndPrice-timeLineModel.currentPrice);
        }];

        CGFloat maxPrice = self.timeLineGroupModel.lastDayEndPrice + self.offsetMaxPrice;
        CGFloat minPrice =self.timeLineGroupModel.lastDayEndPrice - self.offsetMaxPrice;
        CGFloat middlePrice = self.timeLineGroupModel.lastDayEndPrice;
        
        
        UILabel* highLabel = [UILabel new];
        highLabel.text = [NSString stringWithFormat:@"%.02f",maxPrice];
        highLabel.textColor = [UIColor whiteColor];
        highLabel.font = [highLabel.font fontWithSize:10.0];
        [_rightView addSubview:highLabel];
        [highLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_rightView.mas_top).offset(23);
            make.left.equalTo(_rightView.mas_left);
        }];
        
        UILabel* middleLabel = [UILabel new];
        middleLabel.text = [NSString stringWithFormat:@"%.02f",middlePrice];
        middleLabel.textColor = [UIColor whiteColor];
        middleLabel.font = [middleLabel.font fontWithSize:10.0];
        [_rightView addSubview:middleLabel];
        [middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_rightView.mas_centerY).offset(10);
            make.left.equalTo(_rightView.mas_left);
        }];
        
        UILabel* lowLabel = [UILabel new];
        lowLabel.text = [NSString stringWithFormat:@"%.02f",minPrice];
        lowLabel.textColor = [UIColor whiteColor];
        lowLabel.font = [lowLabel.font fontWithSize:10.0];
        [_rightView addSubview:lowLabel];
        [lowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_rightView.mas_bottom);
            make.left.equalTo(_rightView.mas_left);
        }];
    }
    return _rightView;
}

#pragma mark set&get方法
#pragma mark aboveView的get方法
-(HYTimeLineAboveView *)aboveView
{
    if (!_aboveView) {
        _aboveView = [HYTimeLineAboveView new];
        _aboveView.delegate = self;
        //  _aboveView.delegate = self.belowView;
        [self.timeLineContainerView addSubview:_aboveView];
        [_aboveView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo (self.timeLineContainerView).offset(30);
            make.top.equalTo(self.timeLineContainerView);
            make.right.equalTo(self.timeLineContainerView).offset(-100).priorityMedium();
            //            make.right.equalTo(self.timeLineContainerView);
            make.height.equalTo(self.timeLineContainerView).multipliedBy(self.aboveViewRatio);
        }];
    }
    return _aboveView;
}
#pragma mark timeLineContainerView的get方法
-(UIView *)timeLineContainerView
{
    if (!_timeLineContainerView) {
        _timeLineContainerView = [UIView new];
        [self addSubview:_timeLineContainerView];
        [_timeLineContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.right.equalTo(self).offset(0);
            make.height.equalTo(self);
        }];
    }
    _timeLineContainerView.backgroundColor = [UIColor colorWithRed:46/255.0 green:50/255.0 blue:62/255.0 alpha:1.0];
    return _timeLineContainerView;
}

#pragma mark - 模型设置方法
#pragma mark aboveViewRatio设置方法
-(void)setAboveViewRatio:(CGFloat)aboveViewRatio
{
    _aboveViewRatio = aboveViewRatio;
    [_aboveView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self).multipliedBy(_aboveViewRatio);
    }];
//    [_belowView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(self).multipliedBy(1-_aboveViewRatio);
//    }];
}

#pragma mark timeLineModels的设置方法
-(void)setTimeLineGroupModel:(HYTimeLineGroupModel *)timeLineGroupModel
{
    _timeLineGroupModel = timeLineGroupModel;
    if (timeLineGroupModel) {
        self.timeLineModels = timeLineGroupModel.timeModels;
        self.aboveView.groupModel = timeLineGroupModel;
    }
}

-(void)setCenterViewType:(HYStockChartCenterViewType)centerViewType
{
    _centerViewType = centerViewType;
    self.aboveView.centerViewType = centerViewType;
}


- (void)scrollTradeContentClick:(UIButton *)sender
{
    self.lastBtn.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
     sender.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    self.lastBtn = sender;
    
}

#pragma mark - 公共方法
#pragma mark 重绘
-(void)reDraw
{
    [self.aboveView drawAboveView];
    [self.aboveView drawBottomTimeLabel];
    [self rightView];
    [self lastLineView];
}



#pragma mark - HYTimeLineAboveViewDelegate代理方法
//绘制线面的成交量图
-(void)timeLineAboveView:(UIView *)timeLineAboveView positionModels:(NSArray *)positionModels colorModels:(NSArray *)colorModels
{
    NSMutableArray *xPositionArr = [NSMutableArray array];
    for (HYTimeLineAbovePositionModel *positionModel in positionModels) {
        [xPositionArr addObject:[NSNumber numberWithFloat:positionModel.currentPoint.x]];
    }
}
@end
