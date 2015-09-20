//
//  FontStyleViewController.m
//  ChildrenBook
//
//  Created by Ivan Cardenas on 9/17/15.
//  Copyright (c) 2015 Ivan Cardenas. All rights reserved.
//

#import "FontStyleViewController.h"
#import "PageCreatorViewController.h"
#import "DRColorPicker.h"
#import "ChildrenBookConstants.h"
#import "PathHelper.h"

@interface FontStyleViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    int minFontSize;
    int maxFontSize;
}
@property (nonatomic, strong) NSArray* fontList;
@property (nonatomic, strong) NSString* selectedFontFamily;
@property (nonatomic, strong) NSString* selectedFontSize;
@property (nonatomic, strong) IBOutlet UILabel* sampleLabel;
@property (nonatomic, strong) IBOutlet UIButton* colorButton;
@property (nonatomic, strong) DRColorPickerColor* color;
@property (nonatomic, weak) DRColorPickerViewController* colorPickerVC;
@property (nonatomic, strong) UIColor* foregroundColor;
@property (nonatomic, strong) IBOutlet UIImageView* imageView;
@end

@implementation FontStyleViewController
@synthesize fontList, selectedFontFamily, selectedFontSize, sampleLabel, colorButton, color, colorPickerVC, foregroundColor, imageView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadFonts];
    [self setPageBackground];
    minFontSize = 6;
    maxFontSize = 50;
    self.selectedFontFamily = self.sampleLabel.font.familyName;
    self.selectedFontSize = [NSString stringWithFormat:@"%f", self.sampleLabel.font.pointSize];
    self.foregroundColor = [UIColor blackColor];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return maxFontSize - minFontSize;
    }
    else
    {
        return self.fontList.count;
    }
}

- (void)loadFonts
{
    //rebuild font family names and sort
    NSMutableArray *theListFonts = [NSMutableArray arrayWithArray:[UIFont familyNames]];
    if (theListFonts != nil || [theListFonts count] != 0)
    {
        [theListFonts sortUsingSelector:@selector(compare:)];
        self.fontList = [NSArray arrayWithArray:theListFonts];;
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [NSString stringWithFormat:@"%ld", (unsigned long)(row + minFontSize - 1)];
    }
    else
    {
        return [self.fontList objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    id delegate = pickerView.delegate;
    NSString *title = [delegate pickerView:pickerView titleForRow:[pickerView selectedRowInComponent:0] forComponent:0];
    self.selectedFontSize = title;
    title = [delegate pickerView:pickerView titleForRow:[pickerView selectedRowInComponent:1] forComponent:1];
    self.selectedFontFamily = title;
    self.sampleLabel.font = [UIFont fontWithName:self.selectedFontFamily size:[self.selectedFontSize floatValue]];
}

- (IBAction)createPages:(id)sender
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:self.foregroundColor];
    [userDefaults setObject:colorData forKey:kCurrentFontColor];
    [userDefaults setObject:self.selectedFontFamily forKey:kCurrentFontFamily];
    [userDefaults setObject:self.selectedFontSize forKey:kCurrentFontSize];
    
    PageCreatorViewController* pageCreator = [[PageCreatorViewController alloc] initWithNibName:@"PageCreatorViewController" bundle:nil];
    
    [self.navigationController pushViewController:pageCreator animated:YES];
}



