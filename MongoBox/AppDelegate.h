//
//  AppDelegate.h
//  MongoBox
//
//  Created by Andrey M on 03.02.15.
//  Copyright (c) 2015 Andrey M. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CCNPreferencesWindowController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property CCNPreferencesWindowController *preferences;
@property (weak) IBOutlet NSMenu *mainMenu;
@property (weak) IBOutlet NSTextField *welcomeLabel;

- (IBAction)showLogView:(id)sender;
- (IBAction)openPreferences:(id)sender;
- (void)startTask:(id)sender;
- (void)stopTask:(id)sender;

@property (weak) IBOutlet NSMenuItem *openPreferences;
@property (unsafe_unretained) IBOutlet NSTextView *logView;

@property (weak) IBOutlet NSMenuItem *mongoStateMenuItem;

/**
 * NSTask
 */
@property (nonatomic, strong) __block NSTask *mongoTask;
@property (nonatomic) BOOL isRunning;
@property (nonatomic, strong) NSPipe *outputPipe;

@end

