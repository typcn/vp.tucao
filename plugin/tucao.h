//
//  vp-tucao.h
//  vp-tucao
//
//  Created by TYPCN on 2016/8/2.
//  Copyright © 2016 TYPCN. All rights reserved.
//

#ifndef vp_tucao_h
#define vp_tucao_h

#import <Cocoa/Cocoa.h>
#import <VPPlugin/VPPlugin.h>

@interface tucao : VP_Plugin

// trigger on load , version is program build number ( eg: 206 )
- (bool)load:(int)version;

// trigger on unload , do cleanup
- (bool)unload;

// trigger when event from javascript , return true or false
- (bool)canHandleEvent:(NSString *)eventName;

// trigger when event from javascript , return video url to play , reutrn NULL won't do anything
- (NSString *)processEvent:(NSString *)eventName :(NSString *)eventData;

// trigger when user click "settings"
- (void)openSettings;

@end


#endif /* vp_tucao_h */
