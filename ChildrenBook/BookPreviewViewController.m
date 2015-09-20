//
//  BookPreviewViewController.m
//  ChildrenBook
//
//  Created by Ivan Cardenas on 9/20/15.
//  Copyright © 2015 Ivan Cardenas. All rights reserved.
//

#import "BookPreviewViewController.h"
#import "PathHelper.h"
#import "ChildrenBookConstants.h"
#import <AVFoundation/AVFoundation.h>

@interface BookPreviewViewController ()
@property (nonatomic, strong) NSMutableArray* dataSource;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) IBOutlet UICollectionView* theCollectionView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem* titleItem;
@end

@implementation BookPreviewViewController
@synthesize dataSource, theCollectionView, storyBookPath;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.theCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self reloadData];
    self.titleItem.title = [self.storyBookPath lastPathComponent];
    // Do any additional setup after loading the view from its nib.
}

-(void)reloadData
{
    NSString* path = [self.storyBookPath stringByAppendingPathComponent:kManifestFileName];
    
    NSString* fileContents = [NSString stringWithContentsOfFile:path encoding:NSStringEncodingConversionAllowLossy error:nil];
    
    NSArray* lines = [fileContents componentsSeparatedByString:@"\r\n"];
    
    self.dataSource = [NSMutableArray arrayWithArray:lines];
    
    [self.theCollectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSString* imageName = [self.dataSource objectAtIndex:indexPath.row];
    NSString* path = [[self.storyBookPath stringByAppendingPathComponent:imageName] stringByAppendingPathComponent:kPageName];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    cell.backgroundView = imageView;
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.layer.borderWidth = 2;
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* imageName = [self.dataSource objectAtIndex:indexPath.row];
    NSString* path = [[self.storyBookPath stringByAppendingPathComponent:imageName] stringByAppendingPathComponent:@"audio.aif"];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:path];
    
   self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL
                                                                   error:nil];
    self.player.delegate = self;
    self.player.numberOfLoops = 0; //Infinite
    [self.player prepareToPlay];
    [self.player play];

}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error
{
    
}

- (IBAction)previousPage:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
