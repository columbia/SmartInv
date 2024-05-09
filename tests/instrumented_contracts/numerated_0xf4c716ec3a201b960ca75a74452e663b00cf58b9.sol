1 // <ORACLIZE_API>
2 /*
3 Copyright (c) 2015-2016 Oraclize SRL
4 Copyright (c) 2016 Oraclize LTD
5 
6 
7 
8 Permission is hereby granted, free of charge, to any person obtaining a copy
9 of this software and associated documentation files (the "Software"), to deal
10 in the Software without restriction, including without limitation the rights
11 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
12 copies of the Software, and to permit persons to whom the Software is
13 furnished to do so, subject to the following conditions:
14 
15 
16 
17 The above copyright notice and this permission notice shall be included in
18 all copies or substantial portions of the Software.
19 
20 
21 
22 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
23 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
24 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
25 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
26 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
27 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
28 THE SOFTWARE.
29 */
30 
31 pragma solidity ^0.4.16;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
32 
33 contract OraclizeI {
34     address public cbAddress;
35     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
36     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
37     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
38     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
39     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
40     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
41     function getPrice(string _datasource) returns (uint _dsprice);
42     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
43     function useCoupon(string _coupon);
44     function setProofType(byte _proofType);
45     function setConfig(bytes32 _config);
46     function setCustomGasPrice(uint _gasPrice);
47     function randomDS_getSessionPubKeyHash() returns(bytes32);
48 }
49 contract OraclizeAddrResolverI {
50     function getAddress() returns (address _addr);
51 }
52 contract usingOraclize {
53     OraclizeAddrResolverI OAR;
54 
55     OraclizeI oraclize;
56     modifier oraclizeAPI {
57         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork();
58         oraclize = OraclizeI(OAR.getAddress());
59         _;
60     }
61 
62     function oraclize_setNetwork() internal returns(bool){
63         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
64             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
65             return true;
66         }
67         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
68             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
69             return true;
70         }
71         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
72             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
73             return true;
74         }
75         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
76             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
77             return true;
78         }
79         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
80             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
81             return true;
82         }
83         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
84             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
85             return true;
86         }
87         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
88             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
89             return true;
90         }
91         return false;
92     }
93 
94     function __callback(bytes32 myid, string result) {
95         __callback(myid, result, new bytes(0));
96     }
97 
98     function __callback(bytes32 myid, string result, bytes proof);
99 
100     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
101         return oraclize.getPrice(datasource);
102     }
103 
104     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
105         return oraclize.getPrice(datasource, gaslimit);
106     }
107 
108     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
109         uint price = oraclize.getPrice(datasource);
110         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
111         return oraclize.query.value(price)(0, datasource, arg);
112     }
113     function oraclize_cbAddress() oraclizeAPI internal returns (address){
114         return oraclize.cbAddress();
115     }
116     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
117         return oraclize.setCustomGasPrice(gasPrice);
118     }
119     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
120         return oraclize.setConfig(config);
121     }
122 
123     function getCodeSize(address _addr) constant internal returns(uint _size) {
124         assembly {
125             _size := extcodesize(_addr)
126         }
127     }
128 
129     // parseInt
130     function parseInt(string _a) internal returns (uint) {
131         return parseInt(_a, 0);
132     }
133 
134     // parseInt(parseFloat*10^_b)
135     function parseInt(string _a, uint _b) internal returns (uint) {
136         bytes memory bresult = bytes(_a);
137         uint mint = 0;
138         bool decimals = false;
139         for (uint i=0; i<bresult.length; i++){
140             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
141                 if (decimals){
142                    if (_b == 0) break;
143                     else _b--;
144                 }
145                 mint *= 10;
146                 mint += uint(bresult[i]) - 48;
147             } else if (bresult[i] == 46) decimals = true;
148         }
149         if (_b > 0) mint *= 10**_b;
150         return mint;
151     }
152 
153     function uint2str(uint i) internal returns (string){
154         if (i == 0) return "0";
155         uint j = i;
156         uint len;
157         while (j != 0){
158             len++;
159             j /= 10;
160         }
161         bytes memory bstr = new bytes(len);
162         uint k = len - 1;
163         while (i != 0){
164             bstr[k--] = byte(48 + i % 10);
165             i /= 10;
166         }
167         return string(bstr);
168     }
169 }
170 // </ORACLIZE_API>
171 
172 /*
173  * @title String & slice utility library for Solidity contracts.
174  * @author Nick Johnson <arachnid@notdot.net>
175  *
176  * @dev Functionality in this library is largely implemented using an
177  *      abstraction called a 'slice'. A slice represents a part of a string -
178  *      anything from the entire string to a single character, or even no
179  *      characters at all (a 0-length slice). Since a slice only has to specify
180  *      an offset and a length, copying and manipulating slices is a lot less
181  *      expensive than copying and manipulating the strings they reference.
182  *
183  *      To further reduce gas costs, most functions on slice that need to return
184  *      a slice modify the original one instead of allocating a new one; for
185  *      instance, `s.split(".")` will return the text up to the first '.',
186  *      modifying s to only contain the remainder of the string after the '.'.
187  *      In situations where you do not want to modify the original slice, you
188  *      can make a copy first with `.copy()`, for example:
189  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
190  *      Solidity has no memory management, it will result in allocating many
191  *      short-lived slices that are later discarded.
192  *
193  *      Functions that return two slices come in two versions: a non-allocating
194  *      version that takes the second slice as an argument, modifying it in
195  *      place, and an allocating version that allocates and returns the second
196  *      slice; see `nextRune` for example.
197  *
198  *      Functions that have to copy string data will return strings rather than
199  *      slices; these can be cast back to slices for further processing if
200  *      required.
201  *
202  *      For convenience, some functions are provided with non-modifying
203  *      variants that create a new slice and return both; for instance,
204  *      `s.splitNew('.')` leaves s unmodified, and returns two values
205  *      corresponding to the left and right parts of the string.
206  */
207 pragma solidity ^0.4.16;
208 
209 library strings {
210     struct slice {
211         uint _len;
212         uint _ptr;
213     }
214 
215     function memcpy(uint dest, uint src, uint len) private {
216         // Copy word-length chunks while possible
217         for(; len >= 32; len -= 32) {
218             assembly {
219                 mstore(dest, mload(src))
220             }
221             dest += 32;
222             src += 32;
223         }
224 
225         // Copy remaining bytes
226         uint mask = 256 ** (32 - len) - 1;
227         assembly {
228             let srcpart := and(mload(src), not(mask))
229             let destpart := and(mload(dest), mask)
230             mstore(dest, or(destpart, srcpart))
231         }
232     }
233 
234     /*
235      * @dev Returns a slice containing the entire string.
236      * @param self The string to make a slice from.
237      * @return A newly allocated slice containing the entire string.
238      */
239     function toSlice(string self) internal returns (slice) {
240         uint ptr;
241         assembly {
242             ptr := add(self, 0x20)
243         }
244         return slice(bytes(self).length, ptr);
245     }
246 
247     /*
248      * @dev Returns the length of a null-terminated bytes32 string.
249      * @param self The value to find the length of.
250      * @return The length of the string, from 0 to 32.
251      */
252     function len(bytes32 self) internal returns (uint) {
253         uint ret;
254         if (self == 0)
255             return 0;
256         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
257             ret += 16;
258             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
259         }
260         if (self & 0xffffffffffffffff == 0) {
261             ret += 8;
262             self = bytes32(uint(self) / 0x10000000000000000);
263         }
264         if (self & 0xffffffff == 0) {
265             ret += 4;
266             self = bytes32(uint(self) / 0x100000000);
267         }
268         if (self & 0xffff == 0) {
269             ret += 2;
270             self = bytes32(uint(self) / 0x10000);
271         }
272         if (self & 0xff == 0) {
273             ret += 1;
274         }
275         return 32 - ret;
276     }
277 
278     /*
279      * @dev Returns a slice containing the entire bytes32, interpreted as a
280      *      null-termintaed utf-8 string.
281      * @param self The bytes32 value to convert to a slice.
282      * @return A new slice containing the value of the input argument up to the
283      *         first null.
284      */
285     function toSliceB32(bytes32 self) internal returns (slice ret) {
286         // Allocate space for `self` in memory, copy it there, and point ret at it
287         assembly {
288             let ptr := mload(0x40)
289             mstore(0x40, add(ptr, 0x20))
290             mstore(ptr, self)
291             mstore(add(ret, 0x20), ptr)
292         }
293         ret._len = len(self);
294     }
295 
296     /*
297      * @dev Returns a new slice containing the same data as the current slice.
298      * @param self The slice to copy.
299      * @return A new slice containing the same data as `self`.
300      */
301     function copy(slice self) internal returns (slice) {
302         return slice(self._len, self._ptr);
303     }
304 
305     /*
306      * @dev Copies a slice to a new string.
307      * @param self The slice to copy.
308      * @return A newly allocated string containing the slice's text.
309      */
310     function toString(slice self) internal returns (string) {
311         var ret = new string(self._len);
312         uint retptr;
313         assembly { retptr := add(ret, 32) }
314 
315         memcpy(retptr, self._ptr, self._len);
316         return ret;
317     }
318 
319     /*
320      * @dev Returns the length in runes of the slice. Note that this operation
321      *      takes time proportional to the length of the slice; avoid using it
322      *      in loops, and call `slice.empty()` if you only need to know whether
323      *      the slice is empty or not.
324      * @param self The slice to operate on.
325      * @return The length of the slice in runes.
326      */
327     function len(slice self) internal returns (uint) {
328         // Starting at ptr-31 means the LSB will be the byte we care about
329         var ptr = self._ptr - 31;
330         var end = ptr + self._len;
331         for (uint len = 0; ptr < end; len++) {
332             uint8 b;
333             assembly { b := and(mload(ptr), 0xFF) }
334             if (b < 0x80) {
335                 ptr += 1;
336             } else if(b < 0xE0) {
337                 ptr += 2;
338             } else if(b < 0xF0) {
339                 ptr += 3;
340             } else if(b < 0xF8) {
341                 ptr += 4;
342             } else if(b < 0xFC) {
343                 ptr += 5;
344             } else {
345                 ptr += 6;
346             }
347         }
348         return len;
349     }
350 
351     /*
352      * @dev Returns true if the slice is empty (has a length of 0).
353      * @param self The slice to operate on.
354      * @return True if the slice is empty, False otherwise.
355      */
356     function empty(slice self) internal returns (bool) {
357         return self._len == 0;
358     }
359 
360     /*
361      * @dev Returns a positive number if `other` comes lexicographically after
362      *      `self`, a negative number if it comes before, or zero if the
363      *      contents of the two slices are equal. Comparison is done per-rune,
364      *      on unicode codepoints.
365      * @param self The first slice to compare.
366      * @param other The second slice to compare.
367      * @return The result of the comparison.
368      */
369     function compare(slice self, slice other) internal returns (int) {
370         uint shortest = self._len;
371         if (other._len < self._len)
372             shortest = other._len;
373 
374         var selfptr = self._ptr;
375         var otherptr = other._ptr;
376         for (uint idx = 0; idx < shortest; idx += 32) {
377             uint a;
378             uint b;
379             assembly {
380                 a := mload(selfptr)
381                 b := mload(otherptr)
382             }
383             if (a != b) {
384                 // Mask out irrelevant bytes and check again
385                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
386                 var diff = (a & mask) - (b & mask);
387                 if (diff != 0)
388                     return int(diff);
389             }
390             selfptr += 32;
391             otherptr += 32;
392         }
393         return int(self._len) - int(other._len);
394     }
395 
396     /*
397      * @dev Returns true if the two slices contain the same text.
398      * @param self The first slice to compare.
399      * @param self The second slice to compare.
400      * @return True if the slices are equal, false otherwise.
401      */
402     function equals(slice self, slice other) internal returns (bool) {
403         return compare(self, other) == 0;
404     }
405 
406     /*
407      * @dev Extracts the first rune in the slice into `rune`, advancing the
408      *      slice to point to the next rune and returning `self`.
409      * @param self The slice to operate on.
410      * @param rune The slice that will contain the first rune.
411      * @return `rune`.
412      */
413     function nextRune(slice self, slice rune) internal returns (slice) {
414         rune._ptr = self._ptr;
415 
416         if (self._len == 0) {
417             rune._len = 0;
418             return rune;
419         }
420 
421         uint len;
422         uint b;
423         // Load the first byte of the rune into the LSBs of b
424         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
425         if (b < 0x80) {
426             len = 1;
427         } else if(b < 0xE0) {
428             len = 2;
429         } else if(b < 0xF0) {
430             len = 3;
431         } else {
432             len = 4;
433         }
434 
435         // Check for truncated codepoints
436         if (len > self._len) {
437             rune._len = self._len;
438             self._ptr += self._len;
439             self._len = 0;
440             return rune;
441         }
442 
443         self._ptr += len;
444         self._len -= len;
445         rune._len = len;
446         return rune;
447     }
448 
449     /*
450      * @dev Returns the first rune in the slice, advancing the slice to point
451      *      to the next rune.
452      * @param self The slice to operate on.
453      * @return A slice containing only the first rune from `self`.
454      */
455     function nextRune(slice self) internal returns (slice ret) {
456         nextRune(self, ret);
457     }
458 
459     /*
460      * @dev Returns the number of the first codepoint in the slice.
461      * @param self The slice to operate on.
462      * @return The number of the first codepoint in the slice.
463      */
464     function ord(slice self) internal returns (uint ret) {
465         if (self._len == 0) {
466             return 0;
467         }
468 
469         uint word;
470         uint len;
471         uint div = 2 ** 248;
472 
473         // Load the rune into the MSBs of b
474         assembly { word:= mload(mload(add(self, 32))) }
475         var b = word / div;
476         if (b < 0x80) {
477             ret = b;
478             len = 1;
479         } else if(b < 0xE0) {
480             ret = b & 0x1F;
481             len = 2;
482         } else if(b < 0xF0) {
483             ret = b & 0x0F;
484             len = 3;
485         } else {
486             ret = b & 0x07;
487             len = 4;
488         }
489 
490         // Check for truncated codepoints
491         if (len > self._len) {
492             return 0;
493         }
494 
495         for (uint i = 1; i < len; i++) {
496             div = div / 256;
497             b = (word / div) & 0xFF;
498             if (b & 0xC0 != 0x80) {
499                 // Invalid UTF-8 sequence
500                 return 0;
501             }
502             ret = (ret * 64) | (b & 0x3F);
503         }
504 
505         return ret;
506     }
507 
508     /*
509      * @dev Returns the keccak-256 hash of the slice.
510      * @param self The slice to hash.
511      * @return The hash of the slice.
512      */
513     function keccak(slice self) internal returns (bytes32 ret) {
514         assembly {
515             ret := sha3(mload(add(self, 32)), mload(self))
516         }
517     }
518 
519     /*
520      * @dev Returns true if `self` starts with `needle`.
521      * @param self The slice to operate on.
522      * @param needle The slice to search for.
523      * @return True if the slice starts with the provided text, false otherwise.
524      */
525     function startsWith(slice self, slice needle) internal returns (bool) {
526         if (self._len < needle._len) {
527             return false;
528         }
529 
530         if (self._ptr == needle._ptr) {
531             return true;
532         }
533 
534         bool equal;
535         assembly {
536             let len := mload(needle)
537             let selfptr := mload(add(self, 0x20))
538             let needleptr := mload(add(needle, 0x20))
539             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
540         }
541         return equal;
542     }
543 
544     /*
545      * @dev If `self` starts with `needle`, `needle` is removed from the
546      *      beginning of `self`. Otherwise, `self` is unmodified.
547      * @param self The slice to operate on.
548      * @param needle The slice to search for.
549      * @return `self`
550      */
551     function beyond(slice self, slice needle) internal returns (slice) {
552         if (self._len < needle._len) {
553             return self;
554         }
555 
556         bool equal = true;
557         if (self._ptr != needle._ptr) {
558             assembly {
559                 let len := mload(needle)
560                 let selfptr := mload(add(self, 0x20))
561                 let needleptr := mload(add(needle, 0x20))
562                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
563             }
564         }
565 
566         if (equal) {
567             self._len -= needle._len;
568             self._ptr += needle._len;
569         }
570 
571         return self;
572     }
573 
574     /*
575      * @dev Returns true if the slice ends with `needle`.
576      * @param self The slice to operate on.
577      * @param needle The slice to search for.
578      * @return True if the slice starts with the provided text, false otherwise.
579      */
580     function endsWith(slice self, slice needle) internal returns (bool) {
581         if (self._len < needle._len) {
582             return false;
583         }
584 
585         var selfptr = self._ptr + self._len - needle._len;
586 
587         if (selfptr == needle._ptr) {
588             return true;
589         }
590 
591         bool equal;
592         assembly {
593             let len := mload(needle)
594             let needleptr := mload(add(needle, 0x20))
595             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
596         }
597 
598         return equal;
599     }
600 
601     /*
602      * @dev If `self` ends with `needle`, `needle` is removed from the
603      *      end of `self`. Otherwise, `self` is unmodified.
604      * @param self The slice to operate on.
605      * @param needle The slice to search for.
606      * @return `self`
607      */
608     function until(slice self, slice needle) internal returns (slice) {
609         if (self._len < needle._len) {
610             return self;
611         }
612 
613         var selfptr = self._ptr + self._len - needle._len;
614         bool equal = true;
615         if (selfptr != needle._ptr) {
616             assembly {
617                 let len := mload(needle)
618                 let needleptr := mload(add(needle, 0x20))
619                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
620             }
621         }
622 
623         if (equal) {
624             self._len -= needle._len;
625         }
626 
627         return self;
628     }
629 
630     // Returns the memory address of the first byte of the first occurrence of
631     // `needle` in `self`, or the first byte after `self` if not found.
632     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
633         uint ptr;
634         uint idx;
635 
636         if (needlelen <= selflen) {
637             if (needlelen <= 32) {
638                 // Optimized assembly for 68 gas per byte on short strings
639                 assembly {
640                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
641                     let needledata := and(mload(needleptr), mask)
642                     let end := add(selfptr, sub(selflen, needlelen))
643                     ptr := selfptr
644                     loop:
645                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
646                     ptr := add(ptr, 1)
647                     jumpi(loop, lt(sub(ptr, 1), end))
648                     ptr := add(selfptr, selflen)
649                     exit:
650                 }
651                 return ptr;
652             } else {
653                 // For long needles, use hashing
654                 bytes32 hash;
655                 assembly { hash := sha3(needleptr, needlelen) }
656                 ptr = selfptr;
657                 for (idx = 0; idx <= selflen - needlelen; idx++) {
658                     bytes32 testHash;
659                     assembly { testHash := sha3(ptr, needlelen) }
660                     if (hash == testHash)
661                         return ptr;
662                     ptr += 1;
663                 }
664             }
665         }
666         return selfptr + selflen;
667     }
668 
669     // Returns the memory address of the first byte after the last occurrence of
670     // `needle` in `self`, or the address of `self` if not found.
671     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
672         uint ptr;
673 
674         if (needlelen <= selflen) {
675             if (needlelen <= 32) {
676                 // Optimized assembly for 69 gas per byte on short strings
677                 assembly {
678                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
679                     let needledata := and(mload(needleptr), mask)
680                     ptr := add(selfptr, sub(selflen, needlelen))
681                     loop:
682                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
683                     ptr := sub(ptr, 1)
684                     jumpi(loop, gt(add(ptr, 1), selfptr))
685                     ptr := selfptr
686                     jump(exit)
687                     ret:
688                     ptr := add(ptr, needlelen)
689                     exit:
690                 }
691                 return ptr;
692             } else {
693                 // For long needles, use hashing
694                 bytes32 hash;
695                 assembly { hash := sha3(needleptr, needlelen) }
696                 ptr = selfptr + (selflen - needlelen);
697                 while (ptr >= selfptr) {
698                     bytes32 testHash;
699                     assembly { testHash := sha3(ptr, needlelen) }
700                     if (hash == testHash)
701                         return ptr + needlelen;
702                     ptr -= 1;
703                 }
704             }
705         }
706         return selfptr;
707     }
708 
709     /*
710      * @dev Modifies `self` to contain everything from the first occurrence of
711      *      `needle` to the end of the slice. `self` is set to the empty slice
712      *      if `needle` is not found.
713      * @param self The slice to search and modify.
714      * @param needle The text to search for.
715      * @return `self`.
716      */
717     function find(slice self, slice needle) internal returns (slice) {
718         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
719         self._len -= ptr - self._ptr;
720         self._ptr = ptr;
721         return self;
722     }
723 
724     /*
725      * @dev Modifies `self` to contain the part of the string from the start of
726      *      `self` to the end of the first occurrence of `needle`. If `needle`
727      *      is not found, `self` is set to the empty slice.
728      * @param self The slice to search and modify.
729      * @param needle The text to search for.
730      * @return `self`.
731      */
732     function rfind(slice self, slice needle) internal returns (slice) {
733         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
734         self._len = ptr - self._ptr;
735         return self;
736     }
737 
738     /*
739      * @dev Splits the slice, setting `self` to everything after the first
740      *      occurrence of `needle`, and `token` to everything before it. If
741      *      `needle` does not occur in `self`, `self` is set to the empty slice,
742      *      and `token` is set to the entirety of `self`.
743      * @param self The slice to split.
744      * @param needle The text to search for in `self`.
745      * @param token An output parameter to which the first token is written.
746      * @return `token`.
747      */
748     function split(slice self, slice needle, slice token) internal returns (slice) {
749         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
750         token._ptr = self._ptr;
751         token._len = ptr - self._ptr;
752         if (ptr == self._ptr + self._len) {
753             // Not found
754             self._len = 0;
755         } else {
756             self._len -= token._len + needle._len;
757             self._ptr = ptr + needle._len;
758         }
759         return token;
760     }
761 
762     /*
763      * @dev Splits the slice, setting `self` to everything after the first
764      *      occurrence of `needle`, and returning everything before it. If
765      *      `needle` does not occur in `self`, `self` is set to the empty slice,
766      *      and the entirety of `self` is returned.
767      * @param self The slice to split.
768      * @param needle The text to search for in `self`.
769      * @return The part of `self` up to the first occurrence of `delim`.
770      */
771     function split(slice self, slice needle) internal returns (slice token) {
772         split(self, needle, token);
773     }
774 
775     /*
776      * @dev Splits the slice, setting `self` to everything before the last
777      *      occurrence of `needle`, and `token` to everything after it. If
778      *      `needle` does not occur in `self`, `self` is set to the empty slice,
779      *      and `token` is set to the entirety of `self`.
780      * @param self The slice to split.
781      * @param needle The text to search for in `self`.
782      * @param token An output parameter to which the first token is written.
783      * @return `token`.
784      */
785     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
786         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
787         token._ptr = ptr;
788         token._len = self._len - (ptr - self._ptr);
789         if (ptr == self._ptr) {
790             // Not found
791             self._len = 0;
792         } else {
793             self._len -= token._len + needle._len;
794         }
795         return token;
796     }
797 
798     /*
799      * @dev Splits the slice, setting `self` to everything before the last
800      *      occurrence of `needle`, and returning everything after it. If
801      *      `needle` does not occur in `self`, `self` is set to the empty slice,
802      *      and the entirety of `self` is returned.
803      * @param self The slice to split.
804      * @param needle The text to search for in `self`.
805      * @return The part of `self` after the last occurrence of `delim`.
806      */
807     function rsplit(slice self, slice needle) internal returns (slice token) {
808         rsplit(self, needle, token);
809     }
810 
811     /*
812      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
813      * @param self The slice to search.
814      * @param needle The text to search for in `self`.
815      * @return The number of occurrences of `needle` found in `self`.
816      */
817     function count(slice self, slice needle) internal returns (uint count) {
818         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
819         while (ptr <= self._ptr + self._len) {
820             count++;
821             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
822         }
823     }
824 
825     /*
826      * @dev Returns True if `self` contains `needle`.
827      * @param self The slice to search.
828      * @param needle The text to search for in `self`.
829      * @return True if `needle` is found in `self`, false otherwise.
830      */
831     function contains(slice self, slice needle) internal returns (bool) {
832         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
833     }
834 
835     /*
836      * @dev Returns a newly allocated string containing the concatenation of
837      *      `self` and `other`.
838      * @param self The first slice to concatenate.
839      * @param other The second slice to concatenate.
840      * @return The concatenation of the two strings.
841      */
842     function concat(slice self, slice other) internal returns (string) {
843         var ret = new string(self._len + other._len);
844         uint retptr;
845         assembly { retptr := add(ret, 32) }
846         memcpy(retptr, self._ptr, self._len);
847         memcpy(retptr + self._len, other._ptr, other._len);
848         return ret;
849     }
850 
851     /*
852      * @dev Joins an array of slices, using `self` as a delimiter, returning a
853      *      newly allocated string.
854      * @param self The delimiter to use.
855      * @param parts A list of slices to join.
856      * @return A newly allocated string containing all the slices in `parts`,
857      *         joined with `self`.
858      */
859     function join(slice self, slice[] parts) internal returns (string) {
860         if (parts.length == 0)
861             return "";
862 
863         uint len = self._len * (parts.length - 1);
864         for(uint i = 0; i < parts.length; i++)
865             len += parts[i]._len;
866 
867         var ret = new string(len);
868         uint retptr;
869         assembly { retptr := add(ret, 32) }
870 
871         for(i = 0; i < parts.length; i++) {
872             memcpy(retptr, parts[i]._ptr, parts[i]._len);
873             retptr += parts[i]._len;
874             if (i < parts.length - 1) {
875                 memcpy(retptr, self._ptr, self._len);
876                 retptr += self._len;
877             }
878         }
879 
880         return ret;
881     }
882 }
883 
884 /**
885  * Oraclize service proxy interface.
886  */
887 contract LastWillOraclizeProxyI {
888     /**
889      * Get requred amount of money for the next query call.
890      * @return wei
891      */
892     function getPrice() public returns (uint);
893 
894     /**
895      * Do check query.
896      * @param target User address to check.
897      * @param startBlock Starts check for this block.
898      * @param endBlock Latest block.
899      * @param callback Callback function (bool wasTransactions),
900      *                 which will be called on query result.
901      * @return True if query was registered, otherwise false.
902      */
903     function query(
904         address target,
905         uint startBlock,
906         uint endBlock,
907         function (bool) external callback
908     ) public payable returns (bool);
909 }
910 
911 contract LastWillOraclizeProxy is usingOraclize, LastWillOraclizeProxyI {
912     using strings for *;
913 
914     /**
915      * Oraclize query ids.
916      */
917     mapping(bytes32 => function (bool) external) private validIds;
918 
919     /**
920      * To inform LastWill system about latest oraclize price in wei.
921      */
922     event Price(uint);
923 
924     function getPrice() returns (uint) {
925         return oraclize_getPrice("URL");
926     }
927 
928     function query(
929         address target,
930         uint startBlock,
931         uint endBlock,
932         function (bool) external callback
933     ) public payable returns (bool) {
934         string memory url = buildUrl(target, startBlock, endBlock);
935         bytes32 queryId = oraclize_query("URL", url);
936         if (queryId == 0) {
937             return false;
938         }
939         validIds[queryId] = callback;
940         return true;
941     }
942 
943     /**
944      * The result look like '["1469624867", "1469624584",...'
945      */
946     function __callback(bytes32 queryId, string result, bytes) {
947         if (msg.sender != oraclize_cbAddress()) revert();
948         function (bool wasTransactions) external callback = validIds[queryId];
949         delete validIds[queryId];
950         // empty string means not transaction timestamps (no output transaction)
951         callback(bytes(result).length != 0);
952     }
953 
954     /************************** Internal **************************/
955 
956     // json(https://api.etherscan.io/api?module=account&action=txlist&address=0xddbd2b932c763ba5b1b7ae3b362eac3e8d40121a&startblock=0&endblock=99999999&page=0&offset=0&sort=desc&apikey=FJ39P2DIU8IX8U9N2735SUKQWG3HPPGPX8).result[?(@.from=='<address>')].timeStamp
957     function buildUrl(address target, uint startBlock, uint endBlock) internal constant returns (string) {
958         strings.slice memory strAddress = toHex(target).toSlice();
959         uint8 i = 0; // count of the strings below
960         var parts = new strings.slice[](9);
961         parts[i++] = "json(https://api.etherscan.io/api?module=account&action=txlist&address=0x".toSlice();
962         parts[i++] = strAddress;
963         //     // &page=0&offset=0 - means not pagination, but it might be a problem if there will be page limit
964         parts[i++] = "&startblock=".toSlice();
965         parts[i++] = uint2str(startBlock).toSlice();
966         parts[i++] = "&endblock=".toSlice();
967         parts[i++] = uint2str(endBlock).toSlice();
968         parts[i++] = "&sort=desc&apikey=FJ39P2DIU8IX8U9N2735SUKQWG3HPPGPX8).result[?(@.from=='0x".toSlice();
969         parts[i++] = strAddress;
970         parts[i++] = "')].timeStamp".toSlice();
971         return "".toSlice()
972                  .join(parts);
973     }
974 
975     /**
976      * This method is useful when we need to know last transaction ts
977      */
978     function parseJsonArrayAndGetFirstElementAsNumber(string json) internal constant returns (uint) {
979         var jsonSlice = json.toSlice();
980         strings.slice memory firstResult;
981         jsonSlice.split(", ".toSlice(), firstResult);
982         var ts = firstResult.beyond("[\"".toSlice()).toString();
983         return parseInt(ts);
984     }
985 
986     function toHex(address adr) internal constant returns (string) {
987         var ss = new bytes(40);
988         for (uint i = 0; i < 40; i ++) {
989             uint c;
990             assembly {
991                 c := and(adr, 0xf)
992                 adr := div(adr, 0x10)
993                 c := add(add(c, 0x30), mul(0x27, gt(c, 9)))
994             }
995             ss[39-i] = byte(c);
996         }
997         return string(ss);
998     }
999 }