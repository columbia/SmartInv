1 pragma solidity 0.4.20;
2 
3 // we use solidity solidity 0.4.20 to work with oraclize (http://www.oraclize.it)
4 // solidity versions > 0.4.20 are not supported by oraclize
5 
6 /*
7 Lucky Strike smart contracts version: 8.0.0
8 last change: 2019-08-05
9 */
10 
11 /*
12 This smart contract is intended for entertainment purposes only. Cryptocurrency gambling is illegal in many jurisdictions and users should consult their legal counsel regarding the legal status of cryptocurrency gambling in their jurisdictions.
13 Since developers of this smart contract are unable to determine which jurisdiction you reside in, you must check current laws including your local and state laws to find out if cryptocurrency gambling is legal in your area.
14 If you reside in a location where cryptocurrency gambling is illegal, please do not interact with this smart contract in any way and leave it  immediately.
15 */
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  * source: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
21  */
22 library SafeMath {
23 
24     /**
25     * @dev Multiplies two numbers, throws on overflow.
26     */
27     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
28         if (a == 0) {
29             return 0;
30         }
31         c = a * b;
32         assert(c / a == b);
33         return c;
34     }
35 
36     /**
37     * @dev Integer division of two numbers, truncating the quotient.
38     */
39     function div(uint256 a, uint256 b) internal pure returns (uint256) {
40         // assert(b > 0); // Solidity automatically throws when dividing by 0
41         // uint256 c = a / b;
42         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43         return a / b;
44     }
45 
46     /**
47     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
48     */
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         assert(b <= a);
51         return a - b;
52     }
53 
54     /**
55     * @dev Adds two numbers, throws on overflow.
56     */
57     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
58         c = a + b;
59         assert(c >= a);
60         return c;
61     }
62 }
63 
64 // ORACLIZE_API
65 /*
66 Copyright (c) 2015-2016 Oraclize SRL
67 Copyright (c) 2016 Oraclize LTD
68 
69 
70 
71 Permission is hereby granted, free of charge, to any person obtaining a copy
72 of this software and associated documentation files (the "Software"), to deal
73 in the Software without restriction, including without limitation the rights
74 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
75 copies of the Software, and to permit persons to whom the Software is
76 furnished to do so, subject to the following conditions:
77 
78 
79 
80 The above copyright notice and this permission notice shall be included in
81 all copies or substantial portions of the Software.
82 
83 
84 
85 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
86 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
87 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
88 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
89 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
90 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
91 THE SOFTWARE.
92 */
93 
94 //pragma solidity >=0.4.1 <=0.4.20;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
95 
96 contract OraclizeI {
97     address public cbAddress;
98 
99     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
100 
101     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
102 
103     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
104 
105     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
106 
107     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
108 
109     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
110 
111     function getPrice(string _datasource) returns (uint _dsprice);
112 
113     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
114 
115     function useCoupon(string _coupon);
116 
117     function setProofType(byte _proofType);
118 
119     function setConfig(bytes32 _config);
120 
121     function setCustomGasPrice(uint _gasPrice);
122 
123     function randomDS_getSessionPubKeyHash() returns (bytes32);
124 }
125 
126 contract OraclizeAddrResolverI {
127     function getAddress() returns (address _addr);
128 }
129 
130 /*
131 Begin solidity-cborutils
132 
133 https://github.com/smartcontractkit/solidity-cborutils
134 
135 MIT License
136 
137 Copyright (c) 2018 SmartContract ChainLink, Ltd.
138 
139 Permission is hereby granted, free of charge, to any person obtaining a copy
140 of this software and associated documentation files (the "Software"), to deal
141 in the Software without restriction, including without limitation the rights
142 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
143 copies of the Software, and to permit persons to whom the Software is
144 furnished to do so, subject to the following conditions:
145 
146 The above copyright notice and this permission notice shall be included in all
147 copies or substantial portions of the Software.
148 
149 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
150 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
151 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
152 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
153 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
154 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
155 SOFTWARE.
156  */
157 
158 library Buffer {
159     struct buffer {
160         bytes buf;
161         uint capacity;
162     }
163 
164     function init(buffer memory buf, uint capacity) internal constant {
165         if (capacity % 32 != 0) capacity += 32 - (capacity % 32);
166         // Allocate space for the buffer data
167         buf.capacity = capacity;
168         assembly {
169             let ptr := mload(0x40)
170             mstore(buf, ptr)
171             mstore(0x40, add(ptr, capacity))
172         }
173     }
174 
175     function resize(buffer memory buf, uint capacity) private constant {
176         bytes memory oldbuf = buf.buf;
177         init(buf, capacity);
178         append(buf, oldbuf);
179     }
180 
181     function max(uint a, uint b) private constant returns (uint) {
182         if (a > b) {
183             return a;
184         }
185         return b;
186     }
187 
188     /**
189      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
190      *      would exceed the capacity of the buffer.
191      * @param buf The buffer to append to.
192      * @param data The data to append.
193      * @return The original buffer.
194      */
195     function append(buffer memory buf, bytes data) internal constant returns (buffer memory) {
196         if (data.length + buf.buf.length > buf.capacity) {
197             resize(buf, max(buf.capacity, data.length) * 2);
198         }
199 
200         uint dest;
201         uint src;
202         uint len = data.length;
203         assembly {
204         // Memory address of the buffer data
205             let bufptr := mload(buf)
206         // Length of existing buffer data
207             let buflen := mload(bufptr)
208         // Start address = buffer address + buffer length + sizeof(buffer length)
209             dest := add(add(bufptr, buflen), 32)
210         // Update buffer length
211             mstore(bufptr, add(buflen, mload(data)))
212             src := add(data, 32)
213         }
214 
215         // Copy word-length chunks while possible
216         for (; len >= 32; len -= 32) {
217             assembly {
218                 mstore(dest, mload(src))
219             }
220             dest += 32;
221             src += 32;
222         }
223 
224         // Copy remaining bytes
225         uint mask = 256 ** (32 - len) - 1;
226         assembly {
227             let srcpart := and(mload(src), not(mask))
228             let destpart := and(mload(dest), mask)
229             mstore(dest, or(destpart, srcpart))
230         }
231 
232         return buf;
233     }
234 
235     /**
236      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
237      * exceed the capacity of the buffer.
238      * @param buf The buffer to append to.
239      * @param data The data to append.
240      * @return The original buffer.
241      */
242     function append(buffer memory buf, uint8 data) internal constant {
243         if (buf.buf.length + 1 > buf.capacity) {
244             resize(buf, buf.capacity * 2);
245         }
246 
247         assembly {
248         // Memory address of the buffer data
249             let bufptr := mload(buf)
250         // Length of existing buffer data
251             let buflen := mload(bufptr)
252         // Address = buffer address + buffer length + sizeof(buffer length)
253             let dest := add(add(bufptr, buflen), 32)
254             mstore8(dest, data)
255         // Update buffer length
256             mstore(bufptr, add(buflen, 1))
257         }
258     }
259 
260     /**
261      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
262      * exceed the capacity of the buffer.
263      * @param buf The buffer to append to.
264      * @param data The data to append.
265      * @return The original buffer.
266      */
267     function appendInt(buffer memory buf, uint data, uint len) internal constant returns (buffer memory) {
268         if (len + buf.buf.length > buf.capacity) {
269             resize(buf, max(buf.capacity, len) * 2);
270         }
271 
272         uint mask = 256 ** len - 1;
273         assembly {
274         // Memory address of the buffer data
275             let bufptr := mload(buf)
276         // Length of existing buffer data
277             let buflen := mload(bufptr)
278         // Address = buffer address + buffer length + sizeof(buffer length) + len
279             let dest := add(add(bufptr, buflen), len)
280             mstore(dest, or(and(mload(dest), not(mask)), data))
281         // Update buffer length
282             mstore(bufptr, add(buflen, len))
283         }
284         return buf;
285     }
286 }
287 
288 library CBOR {
289     using Buffer for Buffer.buffer;
290 
291     uint8 private constant MAJOR_TYPE_INT = 0;
292     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
293     uint8 private constant MAJOR_TYPE_BYTES = 2;
294     uint8 private constant MAJOR_TYPE_STRING = 3;
295     uint8 private constant MAJOR_TYPE_ARRAY = 4;
296     uint8 private constant MAJOR_TYPE_MAP = 5;
297     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
298 
299     function shl8(uint8 x, uint8 y) private constant returns (uint8) {
300         return x * (2 ** y);
301     }
302 
303     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private constant {
304         if (value <= 23) {
305             buf.append(uint8(shl8(major, 5) | value));
306         } else if (value <= 0xFF) {
307             buf.append(uint8(shl8(major, 5) | 24));
308             buf.appendInt(value, 1);
309         } else if (value <= 0xFFFF) {
310             buf.append(uint8(shl8(major, 5) | 25));
311             buf.appendInt(value, 2);
312         } else if (value <= 0xFFFFFFFF) {
313             buf.append(uint8(shl8(major, 5) | 26));
314             buf.appendInt(value, 4);
315         } else if (value <= 0xFFFFFFFFFFFFFFFF) {
316             buf.append(uint8(shl8(major, 5) | 27));
317             buf.appendInt(value, 8);
318         }
319     }
320 
321     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private constant {
322         buf.append(uint8(shl8(major, 5) | 31));
323     }
324 
325     function encodeUInt(Buffer.buffer memory buf, uint value) internal constant {
326         encodeType(buf, MAJOR_TYPE_INT, value);
327     }
328 
329     function encodeInt(Buffer.buffer memory buf, int value) internal constant {
330         if (value >= 0) {
331             encodeType(buf, MAJOR_TYPE_INT, uint(value));
332         } else {
333             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(- 1 - value));
334         }
335     }
336 
337     function encodeBytes(Buffer.buffer memory buf, bytes value) internal constant {
338         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
339         buf.append(value);
340     }
341 
342     function encodeString(Buffer.buffer memory buf, string value) internal constant {
343         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
344         buf.append(bytes(value));
345     }
346 
347     function startArray(Buffer.buffer memory buf) internal constant {
348         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
349     }
350 
351     function startMap(Buffer.buffer memory buf) internal constant {
352         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
353     }
354 
355     function endSequence(Buffer.buffer memory buf) internal constant {
356         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
357     }
358 }
359 
360 /*
361 End solidity-cborutils
362  */
363 
364 contract usingOraclize {
365     uint constant day = 60 * 60 * 24;
366     uint constant week = 60 * 60 * 24 * 7;
367     uint constant month = 60 * 60 * 24 * 30;
368     byte constant proofType_NONE = 0x00;
369     byte constant proofType_TLSNotary = 0x10;
370     byte constant proofType_Android = 0x20;
371     byte constant proofType_Ledger = 0x30;
372     byte constant proofType_Native = 0xF0;
373     byte constant proofStorage_IPFS = 0x01;
374     uint8 constant networkID_auto = 0;
375     uint8 constant networkID_mainnet = 1;
376     uint8 constant networkID_testnet = 2;
377     uint8 constant networkID_morden = 2;
378     uint8 constant networkID_consensys = 161;
379 
380     OraclizeAddrResolverI OAR;
381 
382     OraclizeI oraclize;
383     modifier oraclizeAPI {
384         if ((address(OAR) == 0) || (getCodeSize(address(OAR)) == 0))
385             oraclize_setNetwork(networkID_auto);
386 
387         if (address(oraclize) != OAR.getAddress())
388             oraclize = OraclizeI(OAR.getAddress());
389 
390         _;
391     }
392     modifier coupon(string code){
393         oraclize = OraclizeI(OAR.getAddress());
394         oraclize.useCoupon(code);
395         _;
396     }
397 
398     function oraclize_setNetwork(uint8 networkID) internal returns (bool){
399         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) {//mainnet
400             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
401             oraclize_setNetworkName("eth_mainnet");
402             return true;
403         }
404         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) {//ropsten testnet
405             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
406             oraclize_setNetworkName("eth_ropsten3");
407             return true;
408         }
409         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) {//kovan testnet
410             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
411             oraclize_setNetworkName("eth_kovan");
412             return true;
413         }
414         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) {//rinkeby testnet
415             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
416             oraclize_setNetworkName("eth_rinkeby");
417             return true;
418         }
419         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) {//ethereum-bridge
420             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
421             return true;
422         }
423         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) {//ether.camp ide
424             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
425             return true;
426         }
427         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) {//browser-solidity
428             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
429             return true;
430         }
431         return false;
432     }
433 
434     function __callback(bytes32 myid, string result) {
435         __callback(myid, result, new bytes(0));
436     }
437 
438     function __callback(bytes32 myid, string result, bytes proof) {
439     }
440 
441     function oraclize_useCoupon(string code) oraclizeAPI internal {
442         oraclize.useCoupon(code);
443     }
444 
445     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
446         return oraclize.getPrice(datasource);
447     }
448 
449     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
450         return oraclize.getPrice(datasource, gaslimit);
451     }
452 
453     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
454         uint price = oraclize.getPrice(datasource);
455         if (price > 1 ether + tx.gasprice * 200000) return 0;
456         // unexpectedly high price
457         return oraclize.query.value(price)(0, datasource, arg);
458     }
459 
460     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
461         uint price = oraclize.getPrice(datasource);
462         if (price > 1 ether + tx.gasprice * 200000) return 0;
463         // unexpectedly high price
464         return oraclize.query.value(price)(timestamp, datasource, arg);
465     }
466 
467     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
468         uint price = oraclize.getPrice(datasource, gaslimit);
469         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
470         // unexpectedly high price
471         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
472     }
473 
474     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
475         uint price = oraclize.getPrice(datasource, gaslimit);
476         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
477         // unexpectedly high price
478         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
479     }
480 
481     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
482         uint price = oraclize.getPrice(datasource);
483         if (price > 1 ether + tx.gasprice * 200000) return 0;
484         // unexpectedly high price
485         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
486     }
487 
488     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
489         uint price = oraclize.getPrice(datasource);
490         if (price > 1 ether + tx.gasprice * 200000) return 0;
491         // unexpectedly high price
492         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
493     }
494 
495     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
496         uint price = oraclize.getPrice(datasource, gaslimit);
497         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
498         // unexpectedly high price
499         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
500     }
501 
502     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
503         uint price = oraclize.getPrice(datasource, gaslimit);
504         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
505         // unexpectedly high price
506         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
507     }
508 
509     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
510         uint price = oraclize.getPrice(datasource);
511         if (price > 1 ether + tx.gasprice * 200000) return 0;
512         // unexpectedly high price
513         bytes memory args = stra2cbor(argN);
514         return oraclize.queryN.value(price)(0, datasource, args);
515     }
516 
517     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
518         uint price = oraclize.getPrice(datasource);
519         if (price > 1 ether + tx.gasprice * 200000) return 0;
520         // unexpectedly high price
521         bytes memory args = stra2cbor(argN);
522         return oraclize.queryN.value(price)(timestamp, datasource, args);
523     }
524 
525     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
526         uint price = oraclize.getPrice(datasource, gaslimit);
527         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
528         // unexpectedly high price
529         bytes memory args = stra2cbor(argN);
530         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
531     }
532 
533     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
534         uint price = oraclize.getPrice(datasource, gaslimit);
535         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
536         // unexpectedly high price
537         bytes memory args = stra2cbor(argN);
538         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
539     }
540 
541     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
542         string[] memory dynargs = new string[](1);
543         dynargs[0] = args[0];
544         return oraclize_query(datasource, dynargs);
545     }
546 
547     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
548         string[] memory dynargs = new string[](1);
549         dynargs[0] = args[0];
550         return oraclize_query(timestamp, datasource, dynargs);
551     }
552 
553     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
554         string[] memory dynargs = new string[](1);
555         dynargs[0] = args[0];
556         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
557     }
558 
559     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
560         string[] memory dynargs = new string[](1);
561         dynargs[0] = args[0];
562         return oraclize_query(datasource, dynargs, gaslimit);
563     }
564 
565     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
566         string[] memory dynargs = new string[](2);
567         dynargs[0] = args[0];
568         dynargs[1] = args[1];
569         return oraclize_query(datasource, dynargs);
570     }
571 
572     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
573         string[] memory dynargs = new string[](2);
574         dynargs[0] = args[0];
575         dynargs[1] = args[1];
576         return oraclize_query(timestamp, datasource, dynargs);
577     }
578 
579     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
580         string[] memory dynargs = new string[](2);
581         dynargs[0] = args[0];
582         dynargs[1] = args[1];
583         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
584     }
585 
586     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
587         string[] memory dynargs = new string[](2);
588         dynargs[0] = args[0];
589         dynargs[1] = args[1];
590         return oraclize_query(datasource, dynargs, gaslimit);
591     }
592 
593     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
594         string[] memory dynargs = new string[](3);
595         dynargs[0] = args[0];
596         dynargs[1] = args[1];
597         dynargs[2] = args[2];
598         return oraclize_query(datasource, dynargs);
599     }
600 
601     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
602         string[] memory dynargs = new string[](3);
603         dynargs[0] = args[0];
604         dynargs[1] = args[1];
605         dynargs[2] = args[2];
606         return oraclize_query(timestamp, datasource, dynargs);
607     }
608 
609     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
610         string[] memory dynargs = new string[](3);
611         dynargs[0] = args[0];
612         dynargs[1] = args[1];
613         dynargs[2] = args[2];
614         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
615     }
616 
617     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
618         string[] memory dynargs = new string[](3);
619         dynargs[0] = args[0];
620         dynargs[1] = args[1];
621         dynargs[2] = args[2];
622         return oraclize_query(datasource, dynargs, gaslimit);
623     }
624 
625     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
626         string[] memory dynargs = new string[](4);
627         dynargs[0] = args[0];
628         dynargs[1] = args[1];
629         dynargs[2] = args[2];
630         dynargs[3] = args[3];
631         return oraclize_query(datasource, dynargs);
632     }
633 
634     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
635         string[] memory dynargs = new string[](4);
636         dynargs[0] = args[0];
637         dynargs[1] = args[1];
638         dynargs[2] = args[2];
639         dynargs[3] = args[3];
640         return oraclize_query(timestamp, datasource, dynargs);
641     }
642 
643     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
644         string[] memory dynargs = new string[](4);
645         dynargs[0] = args[0];
646         dynargs[1] = args[1];
647         dynargs[2] = args[2];
648         dynargs[3] = args[3];
649         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
650     }
651 
652     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
653         string[] memory dynargs = new string[](4);
654         dynargs[0] = args[0];
655         dynargs[1] = args[1];
656         dynargs[2] = args[2];
657         dynargs[3] = args[3];
658         return oraclize_query(datasource, dynargs, gaslimit);
659     }
660 
661     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
662         string[] memory dynargs = new string[](5);
663         dynargs[0] = args[0];
664         dynargs[1] = args[1];
665         dynargs[2] = args[2];
666         dynargs[3] = args[3];
667         dynargs[4] = args[4];
668         return oraclize_query(datasource, dynargs);
669     }
670 
671     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
672         string[] memory dynargs = new string[](5);
673         dynargs[0] = args[0];
674         dynargs[1] = args[1];
675         dynargs[2] = args[2];
676         dynargs[3] = args[3];
677         dynargs[4] = args[4];
678         return oraclize_query(timestamp, datasource, dynargs);
679     }
680 
681     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
682         string[] memory dynargs = new string[](5);
683         dynargs[0] = args[0];
684         dynargs[1] = args[1];
685         dynargs[2] = args[2];
686         dynargs[3] = args[3];
687         dynargs[4] = args[4];
688         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
689     }
690 
691     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
692         string[] memory dynargs = new string[](5);
693         dynargs[0] = args[0];
694         dynargs[1] = args[1];
695         dynargs[2] = args[2];
696         dynargs[3] = args[3];
697         dynargs[4] = args[4];
698         return oraclize_query(datasource, dynargs, gaslimit);
699     }
700 
701     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
702         uint price = oraclize.getPrice(datasource);
703         if (price > 1 ether + tx.gasprice * 200000) return 0;
704         // unexpectedly high price
705         bytes memory args = ba2cbor(argN);
706         return oraclize.queryN.value(price)(0, datasource, args);
707     }
708 
709     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
710         uint price = oraclize.getPrice(datasource);
711         if (price > 1 ether + tx.gasprice * 200000) return 0;
712         // unexpectedly high price
713         bytes memory args = ba2cbor(argN);
714         return oraclize.queryN.value(price)(timestamp, datasource, args);
715     }
716 
717     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
718         uint price = oraclize.getPrice(datasource, gaslimit);
719         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
720         // unexpectedly high price
721         bytes memory args = ba2cbor(argN);
722         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
723     }
724 
725     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
726         uint price = oraclize.getPrice(datasource, gaslimit);
727         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
728         // unexpectedly high price
729         bytes memory args = ba2cbor(argN);
730         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
731     }
732 
733     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
734         bytes[] memory dynargs = new bytes[](1);
735         dynargs[0] = args[0];
736         return oraclize_query(datasource, dynargs);
737     }
738 
739     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
740         bytes[] memory dynargs = new bytes[](1);
741         dynargs[0] = args[0];
742         return oraclize_query(timestamp, datasource, dynargs);
743     }
744 
745     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
746         bytes[] memory dynargs = new bytes[](1);
747         dynargs[0] = args[0];
748         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
749     }
750 
751     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
752         bytes[] memory dynargs = new bytes[](1);
753         dynargs[0] = args[0];
754         return oraclize_query(datasource, dynargs, gaslimit);
755     }
756 
757     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
758         bytes[] memory dynargs = new bytes[](2);
759         dynargs[0] = args[0];
760         dynargs[1] = args[1];
761         return oraclize_query(datasource, dynargs);
762     }
763 
764     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
765         bytes[] memory dynargs = new bytes[](2);
766         dynargs[0] = args[0];
767         dynargs[1] = args[1];
768         return oraclize_query(timestamp, datasource, dynargs);
769     }
770 
771     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
772         bytes[] memory dynargs = new bytes[](2);
773         dynargs[0] = args[0];
774         dynargs[1] = args[1];
775         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
776     }
777 
778     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
779         bytes[] memory dynargs = new bytes[](2);
780         dynargs[0] = args[0];
781         dynargs[1] = args[1];
782         return oraclize_query(datasource, dynargs, gaslimit);
783     }
784 
785     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
786         bytes[] memory dynargs = new bytes[](3);
787         dynargs[0] = args[0];
788         dynargs[1] = args[1];
789         dynargs[2] = args[2];
790         return oraclize_query(datasource, dynargs);
791     }
792 
793     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
794         bytes[] memory dynargs = new bytes[](3);
795         dynargs[0] = args[0];
796         dynargs[1] = args[1];
797         dynargs[2] = args[2];
798         return oraclize_query(timestamp, datasource, dynargs);
799     }
800 
801     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
802         bytes[] memory dynargs = new bytes[](3);
803         dynargs[0] = args[0];
804         dynargs[1] = args[1];
805         dynargs[2] = args[2];
806         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
807     }
808 
809     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
810         bytes[] memory dynargs = new bytes[](3);
811         dynargs[0] = args[0];
812         dynargs[1] = args[1];
813         dynargs[2] = args[2];
814         return oraclize_query(datasource, dynargs, gaslimit);
815     }
816 
817     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
818         bytes[] memory dynargs = new bytes[](4);
819         dynargs[0] = args[0];
820         dynargs[1] = args[1];
821         dynargs[2] = args[2];
822         dynargs[3] = args[3];
823         return oraclize_query(datasource, dynargs);
824     }
825 
826     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
827         bytes[] memory dynargs = new bytes[](4);
828         dynargs[0] = args[0];
829         dynargs[1] = args[1];
830         dynargs[2] = args[2];
831         dynargs[3] = args[3];
832         return oraclize_query(timestamp, datasource, dynargs);
833     }
834 
835     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
836         bytes[] memory dynargs = new bytes[](4);
837         dynargs[0] = args[0];
838         dynargs[1] = args[1];
839         dynargs[2] = args[2];
840         dynargs[3] = args[3];
841         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
842     }
843 
844     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
845         bytes[] memory dynargs = new bytes[](4);
846         dynargs[0] = args[0];
847         dynargs[1] = args[1];
848         dynargs[2] = args[2];
849         dynargs[3] = args[3];
850         return oraclize_query(datasource, dynargs, gaslimit);
851     }
852 
853     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
854         bytes[] memory dynargs = new bytes[](5);
855         dynargs[0] = args[0];
856         dynargs[1] = args[1];
857         dynargs[2] = args[2];
858         dynargs[3] = args[3];
859         dynargs[4] = args[4];
860         return oraclize_query(datasource, dynargs);
861     }
862 
863     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
864         bytes[] memory dynargs = new bytes[](5);
865         dynargs[0] = args[0];
866         dynargs[1] = args[1];
867         dynargs[2] = args[2];
868         dynargs[3] = args[3];
869         dynargs[4] = args[4];
870         return oraclize_query(timestamp, datasource, dynargs);
871     }
872 
873     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
874         bytes[] memory dynargs = new bytes[](5);
875         dynargs[0] = args[0];
876         dynargs[1] = args[1];
877         dynargs[2] = args[2];
878         dynargs[3] = args[3];
879         dynargs[4] = args[4];
880         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
881     }
882 
883     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
884         bytes[] memory dynargs = new bytes[](5);
885         dynargs[0] = args[0];
886         dynargs[1] = args[1];
887         dynargs[2] = args[2];
888         dynargs[3] = args[3];
889         dynargs[4] = args[4];
890         return oraclize_query(datasource, dynargs, gaslimit);
891     }
892 
893     function oraclize_cbAddress() oraclizeAPI internal returns (address){
894         return oraclize.cbAddress();
895     }
896 
897     function oraclize_setProof(byte proofP) oraclizeAPI internal {
898         return oraclize.setProofType(proofP);
899     }
900 
901     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
902         return oraclize.setCustomGasPrice(gasPrice);
903     }
904 
905     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
906         return oraclize.setConfig(config);
907     }
908 
909     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
910         return oraclize.randomDS_getSessionPubKeyHash();
911     }
912 
913     function getCodeSize(address _addr) constant internal returns (uint _size) {
914         assembly {
915             _size := extcodesize(_addr)
916         }
917     }
918 
919     function parseAddr(string _a) internal returns (address){
920         bytes memory tmp = bytes(_a);
921         uint160 iaddr = 0;
922         uint160 b1;
923         uint160 b2;
924         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
925             iaddr *= 256;
926             b1 = uint160(tmp[i]);
927             b2 = uint160(tmp[i + 1]);
928             if ((b1 >= 97) && (b1 <= 102)) b1 -= 87;
929             else if ((b1 >= 65) && (b1 <= 70)) b1 -= 55;
930             else if ((b1 >= 48) && (b1 <= 57)) b1 -= 48;
931             if ((b2 >= 97) && (b2 <= 102)) b2 -= 87;
932             else if ((b2 >= 65) && (b2 <= 70)) b2 -= 55;
933             else if ((b2 >= 48) && (b2 <= 57)) b2 -= 48;
934             iaddr += (b1 * 16 + b2);
935         }
936         return address(iaddr);
937     }
938 
939     function strCompare(string _a, string _b) internal returns (int) {
940         bytes memory a = bytes(_a);
941         bytes memory b = bytes(_b);
942         uint minLength = a.length;
943         if (b.length < minLength) minLength = b.length;
944         for (uint i = 0; i < minLength; i ++)
945             if (a[i] < b[i])
946                 return - 1;
947             else if (a[i] > b[i])
948                 return 1;
949         if (a.length < b.length)
950             return - 1;
951         else if (a.length > b.length)
952             return 1;
953         else
954             return 0;
955     }
956 
957     function indexOf(string _haystack, string _needle) internal returns (int) {
958         bytes memory h = bytes(_haystack);
959         bytes memory n = bytes(_needle);
960         if (h.length < 1 || n.length < 1 || (n.length > h.length))
961             return - 1;
962         else if (h.length > (2 ** 128 - 1))
963             return - 1;
964         else
965         {
966             uint subindex = 0;
967             for (uint i = 0; i < h.length; i ++)
968             {
969                 if (h[i] == n[0])
970                 {
971                     subindex = 1;
972                     while (subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
973                     {
974                         subindex++;
975                     }
976                     if (subindex == n.length)
977                         return int(i);
978                 }
979             }
980             return - 1;
981         }
982     }
983 
984     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
985         bytes memory _ba = bytes(_a);
986         bytes memory _bb = bytes(_b);
987         bytes memory _bc = bytes(_c);
988         bytes memory _bd = bytes(_d);
989         bytes memory _be = bytes(_e);
990         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
991         bytes memory babcde = bytes(abcde);
992         uint k = 0;
993         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
994         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
995         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
996         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
997         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
998         return string(babcde);
999     }
1000 
1001     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
1002         return strConcat(_a, _b, _c, _d, "");
1003     }
1004 
1005     function strConcat(string _a, string _b, string _c) internal returns (string) {
1006         return strConcat(_a, _b, _c, "", "");
1007     }
1008 
1009     function strConcat(string _a, string _b) internal returns (string) {
1010         return strConcat(_a, _b, "", "", "");
1011     }
1012 
1013     // parseInt
1014     function parseInt(string _a) internal returns (uint) {
1015         return parseInt(_a, 0);
1016     }
1017 
1018     // parseInt(parseFloat*10^_b)
1019     function parseInt(string _a, uint _b) internal returns (uint) {
1020         bytes memory bresult = bytes(_a);
1021         uint mint = 0;
1022         bool decimals = false;
1023         for (uint i = 0; i < bresult.length; i++) {
1024             if ((bresult[i] >= 48) && (bresult[i] <= 57)) {
1025                 if (decimals) {
1026                     if (_b == 0) break;
1027                     else _b--;
1028                 }
1029                 mint *= 10;
1030                 mint += uint(bresult[i]) - 48;
1031             } else if (bresult[i] == 46) decimals = true;
1032         }
1033         if (_b > 0) mint *= 10 ** _b;
1034         return mint;
1035     }
1036 
1037     function uint2str(uint i) internal returns (string){
1038         if (i == 0) return "0";
1039         uint j = i;
1040         uint len;
1041         while (j != 0) {
1042             len++;
1043             j /= 10;
1044         }
1045         bytes memory bstr = new bytes(len);
1046         uint k = len - 1;
1047         while (i != 0) {
1048             bstr[k--] = byte(48 + i % 10);
1049             i /= 10;
1050         }
1051         return string(bstr);
1052     }
1053 
1054     using CBOR for Buffer.buffer;
1055     function stra2cbor(string[] arr) internal constant returns (bytes) {
1056         Buffer.buffer memory buf;
1057         Buffer.init(buf, 1024);
1058         buf.startArray();
1059         for (uint i = 0; i < arr.length; i++) {
1060             buf.encodeString(arr[i]);
1061         }
1062         buf.endSequence();
1063         return buf.buf;
1064     }
1065 
1066     function ba2cbor(bytes[] arr) internal constant returns (bytes) {
1067         Buffer.buffer memory buf;
1068         Buffer.init(buf, 1024);
1069         buf.startArray();
1070         for (uint i = 0; i < arr.length; i++) {
1071             buf.encodeBytes(arr[i]);
1072         }
1073         buf.endSequence();
1074         return buf.buf;
1075     }
1076 
1077     string oraclize_network_name;
1078 
1079     function oraclize_setNetworkName(string _network_name) internal {
1080         oraclize_network_name = _network_name;
1081     }
1082 
1083     function oraclize_getNetworkName() internal returns (string) {
1084         return oraclize_network_name;
1085     }
1086 
1087     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1088         if ((_nbytes == 0) || (_nbytes > 32)) throw;
1089         // Convert from seconds to ledger timer ticks
1090         _delay *= 10;
1091         bytes memory nbytes = new bytes(1);
1092         nbytes[0] = byte(_nbytes);
1093         bytes memory unonce = new bytes(32);
1094         bytes memory sessionKeyHash = new bytes(32);
1095         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1096         assembly {
1097             mstore(unonce, 0x20)
1098             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1099             mstore(sessionKeyHash, 0x20)
1100             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1101         }
1102         bytes memory delay = new bytes(32);
1103         assembly {
1104             mstore(add(delay, 0x20), _delay)
1105         }
1106 
1107         bytes memory delay_bytes8 = new bytes(8);
1108         copyBytes(delay, 24, 8, delay_bytes8, 0);
1109 
1110         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1111         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1112 
1113         bytes memory delay_bytes8_left = new bytes(8);
1114 
1115         assembly {
1116             let x := mload(add(delay_bytes8, 0x20))
1117             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1118             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1119             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1120             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1121             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1122             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1123             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1124             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1125 
1126         }
1127 
1128         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1129         return queryId;
1130     }
1131 
1132     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1133         oraclize_randomDS_args[queryId] = commitment;
1134     }
1135 
1136     mapping(bytes32 => bytes32) oraclize_randomDS_args;
1137     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
1138 
1139     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1140         bool sigok;
1141         address signer;
1142 
1143         bytes32 sigr;
1144         bytes32 sigs;
1145 
1146         bytes memory sigr_ = new bytes(32);
1147         uint offset = 4 + (uint(dersig[3]) - 0x20);
1148         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1149         bytes memory sigs_ = new bytes(32);
1150         offset += 32 + 2;
1151         sigs_ = copyBytes(dersig, offset + (uint(dersig[offset - 1]) - 0x20), 32, sigs_, 0);
1152 
1153         assembly {
1154             sigr := mload(add(sigr_, 32))
1155             sigs := mload(add(sigs_, 32))
1156         }
1157 
1158 
1159         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1160         if (address(sha3(pubkey)) == signer) return true;
1161         else {
1162             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1163             return (address(sha3(pubkey)) == signer);
1164         }
1165     }
1166 
1167     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1168         bool sigok;
1169 
1170         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1171         bytes memory sig2 = new bytes(uint(proof[sig2offset + 1]) + 2);
1172         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1173 
1174         bytes memory appkey1_pubkey = new bytes(64);
1175         copyBytes(proof, 3 + 1, 64, appkey1_pubkey, 0);
1176 
1177         bytes memory tosign2 = new bytes(1 + 65 + 32);
1178         tosign2[0] = 1;
1179         //role
1180         copyBytes(proof, sig2offset - 65, 65, tosign2, 1);
1181         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1182         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1183         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1184 
1185         if (sigok == false) return false;
1186 
1187 
1188         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1189         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1190 
1191         bytes memory tosign3 = new bytes(1 + 65);
1192         tosign3[0] = 0xFE;
1193         copyBytes(proof, 3, 65, tosign3, 1);
1194 
1195         bytes memory sig3 = new bytes(uint(proof[3 + 65 + 1]) + 2);
1196         copyBytes(proof, 3 + 65, sig3.length, sig3, 0);
1197 
1198         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1199 
1200         return sigok;
1201     }
1202 
1203     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1204         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1205         if ((_proof[0] != "L") || (_proof[1] != "P") || (_proof[2] != 1)) throw;
1206 
1207         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1208         if (proofVerified == false) throw;
1209 
1210         _;
1211     }
1212 
1213     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1214         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1215         if ((_proof[0] != "L") || (_proof[1] != "P") || (_proof[2] != 1)) return 1;
1216 
1217         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1218         if (proofVerified == false) return 2;
1219 
1220         return 0;
1221     }
1222 
1223     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
1224         bool match_ = true;
1225 
1226         if (prefix.length != n_random_bytes) throw;
1227 
1228         for (uint256 i = 0; i < n_random_bytes; i++) {
1229             if (content[i] != prefix[i]) match_ = false;
1230         }
1231 
1232         return match_;
1233     }
1234 
1235     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1236 
1237         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1238         uint ledgerProofLength = 3 + 65 + (uint(proof[3 + 65 + 1]) + 2) + 32;
1239         bytes memory keyhash = new bytes(32);
1240         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1241         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
1242 
1243         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1]) + 2);
1244         copyBytes(proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1245 
1246         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1247         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength + 32 + 8]))) return false;
1248 
1249         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1250         // This is to verify that the computed args match with the ones specified in the query.
1251         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1252         copyBytes(proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1253 
1254         bytes memory sessionPubkey = new bytes(64);
1255         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1256         copyBytes(proof, sig2offset - 64, 64, sessionPubkey, 0);
1257 
1258         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1259         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)) {//unonce, nbytes and sessionKeyHash match
1260             delete oraclize_randomDS_args[queryId];
1261         } else return false;
1262 
1263 
1264         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1265         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1266         copyBytes(proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1267         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1268 
1269         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1270         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false) {
1271             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1272         }
1273 
1274         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1275     }
1276 
1277 
1278     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1279     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1280         uint minLength = length + toOffset;
1281 
1282         if (to.length < minLength) {
1283             // Buffer too small
1284             throw;
1285             // Should be a better way?
1286         }
1287 
1288         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1289         uint i = 32 + fromOffset;
1290         uint j = 32 + toOffset;
1291 
1292         while (i < (32 + fromOffset + length)) {
1293             assembly {
1294                 let tmp := mload(add(from, i))
1295                 mstore(add(to, j), tmp)
1296             }
1297             i += 32;
1298             j += 32;
1299         }
1300 
1301         return to;
1302     }
1303 
1304     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1305     // Duplicate Solidity's ecrecover, but catching the CALL return value
1306     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1307         // We do our own memory management here. Solidity uses memory offset
1308         // 0x40 to store the current end of memory. We write past it (as
1309         // writes are memory extensions), but don't update the offset so
1310         // Solidity will reuse it. The memory used here is only needed for
1311         // this context.
1312 
1313         // FIXME: inline assembly can't access return values
1314         bool ret;
1315         address addr;
1316 
1317         assembly {
1318             let size := mload(0x40)
1319             mstore(size, hash)
1320             mstore(add(size, 32), v)
1321             mstore(add(size, 64), r)
1322             mstore(add(size, 96), s)
1323 
1324         // NOTE: we can reuse the request memory because we deal with
1325         //       the return code
1326             ret := call(3000, 1, 0, size, 128, size, 32)
1327             addr := mload(size)
1328         }
1329 
1330         return (ret, addr);
1331     }
1332 
1333     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1334     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1335         bytes32 r;
1336         bytes32 s;
1337         uint8 v;
1338 
1339         if (sig.length != 65)
1340             return (false, 0);
1341 
1342         // The signature format is a compact form of:
1343         //   {bytes32 r}{bytes32 s}{uint8 v}
1344         // Compact means, uint8 is not padded to 32 bytes.
1345         assembly {
1346             r := mload(add(sig, 32))
1347             s := mload(add(sig, 64))
1348 
1349         // Here we are loading the last 32 bytes. We exploit the fact that
1350         // 'mload' will pad with zeroes if we overread.
1351         // There is no 'mload8' to do this, but that would be nicer.
1352             v := byte(0, mload(add(sig, 96)))
1353 
1354         // Alternative solution:
1355         // 'byte' is not working due to the Solidity parser, so lets
1356         // use the second best option, 'and'
1357         // v := and(mload(add(sig, 65)), 255)
1358         }
1359 
1360         // albeit non-transactional signatures are not specified by the YP, one would expect it
1361         // to match the YP range of [27, 28]
1362         //
1363         // geth uses [0, 1] and some clients have followed. This might change, see:
1364         //  https://github.com/ethereum/go-ethereum/issues/2053
1365         if (v < 27)
1366             v += 27;
1367 
1368         if (v != 27 && v != 28)
1369             return (false, 0);
1370 
1371         return safer_ecrecover(hash, v, r, s);
1372     }
1373 
1374 }
1375 // end of ORACLIZE_API
1376 
1377 // =============== Lucky Strike ========================================================================================
1378 
1379 contract LuckyStrikeTokens {
1380 
1381     function totalSupply() constant returns (uint256);
1382 
1383     function balanceOf(address _owner) constant returns (uint256);
1384 
1385     function mint(address to, uint256 value, uint256 _invest) public returns (bool);
1386 
1387     function tokenSaleIsRunning() public returns (bool);
1388 
1389     function transferIncome() public payable;
1390 }
1391 
1392 contract LuckyStrike is usingOraclize {
1393 
1394     /* --- see: https://github.com/oraclize/ethereum-examples/blob/master/solidity/random-datasource/randomExample.sol */
1395 
1396     // see: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
1397     using SafeMath for uint256;
1398     using SafeMath for uint16;
1399 
1400     address public owner;
1401     address admin;
1402     // TODO: change in production <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
1403     //    uint256 public ticketPriceInWei = 200000000000000; // (0.02 ETH / 100)
1404     //    uint256 public tokenPriceInWei = 1500000000000; //    (0.00015 ETH / 100)
1405     uint256 public ticketPriceInWei = 20000000000000000; // 0.02 ETH
1406     uint256 public tokenPriceInWei = 150000000000000; //    0.00015 ETH
1407     // TODO: end change in production <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
1408 
1409     // prevents 'out of gas'
1410     // number 333 is a result of manual testing
1411     uint16 public maxTicketsToBuyInOneTransaction = 333; //
1412 
1413     uint256 public eventsCounter;
1414     //
1415     mapping(uint256 => address) public theLotteryTicket;
1416     mapping(address => uint256) public playerTicketsTotal;
1417     uint256 public ticketsTotal;
1418     //
1419     address public kingOfTheHill;
1420     uint256 public kingOfTheHillTicketsNumber;
1421 
1422     mapping(address => uint256) public reward;
1423 
1424     event rewardPaid(uint256 indexed eventsCounter, address indexed to, uint256 sum); //
1425     function getReward() public {
1426         require(reward[msg.sender] > 0);
1427         msg.sender.transfer(reward[msg.sender]);
1428 
1429         eventsCounter = eventsCounter + 1;
1430         rewardPaid(eventsCounter, msg.sender, reward[msg.sender]);
1431         sum[affiliateRewards] = sum[affiliateRewards].sub(reward[msg.sender]);
1432         reward[msg.sender] = 0;
1433     }
1434 
1435     // gas for oraclize_query:
1436     uint256 public oraclizeCallbackGas = 1000000; // amount of gas we want Oraclize to set for the callback function
1437     function changeOraclizeCallbackGas(uint _oraclizeCallbackGas) returns (bool result){
1438         require(msg.sender == owner);
1439         oraclizeCallbackGas = _oraclizeCallbackGas;
1440         return true;
1441     }
1442 
1443     // > to be able to read it from browser after updating
1444     uint256 public currentOraclizeGasPrice; //
1445     function oraclizeGetPrice() public returns (uint256){
1446         currentOraclizeGasPrice = oraclize_getPrice("random", oraclizeCallbackGas);
1447         return currentOraclizeGasPrice;
1448     }
1449 
1450     function getContractsWeiBalance() public view returns (uint256) {
1451         return this.balance;
1452     }
1453 
1454     // mapping to keep sums on accounts (including 'income'):
1455     mapping(uint8 => uint256) public sum;
1456     uint8 public instantGame = 0;
1457     uint8 public dailyJackpot = 1;
1458     uint8 public weeklyJackpot = 2;
1459     uint8 public monthlyJackpot = 3;
1460     uint8 public yearlyJackpot = 4;
1461     uint8 public income = 5;
1462     uint8 public marketingFund = 6;
1463     uint8 public affiliateRewards = 7; //
1464     uint8 public playersBets = 8;
1465 
1466     mapping(uint8 => uint256) public period; // in seconds
1467 
1468     event withdrawalFromMarketingFund(uint256 indexed eventsCounter, uint256 sum); //
1469     function withdrawFromMarketingFund() public {
1470         require(msg.sender == owner);
1471         owner.transfer(sum[marketingFund]);
1472 
1473         eventsCounter = eventsCounter + 1;
1474         withdrawalFromMarketingFund(eventsCounter, sum[marketingFund]);
1475 
1476         sum[marketingFund] = 0;
1477     }
1478 
1479     mapping(uint8 => bool) public jackpotPlayIsRunning; //
1480 
1481     /*
1482     * contains number of block in which jackpot play was started last time;
1483     */
1484     mapping(uint8 => uint256) public jackpotPlayLastTimeStartedFromBlock;
1485 
1486     // new in ver. 7.1.0.
1487     mapping(uint8 => address) public lastJackpotWinnerAddress;
1488     mapping(uint8 => uint256) public lastJackpotSumWon;
1489 
1490     // new in ver. 7.1.0
1491     event JackpotWithdrawal(
1492         uint256 indexed eventsCounter,
1493         uint8 indexed jackpotType,
1494         uint256 sum,
1495         address to
1496     );
1497 
1498     // new in ver. 7.1.0
1499     function withdrawJackpotPrize(uint8 _jackpotType) public {
1500 
1501         require(msg.sender == lastJackpotWinnerAddress[_jackpotType]);
1502 
1503         require(lastJackpotSumWon[_jackpotType] > 0);
1504 
1505         msg.sender.transfer(lastJackpotSumWon[_jackpotType]);
1506 
1507         eventsCounter = eventsCounter + 1;
1508         JackpotWithdrawal(eventsCounter, _jackpotType, lastJackpotSumWon[_jackpotType], msg.sender);
1509 
1510         // changed in ver. 8.0.0 > set to zero _after_ emitting an event
1511         lastJackpotSumWon[_jackpotType] = 0;
1512     }
1513 
1514     // allocation:
1515     mapping(uint8 => uint16) public rate;
1516 
1517     // JackpotCounters (starts with 0):
1518     mapping(uint8 => uint256) jackpotCounter;
1519     mapping(uint8 => uint256) public lastJackpotTime;  // unix time
1520 
1521     address public luckyStrikeTokensContractAddress;
1522 
1523     LuckyStrikeTokens public luckyStrikeTokens;
1524 
1525     /* --- constructor */
1526 
1527     // (!) requires access to Oraclize contract
1528     // will fail on JavaScript VM
1529     function LuckyStrike() public {
1530 
1531         admin = msg.sender;
1532 
1533         // sets the Ledger authenticity proof in the constructor
1534         oraclize_setProof(proofType_Ledger);
1535 
1536     }
1537 
1538     function init(address _luckyStrikeTokensContractAddress) public payable {
1539 
1540         require(ticketsTotal == 0);
1541         require(_luckyStrikeTokensContractAddress != address(0));
1542         require(msg.sender == admin);
1543 
1544         owner = 0x0bBAb60c495413c870F8cABF09436BeE9fe3542F;
1545 
1546         require(msg.value / ticketPriceInWei >= 1);
1547 
1548         luckyStrikeTokensContractAddress = _luckyStrikeTokensContractAddress;
1549 
1550         // should be updated every time we use it
1551         // now we just get value to show in webapp
1552         oraclizeGetPrice();
1553 
1554         kingOfTheHill = msg.sender;
1555         ticketsTotal = kingOfTheHillTicketsNumber = 1;
1556         theLotteryTicket[1] = kingOfTheHill;
1557 
1558         // initialize jackpot periods
1559         // see: https://solidity.readthedocs.io/en/v0.4.20/units-and-global-variables.html#time-units
1560         period[dailyJackpot] = 1 days;
1561         period[weeklyJackpot] = 1 weeks;
1562         period[monthlyJackpot] = 30 days;
1563         period[yearlyJackpot] = 1 years;
1564 
1565         // for testing: TODO change dev mode to production mode<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
1566         //        period[dailyJackpot] = 60 * 1;
1567         //        period[weeklyJackpot] = 60 * 3;
1568         //        period[monthlyJackpot] = 60 * 5;
1569         //        period[yearlyJackpot] = 60 * 7;
1570 
1571         // set last block numbers and timestamps for jackpots:
1572         for (uint8 i = dailyJackpot; i <= yearlyJackpot; i++) {
1573             lastJackpotTime[i] = block.timestamp;
1574         }
1575 
1576         rate[instantGame] = 8500;
1577         rate[dailyJackpot] = 500;
1578         rate[weeklyJackpot] = 300;
1579         rate[monthlyJackpot] = 100;
1580         rate[yearlyJackpot] = 100;
1581         rate[income] = 500;
1582 
1583         luckyStrikeTokens = LuckyStrikeTokens(luckyStrikeTokensContractAddress);
1584 
1585     }
1586 
1587     /* --- Tokens contract information   */
1588     function tokensTotalSupply() public view returns (uint256) {
1589         return luckyStrikeTokens.totalSupply();
1590     }
1591 
1592     function tokensBalanceOf(address acc) public view returns (uint256){
1593         return luckyStrikeTokens.balanceOf(acc);
1594     }
1595 
1596     function weiInTokensContract() public view returns (uint256){
1597         return luckyStrikeTokens.balance;
1598     }
1599 
1600     function tokenSaleIsRunning() public view returns (bool) {
1601         return luckyStrikeTokens.tokenSaleIsRunning();
1602     }
1603 
1604     event AllocationAdjusted(
1605         uint256 indexed eventsCounter,
1606         address by,
1607         uint16 instantGame,
1608         uint16 dailyJackpot,
1609         uint16 weeklyJackpot,
1610         uint16 monthlyJackpot,
1611         uint16 yearlyJackpot,
1612         uint16 income);
1613 
1614     function adjustAllocation(
1615         uint16 _instantGame,
1616         uint16 _dailyJackpot,
1617         uint16 _weeklyJackpot,
1618         uint16 _monthlyJackpot,
1619         uint16 _yearlyJackpot,
1620         uint16 _income) public {
1621 
1622         // only owner !!!
1623         require(msg.sender == owner);
1624 
1625         rate[instantGame] = _instantGame;
1626         rate[dailyJackpot] = _dailyJackpot;
1627         rate[weeklyJackpot] = _weeklyJackpot;
1628         rate[monthlyJackpot] = _monthlyJackpot;
1629         rate[yearlyJackpot] = _yearlyJackpot;
1630         rate[income] = _income;
1631 
1632         // check if provided %% amount to 10,000
1633         uint16 _sum = 0;
1634         for (uint8 i = instantGame; i <= income; i++) {
1635             _sum = _sum + rate[i];
1636         }
1637 
1638         require(_sum == 10000);
1639 
1640         eventsCounter = eventsCounter + 1;
1641         AllocationAdjusted(
1642             eventsCounter,
1643             msg.sender,
1644             rate[instantGame],
1645             rate[dailyJackpot],
1646             rate[weeklyJackpot],
1647             rate[monthlyJackpot],
1648             rate[yearlyJackpot],
1649             rate[income]
1650         );
1651 
1652     } // end of adjustAllocation
1653 
1654     // this function calculates jackpots/income allocation and returns prize for the instant game
1655     uint256 sumAllocatedInWeiCounter;
1656 
1657     event SumAllocatedInWei(
1658         uint256 indexed eventsCounter,
1659         uint256 indexed sumAllocatedInWeiCounter,
1660         address betOf,
1661         uint256 bet, // 0
1662         uint256 dailyJackpot, // 1
1663         uint256 weeklyJackpot, // 2;
1664         uint256 monthlyJackpot, // 3;
1665         uint256 yearlyJackpot, // 4;
1666         uint256 income,
1667         uint256 affiliateRewards,
1668         uint256 payToWinner,
1669         bool sumValidationPassed
1670     );
1671 
1672     function allocateSum(uint256 _sum, address loser) private returns (uint256) {
1673 
1674         // for event
1675         // https://solidity.readthedocs.io/en/v0.4.24/types.html#allocating-memory-arrays
1676         uint256[] memory jackpotsSumAllocation = new uint256[](5);
1677 
1678         // jackpots:
1679         for (uint8 i = dailyJackpot; i <= yearlyJackpot; i++) {
1680             // uint256 sumToAdd = _sum * rate[i] / 10000;
1681             uint256 sumToAdd = _sum.mul(rate[i]).div(10000);
1682             sum[i] = sum[i].add(sumToAdd);
1683             // for event:
1684             jackpotsSumAllocation[i] = sumToAdd;
1685         }
1686 
1687         // income before affiliate reward subtraction:
1688         // uint256 incomeSum = (_sum * rate[income]) / 10000;
1689         uint256 incomeSum = _sum.mul(rate[income]).div(10000);
1690         // referrer reward:
1691         uint256 refSum = 0;
1692         if (referrer[loser] != address(0)) {
1693 
1694             address referrerAddress = referrer[loser];
1695 
1696             refSum = incomeSum / 2;
1697             incomeSum = incomeSum.sub(refSum);
1698 
1699             reward[referrerAddress] = reward[referrerAddress].add(refSum);
1700 
1701             sum[affiliateRewards] = sum[affiliateRewards].add(refSum);
1702         }
1703 
1704         sum[income] = sum[income].add(incomeSum);
1705 
1706         // uint256 payToWinner = _sum * rate[instantGame] / 10000;
1707         uint256 payToWinner = _sum.mul(rate[instantGame]).div(10000);
1708 
1709         bool sumValidationPassed = false;
1710         if (
1711             (jackpotsSumAllocation[1] +
1712             jackpotsSumAllocation[2] +
1713             jackpotsSumAllocation[3] +
1714             jackpotsSumAllocation[4] +
1715             incomeSum +
1716             refSum +
1717             payToWinner) == _sum) {
1718             sumValidationPassed = true;
1719         }
1720 
1721         eventsCounter = eventsCounter + 1;
1722         sumAllocatedInWeiCounter = sumAllocatedInWeiCounter + 1;
1723         SumAllocatedInWei(
1724             eventsCounter,
1725             sumAllocatedInWeiCounter,
1726             loser,
1727             _sum,
1728             jackpotsSumAllocation[1], //  dailyJackpot
1729             jackpotsSumAllocation[2], // weeklyJackpot
1730             jackpotsSumAllocation[3], // monthlyJackpot
1731             jackpotsSumAllocation[4], //  yearlyJackpot
1732             incomeSum,
1733             refSum,
1734             payToWinner,
1735             sumValidationPassed
1736         );
1737 
1738         return payToWinner;
1739     }
1740 
1741     /* -------------- GAME: --------------*/
1742 
1743     /* --- Instant Game ------- */
1744     uint256 public instantGameCounter; // id's of instant games
1745     //
1746     // to allow only one game for the given address simultaneously:
1747     mapping(address => bool) public instantGameIsRunning;
1748     //
1749     mapping(address => uint256) public lastInstantGameBlockNumber; // for address
1750     mapping(address => uint256) public lastInstantGameTicketsNumber; // for address
1751 
1752     // first step for player is to make a bet:
1753     uint256 public betCounter;
1754     uint256 public lastUnplayedBet;
1755     mapping(uint256 => address) public playerByBet;
1756 
1757     event BetPlaced(
1758         uint256 indexed eventsCounter, // 0
1759         uint256 indexed betCounter, // 1
1760         address indexed player, // 2
1761         uint256 betInWei, // 3
1762         uint256 ticketsBefore, // 4
1763         uint256 newTickets // 5
1764     );
1765 
1766     function placeABetInternal(uint value) private {
1767 
1768         require(msg.sender != kingOfTheHill);
1769 
1770         // we do not allow a contract to place a bet
1771         // to prevent vulnerability described on
1772         // https://github.com/EthereumCommonwealth/Auditing/issues/288#issuecomment-507383615 : 3.1
1773         // see: https://github.com/EthereumCommonwealth/Auditing/issues/332#issuecomment-514692834 : 3.1
1774         require(msg.sender == tx.origin);
1775 
1776         // only one game allowed for the address at the given moment:
1777         require(!instantGameIsRunning[msg.sender]);
1778 
1779         if (lastUnplayedBet <= betCounter && betCounter != 0) {
1780             if (lastInstantGameBlockNumber[playerByBet[lastUnplayedBet]] < block.number) {
1781                 play();
1782             }
1783         }
1784 
1785         // number of new tickets to create;
1786         uint256 newTickets = value / ticketPriceInWei;
1787 
1788         eventsCounter++;
1789 
1790         betCounter++;
1791         if (betCounter == 1) {
1792             lastUnplayedBet = 1;
1793         }
1794 
1795         playerByBet[betCounter] = msg.sender;
1796 
1797         BetPlaced(eventsCounter, betCounter, msg.sender, value, ticketsTotal, newTickets);
1798 
1799         uint256 playerBetToPlace = newTickets.mul(ticketPriceInWei);
1800 
1801         sum[playersBets] = sum[playersBets].add(playerBetToPlace);
1802 
1803         require(newTickets > 0 && newTickets <= maxTicketsToBuyInOneTransaction);
1804 
1805         uint256 newTicketsTotal = ticketsTotal.add(newTickets);
1806 
1807         // new tickets included in jackpot games instantly:
1808         for (uint256 i = ticketsTotal + 1; i <= newTicketsTotal; i++) {
1809             theLotteryTicket[i] = msg.sender;
1810         }
1811 
1812         ticketsTotal = newTicketsTotal;
1813         playerTicketsTotal[msg.sender] = playerTicketsTotal[msg.sender].add(newTickets);
1814 
1815         lastInstantGameTicketsNumber[msg.sender] = newTickets;
1816         instantGameIsRunning[msg.sender] = true;
1817         lastInstantGameBlockNumber[msg.sender] = block.number;
1818     }
1819 
1820     function placeABet() public payable {
1821         placeABetInternal(msg.value);
1822     }
1823 
1824     mapping(address => address) public referrer;
1825 
1826     function placeABetWithReferrer(address _referrer) public payable {
1827         /* referrer: */
1828         if (referrer[msg.sender] == 0x0000000000000000000000000000000000000000) {
1829             referrer[msg.sender] = _referrer;
1830         }
1831         placeABetInternal(msg.value);
1832     }
1833 
1834     event Investment(
1835         uint256 indexed eventsCounter, //.1
1836         address indexed by, //............2
1837         uint256 sum, //...................3
1838         uint256 sumToMarketingFund, //....4
1839         uint256 bet, //...................5
1840         uint256 tokens //.................6
1841     ); //
1842     function investAndPlay() public payable {
1843 
1844         // require( luckyStrikeTokens.tokenSaleIsRunning());
1845         // < we will check this in luckyStrikeTokens.mint method
1846 
1847         require(msg.value > 0);
1848         uint256 sumToMarketingFund = msg.value.div(5);
1849 
1850         uint256 bet = ((msg.value.sub(sumToMarketingFund)) / ticketPriceInWei) * ticketPriceInWei;
1851 
1852         sumToMarketingFund = msg.value.sub(bet);
1853 
1854         sum[marketingFund] = sum[marketingFund].add(sumToMarketingFund);
1855 
1856         uint256 tokensToMint = sumToMarketingFund / tokenPriceInWei;
1857 
1858         luckyStrikeTokens.mint(msg.sender, tokensToMint, sumToMarketingFund);
1859 
1860         eventsCounter = eventsCounter + 1;
1861         Investment(
1862             eventsCounter, //......1
1863             msg.sender, //.........2
1864             msg.value, //..........3
1865             sumToMarketingFund, //.4
1866             bet, //................5
1867             tokensToMint //........6
1868         );
1869 
1870         placeABetInternal(bet);
1871 
1872     }
1873 
1874     function investAndPlayWithReferrer(address _referrer) public payable {
1875         if (referrer[msg.sender] == 0x0000000000000000000000000000000000000000) {
1876             referrer[msg.sender] = _referrer;
1877         }
1878         investAndPlay();
1879     }
1880 
1881     // second step in instant game:
1882     event InstantGameResult (
1883         uint256 indexed eventsCounter, //...0
1884         uint256 gameId, // .................1
1885         bool theBetPlayed, //...............2
1886         address indexed challenger, //......3
1887         address indexed king, //............4
1888         uint256 kingsTicketsNumber, //......5
1889         address winner, //..................6
1890         uint256 prize, //...................7
1891         uint256 ticketsInTheInstantGame, //.8
1892         uint256 randomNumber, //............9
1893         address triggeredBy //..............10
1894     );
1895 
1896     uint256 public kingChangedOnBlock; //
1897     uint256 public currentKingVictoriesCounter; //
1898     struct Victory {
1899         uint256 number;
1900         // uint256 unixTime;
1901         address loser;
1902         uint256 loserTicketsAmount;
1903     } //
1904     mapping(uint256 => Victory) public currentKingVictories;
1905 
1906     /*
1907     * plays last unplayed bet
1908     * can be run by any address on the blockchain
1909     * we also run a bot that will check smart contract every ... seconds, and it there is an unplayed bet runs play()
1910     */
1911     function play() public {
1912 
1913         require(lastUnplayedBet <= betCounter);
1914         address player = playerByBet[lastUnplayedBet];
1915 
1916         require(instantGameIsRunning[player]);
1917         // additional check
1918         require(lastInstantGameBlockNumber[player] < block.number);
1919 
1920         // block number with the bet must be no more than 255 blocks before the current block
1921         // or we get 0 as blockhash
1922 
1923         instantGameCounter = instantGameCounter + 1;
1924 
1925         uint256 playerBet = lastInstantGameTicketsNumber[player].mul(ticketPriceInWei);
1926         // uint256 kingsBet = kingOfTheHillTicketsNumber.mul(ticketPriceInWei); // < stack to deep, try removing local variables
1927         uint256 ticketsInTheInstantGame = kingOfTheHillTicketsNumber.add(lastInstantGameTicketsNumber[player]);
1928         // in any case playerBet should be subtracted from sum[playerBets]
1929         sum[playersBets] = sum[playersBets].sub(playerBet);
1930 
1931         if (block.number - lastInstantGameBlockNumber[player] > 255) {
1932 
1933             // player can not play in instant game, but still plays in jackpots
1934             // so we allocate sum to jackpots and income and return unplayed rest to player
1935             player.transfer(allocateSum(playerBet, player));
1936 
1937             eventsCounter = eventsCounter + 1;
1938             InstantGameResult(
1939                 eventsCounter,
1940                 instantGameCounter,
1941                 false,
1942                 player,
1943                 address(0), // kingOfTheHill, // oldKingOfTheHill,
1944                 0,
1945                 address(0), // winner,
1946                 0, // prize,
1947                 0, // lastInstantGameTicketsNumber[player], // ticketsInTheInstantGame,
1948                 0, // randomNumber,
1949                 msg.sender // triggeredBy
1950             );
1951 
1952             lastInstantGameTicketsNumber[player] = 0;
1953             instantGameIsRunning[player] = false;
1954 
1955             lastUnplayedBet++;
1956 
1957             return;
1958         }
1959 
1960         bytes32 seed = keccak256(
1961             block.blockhash(lastInstantGameBlockNumber[player]) // bytes32
1962         );
1963 
1964         // uint256 seedToNumber = uint256(seed);
1965         // uint256 randomNumber = seedToNumber % ticketsInTheInstantGame;
1966         uint256 randomNumber = uint256(seed) % ticketsInTheInstantGame;
1967 
1968         // 0 never plays, and ticketsInTheInstantGame can not be returned by the function above
1969         if (randomNumber == 0) {
1970             randomNumber = ticketsInTheInstantGame;
1971         }
1972 
1973         address oldKingOfTheHill = kingOfTheHill;
1974         uint256 oldKingOfTheHillTicketsNumber = kingOfTheHillTicketsNumber;
1975 
1976         uint256 prize;
1977         address winner;
1978         // address loser;
1979 
1980         if (randomNumber > kingOfTheHillTicketsNumber) {// challenger ('player') wins
1981             winner = player;
1982             prize = allocateSum(kingOfTheHillTicketsNumber.mul(ticketPriceInWei), kingOfTheHill);
1983 
1984             // record this victory for the new king:
1985             currentKingVictoriesCounter = 1;
1986             currentKingVictories[currentKingVictoriesCounter].number = currentKingVictoriesCounter;
1987             currentKingVictories[currentKingVictoriesCounter].loser = kingOfTheHill;
1988             currentKingVictories[currentKingVictoriesCounter].loserTicketsAmount = kingOfTheHillTicketsNumber;
1989 
1990             // inaugurate new kingOfTheHill:
1991             kingChangedOnBlock = block.number;
1992             kingOfTheHill = player;
1993             kingOfTheHillTicketsNumber = lastInstantGameTicketsNumber[player];
1994 
1995         } else {// kingOfTheHill wins
1996             winner = kingOfTheHill;
1997             prize = allocateSum(playerBet, player);
1998             currentKingVictoriesCounter++;
1999             currentKingVictories[currentKingVictoriesCounter].number = currentKingVictoriesCounter;
2000             currentKingVictories[currentKingVictoriesCounter].loser = player;
2001             currentKingVictories[currentKingVictoriesCounter].loserTicketsAmount = lastInstantGameTicketsNumber[player];
2002         }
2003 
2004         instantGameIsRunning[player] = false;
2005 
2006         // pay prize to the winner
2007         winner.transfer(prize);
2008 
2009         eventsCounter = eventsCounter + 1;
2010         InstantGameResult(
2011             eventsCounter,
2012             instantGameCounter,
2013             true,
2014             player,
2015             oldKingOfTheHill,
2016             oldKingOfTheHillTicketsNumber,
2017             winner,
2018             prize,
2019             ticketsInTheInstantGame,
2020             randomNumber,
2021             msg.sender
2022         );
2023 
2024         lastUnplayedBet++;
2025 
2026     }
2027 
2028     /* ----------- Jackpots: ------------ */
2029 
2030     function requestRandomFromOraclize() private returns (bytes32 oraclizeQueryId)  {
2031 
2032         require(msg.value >= oraclizeGetPrice());
2033         // < to pay to oraclize
2034 
2035         // call Oraclize
2036         // uint N :
2037         // number nRandomBytes between 1 and 32, which is the number of random bytes to be returned to the application.
2038         // see: http://www.oraclize.it/papers/random_datasource-rev1.pdf
2039         uint256 N = 32;
2040         // number of seconds to wait before the execution takes place
2041         uint delay = 0;
2042         // this function internally generates the correct oraclize_query and returns its queryId
2043         oraclizeQueryId = oraclize_newRandomDSQuery(delay, N, oraclizeCallbackGas);
2044 
2045         // playJackpotEvent(msg.sender, msg.value, tx.gasprice, oraclizeQueryId);
2046         return oraclizeQueryId;
2047 
2048     }
2049 
2050     // reminder (this defined above):
2051     // mapping(uint8 => uint256) public period; // in seconds
2052     // mapping(uint8 => uint256) public lastJackpotTime;  // unix time
2053     mapping(bytes32 => uint8) public jackpot;
2054 
2055     event JackpotPlayStarted(
2056         uint256 indexed eventsCounter,
2057         uint8 indexed jackpotType,
2058         address startedBy,
2059         bytes32 oraclizeQueryId,
2060         uint256 ticketsPlayingInJackpot
2061     );//
2062 
2063     mapping(bytes32 => uint256) public numberOfTicketsPlayingInJackpot;
2064 
2065     function startJackpotPlay(uint8 jackpotType) public payable {
2066 
2067         require(msg.value >= oraclizeGetPrice());
2068 
2069         require(jackpotType >= 1 && jackpotType <= 4);
2070 
2071         // if jackpot play was already triggered more than 200 blocks ago and still no results, it can be started again
2072         resetJackpotPlayIsRunning(jackpotType);
2073 
2074         require(!jackpotPlayIsRunning[jackpotType]);
2075 
2076         // check if
2077         require(
2078         // block.timestamp (uint): current block timestamp as seconds since unix epoch
2079             block.timestamp >= lastJackpotTime[jackpotType].add(period[jackpotType])
2080         );
2081 
2082         bytes32 oraclizeQueryId = requestRandomFromOraclize();
2083 
2084         jackpot[oraclizeQueryId] = jackpotType;
2085 
2086         jackpotPlayIsRunning[jackpotType] = true;
2087         jackpotPlayLastTimeStartedFromBlock[jackpotType] = block.number;
2088 
2089         numberOfTicketsPlayingInJackpot[oraclizeQueryId] = ticketsTotal;
2090 
2091         eventsCounter = eventsCounter + 1;
2092         JackpotPlayStarted(
2093             eventsCounter,
2094             jackpotType,
2095             msg.sender,
2096             oraclizeQueryId,
2097             numberOfTicketsPlayingInJackpot[oraclizeQueryId]
2098         );
2099 
2100     }
2101 
2102     uint256 public allJackpotsCounter;
2103 
2104     event JackpotResult(
2105         uint256 indexed eventsCounter,
2106         uint256 allJackpotsCounter,
2107         uint8 indexed jackpotType,
2108         uint256 jackpotIdNumber,
2109         uint256 prize,
2110         address indexed winner,
2111         uint256 randomNumber,
2112         uint256 ticketsPlayedInJackpot
2113     );
2114 
2115     /*
2116     * this is for testing and debugging
2117     */
2118     function getOraclizeCallbackAddress() public returns (address){
2119         return oraclize_cbAddress();
2120     }
2121 
2122     /*
2123     * this should help us to identify cases in which Oraclize returned random value verification was filed
2124     */
2125     uint256 public oraclizeRandomValueVerificationWasFailedCounter;
2126 
2127     event OraclizeRandomValueVerificationWasFailed (
2128         uint256 indexed eventsCounter,
2129         uint256 indexed oraclizeRandomValueVerificationWasFailedCounter,
2130         uint8 indexed jackpotType
2131     // bytes32 _queryId,
2132     // string _result,
2133     // bytes _proof
2134     );
2135 
2136     // the callback function is called by Oraclize when the result is ready
2137     // the oraclize_randomDS_proofVerify modifier prevents an invalid proof to execute this function code:
2138     // the proof validity is fully verified on-chain
2139     function __callback(bytes32 _queryId, string _result, bytes _proof) public {
2140 
2141         require(msg.sender == oraclize_cbAddress());
2142 
2143         // find jackpot type for this _queryId:
2144 
2145         uint8 jackpotType = jackpot[_queryId];
2146 
2147         if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0) {
2148             // the proof verification has failed, do we need to take any action here? (depends on the use case)
2149             // revert();
2150             eventsCounter++;
2151             oraclizeRandomValueVerificationWasFailedCounter++;
2152             OraclizeRandomValueVerificationWasFailed(
2153                 eventsCounter,
2154                 oraclizeRandomValueVerificationWasFailedCounter,
2155                 jackpotType
2156             // _queryId,
2157             // _result,
2158             // _proof
2159             );
2160 
2161             // make possible to run this jackpot again
2162             jackpotPlayIsRunning[jackpotType] = false;
2163 
2164             return;
2165 
2166         } else {
2167 
2168             require(jackpotPlayIsRunning[jackpotType]);
2169 
2170             // select jackpot winner:
2171 
2172             // bytes32 hashOfTheRandomString = keccak256(_result);
2173             // uint256 randomNumberSeed = uint256(hashOfTheRandomString);
2174             uint256 randomNumberSeed = uint256(keccak256(_result));
2175 
2176             uint256 randomNumber = randomNumberSeed % numberOfTicketsPlayingInJackpot[_queryId];
2177 
2178             // there is no ticket # 0,
2179             // and above function can not return number equivalent to number of all tickets playing in Jackpot
2180             if (randomNumber == 0) {
2181                 randomNumber = numberOfTicketsPlayingInJackpot[_queryId];
2182             }
2183 
2184             // address winner = theLotteryTicket[randomNumber];
2185 
2186             // old code from ver. 7.0.0
2187             // transfer jackpot sum to the winner:
2188             // theLotteryTicket[randomNumber].transfer(sum[jackpotType]);
2189 
2190             // new in ver. 7.1.0
2191             // add data to allow winner to withdraw the prize
2192             // see function withdrawJackpotPrize
2193             lastJackpotWinnerAddress[jackpotType] = theLotteryTicket[randomNumber];
2194             // if previous jackpot prize was not withdrawn it goes to new winner
2195             lastJackpotSumWon[jackpotType] = lastJackpotSumWon[jackpotType].add(sum[jackpotType]);
2196 
2197             // emit event:
2198             eventsCounter++;
2199             jackpotCounter[jackpotType]++;
2200             allJackpotsCounter++;
2201 
2202             JackpotResult(
2203                 eventsCounter,
2204                 allJackpotsCounter,
2205                 jackpotType,
2206                 jackpotCounter[jackpotType],
2207                 lastJackpotSumWon[jackpotType], // in ver. 7.0.0 sum[jackpotType],
2208                 theLotteryTicket[randomNumber],
2209                 randomNumber,
2210                 numberOfTicketsPlayingInJackpot[_queryId]
2211             );
2212 
2213             // update information for this jackpot:
2214 
2215             sum[jackpotType] = 0;
2216 
2217             lastJackpotTime[jackpotType] = block.timestamp;
2218 
2219             jackpotPlayIsRunning[jackpotType] = false;
2220 
2221         }
2222     } // end of function __callback
2223 
2224     /*
2225     * if jackpot play was already triggered more than 200 blocks ago and still no results, it can be started again
2226     */
2227     function resetJackpotPlayIsRunning(uint8 _jackpotType) public returns (bool success){
2228         if (
2229             jackpotPlayIsRunning[_jackpotType]
2230             && block.number.sub(jackpotPlayLastTimeStartedFromBlock[_jackpotType]) > 200
2231         ) {
2232             jackpotPlayIsRunning[_jackpotType] = false;
2233         }
2234         return true;
2235     }
2236 
2237     event IncomeSentToTokensContract(uint256 indexed eventsCounter, uint256 sum, address indexed triggeredBy);
2238     // can be called by any address:
2239     function payIncome() public returns (bool success){
2240 
2241         // luckyStrikeTokensContractAddress.transfer(sum[income]);
2242         luckyStrikeTokens.transferIncome.value(sum[income])();
2243 
2244         eventsCounter = eventsCounter + 1;
2245         IncomeSentToTokensContract(eventsCounter, sum[income], msg.sender);
2246 
2247         sum[income] = 0;
2248 
2249         return true;
2250     }
2251 
2252 }