1 // <ORACLIZE_API>
2 /*
3 Copyright (c) 2015-2016 Oraclize srl, Thomas Bertani
4 
5 
6 
7 Permission is hereby granted, free of charge, to any person obtaining a copy
8 of this software and associated documentation files (the "Software"), to deal
9 in the Software without restriction, including without limitation the rights
10 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
11 copies of the Software, and to permit persons to whom the Software is
12 furnished to do so, subject to the following conditions:
13 
14 
15 
16 The above copyright notice and this permission notice shall be included in
17 all copies or substantial portions of the Software.
18 
19 
20 
21 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
22 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
23 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
24 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
25 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
26 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
27 THE SOFTWARE.
28 */
29 
30 contract OraclizeI {
31     address public cbAddress;
32     function query(uint _timestamp, string _datasource, string _arg) returns (bytes32 _id);
33     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) returns (bytes32 _id);
34     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) returns (bytes32 _id);
35     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) returns (bytes32 _id);
36     function getPrice(string _datasource) returns (uint _dsprice);
37     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
38     function useCoupon(string _coupon);
39     function setProofType(byte _proofType);
40 }
41 contract OraclizeAddrResolverI {
42     function getAddress() returns (address _addr);
43 }
44 contract usingOraclize {
45     uint constant day = 60*60*24;
46     uint constant week = 60*60*24*7;
47     uint constant month = 60*60*24*30;
48     byte constant proofType_NONE = 0x00;
49     byte constant proofType_TLSNotary = 0x10;
50     byte constant proofStorage_IPFS = 0x01;
51     uint8 constant networkID_auto = 0;
52     uint8 constant networkID_mainnet = 1;
53     uint8 constant networkID_testnet = 2;
54     uint8 constant networkID_morden = 2;
55     uint8 constant networkID_consensys = 161;
56 
57     OraclizeAddrResolverI OAR;
58     
59     OraclizeI oraclize;
60     modifier oraclizeAPI {
61         address oraclizeAddr = OAR.getAddress();
62         if (oraclizeAddr == 0){
63             oraclize_setNetwork(networkID_auto);
64             oraclizeAddr = OAR.getAddress();
65         }
66         oraclize = OraclizeI(oraclizeAddr);
67         _
68     }
69     modifier coupon(string code){
70         oraclize = OraclizeI(OAR.getAddress());
71         oraclize.useCoupon(code);
72         _
73     }
74 
75     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
76         if (getCodeSize(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed)>0){
77             OAR = OraclizeAddrResolverI(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed);
78             return true;
79         }
80         if (getCodeSize(0x9efbea6358bed926b293d2ce63a730d6d98d43dd)>0){
81             OAR = OraclizeAddrResolverI(0x9efbea6358bed926b293d2ce63a730d6d98d43dd);
82             return true;
83         }
84         if (getCodeSize(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf)>0){
85             OAR = OraclizeAddrResolverI(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf);
86             return true;
87         }
88         return false;
89     }
90     
91     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
92         uint price = oraclize.getPrice(datasource);
93         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
94         return oraclize.query.value(price)(0, datasource, arg);
95     }
96     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
97         uint price = oraclize.getPrice(datasource);
98         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
99         return oraclize.query.value(price)(timestamp, datasource, arg);
100     }
101     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
102         uint price = oraclize.getPrice(datasource, gaslimit);
103         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
104         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
105     }
106     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
107         uint price = oraclize.getPrice(datasource, gaslimit);
108         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
109         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
110     }
111     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
112         uint price = oraclize.getPrice(datasource);
113         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
114         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
115     }
116     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
117         uint price = oraclize.getPrice(datasource);
118         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
119         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
120     }
121     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
122         uint price = oraclize.getPrice(datasource, gaslimit);
123         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
124         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
125     }
126     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
127         uint price = oraclize.getPrice(datasource, gaslimit);
128         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
129         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
130     }
131     function oraclize_cbAddress() oraclizeAPI internal returns (address){
132         return oraclize.cbAddress();
133     }
134     function oraclize_setProof(byte proofP) oraclizeAPI internal {
135         return oraclize.setProofType(proofP);
136     }
137 
138     function getCodeSize(address _addr) constant internal returns(uint _size) {
139         assembly {
140             _size := extcodesize(_addr)
141         }
142     }
143 
144 
145     function parseAddr(string _a) internal returns (address){
146         bytes memory tmp = bytes(_a);
147         uint160 iaddr = 0;
148         uint160 b1;
149         uint160 b2;
150         for (uint i=2; i<2+2*20; i+=2){
151             iaddr *= 256;
152             b1 = uint160(tmp[i]);
153             b2 = uint160(tmp[i+1]);
154             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
155             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
156             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
157             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
158             iaddr += (b1*16+b2);
159         }
160         return address(iaddr);
161     }
162 
163 
164     function strCompare(string _a, string _b) internal returns (int) {
165         bytes memory a = bytes(_a);
166         bytes memory b = bytes(_b);
167         uint minLength = a.length;
168         if (b.length < minLength) minLength = b.length;
169         for (uint i = 0; i < minLength; i ++)
170             if (a[i] < b[i])
171                 return -1;
172             else if (a[i] > b[i])
173                 return 1;
174         if (a.length < b.length)
175             return -1;
176         else if (a.length > b.length)
177             return 1;
178         else
179             return 0;
180    } 
181 
182     function indexOf(string _haystack, string _needle) internal returns (int)
183     {
184         bytes memory h = bytes(_haystack);
185         bytes memory n = bytes(_needle);
186         if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
187             return -1;
188         else if(h.length > (2**128 -1))
189             return -1;                                  
190         else
191         {
192             uint subindex = 0;
193             for (uint i = 0; i < h.length; i ++)
194             {
195                 if (h[i] == n[0])
196                 {
197                     subindex = 1;
198                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
199                     {
200                         subindex++;
201                     }   
202                     if(subindex == n.length)
203                         return int(i);
204                 }
205             }
206             return -1;
207         }   
208     }
209 
210     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
211         bytes memory _ba = bytes(_a);
212         bytes memory _bb = bytes(_b);
213         bytes memory _bc = bytes(_c);
214         bytes memory _bd = bytes(_d);
215         bytes memory _be = bytes(_e);
216         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
217         bytes memory babcde = bytes(abcde);
218         uint k = 0;
219         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
220         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
221         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
222         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
223         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
224         return string(babcde);
225     }
226     
227     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
228         return strConcat(_a, _b, _c, _d, "");
229     }
230 
231     function strConcat(string _a, string _b, string _c) internal returns (string) {
232         return strConcat(_a, _b, _c, "", "");
233     }
234 
235     function strConcat(string _a, string _b) internal returns (string) {
236         return strConcat(_a, _b, "", "", "");
237     }
238 
239     // parseInt
240     function parseInt(string _a) internal returns (uint) {
241         return parseInt(_a, 0);
242     }
243 
244     // parseInt(parseFloat*10^_b)
245     function parseInt(string _a, uint _b) internal returns (uint) {
246         bytes memory bresult = bytes(_a);
247         uint mint = 0;
248         bool decimals = false;
249         for (uint i=0; i<bresult.length; i++){
250             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
251                 if (decimals){
252                    if (_b == 0) break;
253                     else _b--;
254                 }
255                 mint *= 10;
256                 mint += uint(bresult[i]) - 48;
257             } else if (bresult[i] == 46) decimals = true;
258         }
259         if (_b > 0) mint *= 10**_b;
260         return mint;
261     }
262     
263 
264 }
265 // </ORACLIZE_API>
266 
267 library strings {
268     struct slice {
269         uint _len;
270         uint _ptr;
271     }
272 
273     function memcpy(uint dest, uint src, uint len) private {
274         // Copy word-length chunks while possible
275         for(; len >= 32; len -= 32) {
276             assembly {
277                 mstore(dest, mload(src))
278             }
279             dest += 32;
280             src += 32;
281         }
282 
283         // Copy remaining bytes
284         uint mask = 256 ** (32 - len) - 1;
285         assembly {
286             let srcpart := and(mload(src), not(mask))
287             let destpart := and(mload(dest), mask)
288             mstore(dest, or(destpart, srcpart))
289         }
290     }
291 
292     /**
293      * @dev Returns a slice containing the entire string.
294      * @param self The string to make a slice from.
295      * @return A newly allocated slice containing the entire string.
296      */
297     function toSlice(string self) internal returns (slice) {
298         uint ptr;
299         assembly {
300             ptr := add(self, 0x20)
301         }
302         return slice(bytes(self).length, ptr);
303     }
304 
305     /**
306      * @dev Returns the length of a null-terminated bytes32 string.
307      * @param self The value to find the length of.
308      * @return The length of the string, from 0 to 32.
309      */
310     function len(bytes32 self) internal returns (uint) {
311         uint ret;
312         if (self == 0)
313             return 0;
314         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
315             ret += 16;
316             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
317         }
318         if (self & 0xffffffffffffffff == 0) {
319             ret += 8;
320             self = bytes32(uint(self) / 0x10000000000000000);
321         }
322         if (self & 0xffffffff == 0) {
323             ret += 4;
324             self = bytes32(uint(self) / 0x100000000);
325         }
326         if (self & 0xffff == 0) {
327             ret += 2;
328             self = bytes32(uint(self) / 0x10000);
329         }
330         if (self & 0xff == 0) {
331             ret += 1;
332         }
333         return 32 - ret;
334     }
335 
336     /**
337      * @dev Returns a slice containing the entire bytes32, interpreted as a
338      *      null-termintaed utf-8 string.
339      * @param self The bytes32 value to convert to a slice.
340      * @return A new slice containing the value of the input argument up to the
341      *         first null.
342      */
343     function toSliceB32(bytes32 self) internal returns (slice ret) {
344         // Allocate space for `self` in memory, copy it there, and point ret at it
345         assembly {
346             let ptr := mload(0x40)
347             mstore(0x40, add(ptr, 0x20))
348             mstore(ptr, self)
349             mstore(add(ret, 0x20), ptr)
350         }
351         ret._len = len(self);
352     }
353 
354     /**
355      * @dev Returns a new slice containing the same data as the current slice.
356      * @param self The slice to copy.
357      * @return A new slice containing the same data as `self`.
358      */
359     function copy(slice self) internal returns (slice) {
360         return slice(self._len, self._ptr);
361     }
362 
363     /**
364      * @dev Copies a slice to a new string.
365      * @param self The slice to copy.
366      * @return A newly allocated string containing the slice's text.
367      */
368     function toString(slice self) internal returns (string) {
369         var ret = new string(self._len);
370         uint retptr;
371         assembly { retptr := add(ret, 32) }
372 
373         memcpy(retptr, self._ptr, self._len);
374         return ret;
375     }
376 
377     /**
378      * @dev Returns the length in runes of the slice. Note that this operation
379      *      takes time proportional to the length of the slice; avoid using it
380      *      in loops, and call `slice.empty()` if you only need to know whether
381      *      the slice is empty or not.
382      * @param self The slice to operate on.
383      * @return The length of the slice in runes.
384      */
385     function len(slice self) internal returns (uint) {
386         // Starting at ptr-31 means the LSB will be the byte we care about
387         var ptr = self._ptr - 31;
388         var end = ptr + self._len;
389         for (uint len = 0; ptr < end; len++) {
390             uint8 b;
391             assembly { b := and(mload(ptr), 0xFF) }
392             if (b < 0x80) {
393                 ptr += 1;
394             } else if(b < 0xE0) {
395                 ptr += 2;
396             } else if(b < 0xF0) {
397                 ptr += 3;
398             } else if(b < 0xF8) {
399                 ptr += 4;
400             } else if(b < 0xFC) {
401                 ptr += 5;
402             } else {
403                 ptr += 6;
404             }
405         }
406         return len;
407     }
408 
409     /**
410      * @dev Returns true if the slice is empty (has a length of 0).
411      * @param self The slice to operate on.
412      * @return True if the slice is empty, False otherwise.
413      */
414     function empty(slice self) internal returns (bool) {
415         return self._len == 0;
416     }
417 
418     /**
419      * @dev Returns a positive number if `other` comes lexicographically after
420      *      `self`, a negative number if it comes before, or zero if the
421      *      contents of the two slices are equal. Comparison is done per-rune,
422      *      on unicode codepoints.
423      * @param self The first slice to compare.
424      * @param other The second slice to compare.
425      * @return The result of the comparison.
426      */
427     function compare(slice self, slice other) internal returns (int) {
428         uint shortest = self._len;
429         if (other._len < self._len)
430             shortest = other._len;
431 
432         var selfptr = self._ptr;
433         var otherptr = other._ptr;
434         for (uint idx = 0; idx < shortest; idx += 32) {
435             uint a;
436             uint b;
437             assembly {
438                 a := mload(selfptr)
439                 b := mload(otherptr)
440             }
441             if (a != b) {
442                 // Mask out irrelevant bytes and check again
443                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
444                 var diff = (a & mask) - (b & mask);
445                 if (diff != 0)
446                     return int(diff);
447             }
448             selfptr += 32;
449             otherptr += 32;
450         }
451         return int(self._len) - int(other._len);
452     }
453 
454     /**
455      * @dev Returns true if the two slices contain the same text.
456      * @param self The first slice to compare.
457      * @param self The second slice to compare.
458      * @return True if the slices are equal, false otherwise.
459      */
460     function equals(slice self, slice other) internal returns (bool) {
461         return compare(self, other) == 0;
462     }
463 
464     /**
465      * @dev Extracts the first rune in the slice into `rune`, advancing the
466      *      slice to point to the next rune and returning `self`.
467      * @param self The slice to operate on.
468      * @param rune The slice that will contain the first rune.
469      * @return `rune`.
470      */
471     function nextRune(slice self, slice rune) internal returns (slice) {
472         rune._ptr = self._ptr;
473 
474         if (self._len == 0) {
475             rune._len = 0;
476             return rune;
477         }
478 
479         uint len;
480         uint b;
481         // Load the first byte of the rune into the LSBs of b
482         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
483         if (b < 0x80) {
484             len = 1;
485         } else if(b < 0xE0) {
486             len = 2;
487         } else if(b < 0xF0) {
488             len = 3;
489         } else {
490             len = 4;
491         }
492 
493         // Check for truncated codepoints
494         if (len > self._len) {
495             rune._len = self._len;
496             self._ptr += self._len;
497             self._len = 0;
498             return rune;
499         }
500 
501         self._ptr += len;
502         self._len -= len;
503         rune._len = len;
504         return rune;
505     }
506 
507     /**
508      * @dev Returns the first rune in the slice, advancing the slice to point
509      *      to the next rune.
510      * @param self The slice to operate on.
511      * @return A slice containing only the first rune from `self`.
512      */
513     function nextRune(slice self) internal returns (slice ret) {
514         nextRune(self, ret);
515     }
516 
517     /**
518      * @dev Returns the number of the first codepoint in the slice.
519      * @param self The slice to operate on.
520      * @return The number of the first codepoint in the slice.
521      */
522     function ord(slice self) internal returns (uint ret) {
523         if (self._len == 0) {
524             return 0;
525         }
526 
527         uint word;
528         uint len;
529         uint div = 2 ** 248;
530 
531         // Load the rune into the MSBs of b
532         assembly { word:= mload(mload(add(self, 32))) }
533         var b = word / div;
534         if (b < 0x80) {
535             ret = b;
536             len = 1;
537         } else if(b < 0xE0) {
538             ret = b & 0x1F;
539             len = 2;
540         } else if(b < 0xF0) {
541             ret = b & 0x0F;
542             len = 3;
543         } else {
544             ret = b & 0x07;
545             len = 4;
546         }
547 
548         // Check for truncated codepoints
549         if (len > self._len) {
550             return 0;
551         }
552 
553         for (uint i = 1; i < len; i++) {
554             div = div / 256;
555             b = (word / div) & 0xFF;
556             if (b & 0xC0 != 0x80) {
557                 // Invalid UTF-8 sequence
558                 return 0;
559             }
560             ret = (ret * 64) | (b & 0x3F);
561         }
562 
563         return ret;
564     }
565 
566     /**
567      * @dev Returns the keccak-256 hash of the slice.
568      * @param self The slice to hash.
569      * @return The hash of the slice.
570      */
571     function keccak(slice self) internal returns (bytes32 ret) {
572         assembly {
573             ret := sha3(mload(add(self, 32)), mload(self))
574         }
575     }
576 
577     /**
578      * @dev Returns true if `self` starts with `needle`.
579      * @param self The slice to operate on.
580      * @param needle The slice to search for.
581      * @return True if the slice starts with the provided text, false otherwise.
582      */
583     function startsWith(slice self, slice needle) internal returns (bool) {
584         if (self._len < needle._len) {
585             return false;
586         }
587 
588         if (self._ptr == needle._ptr) {
589             return true;
590         }
591 
592         bool equal;
593         assembly {
594             let len := mload(needle)
595             let selfptr := mload(add(self, 0x20))
596             let needleptr := mload(add(needle, 0x20))
597             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
598         }
599         return equal;
600     }
601 
602     /**
603      * @dev If `self` starts with `needle`, `needle` is removed from the
604      *      beginning of `self`. Otherwise, `self` is unmodified.
605      * @param self The slice to operate on.
606      * @param needle The slice to search for.
607      * @return `self`
608      */
609     function beyond(slice self, slice needle) internal returns (slice) {
610         if (self._len < needle._len) {
611             return self;
612         }
613 
614         bool equal = true;
615         if (self._ptr != needle._ptr) {
616             assembly {
617                 let len := mload(needle)
618                 let selfptr := mload(add(self, 0x20))
619                 let needleptr := mload(add(needle, 0x20))
620                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
621             }
622         }
623 
624         if (equal) {
625             self._len -= needle._len;
626             self._ptr += needle._len;
627         }
628 
629         return self;
630     }
631 
632     /**
633      * @dev Returns true if the slice ends with `needle`.
634      * @param self The slice to operate on.
635      * @param needle The slice to search for.
636      * @return True if the slice starts with the provided text, false otherwise.
637      */
638     function endsWith(slice self, slice needle) internal returns (bool) {
639         if (self._len < needle._len) {
640             return false;
641         }
642 
643         var selfptr = self._ptr + self._len - needle._len;
644 
645         if (selfptr == needle._ptr) {
646             return true;
647         }
648 
649         bool equal;
650         assembly {
651             let len := mload(needle)
652             let needleptr := mload(add(needle, 0x20))
653             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
654         }
655 
656         return equal;
657     }
658 
659     /**
660      * @dev If `self` ends with `needle`, `needle` is removed from the
661      *      end of `self`. Otherwise, `self` is unmodified.
662      * @param self The slice to operate on.
663      * @param needle The slice to search for.
664      * @return `self`
665      */
666     function until(slice self, slice needle) internal returns (slice) {
667         if (self._len < needle._len) {
668             return self;
669         }
670 
671         var selfptr = self._ptr + self._len - needle._len;
672         bool equal = true;
673         if (selfptr != needle._ptr) {
674             assembly {
675                 let len := mload(needle)
676                 let needleptr := mload(add(needle, 0x20))
677                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
678             }
679         }
680 
681         if (equal) {
682             self._len -= needle._len;
683         }
684 
685         return self;
686     }
687 
688     // Returns the memory address of the first byte of the first occurrence of
689     // `needle` in `self`, or the first byte after `self` if not found.
690     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
691         uint ptr;
692         uint idx;
693 
694         if (needlelen <= selflen) {
695             if (needlelen <= 32) {
696                 // Optimized assembly for 68 gas per byte on short strings
697                 assembly {
698                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
699                     let needledata := and(mload(needleptr), mask)
700                     let end := add(selfptr, sub(selflen, needlelen))
701                     ptr := selfptr
702                     loop:
703                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
704                     ptr := add(ptr, 1)
705                     jumpi(loop, lt(sub(ptr, 1), end))
706                     ptr := add(selfptr, selflen)
707                     exit:
708                 }
709                 return ptr;
710             } else {
711                 // For long needles, use hashing
712                 bytes32 hash;
713                 assembly { hash := sha3(needleptr, needlelen) }
714                 ptr = selfptr;
715                 for (idx = 0; idx <= selflen - needlelen; idx++) {
716                     bytes32 testHash;
717                     assembly { testHash := sha3(ptr, needlelen) }
718                     if (hash == testHash)
719                         return ptr;
720                     ptr += 1;
721                 }
722             }
723         }
724         return selfptr + selflen;
725     }
726 
727     // Returns the memory address of the first byte after the last occurrence of
728     // `needle` in `self`, or the address of `self` if not found.
729     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
730         uint ptr;
731 
732         if (needlelen <= selflen) {
733             if (needlelen <= 32) {
734                 // Optimized assembly for 69 gas per byte on short strings
735                 assembly {
736                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
737                     let needledata := and(mload(needleptr), mask)
738                     ptr := add(selfptr, sub(selflen, needlelen))
739                     loop:
740                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
741                     ptr := sub(ptr, 1)
742                     jumpi(loop, gt(add(ptr, 1), selfptr))
743                     ptr := selfptr
744                     jump(exit)
745                     ret:
746                     ptr := add(ptr, needlelen)
747                     exit:
748                 }
749                 return ptr;
750             } else {
751                 // For long needles, use hashing
752                 bytes32 hash;
753                 assembly { hash := sha3(needleptr, needlelen) }
754                 ptr = selfptr + (selflen - needlelen);
755                 while (ptr >= selfptr) {
756                     bytes32 testHash;
757                     assembly { testHash := sha3(ptr, needlelen) }
758                     if (hash == testHash)
759                         return ptr + needlelen;
760                     ptr -= 1;
761                 }
762             }
763         }
764         return selfptr;
765     }
766 
767     /**
768      * @dev Modifies `self` to contain everything from the first occurrence of
769      *      `needle` to the end of the slice. `self` is set to the empty slice
770      *      if `needle` is not found.
771      * @param self The slice to search and modify.
772      * @param needle The text to search for.
773      * @return `self`.
774      */
775     function find(slice self, slice needle) internal returns (slice) {
776         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
777         self._len -= ptr - self._ptr;
778         self._ptr = ptr;
779         return self;
780     }
781 
782     /**
783      * @dev Modifies `self` to contain the part of the string from the start of
784      *      `self` to the end of the first occurrence of `needle`. If `needle`
785      *      is not found, `self` is set to the empty slice.
786      * @param self The slice to search and modify.
787      * @param needle The text to search for.
788      * @return `self`.
789      */
790     function rfind(slice self, slice needle) internal returns (slice) {
791         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
792         self._len = ptr - self._ptr;
793         return self;
794     }
795 
796     /**
797      * @dev Splits the slice, setting `self` to everything after the first
798      *      occurrence of `needle`, and `token` to everything before it. If
799      *      `needle` does not occur in `self`, `self` is set to the empty slice,
800      *      and `token` is set to the entirety of `self`.
801      * @param self The slice to split.
802      * @param needle The text to search for in `self`.
803      * @param token An output parameter to which the first token is written.
804      * @return `token`.
805      */
806     function split(slice self, slice needle, slice token) internal returns (slice) {
807         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
808         token._ptr = self._ptr;
809         token._len = ptr - self._ptr;
810         if (ptr == self._ptr + self._len) {
811             // Not found
812             self._len = 0;
813         } else {
814             self._len -= token._len + needle._len;
815             self._ptr = ptr + needle._len;
816         }
817         return token;
818     }
819 
820     /**
821      * @dev Splits the slice, setting `self` to everything after the first
822      *      occurrence of `needle`, and returning everything before it. If
823      *      `needle` does not occur in `self`, `self` is set to the empty slice,
824      *      and the entirety of `self` is returned.
825      * @param self The slice to split.
826      * @param needle The text to search for in `self`.
827      * @return The part of `self` up to the first occurrence of `delim`.
828      */
829     function split(slice self, slice needle) internal returns (slice token) {
830         split(self, needle, token);
831     }
832 
833     /**
834      * @dev Splits the slice, setting `self` to everything before the last
835      *      occurrence of `needle`, and `token` to everything after it. If
836      *      `needle` does not occur in `self`, `self` is set to the empty slice,
837      *      and `token` is set to the entirety of `self`.
838      * @param self The slice to split.
839      * @param needle The text to search for in `self`.
840      * @param token An output parameter to which the first token is written.
841      * @return `token`.
842      */
843     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
844         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
845         token._ptr = ptr;
846         token._len = self._len - (ptr - self._ptr);
847         if (ptr == self._ptr) {
848             // Not found
849             self._len = 0;
850         } else {
851             self._len -= token._len + needle._len;
852         }
853         return token;
854     }
855 
856     /**
857      * @dev Splits the slice, setting `self` to everything before the last
858      *      occurrence of `needle`, and returning everything after it. If
859      *      `needle` does not occur in `self`, `self` is set to the empty slice,
860      *      and the entirety of `self` is returned.
861      * @param self The slice to split.
862      * @param needle The text to search for in `self`.
863      * @return The part of `self` after the last occurrence of `delim`.
864      */
865     function rsplit(slice self, slice needle) internal returns (slice token) {
866         rsplit(self, needle, token);
867     }
868 
869     /**
870      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
871      * @param self The slice to search.
872      * @param needle The text to search for in `self`.
873      * @return The number of occurrences of `needle` found in `self`.
874      */
875     function count(slice self, slice needle) internal returns (uint count) {
876         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
877         while (ptr <= self._ptr + self._len) {
878             count++;
879             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
880         }
881     }
882 
883     /**
884      * @dev Returns True if `self` contains `needle`.
885      * @param self The slice to search.
886      * @param needle The text to search for in `self`.
887      * @return True if `needle` is found in `self`, false otherwise.
888      */
889     function contains(slice self, slice needle) internal returns (bool) {
890         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
891     }
892 
893     /**
894      * @dev Returns a newly allocated string containing the concatenation of
895      *      `self` and `other`.
896      * @param self The first slice to concatenate.
897      * @param other The second slice to concatenate.
898      * @return The concatenation of the two strings.
899      */
900     function concat(slice self, slice other) internal returns (string) {
901         var ret = new string(self._len + other._len);
902         uint retptr;
903         assembly { retptr := add(ret, 32) }
904         memcpy(retptr, self._ptr, self._len);
905         memcpy(retptr + self._len, other._ptr, other._len);
906         return ret;
907     }
908 
909     /**
910      * @dev Joins an array of slices, using `self` as a delimiter, returning a
911      *      newly allocated string.
912      * @param self The delimiter to use.
913      * @param parts A list of slices to join.
914      * @return A newly allocated string containing all the slices in `parts`,
915      *         joined with `self`.
916      */
917     function join(slice self, slice[] parts) internal returns (string) {
918         if (parts.length == 0)
919             return "";
920 
921         uint len = self._len * (parts.length - 1);
922         for(uint i = 0; i < parts.length; i++)
923             len += parts[i]._len;
924 
925         var ret = new string(len);
926         uint retptr;
927         assembly { retptr := add(ret, 32) }
928 
929         for(i = 0; i < parts.length; i++) {
930             memcpy(retptr, parts[i]._ptr, parts[i]._len);
931             retptr += parts[i]._len;
932             if (i < parts.length - 1) {
933                 memcpy(retptr, self._ptr, self._len);
934                 retptr += self._len;
935             }
936         }
937 
938         return ret;
939     }
940 }
941 
942 
943 contract mortal {
944     address owner;
945 
946     function mortal() {
947         owner = msg.sender;
948     }
949 
950     function kill() internal{
951         suicide(owner);
952     }
953 }
954 
955 contract Pray4Prey is mortal, usingOraclize {
956 	using strings for *;
957 	
958     /**the balances in wei being held by each player */
959     mapping(address => uint128) winBalances;
960     /**list of all players*/
961     address[] public players;
962     /** the number of players (may be != players.length, since players can leave the game)*/
963     uint16 public numPlayers;
964     
965     /** animals[0] -> list of the owners of the animals of type 0, animals[1] animals type 1 etc (using a mapping instead of a multidimensional array for lower gas consumptions) */
966     mapping(uint8 => address[]) animals;
967     /** the cost of each animal type */
968     uint128[] public costs;
969     /** the value of each animal type (cost - fee), so it's not necessary to compute it each time*/
970     uint128[] public values;
971     /** internal  array of the probability factors, so it's not necessary to compute it each time*/
972     uint8[] probabilityFactors;
973     /** the fee to be paid each time an animal is bought in percent*/
974     uint8[] public fees;
975 
976     /** the indices of the animals per type per player */
977    // mapping(address => mapping(uint8 => uint16[])) animalIndices; 
978   // mapping(address => mapping(uint8 => uint16)) numAnimalsXPlayerXType;
979     
980     /** total number of animals in the game 
981     (!=sum of the lengths of the prey animals arrays, since those arrays contain holes) */
982     uint16 public numAnimals;
983     /** The maximum of animals allowed in the game */
984     uint16 public maxAnimals;
985     /** number of animals per player */
986     mapping(address => uint8) numAnimalsXPlayer;
987     /** number of animals per type */
988     mapping(uint8 => uint16) numAnimalsXType;
989 
990     
991     /** the query string getting the random numbers from oraclize**/
992     string randomQuery;
993     /** the timestamp of the next attack **/
994     uint public nextAttackTimestamp;
995     /** gas provided for oraclize callback (attack)**/
996     uint32 public oraclizeGas;
997     /** the id of the next oraclize callback*/
998     bytes32 nextAttackId;
999     
1000     
1001     /** is fired when new animals are purchased (who bought how many animals of which type?) */
1002     event newPurchase(address player, uint8 animalType, uint8 amount);
1003     /** is fired when a player leaves the game */
1004     event newExit(address player, uint256 totalBalance);
1005     /** is fired when an attack occures*/
1006     event newAttack();
1007     
1008     
1009     /** expected parameters: the costs per animal type and the game fee in percent 
1010     *   assumes that the cheapest animal is stored in [0]
1011     */
1012     function Pray4Prey(uint128[] animalCosts, uint8[] gameFees) {
1013         costs = animalCosts;
1014         fees = gameFees;
1015         for(uint8 i = 0; i< costs.length; i++){
1016             values.push(costs[i]-costs[i]/100*fees[i]);
1017             probabilityFactors.push(uint8(costs[costs.length-i-1]/costs[0]));
1018         }
1019         maxAnimals = 3000;
1020         randomQuery = "https://www.random.org/integers/?num=10&min=0&max=10000&col=1&base=10&format=plain&rnd=new";
1021         oraclizeGas=550000;
1022     }
1023     
1024      /** The fallback function runs whenever someone sends ether
1025         Depending of the value of the transaction the sender is either granted a prey or 
1026         the transaction is discarded and no ether accepted
1027         In the first case fees have to be paid*/
1028      function (){
1029          for(uint8 i = 0; i < costs.length; i++)
1030             if(msg.value==costs[i])
1031                 addAnimals(i);
1032                 
1033         if(msg.value==1000000000000000)
1034             exit();
1035         else
1036             throw;
1037             
1038      }
1039      
1040      /** buy animals of a given type 
1041      *  as many animals as possible are bought with msg.value, rest is added to the winBalance of the sender
1042      */
1043      function addAnimals(uint8 animalType){
1044         uint8 amount = uint8(msg.value/costs[animalType]);
1045         if(animalType >= costs.length || msg.value<costs[animalType] || numAnimalsXPlayer[msg.sender]+amount>50 || numAnimals+amount>=maxAnimals) throw;
1046         //if type exists, enough ether was transferred, the player doesn't posess to many animals already (else exit is too costly) and there are less than 10000 animals in the game
1047         if(numAnimalsXPlayer[msg.sender]==0)//new player
1048             addPlayer();
1049         for(uint8 j = 0; j<amount; j++){
1050             addAnimal(animalType);
1051         }
1052         numAnimals+=amount;
1053         numAnimalsXPlayer[msg.sender]+=amount;
1054         //numAnimalsXPlayerXType[msg.sender][animalType]+=amount;
1055         winBalances[msg.sender]+=uint128(msg.value*(100-fees[animalType])/100);
1056         newPurchase(msg.sender, animalType, j);
1057         
1058      }
1059      
1060      /**
1061      *  adds a single animal of the given type
1062      */
1063      function addAnimal(uint8 animalType) internal{
1064         if(numAnimalsXType[animalType]<animals[animalType].length)
1065             animals[animalType][numAnimalsXType[animalType]]=msg.sender;
1066         else
1067             animals[animalType].push(msg.sender);
1068         numAnimalsXType[animalType]++;
1069      }
1070      
1071   
1072      
1073      /**
1074       * adds an address to the list of players
1075       * before calling you need to check if the address is already in the game
1076       * */
1077      function addPlayer() internal{
1078         if(numPlayers<players.length)
1079             players[numPlayers]=msg.sender;
1080         else
1081             players.push(msg.sender);
1082         numPlayers++;
1083      }
1084      
1085      /**
1086       * removes a given address from the player array
1087       * */
1088      function deletePlayer(address playerAddress) internal{
1089          for(uint16 i  = 0; i < numPlayers; i++)
1090              if(players[i]==playerAddress){
1091                 numPlayers--;
1092                 players[i]=players[numPlayers];
1093                 delete players[numPlayers];
1094                 return;
1095              }
1096      }
1097      
1098      
1099      /** leave the game
1100       * pays out the sender's winBalance and removes him and his animals from the game
1101       * */
1102     function exit(){
1103     	cleanUp(msg.sender);//delete the animals
1104         newExit(msg.sender, winBalances[msg.sender]); //fire the event to notify the client
1105         if(!payout(msg.sender)) throw;
1106         delete winBalances[msg.sender];
1107         deletePlayer(msg.sender);
1108     }
1109     
1110     /**
1111      * Deletes the animals of a given player
1112      * */
1113     function cleanUp(address playerAddress) internal{
1114     	for(uint8 animalType = 0;  animalType< costs.length;  animalType++){//costs.length == num animal types
1115     	    if(numAnimalsXType[animalType]>0){
1116                 for(uint16 i = 0; i < numAnimalsXType[animalType]; i++){
1117                     if(animals[animalType][i] == playerAddress){
1118                        replaceAnimal(animalType,i, true);
1119                     }
1120                 }
1121     	    }
1122         }
1123         numAnimals-=numAnimalsXPlayer[playerAddress];
1124         delete numAnimalsXPlayer[playerAddress];
1125     }
1126     
1127     
1128     /**
1129      * Replaces the animal at the given index with the last animal in the array
1130      * */
1131     function replaceAnimal(uint8 animalType, uint16 index, bool exit) internal{
1132         if(exit){//delete all animals at the end of the array that belong to the same player
1133             while(animals[animalType][numAnimalsXType[animalType]-1]==animals[animalType][index]){
1134                 numAnimalsXType[animalType]--;
1135                 delete animals[animalType][numAnimalsXType[animalType]];
1136                 if(numAnimalsXType[animalType]==index)
1137                     return;
1138             }
1139         }
1140         numAnimalsXType[animalType]--;
1141 		animals[animalType][index]=animals[animalType][numAnimalsXType[animalType]];
1142 		delete animals[animalType][numAnimalsXType[animalType]];//actually there's no need for the delete, since the index will not be accessed since it's higher than numAnimalsXType[animalType]
1143     }
1144     
1145     
1146     
1147     /**
1148      * pays out the given player and removes his fishes.
1149      * amount = winbalance + sum(fishvalues)
1150      * returns true if payout was successful
1151      * */
1152     function payout(address playerAddress) internal returns(bool){
1153         return playerAddress.send(winBalances[playerAddress]);
1154     }
1155 
1156     
1157     /**
1158      * manually triggers the attack. cannot be called afterwards, except
1159      * by the owner if and only if the attack wasn't launched as supposed, signifying
1160      * an error ocurred during the last invocation of oraclize, or there wasn't enough ether to pay the gas
1161      * */
1162     function triggerAttackManually(uint32 inseconds){
1163         if(!(msg.sender==owner && nextAttackTimestamp < now+300)) throw;
1164         triggerAttack(inseconds);
1165     }
1166     
1167     /**
1168      * sends a query to oraclize in order to get random numbers in 'inseconds' seconds
1169      */
1170     function triggerAttack(uint32 inseconds) internal{
1171     	nextAttackTimestamp = now+inseconds;
1172     	nextAttackId = oraclize_query(nextAttackTimestamp, "URL", randomQuery, oraclizeGas+6000*numPlayers);
1173     }
1174     
1175     /**
1176      * The actual predator attack.
1177      * The predator kills up to 10 animals, but in case there are less than 100 animals in the game up to 10% get eaten.
1178      * */
1179     function __callback(bytes32 myid, string result) {
1180         if (msg.sender != oraclize_cbAddress()||myid!=nextAttackId) throw; // just to be sure the calling address is the Oraclize authorized one and the callback is the expected one
1181         
1182         uint16[] memory ranges = new uint16[](costs.length+1);
1183         ranges[0] = 0;
1184         for(uint8 animalType = 0; animalType < costs.length; animalType ++){
1185             ranges[animalType+1] = ranges[animalType]+uint16(probabilityFactors[animalType]*numAnimalsXType[animalType]); 
1186         }     
1187         uint128 pot;
1188         uint16 random;        
1189         uint16 howmany = numAnimals<100?(numAnimals<10?1:numAnimals/10):10;//do not kill more than 10%, but at least one
1190         uint16[] memory randomNumbers = getNumbersFromString(result,"\n", howmany);
1191         for(uint8 i = 0; i < howmany; i++){
1192             random = mapToNewRange(randomNumbers[i], ranges[costs.length]);
1193             for(animalType = 0; animalType < costs.length; animalType ++)
1194                 if (random < ranges[animalType+1]){
1195                     pot+= killAnimal(animalType, (random-ranges[animalType])/probabilityFactors[animalType]);
1196                     break;
1197                 }
1198         }
1199         numAnimals-=howmany;
1200         newAttack();
1201         if(pot>uint128(oraclizeGas*tx.gasprice))
1202             distribute(uint128(pot-oraclizeGas*tx.gasprice));//distribute the pot minus the oraclize gas costs
1203         triggerAttack(timeTillNextAttack());
1204     }
1205     
1206     /**
1207      * the frequency of the shark attacks depends on the number of animals in the game. 
1208      * many animals -> many shark attacks
1209      * at least one attack in 24 hours
1210      * */
1211     function timeTillNextAttack() constant internal returns(uint32){
1212         return (86400/(1+numAnimals/100));
1213     }
1214     
1215 
1216     /**
1217      * kills the animal of the given type at the given index. 
1218      * */
1219     function killAnimal(uint8 animalType, uint16 index) internal returns(uint128){
1220         address preyOwner = animals[animalType][index];
1221 
1222         replaceAnimal(animalType,index,false);
1223         numAnimalsXPlayer[preyOwner]--;
1224         
1225         //numAnimalsXPlayerXType[preyOwner][animalType]--;
1226         //if the player still owns prey, the value of the animalType1 alone goes into the pot
1227         if(numAnimalsXPlayer[preyOwner]>0){
1228         	winBalances[preyOwner]-=values[animalType];
1229             return values[animalType];
1230         }
1231         //owner does not have anymore prey, his winBlanace goes into the pot
1232         else{
1233             uint128 bounty = winBalances[preyOwner];
1234             delete winBalances[preyOwner];
1235             deletePlayer(preyOwner);
1236             return bounty;
1237         }
1238 
1239     }
1240     
1241     
1242     /** distributes the given amount among the players depending on the number of fishes they possess*/
1243     function distribute(uint128 amount) internal{
1244         uint128 share = amount/numAnimals;
1245         for(uint16 i = 0; i < numPlayers; i++){
1246             winBalances[players[i]]+=share*numAnimalsXPlayer[players[i]];
1247         }
1248     }
1249     
1250     /**
1251      * allows the owner to collect the accumulated fees
1252      * sends the given amount to the owner's address if the amount does not exceed the
1253      * fees (cannot touch the players' balances) minus 100 finney (ensure that oraclize fees can be paid)
1254      * */
1255     function collectFees(uint128 amount){
1256         if(!(msg.sender==owner)) throw;
1257         uint collectedFees = getFees();
1258         if(amount + 100 finney < collectedFees){
1259             if(!owner.send(amount)) throw;
1260         }
1261     }
1262     
1263     /**
1264      * pays out the players and kills the game.
1265      * */
1266     function stop(){
1267         if(!(msg.sender==owner)) throw;
1268         for(uint16 i = 0; i< numPlayers; i++){
1269             payout(players[i]);
1270         }
1271         kill();
1272     }
1273     
1274     /**
1275      * adds a new animal type to the game
1276      * max. number of animal types: 100
1277      * the cost may not be lower than costs[0]
1278      * */
1279     function addAnimalType(uint128 cost, uint8 fee){
1280         if(!(msg.sender==owner)||cost<costs[0]||costs.length>=100) throw;
1281         costs.push(cost);
1282         fees.push(fee);
1283         values.push(cost/100*fee);
1284         probabilityFactors.push(uint8(cost/costs[0]));
1285     }
1286     
1287  
1288    
1289    /****************** GETTERS *************************/
1290     
1291     
1292     function getWinBalancesOf(address playerAddress) constant returns(uint128){
1293         return winBalances[playerAddress];
1294     }
1295     
1296     function getAnimals(uint8 animalType) constant returns(address[]){
1297         return animals[animalType];
1298     }
1299     
1300     function getFees() constant returns(uint){
1301         uint reserved = 0;
1302         for(uint16 j = 0; j< numPlayers; j++)
1303             reserved+=winBalances[players[j]];
1304         return address(this).balance - reserved;
1305     }
1306 
1307     function getNumAnimalsXType(uint8 animalType) constant returns(uint16){
1308         return numAnimalsXType[animalType];
1309     }
1310     
1311     function getNumAnimalsXPlayer(address playerAddress) constant returns(uint16){
1312         return numAnimalsXPlayer[playerAddress];
1313     }
1314     
1315    /* function getNumAnimalsXPlayerXType(address playerAddress, uint8 animalType) constant returns(uint16){
1316         return numAnimalsXPlayerXType[playerAddress][animalType];
1317     }
1318     */
1319     /****************** SETTERS *************************/
1320     
1321     function setOraclizeGas(uint32 newGas){
1322         if(!(msg.sender==owner)) throw;
1323     	oraclizeGas = newGas;
1324     }
1325     
1326     function setMaxAnimals(uint16 number){
1327         if(!(msg.sender==owner)) throw;
1328     	maxAnimals = number;
1329     }
1330     
1331     /************* HELPERS ****************/
1332 
1333     /**
1334      * maps a given number to the new range (old range 10000)
1335      * */
1336     function mapToNewRange(uint number, uint range) constant internal returns (uint16 randomNumber) {
1337         return uint16(number*range / 10000);
1338     }
1339     
1340     /**
1341      * converts a string of numbers being separated by a given delimiter into an array of numbers (#howmany) 
1342      */
1343      function getNumbersFromString(string s, string delimiter, uint16 howmany) constant internal returns(uint16[] numbers){
1344          strings.slice memory myresult = s.toSlice();
1345          strings.slice memory delim = delimiter.toSlice();
1346          numbers = new uint16[](howmany);
1347          for(uint8 i = 0; i < howmany; i++){
1348              numbers[i]= uint16(parseInt(myresult.split(delim).toString())); 
1349          }
1350          return numbers;
1351      }
1352     
1353 }