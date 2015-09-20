//
//  CanvasVC.m
//  Drawing Hackathon
//
//  Created by Martin, Greg on 9/16/15.
//  Copyright (c) 2015 Martin, Greg. All rights reserved.
//

#import "CanvasVC.h"
#import "SmoothedBIView.h"
#import "PathHelper.h"
#import "SelectThemeViewController.h"
#import "DRColorPicker.h"

@interface CanvasVC ()

@property(nonatomic, strong) SmoothedBIView* drawingView;
@property (nonatomic, strong) DRColorPickerColor* color;
@property (nonatomic, weak) DRColorPickerViewController* colorPickerVC;
@property (nonatomic, strong) UIColor* foregroundColor;
@property (nonatomic, strong) IBOutlet UILabel* sampleLabel;

@end

@implementation CanvasVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.drawingView = [[SmoothedBIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.bounds.size.height)];
    
    UIButton* eraserBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 40, 25, 75)];
    
    UIButton* saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(850, 40, 150, 60)];
    
    UIButton* colorBtn = [[UIButton alloc] initWithFrame:CGRectMake(450, 40, 150, 60)];

    [eraserBtn setImage:[UIImage imageNamed:@"Eraser.png"] forState:UIControlStateNormal];

    [saveBtn setBackgroundColor:[UIColor whiteColor]];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [colorBtn setBackgroundColor:[UIColor whiteColor]];
    [colorBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [colorBtn setTitle:@"Pick a Color" forState:UIControlStateNormal];
    
    [eraserBtn setTag:9];
    [eraserBtn addTarget:self action:@selector(colorChange:) forControlEvents:UIControlEventTouchUpInside];
    
    [saveBtn addTarget:self action:@selector(saveButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [colorBtn addTarget:self action:@selector(showColorPickerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.drawingView];
    [self.view addSubview:eraserBtn];
    [self.view addSubview:colorBtn];
    [self.view addSubview:saveBtn];
    // Do any additional setup after loading the view from its nib.
    
}

- (IBAction)colorChange:(id)sender
{
    UIButton* button = (UIButton*)sender;
    switch (button.tag) {
        case 9:
            self.drawingView.lineColor = [UIColor clearColor];
            self.drawingView.lineWidth = 10.0;
            break;
        default:
            break;
    }
}

- (IBAction)saveButton:(id)sender
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter a file Name" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}


-(void)saveImage:(NSString*)fileName
{
    NSData* imdata = UIImagePNGRepresentation(self.drawingView.incrementalImage);
    
    NSString* filePath = [[PathHelper getThemeBackgroundLocation] stringByAppendingPathComponent:fileName]; //append filename
    
    [imdata writeToFile:filePath atomically:YES];
    
    [self.popoverController dismissPopoverAnimated:YES];
    
    [self.parentController reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *textfield =  [alertView textFieldAtIndex: 0];
    
    NSString* fileName = textfield.text;
    
    fileName = [fileName stringByAppendingString:@".png"];
    
    [self saveImage:fileName];
}

- (NSString*) getGeneralPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = nil;
    if (paths !=nil)
    {
        docDir = [paths objectAtIndex:0];
    }
    return docDir;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.drawingView = nil;
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
    vc.rootViewController.colorSelectedBlock = ^(DRColorPickerColor* color, DRColorPickerBaseViewController* vc)
    {
        self.color = color;
        if (color.rgbColor == nil)
        {
            self.foregroundColor = [UIColor colorWithPatternImage:color.image];
            [self.sampleLabel setTextColor:self.foregroundColor];
        }
        else
        {
            self.foregroundColor = color.rgbColor;
            [self.sampleLabel setTextColor:self.foregroundColor];
        }
        self.drawingView.lineColor = self.foregroundColor;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

