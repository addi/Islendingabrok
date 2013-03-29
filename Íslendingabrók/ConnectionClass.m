//
//  ConnectionClass.m
//  Íslendingabrók
//
//  Created by Árni Jónsson on 29.3.2013.
//  Copyright (c) 2013 Árni Jónsson. All rights reserved.
//

#import "ConnectionClass.h"

#import "PTPusherChannel.h"
#import "PTPusherEvent.h"

@implementation ConnectionClass

- (void)connect
{
    NSLog(@"Try to connect to pusher");
    
    client = [PTPusher pusherWithKey:@"012e661d4e313d195ea3" connectAutomatically:NO encrypted:YES];
    
    client.delegate = self;
    
    [client connect];
}


- (void)pusher:(PTPusher *)pusher connectionDidConnect:(PTPusherConnection *)connection
{
    NSLog(@"connected to pusher");
    
    channel = [client subscribeToPrivateChannelNamed:@"theChannel"];
    
    [channel bindToEventNamed:@"shake" handleWithBlock:^(PTPusherEvent *event)
    {
        NSLog(@"Shake detected");
        
//        NSDictionary *info = event.data;
    }];
    

    
    
    
}

- (void)sendInfo
{
    [channel triggerEventNamed:@"shake" data:nil];
}



@end
