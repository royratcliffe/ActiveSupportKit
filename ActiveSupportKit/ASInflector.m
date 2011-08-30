// ActiveSupportKit ASInflector.m
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

#import "ASInflector.h"

NSString *ASInflectorApplyRulesAndReplacements(NSArray *rulesAndReplacements, NSString *word);

@implementation ASInflector

+ (ASInflector *)defaultInflector
{
	static ASInflector *inflector;
	if (inflector == nil)
	{
		inflector = [[ASInflector alloc] init];
		atexit_b(^(void) {
			NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
			[inflector release];
			[pool drain];
		});
		// plurals
		{
			[inflector addPluralRegularExpressionRule:@"$" options:0 replacement:@"s"];
			struct
			{
				NSString *const rule, *const replacement;
			}
			plurals[] =
			{
				{ @"s$", @"s" },
				{ @"(ax|test)is$", @"$1es" },
				{ @"(octop|vir)us$", @"$1i" },
				{ @"(octop|vir)i$", @"$1i" },
				{ @"(alias|status)$", @"$1es" },
				{ @"(bu)s$", @"$1ses" },
				{ @"(buffal|tomat)o$", @"$1oes" },
				{ @"([ti])um$", @"$1a" },
				{ @"([ti])a$", @"$1a" },
				{ @"sis$", @"ses" },
				{ @"(?:([^f])fe|([lr])f)$", @"$1\2ves" },
				{ @"(hive)$", @"$1s" },
				{ @"([^aeiouy]|qu)y$", @"$1ies" },
				{ @"(x|ch|ss|sh)$", @"$1es" },
				{ @"(matr|vert|ind)(?:ix|ex)$", @"$1ices" },
				{ @"([m|l])ouse$", @"$1ice" },
				{ @"([m|l])ice$", @"$1ice" },
				{ @"^(ox)$", @"$1en" },
				{ @"^(oxen)$", @"$1" },
				{ @"(quiz)$", @"$1zes" },
			};
			for (NSUInteger i = 0; i < sizeof(plurals)/sizeof(plurals[0]); i++)
			{
				[inflector addPluralRegularExpressionRule:plurals[i].rule options:NSRegularExpressionCaseInsensitive replacement:plurals[i].replacement];
			}
		}
		// singulars
		{
			struct
			{
				NSString *const rule, *const replacement;
			}
			singulars[] =
			{
				{ @"s$", @"" },
				{ @"(n)ews$", @"$1ews" },
				{ @"([ti])a$", @"$1um" },
				{ @"((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$", @"$1$2sis" },
				{ @"(^analy)ses$", @"$1sis" },
				{ @"([^f])ves$", @"$1fe" },
				{ @"(hive)s$", @"$1" },
				{ @"(tive)s$", @"$1" },
				{ @"([lr])ves$", @"$1f" },
				{ @"([^aeiouy]|qu)ies$", @"$1y" },
				{ @"(s)eries$", @"$1eries" },
				{ @"(m)ovies$", @"$1ovie" },
				{ @"(x|ch|ss|sh)es$", @"$1" },
				{ @"([m|l])ice$", @"$1ouse" },
				{ @"(bus)es$", @"$1" },
				{ @"(o)es$", @"$1" },
				{ @"(shoe)s$", @"$1" },
				{ @"(cris|ax|test)es$", @"$1is" },
				{ @"(octop|vir)i$", @"$1us" },
				{ @"(alias|status)es$", @"$1" },
				{ @"^(ox)en", @"$1" },
				{ @"(vert|ind)ices$", @"$1ex" },
				{ @"(matr)ices$", @"$1ix" },
				{ @"(quiz)zes$", @"$1" },
				{ @"(database)s$", @"$1" },
			};
			for (NSUInteger i = 0; i < sizeof(singulars)/sizeof(singulars[0]); i++)
			{
				[inflector addSingularRegularExpressionRule:singulars[i].rule options:NSRegularExpressionCaseInsensitive replacement:singulars[i].replacement];
			}
		}
		// irregulars
		{
			struct
			{
				NSString *const plural, *const singular;
			}
			irregulars[] =
			{
				{ @"person", @"people" },
				{ @"man", @"men" },
				{ @"child", @"children" },
				{ @"sex", @"sexes" },
				{ @"move", @"moves" },
				{ @"cow", @"kine" },
			};
			for (NSUInteger i = 0; i < sizeof(irregulars)/sizeof(irregulars[0]); i++)
			{
				[inflector addIrregularWithSingular:irregulars[i].singular plural:irregulars[i].plural];
			}
		}
		// uncountables
		{
			NSString *const uncountables[] =
			{
				@"equipment",
				@"information",
				@"rice",
				@"money",
				@"species",
				@"series",
				@"fish",
				@"sheep",
				@"jeans",
			};
			for (NSUInteger i = 0; i < sizeof(uncountables)/sizeof(uncountables[0]); i++)
			{
				[inflector addUncountable:uncountables[i]];
			}
		}
	}
	return inflector;
}

