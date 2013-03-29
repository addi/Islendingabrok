//
//  KeychainHelper.h
//  One Word
//
//  Created by Árni Jónsson on 24.1.2013.
//  Copyright (c) 2013 Árni Jónsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainHelper : NSObject

+ (BOOL)createKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier;
+ (NSString *)keychainStringFromMatchingIdentifier:(NSString *)identifier;
+ (void)deleteItemFromKeychainWithIdentifier:(NSString *)identifier;

@end
