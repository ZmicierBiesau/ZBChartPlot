//
//  ZBPlotChart.m
//
//  Created by Źmicier Biesau, based on Zerbinati Francesco project
//  Copyright (c) 2016
//

#import "ZBPlotChart.h"

static const float kNumberOfIntervals = 5.f;
static const float kMaxValueCoeff = 1.3f;

@implementation ZBPlotChart

@synthesize dictDispPoint;
@synthesize chartWidth, chartHeight;

@synthesize prevPoint, curPoint, currentLoc;
@synthesize min, max;


#pragma mark - Initialization/LifeCycle Method
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        @try {
            
            [self setup];
            
        }
        @catch (NSException *exception) {
            NSLog(@"%@",[exception debugDescription]);
        }
        @finally {
            
        }
    }
    return self;
}

- (void) setup
{
    [self setAutoresizingMask: UIViewAutoresizingFlexibleWidth];
    [self setAutoresizesSubviews:YES];
    
    _yParamterName = @"value";
    _xParamterName = @"time";
    _xDateFormat = @"yyyy-MM-dd";
    
    _enableVerticalAxis = YES;
    _enableHorizontalAxis = YES;
    _enableShowXLabels = YES;
    _enableShowYLabels = YES;
    _enableShowXAxis = YES;
    _enableShowYAxis = YES;
    _verticalLabelColor = [UIColor blackColor];
    _horizontalLabelColor = [UIColor blackColor];
    _verticalLabelFont = [UIFont systemFontOfSize:10.f];
    _horizontalLabelFont = [UIFont systemFontOfSize:10.f];
    _emptyLabelFont = [UIFont systemFontOfSize:10.f];
    _horizontalAxisColor = [UIColor lightGrayColor];
    _verticalAxisColor = [UIColor lightGrayColor];
    _topGraphColor = COLOR_WITH_RGB(0, 150, 10);
    _bottomGraphColor = COLOR_WITH_RGB(0, 10, 150);
    self.backgroundColor = [UIColor whiteColor];
    _emptyGraphText = @"This graph has nothing";
    _enablePopUpLabel = YES;
    _enableBackgroundHighlighting = YES;
    _backHightlightingColor = [UIColor colorWithWhite:0.5 alpha:0.8];
    
    self.chartHeight = self.bounds.size.height - kVMargin;
    self.chartWidth = self.bounds.size.width - kHMargin;
    
    isMovement = NO;
    
    self.dictDispPoint = [[NSMutableOrderedSet alloc] initWithCapacity:0];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.chartHeight = self.bounds.size.height - kVMargin;
    self.chartWidth = self.bounds.size.width - kHMargin;
    [self createChartWith:[dictDispPoint copy]];
}

