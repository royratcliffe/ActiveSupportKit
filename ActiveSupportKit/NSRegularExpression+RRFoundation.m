// RRFoundation NSRegularExpression+RRFoundation.m
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

#import "NSRegularExpression+RRFoundation.h"

@implementation NSRegularExpression(RRFoundation)

- (NSString *)replaceMatchesInString:(NSString *)string replacementStringForResult:(NSString *(^)(NSTextCheckingResult *result, NSString *inString, NSInteger offset))replacementStringForResult
{
	NSMutableString *mutableString = [[string mutableCopy] autorelease];
	
	NSInteger offset = 0;
	for (NSTextCheckingResult *result in [self matchesInString:string options:0 range:NSMakeRange(0, [string length])])
	{
		// Replaces the entire result range. However the results after matching
		// have ranges in the index space of the original string. Offset the
		// range to correct for progressive replacements.
		NSRange resultRange = [result range];
		resultRange.location += offset;
		
		NSString *replacementString = replacementStringForResult(result, mutableString, offset);
		[mutableString replaceCharactersInRange:resultRange withString:replacementString];
		offset += [replacementString length] - resultRange.length;
	}
	
	return [[mutableString copy] autorelease];
}

@end
