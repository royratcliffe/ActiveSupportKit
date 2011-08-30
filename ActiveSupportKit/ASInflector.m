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

@implementation ASInflector

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
	if ([[s_1 uppercaseString] isEqualToString:[p_1 uppercaseString]])
	{
		NSString *s1_ = [singular substringFromIndex:1];
		NSString *p1_ = [plural substringFromIndex:1];
		[self addPluralRegularExpressionRule:[NSString stringWithFormat:@"(%@)%@$", s_1, s1_] options:NSRegularExpressionCaseInsensitive replacement:[@"$1" stringByAppendingString:p1_]];
		[self addPluralRegularExpressionRule:[NSString stringWithFormat:@"(%@)%@$", p_1, p1_] options:NSRegularExpressionCaseInsensitive replacement:[@"$1" stringByAppendingString:p1_]];
		[self addSingularRegularExpressionRule:[NSString stringWithFormat:@"(%@)%@$", p_1, p1_] options:NSRegularExpressionCaseInsensitive replacement:[@"$1" stringByAppendingString:s1_]];
	}
	else
	{
		
	}
}

- (NSString *)pluralize:(NSString *)word
{
	NSMutableString *result = [[word mutableCopy] autorelease];
	if ([word length] == 0 || [uncountables containsObject:[word lowercaseString]])
	{
		
	}
	else
	{
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
		for (NSArray *ruleAndReplacement in plurals)
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
	}
	return [[result copy] autorelease];
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
