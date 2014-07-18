//
//  UILabel+GlyphsRect.m
//  TestLabel
//
//  Created by Ben on 14-7-17.
//  Copyright (c) 2014年 Ben. All rights reserved.
//

#import "UILabel+GlyphsRect.h"
#import <CoreText/CoreText.h>

@implementation UILabel (GlyphsRect)

- (NSArray *)glyphsRect{
    NSAttributedString *attributedString = self.attributedText;
    if (!self.attributedText && self.text) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.alignment = self.textAlignment;
        attributedString = [[NSAttributedString alloc]initWithString:self.text attributes:@{NSFontAttributeName:self.font,NSParagraphStyleAttributeName:paragraphStyle}];
    }
    if (attributedString) {
       return [self glyphsRectForAttributedString:attributedString];
    }
    return nil;
}

- (NSArray *)glyphsRectForAttributedString:(NSAttributedString *)attributedString{
    CTFontRef font = (__bridge CTFontRef)self.font;
    CFAttributedStringRef cfAttributedString = (__bridge CFAttributedStringRef)attributedString;

    CFStringRef cfString = (__bridge CFStringRef)attributedString.string;
    CFIndex stringLength = CFStringGetLength(cfString);
    CFRange rangeAll = CFRangeMake(0, stringLength);
    
    UniChar characters[stringLength];
    CFStringGetCharacters(cfString, rangeAll, characters);
    
    CGGlyph glyphs[stringLength];
    CTFontGetGlyphsForCharacters(font, characters, glyphs, stringLength);
    
    CGRect boundingRects[stringLength];
    CTFontGetBoundingRectsForGlyphs(font, kCTFontOrientationDefault, glyphs, boundingRects, stringLength);
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(cfAttributedString);
    CGPathRef path = CGPathCreateWithRect(self.bounds, NULL);
    CTFrameRef ctFrame = CTFramesetterCreateFrame(frameSetter, rangeAll, path, NULL);
    CGPathRelease(path);
    
    CFArrayRef lines = CTFrameGetLines(ctFrame);
    CFIndex lineCount = CFArrayGetCount(lines);
    
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    CGSize boundingSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, 0), NULL, CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX), NULL);
    
    for (CFIndex i = 0; i < lineCount; i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFRange lineRange = CTLineGetStringRange(line);
        CFIndex lineStartIndex = lineRange.location;
        CFIndex lineEndIndex = lineRange.location + lineRange.length;
        
        CGPoint lineOrigin = lineOrigins[i];
        CGFloat offsetY = lineOrigin.y + boundingSize.height/2.0 -CGRectGetHeight(self.bounds)/2.0;
        
        for (CFIndex i = lineStartIndex; i < lineEndIndex; i++) {
            CGFloat offsetX = CTLineGetOffsetForStringIndex(line, i, NULL);
            boundingRects[i] = CGRectOffset(boundingRects[i], lineOrigin.x+offsetX, offsetY);
        }
    }

    CFRelease(ctFrame);
    CFRelease(frameSetter);
    
    NSMutableArray *rectArray = [NSMutableArray arrayWithCapacity:stringLength];
    for (int i = 0; i < stringLength; i++) {
        NSString *rectString = NSStringFromCGRect(boundingRects[i]);
        [rectArray addObject:rectString];
    }
    return rectArray;
}

@end
