// ActiveSupportKit ASDateFormatter.h
//
// Copyright © 2012, 2013, Roy Ratcliffe, Pioneering Software, United Kingdom
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

/**
 * Formats and parses date-times using a sorted collection of Cocoa date
 * formatters.
 *
 * The Active Support date formatter encapsulates a collection of
 * Foundation date formatters. Conversions between strings and dates, and vice
 * versa, occur by asking a prospective date formatter for a conversion followed
 * by a reverse conversion. If the latter matches the input, either string or
 * date, conversion succeeds. This is a longer, more rigorous conversion
 * algorithm but proves more reliable. Conversions to and from strings
 * effectively test themselves.
 */
@interface ASDateFormatter : NSObject
{
@private
	NSMutableArray *__strong _dateFormatters;
}

/**
 * Two dates match if their difference is less than the time comparison
 * threshold.
 *
 * This defaults to one millisecond. Date-times compare
 * equal if there difference does not equal or exceed this threshold.
 */
@property(assign, NS_NONATOMIC_IOSONLY) NSTimeInterval timeComparisonThreshold;

/**
 * Adds a date formatter, automatically sorting the formatters by the
 * length of their date format strings.
 *
 * Sorting produces the most compact strings when converting from dates.
 *
 * The method name includes `NS`, for Next Step, emphasising the sub-formatter
 * type. Active Support's date formatters comprise multiple NSDateFormatter
 * instances.
 */
- (void)addNSDateFormatter:(NSDateFormatter *)dateFormatter;

/**
 * Converts string to date.
 */
- (NSDate *)dateFromString:(NSString *)string;

/**
 * Converts date to string.
 *
 * Some conversions have multiple correct alternatives. The answer
 * represents the shortest string. So, for example, if a formatter supports
 * optional seconds, the resulting string will omit seconds if zero.
 */
- (NSString *)stringFromDate:(NSDate *)date;

@end
