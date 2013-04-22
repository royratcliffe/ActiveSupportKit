/* ActiveSupportKit ASReplacementStringForResults.m
 *
 * Copyright © 2012, 2013, Roy Ratcliffe, Pioneering Software, United Kingdom
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the “Software”), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 *	The above copyright notice and this permission notice shall be included in
 *	all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED “AS IS,” WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO
 * EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
 * OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 ******************************************************************************/

#import "ASReplacementStringForResults.h"
#import "NSRegularExpression+ActiveSupport.h"

NSString *ASStringByReplacingMatchesInStringUsingBlock(NSString *pattern, NSRegularExpressionOptions options, NSString *string, ASReplacementStringForResultsBlock replacementStringForResults)
{
	NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:options error:NULL];
	return [regularExpression stringByReplacingMatchesInString:string replacementStringForResult:^NSString *(NSTextCheckingResult *result, NSString *inString, NSInteger offset) {
		return replacementStringForResults(ASResultsFromTextCheckingResult(result, inString, offset));
	}];
}

NSUInteger ASReplaceMatchesInStringUsingBlock(NSString *pattern, NSRegularExpressionOptions options, NSMutableString *string, ASReplacementStringForResultsBlock replacementStringForResults)
{
	NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:options error:NULL];
	return [regularExpression replaceMatchesInString:string replacementStringForResult:^NSString *(NSTextCheckingResult *result, NSString *inString, NSInteger offset) {
		return replacementStringForResults(ASResultsFromTextCheckingResult(result, inString, offset));
	}];
}

NSArray *ASResultsFromTextCheckingResult(NSTextCheckingResult *result, NSString *inString, NSInteger offset)
{
	NSUInteger numberOfRanges = [result numberOfRanges];
	id results[numberOfRanges];
	result = [result resultByAdjustingRangesWithOffset:offset];
	for (NSUInteger i = 0; i < numberOfRanges; i++)
	{
		NSRange range = [result rangeAtIndex:i];
		results[i] = range.location != NSNotFound ? [inString substringWithRange:range] : [NSNull null];
	}
	return [NSArray arrayWithObjects:results count:numberOfRanges];
}
