//
//  ZBPlotChart.h
//
//  Created by Źmicier Biesau, based on Zerbinati Francesco project
//  Copyright (c) 2016
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define COLOR_WITH_RGB(r,g,b)   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f] // Macro for colors

// Dimension costants
static const float kTopMargin = 20.f;   // top margin
static const float kVMargin = 40.0f;   // vertical margin
static const float kHMargin = 10.0f;   // horizontal margin
static const float kLeftSpace = 20.0f;   // left space

// definitions (as JSON)
static NSString *kPointName = @"Point";


@interface ZBPlotChart : UIView
{
    NSMutableOrderedSet *dictDispPoint;
    float chartWidth, chartHeight;
    CGPoint prevPoint, curPoint;
    float min, max;
    BOOL isMovement;    // Default NO
    CGPoint currentLoc;
}

@property (nonatomic, retain) NSMutableOrderedSet *dictDispPoint;

@property (nonatomic, readwrite) float chartWidth, chartHeight;
@property (nonatomic, readwrite) CGFloat leftMargin;

@property (nonatomic, readwrite) CGPoint prevPoint, curPoint, currentLoc;
@property (nonatomic, readwrite) float min, max;

@property (nonatomic, readwrite) float yMax,yMin;

@property (strong) UIActivityIndicatorView *loadingSpinner;

@property (nonatomic, strong) NSString *xParamterName;
@property (nonatomic, strong) NSString *yParamterName;
@property (nonatomic, strong) NSString *xDateFormat;

@property (nonatomic, assign) BOOL enableVerticalAxis;
@property (nonatomic, assign) BOOL enableHorizontalAxis;
@property (nonatomic, assign) BOOL enableShowXAxis;
@property (nonatomic, assign) BOOL enableShowYAxis;
@property (nonatomic, assign) BOOL enableShowXLabels;
@property (nonatomic, assign) BOOL enableShowYLabels;
@property (nonatomic, strong) UIColor *verticalLabelColor;
@property (nonatomic, strong) UIColor *horizontalLabelColor;
@property (nonatomic, strong) UIFont *verticalLabelFont;
@property (nonatomic, strong) UIFont *horizontalLabelFont;
@property (nonatomic, strong) UIColor *verticalAxisColor;
@property (nonatomic, strong) UIColor *horizontalAxisColor;
@property (nonatomic, strong) UIColor *topGraphColor;
@property (nonatomic, strong) UIColor *bottomGraphColor;
@property (nonatomic, strong) NSString *emptyGraphText;
@property (nonatomic, assign) BOOL enablePopUpLabel;
@property (nonatomic, strong) UIFont *emptyLabelFont;
@property (nonatomic, assign) BOOL enableBackgroundHighlighting;
@property (nonatomic, strong) UIColor *backHightlightingColor;


- (void)createChartWith:(NSOrderedSet *)data;

@end
