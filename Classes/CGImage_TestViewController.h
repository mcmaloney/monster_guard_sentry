//
//  CGImage_TestViewController.h
//  CGImage Test
//
//  Created by Michael Maloney on 6/23/10.
//  Copyright Carlson Shepherd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CAAnimation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <OpenAL/al.h>

@interface CGImage_TestViewController : UIViewController {
	IBOutlet UIImageView *pinwheel_1;
	IBOutlet UIImageView *pinwheel_2;
	IBOutlet UIImageView *pinwheel_3;
	IBOutlet UIImageView *pinwheel_4;
	IBOutlet UIImageView *pinwheel_5;
	IBOutlet UIButton *toggleButton;
	BOOL is_animating;
	BOOL layers_paused;
	
	CABasicAnimation *fullRotation;
	
	AVAudioRecorder *recorder;
	NSTimer *levelTimer;
	double lowPassResults;
	
	IBOutlet UIImageView *alertView;
	
	NSMutableArray *barArray;
	IBOutlet UIImageView *barView;
	
	AVAudioPlayer *activePlayer;
	AVAudioPlayer *alarmPlayer;
}

@property(nonatomic, retain) IBOutlet UIImageView *alertView;
@property(nonatomic, retain) IBOutlet UIButton *toggleButton;

- (IBAction)toggleAnimation:(id)sender;
- (void)levelTimerCallback:(NSTimer *)timer;
- (void) pauseLayer:(CALayer *)layer;
- (void) resumeLayer:(CALayer *)layer;
- (void) startRotation:(CALayer *)inLayer direction:(int)inDirection duration:(double)inDuration;
- (void) startBars;
- (void) stopBars;
- (void) showAlertView;
- (void) hideAlertView;
- (void) pauseActive;

@end

