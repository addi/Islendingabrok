//
//  IslendingabokAPI.h
//  Íslendingabrók
//
//  Created by Árni Jónsson on 23.3.2013.
//  Copyright (c) 2013 Árni Jónsson. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

@interface IslendingabokAPI : NSObject
{
    NSString *baseURLString;
    NSURL *baseURL;
    
    NSString *sessionId;
    NSString *sessionUserId;
}

@property (readonly) NSString *sessionId;

+ (IslendingabokAPI *)sharedInstance;

- (BOOL)loggedIn;

- (void)loginWithUsername:(NSString*)theUsername
                 password:(NSString*)thePassword
              sucessBlock:(void (^)())sucessBlock
             failureBlock:(void (^)())failureBlock;

- (void)getPersonWithId:(NSString*)theId
            sucessBlock:(void (^)(NSDictionary *person))sucessBlock
           failureBlock:(void (^)())failureBlock;

- (void)requestApiWithAction:(NSString*)action
                  parameters:(NSDictionary*)parameters
                jsonResponse:(BOOL)jsonResponse
                 sucessBlock:(void (^)(id response))compeletionBlock
                failureBlock:(void (^)())failureBlock;

- (BOOL)parseLoginResponse:(NSString*)theResponse;

@end