#pragma mark - Chart Creation Method
- (void)createChartWith:(NSOrderedSet *)data
{
    
    [self.dictDispPoint removeAllObjects];
    
    if(data.count == 1)
    {
        data = [self transform1ElemntSet:data];
    }
    
    NSMutableOrderedSet *orderSet = [[NSMutableOrderedSet alloc] initWithCapacity:0];
    
    // Add data to the orderSet
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger ind, BOOL *stop){
        [orderSet addObject:obj];
        
    }];
    
    // Find Min & Max of Chart
    self.max = [[[orderSet valueForKey:self.yParamterName] valueForKeyPath:@"@max.floatValue"] floatValue];
    self.min = 0.f;
    
    
    // Enhance Upper Limit for Flexible Display, based on average of min and max
    if(self.max < 5 && self.max >= 0.001)
        self.max = 5.f;
    else
        self.max = ceilf(self.max * kMaxValueCoeff);
    
    
    // Calculate left space given by the lenght of the string on the axis
    self.leftMargin = [self sizeOfString:[@(self.max) stringValue] withFont:self.verticalLabelFont].width + kLeftSpace;
    
    self.chartWidth-= self.leftMargin;
    float range = self.max-self.min;
    
    float intervalValues = self.max >= 0.001? range / kNumberOfIntervals : 10.f; //I can't garantee that float is 0.f, it can be 0.0000001f for ex.
    intervalValues = ceilf(intervalValues);
    if(self.max >= 0.001)
    {
        range = intervalValues * kNumberOfIntervals;
        self.max = self.min + range;
    }
    
    // Calculate deploying points for chart according to values
    float xGapBetweenTwoPoints = self.chartWidth / ([orderSet count] - 1);
    float x , y;

    x = self.leftMargin;
    y = kTopMargin;
    
    self.yMax = 0;
    
    // assing points to values
    for(NSDictionary *dictionary in orderSet)
    {
        float yValue = [[dictionary valueForKey:self.yParamterName] floatValue];
        
        float diff = (self.max-yValue);
        
        y = ((self.chartHeight) * diff) / range + kTopMargin;
        
        // calculate maximum y
        if(y > self.yMax) self.yMax = y;
        
        CGPoint point = CGPointMake(x,y);
        
        NSDictionary *dictPoint = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:point], kPointName,
                                   [dictionary valueForKey:self.yParamterName], self.yParamterName,
                                   [dictionary valueForKey:self.xParamterName], self.xParamterName, nil];
        
        [self.dictDispPoint addObject:dictPoint];
        
        x+= xGapBetweenTwoPoints;
    }
    
    [self setNeedsDisplay];
    
}

