# Active Support Kit

[![Build Status](https://travis-ci.org/royratcliffe/ActiveSupportKit.png?branch=master)](https://travis-ci.org/royratcliffe/ActiveSupportKit)

Active Support Kit mimics Ruby on Rails [Active Support][as]. Rails'
ActiveSupport gem provides a collection of utility classes and standard library
extensions designed primarily albeit not exclusively for working with the Rails
application framework. Active Support Kit's goal is to provide functionally
compatible classes and helper functions.

Translating interfaces and semantics from Ruby to Objective-C is not _always_ an
easy task, even though most of the time it is. Although both languages share
some elements, e.g. dynamic typing, there remain significant differences. Ruby
has singleton classes, for instance, and Rails makes extensive use of them.
Objective-C has nothing equivalent.

[as]:http://api.rubyonrails.org/

The kit provides a class and a set of helper methods in its first version, as
follows. You can find more detailed documentation
[here](http://royratcliffe.github.com/ActiveSupportKit/).

## ASInflector

Mirrors the Rails ActiveSupport::Inflector::Inflections class. Interface as follows.

	+ (ASInflector *)defaultInflector
	- (void)addPluralRegularExpressionRule:(NSString *)rule options:(NSRegularExpressionOptions)options replacement:(NSString *)replacement
	- (void)addPluralStringRule:(NSString *)rule options:(NSStringCompareOptions)options replacement:(NSString *)replacement
	- (void)addSingularRegularExpressionRule:(NSString *)rule options:(NSRegularExpressionOptions)options replacement:(NSString *)replacement
	- (void)addSingularStringRule:(NSString *)rule options:(NSStringCompareOptions)options replacement:(NSString *)replacement
	- (void)addIrregularWithSingular:(NSString *)singular plural:(NSString *)plural
	- (void)addUncountable:(NSString *)uncountable
	- (void)addHumanRegularExpressionRule:(NSString *)rule options:(NSRegularExpressionOptions)options replacement:(NSString *)replacement
	- (void)addHumanStringRule:(NSString *)rule options:(NSStringCompareOptions)options replacement:(NSString *)replacement
	- (void)clear
	- (NSString *)pluralize:(NSString *)word
	- (NSString *)singularize:(NSString *)word
	- (NSString *)humanize:(NSString *)lowerCaseAndUnderscoredWord
	- (NSString *)titleize:(NSString *)word

## Inflector Methods

	NSString *ASInflectorCamelize(NSString *lowerCaseAndUnderscoredWord, BOOL firstLetterInUppercase)
	NSString *ASInflectorUnderscore(NSString *camelCasedWord)
	NSString *ASInflectorDasherize(NSString *underscoredWord)
	NSString *ASInflectorDemodulize(NSString *classNameInModule)
	NSString *ASInflectorOrdinalize(NSNumber *number)

## Operating Systems

The framework targets the latest versions of OS X and iOS, and depends on Foundation
framework's `NSJSONSerialization`, although you could easily adapt the
underlying requirement for JSON serialisation. Earlier versions depended on
[YAJL and some Objective-C wrappers](https://github.com/royratcliffe/yajl/tree/master/objc).

### iOS

When building the library for iOS, remember to specify `-all_load` in
the Other Linker Flags (`OTHER_LDFLAGS`). You need this because the
library defines categories on standard NextStep foundation
classes. Without 'all load,' you will see run-time exceptions for
"selector not recognised." Linking against static libraries does not
automatically fix up run-time dependencies. See Apple's Technical Q&A
QA1490, Building Objective-C static libraries with categories, for
more details.
