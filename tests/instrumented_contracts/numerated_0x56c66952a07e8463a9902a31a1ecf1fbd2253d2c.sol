1 pragma solidity 0.4.20;
2 
3 // we use solidity solidity 0.4.20 to work with oraclize (http://www.oraclize.it)
4 // solidity versions > 0.4.20 are not supported by oraclize
5 
6 /*
7 Lucky Strike smart contracts version: 1.0
8 */
9 
10 /*
11 Legal Disclaimer
12 This smart contract is intended for entertainment purposes only. Crypto currency gambling is illegal in many jurisdictions and users should consult legal counsel regarding the legal status of cryptocurrency gambling in their jurisdictions.
13 Since developers of this smart contract are unable to determine which jurisdiction you reside in, you must check current laws including your local and state laws to find out if cryptocurrency gambling is legal in your area.
14 If you reside in a location where gambling or crypto currency transactions over the internet or otherwise is illegal, please do not use this smart contract. You must be 21 years of age to use this smart contract even if it is legal to do so in your location.
15 Users in the U.S. should be aware that the U.S. government has taken the position that it is illegal for online casinos and sportsbooks to accept wagers from persons in the U.S.
16 If you reside in the U.S. or intend to promote this smart contract to U.S. residents please do not interact with this smart contract in any way and leave this smart contract  immediately.
17 */
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  * source: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
23  */
24 library SafeMath {
25 
26     /**
27     * @dev Multiplies two numbers, throws on overflow.
28     */
29     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
30         if (a == 0) {
31             return 0;
32         }
33         c = a * b;
34         assert(c / a == b);
35         return c;
36     }
37 
38     /**
39     * @dev Integer division of two numbers, truncating the quotient.
40     */
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         // assert(b > 0); // Solidity automatically throws when dividing by 0
43         // uint256 c = a / b;
44         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45         return a / b;
46     }
47 
48     /**
49     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
50     */
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         assert(b <= a);
53         return a - b;
54     }
55 
56     /**
57     * @dev Adds two numbers, throws on overflow.
58     */
59     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
60         c = a + b;
61         assert(c >= a);
62         return c;
63     }
64 }
65 
66 // ORACLIZE_API
67 /*
68 Copyright (c) 2015-2016 Oraclize SRL
69 Copyright (c) 2016 Oraclize LTD
70 
71 
72 
73 Permission is hereby granted, free of charge, to any person obtaining a copy
74 of this software and associated documentation files (the "Software"), to deal
75 in the Software without restriction, including without limitation the rights
76 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
77 copies of the Software, and to permit persons to whom the Software is
78 furnished to do so, subject to the following conditions:
79 
80 
81 
82 The above copyright notice and this permission notice shall be included in
83 all copies or substantial portions of the Software.
84 
85 
86 
87 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
88 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
89 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
90 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
91 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
92 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
93 THE SOFTWARE.
94 */
95 
96 //pragma solidity >=0.4.1 <=0.4.20;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
97 
98 contract OraclizeI {
99     address public cbAddress;
100 
101     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
102 
103     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
104 
105     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
106 
107     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
108 
109     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
110 
111     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
112 
113     function getPrice(string _datasource) returns (uint _dsprice);
114 
115     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
116 
117     function useCoupon(string _coupon);
118 
119     function setProofType(byte _proofType);
120 
121     function setConfig(bytes32 _config);
122 
123     function setCustomGasPrice(uint _gasPrice);
124 
125     function randomDS_getSessionPubKeyHash() returns (bytes32);
126 }
127 
128 contract OraclizeAddrResolverI {
129     function getAddress() returns (address _addr);
130 }
131 
132 /*
133 Begin solidity-cborutils
134 
135 https://github.com/smartcontractkit/solidity-cborutils
136 
137 MIT License
138 
139 Copyright (c) 2018 SmartContract ChainLink, Ltd.
140 
141 Permission is hereby granted, free of charge, to any person obtaining a copy
142 of this software and associated documentation files (the "Software"), to deal
143 in the Software without restriction, including without limitation the rights
144 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
145 copies of the Software, and to permit persons to whom the Software is
146 furnished to do so, subject to the following conditions:
147 
148 The above copyright notice and this permission notice shall be included in all
149 copies or substantial portions of the Software.
150 
151 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
152 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
153 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
154 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
155 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
156 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
157 SOFTWARE.
158  */
159 
160 library Buffer {
161     struct buffer {
162         bytes buf;
163         uint capacity;
164     }
165 
166     function init(buffer memory buf, uint capacity) internal constant {
167         if (capacity % 32 != 0) capacity += 32 - (capacity % 32);
168         // Allocate space for the buffer data
169         buf.capacity = capacity;
170         assembly {
171             let ptr := mload(0x40)
172             mstore(buf, ptr)
173             mstore(0x40, add(ptr, capacity))
174         }
175     }
176 
177     function resize(buffer memory buf, uint capacity) private constant {
178         bytes memory oldbuf = buf.buf;
179         init(buf, capacity);
180         append(buf, oldbuf);
181     }
182 
183     function max(uint a, uint b) private constant returns (uint) {
184         if (a > b) {
185             return a;
186         }
187         return b;
188     }
189 
190     /**
191      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
192      *      would exceed the capacity of the buffer.
193      * @param buf The buffer to append to.
194      * @param data The data to append.
195      * @return The original buffer.
196      */
197     function append(buffer memory buf, bytes data) internal constant returns (buffer memory) {
198         if (data.length + buf.buf.length > buf.capacity) {
199             resize(buf, max(buf.capacity, data.length) * 2);
200         }
201 
202         uint dest;
203         uint src;
204         uint len = data.length;
205         assembly {
206         // Memory address of the buffer data
207             let bufptr := mload(buf)
208         // Length of existing buffer data
209             let buflen := mload(bufptr)
210         // Start address = buffer address + buffer length + sizeof(buffer length)
211             dest := add(add(bufptr, buflen), 32)
212         // Update buffer length
213             mstore(bufptr, add(buflen, mload(data)))
214             src := add(data, 32)
215         }
216 
217         // Copy word-length chunks while possible
218         for (; len >= 32; len -= 32) {
219             assembly {
220                 mstore(dest, mload(src))
221             }
222             dest += 32;
223             src += 32;
224         }
225 
226         // Copy remaining bytes
227         uint mask = 256 ** (32 - len) - 1;
228         assembly {
229             let srcpart := and(mload(src), not(mask))
230             let destpart := and(mload(dest), mask)
231             mstore(dest, or(destpart, srcpart))
232         }
233 
234         return buf;
235     }
236 
237     /**
238      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
239      * exceed the capacity of the buffer.
240      * @param buf The buffer to append to.
241      * @param data The data to append.
242      * @return The original buffer.
243      */
244     function append(buffer memory buf, uint8 data) internal constant {
245         if (buf.buf.length + 1 > buf.capacity) {
246             resize(buf, buf.capacity * 2);
247         }
248 
249         assembly {
250         // Memory address of the buffer data
251             let bufptr := mload(buf)
252         // Length of existing buffer data
253             let buflen := mload(bufptr)
254         // Address = buffer address + buffer length + sizeof(buffer length)
255             let dest := add(add(bufptr, buflen), 32)
256             mstore8(dest, data)
257         // Update buffer length
258             mstore(bufptr, add(buflen, 1))
259         }
260     }
261 
262     /**
263      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
264      * exceed the capacity of the buffer.
265      * @param buf The buffer to append to.
266      * @param data The data to append.
267      * @return The original buffer.
268      */
269     function appendInt(buffer memory buf, uint data, uint len) internal constant returns (buffer memory) {
270         if (len + buf.buf.length > buf.capacity) {
271             resize(buf, max(buf.capacity, len) * 2);
272         }
273 
274         uint mask = 256 ** len - 1;
275         assembly {
276         // Memory address of the buffer data
277             let bufptr := mload(buf)
278         // Length of existing buffer data
279             let buflen := mload(bufptr)
280         // Address = buffer address + buffer length + sizeof(buffer length) + len
281             let dest := add(add(bufptr, buflen), len)
282             mstore(dest, or(and(mload(dest), not(mask)), data))
283         // Update buffer length
284             mstore(bufptr, add(buflen, len))
285         }
286         return buf;
287     }
288 }
289 
290 library CBOR {
291     using Buffer for Buffer.buffer;
292 
293     uint8 private constant MAJOR_TYPE_INT = 0;
294     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
295     uint8 private constant MAJOR_TYPE_BYTES = 2;
296     uint8 private constant MAJOR_TYPE_STRING = 3;
297     uint8 private constant MAJOR_TYPE_ARRAY = 4;
298     uint8 private constant MAJOR_TYPE_MAP = 5;
299     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
300 
301     function shl8(uint8 x, uint8 y) private constant returns (uint8) {
302         return x * (2 ** y);
303     }
304 
305     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private constant {
306         if (value <= 23) {
307             buf.append(uint8(shl8(major, 5) | value));
308         } else if (value <= 0xFF) {
309             buf.append(uint8(shl8(major, 5) | 24));
310             buf.appendInt(value, 1);
311         } else if (value <= 0xFFFF) {
312             buf.append(uint8(shl8(major, 5) | 25));
313             buf.appendInt(value, 2);
314         } else if (value <= 0xFFFFFFFF) {
315             buf.append(uint8(shl8(major, 5) | 26));
316             buf.appendInt(value, 4);
317         } else if (value <= 0xFFFFFFFFFFFFFFFF) {
318             buf.append(uint8(shl8(major, 5) | 27));
319             buf.appendInt(value, 8);
320         }
321     }
322 
323     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private constant {
324         buf.append(uint8(shl8(major, 5) | 31));
325     }
326 
327     function encodeUInt(Buffer.buffer memory buf, uint value) internal constant {
328         encodeType(buf, MAJOR_TYPE_INT, value);
329     }
330 
331     function encodeInt(Buffer.buffer memory buf, int value) internal constant {
332         if (value >= 0) {
333             encodeType(buf, MAJOR_TYPE_INT, uint(value));
334         } else {
335             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(- 1 - value));
336         }
337     }
338 
339     function encodeBytes(Buffer.buffer memory buf, bytes value) internal constant {
340         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
341         buf.append(value);
342     }
343 
344     function encodeString(Buffer.buffer memory buf, string value) internal constant {
345         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
346         buf.append(bytes(value));
347     }
348 
349     function startArray(Buffer.buffer memory buf) internal constant {
350         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
351     }
352 
353     function startMap(Buffer.buffer memory buf) internal constant {
354         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
355     }
356 
357     function endSequence(Buffer.buffer memory buf) internal constant {
358         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
359     }
360 }
361 
362 /*
363 End solidity-cborutils
364  */
365 
366 contract usingOraclize {
367     uint constant day = 60 * 60 * 24;
368     uint constant week = 60 * 60 * 24 * 7;
369     uint constant month = 60 * 60 * 24 * 30;
370     byte constant proofType_NONE = 0x00;
371     byte constant proofType_TLSNotary = 0x10;
372     byte constant proofType_Android = 0x20;
373     byte constant proofType_Ledger = 0x30;
374     byte constant proofType_Native = 0xF0;
375     byte constant proofStorage_IPFS = 0x01;
376     uint8 constant networkID_auto = 0;
377     uint8 constant networkID_mainnet = 1;
378     uint8 constant networkID_testnet = 2;
379     uint8 constant networkID_morden = 2;
380     uint8 constant networkID_consensys = 161;
381 
382     OraclizeAddrResolverI OAR;
383 
384     OraclizeI oraclize;
385     modifier oraclizeAPI {
386         if ((address(OAR) == 0) || (getCodeSize(address(OAR)) == 0))
387             oraclize_setNetwork(networkID_auto);
388 
389         if (address(oraclize) != OAR.getAddress())
390             oraclize = OraclizeI(OAR.getAddress());
391 
392         _;
393     }
394     modifier coupon(string code){
395         oraclize = OraclizeI(OAR.getAddress());
396         oraclize.useCoupon(code);
397         _;
398     }
399 
400     function oraclize_setNetwork(uint8 networkID) internal returns (bool){
401         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) {//mainnet
402             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
403             oraclize_setNetworkName("eth_mainnet");
404             return true;
405         }
406         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) {//ropsten testnet
407             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
408             oraclize_setNetworkName("eth_ropsten3");
409             return true;
410         }
411         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) {//kovan testnet
412             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
413             oraclize_setNetworkName("eth_kovan");
414             return true;
415         }
416         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) {//rinkeby testnet
417             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
418             oraclize_setNetworkName("eth_rinkeby");
419             return true;
420         }
421         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) {//ethereum-bridge
422             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
423             return true;
424         }
425         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) {//ether.camp ide
426             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
427             return true;
428         }
429         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) {//browser-solidity
430             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
431             return true;
432         }
433         return false;
434     }
435 
436     function __callback(bytes32 myid, string result) {
437         __callback(myid, result, new bytes(0));
438     }
439 
440     function __callback(bytes32 myid, string result, bytes proof) {
441     }
442 
443     function oraclize_useCoupon(string code) oraclizeAPI internal {
444         oraclize.useCoupon(code);
445     }
446 
447     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
448         return oraclize.getPrice(datasource);
449     }
450 
451     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
452         return oraclize.getPrice(datasource, gaslimit);
453     }
454 
455     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
456         uint price = oraclize.getPrice(datasource);
457         if (price > 1 ether + tx.gasprice * 200000) return 0;
458         // unexpectedly high price
459         return oraclize.query.value(price)(0, datasource, arg);
460     }
461 
462     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
463         uint price = oraclize.getPrice(datasource);
464         if (price > 1 ether + tx.gasprice * 200000) return 0;
465         // unexpectedly high price
466         return oraclize.query.value(price)(timestamp, datasource, arg);
467     }
468 
469     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
470         uint price = oraclize.getPrice(datasource, gaslimit);
471         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
472         // unexpectedly high price
473         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
474     }
475 
476     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
477         uint price = oraclize.getPrice(datasource, gaslimit);
478         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
479         // unexpectedly high price
480         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
481     }
482 
483     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
484         uint price = oraclize.getPrice(datasource);
485         if (price > 1 ether + tx.gasprice * 200000) return 0;
486         // unexpectedly high price
487         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
488     }
489 
490     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
491         uint price = oraclize.getPrice(datasource);
492         if (price > 1 ether + tx.gasprice * 200000) return 0;
493         // unexpectedly high price
494         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
495     }
496 
497     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
498         uint price = oraclize.getPrice(datasource, gaslimit);
499         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
500         // unexpectedly high price
501         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
502     }
503 
504     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
505         uint price = oraclize.getPrice(datasource, gaslimit);
506         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
507         // unexpectedly high price
508         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
509     }
510 
511     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
512         uint price = oraclize.getPrice(datasource);
513         if (price > 1 ether + tx.gasprice * 200000) return 0;
514         // unexpectedly high price
515         bytes memory args = stra2cbor(argN);
516         return oraclize.queryN.value(price)(0, datasource, args);
517     }
518 
519     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
520         uint price = oraclize.getPrice(datasource);
521         if (price > 1 ether + tx.gasprice * 200000) return 0;
522         // unexpectedly high price
523         bytes memory args = stra2cbor(argN);
524         return oraclize.queryN.value(price)(timestamp, datasource, args);
525     }
526 
527     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
528         uint price = oraclize.getPrice(datasource, gaslimit);
529         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
530         // unexpectedly high price
531         bytes memory args = stra2cbor(argN);
532         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
533     }
534 
535     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
536         uint price = oraclize.getPrice(datasource, gaslimit);
537         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
538         // unexpectedly high price
539         bytes memory args = stra2cbor(argN);
540         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
541     }
542 
543     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
544         string[] memory dynargs = new string[](1);
545         dynargs[0] = args[0];
546         return oraclize_query(datasource, dynargs);
547     }
548 
549     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
550         string[] memory dynargs = new string[](1);
551         dynargs[0] = args[0];
552         return oraclize_query(timestamp, datasource, dynargs);
553     }
554 
555     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
556         string[] memory dynargs = new string[](1);
557         dynargs[0] = args[0];
558         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
559     }
560 
561     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
562         string[] memory dynargs = new string[](1);
563         dynargs[0] = args[0];
564         return oraclize_query(datasource, dynargs, gaslimit);
565     }
566 
567     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
568         string[] memory dynargs = new string[](2);
569         dynargs[0] = args[0];
570         dynargs[1] = args[1];
571         return oraclize_query(datasource, dynargs);
572     }
573 
574     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
575         string[] memory dynargs = new string[](2);
576         dynargs[0] = args[0];
577         dynargs[1] = args[1];
578         return oraclize_query(timestamp, datasource, dynargs);
579     }
580 
581     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
582         string[] memory dynargs = new string[](2);
583         dynargs[0] = args[0];
584         dynargs[1] = args[1];
585         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
586     }
587 
588     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
589         string[] memory dynargs = new string[](2);
590         dynargs[0] = args[0];
591         dynargs[1] = args[1];
592         return oraclize_query(datasource, dynargs, gaslimit);
593     }
594 
595     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
596         string[] memory dynargs = new string[](3);
597         dynargs[0] = args[0];
598         dynargs[1] = args[1];
599         dynargs[2] = args[2];
600         return oraclize_query(datasource, dynargs);
601     }
602 
603     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
604         string[] memory dynargs = new string[](3);
605         dynargs[0] = args[0];
606         dynargs[1] = args[1];
607         dynargs[2] = args[2];
608         return oraclize_query(timestamp, datasource, dynargs);
609     }
610 
611     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
612         string[] memory dynargs = new string[](3);
613         dynargs[0] = args[0];
614         dynargs[1] = args[1];
615         dynargs[2] = args[2];
616         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
617     }
618 
619     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
620         string[] memory dynargs = new string[](3);
621         dynargs[0] = args[0];
622         dynargs[1] = args[1];
623         dynargs[2] = args[2];
624         return oraclize_query(datasource, dynargs, gaslimit);
625     }
626 
627     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
628         string[] memory dynargs = new string[](4);
629         dynargs[0] = args[0];
630         dynargs[1] = args[1];
631         dynargs[2] = args[2];
632         dynargs[3] = args[3];
633         return oraclize_query(datasource, dynargs);
634     }
635 
636     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
637         string[] memory dynargs = new string[](4);
638         dynargs[0] = args[0];
639         dynargs[1] = args[1];
640         dynargs[2] = args[2];
641         dynargs[3] = args[3];
642         return oraclize_query(timestamp, datasource, dynargs);
643     }
644 
645     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
646         string[] memory dynargs = new string[](4);
647         dynargs[0] = args[0];
648         dynargs[1] = args[1];
649         dynargs[2] = args[2];
650         dynargs[3] = args[3];
651         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
652     }
653 
654     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
655         string[] memory dynargs = new string[](4);
656         dynargs[0] = args[0];
657         dynargs[1] = args[1];
658         dynargs[2] = args[2];
659         dynargs[3] = args[3];
660         return oraclize_query(datasource, dynargs, gaslimit);
661     }
662 
663     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
664         string[] memory dynargs = new string[](5);
665         dynargs[0] = args[0];
666         dynargs[1] = args[1];
667         dynargs[2] = args[2];
668         dynargs[3] = args[3];
669         dynargs[4] = args[4];
670         return oraclize_query(datasource, dynargs);
671     }
672 
673     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
674         string[] memory dynargs = new string[](5);
675         dynargs[0] = args[0];
676         dynargs[1] = args[1];
677         dynargs[2] = args[2];
678         dynargs[3] = args[3];
679         dynargs[4] = args[4];
680         return oraclize_query(timestamp, datasource, dynargs);
681     }
682 
683     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
684         string[] memory dynargs = new string[](5);
685         dynargs[0] = args[0];
686         dynargs[1] = args[1];
687         dynargs[2] = args[2];
688         dynargs[3] = args[3];
689         dynargs[4] = args[4];
690         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
691     }
692 
693     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
694         string[] memory dynargs = new string[](5);
695         dynargs[0] = args[0];
696         dynargs[1] = args[1];
697         dynargs[2] = args[2];
698         dynargs[3] = args[3];
699         dynargs[4] = args[4];
700         return oraclize_query(datasource, dynargs, gaslimit);
701     }
702 
703     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
704         uint price = oraclize.getPrice(datasource);
705         if (price > 1 ether + tx.gasprice * 200000) return 0;
706         // unexpectedly high price
707         bytes memory args = ba2cbor(argN);
708         return oraclize.queryN.value(price)(0, datasource, args);
709     }
710 
711     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
712         uint price = oraclize.getPrice(datasource);
713         if (price > 1 ether + tx.gasprice * 200000) return 0;
714         // unexpectedly high price
715         bytes memory args = ba2cbor(argN);
716         return oraclize.queryN.value(price)(timestamp, datasource, args);
717     }
718 
719     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
720         uint price = oraclize.getPrice(datasource, gaslimit);
721         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
722         // unexpectedly high price
723         bytes memory args = ba2cbor(argN);
724         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
725     }
726 
727     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
728         uint price = oraclize.getPrice(datasource, gaslimit);
729         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
730         // unexpectedly high price
731         bytes memory args = ba2cbor(argN);
732         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
733     }
734 
735     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
736         bytes[] memory dynargs = new bytes[](1);
737         dynargs[0] = args[0];
738         return oraclize_query(datasource, dynargs);
739     }
740 
741     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
742         bytes[] memory dynargs = new bytes[](1);
743         dynargs[0] = args[0];
744         return oraclize_query(timestamp, datasource, dynargs);
745     }
746 
747     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
748         bytes[] memory dynargs = new bytes[](1);
749         dynargs[0] = args[0];
750         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
751     }
752 
753     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
754         bytes[] memory dynargs = new bytes[](1);
755         dynargs[0] = args[0];
756         return oraclize_query(datasource, dynargs, gaslimit);
757     }
758 
759     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
760         bytes[] memory dynargs = new bytes[](2);
761         dynargs[0] = args[0];
762         dynargs[1] = args[1];
763         return oraclize_query(datasource, dynargs);
764     }
765 
766     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
767         bytes[] memory dynargs = new bytes[](2);
768         dynargs[0] = args[0];
769         dynargs[1] = args[1];
770         return oraclize_query(timestamp, datasource, dynargs);
771     }
772 
773     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
774         bytes[] memory dynargs = new bytes[](2);
775         dynargs[0] = args[0];
776         dynargs[1] = args[1];
777         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
778     }
779 
780     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
781         bytes[] memory dynargs = new bytes[](2);
782         dynargs[0] = args[0];
783         dynargs[1] = args[1];
784         return oraclize_query(datasource, dynargs, gaslimit);
785     }
786 
787     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
788         bytes[] memory dynargs = new bytes[](3);
789         dynargs[0] = args[0];
790         dynargs[1] = args[1];
791         dynargs[2] = args[2];
792         return oraclize_query(datasource, dynargs);
793     }
794 
795     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
796         bytes[] memory dynargs = new bytes[](3);
797         dynargs[0] = args[0];
798         dynargs[1] = args[1];
799         dynargs[2] = args[2];
800         return oraclize_query(timestamp, datasource, dynargs);
801     }
802 
803     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
804         bytes[] memory dynargs = new bytes[](3);
805         dynargs[0] = args[0];
806         dynargs[1] = args[1];
807         dynargs[2] = args[2];
808         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
809     }
810 
811     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
812         bytes[] memory dynargs = new bytes[](3);
813         dynargs[0] = args[0];
814         dynargs[1] = args[1];
815         dynargs[2] = args[2];
816         return oraclize_query(datasource, dynargs, gaslimit);
817     }
818 
819     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
820         bytes[] memory dynargs = new bytes[](4);
821         dynargs[0] = args[0];
822         dynargs[1] = args[1];
823         dynargs[2] = args[2];
824         dynargs[3] = args[3];
825         return oraclize_query(datasource, dynargs);
826     }
827 
828     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
829         bytes[] memory dynargs = new bytes[](4);
830         dynargs[0] = args[0];
831         dynargs[1] = args[1];
832         dynargs[2] = args[2];
833         dynargs[3] = args[3];
834         return oraclize_query(timestamp, datasource, dynargs);
835     }
836 
837     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
838         bytes[] memory dynargs = new bytes[](4);
839         dynargs[0] = args[0];
840         dynargs[1] = args[1];
841         dynargs[2] = args[2];
842         dynargs[3] = args[3];
843         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
844     }
845 
846     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
847         bytes[] memory dynargs = new bytes[](4);
848         dynargs[0] = args[0];
849         dynargs[1] = args[1];
850         dynargs[2] = args[2];
851         dynargs[3] = args[3];
852         return oraclize_query(datasource, dynargs, gaslimit);
853     }
854 
855     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
856         bytes[] memory dynargs = new bytes[](5);
857         dynargs[0] = args[0];
858         dynargs[1] = args[1];
859         dynargs[2] = args[2];
860         dynargs[3] = args[3];
861         dynargs[4] = args[4];
862         return oraclize_query(datasource, dynargs);
863     }
864 
865     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
866         bytes[] memory dynargs = new bytes[](5);
867         dynargs[0] = args[0];
868         dynargs[1] = args[1];
869         dynargs[2] = args[2];
870         dynargs[3] = args[3];
871         dynargs[4] = args[4];
872         return oraclize_query(timestamp, datasource, dynargs);
873     }
874 
875     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
876         bytes[] memory dynargs = new bytes[](5);
877         dynargs[0] = args[0];
878         dynargs[1] = args[1];
879         dynargs[2] = args[2];
880         dynargs[3] = args[3];
881         dynargs[4] = args[4];
882         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
883     }
884 
885     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
886         bytes[] memory dynargs = new bytes[](5);
887         dynargs[0] = args[0];
888         dynargs[1] = args[1];
889         dynargs[2] = args[2];
890         dynargs[3] = args[3];
891         dynargs[4] = args[4];
892         return oraclize_query(datasource, dynargs, gaslimit);
893     }
894 
895     function oraclize_cbAddress() oraclizeAPI internal returns (address){
896         return oraclize.cbAddress();
897     }
898 
899     function oraclize_setProof(byte proofP) oraclizeAPI internal {
900         return oraclize.setProofType(proofP);
901     }
902 
903     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
904         return oraclize.setCustomGasPrice(gasPrice);
905     }
906 
907     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
908         return oraclize.setConfig(config);
909     }
910 
911     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
912         return oraclize.randomDS_getSessionPubKeyHash();
913     }
914 
915     function getCodeSize(address _addr) constant internal returns (uint _size) {
916         assembly {
917             _size := extcodesize(_addr)
918         }
919     }
920 
921     function parseAddr(string _a) internal returns (address){
922         bytes memory tmp = bytes(_a);
923         uint160 iaddr = 0;
924         uint160 b1;
925         uint160 b2;
926         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
927             iaddr *= 256;
928             b1 = uint160(tmp[i]);
929             b2 = uint160(tmp[i + 1]);
930             if ((b1 >= 97) && (b1 <= 102)) b1 -= 87;
931             else if ((b1 >= 65) && (b1 <= 70)) b1 -= 55;
932             else if ((b1 >= 48) && (b1 <= 57)) b1 -= 48;
933             if ((b2 >= 97) && (b2 <= 102)) b2 -= 87;
934             else if ((b2 >= 65) && (b2 <= 70)) b2 -= 55;
935             else if ((b2 >= 48) && (b2 <= 57)) b2 -= 48;
936             iaddr += (b1 * 16 + b2);
937         }
938         return address(iaddr);
939     }
940 
941     function strCompare(string _a, string _b) internal returns (int) {
942         bytes memory a = bytes(_a);
943         bytes memory b = bytes(_b);
944         uint minLength = a.length;
945         if (b.length < minLength) minLength = b.length;
946         for (uint i = 0; i < minLength; i ++)
947             if (a[i] < b[i])
948                 return - 1;
949             else if (a[i] > b[i])
950                 return 1;
951         if (a.length < b.length)
952             return - 1;
953         else if (a.length > b.length)
954             return 1;
955         else
956             return 0;
957     }
958 
959     function indexOf(string _haystack, string _needle) internal returns (int) {
960         bytes memory h = bytes(_haystack);
961         bytes memory n = bytes(_needle);
962         if (h.length < 1 || n.length < 1 || (n.length > h.length))
963             return - 1;
964         else if (h.length > (2 ** 128 - 1))
965             return - 1;
966         else
967         {
968             uint subindex = 0;
969             for (uint i = 0; i < h.length; i ++)
970             {
971                 if (h[i] == n[0])
972                 {
973                     subindex = 1;
974                     while (subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
975                     {
976                         subindex++;
977                     }
978                     if (subindex == n.length)
979                         return int(i);
980                 }
981             }
982             return - 1;
983         }
984     }
985 
986     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
987         bytes memory _ba = bytes(_a);
988         bytes memory _bb = bytes(_b);
989         bytes memory _bc = bytes(_c);
990         bytes memory _bd = bytes(_d);
991         bytes memory _be = bytes(_e);
992         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
993         bytes memory babcde = bytes(abcde);
994         uint k = 0;
995         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
996         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
997         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
998         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
999         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1000         return string(babcde);
1001     }
1002 
1003     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
1004         return strConcat(_a, _b, _c, _d, "");
1005     }
1006 
1007     function strConcat(string _a, string _b, string _c) internal returns (string) {
1008         return strConcat(_a, _b, _c, "", "");
1009     }
1010 
1011     function strConcat(string _a, string _b) internal returns (string) {
1012         return strConcat(_a, _b, "", "", "");
1013     }
1014 
1015     // parseInt
1016     function parseInt(string _a) internal returns (uint) {
1017         return parseInt(_a, 0);
1018     }
1019 
1020     // parseInt(parseFloat*10^_b)
1021     function parseInt(string _a, uint _b) internal returns (uint) {
1022         bytes memory bresult = bytes(_a);
1023         uint mint = 0;
1024         bool decimals = false;
1025         for (uint i = 0; i < bresult.length; i++) {
1026             if ((bresult[i] >= 48) && (bresult[i] <= 57)) {
1027                 if (decimals) {
1028                     if (_b == 0) break;
1029                     else _b--;
1030                 }
1031                 mint *= 10;
1032                 mint += uint(bresult[i]) - 48;
1033             } else if (bresult[i] == 46) decimals = true;
1034         }
1035         if (_b > 0) mint *= 10 ** _b;
1036         return mint;
1037     }
1038 
1039     function uint2str(uint i) internal returns (string){
1040         if (i == 0) return "0";
1041         uint j = i;
1042         uint len;
1043         while (j != 0) {
1044             len++;
1045             j /= 10;
1046         }
1047         bytes memory bstr = new bytes(len);
1048         uint k = len - 1;
1049         while (i != 0) {
1050             bstr[k--] = byte(48 + i % 10);
1051             i /= 10;
1052         }
1053         return string(bstr);
1054     }
1055 
1056     using CBOR for Buffer.buffer;
1057     function stra2cbor(string[] arr) internal constant returns (bytes) {
1058         Buffer.buffer memory buf;
1059         Buffer.init(buf, 1024);
1060         buf.startArray();
1061         for (uint i = 0; i < arr.length; i++) {
1062             buf.encodeString(arr[i]);
1063         }
1064         buf.endSequence();
1065         return buf.buf;
1066     }
1067 
1068     function ba2cbor(bytes[] arr) internal constant returns (bytes) {
1069         Buffer.buffer memory buf;
1070         Buffer.init(buf, 1024);
1071         buf.startArray();
1072         for (uint i = 0; i < arr.length; i++) {
1073             buf.encodeBytes(arr[i]);
1074         }
1075         buf.endSequence();
1076         return buf.buf;
1077     }
1078 
1079     string oraclize_network_name;
1080 
1081     function oraclize_setNetworkName(string _network_name) internal {
1082         oraclize_network_name = _network_name;
1083     }
1084 
1085     function oraclize_getNetworkName() internal returns (string) {
1086         return oraclize_network_name;
1087     }
1088 
1089     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1090         if ((_nbytes == 0) || (_nbytes > 32)) throw;
1091         // Convert from seconds to ledger timer ticks
1092         _delay *= 10;
1093         bytes memory nbytes = new bytes(1);
1094         nbytes[0] = byte(_nbytes);
1095         bytes memory unonce = new bytes(32);
1096         bytes memory sessionKeyHash = new bytes(32);
1097         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1098         assembly {
1099             mstore(unonce, 0x20)
1100             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1101             mstore(sessionKeyHash, 0x20)
1102             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1103         }
1104         bytes memory delay = new bytes(32);
1105         assembly {
1106             mstore(add(delay, 0x20), _delay)
1107         }
1108 
1109         bytes memory delay_bytes8 = new bytes(8);
1110         copyBytes(delay, 24, 8, delay_bytes8, 0);
1111 
1112         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1113         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1114 
1115         bytes memory delay_bytes8_left = new bytes(8);
1116 
1117         assembly {
1118             let x := mload(add(delay_bytes8, 0x20))
1119             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1120             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1121             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1122             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1123             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1124             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1125             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1126             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1127 
1128         }
1129 
1130         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1131         return queryId;
1132     }
1133 
1134     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1135         oraclize_randomDS_args[queryId] = commitment;
1136     }
1137 
1138     mapping(bytes32 => bytes32) oraclize_randomDS_args;
1139     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
1140 
1141     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1142         bool sigok;
1143         address signer;
1144 
1145         bytes32 sigr;
1146         bytes32 sigs;
1147 
1148         bytes memory sigr_ = new bytes(32);
1149         uint offset = 4 + (uint(dersig[3]) - 0x20);
1150         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1151         bytes memory sigs_ = new bytes(32);
1152         offset += 32 + 2;
1153         sigs_ = copyBytes(dersig, offset + (uint(dersig[offset - 1]) - 0x20), 32, sigs_, 0);
1154 
1155         assembly {
1156             sigr := mload(add(sigr_, 32))
1157             sigs := mload(add(sigs_, 32))
1158         }
1159 
1160 
1161         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1162         if (address(sha3(pubkey)) == signer) return true;
1163         else {
1164             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1165             return (address(sha3(pubkey)) == signer);
1166         }
1167     }
1168 
1169     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1170         bool sigok;
1171 
1172         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1173         bytes memory sig2 = new bytes(uint(proof[sig2offset + 1]) + 2);
1174         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1175 
1176         bytes memory appkey1_pubkey = new bytes(64);
1177         copyBytes(proof, 3 + 1, 64, appkey1_pubkey, 0);
1178 
1179         bytes memory tosign2 = new bytes(1 + 65 + 32);
1180         tosign2[0] = 1;
1181         //role
1182         copyBytes(proof, sig2offset - 65, 65, tosign2, 1);
1183         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1184         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1185         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1186 
1187         if (sigok == false) return false;
1188 
1189 
1190         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1191         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1192 
1193         bytes memory tosign3 = new bytes(1 + 65);
1194         tosign3[0] = 0xFE;
1195         copyBytes(proof, 3, 65, tosign3, 1);
1196 
1197         bytes memory sig3 = new bytes(uint(proof[3 + 65 + 1]) + 2);
1198         copyBytes(proof, 3 + 65, sig3.length, sig3, 0);
1199 
1200         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1201 
1202         return sigok;
1203     }
1204 
1205     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1206         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1207         if ((_proof[0] != "L") || (_proof[1] != "P") || (_proof[2] != 1)) throw;
1208 
1209         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1210         if (proofVerified == false) throw;
1211 
1212         _;
1213     }
1214 
1215     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1216         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1217         if ((_proof[0] != "L") || (_proof[1] != "P") || (_proof[2] != 1)) return 1;
1218 
1219         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1220         if (proofVerified == false) return 2;
1221 
1222         return 0;
1223     }
1224 
1225     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
1226         bool match_ = true;
1227 
1228         if (prefix.length != n_random_bytes) throw;
1229 
1230         for (uint256 i = 0; i < n_random_bytes; i++) {
1231             if (content[i] != prefix[i]) match_ = false;
1232         }
1233 
1234         return match_;
1235     }
1236 
1237     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1238 
1239         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1240         uint ledgerProofLength = 3 + 65 + (uint(proof[3 + 65 + 1]) + 2) + 32;
1241         bytes memory keyhash = new bytes(32);
1242         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1243         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
1244 
1245         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1]) + 2);
1246         copyBytes(proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1247 
1248         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1249         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength + 32 + 8]))) return false;
1250 
1251         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1252         // This is to verify that the computed args match with the ones specified in the query.
1253         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1254         copyBytes(proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1255 
1256         bytes memory sessionPubkey = new bytes(64);
1257         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1258         copyBytes(proof, sig2offset - 64, 64, sessionPubkey, 0);
1259 
1260         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1261         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)) {//unonce, nbytes and sessionKeyHash match
1262             delete oraclize_randomDS_args[queryId];
1263         } else return false;
1264 
1265 
1266         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1267         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1268         copyBytes(proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1269         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1270 
1271         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1272         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false) {
1273             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1274         }
1275 
1276         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1277     }
1278 
1279 
1280     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1281     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1282         uint minLength = length + toOffset;
1283 
1284         if (to.length < minLength) {
1285             // Buffer too small
1286             throw;
1287             // Should be a better way?
1288         }
1289 
1290         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1291         uint i = 32 + fromOffset;
1292         uint j = 32 + toOffset;
1293 
1294         while (i < (32 + fromOffset + length)) {
1295             assembly {
1296                 let tmp := mload(add(from, i))
1297                 mstore(add(to, j), tmp)
1298             }
1299             i += 32;
1300             j += 32;
1301         }
1302 
1303         return to;
1304     }
1305 
1306     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1307     // Duplicate Solidity's ecrecover, but catching the CALL return value
1308     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1309         // We do our own memory management here. Solidity uses memory offset
1310         // 0x40 to store the current end of memory. We write past it (as
1311         // writes are memory extensions), but don't update the offset so
1312         // Solidity will reuse it. The memory used here is only needed for
1313         // this context.
1314 
1315         // FIXME: inline assembly can't access return values
1316         bool ret;
1317         address addr;
1318 
1319         assembly {
1320             let size := mload(0x40)
1321             mstore(size, hash)
1322             mstore(add(size, 32), v)
1323             mstore(add(size, 64), r)
1324             mstore(add(size, 96), s)
1325 
1326         // NOTE: we can reuse the request memory because we deal with
1327         //       the return code
1328             ret := call(3000, 1, 0, size, 128, size, 32)
1329             addr := mload(size)
1330         }
1331 
1332         return (ret, addr);
1333     }
1334 
1335     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1336     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1337         bytes32 r;
1338         bytes32 s;
1339         uint8 v;
1340 
1341         if (sig.length != 65)
1342             return (false, 0);
1343 
1344         // The signature format is a compact form of:
1345         //   {bytes32 r}{bytes32 s}{uint8 v}
1346         // Compact means, uint8 is not padded to 32 bytes.
1347         assembly {
1348             r := mload(add(sig, 32))
1349             s := mload(add(sig, 64))
1350 
1351         // Here we are loading the last 32 bytes. We exploit the fact that
1352         // 'mload' will pad with zeroes if we overread.
1353         // There is no 'mload8' to do this, but that would be nicer.
1354             v := byte(0, mload(add(sig, 96)))
1355 
1356         // Alternative solution:
1357         // 'byte' is not working due to the Solidity parser, so lets
1358         // use the second best option, 'and'
1359         // v := and(mload(add(sig, 65)), 255)
1360         }
1361 
1362         // albeit non-transactional signatures are not specified by the YP, one would expect it
1363         // to match the YP range of [27, 28]
1364         //
1365         // geth uses [0, 1] and some clients have followed. This might change, see:
1366         //  https://github.com/ethereum/go-ethereum/issues/2053
1367         if (v < 27)
1368             v += 27;
1369 
1370         if (v != 27 && v != 28)
1371             return (false, 0);
1372 
1373         return safer_ecrecover(hash, v, r, s);
1374     }
1375 
1376 }
1377 // end of ORACLIZE_API
1378 
1379 // =============== Lucky Strike ========================================================================================
1380 
1381 contract LuckyStrikeTokens {
1382     function totalSupply() constant returns (uint256);
1383 
1384     function balanceOf(address _owner) constant returns (uint256);
1385 
1386     function mint(address to, uint256 value, uint256 _invest) public returns (bool);
1387 
1388     function tokenSaleIsRunning() public returns (bool);
1389 }
1390 
1391 contract LuckyStrike is usingOraclize {
1392 
1393     /* --- see: https://github.com/oraclize/ethereum-examples/blob/master/solidity/random-datasource/randomExample.sol */
1394 
1395     // see: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
1396     using SafeMath for uint256;
1397     using SafeMath for uint16;
1398 
1399     address public owner;
1400     address admin;
1401     //
1402     uint256 public ticketPriceInWei = 25000000000000000; // 0.025 ETH
1403     uint16 public maxTicketsToBuyInOneTransaction = 333; //
1404     //
1405     uint256 public eventsCounter;
1406     //
1407     mapping(uint256 => address) public theLotteryTicket;
1408     uint256 public ticketsTotal;
1409     //
1410     address public kingOfTheHill;
1411     uint256 public kingOfTheHillTicketsNumber;
1412 
1413     mapping(address => uint256) public reward;
1414 
1415     event rewardPaid(uint256 indexed eventsCounter, address indexed to, uint256 sum); //
1416     function getReward() public {
1417         require(reward[msg.sender] > 0);
1418         msg.sender.transfer(reward[msg.sender]);
1419 
1420         eventsCounter = eventsCounter + 1;
1421         rewardPaid(eventsCounter, msg.sender, reward[msg.sender]);
1422         sum[affiliateRewards] = sum[affiliateRewards].sub(reward[msg.sender]);
1423         reward[msg.sender] = 0;
1424     }
1425 
1426     // gas for oraclize_query:
1427     uint256 public oraclizeCallbackGas = 230000; // amount of gas we want Oraclize to set for the callback function
1428 
1429     // > to be able to read it from browser after updating
1430     uint256 public currentOraclizeGasPrice; //
1431     function oraclizeGetPrice() public returns (uint256){
1432         currentOraclizeGasPrice = oraclize_getPrice("random", oraclizeCallbackGas);
1433         return currentOraclizeGasPrice;
1434     }
1435 
1436     function getContractsWeiBalance() public view returns (uint256) {
1437         return this.balance;
1438     }
1439 
1440     // mapping to keep sums on accounts (including 'income'):
1441     mapping(uint8 => uint256) public sum;
1442     uint8 public instantGame = 0;
1443     uint8 public dailyJackpot = 1;
1444     uint8 public weeklyJackpot = 2;
1445     uint8 public monthlyJackpot = 3;
1446     uint8 public yearlyJackpot = 4;
1447     uint8 public income = 5;
1448     uint8 public marketingFund = 6;
1449     uint8 public affiliateRewards = 7; //
1450     uint8 public playersBets = 8;
1451 
1452     mapping(uint8 => uint256) public period; // in seconds
1453 
1454     event withdrawalFromMarketingFund(uint256 indexed eventsCounter, uint256 sum); //
1455     function withdrawFromMarketingFund() public {
1456         require(msg.sender == owner);
1457         owner.transfer(sum[marketingFund]);
1458 
1459         eventsCounter = eventsCounter + 1;
1460         withdrawalFromMarketingFund(eventsCounter, sum[marketingFund]);
1461 
1462         sum[marketingFund] = 0;
1463     }
1464 
1465     mapping(uint8 => bool) public jackpotPlayIsRunning; //
1466 
1467     // allocation:
1468     mapping(uint8 => uint16) public rate;
1469 
1470     // JackpotCounters (starts with 0):
1471     mapping(uint8 => uint256) jackpotCounter;
1472     mapping(uint8 => uint256) public lastJackpotTime;  // unix time
1473 
1474     // uint256 public lastDividendsPaymentTime; // unix time, for 'income' only
1475 
1476     address public luckyStrikeTokensContractAddress;
1477 
1478     LuckyStrikeTokens public luckyStrikeTokens;
1479 
1480     /* --- constructor */
1481 
1482     // (!) requires acces to Oraclize contract
1483     // will fail on JavaScript VM
1484     function LuckyStrike() public {
1485 
1486         owner = 0xF732628F2757A880A5D73B19fB98bc61c1950d81;
1487         admin = msg.sender;
1488 
1489         // sets the Ledger authenticity proof in the constructor
1490         oraclize_setProof(proofType_Ledger);
1491 
1492     }
1493 
1494     function init(address _luckyStrikeTokensContractAddress) public payable {
1495 
1496         require(ticketsTotal == 0);
1497         require(msg.sender == admin);
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
1755         // require( luckyStrikeTokens.tokenSaleIsRunning());
1756         // < we will check this in luckyStrikeTokens.mint method
1757 
1758         uint256 sumToMarketingFund = msg.value / 5;
1759 
1760         sum[marketingFund] = sum[marketingFund].add(sumToMarketingFund);
1761 
1762         uint256 bet = msg.value.sub(sumToMarketingFund);
1763 
1764         placeABetInternal(bet);
1765 
1766         uint256 tokensToMint = msg.value / ticketPriceInWei;
1767 
1768         // require(bet / ticketPriceInWei > 0); // > makes more complicated
1769         luckyStrikeTokens.mint(msg.sender, tokensToMint, sumToMarketingFund);
1770 
1771         eventsCounter = eventsCounter + 1;
1772         Investment(
1773             eventsCounter, //......1
1774             msg.sender, //.........2
1775             msg.value, //..........3
1776             sumToMarketingFund, //.4
1777             bet, //................5
1778             tokensToMint //........6
1779         );
1780     }
1781 
1782     function investAndPlayWithReferrer(address _referrer) public payable {
1783         if (referrer[msg.sender] == 0x0000000000000000000000000000000000000000) {
1784             referrer[msg.sender] = _referrer;
1785         }
1786         investAndPlay();
1787     }
1788 
1789     function invest() public payable {
1790         //  require(luckyStrikeTokens.tokenSaleIsRunning());
1791         // < we will check this in luckyStrikeTokens.mint method
1792 
1793         sum[marketingFund] = sum[marketingFund].add(msg.value);
1794 
1795         uint256 tokensToMint = msg.value / ticketPriceInWei;
1796 
1797         // uint256 bonus = (tokensToMint / 100).mul(75);
1798         uint256 bonus1part = tokensToMint / 2;
1799         uint256 bonus2part = tokensToMint / 4;
1800         uint256 bonus = bonus1part.add(bonus2part);
1801 
1802         tokensToMint = tokensToMint.add(bonus);
1803 
1804         // require(bet / ticketPriceInWei > 0); // > makes more complicated
1805         luckyStrikeTokens.mint(
1806             msg.sender,
1807             tokensToMint,
1808             msg.value // all sum > investment
1809         );
1810 
1811         eventsCounter = eventsCounter + 1;
1812         Investment(
1813             eventsCounter, //..1
1814             msg.sender, //.....2
1815             msg.value, //......3
1816             msg.value, //......4
1817             0, //..............5 (bet)
1818             tokensToMint //....6
1819         );
1820     }
1821 
1822     function investWithReferrer(address _referrer) public payable {
1823         if (referrer[msg.sender] == 0x0000000000000000000000000000000000000000) {
1824             referrer[msg.sender] = _referrer;
1825         }
1826         invest();
1827     }
1828 
1829     // second step in instant game:
1830     event InstantGameResult (
1831         uint256 indexed eventsCounter, //...0
1832         uint256 gameId, // .................1
1833         bool theBetPlayed, //...............2
1834         address indexed challenger, //......3
1835         address indexed king, //............4
1836         uint256 kingsTicketsNumber, //......5
1837         address winner, //..................6
1838         uint256 prize, //...................7
1839         uint256 ticketsInTheInstantGame, //.8
1840         uint256 randomNumber, //............9
1841         address triggeredBy //..............10
1842     );
1843 
1844     function play(address player) public {
1845 
1846         require(instantGameIsRunning[player]);
1847         require(lastInstantGameBlockNumber[player] < block.number);
1848         // block number with the bet must be no more than 255 blocks before the current block
1849         // or we get 0 as blockhash
1850 
1851         instantGameCounter = instantGameCounter + 1;
1852 
1853         uint256 playerBet = lastInstantGameTicketsNumber[player].mul(ticketPriceInWei);
1854         // in any case playerBet should be subtracted sum[playerBets]
1855         sum[playersBets] = sum[playersBets].sub(playerBet);
1856 
1857         // TODO: recheck this >
1858         if (block.number - lastInstantGameBlockNumber[player] > 250) {
1859             eventsCounter = eventsCounter + 1;
1860             InstantGameResult(
1861                 eventsCounter,
1862                 instantGameCounter,
1863                 false,
1864                 player,
1865                 address(0), // kingOfTheHill, // oldKingOfTheHill,
1866                 0,
1867                 address(0), // winner,
1868                 0, // prize,
1869                 0, // lastInstantGameTicketsNumber[player], // ticketsInTheInstantGame,
1870                 0, // randomNumber,
1871                 msg.sender // triggeredBy
1872             );
1873 
1874             // player.transfer(playerBet);
1875             sum[income] = sum[income].add(playerBet);
1876 
1877             lastInstantGameTicketsNumber[player] = 0;
1878             instantGameIsRunning[player] = false;
1879             return;
1880         }
1881 
1882         address oldKingOfTheHill = kingOfTheHill;
1883         uint256 oldKingOfTheHillTicketsNumber = kingOfTheHillTicketsNumber;
1884         uint256 ticketsInTheInstantGame = kingOfTheHillTicketsNumber.add(lastInstantGameTicketsNumber[player]);
1885 
1886         // TODO: recheck this
1887         bytes32 seed = keccak256(
1888             block.blockhash(lastInstantGameBlockNumber[player]) // bytes32
1889         );
1890 
1891         uint256 seedToNumber = uint256(seed);
1892 
1893         uint256 randomNumber = seedToNumber % ticketsInTheInstantGame;
1894 
1895         // 0 never plays, and ticketsInTheInstantGame can not be returned by the function above
1896         if (randomNumber == 0) {
1897             randomNumber = ticketsInTheInstantGame;
1898         }
1899 
1900         uint256 prize;
1901         address winner;
1902         address loser;
1903 
1904         if (randomNumber > kingOfTheHillTicketsNumber) {// challenger ('player') wins
1905             winner = player;
1906             loser = kingOfTheHill;
1907 
1908             // new kingOfTheHill:
1909             kingOfTheHill = player;
1910             kingOfTheHillTicketsNumber = lastInstantGameTicketsNumber[player];
1911         } else {// kingOfTheHill wins
1912             winner = kingOfTheHill;
1913             loser = player;
1914         }
1915 
1916         // prize = allocateSum(playerBet, loser, winner);
1917         prize = allocateSum(playerBet, loser);
1918 
1919         instantGameIsRunning[player] = false;
1920 
1921         // pay prize to the winner
1922         winner.transfer(prize);
1923 
1924         eventsCounter = eventsCounter + 1;
1925         InstantGameResult(
1926             eventsCounter,
1927             instantGameCounter,
1928             true,
1929             player,
1930             oldKingOfTheHill,
1931             oldKingOfTheHillTicketsNumber,
1932             winner,
1933         // playerBet,
1934             prize,
1935             ticketsInTheInstantGame,
1936             randomNumber,
1937             msg.sender
1938         );
1939 
1940     }
1941 
1942     // convenience function;
1943     function playMyInstantGame() public {
1944         play(msg.sender);
1945     }
1946 
1947     /* ----------- Jackpots: ------------ */
1948 
1949     function requestRandomFromOraclize() private returns (bytes32 oraclizeQueryId)  {
1950 
1951         require(msg.value >= oraclizeGetPrice());
1952         // < to pay to oraclize
1953 
1954         // call Oraclize
1955         // uint N :
1956         // number nRandomBytes between 1 and 32, which is the number of random bytes to be returned to the application.
1957         // see: http://www.oraclize.it/papers/random_datasource-rev1.pdf
1958         uint256 N = 32;
1959         // number of seconds to wait before the execution takes place
1960         uint delay = 0;
1961         // this function internally generates the correct oraclize_query and returns its queryId
1962         oraclizeQueryId = oraclize_newRandomDSQuery(delay, N, oraclizeCallbackGas);
1963 
1964         // playJackpotEvent(msg.sender, msg.value, tx.gasprice, oraclizeQueryId);
1965         return oraclizeQueryId;
1966 
1967     }
1968 
1969     // reminder (this defined above):
1970     // mapping(uint8 => uint256) public period; // in seconds
1971     // mapping(uint8 => uint256) public lastJackpotTime;  // unix time
1972 
1973     mapping(bytes32 => uint8) public jackpot;
1974 
1975     event JackpotPlayStarted(
1976         uint256 indexed eventsCounter,
1977         uint8 indexed jackpotType,
1978         address startedBy,
1979         bytes32 oraclizeQueryId
1980     );//
1981     // uint8 jackpotType
1982     function startJackpotPlay(uint8 jackpotType) public payable {
1983 
1984         require(msg.value >= oraclizeGetPrice());
1985 
1986         require(jackpotType >= 1 && jackpotType <= 4);
1987         require(!jackpotPlayIsRunning[jackpotType]);
1988         require(
1989         // block.timestamp (uint): current block timestamp as seconds since unix epoch
1990             block.timestamp >= lastJackpotTime[jackpotType].add(period[jackpotType])
1991         );
1992 
1993         bytes32 oraclizeQueryId = requestRandomFromOraclize();
1994         jackpot[oraclizeQueryId] = jackpotType;
1995 
1996         jackpotPlayIsRunning[jackpotType] = true;
1997 
1998         eventsCounter = eventsCounter + 1;
1999         JackpotPlayStarted(eventsCounter, jackpotType, msg.sender, oraclizeQueryId);
2000     }
2001 
2002     uint256 public allJackpotsCounter;
2003 
2004     event JackpotResult(
2005         uint256 indexed eventsCounter,
2006         uint256 allJackpotsCounter,
2007         uint8 indexed jackpotType,
2008         uint256 jackpotIdNumber,
2009         uint256 prize,
2010         address indexed winner,
2011         uint256 randomNumberSeed,
2012         uint256 randomNumber,
2013         uint256 ticketsTotal
2014     );
2015 
2016     // the callback function is called by Oraclize when the result is ready
2017     // the oraclize_randomDS_proofVerify modifier prevents an invalid proof to execute this function code:
2018     // the proof validity is fully verified on-chain
2019     function __callback(bytes32 _queryId, string _result, bytes _proof) public {
2020 
2021         require(msg.sender == oraclize_cbAddress());
2022 
2023         if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0) {
2024             // the proof verification has failed, do we need to take any action here? (depends on the use case)
2025             revert();
2026         } else {
2027 
2028             // find jackpot for this _queryId:
2029 
2030             uint8 jackpotType = jackpot[_queryId];
2031 
2032             require(jackpotPlayIsRunning[jackpotType]);
2033 
2034             jackpotCounter[jackpotType] = jackpotCounter[jackpotType] + 1;
2035 
2036             // select jackpot winner:
2037 
2038             bytes32 hashOfTheRandomString = keccak256(_result);
2039 
2040             uint256 randomNumberSeed = uint256(hashOfTheRandomString);
2041 
2042             uint256 randomNumber = randomNumberSeed % ticketsTotal;
2043 
2044             // there is no ticket # 0, and above function can not return number equivalent to 'ticketsTotal'
2045             if (randomNumber == 0) {
2046                 randomNumber = ticketsTotal;
2047             }
2048 
2049             address winner = theLotteryTicket[randomNumber];
2050 
2051             // transfer jackpot sum to the winner
2052 
2053             winner.transfer(sum[jackpotType]);
2054 
2055             // emit event:
2056             eventsCounter = eventsCounter + 1;
2057             allJackpotsCounter = allJackpotsCounter + 1;
2058             JackpotResult(
2059                 eventsCounter,
2060                 allJackpotsCounter,
2061                 jackpotType,
2062                 jackpotCounter[jackpotType],
2063                 sum[jackpotType],
2064                 winner,
2065                 randomNumberSeed,
2066                 randomNumber,
2067                 ticketsTotal
2068             );
2069 
2070             // update information for this jackpot:
2071 
2072             sum[jackpotType] = 0;
2073 
2074             lastJackpotTime[jackpotType] = block.timestamp;
2075 
2076             jackpotPlayIsRunning[jackpotType] = false;
2077 
2078         }
2079     } // end of function __callback
2080 
2081     event DividendsSentToTokensContract(uint256 indexed eventsCounter, uint256 sum, address indexed triggeredBy);
2082     // can be called by any address:
2083     function payDividends() public returns (bool success){
2084 
2085         luckyStrikeTokensContractAddress.transfer(sum[income]);
2086 
2087         eventsCounter = eventsCounter + 1;
2088         DividendsSentToTokensContract(eventsCounter, sum[income], msg.sender);
2089 
2090         sum[income] = 0;
2091 
2092         return true;
2093     }
2094 
2095 }