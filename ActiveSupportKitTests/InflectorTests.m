// ActiveSupportKit InflectorTests.m
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

#import "InflectorTests.h"
#import "ASInflector.h"

@implementation InflectorTests

- (void)testInflectorRegularExpressionRules
{
	ASInflector *inflector = [[ASInflector alloc] init];
	[inflector addPluralRegularExpressionRule:@"^(ox)$" options:NSRegularExpressionCaseInsensitive replacement:@"$1en"];
	STAssertEqualObjects([inflector pluralize:@"ox"], @"oxen", nil);
	STAssertEqualObjects([inflector pluralize:@"Ox"], @"Oxen", nil);
}

- (void)testInflectorStringRules
{
	ASInflector *inflector = [[ASInflector alloc] init];
	[inflector addPluralStringRule:@"person" options:NSCaseInsensitiveSearch replacement:@"people"];
	STAssertEqualObjects([inflector pluralize:@"person"], @"people", nil);

	// The following tests a failure. It finds a match but replaces it with the
	// literal replacement disregarding case considerations.
	STAssertEqualObjects([inflector pluralize:@"Person"], @"people", nil);
}

- (void)testIrregular
{
	ASInflector *inflector = [[ASInflector alloc] init];
	[inflector addIrregularWithSingular:@"person" plural:@"people"];
	STAssertEqualObjects([inflector pluralize:@"person"], @"people", nil);
	STAssertEqualObjects([inflector pluralize:@"Person"], @"People", nil);

	// Ignores capitals after the first letter. Rails does that too.
	//
	//	require 'active_support'
	//	require 'active_support/inflector/inflections'
	//	require 'active_support/inflections'
	//	p ActiveSupport::Inflector.pluralize "PERSON"
	//
	// gives
	//
	//	"People"
	//
	STAssertEqualObjects([inflector pluralize:@"PERSON"], @"People", nil);
}

- (void)testPlurals
{
	STAssertEqualObjects([[ASInflector defaultInflector] pluralize:@"quiz"], @"quizzes", nil);
	STAssertEqualObjects([[ASInflector defaultInflector] pluralize:@"bus"], @"buses", nil);
	STAssertEqualObjects([[ASInflector defaultInflector] pluralize:@"octopus"], @"octopi", nil);
	STAssertEqualObjects([[ASInflector defaultInflector] pluralize:@"axe"], @"axes", nil);
	STAssertEqualObjects([[ASInflector defaultInflector] pluralize:@"object"], @"objects", nil);
}

- (void)testSingulars
{
	STAssertEqualObjects([[ASInflector defaultInflector] singularize:@"quizzes"], @"quiz", nil);
}

- (void)testHumanize
{
	STAssertEqualObjects([[ASInflector defaultInflector] humanize:@"employee_salary"], @"Employee salary", nil);
	STAssertEqualObjects([[ASInflector defaultInflector] humanize:@"author_id"], @"Author", nil);
}

- (void)testTitleize
{
	STAssertEqualObjects([[ASInflector defaultInflector] titleize:@"man from the boondocks"], @"Man From The Boondocks", nil);
	STAssertEqualObjects([[ASInflector defaultInflector] titleize:@"x-men: the last stand"], @"X Men: The Last Stand", nil);
}

- (void)testCamelCaseWithUnderscores
{
	STAssertEqualObjects(@"CamelCase", [[ASInflector defaultInflector] camelize:@"Camel_Case" uppercaseFirstLetter:YES], nil);
}

