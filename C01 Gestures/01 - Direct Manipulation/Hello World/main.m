/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"


#pragma mark - DragView 类

@interface DragView : UIImageView // UIImageView 的子类
@end

@implementation DragView
{
	CGPoint startLocation;
}

- (instancetype)initWithImage:(UIImage *)anImage
{
	self = [super initWithImage:anImage];
	if (self)
	{
		self.userInteractionEnabled = YES;
	}
	return self;
}

#pragma mark 重写触摸事件
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event
{
	// Calculate and store offset, and pop view into front if needed
	// 计算并存储位移，并在需要时候把视图弹出到最前面
	startLocation = [[touches anyObject] locationInView:self];
	[self.superview bringSubviewToFront:self];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent *)event
{
	// Calculate offset
	// 计算位移
	CGPoint pt = [[touches anyObject] locationInView:self];
	float dx = pt.x - startLocation.x;
	float dy = pt.y - startLocation.y;
	CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
	
	// Set new location
	// 设置新位置
	self.center = newcenter;
}

@end


#pragma mark - TestBedViewController 类

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController

- (void)loadView
{
	self.view = [[UIView alloc] init];
	self.view.backgroundColor = [UIColor blackColor];
	
	// Provide a "Randomize" button
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Randomize", @selector(layoutFlowers));
	
	NSUInteger maxFlowers = 12; // number of flowers to add
	NSArray *flowerArray = @[@"blueFlower.png", @"pinkFlower.png", @"orangeFlower.png"];
	
	// Add the flowers
	for (NSUInteger i = 0; i < maxFlowers; i++)
	{
		NSString *whichFlower = [flowerArray objectAtIndex:(random() % flowerArray.count)];
		DragView *flowerDragger = [[DragView alloc] initWithImage:[UIImage imageNamed:whichFlower]];
		[self.view addSubview:flowerDragger];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self layoutFlowers];
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	// Check for any off-screen flowers and move them into place
	// 检查超出屏幕范围的花，并将其移动到其随机位置
	
	CGFloat halfFlower = 32.0f;
	CGRect targetRect = CGRectInset(self.view.bounds, halfFlower * 2, halfFlower * 2);
	targetRect = CGRectOffset(targetRect, halfFlower, halfFlower);
	
	for (UIView *flowerDragger in self.view.subviews)
	{
		if (!CGRectContainsPoint(targetRect, flowerDragger.center))
		{
			[UIView animateWithDuration:0.3f animations:
			 ^(){flowerDragger.center = [self randomFlowerPosition];}];
		}
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

/// 产生随机位置
- (CGPoint)randomFlowerPosition
{
	CGFloat halfFlower = 32.0f; // half of the size of the flower
	
	// The flower must be placed fully within the view. Inset accordingly
	CGSize insetSize = CGRectInset(self.view.bounds, 2*halfFlower, 2*halfFlower).size;
	
	// Return a random position within the inset bounds
	CGFloat randomX = random() % ((int)insetSize.width) + halfFlower;
	CGFloat randomY = random() % ((int)insetSize.height) + halfFlower;
	return CGPointMake(randomX, randomY);
}

/// 随机化按钮事件
- (void)layoutFlowers
{
	// Move every flower into a new random place
	// 移动每个花到一个新的随机位置
	[UIView animateWithDuration:0.3f animations: ^(){
		for (UIView *flowerDragger in self.view.subviews)
		{
			flowerDragger.center = [self randomFlowerPosition];
		}
	}];
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