- (NSOrderedSet*) transform1ElemntSet: (NSOrderedSet*) set
{
    NSMutableOrderedSet *mutableItems = (NSMutableOrderedSet *)set.mutableCopy;
    NSMutableDictionary *dict = ((NSDictionary*)set[0]).mutableCopy;
    dict[self.yParamterName] = @"0";
    NSString *stringDate = dict[self.xParamterName];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:self.xDateFormat];
    NSDate *dateFromString = [dateFormatter dateFromString:stringDate];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:-1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:dateFromString options:0];
    
    NSString *printDate = [dateFormatter stringFromDate:newDate];
    dict[self.xParamterName] = printDate;
    [mutableItems insertObject:dict atIndex:0];
    return (NSOrderedSet *)mutableItems.copy;
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    @try
    {
        if([self.dictDispPoint count] > 0)
        {
            // remove loading animation
            [self stopLoading];
            

            
            float range = self.max - self.min;
            float intervalHlines = (self.chartHeight) / kNumberOfIntervals;
            float intervalValues = self.max >= 0.001? range / kNumberOfIntervals : 10.f; //I can't garantee that float is 0.f, it can be 0.0000001f for ex.
            intervalValues = ceilf(intervalValues);
            if(self.max >= 0.001)
                range = intervalValues * kNumberOfIntervals;
                self.max = self.min + range;
            
            
            
            // horizontal lines
            for(int i = kNumberOfIntervals; i > 0; i--)
            {
                if (self.enableHorizontalAxis)
                {
                    [self setContextWidth:0.5f andColor:self.horizontalAxisColor];
                    
                    CGPoint start = CGPointMake(self.leftMargin - 5.f, self.chartHeight+kTopMargin-i*intervalHlines);
                    CGPoint end = CGPointMake(self.chartWidth+self.leftMargin, self.chartHeight+kTopMargin-i*intervalHlines);
                    
                    // draw the line
                    [self drawLineFrom:start to:end];
                    [self endContext];
                }
                
                if (self.enableBackgroundHighlighting && i % 2 != 0) {
                    [self setContextWidth:intervalHlines andColor:self.backHightlightingColor];
                    
                    CGPoint start = CGPointMake(self.leftMargin, self.chartHeight+kTopMargin - (i - 0.5) * intervalHlines);
                    CGPoint end = CGPointMake(self.chartWidth + self.leftMargin, self.chartHeight+kTopMargin - (i - 0.5) * intervalHlines);
                    
                    // draw the line
                    [self drawLineFrom:start to:end];
                    [self endContext];
                }
                
                // draw Ys on the axis
                if(self.enableShowYLabels)
                {
                    NSString *prezzoAsse = [@(self.min+i*intervalValues) stringValue];
                    CGPoint prezzoAssePoint = CGPointMake(self.leftMargin - [self sizeOfString:prezzoAsse withFont:self.verticalLabelFont].width - 10.f, (self.chartHeight+kTopMargin-i*intervalHlines - 6));
                
                    [self drawString:prezzoAsse at:prezzoAssePoint withFont:self.verticalLabelFont andColor:self.verticalLabelColor];
                }
                
                [self endContext];
                
            }
            
            /*** Draw points ***/
            [self.dictDispPoint enumerateObjectsUsingBlock:^(id obj, NSUInteger ind, BOOL *stop){
                if(ind > 0)
                {
                    self.prevPoint = [[[self.dictDispPoint objectAtIndex:ind - 1] valueForKey:kPointName] CGPointValue];
                    self.curPoint = [[[self.dictDispPoint objectAtIndex:ind] valueForKey:kPointName] CGPointValue];
                }
                else
                {
                    // first point
                    self.prevPoint = [[[self.dictDispPoint objectAtIndex:ind] valueForKey:kPointName] CGPointValue];
                    self.curPoint = self.prevPoint;
                }
                
                // line style
                [self setContextWidth:.5f andColor:self.topGraphColor];
                
                // draw the curve
                //[self drawCurveFrom:self.prevPoint to:self.curPoint];

                [self endContext];
                
                
                long linesRatio;
                
                if([self.dictDispPoint count] < 7)
                    linesRatio = [self.dictDispPoint count] / [self.dictDispPoint count];
                else if([self.dictDispPoint count] < 13)
                    linesRatio = [self.dictDispPoint count] / 2;
                else linesRatio  = [self.dictDispPoint count]/4 ;
                
                
                if(ind%linesRatio == 0) {
                    
                    [self setContextWidth:0.5f andColor:self.verticalAxisColor];
                    
                    // Vertical Lines
                    if(ind!=0 && self.enableVerticalAxis) {
                        CGPoint lower = CGPointMake(self.curPoint.x, kTopMargin+self.chartHeight);
                        CGPoint higher = CGPointMake(self.curPoint.x, kTopMargin);
                        [self drawLineFrom:lower to: higher];
                        
                    }
                    
                    [self endContext];
                    
                    // draw dates on the x axis
                    if (self.enableShowXLabels) {
                        NSString* date = [self monthFromString: [[self.dictDispPoint objectAtIndex:ind] valueForKey:self.xParamterName]];
                        CGPoint datePoint = CGPointMake(self.curPoint.x - 15, kTopMargin + self.chartHeight + 2);
                        [self drawString:date at:datePoint withFont:self.horizontalLabelFont andColor:self.horizontalLabelColor];
                    }
                    [self endContext];
                    
                    
                }
                
            }];
            
            // fill path
            CGMutablePathRef path = CGPathCreateMutable();
            
            CGPathMoveToPoint(path, nil, self.leftMargin, kTopMargin+self.chartHeight);
            
            CGPoint origin = CGPointMake(self.leftMargin, kTopMargin+self.chartHeight);
            if(!isnan(origin.x) && !isnan(origin.y))
            {
                CGPathAddLineToPoint(path, nil, origin.x,origin.y);
            }
            if (self.dictDispPoint && self.dictDispPoint.count > 0) {
                
                //origin
                CGPoint p;
                for (int i = 0; i < self.dictDispPoint.count; i++) {
                    p = [[[self.dictDispPoint objectAtIndex:i] valueForKey:kPointName] CGPointValue];
                    if(!isnan(p.x) && !isnan(p.y))
                    {
                        CGPathAddLineToPoint(path, nil, p.x, p.y);
                    }
                }
            }
            CGPathAddLineToPoint(path, nil, self.curPoint.x, kTopMargin+self.chartHeight);
            CGPathAddLineToPoint(path, nil, self.leftMargin + self.chartWidth, kTopMargin+self.chartHeight);
            CGPathAddLineToPoint(path, nil, self.leftMargin, kTopMargin+self.chartHeight);

            
            // fill
            [self fillUnderGraphForPath:path];
            
            CGPathRelease(path);
            
            
            //  X and Y axis
            
            [self setContextWidth:0.5f andColor:self.horizontalAxisColor];
            
            //  y
            if (self.enableShowYAxis)
            {
                [self drawLineFrom:CGPointMake(self.leftMargin, kTopMargin) to:CGPointMake(self.leftMargin, self.chartHeight+kTopMargin)];
            }
            //  x
            if (self.enableShowXAxis) {
                [self drawLineFrom:CGPointMake(self.leftMargin, kTopMargin+self.chartHeight) to:CGPointMake(self.leftMargin+self.chartWidth, self.chartHeight + kTopMargin)];
            }
            
            
            // vertical closure
            if (!self.enableVerticalAxis && self.enableShowYAxis) {
                CGPoint startLine = CGPointMake(self.leftMargin+self.chartWidth, kTopMargin);
                CGPoint endLine = CGPointMake(self.leftMargin+self.chartWidth, kTopMargin+self.chartHeight);
                [self drawLineFrom:startLine to:endLine];
            }
            // horizontal closure
            if (!self.enableHorizontalAxis && self.enableShowXAxis) {
                [self drawLineFrom:CGPointMake(self.leftMargin, kTopMargin) to:CGPointMake(self.chartWidth+self.leftMargin, kTopMargin)];
            }
            
            
            
            [self endContext];
            
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            
            // popup when moving
            if(isMovement && self.enablePopUpLabel)
            {
                float xGapBetweenTwoPoints = self.chartWidth/[self.dictDispPoint count];
                int pointSlot = currentLoc.x/xGapBetweenTwoPoints;
                
                if(pointSlot >= 0 && pointSlot < [self.dictDispPoint count])
                {
                    NSDictionary *dict = [self.dictDispPoint objectAtIndex:pointSlot];
                    
                    // Calculate Point to draw Circle
                    CGPoint point = CGPointMake([[dict valueForKey:kPointName] CGPointValue].x,[[dict valueForKey:kPointName] CGPointValue].y);
                    
                    
                    [self setContextWidth:1.0f andColor:self.topGraphColor];
                    
                    // Line at current Point
                    [self drawLineFrom:CGPointMake(point.x, kTopMargin-10) to:CGPointMake(point.x, self.chartHeight+kTopMargin)];
                    [self endContext];
                    
                    // Circle at point
                    [self setContextWidth:1.0f andColor:self.topGraphColor];
                    [self drawCircleAt:point ofRadius:8];
                    
                    [self endContext];
                    
                    
                    // draw the dynamic value
                    
                    float value = [[dict objectForKey:self.yParamterName] floatValue];
                    NSString *yString = [@(value) stringValue];
                    
                    CGSize yStringSize = [self sizeOfString:yString withFont:self.horizontalLabelFont];
                    
                    CGRect yStringRect = {point.x-yStringSize.width/2, 2, yStringSize.width + 10, yStringSize.height +3};
                    
                    // if goes out on right
                    if(point.x+-yStringSize.width/2+yStringSize.width+12 > self.chartWidth+self.leftMargin)
                        yStringRect.origin.x = self.chartWidth+self.leftMargin-yStringSize.width-2;
                    // if goes out on left
                    if(yStringRect.origin.x < self.leftMargin)
                        yStringRect.origin.x = self.leftMargin-(self.leftMargin/2);
                    
                    // rectangle for the label
                    [self drawRoundedRect:context rect:yStringRect radius:5 color:self.topGraphColor];
                    // value string
                    [self drawString:yString at:CGPointMake(yStringRect.origin.x + (yStringRect.size.width - yStringSize.width)/2, yStringRect.origin.y + 1.0f) withFont:self.horizontalLabelFont andColor:self.backgroundColor];
                }
            }
            if (self.max <= 0) {
                [self drawMessage:self.emptyGraphText];
            }
        }
        else
        {
            [self drawMessage:self.emptyGraphText];
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception debugDescription]);
    }
    @finally {
        
    }
}


