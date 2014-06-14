/*
 * UniqueID
 *
 * Created by CZQ on 14-6-13.
 * Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"

#define ANE_FUNCTION(f) FREObject (f)(FREContext ctx, void *data, uint32_t argc, FREObject argv[])
#define MAP_FUNCTION(f, data) { (const uint8_t*)(#f), (data), &(f) }
#define DISPATCH_STATUS_EVENT(extensionContext, code, status) FREDispatchStatusEventAsync((extensionContext), (uint8_t*)code, (uint8_t*)status)

/* UniqueIDExtInitializer()
 * The extension initializer is called the first time the ActionScript side of the extension
 * calls ExtensionContext.createExtensionContext() for any context.
 *
 * Please note: this should be same as the <initializer> specified in the extension.xml 
*/
void UniqueIDExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet);

/* UniqueIDExtFinalizer()
 * The extension finalizer is called when the runtime unloads the extension. However, it may not always called.
 *
 * Please note: this should be same as the <finalizer> specified in the extension.xml 
*/
void UniqueIDExtFinalizer(void* extData);

/* UniqueIDContextInitializer()
 * The context initializer is called when the runtime creates the extension context instance.
*/
void UniqueIDContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet);

/* UniqueIDContextFinalizer()
 * The context finalizer is called when the extension's ActionScript code
 * calls the ExtensionContext instance's dispose() method.
 * If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls ContextFinalizer().
*/
void UniqueIDContextFinalizer(FREContext ctx);

ANE_FUNCTION(getMacAddress);
ANE_FUNCTION(getIDFA);
//ANE_FUNCTION(getUDID);

static NSString * getMacaddress();