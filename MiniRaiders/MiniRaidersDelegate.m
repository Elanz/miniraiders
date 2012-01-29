//
//  MiniRaidersDelegate.m
//  MiniRaiders
//
//  Created by elanz on 1/24/12.
//  Copyright 200Monkeys 2012. All rights reserved.
//

#import "MiniRaidersDelegate.h"
#import "MainMenuLayer.h"
#import "MainGameController.h"

@implementation MiniRaidersDelegate

@synthesize window = _window;
@synthesize navController = _navController;
@synthesize director = _director;
@synthesize gameController = _gameController;

+ (MiniRaidersDelegate *) sharedAppDelegate
{
	return (MiniRaidersDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	CCGLView *glView = [CCGLView viewWithFrame:[_window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
								   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];

	_director = (CCDirectorIOS*) [CCDirector sharedDirector];
	_director.wantsFullScreenLayout = YES;
	[_director setDisplayStats:YES];
	[_director setAnimationInterval:1.0/60];
	[_director setView:glView];
	[_director setDelegate:self];
	[_director setProjection:kCCDirectorProjection2D];
//    if( ! [director_ enableRetinaDisplay:YES] )
//		CCLOG(@"Retina Display Not supported");
	_navController = [[UINavigationController alloc] initWithRootViewController:_director];
	_navController.navigationBarHidden = YES;
	[_window addSubview:_navController.view];
	[_window makeKeyAndVisible];
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	[CCFileUtils setiPadSuffix:@"-ipad"];			// Default on iPad is "" (empty string)
	[CCFileUtils setRetinaDisplaySuffix:@"-hd"];	// Default on RetinaDisplay is "-hd"
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
    
    // game setup
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sprites.plist"];
    
    _gameController = [[MainGameController alloc] init];
    [_gameController loadGame];
    
	[_director pushScene: [MainMenuLayer scene]]; 

	return YES;
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [_navController visibleViewController] == _director )
		[_director pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	if( [_navController visibleViewController] == _director )
		[_director resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [_navController visibleViewController] == _director )
		[_director stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [_navController visibleViewController] == _director )
		[_director startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
    [_gameController saveGame];
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

@end
