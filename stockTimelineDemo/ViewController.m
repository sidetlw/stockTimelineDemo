//
//  ViewController.m
//  stockTimelineDemo
//
//  Created by sidetang on 2017/5/9.
//  Copyright © 2017年 sidetang. All rights reserved.
//

#import "ViewController.h"
#import "timelineViewController.h"


@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    }

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    timelineViewController *vc = [timelineViewController new];
    [self presentViewController:vc animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonAction:(id)sender {
    
}



@end
