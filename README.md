ACOKit
======

An Objective-C library for handling Adobe Color Swatches (.aco files).


## Usage

Here is a sample that loads a color swatch from the appliation bundle and reads some colors.

    // load the file
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"MyColors" withExtension:@"aco"];
    ACOColorSwatch *colors = [ACOColorSwatch colorSwatchFromFileAtURL:url error:NULL];
    
    // read some colors
    UIColor *backgroundColor = colors[@"Picton Blue"]; // you can access colors by name
    UIColor *textColor       = colors[0];              // or by the index in the file

Colors are returned as `UIColor` on iOS and as `NSColor` on OS X.