// ActiveSupportKit ASInflector.h
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

#import <Foundation/Foundation.h>

/*!
 * ASInflector departs somewhat with Rails in its design. Rails uses
 * ActiveSupport and Inflector as nested modules, neither as classes. Rails also
 * uses Inflections as the primary class for capturing the inflection
 * behaviour. The module Inflector defines methods for accessing the default
 * inflections instance. Objective-C has nothing quite like modules. Hence
 * ASInflector encapsulates the primary behaviour. You can access the shared
 * inflector using +[ASInflector defaultInflector].
 */
@interface ASInflector : NSObject
{
@private
	NSMutableArray *plurals;
	NSMutableArray *singulars;
	NSMutableArray *uncountables;
	NSMutableArray *humans;
}

- (void)addPluralRegularExpressionRule:(NSString *)rule options:(NSRegularExpressionOptions)options replacement:(NSString *)replacement;
- (void)addPluralStringRule:(NSString *)rule options:(NSStringCompareOptions)options replacement:(NSString *)replacement;
- (void)addSingularRegularExpressionRule:(NSString *)rule options:(NSRegularExpressionOptions)options replacement:(NSString *)replacement;
- (void)addSingularStringRule:(NSString *)rule options:(NSStringCompareOptions)options replacement:(NSString *)replacement;

- (void)addIrregularWithSingular:(NSString *)singular plural:(NSString *)plural;

- (NSString *)pluralize:(NSString *)word;

@end
