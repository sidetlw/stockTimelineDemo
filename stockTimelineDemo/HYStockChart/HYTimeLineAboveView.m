//
//  HYTimeLineAboveView.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/8.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYTimeLineAboveView.h"
#import "HYTimeLineModel.h"
#import "HYStockChartConstant.h"
#import "HYTimeLineAbovePositionModel.h"
#import "HYTimeLine.h"
#import "Masonry.h"
#import "HYTimeLineGroupModel.h"
#import "UIColor+HYStockChart.h"
#import "NSDateFormatter+HYStockChart.h"
#import "HYStockChartGloablVariable.h"
#import "MJExtension.h"
#import "UIView+HXCircleAnimation.h"
#import "YYTimeLineMaskView.h"

#define currentDetailDataListWidth 100
#define currentContentOffset 10

@interface HYTimeLineAboveView()

@property(nonatomic,strong) NSArray *positionModels;

@property(nonatomic,strong) NSArray *colorModels;

@property(nonatomic,assign) CGFloat horizontalViewYPosition;

@property(nonatomic,strong) UIView *timeLabelView;

@property(nonatomic,strong) NSArray *timeLineModels;

@property(nonatomic,strong) UILabel *firstTimeLabel;

@property(nonatomic,strong) UILabel *secondTimeLabel;

@property(nonatomic,strong) UILabel *thirdTimeLabel;

@property(nonatomic,strong) UILabel *forthTimeLabel;

@property(nonatomic,strong) UILabel *fifthTimeLabel;

@property(nonatomic,strong) UILabel *sixthTimeLabel;

@property(nonatomic,assign) CGFloat offsetMaxPrice;

@property (nonatomic,strong)YYTimeLineMaskView *maskView;

@end

@implementation HYTimeLineAboveView

#pragma mark initWithFrame方法
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _positionModels = nil;
        _horizontalViewYPosition = 0;
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    if (!self.timeLineModels) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:46/255.0 green:50/255.0 blue:62/255.0 alpha:1.0].CGColor); //墨色
    CGContextFillRect(context, rect);
    
    //时间标题背景色
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, HYStockChartTimeLineAboveViewMaxY, self.frame.size.width, self.frame.size.height-HYStockChartTimeLineAboveViewMaxY));
    
    [self drawGridBackground:context rect:rect];

    
    HYTimeLine *timeLine = [[HYTimeLine alloc] initWithContext:context];
    //添加位置数组划线
    timeLine.positionModels = [self private_convertTimeLineModlesToPositionModel];
    timeLine.horizontalYPosition = self.horizontalViewYPosition;
    timeLine.timeLineViewWidth = self.frame.size.width;
    timeLine.timeLineViewMaxY = HYStockChartTimeLineAboveViewMaxY;
    [timeLine draw];
    [super drawRect:rect];
}

#pragma mark - **************** 画边框
- (void)drawGridBackground:(CGContextRef)context
                      rect:(CGRect)rect;
{
    UIColor * backgroundColor = [UIColor clearColor];
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    
    //画边框
//    CGContextSetLineWidth(context, HYStockChartTimeLineGridWidth);
//    CGContextSetStrokeColorWithColor(context, [UIColor gridLineColor].CGColor);
//    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width , HYStockChartTimeLineAboveViewMaxY));
    
    if (self.centerViewType == HYStockChartCenterViewTypeTimeLine)
    {
        //画时间分隔线
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - 130)/ 5.0;
        [self drawline:context startPoint:CGPointMake(25,  20) stopPoint:CGPointMake(25, HYStockChartKLineAboveViewMaxY ) color:[UIColor gridLineColor] lineWidth:HYStockChartTimeLineGridWidth];
        [self drawline:context startPoint:CGPointMake(25+width,  20) stopPoint:CGPointMake(25+width, HYStockChartKLineAboveViewMaxY ) color:[UIColor gridLineColor] lineWidth:HYStockChartTimeLineGridWidth];
        [self drawline:context startPoint:CGPointMake(25+ 2.0*width,  20) stopPoint:CGPointMake(25+2.0*width, HYStockChartKLineAboveViewMaxY ) color:[UIColor gridLineColor] lineWidth:HYStockChartTimeLineGridWidth];
        [self drawline:context startPoint:CGPointMake(25+ 3.0*width,  20) stopPoint:CGPointMake(25+3.0*width, HYStockChartKLineAboveViewMaxY ) color:[UIColor gridLineColor] lineWidth:HYStockChartTimeLineGridWidth];
        [self drawline:context startPoint:CGPointMake(25+ 4.0*width,  20) stopPoint:CGPointMake(25+4.0*width, HYStockChartKLineAboveViewMaxY ) color:[UIColor gridLineColor] lineWidth:HYStockChartTimeLineGridWidth];
//        [self drawline:context startPoint:CGPointMake(25+ 5.0*width,  20) stopPoint:CGPointMake(25+5.0*width, HYStockChartKLineAboveViewMaxY ) color:[UIColor gridLineColor] lineWidth:HYStockChartTimeLineGridWidth];
//        [self drawline:context startPoint:CGPointMake((rect.size.width ) / 2,  20) stopPoint:CGPointMake(rect.size.width / 2, HYStockChartKLineAboveViewMaxY ) color:[UIColor gridLineColor] lineWidth:HYStockChartTimeLineGridWidth];
    }
}

