1 pragma solidity 0.4.20;
2 
3 // we use solidity solidity 0.4.20 to work with oraclize (http://www.oraclize.it)
4 // solidity versions > 0.4.20 are not supported by oraclize
5 
6 /*
7 Lucky Strike smart contracts version: 2.0
8 */
9 
10 /*
11 This smart contract is intended for entertainment purposes only. Cryptocurrency gambling is illegal in many jurisdictions and users should consult their legal counsel regarding the legal status of cryptocurrency gambling in their jurisdictions.
12 Since developers of this smart contract are unable to determine which jurisdiction you reside in, you must check current laws including your local and state laws to find out if cryptocurrency gambling is legal in your area.
13 If you reside in a location where cryptocurrency gambling is illegal, please do not interact with this smart contract in any way and leave it  immediately.
14 */
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  * source: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
20  */
21 library SafeMath {
22 
23     /**
24     * @dev Multiplies two numbers, throws on overflow.
25     */
26     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
27         if (a == 0) {
28             return 0;
29         }
30         c = a * b;
31         assert(c / a == b);
32         return c;
33     }
34 
35     /**
36     * @dev Integer division of two numbers, truncating the quotient.
37     */
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         // assert(b > 0); // Solidity automatically throws when dividing by 0
40         // uint256 c = a / b;
41         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42         return a / b;
43     }
44 
45     /**
46     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
47     */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         assert(b <= a);
50         return a - b;
51     }
52 
53     /**
54     * @dev Adds two numbers, throws on overflow.
55     */
56     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
57         c = a + b;
58         assert(c >= a);
59         return c;
60     }
61 }
62 
63 // ORACLIZE_API
64 /*
65 Copyright (c) 2015-2016 Oraclize SRL
66 Copyright (c) 2016 Oraclize LTD
67 
68 
69 
70 Permission is hereby granted, free of charge, to any person obtaining a copy
71 of this software and associated documentation files (the "Software"), to deal
72 in the Software without restriction, including without limitation the rights
73 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
74 copies of the Software, and to permit persons to whom the Software is
75 furnished to do so, subject to the following conditions:
76 
77 
78 
79 The above copyright notice and this permission notice shall be included in
80 all copies or substantial portions of the Software.
81 
82 
83 
84 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
85 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
86 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
87 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
88 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
89 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
90 THE SOFTWARE.
91 */
92 
93 //pragma solidity >=0.4.1 <=0.4.20;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
94 
95 contract OraclizeI {
96     address public cbAddress;
97 
98     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
99 
100     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
101 
102     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
103 
104     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
105 
106     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
107 
108     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
109 
110     function getPrice(string _datasource) returns (uint _dsprice);
111 
112     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
113 
114     function useCoupon(string _coupon);
115 
116     function setProofType(byte _proofType);
117 
118     function setConfig(bytes32 _config);
119 
120     function setCustomGasPrice(uint _gasPrice);
121 
122     function randomDS_getSessionPubKeyHash() returns (bytes32);
123 }
124 
125 contract OraclizeAddrResolverI {
126     function getAddress() returns (address _addr);
127 }
128 
129 /*
130 Begin solidity-cborutils
131 
132 https://github.com/smartcontractkit/solidity-cborutils
133 
134 MIT License
135 
136 Copyright (c) 2018 SmartContract ChainLink, Ltd.
137 
138 Permission is hereby granted, free of charge, to any person obtaining a copy
139 of this software and associated documentation files (the "Software"), to deal
140 in the Software without restriction, including without limitation the rights
141 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
142 copies of the Software, and to permit persons to whom the Software is
143 furnished to do so, subject to the following conditions:
144 
145 The above copyright notice and this permission notice shall be included in all
146 copies or substantial portions of the Software.
147 
148 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
149 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
150 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
151 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
152 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
153 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
154 SOFTWARE.
155  */
156 
157 library Buffer {
158     struct buffer {
159         bytes buf;
160         uint capacity;
161     }
162 
163     function init(buffer memory buf, uint capacity) internal constant {
164         if (capacity % 32 != 0) capacity += 32 - (capacity % 32);
165         // Allocate space for the buffer data
166         buf.capacity = capacity;
167         assembly {
168             let ptr := mload(0x40)
169             mstore(buf, ptr)
170             mstore(0x40, add(ptr, capacity))
171         }
172     }
173 
174     function resize(buffer memory buf, uint capacity) private constant {
175         bytes memory oldbuf = buf.buf;
176         init(buf, capacity);
177         append(buf, oldbuf);
178     }
179 
180     function max(uint a, uint b) private constant returns (uint) {
181         if (a > b) {
182             return a;
183         }
184         return b;
185     }
186 
187     /**
188      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
189      *      would exceed the capacity of the buffer.
190      * @param buf The buffer to append to.
191      * @param data The data to append.
192      * @return The original buffer.
193      */
194     function append(buffer memory buf, bytes data) internal constant returns (buffer memory) {
195         if (data.length + buf.buf.length > buf.capacity) {
196             resize(buf, max(buf.capacity, data.length) * 2);
197         }
198 
199         uint dest;
200         uint src;
201         uint len = data.length;
202         assembly {
203         // Memory address of the buffer data
204             let bufptr := mload(buf)
205         // Length of existing buffer data
206             let buflen := mload(bufptr)
207         // Start address = buffer address + buffer length + sizeof(buffer length)
208             dest := add(add(bufptr, buflen), 32)
209         // Update buffer length
210             mstore(bufptr, add(buflen, mload(data)))
211             src := add(data, 32)
212         }
213 
214         // Copy word-length chunks while possible
215         for (; len >= 32; len -= 32) {
216             assembly {
217                 mstore(dest, mload(src))
218             }
219             dest += 32;
220             src += 32;
221         }
222 
223         // Copy remaining bytes
224         uint mask = 256 ** (32 - len) - 1;
225         assembly {
226             let srcpart := and(mload(src), not(mask))
227             let destpart := and(mload(dest), mask)
228             mstore(dest, or(destpart, srcpart))
229         }
230 
231         return buf;
232     }
233 
234     /**
235      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
236      * exceed the capacity of the buffer.
237      * @param buf The buffer to append to.
238      * @param data The data to append.
239      * @return The original buffer.
240      */
241     function append(buffer memory buf, uint8 data) internal constant {
242         if (buf.buf.length + 1 > buf.capacity) {
243             resize(buf, buf.capacity * 2);
244         }
245 
246         assembly {
247         // Memory address of the buffer data
248             let bufptr := mload(buf)
249         // Length of existing buffer data
250             let buflen := mload(bufptr)
251         // Address = buffer address + buffer length + sizeof(buffer length)
252             let dest := add(add(bufptr, buflen), 32)
253             mstore8(dest, data)
254         // Update buffer length
255             mstore(bufptr, add(buflen, 1))
256         }
257     }
258 
259     /**
260      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
261      * exceed the capacity of the buffer.
262      * @param buf The buffer to append to.
263      * @param data The data to append.
264      * @return The original buffer.
265      */
266     function appendInt(buffer memory buf, uint data, uint len) internal constant returns (buffer memory) {
267         if (len + buf.buf.length > buf.capacity) {
268             resize(buf, max(buf.capacity, len) * 2);
269         }
270 
271         uint mask = 256 ** len - 1;
272         assembly {
273         // Memory address of the buffer data
274             let bufptr := mload(buf)
275         // Length of existing buffer data
276             let buflen := mload(bufptr)
277         // Address = buffer address + buffer length + sizeof(buffer length) + len
278             let dest := add(add(bufptr, buflen), len)
279             mstore(dest, or(and(mload(dest), not(mask)), data))
280         // Update buffer length
281             mstore(bufptr, add(buflen, len))
282         }
283         return buf;
284     }
285 }
286 
287 library CBOR {
288     using Buffer for Buffer.buffer;
289 
290     uint8 private constant MAJOR_TYPE_INT = 0;
291     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
292     uint8 private constant MAJOR_TYPE_BYTES = 2;
293     uint8 private constant MAJOR_TYPE_STRING = 3;
294     uint8 private constant MAJOR_TYPE_ARRAY = 4;
295     uint8 private constant MAJOR_TYPE_MAP = 5;
296     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
297 
298     function shl8(uint8 x, uint8 y) private constant returns (uint8) {
299         return x * (2 ** y);
300     }
301 
302     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private constant {
303         if (value <= 23) {
304             buf.append(uint8(shl8(major, 5) | value));
305         } else if (value <= 0xFF) {
306             buf.append(uint8(shl8(major, 5) | 24));
307             buf.appendInt(value, 1);
308         } else if (value <= 0xFFFF) {
309             buf.append(uint8(shl8(major, 5) | 25));
310             buf.appendInt(value, 2);
311         } else if (value <= 0xFFFFFFFF) {
312             buf.append(uint8(shl8(major, 5) | 26));
313             buf.appendInt(value, 4);
314         } else if (value <= 0xFFFFFFFFFFFFFFFF) {
315             buf.append(uint8(shl8(major, 5) | 27));
316             buf.appendInt(value, 8);
317         }
318     }
319 
320     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private constant {
321         buf.append(uint8(shl8(major, 5) | 31));
322     }
323 
324     function encodeUInt(Buffer.buffer memory buf, uint value) internal constant {
325         encodeType(buf, MAJOR_TYPE_INT, value);
326     }
327 
328     function encodeInt(Buffer.buffer memory buf, int value) internal constant {
329         if (value >= 0) {
330             encodeType(buf, MAJOR_TYPE_INT, uint(value));
331         } else {
332             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(- 1 - value));
333         }
334     }
335 
336     function encodeBytes(Buffer.buffer memory buf, bytes value) internal constant {
337         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
338         buf.append(value);
339     }
340 
341     function encodeString(Buffer.buffer memory buf, string value) internal constant {
342         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
343         buf.append(bytes(value));
344     }
345 
346     function startArray(Buffer.buffer memory buf) internal constant {
347         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
348     }
349 
350     function startMap(Buffer.buffer memory buf) internal constant {
351         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
352     }
353 
354     function endSequence(Buffer.buffer memory buf) internal constant {
355         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
356     }
357 }
358 
359 /*
360 End solidity-cborutils
361  */
362 
363 contract usingOraclize {
364     uint constant day = 60 * 60 * 24;
365     uint constant week = 60 * 60 * 24 * 7;
366     uint constant month = 60 * 60 * 24 * 30;
367     byte constant proofType_NONE = 0x00;
368     byte constant proofType_TLSNotary = 0x10;
369     byte constant proofType_Android = 0x20;
370     byte constant proofType_Ledger = 0x30;
371     byte constant proofType_Native = 0xF0;
372     byte constant proofStorage_IPFS = 0x01;
373     uint8 constant networkID_auto = 0;
374     uint8 constant networkID_mainnet = 1;
375     uint8 constant networkID_testnet = 2;
376     uint8 constant networkID_morden = 2;
377     uint8 constant networkID_consensys = 161;
378 
379     OraclizeAddrResolverI OAR;
380 
381     OraclizeI oraclize;
382     modifier oraclizeAPI {
383         if ((address(OAR) == 0) || (getCodeSize(address(OAR)) == 0))
384             oraclize_setNetwork(networkID_auto);
385 
386         if (address(oraclize) != OAR.getAddress())
387             oraclize = OraclizeI(OAR.getAddress());
388 
389         _;
390     }
391     modifier coupon(string code){
392         oraclize = OraclizeI(OAR.getAddress());
393         oraclize.useCoupon(code);
394         _;
395     }
396 
397     function oraclize_setNetwork(uint8 networkID) internal returns (bool){
398         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) {//mainnet
399             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
400             oraclize_setNetworkName("eth_mainnet");
401             return true;
402         }
403         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) {//ropsten testnet
404             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
405             oraclize_setNetworkName("eth_ropsten3");
406             return true;
407         }
408         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) {//kovan testnet
409             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
410             oraclize_setNetworkName("eth_kovan");
411             return true;
412         }
413         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) {//rinkeby testnet
414             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
415             oraclize_setNetworkName("eth_rinkeby");
416             return true;
417         }
418         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) {//ethereum-bridge
419             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
420             return true;
421         }
422         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) {//ether.camp ide
423             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
424             return true;
425         }
426         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) {//browser-solidity
427             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
428             return true;
429         }
430         return false;
431     }
432 
433     function __callback(bytes32 myid, string result) {
434         __callback(myid, result, new bytes(0));
435     }
436 
437     function __callback(bytes32 myid, string result, bytes proof) {
438     }
439 
440     function oraclize_useCoupon(string code) oraclizeAPI internal {
441         oraclize.useCoupon(code);
442     }
443 
444     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
445         return oraclize.getPrice(datasource);
446     }
447 
448     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
449         return oraclize.getPrice(datasource, gaslimit);
450     }
451 
452     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
453         uint price = oraclize.getPrice(datasource);
454         if (price > 1 ether + tx.gasprice * 200000) return 0;
455         // unexpectedly high price
456         return oraclize.query.value(price)(0, datasource, arg);
457     }
458 
459     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
460         uint price = oraclize.getPrice(datasource);
461         if (price > 1 ether + tx.gasprice * 200000) return 0;
462         // unexpectedly high price
463         return oraclize.query.value(price)(timestamp, datasource, arg);
464     }
465 
466     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
467         uint price = oraclize.getPrice(datasource, gaslimit);
468         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
469         // unexpectedly high price
470         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
471     }
472 
473     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
474         uint price = oraclize.getPrice(datasource, gaslimit);
475         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
476         // unexpectedly high price
477         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
478     }
479 
480     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
481         uint price = oraclize.getPrice(datasource);
482         if (price > 1 ether + tx.gasprice * 200000) return 0;
483         // unexpectedly high price
484         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
485     }
486 
487     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
488         uint price = oraclize.getPrice(datasource);
489         if (price > 1 ether + tx.gasprice * 200000) return 0;
490         // unexpectedly high price
491         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
492     }
493 
494     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
495         uint price = oraclize.getPrice(datasource, gaslimit);
496         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
497         // unexpectedly high price
498         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
499     }
500 
501     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
502         uint price = oraclize.getPrice(datasource, gaslimit);
503         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
504         // unexpectedly high price
505         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
506     }
507 
508     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
509         uint price = oraclize.getPrice(datasource);
510         if (price > 1 ether + tx.gasprice * 200000) return 0;
511         // unexpectedly high price
512         bytes memory args = stra2cbor(argN);
513         return oraclize.queryN.value(price)(0, datasource, args);
514     }
515 
516     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
517         uint price = oraclize.getPrice(datasource);
518         if (price > 1 ether + tx.gasprice * 200000) return 0;
519         // unexpectedly high price
520         bytes memory args = stra2cbor(argN);
521         return oraclize.queryN.value(price)(timestamp, datasource, args);
522     }
523 
524     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
525         uint price = oraclize.getPrice(datasource, gaslimit);
526         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
527         // unexpectedly high price
528         bytes memory args = stra2cbor(argN);
529         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
530     }
531 
532     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
533         uint price = oraclize.getPrice(datasource, gaslimit);
534         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
535         // unexpectedly high price
536         bytes memory args = stra2cbor(argN);
537         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
538     }
539 
540     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
541         string[] memory dynargs = new string[](1);
542         dynargs[0] = args[0];
543         return oraclize_query(datasource, dynargs);
544     }
545 
546     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
547         string[] memory dynargs = new string[](1);
548         dynargs[0] = args[0];
549         return oraclize_query(timestamp, datasource, dynargs);
550     }
551 
552     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
553         string[] memory dynargs = new string[](1);
554         dynargs[0] = args[0];
555         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
556     }
557 
558     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
559         string[] memory dynargs = new string[](1);
560         dynargs[0] = args[0];
561         return oraclize_query(datasource, dynargs, gaslimit);
562     }
563 
564     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
565         string[] memory dynargs = new string[](2);
566         dynargs[0] = args[0];
567         dynargs[1] = args[1];
568         return oraclize_query(datasource, dynargs);
569     }
570 
571     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
572         string[] memory dynargs = new string[](2);
573         dynargs[0] = args[0];
574         dynargs[1] = args[1];
575         return oraclize_query(timestamp, datasource, dynargs);
576     }
577 
578     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
579         string[] memory dynargs = new string[](2);
580         dynargs[0] = args[0];
581         dynargs[1] = args[1];
582         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
583     }
584 
585     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
586         string[] memory dynargs = new string[](2);
587         dynargs[0] = args[0];
588         dynargs[1] = args[1];
589         return oraclize_query(datasource, dynargs, gaslimit);
590     }
591 
592     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
593         string[] memory dynargs = new string[](3);
594         dynargs[0] = args[0];
595         dynargs[1] = args[1];
596         dynargs[2] = args[2];
597         return oraclize_query(datasource, dynargs);
598     }
599 
600     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
601         string[] memory dynargs = new string[](3);
602         dynargs[0] = args[0];
603         dynargs[1] = args[1];
604         dynargs[2] = args[2];
605         return oraclize_query(timestamp, datasource, dynargs);
606     }
607 
608     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
609         string[] memory dynargs = new string[](3);
610         dynargs[0] = args[0];
611         dynargs[1] = args[1];
612         dynargs[2] = args[2];
613         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
614     }
615 
616     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
617         string[] memory dynargs = new string[](3);
618         dynargs[0] = args[0];
619         dynargs[1] = args[1];
620         dynargs[2] = args[2];
621         return oraclize_query(datasource, dynargs, gaslimit);
622     }
623 
624     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
625         string[] memory dynargs = new string[](4);
626         dynargs[0] = args[0];
627         dynargs[1] = args[1];
628         dynargs[2] = args[2];
629         dynargs[3] = args[3];
630         return oraclize_query(datasource, dynargs);
631     }
632 
633     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
634         string[] memory dynargs = new string[](4);
635         dynargs[0] = args[0];
636         dynargs[1] = args[1];
637         dynargs[2] = args[2];
638         dynargs[3] = args[3];
639         return oraclize_query(timestamp, datasource, dynargs);
640     }
641 
642     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
643         string[] memory dynargs = new string[](4);
644         dynargs[0] = args[0];
645         dynargs[1] = args[1];
646         dynargs[2] = args[2];
647         dynargs[3] = args[3];
648         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
649     }
650 
651     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
652         string[] memory dynargs = new string[](4);
653         dynargs[0] = args[0];
654         dynargs[1] = args[1];
655         dynargs[2] = args[2];
656         dynargs[3] = args[3];
657         return oraclize_query(datasource, dynargs, gaslimit);
658     }
659 
660     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
661         string[] memory dynargs = new string[](5);
662         dynargs[0] = args[0];
663         dynargs[1] = args[1];
664         dynargs[2] = args[2];
665         dynargs[3] = args[3];
666         dynargs[4] = args[4];
667         return oraclize_query(datasource, dynargs);
668     }
669 
670     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
671         string[] memory dynargs = new string[](5);
672         dynargs[0] = args[0];
673         dynargs[1] = args[1];
674         dynargs[2] = args[2];
675         dynargs[3] = args[3];
676         dynargs[4] = args[4];
677         return oraclize_query(timestamp, datasource, dynargs);
678     }
679 
680     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
681         string[] memory dynargs = new string[](5);
682         dynargs[0] = args[0];
683         dynargs[1] = args[1];
684         dynargs[2] = args[2];
685         dynargs[3] = args[3];
686         dynargs[4] = args[4];
687         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
688     }
689 
690     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
691         string[] memory dynargs = new string[](5);
692         dynargs[0] = args[0];
693         dynargs[1] = args[1];
694         dynargs[2] = args[2];
695         dynargs[3] = args[3];
696         dynargs[4] = args[4];
697         return oraclize_query(datasource, dynargs, gaslimit);
698     }
699 
700     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
701         uint price = oraclize.getPrice(datasource);
702         if (price > 1 ether + tx.gasprice * 200000) return 0;
703         // unexpectedly high price
704         bytes memory args = ba2cbor(argN);
705         return oraclize.queryN.value(price)(0, datasource, args);
706     }
707 
708     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
709         uint price = oraclize.getPrice(datasource);
710         if (price > 1 ether + tx.gasprice * 200000) return 0;
711         // unexpectedly high price
712         bytes memory args = ba2cbor(argN);
713         return oraclize.queryN.value(price)(timestamp, datasource, args);
714     }
715 
716     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
717         uint price = oraclize.getPrice(datasource, gaslimit);
718         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
719         // unexpectedly high price
720         bytes memory args = ba2cbor(argN);
721         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
722     }
723 
724     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
725         uint price = oraclize.getPrice(datasource, gaslimit);
726         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
727         // unexpectedly high price
728         bytes memory args = ba2cbor(argN);
729         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
730     }
731 
732     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
733         bytes[] memory dynargs = new bytes[](1);
734         dynargs[0] = args[0];
735         return oraclize_query(datasource, dynargs);
736     }
737 
738     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
739         bytes[] memory dynargs = new bytes[](1);
740         dynargs[0] = args[0];
741         return oraclize_query(timestamp, datasource, dynargs);
742     }
743 
744     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
745         bytes[] memory dynargs = new bytes[](1);
746         dynargs[0] = args[0];
747         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
748     }
749 
750     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
751         bytes[] memory dynargs = new bytes[](1);
752         dynargs[0] = args[0];
753         return oraclize_query(datasource, dynargs, gaslimit);
754     }
755 
756     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
757         bytes[] memory dynargs = new bytes[](2);
758         dynargs[0] = args[0];
759         dynargs[1] = args[1];
760         return oraclize_query(datasource, dynargs);
761     }
762 
763     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
764         bytes[] memory dynargs = new bytes[](2);
765         dynargs[0] = args[0];
766         dynargs[1] = args[1];
767         return oraclize_query(timestamp, datasource, dynargs);
768     }
769 
770     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
771         bytes[] memory dynargs = new bytes[](2);
772         dynargs[0] = args[0];
773         dynargs[1] = args[1];
774         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
775     }
776 
777     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
778         bytes[] memory dynargs = new bytes[](2);
779         dynargs[0] = args[0];
780         dynargs[1] = args[1];
781         return oraclize_query(datasource, dynargs, gaslimit);
782     }
783 
784     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
785         bytes[] memory dynargs = new bytes[](3);
786         dynargs[0] = args[0];
787         dynargs[1] = args[1];
788         dynargs[2] = args[2];
789         return oraclize_query(datasource, dynargs);
790     }
791 
792     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
793         bytes[] memory dynargs = new bytes[](3);
794         dynargs[0] = args[0];
795         dynargs[1] = args[1];
796         dynargs[2] = args[2];
797         return oraclize_query(timestamp, datasource, dynargs);
798     }
799 
800     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
801         bytes[] memory dynargs = new bytes[](3);
802         dynargs[0] = args[0];
803         dynargs[1] = args[1];
804         dynargs[2] = args[2];
805         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
806     }
807 
808     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
809         bytes[] memory dynargs = new bytes[](3);
810         dynargs[0] = args[0];
811         dynargs[1] = args[1];
812         dynargs[2] = args[2];
813         return oraclize_query(datasource, dynargs, gaslimit);
814     }
815 
816     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
817         bytes[] memory dynargs = new bytes[](4);
818         dynargs[0] = args[0];
819         dynargs[1] = args[1];
820         dynargs[2] = args[2];
821         dynargs[3] = args[3];
822         return oraclize_query(datasource, dynargs);
823     }
824 
825     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
826         bytes[] memory dynargs = new bytes[](4);
827         dynargs[0] = args[0];
828         dynargs[1] = args[1];
829         dynargs[2] = args[2];
830         dynargs[3] = args[3];
831         return oraclize_query(timestamp, datasource, dynargs);
832     }
833 
834     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
835         bytes[] memory dynargs = new bytes[](4);
836         dynargs[0] = args[0];
837         dynargs[1] = args[1];
838         dynargs[2] = args[2];
839         dynargs[3] = args[3];
840         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
841     }
842 
843     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
844         bytes[] memory dynargs = new bytes[](4);
845         dynargs[0] = args[0];
846         dynargs[1] = args[1];
847         dynargs[2] = args[2];
848         dynargs[3] = args[3];
849         return oraclize_query(datasource, dynargs, gaslimit);
850     }
851 
852     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
853         bytes[] memory dynargs = new bytes[](5);
854         dynargs[0] = args[0];
855         dynargs[1] = args[1];
856         dynargs[2] = args[2];
857         dynargs[3] = args[3];
858         dynargs[4] = args[4];
859         return oraclize_query(datasource, dynargs);
860     }
861 
862     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
863         bytes[] memory dynargs = new bytes[](5);
864         dynargs[0] = args[0];
865         dynargs[1] = args[1];
866         dynargs[2] = args[2];
867         dynargs[3] = args[3];
868         dynargs[4] = args[4];
869         return oraclize_query(timestamp, datasource, dynargs);
870     }
871 
872     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
873         bytes[] memory dynargs = new bytes[](5);
874         dynargs[0] = args[0];
875         dynargs[1] = args[1];
876         dynargs[2] = args[2];
877         dynargs[3] = args[3];
878         dynargs[4] = args[4];
879         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
880     }
881 
882     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
883         bytes[] memory dynargs = new bytes[](5);
884         dynargs[0] = args[0];
885         dynargs[1] = args[1];
886         dynargs[2] = args[2];
887         dynargs[3] = args[3];
888         dynargs[4] = args[4];
889         return oraclize_query(datasource, dynargs, gaslimit);
890     }
891 
892     function oraclize_cbAddress() oraclizeAPI internal returns (address){
893         return oraclize.cbAddress();
894     }
895 
896     function oraclize_setProof(byte proofP) oraclizeAPI internal {
897         return oraclize.setProofType(proofP);
898     }
899 
900     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
901         return oraclize.setCustomGasPrice(gasPrice);
902     }
903 
904     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
905         return oraclize.setConfig(config);
906     }
907 
908     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
909         return oraclize.randomDS_getSessionPubKeyHash();
910     }
911 
912     function getCodeSize(address _addr) constant internal returns (uint _size) {
913         assembly {
914             _size := extcodesize(_addr)
915         }
916     }
917 
918     function parseAddr(string _a) internal returns (address){
919         bytes memory tmp = bytes(_a);
920         uint160 iaddr = 0;
921         uint160 b1;
922         uint160 b2;
923         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
924             iaddr *= 256;
925             b1 = uint160(tmp[i]);
926             b2 = uint160(tmp[i + 1]);
927             if ((b1 >= 97) && (b1 <= 102)) b1 -= 87;
928             else if ((b1 >= 65) && (b1 <= 70)) b1 -= 55;
929             else if ((b1 >= 48) && (b1 <= 57)) b1 -= 48;
930             if ((b2 >= 97) && (b2 <= 102)) b2 -= 87;
931             else if ((b2 >= 65) && (b2 <= 70)) b2 -= 55;
932             else if ((b2 >= 48) && (b2 <= 57)) b2 -= 48;
933             iaddr += (b1 * 16 + b2);
934         }
935         return address(iaddr);
936     }
937 
938     function strCompare(string _a, string _b) internal returns (int) {
939         bytes memory a = bytes(_a);
940         bytes memory b = bytes(_b);
941         uint minLength = a.length;
942         if (b.length < minLength) minLength = b.length;
943         for (uint i = 0; i < minLength; i ++)
944             if (a[i] < b[i])
945                 return - 1;
946             else if (a[i] > b[i])
947                 return 1;
948         if (a.length < b.length)
949             return - 1;
950         else if (a.length > b.length)
951             return 1;
952         else
953             return 0;
954     }
955 
956     function indexOf(string _haystack, string _needle) internal returns (int) {
957         bytes memory h = bytes(_haystack);
958         bytes memory n = bytes(_needle);
959         if (h.length < 1 || n.length < 1 || (n.length > h.length))
960             return - 1;
961         else if (h.length > (2 ** 128 - 1))
962             return - 1;
963         else
964         {
965             uint subindex = 0;
966             for (uint i = 0; i < h.length; i ++)
967             {
968                 if (h[i] == n[0])
969                 {
970                     subindex = 1;
971                     while (subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
972                     {
973                         subindex++;
974                     }
975                     if (subindex == n.length)
976                         return int(i);
977                 }
978             }
979             return - 1;
980         }
981     }
982 
983     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
984         bytes memory _ba = bytes(_a);
985         bytes memory _bb = bytes(_b);
986         bytes memory _bc = bytes(_c);
987         bytes memory _bd = bytes(_d);
988         bytes memory _be = bytes(_e);
989         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
990         bytes memory babcde = bytes(abcde);
991         uint k = 0;
992         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
993         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
994         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
995         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
996         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
997         return string(babcde);
998     }
999 
1000     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
1001         return strConcat(_a, _b, _c, _d, "");
1002     }
1003 
1004     function strConcat(string _a, string _b, string _c) internal returns (string) {
1005         return strConcat(_a, _b, _c, "", "");
1006     }
1007 
1008     function strConcat(string _a, string _b) internal returns (string) {
1009         return strConcat(_a, _b, "", "", "");
1010     }
1011 
1012     // parseInt
1013     function parseInt(string _a) internal returns (uint) {
1014         return parseInt(_a, 0);
1015     }
1016 
1017     // parseInt(parseFloat*10^_b)
1018     function parseInt(string _a, uint _b) internal returns (uint) {
1019         bytes memory bresult = bytes(_a);
1020         uint mint = 0;
1021         bool decimals = false;
1022         for (uint i = 0; i < bresult.length; i++) {
1023             if ((bresult[i] >= 48) && (bresult[i] <= 57)) {
1024                 if (decimals) {
1025                     if (_b == 0) break;
1026                     else _b--;
1027                 }
1028                 mint *= 10;
1029                 mint += uint(bresult[i]) - 48;
1030             } else if (bresult[i] == 46) decimals = true;
1031         }
1032         if (_b > 0) mint *= 10 ** _b;
1033         return mint;
1034     }
1035 
1036     function uint2str(uint i) internal returns (string){
1037         if (i == 0) return "0";
1038         uint j = i;
1039         uint len;
1040         while (j != 0) {
1041             len++;
1042             j /= 10;
1043         }
1044         bytes memory bstr = new bytes(len);
1045         uint k = len - 1;
1046         while (i != 0) {
1047             bstr[k--] = byte(48 + i % 10);
1048             i /= 10;
1049         }
1050         return string(bstr);
1051     }
1052 
1053     using CBOR for Buffer.buffer;
1054     function stra2cbor(string[] arr) internal constant returns (bytes) {
1055         Buffer.buffer memory buf;
1056         Buffer.init(buf, 1024);
1057         buf.startArray();
1058         for (uint i = 0; i < arr.length; i++) {
1059             buf.encodeString(arr[i]);
1060         }
1061         buf.endSequence();
1062         return buf.buf;
1063     }
1064 
1065     function ba2cbor(bytes[] arr) internal constant returns (bytes) {
1066         Buffer.buffer memory buf;
1067         Buffer.init(buf, 1024);
1068         buf.startArray();
1069         for (uint i = 0; i < arr.length; i++) {
1070             buf.encodeBytes(arr[i]);
1071         }
1072         buf.endSequence();
1073         return buf.buf;
1074     }
1075 
1076     string oraclize_network_name;
1077 
1078     function oraclize_setNetworkName(string _network_name) internal {
1079         oraclize_network_name = _network_name;
1080     }
1081 
1082     function oraclize_getNetworkName() internal returns (string) {
1083         return oraclize_network_name;
1084     }
1085 
1086     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1087         if ((_nbytes == 0) || (_nbytes > 32)) throw;
1088         // Convert from seconds to ledger timer ticks
1089         _delay *= 10;
1090         bytes memory nbytes = new bytes(1);
1091         nbytes[0] = byte(_nbytes);
1092         bytes memory unonce = new bytes(32);
1093         bytes memory sessionKeyHash = new bytes(32);
1094         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1095         assembly {
1096             mstore(unonce, 0x20)
1097             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1098             mstore(sessionKeyHash, 0x20)
1099             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1100         }
1101         bytes memory delay = new bytes(32);
1102         assembly {
1103             mstore(add(delay, 0x20), _delay)
1104         }
1105 
1106         bytes memory delay_bytes8 = new bytes(8);
1107         copyBytes(delay, 24, 8, delay_bytes8, 0);
1108 
1109         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1110         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1111 
1112         bytes memory delay_bytes8_left = new bytes(8);
1113 
1114         assembly {
1115             let x := mload(add(delay_bytes8, 0x20))
1116             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1117             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1118             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1119             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1120             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1121             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1122             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1123             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1124 
1125         }
1126 
1127         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1128         return queryId;
1129     }
1130 
1131     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1132         oraclize_randomDS_args[queryId] = commitment;
1133     }
1134 
1135     mapping(bytes32 => bytes32) oraclize_randomDS_args;
1136     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
1137 
1138     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1139         bool sigok;
1140         address signer;
1141 
1142         bytes32 sigr;
1143         bytes32 sigs;
1144 
1145         bytes memory sigr_ = new bytes(32);
1146         uint offset = 4 + (uint(dersig[3]) - 0x20);
1147         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1148         bytes memory sigs_ = new bytes(32);
1149         offset += 32 + 2;
1150         sigs_ = copyBytes(dersig, offset + (uint(dersig[offset - 1]) - 0x20), 32, sigs_, 0);
1151 
1152         assembly {
1153             sigr := mload(add(sigr_, 32))
1154             sigs := mload(add(sigs_, 32))
1155         }
1156 
1157 
1158         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1159         if (address(sha3(pubkey)) == signer) return true;
1160         else {
1161             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1162             return (address(sha3(pubkey)) == signer);
1163         }
1164     }
1165 
1166     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1167         bool sigok;
1168 
1169         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1170         bytes memory sig2 = new bytes(uint(proof[sig2offset + 1]) + 2);
1171         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1172 
1173         bytes memory appkey1_pubkey = new bytes(64);
1174         copyBytes(proof, 3 + 1, 64, appkey1_pubkey, 0);
1175 
1176         bytes memory tosign2 = new bytes(1 + 65 + 32);
1177         tosign2[0] = 1;
1178         //role
1179         copyBytes(proof, sig2offset - 65, 65, tosign2, 1);
1180         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1181         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1182         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1183 
1184         if (sigok == false) return false;
1185 
1186 
1187         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1188         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1189 
1190         bytes memory tosign3 = new bytes(1 + 65);
1191         tosign3[0] = 0xFE;
1192         copyBytes(proof, 3, 65, tosign3, 1);
1193 
1194         bytes memory sig3 = new bytes(uint(proof[3 + 65 + 1]) + 2);
1195         copyBytes(proof, 3 + 65, sig3.length, sig3, 0);
1196 
1197         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1198 
1199         return sigok;
1200     }
1201 
1202     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1203         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1204         if ((_proof[0] != "L") || (_proof[1] != "P") || (_proof[2] != 1)) throw;
1205 
1206         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1207         if (proofVerified == false) throw;
1208 
1209         _;
1210     }
1211 
1212     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1213         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1214         if ((_proof[0] != "L") || (_proof[1] != "P") || (_proof[2] != 1)) return 1;
1215 
1216         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1217         if (proofVerified == false) return 2;
1218 
1219         return 0;
1220     }
1221 
1222     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
1223         bool match_ = true;
1224 
1225         if (prefix.length != n_random_bytes) throw;
1226 
1227         for (uint256 i = 0; i < n_random_bytes; i++) {
1228             if (content[i] != prefix[i]) match_ = false;
1229         }
1230 
1231         return match_;
1232     }
1233 
1234     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1235 
1236         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1237         uint ledgerProofLength = 3 + 65 + (uint(proof[3 + 65 + 1]) + 2) + 32;
1238         bytes memory keyhash = new bytes(32);
1239         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1240         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
1241 
1242         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1]) + 2);
1243         copyBytes(proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1244 
1245         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1246         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength + 32 + 8]))) return false;
1247 
1248         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1249         // This is to verify that the computed args match with the ones specified in the query.
1250         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1251         copyBytes(proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1252 
1253         bytes memory sessionPubkey = new bytes(64);
1254         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1255         copyBytes(proof, sig2offset - 64, 64, sessionPubkey, 0);
1256 
1257         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1258         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)) {//unonce, nbytes and sessionKeyHash match
1259             delete oraclize_randomDS_args[queryId];
1260         } else return false;
1261 
1262 
1263         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1264         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1265         copyBytes(proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1266         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1267 
1268         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1269         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false) {
1270             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1271         }
1272 
1273         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1274     }
1275 
1276 
1277     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1278     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1279         uint minLength = length + toOffset;
1280 
1281         if (to.length < minLength) {
1282             // Buffer too small
1283             throw;
1284             // Should be a better way?
1285         }
1286 
1287         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1288         uint i = 32 + fromOffset;
1289         uint j = 32 + toOffset;
1290 
1291         while (i < (32 + fromOffset + length)) {
1292             assembly {
1293                 let tmp := mload(add(from, i))
1294                 mstore(add(to, j), tmp)
1295             }
1296             i += 32;
1297             j += 32;
1298         }
1299 
1300         return to;
1301     }
1302 
1303     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1304     // Duplicate Solidity's ecrecover, but catching the CALL return value
1305     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1306         // We do our own memory management here. Solidity uses memory offset
1307         // 0x40 to store the current end of memory. We write past it (as
1308         // writes are memory extensions), but don't update the offset so
1309         // Solidity will reuse it. The memory used here is only needed for
1310         // this context.
1311 
1312         // FIXME: inline assembly can't access return values
1313         bool ret;
1314         address addr;
1315 
1316         assembly {
1317             let size := mload(0x40)
1318             mstore(size, hash)
1319             mstore(add(size, 32), v)
1320             mstore(add(size, 64), r)
1321             mstore(add(size, 96), s)
1322 
1323         // NOTE: we can reuse the request memory because we deal with
1324         //       the return code
1325             ret := call(3000, 1, 0, size, 128, size, 32)
1326             addr := mload(size)
1327         }
1328 
1329         return (ret, addr);
1330     }
1331 
1332     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1333     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1334         bytes32 r;
1335         bytes32 s;
1336         uint8 v;
1337 
1338         if (sig.length != 65)
1339             return (false, 0);
1340 
1341         // The signature format is a compact form of:
1342         //   {bytes32 r}{bytes32 s}{uint8 v}
1343         // Compact means, uint8 is not padded to 32 bytes.
1344         assembly {
1345             r := mload(add(sig, 32))
1346             s := mload(add(sig, 64))
1347 
1348         // Here we are loading the last 32 bytes. We exploit the fact that
1349         // 'mload' will pad with zeroes if we overread.
1350         // There is no 'mload8' to do this, but that would be nicer.
1351             v := byte(0, mload(add(sig, 96)))
1352 
1353         // Alternative solution:
1354         // 'byte' is not working due to the Solidity parser, so lets
1355         // use the second best option, 'and'
1356         // v := and(mload(add(sig, 65)), 255)
1357         }
1358 
1359         // albeit non-transactional signatures are not specified by the YP, one would expect it
1360         // to match the YP range of [27, 28]
1361         //
1362         // geth uses [0, 1] and some clients have followed. This might change, see:
1363         //  https://github.com/ethereum/go-ethereum/issues/2053
1364         if (v < 27)
1365             v += 27;
1366 
1367         if (v != 27 && v != 28)
1368             return (false, 0);
1369 
1370         return safer_ecrecover(hash, v, r, s);
1371     }
1372 
1373 }
1374 // end of ORACLIZE_API
1375 
1376 // =============== Lucky Strike ========================================================================================
1377 
1378 contract LuckyStrikeTokens {
1379 
1380     function totalSupply() constant returns (uint256);
1381 
1382     function balanceOf(address _owner) constant returns (uint256);
1383 
1384     function mint(address to, uint256 value, uint256 _invest) public returns (bool);
1385 
1386     function tokenSaleIsRunning() public returns (bool);
1387 }
1388 
1389 contract LuckyStrike is usingOraclize {
1390 
1391     /* --- see: https://github.com/oraclize/ethereum-examples/blob/master/solidity/random-datasource/randomExample.sol */
1392 
1393     // see: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
1394     using SafeMath for uint256;
1395     using SafeMath for uint16;
1396 
1397     address public owner;
1398     address admin;
1399     //
1400     uint256 public ticketPriceInWei = 20000000000000000; // 0.02 ETH
1401     uint256 public tokenPriceInWei = 150000000000000; // 0.00015 ETH
1402     uint16 public maxTicketsToBuyInOneTransaction = 333; //
1403     //
1404     uint256 public eventsCounter;
1405     //
1406     mapping(uint256 => address) public theLotteryTicket;
1407     uint256 public ticketsTotal;
1408     //
1409     address public kingOfTheHill;
1410     uint256 public kingOfTheHillTicketsNumber;
1411 
1412     mapping(address => uint256) public reward;
1413 
1414     event rewardPaid(uint256 indexed eventsCounter, address indexed to, uint256 sum); //
1415     function getReward() public {
1416         require(reward[msg.sender] > 0);
1417         msg.sender.transfer(reward[msg.sender]);
1418 
1419         eventsCounter = eventsCounter + 1;
1420         rewardPaid(eventsCounter, msg.sender, reward[msg.sender]);
1421         sum[affiliateRewards] = sum[affiliateRewards].sub(reward[msg.sender]);
1422         reward[msg.sender] = 0;
1423     }
1424 
1425     // gas for oraclize_query:
1426     uint256 public oraclizeCallbackGas = 230000; // amount of gas we want Oraclize to set for the callback function
1427 
1428     // > to be able to read it from browser after updating
1429     uint256 public currentOraclizeGasPrice; //
1430     function oraclizeGetPrice() public returns (uint256){
1431         currentOraclizeGasPrice = oraclize_getPrice("random", oraclizeCallbackGas);
1432         return currentOraclizeGasPrice;
1433     }
1434 
1435     function getContractsWeiBalance() public view returns (uint256) {
1436         return this.balance;
1437     }
1438 
1439     // mapping to keep sums on accounts (including 'income'):
1440     mapping(uint8 => uint256) public sum;
1441     uint8 public instantGame = 0;
1442     uint8 public dailyJackpot = 1;
1443     uint8 public weeklyJackpot = 2;
1444     uint8 public monthlyJackpot = 3;
1445     uint8 public yearlyJackpot = 4;
1446     uint8 public income = 5;
1447     uint8 public marketingFund = 6;
1448     uint8 public affiliateRewards = 7; //
1449     uint8 public playersBets = 8;
1450 
1451     mapping(uint8 => uint256) public period; // in seconds
1452 
1453     event withdrawalFromMarketingFund(uint256 indexed eventsCounter, uint256 sum); //
1454     function withdrawFromMarketingFund() public {
1455         require(msg.sender == owner);
1456         owner.transfer(sum[marketingFund]);
1457 
1458         eventsCounter = eventsCounter + 1;
1459         withdrawalFromMarketingFund(eventsCounter, sum[marketingFund]);
1460 
1461         sum[marketingFund] = 0;
1462     }
1463 
1464     mapping(uint8 => bool) public jackpotPlayIsRunning; //
1465 
1466     // allocation:
1467     mapping(uint8 => uint16) public rate;
1468 
1469     // JackpotCounters (starts with 0):
1470     mapping(uint8 => uint256) jackpotCounter;
1471     mapping(uint8 => uint256) public lastJackpotTime;  // unix time
1472 
1473     // uint256 public lastDividendsPaymentTime; // unix time, for 'income' only
1474 
1475     address public luckyStrikeTokensContractAddress;
1476 
1477     LuckyStrikeTokens public luckyStrikeTokens;
1478 
1479     /* --- constructor */
1480 
1481     // (!) requires acces to Oraclize contract
1482     // will fail on JavaScript VM
1483     function LuckyStrike() public {
1484 
1485         admin = msg.sender;
1486 
1487         // sets the Ledger authenticity proof in the constructor
1488         oraclize_setProof(proofType_Ledger);
1489 
1490     }
1491 
1492     function init(address _luckyStrikeTokensContractAddress) public payable {
1493 
1494         require(ticketsTotal == 0);
1495         require(msg.sender == admin);
1496 
1497         owner = 0x0bBAb60c495413c870F8cABF09436BeE9fe3542F;
1498 
1499         require(msg.value / ticketPriceInWei >= 1);
1500 
1501         luckyStrikeTokensContractAddress = _luckyStrikeTokensContractAddress;
1502 
1503         // should be updated every time we use it
1504         // now we just get value to show in webapp
1505         oraclizeGetPrice();
1506 
1507         kingOfTheHill = msg.sender;
1508         ticketsTotal = kingOfTheHillTicketsNumber = 1;
1509         theLotteryTicket[1] = kingOfTheHill;
1510 
1511         // initialize jackpot periods
1512         // see: https://solidity.readthedocs.io/en/v0.4.20/units-and-global-variables.html#time-units
1513         period[dailyJackpot] = 1 days;
1514         period[weeklyJackpot] = 1 weeks;
1515         period[monthlyJackpot] = 30 days;
1516         period[yearlyJackpot] = 1 years;
1517         // for testing:
1518         //        period[dailyJackpot] = 60 * 1;
1519         //        period[weeklyJackpot] = 60 * 3;
1520         //        period[monthlyJackpot] = 60 * 5;
1521         //        period[yearlyJackpot] = 60 * 7;
1522 
1523         // set last block numbers and timestamps for jackpots:
1524         for (uint8 i = dailyJackpot; i <= yearlyJackpot; i++) {
1525             lastJackpotTime[i] = block.timestamp;
1526         }
1527 
1528         rate[instantGame] = 8500;
1529         rate[dailyJackpot] = 500;
1530         rate[weeklyJackpot] = 300;
1531         rate[monthlyJackpot] = 100;
1532         rate[yearlyJackpot] = 100;
1533         rate[income] = 500;
1534 
1535         luckyStrikeTokens = LuckyStrikeTokens(luckyStrikeTokensContractAddress);
1536 
1537     }
1538 
1539     /* --- Tokens contract information   */
1540     function tokensTotalSupply() public view returns (uint256) {
1541         return luckyStrikeTokens.totalSupply();
1542     }
1543 
1544     function tokensBalanceOf(address acc) public view returns (uint256){
1545         return luckyStrikeTokens.balanceOf(acc);
1546     }
1547 
1548     function weiInTokensContract() public view returns (uint256){
1549         return luckyStrikeTokens.balance;
1550     }
1551 
1552     function tokenSaleIsRunning() public view returns (bool) {
1553         return luckyStrikeTokens.tokenSaleIsRunning();
1554     }
1555 
1556     event AllocationAdjusted(
1557         uint256 indexed eventsCounter,
1558         address by,
1559         uint16 instantGame,
1560         uint16 dailyJackpot,
1561         uint16 weeklyJackpot,
1562         uint16 monthlyJackpot,
1563         uint16 yearlyJackpot,
1564         uint16 income);
1565 
1566     function adjustAllocation(
1567         uint16 _instantGame,
1568         uint16 _dailyJackpot,
1569         uint16 _weeklyJackpot,
1570         uint16 _monthlyJackpot,
1571         uint16 _yearlyJackpot,
1572         uint16 _income) public {
1573 
1574         // only owner !!!
1575         require(msg.sender == owner);
1576 
1577         rate[instantGame] = _instantGame;
1578         rate[dailyJackpot] = _dailyJackpot;
1579         rate[weeklyJackpot] = _weeklyJackpot;
1580         rate[monthlyJackpot] = _monthlyJackpot;
1581         rate[yearlyJackpot] = _yearlyJackpot;
1582         rate[income] = _income;
1583 
1584         // check if provided %% amount to 10,000
1585         uint16 _sum = 0;
1586         for (uint8 i = instantGame; i <= income; i++) {
1587             _sum = _sum + rate[i];
1588         }
1589 
1590         require(_sum == 10000);
1591 
1592         eventsCounter = eventsCounter + 1;
1593         AllocationAdjusted(
1594             eventsCounter,
1595             msg.sender,
1596             rate[instantGame],
1597             rate[dailyJackpot],
1598             rate[weeklyJackpot],
1599             rate[monthlyJackpot],
1600             rate[yearlyJackpot],
1601             rate[income]
1602         );
1603 
1604     } // end of adjustAllocation
1605 
1606     // this function calculates jackpots/income allocation and returns prize for the instant game
1607     uint256 sumAllocatedInWeiCounter;
1608 
1609     event SumAllocatedInWei(
1610         uint256 indexed eventsCounter,
1611         uint256 indexed sumAllocatedInWeiCounter,
1612         address betOf,
1613         uint256 bet, // 0
1614         uint256 dailyJackpot, // 1
1615         uint256 weeklyJackpot, // 2;
1616         uint256 monthlyJackpot, // 3;
1617         uint256 yearlyJackpot, // 4;
1618         uint256 income,
1619         uint256 affiliateRewards,
1620         uint256 payToWinner
1621     );
1622 
1623     function allocateSum(uint256 _sum, address loser) private returns (uint256) {
1624 
1625         // for event
1626         // https://solidity.readthedocs.io/en/v0.4.24/types.html#allocating-memory-arrays
1627         uint256[] memory jackpotsSumAllocation = new uint256[](5);
1628 
1629         // jackpots:
1630         for (uint8 i = dailyJackpot; i <= yearlyJackpot; i++) {
1631             uint256 sumToAdd = _sum * rate[i] / 10000;
1632             sum[i] = sum[i].add(sumToAdd);
1633             // for event:
1634             jackpotsSumAllocation[i] = sumToAdd;
1635         }
1636 
1637         // income before affiliate reward subtraction:
1638         uint256 incomeSum = (_sum * rate[income]) / 10000;
1639         // referrer reward:
1640         uint256 refSum = 0;
1641         if (referrer[loser] != address(0)) {
1642 
1643             address referrerAddress = referrer[loser];
1644 
1645             refSum = incomeSum / 2;
1646             incomeSum = incomeSum.sub(refSum);
1647 
1648             reward[referrerAddress] = reward[referrerAddress].add(refSum);
1649 
1650             sum[affiliateRewards] = sum[affiliateRewards].add(refSum);
1651         }
1652 
1653         sum[income] = sum[income].add(incomeSum);
1654 
1655         uint256 payToWinner = _sum * rate[instantGame] / 10000;
1656 
1657         eventsCounter = eventsCounter + 1;
1658         sumAllocatedInWeiCounter = sumAllocatedInWeiCounter + 1;
1659         SumAllocatedInWei(
1660             eventsCounter,
1661             sumAllocatedInWeiCounter,
1662             loser,
1663             _sum,
1664             jackpotsSumAllocation[1], //  dailyJackpot
1665             jackpotsSumAllocation[2], // weeklyJackpot
1666             jackpotsSumAllocation[3], // monthlyJackpot
1667             jackpotsSumAllocation[4], //  yearlyJackpot
1668             incomeSum,
1669             refSum,
1670             payToWinner
1671         );
1672 
1673         return payToWinner;
1674     }
1675 
1676     /* -------------- GAME: --------------*/
1677 
1678     /* --- Instant Game ------- */
1679     uint256 public instantGameCounter; // id's of the instant games
1680     //
1681     // to allow only one game for the given address simultaneously:
1682     mapping(address => bool) public instantGameIsRunning;
1683     //
1684     mapping(address => uint256) public lastInstantGameBlockNumber; // for address
1685     mapping(address => uint256) public lastInstantGameTicketsNumber; // for address
1686 
1687     // first step for player is to make a bet:
1688     uint256 public betCounter;
1689 
1690     event BetPlaced(
1691         uint256 indexed eventsCounter,
1692         uint256 indexed betCounter,
1693         address indexed player,
1694         uint256 betInWei,
1695         uint256 ticketsBefore,
1696         uint256 newTickets
1697     );
1698 
1699     function placeABetInternal(uint value) private {
1700 
1701         require(msg.sender != kingOfTheHill);
1702 
1703         // only one game allowed for the address at the given moment:
1704         require(!instantGameIsRunning[msg.sender]);
1705 
1706         // number of new tickets to create;
1707         uint256 newTickets = value / ticketPriceInWei;
1708 
1709         eventsCounter = eventsCounter + 1;
1710         betCounter = betCounter + 1;
1711         BetPlaced(eventsCounter, betCounter, msg.sender, value, ticketsTotal, newTickets);
1712 
1713         uint256 playerBetToPlace = newTickets.mul(ticketPriceInWei);
1714 
1715         sum[playersBets] = sum[playersBets].add(playerBetToPlace);
1716 
1717         require(newTickets > 0 && newTickets <= maxTicketsToBuyInOneTransaction);
1718 
1719         uint256 newTicketsTotal = ticketsTotal.add(newTickets);
1720         // new tickets included in jackpot games instantly:
1721         for (uint256 i = ticketsTotal + 1; i <= newTicketsTotal; i++) {
1722             theLotteryTicket[i] = msg.sender;
1723         }
1724 
1725         ticketsTotal = newTicketsTotal;
1726 
1727         lastInstantGameTicketsNumber[msg.sender] = newTickets;
1728         instantGameIsRunning[msg.sender] = true;
1729         lastInstantGameBlockNumber[msg.sender] = block.number;
1730     }
1731 
1732     function placeABet() public payable {
1733         placeABetInternal(msg.value);
1734     }
1735 
1736     mapping(address => address) public referrer;
1737 
1738     function placeABetWithReferrer(address _referrer) public payable {
1739         /* referrer: */
1740         if (referrer[msg.sender] == 0x0000000000000000000000000000000000000000) {
1741             referrer[msg.sender] = _referrer;
1742         }
1743         placeABetInternal(msg.value);
1744     }
1745 
1746     event Investment(
1747         uint256 indexed eventsCounter, //.1
1748         address indexed by, //............2
1749         uint256 sum, //...................3
1750         uint256 sumToMarketingFund, //....4
1751         uint256 bet, //...................5
1752         uint256 tokens //.................6
1753     ); //
1754     function investAndPlay() public payable {
1755 
1756         // require( luckyStrikeTokens.tokenSaleIsRunning());
1757         // < we will check this in luckyStrikeTokens.mint method
1758 
1759         uint256 sumToMarketingFund = msg.value / 5;
1760 
1761         sum[marketingFund] = sum[marketingFund].add(sumToMarketingFund);
1762 
1763         uint256 bet = msg.value.sub(sumToMarketingFund);
1764 
1765         placeABetInternal(bet);
1766 
1767         // uint256 tokensToMint = msg.value / ticketPriceInWei;
1768         // uint256 tokensToMint = bet / tokenPriceInWei;
1769         uint256 tokensToMint = sumToMarketingFund / tokenPriceInWei;
1770 
1771         // require(bet / ticketPriceInWei > 0); // > makes more complicated
1772         luckyStrikeTokens.mint(msg.sender, tokensToMint, sumToMarketingFund);
1773 
1774         eventsCounter = eventsCounter + 1;
1775         Investment(
1776             eventsCounter, //......1
1777             msg.sender, //.........2
1778             msg.value, //..........3
1779             sumToMarketingFund, //.4
1780             bet, //................5
1781             tokensToMint //........6
1782         );
1783     }
1784 
1785     function investAndPlayWithReferrer(address _referrer) public payable {
1786         if (referrer[msg.sender] == 0x0000000000000000000000000000000000000000) {
1787             referrer[msg.sender] = _referrer;
1788         }
1789         investAndPlay();
1790     }
1791 
1792     /*
1793         function invest() public payable {
1794             //  require(luckyStrikeTokens.tokenSaleIsRunning());
1795             // < we will check this in luckyStrikeTokens.mint method
1796 
1797             sum[marketingFund] = sum[marketingFund].add(msg.value);
1798 
1799             uint256 tokensToMint = msg.value / ticketPriceInWei;
1800 
1801             // uint256 bonus = (tokensToMint / 100).mul(75);
1802             uint256 bonus1part = tokensToMint / 2;
1803             uint256 bonus2part = tokensToMint / 4;
1804             uint256 bonus = bonus1part.add(bonus2part);
1805 
1806             tokensToMint = tokensToMint.add(bonus);
1807 
1808             // require(bet / ticketPriceInWei > 0); // > makes more complicated
1809             luckyStrikeTokens.mint(
1810                 msg.sender,
1811                 tokensToMint,
1812                 msg.value // all sum > investment
1813             );
1814 
1815             eventsCounter = eventsCounter + 1;
1816             Investment(
1817                 eventsCounter, //..1
1818                 msg.sender, //.....2
1819                 msg.value, //......3
1820                 msg.value, //......4
1821                 0, //..............5 (bet)
1822                 tokensToMint //....6
1823             );
1824         }
1825 
1826         function investWithReferrer(address _referrer) public payable {
1827             if (referrer[msg.sender] == 0x0000000000000000000000000000000000000000) {
1828                 referrer[msg.sender] = _referrer;
1829             }
1830             invest();
1831         }
1832     */
1833 
1834     // second step in instant game:
1835     event InstantGameResult (
1836         uint256 indexed eventsCounter, //...0
1837         uint256 gameId, // .................1
1838         bool theBetPlayed, //...............2
1839         address indexed challenger, //......3
1840         address indexed king, //............4
1841         uint256 kingsTicketsNumber, //......5
1842         address winner, //..................6
1843         uint256 prize, //...................7
1844         uint256 ticketsInTheInstantGame, //.8
1845         uint256 randomNumber, //............9
1846         address triggeredBy //..............10
1847     );
1848 
1849     function play(address player) public {
1850 
1851         require(instantGameIsRunning[player]);
1852         require(lastInstantGameBlockNumber[player] < block.number);
1853         // block number with the bet must be no more than 255 blocks before the current block
1854         // or we get 0 as blockhash
1855 
1856         instantGameCounter = instantGameCounter + 1;
1857 
1858         uint256 playerBet = lastInstantGameTicketsNumber[player].mul(ticketPriceInWei);
1859         // in any case playerBet should be subtracted sum[playerBets]
1860         sum[playersBets] = sum[playersBets].sub(playerBet);
1861 
1862         // TODO: recheck this >
1863         if (block.number - lastInstantGameBlockNumber[player] > 250) {
1864             eventsCounter = eventsCounter + 1;
1865             InstantGameResult(
1866                 eventsCounter,
1867                 instantGameCounter,
1868                 false,
1869                 player,
1870                 address(0), // kingOfTheHill, // oldKingOfTheHill,
1871                 0,
1872                 address(0), // winner,
1873                 0, // prize,
1874                 0, // lastInstantGameTicketsNumber[player], // ticketsInTheInstantGame,
1875                 0, // randomNumber,
1876                 msg.sender // triggeredBy
1877             );
1878 
1879             // player.transfer(playerBet);
1880             sum[income] = sum[income].add(playerBet);
1881 
1882             lastInstantGameTicketsNumber[player] = 0;
1883             instantGameIsRunning[player] = false;
1884             return;
1885         }
1886 
1887         address oldKingOfTheHill = kingOfTheHill;
1888         uint256 oldKingOfTheHillTicketsNumber = kingOfTheHillTicketsNumber;
1889         uint256 ticketsInTheInstantGame = kingOfTheHillTicketsNumber.add(lastInstantGameTicketsNumber[player]);
1890 
1891         // TODO: recheck this
1892         bytes32 seed = keccak256(
1893             block.blockhash(lastInstantGameBlockNumber[player]) // bytes32
1894         );
1895 
1896         uint256 seedToNumber = uint256(seed);
1897 
1898         uint256 randomNumber = seedToNumber % ticketsInTheInstantGame;
1899 
1900         // 0 never plays, and ticketsInTheInstantGame can not be returned by the function above
1901         if (randomNumber == 0) {
1902             randomNumber = ticketsInTheInstantGame;
1903         }
1904 
1905         uint256 prize;
1906         address winner;
1907         address loser;
1908 
1909         if (randomNumber > kingOfTheHillTicketsNumber) {// challenger ('player') wins
1910             winner = player;
1911             loser = kingOfTheHill;
1912 
1913             // new kingOfTheHill:
1914             kingOfTheHill = player;
1915             kingOfTheHillTicketsNumber = lastInstantGameTicketsNumber[player];
1916         } else {// kingOfTheHill wins
1917             winner = kingOfTheHill;
1918             loser = player;
1919         }
1920 
1921         // prize = allocateSum(playerBet, loser, winner);
1922         prize = allocateSum(playerBet, loser);
1923 
1924         instantGameIsRunning[player] = false;
1925 
1926         // pay prize to the winner
1927         winner.transfer(prize);
1928 
1929         eventsCounter = eventsCounter + 1;
1930         InstantGameResult(
1931             eventsCounter,
1932             instantGameCounter,
1933             true,
1934             player,
1935             oldKingOfTheHill,
1936             oldKingOfTheHillTicketsNumber,
1937             winner,
1938         // playerBet,
1939             prize,
1940             ticketsInTheInstantGame,
1941             randomNumber,
1942             msg.sender
1943         );
1944 
1945     }
1946 
1947     // convenience function;
1948     function playMyInstantGame() public {
1949         play(msg.sender);
1950     }
1951 
1952     /* ----------- Jackpots: ------------ */
1953 
1954     function requestRandomFromOraclize() private returns (bytes32 oraclizeQueryId)  {
1955 
1956         require(msg.value >= oraclizeGetPrice());
1957         // < to pay to oraclize
1958 
1959         // call Oraclize
1960         // uint N :
1961         // number nRandomBytes between 1 and 32, which is the number of random bytes to be returned to the application.
1962         // see: http://www.oraclize.it/papers/random_datasource-rev1.pdf
1963         uint256 N = 32;
1964         // number of seconds to wait before the execution takes place
1965         uint delay = 0;
1966         // this function internally generates the correct oraclize_query and returns its queryId
1967         oraclizeQueryId = oraclize_newRandomDSQuery(delay, N, oraclizeCallbackGas);
1968 
1969         // playJackpotEvent(msg.sender, msg.value, tx.gasprice, oraclizeQueryId);
1970         return oraclizeQueryId;
1971 
1972     }
1973 
1974     // reminder (this defined above):
1975     // mapping(uint8 => uint256) public period; // in seconds
1976     // mapping(uint8 => uint256) public lastJackpotTime;  // unix time
1977 
1978     mapping(bytes32 => uint8) public jackpot;
1979 
1980     event JackpotPlayStarted(
1981         uint256 indexed eventsCounter,
1982         uint8 indexed jackpotType,
1983         address startedBy,
1984         bytes32 oraclizeQueryId
1985     );//
1986     // uint8 jackpotType
1987     function startJackpotPlay(uint8 jackpotType) public payable {
1988 
1989         require(msg.value >= oraclizeGetPrice());
1990 
1991         require(jackpotType >= 1 && jackpotType <= 4);
1992         require(!jackpotPlayIsRunning[jackpotType]);
1993         require(
1994         // block.timestamp (uint): current block timestamp as seconds since unix epoch
1995             block.timestamp >= lastJackpotTime[jackpotType].add(period[jackpotType])
1996         );
1997 
1998         bytes32 oraclizeQueryId = requestRandomFromOraclize();
1999         jackpot[oraclizeQueryId] = jackpotType;
2000 
2001         jackpotPlayIsRunning[jackpotType] = true;
2002 
2003         eventsCounter = eventsCounter + 1;
2004         JackpotPlayStarted(eventsCounter, jackpotType, msg.sender, oraclizeQueryId);
2005     }
2006 
2007     uint256 public allJackpotsCounter;
2008 
2009     event JackpotResult(
2010         uint256 indexed eventsCounter,
2011         uint256 allJackpotsCounter,
2012         uint8 indexed jackpotType,
2013         uint256 jackpotIdNumber,
2014         uint256 prize,
2015         address indexed winner,
2016         uint256 randomNumberSeed,
2017         uint256 randomNumber,
2018         uint256 ticketsTotal
2019     );
2020 
2021     // the callback function is called by Oraclize when the result is ready
2022     // the oraclize_randomDS_proofVerify modifier prevents an invalid proof to execute this function code:
2023     // the proof validity is fully verified on-chain
2024     function __callback(bytes32 _queryId, string _result, bytes _proof) public {
2025 
2026         require(msg.sender == oraclize_cbAddress());
2027 
2028         if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0) {
2029             // the proof verification has failed, do we need to take any action here? (depends on the use case)
2030             revert();
2031         } else {
2032 
2033             // find jackpot for this _queryId:
2034 
2035             uint8 jackpotType = jackpot[_queryId];
2036 
2037             require(jackpotPlayIsRunning[jackpotType]);
2038 
2039             jackpotCounter[jackpotType] = jackpotCounter[jackpotType] + 1;
2040 
2041             // select jackpot winner:
2042 
2043             bytes32 hashOfTheRandomString = keccak256(_result);
2044 
2045             uint256 randomNumberSeed = uint256(hashOfTheRandomString);
2046 
2047             uint256 randomNumber = randomNumberSeed % ticketsTotal;
2048 
2049             // there is no ticket # 0, and above function can not return number equivalent to 'ticketsTotal'
2050             if (randomNumber == 0) {
2051                 randomNumber = ticketsTotal;
2052             }
2053 
2054             address winner = theLotteryTicket[randomNumber];
2055 
2056             // transfer jackpot sum to the winner
2057 
2058             winner.transfer(sum[jackpotType]);
2059 
2060             // emit event:
2061             eventsCounter = eventsCounter + 1;
2062             allJackpotsCounter = allJackpotsCounter + 1;
2063             JackpotResult(
2064                 eventsCounter,
2065                 allJackpotsCounter,
2066                 jackpotType,
2067                 jackpotCounter[jackpotType],
2068                 sum[jackpotType],
2069                 winner,
2070                 randomNumberSeed,
2071                 randomNumber,
2072                 ticketsTotal
2073             );
2074 
2075             // update information for this jackpot:
2076 
2077             sum[jackpotType] = 0;
2078 
2079             lastJackpotTime[jackpotType] = block.timestamp;
2080 
2081             jackpotPlayIsRunning[jackpotType] = false;
2082 
2083         }
2084     } // end of function __callback
2085 
2086     event DividendsSentToTokensContract(uint256 indexed eventsCounter, uint256 sum, address indexed triggeredBy);
2087     // can be called by any address:
2088     function payDividends() public returns (bool success){
2089 
2090         luckyStrikeTokensContractAddress.transfer(sum[income]);
2091 
2092         eventsCounter = eventsCounter + 1;
2093         DividendsSentToTokensContract(eventsCounter, sum[income], msg.sender);
2094 
2095         sum[income] = 0;
2096 
2097         return true;
2098     }
2099 
2100 }