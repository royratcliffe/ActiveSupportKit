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
 *
 * The method name includes @c NS, for Next Step, emphasising the sub-formatter
 * type. Active Support's date formatters comprise multiple NSDateFormatter
 * instances.
 */
- (void)addNSDateFormatter:(NSDateFormatter *)dateFormatter;

/*!
 * @brief Converts string to date.
 */
- (NSDate *)dateFromString:(NSString *)string;

/*!
 * @brief Converts date to string.
 */
- (NSString *)stringFromDate:(NSDate *)date;

@end
