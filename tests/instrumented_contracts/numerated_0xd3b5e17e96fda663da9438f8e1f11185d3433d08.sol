1 // <ORACLIZE_API_LIB>
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
31 pragma solidity ^0.4.21;
32 
33 contract OraclizeI {
34     address public cbAddress;
35     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
36     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
37     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
38     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
39     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
40     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
41     function getPrice(string _datasource) public view returns (uint _dsprice);
42     function getPrice(string _datasource, uint gaslimit) public view returns (uint _dsprice);
43     function setProofType(byte _proofType) external;
44     function setCustomGasPrice(uint _gasPrice) external;
45     function randomDS_getSessionPubKeyHash() external view returns(bytes32);
46 }
47 contract OraclizeAddrResolverI {
48     function getAddress() public view returns (address _addr);
49 }
50 library oraclizeLib {
51 
52     function proofType_NONE()
53     public
54     pure
55     returns (byte) {
56         return 0x00;
57     }
58 
59     function proofType_TLSNotary()
60     public
61     pure
62     returns (byte) {
63         return 0x10;
64     }
65 
66     function proofType_Android()
67     public
68     pure
69     returns (byte) {
70         return 0x20;
71     }
72 
73     function proofType_Ledger()
74     public
75     pure
76     returns (byte) {
77         return 0x30;
78     }
79 
80     function proofType_Native()
81     public
82     pure
83     returns (byte) {
84         return 0xF0;
85     }
86 
87     function proofStorage_IPFS()
88     public
89     pure
90     returns (byte) {
91         return 0x01;
92     }
93 
94     //OraclizeAddrResolverI constant public OAR = oraclize_setNetwork();
95 
96     function OAR()
97     public
98     view
99     returns (OraclizeAddrResolverI) {
100         return oraclize_setNetwork();
101     }
102 
103     //OraclizeI constant public oraclize = OraclizeI(OAR.getAddress());
104 
105     function oraclize()
106     public
107     view
108     returns (OraclizeI) {
109         return OraclizeI(OAR().getAddress());
110     }
111 
112     function oraclize_setNetwork()
113     public
114     view
115     returns(OraclizeAddrResolverI){
116         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
117             return OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
118         }
119         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
120             return OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
121         }
122         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
123             return OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
124         }
125         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
126             return OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
127         }
128         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
129             return OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
130         }
131         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
132             return OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
133         }
134         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
135             return OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
136         }
137     }
138 
139     function oraclize_getPrice(string datasource)
140     public
141     view
142     returns (uint){
143         return oraclize().getPrice(datasource);
144     }
145 
146     function oraclize_getPrice(string datasource, uint gaslimit)
147     public
148     view
149     returns (uint){
150         return oraclize().getPrice(datasource, gaslimit);
151     }
152 
153     function oraclize_query(string datasource, string arg)
154     public
155     returns (bytes32 id){
156         return oraclize_query(0, datasource, arg);
157     }
158 
159     function oraclize_query(uint timestamp, string datasource, string arg)
160     public
161     returns (bytes32 id){
162         OraclizeI oracle = oraclize();
163         uint price = oracle.getPrice(datasource);
164         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
165         return oracle.query.value(price)(timestamp, datasource, arg);
166     }
167 
168     function oraclize_query(string datasource, string arg, uint gaslimit)
169     public
170     returns (bytes32 id){
171         return oraclize_query(0, datasource, arg, gaslimit);
172     }
173 
174     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit)
175     public
176     returns (bytes32 id){
177         OraclizeI oracle = oraclize();
178         uint price = oracle.getPrice(datasource, gaslimit);
179         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
180         return oracle.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
181     }
182 
183     function oraclize_query(string datasource, string arg1, string arg2)
184     public
185     returns (bytes32 id){
186         return oraclize_query(0, datasource, arg1, arg2);
187     }
188 
189     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2)
190     public
191     returns (bytes32 id){
192         OraclizeI oracle = oraclize();
193         uint price = oracle.getPrice(datasource);
194         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
195         return oracle.query2.value(price)(timestamp, datasource, arg1, arg2);
196     }
197 
198     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit)
199     public
200     returns (bytes32 id){
201         return oraclize_query(0, datasource, arg1, arg2, gaslimit);
202     }
203 
204     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit)
205     public
206     returns (bytes32 id){
207         OraclizeI oracle = oraclize();
208         uint price = oracle.getPrice(datasource, gaslimit);
209         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
210         return oracle.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
211     }
212 
213     // internalize w/o experimental
214     function oraclize_query(string datasource, string[] argN)
215     internal
216     returns (bytes32 id){
217         return oraclize_query(0, datasource, argN);
218     }
219 
220     // internalize w/o experimental
221     function oraclize_query(uint timestamp, string datasource, string[] argN)
222     internal
223     returns (bytes32 id){
224         OraclizeI oracle = oraclize();
225         uint price = oracle.getPrice(datasource);
226         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
227         bytes memory args = stra2cbor(argN);
228         return oracle.queryN.value(price)(timestamp, datasource, args);
229     }
230 
231     // internalize w/o experimental
232     function oraclize_query(string datasource, string[] argN, uint gaslimit)
233     internal
234     returns (bytes32 id){
235         return oraclize_query(0, datasource, argN, gaslimit);
236     }
237 
238     // internalize w/o experimental
239     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit)
240     internal
241     returns (bytes32 id){
242         OraclizeI oracle = oraclize();
243         uint price = oracle.getPrice(datasource, gaslimit);
244         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
245         bytes memory args = stra2cbor(argN);
246         return oracle.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
247     }
248 
249     function oraclize_cbAddress()
250     public
251     view
252     returns (address){
253         return oraclize().cbAddress();
254     }
255 
256     function oraclize_setProof(byte proofP)
257     public {
258         return oraclize().setProofType(proofP);
259     }
260 
261     function oraclize_setCustomGasPrice(uint gasPrice)
262     public {
263         return oraclize().setCustomGasPrice(gasPrice);
264     }
265 
266     // setting to internal doesn't cause major increase in deployment and saves gas
267     // per use, for this tiny function
268     function getCodeSize(address _addr)
269     public
270     view
271     returns(uint _size) {
272         assembly {
273             _size := extcodesize(_addr)
274         }
275     }
276 
277     // expects 0x prefix
278     function parseAddr(string _a)
279     public
280     pure
281     returns (address){
282         bytes memory tmp = bytes(_a);
283         uint160 iaddr = 0;
284         uint160 b1;
285         uint160 b2;
286         for (uint i=2; i<2+2*20; i+=2){
287             iaddr *= 256;
288             b1 = uint160(tmp[i]);
289             b2 = uint160(tmp[i+1]);
290             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
291             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
292             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
293             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
294             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
295             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
296             iaddr += (b1*16+b2);
297         }
298         return address(iaddr);
299     }
300 
301     function strCompare(string _a, string _b)
302     public
303     pure
304     returns (int) {
305         bytes memory a = bytes(_a);
306         bytes memory b = bytes(_b);
307         uint minLength = a.length;
308         if (b.length < minLength) minLength = b.length;
309         for (uint i = 0; i < minLength; i ++)
310             if (a[i] < b[i])
311                 return -1;
312             else if (a[i] > b[i])
313                 return 1;
314         if (a.length < b.length)
315             return -1;
316         else if (a.length > b.length)
317             return 1;
318         else
319             return 0;
320     }
321 
322     function indexOf(string _haystack, string _needle)
323     public
324     pure
325     returns (int) {
326         bytes memory h = bytes(_haystack);
327         bytes memory n = bytes(_needle);
328         if(h.length < 1 || n.length < 1 || (n.length > h.length))
329             return -1;
330         else if(h.length > (2**128 -1))
331             return -1;
332         else
333         {
334             uint subindex = 0;
335             for (uint i = 0; i < h.length; i ++)
336             {
337                 if (h[i] == n[0])
338                 {
339                     subindex = 1;
340                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
341                     {
342                         subindex++;
343                     }
344                     if(subindex == n.length)
345                         return int(i);
346                 }
347             }
348             return -1;
349         }
350     }
351 
352     function strConcat(string _a, string _b, string _c, string _d, string _e)
353     internal
354     pure
355     returns (string) {
356         bytes memory _ba = bytes(_a);
357         bytes memory _bb = bytes(_b);
358         bytes memory _bc = bytes(_c);
359         bytes memory _bd = bytes(_d);
360         bytes memory _be = bytes(_e);
361         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
362         bytes memory babcde = bytes(abcde);
363         uint k = 0;
364         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
365         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
366         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
367         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
368         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
369         return string(babcde);
370     }
371 
372     function strConcat(string _a, string _b, string _c, string _d)
373     internal
374     pure
375     returns (string) {
376         return strConcat(_a, _b, _c, _d, "");
377     }
378 
379     function strConcat(string _a, string _b, string _c)
380     internal
381     pure
382     returns (string) {
383         return strConcat(_a, _b, _c, "", "");
384     }
385 
386     function strConcat(string _a, string _b)
387     internal
388     pure
389     returns (string) {
390         return strConcat(_a, _b, "", "", "");
391     }
392 
393     // parseInt
394     function parseInt(string _a)
395     public
396     pure
397     returns (uint) {
398         return parseInt(_a, 0);
399     }
400 
401     // parseInt(parseFloat*10^_b)
402     function parseInt(string _a, uint _b)
403     public
404     pure
405     returns (uint) {
406         bytes memory bresult = bytes(_a);
407         uint mint = 0;
408         bool decimals = false;
409         for (uint i=0; i<bresult.length; i++){
410             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
411                 if (decimals){
412                    if (_b == 0) break;
413                     else _b--;
414                 }
415                 mint *= 10;
416                 mint += uint(bresult[i]) - 48;
417             } else if (bresult[i] == 46) decimals = true;
418         }
419         if (_b > 0) mint *= 10**_b;
420         return mint;
421     }
422 
423     function uint2str(uint i)
424     internal
425     pure
426     returns (string){
427         if (i == 0) return "0";
428         uint j = i;
429         uint len;
430         while (j != 0){
431             len++;
432             j /= 10;
433         }
434         bytes memory bstr = new bytes(len);
435         uint k = len - 1;
436         while (i != 0){
437             bstr[k--] = byte(48 + i % 10);
438             i /= 10;
439         }
440         return string(bstr);
441     }
442 
443     function stra2cbor(string[] arr)
444     internal
445     pure
446     returns (bytes) {
447         uint arrlen = arr.length;
448 
449         // get correct cbor output length
450         uint outputlen = 0;
451         bytes[] memory elemArray = new bytes[](arrlen);
452         for (uint i = 0; i < arrlen; i++) {
453             elemArray[i] = (bytes(arr[i]));
454             outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
455         }
456         uint ctr = 0;
457         uint cborlen = arrlen + 0x80;
458         outputlen += byte(cborlen).length;
459         bytes memory res = new bytes(outputlen);
460 
461         while (byte(cborlen).length > ctr) {
462             res[ctr] = byte(cborlen)[ctr];
463             ctr++;
464         }
465         for (i = 0; i < arrlen; i++) {
466             res[ctr] = 0x5F;
467             ctr++;
468             for (uint x = 0; x < elemArray[i].length; x++) {
469                 // if there's a bug with larger strings, this may be the culprit
470                 if (x % 23 == 0) {
471                     uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
472                     elemcborlen += 0x40;
473                     uint lctr = ctr;
474                     while (byte(elemcborlen).length > ctr - lctr) {
475                         res[ctr] = byte(elemcborlen)[ctr - lctr];
476                         ctr++;
477                     }
478                 }
479                 res[ctr] = elemArray[i][x];
480                 ctr++;
481             }
482             res[ctr] = 0xFF;
483             ctr++;
484         }
485         return res;
486     }    
487 }
488 // </ORACLIZE_API_LIB>
489 
490 
491 /*
492  * @title String & slice utility library for Solidity contracts.
493  * @author Nick Johnson <arachnid@notdot.net>
494  *
495  * @dev Functionality in this library is largely implemented using an
496  *      abstraction called a 'slice'. A slice represents a part of a string -
497  *      anything from the entire string to a single character, or even no
498  *      characters at all (a 0-length slice). Since a slice only has to specify
499  *      an offset and a length, copying and manipulating slices is a lot less
500  *      expensive than copying and manipulating the strings they reference.
501  *
502  *      To further reduce gas costs, most functions on slice that need to return
503  *      a slice modify the original one instead of allocating a new one; for
504  *      instance, `s.split(".")` will return the text up to the first '.',
505  *      modifying s to only contain the remainder of the string after the '.'.
506  *      In situations where you do not want to modify the original slice, you
507  *      can make a copy first with `.copy()`, for example:
508  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
509  *      Solidity has no memory management, it will result in allocating many
510  *      short-lived slices that are later discarded.
511  *
512  *      Functions that return two slices come in two versions: a non-allocating
513  *      version that takes the second slice as an argument, modifying it in
514  *      place, and an allocating version that allocates and returns the second
515  *      slice; see `nextRune` for example.
516  *
517  *      Functions that have to copy string data will return strings rather than
518  *      slices; these can be cast back to slices for further processing if
519  *      required.
520  *
521  *      For convenience, some functions are provided with non-modifying
522  *      variants that create a new slice and return both; for instance,
523  *      `s.splitNew('.')` leaves s unmodified, and returns two values
524  *      corresponding to the left and right parts of the string.
525  */
526 
527 library strings {
528     struct slice {
529         uint _len;
530         uint _ptr;
531     }
532 
533     function memcpy(uint dest, uint src, uint len) private pure {
534         // Copy word-length chunks while possible
535         for(; len >= 32; len -= 32) {
536             assembly {
537                 mstore(dest, mload(src))
538             }
539             dest += 32;
540             src += 32;
541         }
542 
543         // Copy remaining bytes
544         uint mask = 256 ** (32 - len) - 1;
545         assembly {
546             let srcpart := and(mload(src), not(mask))
547             let destpart := and(mload(dest), mask)
548             mstore(dest, or(destpart, srcpart))
549         }
550     }
551 
552     /*
553      * @dev Returns a slice containing the entire string.
554      * @param self The string to make a slice from.
555      * @return A newly allocated slice containing the entire string.
556      */
557     function toSlice(string self) internal pure returns (slice) {
558         uint ptr;
559         assembly {
560             ptr := add(self, 0x20)
561         }
562         return slice(bytes(self).length, ptr);
563     }
564 
565     /*
566      * @dev Returns the length of a null-terminated bytes32 string.
567      * @param self The value to find the length of.
568      * @return The length of the string, from 0 to 32.
569      */
570     function len(bytes32 self) internal pure returns (uint) {
571         uint ret;
572         if (self == 0)
573             return 0;
574         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
575             ret += 16;
576             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
577         }
578         if (self & 0xffffffffffffffff == 0) {
579             ret += 8;
580             self = bytes32(uint(self) / 0x10000000000000000);
581         }
582         if (self & 0xffffffff == 0) {
583             ret += 4;
584             self = bytes32(uint(self) / 0x100000000);
585         }
586         if (self & 0xffff == 0) {
587             ret += 2;
588             self = bytes32(uint(self) / 0x10000);
589         }
590         if (self & 0xff == 0) {
591             ret += 1;
592         }
593         return 32 - ret;
594     }
595 
596     /*
597      * @dev Returns a slice containing the entire bytes32, interpreted as a
598      *      null-terminated utf-8 string.
599      * @param self The bytes32 value to convert to a slice.
600      * @return A new slice containing the value of the input argument up to the
601      *         first null.
602      */
603     function toSliceB32(bytes32 self) internal pure returns (slice ret) {
604         // Allocate space for `self` in memory, copy it there, and point ret at it
605         assembly {
606             let ptr := mload(0x40)
607             mstore(0x40, add(ptr, 0x20))
608             mstore(ptr, self)
609             mstore(add(ret, 0x20), ptr)
610         }
611         ret._len = len(self);
612     }
613 
614     /*
615      * @dev Returns a new slice containing the same data as the current slice.
616      * @param self The slice to copy.
617      * @return A new slice containing the same data as `self`.
618      */
619     function copy(slice self) internal pure returns (slice) {
620         return slice(self._len, self._ptr);
621     }
622 
623     /*
624      * @dev Copies a slice to a new string.
625      * @param self The slice to copy.
626      * @return A newly allocated string containing the slice's text.
627      */
628     function toString(slice self) internal pure returns (string) {
629         string memory ret = new string(self._len);
630         uint retptr;
631         assembly { retptr := add(ret, 32) }
632 
633         memcpy(retptr, self._ptr, self._len);
634         return ret;
635     }
636 
637     /*
638      * @dev Returns the length in runes of the slice. Note that this operation
639      *      takes time proportional to the length of the slice; avoid using it
640      *      in loops, and call `slice.empty()` if you only need to know whether
641      *      the slice is empty or not.
642      * @param self The slice to operate on.
643      * @return The length of the slice in runes.
644      */
645     function len(slice self) internal pure returns (uint l) {
646         // Starting at ptr-31 means the LSB will be the byte we care about
647         uint ptr = self._ptr - 31;
648         uint end = ptr + self._len;
649         for (l = 0; ptr < end; l++) {
650             uint8 b;
651             assembly { b := and(mload(ptr), 0xFF) }
652             if (b < 0x80) {
653                 ptr += 1;
654             } else if(b < 0xE0) {
655                 ptr += 2;
656             } else if(b < 0xF0) {
657                 ptr += 3;
658             } else if(b < 0xF8) {
659                 ptr += 4;
660             } else if(b < 0xFC) {
661                 ptr += 5;
662             } else {
663                 ptr += 6;
664             }
665         }
666     }
667 
668     /*
669      * @dev Returns true if the slice is empty (has a length of 0).
670      * @param self The slice to operate on.
671      * @return True if the slice is empty, False otherwise.
672      */
673     function empty(slice self) internal pure returns (bool) {
674         return self._len == 0;
675     }
676 
677     /*
678      * @dev Returns a positive number if `other` comes lexicographically after
679      *      `self`, a negative number if it comes before, or zero if the
680      *      contents of the two slices are equal. Comparison is done per-rune,
681      *      on unicode codepoints.
682      * @param self The first slice to compare.
683      * @param other The second slice to compare.
684      * @return The result of the comparison.
685      */
686     function compare(slice self, slice other) internal pure returns (int) {
687         uint shortest = self._len;
688         if (other._len < self._len)
689             shortest = other._len;
690 
691         uint selfptr = self._ptr;
692         uint otherptr = other._ptr;
693         for (uint idx = 0; idx < shortest; idx += 32) {
694             uint a;
695             uint b;
696             assembly {
697                 a := mload(selfptr)
698                 b := mload(otherptr)
699             }
700             if (a != b) {
701                 // Mask out irrelevant bytes and check again
702                 uint256 mask = uint256(-1); // 0xffff...
703                 if(shortest < 32) {
704                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
705                 }
706                 uint256 diff = (a & mask) - (b & mask);
707                 if (diff != 0)
708                     return int(diff);
709             }
710             selfptr += 32;
711             otherptr += 32;
712         }
713         return int(self._len) - int(other._len);
714     }
715 
716     /*
717      * @dev Returns true if the two slices contain the same text.
718      * @param self The first slice to compare.
719      * @param self The second slice to compare.
720      * @return True if the slices are equal, false otherwise.
721      */
722     function equals(slice self, slice other) internal pure returns (bool) {
723         return compare(self, other) == 0;
724     }
725 
726     /*
727      * @dev Extracts the first rune in the slice into `rune`, advancing the
728      *      slice to point to the next rune and returning `self`.
729      * @param self The slice to operate on.
730      * @param rune The slice that will contain the first rune.
731      * @return `rune`.
732      */
733     function nextRune(slice self, slice rune) internal pure returns (slice) {
734         rune._ptr = self._ptr;
735 
736         if (self._len == 0) {
737             rune._len = 0;
738             return rune;
739         }
740 
741         uint l;
742         uint b;
743         // Load the first byte of the rune into the LSBs of b
744         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
745         if (b < 0x80) {
746             l = 1;
747         } else if(b < 0xE0) {
748             l = 2;
749         } else if(b < 0xF0) {
750             l = 3;
751         } else {
752             l = 4;
753         }
754 
755         // Check for truncated codepoints
756         if (l > self._len) {
757             rune._len = self._len;
758             self._ptr += self._len;
759             self._len = 0;
760             return rune;
761         }
762 
763         self._ptr += l;
764         self._len -= l;
765         rune._len = l;
766         return rune;
767     }
768 
769     /*
770      * @dev Returns the first rune in the slice, advancing the slice to point
771      *      to the next rune.
772      * @param self The slice to operate on.
773      * @return A slice containing only the first rune from `self`.
774      */
775     function nextRune(slice self) internal pure returns (slice ret) {
776         nextRune(self, ret);
777     }
778 
779     /*
780      * @dev Returns the number of the first codepoint in the slice.
781      * @param self The slice to operate on.
782      * @return The number of the first codepoint in the slice.
783      */
784     function ord(slice self) internal pure returns (uint ret) {
785         if (self._len == 0) {
786             return 0;
787         }
788 
789         uint word;
790         uint length;
791         uint divisor = 2 ** 248;
792 
793         // Load the rune into the MSBs of b
794         assembly { word:= mload(mload(add(self, 32))) }
795         uint b = word / divisor;
796         if (b < 0x80) {
797             ret = b;
798             length = 1;
799         } else if(b < 0xE0) {
800             ret = b & 0x1F;
801             length = 2;
802         } else if(b < 0xF0) {
803             ret = b & 0x0F;
804             length = 3;
805         } else {
806             ret = b & 0x07;
807             length = 4;
808         }
809 
810         // Check for truncated codepoints
811         if (length > self._len) {
812             return 0;
813         }
814 
815         for (uint i = 1; i < length; i++) {
816             divisor = divisor / 256;
817             b = (word / divisor) & 0xFF;
818             if (b & 0xC0 != 0x80) {
819                 // Invalid UTF-8 sequence
820                 return 0;
821             }
822             ret = (ret * 64) | (b & 0x3F);
823         }
824 
825         return ret;
826     }
827 
828     /*
829      * @dev Returns the keccak-256 hash of the slice.
830      * @param self The slice to hash.
831      * @return The hash of the slice.
832      */
833     function keccak(slice self) internal pure returns (bytes32 ret) {
834         assembly {
835             ret := keccak256(mload(add(self, 32)), mload(self))
836         }
837     }
838 
839     /*
840      * @dev Returns true if `self` starts with `needle`.
841      * @param self The slice to operate on.
842      * @param needle The slice to search for.
843      * @return True if the slice starts with the provided text, false otherwise.
844      */
845     function startsWith(slice self, slice needle) internal pure returns (bool) {
846         if (self._len < needle._len) {
847             return false;
848         }
849 
850         if (self._ptr == needle._ptr) {
851             return true;
852         }
853 
854         bool equal;
855         assembly {
856             let length := mload(needle)
857             let selfptr := mload(add(self, 0x20))
858             let needleptr := mload(add(needle, 0x20))
859             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
860         }
861         return equal;
862     }
863 
864     /*
865      * @dev If `self` starts with `needle`, `needle` is removed from the
866      *      beginning of `self`. Otherwise, `self` is unmodified.
867      * @param self The slice to operate on.
868      * @param needle The slice to search for.
869      * @return `self`
870      */
871     function beyond(slice self, slice needle) internal pure returns (slice) {
872         if (self._len < needle._len) {
873             return self;
874         }
875 
876         bool equal = true;
877         if (self._ptr != needle._ptr) {
878             assembly {
879                 let length := mload(needle)
880                 let selfptr := mload(add(self, 0x20))
881                 let needleptr := mload(add(needle, 0x20))
882                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
883             }
884         }
885 
886         if (equal) {
887             self._len -= needle._len;
888             self._ptr += needle._len;
889         }
890 
891         return self;
892     }
893 
894     /*
895      * @dev Returns true if the slice ends with `needle`.
896      * @param self The slice to operate on.
897      * @param needle The slice to search for.
898      * @return True if the slice starts with the provided text, false otherwise.
899      */
900     function endsWith(slice self, slice needle) internal pure returns (bool) {
901         if (self._len < needle._len) {
902             return false;
903         }
904 
905         uint selfptr = self._ptr + self._len - needle._len;
906 
907         if (selfptr == needle._ptr) {
908             return true;
909         }
910 
911         bool equal;
912         assembly {
913             let length := mload(needle)
914             let needleptr := mload(add(needle, 0x20))
915             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
916         }
917 
918         return equal;
919     }
920 
921     /*
922      * @dev If `self` ends with `needle`, `needle` is removed from the
923      *      end of `self`. Otherwise, `self` is unmodified.
924      * @param self The slice to operate on.
925      * @param needle The slice to search for.
926      * @return `self`
927      */
928     function until(slice self, slice needle) internal pure returns (slice) {
929         if (self._len < needle._len) {
930             return self;
931         }
932 
933         uint selfptr = self._ptr + self._len - needle._len;
934         bool equal = true;
935         if (selfptr != needle._ptr) {
936             assembly {
937                 let length := mload(needle)
938                 let needleptr := mload(add(needle, 0x20))
939                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
940             }
941         }
942 
943         if (equal) {
944             self._len -= needle._len;
945         }
946 
947         return self;
948     }
949 
950     event log_bytemask(bytes32 mask);
951 
952     // Returns the memory address of the first byte of the first occurrence of
953     // `needle` in `self`, or the first byte after `self` if not found.
954     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
955         uint ptr = selfptr;
956         uint idx;
957 
958         if (needlelen <= selflen) {
959             if (needlelen <= 32) {
960                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
961 
962                 bytes32 needledata;
963                 assembly { needledata := and(mload(needleptr), mask) }
964 
965                 uint end = selfptr + selflen - needlelen;
966                 bytes32 ptrdata;
967                 assembly { ptrdata := and(mload(ptr), mask) }
968 
969                 while (ptrdata != needledata) {
970                     if (ptr >= end)
971                         return selfptr + selflen;
972                     ptr++;
973                     assembly { ptrdata := and(mload(ptr), mask) }
974                 }
975                 return ptr;
976             } else {
977                 // For long needles, use hashing
978                 bytes32 hash;
979                 assembly { hash := sha3(needleptr, needlelen) }
980 
981                 for (idx = 0; idx <= selflen - needlelen; idx++) {
982                     bytes32 testHash;
983                     assembly { testHash := sha3(ptr, needlelen) }
984                     if (hash == testHash)
985                         return ptr;
986                     ptr += 1;
987                 }
988             }
989         }
990         return selfptr + selflen;
991     }
992 
993     // Returns the memory address of the first byte after the last occurrence of
994     // `needle` in `self`, or the address of `self` if not found.
995     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
996         uint ptr;
997 
998         if (needlelen <= selflen) {
999             if (needlelen <= 32) {
1000                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
1001 
1002                 bytes32 needledata;
1003                 assembly { needledata := and(mload(needleptr), mask) }
1004 
1005                 ptr = selfptr + selflen - needlelen;
1006                 bytes32 ptrdata;
1007                 assembly { ptrdata := and(mload(ptr), mask) }
1008 
1009                 while (ptrdata != needledata) {
1010                     if (ptr <= selfptr)
1011                         return selfptr;
1012                     ptr--;
1013                     assembly { ptrdata := and(mload(ptr), mask) }
1014                 }
1015                 return ptr + needlelen;
1016             } else {
1017                 // For long needles, use hashing
1018                 bytes32 hash;
1019                 assembly { hash := sha3(needleptr, needlelen) }
1020                 ptr = selfptr + (selflen - needlelen);
1021                 while (ptr >= selfptr) {
1022                     bytes32 testHash;
1023                     assembly { testHash := sha3(ptr, needlelen) }
1024                     if (hash == testHash)
1025                         return ptr + needlelen;
1026                     ptr -= 1;
1027                 }
1028             }
1029         }
1030         return selfptr;
1031     }
1032 
1033     /*
1034      * @dev Modifies `self` to contain everything from the first occurrence of
1035      *      `needle` to the end of the slice. `self` is set to the empty slice
1036      *      if `needle` is not found.
1037      * @param self The slice to search and modify.
1038      * @param needle The text to search for.
1039      * @return `self`.
1040      */
1041     function find(slice self, slice needle) internal pure returns (slice) {
1042         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1043         self._len -= ptr - self._ptr;
1044         self._ptr = ptr;
1045         return self;
1046     }
1047 
1048     /*
1049      * @dev Modifies `self` to contain the part of the string from the start of
1050      *      `self` to the end of the first occurrence of `needle`. If `needle`
1051      *      is not found, `self` is set to the empty slice.
1052      * @param self The slice to search and modify.
1053      * @param needle The text to search for.
1054      * @return `self`.
1055      */
1056     function rfind(slice self, slice needle) internal pure returns (slice) {
1057         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1058         self._len = ptr - self._ptr;
1059         return self;
1060     }
1061 
1062     /*
1063      * @dev Splits the slice, setting `self` to everything after the first
1064      *      occurrence of `needle`, and `token` to everything before it. If
1065      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1066      *      and `token` is set to the entirety of `self`.
1067      * @param self The slice to split.
1068      * @param needle The text to search for in `self`.
1069      * @param token An output parameter to which the first token is written.
1070      * @return `token`.
1071      */
1072     function split(slice self, slice needle, slice token) internal pure returns (slice) {
1073         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1074         token._ptr = self._ptr;
1075         token._len = ptr - self._ptr;
1076         if (ptr == self._ptr + self._len) {
1077             // Not found
1078             self._len = 0;
1079         } else {
1080             self._len -= token._len + needle._len;
1081             self._ptr = ptr + needle._len;
1082         }
1083         return token;
1084     }
1085 
1086     /*
1087      * @dev Splits the slice, setting `self` to everything after the first
1088      *      occurrence of `needle`, and returning everything before it. If
1089      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1090      *      and the entirety of `self` is returned.
1091      * @param self The slice to split.
1092      * @param needle The text to search for in `self`.
1093      * @return The part of `self` up to the first occurrence of `delim`.
1094      */
1095     function split(slice self, slice needle) internal pure returns (slice token) {
1096         split(self, needle, token);
1097     }
1098 
1099     /*
1100      * @dev Splits the slice, setting `self` to everything before the last
1101      *      occurrence of `needle`, and `token` to everything after it. If
1102      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1103      *      and `token` is set to the entirety of `self`.
1104      * @param self The slice to split.
1105      * @param needle The text to search for in `self`.
1106      * @param token An output parameter to which the first token is written.
1107      * @return `token`.
1108      */
1109     function rsplit(slice self, slice needle, slice token) internal pure returns (slice) {
1110         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1111         token._ptr = ptr;
1112         token._len = self._len - (ptr - self._ptr);
1113         if (ptr == self._ptr) {
1114             // Not found
1115             self._len = 0;
1116         } else {
1117             self._len -= token._len + needle._len;
1118         }
1119         return token;
1120     }
1121 
1122     /*
1123      * @dev Splits the slice, setting `self` to everything before the last
1124      *      occurrence of `needle`, and returning everything after it. If
1125      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1126      *      and the entirety of `self` is returned.
1127      * @param self The slice to split.
1128      * @param needle The text to search for in `self`.
1129      * @return The part of `self` after the last occurrence of `delim`.
1130      */
1131     function rsplit(slice self, slice needle) internal pure returns (slice token) {
1132         rsplit(self, needle, token);
1133     }
1134 
1135     /*
1136      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1137      * @param self The slice to search.
1138      * @param needle The text to search for in `self`.
1139      * @return The number of occurrences of `needle` found in `self`.
1140      */
1141     function count(slice self, slice needle) internal pure returns (uint cnt) {
1142         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1143         while (ptr <= self._ptr + self._len) {
1144             cnt++;
1145             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1146         }
1147     }
1148 
1149     /*
1150      * @dev Returns True if `self` contains `needle`.
1151      * @param self The slice to search.
1152      * @param needle The text to search for in `self`.
1153      * @return True if `needle` is found in `self`, false otherwise.
1154      */
1155     function contains(slice self, slice needle) internal pure returns (bool) {
1156         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1157     }
1158 
1159     /*
1160      * @dev Returns a newly allocated string containing the concatenation of
1161      *      `self` and `other`.
1162      * @param self The first slice to concatenate.
1163      * @param other The second slice to concatenate.
1164      * @return The concatenation of the two strings.
1165      */
1166     function concat(slice self, slice other) internal pure returns (string) {
1167         string memory ret = new string(self._len + other._len);
1168         uint retptr;
1169         assembly { retptr := add(ret, 32) }
1170         memcpy(retptr, self._ptr, self._len);
1171         memcpy(retptr + self._len, other._ptr, other._len);
1172         return ret;
1173     }
1174 
1175     /*
1176      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1177      *      newly allocated string.
1178      * @param self The delimiter to use.
1179      * @param parts A list of slices to join.
1180      * @return A newly allocated string containing all the slices in `parts`,
1181      *         joined with `self`.
1182      */
1183     function join(slice self, slice[] parts) internal pure returns (string) {
1184         if (parts.length == 0)
1185             return "";
1186 
1187         uint length = self._len * (parts.length - 1);
1188         for(uint i = 0; i < parts.length; i++)
1189             length += parts[i]._len;
1190 
1191         string memory ret = new string(length);
1192         uint retptr;
1193         assembly { retptr := add(ret, 32) }
1194 
1195         for(i = 0; i < parts.length; i++) {
1196             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1197             retptr += parts[i]._len;
1198             if (i < parts.length - 1) {
1199                 memcpy(retptr, self._ptr, self._len);
1200                 retptr += self._len;
1201             }
1202         }
1203 
1204         return ret;
1205     }
1206 }
1207 
1208 library SafeMath {
1209 
1210   /**
1211   * @dev Multiplies two numbers, throws on overflow.
1212   */
1213   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1214     if (a == 0) {
1215       return 0;
1216     }
1217     uint256 c = a * b;
1218     assert(c / a == b);
1219     return c;
1220   }
1221 
1222   /**
1223   * @dev Integer division of two numbers, truncating the quotient.
1224   */
1225   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1226     // assert(b > 0); // Solidity automatically throws when dividing by 0
1227     uint256 c = a / b;
1228     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1229     return c;
1230   }
1231 
1232   /**
1233   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1234   */
1235   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1236     assert(b <= a);
1237     return a - b;
1238   }
1239 
1240   /**
1241   * @dev Adds two numbers, throws on overflow.
1242   */
1243   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1244     uint256 c = a + b;
1245     assert(c >= a);
1246     return c;
1247   }
1248 }
1249 
1250 
1251 /**
1252  * @title Ownable
1253  * @dev The Ownable contract has an owner address, and provides basic authorization control
1254  * functions, this simplifies the implementation of "user permissions".
1255  */
1256 contract Ownable {
1257   address public owner;
1258 
1259 
1260   /**
1261    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1262    * account.
1263    */
1264   function Ownable() public{
1265     owner = msg.sender;
1266   }
1267 
1268 
1269   /**
1270    * @dev Throws if called by any account other than the owner.
1271    */
1272   modifier onlyOwner() {
1273     require(msg.sender == owner);
1274     _;
1275   }
1276 
1277 
1278   /**
1279    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1280    * @param newOwner The address to transfer ownership to.
1281    */
1282   function transferOwnership(address newOwner) onlyOwner public{
1283     if (newOwner != address(0)) {
1284       owner = newOwner;
1285     }
1286   }
1287 
1288 }
1289 
1290 
1291 /**
1292  * @title Pausable
1293  * @dev Base contract which allows children to implement an emergency stop mechanism.
1294  */
1295 contract Pausable is Ownable {
1296   event Pause();
1297   event Unpause();
1298 
1299   bool public paused = false;
1300 
1301 
1302   /**
1303    * @dev modifier to allow actions only when the contract IS paused
1304    */
1305   modifier whenNotPaused() {
1306     require(!paused);
1307     _;
1308   }
1309 
1310   /**
1311    * @dev modifier to allow actions only when the contract IS NOT paused
1312    */
1313   modifier whenPaused {
1314     require(paused);
1315     _;
1316   }
1317 
1318   /**
1319    * @dev called by the owner to pause, triggers stopped state
1320    */
1321   function pause() onlyOwner whenNotPaused public returns (bool) {
1322     paused = true;
1323     emit Pause();
1324     return true;
1325   }
1326 
1327   /**
1328    * @dev called by the owner to unpause, returns to normal state
1329    */
1330   function unpause() onlyOwner whenPaused public returns (bool) {
1331     paused = false;
1332     emit Unpause();
1333     return true;
1334   }
1335 }
1336 
1337 
1338 /**
1339  * @title Ownable
1340  * @dev The Ownable contract has an owner address, and provides basic authorization control
1341  * functions, this simplifies the implementation of "user permissions".
1342  */
1343 contract Config is Pausable {
1344     // 配置信息
1345     uint public taxRate;     
1346     uint gasForOraclize;
1347     uint systemGasForOraclize; 
1348     uint256 public minStake;
1349     uint256 public maxStake;
1350     uint256 public maxWin;
1351     uint256 public normalRoomMin;
1352     uint256 public normalRoomMax;
1353     uint256 public tripleRoomMin;
1354     uint256 public tripleRoomMax;
1355     uint referrelFund;
1356     string random_api_key;
1357     uint public minSet;
1358     uint public maxSet;
1359 
1360     function Config() public{
1361         setOraGasLimit(235000);         
1362         setSystemOraGasLimit(120000);   
1363         setMinStake(0.1 ether);
1364         setMaxStake(10 ether);
1365         setMaxWin(10 ether); 
1366         taxRate = 20;
1367         setNormalRoomMin(0.1 ether);
1368         setNormalRoomMax(1 ether);
1369         setTripleRoomMin(1 ether);
1370         setTripleRoomMax(10 ether);
1371         setRandomApiKey("50faa373-68a1-40ce-8da8-4523db62d42a");
1372         setMinSet(3);
1373         setMaxSet(10);
1374         referrelFund = 10;
1375     }
1376 
1377     function setRandomApiKey(string value) public onlyOwner {        
1378         random_api_key = value;
1379     }           
1380 
1381     function setOraGasLimit(uint gasLimit) public onlyOwner {
1382         if(gasLimit == 0){
1383             return;
1384         }
1385         gasForOraclize = gasLimit;
1386     }
1387 
1388     function setSystemOraGasLimit(uint gasLimit) public onlyOwner {
1389         if(gasLimit == 0){
1390             return;
1391         }
1392         systemGasForOraclize = gasLimit;
1393     }       
1394     
1395 
1396     function setMinStake(uint256 value) public onlyOwner{
1397         if(value == 0){
1398             return;
1399         }
1400         minStake = value;
1401     }
1402 
1403     function setMaxStake(uint256 value) public onlyOwner{
1404         if(value == 0){
1405             return;
1406         }
1407         maxStake = value;
1408     }
1409 
1410     function setMinSet(uint value) public onlyOwner{
1411         if(value == 0){
1412             return;
1413         }
1414         minSet = value;
1415     }
1416 
1417     function setMaxSet(uint value) public onlyOwner{
1418         if(value == 0){
1419             return;
1420         }
1421         maxSet = value;
1422     }
1423 
1424     function setMaxWin(uint256 value) public onlyOwner{
1425         if(value == 0){
1426             return;
1427         }
1428         maxWin = value;
1429     }
1430 
1431     function setNormalRoomMax(uint256 value) public onlyOwner{
1432         if(value == 0){
1433             return;
1434         }
1435         normalRoomMax = value;
1436     }
1437 
1438     function setNormalRoomMin(uint256 value) public onlyOwner{
1439         if(value == 0){
1440             return;
1441         }
1442         normalRoomMin = value;
1443     }
1444 
1445     function setTripleRoomMax(uint256 value) public onlyOwner{
1446         if(value == 0){
1447             return;
1448         }
1449         tripleRoomMax = value;
1450     }
1451 
1452     function setTripleRoomMin(uint256 value) public onlyOwner{
1453         if(value == 0){
1454             return;
1455         }
1456         tripleRoomMin = value;
1457     }
1458 
1459     function setTaxRate(uint value) public onlyOwner{
1460         if(value == 0 || value >= 1000){
1461             return;
1462         }
1463         taxRate = value;
1464     }
1465 
1466     function setReferralFund(uint value) public onlyOwner{
1467         if(value == 0 || value >= 1000){
1468             return;
1469         }
1470         referrelFund = value;
1471     }  
1472 }
1473 
1474 contract UserManager {    
1475     struct UserInfo {         
1476         uint256 playAmount;
1477         uint playCount;
1478         uint openRoomCount;
1479         uint256 winAmount;
1480         address referral;       
1481     }
1482    
1483     mapping (address => UserInfo) allUsers;
1484     
1485     
1486     function UserManager() public{        
1487     }    
1488 
1489     function addBet (address player,uint256 value) internal {        
1490         allUsers[player].playCount++;
1491         allUsers[player].playAmount += value;
1492     }
1493 
1494     function addWin (address player,uint256 value) internal {            
1495         allUsers[player].winAmount += value;
1496     }
1497     
1498     function addOpenRoomCount (address player) internal {
1499        allUsers[player].openRoomCount ++;
1500     }
1501 
1502     function subOpenRoomCount (address player) internal {          
1503         if(allUsers[player].openRoomCount > 0){
1504             allUsers[player].openRoomCount--;
1505         }
1506     }
1507 
1508     function setReferral (address player,address referral) internal { 
1509         if(referral == 0)
1510             return;
1511         if(allUsers[player].referral == 0 && referral != player){
1512             allUsers[player].referral = referral;
1513         }
1514     }
1515     
1516     function getPlayedInfo (address player) public view returns(uint playedCount,uint openRoomCount,
1517         uint256 playAmount,uint256 winAmount) {
1518         playedCount = allUsers[player].playCount;
1519         openRoomCount = allUsers[player].openRoomCount;
1520         playAmount = allUsers[player].playAmount;
1521         winAmount = allUsers[player].winAmount;
1522     }
1523     
1524 
1525     function fundReferrel(address player,uint256 value) internal {
1526         if(allUsers[player].referral != 0){
1527             allUsers[player].referral.transfer(value);
1528         }
1529     }    
1530 }
1531 
1532 /**
1533  * The contractName contract does this and that...
1534  */
1535 contract RoomManager {  
1536     uint constant roomFree = 0;
1537     uint constant roomPending = 1;
1538     uint constant roomEnded = 2;
1539 
1540     struct RoomInfo{
1541         uint roomid;
1542         address owner;
1543         uint setCount;  // 0 if not a tripple room
1544         uint256 balance;
1545         uint status;
1546         uint currentSet;
1547         uint256 initBalance;
1548         uint roomData;  // owner choose big(1) ozr small(0)
1549         address lastPlayer;
1550         uint256 lastBet;
1551     }
1552 
1553     uint[] roomIDList;
1554 
1555     mapping (uint => RoomInfo) roomMapping;   
1556 
1557     uint _roomindex;
1558 
1559     event evt_calculate(address indexed player,address owner,uint num123,int256 winAmount,uint roomid,uint256 playTime,bytes32 serialNumber);
1560     event evt_gameRecord(address indexed player,uint256 betAmount,int256 winAmount,uint playTypeAndData,uint256 time,uint num123,address owner,uint setCountAndEndSet,uint256 roomInitBalance);
1561     
1562 
1563     function RoomManager ()  public {       
1564         _roomindex = 1; // 0 is invalid roomid       
1565     }
1566     
1567     function getResult(uint num123) internal pure returns(uint){
1568         uint num1 = num123 / 100;
1569         uint num2 = (num123 % 100) / 10;
1570         uint num3 = num123 % 10;
1571         if(num1 + num2 + num3 > 10){
1572             return 1;
1573         }
1574         return 0;
1575     }
1576     
1577     function isTripleNumber(uint num123) internal pure returns(bool){
1578         uint num1 = num123 / 100;
1579         uint num2 = (num123 % 100) / 10;
1580         uint num3 = num123 % 10;
1581         return (num1 == num2 && num1 == num3);
1582     }
1583 
1584     
1585     function tryOpenRoom(address owner,uint256 value,uint setCount,uint roomData) internal returns(uint roomID){
1586         roomID = _roomindex;
1587         roomMapping[_roomindex].owner = owner;
1588         roomMapping[_roomindex].initBalance = value;
1589         roomMapping[_roomindex].balance = value;
1590         roomMapping[_roomindex].setCount = setCount;
1591         roomMapping[_roomindex].roomData = roomData;
1592         roomMapping[_roomindex].roomid = _roomindex;
1593         roomMapping[_roomindex].status = roomFree;
1594         roomIDList.push(_roomindex);
1595         _roomindex++;
1596         if(_roomindex == 0){
1597             _roomindex = 1;
1598         }      
1599     }
1600 
1601     function tryCloseRoom(address owner,uint roomid,uint taxrate) internal returns(bool ret,bool taxPayed)  {
1602         // find the room        
1603         ret = false;
1604         taxPayed = false;
1605         if(roomMapping[roomid].roomid == 0){
1606             return;
1607         }       
1608         RoomInfo memory room = roomMapping[roomid];
1609         // is the owner?
1610         if(room.owner != owner){
1611             return;
1612         }
1613         // 能不能解散
1614         if(room.status == roomPending){
1615             return;
1616         }
1617         ret = true;
1618         // return 
1619         // need to pay tax?
1620         if(room.balance > room.initBalance){
1621             uint256 tax = SafeMath.div(SafeMath.mul(room.balance,taxrate),1000);            
1622             room.balance -= tax;
1623             taxPayed = true;
1624         }
1625         room.owner.transfer(room.balance);
1626         deleteRoomByRoomID(roomid);
1627         return;
1628     }
1629 
1630     function tryDismissRoom(uint roomid) internal {
1631         // find the room        
1632         if(roomMapping[roomid].roomid == 0){
1633             return;
1634         }    
1635 
1636         RoomInfo memory room = roomMapping[roomid];
1637         
1638         if(room.lastPlayer == 0){
1639             room.owner.transfer(room.balance);
1640             deleteRoomByRoomID(roomid);
1641             return;
1642         }
1643         room.lastPlayer.transfer(room.lastBet);
1644         room.owner.transfer(SafeMath.sub(room.balance,room.lastBet));
1645         deleteRoomByRoomID(roomid);
1646     }   
1647 
1648     // just check if can be rolled and update balance,not calculate here
1649     function tryRollRoom(address user,uint256 value,uint roomid) internal returns(bool)  {
1650         if(value <= 0){
1651             return false;
1652         }
1653 
1654         if(roomMapping[roomid].roomid == 0){
1655             return false;
1656         }
1657 
1658         RoomInfo storage room = roomMapping[roomid];
1659 
1660         if(room.status != roomFree || room.balance == 0){
1661             return false;
1662         }
1663 
1664         uint256 betValue = getBetValue(room.initBalance,room.balance,room.setCount);
1665 
1666         // if value less
1667         if (value < betValue){
1668             return false;
1669         }
1670         if(value > betValue){
1671             user.transfer(value - betValue);
1672             value = betValue;
1673         }
1674         // add to room balance
1675         room.balance += value;
1676         room.lastPlayer = user;
1677         room.lastBet = value;
1678         room.status = roomPending;
1679         return true;
1680     }
1681 
1682     // do the calculation
1683     // returns : success,isend,winer,tax
1684     function calculateRoom(uint roomid,uint num123,uint taxrate,bytes32 myid) internal returns(bool success,
1685         bool isend,address winer,uint256 tax) {
1686         success = false;        
1687         tax = 0;
1688         if(roomMapping[roomid].roomid == 0){
1689             return;
1690         }
1691 
1692         RoomInfo memory room = roomMapping[roomid];
1693         if(room.status != roomPending || room.balance == 0){            
1694             return;
1695         }
1696 
1697         // ok
1698         success = true;        
1699         // simple room
1700         if(room.setCount == 0){
1701             isend = true;
1702             (winer,tax) = calSimpleRoom(roomid,taxrate,num123,myid);            
1703             return;
1704         }
1705 
1706         (winer,tax,isend) = calTripleRoom(roomid,taxrate,num123,myid);
1707     }
1708 
1709     function calSimpleRoom(uint roomid,uint taxrate,uint num123,bytes32 myid) internal returns(address winer,uint256 tax) { 
1710         RoomInfo storage room = roomMapping[roomid];
1711         uint result = getResult(num123);
1712         tax = SafeMath.div(SafeMath.mul(room.balance,taxrate),1000);
1713         room.balance -= tax; 
1714         int256 winamount = -int256(room.lastBet);
1715         if(room.roomData == result){
1716             // owner win                
1717             winer = room.owner;
1718             winamount += int256(tax);
1719         } else {
1720             // player win               
1721             winer = room.lastPlayer;
1722             winamount = int256(room.balance - room.initBalance);
1723         }
1724         room.status = roomEnded;            
1725         winer.transfer(room.balance);       
1726         
1727         emit evt_calculate(room.lastPlayer,room.owner,num123,winamount,room.roomid,now,myid);
1728         emit evt_gameRecord(room.lastPlayer,room.lastBet,winamount,10 + room.roomData,now,num123,room.owner,0,room.initBalance);
1729         deleteRoomByRoomID(roomid);
1730     }
1731 
1732     function calTripleRoom(uint roomid,uint taxrate,uint num123,bytes32 myid) internal 
1733         returns(address winer,uint256 tax,bool isend) { 
1734         RoomInfo storage room = roomMapping[roomid];       
1735         // triple room
1736         room.currentSet++;
1737         int256 winamount = -int256(room.lastBet);
1738         bool isTriple = isTripleNumber(num123);
1739         isend = room.currentSet >= room.setCount || isTriple;
1740         if(isend){
1741             tax = SafeMath.div(SafeMath.mul(room.balance,taxrate),1000);
1742             room.balance -= tax; 
1743             if(isTriple){   
1744                 // player win
1745                 winer = room.lastPlayer;
1746                 winamount = int256(room.balance - room.lastBet);
1747             } else {
1748                 // owner win
1749                 winer = room.owner;
1750             }
1751             room.status = roomEnded;
1752             winer.transfer(room.balance);       
1753             
1754             room.balance = 0;            
1755             emit evt_calculate(room.lastPlayer,room.owner,num123,winamount,room.roomid,now,myid);
1756             emit evt_gameRecord(room.lastPlayer,room.lastBet,winamount,10,now,num123,room.owner,room.setCount * 100 + room.currentSet,room.initBalance);
1757             deleteRoomByRoomID(roomid);
1758         } else {
1759             room.status = roomFree;
1760             emit evt_gameRecord(room.lastPlayer,room.lastBet,winamount,10,now,num123,room.owner,room.setCount * 100 + room.currentSet,room.initBalance);
1761             emit evt_calculate(room.lastPlayer,room.owner,num123,winamount,room.roomid,now,myid);
1762         }
1763     }
1764     
1765 
1766     function getBetValue(uint256 initBalance,uint256 curBalance,uint setCount) public pure returns(uint256) {
1767         // normal
1768         if(setCount == 0){
1769             return initBalance;
1770         }
1771 
1772         // tripple
1773         return SafeMath.div(curBalance,setCount);
1774     }   
1775 
1776     function deleteRoomByRoomID (uint roomID) internal {
1777         delete roomMapping[roomID];
1778         uint len = roomIDList.length;
1779         for(uint i = 0;i < len;i++){
1780             if(roomIDList[i] == roomID){
1781                 roomIDList[i] = roomIDList[len - 1];
1782                 roomIDList.length--;
1783                 return;
1784             }
1785         }        
1786     }
1787 
1788     function deleteRoomByIndex (uint index) internal {    
1789         uint len = roomIDList.length;
1790         if(index > len - 1){
1791             return;
1792         }
1793         delete roomMapping[roomIDList[index]];
1794         roomIDList[index] = roomIDList[len - 1];   
1795         roomIDList.length--;
1796     }
1797 
1798     function getAllBalance() public view returns(uint256) {
1799         uint256 ret = 0;
1800         for(uint i = 0;i < roomIDList.length;i++){
1801             ret += roomMapping[roomIDList[i]].balance;
1802         }
1803         return ret;
1804     }
1805     
1806     function returnAllRoomsBalance() internal {
1807         for(uint i = 0;i < roomIDList.length;i++){            
1808             if(roomMapping[roomIDList[i]].balance > 0){
1809                 roomMapping[roomIDList[i]].owner.transfer(roomMapping[roomIDList[i]].balance);
1810                 roomMapping[roomIDList[i]].balance = 0;
1811                 roomMapping[roomIDList[i]].status = roomEnded;
1812             }
1813         }
1814     }
1815 
1816     function removeFreeRoom() internal {
1817         for(uint i = 0;i < roomIDList.length;i++){
1818             if(roomMapping[roomIDList[i]].balance ==0 && roomMapping[roomIDList[i]].status == roomEnded){
1819                 deleteRoomByIndex(i);
1820                 removeFreeRoom();
1821                 return;
1822             }
1823         }
1824     }
1825 
1826     function getRoomCount() public view returns(uint) {
1827         return roomIDList.length;
1828     }
1829 
1830     function getRoomID(uint index) public view returns(uint)  {
1831         if(index > roomIDList.length){
1832             return 0;
1833         }
1834         return roomIDList[index];
1835     } 
1836 
1837     function getRoomInfo(uint index) public view 
1838         returns(uint roomID,address owner,uint setCount,
1839             uint256 balance,uint status,uint curSet,uint data) {
1840         if(index > roomIDList.length){
1841             return;
1842         }
1843         roomID = roomMapping[roomIDList[index]].roomid;
1844         owner = roomMapping[roomIDList[index]].owner;
1845         setCount = roomMapping[roomIDList[index]].setCount;
1846         balance = roomMapping[roomIDList[index]].balance;
1847         status = roomMapping[roomIDList[index]].status;
1848         curSet = roomMapping[roomIDList[index]].currentSet;
1849         data = roomMapping[roomIDList[index]].roomData;
1850     }    
1851 }
1852 
1853 contract DiceOffline is Config,RoomManager,UserManager {
1854     // 事件
1855     event withdraw_failed();
1856     event withdraw_succeeded(address toUser,uint256 value);    
1857     event bet_failed(address indexed player,uint256 value,uint result,uint roomid,uint errorcode);
1858     event bet_succeeded(address indexed player,uint256 value,uint result,uint roomid,bytes32 serialNumber);    
1859     event evt_createRoomFailed(address indexed player);
1860     event evt_createRoomSucceeded(address indexed player,uint roomid);
1861     event evt_closeRoomFailed(address indexed player,uint roomid);
1862     event evt_closeRoomSucceeded(address indexed player,uint roomid);
1863 
1864     // 下注信息
1865     struct BetInfo{
1866         address player;
1867         uint result;
1868         uint256 value;  
1869         uint roomid;       
1870     }
1871 
1872     mapping (bytes32 => BetInfo) rollingBet;
1873     uint256 public allWagered;
1874     uint256 public allWon;
1875     uint    public allPlayCount;
1876 
1877     function DiceOffline() public{        
1878     }  
1879    
1880     
1881     // 销毁合约
1882     function destroy() onlyOwner public{     
1883         returnAllRoomsBalance();
1884         selfdestruct(owner);
1885     }
1886 
1887     // 充值
1888     function () public payable {        
1889     }
1890 
1891     // 提现
1892     function withdraw(uint256 value) public onlyOwner{
1893         if(getAvailableBalance() < value){
1894             emit withdraw_failed();
1895             return;
1896         }
1897         owner.transfer(value);  
1898         emit withdraw_succeeded(owner,value);
1899     }
1900 
1901     // 获取可提现额度
1902     function getAvailableBalance() public view returns (uint256){
1903         return SafeMath.sub(getBalance(),getAllBalance());
1904     }
1905 
1906     function rollSystem (uint result,address referral) public payable returns(bool) {
1907         if(msg.value == 0){
1908             return;
1909         }
1910         BetInfo memory bet = BetInfo(msg.sender,result,msg.value,0);
1911        
1912         if(bet.value < minStake){
1913             bet.player.transfer(bet.value);
1914             emit bet_failed(bet.player,bet.value,result,0,0);
1915             return false;
1916         }
1917 
1918         uint256 maxBet = getAvailableBalance() / 10;
1919         if(maxBet > maxStake){
1920             maxBet = maxStake;
1921         }
1922 
1923         if(bet.value > maxBet){
1924             bet.player.transfer(SafeMath.sub(bet.value,maxBet));
1925             bet.value = maxBet;
1926         }
1927       
1928         allWagered += bet.value;
1929         allPlayCount++;
1930 
1931         addBet(msg.sender,bet.value);
1932         setReferral(msg.sender,referral);        
1933         // 生成随机数
1934         bytes32 serialNumber = doOraclize(true);
1935         rollingBet[serialNumber] = bet;
1936         emit bet_succeeded(bet.player,bet.value,result,0,serialNumber);        
1937         return true;
1938     }   
1939 
1940     // 如果setCount为0，表示大小
1941     function openRoom(uint setCount,uint roomData,address referral) public payable returns(bool) {
1942         if(setCount > 0 && (setCount > maxSet || setCount < minSet)){
1943             emit evt_createRoomFailed(msg.sender);
1944             msg.sender.transfer(msg.value);
1945             return false;
1946         }
1947         uint256 minValue = normalRoomMin;
1948         uint256 maxValue = normalRoomMax;
1949         if(setCount > 0){
1950             minValue = tripleRoomMin;
1951             maxValue = tripleRoomMax;
1952         }
1953 
1954         if(msg.value < minValue || msg.value > maxValue){
1955             emit evt_createRoomFailed(msg.sender);
1956             msg.sender.transfer(msg.value);
1957             return false;
1958         }
1959 
1960         allWagered += msg.value;
1961 
1962         uint roomid = tryOpenRoom(msg.sender,msg.value,setCount,roomData);
1963         setReferral(msg.sender,referral);
1964         addOpenRoomCount(msg.sender);
1965 
1966         emit evt_createRoomSucceeded(msg.sender,roomid); 
1967     }
1968 
1969     function closeRoom(uint roomid) public returns(bool) {        
1970         bool ret = false;
1971         bool taxPayed = false;        
1972         (ret,taxPayed) = tryCloseRoom(msg.sender,roomid,taxRate);
1973         if(!ret){
1974             emit evt_closeRoomFailed(msg.sender,roomid);
1975             return false;
1976         }
1977         
1978         emit evt_closeRoomSucceeded(msg.sender,roomid);
1979 
1980         if(!taxPayed){
1981             subOpenRoomCount(msg.sender);
1982         }
1983         
1984         return true;
1985     }    
1986 
1987     function rollRoom(uint roomid,address referral) public payable returns(bool) {
1988         bool ret = tryRollRoom(msg.sender,msg.value,roomid);
1989         if(!ret){
1990             emit bet_failed(msg.sender,msg.value,0,roomid,0);
1991             msg.sender.transfer(msg.value);
1992             return false;
1993         }        
1994         
1995         BetInfo memory bet = BetInfo(msg.sender,0,msg.value,roomid);
1996 
1997         allWagered += bet.value;
1998         allPlayCount++;
1999        
2000         setReferral(msg.sender,referral);
2001         addBet(msg.sender,bet.value);
2002         // 生成随机数
2003         bytes32 serialNumber = doOraclize(false);
2004         rollingBet[serialNumber] = bet;
2005         emit bet_succeeded(msg.sender,msg.value,0,roomid,serialNumber);       
2006         return true;
2007     }
2008 
2009     function dismissRoom(uint roomid) public onlyOwner {
2010         tryDismissRoom(roomid);
2011     } 
2012 
2013     function doOraclize(bool isSystem) internal returns(bytes32) {        
2014         uint256 random = uint256(keccak256(block.difficulty,now));
2015         return bytes32(random);       
2016     }
2017 
2018     /*TLSNotary for oraclize call 
2019     function offlineCallback(bytes32 myid) internal {
2020         uint num = uint256(keccak256(block.difficulty,now)) & 216;
2021         uint num1 = num % 6 + 1;
2022         uint num2 = (num / 6) % 6 + 1;
2023         uint num3 = (num / 36) % 6 + 1;
2024         doCalculate(num1 * 100 + num2 * 10 + num3,myid);  
2025     }*/
2026 
2027     function doCalculate(uint num123,bytes32 myid) internal {
2028         BetInfo memory bet = rollingBet[myid];   
2029         if(bet.player == 0){            
2030             return;
2031         }       
2032         
2033         if(bet.roomid == 0){    // 普通房间
2034             // 进行结算
2035             int256 winAmount = -int256(bet.value);
2036             if(bet.result == getResult(num123)){
2037                 uint256 tax = (bet.value + bet.value) * taxRate / 1000;                
2038                 winAmount = int256(bet.value - tax);
2039                 addWin(bet.player,uint256(winAmount));
2040                 bet.player.transfer(bet.value + uint256(winAmount));
2041                 fundReferrel(bet.player,tax * referrelFund / 1000);
2042                 allWon += uint256(winAmount);
2043             }
2044             //addGameRecord(bet.player,bet.value,winAmount,bet.result,num123,0x0,0,0);
2045             emit evt_calculate(bet.player,0x0,num123,winAmount,0,now,myid);
2046             emit evt_gameRecord(bet.player,bet.value,winAmount,bet.result,now,num123,0x0,0,0);
2047             delete rollingBet[myid];
2048             return;
2049         }
2050         
2051         doCalculateRoom(num123,myid);
2052     }
2053 
2054     function doCalculateRoom(uint num123,bytes32 myid) internal {
2055         // 多人房间
2056         BetInfo memory bet = rollingBet[myid];         
2057        
2058         bool success;
2059         bool isend;
2060         address winer;
2061         uint256 tax;     
2062 
2063         (success,isend,winer,tax) = calculateRoom(bet.roomid,num123,taxRate,myid);
2064         delete rollingBet[myid];
2065         if(!success){            
2066             return;
2067         }
2068 
2069         if(isend){
2070             addWin(winer,tax * 1000 / taxRate);
2071             fundReferrel(winer,SafeMath.div(SafeMath.mul(tax,referrelFund),1000));            
2072         }        
2073     }
2074   
2075     function getBalance() public view returns(uint256){
2076         return address(this).balance;
2077     }
2078 }
2079 
2080 contract DiceOnline is DiceOffline {    
2081     using strings for *;     
2082     // 随机序列号
2083     uint randomQueryID;   
2084     
2085     function DiceOnline() public{   
2086         oraclizeLib.oraclize_setProof(oraclizeLib.proofType_TLSNotary() | oraclizeLib.proofStorage_IPFS());     
2087         oraclizeLib.oraclize_setCustomGasPrice(20000000000 wei);        
2088         randomQueryID = 0;
2089     }    
2090 
2091     /*
2092      * checks only Oraclize address is calling
2093     */
2094     modifier onlyOraclize {
2095         require(msg.sender == oraclizeLib.oraclize_cbAddress());
2096         _;
2097     }    
2098     
2099     function doOraclize(bool isSystem) internal returns(bytes32) {
2100         randomQueryID += 1;
2101         string memory queryString1 = "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random[\"data\"]', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"params\":{\"apiKey\":\"";
2102         string memory queryString2 = random_api_key;
2103         string memory queryString3 = "\",\"n\":3,\"min\":1,\"max\":6},\"id\":";
2104         string memory queryString4 = oraclizeLib.uint2str(randomQueryID);
2105         string memory queryString5 = "}']";
2106 
2107         string memory queryString1_2 = queryString1.toSlice().concat(queryString2.toSlice());
2108         string memory queryString1_2_3 = queryString1_2.toSlice().concat(queryString3.toSlice());
2109         string memory queryString1_2_3_4 = queryString1_2_3.toSlice().concat(queryString4.toSlice());
2110         string memory queryString1_2_3_4_5 = queryString1_2_3_4.toSlice().concat(queryString5.toSlice());
2111         //emit logString(queryString1_2_3_4_5,"queryString");
2112         if(isSystem)
2113             return oraclizeLib.oraclize_query("nested", queryString1_2_3_4_5,systemGasForOraclize);
2114         else
2115             return oraclizeLib.oraclize_query("nested", queryString1_2_3_4_5,gasForOraclize);
2116     }
2117 
2118     /*TLSNotary for oraclize call */
2119     function __callback(bytes32 myid, string result, bytes proof) public onlyOraclize {
2120         /* keep oraclize honest by retrieving the serialNumber from random.org result */
2121         proof;
2122         //emit logString(result,"result");       
2123         strings.slice memory sl_result = result.toSlice();
2124         sl_result = sl_result.beyond("[".toSlice()).until("]".toSlice());        
2125       
2126         string memory numString = sl_result.split(', '.toSlice()).toString();
2127         uint num1 = oraclizeLib.parseInt(numString);
2128         numString = sl_result.split(', '.toSlice()).toString();
2129         uint num2 = oraclizeLib.parseInt(numString);
2130         numString = sl_result.split(', '.toSlice()).toString();
2131         uint num3 = oraclizeLib.parseInt(numString);
2132         if(num1 < 1 || num1 > 6){            
2133             return;
2134         }
2135         if(num2 < 1 || num2 > 6){            
2136             return;
2137         }
2138         if(num3 < 1 || num3 > 6){            
2139             return;
2140         }        
2141         doCalculate(num1  * 100 + num2 * 10 + num3,myid);        
2142     }    
2143 }