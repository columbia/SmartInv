1 pragma solidity ^0.4.8;
2 
3 // <ORACLIZE_API>
4 /*
5 Copyright (c) 2015-2016 Oraclize SRL
6 Copyright (c) 2016 Oraclize LTD
7 
8 
9 
10 Permission is hereby granted, free of charge, to any person obtaining a copy
11 of this software and associated documentation files (the "Software"), to deal
12 in the Software without restriction, including without limitation the rights
13 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
14 copies of the Software, and to permit persons to whom the Software is
15 furnished to do so, subject to the following conditions:
16 
17 
18 
19 The above copyright notice and this permission notice shall be included in
20 all copies or substantial portions of the Software.
21 
22 
23 
24 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
25 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
26 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
27 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
28 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
29 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
30 THE SOFTWARE.
31 */
32 
33 pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
34 
35 contract OraclizeI {
36     address public cbAddress;
37     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
38     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
39     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
40     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
41     function getPrice(string _datasource) returns (uint _dsprice);
42     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
43     function useCoupon(string _coupon);
44     function setProofType(byte _proofType);
45     function setConfig(bytes32 _config);
46     function setCustomGasPrice(uint _gasPrice);
47 }
48 contract OraclizeAddrResolverI {
49     function getAddress() returns (address _addr);
50 }
51 contract usingOraclize {
52     uint constant day = 60*60*24;
53     uint constant week = 60*60*24*7;
54     uint constant month = 60*60*24*30;
55     byte constant proofType_NONE = 0x00;
56     byte constant proofType_TLSNotary = 0x10;
57     byte constant proofStorage_IPFS = 0x01;
58     uint8 constant networkID_auto = 0;
59     uint8 constant networkID_mainnet = 1;
60     uint8 constant networkID_testnet = 2;
61     uint8 constant networkID_morden = 2;
62     uint8 constant networkID_consensys = 161;
63 
64     OraclizeAddrResolverI OAR;
65     
66     OraclizeI oraclize;
67     modifier oraclizeAPI {
68         if(address(OAR)==0) oraclize_setNetwork(networkID_auto);
69         oraclize = OraclizeI(OAR.getAddress());
70         _;
71     }
72     modifier coupon(string code){
73         oraclize = OraclizeI(OAR.getAddress());
74         oraclize.useCoupon(code);
75         _;
76     }
77 
78     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
79         if (getCodeSize(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed)>0){ //mainnet
80             OAR = OraclizeAddrResolverI(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed);
81             return true;
82         }
83         if (getCodeSize(0xc03a2615d5efaf5f49f60b7bb6583eaec212fdf1)>0){ //ropsten testnet
84             OAR = OraclizeAddrResolverI(0xc03a2615d5efaf5f49f60b7bb6583eaec212fdf1);
85             return true;
86         }
87         if (getCodeSize(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf)>0){ //ether.camp ide
88             OAR = OraclizeAddrResolverI(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf);
89             return true;
90         }
91         if (getCodeSize(0x93bbbe5ce77034e3095f0479919962a903f898ad)>0){ //norsborg testnet
92             OAR = OraclizeAddrResolverI(0x93bbbe5ce77034e3095f0479919962a903f898ad);
93             return true;
94         }
95         if (getCodeSize(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa)>0){ //browser-solidity
96             OAR = OraclizeAddrResolverI(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa);
97             return true;
98         }
99         return false;
100     }
101     
102     function __callback(bytes32 myid, string result) {
103         __callback(myid, result, new bytes(0));
104     }
105     function __callback(bytes32 myid, string result, bytes proof) {
106     }
107     
108     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
109         return oraclize.getPrice(datasource);
110     }
111     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
112         return oraclize.getPrice(datasource, gaslimit);
113     }
114     
115     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
116         uint price = oraclize.getPrice(datasource);
117         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
118         return oraclize.query.value(price)(0, datasource, arg);
119     }
120     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
121         uint price = oraclize.getPrice(datasource);
122         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
123         return oraclize.query.value(price)(timestamp, datasource, arg);
124     }
125     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
126         uint price = oraclize.getPrice(datasource, gaslimit);
127         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
128         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
129     }
130     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
131         uint price = oraclize.getPrice(datasource, gaslimit);
132         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
133         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
134     }
135     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
136         uint price = oraclize.getPrice(datasource);
137         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
138         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
139     }
140     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
141         uint price = oraclize.getPrice(datasource);
142         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
143         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
144     }
145     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
146         uint price = oraclize.getPrice(datasource, gaslimit);
147         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
148         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
149     }
150     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
151         uint price = oraclize.getPrice(datasource, gaslimit);
152         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
153         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
154     }
155     function oraclize_cbAddress() oraclizeAPI internal returns (address){
156         return oraclize.cbAddress();
157     }
158     function oraclize_setProof(byte proofP) oraclizeAPI internal {
159         return oraclize.setProofType(proofP);
160     }
161     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
162         return oraclize.setCustomGasPrice(gasPrice);
163     }    
164     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
165         return oraclize.setConfig(config);
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
293     function uint2str(uint i) internal returns (string){
294         if (i == 0) return "0";
295         uint j = i;
296         uint len;
297         while (j != 0){
298             len++;
299             j /= 10;
300         }
301         bytes memory bstr = new bytes(len);
302         uint k = len - 1;
303         while (i != 0){
304             bstr[k--] = byte(48 + i % 10);
305             i /= 10;
306         }
307         return string(bstr);
308     }
309     
310     
311 
312 }
313 // </ORACLIZE_API>
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
1053 	/** is fired when an attack occures*/
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
1067 		/*randomQuery = "https://www.random.org/integers/?num=10&min=0&max=10000&col=1&base=10&format=plain&rnd=new";
1068 		queryType = "URL";*/
1069 		randomQuery = "10 random numbers between 1 and 1000";
1070 		queryType = "WolframAlpha";
1071 		oraclizeGas = 400000;
1072 		nextId = 1;
1073 		oldest = 1;
1074 	}
1075 
1076 	/** The fallback function runs whenever someone sends ether
1077 	   Depending of the value of the transaction the sender is either granted a prey or 
1078 	   the transaction is discarded and no ether accepted
1079 	   In the first case fees have to be paid*/
1080 	function() payable {
1081 		for (uint8 i = 0; i < costs.length; i++)
1082 			if (msg.value == costs[i])
1083 				addAnimals(i);
1084 
1085 		if (msg.value == 1000000000000000)
1086 			exit();
1087 		else
1088 			throw;
1089 
1090 	}
1091 
1092 	/** buy animals of a given type 
1093 	 *  as many animals as possible are bought with msg.value
1094 	 */
1095 	function addAnimals(uint8 animalType) payable {
1096 		uint8 amount = uint8(msg.value / costs[animalType]);
1097 		if (animalType >= costs.length || msg.value < costs[animalType] ||  numAnimals + amount >= maxAnimals) throw;
1098 		//if type exists, enough ether was transferred and there are less than maxAnimals animals in the game
1099 		for (uint8 j = 0; j < amount; j++) {
1100 			addAnimal(animalType);
1101 		}
1102 		numAnimalsXType[animalType] += amount;
1103 		newPurchase(msg.sender, animalType, amount, nextId-amount);
1104 	}
1105 
1106 	/**
1107 	 *  adds a single animal of the given type
1108 	 */
1109 	function addAnimal(uint8 animalType) internal {
1110 		if (numAnimals < ids.length)
1111 			ids[numAnimals] = nextId;
1112 		else
1113 			ids.push(nextId);
1114 		animals[nextId] = Animal(animalType, values[animalType], msg.sender);
1115 		nextId++;
1116 		numAnimals++;
1117 	}
1118 
1119 
1120 	/** leave the game
1121 	 * pays out the sender's winBalance and removes him and his animals from the game
1122 	 * */
1123 	function exit() {
1124 		uint balance = cleanUp(msg.sender); //delete the animals
1125 		newExit(msg.sender, balance); //fire the event to notify the client
1126 		if (!msg.sender.send(balance)) throw;
1127 	}
1128 
1129 	/**
1130 	 * Deletes the animals of a given player
1131 	 * */
1132 	function cleanUp(address playerAddress) internal returns(uint playerBalance){
1133 		uint32 lastId;
1134 		for (uint16 i = 0; i < numAnimals; i++) {
1135 			if (animals[ids[i]].owner == playerAddress) {
1136 				//first delete all animals at the end of the array
1137 				while (numAnimals > 0 && animals[ids[numAnimals - 1]].owner == playerAddress) {
1138 					numAnimals--;
1139 					lastId = ids[numAnimals];
1140 					numAnimalsXType[animals[lastId].animalType]--;
1141 					playerBalance+=animals[lastId].value;
1142 					delete animals[lastId];
1143 				}
1144 				//if the last animal does not belong to the player, replace the players animal by this last one
1145 				if (numAnimals > i + 1) {
1146 				    playerBalance+=animals[ids[i]].value;
1147 					replaceAnimal(i);
1148 				}
1149 			}
1150 		}
1151 	}
1152 
1153 
1154 	/**
1155 	 * Replaces the animal with the given id with the last animal in the array
1156 	 * */
1157 	function replaceAnimal(uint16 index) internal {
1158 		numAnimalsXType[animals[ids[index]].animalType]--;
1159 		numAnimals--;
1160 		uint32 lastId = ids[numAnimals];
1161 		animals[ids[index]] = animals[lastId];
1162 		ids[index] = lastId;
1163 		delete ids[numAnimals];
1164 	}
1165 
1166 
1167 	/**
1168 	 * manually triggers the attack. cannot be called afterwards, except
1169 	 * by the owner if and only if the attack wasn't launched as supposed, signifying
1170 	 * an error ocurred during the last invocation of oraclize, or there wasn't enough ether to pay the gas
1171 	 * */
1172 	function triggerAttackManually(uint32 inseconds) {
1173 		if (!(msg.sender == owner && nextAttackTimestamp < now + 300)) throw;
1174 		triggerAttack(inseconds, (oraclizeGas + 10000 * numAnimals));
1175 	}
1176 
1177 	/**
1178 	 * sends a query to oraclize in order to get random numbers in 'inseconds' seconds
1179 	 */
1180 	function triggerAttack(uint32 inseconds, uint128 gasAmount) internal {
1181 		nextAttackTimestamp = now + inseconds;
1182 		nextAttackId = oraclize_query(nextAttackTimestamp, queryType, randomQuery, gasAmount );
1183 	}
1184 
1185 	/**
1186 	 * The actual predator attack.
1187 	 * The predator kills up to 10 animals, but in case there are less than 100 animals in the game up to 10% get eaten.
1188 	 * */
1189 	function __callback(bytes32 myid, string result) {
1190 		if (msg.sender != oraclize_cbAddress() || myid != nextAttackId) throw; // just to be sure the calling address is the Oraclize authorized one and the callback is the expected one   
1191 		uint128 pot;
1192 		uint16 random;
1193 		uint16 howmany = numAnimals < 100 ? (numAnimals < 10 ? 1 : numAnimals / 10) : 10; //do not kill more than 10%, but at least one
1194 		uint16[] memory randomNumbers = getNumbersFromString(result, ",", howmany);
1195 		uint32[] memory killedAnimals = new uint32[](howmany);
1196 		for (uint8 i = 0; i < howmany; i++) {
1197 			random = mapToNewRange(randomNumbers[i], numAnimals);
1198 			killedAnimals[i] = ids[random];
1199 			pot += killAnimal(random);
1200 		}
1201 		uint128 neededGas = oraclizeGas + 10000*numAnimals;
1202 		uint128 gasCost = uint128(neededGas * tx.gasprice);
1203 		if (pot > gasCost)
1204 			distribute(uint128(pot - gasCost)); //distribute the pot minus the oraclize gas costs
1205 		triggerAttack(timeTillNextAttack(), neededGas);
1206 		newAttack(killedAnimals);
1207 	}
1208 
1209 	/**
1210 	 * the frequency of the shark attacks depends on the number of animals in the game. 
1211 	 * many animals -> many shark attacks
1212 	 * at least one attack in 24 hours
1213 	 * */
1214 	function timeTillNextAttack() constant internal returns(uint32) {
1215 		return (86400 / (1 + numAnimals / 100));
1216 	}
1217 
1218 
1219 	/**
1220 	 * kills the animal of the given type at the given index. 
1221 	 * */
1222 	function killAnimal(uint16 index) internal returns(uint128 animalValue) {
1223 		animalValue = animals[ids[index]].value;
1224 		replaceAnimal(index);
1225 		if (ids[index] == oldest)
1226 			oldest = 0;
1227 	}
1228 
1229 	/**
1230 	 * finds the oldest animal
1231 	 * */
1232 	function findOldest() internal returns(uint128 animalValue) {
1233 		oldest = ids[0];
1234 		for (uint16 i = 1; i < numAnimals; i++){
1235 			if(ids[i] < oldest)//the oldest animal has the lowest id
1236 				oldest = ids[i];
1237 		}
1238 	}
1239 
1240 
1241 	/** distributes the given amount among the surviving fishes*/
1242 	function distribute(uint128 amount) internal {
1243 		//pay 10% to the oldest fish
1244 		if (oldest == 0)
1245 			findOldest();
1246 		animals[oldest].value += amount / 10;
1247 		amount = amount / 10 * 9;
1248 		//distribute the rest according to their type
1249 		uint128 valueSum;
1250 		uint128[] memory shares = new uint128[](values.length);
1251 		for (uint8 v = 0; v < values.length; v++) {
1252 			if (numAnimalsXType[v] > 0) valueSum += values[v];
1253 		}
1254 		for (uint8 m = 0; m < values.length; m++) {
1255 		    if(numAnimalsXType[m] > 0)
1256 			    shares[m] = amount / valueSum * values[m] / numAnimalsXType[m];
1257 		}
1258 		
1259 
1260 		for (uint16 i = 0; i < numAnimals; i++) {
1261 			animals[ids[i]].value += shares[animals[ids[i]].animalType];
1262 		}
1263 
1264 	}
1265 
1266 	/**
1267 	 * allows the owner to collect the accumulated fees
1268 	 * sends the given amount to the owner's address if the amount does not exceed the
1269 	 * fees (cannot touch the players' balances) minus 100 finney (ensure that oraclize fees can be paid)
1270 	 * */
1271 	function collectFees(uint128 amount) {
1272 		if (!(msg.sender == owner)) throw;
1273 		uint collectedFees = getFees();
1274 		if (amount + 100 finney < collectedFees) {
1275 			if (!owner.send(amount)) throw;
1276 		}
1277 	}
1278 
1279 	/**
1280 	 * pays out the players and kills the game.
1281 	 * */
1282 	function stop() {
1283 		if (!(msg.sender == owner)) throw;
1284 		for (uint16 i = 0; i < numAnimals; i++) {
1285 			animals[ids[i]].owner.send(animals[ids[i]].value);
1286 		}
1287 		kill();
1288 	}
1289 
1290 	/**
1291 	 * adds a new animal type to the game
1292 	 * max. number of animal types: 100
1293 	 * the cost may not be lower than costs[0]
1294 	 * */
1295 	function addAnimalType(uint128 cost) {
1296 		if (!(msg.sender == owner)) throw;
1297 		costs.push(cost);
1298 		values.push(cost / 100 * fee);
1299 	}
1300 
1301 	function sellAnimal(uint32 animalId){
1302         if(msg.sender!=animals[animalId].owner) throw;
1303         uint128 val = animals[animalId].value;
1304         uint16 animalIndex;
1305         for(uint16 i = 0; i < ids.length; i++){
1306             if(ids[i]==animalId){
1307                 animalIndex = i;
1308                 break;
1309             }
1310         }
1311         replaceAnimal(animalIndex);
1312         if(!msg.sender.send(val)) throw;
1313     }
1314 
1315 	/****************** GETTERS *************************/
1316 
1317 
1318 	function getPlayerBalance(address playerAddress) constant returns(uint128 playerBalance) {
1319 		for (uint16 i = 0; i < numAnimals; i++) {
1320 			if (animals[ids[i]].owner == playerAddress) playerBalance += animals[ids[i]].value;
1321 		}
1322 	}
1323 	
1324 	function getAnimal(uint32 animalId) constant returns(uint8, uint128, address){
1325 		return (animals[animalId].animalType,animals[animalId].value,animals[animalId].owner);
1326 	}
1327 	
1328 	function get10Animals(uint16 startIndex) constant returns(uint32[10] animalIds, uint8[10] types, uint128[10] values, address[10] owners) {
1329 		uint16 endIndex= startIndex+10 > numAnimals? numAnimals: startIndex+10;
1330 		uint8 j = 0;
1331 		uint32 id;
1332 		for (uint16 i = startIndex; i < endIndex; i++){
1333 			id=ids[i];
1334 			animalIds[j] = id;
1335 			types[j] = animals[id].animalType;
1336 			values[j] = animals[id].value;
1337 			owners[j] = animals[id].owner;
1338 			j++;
1339 		}
1340 		
1341 	}
1342 	
1343 
1344 	function getFees() constant returns(uint) {
1345 		uint reserved = 0;
1346 		for (uint16 j = 0; j < numAnimals; j++)
1347 			reserved += animals[ids[j]].value;
1348 		return address(this).balance - reserved;
1349 	}
1350 
1351 
1352 	/****************** SETTERS *************************/
1353 
1354 	function setOraclizeGas(uint32 newGas) {
1355 		if (!(msg.sender == owner)) throw;
1356 		oraclizeGas = newGas;
1357 	}
1358 
1359 	function setMaxAnimals(uint16 number) {
1360 		if (!(msg.sender == owner)) throw;
1361 		maxAnimals = number;
1362 	}
1363 
1364 
1365 	/************* HELPERS ****************/
1366 
1367 	/**
1368 	 * maps a given number to the new range (old range 1000)
1369 	 * */
1370 	function mapToNewRange(uint number, uint range) constant internal returns(uint16 randomNumber) {
1371 		return uint16(number * range / 1000);
1372 	}
1373 
1374 	/**
1375 	 * converts a string of numbers being separated by a given delimiter into an array of numbers (#howmany) 
1376 	 */
1377 	function getNumbersFromString(string s, string delimiter, uint16 howmany) constant internal returns(uint16[] numbers) {
1378 		strings.slice memory myresult = s.toSlice();
1379 		strings.slice memory delim = delimiter.toSlice();
1380 		numbers = new uint16[](howmany);
1381 		for (uint8 i = 0; i < howmany; i++) {
1382 			numbers[i] = uint16(parseInt(myresult.split(delim).toString()));
1383 		}
1384 		return numbers;
1385 	}
1386 
1387 }