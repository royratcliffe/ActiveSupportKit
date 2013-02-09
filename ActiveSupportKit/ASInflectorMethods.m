// ActiveSupportKit ASInflectorMethods.m
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

#import "ASInflectorMethods.h"
#import "ASInflector.h"
#import "NSRegularExpression+ActiveSupport.h"

NSString *ASInflectorCamelize(NSString *lowerCaseAndUnderscoredWord, BOOL firstLetterInUppercase)
{
	return [[ASInflector defaultInflector] camelize:lowerCaseAndUnderscoredWord uppercaseFirstLetter:firstLetterInUppercase];
}

NSString *ASInflectorUnderscore(NSString *camelCasedWord)
{
	return [[ASInflector defaultInflector] underscore:camelCasedWord];
}

NSString *ASInflectorDasherize(NSString *underscoredWord)
{
	return [underscoredWord stringByReplacingOccurrencesOfString:@"_" withString:@"-"];
}

NSString *ASInflectorDemodulize(NSString *classNameInModule)
{
	return [[NSRegularExpression regularExpressionWithPattern:@"^.*::" options:0 error:NULL] stringByReplacingMatchesInString:classNameInModule options:0 range:NSMakeRange(0, [classNameInModule length]) withTemplate:@""];
}

NSString *ASInflectorOrdinalize(NSNumber *number)
{
	NSString *suffix;
	NSInteger absoluteIntegerValue = [number integerValue];
	// NSInteger is a long or an int depending on architecture. Avoid using abs,
	// labs or llabs from the standard C library to find out the absolute
	// integer value. Long integers are 64 bits wide in 64-bit software. Hence
	// the name and signature of the correct function changes according to
	// architecture. Let the compiler handle it. Just subtract from zero if
	// negative.
	if (absoluteIntegerValue < 0)
	{
		absoluteIntegerValue = -absoluteIntegerValue;
	}
	switch (absoluteIntegerValue % 100)
	{
		case 11:
		case 12:
		case 13:
			suffix = @"th";
			break;
		default:
		{
			switch (absoluteIntegerValue % 10)
			{
				case 1:
					suffix = @"st";
					break;
				case 2:
					suffix = @"nd";
					break;
				case 3:
					suffix = @"rd";
					break;
				default:
					suffix = @"th";
			}
		}
	}
	return [[number description] stringByAppendingString:suffix];
}

NSString *ASInflectorApplyRulesAndReplacements(NSArray *rulesAndReplacements, NSString *word)
{
	NSMutableString *result = [word mutableCopy];
	// Plurals is an array of arrays. The elements have two or three
	// sub-elements. If two elements, the first specifies a regular expression
	// and the second its replacement template. If three elements, the first
	// specifies a string target, the second its replacement and the third its
	// string compare options.
	//
	// Why is this necessary? Simply because Objective-C has no polymorphic
	// “gsub” method which accepts either a regular expression or string. Nor
	// can string-based search and replacements incorporate any flags;
	// comparison options amount to extra baggage. Hence the array of plurals
	// polymorphically carries different kinds of rules and their
	// replacements. The number of elements, the array count, determines
	// behaviour.
	for (NSArray *ruleAndReplacement in rulesAndReplacements)
	{
		if ([ruleAndReplacement count] == 2)
		{
			NSRegularExpression *re = [ruleAndReplacement objectAtIndex:0];
			NSString *replacement = [ruleAndReplacement objectAtIndex:1];
			if ([re replaceMatchesInString:result options:0 range:NSMakeRange(0, [result length]) withTemplate:replacement])
			{
				break;
			}
		}
		else if ([ruleAndReplacement count] == 3)
		{
			NSString *target = [ruleAndReplacement objectAtIndex:0];
			NSString *replacement = [ruleAndReplacement objectAtIndex:1];
			NSUInteger options = [[ruleAndReplacement objectAtIndex:2] unsignedIntegerValue];
			if ([result replaceOccurrencesOfString:target withString:replacement options:options range:NSMakeRange(0, [result length])])
			{
				break;
			}
		}
	}
	return [result copy];
}
