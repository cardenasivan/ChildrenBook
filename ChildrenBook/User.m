//
//  User.m
//  ChildrenBook
//
//  Created by administrator on 9/19/15.
//  Copyright (c) 2015 Ivan Cardenas. All rights reserved.
//

#import "User.h"

@implementation User
@dynamic userID;

+ (NSString*)dataClassName
{
    return NSStringFromClass(self);
}

+ (void)initialize
{
    [self registerSpecialization];
}

- (void)saveProduct:(User *)prod
{
    [[prod save] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            // error handling code here
        } else {
            User *savedProd = task.result;
            // take action on success
            
            NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:2];
            
            //default use of "publicuser" if no specific user is supplied.
            //[parameters setObject:@'MyUserId' forKey:IBMUseridKey];
            
            //enable automatic synchronization
            [parameters setObject:IBMFileLiveSyncEnableKey forKey:[NSNumber numberWithBool:YES]];
            
            IBMDataClientManager *clientManager = [IBMDataClientManager sharedManager];
            // set the delegate to be self, which conforms to the protocol IBMDataClientManagerDelegate
            clientManager.delegate = self;
            
            [[clientManager connect:parameters] continueWithBlock:^id(BFTask *task) {
                if (task.error) {
                    // do error handling here
                } else {
                    // do something now that you are connected
                }
                return nil;
            }];
        }
        return nil;
    }];
}

- (void)dataClientManager:(IBMDataClientManager *)manager onError:(NSError *)error
{
    
}

@end
