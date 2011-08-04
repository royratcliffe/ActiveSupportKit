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
#import "NSRegularExpression+RRFoundation.h"

NSString *ASInflectorCamelize(NSString *lowerCaseAndUnderscoredWord, BOOL firstLetterInUppercase)
{
	NSString *__autoreleasing camelizedString;
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
