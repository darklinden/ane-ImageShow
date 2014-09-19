/*
 
 Copyright (c) 2012, DIVIJ KUMAR
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met: 
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer. 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution. 
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 The views and conclusions contained in the software and documentation are those
 of the authors and should not be interpreted as representing official policies, 
 either expressed or implied, of the FreeBSD Project.
 
 
 */

/*
 * ImageShow.m
 * ImageShow
 *
 * Created by darklinden on 14-9-18.
 * Copyright (c) 2014年 darklinden. All rights reserved.
 */

#import "ImageShow.h"
#import <UIKit/UIKit.h>
#import "UIImage+largeImage.h"
#import "CoverImagerView.h"

/* ImageShowExtInitializer()
 * The extension initializer is called the first time the ActionScript side of the extension
 * calls ExtensionContext.createExtensionContext() for any context.
 *
 * Please note: this should be same as the <initializer> specified in the extension.xml 
 */
void ImageShowExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) 
{
    NSLog(@"Entering ImageShowExtInitializer()");

    *extDataToSet = NULL;
    *ctxInitializerToSet = &ContextInitializer;
    *ctxFinalizerToSet = &ContextFinalizer;

    NSLog(@"Exiting ImageShowExtInitializer()");
}

/* ImageShowExtFinalizer()
 * The extension finalizer is called when the runtime unloads the extension. However, it may not always called.
 *
 * Please note: this should be same as the <finalizer> specified in the extension.xml 
 */
void ImageShowExtFinalizer(void* extData) 
{
    NSLog(@"Entering ImageShowExtFinalizer()");

    // Nothing to clean up.
    NSLog(@"Exiting ImageShowExtFinalizer()");
    return;
}

/* ContextInitializer()
 * The context initializer is called when the runtime creates the extension context instance.
 */
void ContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    NSLog(@"Entering ContextInitializer()");
    
    /* The following code describes the functions that are exposed by this native extension to the ActionScript code.
     */
    static FRENamedFunction func[] = 
    {
        MAP_FUNCTION(isSupported, NULL),
        MAP_FUNCTION(isShow, NULL)
    };
    
    *numFunctionsToTest = 2;//sizeof(func) / sizeof(FRENamedFunction);
    *functionsToSet = func;
    
    NSLog(@"Exiting ContextInitializer()");
}

/* ContextFinalizer()
 * The context finalizer is called when the extension's ActionScript code
 * calls the ExtensionContext instance's dispose() method.
 * If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls ContextFinalizer().
 */
void ContextFinalizer(FREContext ctx) 
{
    NSLog(@"Entering ContextFinalizer()");

    // Nothing to clean up.
    NSLog(@"Exiting ContextFinalizer()");
    return;
}


/* This is a TEST function that is being included as part of this template. 
 *
 * Users of this template are expected to change this and add similar functions 
 * to be able to call the native functions in the ANE from their ActionScript code
 */
ANE_FUNCTION(isSupported)
{
    NSLog(@"Entering IsSupported()");
    
    FREObject fo;
    
    FREResult aResult = FRENewObjectFromBool(YES, &fo);
    if (aResult == FRE_OK)
    {
        NSLog(@"Result = %d", aResult);
    }
    else
    {
        NSLog(@"Result = %d", aResult);
    }
    
	NSLog(@"Exiting IsSupported()");    
	return fo;
}

ANE_FUNCTION(isShow)
{
    NSLog(@"Entering isShow()");
    
    uint32_t string1Length;
    const uint8_t *string1;
    FREGetObjectAsUTF8(argv[0], &string1Length, &string1);
    
    NSString *path = [NSString stringWithUTF8String:(char*)string1];
    
    double numberx;
    FREGetObjectAsDouble(argv[1], &numberx);
    
    double numbery;
    FREGetObjectAsDouble(argv[2], &numbery);
    
    double numberw;
    FREGetObjectAsDouble(argv[3], &numberw);
    
    double numberh;
    FREGetObjectAsDouble(argv[4], &numberh);
    
    CGRect rect = CGRectMake(numberx, numbery, numberw, numberh);
    
    NSLog(@"path: %@", path);
    
    [CoverImagerView showImageAtPath:path fromRect:rect];
    
//    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
//    img.backgroundColor = [UIColor whiteColor];
//    img.image = [UIImage imageWithContentsOfFile:path];
//    img.contentMode = UIViewContentModeCenter;
//    [view addSubview:img];
//    [img release];
    
    FREObject fo;
    
    FREResult aResult = FRENewObjectFromBool(YES, &fo);
    if (aResult == FRE_OK)
    {
        NSLog(@"Result = %d", aResult);
    }
    else
    {
        NSLog(@"Result = %d", aResult);
    }
    
	NSLog(@"Exiting isShow()");
	return fo;
}