#pragma mark - Graphic Utilities

-(void)stopLoading {
    [self.loadingSpinner stopAnimating];
}

-(void)fillUnderGraphForPath:(CGMutablePathRef) path{
 
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSArray* simpleLinearGradientColors = [NSArray arrayWithObjects:
                                           (id)self.topGraphColor.CGColor,
                                           (id)self.bottomGraphColor.CGColor, nil];
    CGFloat simpleLinearGradientLocations[] = {0.7f, 1.f};
    CGGradientRef simpleLinearGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)simpleLinearGradientColors, simpleLinearGradientLocations);
    
    
    // Bezier Drawing
    UIBezierPath *bezier = [UIBezierPath bezierPathWithCGPath:path];
  //  [bezier closePath];
    CGContextSaveGState(context);
    [bezier addClip];
    CGContextDrawLinearGradient(context, simpleLinearGradient, CGPointMake(self.chartWidth / 2, self.yMin), CGPointMake(self.chartWidth / 2, kTopMargin+self.chartHeight), 1);
    CGContextRestoreGState(context);
    
//    [[UIColor blackColor] setStroke];
//    bezier.lineWidth = 1;
//    [bezier stroke];
    
    CGGradientRelease(simpleLinearGradient);
    CGColorSpaceRelease(colorSpace);
   
}

