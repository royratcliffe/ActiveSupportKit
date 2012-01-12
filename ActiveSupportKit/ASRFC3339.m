/* ActiveSupportKit ASRFC3339.m
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

#import "ASRFC3339.h"

NSArray *ASRFC3339DateFormatters()
{
	static NSArray *__strong dateFormatters;
	if (dateFormatters == nil)
	{
		NSMutableArray *dateFormats = [NSMutableArray array];
		[dateFormats addObject:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
		NSMutableString *s = [NSMutableString string];
		for (NSUInteger count = 0; count < 10; count++)
		{
			[s appendString:@"S"];
			[dateFormats addObject:[NSString stringWithFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'%@'Z'", s]];
		}
		NSMutableArray *formatters = [NSMutableArray array];
		for (NSString *dateFormat in [dateFormats sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"length" ascending:YES]]])
		{
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
			[dateFormatter setDateFormat:dateFormat];
			[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
			[formatters addObject:dateFormatter];
		}
		dateFormatters = [formatters copy];
	}
	return dateFormatters;
}

NSDate *ASDateFromRFC3339String(NSString *dateString)
{
	for (NSDateFormatter *dateFormatter in ASRFC3339DateFormatters())
	{
		NSDate *date = [dateFormatter dateFromString:dateString];
		if (date && [dateString isEqualToString:[dateFormatter stringFromDate:date]])
		{
			return date;
		}
	}
	return nil;
}

NSString *ASRFC3339StringFromDate(NSDate *date)
{
	for (NSDateFormatter *dateFormatter in ASRFC3339DateFormatters())
	{
		NSString *string = [dateFormatter stringFromDate:date];
		if (string && [date isEqualToDate:[dateFormatter dateFromString:string]])
		{
			return string;
		}
	}
	return nil;
}
