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
33 
34 contract OraclizeI {
35     address public cbAddress;
36     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
37     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
38     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
39     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
40     function getPrice(string _datasource) returns (uint _dsprice);
41     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
42     function useCoupon(string _coupon);
43     function setProofType(byte _proofType);
44     function setConfig(bytes32 _config);
45     function setCustomGasPrice(uint _gasPrice);
46 }
47 contract OraclizeAddrResolverI {
48     function getAddress() returns (address _addr);
49 }
50 contract usingOraclize {
51     uint constant day = 60*60*24;
52     uint constant week = 60*60*24*7;
53     uint constant month = 60*60*24*30;
54     byte constant proofType_NONE = 0x00;
55     byte constant proofType_TLSNotary = 0x10;
56     byte constant proofStorage_IPFS = 0x01;
57     uint8 constant networkID_auto = 0;
58     uint8 constant networkID_mainnet = 1;
59     uint8 constant networkID_testnet = 2;
60     uint8 constant networkID_morden = 2;
61     uint8 constant networkID_consensys = 161;
62 
63     OraclizeAddrResolverI OAR;
64     
65     OraclizeI oraclize;
66     modifier oraclizeAPI {
67         if(address(OAR)==0) oraclize_setNetwork(networkID_auto);
68         oraclize = OraclizeI(OAR.getAddress());
69         _;
70     }
71     modifier coupon(string code){
72         oraclize = OraclizeI(OAR.getAddress());
73         oraclize.useCoupon(code);
74         _;
75     }
76 
77     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
78         if (getCodeSize(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed)>0){ //mainnet
79             OAR = OraclizeAddrResolverI(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed);
80             return true;
81         }
82         if (getCodeSize(0xc03a2615d5efaf5f49f60b7bb6583eaec212fdf1)>0){ //ropsten testnet
83             OAR = OraclizeAddrResolverI(0xc03a2615d5efaf5f49f60b7bb6583eaec212fdf1);
84             return true;
85         }
86         if (getCodeSize(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf)>0){ //ether.camp ide
87             OAR = OraclizeAddrResolverI(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf);
88             return true;
89         }
90         if (getCodeSize(0x93bbbe5ce77034e3095f0479919962a903f898ad)>0){ //norsborg testnet
91             OAR = OraclizeAddrResolverI(0x93bbbe5ce77034e3095f0479919962a903f898ad);
92             return true;
93         }
94         if (getCodeSize(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa)>0){ //browser-solidity
95             OAR = OraclizeAddrResolverI(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa);
96             return true;
97         }
98         return false;
99     }
100     
101     function __callback(bytes32 myid, string result) {
102         __callback(myid, result, new bytes(0));
103     }
104     function __callback(bytes32 myid, string result, bytes proof) {
105     }
106     
107     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
108         return oraclize.getPrice(datasource);
109     }
110     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
111         return oraclize.getPrice(datasource, gaslimit);
112     }
113     
114     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
115         uint price = oraclize.getPrice(datasource);
116         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
117         return oraclize.query.value(price)(0, datasource, arg);
118     }
119     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
120         uint price = oraclize.getPrice(datasource);
121         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
122         return oraclize.query.value(price)(timestamp, datasource, arg);
123     }
124     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
125         uint price = oraclize.getPrice(datasource, gaslimit);
126         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
127         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
128     }
129     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
130         uint price = oraclize.getPrice(datasource, gaslimit);
131         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
132         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
133     }
134     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
135         uint price = oraclize.getPrice(datasource);
136         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
137         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
138     }
139     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
140         uint price = oraclize.getPrice(datasource);
141         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
142         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
143     }
144     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
145         uint price = oraclize.getPrice(datasource, gaslimit);
146         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
147         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
148     }
149     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
150         uint price = oraclize.getPrice(datasource, gaslimit);
151         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
152         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
153     }
154     function oraclize_cbAddress() oraclizeAPI internal returns (address){
155         return oraclize.cbAddress();
156     }
157     function oraclize_setProof(byte proofP) oraclizeAPI internal {
158         return oraclize.setProofType(proofP);
159     }
160     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
161         return oraclize.setCustomGasPrice(gasPrice);
162     }    
163     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
164         return oraclize.setConfig(config);
165     }
166 
167     function getCodeSize(address _addr) constant internal returns(uint _size) {
168         assembly {
169             _size := extcodesize(_addr)
170         }
171     }
172 
173 
174     function parseAddr(string _a) internal returns (address){
175         bytes memory tmp = bytes(_a);
176         uint160 iaddr = 0;
177         uint160 b1;
178         uint160 b2;
179         for (uint i=2; i<2+2*20; i+=2){
180             iaddr *= 256;
181             b1 = uint160(tmp[i]);
182             b2 = uint160(tmp[i+1]);
183             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
184             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
185             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
186             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
187             iaddr += (b1*16+b2);
188         }
189         return address(iaddr);
190     }
191 
192 
193     function strCompare(string _a, string _b) internal returns (int) {
194         bytes memory a = bytes(_a);
195         bytes memory b = bytes(_b);
196         uint minLength = a.length;
197         if (b.length < minLength) minLength = b.length;
198         for (uint i = 0; i < minLength; i ++)
199             if (a[i] < b[i])
200                 return -1;
201             else if (a[i] > b[i])
202                 return 1;
203         if (a.length < b.length)
204             return -1;
205         else if (a.length > b.length)
206             return 1;
207         else
208             return 0;
209    } 
210 
211     function indexOf(string _haystack, string _needle) internal returns (int)
212     {
213         bytes memory h = bytes(_haystack);
214         bytes memory n = bytes(_needle);
215         if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
216             return -1;
217         else if(h.length > (2**128 -1))
218             return -1;                                  
219         else
220         {
221             uint subindex = 0;
222             for (uint i = 0; i < h.length; i ++)
223             {
224                 if (h[i] == n[0])
225                 {
226                     subindex = 1;
227                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
228                     {
229                         subindex++;
230                     }   
231                     if(subindex == n.length)
232                         return int(i);
233                 }
234             }
235             return -1;
236         }   
237     }
238 
239     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
240         bytes memory _ba = bytes(_a);
241         bytes memory _bb = bytes(_b);
242         bytes memory _bc = bytes(_c);
243         bytes memory _bd = bytes(_d);
244         bytes memory _be = bytes(_e);
245         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
246         bytes memory babcde = bytes(abcde);
247         uint k = 0;
248         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
249         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
250         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
251         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
252         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
253         return string(babcde);
254     }
255     
256     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
257         return strConcat(_a, _b, _c, _d, "");
258     }
259 
260     function strConcat(string _a, string _b, string _c) internal returns (string) {
261         return strConcat(_a, _b, _c, "", "");
262     }
263 
264     function strConcat(string _a, string _b) internal returns (string) {
265         return strConcat(_a, _b, "", "", "");
266     }
267 
268     // parseInt
269     function parseInt(string _a) internal returns (uint) {
270         return parseInt(_a, 0);
271     }
272 
273     // parseInt(parseFloat*10^_b)
274     function parseInt(string _a, uint _b) internal returns (uint) {
275         bytes memory bresult = bytes(_a);
276         uint mint = 0;
277         bool decimals = false;
278         for (uint i=0; i<bresult.length; i++){
279             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
280                 if (decimals){
281                    if (_b == 0) break;
282                     else _b--;
283                 }
284                 mint *= 10;
285                 mint += uint(bresult[i]) - 48;
286             } else if (bresult[i] == 46) decimals = true;
287         }
288         if (_b > 0) mint *= 10**_b;
289         return mint;
290     }
291     
292     function uint2str(uint i) internal returns (string){
293         if (i == 0) return "0";
294         uint j = i;
295         uint len;
296         while (j != 0){
297             len++;
298             j /= 10;
299         }
300         bytes memory bstr = new bytes(len);
301         uint k = len - 1;
302         while (i != 0){
303             bstr[k--] = byte(48 + i % 10);
304             i /= 10;
305         }
306         return string(bstr);
307     }
308     
309     
310 
311 }
312 // </ORACLIZE_API>
313 
314 
315 
316 contract mortal {
317 	address owner;
318 
319 	function mortal() {
320 		owner = msg.sender;
321 	}
322 
323 	function kill() internal {
324 		suicide(owner);
325 	}
326 }
327 
328 
329 
330 
331 library strings {
332     struct slice {
333         uint _len;
334         uint _ptr;
335     }
336 
337     function memcpy(uint dest, uint src, uint len) private {
338         // Copy word-length chunks while possible
339         for(; len >= 32; len -= 32) {
340             assembly {
341                 mstore(dest, mload(src))
342             }
343             dest += 32;
344             src += 32;
345         }
346 
347         // Copy remaining bytes
348         uint mask = 256 ** (32 - len) - 1;
349         assembly {
350             let srcpart := and(mload(src), not(mask))
351             let destpart := and(mload(dest), mask)
352             mstore(dest, or(destpart, srcpart))
353         }
354     }
355 
356     /**
357      * @dev Returns a slice containing the entire string.
358      * @param self The string to make a slice from.
359      * @return A newly allocated slice containing the entire string.
360      */
361     function toSlice(string self) internal returns (slice) {
362         uint ptr;
363         assembly {
364             ptr := add(self, 0x20)
365         }
366         return slice(bytes(self).length, ptr);
367     }
368 
369     /**
370      * @dev Returns the length of a null-terminated bytes32 string.
371      * @param self The value to find the length of.
372      * @return The length of the string, from 0 to 32.
373      */
374     function len(bytes32 self) internal returns (uint) {
375         uint ret;
376         if (self == 0)
377             return 0;
378         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
379             ret += 16;
380             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
381         }
382         if (self & 0xffffffffffffffff == 0) {
383             ret += 8;
384             self = bytes32(uint(self) / 0x10000000000000000);
385         }
386         if (self & 0xffffffff == 0) {
387             ret += 4;
388             self = bytes32(uint(self) / 0x100000000);
389         }
390         if (self & 0xffff == 0) {
391             ret += 2;
392             self = bytes32(uint(self) / 0x10000);
393         }
394         if (self & 0xff == 0) {
395             ret += 1;
396         }
397         return 32 - ret;
398     }
399 
400     /**
401      * @dev Returns a slice containing the entire bytes32, interpreted as a
402      *      null-termintaed utf-8 string.
403      * @param self The bytes32 value to convert to a slice.
404      * @return A new slice containing the value of the input argument up to the
405      *         first null.
406      */
407     function toSliceB32(bytes32 self) internal returns (slice ret) {
408         // Allocate space for `self` in memory, copy it there, and point ret at it
409         assembly {
410             let ptr := mload(0x40)
411             mstore(0x40, add(ptr, 0x20))
412             mstore(ptr, self)
413             mstore(add(ret, 0x20), ptr)
414         }
415         ret._len = len(self);
416     }
417 
418     /**
419      * @dev Returns a new slice containing the same data as the current slice.
420      * @param self The slice to copy.
421      * @return A new slice containing the same data as `self`.
422      */
423     function copy(slice self) internal returns (slice) {
424         return slice(self._len, self._ptr);
425     }
426 
427     /**
428      * @dev Copies a slice to a new string.
429      * @param self The slice to copy.
430      * @return A newly allocated string containing the slice's text.
431      */
432     function toString(slice self) internal returns (string) {
433         var ret = new string(self._len);
434         uint retptr;
435         assembly { retptr := add(ret, 32) }
436 
437         memcpy(retptr, self._ptr, self._len);
438         return ret;
439     }
440 
441     /**
442      * @dev Returns the length in runes of the slice. Note that this operation
443      *      takes time proportional to the length of the slice; avoid using it
444      *      in loops, and call `slice.empty()` if you only need to know whether
445      *      the slice is empty or not.
446      * @param self The slice to operate on.
447      * @return The length of the slice in runes.
448      */
449     function len(slice self) internal returns (uint) {
450         // Starting at ptr-31 means the LSB will be the byte we care about
451         var ptr = self._ptr - 31;
452         var end = ptr + self._len;
453         for (uint len = 0; ptr < end; len++) {
454             uint8 b;
455             assembly { b := and(mload(ptr), 0xFF) }
456             if (b < 0x80) {
457                 ptr += 1;
458             } else if(b < 0xE0) {
459                 ptr += 2;
460             } else if(b < 0xF0) {
461                 ptr += 3;
462             } else if(b < 0xF8) {
463                 ptr += 4;
464             } else if(b < 0xFC) {
465                 ptr += 5;
466             } else {
467                 ptr += 6;
468             }
469         }
470         return len;
471     }
472 
473     /**
474      * @dev Returns true if the slice is empty (has a length of 0).
475      * @param self The slice to operate on.
476      * @return True if the slice is empty, False otherwise.
477      */
478     function empty(slice self) internal returns (bool) {
479         return self._len == 0;
480     }
481 
482     /**
483      * @dev Returns a positive number if `other` comes lexicographically after
484      *      `self`, a negative number if it comes before, or zero if the
485      *      contents of the two slices are equal. Comparison is done per-rune,
486      *      on unicode codepoints.
487      * @param self The first slice to compare.
488      * @param other The second slice to compare.
489      * @return The result of the comparison.
490      */
491     function compare(slice self, slice other) internal returns (int) {
492         uint shortest = self._len;
493         if (other._len < self._len)
494             shortest = other._len;
495 
496         var selfptr = self._ptr;
497         var otherptr = other._ptr;
498         for (uint idx = 0; idx < shortest; idx += 32) {
499             uint a;
500             uint b;
501             assembly {
502                 a := mload(selfptr)
503                 b := mload(otherptr)
504             }
505             if (a != b) {
506                 // Mask out irrelevant bytes and check again
507                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
508                 var diff = (a & mask) - (b & mask);
509                 if (diff != 0)
510                     return int(diff);
511             }
512             selfptr += 32;
513             otherptr += 32;
514         }
515         return int(self._len) - int(other._len);
516     }
517 
518     /**
519      * @dev Returns true if the two slices contain the same text.
520      * @param self The first slice to compare.
521      * @param self The second slice to compare.
522      * @return True if the slices are equal, false otherwise.
523      */
524     function equals(slice self, slice other) internal returns (bool) {
525         return compare(self, other) == 0;
526     }
527 
528     /**
529      * @dev Extracts the first rune in the slice into `rune`, advancing the
530      *      slice to point to the next rune and returning `self`.
531      * @param self The slice to operate on.
532      * @param rune The slice that will contain the first rune.
533      * @return `rune`.
534      */
535     function nextRune(slice self, slice rune) internal returns (slice) {
536         rune._ptr = self._ptr;
537 
538         if (self._len == 0) {
539             rune._len = 0;
540             return rune;
541         }
542 
543         uint len;
544         uint b;
545         // Load the first byte of the rune into the LSBs of b
546         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
547         if (b < 0x80) {
548             len = 1;
549         } else if(b < 0xE0) {
550             len = 2;
551         } else if(b < 0xF0) {
552             len = 3;
553         } else {
554             len = 4;
555         }
556 
557         // Check for truncated codepoints
558         if (len > self._len) {
559             rune._len = self._len;
560             self._ptr += self._len;
561             self._len = 0;
562             return rune;
563         }
564 
565         self._ptr += len;
566         self._len -= len;
567         rune._len = len;
568         return rune;
569     }
570 
571     /**
572      * @dev Returns the first rune in the slice, advancing the slice to point
573      *      to the next rune.
574      * @param self The slice to operate on.
575      * @return A slice containing only the first rune from `self`.
576      */
577     function nextRune(slice self) internal returns (slice ret) {
578         nextRune(self, ret);
579     }
580 
581     /**
582      * @dev Returns the number of the first codepoint in the slice.
583      * @param self The slice to operate on.
584      * @return The number of the first codepoint in the slice.
585      */
586     function ord(slice self) internal returns (uint ret) {
587         if (self._len == 0) {
588             return 0;
589         }
590 
591         uint word;
592         uint len;
593         uint div = 2 ** 248;
594 
595         // Load the rune into the MSBs of b
596         assembly { word:= mload(mload(add(self, 32))) }
597         var b = word / div;
598         if (b < 0x80) {
599             ret = b;
600             len = 1;
601         } else if(b < 0xE0) {
602             ret = b & 0x1F;
603             len = 2;
604         } else if(b < 0xF0) {
605             ret = b & 0x0F;
606             len = 3;
607         } else {
608             ret = b & 0x07;
609             len = 4;
610         }
611 
612         // Check for truncated codepoints
613         if (len > self._len) {
614             return 0;
615         }
616 
617         for (uint i = 1; i < len; i++) {
618             div = div / 256;
619             b = (word / div) & 0xFF;
620             if (b & 0xC0 != 0x80) {
621                 // Invalid UTF-8 sequence
622                 return 0;
623             }
624             ret = (ret * 64) | (b & 0x3F);
625         }
626 
627         return ret;
628     }
629 
630     /**
631      * @dev Returns the keccak-256 hash of the slice.
632      * @param self The slice to hash.
633      * @return The hash of the slice.
634      */
635     function keccak(slice self) internal returns (bytes32 ret) {
636         assembly {
637             ret := sha3(mload(add(self, 32)), mload(self))
638         }
639     }
640 
641     /**
642      * @dev Returns true if `self` starts with `needle`.
643      * @param self The slice to operate on.
644      * @param needle The slice to search for.
645      * @return True if the slice starts with the provided text, false otherwise.
646      */
647     function startsWith(slice self, slice needle) internal returns (bool) {
648         if (self._len < needle._len) {
649             return false;
650         }
651 
652         if (self._ptr == needle._ptr) {
653             return true;
654         }
655 
656         bool equal;
657         assembly {
658             let len := mload(needle)
659             let selfptr := mload(add(self, 0x20))
660             let needleptr := mload(add(needle, 0x20))
661             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
662         }
663         return equal;
664     }
665 
666     /**
667      * @dev If `self` starts with `needle`, `needle` is removed from the
668      *      beginning of `self`. Otherwise, `self` is unmodified.
669      * @param self The slice to operate on.
670      * @param needle The slice to search for.
671      * @return `self`
672      */
673     function beyond(slice self, slice needle) internal returns (slice) {
674         if (self._len < needle._len) {
675             return self;
676         }
677 
678         bool equal = true;
679         if (self._ptr != needle._ptr) {
680             assembly {
681                 let len := mload(needle)
682                 let selfptr := mload(add(self, 0x20))
683                 let needleptr := mload(add(needle, 0x20))
684                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
685             }
686         }
687 
688         if (equal) {
689             self._len -= needle._len;
690             self._ptr += needle._len;
691         }
692 
693         return self;
694     }
695 
696     /**
697      * @dev Returns true if the slice ends with `needle`.
698      * @param self The slice to operate on.
699      * @param needle The slice to search for.
700      * @return True if the slice starts with the provided text, false otherwise.
701      */
702     function endsWith(slice self, slice needle) internal returns (bool) {
703         if (self._len < needle._len) {
704             return false;
705         }
706 
707         var selfptr = self._ptr + self._len - needle._len;
708 
709         if (selfptr == needle._ptr) {
710             return true;
711         }
712 
713         bool equal;
714         assembly {
715             let len := mload(needle)
716             let needleptr := mload(add(needle, 0x20))
717             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
718         }
719 
720         return equal;
721     }
722 
723     /**
724      * @dev If `self` ends with `needle`, `needle` is removed from the
725      *      end of `self`. Otherwise, `self` is unmodified.
726      * @param self The slice to operate on.
727      * @param needle The slice to search for.
728      * @return `self`
729      */
730     function until(slice self, slice needle) internal returns (slice) {
731         if (self._len < needle._len) {
732             return self;
733         }
734 
735         var selfptr = self._ptr + self._len - needle._len;
736         bool equal = true;
737         if (selfptr != needle._ptr) {
738             assembly {
739                 let len := mload(needle)
740                 let needleptr := mload(add(needle, 0x20))
741                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
742             }
743         }
744 
745         if (equal) {
746             self._len -= needle._len;
747         }
748 
749         return self;
750     }
751 
752     // Returns the memory address of the first byte of the first occurrence of
753     // `needle` in `self`, or the first byte after `self` if not found.
754     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
755         uint ptr;
756         uint idx;
757 
758         if (needlelen <= selflen) {
759             if (needlelen <= 32) {
760                 // Optimized assembly for 68 gas per byte on short strings
761                 assembly {
762                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
763                     let needledata := and(mload(needleptr), mask)
764                     let end := add(selfptr, sub(selflen, needlelen))
765                     ptr := selfptr
766                     loop:
767                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
768                     ptr := add(ptr, 1)
769                     jumpi(loop, lt(sub(ptr, 1), end))
770                     ptr := add(selfptr, selflen)
771                     exit:
772                 }
773                 return ptr;
774             } else {
775                 // For long needles, use hashing
776                 bytes32 hash;
777                 assembly { hash := sha3(needleptr, needlelen) }
778                 ptr = selfptr;
779                 for (idx = 0; idx <= selflen - needlelen; idx++) {
780                     bytes32 testHash;
781                     assembly { testHash := sha3(ptr, needlelen) }
782                     if (hash == testHash)
783                         return ptr;
784                     ptr += 1;
785                 }
786             }
787         }
788         return selfptr + selflen;
789     }
790 
791     // Returns the memory address of the first byte after the last occurrence of
792     // `needle` in `self`, or the address of `self` if not found.
793     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
794         uint ptr;
795 
796         if (needlelen <= selflen) {
797             if (needlelen <= 32) {
798                 // Optimized assembly for 69 gas per byte on short strings
799                 assembly {
800                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
801                     let needledata := and(mload(needleptr), mask)
802                     ptr := add(selfptr, sub(selflen, needlelen))
803                     loop:
804                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
805                     ptr := sub(ptr, 1)
806                     jumpi(loop, gt(add(ptr, 1), selfptr))
807                     ptr := selfptr
808                     jump(exit)
809                     ret:
810                     ptr := add(ptr, needlelen)
811                     exit:
812                 }
813                 return ptr;
814             } else {
815                 // For long needles, use hashing
816                 bytes32 hash;
817                 assembly { hash := sha3(needleptr, needlelen) }
818                 ptr = selfptr + (selflen - needlelen);
819                 while (ptr >= selfptr) {
820                     bytes32 testHash;
821                     assembly { testHash := sha3(ptr, needlelen) }
822                     if (hash == testHash)
823                         return ptr + needlelen;
824                     ptr -= 1;
825                 }
826             }
827         }
828         return selfptr;
829     }
830 
831     /**
832      * @dev Modifies `self` to contain everything from the first occurrence of
833      *      `needle` to the end of the slice. `self` is set to the empty slice
834      *      if `needle` is not found.
835      * @param self The slice to search and modify.
836      * @param needle The text to search for.
837      * @return `self`.
838      */
839     function find(slice self, slice needle) internal returns (slice) {
840         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
841         self._len -= ptr - self._ptr;
842         self._ptr = ptr;
843         return self;
844     }
845 
846     /**
847      * @dev Modifies `self` to contain the part of the string from the start of
848      *      `self` to the end of the first occurrence of `needle`. If `needle`
849      *      is not found, `self` is set to the empty slice.
850      * @param self The slice to search and modify.
851      * @param needle The text to search for.
852      * @return `self`.
853      */
854     function rfind(slice self, slice needle) internal returns (slice) {
855         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
856         self._len = ptr - self._ptr;
857         return self;
858     }
859 
860     /**
861      * @dev Splits the slice, setting `self` to everything after the first
862      *      occurrence of `needle`, and `token` to everything before it. If
863      *      `needle` does not occur in `self`, `self` is set to the empty slice,
864      *      and `token` is set to the entirety of `self`.
865      * @param self The slice to split.
866      * @param needle The text to search for in `self`.
867      * @param token An output parameter to which the first token is written.
868      * @return `token`.
869      */
870     function split(slice self, slice needle, slice token) internal returns (slice) {
871         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
872         token._ptr = self._ptr;
873         token._len = ptr - self._ptr;
874         if (ptr == self._ptr + self._len) {
875             // Not found
876             self._len = 0;
877         } else {
878             self._len -= token._len + needle._len;
879             self._ptr = ptr + needle._len;
880         }
881         return token;
882     }
883 
884     /**
885      * @dev Splits the slice, setting `self` to everything after the first
886      *      occurrence of `needle`, and returning everything before it. If
887      *      `needle` does not occur in `self`, `self` is set to the empty slice,
888      *      and the entirety of `self` is returned.
889      * @param self The slice to split.
890      * @param needle The text to search for in `self`.
891      * @return The part of `self` up to the first occurrence of `delim`.
892      */
893     function split(slice self, slice needle) internal returns (slice token) {
894         split(self, needle, token);
895     }
896 
897     /**
898      * @dev Splits the slice, setting `self` to everything before the last
899      *      occurrence of `needle`, and `token` to everything after it. If
900      *      `needle` does not occur in `self`, `self` is set to the empty slice,
901      *      and `token` is set to the entirety of `self`.
902      * @param self The slice to split.
903      * @param needle The text to search for in `self`.
904      * @param token An output parameter to which the first token is written.
905      * @return `token`.
906      */
907     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
908         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
909         token._ptr = ptr;
910         token._len = self._len - (ptr - self._ptr);
911         if (ptr == self._ptr) {
912             // Not found
913             self._len = 0;
914         } else {
915             self._len -= token._len + needle._len;
916         }
917         return token;
918     }
919 
920     /**
921      * @dev Splits the slice, setting `self` to everything before the last
922      *      occurrence of `needle`, and returning everything after it. If
923      *      `needle` does not occur in `self`, `self` is set to the empty slice,
924      *      and the entirety of `self` is returned.
925      * @param self The slice to split.
926      * @param needle The text to search for in `self`.
927      * @return The part of `self` after the last occurrence of `delim`.
928      */
929     function rsplit(slice self, slice needle) internal returns (slice token) {
930         rsplit(self, needle, token);
931     }
932 
933     /**
934      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
935      * @param self The slice to search.
936      * @param needle The text to search for in `self`.
937      * @return The number of occurrences of `needle` found in `self`.
938      */
939     function count(slice self, slice needle) internal returns (uint count) {
940         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
941         while (ptr <= self._ptr + self._len) {
942             count++;
943             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
944         }
945     }
946 
947     /**
948      * @dev Returns True if `self` contains `needle`.
949      * @param self The slice to search.
950      * @param needle The text to search for in `self`.
951      * @return True if `needle` is found in `self`, false otherwise.
952      */
953     function contains(slice self, slice needle) internal returns (bool) {
954         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
955     }
956 
957     /**
958      * @dev Returns a newly allocated string containing the concatenation of
959      *      `self` and `other`.
960      * @param self The first slice to concatenate.
961      * @param other The second slice to concatenate.
962      * @return The concatenation of the two strings.
963      */
964     function concat(slice self, slice other) internal returns (string) {
965         var ret = new string(self._len + other._len);
966         uint retptr;
967         assembly { retptr := add(ret, 32) }
968         memcpy(retptr, self._ptr, self._len);
969         memcpy(retptr + self._len, other._ptr, other._len);
970         return ret;
971     }
972 
973     /**
974      * @dev Joins an array of slices, using `self` as a delimiter, returning a
975      *      newly allocated string.
976      * @param self The delimiter to use.
977      * @param parts A list of slices to join.
978      * @return A newly allocated string containing all the slices in `parts`,
979      *         joined with `self`.
980      */
981     function join(slice self, slice[] parts) internal returns (string) {
982         if (parts.length == 0)
983             return "";
984 
985         uint len = self._len * (parts.length - 1);
986         for(uint i = 0; i < parts.length; i++)
987             len += parts[i]._len;
988 
989         var ret = new string(len);
990         uint retptr;
991         assembly { retptr := add(ret, 32) }
992 
993         for(i = 0; i < parts.length; i++) {
994             memcpy(retptr, parts[i]._ptr, parts[i]._len);
995             retptr += parts[i]._len;
996             if (i < parts.length - 1) {
997                 memcpy(retptr, self._ptr, self._len);
998                 retptr += self._len;
999             }
1000         }
1001 
1002         return ret;
1003     }
1004 }
1005 
1006       
1007       
1008 
1009 contract transferable {
1010 	function receive(address player, uint8 animalType, uint32[] animalIds) payable {}
1011 }
1012 
1013 contract Pray4Prey is mortal, usingOraclize, transferable {
1014 	using strings
1015 	for * ;
1016 
1017 	struct Animal {
1018 		uint8 animalType;
1019 		uint128 value;
1020 		address owner;
1021 	}
1022 
1023 	/** array holding ids of the curret animals*/
1024 	uint32[] public ids;
1025 	/** the id to be given to the net animal **/
1026 	uint32 public nextId;
1027 	/** the id of the oldest animal */
1028 	uint32 public oldest;
1029 	/** the animal belonging to a given id */
1030 	mapping(uint32 => Animal) animals;
1031 	/** the cost of each animal type */
1032 	uint128[] public costs;
1033 	/** the value of each animal type (cost - fee), so it's not necessary to compute it each time*/
1034 	uint128[] public values;
1035 	/** the fee to be paid each time an animal is bought in percent*/
1036 	uint8 fee;
1037 	/** the address of the old contract version. animals may be transfered from this address */
1038 	address lastP4P;
1039 
1040 	/** total number of animals in the game (uint32 because of multiplication issues) */
1041 	uint32 public numAnimals;
1042 	/** The maximum of animals allowed in the game */
1043 	uint16 public maxAnimals;
1044 	/** number of animals per type */
1045 	mapping(uint8 => uint16) public numAnimalsXType;
1046 
1047 
1048 	/** the query string getting the random numbers from oraclize**/
1049 	string randomQuery;
1050 	/** the type of the oraclize query**/
1051 	string queryType;
1052 	/** the timestamp of the next attack **/
1053 	uint public nextAttackTimestamp;
1054 	/** gas provided for oraclize callback (attack)**/
1055 	uint32 public oraclizeGas;
1056 	/** the id of the next oraclize callback*/
1057 	bytes32 nextAttackId;
1058 
1059 
1060 	/** is fired when new animals are purchased (who bought how many animals of which type?) */
1061 	event newPurchase(address player, uint8 animalType, uint8 amount, uint32 startId);
1062 	/** is fired when a player leaves the game */
1063 	event newExit(address player, uint256 totalBalance, uint32[] removedAnimals);
1064 	/** is fired when an attack occures */
1065 	event newAttack(uint32[] killedAnimals);
1066 	/** is fired when a single animal is sold **/
1067 	event newSell(uint32 animalId, address player, uint256 value);
1068 
1069 
1070 	/** initializes the contract parameters	 (would be constructor if it wasn't for the gas limit)*/
1071 	function init(address oldContract) {
1072 		if(msg.sender != owner) throw;
1073 		costs = [100000000000000000, 200000000000000000, 500000000000000000, 1000000000000000000, 5000000000000000000];
1074 		fee = 5;
1075 		for (uint8 i = 0; i < costs.length; i++) {
1076 			values.push(costs[i] - costs[i] / 100 * fee);
1077 		}
1078 		maxAnimals = 300;
1079 		randomQuery = "10 random numbers between 1 and 1000";
1080 		queryType = "WolframAlpha";
1081 		oraclizeGas = 700000;
1082 		lastP4P = oldContract; //allow transfer from old contract
1083 		nextId = 500;
1084 		oldest = 500;
1085 	}
1086 
1087 	/** The fallback function runs whenever someone sends ether
1088 	   Depending of the value of the transaction the sender is either granted a prey or 
1089 	   the transaction is discarded and no ether accepted
1090 	   In the first case fees have to be paid*/
1091 	function() payable {
1092 		for (uint8 i = 0; i < costs.length; i++)
1093 			if (msg.value == costs[i])
1094 				addAnimals(i);
1095 
1096 		if (msg.value == 1000000000000000)
1097 			exit();
1098 		else
1099 			throw;
1100 
1101 	}
1102 
1103 	/** buy animals of a given type 
1104 	 *  as many animals as possible are bought with msg.value
1105 	 */
1106 	function addAnimals(uint8 animalType) payable {
1107 		giveAnimals(animalType, msg.sender);
1108 	}
1109 
1110 	/** buy animals of a given type forsomeone else
1111 	 *  as many animals as possible are bought with msg.value
1112 	 */
1113 	function giveAnimals(uint8 animalType, address receiver) payable {
1114 		uint8 amount = uint8(msg.value / costs[animalType]);
1115 		if (animalType >= costs.length || msg.value < costs[animalType] || numAnimals + amount >= maxAnimals) throw;
1116 		//if type exists, enough ether was transferred and there are less than maxAnimals animals in the game
1117 		for (uint8 j = 0; j < amount; j++) {
1118 			addAnimal(animalType, receiver, nextId);
1119 			nextId++;
1120 		}
1121 		numAnimalsXType[animalType] += amount;
1122 		newPurchase(receiver, animalType, amount, nextId - amount);
1123 	}
1124 
1125 	/**
1126 	 *  adds a single animal of the given type
1127 	 */
1128 	function addAnimal(uint8 animalType, address receiver, uint32 nId) internal {
1129 		if (numAnimals < ids.length)
1130 			ids[numAnimals] = nId;
1131 		else
1132 			ids.push(nId);
1133 		animals[nId] = Animal(animalType, values[animalType], receiver);
1134 		numAnimals++;
1135 	}
1136 
1137 
1138 
1139 	/** leave the game
1140 	 * pays out the sender's winBalance and removes him and his animals from the game
1141 	 * */
1142 	function exit() {
1143 		uint32[] memory removed = new uint32[](50);
1144 		uint8 count;
1145 		uint32 lastId;
1146 		uint playerBalance;
1147 		for (uint16 i = 0; i < numAnimals; i++) {
1148 			if (animals[ids[i]].owner == msg.sender) {
1149 				//first delete all animals at the end of the array
1150 				while (numAnimals > 0 && animals[ids[numAnimals - 1]].owner == msg.sender) {
1151 					numAnimals--;
1152 					lastId = ids[numAnimals];
1153 					numAnimalsXType[animals[lastId].animalType]--;
1154 					playerBalance += animals[lastId].value;
1155 					removed[count] = lastId;
1156 					count++;
1157 					if (lastId == oldest) oldest = 0;
1158 					delete animals[lastId];
1159 				}
1160 				//if the last animal does not belong to the player, replace the players animal by this last one
1161 				if (numAnimals > i + 1) {
1162 					playerBalance += animals[ids[i]].value;
1163 					removed[count] = ids[i];
1164 					count++;
1165 					replaceAnimal(i);
1166 				}
1167 			}
1168 		}
1169 		newExit(msg.sender, playerBalance, removed); //fire the event to notify the client
1170 		if (!msg.sender.send(playerBalance)) throw;
1171 	}
1172 
1173 
1174 	/**
1175 	 * Replaces the animal with the given id with the last animal in the array
1176 	 * */
1177 	function replaceAnimal(uint16 index) internal {
1178 		uint32 animalId = ids[index];
1179 		numAnimalsXType[animals[animalId].animalType]--;
1180 		numAnimals--;
1181 		if (animalId == oldest) oldest = 0;
1182 		delete animals[animalId];
1183 		ids[index] = ids[numAnimals];
1184 		delete ids[numAnimals];
1185 	}
1186 
1187 
1188 	/**
1189 	 * manually triggers the attack. cannot be called afterwards, except
1190 	 * by the owner if and only if the attack wasn't launched as supposed, signifying
1191 	 * an error ocurred during the last invocation of oraclize, or there wasn't enough ether to pay the gas
1192 	 * */
1193 	function triggerAttackManually(uint32 inseconds) {
1194 		if (!(msg.sender == owner && nextAttackTimestamp < now + 300)) throw;
1195 		triggerAttack(inseconds, (oraclizeGas + 10000 * numAnimals));
1196 	}
1197 
1198 	/**
1199 	 * sends a query to oraclize in order to get random numbers in 'inseconds' seconds
1200 	 */
1201 	function triggerAttack(uint32 inseconds, uint128 gasAmount) internal {
1202 		nextAttackTimestamp = now + inseconds;
1203 		nextAttackId = oraclize_query(nextAttackTimestamp, queryType, randomQuery, gasAmount);
1204 	}
1205 
1206 	/**
1207 	 * The actual predator attack.
1208 	 * The predator kills up to 10 animals, but in case there are less than 100 animals in the game up to 10% get eaten.
1209 	 * */
1210 	function __callback(bytes32 myid, string result) {
1211 		if (msg.sender != oraclize_cbAddress() || myid != nextAttackId) throw; // just to be sure the calling address is the Oraclize authorized one and the callback is the expected one   
1212 		uint128 pot;
1213 		uint16 random;
1214 		uint32 howmany = numAnimals < 100 ? (numAnimals < 10 ? 1 : numAnimals / 10) : 10; //do not kill more than 10%, but at least one
1215 		uint16[] memory randomNumbers = getNumbersFromString(result, ",", howmany);
1216 		uint32[] memory killedAnimals = new uint32[](howmany);
1217 		for (uint8 i = 0; i < howmany; i++) {
1218 			random = mapToNewRange(randomNumbers[i], numAnimals);
1219 			killedAnimals[i] = ids[random];
1220 			pot += killAnimal(random);
1221 		}
1222 		uint128 neededGas = oraclizeGas + 10000 * numAnimals;
1223 		uint128 gasCost = uint128(neededGas * tx.gasprice);
1224 		if (pot > gasCost)
1225 			distribute(uint128(pot - gasCost)); //distribute the pot minus the oraclize gas costs
1226 		triggerAttack(timeTillNextAttack(), neededGas);
1227 		newAttack(killedAnimals);
1228 	}
1229 
1230 	/**
1231 	 * the frequency of the shark attacks depends on the number of animals in the game. 
1232 	 * many animals -> many shark attacks
1233 	 * at least one attack in 24 hours
1234 	 * */
1235 	function timeTillNextAttack() constant internal returns(uint32) {
1236 		return (86400 / (1 + numAnimals / 100));
1237 	}
1238 
1239 
1240 	/**
1241 	 * kills the animal of the given type at the given index. 
1242 	 * */
1243 	function killAnimal(uint16 index) internal returns(uint128 animalValue) {
1244 		animalValue = animals[ids[index]].value;
1245 		replaceAnimal(index);
1246 	}
1247 
1248 	/**
1249 	 * finds the oldest animal
1250 	 * */
1251 	function findOldest() {
1252 		oldest = ids[0];
1253 		for (uint16 i = 1; i < numAnimals; i++) {
1254 			if (ids[i] < oldest) //the oldest animal has the lowest id
1255 				oldest = ids[i];
1256 		}
1257 	}
1258 
1259 
1260 	/** distributes the given amount among the surviving fishes*/
1261 	function distribute(uint128 totalAmount) internal {
1262 		//pay 10% to the oldest fish
1263 		if (oldest == 0)
1264 			findOldest();
1265 		animals[oldest].value += totalAmount / 10;
1266 		uint128 amount = totalAmount / 10 * 9;
1267 		//distribute the rest according to their type
1268 		uint128 valueSum;
1269 		uint128[] memory shares = new uint128[](values.length);
1270 		for (uint8 v = 0; v < values.length; v++) {
1271 			if (numAnimalsXType[v] > 0) valueSum += values[v];
1272 		}
1273 		for (uint8 m = 0; m < values.length; m++) {
1274 			if (numAnimalsXType[m] > 0)
1275 				shares[m] = amount * values[m] / valueSum / numAnimalsXType[m];
1276 		}
1277 		for (uint16 i = 0; i < numAnimals; i++) {
1278 			animals[ids[i]].value += shares[animals[ids[i]].animalType];
1279 		}
1280 
1281 	}
1282 
1283 	/**
1284 	 * allows the owner to collect the accumulated fees
1285 	 * sends the given amount to the owner's address if the amount does not exceed the
1286 	 * fees (cannot touch the players' balances) minus 100 finney (ensure that oraclize fees can be paid)
1287 	 * */
1288 	function collectFees(uint128 amount) {
1289 		if (!(msg.sender == owner)) throw;
1290 		uint collectedFees = getFees();
1291 		if (amount + 100 finney < collectedFees) {
1292 			if (!owner.send(amount)) throw;
1293 		}
1294 	}
1295 
1296 	/**
1297 	 * pays out the players and kills the game.
1298 	 * */
1299 	function stop() {
1300 		if (!(msg.sender == owner)) throw;
1301 		for (uint16 i = 0; i < numAnimals; i++) {
1302 			if(!animals[ids[i]].owner.send(animals[ids[i]].value)) throw;
1303 		}
1304 		kill();
1305 	}
1306 
1307 
1308 	/**
1309 	 * sell the animal of the given id
1310 	 * */
1311 	function sellAnimal(uint32 animalId) {
1312 		if (msg.sender != animals[animalId].owner) throw;
1313 		uint128 val = animals[animalId].value;
1314 		uint16 animalIndex;
1315 		for (uint16 i = 0; i < ids.length; i++) {
1316 			if (ids[i] == animalId) {
1317 				animalIndex = i;
1318 				break;
1319 			}
1320 		}
1321 		replaceAnimal(animalIndex);
1322 		if (!msg.sender.send(val)) throw;
1323 		newSell(animalId, msg.sender, val);
1324 	}
1325 
1326 	/** transfers animals from one contract to another.
1327 	 *   for easier contract update.
1328 	 * */
1329 	function transfer(address contractAddress) {
1330 		transferable newP4P = transferable(contractAddress);
1331 		uint8[] memory numXType = new uint8[](costs.length);
1332 		mapping(uint16 => uint32[]) tids;
1333 		uint winnings;
1334 
1335 		for (uint16 i = 0; i < numAnimals; i++) {
1336 
1337 			if (animals[ids[i]].owner == msg.sender) {
1338 				Animal a = animals[ids[i]];
1339 				numXType[a.animalType]++;
1340 				winnings += a.value - values[a.animalType];
1341 				tids[a.animalType].push(ids[i]);
1342 				replaceAnimal(i);
1343 				i--;
1344 			}
1345 		}
1346 		for (i = 0; i < costs.length; i++){
1347 			if(numXType[i]>0){
1348 				newP4P.receive.value(numXType[i]*values[i])(msg.sender, uint8(i), tids[i]);
1349 				delete tids[i];
1350 			}
1351 			
1352 		}
1353 			
1354 		if(winnings>0 && !msg.sender.send(winnings)) throw;
1355 	}
1356 	
1357 	/**
1358 	*	receives animals from an old contract version.
1359 	* */
1360 	function receive(address receiver, uint8 animalType, uint32[] oldids) payable {
1361 		if(msg.sender!=lastP4P) throw;
1362 		if (msg.value < oldids.length * values[animalType]) throw;
1363 		for (uint8 i = 0; i < oldids.length; i++) {
1364 			if (animals[oldids[i]].value == 0) {
1365 				addAnimal(animalType, receiver, oldids[i]);
1366 				if(oldids[i]<oldest) oldest = oldids[i];
1367 			} else {
1368 				addAnimal(animalType, receiver, nextId);
1369 				nextId++;
1370 			}
1371 		}
1372 		numAnimalsXType[animalType] += uint16(oldids.length);
1373 	}
1374 
1375 	
1376 	
1377 	/****************** GETTERS *************************/
1378 
1379 
1380 	function getAnimal(uint32 animalId) constant returns(uint8, uint128, address) {
1381 		return (animals[animalId].animalType, animals[animalId].value, animals[animalId].owner);
1382 	}
1383 
1384 	function get10Animals(uint16 startIndex) constant returns(uint32[10] animalIds, uint8[10] types, uint128[10] values, address[10] owners) {
1385 		uint32 endIndex = startIndex + 10 > numAnimals ? numAnimals : startIndex + 10;
1386 		uint8 j = 0;
1387 		uint32 id;
1388 		for (uint16 i = startIndex; i < endIndex; i++) {
1389 			id = ids[i];
1390 			animalIds[j] = id;
1391 			types[j] = animals[id].animalType;
1392 			values[j] = animals[id].value;
1393 			owners[j] = animals[id].owner;
1394 			j++;
1395 		}
1396 
1397 	}
1398 
1399 
1400 	function getFees() constant returns(uint) {
1401 		uint reserved = 0;
1402 		for (uint16 j = 0; j < numAnimals; j++)
1403 			reserved += animals[ids[j]].value;
1404 		return address(this).balance - reserved;
1405 	}
1406 
1407 
1408 	/****************** SETTERS *************************/
1409 
1410 	function setOraclizeGas(uint32 newGas) {
1411 		if (!(msg.sender == owner)) throw;
1412 		oraclizeGas = newGas;
1413 	}
1414 
1415 	function setMaxAnimals(uint16 number) {
1416 		if (!(msg.sender == owner)) throw;
1417 		maxAnimals = number;
1418 	}
1419 	
1420 
1421 	/************* HELPERS ****************/
1422 
1423 	/**
1424 	 * maps a given number to the new range (old range 1000)
1425 	 * */
1426 	function mapToNewRange(uint number, uint range) constant internal returns(uint16 randomNumber) {
1427 		return uint16(number * range / 1000);
1428 	}
1429 
1430 	/**
1431 	 * converts a string of numbers being separated by a given delimiter into an array of numbers (#howmany) 
1432 	 */
1433 	function getNumbersFromString(string s, string delimiter, uint32 howmany) constant internal returns(uint16[] numbers) {
1434 		strings.slice memory myresult = s.toSlice();
1435 		strings.slice memory delim = delimiter.toSlice();
1436 		numbers = new uint16[](howmany);
1437 		for (uint8 i = 0; i < howmany; i++) {
1438 			numbers[i] = uint16(parseInt(myresult.split(delim).toString()));
1439 		}
1440 		return numbers;
1441 	}
1442 
1443 }