-(void)drawMessage:(NSString*)string {
    
   

    /// Make a copy of the default paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    CGFloat leftInset = 25.f;
    CGFloat topBottomInset = 5.f;
    
    CGSize textSize = [self sizeOfString:string withFont:self.emptyLabelFont];
    CGFloat numberOfStrings = textSize.width / (self.chartWidth - 2 * leftInset);
    numberOfStrings = ceilf(numberOfStrings);
    
    while ((textSize.height * numberOfStrings > self.chartHeight - 2 * topBottomInset) && textSize.height > 0 && numberOfStrings > 0)
    {
        self.emptyLabelFont = [self.emptyLabelFont fontWithSize:self.emptyLabelFont.pointSize - 1];
        textSize = [self sizeOfString:string withFont:self.emptyLabelFont];
        numberOfStrings = textSize.width / (self.chartWidth - 2 * leftInset);
        numberOfStrings = ceilf(numberOfStrings);
    }
    
     NSDictionary *attributes = @{NSFontAttributeName: self.emptyLabelFont,
                       NSForegroundColorAttributeName: [UIColor blackColor],
                        NSParagraphStyleAttributeName: paragraphStyle};
   
    
    
    [string drawInRect:CGRectMake(self.leftMargin + leftInset, self.bounds.size.height / 2 - numberOfStrings * textSize.height / 2, self.chartWidth - 2 * leftInset, numberOfStrings * textSize.height) withAttributes:attributes];
    
    [self endContext];
}


