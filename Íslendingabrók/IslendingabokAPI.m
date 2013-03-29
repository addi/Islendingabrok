//
//  IslendingabokAPI.m
//  Íslendingabrók
//
//  Created by Árni Jónsson on 23.3.2013.
//  Copyright (c) 2013 Árni Jónsson. All rights reserved.
//

#import "IslendingabokAPI.h"

#import "JSONKit.h"

#import "KeychainHelper.h"

@implementation IslendingabokAPI

@synthesize sessionId;

static IslendingabokAPI *instance = nil;

+ (IslendingabokAPI *)sharedInstance
{
    if(instance == nil)
    {
        instance = [[IslendingabokAPI alloc] init];
    }
    
    return instance;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        baseURLString = @"http://www.islendingabok.is/ib_app/";
        baseURL = [[NSURL alloc] initWithString:baseURLString];
    }
    
    return self;
}

- (BOOL)loggedIn
{
    if(sessionId)
        return YES;
    else
        return NO;
}

- (void)loginWithUsername:(NSString*)theUsername
                 password:(NSString*)thePassword
              sucessBlock:(void (^)())sucessBlock
             failureBlock:(void (^)())failureBlock
{
    NSDictionary *parameters = @{@"user": theUsername,
                                 @"pwd": thePassword};
    
    [self requestApiWithAction:@"login"
                    parameters:parameters
                  jsonResponse:NO
                   sucessBlock:^(id response)
    {
        NSString *responseString = response;
        
        BOOL parseWorked = [self parseLoginResponse:responseString];
        
        if (parseWorked)
        {
            sucessBlock();
            
            [KeychainHelper createKeychainValue:theUsername forIdentifier:@"username"];
            [KeychainHelper createKeychainValue:thePassword forIdentifier:@"password"];
        }
        else
        {
            failureBlock();
        }
    }
                  failureBlock:^
    {
        failureBlock();
        
        NSLog(@"ERROR");
    }];
}

- (void)getPersonWithId:(NSString*)theId
            sucessBlock:(void (^)(NSDictionary *person))sucessBlock
           failureBlock:(void (^)())failureBlock
{
    NSDictionary *parameters = @{@"id": theId};
    
    [self requestApiWithAction:@"get"
                    parameters:parameters
                  jsonResponse:YES
                   sucessBlock:^(id response)
     {
         NSDictionary *responseDict = response;
         
         NSLog(@"response: %@", responseDict);
     }
                  failureBlock:^
     {
         failureBlock();
         
         NSLog(@"ERROR");
     }];
}

- (void)requestApiWithAction:(NSString*)action
                  parameters:(NSDictionary*)parameters
                jsonResponse:(BOOL)jsonResponse
                 sucessBlock:(void (^)(id response))compeletionBlock
                failureBlock:(void (^)())failureBlock
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    NSString *path = [NSString stringWithFormat:@"/ib_app/%@", action];
    
    NSMutableDictionary *allParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    if(sessionId)
    {
        [allParameters setValue:sessionId forKey:@"session"];
    }
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:allParameters];
    
    NSLog(@"URL: %@", [request.URL absoluteString]);
        
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"response: '%@'", operation.responseString);
         
         if (jsonResponse)
         {
             NSString *fixedString = [operation.responseString stringByReplacingOccurrencesOfString:@"(\\w+)\\s*:"
                                                                                                withString:@"\"$1\":"
                                                                                                   options:NSRegularExpressionSearch
                                                                                                     range:NSMakeRange(0, [operation.responseString length])];
             
             NSDictionary *output = [fixedString objectFromJSONString];
                          
             compeletionBlock(output);
         }
         else
         {
             compeletionBlock(operation.responseString);
         }
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         
         failureBlock();
     }];
    
    [operation start];
}

- (BOOL)parseLoginResponse:(NSString*)theResponse
{
    NSArray *parts = [theResponse componentsSeparatedByString:@","];
    
    if([parts count] == 2)
    {
        sessionId = [parts objectAtIndex:0];
        sessionUserId = [parts objectAtIndex:1];
        
        return YES;
    }
    
    return NO;
}

@end
