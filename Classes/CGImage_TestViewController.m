//
//  CGImage_TestViewController.m
//  CGImage Test
//
//  Created by Michael Maloney on 6/23/10.
//  Copyright Carlson Shepherd 2010. All rights reserved.
//

#import "CGImage_TestViewController.h"

#define SPIN_CLOCK_WISE 1
#define SPIN_COUNTERCLOCK_WISE -1


@implementation CGImage_TestViewController

@synthesize alertView;
@synthesize toggleButton;

// Start or stop the animation.
- (IBAction)toggleAnimation:(id)sender {
	if (is_animating) {
		[self pauseLayer:pinwheel_1.layer];
		[self pauseLayer:pinwheel_2.layer];
		[self pauseLayer:pinwheel_3.layer];
		[self pauseLayer:pinwheel_4.layer];
		[self pauseLayer:pinwheel_5.layer];
		layers_paused = YES;
		[self stopBars];
		[self pauseActive];
		UIImage *btnOnImage = [UIImage imageNamed:@"btn_ON.png"];
		[toggleButton setImage:btnOnImage forState:UIControlStateNormal];
		is_animating = NO;
	} else {
		if (layers_paused) {
			[self resumeLayer:pinwheel_1.layer];
			[self resumeLayer:pinwheel_2.layer];
			[self resumeLayer:pinwheel_3.layer];
			[self resumeLayer:pinwheel_4.layer];
			[self resumeLayer:pinwheel_5.layer];
		} else {
			[self startRotation:pinwheel_1.layer direction:SPIN_CLOCK_WISE duration:6.0];
			[self startRotation:pinwheel_2.layer direction:SPIN_COUNTERCLOCK_WISE duration:5.0];
			[self startRotation:pinwheel_3.layer direction:SPIN_CLOCK_WISE duration:7.0];
			[self startRotation:pinwheel_4.layer direction:SPIN_COUNTERCLOCK_WISE duration:4.0];
			[self startRotation:pinwheel_5.layer direction:SPIN_CLOCK_WISE duration:5.5];
		}
		[self startBars];
		[self playActive];
		UIImage *btnOffImage = [UIImage imageNamed:@"btn_OFF.png"];
		[toggleButton setImage:btnOffImage forState:UIControlStateNormal];
		is_animating = YES;
		layers_paused = NO;
	}
}

// Start rotating a layer in a given direction.
- (void) startRotation:(CALayer *)inLayer direction:(int)inDirection duration:(double)inDuration {
	fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	fullRotation.fromValue = [NSNumber numberWithFloat:0]; 
	fullRotation.toValue = [NSNumber numberWithFloat:(2 * M_PI * inDirection)]; 
	fullRotation.duration = inDuration; 
	fullRotation.repeatCount = 1e100f; 
	// Add the animation group to the layer 
	[inLayer addAnimation:fullRotation forKey:@"inLayer"]; 
}

// Pause a layer, in its tracks.
- (void) pauseLayer:(CALayer *)layer {
	CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
	layer.speed = 0.0;
	layer.timeOffset = pausedTime;
}


// Start a layer animating again from where it stopped.
-(void)resumeLayer:(CALayer*)layer {
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

- (void) playActive {
	[activePlayer play];
}

- (void) pauseActive {
	if (activePlayer.playing) {
		[activePlayer pause];
	}
}
	
// Animate the bars.
- (void) startBars {
	barView.hidden = NO;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[barView setAlpha:1.0];
	[UIView commitAnimations];
	[barView startAnimating];
}

// Stop the bars.
- (void) stopBars {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[barView setAlpha:0.0];
	[UIView commitAnimations];
	[barView stopAnimating];
}

// Load the animation images into the UIImageView for the bars.
- (void) setupBars {
	barArray = [[NSMutableArray alloc] init];
	int i;
	for (i = 0; i < 31; i++) {
		if (i < 10) {
			[barArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"0%d.png", i]]];
		} else {
			[barArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", i]]];
		}
	}
	barView.animationImages = barArray;
}


// Load the sound players.
- (void) setupSounds {
	NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sentry_on_v1.aif", [[NSBundle mainBundle] resourcePath]]];
	activePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	activePlayer.numberOfLoops = -1;
	activePlayer.currentTime = 0;
	activePlayer.volume = -1.5;
}
	

// Stop animating a given layer.
- (void) stopRotation:(CALayer *)inLayer {
	[inLayer removeAllAnimations];
}

// Listen for the peak level and show the alert if we go over the threshold.
- (void)levelTimerCallback:(NSTimer *)timer {
	[recorder updateMeters];
	
	const double ALPHA = 0.05;
	double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
	lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;	
	if (lowPassResults > 0.6 && is_animating) {
		[self showAlertView];
	} else {
		[self hideAlertView];
	}
}


// Fade in the alert view.
- (void) showAlertView {
	alertView.hidden = NO;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[alertView setAlpha:1.0];
	[UIView commitAnimations];
}

// Fade the alert view out.
- (void) hideAlertView {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[alertView setAlpha:0.0];
	[UIView commitAnimations];
}

// Start the mic listening for sound.
- (void) setupRecorder {
	NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
	
  	NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
							  [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
							  [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
							  [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
							  nil];
	
  	NSError *error;
	
  	recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
	[recorder prepareToRecord];
	recorder.meteringEnabled = YES;
	[recorder record];
	levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.03 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[UIApplication sharedApplication].idleTimerDisabled = YES;
    [super viewDidLoad];
	alertView.hidden = YES;
	barView.hidden = YES;
	[self setupRecorder];
	[self setupBars];
	[self setupSounds];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[levelTimer release];
	[recorder release];
	[fullRotation release];
	[barArray release];
	[UIApplication sharedApplication].idleTimerDisabled = NO;
    [super dealloc];
	
}

@end
