// ActiveSupportKit NSRegularExpression+ActiveSupport.h
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

#import <Foundation/Foundation.h>

typedef NSString *(^ASReplacementStringForResultBlock)(NSTextCheckingResult *result, NSString *inString, NSInteger offset);

@interface NSRegularExpression(ActiveSupport)

/**
 * Replaces all matches of a given regular expression in a given string
 * using a given block to compute the replacement string for each match.
 *
 * The block accepts the match result, the progressively replaced
 * string along with its progressive offset.
 *
 * Use the method as follows. Suppose you want to have strings of the form
 * `"a/b/c"` and you want to replace every path element separator (the forward
 * slashes) to double-colons and fold the following character to uppercase at
 * the same time. This assumes the characters following the slashes are
 * letters. We could use the regular expression `"/(.?)"` meaning a slash
 * optionally followed by any character. The parentheses act as markers for
 * substitution.
 *
 *	NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"/(.?)"
 *																		options:0
 *																		  error:NULL];
 *	NSString *answer = [re replaceMatchesInString:@"a/b/c"
 *					   replacementStringForResult:^NSString *(NSTextCheckingResult *result,
 *															  NSString *inString,
 *															  NSInteger offset) {
 *						   // See Note 1
 *						   NSRegularExpression *re = [result regularExpression];
 *						   // See Note 2
 *						   NSString *s1 = [re replacementStringForResult:result
 *																inString:inString
 *																  offset:offset
 *																template:@"$1"];
 *						   return [@"::" stringByAppendingString:[s1 uppercaseString]];
 *					   }];
 *	NSLog(@"\"%@\"", answer);
 *
 * The answer `"a::B::C"` appears in the log.
 *
 * - Note 1:
 * Uses `result` to access the regular expression again. This step could be
 * omitted because (in this example) this interior block has access to the
 * exterior context, the `re` above. However, that is not always the
 * case. Accessing the original regular expression via the matching result
 * proves the best general approach.
 * - Note 2:
 * Pulls out `s1` from the input string, the string matching the first
 * parentheses. The `"$1"` template refers to this first matching part of the
 * entire regular expression match. The block runs for every match. Of course,
 * each match can have multiple matching subsections. See Apple documentation
 * for `NSRegularExpression` for more details.
 *
 * @result Answers the total number of replacements completed.
 */
- (NSUInteger)replaceMatchesInString:(NSMutableString *)string replacementStringForResult:(ASReplacementStringForResultBlock)replacementStringForResult;

- (NSString *)stringByReplacingMatchesInString:(NSString *)string replacementStringForResult:(ASReplacementStringForResultBlock)replacementStringForResult;

@end
