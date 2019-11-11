//
//  Category.h
//  APICallsTest
//
//  Created by OPS on 8/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Category : NSObject

@property(assign) int categoryID;
@property(copy, readwrite) NSString *categoryName;

- (instancetype) categoryID:(int)categoryID name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
