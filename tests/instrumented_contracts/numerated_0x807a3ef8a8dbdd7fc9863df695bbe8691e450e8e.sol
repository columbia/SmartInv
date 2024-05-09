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
31 pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
32 
33 contract OraclizeI {
34     address public cbAddress;
35     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
36     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
37     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
38     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
39     function getPrice(string _datasource) returns (uint _dsprice);
40     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
41     function useCoupon(string _coupon);
42     function setProofType(byte _proofType);
43     function setConfig(bytes32 _config);
44     function setCustomGasPrice(uint _gasPrice);
45 }
46 contract OraclizeAddrResolverI {
47     function getAddress() returns (address _addr);
48 }
49 contract usingOraclize {
50     uint constant day = 60*60*24;
51     uint constant week = 60*60*24*7;
52     uint constant month = 60*60*24*30;
53     byte constant proofType_NONE = 0x00;
54     byte constant proofType_TLSNotary = 0x10;
55     byte constant proofStorage_IPFS = 0x01;
56     uint8 constant networkID_auto = 0;
57     uint8 constant networkID_mainnet = 1;
58     uint8 constant networkID_testnet = 2;
59     uint8 constant networkID_morden = 2;
60     uint8 constant networkID_consensys = 161;
61 
62     OraclizeAddrResolverI OAR;
63     
64     OraclizeI oraclize;
65     modifier oraclizeAPI {
66         if(address(OAR)==0) oraclize_setNetwork(networkID_auto);
67         oraclize = OraclizeI(OAR.getAddress());
68         _;
69     }
70     modifier coupon(string code){
71         oraclize = OraclizeI(OAR.getAddress());
72         oraclize.useCoupon(code);
73         _;
74     }
75 
76     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
77         if (getCodeSize(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed)>0){ //mainnet
78             OAR = OraclizeAddrResolverI(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed);
79             return true;
80         }
81         if (getCodeSize(0xc03a2615d5efaf5f49f60b7bb6583eaec212fdf1)>0){ //ropsten testnet
82             OAR = OraclizeAddrResolverI(0xc03a2615d5efaf5f49f60b7bb6583eaec212fdf1);
83             return true;
84         }
85         if (getCodeSize(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf)>0){ //ether.camp ide
86             OAR = OraclizeAddrResolverI(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf);
87             return true;
88         }
89         if (getCodeSize(0x93bbbe5ce77034e3095f0479919962a903f898ad)>0){ //norsborg testnet
90             OAR = OraclizeAddrResolverI(0x93bbbe5ce77034e3095f0479919962a903f898ad);
91             return true;
92         }
93         if (getCodeSize(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa)>0){ //browser-solidity
94             OAR = OraclizeAddrResolverI(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa);
95             return true;
96         }
97         return false;
98     }
99     
100     function __callback(bytes32 myid, string result) {
101         __callback(myid, result, new bytes(0));
102     }
103     function __callback(bytes32 myid, string result, bytes proof) {
104     }
105     
106     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
107         return oraclize.getPrice(datasource);
108     }
109     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
110         return oraclize.getPrice(datasource, gaslimit);
111     }
112     
113     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
114         uint price = oraclize.getPrice(datasource);
115         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
116         return oraclize.query.value(price)(0, datasource, arg);
117     }
118     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
119         uint price = oraclize.getPrice(datasource);
120         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
121         return oraclize.query.value(price)(timestamp, datasource, arg);
122     }
123     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
124         uint price = oraclize.getPrice(datasource, gaslimit);
125         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
126         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
127     }
128     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
129         uint price = oraclize.getPrice(datasource, gaslimit);
130         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
131         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
132     }
133     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
134         uint price = oraclize.getPrice(datasource);
135         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
136         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
137     }
138     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
139         uint price = oraclize.getPrice(datasource);
140         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
141         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
142     }
143     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
144         uint price = oraclize.getPrice(datasource, gaslimit);
145         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
146         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
147     }
148     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
149         uint price = oraclize.getPrice(datasource, gaslimit);
150         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
151         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
152     }
153     function oraclize_cbAddress() oraclizeAPI internal returns (address){
154         return oraclize.cbAddress();
155     }
156     function oraclize_setProof(byte proofP) oraclizeAPI internal {
157         return oraclize.setProofType(proofP);
158     }
159     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
160         return oraclize.setCustomGasPrice(gasPrice);
161     }    
162     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
163         return oraclize.setConfig(config);
164     }
165 
166     function getCodeSize(address _addr) constant internal returns(uint _size) {
167         assembly {
168             _size := extcodesize(_addr)
169         }
170     }
171 
172 
173     function parseAddr(string _a) internal returns (address){
174         bytes memory tmp = bytes(_a);
175         uint160 iaddr = 0;
176         uint160 b1;
177         uint160 b2;
178         for (uint i=2; i<2+2*20; i+=2){
179             iaddr *= 256;
180             b1 = uint160(tmp[i]);
181             b2 = uint160(tmp[i+1]);
182             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
183             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
184             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
185             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
186             iaddr += (b1*16+b2);
187         }
188         return address(iaddr);
189     }
190 
191 
192     function strCompare(string _a, string _b) internal returns (int) {
193         bytes memory a = bytes(_a);
194         bytes memory b = bytes(_b);
195         uint minLength = a.length;
196         if (b.length < minLength) minLength = b.length;
197         for (uint i = 0; i < minLength; i ++)
198             if (a[i] < b[i])
199                 return -1;
200             else if (a[i] > b[i])
201                 return 1;
202         if (a.length < b.length)
203             return -1;
204         else if (a.length > b.length)
205             return 1;
206         else
207             return 0;
208    } 
209 
210     function indexOf(string _haystack, string _needle) internal returns (int)
211     {
212         bytes memory h = bytes(_haystack);
213         bytes memory n = bytes(_needle);
214         if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
215             return -1;
216         else if(h.length > (2**128 -1))
217             return -1;                                  
218         else
219         {
220             uint subindex = 0;
221             for (uint i = 0; i < h.length; i ++)
222             {
223                 if (h[i] == n[0])
224                 {
225                     subindex = 1;
226                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
227                     {
228                         subindex++;
229                     }   
230                     if(subindex == n.length)
231                         return int(i);
232                 }
233             }
234             return -1;
235         }   
236     }
237 
238     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
239         bytes memory _ba = bytes(_a);
240         bytes memory _bb = bytes(_b);
241         bytes memory _bc = bytes(_c);
242         bytes memory _bd = bytes(_d);
243         bytes memory _be = bytes(_e);
244         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
245         bytes memory babcde = bytes(abcde);
246         uint k = 0;
247         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
248         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
249         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
250         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
251         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
252         return string(babcde);
253     }
254     
255     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
256         return strConcat(_a, _b, _c, _d, "");
257     }
258 
259     function strConcat(string _a, string _b, string _c) internal returns (string) {
260         return strConcat(_a, _b, _c, "", "");
261     }
262 
263     function strConcat(string _a, string _b) internal returns (string) {
264         return strConcat(_a, _b, "", "", "");
265     }
266 
267     // parseInt
268     function parseInt(string _a) internal returns (uint) {
269         return parseInt(_a, 0);
270     }
271 
272     // parseInt(parseFloat*10^_b)
273     function parseInt(string _a, uint _b) internal returns (uint) {
274         bytes memory bresult = bytes(_a);
275         uint mint = 0;
276         bool decimals = false;
277         for (uint i=0; i<bresult.length; i++){
278             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
279                 if (decimals){
280                    if (_b == 0) break;
281                     else _b--;
282                 }
283                 mint *= 10;
284                 mint += uint(bresult[i]) - 48;
285             } else if (bresult[i] == 46) decimals = true;
286         }
287         if (_b > 0) mint *= 10**_b;
288         return mint;
289     }
290     
291     function uint2str(uint i) internal returns (string){
292         if (i == 0) return "0";
293         uint j = i;
294         uint len;
295         while (j != 0){
296             len++;
297             j /= 10;
298         }
299         bytes memory bstr = new bytes(len);
300         uint k = len - 1;
301         while (i != 0){
302             bstr[k--] = byte(48 + i % 10);
303             i /= 10;
304         }
305         return string(bstr);
306     }
307     
308     
309 
310 }
311 // </ORACLIZE_API>
312 
313 
314 
315 library strings {
316     struct slice {
317         uint _len;
318         uint _ptr;
319     }
320 
321     function memcpy(uint dest, uint src, uint len) private {
322         // Copy word-length chunks while possible
323         for(; len >= 32; len -= 32) {
324             assembly {
325                 mstore(dest, mload(src))
326             }
327             dest += 32;
328             src += 32;
329         }
330 
331         // Copy remaining bytes
332         uint mask = 256 ** (32 - len) - 1;
333         assembly {
334             let srcpart := and(mload(src), not(mask))
335             let destpart := and(mload(dest), mask)
336             mstore(dest, or(destpart, srcpart))
337         }
338     }
339 
340     /**
341      * @dev Returns a slice containing the entire string.
342      * @param self The string to make a slice from.
343      * @return A newly allocated slice containing the entire string.
344      */
345     function toSlice(string self) internal returns (slice) {
346         uint ptr;
347         assembly {
348             ptr := add(self, 0x20)
349         }
350         return slice(bytes(self).length, ptr);
351     }
352 
353     /**
354      * @dev Returns the length of a null-terminated bytes32 string.
355      * @param self The value to find the length of.
356      * @return The length of the string, from 0 to 32.
357      */
358     function len(bytes32 self) internal returns (uint) {
359         uint ret;
360         if (self == 0)
361             return 0;
362         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
363             ret += 16;
364             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
365         }
366         if (self & 0xffffffffffffffff == 0) {
367             ret += 8;
368             self = bytes32(uint(self) / 0x10000000000000000);
369         }
370         if (self & 0xffffffff == 0) {
371             ret += 4;
372             self = bytes32(uint(self) / 0x100000000);
373         }
374         if (self & 0xffff == 0) {
375             ret += 2;
376             self = bytes32(uint(self) / 0x10000);
377         }
378         if (self & 0xff == 0) {
379             ret += 1;
380         }
381         return 32 - ret;
382     }
383 
384     /**
385      * @dev Returns a slice containing the entire bytes32, interpreted as a
386      *      null-termintaed utf-8 string.
387      * @param self The bytes32 value to convert to a slice.
388      * @return A new slice containing the value of the input argument up to the
389      *         first null.
390      */
391     function toSliceB32(bytes32 self) internal returns (slice ret) {
392         // Allocate space for `self` in memory, copy it there, and point ret at it
393         assembly {
394             let ptr := mload(0x40)
395             mstore(0x40, add(ptr, 0x20))
396             mstore(ptr, self)
397             mstore(add(ret, 0x20), ptr)
398         }
399         ret._len = len(self);
400     }
401 
402     /**
403      * @dev Returns a new slice containing the same data as the current slice.
404      * @param self The slice to copy.
405      * @return A new slice containing the same data as `self`.
406      */
407     function copy(slice self) internal returns (slice) {
408         return slice(self._len, self._ptr);
409     }
410 
411     /**
412      * @dev Copies a slice to a new string.
413      * @param self The slice to copy.
414      * @return A newly allocated string containing the slice's text.
415      */
416     function toString(slice self) internal returns (string) {
417         var ret = new string(self._len);
418         uint retptr;
419         assembly { retptr := add(ret, 32) }
420 
421         memcpy(retptr, self._ptr, self._len);
422         return ret;
423     }
424 
425     /**
426      * @dev Returns the length in runes of the slice. Note that this operation
427      *      takes time proportional to the length of the slice; avoid using it
428      *      in loops, and call `slice.empty()` if you only need to know whether
429      *      the slice is empty or not.
430      * @param self The slice to operate on.
431      * @return The length of the slice in runes.
432      */
433     function len(slice self) internal returns (uint) {
434         // Starting at ptr-31 means the LSB will be the byte we care about
435         var ptr = self._ptr - 31;
436         var end = ptr + self._len;
437         for (uint len = 0; ptr < end; len++) {
438             uint8 b;
439             assembly { b := and(mload(ptr), 0xFF) }
440             if (b < 0x80) {
441                 ptr += 1;
442             } else if(b < 0xE0) {
443                 ptr += 2;
444             } else if(b < 0xF0) {
445                 ptr += 3;
446             } else if(b < 0xF8) {
447                 ptr += 4;
448             } else if(b < 0xFC) {
449                 ptr += 5;
450             } else {
451                 ptr += 6;
452             }
453         }
454         return len;
455     }
456 
457     /**
458      * @dev Returns true if the slice is empty (has a length of 0).
459      * @param self The slice to operate on.
460      * @return True if the slice is empty, False otherwise.
461      */
462     function empty(slice self) internal returns (bool) {
463         return self._len == 0;
464     }
465 
466     /**
467      * @dev Returns a positive number if `other` comes lexicographically after
468      *      `self`, a negative number if it comes before, or zero if the
469      *      contents of the two slices are equal. Comparison is done per-rune,
470      *      on unicode codepoints.
471      * @param self The first slice to compare.
472      * @param other The second slice to compare.
473      * @return The result of the comparison.
474      */
475     function compare(slice self, slice other) internal returns (int) {
476         uint shortest = self._len;
477         if (other._len < self._len)
478             shortest = other._len;
479 
480         var selfptr = self._ptr;
481         var otherptr = other._ptr;
482         for (uint idx = 0; idx < shortest; idx += 32) {
483             uint a;
484             uint b;
485             assembly {
486                 a := mload(selfptr)
487                 b := mload(otherptr)
488             }
489             if (a != b) {
490                 // Mask out irrelevant bytes and check again
491                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
492                 var diff = (a & mask) - (b & mask);
493                 if (diff != 0)
494                     return int(diff);
495             }
496             selfptr += 32;
497             otherptr += 32;
498         }
499         return int(self._len) - int(other._len);
500     }
501 
502     /**
503      * @dev Returns true if the two slices contain the same text.
504      * @param self The first slice to compare.
505      * @param self The second slice to compare.
506      * @return True if the slices are equal, false otherwise.
507      */
508     function equals(slice self, slice other) internal returns (bool) {
509         return compare(self, other) == 0;
510     }
511 
512     /**
513      * @dev Extracts the first rune in the slice into `rune`, advancing the
514      *      slice to point to the next rune and returning `self`.
515      * @param self The slice to operate on.
516      * @param rune The slice that will contain the first rune.
517      * @return `rune`.
518      */
519     function nextRune(slice self, slice rune) internal returns (slice) {
520         rune._ptr = self._ptr;
521 
522         if (self._len == 0) {
523             rune._len = 0;
524             return rune;
525         }
526 
527         uint len;
528         uint b;
529         // Load the first byte of the rune into the LSBs of b
530         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
531         if (b < 0x80) {
532             len = 1;
533         } else if(b < 0xE0) {
534             len = 2;
535         } else if(b < 0xF0) {
536             len = 3;
537         } else {
538             len = 4;
539         }
540 
541         // Check for truncated codepoints
542         if (len > self._len) {
543             rune._len = self._len;
544             self._ptr += self._len;
545             self._len = 0;
546             return rune;
547         }
548 
549         self._ptr += len;
550         self._len -= len;
551         rune._len = len;
552         return rune;
553     }
554 
555     /**
556      * @dev Returns the first rune in the slice, advancing the slice to point
557      *      to the next rune.
558      * @param self The slice to operate on.
559      * @return A slice containing only the first rune from `self`.
560      */
561     function nextRune(slice self) internal returns (slice ret) {
562         nextRune(self, ret);
563     }
564 
565     /**
566      * @dev Returns the number of the first codepoint in the slice.
567      * @param self The slice to operate on.
568      * @return The number of the first codepoint in the slice.
569      */
570     function ord(slice self) internal returns (uint ret) {
571         if (self._len == 0) {
572             return 0;
573         }
574 
575         uint word;
576         uint len;
577         uint div = 2 ** 248;
578 
579         // Load the rune into the MSBs of b
580         assembly { word:= mload(mload(add(self, 32))) }
581         var b = word / div;
582         if (b < 0x80) {
583             ret = b;
584             len = 1;
585         } else if(b < 0xE0) {
586             ret = b & 0x1F;
587             len = 2;
588         } else if(b < 0xF0) {
589             ret = b & 0x0F;
590             len = 3;
591         } else {
592             ret = b & 0x07;
593             len = 4;
594         }
595 
596         // Check for truncated codepoints
597         if (len > self._len) {
598             return 0;
599         }
600 
601         for (uint i = 1; i < len; i++) {
602             div = div / 256;
603             b = (word / div) & 0xFF;
604             if (b & 0xC0 != 0x80) {
605                 // Invalid UTF-8 sequence
606                 return 0;
607             }
608             ret = (ret * 64) | (b & 0x3F);
609         }
610 
611         return ret;
612     }
613 
614     /**
615      * @dev Returns the keccak-256 hash of the slice.
616      * @param self The slice to hash.
617      * @return The hash of the slice.
618      */
619     function keccak(slice self) internal returns (bytes32 ret) {
620         assembly {
621             ret := sha3(mload(add(self, 32)), mload(self))
622         }
623     }
624 
625     /**
626      * @dev Returns true if `self` starts with `needle`.
627      * @param self The slice to operate on.
628      * @param needle The slice to search for.
629      * @return True if the slice starts with the provided text, false otherwise.
630      */
631     function startsWith(slice self, slice needle) internal returns (bool) {
632         if (self._len < needle._len) {
633             return false;
634         }
635 
636         if (self._ptr == needle._ptr) {
637             return true;
638         }
639 
640         bool equal;
641         assembly {
642             let len := mload(needle)
643             let selfptr := mload(add(self, 0x20))
644             let needleptr := mload(add(needle, 0x20))
645             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
646         }
647         return equal;
648     }
649 
650     /**
651      * @dev If `self` starts with `needle`, `needle` is removed from the
652      *      beginning of `self`. Otherwise, `self` is unmodified.
653      * @param self The slice to operate on.
654      * @param needle The slice to search for.
655      * @return `self`
656      */
657     function beyond(slice self, slice needle) internal returns (slice) {
658         if (self._len < needle._len) {
659             return self;
660         }
661 
662         bool equal = true;
663         if (self._ptr != needle._ptr) {
664             assembly {
665                 let len := mload(needle)
666                 let selfptr := mload(add(self, 0x20))
667                 let needleptr := mload(add(needle, 0x20))
668                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
669             }
670         }
671 
672         if (equal) {
673             self._len -= needle._len;
674             self._ptr += needle._len;
675         }
676 
677         return self;
678     }
679 
680     /**
681      * @dev Returns true if the slice ends with `needle`.
682      * @param self The slice to operate on.
683      * @param needle The slice to search for.
684      * @return True if the slice starts with the provided text, false otherwise.
685      */
686     function endsWith(slice self, slice needle) internal returns (bool) {
687         if (self._len < needle._len) {
688             return false;
689         }
690 
691         var selfptr = self._ptr + self._len - needle._len;
692 
693         if (selfptr == needle._ptr) {
694             return true;
695         }
696 
697         bool equal;
698         assembly {
699             let len := mload(needle)
700             let needleptr := mload(add(needle, 0x20))
701             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
702         }
703 
704         return equal;
705     }
706 
707     /**
708      * @dev If `self` ends with `needle`, `needle` is removed from the
709      *      end of `self`. Otherwise, `self` is unmodified.
710      * @param self The slice to operate on.
711      * @param needle The slice to search for.
712      * @return `self`
713      */
714     function until(slice self, slice needle) internal returns (slice) {
715         if (self._len < needle._len) {
716             return self;
717         }
718 
719         var selfptr = self._ptr + self._len - needle._len;
720         bool equal = true;
721         if (selfptr != needle._ptr) {
722             assembly {
723                 let len := mload(needle)
724                 let needleptr := mload(add(needle, 0x20))
725                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
726             }
727         }
728 
729         if (equal) {
730             self._len -= needle._len;
731         }
732 
733         return self;
734     }
735 
736     // Returns the memory address of the first byte of the first occurrence of
737     // `needle` in `self`, or the first byte after `self` if not found.
738     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
739         uint ptr;
740         uint idx;
741 
742         if (needlelen <= selflen) {
743             if (needlelen <= 32) {
744                 // Optimized assembly for 68 gas per byte on short strings
745                 assembly {
746                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
747                     let needledata := and(mload(needleptr), mask)
748                     let end := add(selfptr, sub(selflen, needlelen))
749                     ptr := selfptr
750                     loop:
751                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
752                     ptr := add(ptr, 1)
753                     jumpi(loop, lt(sub(ptr, 1), end))
754                     ptr := add(selfptr, selflen)
755                     exit:
756                 }
757                 return ptr;
758             } else {
759                 // For long needles, use hashing
760                 bytes32 hash;
761                 assembly { hash := sha3(needleptr, needlelen) }
762                 ptr = selfptr;
763                 for (idx = 0; idx <= selflen - needlelen; idx++) {
764                     bytes32 testHash;
765                     assembly { testHash := sha3(ptr, needlelen) }
766                     if (hash == testHash)
767                         return ptr;
768                     ptr += 1;
769                 }
770             }
771         }
772         return selfptr + selflen;
773     }
774 
775     // Returns the memory address of the first byte after the last occurrence of
776     // `needle` in `self`, or the address of `self` if not found.
777     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
778         uint ptr;
779 
780         if (needlelen <= selflen) {
781             if (needlelen <= 32) {
782                 // Optimized assembly for 69 gas per byte on short strings
783                 assembly {
784                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
785                     let needledata := and(mload(needleptr), mask)
786                     ptr := add(selfptr, sub(selflen, needlelen))
787                     loop:
788                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
789                     ptr := sub(ptr, 1)
790                     jumpi(loop, gt(add(ptr, 1), selfptr))
791                     ptr := selfptr
792                     jump(exit)
793                     ret:
794                     ptr := add(ptr, needlelen)
795                     exit:
796                 }
797                 return ptr;
798             } else {
799                 // For long needles, use hashing
800                 bytes32 hash;
801                 assembly { hash := sha3(needleptr, needlelen) }
802                 ptr = selfptr + (selflen - needlelen);
803                 while (ptr >= selfptr) {
804                     bytes32 testHash;
805                     assembly { testHash := sha3(ptr, needlelen) }
806                     if (hash == testHash)
807                         return ptr + needlelen;
808                     ptr -= 1;
809                 }
810             }
811         }
812         return selfptr;
813     }
814 
815     /**
816      * @dev Modifies `self` to contain everything from the first occurrence of
817      *      `needle` to the end of the slice. `self` is set to the empty slice
818      *      if `needle` is not found.
819      * @param self The slice to search and modify.
820      * @param needle The text to search for.
821      * @return `self`.
822      */
823     function find(slice self, slice needle) internal returns (slice) {
824         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
825         self._len -= ptr - self._ptr;
826         self._ptr = ptr;
827         return self;
828     }
829 
830     /**
831      * @dev Modifies `self` to contain the part of the string from the start of
832      *      `self` to the end of the first occurrence of `needle`. If `needle`
833      *      is not found, `self` is set to the empty slice.
834      * @param self The slice to search and modify.
835      * @param needle The text to search for.
836      * @return `self`.
837      */
838     function rfind(slice self, slice needle) internal returns (slice) {
839         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
840         self._len = ptr - self._ptr;
841         return self;
842     }
843 
844     /**
845      * @dev Splits the slice, setting `self` to everything after the first
846      *      occurrence of `needle`, and `token` to everything before it. If
847      *      `needle` does not occur in `self`, `self` is set to the empty slice,
848      *      and `token` is set to the entirety of `self`.
849      * @param self The slice to split.
850      * @param needle The text to search for in `self`.
851      * @param token An output parameter to which the first token is written.
852      * @return `token`.
853      */
854     function split(slice self, slice needle, slice token) internal returns (slice) {
855         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
856         token._ptr = self._ptr;
857         token._len = ptr - self._ptr;
858         if (ptr == self._ptr + self._len) {
859             // Not found
860             self._len = 0;
861         } else {
862             self._len -= token._len + needle._len;
863             self._ptr = ptr + needle._len;
864         }
865         return token;
866     }
867 
868     /**
869      * @dev Splits the slice, setting `self` to everything after the first
870      *      occurrence of `needle`, and returning everything before it. If
871      *      `needle` does not occur in `self`, `self` is set to the empty slice,
872      *      and the entirety of `self` is returned.
873      * @param self The slice to split.
874      * @param needle The text to search for in `self`.
875      * @return The part of `self` up to the first occurrence of `delim`.
876      */
877     function split(slice self, slice needle) internal returns (slice token) {
878         split(self, needle, token);
879     }
880 
881     /**
882      * @dev Splits the slice, setting `self` to everything before the last
883      *      occurrence of `needle`, and `token` to everything after it. If
884      *      `needle` does not occur in `self`, `self` is set to the empty slice,
885      *      and `token` is set to the entirety of `self`.
886      * @param self The slice to split.
887      * @param needle The text to search for in `self`.
888      * @param token An output parameter to which the first token is written.
889      * @return `token`.
890      */
891     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
892         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
893         token._ptr = ptr;
894         token._len = self._len - (ptr - self._ptr);
895         if (ptr == self._ptr) {
896             // Not found
897             self._len = 0;
898         } else {
899             self._len -= token._len + needle._len;
900         }
901         return token;
902     }
903 
904     /**
905      * @dev Splits the slice, setting `self` to everything before the last
906      *      occurrence of `needle`, and returning everything after it. If
907      *      `needle` does not occur in `self`, `self` is set to the empty slice,
908      *      and the entirety of `self` is returned.
909      * @param self The slice to split.
910      * @param needle The text to search for in `self`.
911      * @return The part of `self` after the last occurrence of `delim`.
912      */
913     function rsplit(slice self, slice needle) internal returns (slice token) {
914         rsplit(self, needle, token);
915     }
916 
917     /**
918      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
919      * @param self The slice to search.
920      * @param needle The text to search for in `self`.
921      * @return The number of occurrences of `needle` found in `self`.
922      */
923     function count(slice self, slice needle) internal returns (uint count) {
924         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
925         while (ptr <= self._ptr + self._len) {
926             count++;
927             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
928         }
929     }
930 
931     /**
932      * @dev Returns True if `self` contains `needle`.
933      * @param self The slice to search.
934      * @param needle The text to search for in `self`.
935      * @return True if `needle` is found in `self`, false otherwise.
936      */
937     function contains(slice self, slice needle) internal returns (bool) {
938         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
939     }
940 
941     /**
942      * @dev Returns a newly allocated string containing the concatenation of
943      *      `self` and `other`.
944      * @param self The first slice to concatenate.
945      * @param other The second slice to concatenate.
946      * @return The concatenation of the two strings.
947      */
948     function concat(slice self, slice other) internal returns (string) {
949         var ret = new string(self._len + other._len);
950         uint retptr;
951         assembly { retptr := add(ret, 32) }
952         memcpy(retptr, self._ptr, self._len);
953         memcpy(retptr + self._len, other._ptr, other._len);
954         return ret;
955     }
956 
957     /**
958      * @dev Joins an array of slices, using `self` as a delimiter, returning a
959      *      newly allocated string.
960      * @param self The delimiter to use.
961      * @param parts A list of slices to join.
962      * @return A newly allocated string containing all the slices in `parts`,
963      *         joined with `self`.
964      */
965     function join(slice self, slice[] parts) internal returns (string) {
966         if (parts.length == 0)
967             return "";
968 
969         uint len = self._len * (parts.length - 1);
970         for(uint i = 0; i < parts.length; i++)
971             len += parts[i]._len;
972 
973         var ret = new string(len);
974         uint retptr;
975         assembly { retptr := add(ret, 32) }
976 
977         for(i = 0; i < parts.length; i++) {
978             memcpy(retptr, parts[i]._ptr, parts[i]._len);
979             retptr += parts[i]._len;
980             if (i < parts.length - 1) {
981                 memcpy(retptr, self._ptr, self._len);
982                 retptr += self._len;
983             }
984         }
985 
986         return ret;
987     }
988 }
989 
990 
991 contract mortal {
992 	address owner;
993 
994 	function mortal() {
995 		owner = msg.sender;
996 	}
997 
998 	function kill() internal {
999 		suicide(owner);
1000 	}
1001 }
1002 
1003 contract Pray4Prey is mortal, usingOraclize {
1004 	using strings
1005 	for * ;
1006 
1007 	struct Animal {
1008 		uint8 animalType;
1009 		uint128 value;
1010 		address owner;
1011 	}
1012 
1013 	/** array holding ids of the curret animals*/
1014 	uint32[] public ids;
1015 	/** the id to be given to the net animal **/
1016 	uint32 public nextId;
1017 	/** the id of the oldest animal */
1018 	uint32 public oldest;
1019 	/** the animal belonging to a given id */
1020 	mapping(uint32 => Animal) animals;
1021 	/** the cost of each animal type */
1022 	uint128[] public costs;
1023 	/** the value of each animal type (cost - fee), so it's not necessary to compute it each time*/
1024 	uint128[] public values;
1025 	/** the fee to be paid each time an animal is bought in percent*/
1026 	uint8  fee;
1027 
1028 	/** total number of animals in the game 
1029 	(!=sum of the lengths of the prey animals arrays, since those arrays contain holes) */
1030 	uint16 public numAnimals;
1031 	/** The maximum of animals allowed in the game */
1032 	uint16 public maxAnimals;
1033 	/** number of animals per type */
1034 	mapping(uint8 => uint16) public numAnimalsXType;
1035 
1036 
1037 	/** the query string getting the random numbers from oraclize**/
1038 	string  randomQuery;
1039 	/** the type of the oraclize query**/
1040 	string  queryType;
1041 	/** the timestamp of the next attack **/
1042 	uint public nextAttackTimestamp;
1043 	/** gas provided for oraclize callback (attack)**/
1044 	uint32 public oraclizeGas;
1045 	/** the id of the next oraclize callback*/
1046 	bytes32 nextAttackId;
1047 
1048 
1049 	/** is fired when new animals are purchased (who bought how many animals of which type?) */
1050 	event newPurchase(address player, uint8 animalType, uint8 amount, uint32 startId);
1051 	/** is fired when a player leaves the game */
1052 	event newExit(address player, uint256 totalBalance);
1053 	/** is fired when an attack occures */
1054 	event newAttack(uint32[] killedAnimals);
1055 
1056 
1057 	/** expected parameters: the costs per animal type and the game fee in percent 
1058 	 *   assumes that the cheapest animal is stored in [0]
1059 	 */
1060 	function Pray4Prey() {
1061 		costs = [100000000000000000,200000000000000000,500000000000000000,1000000000000000000,5000000000000000000];
1062 		fee = 5;
1063 		for (uint8 i = 0; i < costs.length; i++) {
1064 			values.push(costs[i] - costs[i] / 100 * fee);
1065 		}
1066 		maxAnimals = 300;
1067 		randomQuery = "10 random numbers between 1 and 1000";
1068 		queryType = "WolframAlpha";
1069 		oraclizeGas = 400000;
1070 		nextId = 1;
1071 		oldest = 1;
1072 	}
1073 
1074 	/** The fallback function runs whenever someone sends ether
1075 	   Depending of the value of the transaction the sender is either granted a prey or 
1076 	   the transaction is discarded and no ether accepted
1077 	   In the first case fees have to be paid*/
1078 	function() payable {
1079 		for (uint8 i = 0; i < costs.length; i++)
1080 			if (msg.value == costs[i])
1081 				addAnimals(i);
1082 
1083 		if (msg.value == 1000000000000000)
1084 			exit();
1085 		else
1086 			throw;
1087 
1088 	}
1089 
1090 	/** buy animals of a given type 
1091 	 *  as many animals as possible are bought with msg.value
1092 	 */
1093 	function addAnimals(uint8 animalType) payable {
1094 		giveAnimals(animalType, msg.sender);
1095 	}
1096 	
1097 	/** buy animals of a given type forsomeone else
1098 	 *  as many animals as possible are bought with msg.value
1099 	 */
1100 	function giveAnimals(uint8 animalType, address receiver) payable {
1101 		uint8 amount = uint8(msg.value / costs[animalType]);
1102 		if (animalType >= costs.length || msg.value < costs[animalType] ||  numAnimals + amount >= maxAnimals) throw;
1103 		//if type exists, enough ether was transferred and there are less than maxAnimals animals in the game
1104 		for (uint8 j = 0; j < amount; j++) {
1105 			addAnimal(animalType, receiver);
1106 		}
1107 		numAnimalsXType[animalType] += amount;
1108 		newPurchase(receiver, animalType, amount, nextId-amount);
1109 	}
1110 
1111 	/**
1112 	 *  adds a single animal of the given type
1113 	 */
1114 	function addAnimal(uint8 animalType, address receiver) internal {
1115 		if (numAnimals < ids.length)
1116 			ids[numAnimals] = nextId;
1117 		else
1118 			ids.push(nextId);
1119 		animals[nextId] = Animal(animalType, values[animalType], receiver);
1120 		nextId++;
1121 		numAnimals++;
1122 	}
1123 	
1124 
1125 
1126 	/** leave the game
1127 	 * pays out the sender's winBalance and removes him and his animals from the game
1128 	 * */
1129 	function exit() {
1130 		uint balance = cleanUp(msg.sender); //delete the animals
1131 		newExit(msg.sender, balance); //fire the event to notify the client
1132 		if (!msg.sender.send(balance)) throw;
1133 	}
1134 
1135 	/**
1136 	 * Deletes the animals of a given player
1137 	 * */
1138 	function cleanUp(address playerAddress) internal returns(uint playerBalance){
1139 		uint32 lastId;
1140 		for (uint16 i = 0; i < numAnimals; i++) {
1141 			if (animals[ids[i]].owner == playerAddress) {
1142 				//first delete all animals at the end of the array
1143 				while (numAnimals > 0 && animals[ids[numAnimals - 1]].owner == playerAddress) {
1144 					numAnimals--;
1145 					lastId = ids[numAnimals];
1146 					numAnimalsXType[animals[lastId].animalType]--;
1147 					playerBalance+=animals[lastId].value;
1148 					delete animals[lastId];
1149 				}
1150 				//if the last animal does not belong to the player, replace the players animal by this last one
1151 				if (numAnimals > i + 1) {
1152 				    playerBalance+=animals[ids[i]].value;
1153 					replaceAnimal(i);
1154 				}
1155 			}
1156 		}
1157 	}
1158 
1159 
1160 	/**
1161 	 * Replaces the animal with the given id with the last animal in the array
1162 	 * */
1163 	function replaceAnimal(uint16 index) internal {
1164 		numAnimalsXType[animals[ids[index]].animalType]--;
1165 		numAnimals--;
1166 		uint32 lastId = ids[numAnimals];
1167 		animals[ids[index]] = animals[lastId];
1168 		ids[index] = lastId;
1169 		delete ids[numAnimals];
1170 	}
1171 
1172 
1173 	/**
1174 	 * manually triggers the attack. cannot be called afterwards, except
1175 	 * by the owner if and only if the attack wasn't launched as supposed, signifying
1176 	 * an error ocurred during the last invocation of oraclize, or there wasn't enough ether to pay the gas
1177 	 * */
1178 	function triggerAttackManually(uint32 inseconds) {
1179 		if (!(msg.sender == owner && nextAttackTimestamp < now + 300)) throw;
1180 		triggerAttack(inseconds, (oraclizeGas + 10000 * numAnimals));
1181 	}
1182 
1183 	/**
1184 	 * sends a query to oraclize in order to get random numbers in 'inseconds' seconds
1185 	 */
1186 	function triggerAttack(uint32 inseconds, uint128 gasAmount) internal {
1187 		nextAttackTimestamp = now + inseconds;
1188 		nextAttackId = oraclize_query(nextAttackTimestamp, queryType, randomQuery, gasAmount );
1189 	}
1190 
1191 	/**
1192 	 * The actual predator attack.
1193 	 * The predator kills up to 10 animals, but in case there are less than 100 animals in the game up to 10% get eaten.
1194 	 * */
1195 	function __callback(bytes32 myid, string result) {
1196 		if (msg.sender != oraclize_cbAddress() || myid != nextAttackId) throw; // just to be sure the calling address is the Oraclize authorized one and the callback is the expected one   
1197 		uint128 pot;
1198 		uint16 random;
1199 		uint16 howmany = numAnimals < 100 ? (numAnimals < 10 ? 1 : numAnimals / 10) : 10; //do not kill more than 10%, but at least one
1200 		uint16[] memory randomNumbers = getNumbersFromString(result, ",", howmany);
1201 		uint32[] memory killedAnimals = new uint32[](howmany);
1202 		for (uint8 i = 0; i < howmany; i++) {
1203 			random = mapToNewRange(randomNumbers[i], numAnimals);
1204 			killedAnimals[i] = ids[random];
1205 			pot += killAnimal(random);
1206 		}
1207 		uint128 neededGas = oraclizeGas + 10000*numAnimals;
1208 		uint128 gasCost = uint128(neededGas * tx.gasprice);
1209 		if (pot > gasCost)
1210 			distribute(uint128(pot - gasCost)); //distribute the pot minus the oraclize gas costs
1211 		triggerAttack(timeTillNextAttack(), neededGas);
1212 		newAttack(killedAnimals);
1213 	}
1214 
1215 	/**
1216 	 * the frequency of the shark attacks depends on the number of animals in the game. 
1217 	 * many animals -> many shark attacks
1218 	 * at least one attack in 24 hours
1219 	 * */
1220 	function timeTillNextAttack() constant internal returns(uint32) {
1221 		return (86400 / (1 + numAnimals / 100));
1222 	}
1223 
1224 
1225 	/**
1226 	 * kills the animal of the given type at the given index. 
1227 	 * */
1228 	function killAnimal(uint16 index) internal returns(uint128 animalValue) {
1229 		animalValue = animals[ids[index]].value;
1230 		replaceAnimal(index);
1231 		if (ids[index] == oldest)
1232 			oldest = 0;
1233 	}
1234 
1235 	/**
1236 	 * finds the oldest animal
1237 	 * */
1238 	function findOldest() internal returns(uint128 animalValue) {
1239 		oldest = ids[0];
1240 		for (uint16 i = 1; i < numAnimals; i++){
1241 			if(ids[i] < oldest)//the oldest animal has the lowest id
1242 				oldest = ids[i];
1243 		}
1244 	}
1245 
1246 
1247 	/** distributes the given amount among the surviving fishes*/
1248 	function distribute(uint128 totalAmount) internal {
1249 		//pay 10% to the oldest fish
1250 		if (oldest == 0)
1251 			findOldest();
1252 		animals[oldest].value += totalAmount / 10;
1253 		uint128 amount = totalAmount / 10 * 9;
1254 		//distribute the rest according to their type
1255 		uint128 valueSum;
1256 		uint128[] memory shares = new uint128[](values.length);
1257 		for (uint8 v = 0; v < values.length; v++) {
1258 			if (numAnimalsXType[v] > 0) valueSum += values[v];
1259 		}
1260 		for (uint8 m = 0; m < values.length; m++) {
1261 		    if(numAnimalsXType[m] > 0)
1262 			    shares[m] =  amount * values[m] / valueSum / numAnimalsXType[m];
1263 		}
1264 		for (uint16 i = 0; i < numAnimals; i++) {
1265 			animals[ids[i]].value += shares[animals[ids[i]].animalType];
1266 		}
1267 
1268 	}
1269 
1270 	/**
1271 	 * allows the owner to collect the accumulated fees
1272 	 * sends the given amount to the owner's address if the amount does not exceed the
1273 	 * fees (cannot touch the players' balances) minus 100 finney (ensure that oraclize fees can be paid)
1274 	 * */
1275 	function collectFees(uint128 amount) {
1276 		if (!(msg.sender == owner)) throw;
1277 		uint collectedFees = getFees();
1278 		if (amount + 100 finney < collectedFees) {
1279 			if (!owner.send(amount)) throw;
1280 		}
1281 	}
1282 
1283 	/**
1284 	 * pays out the players and kills the game.
1285 	 * */
1286 	function stop() {
1287 		if (!(msg.sender == owner)) throw;
1288 		for (uint16 i = 0; i < numAnimals; i++) {
1289 			animals[ids[i]].owner.send(animals[ids[i]].value);
1290 		}
1291 		kill();
1292 	}
1293 
1294 	/**
1295 	 * adds a new animal type to the game
1296 	 * max. number of animal types: 100
1297 	 * the cost may not be lower than costs[0]
1298 	 * */
1299 	function addAnimalType(uint128 cost) {
1300 		if (!(msg.sender == owner)) throw;
1301 		costs.push(cost);
1302 		values.push(cost / 100 * fee);
1303 	}
1304 
1305 	function sellAnimal(uint32 animalId){
1306         if(msg.sender!=animals[animalId].owner) throw;
1307         uint128 val = animals[animalId].value;
1308         uint16 animalIndex;
1309         for(uint16 i = 0; i < ids.length; i++){
1310             if(ids[i]==animalId){
1311                 animalIndex = i;
1312                 break;
1313             }
1314         }
1315         replaceAnimal(animalIndex);
1316         if(!msg.sender.send(val)) throw;
1317     }
1318 
1319 	/****************** GETTERS *************************/
1320 
1321 
1322 	function getPlayerBalance(address playerAddress) constant returns(uint128 playerBalance) {
1323 		for (uint16 i = 0; i < numAnimals; i++) {
1324 			if (animals[ids[i]].owner == playerAddress) playerBalance += animals[ids[i]].value;
1325 		}
1326 	}
1327 	
1328 	function getAnimal(uint32 animalId) constant returns(uint8, uint128, address){
1329 		return (animals[animalId].animalType,animals[animalId].value,animals[animalId].owner);
1330 	}
1331 	
1332 	function get10Animals(uint16 startIndex) constant returns(uint32[10] animalIds, uint8[10] types, uint128[10] values, address[10] owners) {
1333 		uint16 endIndex= startIndex+10 > numAnimals? numAnimals: startIndex+10;
1334 		uint8 j = 0;
1335 		uint32 id;
1336 		for (uint16 i = startIndex; i < endIndex; i++){
1337 			id=ids[i];
1338 			animalIds[j] = id;
1339 			types[j] = animals[id].animalType;
1340 			values[j] = animals[id].value;
1341 			owners[j] = animals[id].owner;
1342 			j++;
1343 		}
1344 		
1345 	}
1346 	
1347 
1348 	function getFees() constant returns(uint) {
1349 		uint reserved = 0;
1350 		for (uint16 j = 0; j < numAnimals; j++)
1351 			reserved += animals[ids[j]].value;
1352 		return address(this).balance - reserved;
1353 	}
1354 
1355 
1356 	/****************** SETTERS *************************/
1357 
1358 	function setOraclizeGas(uint32 newGas) {
1359 		if (!(msg.sender == owner)) throw;
1360 		oraclizeGas = newGas;
1361 	}
1362 
1363 	function setMaxAnimals(uint16 number) {
1364 		if (!(msg.sender == owner)) throw;
1365 		maxAnimals = number;
1366 	}
1367 
1368 
1369 	/************* HELPERS ****************/
1370 
1371 	/**
1372 	 * maps a given number to the new range (old range 1000)
1373 	 * */
1374 	function mapToNewRange(uint number, uint range) constant internal returns(uint16 randomNumber) {
1375 		return uint16(number * range / 1000);
1376 	}
1377 
1378 	/**
1379 	 * converts a string of numbers being separated by a given delimiter into an array of numbers (#howmany) 
1380 	 */
1381 	function getNumbersFromString(string s, string delimiter, uint16 howmany) constant internal returns(uint16[] numbers) {
1382 		strings.slice memory myresult = s.toSlice();
1383 		strings.slice memory delim = delimiter.toSlice();
1384 		numbers = new uint16[](howmany);
1385 		for (uint8 i = 0; i < howmany; i++) {
1386 			numbers[i] = uint16(parseInt(myresult.split(delim).toString()));
1387 		}
1388 		return numbers;
1389 	}
1390 
1391 }