// ActiveSupportKit ActiveSupportKit.h
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

#import <ActiveSupportKit/ASJSON.h>
#import <ActiveSupportKit/ASInflectorMethods.h>
#import <ActiveSupportKit/ASInflector.h>
#import <ActiveSupportKit/ASRFC3339.h>

// categories
#import <ActiveSupportKit/NSObject+ActiveSupport.h>
#import <ActiveSupportKit/NSArray+ActiveSupport.h>
#import <ActiveSupportKit/NSDictionary+ActiveSupport.h>
#import <ActiveSupportKit/NSRegularExpression+ActiveSupport.h>
#import <ActiveSupportKit/NSMutableString+ActiveSupport.h>

#import <ActiveSupportKit/Versioning.h>

/*!
 * @mainpage Active Support Kit
 *
 * Active Support Kit mimics Ruby on Rails <a
 * href="http://as.rubyonrails.org/">Active Support</a>. Rails' ActiveSupport
 * gem provides a collection of utility classes and standard library extensions
 * designed primarily albeit not exclusively for working with the Rails
 * application framework. Active Support Kit's goal is to provide functionally
 * compatible classes and helper functions.
 *
 * Translating interfaces and semantics from Ruby to Objective-C is not @em always
 * an easy task, even though most of the time it is. Although both languages
 * share some elements, e.g. dynamic typing, there remain significant
 * differences. Ruby has singleton classes, for instance, and Rails makes
 * extensive use of them. Objective-C has nothing equivalent.
 *
 * The kit provides a class and a set of helper methods in its first version, as
 * follows.
 *
 * @section as_inflector ASInflector
 *
 * Mirrors the Rails ActiveSupport::Inflector::Inflections class. Interface as
 * follows.
 *
 * 	- + (ASInflector *)defaultInflector
 * 	- - (void)addPluralRegularExpressionRule:(NSString *)rule options:(NSRegularExpressionOptions)options replacement:(NSString *)replacement
 * 	- - (void)addPluralStringRule:(NSString *)rule options:(NSStringCompareOptions)options replacement:(NSString *)replacement
 * 	- - (void)addSingularRegularExpressionRule:(NSString *)rule options:(NSRegularExpressionOptions)options replacement:(NSString *)replacement
 * 	- - (void)addSingularStringRule:(NSString *)rule options:(NSStringCompareOptions)options replacement:(NSString *)replacement
 * 	- - (void)addIrregularWithSingular:(NSString *)singular plural:(NSString *)plural
 * 	- - (void)addUncountable:(NSString *)uncountable
 * 	- - (void)addHumanRegularExpressionRule:(NSString *)rule options:(NSRegularExpressionOptions)options replacement:(NSString *)replacement
 * 	- - (void)addHumanStringRule:(NSString *)rule options:(NSStringCompareOptions)options replacement:(NSString *)replacement
 * 	- - (void)clear
 * 	- - (NSString *)pluralize:(NSString *)word
 * 	- - (NSString *)singularize:(NSString *)word
 * 	- - (NSString *)humanize:(NSString *)lowerCaseAndUnderscoredWord
 * 	- - (NSString *)titleize:(NSString *)word
 *
 * @section inflector_methods Inflector Methods
 *
 * 	- - NSString *ASInflectorCamelize(NSString *lowerCaseAndUnderscoredWord, BOOL firstLetterInUppercase)
 * 	- - NSString *ASInflectorUnderscore(NSString *camelCasedWord)
 * 	- - NSString *ASInflectorDasherize(NSString *underscoredWord)
 * 	- - NSString *ASInflectorDemodulize(NSString *classNameInModule)
 * 	- - NSString *ASInflectorOrdinalize(NSNumber *number)
 *
 * @section operating_systems Operating Systems
 *
 * The framework targets OS X 10.7 Lion and iOS 5.0. It depends on Foundation
 * framework's @c NSJSONSerialization, although you could easily adapt the
 * underlying requirement for JSON serialisation.
 *
 * @section iOS
 *
 * When building the library for iOS, remember to specify @c -all_load in
 * the Other Linker Flags (@c OTHER_LDFLAGS). You need this because the
 * library defines categories on standard NextStep foundation
 * classes. Without 'all load,' you will see run-time exceptions for
 * "selector not recognised." Linking against static libraries does not
 * automatically fix up run-time dependencies. See Apple's Technical Q&A
 * QA1490, Building Objective-C static libraries with categories, for
 * more details.
 */
