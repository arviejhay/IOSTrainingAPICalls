//
//  DatabasePresentation.h
//  APICallsTest
//
//  Created by OPS on 13/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FirebaseFirestore/FirebaseFirestore.h>

#ifndef DatabasePresentation_h
#define DatabasePresentation_h

@protocol DatabasePresentation <NSObject>

- (NSDictionary *) representation;
+ (instancetype)initWithDocument:(FIRQueryDocumentSnapshot *)document;
@end

#endif /* DatabasePresentation_h */