#pragma mark - **************** 绘制线
- (void)drawline:(CGContextRef)context
      startPoint:(CGPoint)startPoint
       stopPoint:(CGPoint)stopPoint
           color:(UIColor *)color
       lineWidth:(CGFloat)lineWitdth
{
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, lineWitdth);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, stopPoint.x,stopPoint.y);
    CGContextStrokePath(context);
}


#pragma mark - get&set方法
-(UIView *)timeLabelView
{
    if (!_timeLabelView) {
        _timeLabelView = [UIView new];
        [self addSubview:_timeLabelView];
        [_timeLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.width.left.equalTo(self);
            make.height.equalTo(@(HYStockChartTimeLineTimeLabelViewHeight));
        }];
        
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - 130)/ 5.0;
        self.firstTimeLabel = [self private_createTimeLabel];
        [_timeLabelView addSubview:self.firstTimeLabel];
        self.secondTimeLabel = [self private_createTimeLabel];
        [_timeLabelView addSubview:self.secondTimeLabel];
        self.thirdTimeLabel = [self private_createTimeLabel];
        [_timeLabelView addSubview:self.thirdTimeLabel];
        self.forthTimeLabel = [self private_createTimeLabel];
        [_timeLabelView addSubview:self.forthTimeLabel];
        self.fifthTimeLabel = [self private_createTimeLabel];
        [_timeLabelView addSubview:self.fifthTimeLabel];
        self.sixthTimeLabel = [self private_createTimeLabel];
        [_timeLabelView addSubview:self.sixthTimeLabel];
        
       
        [self.firstTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_timeLabelView.mas_top).offset(5);
            make.left.equalTo(_timeLabelView.mas_left).offset(20);
            make.height.equalTo(@(10));
//            make.width.equalTo(@(50));
        }];
        
        [self.secondTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(_timeLabelView.mas_centerX);
            make.left.equalTo(_timeLabelView.mas_left).offset(20 + width);
            make.top.height.equalTo(self.firstTimeLabel);
        }];
        
//        self.thirdTimeLabel.textAlignment = NSTextAlignmentRight;
        [self.thirdTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(_timeLabelView.mas_right).offset(25);
            make.left.equalTo(_timeLabelView.mas_left).offset(10 + 2.0 * width);
            make.top.height.width.equalTo(self.firstTimeLabel);
        }];
        
        [self.forthTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.right.equalTo(_timeLabelView.mas_right).offset(25);
            make.left.equalTo(_timeLabelView.mas_left).offset(20 + 3.0 * width);
            make.top.height.width.equalTo(self.firstTimeLabel);
        }];
        
        [self.fifthTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.right.equalTo(_timeLabelView.mas_right).offset(25);
            make.left.equalTo(_timeLabelView.mas_left).offset(20 + 4.0 * width);
            make.top.height.width.equalTo(self.firstTimeLabel);
        }];
        
        [self.sixthTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.right.equalTo(_timeLabelView.mas_right).offset(25);
            make.left.equalTo(_timeLabelView.mas_left).offset(20 + 5.0 * width);
            make.top.height.width.equalTo(self.firstTimeLabel);
        }];

        
    }
    
    NSString *firstTime = nil;
    NSString *secondTime = nil;
    NSString *thirdTime = nil;
    NSString *forthTime = nil;
    NSString *fifthTime = nil;
    NSString *sixthTime = nil;
    HYStockType stockType = [HYStockChartGloablVariable stockType];
    switch (stockType) {
        case HYStockTypeA:
            firstTime = @"10";
            secondTime = @"11";
            thirdTime = @"11:30/13";
            forthTime = @"14";
            fifthTime = @"15";
            sixthTime = @"16";
            break;
        case HYStockTypeUSA:
            firstTime = @"10";
            secondTime = @"11";
            thirdTime = @"12/13";
            forthTime = @"14";
            fifthTime = @"15";
            sixthTime = @"16";
            break;
        case HYStockTypeHK:
            
            break;
        default:
            break;
    }
    
    self.firstTimeLabel.text = firstTime;
    self.secondTimeLabel.text = secondTime;
    self.thirdTimeLabel.text = thirdTime;
    self.forthTimeLabel.text = forthTime;
    self.fifthTimeLabel.text = fifthTime;
    self.sixthTimeLabel.text = sixthTime;
    
    return _timeLabelView;
}

