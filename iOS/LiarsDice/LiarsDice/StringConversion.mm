//
//  StringConversion.m
//  StringConversion
//
//  Created by David Raleigh on 9/24/12.
//  Copyright (c) 2012 David Raleigh. All rights reserved.
//

#import "StringConversion.h"

@implementation NSString (cppstring_additions)

#if TARGET_RT_BIG_ENDIAN
const NSStringEncoding kEncoding_wchar_t = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF32BE);
#else
const NSStringEncoding kEncoding_wchar_t = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF32LE);
#endif

+(NSString*) stringWithwstring:(const std::wstring&)ws
{
    char* data = (char*)ws.data();
    unsigned size = ws.size() * sizeof(wchar_t);
    
    NSString* result = [[NSString alloc] initWithBytes:data length:size encoding:kEncoding_wchar_t];
    return result;
}
+(NSString*) stringWithstring:(const std::string&)s
{
    NSString* result = [[NSString alloc] initWithUTF8String:s.c_str()];
    return result;
}

-(std::wstring) getwstring
{
    NSData* asData = [self dataUsingEncoding:kEncoding_wchar_t];
    return std::wstring((wchar_t*)[asData bytes], [asData length] / sizeof(wchar_t));
}
-(std::string) getstring
{
    return [self UTF8String];
}

- (std::string)getstringTrimmed
{
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] UTF8String];
}

@end