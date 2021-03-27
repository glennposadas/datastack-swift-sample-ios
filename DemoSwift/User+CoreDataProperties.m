//
//  User+CoreDataProperties.m
//  DemoSwift
//
//  Created by Glenn Posadas on 3/28/21.
//
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"User"];
}

@dynamic createdDate;
@dynamic name;
@dynamic remoteID;

@end
