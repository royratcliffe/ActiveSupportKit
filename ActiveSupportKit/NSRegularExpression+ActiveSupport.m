// ActiveSupportKit NSRegularExpression+ActiveSupport.m
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

#import "NSRegularExpression+ActiveSupport.h"

@implementation NSRegularExpression(ActiveSupport)

- (NSUInteger)replaceMatchesInString:(NSMutableString *)string replacementStringForResult:(ASReplacementStringForResultBlock)replacementStringForResult
{
	NSUInteger numberOfReplacements = 0;

	NSInteger offset = 0;
	for (NSTextCheckingResult *result in [self matchesInString:string options:0 range:NSMakeRange(0, [string length])])
	{
		// Replaces the entire result range. However the results after matching
		// have ranges in the index space of the original string. Offset the
		// range to correct for progressive replacements.
		NSRange resultRange = [result range];
		resultRange.location += offset;

		// Pass the mutable string to the replacement block even though the
		// interface specifies an immutable string. Do not make an immutable
		// copy. NSMutableString inherits from NSString; hence they share a
		// common immutable interface.
		NSString *replacementString = replacementStringForResult(result, string, offset);
		[string replaceCharactersInRange:resultRange withString:replacementString];
		offset += [replacementString length] - resultRange.length;
		numberOfReplacements++;
	}

	return numberOfReplacements;
}

- (NSString *)stringByReplacingMatchesInString:(NSString *)string replacementStringForResult:(ASReplacementStringForResultBlock)replacementStringForResult
{
	NSMutableString *mutableString = [string mutableCopy];

	[self replaceMatchesInString:mutableString replacementStringForResult:replacementStringForResult];

	return [mutableString copy];
}

@end
