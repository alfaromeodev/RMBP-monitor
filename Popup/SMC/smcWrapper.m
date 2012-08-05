//
//  smcWrapper.m
//  HeatSync
//
//  Created by Vlad Alexa on 9/3/10.
//  Copyright 2010 NextDesign.
//  Portions from FanControl Copyright (c) 2006 Hendrik Holtmann 
//
//	This program is free software; you can redistribute it and/or modify
//	it under the terms of the GNU General Public License as published by
//	the Free Software Foundation; either version 2 of the License, or
//	(at your option) any later version.
//
//	This program is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU General Public License for more details.
//
//	You should have received a copy of the GNU General Public License
//	along with this program; if not, write to the Free Software
//	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

#import "smcWrapper.h"

#include "smc.h"
#include <sys/sysctl.h>
#include <sys/param.h>
#include <sys/mount.h>

io_connect_t conn;

@implementation smcWrapper



+ (void)openConn{	
    if (!conn) {
        kern_return_t result = SMCOpen(&conn);
        if (result != kIOReturnSuccess) {
            NSLog(@"Failed to open connection to SMC");
        }
    }		
}



#pragma mark temps
+ (NSDictionary*)getAllKeys {
	NSMutableDictionary *keys = [NSMutableDictionary dictionaryWithCapacity:1];
	[keys setValue:@"Memory Controller" forKey:@"Tm0P"];
	[keys setValue:@"Mem Bank A1" forKey:@"TM0P"];
	[keys setValue:@"Mem Bank A2" forKey:@"TM1P"];
	[keys setValue:@"Mem Bank A3" forKey:@"TM2P"];
	[keys setValue:@"Mem Bank A4" forKey:@"TM3P"]; // guessing
	[keys setValue:@"Mem Bank A5" forKey:@"TM4P"]; // guessing
	[keys setValue:@"Mem Bank A6" forKey:@"TM5P"]; // guessing
	[keys setValue:@"Mem Bank A7" forKey:@"TM6P"]; // guessing
	[keys setValue:@"Mem Bank A8" forKey:@"TM7P"]; // guessing
	[keys setValue:@"Mem Bank B1" forKey:@"TM8P"];
	[keys setValue:@"Mem Bank B2" forKey:@"TM9P"];
	[keys setValue:@"Mem Bank B3" forKey:@"TMAP"];
	[keys setValue:@"Mem Bank B4" forKey:@"TMBP"];  // guessing
	[keys setValue:@"Mem Bank B5" forKey:@"TMCP"]; // guessing
	[keys setValue:@"Mem Bank B6" forKey:@"TMDP"]; // guessing
	[keys setValue:@"Mem Bank B7" forKey:@"TMEP"]; // guessing
	[keys setValue:@"Mem Bank B8" forKey:@"TMFP"]; // guessing
	[keys setValue:@"Mem module A1" forKey:@"TM0S"];
	[keys setValue:@"Mem module A2" forKey:@"TM1S"];
	[keys setValue:@"Mem module A3" forKey:@"TM2S"];
	[keys setValue:@"Mem module A4" forKey:@"TM3S"];// guessing
	[keys setValue:@"Mem module A5" forKey:@"TM4S"]; // guessing
	[keys setValue:@"Mem module A6" forKey:@"TM5S"]; // guessing
	[keys setValue:@"Mem module A7" forKey:@"TM6S"]; // guessing
	[keys setValue:@"Mem module A8" forKey:@"TM7S"]; // guessing
	[keys setValue:@"Mem module B1" forKey:@"TM8S"];
	[keys setValue:@"Mem module B2" forKey:@"TM9S"];
	[keys setValue:@"Mem module B3" forKey:@"TMAS"]; 
	[keys setValue:@"Mem module B4" forKey:@"TMBS"]; // guessing
	[keys setValue:@"Mem module B5" forKey:@"TMCS"]; // guessing
	[keys setValue:@"Mem module B6" forKey:@"TMDS"]; // guessing
	[keys setValue:@"Mem module B7" forKey:@"TMES"]; // guessing
	[keys setValue:@"Mem module B8" forKey:@"TMFS"]; // guessing
	
    [keys setValue:@"Ambient" forKey:@"TA0P"];
    [keys setValue:@"Ambient 2" forKey:@"TA1P"];

	[keys setValue:@"LCD" forKey:@"TL0P"];    
	[keys setValue:@"HD Bay 1" forKey:@"TH0P"];
	[keys setValue:@"HD Bay 2" forKey:@"TH1P"];
	[keys setValue:@"HD Bay 3" forKey:@"TH2P"];
	[keys setValue:@"HD Bay 4" forKey:@"TH3P"];
    
	[keys setValue:@"Power supply 2" forKey:@"Tp1C"];
	[keys setValue:@"Power supply 1" forKey:@"Tp0C"];
	[keys setValue:@"Power supply 1" forKey:@"Tp0P"];
	[keys setValue:@"Enclosure Bottom" forKey:@"TB0T"];
    
	[keys setValue:@"Northbridge 1" forKey:@"TN0P"];
	[keys setValue:@"Northbridge 2" forKey:@"TN1P"];
	[keys setValue:@"Northbridge" forKey:@"TN0H"];
    
	[keys setValue:@"Expansion Slots" forKey:@"TS0C"];

	[keys setValue:@"PCI Slot 1 Pos 1" forKey:@"TA0S"];
	[keys setValue:@"PCI Slot 1 Pos 2" forKey:@"TA1S"];
	[keys setValue:@"PCI Slot 2 Pos 1" forKey:@"TA2S"];
	[keys setValue:@"PCI Slot 2 Pos 2" forKey:@"TA3S"];
    
	[keys setValue:@"Power supply 2" forKey:@"Tp1P"];
	[keys setValue:@"Power supply 3" forKey:@"Tp2P"];
	[keys setValue:@"Power supply 4" forKey:@"Tp3P"];
	[keys setValue:@"Power supply 5" forKey:@"Tp4P"];
	[keys setValue:@"Power supply 6" forKey:@"Tp5P"];
    //keys from SMART, not from SMC
	[keys setValue:@"SMART HDD Drive 1" forKey:@"SMART1"];
	[keys setValue:@"SMART HDD Drive 2" forKey:@"SMART2"];
	[keys setValue:@"SMART HDD Drive 3" forKey:@"SMART3"];
	[keys setValue:@"SMART HDD Drive 4" forKey:@"SMART4"];        
    /*    
	[keys setValue:@"MB unknown AC power related (ui8)" forKey:@"ACCL"];
	[keys setValue:@"MB unknown AC power related (ui8)" forKey:@"ACEN"];
	[keys setValue:@"MB unknown AC power related (flag)" forKey:@"ACFP"];
	[keys setValue:@"MB unknown AC power related (ch8*)" forKey:@"ACID"];
	[keys setValue:@"MB unknown AC power related (flag)" forKey:@"ACIN"];
	[keys setValue:@"MB unknown AC power related (flag)" forKey:@"ACOW"];    
	[keys setValue:@"MB unknown battery related (si16)" forKey:@"B0AC"];
	[keys setValue:@"MB unknown battery related (flag)" forKey:@"B0AP"];
	[keys setValue:@"MB unknown battery related (ui16)" forKey:@"B0AV"];
	[keys setValue:@"MB unknown battery related (ui16)" forKey:@"B0Ad"];
	[keys setValue:@"MB unknown battery related (ui16)" forKey:@"B0Al"];
	[keys setValue:@"MB unknown battery related (ui8)" forKey:@"B0Am"];
	[keys setValue:@"MB unknown battery related (ui8)" forKey:@"B0Ar"];  
    */     
	return keys;
}

