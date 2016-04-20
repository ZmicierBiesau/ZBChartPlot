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
    
    CGRect frame = CGRectMake(0, 50, screenWidth, 150);
    
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
    self.plotChart.xDateFormat = @"yyyy-MM-dd";
    
    self.plotChart.enableVerticalAxis = NO;
    self.plotChart.enableHorizontalAxis = YES;
    self.plotChart.enableShowXLabels = YES;
    self.plotChart.enableShowYLabels = YES;
    self.plotChart.enableShowXAxis = NO;
    self.plotChart.enableShowYAxis = NO;
    self.plotChart.verticalLabelColor = [UIColor redColor];
    self.plotChart.horizontalLabelColor = [UIColor blueColor];
    self.plotChart.verticalLabelFont = [UIFont systemFontOfSize:8.f];
    self.plotChart.horizontalLabelFont = [UIFont systemFontOfSize:8.f];
    self.plotChart.horizontalAxisColor = [UIColor lightGrayColor];
    self.plotChart.verticalAxisColor = [UIColor greenColor];
    self.plotChart.topGraphColor = COLOR_WITH_RGB(255, 150, 10);
    self.plotChart.bottomGraphColor = COLOR_WITH_RGB(150, 255, 10);
    self.plotChart.backgroundColor = [UIColor whiteColor];
    self.plotChart.emptyGraphText = @"This graph has nothing to show1 This graph has nothing to show2 This graph has nothing to show3 This graph has nothing to show4 This graph has nothing to show5 This graph has nothing to show6 This graph has nothing to show7 This graph has nothing to show8 This graph has nothing to show9 This graph has nothing to show0 This graph has nothing to show1 This graph has nothing to show2";
    self.plotChart.enablePopUpLabel = YES;
    self.plotChart.emptyLabelFont = [UIFont systemFontOfSize:12.f];
    self.plotChart.enableBackgroundHighlighting = YES;
    self.plotChart.backHightlightingColor = [UIColor colorWithWhite:0.5f alpha:.5f];
    
    
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
    self.secondChart.xDateFormat = @"yyyy-MM-dd";
    
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
    self.secondChart.topGraphColor = COLOR_WITH_RGB(255, 150, 10);
    self.secondChart.bottomGraphColor = COLOR_WITH_RGB(150, 255, 10);
    self.secondChart.backgroundColor = [UIColor whiteColor];
    self.secondChart.emptyGraphText = @"No good info for showing";
    self.secondChart.enablePopUpLabel = YES;
    self.secondChart.emptyLabelFont = [UIFont boldSystemFontOfSize:12.f];
    self.secondChart.enableBackgroundHighlighting = NO;
    
    
    // draw data
    [self.secondChart createChartWith:result];
    
}

@end
