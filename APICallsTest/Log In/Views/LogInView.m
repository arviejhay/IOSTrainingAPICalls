//
//  LogInView.m
//  APICallsTest
//
//  Created by OPS on 12/11/19.
//  Copyright © 2019 OPS. All rights reserved.
//

#import "LogInView.h"

@implementation LogInView
- (IBAction)didTapLogin:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapLogin)]) {
        [self.delegate didTapLogin];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

