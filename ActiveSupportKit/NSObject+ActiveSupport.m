// ActiveSupportKit NSObject+ActiveSupport.m
//
// Copyright © 2011–2013, Roy Ratcliffe, Pioneering Software, United Kingdom
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS," WITHOUT WARRANTY OF ANY KIND, EITHER
// EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//
//------------------------------------------------------------------------------

#import "NSObject+ActiveSupport.h"

@implementation NSObject(ActiveSupport)

- (NSString *)toParam
{
	// Cocoa (or Cocoa Touch) makes this easy to implement. This implementation
	// works on strings, numbers, all primitive types. Asking for the
	// “description” answers some kind of string representation of the object.
	return [self description];
}

- (NSString *)toQueryWithKey:(NSString *)key
{
	return [NSString stringWithFormat:@"%@=%@", [[key description] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[self toParam] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

@end
