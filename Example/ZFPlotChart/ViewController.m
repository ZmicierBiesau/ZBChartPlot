//
//  ViewController.m
//  ZBPlotChart
//
//  Created by Źmicier Biesau, based on Zerbinati Francesco project
//  Copyright (c) 2016
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /********** Creating an area for the graph ***********/
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    CGRect frame = CGRectMake(0, 100, screenWidth, 190);
    
    // initialization
    self.plotChart = [[ZBPlotChart alloc] initWithFrame:frame];
    [self.view addSubview:self.plotChart];
    
    
    // get the data from the json file
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    // string creation
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    // json parsing
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];

    if (!json) {
        NSLog(@"Error parsing JSON");
    } else {
        NSLog(@"%@",json);
    }
    
    // values are contained inside "values" in the JSON file
    NSArray *values = [json valueForKeyPath:@"values"];
    // create the nsorderedset from the array
    NSOrderedSet *result = [NSOrderedSet orderedSetWithArray:values];
    
    self.plotChart.alpha = 0;
    
    self.plotChart.yParamterName = @"value";
    self.plotChart.xParamterName = @"time";
    self.plotChart.xDateFormat = @"yyyyMMdd";
    
    self.plotChart.enableVerticalAxis = YES;
    self.plotChart.enableHorizontalAxis = YES;
    self.plotChart.enableShowXLabels = YES;
    self.plotChart.enableShowYLabels = YES;
    self.plotChart.verticalLabelColor = [UIColor redColor];
    self.plotChart.horizontalLabelColor = [UIColor blueColor];
    self.plotChart.verticalLabelFont = [UIFont systemFontOfSize:12.f];
    self.plotChart.horizontalLabelFont = [UIFont systemFontOfSize:10.f];
    self.plotChart.horizontalAxisColor = [UIColor lightGrayColor];
    self.plotChart.verticalAxisColor = [UIColor greenColor];
    self.plotChart.graphColor = COLOR_WITH_RGB(255, 150, 10);
    self.plotChart.backgroundColor = [UIColor whiteColor];
    self.plotChart.emptyGraphText = @"This graph has nothing to show This graph has nothing to show This graph has nothing to show";
    self.plotChart.enablePopUpLabel = YES;
    
    
    // draw data
    [self.plotChart createChartWith:result];
    [UIView animateWithDuration:0.5 animations:^{
        self.plotChart.alpha = 1.0;
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
