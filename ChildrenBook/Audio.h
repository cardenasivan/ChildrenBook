//
//  Audio.h
//  ChildrenBook
//
//  Created by administrator on 9/19/15.
//  Copyright (c) 2015 Ivan Cardenas. All rights reserved.
//

#import <IBMFileSync/IBMFileSync.h>
#import <IBMData/IBMData.h>

@interface Audio : IBMDataObject<IBMDataClientManagerDelegate>

@property (nonatomic, assign) NSString* audioID;
@property (nonatomic, assign) NSString* pageID;
@property (nonatomic, strong) NSData* audio;

- (void)saveProduct:(Audio *)prod;

@end
