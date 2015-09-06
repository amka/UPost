//
//  YTAPIManager.m
//  UPost
//
//  Created by Andrey M on 06.09.15.
//  Copyright (c) 2015 Andrey M. All rights reserved.
//

#import "YTAPIManager.h"

#import <AFNetworking/AFNetworking.h>

@implementation YTAPIManager

//- (void)setUsername:(NSString *)username andPassword:(NSString *)password {
//    [self.requestSerializer clearAuthorizationHeader];
//    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
//}


- (id)initWithBaseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [AFXMLDocumentResponseSerializer serializer];
    }
    return self;
}

- (id) init {
    if (self = [super init]) {
        
    }
    return self;
}

+ (YTAPIManager *)sharedManager {
    static dispatch_once_t pred;
    static YTAPIManager *_sharedManager = nil;
    
    NSURL *url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"Youtrack URL"]];
    
    dispatch_once(&pred, ^{_sharedManager = [[self alloc] initWithBaseURL:url]; });
    return _sharedManager;
}

- (void)clearAuth {
    [self.requestSerializer clearAuthorizationHeader];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