+ (NSDictionary*)getKeyValues {
	NSString *cachePath = [NSString stringWithFormat:@"%@/Library/Application Support/HeatSync/keys.plist",NSHomeDirectory()];
    NSMutableDictionary *cachedKeys = [NSMutableDictionary dictionaryWithContentsOfFile:cachePath];
    if (cachedKeys == nil) cachedKeys = [NSMutableDictionary dictionaryWithDictionary:[smcWrapper getAllKeys]];
    NSMutableDictionary *loopKeys = [NSMutableDictionary dictionaryWithContentsOfFile:cachePath];   
    if (loopKeys == nil) loopKeys = [NSMutableDictionary dictionaryWithDictionary:[smcWrapper getAllKeys]];    
	NSMutableDictionary *foundKeys = [NSMutableDictionary dictionaryWithCapacity:1];
    SMCVal_t      val;	
	for(NSString *key in loopKeys){
		kern_return_t result = SMCReadKey2((char *)[key cStringUsingEncoding:NSASCIIStringEncoding], &val,conn);
		if (result == kIOReturnSuccess){
			if (val.dataSize > 0) {
                int value = ((val.bytes[0] * 256 + val.bytes[1]) >> 2)/64;
				if(value <= 0) continue;				
				[foundKeys setValue:[NSNumber numberWithInt:value] forKey:key];				
			}else {
                [cachedKeys removeObjectForKey:key];                
            }
		}
	}
    [cachedKeys writeToFile:cachePath atomically:YES];
	if ([foundKeys count] == 0) NSLog(@"getKeyValues found nothing");
	return foundKeys;
}



#pragma mark fans
+ (int)get_fan_rpm:(int)fan_number {
	UInt32Char_t  key;
	SMCVal_t      val;
	//kern_return_t result;
	sprintf(key, "F%dAc", fan_number);
	SMCReadKey2(key, &val,conn);
	int running= _strtof(val.bytes, val.dataSize, 2);
	return running;
}	

