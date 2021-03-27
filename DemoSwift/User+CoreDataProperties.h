//
//  User+CoreDataProperties.h
//  DemoSwift
//
//  Created by Glenn Posadas on 3/28/21.
//
//

#import "User+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *createdDate;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *remoteID;

@end

NS_ASSUME_NONNULL_END