- (void)testAcronyms
{
	[[ASInflector defaultInflector] addAcronym:@"API"];
	[[ASInflector defaultInflector] addAcronym:@"HTML"];
	[[ASInflector defaultInflector] addAcronym:@"HTTP"];
	[[ASInflector defaultInflector] addAcronym:@"SSL"];
	[[ASInflector defaultInflector] addAcronym:@"RESTful"];
	[[ASInflector defaultInflector] addAcronym:@"W3C"];
	static struct
	{
		NSString *const __unsafe_unretained camel;
		NSString *const __unsafe_unretained under;
		NSString *const __unsafe_unretained human;
		NSString *const __unsafe_unretained title;
	}
	camelUnderHumanTitle[] =
	{
		{ @"API",               @"api",                @"API",                @"API" },
		{ @"APIController",     @"api_controller",     @"API controller",     @"API Controller" },
		{ @"Nokogiri::HTML",    @"nokogiri/html",      @"Nokogiri/HTML",      @"Nokogiri/HTML" },
		{ @"HTTPAPI",           @"http_api",           @"HTTP API",           @"HTTP API" },
		{ @"HTTP::Get",         @"http/get",           @"HTTP/get",           @"HTTP/Get" },
		{ @"SSLError",          @"ssl_error",          @"SSL error",          @"SSL Error" },
		{ @"RESTful",           @"restful",            @"RESTful",            @"RESTful" },
		{ @"RESTfulController", @"restful_controller", @"RESTful controller", @"RESTful Controller" },
		{ @"IHeartW3C",         @"i_heart_w3c",        @"I heart W3C",        @"I Heart W3C" },
	};
	for (NSUInteger i = 0; i < sizeof(camelUnderHumanTitle)/sizeof(camelUnderHumanTitle[0]); i++)
	{
		STAssertEqualObjects(camelUnderHumanTitle[i].camel, [[ASInflector defaultInflector] camelize:camelUnderHumanTitle[i].under uppercaseFirstLetter:YES], nil);
		STAssertEqualObjects(camelUnderHumanTitle[i].camel, [[ASInflector defaultInflector] camelize:camelUnderHumanTitle[i].camel uppercaseFirstLetter:YES], nil);
		STAssertEqualObjects(camelUnderHumanTitle[i].under, [[ASInflector defaultInflector] underscore:camelUnderHumanTitle[i].under], nil);
		STAssertEqualObjects(camelUnderHumanTitle[i].under, [[ASInflector defaultInflector] underscore:camelUnderHumanTitle[i].camel], nil);
		STAssertEqualObjects(camelUnderHumanTitle[i].title, [[ASInflector defaultInflector] titleize:camelUnderHumanTitle[i].under], nil);
		STAssertEqualObjects(camelUnderHumanTitle[i].title, [[ASInflector defaultInflector] titleize:camelUnderHumanTitle[i].camel], nil);
		STAssertEqualObjects(camelUnderHumanTitle[i].human, [[ASInflector defaultInflector] humanize:camelUnderHumanTitle[i].under], nil);
	}
}

- (void)testDemodularize
{
	STAssertEqualObjects(@"Account", [[ASInflector defaultInflector] demodularize:@"MyApplication::Billing::Account"], nil);
	STAssertEqualObjects(@"Account", [[ASInflector defaultInflector] demodularize:@"Account"], nil);
	STAssertEqualObjects(@"", [[ASInflector defaultInflector] demodularize:@""], nil);
}

- (void)testDeconstantize
{
	STAssertEqualObjects(@"MyApplication::Billing", [[ASInflector defaultInflector] deconstantize:@"MyApplication::Billing::Account"], nil);
	STAssertEqualObjects(@"::MyApplication::Billing", [[ASInflector defaultInflector] deconstantize:@"::MyApplication::Billing::Account"], nil);

	STAssertEqualObjects(@"MyApplication", [[ASInflector defaultInflector] deconstantize:@"MyApplication::Billing"], nil);
	STAssertEqualObjects(@"::MyApplication", [[ASInflector defaultInflector] deconstantize:@"::MyApplication::Billing"], nil);

	STAssertEqualObjects(@"", [[ASInflector defaultInflector] deconstantize:@"Account"], nil);
	STAssertEqualObjects(@"", [[ASInflector defaultInflector] deconstantize:@"::Account"], nil);
	STAssertEqualObjects(@"", [[ASInflector defaultInflector] deconstantize:@""], nil);
}

- (void)testForeignKey
{
	STAssertEqualObjects(@"person_id", [[ASInflector defaultInflector] foreignKey:@"Person" separateClassNameAndIDWithUnderscore:YES], nil);
	STAssertEqualObjects(@"account_id", [[ASInflector defaultInflector] foreignKey:@"MyApplication::Billing::Account" separateClassNameAndIDWithUnderscore:YES], nil);

	STAssertEqualObjects(@"personid", [[ASInflector defaultInflector] foreignKey:@"Person" separateClassNameAndIDWithUnderscore:NO], nil);
	STAssertEqualObjects(@"accountid", [[ASInflector defaultInflector] foreignKey:@"MyApplication::Billing::Account" separateClassNameAndIDWithUnderscore:NO], nil);
}

@end
