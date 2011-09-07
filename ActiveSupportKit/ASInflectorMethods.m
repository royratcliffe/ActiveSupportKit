// ActiveSupportKit ASInflectorMethods.m
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

#import "ASInflectorMethods.h"
#import "NSRegularExpression+ActiveSupport.h"

NSString *ASInflectorCamelize(NSString *lowerCaseAndUnderscoredWord, BOOL firstLetterInUppercase)
{
	NSString *camelizedString;
	if (firstLetterInUppercase)
	{
		camelizedString = [[NSRegularExpression regularExpressionWithPattern:@"/(.?)" options:0 error:NULL] replaceMatchesInString:lowerCaseAndUnderscoredWord replacementStringForResult:^NSString *(NSTextCheckingResult *result, NSString *inString, NSInteger offset) {
			return [@"::" stringByAppendingString:[[[result regularExpression] replacementStringForResult:result inString:inString offset:offset template:@"$1"] uppercaseString]];
		}];
		//	(?:)	grouping without back-references
		//	^|_		beginning of a line or string, or an underscore
		camelizedString = [[NSRegularExpression regularExpressionWithPattern:@"(?:^|_)(.)" options:0 error:NULL] replaceMatchesInString:camelizedString replacementStringForResult:^NSString *(NSTextCheckingResult *result, NSString *inString, NSInteger offset) {
			return [[[result regularExpression] replacementStringForResult:result inString:inString offset:offset template:@"$1"] uppercaseString];
		}];
	}
	else
	{
		camelizedString = ASInflectorCamelize(lowerCaseAndUnderscoredWord, YES);
		camelizedString = [[[lowerCaseAndUnderscoredWord substringWithRange:NSMakeRange(0, 1)] lowercaseString] stringByAppendingString:[camelizedString substringWithRange:NSMakeRange(1, [camelizedString length] - 1)]];
	}
	return camelizedString;
}

NSString *ASInflectorUnderscore(NSString *camelCasedWord)
{
	NSMutableString *word = [[camelCasedWord mutableCopy] autorelease];
	[[NSRegularExpression regularExpressionWithPattern:@"::" options:0 error:NULL] replaceMatchesInString:word options:0 range:NSMakeRange(0, [word length]) withTemplate:@"/"];
	[[NSRegularExpression regularExpressionWithPattern:@"([A-Z]+)([A-Z][a-z])" options:0 error:NULL] replaceMatchesInString:word options:0 range:NSMakeRange(0, [word length]) withTemplate:@"$1_$2"];
	[[NSRegularExpression regularExpressionWithPattern:@"([a-z\\d])([A-Z])" options:0 error:NULL] replaceMatchesInString:word options:0 range:NSMakeRange(0, [word length]) withTemplate:@"$1_$2"];
	return [[[[word copy] autorelease] stringByReplacingOccurrencesOfString:@"-" withString:@"_"] lowercaseString];
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
