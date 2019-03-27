//
//  HLDragDropView.h
//  ResourceGenerator
//
//  Created by Dat Nguyen on 1/28/19.
//  Copyright © 2019 Healint. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HLDragDropViewDelegate;

@interface HLDragDropView : NSView

@property(weak) id<NSObject, HLDragDropViewDelegate> delegate;

@end


@protocol HLDragDropViewDelegate<NSObject>

- (void)dragViewWithURLs:(NSArray<NSURL *> *)urls;

@end

NS_ASSUME_NONNULL_END
