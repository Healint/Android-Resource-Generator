//
//  AndroidQuality.h
//  ResourceGenerator
//
//  Created by Dat Nguyen on 1/28/19.
//  Copyright © 2019 Healint. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AndroidQuality : NSObject

@property(nonatomic, assign) NSInteger value;
@property(nonatomic, assign) CGFloat ratioOnXXX;
@property(nonatomic, copy) NSString *resValue;


- (NSString *)resFolder;

+ (AndroidQuality *) MDPI;
+ (AndroidQuality *) HDPI;
+ (AndroidQuality *) XHDPI;
+ (AndroidQuality *) XXHDPI;
+ (AndroidQuality *) XXXHDPI;

+ (NSArray *)values;

+ (NSArray *)valuesNeededForQuality:(AndroidQuality *)inputQuality;
+ (AndroidQuality *)androidQualityByResValue:(NSString *)resValue;

@end

NS_ASSUME_NONNULL_END
