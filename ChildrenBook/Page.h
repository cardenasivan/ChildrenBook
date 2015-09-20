//
//  Page.h
//  ChildrenBook
//
//  Created by administrator on 9/19/15.
//  Copyright (c) 2015 Ivan Cardenas. All rights reserved.
//

#import <IBMFileSync/IBMFileSync.h>
#import <IBMData/IBMData.h>

@interface Page : IBMDataObject<IBMDataObjectSpecialization, IBMDataClientManagerDelegate>

@property (nonatomic, assign) NSString* pageID;
@property (nonatomic, assign) NSString* bookID;
@property (nonatomic, assign) NSString* text;
@property (nonatomic, strong) NSData* image;
@property (nonatomic, strong) NSString* pageNumber;

@end
