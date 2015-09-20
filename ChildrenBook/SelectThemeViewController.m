//
//  SelectThemeViewController.m
//  ChildrenBook
//
//  Created by Ivan Cardenas on 9/15/15.
//  Copyright (c) 2015 Ivan Cardenas. All rights reserved.
//

#import "SelectThemeViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ChildrenBookConstants.h"
#import "PageCreatorViewController.h"
#import "PathHelper.h"
#import "FontStyleViewController.h"
#import "CanvasVC.h"

@interface SelectThemeViewController ()
@property (nonatomic, strong) IBOutlet UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataSource;
@property (nonatomic, strong) IBOutlet UIImageView* imageView;
@property (nonatomic, strong) NSString* selectedImageName;
@end

@implementation SelectThemeViewController
@synthesize tableView, dataSource, imageView, selectedImageName;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSource = [[NSMutableArray alloc] init];
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)reloadData
{
    [self.dataSource removeAllObjects];
    
    NSString* backgroundSourcePath = [PathHelper getThemeBackgroundLocation];
    
    NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:backgroundSourcePath
                                                                         error:NULL];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if (![fileManager fileExistsAtPath:backgroundSourcePath isDirectory:&isDir])
    {
        [fileManager createDirectoryAtPath:backgroundSourcePath withIntermediateDirectories:YES attributes:nil error:nil];
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
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString* imageName = [self.dataSource objectAtIndex:indexPath.row];
    
    self.selectedImageName = imageName;
    
    NSString* path = [[PathHelper getThemeBackgroundLocation] stringByAppendingPathComponent:imageName];
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    [self.imageView setImage:image];
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
            
            [imageData writeToFile:[[PathHelper getThemeBackgroundLocation] stringByAppendingPathComponent:fileName] atomically:YES];
            
            [self reloadData];
            
            
        }
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)finishedTheme:(id)sender
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString* storyName = [userDefaults valueForKey:kCurrentStoryName];
    
    [userDefaults setObject:self.selectedImageName forKey:[NSString stringWithFormat:@"%@%@", storyName, kBackgroundKey]];
    
    FontStyleViewController* fontSytle = [[FontStyleViewController alloc] initWithNibName:@"FontStyleViewController" bundle:nil];
    
    [self.navigationController pushViewController:fontSytle animated:YES];
    
}

- (IBAction)createTheme:(id)sender
{
    UIBarButtonItem* barButton = (UIBarButtonItem*)sender;
    
    CanvasVC* canvas = [[CanvasVC alloc] initWithNibName:@"CanvasVC" bundle:nil];
    
    UIPopoverController* popover = [[UIPopoverController alloc] initWithContentViewController:canvas];
    
    canvas.popoverController = popover;
    canvas.parentController = self;
    
    popover.delegate = self;
    
    popover.popoverContentSize = CGSizeMake(1024, 768);
    
    [popover presentPopoverFromBarButtonItem:barButton permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

@end
