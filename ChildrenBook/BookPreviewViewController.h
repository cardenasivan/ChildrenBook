//
//  BookPreviewViewController.h
//  ChildrenBook
//
//  Created by Ivan Cardenas on 9/20/15.
//  Copyright © 2015 Ivan Cardenas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface BookPreviewViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, AVAudioPlayerDelegate>
@property (nonatomic, strong) NSString* storyBookPath;
@end
