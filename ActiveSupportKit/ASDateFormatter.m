// ActiveSupportKit ASDateFormatter.m
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

#import "ASDateFormatter.h"

@implementation ASDateFormatter

- (id)init
{
	self = [super init];
	if (self)
	{
		_dateFormatters = [NSMutableArray array];
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
	for (NSDateFormatter *dateFormatter in _dateFormatters)
	{
		NSString *string = [dateFormatter stringFromDate:date];
		if (string && [date isEqualToDate:[dateFormatter dateFromString:string]])
		{
			return string;
		}
	}
	return nil;
}

@end
