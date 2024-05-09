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
31 pragma solidity ^0.4.8;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
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
314 library strings {
315     struct slice {
316         uint _len;
317         uint _ptr;
318     }
319 
320     function memcpy(uint dest, uint src, uint len) private {
321         // Copy word-length chunks while possible
322         for(; len >= 32; len -= 32) {
323             assembly {
324                 mstore(dest, mload(src))
325             }
326             dest += 32;
327             src += 32;
328         }
329 
330         // Copy remaining bytes
331         uint mask = 256 ** (32 - len) - 1;
332         assembly {
333             let srcpart := and(mload(src), not(mask))
334             let destpart := and(mload(dest), mask)
335             mstore(dest, or(destpart, srcpart))
336         }
337     }
338 
339     /**
340      * @dev Returns a slice containing the entire string.
341      * @param self The string to make a slice from.
342      * @return A newly allocated slice containing the entire string.
343      */
344     function toSlice(string self) internal returns (slice) {
345         uint ptr;
346         assembly {
347             ptr := add(self, 0x20)
348         }
349         return slice(bytes(self).length, ptr);
350     }
351 
352     /**
353      * @dev Returns the length of a null-terminated bytes32 string.
354      * @param self The value to find the length of.
355      * @return The length of the string, from 0 to 32.
356      */
357     function len(bytes32 self) internal returns (uint) {
358         uint ret;
359         if (self == 0)
360             return 0;
361         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
362             ret += 16;
363             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
364         }
365         if (self & 0xffffffffffffffff == 0) {
366             ret += 8;
367             self = bytes32(uint(self) / 0x10000000000000000);
368         }
369         if (self & 0xffffffff == 0) {
370             ret += 4;
371             self = bytes32(uint(self) / 0x100000000);
372         }
373         if (self & 0xffff == 0) {
374             ret += 2;
375             self = bytes32(uint(self) / 0x10000);
376         }
377         if (self & 0xff == 0) {
378             ret += 1;
379         }
380         return 32 - ret;
381     }
382 
383     /**
384      * @dev Returns a slice containing the entire bytes32, interpreted as a
385      *      null-termintaed utf-8 string.
386      * @param self The bytes32 value to convert to a slice.
387      * @return A new slice containing the value of the input argument up to the
388      *         first null.
389      */
390     function toSliceB32(bytes32 self) internal returns (slice ret) {
391         // Allocate space for `self` in memory, copy it there, and point ret at it
392         assembly {
393             let ptr := mload(0x40)
394             mstore(0x40, add(ptr, 0x20))
395             mstore(ptr, self)
396             mstore(add(ret, 0x20), ptr)
397         }
398         ret._len = len(self);
399     }
400 
401     /**
402      * @dev Returns a new slice containing the same data as the current slice.
403      * @param self The slice to copy.
404      * @return A new slice containing the same data as `self`.
405      */
406     function copy(slice self) internal returns (slice) {
407         return slice(self._len, self._ptr);
408     }
409 
410     /**
411      * @dev Copies a slice to a new string.
412      * @param self The slice to copy.
413      * @return A newly allocated string containing the slice's text.
414      */
415     function toString(slice self) internal returns (string) {
416         var ret = new string(self._len);
417         uint retptr;
418         assembly { retptr := add(ret, 32) }
419 
420         memcpy(retptr, self._ptr, self._len);
421         return ret;
422     }
423 
424     /**
425      * @dev Returns the length in runes of the slice. Note that this operation
426      *      takes time proportional to the length of the slice; avoid using it
427      *      in loops, and call `slice.empty()` if you only need to know whether
428      *      the slice is empty or not.
429      * @param self The slice to operate on.
430      * @return The length of the slice in runes.
431      */
432     function len(slice self) internal returns (uint) {
433         // Starting at ptr-31 means the LSB will be the byte we care about
434         var ptr = self._ptr - 31;
435         var end = ptr + self._len;
436         for (uint len = 0; ptr < end; len++) {
437             uint8 b;
438             assembly { b := and(mload(ptr), 0xFF) }
439             if (b < 0x80) {
440                 ptr += 1;
441             } else if(b < 0xE0) {
442                 ptr += 2;
443             } else if(b < 0xF0) {
444                 ptr += 3;
445             } else if(b < 0xF8) {
446                 ptr += 4;
447             } else if(b < 0xFC) {
448                 ptr += 5;
449             } else {
450                 ptr += 6;
451             }
452         }
453         return len;
454     }
455 
456     /**
457      * @dev Returns true if the slice is empty (has a length of 0).
458      * @param self The slice to operate on.
459      * @return True if the slice is empty, False otherwise.
460      */
461     function empty(slice self) internal returns (bool) {
462         return self._len == 0;
463     }
464 
465     /**
466      * @dev Returns a positive number if `other` comes lexicographically after
467      *      `self`, a negative number if it comes before, or zero if the
468      *      contents of the two slices are equal. Comparison is done per-rune,
469      *      on unicode codepoints.
470      * @param self The first slice to compare.
471      * @param other The second slice to compare.
472      * @return The result of the comparison.
473      */
474     function compare(slice self, slice other) internal returns (int) {
475         uint shortest = self._len;
476         if (other._len < self._len)
477             shortest = other._len;
478 
479         var selfptr = self._ptr;
480         var otherptr = other._ptr;
481         for (uint idx = 0; idx < shortest; idx += 32) {
482             uint a;
483             uint b;
484             assembly {
485                 a := mload(selfptr)
486                 b := mload(otherptr)
487             }
488             if (a != b) {
489                 // Mask out irrelevant bytes and check again
490                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
491                 var diff = (a & mask) - (b & mask);
492                 if (diff != 0)
493                     return int(diff);
494             }
495             selfptr += 32;
496             otherptr += 32;
497         }
498         return int(self._len) - int(other._len);
499     }
500 
501     /**
502      * @dev Returns true if the two slices contain the same text.
503      * @param self The first slice to compare.
504      * @param self The second slice to compare.
505      * @return True if the slices are equal, false otherwise.
506      */
507     function equals(slice self, slice other) internal returns (bool) {
508         return compare(self, other) == 0;
509     }
510 
511     /**
512      * @dev Extracts the first rune in the slice into `rune`, advancing the
513      *      slice to point to the next rune and returning `self`.
514      * @param self The slice to operate on.
515      * @param rune The slice that will contain the first rune.
516      * @return `rune`.
517      */
518     function nextRune(slice self, slice rune) internal returns (slice) {
519         rune._ptr = self._ptr;
520 
521         if (self._len == 0) {
522             rune._len = 0;
523             return rune;
524         }
525 
526         uint len;
527         uint b;
528         // Load the first byte of the rune into the LSBs of b
529         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
530         if (b < 0x80) {
531             len = 1;
532         } else if(b < 0xE0) {
533             len = 2;
534         } else if(b < 0xF0) {
535             len = 3;
536         } else {
537             len = 4;
538         }
539 
540         // Check for truncated codepoints
541         if (len > self._len) {
542             rune._len = self._len;
543             self._ptr += self._len;
544             self._len = 0;
545             return rune;
546         }
547 
548         self._ptr += len;
549         self._len -= len;
550         rune._len = len;
551         return rune;
552     }
553 
554     /**
555      * @dev Returns the first rune in the slice, advancing the slice to point
556      *      to the next rune.
557      * @param self The slice to operate on.
558      * @return A slice containing only the first rune from `self`.
559      */
560     function nextRune(slice self) internal returns (slice ret) {
561         nextRune(self, ret);
562     }
563 
564     /**
565      * @dev Returns the number of the first codepoint in the slice.
566      * @param self The slice to operate on.
567      * @return The number of the first codepoint in the slice.
568      */
569     function ord(slice self) internal returns (uint ret) {
570         if (self._len == 0) {
571             return 0;
572         }
573 
574         uint word;
575         uint len;
576         uint div = 2 ** 248;
577 
578         // Load the rune into the MSBs of b
579         assembly { word:= mload(mload(add(self, 32))) }
580         var b = word / div;
581         if (b < 0x80) {
582             ret = b;
583             len = 1;
584         } else if(b < 0xE0) {
585             ret = b & 0x1F;
586             len = 2;
587         } else if(b < 0xF0) {
588             ret = b & 0x0F;
589             len = 3;
590         } else {
591             ret = b & 0x07;
592             len = 4;
593         }
594 
595         // Check for truncated codepoints
596         if (len > self._len) {
597             return 0;
598         }
599 
600         for (uint i = 1; i < len; i++) {
601             div = div / 256;
602             b = (word / div) & 0xFF;
603             if (b & 0xC0 != 0x80) {
604                 // Invalid UTF-8 sequence
605                 return 0;
606             }
607             ret = (ret * 64) | (b & 0x3F);
608         }
609 
610         return ret;
611     }
612 
613     /**
614      * @dev Returns the keccak-256 hash of the slice.
615      * @param self The slice to hash.
616      * @return The hash of the slice.
617      */
618     function keccak(slice self) internal returns (bytes32 ret) {
619         assembly {
620             ret := sha3(mload(add(self, 32)), mload(self))
621         }
622     }
623 
624     /**
625      * @dev Returns true if `self` starts with `needle`.
626      * @param self The slice to operate on.
627      * @param needle The slice to search for.
628      * @return True if the slice starts with the provided text, false otherwise.
629      */
630     function startsWith(slice self, slice needle) internal returns (bool) {
631         if (self._len < needle._len) {
632             return false;
633         }
634 
635         if (self._ptr == needle._ptr) {
636             return true;
637         }
638 
639         bool equal;
640         assembly {
641             let len := mload(needle)
642             let selfptr := mload(add(self, 0x20))
643             let needleptr := mload(add(needle, 0x20))
644             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
645         }
646         return equal;
647     }
648 
649     /**
650      * @dev If `self` starts with `needle`, `needle` is removed from the
651      *      beginning of `self`. Otherwise, `self` is unmodified.
652      * @param self The slice to operate on.
653      * @param needle The slice to search for.
654      * @return `self`
655      */
656     function beyond(slice self, slice needle) internal returns (slice) {
657         if (self._len < needle._len) {
658             return self;
659         }
660 
661         bool equal = true;
662         if (self._ptr != needle._ptr) {
663             assembly {
664                 let len := mload(needle)
665                 let selfptr := mload(add(self, 0x20))
666                 let needleptr := mload(add(needle, 0x20))
667                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
668             }
669         }
670 
671         if (equal) {
672             self._len -= needle._len;
673             self._ptr += needle._len;
674         }
675 
676         return self;
677     }
678 
679     /**
680      * @dev Returns true if the slice ends with `needle`.
681      * @param self The slice to operate on.
682      * @param needle The slice to search for.
683      * @return True if the slice starts with the provided text, false otherwise.
684      */
685     function endsWith(slice self, slice needle) internal returns (bool) {
686         if (self._len < needle._len) {
687             return false;
688         }
689 
690         var selfptr = self._ptr + self._len - needle._len;
691 
692         if (selfptr == needle._ptr) {
693             return true;
694         }
695 
696         bool equal;
697         assembly {
698             let len := mload(needle)
699             let needleptr := mload(add(needle, 0x20))
700             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
701         }
702 
703         return equal;
704     }
705 
706     /**
707      * @dev If `self` ends with `needle`, `needle` is removed from the
708      *      end of `self`. Otherwise, `self` is unmodified.
709      * @param self The slice to operate on.
710      * @param needle The slice to search for.
711      * @return `self`
712      */
713     function until(slice self, slice needle) internal returns (slice) {
714         if (self._len < needle._len) {
715             return self;
716         }
717 
718         var selfptr = self._ptr + self._len - needle._len;
719         bool equal = true;
720         if (selfptr != needle._ptr) {
721             assembly {
722                 let len := mload(needle)
723                 let needleptr := mload(add(needle, 0x20))
724                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
725             }
726         }
727 
728         if (equal) {
729             self._len -= needle._len;
730         }
731 
732         return self;
733     }
734 
735     // Returns the memory address of the first byte of the first occurrence of
736     // `needle` in `self`, or the first byte after `self` if not found.
737     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
738         uint ptr;
739         uint idx;
740 
741         if (needlelen <= selflen) {
742             if (needlelen <= 32) {
743                 // Optimized assembly for 68 gas per byte on short strings
744                 assembly {
745                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
746                     let needledata := and(mload(needleptr), mask)
747                     let end := add(selfptr, sub(selflen, needlelen))
748                     ptr := selfptr
749                     loop:
750                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
751                     ptr := add(ptr, 1)
752                     jumpi(loop, lt(sub(ptr, 1), end))
753                     ptr := add(selfptr, selflen)
754                     exit:
755                 }
756                 return ptr;
757             } else {
758                 // For long needles, use hashing
759                 bytes32 hash;
760                 assembly { hash := sha3(needleptr, needlelen) }
761                 ptr = selfptr;
762                 for (idx = 0; idx <= selflen - needlelen; idx++) {
763                     bytes32 testHash;
764                     assembly { testHash := sha3(ptr, needlelen) }
765                     if (hash == testHash)
766                         return ptr;
767                     ptr += 1;
768                 }
769             }
770         }
771         return selfptr + selflen;
772     }
773 
774     // Returns the memory address of the first byte after the last occurrence of
775     // `needle` in `self`, or the address of `self` if not found.
776     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
777         uint ptr;
778 
779         if (needlelen <= selflen) {
780             if (needlelen <= 32) {
781                 // Optimized assembly for 69 gas per byte on short strings
782                 assembly {
783                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
784                     let needledata := and(mload(needleptr), mask)
785                     ptr := add(selfptr, sub(selflen, needlelen))
786                     loop:
787                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
788                     ptr := sub(ptr, 1)
789                     jumpi(loop, gt(add(ptr, 1), selfptr))
790                     ptr := selfptr
791                     jump(exit)
792                     ret:
793                     ptr := add(ptr, needlelen)
794                     exit:
795                 }
796                 return ptr;
797             } else {
798                 // For long needles, use hashing
799                 bytes32 hash;
800                 assembly { hash := sha3(needleptr, needlelen) }
801                 ptr = selfptr + (selflen - needlelen);
802                 while (ptr >= selfptr) {
803                     bytes32 testHash;
804                     assembly { testHash := sha3(ptr, needlelen) }
805                     if (hash == testHash)
806                         return ptr + needlelen;
807                     ptr -= 1;
808                 }
809             }
810         }
811         return selfptr;
812     }
813 
814     /**
815      * @dev Modifies `self` to contain everything from the first occurrence of
816      *      `needle` to the end of the slice. `self` is set to the empty slice
817      *      if `needle` is not found.
818      * @param self The slice to search and modify.
819      * @param needle The text to search for.
820      * @return `self`.
821      */
822     function find(slice self, slice needle) internal returns (slice) {
823         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
824         self._len -= ptr - self._ptr;
825         self._ptr = ptr;
826         return self;
827     }
828 
829     /**
830      * @dev Modifies `self` to contain the part of the string from the start of
831      *      `self` to the end of the first occurrence of `needle`. If `needle`
832      *      is not found, `self` is set to the empty slice.
833      * @param self The slice to search and modify.
834      * @param needle The text to search for.
835      * @return `self`.
836      */
837     function rfind(slice self, slice needle) internal returns (slice) {
838         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
839         self._len = ptr - self._ptr;
840         return self;
841     }
842 
843     /**
844      * @dev Splits the slice, setting `self` to everything after the first
845      *      occurrence of `needle`, and `token` to everything before it. If
846      *      `needle` does not occur in `self`, `self` is set to the empty slice,
847      *      and `token` is set to the entirety of `self`.
848      * @param self The slice to split.
849      * @param needle The text to search for in `self`.
850      * @param token An output parameter to which the first token is written.
851      * @return `token`.
852      */
853     function split(slice self, slice needle, slice token) internal returns (slice) {
854         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
855         token._ptr = self._ptr;
856         token._len = ptr - self._ptr;
857         if (ptr == self._ptr + self._len) {
858             // Not found
859             self._len = 0;
860         } else {
861             self._len -= token._len + needle._len;
862             self._ptr = ptr + needle._len;
863         }
864         return token;
865     }
866 
867     /**
868      * @dev Splits the slice, setting `self` to everything after the first
869      *      occurrence of `needle`, and returning everything before it. If
870      *      `needle` does not occur in `self`, `self` is set to the empty slice,
871      *      and the entirety of `self` is returned.
872      * @param self The slice to split.
873      * @param needle The text to search for in `self`.
874      * @return The part of `self` up to the first occurrence of `delim`.
875      */
876     function split(slice self, slice needle) internal returns (slice token) {
877         split(self, needle, token);
878     }
879 
880     /**
881      * @dev Splits the slice, setting `self` to everything before the last
882      *      occurrence of `needle`, and `token` to everything after it. If
883      *      `needle` does not occur in `self`, `self` is set to the empty slice,
884      *      and `token` is set to the entirety of `self`.
885      * @param self The slice to split.
886      * @param needle The text to search for in `self`.
887      * @param token An output parameter to which the first token is written.
888      * @return `token`.
889      */
890     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
891         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
892         token._ptr = ptr;
893         token._len = self._len - (ptr - self._ptr);
894         if (ptr == self._ptr) {
895             // Not found
896             self._len = 0;
897         } else {
898             self._len -= token._len + needle._len;
899         }
900         return token;
901     }
902 
903     /**
904      * @dev Splits the slice, setting `self` to everything before the last
905      *      occurrence of `needle`, and returning everything after it. If
906      *      `needle` does not occur in `self`, `self` is set to the empty slice,
907      *      and the entirety of `self` is returned.
908      * @param self The slice to split.
909      * @param needle The text to search for in `self`.
910      * @return The part of `self` after the last occurrence of `delim`.
911      */
912     function rsplit(slice self, slice needle) internal returns (slice token) {
913         rsplit(self, needle, token);
914     }
915 
916     /**
917      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
918      * @param self The slice to search.
919      * @param needle The text to search for in `self`.
920      * @return The number of occurrences of `needle` found in `self`.
921      */
922     function count(slice self, slice needle) internal returns (uint count) {
923         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
924         while (ptr <= self._ptr + self._len) {
925             count++;
926             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
927         }
928     }
929 
930     /**
931      * @dev Returns True if `self` contains `needle`.
932      * @param self The slice to search.
933      * @param needle The text to search for in `self`.
934      * @return True if `needle` is found in `self`, false otherwise.
935      */
936     function contains(slice self, slice needle) internal returns (bool) {
937         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
938     }
939 
940     /**
941      * @dev Returns a newly allocated string containing the concatenation of
942      *      `self` and `other`.
943      * @param self The first slice to concatenate.
944      * @param other The second slice to concatenate.
945      * @return The concatenation of the two strings.
946      */
947     function concat(slice self, slice other) internal returns (string) {
948         var ret = new string(self._len + other._len);
949         uint retptr;
950         assembly { retptr := add(ret, 32) }
951         memcpy(retptr, self._ptr, self._len);
952         memcpy(retptr + self._len, other._ptr, other._len);
953         return ret;
954     }
955 
956     /**
957      * @dev Joins an array of slices, using `self` as a delimiter, returning a
958      *      newly allocated string.
959      * @param self The delimiter to use.
960      * @param parts A list of slices to join.
961      * @return A newly allocated string containing all the slices in `parts`,
962      *         joined with `self`.
963      */
964     function join(slice self, slice[] parts) internal returns (string) {
965         if (parts.length == 0)
966             return "";
967 
968         uint len = self._len * (parts.length - 1);
969         for(uint i = 0; i < parts.length; i++)
970             len += parts[i]._len;
971 
972         var ret = new string(len);
973         uint retptr;
974         assembly { retptr := add(ret, 32) }
975 
976         for(i = 0; i < parts.length; i++) {
977             memcpy(retptr, parts[i]._ptr, parts[i]._len);
978             retptr += parts[i]._len;
979             if (i < parts.length - 1) {
980                 memcpy(retptr, self._ptr, self._len);
981                 retptr += self._len;
982             }
983         }
984 
985         return ret;
986     }
987 }
988 
989 
990 contract mortal {
991 	address owner;
992 
993 	function mortal() {
994 		owner = msg.sender;
995 	}
996 
997 	function kill() internal {
998 		suicide(owner);
999 	}
1000 }
1001 
1002 
1003 contract transferable {
1004 	function receive(address player, uint8 animalType, uint32[] animalIds) payable {}
1005 }
1006 
1007 contract Pray4Prey is mortal, usingOraclize, transferable {
1008 	using strings
1009 	for * ;
1010 
1011 	struct Animal {
1012 		uint8 animalType;
1013 		uint128 value;
1014 		address owner;
1015 	}
1016 
1017 	/** array holding ids of the curret animals*/
1018 	uint32[] public ids;
1019 	/** the id to be given to the net animal **/
1020 	uint32 public nextId;
1021 	/** the id of the oldest animal */
1022 	uint32 public oldest;
1023 	/** the animal belonging to a given id */
1024 	mapping(uint32 => Animal) animals;
1025 	/** the cost of each animal type */
1026 	uint128[] public costs;
1027 	/** the value of each animal type (cost - fee), so it's not necessary to compute it each time*/
1028 	uint128[] public values;
1029 	/** the fee to be paid each time an animal is bought in percent*/
1030 	uint8 fee;
1031 	/** specifies if animals may be transfered from old contract version */
1032 	bool transferAllowed;
1033 
1034 	/** total number of animals in the game (uint32 because of multiplication issues) */
1035 	uint32 public numAnimals;
1036 	/** The maximum of animals allowed in the game */
1037 	uint16 public maxAnimals;
1038 	/** number of animals per type */
1039 	mapping(uint8 => uint16) public numAnimalsXType;
1040 
1041 
1042 	/** the query string getting the random numbers from oraclize**/
1043 	string randomQuery;
1044 	/** the type of the oraclize query**/
1045 	string queryType;
1046 	/** the timestamp of the next attack **/
1047 	uint public nextAttackTimestamp;
1048 	/** gas provided for oraclize callback (attack)**/
1049 	uint32 public oraclizeGas;
1050 	/** the id of the next oraclize callback*/
1051 	bytes32 nextAttackId;
1052 
1053 
1054 	/** is fired when new animals are purchased (who bought how many animals of which type?) */
1055 	event newPurchase(address player, uint8 animalType, uint8 amount, uint32 startId);
1056 	/** is fired when a player leaves the game */
1057 	event newExit(address player, uint256 totalBalance, uint32[] removedAnimals);
1058 	/** is fired when an attack occures */
1059 	event newAttack(uint32[] killedAnimals);
1060 	/** is fired when a single animal is sold **/
1061 	event newSell(uint32 animalId, address player, uint256 value);
1062 
1063 
1064 	/** initializes the contract parameters	 (would be constructor if it wasn't for the gas limit)*/
1065 	function init() {
1066 		if(msg.sender != owner) throw;
1067 		costs = [100000000000000000, 200000000000000000, 500000000000000000, 1000000000000000000, 5000000000000000000];
1068 		fee = 5;
1069 		for (uint8 i = 0; i < costs.length; i++) {
1070 			values.push(costs[i] - costs[i] / 100 * fee);
1071 		}
1072 		maxAnimals = 300;
1073 		randomQuery = "10 random numbers between 1 and 1000";
1074 		queryType = "WolframAlpha";
1075 		oraclizeGas = 600000;
1076 		transferAllowed = true; //allow transfer from old contract
1077 		nextId = 150;
1078 		oldest = 150;
1079 	}
1080 
1081 	/** The fallback function runs whenever someone sends ether
1082 	   Depending of the value of the transaction the sender is either granted a prey or 
1083 	   the transaction is discarded and no ether accepted
1084 	   In the first case fees have to be paid*/
1085 	function() payable {
1086 		for (uint8 i = 0; i < costs.length; i++)
1087 			if (msg.value == costs[i])
1088 				addAnimals(i);
1089 
1090 		if (msg.value == 1000000000000000)
1091 			exit();
1092 		else
1093 			throw;
1094 
1095 	}
1096 
1097 	/** buy animals of a given type 
1098 	 *  as many animals as possible are bought with msg.value
1099 	 */
1100 	function addAnimals(uint8 animalType) payable {
1101 		giveAnimals(animalType, msg.sender);
1102 	}
1103 
1104 	/** buy animals of a given type forsomeone else
1105 	 *  as many animals as possible are bought with msg.value
1106 	 */
1107 	function giveAnimals(uint8 animalType, address receiver) payable {
1108 		uint8 amount = uint8(msg.value / costs[animalType]);
1109 		if (animalType >= costs.length || msg.value < costs[animalType] || numAnimals + amount >= maxAnimals) throw;
1110 		//if type exists, enough ether was transferred and there are less than maxAnimals animals in the game
1111 		for (uint8 j = 0; j < amount; j++) {
1112 			addAnimal(animalType, receiver, nextId);
1113 			nextId++;
1114 		}
1115 		numAnimalsXType[animalType] += amount;
1116 		newPurchase(receiver, animalType, amount, nextId - amount);
1117 	}
1118 
1119 	/**
1120 	 *  adds a single animal of the given type
1121 	 */
1122 	function addAnimal(uint8 animalType, address receiver, uint32 nId) internal {
1123 		if (numAnimals < ids.length)
1124 			ids[numAnimals] = nId;
1125 		else
1126 			ids.push(nId);
1127 		if(nId<oldest) 
1128 			oldest = nId;
1129 		animals[nId] = Animal(animalType, values[animalType], receiver);
1130 		numAnimals++;
1131 	}
1132 
1133 
1134 
1135 	/** leave the game
1136 	 * pays out the sender's winBalance and removes him and his animals from the game
1137 	 * */
1138 	function exit() {
1139 		uint32[] memory removed = new uint32[](50);
1140 		uint8 count;
1141 		uint32 lastId;
1142 		uint playerBalance;
1143 		for (uint16 i = 0; i < numAnimals; i++) {
1144 			if (animals[ids[i]].owner == msg.sender) {
1145 				//first delete all animals at the end of the array
1146 				while (numAnimals > 0 && animals[ids[numAnimals - 1]].owner == msg.sender) {
1147 					numAnimals--;
1148 					lastId = ids[numAnimals];
1149 					numAnimalsXType[animals[lastId].animalType]--;
1150 					playerBalance += animals[lastId].value;
1151 					removed[count] = lastId;
1152 					count++;
1153 					if (lastId == oldest) oldest = 0;
1154 					delete animals[lastId];
1155 				}
1156 				//if the last animal does not belong to the player, replace the players animal by this last one
1157 				if (numAnimals > i + 1) {
1158 					playerBalance += animals[ids[i]].value;
1159 					removed[count] = ids[i];
1160 					count++;
1161 					replaceAnimal(i);
1162 				}
1163 			}
1164 		}
1165 		newExit(msg.sender, playerBalance, removed); //fire the event to notify the client
1166 		if (!msg.sender.send(playerBalance)) throw;
1167 	}
1168 
1169 
1170 	/**
1171 	 * Replaces the animal with the given id with the last animal in the array
1172 	 * */
1173 	function replaceAnimal(uint16 index) internal {
1174 		uint32 animalId = ids[index];
1175 		numAnimalsXType[animals[animalId].animalType]--;
1176 		numAnimals--;
1177 		if (animalId == oldest) oldest = 0;
1178 		delete animals[animalId];
1179 		ids[index] = ids[numAnimals];
1180 		delete ids[numAnimals];
1181 	}
1182 
1183 
1184 	/**
1185 	 * manually triggers the attack. cannot be called afterwards, except
1186 	 * by the owner if and only if the attack wasn't launched as supposed, signifying
1187 	 * an error ocurred during the last invocation of oraclize, or there wasn't enough ether to pay the gas
1188 	 * */
1189 	function triggerAttackManually(uint32 inseconds) {
1190 		if (!(msg.sender == owner && nextAttackTimestamp < now + 300)) throw;
1191 		triggerAttack(inseconds, (oraclizeGas + 10000 * numAnimals));
1192 	}
1193 
1194 	/**
1195 	 * sends a query to oraclize in order to get random numbers in 'inseconds' seconds
1196 	 */
1197 	function triggerAttack(uint32 inseconds, uint128 gasAmount) internal {
1198 		nextAttackTimestamp = now + inseconds;
1199 		nextAttackId = oraclize_query(nextAttackTimestamp, queryType, randomQuery, gasAmount);
1200 	}
1201 
1202 	/**
1203 	 * The actual predator attack.
1204 	 * The predator kills up to 10 animals, but in case there are less than 100 animals in the game up to 10% get eaten.
1205 	 * */
1206 	function __callback(bytes32 myid, string result) {
1207 		if (msg.sender != oraclize_cbAddress() || myid != nextAttackId) throw; // just to be sure the calling address is the Oraclize authorized one and the callback is the expected one   
1208 		uint128 pot;
1209 		uint16 random;
1210 		uint32 howmany = numAnimals < 100 ? (numAnimals < 10 ? 1 : numAnimals / 10) : 10; //do not kill more than 10%, but at least one
1211 		uint16[] memory randomNumbers = getNumbersFromString(result, ",", howmany);
1212 		uint32[] memory killedAnimals = new uint32[](howmany);
1213 		for (uint8 i = 0; i < howmany; i++) {
1214 			random = mapToNewRange(randomNumbers[i], numAnimals);
1215 			killedAnimals[i] = ids[random];
1216 			pot += killAnimal(random);
1217 		}
1218 		uint128 neededGas = oraclizeGas + 10000 * numAnimals;
1219 		uint128 gasCost = uint128(neededGas * tx.gasprice);
1220 		if (pot > gasCost)
1221 			distribute(uint128(pot - gasCost)); //distribute the pot minus the oraclize gas costs
1222 		triggerAttack(timeTillNextAttack(), neededGas);
1223 		newAttack(killedAnimals);
1224 	}
1225 
1226 	/**
1227 	 * the frequency of the shark attacks depends on the number of animals in the game. 
1228 	 * many animals -> many shark attacks
1229 	 * at least one attack in 24 hours
1230 	 * */
1231 	function timeTillNextAttack() constant internal returns(uint32) {
1232 		return (86400 / (1 + numAnimals / 100));
1233 	}
1234 
1235 
1236 	/**
1237 	 * kills the animal of the given type at the given index. 
1238 	 * */
1239 	function killAnimal(uint16 index) internal returns(uint128 animalValue) {
1240 		animalValue = animals[ids[index]].value;
1241 		replaceAnimal(index);
1242 	}
1243 
1244 	/**
1245 	 * finds the oldest animal
1246 	 * */
1247 	function findOldest() {
1248 		oldest = ids[0];
1249 		for (uint16 i = 1; i < numAnimals; i++) {
1250 			if (ids[i] < oldest) //the oldest animal has the lowest id
1251 				oldest = ids[i];
1252 		}
1253 	}
1254 
1255 
1256 	/** distributes the given amount among the surviving fishes*/
1257 	function distribute(uint128 totalAmount) internal {
1258 		//pay 10% to the oldest fish
1259 		if (oldest == 0)
1260 			findOldest();
1261 		animals[oldest].value += totalAmount / 10;
1262 		uint128 amount = totalAmount / 10 * 9;
1263 		//distribute the rest according to their type
1264 		uint128 valueSum;
1265 		uint128[] memory shares = new uint128[](values.length);
1266 		for (uint8 v = 0; v < values.length; v++) {
1267 			if (numAnimalsXType[v] > 0) valueSum += values[v];
1268 		}
1269 		for (uint8 m = 0; m < values.length; m++) {
1270 			if (numAnimalsXType[m] > 0)
1271 				shares[m] = amount * values[m] / valueSum / numAnimalsXType[m];
1272 		}
1273 		for (uint16 i = 0; i < numAnimals; i++) {
1274 			animals[ids[i]].value += shares[animals[ids[i]].animalType];
1275 		}
1276 
1277 	}
1278 
1279 	/**
1280 	 * allows the owner to collect the accumulated fees
1281 	 * sends the given amount to the owner's address if the amount does not exceed the
1282 	 * fees (cannot touch the players' balances) minus 100 finney (ensure that oraclize fees can be paid)
1283 	 * */
1284 	function collectFees(uint128 amount) {
1285 		if (!(msg.sender == owner)) throw;
1286 		uint collectedFees = getFees();
1287 		if (amount + 100 finney < collectedFees) {
1288 			if (!owner.send(amount)) throw;
1289 		}
1290 	}
1291 
1292 	/**
1293 	 * pays out the players and kills the game.
1294 	 * */
1295 	function stop() {
1296 		if (!(msg.sender == owner)) throw;
1297 		for (uint16 i = 0; i < numAnimals; i++) {
1298 			if(!animals[ids[i]].owner.send(animals[ids[i]].value)) throw;
1299 		}
1300 		kill();
1301 	}
1302 
1303 
1304 	/**
1305 	 * sell the animal of the given id
1306 	 * */
1307 	function sellAnimal(uint32 animalId) {
1308 		if (msg.sender != animals[animalId].owner) throw;
1309 		uint128 val = animals[animalId].value;
1310 		uint16 animalIndex;
1311 		for (uint16 i = 0; i < ids.length; i++) {
1312 			if (ids[i] == animalId) {
1313 				animalIndex = i;
1314 				break;
1315 			}
1316 		}
1317 		replaceAnimal(animalIndex);
1318 		if (!msg.sender.send(val)) throw;
1319 		newSell(animalId, msg.sender, val);
1320 	}
1321 
1322 	/** transfers animals from one contract to another.
1323 	 *   for easier contract update.
1324 	 * */
1325 	function transfer(address contractAddress) {
1326 		transferable newP4P = transferable(contractAddress);
1327 		uint8[] memory numXType = new uint8[](costs.length);
1328 		mapping(uint16 => uint32[]) tids;
1329 		uint winnings;
1330 
1331 		for (uint16 i = 0; i < numAnimals; i++) {
1332 
1333 			if (animals[ids[i]].owner == msg.sender) {
1334 				Animal a = animals[ids[i]];
1335 				numXType[a.animalType]++;
1336 				winnings += a.value - values[a.animalType];
1337 				tids[a.animalType].push(ids[i]);
1338 				replaceAnimal(i);
1339 				i--;
1340 			}
1341 		}
1342 		for (i = 0; i < costs.length; i++){
1343 			if(numXType[i]>0){
1344 				newP4P.receive.value(numXType[i]*values[i])(msg.sender, uint8(i), tids[i]);
1345 			}
1346 			
1347 		}
1348 			
1349 		if(winnings>0 && !msg.sender.send(winnings)) throw;
1350 	}
1351 	
1352 	/**
1353 	*	receives animals from an old contract version.
1354 	* todo: evtl reset oldest
1355 	* */
1356 	function receive(address receiver, uint8 animalType, uint32[] oldids) payable {
1357 		if(!transferAllowed) throw; //for now manually allowing and disallowing, in next version instead only allow calls from old contract address
1358 		if (msg.value < oldids.length * values[animalType]) throw;
1359 		for (uint8 i = 0; i < oldids.length; i++) {
1360 			if (animals[oldids[i]].value == 0) {
1361 				addAnimal(animalType, receiver, oldids[i]);
1362 			} else {
1363 				addAnimal(animalType, receiver, nextId);
1364 				nextId++;
1365 			}
1366 		}
1367 	}
1368 
1369 	
1370 	
1371 	/****************** GETTERS *************************/
1372 
1373 
1374 	function getAnimal(uint32 animalId) constant returns(uint8, uint128, address) {
1375 		return (animals[animalId].animalType, animals[animalId].value, animals[animalId].owner);
1376 	}
1377 
1378 	function get10Animals(uint16 startIndex) constant returns(uint32[10] animalIds, uint8[10] types, uint128[10] values, address[10] owners) {
1379 		uint32 endIndex = startIndex + 10 > numAnimals ? numAnimals : startIndex + 10;
1380 		uint8 j = 0;
1381 		uint32 id;
1382 		for (uint16 i = startIndex; i < endIndex; i++) {
1383 			id = ids[i];
1384 			animalIds[j] = id;
1385 			types[j] = animals[id].animalType;
1386 			values[j] = animals[id].value;
1387 			owners[j] = animals[id].owner;
1388 			j++;
1389 		}
1390 
1391 	}
1392 
1393 
1394 	function getFees() constant returns(uint) {
1395 		uint reserved = 0;
1396 		for (uint16 j = 0; j < numAnimals; j++)
1397 			reserved += animals[ids[j]].value;
1398 		return address(this).balance - reserved;
1399 	}
1400 
1401 
1402 	/****************** SETTERS *************************/
1403 
1404 	function setOraclizeGas(uint32 newGas) {
1405 		if (!(msg.sender == owner)) throw;
1406 		oraclizeGas = newGas;
1407 	}
1408 
1409 	function setMaxAnimals(uint16 number) {
1410 		if (!(msg.sender == owner)) throw;
1411 		maxAnimals = number;
1412 	}
1413 	
1414 	function setTransferAllowance(bool isAllowed){
1415 		if (!(msg.sender == owner)) throw;
1416 		transferAllowed = isAllowed;
1417 	}
1418 
1419 	/************* HELPERS ****************/
1420 
1421 	/**
1422 	 * maps a given number to the new range (old range 1000)
1423 	 * */
1424 	function mapToNewRange(uint number, uint range) constant internal returns(uint16 randomNumber) {
1425 		return uint16(number * range / 1000);
1426 	}
1427 
1428 	/**
1429 	 * converts a string of numbers being separated by a given delimiter into an array of numbers (#howmany) 
1430 	 */
1431 	function getNumbersFromString(string s, string delimiter, uint32 howmany) constant internal returns(uint16[] numbers) {
1432 		strings.slice memory myresult = s.toSlice();
1433 		strings.slice memory delim = delimiter.toSlice();
1434 		numbers = new uint16[](howmany);
1435 		for (uint8 i = 0; i < howmany; i++) {
1436 			numbers[i] = uint16(parseInt(myresult.split(delim).toString()));
1437 		}
1438 		return numbers;
1439 	}
1440 
1441 }