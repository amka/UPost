//
//  AppDelegate.m
//  UPost
//
//  Created by Andrey M on 01.09.15.
//  Copyright (c) 2015 Andrey M. All rights reserved.
//

#import "AppDelegate.h"
#import <CCNPreferencesWindowController.h>

#import "IssueWindowController.h"
#import "PreferencesGeneralViewController.h"


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSMenu *statusBarMenu;

@property (strong) CCNPreferencesWindowController *preferences;
@property (strong) NSStatusItem *statusBarItem;
@property (strong) IssueWindowController *issueWindowController;

- (IBAction)newIssueAction:(id)sender;
- (IBAction)showPreferencesAction:(id)sender;

@end

@implementation AppDelegate

- (void)awakeFromNib {
    
    // Init statsBar Item
    self.statusBarItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    self.statusBarItem.menu = self.statusBarMenu;
    self.statusBarItem.title = @"UP⇪";
    self.statusBarItem.highlightMode = YES;
    
    // Init Preferences Controller
    self.preferences = [CCNPreferencesWindowController new];
    self.preferences.centerToolbarItems = NO;
    
    [self.preferences setPreferencesViewControllers:@[[PreferencesGeneralViewController new]]];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)newIssueAction:(id)sender {
    if (!self.issueWindowController) {
        self.issueWindowController = [[IssueWindowController alloc] initWithWindowNibName:@"IssueWindow"];
    }
    [self.issueWindowController showWindow:self];
}

- (IBAction)showPreferencesAction:(id)sender {
    
    [self.preferences showPreferencesWindow];
}
@end
