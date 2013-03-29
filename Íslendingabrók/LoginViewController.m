//
//  LoginViewController.m
//  Íslendingabrók
//
//  Created by Árni Jónsson on 25.3.2013.
//  Copyright (c) 2013 Árni Jónsson. All rights reserved.
//

#import "LoginViewController.h"

#import "IslendingabokAPI.h"

#import "ViewController.h"

#import "MBProgressHUD.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[IslendingabokAPI sharedInstance] loginWithUsername:usernameField.text
                                                password:passwordField.text
                                             sucessBlock:^
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         ViewController *vc = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
         
         [self.navigationController setViewControllers:@[vc] animated:YES];
         
         NSLog(@"virkði");
     }
                                            failureBlock:^
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         NSLog(@"virkði ekki");
     }];
    
    
    [self.view endEditing:YES];
}


@end
