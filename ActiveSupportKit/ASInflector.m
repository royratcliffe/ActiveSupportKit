// ActiveSupportKit ASInflector.m
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

#import "ASInflector.h"
#import "ASInflectorMethods.h"
#import "ASReplacementStringForResults.h"
#import "ASNull.h"

@implementation ASInflector

+ (ASInflector *)defaultInflector
{
	static ASInflector *__strong inflector;
	if (inflector == nil)
	{
		inflector = [[ASInflector alloc] init];
		atexit_b(^(void) {
			inflector = nil;
		});
		// plurals
		{
			[inflector addPluralRegularExpressionRule:@"$" options:0 replacement:@"s"];
			struct
			{
				NSString *const __unsafe_unretained rule, *const __unsafe_unretained replacement;
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
				{ @"(?:([^f])fe|([lr])f)$", @"$1$2ves" },
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
				NSString *const __unsafe_unretained rule, *const __unsafe_unretained replacement;
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
				NSString *const __unsafe_unretained singular, *const __unsafe_unretained plural;
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
		acronyms = [NSMutableDictionary dictionary];
		acronymsRegularExpressionString = @"(?=a)b";
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

- (void)addHumanRegularExpressionRule:(NSString *)rule options:(NSRegularExpressionOptions)options replacement:(NSString *)replacement
{
	[humans insertObject:[NSArray arrayWithObjects:[NSRegularExpression regularExpressionWithPattern:rule options:options error:NULL], replacement, nil] atIndex:0];
}

- (void)addHumanStringRule:(NSString *)rule options:(NSStringCompareOptions)options replacement:(NSString *)replacement
{
	[humans insertObject:[NSArray arrayWithObjects:rule, replacement, [NSNumber numberWithUnsignedInteger:options], nil] atIndex:0];
}

- (void)addAcronym:(NSString *)acronym
{
	[acronyms setObject:acronym forKey:[acronym lowercaseString]];
	acronymsRegularExpressionString = [[acronyms allValues] componentsJoinedByString:@"|"];
}

- (void)clear
{
	[plurals removeAllObjects];
	[singulars removeAllObjects];
	[uncountables removeAllObjects];
	[humans removeAllObjects];
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

- (NSString *)camelize:(NSString *)term uppercaseFirstLetter:(BOOL)uppercaseFirstLetter
{
	NSString *string;
	if (uppercaseFirstLetter)
	{
		string = ASStringByReplacingMatchesInStringUsingBlock(@"^[a-z\\d]*", 0, term, ^NSString *(NSArray *results) {
			NSString *result0 = [results objectAtIndex:0], *acronym = [acronyms objectForKey:result0];
			return acronym ? acronym : [result0 capitalizedString];
		});
	}
	else
	{
		NSString *pattern = [NSString stringWithFormat:@"^(?:%@(?=\\b|[A-Z_])|\\w)", acronymsRegularExpressionString];
		string = ASStringByReplacingMatchesInStringUsingBlock(pattern, 0, term, ^NSString *(NSArray *results) {
			return [[results objectAtIndex:0] lowercaseString];
		});
	}
	return [ASStringByReplacingMatchesInStringUsingBlock(@"(?:_|(\\/))([a-z\\d]*)", NSRegularExpressionCaseInsensitive, string, ^NSString *(NSArray *results) {
		// Note that the first replacement string may not find a match. The
		// range, in that case, has location equal to NSNotFound. The ?: regular
		// expression operator marks non-capturing parentheses. The enclosing
		// parentheses group the pattern but does not capture the matching text;
		// an optimisation.
		NSString *result1 = ASNilForNull([results objectAtIndex:1]), *result2 = [results objectAtIndex:2], *acronym = [acronyms objectForKey:result2];
		return [result1 ? result1 : @"" stringByAppendingString:acronym ? acronym : [result2 capitalizedString]];
	}) stringByReplacingOccurrencesOfString:@"/" withString:@"::"];
}

- (NSString *)underscore:(NSString *)camelCasedWord
{
	NSMutableString *word = [camelCasedWord mutableCopy];
	[[NSRegularExpression regularExpressionWithPattern:@"::" options:0 error:NULL] replaceMatchesInString:word options:0 range:NSMakeRange(0, [word length]) withTemplate:@"/"];
	NSString *pattern = [NSString stringWithFormat:@"(?:([A-Za-z\\d])|^)(%@)(?=\\b|[^a-z])", acronymsRegularExpressionString];
	ASReplaceMatchesInStringUsingBlock(pattern, 0, word, ^NSString *(NSArray *results) {
		NSString *result1 = ASNilForNull([results objectAtIndex:1]), *result2 = [results objectAtIndex:2];
		return [NSString stringWithFormat:@"%@%@%@", result1 ? result1 : @"", result1 ? @"_" : @"", [result2 lowercaseString]];
	});
	[[NSRegularExpression regularExpressionWithPattern:@"([A-Z\\d]+)([A-Z][a-z])" options:0 error:NULL] replaceMatchesInString:word options:0 range:NSMakeRange(0, [word length]) withTemplate:@"$1_$2"];
	[[NSRegularExpression regularExpressionWithPattern:@"([a-z\\d])([A-Z])" options:0 error:NULL] replaceMatchesInString:word options:0 range:NSMakeRange(0, [word length]) withTemplate:@"$1_$2"];
	return [[[word copy] stringByReplacingOccurrencesOfString:@"-" withString:@"_"] lowercaseString];
}

- (NSString *)humanize:(NSString *)lowerCaseAndUnderscoredWord
{
	NSMutableString *result = [ASInflectorApplyRulesAndReplacements(humans, lowerCaseAndUnderscoredWord) mutableCopy];

	// Strip any trailing "_id" string. The method could implement this without
	// using regular expressions. Such might prove more efficient. Rails uses
	// regular expressions however and since this framework aims to mimic Rails,
	// use a regular expression too.
	[[NSRegularExpression regularExpressionWithPattern:@"_id$" options:0 error:NULL] replaceMatchesInString:result options:0 range:NSMakeRange(0, [result length]) withTemplate:@""];

	[result replaceOccurrencesOfString:@"_" withString:@" " options:0 range:NSMakeRange(0, [result length])];

	// Match sequences of letters and numbers case-insensitively. Does the match
	// correspond to an acronym? If it does, replace the acronym with its
	// case-sensitive equivalent. Note, some acronyms use both upper and lower
	// cases, e.g. RESTful. The acronyms dictionary keys contain acronyms in
	// lower case. The argument is a lower-case and underscored word.
	ASReplaceMatchesInStringUsingBlock(@"([a-z\\d]*)", NSRegularExpressionCaseInsensitive, result, ^NSString *(NSArray *results) {
		NSString *result0 = [results objectAtIndex:0], *acronym = [acronyms objectForKey:result0];
		return acronym ? acronym : [result0 lowercaseString];
	});

	return ASStringByReplacingMatchesInStringUsingBlock(@"^\\w", 0, result, ^NSString *(NSArray *results) {
		return [[results objectAtIndex:0] uppercaseString];
	});
}

- (NSString *)titleize:(NSString *)word
{
	return ASStringByReplacingMatchesInStringUsingBlock(@"\\b('?[a-z])", 0, [self humanize:[self underscore:word]], ^NSString *(NSArray *results) {
		return [[results objectAtIndex:1] capitalizedString];
	});
}

- (NSString *)demodularize:(NSString *)path
{
	NSRange range = [path rangeOfString:@"::" options:NSBackwardsSearch];
	return range.location != NSNotFound ? [path substringFromIndex:range.location + 2] : path;
}

- (NSString *)deconstantize:(NSString *)path
{
	NSRange range = [path rangeOfString:@"::" options:NSBackwardsSearch];
	return [path substringWithRange:NSMakeRange(0, range.location != NSNotFound ? range.location : 0)];
}

- (NSString *)foreignKey:(NSString *)className separateClassNameAndIDWithUnderscore:(BOOL)yesOrNo
{
	return [[self underscore:[self demodularize:className]] stringByAppendingString:yesOrNo ? @"_id" : @"id"];
}

@end
