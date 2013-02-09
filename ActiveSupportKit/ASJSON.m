// ActiveSupportKit ASJSON.m
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

#import "ASJSON.h"

id ASJSONDecodeFromData(NSData *data, NSError **outError)
{
	return [NSJSONSerialization JSONObjectWithData:data options:0 error:outError];
}

NSData *ASJSONEncodeToData(id object, NSError **outError)
{
	return [NSJSONSerialization dataWithJSONObject:object options:0 error:outError];
}

id ASJSONDecodeFromString(NSString *string, NSError **outError)
{
	return ASJSONDecodeFromData([string dataUsingEncoding:NSUTF8StringEncoding], outError);
}

NSString *ASJSONEncodeToString(id object, NSError **outError)
{
	NSData *data = ASJSONEncodeToData(object, outError);
	return data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : nil;
}

BOOL ASCheckJSONObjectForCircularReferences(id object)
{
	return ASAllObjectsInJSONObject(object) != nil;
}

NSArray *ASAllObjectsInJSONObject(id object)
{
	// Importantly, do not use an enumerator to iterate the array elements. The
	// iterator will modify the array; the count of objects increases at
	// iterations where the object is a non-empty array or dictionary. The array
	// has a two-fold function. First, to unwrap the arrays and
	// dictionaries. Second, to collect the array and dictionary contents for
	// checking; JSON objects should never contain circular references.
	NSMutableArray *objects = [NSMutableArray arrayWithObject:object];
	for (NSUInteger index = 0; index < [objects count]; index++)
	{
		id object = [objects objectAtIndex:index];
		if ([object isKindOfClass:[NSArray class]])
		{
			if ([objects firstObjectCommonWithArray:(NSArray *)object])
			{
				return nil;
			}
			[objects addObjectsFromArray:(NSArray *)object];
		}
		else if ([object isKindOfClass:[NSDictionary class]])
		{
			NSArray *values = [(NSDictionary *)object allValues];
			if ([objects firstObjectCommonWithArray:values])
			{
				return nil;
			}
			[objects addObjectsFromArray:values];
		}
	}
	return [objects copy];
}
