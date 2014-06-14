/*
 * UniqueID.m
 * UniqueID
 *
 * Created by CZQ on 14-6-13.
 * Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
 */

#import "UniqueID.h"
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
//#include "OpenUDID.h"
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>

/* UniqueIDExtInitializer()
 * The extension initializer is called the first time the ActionScript side of the extension
 * calls ExtensionContext.createExtensionContext() for any context.
 *
 * Please note: this should be same as the <initializer> specified in the extension.xml 
 */
void UniqueIDExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) 
{
    NSLog(@"Entering UniqueIDExtInitializer()");

    *extDataToSet = NULL;
    *ctxInitializerToSet = &UniqueIDContextInitializer;
    *ctxFinalizerToSet = &UniqueIDContextFinalizer;

    NSLog(@"Exiting UniqueIDExtInitializer()");
}

/* UniqueIDExtFinalizer()
 * The extension finalizer is called when the runtime unloads the extension. However, it may not always called.
 *
 * Please note: this should be same as the <finalizer> specified in the extension.xml 
 */
void UniqueIDExtFinalizer(void* extData) 
{
    NSLog(@"Entering UniqueIDExtFinalizer()");

    // Nothing to clean up.
    NSLog(@"Exiting UniqueIDExtFinalizer()");
    return;
}

/* UniqueIDContextInitializer()
 * The context initiavoidvoidlizer is called when the runtime creates the extension context instance.
 */
void UniqueIDContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    NSLog(@"Entering ContextInitializer()");
    
    /* The following code describes the functions that are exposed by this native extension to the ActionScript code.
     */
    static FRENamedFunction func[] = 
    {
        MAP_FUNCTION(getMacAddress, NULL),
        MAP_FUNCTION(getIDFA, NULL),
//        MAP_FUNCTION(getUDID, NULL),
    };
    
    *numFunctionsToTest = sizeof(func) / sizeof(FRENamedFunction);
    *functionsToSet = func;
    
    NSLog(@"Exiting ContextInitializer()");
}

/* UniqueIDContextFinalizer()
 * The context finalizer is called when the extension's ActionScript code
 * calls the ExtensionContext instance's dispose() method.
 * If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls ContextFinalizer().
 */
void UniqueIDContextFinalizer(FREContext ctx)
{
    NSLog(@"Entering ContextFinalizer()");

    // Nothing to clean up.
    NSLog(@"Exiting ContextFinalizer()");
    return;
}


ANE_FUNCTION(getMacAddress)
{
    FREObject result;
    NSString* macAddress = getMacaddress();
    FRENewObjectFromUTF8( strlen((const char*)[macAddress UTF8String]) + 1, (const uint8_t*)[macAddress UTF8String], &result);
    return result;
}
ANE_FUNCTION(getIDFA)
{
    FREObject result;
    NSString* idfa = @"";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0){
        idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    FRENewObjectFromUTF8( strlen((const char*)[idfa UTF8String]) + 1, (const uint8_t*)[idfa UTF8String], &result);
    return result;
    
}
/*ANE_FUNCTION(getUDID)
{
    FREObject result;
    NSString* openUDID = [OpenUDID value];
    FRENewObjectFromUTF8( strlen((const char*)[openUDID UTF8String]) + 1, (const uint8_t*)[openUDID UTF8String], &result);
    return result;
}*/


// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
static NSString * getMacaddress()
{
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
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
//        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
//        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
//        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
//        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    //    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    NSLog(@"outString:%@", outstring);
    
    free(buf);
    
    return [outstring uppercaseString];
}