// set the context with a specified widht and color
-(void) setContextWidth:(float)width andColor:(UIColor*)color {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, width);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
}
// end context
-(void)endContext {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextStrokePath(context);
}
// line between two points
-(void) drawLineFrom:(CGPoint) start to: (CGPoint)end {
    if(isnan(start.x) || isnan(start.y) || isnan(end.x) || isnan(end.y)) return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, start.x, start.y);
    CGContextAddLineToPoint(context,end.x,end.y);
    
}
// curve between two points
-(void) drawCurveFrom:(CGPoint)start to:(CGPoint)end {
    if(isnan(start.x)|| isnan(start.y)|| isnan(end.x) || isnan(end.y)) return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, start.x, start.y);
    CGContextAddQuadCurveToPoint(context, start.x, start.y, end.x, end.y);
    CGContextSetLineCap(context, kCGLineCapRound);
}
// draws a string given a point, font and color
-(void) drawString:(NSString*)string at:(CGPoint)point withFont:(UIFont*)font andColor:(UIColor*)color{
    if(isnan(point.x)|| isnan(point.y)) return;
    NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: color};
    if (string.length > 3)
        string = [string substringToIndex:3];
    [string.uppercaseString drawAtPoint:point withAttributes:attributes];
}
// draw a circle given center and radius
-(void) drawCircleAt:(CGPoint)point ofRadius:(int)radius {
    if(isnan(point.x) || isnan(point.y)) return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect myOval = {point.x-radius/2, point.y-radius/2, radius, radius};
    CGContextAddEllipseInRect(context, myOval);
    CGContextFillPath(context);
}
// rounded corners rectangle
- (void) drawRoundedRect:(CGContextRef)c rect:(CGRect)rect radius:(int)corner_radius color:(UIColor *)color
{
    if(isnan(rect.origin.x)|| isnan(rect.origin.y)) return;
    int x_left = rect.origin.x;
    int x_left_center = rect.origin.x + corner_radius;
    int x_right_center = rect.origin.x + rect.size.width - corner_radius;
    int x_right = rect.origin.x + rect.size.width;
    
    int y_top = rect.origin.y;
    int y_top_center = rect.origin.y + corner_radius;
    int y_bottom_center = rect.origin.y + rect.size.height - corner_radius;
    int y_bottom = rect.origin.y + rect.size.height;
    
    /* Begin! */
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, x_left, y_top_center);
    
    /* First corner */
    CGContextAddArcToPoint(c, x_left, y_top, x_left_center, y_top, corner_radius);
    CGContextAddLineToPoint(c, x_right_center, y_top);
    
    /* Second corner */
    CGContextAddArcToPoint(c, x_right, y_top, x_right, y_top_center, corner_radius);
    CGContextAddLineToPoint(c, x_right, y_bottom_center);
    
    /* Third corner */
    CGContextAddArcToPoint(c, x_right, y_bottom, x_right_center, y_bottom, corner_radius);
    CGContextAddLineToPoint(c, x_left_center, y_bottom);
    
    /* Fourth corner */
    CGContextAddArcToPoint(c, x_left, y_bottom, x_left, y_bottom_center, corner_radius);
    CGContextAddLineToPoint(c, x_left, y_top_center);
    
    /* Done */
    CGContextClosePath(c);
    
    CGContextSetFillColorWithColor(c, color.CGColor);
    
    CGContextFillPath(c);
}
// size of a string given a specific font
-(CGSize) sizeOfString:(NSString *)string withFont:(UIFont *)font {
    NSDictionary *attributes = @{ NSFontAttributeName: font};
    return [string sizeWithAttributes:attributes];
}

#pragma mark - String utilities

// format a string as a date

- (NSString*) monthFromString: (NSString*) string {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:self.xDateFormat];
    NSDate *dateFromString = [dateFormatter dateFromString:string];
    
    [dateFormatter setDateFormat:@"MMM"];
    NSString *printDate = [dateFormatter stringFromDate:dateFromString];
    return printDate;
}



#pragma mark - Handle Touch Events

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableScrolling" object:nil];
    
    UITouch *touch = [touches anyObject];
    currentLoc = [touch locationInView:self];
    currentLoc.x -= self.leftMargin;
    isMovement = YES;
    
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    currentLoc = [touch locationInView:self];
    currentLoc.x -= self.leftMargin;
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enableScrolling" object:nil];
    
    UITouch *touch = [touches anyObject];
    currentLoc = [touch locationInView:self];
    currentLoc.x -= self.leftMargin;
    
    isMovement = NO;
    [self setNeedsDisplay];
}

@end