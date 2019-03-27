//
//  AndroidQuality.m
//  ResourceGenerator
//
//  Created by Dat Nguyen on 1/28/19.
//  Copyright © 2019 Healint. All rights reserved.
//

#import "AndroidQuality.h"

#define DRAWABLE_PREFIX				@"drawable"
#define RES_MDPI					@"mdpi"
#define RES_HDPI					@"hdpi"
#define RES_XHDPI					@"xhdpi"
#define RES_XXHDPI					@"xxhdpi"
#define RES_XXXHDPI					@"xxxhdpi"

static AndroidQuality *_mdpi;
static AndroidQuality *_hdpi;
static AndroidQuality *_xhdpi;
static AndroidQuality *_xxhdpi;
static AndroidQuality *_xxxhdpi;
static NSArray *_values;

@interface AndroidQuality() {
	
}

@end

@implementation AndroidQuality

- (instancetype)initWithValue:(NSInteger)aValue resValue:(NSString *)resValue ratioOnXXX:(CGFloat)ratio {
	self = [super init];
	
	self.value = aValue;
	self.resValue = resValue;
	self.ratioOnXXX = ratio;
	return self;
	
}

- (NSString *)resFolder {
	return [NSString stringWithFormat:@"%@-%@", DRAWABLE_PREFIX, self.resValue];
}

+ (void)load {
	
	if (self == [self class]) {
		
		_mdpi = [[self alloc] initWithValue:0 resValue:RES_MDPI ratioOnXXX:0.25f];
		_hdpi = [[self alloc] initWithValue:1 resValue:RES_HDPI ratioOnXXX:0.375f];
		_xhdpi = [[self alloc] initWithValue:2 resValue:RES_XHDPI ratioOnXXX:0.5f];
		_xxhdpi = [[self alloc] initWithValue:3 resValue:RES_XXHDPI ratioOnXXX:0.75f];
		_xxxhdpi = [[self alloc] initWithValue:4 resValue:RES_XXXHDPI ratioOnXXX:1.f];
		_values = [NSArray arrayWithObjects:_mdpi, _hdpi, _xhdpi, _xxhdpi, _xxxhdpi, nil];
	}
}


+ (AndroidQuality *) MDPI {
	return _mdpi;
	
}

+ (AndroidQuality *) HDPI {
	return _hdpi;
}

+ (AndroidQuality *) XHDPI {
	return _xhdpi;
}

+ (AndroidQuality *) XXHDPI {
	return _xxhdpi;
}

+ (AndroidQuality *) XXXHDPI {
	return _xxxhdpi;
}

+ (NSArray *)values {
	return _values;
}

+ (NSArray *)valuesNeededForQuality:(AndroidQuality *)inputQuality {
	NSMutableArray *needed = [NSMutableArray new];
	for (AndroidQuality *quality in _values) {
		
		if (quality.value <= inputQuality.value) {
			
			[needed addObject:quality];
		}
	}
	return needed;
}

+ (AndroidQuality *)androidQualityByResValue:(NSString *)resValue {
	for (AndroidQuality *quality in _values) {
		if ([quality.resValue isEqualToString:resValue]) {
			return quality;
		}
	}
	
	return nil;
}

@end
