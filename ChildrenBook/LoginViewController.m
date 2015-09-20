//
//  LoginViewController.m
//  ChildrenBook
//
//  Created by Ivan Cardenas on 9/19/15.
//  Copyright © 2015 Ivan Cardenas. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)loginAction:(id)sender
{
    HomeViewController* homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    
    [self.navigationController pushViewController:homeViewController animated:YES];
}

@end
