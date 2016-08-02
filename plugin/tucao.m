//
//  vp-tucao.m
//  vp-tucao
//
//  Created by TYPCN on 2016/8/2.
//  Copyright © 2016 TYPCN. All rights reserved.
//

#import "tucao.h"
#import "SP_Tucao.h"
#import "VP_Tucao.h"

@interface tucao (){
    NSString *playAddr;
    VP_Tucao *vp;
    SP_Tucao *sp;
}

@property (strong) NSWindowController* settingsPanel;

@end

@implementation tucao

@synthesize settingsPanel;

- (bool)load:(int)version{
    
    vp = [[VP_Tucao alloc] init];
    sp = [[SP_Tucao alloc] init];
    
    NSLog(@"VP-tucao is loaded");
    
    return true;
}


- (bool)unload{
    return true;
}

- (bool)canHandleEvent:(NSString *)eventName{
    return false;
}

- (NSString *)processEvent:(NSString *)eventName :(NSString *)eventData{
    return NULL;
}

- (id)getClassOfType:(NSString *)type{
    if([type isEqualToString:@"SubProvider"]){
        return sp;
    }else if([type isEqualToString:@"VideoProvider"]){
        return vp;
    }
    return NULL;
}

- (void)openSettings{
    NSLog(@"Show tucao settings");
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        NSString *path = [[NSBundle bundleForClass:[self class]]
                          pathForResource:@"Settings" ofType:@"nib"];
        settingsPanel =[[NSWindowController alloc] initWithWindowNibPath:path owner:self];
        [settingsPanel showWindow:self];
        [settingsPanel.window makeKeyAndOrderFront:self];
    });
    return;
}


@end

