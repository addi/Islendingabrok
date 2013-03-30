//
//  ConnectionDelegate.h
//  Íslendingabrók
//
//  Created by Árni Jónsson on 29.3.2013.
//  Copyright (c) 2013 Árni Jónsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConnectionDelegate <NSObject>

-(void)tokenReceived:(NSString*)theToken;

@end
