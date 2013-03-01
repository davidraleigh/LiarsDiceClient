//
//  StringConversion.h
//  StringConversion
//
//  Created by David Raleigh on 9/24/12.
//  Copyright (c) 2012 David Raleigh. All rights reserved.
//

// implementation from stackoverflow
// http://stackoverflow.com/questions/3552195/how-to-convert-stdstring-to-nsstring

#import <Foundation/Foundation.h>
#import <string>

@interface NSString (cppstring_additions)
+ (NSString*)stringWithwstring:(const std::wstring&)string;
+ (NSString*)stringWithstring:(const std::string&)string;
- (std::wstring)getwstring;
- (std::string)getstring;
- (std::string)getstringTrimmed;
- (BOOL)isInteger;
@end