+ (int)get_fan_num {
    SMCVal_t      val;
    int           totalFans;
	SMCReadKey2("FNum", &val,conn);
    totalFans = _strtoul(val.bytes, val.dataSize, 10); 
	return totalFans;
}

+ (NSString*)get_fan_descr:(int)fan_number {
	UInt32Char_t key;
	char temp;
	SMCVal_t val;
	NSMutableString *desc = [[NSMutableString alloc] init];
	sprintf(key, "F%dID", fan_number);
	SMCReadKey2(key, &val, conn);
	int i;
	for (i = 0; i < val.dataSize; i++) {
		if ((int)val.bytes[i]>32) {
			temp = (unsigned char)val.bytes[i];
			[desc appendFormat:@"%c",temp];
		}
	}	
	return [desc autorelease];
}	

+ (int)get_min_speed:(int)fan_number {
	UInt32Char_t  key;
	SMCVal_t      val;
	sprintf(key, "F%dMn", fan_number);
	SMCReadKey2(key, &val,conn);
	int min= _strtof(val.bytes, val.dataSize, 2);
	return min;
}	

+ (int)get_max_speed:(int)fan_number {
	UInt32Char_t  key;
	SMCVal_t      val;
	sprintf(key, "F%dMx", fan_number);
	SMCReadKey2(key, &val,conn);
	int max= _strtof(val.bytes, val.dataSize, 2);
	return max;
}

+ (kern_return_t)set_fan:(char *)key rpm:(int)rpm {
    SMCVal_t val;
    
    strcpy(val.key, key);
    val.bytes[0] = (rpm << 2) / 256;
    val.bytes[1] = (rpm << 2) % 256;
    val.dataSize = 2;
    return SMCWriteKey(val);
}



#pragma mark hidden
+ (double)get_temp:(char *)key {
    SMCVal_t val;
    kern_return_t result;
    
    result = SMCReadKey(key, &val);
    if (result == kIOReturnSuccess) {
        // read succeeded - check returned value
        if (val.dataSize > 0) {
            if (strcmp(val.dataType, DATATYPE_SP78) == 0) {
                // convert fp78 value to temperature
                int intValue = (val.bytes[0] * 256 + val.bytes[1]) >> 2;
                return intValue / 64.0;
            }
        }
    }
    // read failed
    return 0.0;
}



#pragma mark keys
- (void)updateSystemInfo {
    
    int num_fans = [smcWrapper get_fan_num];
    NSString *desc = nil;
    int min, max, current;
    
    for ( int i = 0; i < num_fans; i++ ) {
        min = [smcWrapper get_min_speed:i];
        max = [smcWrapper get_max_speed:i];
        current = [smcWrapper get_fan_rpm:i];
        desc = [smcWrapper get_fan_descr:i];
        NSLog(@"\nfan%@ (idx:%d min:%d max:%d current:%d)", desc, i, min, max, current);
    }
    
    NSLog(@"battery ---------------");
    
    NSLog(@"%.2f", [smcWrapper get_temp:"TB0T"]); //Battery TS_MAX
    NSLog(@"%.2f", [smcWrapper get_temp:"TB1T"]); //Battery TS 1
    NSLog(@"%.2f", [smcWrapper get_temp:"TB2T"]); //Battery TS 2
    
    NSLog(@"cpu ---------------");
    
    NSLog(@"%.2f", [smcWrapper get_temp:"TC0P"]); //CPU 0 Proximity temp
    NSLog(@"%.2f", [smcWrapper get_temp:"TC0E"]); //
    NSLog(@"%.2f", [smcWrapper get_temp:"TC0F"]); //CPU
    
    
    NSLog(@"wifi ---------------");
    
    NSLog(@"%.2f", [smcWrapper get_temp:"TW0P"]); //Airport temp
    
    NSLog(@"graphic ---------------");
    
    NSLog(@"%.2f", [smcWrapper get_temp:"TG0P"]); //GPU 0 Proximity temp
    NSLog(@"%.2f", [smcWrapper get_temp:"TG0D"]); //GPU 0 die temp
    NSLog(@"%.2f", [smcWrapper get_temp:"TG1D"]); //gph
    
    
    /*
     //Excessive logic boardtemperature (this sensor ispart of logic board)
     NSLog(@"logic board ---------------");
     NSLog(@"%.2f", [smcWrapper get_temp:"TC1C"]);
     NSLog(@"%.2f", [smcWrapper get_temp:"TC2C"]);
     NSLog(@"%.2f", [smcWrapper get_temp:"TC3C"]);
     NSLog(@"%.2f", [smcWrapper get_temp:"TC4C"]);
     NSLog(@"%.2f", [smcWrapper get_temp:"TCGC"]);
     NSLog(@"%.2f", [smcWrapper get_temp:"TCSA"]);
     
     NSLog(@"%.2f", [smcWrapper get_temp:"TCTD"]); //cpu??
     
     //Heatsink
     NSLog(@"%.2f", [smcWrapper get_temp:"Th1H"]); //main heatsink1
     
     NSLog(@"%.2f", [smcWrapper get_temp:"TM0S"]); //memory
     NSLog(@"%.2f", [smcWrapper get_temp:"TM0P"]); //memory
     
     NSLog(@"%.2f", [smcWrapper get_temp:"TP0P"]); //power PCH-T29Proximity
     NSLog(@"%.2f", [smcWrapper get_temp:"TPCD"]); //power PCH Digital Die Temp
     NSLog(@"%.2f", [smcWrapper get_temp:"TmOP"]); //DC In Proximity
     
     NSLog(@"%.2f", [smcWrapper get_temp:"TS0P"]); //Track pad
     */
    
    [self performSelector:@selector(updateSystemInfo) withObject:nil afterDelay:5];
    
}


