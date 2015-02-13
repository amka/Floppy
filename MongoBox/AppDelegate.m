//
//  AppDelegate.m
//  MongoBox
//
//  Created by Andrey M on 03.02.15.
//  Copyright (c) 2015 Andrey M. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (weak) IBOutlet NSWindow *logWindow;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSURL *defaultPrefsFile = [[NSBundle mainBundle] URLForResource:@"DefaultPreferences" withExtension:@"plist"];
    NSMutableDictionary *defaultPrefs = [NSMutableDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
    [defaultPrefs setValue:[NSHomeDirectory() stringByAppendingString:@"/MongoDB"] forKey:@"DBPath"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.menu = self.mainMenu;
    self.statusItem.image = [NSImage imageNamed:@"Floppy"];
    self.statusItem.alternateImage = [NSImage imageNamed:@"FloppyAlt"];
    
    // Check or create DB folder
    if ([self makeDBPath:[[NSUserDefaults standardUserDefaults] stringForKey:@"DBPath"]] == NO) {
        self.logView.string = NSLocalizedString(@"Can not create DB directory", @"");
    } else {
        [self startTask:nil];
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [self stopTask:nil];
}

- (BOOL)makeDBPath:(NSString *)path {
    // Check if DB dir exists and try to creata one if it's not
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path] == YES) {
        return YES;
    } else {
        NSError *error;
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error == nil) {
            return YES;
        } else {
            self.logView.string = error.localizedDescription;
        }
    }
    return NO;
}

- (IBAction)changeLogViewState:(id)sender {
    [self.logWindow makeKeyAndOrderFront:self];
}

- (void)startTask:(id)sender {
    self.logView.string = @"";
    
    NSString *dataLocation    = [NSString stringWithFormat:@"--dbpath=%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"DBPath"]];
    NSLog(@"--dbpath=%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"DBPath"]);
    
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    [arguments addObject:dataLocation];
//    [self.buildButton setEnabled:NO];
//    [self.spinner startAnimation:self];
    
    [self runScript:arguments];
}

- (void)stopTask:(id)sender {
    // Empty yet
    if (self.mongoTask.isRunning) {
        [self.mongoTask terminate];
    }
}

- (void)runScript:(NSArray*)arguments {
    
    dispatch_queue_t taskQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(taskQueue, ^{
        
        self.isRunning = YES;
        self.mongoStateMenuItem.title = @"Starting Mongo…";
        
        @try {
            
            NSString *path = [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] pathForResource:@"mongod" ofType:@"" inDirectory:@"mongo"]];
            
            NSLog(@"path: %@", path);
            
            self.mongoTask = [[NSTask alloc] init];
            self.mongoTask.launchPath = path;
            self.mongoTask.arguments = arguments;
            
            // Output Handling
            self.outputPipe               = [[NSPipe alloc] init];
            self.mongoTask.standardOutput = self.outputPipe;
            
            [[self.outputPipe fileHandleForReading] waitForDataInBackgroundAndNotify];
            
            [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification object:[self.outputPipe fileHandleForReading] queue:nil usingBlock:^(NSNotification *notification){
                
                NSData *output = [[self.outputPipe fileHandleForReading] availableData];
                NSString *outStr = [[NSString alloc] initWithData:output encoding:NSUTF8StringEncoding];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.logView.string = [self.logView.string stringByAppendingString:[NSString stringWithFormat:@"%@", outStr]];
                    // Scroll to end of outputText field
                    NSRange range;
                    range = NSMakeRange([self.logView.string length], 0);
                    [self.logView scrollRangeToVisible:range];
                });
                
                [[self.outputPipe fileHandleForReading] waitForDataInBackgroundAndNotify];
            }];
            
            [self.mongoTask launch];
            self.mongoStateMenuItem.title = @"Running on port 27017";
            
            [self.mongoTask waitUntilExit];
        }
        @catch (NSException *exception) {
            NSLog(@"Problem Running Task: %@", [exception description]);
        }
        @finally {
//            [self.buildButton setEnabled:YES];
//            [self.spinner stopAnimation:self];
            self.mongoStateMenuItem.title = @"Mongo stopped";
            self.isRunning = NO;
        }
    });
}

@end
