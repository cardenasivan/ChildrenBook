//
//  PageCreatorViewController.m
//  ChildrenBook
//
//  Created by Ivan Cardenas on 9/17/15.
//  Copyright (c) 2015 Ivan Cardenas. All rights reserved.
//

#import "PageCreatorViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ChildrenBookConstants.h"
#import "DragableClipart.h"
#import "PathHelper.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ClipartCanvas.h"
#import "STPopupController.h"
#import "audioRecord.h"

@interface PageCreatorViewController ()
@property (nonatomic, strong) NSMutableArray* dataSource;
@property (nonatomic, strong) NSString* storyName;
@property (nonatomic, strong) NSString* storyBookPath;
@property (nonatomic, strong) NSString* manifestFilePath;
@property (nonatomic, strong) IBOutlet UICollectionView* collectionView;
@property (nonatomic, strong) IBOutlet UIView* bookPage;
@property (nonatomic, strong) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) IBOutlet UITextField* textArea;
@property (nonatomic) NSInteger pageNumber;
@property (nonatomic, strong) UIFont* font;
@property (nonatomic, strong) UIColor* foregroundColor;
@end

@implementation PageCreatorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSource = [[NSMutableArray alloc] init];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self reloadData];
    [self setPageBackground];
    [self createStoryFolder];
    [self loadFonts];
    self.textArea.font = self.font;
    self.textArea.textColor = self.foregroundColor;
    // Do any additional setup after loading the view from its nib.
}

- (void)loadFonts
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    self.font = [UIFont fontWithName:[userDefaults valueForKey:kCurrentFontFamily] size:[[userDefaults valueForKey:kCurrentFontSize] floatValue]];
    
    NSData* colorData = [userDefaults valueForKey:kCurrentFontColor];
    
    self.foregroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
}

- (void)setPageBackground
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString* storyName = [userDefaults valueForKey:kCurrentStoryName];
    
    NSString* backgroundKey = [NSString stringWithFormat:@"%@%@", storyName, kBackgroundKey];
    
    NSString* imageName = [userDefaults valueForKey:backgroundKey];
    
    NSString* path = [[PathHelper getThemeBackgroundLocation] stringByAppendingPathComponent:imageName];
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    UIGraphicsBeginImageContext(self.bookPage.frame.size);
    [image drawInRect:self.bookPage.bounds];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.bookPage setBackgroundColor:[UIColor colorWithPatternImage:newImage]];
}

