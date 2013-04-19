/* ActiveSupportKit ASReplacementStringForResults.h
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

#import <Foundation/Foundation.h>

typedef NSString *(^ASReplacementStringForResultsBlock)(NSArray *results);

/**
 * Helper function for simplifying regular-expression replacement.
 *
 * The helper exists to simplify the common patterns of usage by the
 * inflector. It also decodes the resulting ranges. The replacement handler
 * block, argument @a replacementStringForResults, takes an array of strings,
 * one for each captured range. The @a results array can contain `NSNull`
 * elements. These correspond to ranges _not_ found.
 */
NSString *ASStringByReplacingMatchesInStringUsingBlock(NSString *pattern, NSRegularExpressionOptions options, NSString *string, ASReplacementStringForResultsBlock replacementStringForResults);

NSUInteger ASReplaceMatchesInStringUsingBlock(NSString *pattern, NSRegularExpressionOptions options, NSMutableString *string, ASReplacementStringForResultsBlock replacementStringForResults);

/**
 * Safely extracts an array of captured ranges from a given text-checking result.
 *
 * @result Answers an array of string and nulls. Array elements are either
 * NSString or NSNull instances. String elements contain the captured text. Null
 * elements correspond to ranges not found. Pass elements through @ref
 * ASNilForNull to convert nulls to `nil`.
 */
NSArray *ASResultsFromTextCheckingResult(NSTextCheckingResult *result, NSString *inString, NSInteger offset);
