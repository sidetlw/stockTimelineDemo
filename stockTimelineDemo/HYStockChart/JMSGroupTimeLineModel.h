//
//  JMSGroupTimeLineModel.h
//  jimustock
//
//  Created by jimubox on 15/6/6.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JMSTimeLineModel;

@interface JMSGroupTimeLineModel : NSObject

/**
 *  服务器的数据是PreviousClose
 */
@property(nonatomic,assign) CGFloat lastDayEndPrice;

/**
 *  里面装的是JMSTimeLineModel
 */
@property(nonatomic,strong) NSArray<JMSTimeLineModel*> *timeLineModels;


@end
