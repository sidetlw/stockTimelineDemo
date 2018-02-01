//
//  timelineViewController.m
//  stockTimelineDemo
//
//  Created by sidetang on 2017/5/9.
//  Copyright © 2017年 sidetang. All rights reserved.
//

#import "timelineViewController.h"
#import "HYStockChartView.h"
#import "HYStockChartProfileModel.h"
#import "JMSGroupTimeLineModel.h"
#import "JMSTimeLineModel.h"
#import "MJExtension.h"
#import "HYTimeLineModel.h"
#import "HYTimeLineGroupModel.h"


@interface timelineViewController ()<HYStockChartViewDataSource>
@property(nonatomic,strong) HYStockChartView *stockChartView;
@property(nonatomic,strong) JMSGroupTimeLineModel *groupTimeLineModel;
@end

@implementation timelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.stockChartView.backgroundColor = [UIColor lightGrayColor];
    [self setStockChartProfile];
    [self.stockChartView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setStockChartProfile
{
    HYStockChartProfileModel *profileModel = [HYStockChartProfileModel new];
    profileModel.Symbol = @"COMP.IND_GIDS";
    profileModel.Name = @"纳斯达克";
    profileModel.ChineseName = @"纳斯达克";
    profileModel.Volume = 20000000;
    profileModel.CurrentPrice = 5160.09;
    profileModel.applies = -003;
//    HYStockType stockType = HYStockTypeHK;
      HYStockType stockType = HYStockTypeUSA;
    profileModel.stockType = stockType;
    self.stockChartView.stockChartProfileModel = profileModel;
}

#pragma mark stockChartView的get方法
-(HYStockChartView *)stockChartView
{
    if (!_stockChartView) {
        _stockChartView = [HYStockChartView new];
        _stockChartView.itemModels = @[[HYStockChartViewItemModel itemModelWithTitle:@"时分" type:HYStockChartCenterViewTypeTimeLine]];
        _stockChartView.dataSource = self;
        [self.view addSubview:_stockChartView];
        CGSize size = self.view.bounds.size;
        _stockChartView.frame = CGRectMake(0, 100, size.width, 120);//self.view.bounds;
    }
    return _stockChartView;
}



#pragma mark - HYStockChartView的代理方法
#pragma mark 某个对应的Index需要展示的数据
-(id)stockDatasWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            //时分
            if (self.groupTimeLineModel.timeLineModels.count <= 0){
                [self event_timeLineRequestMethod];
            }
            
            if (self.groupTimeLineModel.timeLineModels.count > 0) {
                //先将jms转换成hy
                NSArray *jmsTimeLineDict = [JMSTimeLineModel keyValuesArrayWithObjectArray:self.groupTimeLineModel.timeLineModels];
                NSArray *hyTimeLineModels = [HYTimeLineModel objectArrayWithKeyValuesArray:jmsTimeLineDict];
                HYTimeLineGroupModel *hyTimeGroupModel = [HYTimeLineGroupModel new];
                hyTimeGroupModel.lastDayEndPrice = self.groupTimeLineModel.lastDayEndPrice;
                hyTimeGroupModel.timeModels = hyTimeLineModels;
                
                return hyTimeGroupModel;
            }
        break;
        default:
            break;
    }
    return nil;
}

#pragma mark 分时线数据请求方法
-(void)event_timeLineRequestMethod
{
    //加载假分时线数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TimeLine" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *datas = [dict objectForKey:@"Bars"];
    CGFloat PreClose = [[dict objectForKey:@"PreClose"] floatValue];
    if (!self.groupTimeLineModel) {
        self.groupTimeLineModel = [JMSGroupTimeLineModel new];
    }
    self.groupTimeLineModel.timeLineModels = [JMSTimeLineModel objectArrayWithKeyValuesArray:datas];
    self.groupTimeLineModel.lastDayEndPrice = PreClose;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
