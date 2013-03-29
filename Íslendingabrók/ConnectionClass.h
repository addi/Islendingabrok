//
//  ConnectionClass.h
//  Íslendingabrók
//
//  Created by Árni Jónsson on 29.3.2013.
//  Copyright (c) 2013 Árni Jónsson. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PTPusher.h"

@interface ConnectionClass : NSObject <PTPusherDelegate>
{
    PTPusher *client;
    
    PTPusherPrivateChannel *channel;
}

- (void)connect;

- (void)sendInfo;

@end
