//
//  Category.m
//  APICallsTest
//
//  Created by OPS on 8/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "Category.h"

@implementation Category

- (instancetype)categoryID:(int)categoryID name:(NSString *)name {
    if (self) {
        self.categoryID = categoryID;
        self.categoryName = name;
    }
    return self;
}

@end
