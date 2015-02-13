//
//  AppDelegate.h
//  MongoBox
//
//  Created by Andrey M on 03.02.15.
//  Copyright (c) 2015 Andrey M. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSMenu *mainMenu;

- (IBAction)startTask:(id)sender;
- (IBAction)stopTask:(id)sender;
- (IBAction)changeLogViewState:(id)sender;

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

