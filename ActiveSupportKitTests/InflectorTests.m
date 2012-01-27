// ActiveSupportKit InflectorTests.m
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

#import "InflectorTests.h"
#import "ASInflector.h"

@implementation InflectorTests

- (void)testCamelCaseWithUnderscores
{
	STAssertEqualObjects(@"CamelCase", [[ASInflector defaultInflector] camelize:@"Camel_Case" uppercaseFirstLetter:YES], nil);
}

- (void)testAcronyms
{
	[[ASInflector defaultInflector] addAcronym:@"API"];
	static struct
	{
		NSString *const __unsafe_unretained camel;
		NSString *const __unsafe_unretained under;
		NSString *const __unsafe_unretained human;
		NSString *const __unsafe_unretained title;
	}
	camelUnderHumanTitle[] =
	{
		{ @"API", @"api", @"API", @"API" },
	};
	for (NSUInteger i = 0; i < sizeof(camelUnderHumanTitle)/sizeof(camelUnderHumanTitle[0]); i++)
	{
		STAssertEqualObjects(camelUnderHumanTitle[i].camel, [[ASInflector defaultInflector] camelize:camelUnderHumanTitle[i].under uppercaseFirstLetter:YES], nil);
	}
}

@end
