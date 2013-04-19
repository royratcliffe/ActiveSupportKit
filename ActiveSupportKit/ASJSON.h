// ActiveSupportKit ASJSON.h
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

// data
id ASJSONDecodeFromData(NSData *data, NSError **outError);
NSData *ASJSONEncodeToData(id object, NSError **outError);

// string
id ASJSONDecodeFromString(NSString *string, NSError **outError);
NSString *ASJSONEncodeToString(id object, NSError **outError);

/**
 * @result YES if the JSON object contains at least one circular reference; NO
 * if it contains no circular references.
 */
BOOL ASCheckJSONObjectForCircularReferences(id object);

/**
 * Walks a JSON object and also checks the given JSON object for circular
 * references, failing if circular.
 * @param object The JSON object to walk, where objects have one of three types:
 * array, dictionary or primitive. Primitives include strings, numbers and
 * date-times. The root JSON object can be any one of these three, as can array
 * elements and dictionary objects. Dictionary keys can be strings only.
 * @result Answers an array of unique objects extracted by walking the JSON @a
 * object. The array contains all primitives, all arrays and their elements, and
 * all dictionaries and their values. The array does @em not contain dictionary
 * keys. You can extract dictionary keys from the result by picking out the
 * dictionaries. Answers `nil` if the JSON object contains circular references.
 *
 * Walks the JSON object, adding each object to the resulting array
 * one-by-one unless it encounters an object already seen. Checking for circular
 * references uses the <code>-[NSArray firstObjectCommonWithArray:]</code>
 * method. If using an array is not efficient, the implementation could improve
 * by using a set rather than an array. As a disadvantage in that case, the
 * ordering would become undefined. Dictionaries already make their ordering
 * undefined.
 */
NSArray *ASAllObjectsInJSONObject(id object);
