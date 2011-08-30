// ActiveSupportKit ActiveSupportKitTests.m
//
// Copyright © 2011, Roy Ratcliffe, Pioneering Software, United Kingdom
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
#import "ASInflectorMethods.h"

@implementation ActiveSupportKitTests

- (void)testCamelize
{
	STAssertEqualObjects(ASInflectorCamelize(@"active_record", YES), @"ActiveRecord", @"");
	STAssertEqualObjects(ASInflectorCamelize(@"active_record", NO), @"activeRecord", @"");
	STAssertEqualObjects(ASInflectorCamelize(@"active_record/errors", YES), @"ActiveRecord::Errors", @"");
	STAssertEqualObjects(ASInflectorCamelize(@"active_record/errors", NO), @"activeRecord::Errors", @"");
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

@end