#pragma mark groupModel的set方法
-(void)setGroupModel:(HYTimeLineGroupModel *)groupModel
{
    _groupModel = groupModel;
    
    if (groupModel) {
        
        //先将groupModel里面的数组根据时间排序
        NSArray *timeLineModels = groupModel.timeModels;
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"MM-dd-yyyy";
        NSDateFormatter *timeFormatter = [NSDateFormatter new];
        timeFormatter.dateFormat = @"hh:mm:ss a";
        NSArray *newTimeLineModels = [timeLineModels sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            HYTimeLineModel *timeLineModel1 = (HYTimeLineModel *)obj1;
            HYTimeLineModel *timeLineModel2 = (HYTimeLineModel *)obj2;
            NSDate *date1 = [dateFormatter dateFromString:timeLineModel1.currentDate];
            NSDate *date2 = [dateFormatter dateFromString:timeLineModel2.currentDate];
            if ([date1 compare:date2] != NSOrderedSame) {
                return [date1 compare:date2];
            }else{
                date1 = [timeFormatter dateFromString:timeLineModel1.currentTime];
                date2 = [timeFormatter dateFromString:timeLineModel2.currentTime];
                return [date1 compare:date2];
            }
            return YES;
        }];
        
        self.timeLineModels = newTimeLineModels;
        _groupModel.timeModels = newTimeLineModels;
    }
}

#pragma mark - 公有方法
#pragma mark 画时分线的方法
-(void)drawAboveView
{
    NSAssert(self.timeLineModels, @"timeLineModels不能为空!");
    [self setNeedsDisplay];
}

-(void)drawBottomTimeLabel
{
    self.timeLabelView.backgroundColor = [UIColor clearColor];
}


#pragma mark - 私有方法
#pragma mark 将HYTimeLineModel转换成对应的position模型
-(NSArray *)private_convertTimeLineModlesToPositionModel
{
    NSAssert(self.timeLineModels, @"timeLineModels不能为空!");
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
    //1.算y轴的单元值
    HYTimeLineModel *firstModel = [self.timeLineModels firstObject];
    __block CGFloat minPrice = firstModel.currentPrice;
    __block CGFloat maxPrice = firstModel.currentPrice;
    //算出y轴单位值
    CGFloat yUnitValue = 0.0;
    CGFloat minY = HYStockChartTimeLineAboveViewMinY; //10
    CGFloat maxY = HYStockChartTimeLineAboveViewMaxY; //self.frame.size.height-19
    
    [self.timeLineModels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HYTimeLineModel *timeLineModel = (HYTimeLineModel *)obj;
        self.offsetMaxPrice = self.offsetMaxPrice >fabs(self.groupModel.lastDayEndPrice-timeLineModel.currentPrice)?self.offsetMaxPrice:fabs(self.groupModel.lastDayEndPrice-timeLineModel.currentPrice);
    }];
    
    maxPrice = self.groupModel.lastDayEndPrice + self.offsetMaxPrice;
    minPrice =self.groupModel.lastDayEndPrice - self.offsetMaxPrice;
//    [self drawRightMarkAtt:context maxPrice:maxPrice midPrice:self.groupModel.lastDayEndPrice minPrice:minPrice];   //画右边的最高值平均值和最低值
    
    yUnitValue = (maxPrice - minPrice)/(maxY-minY - currentContentOffset);
    
    //昨天最后价格点，画虚线的y点
    self.horizontalViewYPosition = (self.groupModel.lastDayEndPrice-minPrice)/yUnitValue + currentContentOffset;
    
    //2.算出x轴的单元值
    CGFloat xUnitValue = [self private_getXAxisUnitValue];
    
    //转换成posisiton的模型，为了不多遍历一次数组，在这里顺便把折线情况下的日期也设置一下
    NSMutableArray *positionArray = [NSMutableArray array];
    //颜色信息
    NSMutableArray *colorArray = [NSMutableArray array];
    NSInteger index = 0;
    
    CGFloat oldXPosition = -1;
    UIColor *color;
    for (HYTimeLineModel *timeLineModel in self.timeLineModels) {
        CGFloat xPosition = 0;
        CGFloat yPosition = 0;
        switch (self.centerViewType) {
            case HYStockChartCenterViewTypeTimeLine:
            {
                if (oldXPosition < 0) {
                    oldXPosition = 0;
                    xPosition = oldXPosition;
                }else{
                    //每2分钟一次数据
                    xPosition = oldXPosition+ xUnitValue * 2;
                    oldXPosition = xPosition;
                }
                yPosition = (maxY - (timeLineModel.currentPrice - minPrice)/yUnitValue - minY);
            }
                break;
            
            default:break;
        }
        
        if (index == 0)
        {
            if(timeLineModel.currentPrice >= self.groupModel.lastDayEndPrice)
            {
                color = [UIColor increaseColor];
            }
            else
            {
               color = [UIColor decreaseColor];
            }
        }
        else
        {
            HYTimeLineModel *lastTimeLineModel = self.timeLineModels[index - 1];
            if(timeLineModel.currentPrice >= lastTimeLineModel.currentPrice)
            {
                color = [UIColor increaseColor];
            }
            else
            {
                color = [UIColor decreaseColor];
            }
        }
        
        [colorArray addObject:color];
        
        index++;
        NSAssert(!isnan(xPosition)&&!isnan(yPosition), @"x或y出现NAN值!");
        HYTimeLineAbovePositionModel *positionModel = [HYTimeLineAbovePositionModel new];
        positionModel.currentPoint = CGPointMake(xPosition, yPosition);
        [positionArray addObject:positionModel];
    }
    _positionModels = positionArray;
    _colorModels = colorArray;
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(timeLineAboveView:positionModels:colorModels:)]) {
            [self.delegate timeLineAboveView:self positionModels:positionArray colorModels:colorArray];
        }
    }
    
    return positionArray;
}