- (id)init
{
	self = [super init];
	if (self)
	{
		plurals = [[NSMutableArray alloc] init];
		singulars = [[NSMutableArray alloc] init];
		uncountables = [[NSMutableArray alloc] init];
		humans = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)addPluralRegularExpressionRule:(NSString *)rule options:(NSRegularExpressionOptions)options replacement:(NSString *)replacement
{
	[uncountables removeObject:replacement];
	[plurals insertObject:[NSArray arrayWithObjects:[NSRegularExpression regularExpressionWithPattern:rule options:options error:NULL], replacement, nil] atIndex:0];
}

- (void)addPluralStringRule:(NSString *)rule options:(NSStringCompareOptions)options replacement:(NSString *)replacement
{
	[uncountables removeObject:rule];
	[uncountables removeObject:replacement];
	[plurals insertObject:[NSArray arrayWithObjects:rule, replacement, [NSNumber numberWithUnsignedInteger:options], nil] atIndex:0];
}

- (void)addSingularRegularExpressionRule:(NSString *)rule options:(NSRegularExpressionOptions)options replacement:(NSString *)replacement
{
	[uncountables removeObject:replacement];
	[singulars insertObject:[NSArray arrayWithObjects:[NSRegularExpression regularExpressionWithPattern:rule options:options error:NULL], replacement, nil] atIndex:0];
}

- (void)addSingularStringRule:(NSString *)rule options:(NSStringCompareOptions)options replacement:(NSString *)replacement
{
	[uncountables removeObject:rule];
	[uncountables removeObject:replacement];
	[singulars insertObject:[NSArray arrayWithObjects:rule, replacement, [NSNumber numberWithUnsignedInteger:options], nil] atIndex:0];
}

- (void)addIrregularWithSingular:(NSString *)singular plural:(NSString *)plural
{
	[uncountables removeObject:singular];
	[uncountables removeObject:plural];
	// Assume that the singular and plural string arguments are not empty. Both
	// must have lengths equal to or greater than one.
	NSString *s_1 = [singular substringToIndex:1];
	NSString *p_1 = [plural substringToIndex:1];
	NSString *s1_ = [singular substringFromIndex:1];
	NSString *p1_ = [plural substringFromIndex:1];
	if ([[s_1 uppercaseString] isEqualToString:[p_1 uppercaseString]])
	{
		[self addPluralRegularExpressionRule:[NSString stringWithFormat:@"(%@)%@$", s_1, s1_] options:NSRegularExpressionCaseInsensitive replacement:[@"$1" stringByAppendingString:p1_]];
		[self addPluralRegularExpressionRule:[NSString stringWithFormat:@"(%@)%@$", p_1, p1_] options:NSRegularExpressionCaseInsensitive replacement:[@"$1" stringByAppendingString:p1_]];
		[self addSingularRegularExpressionRule:[NSString stringWithFormat:@"(%@)%@$", p_1, p1_] options:NSRegularExpressionCaseInsensitive replacement:[@"$1" stringByAppendingString:s1_]];
	}
	else
	{
		[self addPluralRegularExpressionRule:[NSString stringWithFormat:@"%@(?i)%@$", [s_1 uppercaseString], s1_] options:NSRegularExpressionCaseInsensitive replacement:[[p_1 uppercaseString] stringByAppendingString:p1_]];
		[self addPluralRegularExpressionRule:[NSString stringWithFormat:@"%@(?i)%@$", [s_1 lowercaseString], s1_] options:NSRegularExpressionCaseInsensitive replacement:[[p_1 lowercaseString] stringByAppendingString:p1_]];
		[self addPluralRegularExpressionRule:[NSString stringWithFormat:@"%@(?i)%@$", [p_1 uppercaseString], p1_] options:NSRegularExpressionCaseInsensitive replacement:[[p_1 uppercaseString] stringByAppendingString:p1_]];
		[self addPluralRegularExpressionRule:[NSString stringWithFormat:@"%@(?i)%@$", [p_1 lowercaseString], p1_] options:NSRegularExpressionCaseInsensitive replacement:[[p_1 lowercaseString] stringByAppendingString:p1_]];
		[self addSingularRegularExpressionRule:[NSString stringWithFormat:@"%@(?i)%@$", [p_1 uppercaseString], p1_] options:NSRegularExpressionCaseInsensitive replacement:[[s_1 uppercaseString] stringByAppendingString:s1_]];
		[self addSingularRegularExpressionRule:[NSString stringWithFormat:@"%@(?i)%@$", [p_1 lowercaseString], p1_] options:NSRegularExpressionCaseInsensitive replacement:[[s_1 lowercaseString] stringByAppendingString:s1_]];
	}
}

- (void)addUncountable:(NSString *)uncountable
{
	[uncountables addObject:uncountable];
}

- (NSString *)pluralize:(NSString *)word
{
	if ([word length] == 0 || [uncountables containsObject:[word lowercaseString]])
	{
		return word;
	}
	return ASInflectorApplyRulesAndReplacements(plurals, word);
}

- (NSString *)singularize:(NSString *)word
{
	for (NSString *uncountable in uncountables)
	{
		if ([[[NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"\\b(%@)\\Z", uncountable] options:NSRegularExpressionCaseInsensitive error:NULL] matchesInString:word options:0 range:NSMakeRange(0, [word length])] count])
		{
			return word;
		}
	}
	return ASInflectorApplyRulesAndReplacements(singulars, word);
}

