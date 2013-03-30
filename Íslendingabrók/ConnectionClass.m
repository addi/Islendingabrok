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

@synthesize delegate;

- (void)connect
{
    NSLog(@"Try to connect to pusher");
    
    client = [PTPusher pusherWithKey:@"012e661d4e313d195ea3" connectAutomatically:NO encrypted:YES];
    
    client.authorizationURL = [NSURL URLWithString:@"http://ibpusherauth.appspot.com/pusher/auth"];
    
    client.delegate = self;
    
    [client connect];
    
    channel = [client subscribeToPrivateChannelNamed:@"bla"];
    
    [channel bindToEventNamed:@"client-token" handleWithBlock:^(PTPusherEvent *event)
     {
         NSLog(@"Shake detected");
         
         NSString *strangersToken = [event.data valueForKey:@"token"];
         
         [delegate tokenReceived:strangersToken];
     }];
}

- (void)pusher:(PTPusher *)pusher connectionDidConnect:(PTPusherConnection *)connection
{
    NSLog(@"connected to pusher");
}

- (void)pusher:(PTPusher *)pusher didSubscribeToChannel:(PTPusherChannel *)channel
{
    NSLog(@"didSubscribeToChannel");    
}

- (void)pusher:(PTPusher *)pusher didReceiveErrorEvent:(PTPusherErrorEvent *)errorEvent
{
    
    NSLog(@"ERROR: %@", errorEvent.description);
}

- (void)sendToken:(NSString*)authToken
{
    NSLog(@"sending info");
    
    NSDictionary *tokenDict = @{@"token": authToken};
    
    [channel triggerEventNamed:@"token" data:tokenDict];
}

@end
