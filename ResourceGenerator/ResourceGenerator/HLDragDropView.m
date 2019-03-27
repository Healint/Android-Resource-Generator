//
//  HLDragDropView.m
//  ResourceGenerator
//
//  Created by Dat Nguyen on 1/28/19.
//  Copyright © 2019 Healint. All rights reserved.
//

#import "HLDragDropView.h"

@interface HLDragDropView() {

	BOOL fileTypeIsOk;
	NSArray<NSString *> * acceptedFileExtensions;
}

@end

@implementation HLDragDropView

- (instancetype)initWithCoder:(NSCoder *)decoder {

	self = [super initWithCoder:decoder];
	
	acceptedFileExtensions = @[@"PNG"];
	[self registerForDraggedTypes:@[NSPasteboardTypeFileURL]];
	
	return self;
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
	fileTypeIsOk = [self checkExtension:sender];
	return NSDragOperationNone;
}

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender {

	return fileTypeIsOk ? NSDragOperationCopy : NSDragOperationNone;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
	
	NSArray<NSURL *> *urls = [self urlFromDraggingInfo:sender];
	
	if (fileTypeIsOk) {
		[self.delegate dragViewWithURLs:[self validUrls:urls]];
	}
	
	return TRUE;
}

- (BOOL)checkExtension:(id<NSDraggingInfo>)drag {
	NSArray<NSURL *> *urls = [self validUrls:[self urlFromDraggingInfo:drag]];
	return urls.count > 0;
}

- (NSArray<NSURL *> *)validUrls:(NSArray<NSURL *> *)urls {
	NSArray<NSURL *> *validUrls = [urls filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
		NSURL *urlCheck = (NSURL *)evaluatedObject;
		return [self->acceptedFileExtensions containsObject:urlCheck.lastPathComponent.pathExtension.uppercaseString];
	}]];
	
	return validUrls;
}

- (NSArray<NSURL *> *)urlFromDraggingInfo:(id<NSDraggingInfo>)drag {
	
	NSArray<NSURL *> *urls = [drag.draggingPasteboard readObjectsForClasses:@[NSURL.class] options:nil];
	
	return urls;
}

@end
