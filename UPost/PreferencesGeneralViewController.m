//
//  PreferencesGeneralViewController.m
//  UPost
//
//  Created by Andrey M on 06.09.15.
//  Copyright (c) 2015 Andrey M. All rights reserved.
//

#import "PreferencesGeneralViewController.h"
#import <CCNPreferencesWindowController.h>

@interface PreferencesGeneralViewController () <CCNPreferencesWindowControllerProtocol>

@property NSString *userFullname;
@property NSString *userEmail;

@property (weak) IBOutlet NSView *signinFormView;
@property (strong) IBOutlet NSView *signInView;
@property (strong) IBOutlet NSView *signedView;

- (IBAction)signInAction:(id)sender;
- (IBAction)signOutAction:(id)sender;

@end

@implementation PreferencesGeneralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self.signinFormView addSubview:self.signInView];
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

- (IBAction)signInAction:(id)sender {
    
    [self.signinFormView replaceSubview:self.signInView with:self.signedView];
}

- (IBAction)signOutAction:(id)sender {
    [self.signinFormView replaceSubview:self.signedView with:self.signInView];
}
@end
