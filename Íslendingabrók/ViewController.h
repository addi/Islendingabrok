//
//  ViewController.h
//  Íslendingabrók
//
//  Created by Árni Jónsson on 23.3.2013.
//  Copyright (c) 2013 Árni Jónsson. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ConnectionClass.h"

@interface ViewController : UIViewController
{
    ConnectionClass *connection;
}

- (IBAction)bump:(id)sender;

@end
