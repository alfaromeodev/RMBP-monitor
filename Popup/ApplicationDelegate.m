#import "ApplicationDelegate.h"
#import "smcWrapper.h"


@implementation ApplicationDelegate

#pragma mark -
- (void)dealloc {
    [statusItem release];
    [statusMenu release];
    
    [super dealloc];
}


#pragma mark - NSApplicationDelegate
-(void)awakeFromNib{
    
    statusMenu = [[NSMenu alloc] initWithTitle:@"test"];
    
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    statusItem.title = @"Monitor";
    statusItem.highlightMode = YES;
    statusItem.menu = statusMenu;
    
    fanSpeed = [[NSMenuItem alloc] initWithTitle:@"风扇" action:@selector(nothing) keyEquivalent:@""];
    [statusMenu addItem:fanSpeed];
    [fanSpeed release];
    
    cpuTmp = [[NSMenuItem alloc] initWithTitle:@"CPU" action:@selector(nothing) keyEquivalent:@""];
    [statusMenu addItem:cpuTmp];
    [cpuTmp release];
    
    graphTmp = [[NSMenuItem alloc] initWithTitle:@"显卡" action:@selector(nothing) keyEquivalent:@""];
    [statusMenu addItem:graphTmp];
    [graphTmp release];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    // Install icon into the menu bar
    
    [smcWrapper openConn];
    
    [self performSelector:@selector(updateSystemInfo) withObject:nil afterDelay:5];

}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    // Explicitly remove the icon from the menu bar

    return NSTerminateNow;
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
    
    fanSpeed.title = [NSString stringWithFormat:@"风扇: %d, %d", leftRPM, rightRPM];
    
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
    
    statusItem.title = [NSString stringWithFormat:@"%.0f",[smcWrapper get_temp:"TC0F"]];
    
    cpuTmp.title = [NSString stringWithFormat:@"CPU: %.0f, %.0f, %.0f",
                    [smcWrapper get_temp:"TC0P"],
                    [smcWrapper get_temp:"TC0E"],
                    [smcWrapper get_temp:"TC0F"] ];
    graphTmp.title = [NSString stringWithFormat:@"显卡: %.0f, %.0f, %.0f",
                      [smcWrapper get_temp:"TG0P"], //GPU 0 Proximity temp
                      [smcWrapper get_temp:"TG0D"], //GPU 0 die temp
                      [smcWrapper get_temp:"TG1D"] ];
    
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



@end
