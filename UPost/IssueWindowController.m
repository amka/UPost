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

- (IBAction)sendIssueAction:(id)sender;
@end

@implementation IssueWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        
        [self getAccessibleProjects];
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
    
    NSLog(@"Create Issue in Project: %@", self.accessibleArrayController.selectedObjects[0]);
}
@end
