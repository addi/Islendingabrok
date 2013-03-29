//
//  LoginViewController.h
//  Íslendingabrók
//
//  Created by Árni Jónsson on 25.3.2013.
//  Copyright (c) 2013 Árni Jónsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
{
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
}

- (IBAction)login:(id)sender;


@end