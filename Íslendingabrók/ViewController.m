//
//  ViewController.m
//  Íslendingabrók
//
//  Created by Árni Jónsson on 23.3.2013.
//  Copyright (c) 2013 Árni Jónsson. All rights reserved.
//

#import "ViewController.h"

#import "IslendingabokAPI.h"

#import "BumpClient.h"

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
    }
    
    [BumpClient configureWithAPIKey:@"f55dbe46688746a88cf759b3a49b3ebb" andUserID:[[UIDevice currentDevice] name]];
    
    [[BumpClient sharedClient] setMatchBlock:^(BumpChannelID channel)
    {
        NSLog(@"Matched with user: %@", [[BumpClient sharedClient] userIDForChannel:channel]);
    
        [[BumpClient sharedClient] confirmMatch:YES onChannel:channel];
    }];
    
    [[BumpClient sharedClient] setChannelConfirmedBlock:^(BumpChannelID channel)
    {
        NSLog(@"Channel with %@ confirmed.", [[BumpClient sharedClient] userIDForChannel:channel]);
        
        if ([[IslendingabokAPI sharedInstance] loggedIn])
        {
            NSLog(@"Sending: %@", [IslendingabokAPI sharedInstance].sessionId);
            
            NSData *sendData = [[IslendingabokAPI sharedInstance].sessionId dataUsingEncoding:NSUTF8StringEncoding];
            
            [[BumpClient sharedClient] sendData:sendData toChannel:channel];
        }
    }];
    
    [[BumpClient sharedClient] setDataReceivedBlock:^(BumpChannelID channel, NSData *data)
    {
        
        
        NSString *receivedString =[NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding];
        
        NSLog(@"Data received from %@: %@",
              [[BumpClient sharedClient] userIDForChannel:channel],
              receivedString);
    }];
    
    // optional callback
    [[BumpClient sharedClient] setConnectionStateChangedBlock:^(BOOL connected)
    {
        if (connected)
        {
            NSLog(@"Bump connected...");
        }
        else
        {
            NSLog(@"Bump disconnected...");
        }
    }];
    
    // optional callback
    [[BumpClient sharedClient] setBumpEventBlock:^(bump_event event)
    {
        switch(event)
        {
            case BUMP_EVENT_BUMP:
                NSLog(@"Bump detected.");
                break;
            case BUMP_EVENT_NO_MATCH:
                NSLog(@"No match.");
                break;
        }
    }];
    
//    [[IslendingabokAPI sharedInstance] getPersonWithId:@"4075090" sucessBlock:^(NSDictionary *person)
//     {
//         NSLog(@"virkaði fuck yeah");
//     }
//                                          failureBlock:^
//     {
//         NSLog(@"erorrorororororor");
//     }];
}

- (IBAction)bump:(id)sender
{
    [[BumpClient sharedClient] simulateBump];
}

@end
