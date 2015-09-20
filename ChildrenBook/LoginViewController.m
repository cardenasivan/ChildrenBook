//
//  LoginViewController.m
//  ChildrenBook
//
//  Created by Ivan Cardenas on 9/19/15.
//  Copyright © 2015 Ivan Cardenas. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "GTMOAuth2ViewControllerTouch.h"

@interface LoginViewController ()
@property (nonatomic, strong) GTMOAuth2Authentication* auth;
@end

@implementation LoginViewController
@synthesize auth;

#define GoogleAuthURL   @"https://accounts.google.com/o/oauth2/auth"
#define GoogleTokenURL  @"https://accounts.google.com/o/oauth2/token"
#define GoogleClientID @"405054308509-h4dr7okf3l1kqifhcjda8eqsk5e2aqqf.apps.googleusercontent.com"
#define GoogleClientSecret @"dbSuV0grCHX5SWNPIeS46kJA"

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
     [[UIApplication sharedApplication] setStatusBarHidden:YES];
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

-(IBAction)SignInGoogleButtonClicked:(id)sender
{
    [self signInToGoogle];
}

- (GTMOAuth2Authentication * )authForGoogle
{
    NSURL * tokenURL = [NSURL URLWithString:GoogleTokenURL];
    
    NSString * redirectURI = @"urn:ietf:wg:oauth:2.0:oob";
    
    self.auth = [GTMOAuth2Authentication authenticationWithServiceProvider:@"Google"
                                                              tokenURL:tokenURL
                                                           redirectURI:redirectURI
                                                              clientID:GoogleClientID
                                                          clientSecret:GoogleClientSecret];
    self.auth.scope = @"https://www.googleapis.com/auth/userinfo.profile";
    return self.auth;
}


- (void)signInToGoogle
{
    self.auth = [self authForGoogle];
    
    // Display the authentication view
    GTMOAuth2ViewControllerTouch * viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithAuthentication:self.auth
                                                                                                authorizationURL:[NSURL URLWithString:GoogleAuthURL]
                                                                                                keychainItemName:@"GoogleKeychainName"
                                                                                                        delegate:self
                                                                                                finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error
{
    if (error != nil) {
        NSString *output=nil;
        output = [error description];
        NSLog(@"output:%@",output);
        UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                       message:[NSString stringWithFormat:@"Error, Authentication failed!\n %@",error]
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:@"Try again", nil];
        fail.tag = 1;
        
        [fail show];
        NSLog(@"Authentication failed!");
    } else {
        UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                          message:[NSString stringWithFormat:@"Authentication succeeded!"]
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        success.tag = 2;
        
        [success show];
        NSLog(@"Autzentication succeeded!");
    }
}

@end
