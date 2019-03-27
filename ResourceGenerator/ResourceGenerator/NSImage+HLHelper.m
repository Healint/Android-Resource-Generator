//
//  NSImage+HLHelper.m
//  ResourceGenerator
//
//  Created by Dat Nguyen on 1/28/19.
//  Copyright © 2019 Healint. All rights reserved.
//

#import "NSImage+HLHelper.h"

@implementation NSImage(HLHelper)

- (NSImage *)imageWithColorOverlay:(NSColor *)color {
	
	CGFloat scale = [self recommendedLayerContentsScale:[[NSScreen mainScreen] backingScaleFactor]];
	
	NSImage * overlayedImage = [[NSImage alloc] initWithSize:self.size];
	[self.representations enumerateObjectsUsingBlock:^(NSImageRep * imageRep, NSUInteger idx, BOOL *stop){
		
		CGFloat imageWidth = imageRep.pixelsWide ?: imageRep.size.width * scale;
		CGFloat imageHeight = imageRep.pixelsHigh ?: imageRep.size.height * scale;
		NSRect imageRect = NSMakeRect(0, 0, imageWidth, imageHeight);
		
		CGImageRef imageRef = [imageRep CGImageForProposedRect:&imageRect context:NULL hints:nil];
		
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, imageWidth, imageHeight,
													 CGImageGetBitsPerComponent(imageRef), 0,
													 colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
		CGColorSpaceRelease(colorSpace);
		
		CGContextClipToMask(context, NSRectToCGRect(imageRect), imageRef);
		CGContextSetFillColorWithColor(context, color.CGColor);
		CGContextFillRect(context, NSRectToCGRect(imageRect));
		
		CGImageRef newImage = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		
		[overlayedImage addRepresentation:[[NSBitmapImageRep alloc] initWithCGImage:newImage]];
		CGImageRelease(newImage);
	}];
	
	return overlayedImage;
}

- (NSImage *)resizedImageToRatio:(CGFloat)ratio {
	NSSize currentSize = self.size;
	
	NSSize newSize = NSMakeSize(currentSize.width * ratio, currentSize.height * ratio);
	
	return [self resizedImageToPixelDimensions:newSize];
}

- (NSImage *)resizedImageToPixelDimensions:(NSSize)newSize {
	if (! self.isValid) return nil;
	
	NSBitmapImageRep *rep = [[NSBitmapImageRep alloc]
							 initWithBitmapDataPlanes:NULL
							 pixelsWide:newSize.width
							 pixelsHigh:newSize.height
							 bitsPerSample:8
							 samplesPerPixel:4
							 hasAlpha:YES
							 isPlanar:NO
							 colorSpaceName:NSCalibratedRGBColorSpace
							 bytesPerRow:0
							 bitsPerPixel:0];
	rep.size = newSize;
	
	[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:rep]];
	[self drawInRect:NSMakeRect(0, 0, newSize.width, newSize.height) fromRect:NSZeroRect operation:NSCompositingOperationCopy fraction:1.0];
	[NSGraphicsContext restoreGraphicsState];
	
	NSImage *newImage = [[NSImage alloc] initWithSize:newSize];
	[newImage addRepresentation:rep];
	return newImage;
}


@end
