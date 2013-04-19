// ActiveSupportKit ActiveSupportKitTests.m
//
// Copyright © 2011–2013, Roy Ratcliffe, Pioneering Software, United Kingdom
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

#import "ActiveSupportKitTests.h"
#import <ActiveSupportKit/ActiveSupportKit.h>

@implementation ActiveSupportKitTests

- testVersioning
{
	STAssertEquals(kActiveSupportKitVersionNumber, 1.0, nil);
}

- (void)testCamelize
{
	STAssertEqualObjects([[ASInflector defaultInflector] camelize:@"active_record" uppercaseFirstLetter:YES], @"ActiveRecord", @"");
	STAssertEqualObjects([[ASInflector defaultInflector] camelize:@"active_record" uppercaseFirstLetter:NO], @"activeRecord", @"");
	STAssertEqualObjects([[ASInflector defaultInflector] camelize:@"active_record/errors" uppercaseFirstLetter:YES], @"ActiveRecord::Errors", @"");
	STAssertEqualObjects([[ASInflector defaultInflector] camelize:@"active_record/errors" uppercaseFirstLetter:NO], @"activeRecord::Errors", @"");
}

- (void)testUnderscore
{
	STAssertEqualObjects(ASInflectorUnderscore(@"ActiveRecord"), @"active_record", nil);
	STAssertEqualObjects(ASInflectorUnderscore(@"ActiveRecord::Errors"), @"active_record/errors", nil);
	STAssertEqualObjects(ASInflectorUnderscore(@"AAAAzzzz"), @"aaa_azzzz", nil);
	STAssertEqualObjects(ASInflectorUnderscore(@"a1Z"), @"a1_z", nil);
}

- (void)testDasherize
{
	STAssertEqualObjects(ASInflectorDasherize(@"puni_puni"), @"puni-puni", nil);
}

- (void)testDemodulize
{
	STAssertEqualObjects(ASInflectorDemodulize(@"ActiveRecord::CoreExtensions::String::Inflections"), @"Inflections", nil);
	STAssertEqualObjects(ASInflectorDemodulize(@"Inflections"), @"Inflections", nil);
}

- (void)testOrdinalize
{
	STAssertEqualObjects(ASInflectorOrdinalize([NSNumber numberWithInt:1]), @"1st", nil);
	STAssertEqualObjects(ASInflectorOrdinalize([NSNumber numberWithInt:2]), @"2nd", nil);
	STAssertEqualObjects(ASInflectorOrdinalize([NSNumber numberWithInt:1002]), @"1002nd", nil);
	STAssertEqualObjects(ASInflectorOrdinalize([NSNumber numberWithInt:1003]), @"1003rd", nil);
	STAssertEqualObjects(ASInflectorOrdinalize([NSNumber numberWithInt:-11]), @"-11th", nil);
	STAssertEqualObjects(ASInflectorOrdinalize([NSNumber numberWithInt:-1021]), @"-1021st", nil);
}

- (void)testArrayToParam
{
	NSArray *array = [NSArray arrayWithObjects:@"a", @"b", @"c", nil];
	STAssertEqualObjects([array toParam], @"a/b/c", nil);
	array = [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], nil];
	STAssertEqualObjects([array toParam], @"1/2/3", nil);
}

- (void)testArrayToQuery
{
	NSArray *array = [NSArray arrayWithObjects:@"Rails", @"coding", nil];
	STAssertEqualObjects([array toQueryWithKey:@"hobbies"], @"hobbies%5B%5D=Rails&hobbies%5B%5D=coding", nil);
}

- (void)testHashToParam
{
	NSDictionary *hash = [NSDictionary dictionaryWithObjectsAndKeys:@"David", @"name", @"Danish", @"nationality", nil];
	STAssertEqualObjects([hash toParamWithNamespace:nil], @"name=David&nationality=Danish", nil);
	STAssertEqualObjects([hash toParamWithNamespace:@"user"], @"user%5Bname%5D=David&user%5Bnationality%5D=Danish", nil);
	// Rails outputs
	//
	//	user[name]=David&user[nationality]=Danish
	//
	// but this Objective-C implementation outputs
	//
	//	user%5Bname%5D=David&user%5Bnationality%5D=Danish
	//
	// This happens because [ and ] turns to %5B and %5D. Apple's
	// -stringByAddingPercentEscapesUsingEncoding: escapes more zealously
	// compared to Rails. Does it amount to the same thing in the end?
}

- (void)testJSONDecode
{
	// require 'active_support'
	// p ActiveSupport::JSON.decode("[\"hello world\"]")
	NSError *__autoreleasing error = nil;
	id object = ASJSONDecodeFromData([@"[\"hello world\"]" dataUsingEncoding:NSUTF8StringEncoding], &error);
	STAssertTrue([object isKindOfClass:[NSArray class]], nil);
	STAssertEquals([object count], (NSUInteger)1, nil);
	STAssertEqualObjects([object objectAtIndex:0], @"hello world", nil);
	STAssertEqualObjects(error, nil, nil);
}

- (void)testJSONEncode
{
	STAssertEqualObjects(ASJSONEncodeToString([NSArray arrayWithObject:@"hello world"], NULL), @"[\"hello world\"]", nil);
}

- (void)testRFC3339
{
	// Construct an arbitrary reference date-time.
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	[calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	[dateComponents setYear:1985];
	[dateComponents setMonth:4];
	[dateComponents setDay:12];
	[dateComponents setHour:23];
	[dateComponents setMinute:20];
	[dateComponents setSecond:50];
	NSDate *date = [calendar dateFromComponents:dateComponents];

	STAssertEqualObjects(ASDateFromRFC3339String(@"1985-04-12T23:20:50Z"), date, nil);
	STAssertEqualObjects(ASDateFromRFC3339String(@"1985-04-12T23:20:50.52Z"), [date dateByAddingTimeInterval:0.52], nil);
}

- (void)testRFC2822
{
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	[dateComponents setYear:1999];
	[dateComponents setMonth:12];
	[dateComponents setDay:31];
	[dateComponents setHour:19];
	[dateComponents setMinute:0];
	[dateComponents setSecond:0];
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	[calendar setTimeZone:[NSTimeZone timeZoneWithName:@"EST"]];
	NSDate *date = [calendar dateFromComponents:dateComponents];
	// Note, ASRFC2822StringFromDate applies the current time zone when
	// converting from a date. This may not be Greenwich Mean Time. Fixing the
	// time zone occurs when the ActiveSupport date formatter constructs its
	// dependent NSDateFormatter objects. The sub-formatters apply the default
	// time zone.
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	[dateFormatter setDateFormat:@"dd MMM yyyy HH:mm ZZZ"];
	STAssertEqualObjects(ASRFC2822StringFromDate(date), [dateFormatter stringFromDate:date], nil);
}

- (void)testNilForNull
{
	STAssertNil(ASNilForNull([NSNull null]), nil);
	STAssertNil(ASNilForNull(nil), nil);
	STAssertNotNil(ASNilForNull([[NSObject alloc] init]), nil);
}

- (void)testNullForNil
{
	id object = [NSObject new];
	STAssertEqualObjects([NSNull null], ASNullForNil(nil), nil);
	STAssertEqualObjects(object, ASNullForNil(object), nil);
}

@end
