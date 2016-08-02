//
//  SP_Tucao.m
//  vp_tucao
//
//  Created by TYPCN on 2016/8/2.
//  Copyright © 2016 TYPCN. All rights reserved.
//

#import "SP_Tucao.h"

@implementation SP_Tucao

- (BOOL) canHandle: (NSDictionary *)dict{
    if(dict && dict[@"hid"]){
        return YES;
    }
    return NO;
}

- (NSDictionary *) getSubtitle: (NSDictionary *)dict{
    NSData *urlData;
    int t = 0;

cmDownload:
    
    if(!urlData && t < 3){
        NSString *stringURL = [NSString stringWithFormat:@"http://www.tucao.tv/index.php?m=mukio&c=index&a=init&playerID=11-%@-1-%@&r=%u",dict[@"hid"], dict[@"part"], arc4random()];
        NSLog(@"[VP-Tucao] Comment URL: %@",stringURL);
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:stringURL]];
        request.HTTPMethod = @"GET";
        request.timeoutInterval = 3;
        
        NSURLResponse * response = nil;
        NSError * error = nil;
        urlData = [NSURLConnection sendSynchronousRequest:request
                                        returningResponse:&response
                                                    error:&error];
        if(error){
            t++;
            NSLog(@"Comment download failed, retry %d",t);
            goto cmDownload;
        }
    }else{
        NSLog(@"Comment cache hit from PreloadManager");
    }
    
    NSMutableDictionary *rdict = [dict mutableCopy];
    
    if (!urlData)
    {
        if(rdict[@"title"]){
            rdict[@"title"] = [rdict[@"title"] stringByAppendingString:NSLocalizedString(@" - 弹幕下载失败", nil)];
            
        }
        return rdict;
    }
    
    NSString  *filePath = [NSString stringWithFormat:@"%@%@%@.cminfo.xml", NSTemporaryDirectory(),dict[@"hid"],dict[@"part"]];
    BOOL isSuc = [urlData writeToFile:filePath atomically:YES];
    if(!isSuc){
        if(rdict[@"title"]){
            rdict[@"title"] = [rdict[@"title"] stringByAppendingString:NSLocalizedString(@" - 弹幕保存失败", nil)];
            
        }
        return rdict;
    }
    
    
    rdict[@"commentFile"] = filePath;
    NSLog(@"[VP-Tucao] Comment File: %@",filePath);
    
    return rdict;
}

@end
