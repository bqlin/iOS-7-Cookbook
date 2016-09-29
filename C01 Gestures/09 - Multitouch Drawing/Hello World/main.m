/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"


#pragma mark - TouchTrackerView 类

@interface TouchTrackerView : UIView
- (void) clear;
@end

@implementation TouchTrackerView
{
    NSMutableArray *strokes;
    NSMutableDictionary *touchPaths;
}

// 通过存储绘图初始化建立新视图
- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
    if (self)
    {
		self.multipleTouchEnabled = YES;
        strokes = [NSMutableArray array];
        touchPaths = [NSMutableDictionary dictionary];
    }
	return self;
}

// 移除所有存在的线条，但不移除正在绘制的线条
- (void)clear
{
    [strokes removeAllObjects];
    [self setNeedsDisplay];
}

// 通过添加新路径到 touchPath 字典开始触摸
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (UITouch *touch in touches)
	{
		NSString *key = [NSString stringWithFormat:@"%d", (int) touch];
		CGPoint pt = [touch locationInView:self];
		
		UIBezierPath *path = [UIBezierPath bezierPath];
		path.lineWidth = IS_IPAD ? 8: 4;
        path.lineCapStyle = kCGLineCapRound;
		[path moveToPoint:pt];
        
		[touchPaths setObject:path forKey:key];
	}
}

// 通过增长和连接路径，跟踪触摸动作
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (UITouch *touch in touches)
	{
		NSString *key = [NSString stringWithFormat:@"%d", (int) touch];
		UIBezierPath *path = [touchPaths objectForKey:key];
		if (!path) break;
		
		CGPoint pt = [touch locationInView:self];
		[path addLineToPoint:pt];
	}
	[self setNeedsDisplay];
}

// 在触摸结束，移动路径到 strokes 数组
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (UITouch *touch in touches)
	{
		NSString *key = [NSString stringWithFormat:@"%d", (int) touch];
        UIBezierPath *path = [touchPaths objectForKey:key];
        if (path) [strokes addObject:path];
		[touchPaths removeObjectForKey:key];
	}
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self touchesEnded:touches withEvent:event];
}

// 用暗紫色绘制存在的线条，用亮紫色绘制正在绘制的线条
- (void)drawRect:(CGRect)rect
{
	[COOKBOOK_PURPLE_COLOR set];
    for (UIBezierPath *path in strokes)
        [path stroke];
    
    [[COOKBOOK_PURPLE_COLOR colorWithAlphaComponent:0.5f] set];
    for (UIBezierPath *path in [touchPaths allValues])
    {
		[path stroke];
    }
}

@end


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController

- (void)loadView
{
    self.view = [[TouchTrackerView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    self.view.backgroundColor = [UIColor whiteColor];
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Clear", @selector(clear));
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self clear];
}

- (void)clear
{
    [(TouchTrackerView *)self.view clear];
}

@end


#pragma mark - Application Setup

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@end

@implementation TestBedAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.tintColor = COOKBOOK_PURPLE_COLOR;
    TestBedViewController *tbvc = [[TestBedViewController alloc] init];
    tbvc.edgesForExtendedLayout = UIRectEdgeNone;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tbvc];
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    return YES;
}

@end


#pragma mark - main

int main(int argc, char *argv[])
{
    @autoreleasepool
    {
        int retVal = UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
        return retVal;
    }
}
