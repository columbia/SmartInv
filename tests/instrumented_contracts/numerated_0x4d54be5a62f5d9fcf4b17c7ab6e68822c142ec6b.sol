1 /**
2  * 
3  *	@title 	FlightDelay contract
4  *	@author	Christoph Mussenbrock, Stephan Karpischek
5  *	
6  *  @brief 	This is a smart contract modelling the financial compensation of 
7  *			delayed flights. People can apply for a policy and get automatically 
8  *			paid in case a plane is late. Probabilities are calculated based on
9  *			public accessible information from http://www.flightstats.com. 
10  *			Real time flight status information is also pulled from the 
11  *			same source.
12  *			A frontend for the contract is running on http://fdi.etherisc.com.
13  *	
14  *	@copyright (c) 2016 by the authors.
15  *
16  *	@remark To view the contract code, you have to scroll down past
17  *  		the imported interfaces. 
18  * 
19  */
20 
21 /**************************************************************************
22  *
23  *	Oraclize API
24  *
25  **************************************************************************/
26  
27 // <ORACLIZE_API>
28 /*
29 Copyright (c) 2015-2016 Oraclize srl, Thomas Bertani
30 
31 
32 
33 Permission is hereby granted, free of charge, to any person obtaining a copy
34 of this software and associated documentation files (the "Software"), to deal
35 in the Software without restriction, including without limitation the rights
36 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
37 copies of the Software, and to permit persons to whom the Software is
38 furnished to do so, subject to the following conditions:
39 
40 
41 
42 The above copyright notice and this permission notice shall be included in
43 all copies or substantial portions of the Software.
44 
45 
46 
47 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
48 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
49 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
50 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
51 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
52 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
53 THE SOFTWARE.
54 */
55 
56 contract OraclizeI {
57     address public cbAddress;
58     function query(uint _timestamp, string _datasource, string _arg) returns (bytes32 _id);
59     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) returns (bytes32 _id);
60     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) returns (bytes32 _id);
61     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) returns (bytes32 _id);
62     function getPrice(string _datasource) returns (uint _dsprice);
63     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
64     function useCoupon(string _coupon);
65     function setProofType(byte _proofType);
66     function setCustomGasPrice(uint _gasPrice);
67 }
68 contract OraclizeAddrResolverI {
69     function getAddress() returns (address _addr);
70 }
71 contract usingOraclize {
72     uint constant day = 60*60*24;
73     uint constant week = 60*60*24*7;
74     uint constant month = 60*60*24*30;
75     byte constant proofType_NONE = 0x00;
76     byte constant proofType_TLSNotary = 0x10;
77     byte constant proofStorage_IPFS = 0x01;
78     uint8 constant networkID_auto = 0;
79     uint8 constant networkID_mainnet = 1;
80     uint8 constant networkID_testnet = 2;
81     uint8 constant networkID_morden = 2;
82     uint8 constant networkID_consensys = 161;
83 
84     OraclizeAddrResolverI OAR;
85     
86     OraclizeI oraclize;
87     modifier oraclizeAPI {
88         address oraclizeAddr = OAR.getAddress();
89         if (oraclizeAddr == 0){
90             oraclize_setNetwork(networkID_auto);
91             oraclizeAddr = OAR.getAddress();
92         }
93         oraclize = OraclizeI(oraclizeAddr);
94         _
95     }
96     modifier coupon(string code){
97         oraclize = OraclizeI(OAR.getAddress());
98         oraclize.useCoupon(code);
99         _
100     }
101 
102     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
103         if (getCodeSize(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed)>0){
104             OAR = OraclizeAddrResolverI(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed);
105             return true;
106         }
107         if (getCodeSize(0x9efbea6358bed926b293d2ce63a730d6d98d43dd)>0){
108             OAR = OraclizeAddrResolverI(0x9efbea6358bed926b293d2ce63a730d6d98d43dd);
109             return true;
110         }
111         if (getCodeSize(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf)>0){
112             OAR = OraclizeAddrResolverI(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf);
113             return true;
114         }
115         return false;
116     }
117     
118     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
119         uint price = oraclize.getPrice(datasource);
120         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
121         return oraclize.query.value(price)(0, datasource, arg);
122     }
123     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
124         uint price = oraclize.getPrice(datasource);
125         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
126         return oraclize.query.value(price)(timestamp, datasource, arg);
127     }
128     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
129         uint price = oraclize.getPrice(datasource, gaslimit);
130         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
131         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
132     }
133     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
134         uint price = oraclize.getPrice(datasource, gaslimit);
135         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
136         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
137     }
138     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
139         uint price = oraclize.getPrice(datasource);
140         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
141         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
142     }
143     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
144         uint price = oraclize.getPrice(datasource);
145         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
146         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
147     }
148     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
149         uint price = oraclize.getPrice(datasource, gaslimit);
150         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
151         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
152     }
153     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
154         uint price = oraclize.getPrice(datasource, gaslimit);
155         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
156         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
157     }
158     function oraclize_cbAddress() oraclizeAPI internal returns (address){
159         return oraclize.cbAddress();
160     }
161     function oraclize_setProof(byte proofP) oraclizeAPI internal {
162         return oraclize.setProofType(proofP);
163     }
164     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
165         return oraclize.setCustomGasPrice(gasPrice);
166     }    
167 
168     function getCodeSize(address _addr) constant internal returns(uint _size) {
169         assembly {
170             _size := extcodesize(_addr)
171         }
172     }
173 
174 
175     function parseAddr(string _a) internal returns (address){
176         bytes memory tmp = bytes(_a);
177         uint160 iaddr = 0;
178         uint160 b1;
179         uint160 b2;
180         for (uint i=2; i<2+2*20; i+=2){
181             iaddr *= 256;
182             b1 = uint160(tmp[i]);
183             b2 = uint160(tmp[i+1]);
184             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
185             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
186             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
187             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
188             iaddr += (b1*16+b2);
189         }
190         return address(iaddr);
191     }
192 
193 
194     function strCompare(string _a, string _b) internal returns (int) {
195         bytes memory a = bytes(_a);
196         bytes memory b = bytes(_b);
197         uint minLength = a.length;
198         if (b.length < minLength) minLength = b.length;
199         for (uint i = 0; i < minLength; i ++)
200             if (a[i] < b[i])
201                 return -1;
202             else if (a[i] > b[i])
203                 return 1;
204         if (a.length < b.length)
205             return -1;
206         else if (a.length > b.length)
207             return 1;
208         else
209             return 0;
210    } 
211 
212     function indexOf(string _haystack, string _needle) internal returns (int)
213     {
214         bytes memory h = bytes(_haystack);
215         bytes memory n = bytes(_needle);
216         if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
217             return -1;
218         else if(h.length > (2**128 -1))
219             return -1;                                  
220         else
221         {
222             uint subindex = 0;
223             for (uint i = 0; i < h.length; i ++)
224             {
225                 if (h[i] == n[0])
226                 {
227                     subindex = 1;
228                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
229                     {
230                         subindex++;
231                     }   
232                     if(subindex == n.length)
233                         return int(i);
234                 }
235             }
236             return -1;
237         }   
238     }
239 
240     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
241         bytes memory _ba = bytes(_a);
242         bytes memory _bb = bytes(_b);
243         bytes memory _bc = bytes(_c);
244         bytes memory _bd = bytes(_d);
245         bytes memory _be = bytes(_e);
246         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
247         bytes memory babcde = bytes(abcde);
248         uint k = 0;
249         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
250         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
251         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
252         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
253         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
254         return string(babcde);
255     }
256     
257     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
258         return strConcat(_a, _b, _c, _d, "");
259     }
260 
261     function strConcat(string _a, string _b, string _c) internal returns (string) {
262         return strConcat(_a, _b, _c, "", "");
263     }
264 
265     function strConcat(string _a, string _b) internal returns (string) {
266         return strConcat(_a, _b, "", "", "");
267     }
268 
269     // parseInt
270     function parseInt(string _a) internal returns (uint) {
271         return parseInt(_a, 0);
272     }
273 
274     // parseInt(parseFloat*10^_b)
275     function parseInt(string _a, uint _b) internal returns (uint) {
276         bytes memory bresult = bytes(_a);
277         uint mint = 0;
278         bool decimals = false;
279         for (uint i=0; i<bresult.length; i++){
280             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
281                 if (decimals){
282                    if (_b == 0) break;
283                     else _b--;
284                 }
285                 mint *= 10;
286                 mint += uint(bresult[i]) - 48;
287             } else if (bresult[i] == 46) decimals = true;
288         }
289         if (_b > 0) mint *= 10**_b;
290         return mint;
291     }
292     
293 
294 }
295 // </ORACLIZE_API>
296 
297 
298 /**************************************************************************
299  *
300  *	Arachnid Strings utils.
301  *
302  **************************************************************************/
303 
304 /*
305  * @title String & slice utility library for Solidity contracts.
306  * @author Nick Johnson <arachnid@notdot.net>
307  *
308  * @dev Functionality in this library is largely implemented using an
309  *      abstraction called a 'slice'. A slice represents a part of a string -
310  *      anything from the entire string to a single character, or even no
311  *      characters at all (a 0-length slice). Since a slice only has to specify
312  *      an offset and a length, copying and manipulating slices is a lot less
313  *      expensive than copying and manipulating the strings they reference.
314  *
315  *      To further reduce gas costs, most functions on slice that need to return
316  *      a slice modify the original one instead of allocating a new one; for
317  *      instance, `s.split(".")` will return the text up to the first '.',
318  *      modifying s to only contain the remainder of the string after the '.'.
319  *      In situations where you do not want to modify the original slice, you
320  *      can make a copy first with `.copy()`, for example:
321  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
322  *      Solidity has no memory management, it will result in allocating many
323  *      short-lived slices that are later discarded.
324  *
325  *      Functions that return two slices come in two versions: a non-allocating
326  *      version that takes the second slice as an argument, modifying it in
327  *      place, and an allocating version that allocates and returns the second
328  *      slice; see `nextRune` for example.
329  *
330  *      Functions that have to copy string data will return strings rather than
331  *      slices; these can be cast back to slices for further processing if
332  *      required.
333  *
334  *      For convenience, some functions are provided with non-modifying
335  *      variants that create a new slice and return both; for instance,
336  *      `s.splitNew('.')` leaves s unmodified, and returns two values
337  *      corresponding to the left and right parts of the string.
338  */
339 library strings {
340     struct slice {
341         uint _len;
342         uint _ptr;
343     }
344 
345     function memcpy(uint dest, uint src, uint len) private {
346         // Copy word-length chunks while possible
347         for(; len >= 32; len -= 32) {
348             assembly {
349                 mstore(dest, mload(src))
350             }
351             dest += 32;
352             src += 32;
353         }
354 
355         // Copy remaining bytes
356         uint mask = 256 ** (32 - len) - 1;
357         assembly {
358             let srcpart := and(mload(src), not(mask))
359             let destpart := and(mload(dest), mask)
360             mstore(dest, or(destpart, srcpart))
361         }
362     }
363 
364     /*
365      * @dev Returns a slice containing the entire string.
366      * @param self The string to make a slice from.
367      * @return A newly allocated slice containing the entire string.
368      */
369     function toSlice(string self) internal returns (slice) {
370         uint ptr;
371         assembly {
372             ptr := add(self, 0x20)
373         }
374         return slice(bytes(self).length, ptr);
375     }
376 
377     /*
378      * @dev Returns the length of a null-terminated bytes32 string.
379      * @param self The value to find the length of.
380      * @return The length of the string, from 0 to 32.
381      */
382     function len(bytes32 self) internal returns (uint) {
383         uint ret;
384         if (self == 0)
385             return 0;
386         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
387             ret += 16;
388             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
389         }
390         if (self & 0xffffffffffffffff == 0) {
391             ret += 8;
392             self = bytes32(uint(self) / 0x10000000000000000);
393         }
394         if (self & 0xffffffff == 0) {
395             ret += 4;
396             self = bytes32(uint(self) / 0x100000000);
397         }
398         if (self & 0xffff == 0) {
399             ret += 2;
400             self = bytes32(uint(self) / 0x10000);
401         }
402         if (self & 0xff == 0) {
403             ret += 1;
404         }
405         return 32 - ret;
406     }
407 
408     /*
409      * @dev Returns a slice containing the entire bytes32, interpreted as a
410      *      null-termintaed utf-8 string.
411      * @param self The bytes32 value to convert to a slice.
412      * @return A new slice containing the value of the input argument up to the
413      *         first null.
414      */
415     function toSliceB32(bytes32 self) internal returns (slice ret) {
416         // Allocate space for `self` in memory, copy it there, and point ret at it
417         assembly {
418             let ptr := mload(0x40)
419             mstore(0x40, add(ptr, 0x20))
420             mstore(ptr, self)
421             mstore(add(ret, 0x20), ptr)
422         }
423         ret._len = len(self);
424     }
425 
426     /*
427      * @dev Returns a new slice containing the same data as the current slice.
428      * @param self The slice to copy.
429      * @return A new slice containing the same data as `self`.
430      */
431     function copy(slice self) internal returns (slice) {
432         return slice(self._len, self._ptr);
433     }
434 
435     /*
436      * @dev Copies a slice to a new string.
437      * @param self The slice to copy.
438      * @return A newly allocated string containing the slice's text.
439      */
440     function toString(slice self) internal returns (string) {
441         var ret = new string(self._len);
442         uint retptr;
443         assembly { retptr := add(ret, 32) }
444 
445         memcpy(retptr, self._ptr, self._len);
446         return ret;
447     }
448 
449     /*
450      * @dev Returns the length in runes of the slice. Note that this operation
451      *      takes time proportional to the length of the slice; avoid using it
452      *      in loops, and call `slice.empty()` if you only need to know whether
453      *      the slice is empty or not.
454      * @param self The slice to operate on.
455      * @return The length of the slice in runes.
456      */
457     function len(slice self) internal returns (uint) {
458         // Starting at ptr-31 means the LSB will be the byte we care about
459         var ptr = self._ptr - 31;
460         var end = ptr + self._len;
461         for (uint len = 0; ptr < end; len++) {
462             uint8 b;
463             assembly { b := and(mload(ptr), 0xFF) }
464             if (b < 0x80) {
465                 ptr += 1;
466             } else if(b < 0xE0) {
467                 ptr += 2;
468             } else if(b < 0xF0) {
469                 ptr += 3;
470             } else if(b < 0xF8) {
471                 ptr += 4;
472             } else if(b < 0xFC) {
473                 ptr += 5;
474             } else {
475                 ptr += 6;
476             }
477         }
478         return len;
479     }
480 
481     /*
482      * @dev Returns true if the slice is empty (has a length of 0).
483      * @param self The slice to operate on.
484      * @return True if the slice is empty, False otherwise.
485      */
486     function empty(slice self) internal returns (bool) {
487         return self._len == 0;
488     }
489 
490     /*
491      * @dev Returns a positive number if `other` comes lexicographically after
492      *      `self`, a negative number if it comes before, or zero if the
493      *      contents of the two slices are equal. Comparison is done per-rune,
494      *      on unicode codepoints.
495      * @param self The first slice to compare.
496      * @param other The second slice to compare.
497      * @return The result of the comparison.
498      */
499     function compare(slice self, slice other) internal returns (int) {
500         uint shortest = self._len;
501         if (other._len < self._len)
502             shortest = other._len;
503 
504         var selfptr = self._ptr;
505         var otherptr = other._ptr;
506         for (uint idx = 0; idx < shortest; idx += 32) {
507             uint a;
508             uint b;
509             assembly {
510                 a := mload(selfptr)
511                 b := mload(otherptr)
512             }
513             if (a != b) {
514                 // Mask out irrelevant bytes and check again
515                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
516                 var diff = (a & mask) - (b & mask);
517                 if (diff != 0)
518                     return int(diff);
519             }
520             selfptr += 32;
521             otherptr += 32;
522         }
523         return int(self._len) - int(other._len);
524     }
525 
526     /*
527      * @dev Returns true if the two slices contain the same text.
528      * @param self The first slice to compare.
529      * @param self The second slice to compare.
530      * @return True if the slices are equal, false otherwise.
531      */
532     function equals(slice self, slice other) internal returns (bool) {
533         return compare(self, other) == 0;
534     }
535 
536     /*
537      * @dev Extracts the first rune in the slice into `rune`, advancing the
538      *      slice to point to the next rune and returning `self`.
539      * @param self The slice to operate on.
540      * @param rune The slice that will contain the first rune.
541      * @return `rune`.
542      */
543     function nextRune(slice self, slice rune) internal returns (slice) {
544         rune._ptr = self._ptr;
545 
546         if (self._len == 0) {
547             rune._len = 0;
548             return rune;
549         }
550 
551         uint len;
552         uint b;
553         // Load the first byte of the rune into the LSBs of b
554         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
555         if (b < 0x80) {
556             len = 1;
557         } else if(b < 0xE0) {
558             len = 2;
559         } else if(b < 0xF0) {
560             len = 3;
561         } else {
562             len = 4;
563         }
564 
565         // Check for truncated codepoints
566         if (len > self._len) {
567             rune._len = self._len;
568             self._ptr += self._len;
569             self._len = 0;
570             return rune;
571         }
572 
573         self._ptr += len;
574         self._len -= len;
575         rune._len = len;
576         return rune;
577     }
578 
579     /*
580      * @dev Returns the first rune in the slice, advancing the slice to point
581      *      to the next rune.
582      * @param self The slice to operate on.
583      * @return A slice containing only the first rune from `self`.
584      */
585     function nextRune(slice self) internal returns (slice ret) {
586         nextRune(self, ret);
587     }
588 
589     /*
590      * @dev Returns the number of the first codepoint in the slice.
591      * @param self The slice to operate on.
592      * @return The number of the first codepoint in the slice.
593      */
594     function ord(slice self) internal returns (uint ret) {
595         if (self._len == 0) {
596             return 0;
597         }
598 
599         uint word;
600         uint len;
601         uint div = 2 ** 248;
602 
603         // Load the rune into the MSBs of b
604         assembly { word:= mload(mload(add(self, 32))) }
605         var b = word / div;
606         if (b < 0x80) {
607             ret = b;
608             len = 1;
609         } else if(b < 0xE0) {
610             ret = b & 0x1F;
611             len = 2;
612         } else if(b < 0xF0) {
613             ret = b & 0x0F;
614             len = 3;
615         } else {
616             ret = b & 0x07;
617             len = 4;
618         }
619 
620         // Check for truncated codepoints
621         if (len > self._len) {
622             return 0;
623         }
624 
625         for (uint i = 1; i < len; i++) {
626             div = div / 256;
627             b = (word / div) & 0xFF;
628             if (b & 0xC0 != 0x80) {
629                 // Invalid UTF-8 sequence
630                 return 0;
631             }
632             ret = (ret * 64) | (b & 0x3F);
633         }
634 
635         return ret;
636     }
637 
638     /*
639      * @dev Returns the keccak-256 hash of the slice.
640      * @param self The slice to hash.
641      * @return The hash of the slice.
642      */
643     function keccak(slice self) internal returns (bytes32 ret) {
644         assembly {
645             ret := sha3(mload(add(self, 32)), mload(self))
646         }
647     }
648 
649     /*
650      * @dev Returns true if `self` starts with `needle`.
651      * @param self The slice to operate on.
652      * @param needle The slice to search for.
653      * @return True if the slice starts with the provided text, false otherwise.
654      */
655     function startsWith(slice self, slice needle) internal returns (bool) {
656         if (self._len < needle._len) {
657             return false;
658         }
659 
660         if (self._ptr == needle._ptr) {
661             return true;
662         }
663 
664         bool equal;
665         assembly {
666             let len := mload(needle)
667             let selfptr := mload(add(self, 0x20))
668             let needleptr := mload(add(needle, 0x20))
669             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
670         }
671         return equal;
672     }
673 
674     /*
675      * @dev If `self` starts with `needle`, `needle` is removed from the
676      *      beginning of `self`. Otherwise, `self` is unmodified.
677      * @param self The slice to operate on.
678      * @param needle The slice to search for.
679      * @return `self`
680      */
681     function beyond(slice self, slice needle) internal returns (slice) {
682         if (self._len < needle._len) {
683             return self;
684         }
685 
686         bool equal = true;
687         if (self._ptr != needle._ptr) {
688             assembly {
689                 let len := mload(needle)
690                 let selfptr := mload(add(self, 0x20))
691                 let needleptr := mload(add(needle, 0x20))
692                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
693             }
694         }
695 
696         if (equal) {
697             self._len -= needle._len;
698             self._ptr += needle._len;
699         }
700 
701         return self;
702     }
703 
704     /*
705      * @dev Returns true if the slice ends with `needle`.
706      * @param self The slice to operate on.
707      * @param needle The slice to search for.
708      * @return True if the slice starts with the provided text, false otherwise.
709      */
710     function endsWith(slice self, slice needle) internal returns (bool) {
711         if (self._len < needle._len) {
712             return false;
713         }
714 
715         var selfptr = self._ptr + self._len - needle._len;
716 
717         if (selfptr == needle._ptr) {
718             return true;
719         }
720 
721         bool equal;
722         assembly {
723             let len := mload(needle)
724             let needleptr := mload(add(needle, 0x20))
725             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
726         }
727 
728         return equal;
729     }
730 
731     /*
732      * @dev If `self` ends with `needle`, `needle` is removed from the
733      *      end of `self`. Otherwise, `self` is unmodified.
734      * @param self The slice to operate on.
735      * @param needle The slice to search for.
736      * @return `self`
737      */
738     function until(slice self, slice needle) internal returns (slice) {
739         if (self._len < needle._len) {
740             return self;
741         }
742 
743         var selfptr = self._ptr + self._len - needle._len;
744         bool equal = true;
745         if (selfptr != needle._ptr) {
746             assembly {
747                 let len := mload(needle)
748                 let needleptr := mload(add(needle, 0x20))
749                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
750             }
751         }
752 
753         if (equal) {
754             self._len -= needle._len;
755         }
756 
757         return self;
758     }
759 
760     // Returns the memory address of the first byte of the first occurrence of
761     // `needle` in `self`, or the first byte after `self` if not found.
762     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
763         uint ptr;
764         uint idx;
765 
766         if (needlelen <= selflen) {
767             if (needlelen <= 32) {
768                 // Optimized assembly for 68 gas per byte on short strings
769                 assembly {
770                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
771                     let needledata := and(mload(needleptr), mask)
772                     let end := add(selfptr, sub(selflen, needlelen))
773                     ptr := selfptr
774                     loop:
775                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
776                     ptr := add(ptr, 1)
777                     jumpi(loop, lt(sub(ptr, 1), end))
778                     ptr := add(selfptr, selflen)
779                     exit:
780                 }
781                 return ptr;
782             } else {
783                 // For long needles, use hashing
784                 bytes32 hash;
785                 assembly { hash := sha3(needleptr, needlelen) }
786                 ptr = selfptr;
787                 for (idx = 0; idx <= selflen - needlelen; idx++) {
788                     bytes32 testHash;
789                     assembly { testHash := sha3(ptr, needlelen) }
790                     if (hash == testHash)
791                         return ptr;
792                     ptr += 1;
793                 }
794             }
795         }
796         return selfptr + selflen;
797     }
798 
799     // Returns the memory address of the first byte after the last occurrence of
800     // `needle` in `self`, or the address of `self` if not found.
801     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
802         uint ptr;
803 
804         if (needlelen <= selflen) {
805             if (needlelen <= 32) {
806                 // Optimized assembly for 69 gas per byte on short strings
807                 assembly {
808                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
809                     let needledata := and(mload(needleptr), mask)
810                     ptr := add(selfptr, sub(selflen, needlelen))
811                     loop:
812                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
813                     ptr := sub(ptr, 1)
814                     jumpi(loop, gt(add(ptr, 1), selfptr))
815                     ptr := selfptr
816                     jump(exit)
817                     ret:
818                     ptr := add(ptr, needlelen)
819                     exit:
820                 }
821                 return ptr;
822             } else {
823                 // For long needles, use hashing
824                 bytes32 hash;
825                 assembly { hash := sha3(needleptr, needlelen) }
826                 ptr = selfptr + (selflen - needlelen);
827                 while (ptr >= selfptr) {
828                     bytes32 testHash;
829                     assembly { testHash := sha3(ptr, needlelen) }
830                     if (hash == testHash)
831                         return ptr + needlelen;
832                     ptr -= 1;
833                 }
834             }
835         }
836         return selfptr;
837     }
838 
839     /*
840      * @dev Modifies `self` to contain everything from the first occurrence of
841      *      `needle` to the end of the slice. `self` is set to the empty slice
842      *      if `needle` is not found.
843      * @param self The slice to search and modify.
844      * @param needle The text to search for.
845      * @return `self`.
846      */
847     function find(slice self, slice needle) internal returns (slice) {
848         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
849         self._len -= ptr - self._ptr;
850         self._ptr = ptr;
851         return self;
852     }
853 
854     /*
855      * @dev Modifies `self` to contain the part of the string from the start of
856      *      `self` to the end of the first occurrence of `needle`. If `needle`
857      *      is not found, `self` is set to the empty slice.
858      * @param self The slice to search and modify.
859      * @param needle The text to search for.
860      * @return `self`.
861      */
862     function rfind(slice self, slice needle) internal returns (slice) {
863         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
864         self._len = ptr - self._ptr;
865         return self;
866     }
867 
868     /*
869      * @dev Splits the slice, setting `self` to everything after the first
870      *      occurrence of `needle`, and `token` to everything before it. If
871      *      `needle` does not occur in `self`, `self` is set to the empty slice,
872      *      and `token` is set to the entirety of `self`.
873      * @param self The slice to split.
874      * @param needle The text to search for in `self`.
875      * @param token An output parameter to which the first token is written.
876      * @return `token`.
877      */
878     function split(slice self, slice needle, slice token) internal returns (slice) {
879         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
880         token._ptr = self._ptr;
881         token._len = ptr - self._ptr;
882         if (ptr == self._ptr + self._len) {
883             // Not found
884             self._len = 0;
885         } else {
886             self._len -= token._len + needle._len;
887             self._ptr = ptr + needle._len;
888         }
889         return token;
890     }
891 
892     /*
893      * @dev Splits the slice, setting `self` to everything after the first
894      *      occurrence of `needle`, and returning everything before it. If
895      *      `needle` does not occur in `self`, `self` is set to the empty slice,
896      *      and the entirety of `self` is returned.
897      * @param self The slice to split.
898      * @param needle The text to search for in `self`.
899      * @return The part of `self` up to the first occurrence of `delim`.
900      */
901     function split(slice self, slice needle) internal returns (slice token) {
902         split(self, needle, token);
903     }
904 
905     /*
906      * @dev Splits the slice, setting `self` to everything before the last
907      *      occurrence of `needle`, and `token` to everything after it. If
908      *      `needle` does not occur in `self`, `self` is set to the empty slice,
909      *      and `token` is set to the entirety of `self`.
910      * @param self The slice to split.
911      * @param needle The text to search for in `self`.
912      * @param token An output parameter to which the first token is written.
913      * @return `token`.
914      */
915     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
916         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
917         token._ptr = ptr;
918         token._len = self._len - (ptr - self._ptr);
919         if (ptr == self._ptr) {
920             // Not found
921             self._len = 0;
922         } else {
923             self._len -= token._len + needle._len;
924         }
925         return token;
926     }
927 
928     /*
929      * @dev Splits the slice, setting `self` to everything before the last
930      *      occurrence of `needle`, and returning everything after it. If
931      *      `needle` does not occur in `self`, `self` is set to the empty slice,
932      *      and the entirety of `self` is returned.
933      * @param self The slice to split.
934      * @param needle The text to search for in `self`.
935      * @return The part of `self` after the last occurrence of `delim`.
936      */
937     function rsplit(slice self, slice needle) internal returns (slice token) {
938         rsplit(self, needle, token);
939     }
940 
941     /*
942      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
943      * @param self The slice to search.
944      * @param needle The text to search for in `self`.
945      * @return The number of occurrences of `needle` found in `self`.
946      */
947     function count(slice self, slice needle) internal returns (uint count) {
948         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
949         while (ptr <= self._ptr + self._len) {
950             count++;
951             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
952         }
953     }
954 
955     /*
956      * @dev Returns True if `self` contains `needle`.
957      * @param self The slice to search.
958      * @param needle The text to search for in `self`.
959      * @return True if `needle` is found in `self`, false otherwise.
960      */
961     function contains(slice self, slice needle) internal returns (bool) {
962         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
963     }
964 
965     /*
966      * @dev Returns a newly allocated string containing the concatenation of
967      *      `self` and `other`.
968      * @param self The first slice to concatenate.
969      * @param other The second slice to concatenate.
970      * @return The concatenation of the two strings.
971      */
972     function concat(slice self, slice other) internal returns (string) {
973         var ret = new string(self._len + other._len);
974         uint retptr;
975         assembly { retptr := add(ret, 32) }
976         memcpy(retptr, self._ptr, self._len);
977         memcpy(retptr + self._len, other._ptr, other._len);
978         return ret;
979     }
980 
981     /*
982      * @dev Joins an array of slices, using `self` as a delimiter, returning a
983      *      newly allocated string.
984      * @param self The delimiter to use.
985      * @param parts A list of slices to join.
986      * @return A newly allocated string containing all the slices in `parts`,
987      *         joined with `self`.
988      */
989     function join(slice self, slice[] parts) internal returns (string) {
990         if (parts.length == 0)
991             return "";
992 
993         uint len = self._len * (parts.length - 1);
994         for(uint i = 0; i < parts.length; i++)
995             len += parts[i]._len;
996 
997         var ret = new string(len);
998         uint retptr;
999         assembly { retptr := add(ret, 32) }
1000 
1001         for(i = 0; i < parts.length; i++) {
1002             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1003             retptr += parts[i]._len;
1004             if (i < parts.length - 1) {
1005                 memcpy(retptr, self._ptr, self._len);
1006                 retptr += self._len;
1007             }
1008         }
1009 
1010         return ret;
1011     }
1012 }
1013 
1014 
1015 /**************************************************************************
1016  * 
1017  *	Contract code starts here. 
1018  * 
1019  **************************************************************************/
1020 
1021 /*
1022 
1023 	FlightDelay with Oraclized Underwriting and Payout
1024 	All times are UTC.
1025 	Copyright (C) Christoph Mussenbrock, Stephan Karpischek
1026 	
1027 */
1028 
1029 contract FlightDelay is usingOraclize {
1030 
1031 	using strings for *;
1032 
1033 	modifier noEther { if (msg.value > 0) throw; _ }
1034 	modifier onlyOwner { if (msg.sender != owner) throw; _ }
1035 	modifier onlyOraclize {	if (msg.sender != oraclize_cbAddress()) throw; _ }
1036 
1037 	modifier onlyInState (uint _policyId, policyState _state) {
1038 
1039 		policy p = policies[_policyId];
1040 		if (p.state != _state) throw;
1041 		_
1042 
1043 	}
1044 
1045 	modifier onlyCustomer(uint _policyId) {
1046 
1047 		policy p = policies[_policyId];
1048 		if (p.customer != msg.sender) throw;
1049 		_
1050 
1051 	}
1052 
1053 	modifier notInMaintenance {
1054 		healthCheck();
1055 		if (maintenance_mode >= maintenance_Emergency) throw;
1056 		_
1057 	}
1058 
1059 	// the following modifier is always checked at last, so previous modifiers
1060 	// may throw without affecting reentrantGuard
1061 	modifier noReentrant {
1062 		if (reentrantGuard) throw;
1063 		reentrantGuard = true;
1064 		_
1065 		reentrantGuard = false;
1066 	}
1067 
1068 	// policy Status Codes and meaning:
1069 	//
1070 	// 00 = Applied:	the customer has payed a premium, but the oracle has
1071 	//					not yet checked and confirmed.
1072 	//					The customer can still revoke the policy.
1073 	// 01 = Accepted:	the oracle has checked and confirmed.
1074 	//					The customer can still revoke the policy.
1075 	// 02 = Revoked:	The customer has revoked the policy.
1076 	//					The premium minus cancellation fee is payed back to the
1077 	//					customer by the oracle.
1078 	// 03 = PaidOut:	The flight has ended with delay.
1079 	//					The oracle has checked and payed out.
1080 	// 04 = Expired:	The flight has endet with <15min. delay.
1081 	//					No payout.
1082 	// 05 = Declined:	The application was invalid.
1083 	//					The premium minus cancellation fee is payed back to the
1084 	//					customer by the oracle.
1085 	// 06 = SendFailed:	During Revoke, Decline or Payout, sending ether failed
1086 	//					for unknown reasons.
1087 	//					The funds remain in the contracts RiskFund.
1088 
1089 
1090 	//                  00       01        02       03
1091 	enum policyState {Applied, Accepted, Revoked, PaidOut,
1092 	//					04      05           06
1093 					  Expired, Declined, SendFailed}
1094 
1095 	// oraclize callback types:
1096 	enum oraclizeState { ForUnderwriting, ForPayout }
1097 
1098 	event LOG_PolicyApplied(
1099 		uint policyId,
1100 		address customer,
1101 		string carrierFlightNumber,
1102 		uint premium
1103 	);
1104 	event LOG_PolicyAccepted(
1105 		uint policyId,
1106 		uint statistics0,
1107 		uint statistics1,
1108 		uint statistics2,
1109 		uint statistics3,
1110 		uint statistics4,
1111 		uint statistics5
1112 	);
1113 	event LOG_PolicyRevoked(
1114 		uint policyId
1115 	);
1116 	event LOG_PolicyPaidOut(
1117 		uint policyId,
1118 		uint amount
1119 	);
1120 	event LOG_PolicyExpired(
1121 		uint policyId
1122 	);
1123 	event LOG_PolicyDeclined(
1124 		uint policyId,
1125 		bytes32 reason
1126 	);
1127 	event LOG_PolicyManualPayout(
1128 		uint policyId,
1129 		bytes32 reason
1130 	);
1131 	event LOG_SendFail(
1132 		uint policyId,
1133 		bytes32 reason
1134 	);
1135 	event LOG_OraclizeCall(
1136 		uint policyId,
1137 		bytes32 queryId,
1138 		string oraclize_url
1139 	);
1140 	event LOG_OraclizeCallback(
1141 		uint policyId,
1142 		bytes32 queryId,
1143 		string result,
1144 		bytes proof
1145 	);
1146 	event LOG_HealthCheck(
1147 		bytes32 message, 
1148 		int diff,
1149 		uint balance,
1150 		int ledgerBalance 
1151 	);
1152 
1153 	// some general constants for the system:
1154 	// minimum observations for valid prediction
1155 	uint constant minObservations 			= 10;
1156 	// minimum premium to cover costs
1157 	uint constant minPremium 				= 500 finney;
1158 	// maximum premium
1159 	uint constant maxPremium 				= 5 ether;
1160 	// maximum payout
1161 	uint constant maxPayout 				= 150 ether;
1162 	// maximum cumulated weighted premium per risk
1163 	uint maxCumulatedWeightedPremium		= 300 ether; 
1164 	// 1 percent for DAO, 1 percent for maintainer
1165 	uint8 constant rewardPercent 			= 2;
1166 	// reserve for tail risks
1167 	uint8 constant reservePercent 			= 1;
1168 	// the weight pattern; in future versions this may become part of the policy struct.
1169 	// currently can't be constant because of compiler restrictions
1170 	// weightPattern[0] is not used, just to be consistent
1171     uint8[6] weightPattern 					= [0, 10,20,30,50,50];
1172 	// Deadline for acceptance of policies: Mon, 26 Sep 2016 12:00:00 GMT
1173 	uint contractDeadline 					= 1474891200; 
1174 
1175 	// account numbers for the internal ledger:
1176 	// sum of all Premiums of all currently active policies
1177 	uint8 constant acc_Premium 				= 0;
1178 	// Risk fund; serves as reserve for tail risks
1179 	uint8 constant acc_RiskFund 			= 1;
1180 	// sum of all payed out policies
1181 	uint8 constant acc_Payout 				= 2;
1182 	// the balance of the contract (negative!!)
1183 	uint8 constant acc_Balance 				= 3;
1184 	// the reward account for DAO and maintainer
1185 	uint8 constant acc_Reward 				= 4;
1186 	// oraclize costs
1187 	uint8 constant acc_OraclizeCosts 		= 5;
1188 	// when adding more accounts, remember to increase ledger array length
1189 
1190 	// Maintenance modes 
1191 	uint8 constant maintenance_None      	= 0;
1192 	uint8 constant maintenance_BalTooHigh 	= 1;
1193 	uint8 constant maintenance_Emergency 	= 255;
1194 	
1195 	
1196 	// gas Constants for oraclize
1197 	uint constant oraclizeGas 				= 500000;
1198 
1199 	// URLs and query strings for oraclize
1200 
1201 	string constant oraclize_RatingsBaseUrl =
1202 		"[URL] json(https://api.flightstats.com/flex/ratings/rest/v1/json/flight/";
1203 	string constant oraclizeRatingsQuery =
1204 		"?${[decrypt] BGHdZ9cDNIfZogzCYUU+esupKmGPoVvNE38mj1ELQZHv9MybFpzBp90QQN6j33fzU2UvvX/NqE02z1bGJ9yY5X3Az/dLou0DdWTc/Pu9vYXaq8oTuq9Zyqjg+VQ9T6k/OrASsgCF8P9z+/vW3FO5odhpmqCrwUpvLZTAbhcNyCYjbnA16XUW}).ratings[0]['observations','late15','late30','late45','cancelled','diverted']";
1205 
1206 	// [URL] json(https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/status/LH/410/dep/2016/09/01?appId={appId}&appKey={appKey})
1207 	string constant oraclize_StatusBaseUrl =
1208 	  "[URL] json(https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/status/";
1209 	string constant oraclizeStatusQuery =
1210 		"?${[decrypt] BGHdZ9cDNIfZogzCYUU+esupKmGPoVvNE38mj1ELQZHv9MybFpzBp90QQN6j33fzU2UvvX/NqE02z1bGJ9yY5X3Az/dLou0DdWTc/Pu9vYXaq8oTuq9Zyqjg+VQ9T6k/OrASsgCF8P9z+/vW3FO5odhpmqCrwUpvLZTAbhcNyCYjbnA16XUW}).flightStatuses[0]['status','delays','operationalTimes']";
1211 
1212 
1213 	// the policy structure: this structure keeps track of the individual parameters of a policy.
1214 	// typically customer address, premium and some status information.
1215 
1216 	struct policy {
1217 
1218 		// 0 - the customer
1219 		address customer;
1220 		// 1 - premium
1221 		uint premium;
1222 
1223 		// risk specific parameters:
1224 		// 2 - pointer to the risk in the risks mapping
1225 		bytes32 riskId;
1226 		// custom payout pattern
1227 		// in future versions, customer will be able to tamper with this array.
1228 		// to keep things simple, we have decided to hard-code the array for all policies.
1229 		// uint8[5] pattern;
1230 		// 3 - probability weight. this is the central parameter
1231 		uint weight;
1232 		// 4 - calculated Payout
1233 		uint calculatedPayout;
1234 		// 5 - actual Payout
1235 		uint actualPayout;
1236 
1237 		// status fields:
1238 		// 6 - the state of the policy
1239 		policyState state;
1240 		// 7 - time of last state change
1241 		uint stateTime;
1242 		// 8 - state change message/reason
1243 		bytes32 stateMessage;
1244 		// 9 - TLSNotary Proof
1245 		bytes proof;
1246 	}
1247 
1248 	// the risk structure; this structure keeps track of the risk-
1249 	// specific parameters.
1250 	// several policies can share the same risk structure (typically 
1251 	// some people flying with the same plane)
1252 
1253 	struct risk {
1254 
1255 		// 0 - Airline Code + FlightNumber
1256 		string carrierFlightNumber;
1257 		// 1 - scheduled departure and arrival time in the format /dep/YYYY/MM/DD
1258 		string departureYearMonthDay;
1259 		// 2 - the inital arrival time
1260 		uint arrivalTime;
1261 		// 3 - the final delay in minutes
1262 		uint delayInMinutes;
1263 		// 4 - the determined delay category (0-5)
1264 		uint8 delay;
1265 		// 5 - we limit the cumulated weighted premium to avoid cluster risks
1266 		uint cumulatedWeightedPremium;
1267 		// 6 - max cumulated Payout for this risk
1268 		uint premiumMultiplier;
1269 	}
1270 
1271 	// the oraclize callback structure: we use several oraclize calls.
1272 	// all oraclize calls will result in a common callback to __callback(...).
1273 	// to keep track of the different querys we have to introduce this struct.
1274 
1275 	struct oraclizeCallback {
1276 
1277 		// for which policy have we called?
1278 		uint policyId;
1279 		// for which purpose did we call? {ForUnderwrite | ForPayout}
1280 		oraclizeState oState;
1281 		uint oraclizeTime;
1282 
1283 	}
1284 
1285 	address public owner;
1286 
1287 	// Table of policies
1288 	policy[] public policies;
1289 	// Lookup policyIds from customer addresses
1290 	mapping (address => uint[]) public customerPolicies;
1291 	// Lookup policy Ids from queryIds
1292 	mapping (bytes32 => oraclizeCallback) public oraclizeCallbacks;
1293 	mapping (bytes32 => risk) public risks;
1294 	// Internal ledger
1295 	int[6] public ledger;
1296 
1297 	// invariant: acc_Premium + acc_RiskFund + acc_Payout
1298 	//						+ acc_Balance + acc_Reward == 0
1299 
1300 	// Mutex
1301 	bool public reentrantGuard;
1302 	uint8 public maintenance_mode;
1303 
1304 	function healthCheck() internal {
1305 		int diff = int(this.balance-msg.value) + ledger[acc_Balance];
1306 		if (diff == 0) {
1307 			return; // everything ok.
1308 		}
1309 		if (diff > 0) {
1310 			LOG_HealthCheck('Balance too high', diff, this.balance, ledger[acc_Balance]);
1311 			maintenance_mode = maintenance_BalTooHigh;
1312 		} else {
1313 			LOG_HealthCheck('Balance too low', diff, this.balance, ledger[acc_Balance]);
1314 			maintenance_mode = maintenance_Emergency;
1315 		}
1316 	}
1317 
1318 	// manually perform healthcheck.
1319 	// @param _maintenance_mode: 
1320 	// 		0 = reset maintenance_mode, even in emergency
1321 	// 		1 = perform health check
1322 	//    255 = set maintenance_mode to maintenance_emergency (no newPolicy anymore)
1323 	function performHealthCheck(uint8 _maintenance_mode) onlyOwner {
1324 		maintenance_mode = _maintenance_mode;
1325 		if (maintenance_mode > 0 && maintenance_mode < maintenance_Emergency) {
1326 			healthCheck();
1327 		}
1328 	}
1329 
1330 	function payReward() onlyOwner {
1331 
1332 		if (!owner.send(this.balance)) throw;
1333 		maintenance_mode = maintenance_Emergency; // don't accept any policies
1334 
1335 	}
1336 
1337 	function bookkeeping(uint8 _from, uint8 _to, uint _amount) internal {
1338 
1339 		ledger[_from] -= int(_amount);
1340 		ledger[_to] += int(_amount);
1341 
1342 	}
1343 
1344 	// if ledger gets corrupt for unknown reasons, have a way to correct it:
1345 	function audit(uint8 _from, uint8 _to, uint _amount) onlyOwner {
1346 
1347 		bookkeeping (_from, _to, _amount);
1348 
1349 	}
1350 
1351 	function getPolicyCount(address _customer)
1352 		constant returns (uint _count) {
1353 		return policies.length;
1354 	}
1355 
1356 	function getCustomerPolicyCount(address _customer)
1357 		constant returns (uint _count) {
1358 		return customerPolicies[_customer].length;
1359 	}
1360 
1361 	function bookAndCalcRemainingPremium() internal returns (uint) {
1362 
1363 		uint v = msg.value;
1364 		uint reserve = v * reservePercent / 100;
1365 		uint remain = v - reserve;
1366 		uint reward = remain * rewardPercent / 100;
1367 
1368 		bookkeeping(acc_Balance, acc_Premium, v);
1369 		bookkeeping(acc_Premium, acc_RiskFund, reserve);
1370 		bookkeeping(acc_Premium, acc_Reward, reward);
1371 
1372 		return (uint(remain - reward));
1373 
1374 	}
1375 
1376 	// constructor
1377 	function FlightDelay (address _owner) {
1378 
1379 		owner = _owner;
1380 		reentrantGuard = false;
1381 		maintenance_mode = maintenance_None;
1382 
1383 		// initially put all funds in risk fund.
1384 		bookkeeping(acc_Balance, acc_RiskFund, msg.value);
1385 		oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1386 
1387 	}
1388 
1389 	// create new policy
1390 	function newPolicy(
1391 		string _carrierFlightNumber, 
1392 		string _departureYearMonthDay, 
1393 		uint _departureTime, 
1394 		uint _arrivalTime
1395 		) 
1396 		notInMaintenance {
1397 
1398 		// sanity checks:
1399 
1400 		// don't accept too low or too high policies
1401 
1402 		if (msg.value < minPremium || msg.value > maxPremium) {
1403 			LOG_PolicyDeclined(0, 'Invalid premium value');
1404 			if (!msg.sender.send(msg.value)) {
1405 				LOG_SendFail(0, 'newPolicy sendback failed (1)');
1406 			}
1407 			return;
1408 		}
1409 
1410         // don't accept flights with departure time earlier than in 24 hours, 
1411 		// or arrivalTime before departureTime, 
1412 		// or departureTime after Mon, 26 Sep 2016 12:00:00 GMT
1413         if (
1414 			_arrivalTime < _departureTime ||
1415 			_arrivalTime > _departureTime + 2 days ||
1416 			_departureTime < now + 24 hours ||
1417 			_departureTime > contractDeadline) {
1418 			LOG_PolicyDeclined(0, 'Invalid arrival/departure time');
1419 			if (!msg.sender.send(msg.value)) {
1420 				LOG_SendFail(0, 'newPolicy sendback failed (2)');
1421 			}
1422 			return;
1423         }
1424 		
1425 		// accept only a number of maxIdenticalRisks identical risks:
1426 		
1427 		bytes32 riskId = sha3(
1428 			_carrierFlightNumber, 
1429 			_departureYearMonthDay, 
1430 			_arrivalTime
1431 		);
1432 		risk r = risks[riskId];
1433 	
1434 		// roughly check, whether maxCumulatedWeightedPremium will be exceeded
1435 		// (we accept the inaccuracy that the real remaining premium is 3% lower), 
1436 		// but we are conservative;
1437 		// if this is the first policy, the left side will be 0
1438 		if (msg.value * r.premiumMultiplier + r.cumulatedWeightedPremium >= 
1439 			maxCumulatedWeightedPremium) {
1440 			LOG_PolicyDeclined(0, 'Cluster risk');
1441 			if (!msg.sender.send(msg.value)) {
1442 				LOG_SendFail(0, 'newPolicy sendback failed (3)');
1443 			}
1444 			return;
1445 		} else if (r.cumulatedWeightedPremium == 0) {
1446 			// at the first police, we set r.cumulatedWeightedPremium to the max.
1447 			// this prevents further polices to be accepted, until the correct
1448 			// value is calculated after the first callback from the oracle.
1449 			r.cumulatedWeightedPremium = maxCumulatedWeightedPremium;
1450 		}
1451 
1452 		// store or update policy
1453 		uint policyId = policies.length++;
1454 		customerPolicies[msg.sender].push(policyId);
1455 		policy p = policies[policyId];
1456 
1457 		p.customer = msg.sender;
1458 		// the remaining premium after deducting reserve and reward
1459 		p.premium = bookAndCalcRemainingPremium();
1460 		p.riskId = riskId;
1461 
1462 		// store risk parameters
1463 		// Airline Code
1464 		if (r.premiumMultiplier == 0) { // then it is the first call.
1465 			// we have a new struct
1466 			r.carrierFlightNumber = _carrierFlightNumber;
1467 			r.departureYearMonthDay = _departureYearMonthDay;
1468 			r.arrivalTime = _arrivalTime;
1469 		} else { // we cumulate the risk
1470 			r.cumulatedWeightedPremium += p.premium * r.premiumMultiplier;
1471 		}
1472 
1473 		// now we have successfully applied
1474 		p.state = policyState.Applied;
1475 		p.stateMessage = 'Policy applied by customer';
1476 		p.stateTime = now;
1477 		LOG_PolicyApplied(policyId, msg.sender, _carrierFlightNumber, p.premium);
1478 
1479 		// call oraclize to get Flight Stats; this will also call underwrite()
1480 		getFlightStats(policyId, _carrierFlightNumber);
1481 	}
1482 	
1483 	function underwrite(uint _policyId, uint[6] _statistics, bytes _proof) internal {
1484 
1485 		policy p = policies[_policyId]; // throws if _policyId invalid
1486 		uint weight;
1487 		for (uint8 i = 1; i <= 5; i++ ) {
1488 			weight += weightPattern[i] * _statistics[i];
1489 			// 1% = 100 / 100% = 10,000
1490 		}
1491 		// to avoid div0 in the payout section, 
1492 		// we have to make a minimal assumption on p.weight.
1493 		if (weight == 0) { weight = 100000 / _statistics[0]; }
1494 
1495 		risk r = risks[p.riskId];
1496 		// we calculate the factors to limit cluster risks.
1497 		if (r.premiumMultiplier == 0) { 
1498 			// it's the first call, we accept any premium
1499 			r.premiumMultiplier = 100000 / weight;
1500 			r.cumulatedWeightedPremium = p.premium * 100000 / weight;
1501 		}
1502 		
1503 		p.proof = _proof;
1504 		p.weight = weight;
1505 
1506 		// schedule payout Oracle
1507 		schedulePayoutOraclizeCall(
1508 			_policyId, 
1509 			r.carrierFlightNumber, 
1510 			r.departureYearMonthDay, 
1511 			r.arrivalTime + 15 minutes
1512 		);
1513 
1514 		p.state = policyState.Accepted;
1515 		p.stateMessage = 'Policy underwritten by oracle';
1516 		p.stateTime = now;
1517 
1518 		LOG_PolicyAccepted(
1519 			_policyId, 
1520 			_statistics[0], 
1521 			_statistics[1], 
1522 			_statistics[2], 
1523 			_statistics[3], 
1524 			_statistics[4],
1525 			_statistics[5]
1526 		);
1527 
1528 	}
1529 	
1530 	function decline(uint _policyId, bytes32 _reason, bytes _proof)	internal {
1531 
1532 		policy p = policies[_policyId];
1533 
1534 		p.state = policyState.Declined;
1535 		p.stateMessage = _reason;
1536 		p.stateTime = now; // won't be reverted in case of errors
1537 		p.proof = _proof;
1538 		bookkeeping(acc_Premium, acc_Balance, p.premium);
1539 
1540 		if (!p.customer.send(p.premium))  {
1541 			bookkeeping(acc_Balance, acc_RiskFund, p.premium);
1542 			p.state = policyState.SendFailed;
1543 			p.stateMessage = 'decline: Send failed.';
1544 			LOG_SendFail(_policyId, 'decline sendfail');
1545 		}
1546 		else {
1547 			LOG_PolicyDeclined(_policyId, _reason);
1548 		}
1549 
1550 
1551 	}
1552 	
1553 	function schedulePayoutOraclizeCall(
1554 		uint _policyId, 
1555 		string _carrierFlightNumber, 
1556 		string _departureYearMonthDay, 
1557 		uint _oraclizeTime) 
1558 		internal {
1559 
1560 		string memory oraclize_url = strConcat(
1561 			oraclize_StatusBaseUrl,
1562 			_carrierFlightNumber,
1563 			_departureYearMonthDay,
1564 			oraclizeStatusQuery
1565 			);
1566 
1567 		bytes32 queryId = oraclize_query(_oraclizeTime, 'nested', oraclize_url, oraclizeGas);
1568 		bookkeeping(acc_OraclizeCosts, acc_Balance, uint((-ledger[acc_Balance]) - int(this.balance)));
1569 		oraclizeCallbacks[queryId] = oraclizeCallback(_policyId, oraclizeState.ForPayout, _oraclizeTime);
1570 
1571 		LOG_OraclizeCall(_policyId, queryId, oraclize_url);
1572 	}
1573 
1574 	function payOut(uint _policyId, uint8 _delay, uint _delayInMinutes)
1575 		notInMaintenance
1576 		onlyOraclize
1577 		onlyInState(_policyId, policyState.Accepted)
1578 		internal {
1579 
1580 		policy p = policies[_policyId];
1581 		risk r = risks[p.riskId];
1582 		r.delay = _delay;
1583 		r.delayInMinutes = _delayInMinutes;
1584 		
1585 		if (_delay == 0) {
1586 			p.state = policyState.Expired;
1587 			p.stateMessage = 'Expired - no delay!';
1588 			p.stateTime = now;
1589 			LOG_PolicyExpired(_policyId);
1590 		} else {
1591 
1592 			uint payout = p.premium * weightPattern[_delay] * 10000 / p.weight;
1593 			p.calculatedPayout = payout;
1594 
1595 			if (payout > maxPayout) {
1596 				payout = maxPayout;
1597 			}
1598 
1599 			if (payout > uint(-ledger[acc_Balance])) { // don't go for chapter 11
1600 				payout = uint(-ledger[acc_Balance]);
1601 			}
1602 
1603 			p.actualPayout = payout;
1604 			bookkeeping(acc_Payout, acc_Balance, payout);      // cash out payout
1605 
1606 
1607 			if (!p.customer.send(payout))  {
1608 				bookkeeping(acc_Balance, acc_Payout, payout);
1609 				p.state = policyState.SendFailed;
1610 				p.stateMessage = 'Payout, send failed!';
1611 				p.actualPayout = 0;
1612 				LOG_SendFail(_policyId, 'payout sendfail');
1613 			}
1614 			else {
1615 				p.state = policyState.PaidOut;
1616 				p.stateMessage = 'Payout successful!';
1617 				p.stateTime = now; // won't be reverted in case of errors
1618 				LOG_PolicyPaidOut(_policyId, payout);
1619 			}
1620 		}
1621 
1622 	}
1623 
1624 	// fallback function: don't accept ether, except from owner
1625 	function () onlyOwner {
1626 
1627 		// put additional funds in risk fund.
1628 		bookkeeping(acc_Balance, acc_RiskFund, msg.value);
1629 
1630 	}
1631 
1632 	// internal, so no reentrant guard neccessary
1633 	function getFlightStats(
1634 		uint _policyId,
1635 		string _carrierFlightNumber)
1636 		internal {
1637 
1638 		// call oraclize and retrieve the number of observations from flightstats API
1639 		// format https://api.flightstats.com/flex/ratings/rest/v1/json/flight/OS/75?appId=**&appKey=**
1640 
1641 		// using nested data sources (query type nested) and partial
1642 		// encrypted queries in the next release of oraclize
1643 		// note that the first call maps the encrypted string to the
1644 		// sending contract address, this string can't be used from any other sender
1645 		string memory oraclize_url = strConcat(
1646 			oraclize_RatingsBaseUrl,
1647 			_carrierFlightNumber,
1648 			oraclizeRatingsQuery
1649 			);
1650 
1651 		bytes32 queryId = oraclize_query("nested", oraclize_url, oraclizeGas);
1652 		// calculate the spent gas
1653 		bookkeeping(acc_OraclizeCosts, acc_Balance, uint((-ledger[acc_Balance]) - int(this.balance)));
1654 		oraclizeCallbacks[queryId] = oraclizeCallback(_policyId, oraclizeState.ForUnderwriting, 0);
1655 
1656 		LOG_OraclizeCall(_policyId, queryId, oraclize_url);
1657 
1658 	}
1659 
1660 	// this is a dispatcher, but must be called __callback
1661 	function __callback(bytes32 _queryId, string _result, bytes _proof) 
1662 		onlyOraclize 
1663 		noReentrant {
1664 
1665 		oraclizeCallback o = oraclizeCallbacks[_queryId];
1666 		LOG_OraclizeCallback(o.policyId, _queryId, _result, _proof);
1667 		
1668 		if (o.oState == oraclizeState.ForUnderwriting) {
1669             callback_ForUnderwriting(o.policyId, _result, _proof);
1670 		}
1671         else {
1672             callback_ForPayout(_queryId, _result, _proof);
1673         }
1674 	}
1675 
1676 	function callback_ForUnderwriting(uint _policyId, string _result, bytes _proof) 
1677 		onlyInState(_policyId, policyState.Applied)
1678 		internal {
1679 
1680 		var sl_result = _result.toSlice(); 		
1681 		risk r = risks[policies[_policyId].riskId];
1682 
1683 		// we expect result to contain 6 values, something like
1684 		// "[61, 10, 4, 3, 0, 0]" ->
1685 		// ['observations','late15','late30','late45','cancelled','diverted']
1686 
1687 		if (bytes(_result).length == 0) {
1688 			decline(_policyId, 'Declined (empty result)', _proof);
1689 		} else {
1690 
1691 			// now slice the string using
1692 			// https://github.com/Arachnid/solidity-stringutils
1693 
1694 			if (sl_result.count(', '.toSlice()) != 5) { 
1695 				// check if result contains 6 values
1696 				decline(_policyId, 'Declined (invalid result)', _proof);
1697 			} else {
1698 				sl_result.beyond("[".toSlice()).until("]".toSlice());
1699 
1700 				uint observations = parseInt(
1701 					sl_result.split(', '.toSlice()).toString());
1702 
1703 				// decline on < minObservations observations,
1704 				// can't calculate reasonable probabibilities
1705 				if (observations <= minObservations) {
1706 					decline(_policyId, 'Declined (too few observations)', _proof);
1707 				} else {
1708 					uint[6] memory statistics;
1709 					// calculate statistics (scaled by 10000; 1% => 100)
1710 					statistics[0] = observations;
1711 					for(uint i = 1; i <= 5; i++) {
1712 						statistics[i] =
1713 							parseInt(
1714 								sl_result.split(', '.toSlice()).toString()) 
1715 								* 10000/observations;
1716 					}
1717 
1718 					// underwrite policy
1719 					underwrite(_policyId, statistics, _proof);
1720 				}
1721 			}
1722 		}
1723 	} 
1724 
1725 	function callback_ForPayout(bytes32 _queryId, string _result, bytes _proof) internal {
1726 
1727 		oraclizeCallback o = oraclizeCallbacks[_queryId];
1728 		uint policyId = o.policyId;
1729 		var sl_result = _result.toSlice(); 		
1730 		risk r = risks[policies[policyId].riskId];
1731 
1732 		if (bytes(_result).length == 0) {
1733 			if (o.oraclizeTime > r.arrivalTime + 180 minutes) {
1734 				LOG_PolicyManualPayout(policyId, 'No Callback at +120 min');
1735 				return;
1736 			} else {
1737 				schedulePayoutOraclizeCall(
1738 					policyId, 
1739 					r.carrierFlightNumber, 
1740 					r.departureYearMonthDay, 
1741 					o.oraclizeTime + 45 minutes
1742 				);
1743 			}
1744 		} else {
1745 						
1746 			// first check status
1747 
1748 			// extract the status field:
1749 			sl_result.find('"'.toSlice()).beyond('"'.toSlice());
1750 			sl_result.until(sl_result.copy().find('"'.toSlice()));
1751 			bytes1 status = bytes(sl_result.toString())[0];	// s = L
1752 			
1753 			if (status == 'C') {
1754 				// flight cancelled --> payout
1755 				payOut(policyId, 4, 0);
1756 				return;
1757 			} else if (status == 'D') {
1758 				// flight diverted --> payout					
1759 				payOut(policyId, 5, 0);
1760 				return;
1761 			} else if (status != 'L' && status != 'A' && status != 'C' && status != 'D') {
1762 				LOG_PolicyManualPayout(policyId, 'Unprocessable status');
1763 				return;
1764 			}
1765 			
1766 			// process the rest of the response:
1767 			sl_result = _result.toSlice();
1768 			bool arrived = sl_result.contains('actualGateArrival'.toSlice());
1769 
1770 			if (status == 'A' || (status == 'L' && !arrived)) {
1771 				// flight still active or not at gate --> reschedule
1772 				if (o.oraclizeTime > r.arrivalTime + 180 minutes) {
1773 					LOG_PolicyManualPayout(policyId, 'No arrival at +120 min');
1774 				} else {
1775 					schedulePayoutOraclizeCall(
1776 						policyId, 
1777 						r.carrierFlightNumber, 
1778 						r.departureYearMonthDay, 
1779 						o.oraclizeTime + 45 minutes
1780 					);
1781 				}
1782 			} else if (status == 'L' && arrived) {
1783 				var aG = '"arrivalGateDelayMinutes": '.toSlice();
1784 				if (sl_result.contains(aG)) {
1785 					sl_result.find(aG).beyond(aG);
1786 					sl_result.until(sl_result.copy().find('"'.toSlice())
1787 						.beyond('"'.toSlice()));
1788 					sl_result.until(sl_result.copy().find('}'.toSlice()));
1789 					sl_result.until(sl_result.copy().find(','.toSlice()));
1790 					uint delayInMinutes = parseInt(sl_result.toString());
1791 				} else {
1792 					delayInMinutes = 0;
1793 				}
1794 				
1795 				if (delayInMinutes < 15) {
1796 					payOut(policyId, 0, 0);
1797 				} else if (delayInMinutes < 30) {
1798 					payOut(policyId, 1, delayInMinutes);
1799 				} else if (delayInMinutes < 45) {
1800 					payOut(policyId, 2, delayInMinutes);
1801 				} else {
1802 					payOut(policyId, 3, delayInMinutes);
1803 				}
1804 			} else { // no delay info
1805 				payOut(policyId, 0, 0);
1806 			}
1807 		} 
1808 	}
1809 }
1810 
1811 
1812 
1813 
1814 /* EOF */