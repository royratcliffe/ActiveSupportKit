/* ActiveSupportKit ASRFC3339.m
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

#import "ASRFC3339.h"

#import "NSDateFormatter+ActiveSupport.h"

ASDateFormatter *ASRFC3339DateFormatter()
{
	static ASDateFormatter *__strong dateFormatter;
	if (dateFormatter == nil)
	{
		dateFormatter = [[ASDateFormatter alloc] init];
		NSTimeZone *gmt = [NSTimeZone timeZoneForSecondsFromGMT:0];
		[dateFormatter addNSDateFormatter:[NSDateFormatter enUSPOSIXDateFormatterWithDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'" timeZone:gmt]];
		NSMutableString *s = [NSMutableString string];
		for (NSUInteger count = 0; count < 5; count++)
		{
			[s appendString:@"S"];
			NSString *dateFormat = [NSString stringWithFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'%@'Z'", s];
			[dateFormatter addNSDateFormatter:[NSDateFormatter enUSPOSIXDateFormatterWithDateFormat:dateFormat timeZone:gmt]];
		}
	}
	return dateFormatter;
}

NSDate *ASDateFromRFC3339String(NSString *string)
{
	return [ASRFC3339DateFormatter() dateFromString:string];
}

NSString *ASRFC3339StringFromDate(NSDate *date)
{
	return [ASRFC3339DateFormatter() stringFromDate:date];
}