- (IBAction)showColorPickerButtonTapped:(id)sender
{
    // Setup the color picker - this only has to be done once, but can be called again and again if the values need to change while the app runs
    //    DRColorPickerThumbnailSizeInPointsPhone = 44.0f; // default is 42
    //    DRColorPickerThumbnailSizeInPointsPad = 44.0f; // default is 54
    
    // REQUIRED SETUP....................
    // background color of each view
    DRColorPickerBackgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    
    // border color of the color thumbnails
    DRColorPickerBorderColor = [UIColor blackColor];
    
    // font for any labels in the color picker
    DRColorPickerFont = [UIFont systemFontOfSize:16.0f];
    
    // font color for labels in the color picker
    DRColorPickerLabelColor = [UIColor blackColor];
    // END REQUIRED SETUP
    
    // OPTIONAL SETUP....................
    // max number of colors in the recent and favorites - default is 200
    DRColorPickerStoreMaxColors = 200;
    
    // show a saturation bar in the color wheel view - default is NO
    DRColorPickerShowSaturationBar = YES;
    
    // highlight the last hue in the hue view - default is NO
    DRColorPickerHighlightLastHue = YES;
    
    // use JPEG2000, not PNG which is the default
    // *** WARNING - NEVER CHANGE THIS ONCE YOU RELEASE YOUR APP!!! ***
    DRColorPickerUsePNG = NO;
    
    // JPEG2000 quality default is 0.9, which really reduces the file size but still keeps a nice looking image
    // *** WARNING - NEVER CHANGE THIS ONCE YOU RELEASE YOUR APP!!! ***
    DRColorPickerJPEG2000Quality = 0.9f;
    
    // set to your shared app group to use the same color picker settings with multiple apps and extensions
    DRColorPickerSharedAppGroup = nil;
    // END OPTIONAL SETUP
    
    // create the color picker
    DRColorPickerViewController* vc = [DRColorPickerViewController newColorPickerWithColor:self.color];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.rootViewController.showAlphaSlider = YES; // default is YES, set to NO to hide the alpha slider
    
    // setting these to nil (the default) tells it to use the built-in default images
    vc.rootViewController.addToFavoritesImage = nil;
    vc.rootViewController.favoritesImage = nil;
    vc.rootViewController.hueImage = nil;
    vc.rootViewController.wheelImage = nil;
    vc.rootViewController.importImage = nil;

    
    // assign a weak reference to the color picker, need this for UIImagePickerController delegate
    self.colorPickerVC = vc;
    
    // make an import block, this allows using images as colors, this import block uses the UIImagePickerController,
    // but in You Doodle for iOS, I have a more complex import that allows importing from many different sources
    // *** Leave this as nil to not allowing import of textures ***
    vc.rootViewController.importBlock = ^(UINavigationController* navVC, DRColorPickerHomeViewController* rootVC, NSString* title)
    {
        UIImagePickerController* p = [[UIImagePickerController alloc] init];
        p.delegate = self;
        p.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self.colorPickerVC presentViewController:p animated:YES completion:nil];
    };
    
    // dismiss the color picker
    vc.rootViewController.dismissBlock = ^(BOOL cancel)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    // a color was selected, do something with it, but do NOT dismiss the color picker, that happens in the dismissBlock
    vc.rootViewController.colorSelectedBlock = ^(DRColorPickerColor* aColor, DRColorPickerBaseViewController* vc)
    {
        self.color = aColor;
        if (color.rgbColor == nil)
        {
            self.foregroundColor = [UIColor colorWithPatternImage:aColor.image];
            [self.sampleLabel setTextColor:self.foregroundColor];
        }
        else
        {
            self.foregroundColor = aColor.rgbColor;
            [self.sampleLabel setTextColor:self.foregroundColor];
        }
        [self.colorButton setTitleColor:self.foregroundColor forState:UIControlStateNormal];
    };
    
    // finally, present the color picker
    [self presentViewController:vc animated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    // get the image
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    if(!img) img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // tell the color picker to finish importing
    [self.colorPickerVC.rootViewController finishImport:img];
    
    // dismiss the image picker
    [self.colorPickerVC dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    // image picker cancel, just dismiss it
    [self.colorPickerVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)setPageBackground
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString* storyName = [userDefaults valueForKey:kCurrentStoryName];
    
    NSString* backgroundKey = [NSString stringWithFormat:@"%@%@", storyName, kBackgroundKey];
    
    NSString* imageName = [userDefaults valueForKey:backgroundKey];
    
    NSString* path = [[PathHelper getThemeBackgroundLocation] stringByAppendingPathComponent:imageName];
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    [self.imageView setImage:image];
}

- (IBAction)previousPage:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
