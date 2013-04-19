/* ActiveSupportKit ASRFC3339.h
 *
 * Copyright © 2012, 2013, Roy Ratcliffe, Pioneering Software, United Kingdom
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the “Software”), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 *	The above copyright notice and this permission notice shall be included in
 *	all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED “AS IS,” WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO
 * EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
 * OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 ******************************************************************************/

#import <ActiveSupportKit/ASDateFormatter.h>

ASDateFormatter *ASRFC3339DateFormatter(void);

/**
 * Converts an RFC 3339 date-time string to a date.
 *
 * <a href="http://www.ietf.org/rfc/rfc3339.txt">Request for Comments
 * 3339</a> describes a standard Internet date-time format as follows.
 * `yyyy-mm-ddThh:mm:ssZ` where `yyyy-mm-dd` describes the year, month
 * and day of month using decimal digits; `hh:mm:ss` describes hours, minutes
 * and seconds. Time is expressed in Zulu time, more commonly known as Greenwich
 * Mean Time. See Apple's Technical Q&A QA1480 for more details.
 *
 * @par Implementation Notes:
 * The implementation searches for the first successful formatter where the
 * resulting date reverse-formats to a matching date string. This may result in
 * a number of formatting and parsing iterations and therefore runs slower than
 * a one-shot attempt. However, the algorithm effectively guarantees reverse
 * translation if and when that becomes necessary. To mitigate the iterative
 * approach, the implementation caches the date formatters.
 */
NSDate *ASDateFromRFC3339String(NSString *string);

/**
 * Converts the given date to a string in RFC 3339 format.
 */
NSString *ASRFC3339StringFromDate(NSDate *date);
