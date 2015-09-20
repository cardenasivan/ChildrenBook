//
//  User.h
//  ChildrenBook
//
//  Created by administrator on 9/19/15.
//  Copyright (c) 2015 Ivan Cardenas. All rights reserved.
//
#import <IBMFileSync/IBMFileSync.h>
#import <IBMData/IBMData.h>

@interface User : IBMDataObject<IBMDataObjectSpecialization, IBMDataClientManagerDelegate>

@property (nonatomic, assign) NSString* userID;

@end
