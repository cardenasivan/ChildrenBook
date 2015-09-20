//
//  audioRecord.h
//  record2
//
//  Created by Davvit on 9/19/15.
//  Copyright (c) 2015 Davvit. All rights reserved.
//

#ifndef record2_audioRecord_h
#define record2_audioRecord_h
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface audioRecord : UIViewController<AVAudioPlayerDelegate>

@property (nonatomic,strong) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (weak, nonatomic) IBOutlet UIButton *play;
@property (weak, nonatomic) IBOutlet UILabel *timerLbl;
- (instancetype)initWithPath:(NSString* )path;

@end

#endif