#pragma mark tools
+ (BOOL)volHasOwnershipSuid:(NSString *)path {
	//check if the volume has ownership and suid 
	NSArray *pathComponents = [path pathComponents];
	NSString *volume = [NSString stringWithFormat:@"/%@/%@",[pathComponents objectAtIndex:1],[pathComponents objectAtIndex:2]];
	struct statfs sb;
	int err = statfs([volume cStringUsingEncoding:NSUTF8StringEncoding], &sb);	
	if (err == 0) {
		if (sb.f_flags & MNT_IGNORE_OWNERSHIP) {
			NSLog(@"Ownership ignored on %@",volume);			
			return NO;			
		}
		if (sb.f_flags & MNT_NOSUID) {
			NSLog(@"NO setuid bits on %@",volume);			
			return NO;			
		}		
	}else {
		NSLog(@"Failed to statfs %@",volume);
		return NO;		
	}
	return YES;
}

+ (NSString *)execTask:(NSString *)launch args:(NSArray *)args {
    //NSLog(@"Exec: %@",launch);
	NSTask *task = [[[NSTask alloc] init] autorelease];
	[task setLaunchPath:launch];
	[task setArguments:args];
	
	NSPipe *pipe = [NSPipe pipe];
	[task setStandardOutput:pipe];
	
	NSFileHandle *file = [pipe fileHandleForReading];
	
	[task launch];
	
	NSData *data = [file readDataToEndOfFile];
	
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return [string autorelease];
}

+ (NSString *)machineName {
    NSString *modelString = nil;
    io_service_t pexpdev;
    if ((pexpdev = IOServiceGetMatchingService (kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"))))
    {
        CFDataRef data;
        if ((data = IORegistryEntryCreateCFProperty(pexpdev, CFSTR("product-name"), kCFAllocatorDefault, 0))) {
            modelString = [[NSString alloc] initWithCString:[(NSData*)data bytes] encoding:NSASCIIStringEncoding];
            CFRelease(data);
        }
    }    
    return [modelString autorelease];
}

+ (NSString *)machineModel {
    NSString * modelString  = nil;
    int        modelInfo[2] = { CTL_HW, HW_MODEL };
    size_t     modelSize;
	
    if (sysctl(modelInfo,2,NULL,&modelSize,NULL, 0) == 0)
    {
        void * modelData = malloc(modelSize);        
        if (modelData){
            if (sysctl(modelInfo,2,modelData,&modelSize,NULL, 0) == 0){
                modelString = [NSString stringWithUTF8String:modelData];
            }            
            free(modelData);
        }
    }    
    return modelString;
}

+ (BOOL)isIntel {
	SInt32 gestaltReturnValue;	
	OSType returnType = Gestalt(gestaltSysArchitecture, &gestaltReturnValue);	
	if (!returnType && gestaltReturnValue == gestaltIntel)	return YES;	
	return NO;
}

+ (BOOL)isDesktop {
	NSString *machineName = [smcWrapper machineModel];	
	if ([machineName rangeOfString:@"PowerBook"].location != NSNotFound) return NO;
	if ([machineName rangeOfString:@"MacBook"].location != NSNotFound) return NO;	
	return YES;	
}

@end



@implementation NSNumber (NumberAdditions)

- (NSString *)tohex {
	if ([self intValue] < 100)	NSLog(@"Will set fan rpm lower than 100");
	return [NSString stringWithFormat:@"%0.4x",[self intValue]<<2];
}

- (NSNumber *)celsius_fahrenheit {
	float celsius=[self floatValue];
	float fahrenheit=(celsius*9)/5+32;
	return [NSNumber numberWithFloat:fahrenheit];
}

@end
