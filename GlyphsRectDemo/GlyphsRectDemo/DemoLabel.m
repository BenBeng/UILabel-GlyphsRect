//
//  DemoLabel.m
//  GlyphsRectDemo
//
//  Created by Ben on 14-7-18.
//  Copyright (c) 2014年 Ben. All rights reserved.
//

#import "DemoLabel.h"
#import "UILabel+GlyphsRect.h"

@interface DemoLabel ()
@property (nonatomic, strong) NSArray *rects;
@end
@implementation DemoLabel


- (void)setText:(NSString *)atext{
    super.text = atext;
    _rects = [self glyphsRect];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    for (NSString *string in self.rects) {
        CGRect rect = CGRectFromString(string);
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        CGContextStrokeRectWithWidth(context, rect, 0.5);
    }
}

- (void)didMoveToSuperview{
    NSString *s = self.text;
    self.text = s;
}



@end
