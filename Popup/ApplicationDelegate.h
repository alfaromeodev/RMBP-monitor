@interface ApplicationDelegate : NSObject <NSApplicationDelegate> {
    NSMenu *statusMenu;
    NSStatusItem *statusItem;
    
    NSMenuItem *fanSpeed, *cpuTmp, *graphTmp;
}

- (void)updateSystemInfo;

@end
