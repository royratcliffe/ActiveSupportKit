// ActiveSupportKit ASInflectorMethods.h
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

NSString *ASInflectorCamelize(NSString *lowerCaseAndUnderscoredWord, BOOL firstLetterInUppercase);

/**
 * Makes an underscored and lowercase form of the given string. Replaces
 * double-colons with slashes. Two or more capital letters followed by lower
 * case letters become separated words, separated that is by an underscore; the
 * underscore appears before the last capital, e.g. ABCdef becomes ab_cdef
 * assuming that Cdef is a meaningful word. Similarly, a1A becomes
 * underscore-separated as a1_a. Finally replaces dashes for underscores and
 * down-cases the result.
 */
NSString *ASInflectorUnderscore(NSString *camelCasedWord);

/**
 * Replaces underscores with dashes.
 */
NSString *ASInflectorDasherize(NSString *underscoredWord);

NSString *ASInflectorDemodulize(NSString *classNameInModule);

NSString *ASInflectorOrdinalize(NSNumber *number);

NSString *ASInflectorApplyRulesAndReplacements(NSArray *rulesAndReplacements, NSString *word);
