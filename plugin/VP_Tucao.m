//
//  VP_Tucao.m
//  vp_tucao
//
//  Created by TYPCN on 2016/8/2.
//  Copyright © 2016 TYPCN. All rights reserved.
//

#import "VP_Tucao.h"

@implementation VP_Tucao

- (NSDictionary *)generateParamsFromURL: (NSString *)URL{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSArray *arr = [URL componentsSeparatedByString:@"|"];
    
    params[@"url"] = arr[0];
    params[@"vid"] = arr[1];
    
    NSArray *url_p = [arr[0] componentsSeparatedByString:@"#"];
    if([url_p count] == 2){
        params[@"part"] = @([url_p[1] intValue] - 1);
    }else{
        params[@"part"] = @(0);
    }
    
    NSArray *url_a = [arr[0] componentsSeparatedByString:@"/"];
    if([url_a count] >= 5){
        params[@"hid"] = @([[url_a[4] stringByReplacingOccurrencesOfString:@"h" withString:@""] intValue]);
    }
    
    return params;
}

- (VideoAddress *) getVideoAddress: (NSDictionary *)params{
    if(!params[@"vid"]){
        [NSException raise:@VP_PARAM_ERROR format:@"VID cannot be empty"];
        return NULL;
    }
    
    VideoAddress *video = [[VideoAddress alloc] init];
    
    NSString *stringURL = [NSString stringWithFormat:@"http://api.tucao.tv/api/playurl?%@&cid=bilimac_inline", params[@"vid"]];
    NSURL* URL = [NSURL URLWithString:stringURL];
    
    NSLog(@"[VP-Tucao] Request URL: %@",stringURL);
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response
                                      error:&error];
    if(error || !data){
        [NSException raise:@VP_RESOLVE_ERROR format:@"%@", [error localizedDescription]];
        return NULL;
    }
    NSString *resp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(http://.*?)]]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:resp options:0 range:NSMakeRange(0, [resp length])];
    NSRange range = [match rangeAtIndex:1];
    if(range.length > 0){
        NSLog(@"[VP-Tucao] Video URL: %@",stringURL);
        NSString *durl = [resp substringWithRange:range];
        [video setFirstFragmentURL:durl];
        [video addDefaultPlayURL:durl];
    }else{
        [NSException raise:@VP_RESOLVE_ERROR format:@"%@",resp];
        return NULL;
    }
    return video;
}

@end
