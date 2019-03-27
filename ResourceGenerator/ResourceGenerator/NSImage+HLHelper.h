//
//  NSImage+HLHelper.h
//  ResourceGenerator
//
//  Created by Dat Nguyen on 1/28/19.
//  Copyright © 2019 Healint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSImage(HLHelper)

- (NSImage *)imageWithColorOverlay:(NSColor *)color;
- (NSImage *)resizedImageToRatio:(CGFloat)ratio;
- (NSImage *)resizedImageToPixelDimensions:(NSSize)newSize;

@end

NS_ASSUME_NONNULL_END
