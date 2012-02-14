// ActiveSupportKit ASDateFormatter.h
//
// Copyright © 2012, Roy Ratcliffe, Pioneering Software, United Kingdom
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the “Software”), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS,” WITHOUT WARRANTY OF ANY KIND, EITHER
// EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//
//------------------------------------------------------------------------------

#import <Foundation/Foundation.h>

/*!
 * @brief Formats and parses date-times using a sorted collection of Cocoa date
 * formatters.
 * @details The Active Support date formatter encapsulates a collection of
 * Foundation date formatters. Conversions between strings and dates, and vice
 * versa, occur by asking a prospective date formatter for a conversion followed
 * by a reverse conversion. If the latter matches the input, either string or
 * date, conversion succeeds. This is a longer, more rigourous conversion
 * algorithm but proves more reliable. Conversions to and from strings
 * effectively test themselves.
 */
@interface ASDateFormatter : NSObject
{
@private
	NSMutableArray *__strong _dateFormatters;
}

/*!
 * @brief Adds a date formatter, automatically sorting the formatters by the
 * length of their date format strings. @details This produces the most compact
 * strings when converting from dates.
 */
- (void)addDateFormatter:(NSDateFormatter *)dateFormatter;

/*!
 * @brief Converts string to date.
 */
- (NSDate *)dateFromString:(NSString *)string;

/*!
 * @brief Converts date to string.
 */
- (NSString *)stringFromDate:(NSDate *)date;

/*!
 * @brief Convenience class method for constructing a US English POSIX-locale
 * date formatter.
 * @details You only need to set up the date format and time zone. The returned
 * date formatter will work consistently for all users, regardless of both user
 * and system preferences.
 */
+ (NSDateFormatter *)enUSPOSIXDateFormatter;

// more convenience methods for constructing en-US POSIX date formatters using date format and time zone
+ (NSDateFormatter *)enUSPOSIXDateFormatterWithDateFormat:(NSString *)dateFormat;
+ (NSDateFormatter *)enUSPOSIXDateFormatterWithDateFormat:(NSString *)dateFormat timeZone:(NSTimeZone *)timeZone;

@end
