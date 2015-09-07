//
//  PreferencesGeneralViewController.m
//  UPost
//
//  Created by Andrey M on 06.09.15.
//  Copyright (c) 2015 Andrey M. All rights reserved.
//

#import "PreferencesGeneralViewController.h"
#import <CCNPreferencesWindowController.h>

#import "YTAPIManager.h"

@interface PreferencesGeneralViewController () <CCNPreferencesWindowControllerProtocol>

@property NSString *userFullname;
@property NSString *userEmail;
@property NSURL *userAvatarURL;

@property (weak) IBOutlet NSView *signinFormView;
@property (strong) IBOutlet NSView *signInView;
@property (strong) IBOutlet NSView *signedView;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

@property (weak) IBOutlet NSTextField *youtrackHost;
@property (weak) IBOutlet NSTextField *youtrackLogin;
@property (weak) IBOutlet NSSecureTextField *youtrackPassword;

- (IBAction)signInAction:(id)sender;
- (IBAction)signOutAction:(id)sender;

@end

@implementation PreferencesGeneralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self.signinFormView addSubview:self.signInView];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Youtrack URL"]) {
        [self fillCurrentUserInfo];
    }
}

- (instancetype)init {
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        
    }
    return self;
}

#pragma mark - CCNPreferencesWindowControllerDelegate

- (NSString *)preferenceIdentifier { return @"GeneralPreferencesIdentifier"; }
- (NSString *)preferenceTitle { return @"General"; }
- (NSImage *)preferenceIcon { return [NSImage imageNamed:NSImageNamePreferencesGeneral]; }


# pragma mark — Preferences Actions

- (IBAction)signInAction:(id)sender {
    
    if (_youtrackHost.stringValue.length <= 0) {
        [_youtrackHost becomeFirstResponder];
    } else {
        [[YTAPIManager sharedManager] setBaseURL:[NSURL URLWithString:self.youtrackHost.stringValue]];
    }
    
    if (_youtrackLogin.stringValue.length <= 0) {
        [_youtrackLogin becomeFirstResponder];
    }
    
    if (_youtrackPassword.stringValue.length <= 0) {
        [_youtrackPassword becomeFirstResponder];
    }
    
    [self disableYoutrackFields];
    [self.progressIndicator startAnimation:nil];
    
    NSLog(@"YT BASE URL: %@", [[YTAPIManager sharedManager] baseURL]);
    
    // Init Youtrack REST Client Singleton
    [[YTAPIManager sharedManager] clearAuth];
    
    NSDictionary *signinParams = @{@"login": self.youtrackLogin.stringValue, @"password": self.youtrackPassword.stringValue};
    
    // Try to sign in
    [[YTAPIManager sharedManager] POST:@"/rest/user/login" parameters:signinParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // S
        NSLog(@"GOT SIGNIN DATA: %@", responseObject);
        [self fillCurrentUserInfo];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // F
        NSLog(@"GOT AN ERROR: %@", error.description);
        [self.progressIndicator stopAnimation:nil];
        [self enableYoutrackFields];
    }];
}

- (IBAction)signOutAction:(id)sender {
    // Clear auth headers
    [[YTAPIManager sharedManager] clearAuth];
    
    // And swap signed view to sign in form
    [self.signinFormView replaceSubview:self.signedView with:self.signInView];
}

- (void)fillCurrentUserInfo {
    [[YTAPIManager sharedManager] GET:@"/rest/user/current" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // S
        NSXMLElement *userElement = [responseObject rootElement];
        self.userFullname = [[userElement attributeForName:@"fullName"] stringValue];
        self.userEmail = [[userElement attributeForName:@"email"] stringValue];
        self.userAvatarURL = [NSURL URLWithString:[[userElement attributeForName:@"avatar"] stringValue]];
        
//        NSLog(@"GOT USER DATA: %@", [responseObject elementsForName:@"user"]);
        [self.progressIndicator stopAnimation:nil];
        [self.signinFormView replaceSubview:self.signInView with:self.signedView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // F
        NSLog(@"GOT AN ERROR: %@", error.description);
        [self.progressIndicator stopAnimation:nil];
        [self.signinFormView replaceSubview:self.signedView with:self.signInView];
    }];
    
    [self enableYoutrackFields];
}


#pragma mark — UI bulk changes

- (void)disableYoutrackFields {
    self.youtrackHost.enabled = self.youtrackLogin.enabled = self.youtrackPassword.enabled = NO;
}


- (void)enableYoutrackFields {
    self.youtrackHost.enabled = self.youtrackLogin.enabled = self.youtrackPassword.enabled = YES;
}
@end
