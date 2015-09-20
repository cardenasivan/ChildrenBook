//
//  audioRecord.m
//  record2
//
//  Created by Davvit on 9/19/15.
//  Copyright (c) 2015 Davvit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "audioRecord.h"
#import "STPopup.h"
#import "PathHelper.h"
#import <AVFoundation/AVFoundation.h>

@interface audioRecord()
@property (nonatomic,strong) AVAudioRecorder *recorder;
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) NSTimer* timer;
@property (nonatomic, strong) NSString* pathForAudio;
@end

int hours;
int minutes;
int seconds;
int secondsLeft;

@implementation audioRecord

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"Record Audio";
        self.contentSizeInPopup = CGSizeMake(300, 60);
        self.landscapeContentSizeInPopup = CGSizeMake(300, 60);
    }
    secondsLeft = 16925;
    return self;
}

- (instancetype)initWithPath:(NSString* )path
{
    if (self = [super init]) {
        self.pathForAudio = path;
        NSFileManager* fileManager = [NSFileManager defaultManager];
        BOOL isDir = YES;
        if (![fileManager fileExistsAtPath:path isDirectory:&isDir])
        {
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        self.title = @"Record Audio";
        self.contentSizeInPopup = CGSizeMake(300, 60);
        self.landscapeContentSizeInPopup = CGSizeMake(300, 60);
        secondsLeft = 16925;
       
    }
    return self;
}

-(void)viewDidLoad{
    // Recording settings
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings setValue: [NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [settings setValue: [NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
    [settings setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    [settings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    [settings setValue:  [NSNumber numberWithInt: AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
    
    //audio file format :  bookTitle.Page#.aif
    NSString* path = [self.pathForAudio stringByAppendingPathComponent:@"audio.aif"];
    
    // File URL
    NSURL *url = [NSURL fileURLWithPath:path];
    
    //Save recording path to preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setURL:url forKey:[path lastPathComponent]];
    [prefs synchronize];
    
    // Create recorder
    NSError *error;
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    [_recorder prepareToRecord];
}

- (IBAction)recordBtn_press:(id)sender {
    [_recorder record];
    [self countdownTimer];
}

- (IBAction)stopBtn_press:(id)sender {
    [_recorder stop];
    [self.timer invalidate];
    self.timerLbl.text = @"0.00";
}

- (IBAction)playBtn_press:(id)sender {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    //Load recording path from preferences
    
    NSURL *temporaryRecFile = [NSURL fileURLWithPath:[self.pathForAudio stringByAppendingPathComponent:@"audio.aif"]];
    
    _player =  [[AVAudioPlayer alloc] initWithContentsOfURL:temporaryRecFile error:nil];
    [_player setNumberOfLoops:0];
    _player.volume = 10;
    [_player prepareToPlay];
    [_player play];
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    
}
- (void)updateCounter:(NSTimer *)theTimer {
    secondsLeft--;
    minutes = (secondsLeft % 3600) / 60;
    seconds = (secondsLeft %3600) % 60;
    self.timerLbl.text = [NSString stringWithFormat:@"%02d:%02d", minutes*-1, seconds*-1];
}

-(void)countdownTimer {
    
    secondsLeft = hours = minutes = seconds = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}
@end
