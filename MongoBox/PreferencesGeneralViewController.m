//
//  PreferencesGeneralViewController.m
//  Mongod
//
//  Created by Andrey M on 14.02.15.
//  Copyright (c) 2015 Andrey M. All rights reserved.
//

#import "PreferencesGeneralViewController.h"
#import <CCNPreferencesWindowControllerProtocol.h>

@interface PreferencesGeneralViewController () <CCNPreferencesWindowControllerProtocol>

@end

@implementation PreferencesGeneralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

#pragma mark - CCNPreferencesWindowControllerDelegate

- (NSString *)preferenceIdentifier { return @"GeneralPreferencesIdentifier"; }
- (NSString *)preferenceTitle { return @"General"; }
- (NSImage *)preferenceIcon { return [NSImage imageNamed:NSImageNamePreferencesGeneral]; }

- (IBAction)revealInFinder:(id)sender {
}

- (IBAction)selectDBDirectory:(id)sender {
}
@end
