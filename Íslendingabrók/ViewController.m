//
//  ViewController.m
//  Íslendingabrók
//
//  Created by Árni Jónsson on 23.3.2013.
//  Copyright (c) 2013 Árni Jónsson. All rights reserved.
//

#import "ViewController.h"

#import "IslendingabokAPI.h"

#import "LoginViewController.h"

#import "KeychainHelper.h"

#import "MBProgressHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![[IslendingabokAPI sharedInstance] loggedIn])
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[IslendingabokAPI sharedInstance] loginWithUsername:[KeychainHelper keychainStringFromMatchingIdentifier:@"username"]
                                                    password:[KeychainHelper keychainStringFromMatchingIdentifier:@"password"]
                                                 sucessBlock:^
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             NSLog(@"logged in");
         }
                                                failureBlock:^
         {
             LoginViewController *lvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
             
             [self.navigationController setViewControllers:@[lvc] animated:YES];
             
             NSLog(@"virkði ekki");
         }];
        
        
        connection = [[ConnectionClass alloc] init];
        
        [connection connect];
    }
}

- (IBAction)bump:(id)sender
{
    [connection sendToken:[IslendingabokAPI sharedInstance].sessionId];
}

-(void)tokenReceived:(NSString*)theToken
{
    NSLog(@"token: %@", theToken);
}

@end