#pragma mark - **************** 分时图右侧坐标值
- (void)drawRightMarkAtt:(CGContextRef)context maxPrice:(CGFloat)maxPrice midPrice:(CGFloat)midPrice minPrice:(CGFloat)minPrice   //已弃用
{
    // ------分时图右侧坐标值
    NSMutableAttributedString * rightMarkerMaxStrAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.02f",maxPrice] attributes:nil];
    CGSize currentXZuoBiaoSize = [rightMarkerMaxStrAtt size];
    [self drawLabel:context attributesText:rightMarkerMaxStrAtt rect:CGRectMake(HYStockChartTimeLineAboveViewMaxX - currentXZuoBiaoSize.width - 5, currentContentOffset, currentXZuoBiaoSize.width, currentXZuoBiaoSize.height)];
    
    NSMutableAttributedString * rightMarkerMidStrAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.02f",midPrice] attributes:nil];
    [self drawLabel:context attributesText:rightMarkerMidStrAtt rect:CGRectMake(HYStockChartTimeLineAboveViewMaxX - currentXZuoBiaoSize.width - 5, (HYStockChartTimeLineAboveViewMaxY  -currentXZuoBiaoSize.height) / 2 , currentXZuoBiaoSize.width, currentXZuoBiaoSize.height)];
    
    
    UIColor *color = [UIColor whiteColor]; // select needed color
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : color };
    NSMutableAttributedString * rightMarkerMinStrAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.02f",minPrice] attributes:attrs];
    [self drawLabel:context attributesText:rightMarkerMinStrAtt rect:CGRectMake(HYStockChartTimeLineAboveViewMaxX - currentXZuoBiaoSize.width - 5, HYStockChartTimeLineAboveViewMaxY - currentContentOffset - currentXZuoBiaoSize.height / 2, currentXZuoBiaoSize.width, currentXZuoBiaoSize.height)];

}

//画x轴坐标
- (void)drawLabel:(CGContextRef)context
   attributesText:(NSAttributedString *)attributesText
             rect:(CGRect)rect
{
    [attributesText drawInRect:rect];
    //[self drawRect:context rect:rect color:[UIColor clearColor]];
}

#pragma mark 创建时间的label
-(UILabel *)private_createTimeLabel
{
    UILabel *timeLabel = [UILabel new];
    timeLabel.font = [UIFont systemFontOfSize:11];
    timeLabel.textColor = [UIColor whiteColor]; //[UIColor colorWithRGBHex:0x2d333a];
    return timeLabel;
}

-(CGFloat)private_getXAxisUnitValue
{
    NSTimeInterval oneDayTradeTimes = [self private_oneDayTradeTimes];
    CGFloat xUnitValue = 0;
    //当天分时
    if (self.centerViewType == HYStockChartCenterViewTypeTimeLine) {
        xUnitValue = (HYStockChartTimeLineAboveViewMaxX-HYStockChartTimeLineAboveViewMinX)/oneDayTradeTimes;
        return xUnitValue;
    }
    return xUnitValue;
}


#pragma mark 一天的交易总时间，单位是分钟
-(CGFloat)private_oneDayTradeTimes
{
    HYStockType stockType = [HYStockChartGloablVariable stockType];
    switch (stockType) {
        case HYStockTypeA:
            //（9：30-11：30，13：00-15：00）
            return 240;
            break;
        case HYStockTypeUSA:
            //（9：30-16：00）
            return 390;
            break;
        default:
            //（9：30-12：00，13：00-16：00） hk 150+180 = 330
            return 330;
            break;
    }
}

@end
