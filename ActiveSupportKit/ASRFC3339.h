/* ActiveSupportKit ASRFC3339.h
 *
 * Copyright © 2012, Roy Ratcliffe, Pioneering Software, United Kingdom
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

#import <Foundation/Foundation.h>

/*!
 * @brief Converts an RFC 3339 date-time string to a date.
 * @details <a href="http://www.ietf.org/rfc/rfc3339.txt">Request for Comments
 * 3339</a> describes a standard Internet date-time format as follows. @code
 * yyyy-mm-ddThh:mm:ssZ @endcode where @c yyyy-mm-dd describes the year, month
 * and day of month using decimal digits; @c hh:mm:ss describes hours, minutes
 * and seconds. Time is expressed in Zulu time, more commonly known as Greenwich
 * Mean Time. See Apple's Technical Q&A QA1480 for more details.
 */
NSDate *ASDateFromRFC3339String(NSString *dateTimeString);
