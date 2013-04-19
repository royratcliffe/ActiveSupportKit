// ActiveSupportKit NSDateFormatter+ActiveSupport.h
//
// Copyright © 2012, 2013, Roy Ratcliffe, Pioneering Software, United Kingdom
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS," WITHOUT WARRANTY OF ANY KIND, EITHER
// EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//
//------------------------------------------------------------------------------

#import <Foundation/Foundation.h>

@interface NSDateFormatter(ActiveSupport)

/**
 * Convenience class method for constructing a US English POSIX-locale
 * date formatter.
 *
 * You only need to set up the date format and time zone. The returned
 * date formatter will work consistently for all users, regardless of both user
 * and system preferences.
 */
+ (NSDateFormatter *)enUSPOSIXDateFormatter;

// more convenience methods for constructing en-US POSIX date formatters using date format and time zone
+ (NSDateFormatter *)enUSPOSIXDateFormatterWithDateFormat:(NSString *)dateFormat;
+ (NSDateFormatter *)enUSPOSIXDateFormatterWithDateFormat:(NSString *)dateFormat timeZone:(NSTimeZone *)timeZone;

@end
