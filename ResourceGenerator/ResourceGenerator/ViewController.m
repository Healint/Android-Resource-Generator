//
//  ViewController.m
//  ResourceGenerator
//
//  Created by Dat Nguyen on 1/28/19.
//  Copyright © 2019 Healint. All rights reserved.
//

#import "ViewController.h"
#import "AndroidQuality.h"
#import "NSImage+HLHelper.h"

#define kUDExportPath		 		@"UDExportPath"
#define DEFAULT_ANDROID_QUALITY 	AndroidQuality.XHDPI

#define kMessageMissingExportPath 		@"Please select export path"
#define kTextInstruction				@"Drag and Drop images into this window. Only Accept PNG."

@interface ViewController()<HLDragDropViewDelegate> {
	NSURL *exportPath;
	NSArray<NSURL *> *sourceUrls;
	NSColor *tintColor;
	AndroidQuality *androidQuality;
}

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.viewDrag.delegate = self;
	
	// set colorWell default color
	self.colorWell.color = NSColor.clearColor;
	
	// unregister dragged Types for imvPreview so it won't interfere with draggedTypes of whole window
	[self.imvPreview unregisterDraggedTypes];
	
	// default Input res to DEFAULT_ANDROID_QUALITY
	androidQuality = DEFAULT_ANDROID_QUALITY;
	[self.comboBox selectItemWithObjectValue:androidQuality.resValue];
	
	// get exportPath from userDefault if available
	exportPath = [NSUserDefaults.standardUserDefaults URLForKey:kUDExportPath];
	
	// update UI
	[self updateUI];
}

- (IBAction)btnSelectPathDidTap:(id)sender {
	exportPath = [self openSelectUrl];
	if (exportPath) {
		// save to userDefaults
		[NSUserDefaults.standardUserDefaults setURL:exportPath forKey:kUDExportPath];
		[NSUserDefaults.standardUserDefaults synchronize];
	}
	
	[self updateExportPathUI];
}

- (IBAction)btnResetColorDidTap:(id)sender {
	if ([self.colorWell isActive]) {
		[self.colorWell deactivate];
	}
	self.colorWell.color = NSColor.clearColor;
	
	// reset color
	tintColor = nil;
	self.imvPreview.contentTintColor = nil;
	[self updateUI];
}

- (IBAction)dimensionDidChange:(id)sender {
	NSString *selectedQuality = [self.comboBox itemObjectValueAtIndex:self.comboBox.indexOfSelectedItem];
	
	androidQuality = [AndroidQuality androidQualityByResValue:selectedQuality];
}

- (IBAction)colorWellDidSelect:(id)sender {
	tintColor = self.colorWell.color;
	
	// update UI
	// check if it's clear color
	if (CGColorEqualToColor(tintColor.CGColor, NSColor.clearColor.CGColor)) {
		self.imvPreview.image.template = NO;
	} else {
		self.imvPreview.image.template = YES;
	}
	self.imvPreview.contentTintColor = tintColor;
}

- (IBAction)btnExportDidTap:(id)sender {
	
	// convert android images
	for (NSURL *url in sourceUrls) {
		[self convertAndroidResourceUrl:url
							  tintColor:tintColor
							fromQuality:androidQuality];
	}
	
}

- (void)updateExportPathUI {
	if (exportPath) {
		// update label path
		[self.txtExportPath setStringValue:exportPath.absoluteString];
	} else {
		[self.txtExportPath setStringValue:kMessageMissingExportPath];
	}
}

- (void)updateUI {
	
	if (sourceUrls && sourceUrls.count > 0) {
		NSImage *image = [[NSImage alloc]initByReferencingURL:sourceUrls.firstObject];
		image.template = (tintColor != nil);
		[self.imvPreview setImage:image];
		
		// update status text
		NSMutableString *fileNames = [NSMutableString new];
		for (NSURL *url in sourceUrls) {
			[fileNames appendFormat:@"%@\n", url.lastPathComponent];
		}
		[self.tvStatus setString:fileNames];
	} else {
		[self.tvStatus setString:kTextInstruction];
	}
	
	[self updateExportPathUI];
}

- (NSURL *)openSelectUrl {
	NSOpenPanel *panel = [NSOpenPanel openPanel];
	[panel setAllowsMultipleSelection:NO];
	[panel setCanChooseDirectories:YES];
	[panel setCanChooseFiles:NO];
	
	if ([panel runModal] != NSModalResponseOK) return nil;
	return [[panel URLs] lastObject];
}

#pragma mark - DragDrop delegate
- (void)dragViewWithURLs:(NSArray<NSURL *> *)urls {
	NSLog(@"dragViewWithURLs: %@", urls);
	sourceUrls = urls;
	
	[self updateUI];
}

#pragma mark - Conversion Methods
// Do conversion for Android images
- (void)convertAndroidResourceUrl:(NSURL *)imageRefUrl
						tintColor:(NSColor *)color
					  fromQuality:(AndroidQuality *)inputQuality {
	
	NSImage *image = [[NSImage alloc] initByReferencingURL:imageRefUrl];
	if (!image) {
		// fail, update message
		return;
	}
	
	// create folder if not exist
	NSError *error = nil;
	
	// generate different dimension folders, order from input quality desc
	// mdpi < hdpi < xhdpi < xxhdpi < xxxhdpi
	
	// find list of dimensions need to generate
	NSArray<AndroidQuality *> *needed = [AndroidQuality valuesNeededForQuality:inputQuality];
	
	for (AndroidQuality *quality in needed) {
		CGFloat ratioBaseOnInputQuality = quality.ratioOnXXX / inputQuality.ratioOnXXX;
		
		// resize image base on ratio
		NSImage *newImage = [image resizedImageToRatio:ratioBaseOnInputQuality];
		
		if (color && !CGColorEqualToColor(color.CGColor, NSColor.clearColor.CGColor)) {
			newImage = [newImage imageWithColorOverlay:color];
		}
		
		// export to folder
		NSURL *folderResPath = [exportPath URLByAppendingPathComponent:quality.resFolder];
		[NSFileManager.defaultManager createDirectoryAtURL:folderResPath withIntermediateDirectories:YES attributes:nil error:&error];
		
		NSLog(@"create folder %@ error: %@", folderResPath, error);
		
		NSString *fileName = imageRefUrl.lastPathComponent;
		NSURL *imagePath = [folderResPath URLByAppendingPathComponent:fileName];
		
		// save image to that folder
		NSData *imageData = [newImage TIFFRepresentation];
		NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
		NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
		imageData = [imageRep representationUsingType:NSBitmapImageFileTypePNG properties:imageProps];
		BOOL writeResult = [imageData writeToURL:imagePath atomically:NO];
		NSLog(@"writeResult: %d for imagePath: %@", writeResult, imagePath);
	}
	
}

@end
