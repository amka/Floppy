//
//  PreferencesUpdateViewController.m
//  Mongod
//
//  Created by Andrey M on 14.02.15.
//  Copyright (c) 2015 Andrey M. All rights reserved.
//

#import "PreferencesUpdateViewController.h"
#import <CCNPreferencesWindowControllerProtocol.h>

@interface PreferencesUpdateViewController () <CCNPreferencesWindowControllerProtocol>

@end

@implementation PreferencesUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}
#pragma mark - CCNPreferencesWindowControllerDelegate

- (NSString *)preferenceIdentifier { return @"UpdatePreferencesIdentifier"; }
- (NSString *)preferenceTitle { return @"Update"; }
- (NSImage *)preferenceIcon { return [NSImage imageNamed:NSImageNameNetwork]; }

@end
