// ActiveSupportKit ASDateFormatter.m
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

#import "ASDateFormatter.h"

@implementation ASDateFormatter

@synthesize timeComparisonThreshold;

- (id)init
{
	self = [super init];
	if (self)
	{
		_dateFormatters = [NSMutableArray array];
		[self setTimeComparisonThreshold:0.001];
	}
	return self;
}

- (void)addNSDateFormatter:(NSDateFormatter *)dateFormatter
{
	[_dateFormatters addObject:dateFormatter];
	[_dateFormatters sortUsingComparator:^NSComparisonResult(id lhs, id rhs) {
		return [[NSNumber numberWithUnsignedInteger:[[(NSDateFormatter *)lhs dateFormat] length]] compare:[NSNumber numberWithUnsignedInteger:[[(NSDateFormatter *)rhs dateFormat] length]]];
	}];
}

- (NSDate *)dateFromString:(NSString *)string
{
	for (NSDateFormatter *dateFormatter in _dateFormatters)
	{
		NSDate *date = [dateFormatter dateFromString:string];
		if (date && [string isEqualToString:[dateFormatter stringFromDate:date]])
		{
			return date;
		}
	}
	return nil;
}

- (NSString *)stringFromDate:(NSDate *)date
{
	// Date comparisons prove tricky. The -[NSDate isEqualToDate:anotherDate]
	// detects sub-second differences in dates. It answers true if, and only if,
	// the two dates match exactly. Therefore avoid using this method in case
	// all formatters fail due to lack of time resolution.
	for (NSDateFormatter *dateFormatter in _dateFormatters)
	{
		NSString *string = [dateFormatter stringFromDate:date];
		if (string && fabs([date timeIntervalSinceDate:[dateFormatter dateFromString:string]]) < [self timeComparisonThreshold])
		{
			return string;
		}
	}
	return nil;
}

@end
