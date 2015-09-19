//
//  PathHelper.m
//  ChildrenBook
//
//  Created by Ivan Cardenas on 9/17/15.
//  Copyright (c) 2015 Ivan Cardenas. All rights reserved.
//

#import "PathHelper.h"
#import "ChildrenBookConstants.h"

@implementation PathHelper

+ (NSString* )getThemeBackgroundLocation
{
    return [[PathHelper getGeneralPath] stringByAppendingPathComponent:kImageFolderName];
}

+ (NSString* )getClipartLocation
{
    return [[PathHelper getGeneralPath] stringByAppendingPathComponent:kImageClipartName];
}

+ (NSString* )getStoryboardLocation
{
    return [[PathHelper getGeneralPath] stringByAppendingPathComponent:kStorybookFolderName];
}

+ (NSString *)getGeneralPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = nil;
    if (paths != nil)
    {
        docDir = [paths objectAtIndex:0];
    }
    return docDir;
}

@end