- (void)dealloc
{
	[plurals release];
	[singulars release];
	[uncountables release];
	[humans release];
	[super dealloc];
}

@end

NSString *ASInflectorApplyRulesAndReplacements(NSArray *rulesAndReplacements, NSString *word)
{
	NSMutableString *result = [[word mutableCopy] autorelease];
	// Plurals is an array of arrays. The elements have two or three
	// sub-elements. If two elements, the first specifies a regular
	// expression and the second its replacement template. If three
	// elements, the first specifies a string target, the second its
	// replacement and the third its string compare options.
	//
	// Why is this necessary? Simply because Objective-C has no polymorphic
	// “gsub” method which accepts either a regular expression or
	// string. Nor can string-based search and replacements incorporate any
	// flags; comparison options amount to extra baggage. Hence the array of
	// plurals polymorphically carries different kinds of rules and their
	// replacements. The number of elements, the array count, determines
	// behaviour.
	for (NSArray *ruleAndReplacement in rulesAndReplacements)
	{
		if ([ruleAndReplacement count] == 2)
		{
			NSRegularExpression *re = [ruleAndReplacement objectAtIndex:0];
			NSString *replacement = [ruleAndReplacement objectAtIndex:1];
			if ([re replaceMatchesInString:result options:0 range:NSMakeRange(0, [result length]) withTemplate:replacement])
			{
				break;
			}
		}
		else if ([ruleAndReplacement count] == 3)
		{
			NSString *target = [ruleAndReplacement objectAtIndex:0];
			NSString *replacement = [ruleAndReplacement objectAtIndex:1];
			NSUInteger options = [[ruleAndReplacement objectAtIndex:2] unsignedIntegerValue];
			if ([result replaceOccurrencesOfString:target withString:replacement options:options range:NSMakeRange(0, [result length])])
			{
				break;
			}
		}
	}
	return [[result copy] autorelease];
}
