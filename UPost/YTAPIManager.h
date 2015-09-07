//
//  YTAPIManager.h
//  UPost
//
//  Created by Andrey M on 06.09.15.
//  Copyright (c) 2015 Andrey M. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface YTAPIManager : AFHTTPRequestOperationManager

@property (strong) NSURL *baseURL;

//- (void)setUsername:(NSString *)username andPassword:(NSString *)password;
- (void)clearAuth;
- (void)setBaseURL:(NSURL *)baseURL;

+ (YTAPIManager *)sharedManager;

@end
