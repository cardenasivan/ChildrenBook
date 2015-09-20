//
//  HomeViewController.m
//  ChildrenBook
//
//  Created by Ivan Cardenas on 9/15/15.
//  Copyright (c) 2015 Ivan Cardenas. All rights reserved.
//

#import "HomeViewController.h"
#import "SelectThemeViewController.h"
#import "ChildrenBookConstants.h"
#import "SelectStoryViewController.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
     [[UIApplication sharedApplication] setStatusBarHidden:YES];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *textfield =  [alertView textFieldAtIndex: 0];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:textfield.text forKey:kCurrentStoryName];
    
    SelectThemeViewController* controller = [[SelectThemeViewController alloc] initWithNibName:@"SelectThemeViewController" bundle:nil];
    
    [self.navigationController pushViewController:controller animated:YES];
    
}
- (IBAction)createNewStory:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Storybook Adventures" message:@"Type your story name!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    alert.delegate = self;
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
    [[alert textFieldAtIndex:0] resignFirstResponder];
}

- (IBAction)viewStoryBooks:(id)sender
{
    SelectStoryViewController* controller = [[SelectStoryViewController alloc] initWithNibName:@"SelectStoryViewController" bundle:nil];
    
    [self.navigationController pushViewController:controller animated:YES];
}


@end
