//
//  ViewController.h
//  ResourceGenerator
//
//  Created by Dat Nguyen on 1/28/19.
//  Copyright © 2019 Healint. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HLDragDropView.h"

@interface ViewController : NSViewController

@property (weak) IBOutlet HLDragDropView *viewDrag;
@property (weak) IBOutlet NSTextView *tvStatus;
@property (weak) IBOutlet NSButton *btnSelectPath;
@property (weak) IBOutlet NSTextField *txtExportPath;
@property (weak) IBOutlet NSImageView *imvPreview;
@property (weak) IBOutlet NSColorWell *colorWell;
@property (weak) IBOutlet NSComboBox *comboBox;

@end

