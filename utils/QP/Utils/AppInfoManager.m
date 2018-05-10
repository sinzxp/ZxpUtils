//
//  AppInfoManager.m
//  Album
//
//  Created by cen on 23/6/14.
//  Copyright (c) 2014 cen. All rights reserved.
//

#import "AppInfoManager.h"
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <UIKit/UIKit.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

NSDictionary *infoDictionary;
@implementation AppInfoManager


+(void)initialize{
    infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
//    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
}

+(NSString *)getBundleId{
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];

}

+(NSString *)getVersion{
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

+(NSString *)getBuild{
    return [infoDictionary objectForKey:@"CFBundleVersion"];
}

+(NSString *)getName{
//    return [infoDictionary objectForKey:@"CFBundleDisplayName"];
//    DDLogDebug(@"%@",infoDictionary);
    return @"相聚云相册";
}

+(NSString *)getAppCode{
    return @"20140819";
}

+(NSString *)getUrlScheme{
    return @"xiangju://www.myclan.tv";
}

+(BOOL)hasLogin{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *isLogin = [userDefault objectForKey:@"logined"];
    if ([isLogin isEqualToString:@"yes"]) {
        return YES;
    }else{
        return NO;
    }
}

+(NSString *)createUID
{
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    NSString* noUID = @"";
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        return noUID;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        return noUID;
    }
    
    if ((buf = (char*)malloc(len)) == NULL) {
        return noUID;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        return noUID;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}


@end