- (void)createStoryFolder
{
    self.storyName = [[NSUserDefaults standardUserDefaults] valueForKey:kCurrentStoryName];
    self.storyBookPath = [[PathHelper getStoryboardLocation] stringByAppendingPathComponent:self.storyName];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if (![fileManager fileExistsAtPath:self.storyBookPath isDirectory:&isDir])
    {
        [fileManager createDirectoryAtPath:self.storyBookPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
   self.manifestFilePath = [[[PathHelper getStoryboardLocation] stringByAppendingPathComponent:self.storyName] stringByAppendingPathComponent:kManifestFileName];
    
    isDir = NO;
    if (![fileManager fileExistsAtPath:self.manifestFilePath isDirectory:&isDir])
    {
        [fileManager createFileAtPath:self.manifestFilePath contents:nil attributes:nil];
    }
    
    NSString* fileContents = [NSString stringWithContentsOfFile:self.manifestFilePath encoding:NSStringEncodingConversionAllowLossy error:nil];
    
    NSArray* lines = [fileContents componentsSeparatedByString:@"\r\n"];
    self.pageNumber = lines.count;
    NSString* labelText = [NSString stringWithFormat:@"Page %lu", (long)self.pageNumber];
    
    [self.titleLabel setText:labelText];
    
}


- (void)reloadData
{
    [self.dataSource removeAllObjects];
    
    NSString* clipartSearchPath = [PathHelper getClipartLocation];
    
    NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:clipartSearchPath
                                                                         error:NULL];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if (![fileManager fileExistsAtPath:clipartSearchPath isDirectory:&isDir])
    {
        [fileManager createDirectoryAtPath:clipartSearchPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if ([files count] > 0)
    {
        for (NSString* file in files)
        {
            CFStringRef fileExtension = (__bridge CFStringRef) [file pathExtension];
            CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
            
            if (UTTypeConformsTo(fileUTI, kUTTypeImage))
            {
                [self.dataSource addObject:file];
            }
        }
    }
    [self.collectionView reloadData];
}

- (NSString *)getBackgroundPathImages
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = nil;
    if (paths != nil)
    {
        docDir = [paths objectAtIndex:0];
    }
    return docDir;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSString* imageName = [self.dataSource objectAtIndex:indexPath.row];
    NSString* path = [[PathHelper getClipartLocation] stringByAppendingPathComponent:imageName];
    
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
    NSString* path = [[PathHelper getClipartLocation] stringByAppendingPathComponent:imageName];
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    DragableClipart* clipart = [[DragableClipart alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [clipart setImage:image];
    clipart.userInteractionEnabled = YES;
    [clipart setImage:image];
    
    [self.bookPage addSubview:clipart];
    
}

- (void)savePage
{
    self.textArea.borderStyle = UITextBorderStyleNone;
    [self.textArea resignFirstResponder];
    UIGraphicsBeginImageContextWithOptions(self.bookPage.bounds.size, YES, 1.0);
    
    [self.bookPage.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString* imageFolder = [self.storyBookPath stringByAppendingPathComponent:self.titleLabel.text];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if (![fileManager fileExistsAtPath:imageFolder isDirectory:&isDir])
    {
        [fileManager createDirectoryAtPath:imageFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSData* imageData = UIImagePNGRepresentation(image);
    
    [imageData writeToFile:[imageFolder stringByAppendingPathComponent:kPageName] atomically:YES];
}

- (void)updateManifest
{
    NSString* lineToAdd = [NSString stringWithFormat:@"%@\r\n",self.titleLabel.text];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.manifestFilePath];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[lineToAdd dataUsingEncoding:NSStringEncodingConversionAllowLossy]];
    [fileHandle closeFile];

}
- (IBAction)newPage:(id)sender
{
    [self savePage];
    [self updateManifest];
    PageCreatorViewController* newpage = [[PageCreatorViewController alloc] initWithNibName:@"PageCreatorViewController" bundle:nil];
    
    [self.navigationController pushViewController:newpage animated:YES];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)pickImage:(id)sender
{
    [self startMediaBrowserFromViewController: self
                                usingDelegate: self];
    
}

- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType =   UIImagePickerControllerSourceTypePhotoLibrary |UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    mediaUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = NO;
    
    mediaUI.delegate = delegate;
    
    [self presentViewController:mediaUI animated:YES completion:nil];
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        NSString *fileName = [representation filename];
        
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        UIImage *myImage;
        
        if (iref)
        {
            myImage = [UIImage imageWithCGImage:iref scale:[rep scale]
                                    orientation:(UIImageOrientation)[rep orientation]];
            
            NSData* imageData = UIImagePNGRepresentation(myImage);
            
            [imageData writeToFile:[[PathHelper getClipartLocation] stringByAppendingPathComponent:fileName] atomically:YES];
            
            [self reloadData];
            
            
        }
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)createNewImage:(id)sender
{
    
    UIButton* barButton = (UIButton*)sender;
    
    ClipartCanvas* clipartCanvas = [[ClipartCanvas alloc] initWithNibName:@"ClipartCanvas" bundle:nil];
    
    UIPopoverController* popover = [[UIPopoverController alloc] initWithContentViewController:clipartCanvas];
    
    clipartCanvas.clipartPopoverController = popover;
    clipartCanvas.clipartParentController = self;
    
    popover.delegate = self;
    
    popover.popoverContentSize = CGSizeMake(1024, 768);
    
    [popover presentPopoverFromRect:barButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)recordAudio:(id)sender
{
    [STPopupNavigationBar appearance].barTintColor = [UIColor colorWithRed:0.20 green:0.60 blue:0.86 alpha:1.0];
    [STPopupNavigationBar appearance].tintColor = [UIColor whiteColor];
    [STPopupNavigationBar appearance].barStyle = UIBarStyleDefault;
    [STPopupNavigationBar appearance].titleTextAttributes = @{ NSFontAttributeName: [UIFont fontWithName:@"Cochin" size:18],
                                                               NSForegroundColorAttributeName: [UIColor whiteColor] };
    
    [[UIBarButtonItem appearanceWhenContainedIn:[STPopupNavigationBar class], nil] setTitleTextAttributes:@{ NSFontAttributeName:[UIFont fontWithName:@"Cochin" size:17] } forState:UIControlStateNormal];
    
    NSString* imageFolder = [self.storyBookPath stringByAppendingPathComponent:self.titleLabel.text];
    audioRecord* ad = [[audioRecord alloc] initWithPath:imageFolder];
    
    [self showPopupWithTransitionStyle:STPopupTransitionStyleSlideVertical rootViewController:ad];
}

- (void)showPopupWithTransitionStyle:(STPopupTransitionStyle)transitionStyle rootViewController:(UIViewController *)rootViewController
{
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:rootViewController];
    popupController.cornerRadius = 4;
    popupController.transitionStyle = transitionStyle;
    [popupController presentInViewController:self];
}

@end
