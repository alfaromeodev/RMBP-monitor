#import "StatusItemView.h"
#import "smcWrapper.h"

@implementation StatusItemView

@synthesize statusItem = _statusItem;
@synthesize image = _image;
@synthesize alternateImage = _alternateImage;
@synthesize isHighlighted = _isHighlighted;
@synthesize action = _action;
@synthesize target = _target;



#pragma mark -
- (void)dealloc {

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateSystemInfo) object:nil];
    
    [super dealloc];
}

- (id)initWithStatusItem:(NSStatusItem *)statusItem {
    
    CGFloat itemWidth = [statusItem length];
    CGFloat itemHeight = [[NSStatusBar systemStatusBar] thickness];
    NSRect itemRect = NSMakeRect(0.0, 0.0, itemWidth, itemHeight);
    self = [super initWithFrame:itemRect];
    
    if (self != nil) {
        _statusItem = statusItem;
        _statusItem.view = self;
        
        [smcWrapper openConn];

        [self performSelector:@selector(updateSystemInfo) withObject:nil afterDelay:5];
    }
    return self;
    
}



#pragma mark -
- (void)drawRect:(NSRect)dirtyRect {
	[self.statusItem drawStatusBarBackgroundInRect:dirtyRect withHighlight:self.isHighlighted];
    
    NSImage *icon = self.isHighlighted ? self.alternateImage : self.image;
    NSSize iconSize = [icon size];
    NSRect bounds = self.bounds;
    CGFloat iconX = roundf((NSWidth(bounds) - iconSize.width) / 2);
    CGFloat iconY = roundf((NSHeight(bounds) - iconSize.height) / 2);
    NSPoint iconPoint = NSMakePoint(iconX, iconY);
    [icon compositeToPoint:iconPoint operation:NSCompositeSourceOver];
}



#pragma mark -
#pragma mark Mouse tracking
- (void)mouseDown:(NSEvent *)theEvent {
    [NSApp sendAction:self.action to:self.target from:self];
}



#pragma mark -
#pragma mark Accessors
- (void)setHighlighted:(BOOL)newFlag {
    if (_isHighlighted == newFlag) return;
    _isHighlighted = newFlag;
    [self setNeedsDisplay:YES];
}



#pragma mark read from sensors
- (void)updateSystemInfo {
    
//    int num_fans = [smcWrapper get_fan_num];
//    NSString *desc = nil;
//    int min, max, current;    
//    for ( int i = 0; i < num_fans; i++ ) {
//        min = [smcWrapper get_min_speed:i];
//        max = [smcWrapper get_max_speed:i];
//        current = [smcWrapper get_fan_rpm:i];
//        desc = [smcWrapper get_fan_descr:i];
//    }
    
    int leftRPM = [smcWrapper get_fan_rpm:0];
    int rightRPM = [smcWrapper get_fan_rpm:1];
    NSLog(@"left:%d right:%d", leftRPM, rightRPM);
    
    double batteryMax = [smcWrapper get_temp:"TB0T"];//Battery TS_MAX
    double battery1 = [smcWrapper get_temp:"TB1T"];//Battery TS 1
    double battery2 = [smcWrapper get_temp:"TB2T"];//Battery TS 2
    
    if (batteryMax > 50 || battery1 > 50 || battery2 > 50) {
        NSLog(@"battery ---------------");

        NSLog(@"%.2f", batteryMax); 
        NSLog(@"battery alert:\nbattery1:%.2f, battery2:%.2f", battery1, battery2);
    }

    double wifi = [smcWrapper get_temp:"TW0P"];//Airport temp
    if (wifi > 60) {
        NSLog(@"wifi alert:\nairport:%.2f", wifi);
    }
    
    NSLog(@"cpu: %.2f, %.2f, %.2f",
          [smcWrapper get_temp:"TC0P"], //CPU 0 Proximity temp
          [smcWrapper get_temp:"TC0E"], //
          [smcWrapper get_temp:"TC0F"]  //CPU
          );
    
    NSLog(@"graphic: %.2f, %.2f, %.2f",
          [smcWrapper get_temp:"TG0P"], //GPU 0 Proximity temp
          [smcWrapper get_temp:"TG0D"], //GPU 0 die temp
          [smcWrapper get_temp:"TG1D"]  //gph
          ); 
    
    NSLog(@"--------------------------");
    
    [self performSelector:@selector(updateSystemInfo) withObject:nil afterDelay:5];

}



#pragma mark -
- (void)setImage:(NSImage *)newImage {
    if (_image != newImage) {
        _image = newImage;
        [self setNeedsDisplay:YES];
    }
}

- (void)setAlternateImage:(NSImage *)newImage {
    if (_alternateImage != newImage) {
        _alternateImage = newImage;
        if (self.isHighlighted) {
            [self setNeedsDisplay:YES];
        }
    }
}



#pragma mark -
- (NSRect)globalRect {
    NSRect frame = [self frame];
    frame.origin = [self.window convertBaseToScreen:frame.origin];
    return frame;
}



@end
