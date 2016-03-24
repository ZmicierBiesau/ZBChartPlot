//
//  ViewController.m
//  ZBPlotChart
//
//  Created by Źmicier Biesau, based on Zerbinati Francesco project
//  Copyright (c) 2016
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet ZBPlotChart *secondChart;


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
        //NSLog(@"%@",json);
    }
    
    // values are contained inside "values" in the JSON file
    NSArray *values = [json valueForKeyPath:@"values"];
    // create the nsorderedset from the array
    NSOrderedSet *result = [NSOrderedSet orderedSetWithArray:values];
    NSLog(@"%@", result);
    
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
    self.plotChart.verticalLabelFont = [UIFont systemFontOfSize:8.f];
    self.plotChart.horizontalLabelFont = [UIFont systemFontOfSize:8.f];
    self.plotChart.horizontalAxisColor = [UIColor lightGrayColor];
    self.plotChart.verticalAxisColor = [UIColor greenColor];
    self.plotChart.graphColor = COLOR_WITH_RGB(255, 150, 10);
    self.plotChart.backgroundColor = [UIColor whiteColor];
    self.plotChart.emptyGraphText = @"This graph has nothing to show This graph has nothing to show This graph has nothing to show";
    self.plotChart.enablePopUpLabel = YES;
    self.plotChart.emptyLabelFont = [UIFont systemFontOfSize:12.f];
    
    
    // draw data
    [self.plotChart createChartWith:result];
    [UIView animateWithDuration:0.5 animations:^{
        self.plotChart.alpha = 1.0;
    }];

    [self setupSecondChart];
}

- (void) setupSecondChart
{
    // get the data from the json file
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    // string creation
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    // json parsing
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    if (!json) {
        NSLog(@"Error parsing JSON");
    } else {
        //NSLog(@"%@",json);
    }
    
    // values are contained inside "values" in the JSON file
    NSArray *values = [json valueForKeyPath:@"values"];
    // create the nsorderedset from the array
    NSOrderedSet *result = [NSOrderedSet orderedSetWithArray:values];
    NSLog(@"%@", result);
    
    self.secondChart.alpha = 1;
    
    self.secondChart.yParamterName = @"value";
    self.secondChart.xParamterName = @"time";
    self.secondChart.xDateFormat = @"yyyyMMdd";
    
    self.secondChart.enableVerticalAxis = YES;
    self.secondChart.enableHorizontalAxis = YES;
    self.secondChart.enableShowXLabels = YES;
    self.secondChart.enableShowYLabels = YES;
    self.secondChart.verticalLabelColor = [UIColor greenColor];
    self.secondChart.horizontalLabelColor = [UIColor redColor];
    self.secondChart.verticalLabelFont = [UIFont systemFontOfSize:12.f];
    self.secondChart.horizontalLabelFont = [UIFont systemFontOfSize:10.f];
    self.secondChart.horizontalAxisColor = [UIColor yellowColor];
    self.secondChart.verticalAxisColor = [UIColor blueColor];
    self.secondChart.graphColor = COLOR_WITH_RGB(255, 150, 10);
    self.secondChart.backgroundColor = [UIColor whiteColor];
    self.secondChart.emptyGraphText = @"This graph has nothing to show This graph has nothing to show This graph has nothing to show";
    self.secondChart.enablePopUpLabel = YES;
    
    
    // draw data
    [self.secondChart createChartWith:result];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
