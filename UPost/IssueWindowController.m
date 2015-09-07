//
//  IssueWindowController.m
//  UPost
//
//  Created by Andrey M on 06.09.15.
//  Copyright (c) 2015 Andrey M. All rights reserved.
//

#import "IssueWindowController.h"

#import "YTAPIManager.h"

@interface IssueWindowController ()

@property NSMutableArray *ytAccessiblePojects;
@property (strong) IBOutlet NSArrayController *accessibleArrayController;

@property (weak) IBOutlet NSTextField *titleField;
@property (weak) IBOutlet NSTextField *descriptionField;
@property (weak) IBOutlet NSPopUpButton *priorityField;
@property (weak) IBOutlet NSPopUpButton *stateField;

- (IBAction)sendIssueAction:(id)sender;

@end

@implementation IssueWindowController

- (void)showWindow:(id)sender {
    [super showWindow:sender];
    [self getAccessibleProjects];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        // Init
    }
    return self;
}

- (void)getAccessibleProjects {
    [[YTAPIManager sharedManager] GET:@"/rest/project/all" parameters:nil success:^(AFHTTPRequestOperation *operatino, id responseObject) {
        // S
        NSXMLElement *userElement = [responseObject rootElement];
        NSArray *projectsElements = [userElement elementsForName:@"project"];
        
        NSLog(@"SUC: %@", projectsElements);
        
        NSRange range = NSMakeRange(0, [[self.accessibleArrayController arrangedObjects] count]);
        [self.accessibleArrayController removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        
        for(NSXMLElement *project in projectsElements) {
            NSDictionary *projectData = @{@"name": [[project attributeForName:@"name"] stringValue],
                                          @"shortName": [[project attributeForName:@"shortName"] stringValue]};
            NSLog(@"projectData: %@", projectData);
            [self.accessibleArrayController addObject:projectData];
        }
        
        NSInteger lastSelectedProjectIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"Last Selected Project"];
        if (lastSelectedProjectIndex) {
            [self.accessibleArrayController setSelectionIndex:lastSelectedProjectIndex];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // F
        NSLog(@"ERR: %@", error.description);
    }];
}

- (IBAction)sendIssueAction:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setInteger:self.accessibleArrayController.selectionIndex forKey:@"Last Selected Project"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.titleField.stringValue.length <= 0) {
        [self.titleField becomeFirstResponder];
    }
    
    if (self.descriptionField.stringValue.length <= 0) {
        [self.descriptionField becomeFirstResponder];
    }

    NSDictionary *newIssueParams = @{@"project":[self.accessibleArrayController.selectedObjects[0] objectForKey:@"shortName"],
                                     @"summary":self.titleField.stringValue,
                                     @"description": self.descriptionField.stringValue};
    NSLog(@"Create Issue with data %@", newIssueParams);
    
    [[YTAPIManager sharedManager] POST:@"/rest/issue" parameters:newIssueParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // S
        NSXMLElement *root = [responseObject rootElement];
        NSLog(@"SUC: %ld %@", operation.response.statusCode, responseObject);
        
        
        NSUserNotification *notification = [NSUserNotification new];
        notification.title = @"UPost";
        
        NSString *issueURLString = [NSString stringWithFormat:@"%@/issue/%@",
                                    [[YTAPIManager sharedManager] baseURL],
                                    [[root attributeForName:@"id"] stringValue]];
        
        NSLog(@"Issue URL: %@", issueURLString);
        notification.userInfo = @{@"IssueURLString": issueURLString};
        
        // Send user notification
        notification.informativeText = NSLocalizedString(@"Issue successfulle created!", @"issue successfully created");
        notification.soundName = @"Glass";
        notification.hasActionButton = YES;
        notification.actionButtonTitle = NSLocalizedString(@"View issue", @"view issue");
        
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // F
        NSLog(@"ERR: %@", error.description);
        
        NSUserNotification *notification = [NSUserNotification new];
        notification.title = @"UPost";
        // Notify user 'bout failed action
        notification.informativeText = NSLocalizedString(@"Failed to create issue", @"failed to create issue");
        notification.soundName = @"Basso";
        notification.hasActionButton = YES;
        notification.actionButtonTitle = NSLocalizedString(@"New issue", @"view issue");
        
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
        
    }];
}

@end
