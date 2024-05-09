1 pragma solidity ^0.4.22;
2 
3 // File: contracts/zeppelin/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 // <ORACLIZE_API>
51 /*
52 Copyright (c) 2015-2016 Oraclize SRL
53 Copyright (c) 2016 Oraclize LTD
54 
55 
56 
57 Permission is hereby granted, free of charge, to any person obtaining a copy
58 of this software and associated documentation files (the "Software"), to deal
59 in the Software without restriction, including without limitation the rights
60 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
61 copies of the Software, and to permit persons to whom the Software is
62 furnished to do so, subject to the following conditions:
63 
64 
65 
66 The above copyright notice and this permission notice shall be included in
67 all copies or substantial portions of the Software.
68 
69 
70 
71 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
72 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
73 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
74 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
75 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
76 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
77 THE SOFTWARE.
78 */
79 
80 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
81 
82 contract OraclizeI {
83     address public cbAddress;
84     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
85     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
86     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
87     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
88     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
89     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
90     function getPrice(string _datasource) public returns (uint _dsprice);
91     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
92     function setProofType(byte _proofType) external;
93     function setCustomGasPrice(uint _gasPrice) external;
94     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
95 }
96 
97 contract OraclizeAddrResolverI {
98     function getAddress() public returns (address _addr);
99 }
100 
101 /*
102 Begin solidity-cborutils
103 
104 https://github.com/smartcontractkit/solidity-cborutils
105 
106 MIT License
107 
108 Copyright (c) 2018 SmartContract ChainLink, Ltd.
109 
110 Permission is hereby granted, free of charge, to any person obtaining a copy
111 of this software and associated documentation files (the "Software"), to deal
112 in the Software without restriction, including without limitation the rights
113 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
114 copies of the Software, and to permit persons to whom the Software is
115 furnished to do so, subject to the following conditions:
116 
117 The above copyright notice and this permission notice shall be included in all
118 copies or substantial portions of the Software.
119 
120 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
121 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
122 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
123 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
124 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
125 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
126 SOFTWARE.
127  */
128 
129 library Buffer {
130     struct buffer {
131         bytes buf;
132         uint capacity;
133     }
134 
135     function init(buffer memory buf, uint capacity) internal pure {
136         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
137         // Allocate space for the buffer data
138         buf.capacity = capacity;
139         assembly {
140             let ptr := mload(0x40)
141             mstore(buf, ptr)
142             mstore(0x40, add(ptr, capacity))
143         }
144     }
145 
146     function resize(buffer memory buf, uint capacity) private pure {
147         bytes memory oldbuf = buf.buf;
148         init(buf, capacity);
149         append(buf, oldbuf);
150     }
151 
152     function max(uint a, uint b) private pure returns(uint) {
153         if(a > b) {
154             return a;
155         }
156         return b;
157     }
158 
159     /**
160      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
161      *      would exceed the capacity of the buffer.
162      * @param buf The buffer to append to.
163      * @param data The data to append.
164      * @return The original buffer.
165      */
166     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
167         if(data.length + buf.buf.length > buf.capacity) {
168             resize(buf, max(buf.capacity, data.length) * 2);
169         }
170 
171         uint dest;
172         uint src;
173         uint len = data.length;
174         assembly {
175             // Memory address of the buffer data
176             let bufptr := mload(buf)
177             // Length of existing buffer data
178             let buflen := mload(bufptr)
179             // Start address = buffer address + buffer length + sizeof(buffer length)
180             dest := add(add(bufptr, buflen), 32)
181             // Update buffer length
182             mstore(bufptr, add(buflen, mload(data)))
183             src := add(data, 32)
184         }
185 
186         // Copy word-length chunks while possible
187         for(; len >= 32; len -= 32) {
188             assembly {
189                 mstore(dest, mload(src))
190             }
191             dest += 32;
192             src += 32;
193         }
194 
195         // Copy remaining bytes
196         uint mask = 256 ** (32 - len) - 1;
197         assembly {
198             let srcpart := and(mload(src), not(mask))
199             let destpart := and(mload(dest), mask)
200             mstore(dest, or(destpart, srcpart))
201         }
202 
203         return buf;
204     }
205 
206     /**
207      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
208      * exceed the capacity of the buffer.
209      * @param buf The buffer to append to.
210      * @param data The data to append.
211      * @return The original buffer.
212      */
213     function append(buffer memory buf, uint8 data) internal pure {
214         if(buf.buf.length + 1 > buf.capacity) {
215             resize(buf, buf.capacity * 2);
216         }
217 
218         assembly {
219             // Memory address of the buffer data
220             let bufptr := mload(buf)
221             // Length of existing buffer data
222             let buflen := mload(bufptr)
223             // Address = buffer address + buffer length + sizeof(buffer length)
224             let dest := add(add(bufptr, buflen), 32)
225             mstore8(dest, data)
226             // Update buffer length
227             mstore(bufptr, add(buflen, 1))
228         }
229     }
230 
231     /**
232      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
233      * exceed the capacity of the buffer.
234      * @param buf The buffer to append to.
235      * @param data The data to append.
236      * @return The original buffer.
237      */
238     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
239         if(len + buf.buf.length > buf.capacity) {
240             resize(buf, max(buf.capacity, len) * 2);
241         }
242 
243         uint mask = 256 ** len - 1;
244         assembly {
245             // Memory address of the buffer data
246             let bufptr := mload(buf)
247             // Length of existing buffer data
248             let buflen := mload(bufptr)
249             // Address = buffer address + buffer length + sizeof(buffer length) + len
250             let dest := add(add(bufptr, buflen), len)
251             mstore(dest, or(and(mload(dest), not(mask)), data))
252             // Update buffer length
253             mstore(bufptr, add(buflen, len))
254         }
255         return buf;
256     }
257 }
258 
259 library CBOR {
260     using Buffer for Buffer.buffer;
261 
262     uint8 private constant MAJOR_TYPE_INT = 0;
263     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
264     uint8 private constant MAJOR_TYPE_BYTES = 2;
265     uint8 private constant MAJOR_TYPE_STRING = 3;
266     uint8 private constant MAJOR_TYPE_ARRAY = 4;
267     uint8 private constant MAJOR_TYPE_MAP = 5;
268     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
269 
270     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
271         if(value <= 23) {
272             buf.append(uint8((major << 5) | value));
273         } else if(value <= 0xFF) {
274             buf.append(uint8((major << 5) | 24));
275             buf.appendInt(value, 1);
276         } else if(value <= 0xFFFF) {
277             buf.append(uint8((major << 5) | 25));
278             buf.appendInt(value, 2);
279         } else if(value <= 0xFFFFFFFF) {
280             buf.append(uint8((major << 5) | 26));
281             buf.appendInt(value, 4);
282         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
283             buf.append(uint8((major << 5) | 27));
284             buf.appendInt(value, 8);
285         }
286     }
287 
288     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
289         buf.append(uint8((major << 5) | 31));
290     }
291 
292     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
293         encodeType(buf, MAJOR_TYPE_INT, value);
294     }
295 
296     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
297         if(value >= 0) {
298             encodeType(buf, MAJOR_TYPE_INT, uint(value));
299         } else {
300             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
301         }
302     }
303 
304     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
305         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
306         buf.append(value);
307     }
308 
309     function encodeString(Buffer.buffer memory buf, string value) internal pure {
310         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
311         buf.append(bytes(value));
312     }
313 
314     function startArray(Buffer.buffer memory buf) internal pure {
315         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
316     }
317 
318     function startMap(Buffer.buffer memory buf) internal pure {
319         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
320     }
321 
322     function endSequence(Buffer.buffer memory buf) internal pure {
323         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
324     }
325 }
326 
327 /*
328 End solidity-cborutils
329  */
330 
331 contract usingOraclize {
332     uint constant day = 60*60*24;
333     uint constant week = 60*60*24*7;
334     uint constant month = 60*60*24*30;
335     byte constant proofType_NONE = 0x00;
336     byte constant proofType_TLSNotary = 0x10;
337     byte constant proofType_Android = 0x20;
338     byte constant proofType_Ledger = 0x30;
339     byte constant proofType_Native = 0xF0;
340     byte constant proofStorage_IPFS = 0x01;
341     uint8 constant networkID_auto = 0;
342     uint8 constant networkID_mainnet = 1;
343     uint8 constant networkID_testnet = 2;
344     uint8 constant networkID_morden = 2;
345     uint8 constant networkID_consensys = 161;
346 
347     OraclizeAddrResolverI OAR;
348 
349     OraclizeI oraclize;
350     modifier oraclizeAPI {
351         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
352             oraclize_setNetwork(networkID_auto);
353 
354         if(address(oraclize) != OAR.getAddress())
355             oraclize = OraclizeI(OAR.getAddress());
356 
357         _;
358     }
359     modifier coupon(string code){
360         oraclize = OraclizeI(OAR.getAddress());
361         _;
362     }
363 
364     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
365       return oraclize_setNetwork();
366       networkID; // silence the warning and remain backwards compatible
367     }
368     function oraclize_setNetwork() internal returns(bool){
369         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
370             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
371             oraclize_setNetworkName("eth_mainnet");
372             return true;
373         }
374         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
375             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
376             oraclize_setNetworkName("eth_ropsten3");
377             return true;
378         }
379         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
380             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
381             oraclize_setNetworkName("eth_kovan");
382             return true;
383         }
384         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
385             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
386             oraclize_setNetworkName("eth_rinkeby");
387             return true;
388         }
389         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
390             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
391             return true;
392         }
393         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
394             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
395             return true;
396         }
397         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
398             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
399             return true;
400         }
401         return false;
402     }
403 
404     function __callback(bytes32 myid, string result) public {
405         __callback(myid, result, new bytes(0));
406     }
407     function __callback(bytes32 myid, string result, bytes proof) public {
408       return;
409       myid; result; proof; // Silence compiler warnings
410     }
411 
412     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
413         return oraclize.getPrice(datasource);
414     }
415 
416     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
417         return oraclize.getPrice(datasource, gaslimit);
418     }
419 
420     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
421         uint price = oraclize.getPrice(datasource);
422         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
423         return oraclize.query.value(price)(0, datasource, arg);
424     }
425     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
426         uint price = oraclize.getPrice(datasource);
427         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
428         return oraclize.query.value(price)(timestamp, datasource, arg);
429     }
430     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
431         uint price = oraclize.getPrice(datasource, gaslimit);
432         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
433         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
434     }
435     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
436         uint price = oraclize.getPrice(datasource, gaslimit);
437         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
438         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
439     }
440     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
441         uint price = oraclize.getPrice(datasource);
442         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
443         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
444     }
445     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
446         uint price = oraclize.getPrice(datasource);
447         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
448         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
449     }
450     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
451         uint price = oraclize.getPrice(datasource, gaslimit);
452         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
453         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
454     }
455     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
456         uint price = oraclize.getPrice(datasource, gaslimit);
457         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
458         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
459     }
460     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
461         uint price = oraclize.getPrice(datasource);
462         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
463         bytes memory args = stra2cbor(argN);
464         return oraclize.queryN.value(price)(0, datasource, args);
465     }
466     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
467         uint price = oraclize.getPrice(datasource);
468         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
469         bytes memory args = stra2cbor(argN);
470         return oraclize.queryN.value(price)(timestamp, datasource, args);
471     }
472     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
473         uint price = oraclize.getPrice(datasource, gaslimit);
474         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
475         bytes memory args = stra2cbor(argN);
476         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
477     }
478     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
479         uint price = oraclize.getPrice(datasource, gaslimit);
480         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
481         bytes memory args = stra2cbor(argN);
482         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
483     }
484     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
485         string[] memory dynargs = new string[](1);
486         dynargs[0] = args[0];
487         return oraclize_query(datasource, dynargs);
488     }
489     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
490         string[] memory dynargs = new string[](1);
491         dynargs[0] = args[0];
492         return oraclize_query(timestamp, datasource, dynargs);
493     }
494     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
495         string[] memory dynargs = new string[](1);
496         dynargs[0] = args[0];
497         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
498     }
499     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
500         string[] memory dynargs = new string[](1);
501         dynargs[0] = args[0];
502         return oraclize_query(datasource, dynargs, gaslimit);
503     }
504 
505     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
506         string[] memory dynargs = new string[](2);
507         dynargs[0] = args[0];
508         dynargs[1] = args[1];
509         return oraclize_query(datasource, dynargs);
510     }
511     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
512         string[] memory dynargs = new string[](2);
513         dynargs[0] = args[0];
514         dynargs[1] = args[1];
515         return oraclize_query(timestamp, datasource, dynargs);
516     }
517     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
518         string[] memory dynargs = new string[](2);
519         dynargs[0] = args[0];
520         dynargs[1] = args[1];
521         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
522     }
523     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
524         string[] memory dynargs = new string[](2);
525         dynargs[0] = args[0];
526         dynargs[1] = args[1];
527         return oraclize_query(datasource, dynargs, gaslimit);
528     }
529     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
530         string[] memory dynargs = new string[](3);
531         dynargs[0] = args[0];
532         dynargs[1] = args[1];
533         dynargs[2] = args[2];
534         return oraclize_query(datasource, dynargs);
535     }
536     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
537         string[] memory dynargs = new string[](3);
538         dynargs[0] = args[0];
539         dynargs[1] = args[1];
540         dynargs[2] = args[2];
541         return oraclize_query(timestamp, datasource, dynargs);
542     }
543     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
544         string[] memory dynargs = new string[](3);
545         dynargs[0] = args[0];
546         dynargs[1] = args[1];
547         dynargs[2] = args[2];
548         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
549     }
550     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
551         string[] memory dynargs = new string[](3);
552         dynargs[0] = args[0];
553         dynargs[1] = args[1];
554         dynargs[2] = args[2];
555         return oraclize_query(datasource, dynargs, gaslimit);
556     }
557 
558     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
559         string[] memory dynargs = new string[](4);
560         dynargs[0] = args[0];
561         dynargs[1] = args[1];
562         dynargs[2] = args[2];
563         dynargs[3] = args[3];
564         return oraclize_query(datasource, dynargs);
565     }
566     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
567         string[] memory dynargs = new string[](4);
568         dynargs[0] = args[0];
569         dynargs[1] = args[1];
570         dynargs[2] = args[2];
571         dynargs[3] = args[3];
572         return oraclize_query(timestamp, datasource, dynargs);
573     }
574     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
575         string[] memory dynargs = new string[](4);
576         dynargs[0] = args[0];
577         dynargs[1] = args[1];
578         dynargs[2] = args[2];
579         dynargs[3] = args[3];
580         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
581     }
582     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
583         string[] memory dynargs = new string[](4);
584         dynargs[0] = args[0];
585         dynargs[1] = args[1];
586         dynargs[2] = args[2];
587         dynargs[3] = args[3];
588         return oraclize_query(datasource, dynargs, gaslimit);
589     }
590     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
591         string[] memory dynargs = new string[](5);
592         dynargs[0] = args[0];
593         dynargs[1] = args[1];
594         dynargs[2] = args[2];
595         dynargs[3] = args[3];
596         dynargs[4] = args[4];
597         return oraclize_query(datasource, dynargs);
598     }
599     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
600         string[] memory dynargs = new string[](5);
601         dynargs[0] = args[0];
602         dynargs[1] = args[1];
603         dynargs[2] = args[2];
604         dynargs[3] = args[3];
605         dynargs[4] = args[4];
606         return oraclize_query(timestamp, datasource, dynargs);
607     }
608     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
609         string[] memory dynargs = new string[](5);
610         dynargs[0] = args[0];
611         dynargs[1] = args[1];
612         dynargs[2] = args[2];
613         dynargs[3] = args[3];
614         dynargs[4] = args[4];
615         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
616     }
617     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
618         string[] memory dynargs = new string[](5);
619         dynargs[0] = args[0];
620         dynargs[1] = args[1];
621         dynargs[2] = args[2];
622         dynargs[3] = args[3];
623         dynargs[4] = args[4];
624         return oraclize_query(datasource, dynargs, gaslimit);
625     }
626     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
627         uint price = oraclize.getPrice(datasource);
628         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
629         bytes memory args = ba2cbor(argN);
630         return oraclize.queryN.value(price)(0, datasource, args);
631     }
632     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
633         uint price = oraclize.getPrice(datasource);
634         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
635         bytes memory args = ba2cbor(argN);
636         return oraclize.queryN.value(price)(timestamp, datasource, args);
637     }
638     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
639         uint price = oraclize.getPrice(datasource, gaslimit);
640         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
641         bytes memory args = ba2cbor(argN);
642         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
643     }
644     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
645         uint price = oraclize.getPrice(datasource, gaslimit);
646         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
647         bytes memory args = ba2cbor(argN);
648         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
649     }
650     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
651         bytes[] memory dynargs = new bytes[](1);
652         dynargs[0] = args[0];
653         return oraclize_query(datasource, dynargs);
654     }
655     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
656         bytes[] memory dynargs = new bytes[](1);
657         dynargs[0] = args[0];
658         return oraclize_query(timestamp, datasource, dynargs);
659     }
660     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
661         bytes[] memory dynargs = new bytes[](1);
662         dynargs[0] = args[0];
663         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
664     }
665     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
666         bytes[] memory dynargs = new bytes[](1);
667         dynargs[0] = args[0];
668         return oraclize_query(datasource, dynargs, gaslimit);
669     }
670 
671     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
672         bytes[] memory dynargs = new bytes[](2);
673         dynargs[0] = args[0];
674         dynargs[1] = args[1];
675         return oraclize_query(datasource, dynargs);
676     }
677     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
678         bytes[] memory dynargs = new bytes[](2);
679         dynargs[0] = args[0];
680         dynargs[1] = args[1];
681         return oraclize_query(timestamp, datasource, dynargs);
682     }
683     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
684         bytes[] memory dynargs = new bytes[](2);
685         dynargs[0] = args[0];
686         dynargs[1] = args[1];
687         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
688     }
689     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
690         bytes[] memory dynargs = new bytes[](2);
691         dynargs[0] = args[0];
692         dynargs[1] = args[1];
693         return oraclize_query(datasource, dynargs, gaslimit);
694     }
695     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
696         bytes[] memory dynargs = new bytes[](3);
697         dynargs[0] = args[0];
698         dynargs[1] = args[1];
699         dynargs[2] = args[2];
700         return oraclize_query(datasource, dynargs);
701     }
702     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
703         bytes[] memory dynargs = new bytes[](3);
704         dynargs[0] = args[0];
705         dynargs[1] = args[1];
706         dynargs[2] = args[2];
707         return oraclize_query(timestamp, datasource, dynargs);
708     }
709     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
710         bytes[] memory dynargs = new bytes[](3);
711         dynargs[0] = args[0];
712         dynargs[1] = args[1];
713         dynargs[2] = args[2];
714         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
715     }
716     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
717         bytes[] memory dynargs = new bytes[](3);
718         dynargs[0] = args[0];
719         dynargs[1] = args[1];
720         dynargs[2] = args[2];
721         return oraclize_query(datasource, dynargs, gaslimit);
722     }
723 
724     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
725         bytes[] memory dynargs = new bytes[](4);
726         dynargs[0] = args[0];
727         dynargs[1] = args[1];
728         dynargs[2] = args[2];
729         dynargs[3] = args[3];
730         return oraclize_query(datasource, dynargs);
731     }
732     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
733         bytes[] memory dynargs = new bytes[](4);
734         dynargs[0] = args[0];
735         dynargs[1] = args[1];
736         dynargs[2] = args[2];
737         dynargs[3] = args[3];
738         return oraclize_query(timestamp, datasource, dynargs);
739     }
740     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
741         bytes[] memory dynargs = new bytes[](4);
742         dynargs[0] = args[0];
743         dynargs[1] = args[1];
744         dynargs[2] = args[2];
745         dynargs[3] = args[3];
746         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
747     }
748     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
749         bytes[] memory dynargs = new bytes[](4);
750         dynargs[0] = args[0];
751         dynargs[1] = args[1];
752         dynargs[2] = args[2];
753         dynargs[3] = args[3];
754         return oraclize_query(datasource, dynargs, gaslimit);
755     }
756     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
757         bytes[] memory dynargs = new bytes[](5);
758         dynargs[0] = args[0];
759         dynargs[1] = args[1];
760         dynargs[2] = args[2];
761         dynargs[3] = args[3];
762         dynargs[4] = args[4];
763         return oraclize_query(datasource, dynargs);
764     }
765     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
766         bytes[] memory dynargs = new bytes[](5);
767         dynargs[0] = args[0];
768         dynargs[1] = args[1];
769         dynargs[2] = args[2];
770         dynargs[3] = args[3];
771         dynargs[4] = args[4];
772         return oraclize_query(timestamp, datasource, dynargs);
773     }
774     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
775         bytes[] memory dynargs = new bytes[](5);
776         dynargs[0] = args[0];
777         dynargs[1] = args[1];
778         dynargs[2] = args[2];
779         dynargs[3] = args[3];
780         dynargs[4] = args[4];
781         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
782     }
783     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
784         bytes[] memory dynargs = new bytes[](5);
785         dynargs[0] = args[0];
786         dynargs[1] = args[1];
787         dynargs[2] = args[2];
788         dynargs[3] = args[3];
789         dynargs[4] = args[4];
790         return oraclize_query(datasource, dynargs, gaslimit);
791     }
792 
793     function oraclize_cbAddress() oraclizeAPI internal returns (address){
794         return oraclize.cbAddress();
795     }
796     function oraclize_setProof(byte proofP) oraclizeAPI internal {
797         return oraclize.setProofType(proofP);
798     }
799     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
800         return oraclize.setCustomGasPrice(gasPrice);
801     }
802 
803     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
804         return oraclize.randomDS_getSessionPubKeyHash();
805     }
806 
807     function getCodeSize(address _addr) constant internal returns(uint _size) {
808         assembly {
809             _size := extcodesize(_addr)
810         }
811     }
812 
813     function parseAddr(string _a) internal pure returns (address){
814         bytes memory tmp = bytes(_a);
815         uint160 iaddr = 0;
816         uint160 b1;
817         uint160 b2;
818         for (uint i=2; i<2+2*20; i+=2){
819             iaddr *= 256;
820             b1 = uint160(tmp[i]);
821             b2 = uint160(tmp[i+1]);
822             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
823             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
824             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
825             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
826             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
827             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
828             iaddr += (b1*16+b2);
829         }
830         return address(iaddr);
831     }
832 
833     function strCompare(string _a, string _b) internal pure returns (int) {
834         bytes memory a = bytes(_a);
835         bytes memory b = bytes(_b);
836         uint minLength = a.length;
837         if (b.length < minLength) minLength = b.length;
838         for (uint i = 0; i < minLength; i ++)
839             if (a[i] < b[i])
840                 return -1;
841             else if (a[i] > b[i])
842                 return 1;
843         if (a.length < b.length)
844             return -1;
845         else if (a.length > b.length)
846             return 1;
847         else
848             return 0;
849     }
850 
851     function indexOf(string _haystack, string _needle) internal pure returns (int) {
852         bytes memory h = bytes(_haystack);
853         bytes memory n = bytes(_needle);
854         if(h.length < 1 || n.length < 1 || (n.length > h.length))
855             return -1;
856         else if(h.length > (2**128 -1))
857             return -1;
858         else
859         {
860             uint subindex = 0;
861             for (uint i = 0; i < h.length; i ++)
862             {
863                 if (h[i] == n[0])
864                 {
865                     subindex = 1;
866                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
867                     {
868                         subindex++;
869                     }
870                     if(subindex == n.length)
871                         return int(i);
872                 }
873             }
874             return -1;
875         }
876     }
877 
878     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
879         bytes memory _ba = bytes(_a);
880         bytes memory _bb = bytes(_b);
881         bytes memory _bc = bytes(_c);
882         bytes memory _bd = bytes(_d);
883         bytes memory _be = bytes(_e);
884         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
885         bytes memory babcde = bytes(abcde);
886         uint k = 0;
887         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
888         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
889         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
890         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
891         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
892         return string(babcde);
893     }
894 
895     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
896         return strConcat(_a, _b, _c, _d, "");
897     }
898 
899     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
900         return strConcat(_a, _b, _c, "", "");
901     }
902 
903     function strConcat(string _a, string _b) internal pure returns (string) {
904         return strConcat(_a, _b, "", "", "");
905     }
906 
907     // parseInt
908     function parseInt(string _a) internal pure returns (uint) {
909         return parseInt(_a, 0);
910     }
911 
912     // parseInt(parseFloat*10^_b)
913     function parseInt(string _a, uint _b) internal pure returns (uint) {
914         bytes memory bresult = bytes(_a);
915         uint mint = 0;
916         bool decimals = false;
917         for (uint i=0; i<bresult.length; i++){
918             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
919                 if (decimals){
920                    if (_b == 0) break;
921                     else _b--;
922                 }
923                 mint *= 10;
924                 mint += uint(bresult[i]) - 48;
925             } else if (bresult[i] == 46) decimals = true;
926         }
927         if (_b > 0) mint *= 10**_b;
928         return mint;
929     }
930 
931     function uint2str(uint i) internal pure returns (string){
932         if (i == 0) return "0";
933         uint j = i;
934         uint len;
935         while (j != 0){
936             len++;
937             j /= 10;
938         }
939         bytes memory bstr = new bytes(len);
940         uint k = len - 1;
941         while (i != 0){
942             bstr[k--] = byte(48 + i % 10);
943             i /= 10;
944         }
945         return string(bstr);
946     }
947 
948     using CBOR for Buffer.buffer;
949     function stra2cbor(string[] arr) internal pure returns (bytes) {
950         Buffer.buffer memory buf;
951         Buffer.init(buf, 1024);
952         buf.startArray();
953         for (uint i = 0; i < arr.length; i++) {
954             buf.encodeString(arr[i]);
955         }
956         buf.endSequence();
957         return buf.buf;
958     }
959 
960     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
961         Buffer.buffer memory buf;
962         Buffer.init(buf, 1024);
963         buf.startArray();
964         for (uint i = 0; i < arr.length; i++) {
965             buf.encodeBytes(arr[i]);
966         }
967         buf.endSequence();
968         return buf.buf;
969     }
970 
971     string oraclize_network_name;
972     function oraclize_setNetworkName(string _network_name) internal {
973         oraclize_network_name = _network_name;
974     }
975 
976     function oraclize_getNetworkName() internal view returns (string) {
977         return oraclize_network_name;
978     }
979 
980     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
981         require((_nbytes > 0) && (_nbytes <= 32));
982         // Convert from seconds to ledger timer ticks
983         _delay *= 10;
984         bytes memory nbytes = new bytes(1);
985         nbytes[0] = byte(_nbytes);
986         bytes memory unonce = new bytes(32);
987         bytes memory sessionKeyHash = new bytes(32);
988         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
989         assembly {
990             mstore(unonce, 0x20)
991             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
992             mstore(sessionKeyHash, 0x20)
993             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
994         }
995         bytes memory delay = new bytes(32);
996         assembly {
997             mstore(add(delay, 0x20), _delay)
998         }
999 
1000         bytes memory delay_bytes8 = new bytes(8);
1001         copyBytes(delay, 24, 8, delay_bytes8, 0);
1002 
1003         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1004         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1005 
1006         bytes memory delay_bytes8_left = new bytes(8);
1007 
1008         assembly {
1009             let x := mload(add(delay_bytes8, 0x20))
1010             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1011             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1012             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1013             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1014             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1015             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1016             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1017             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1018 
1019         }
1020 
1021         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1022         return queryId;
1023     }
1024 
1025     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1026         oraclize_randomDS_args[queryId] = commitment;
1027     }
1028 
1029     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1030     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1031 
1032     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1033         bool sigok;
1034         address signer;
1035 
1036         bytes32 sigr;
1037         bytes32 sigs;
1038 
1039         bytes memory sigr_ = new bytes(32);
1040         uint offset = 4+(uint(dersig[3]) - 0x20);
1041         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1042         bytes memory sigs_ = new bytes(32);
1043         offset += 32 + 2;
1044         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1045 
1046         assembly {
1047             sigr := mload(add(sigr_, 32))
1048             sigs := mload(add(sigs_, 32))
1049         }
1050 
1051 
1052         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1053         if (address(keccak256(pubkey)) == signer) return true;
1054         else {
1055             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1056             return (address(keccak256(pubkey)) == signer);
1057         }
1058     }
1059 
1060     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1061         bool sigok;
1062 
1063         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1064         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1065         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1066 
1067         bytes memory appkey1_pubkey = new bytes(64);
1068         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1069 
1070         bytes memory tosign2 = new bytes(1+65+32);
1071         tosign2[0] = byte(1); //role
1072         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1073         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1074         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1075         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1076 
1077         if (sigok == false) return false;
1078 
1079 
1080         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1081         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1082 
1083         bytes memory tosign3 = new bytes(1+65);
1084         tosign3[0] = 0xFE;
1085         copyBytes(proof, 3, 65, tosign3, 1);
1086 
1087         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1088         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1089 
1090         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1091 
1092         return sigok;
1093     }
1094 
1095     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1096         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1097         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1098 
1099         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1100         require(proofVerified);
1101 
1102         _;
1103     }
1104 
1105     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1106         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1107         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1108 
1109         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1110         if (proofVerified == false) return 2;
1111 
1112         return 0;
1113     }
1114 
1115     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1116         bool match_ = true;
1117 
1118         require(prefix.length == n_random_bytes);
1119 
1120         for (uint256 i=0; i< n_random_bytes; i++) {
1121             if (content[i] != prefix[i]) match_ = false;
1122         }
1123 
1124         return match_;
1125     }
1126 
1127     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1128 
1129         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1130         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1131         bytes memory keyhash = new bytes(32);
1132         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1133         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1134 
1135         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1136         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1137 
1138         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1139         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1140 
1141         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1142         // This is to verify that the computed args match with the ones specified in the query.
1143         bytes memory commitmentSlice1 = new bytes(8+1+32);
1144         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1145 
1146         bytes memory sessionPubkey = new bytes(64);
1147         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1148         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1149 
1150         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1151         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1152             delete oraclize_randomDS_args[queryId];
1153         } else return false;
1154 
1155 
1156         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1157         bytes memory tosign1 = new bytes(32+8+1+32);
1158         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1159         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1160 
1161         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1162         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1163             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1164         }
1165 
1166         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1167     }
1168 
1169     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1170     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1171         uint minLength = length + toOffset;
1172 
1173         // Buffer too small
1174         require(to.length >= minLength); // Should be a better way?
1175 
1176         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1177         uint i = 32 + fromOffset;
1178         uint j = 32 + toOffset;
1179 
1180         while (i < (32 + fromOffset + length)) {
1181             assembly {
1182                 let tmp := mload(add(from, i))
1183                 mstore(add(to, j), tmp)
1184             }
1185             i += 32;
1186             j += 32;
1187         }
1188 
1189         return to;
1190     }
1191 
1192     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1193     // Duplicate Solidity's ecrecover, but catching the CALL return value
1194     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1195         // We do our own memory management here. Solidity uses memory offset
1196         // 0x40 to store the current end of memory. We write past it (as
1197         // writes are memory extensions), but don't update the offset so
1198         // Solidity will reuse it. The memory used here is only needed for
1199         // this context.
1200 
1201         // FIXME: inline assembly can't access return values
1202         bool ret;
1203         address addr;
1204 
1205         assembly {
1206             let size := mload(0x40)
1207             mstore(size, hash)
1208             mstore(add(size, 32), v)
1209             mstore(add(size, 64), r)
1210             mstore(add(size, 96), s)
1211 
1212             // NOTE: we can reuse the request memory because we deal with
1213             //       the return code
1214             ret := call(3000, 1, 0, size, 128, size, 32)
1215             addr := mload(size)
1216         }
1217 
1218         return (ret, addr);
1219     }
1220 
1221     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1222     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1223         bytes32 r;
1224         bytes32 s;
1225         uint8 v;
1226 
1227         if (sig.length != 65)
1228           return (false, 0);
1229 
1230         // The signature format is a compact form of:
1231         //   {bytes32 r}{bytes32 s}{uint8 v}
1232         // Compact means, uint8 is not padded to 32 bytes.
1233         assembly {
1234             r := mload(add(sig, 32))
1235             s := mload(add(sig, 64))
1236 
1237             // Here we are loading the last 32 bytes. We exploit the fact that
1238             // 'mload' will pad with zeroes if we overread.
1239             // There is no 'mload8' to do this, but that would be nicer.
1240             v := byte(0, mload(add(sig, 96)))
1241 
1242             // Alternative solution:
1243             // 'byte' is not working due to the Solidity parser, so lets
1244             // use the second best option, 'and'
1245             // v := and(mload(add(sig, 65)), 255)
1246         }
1247 
1248         // albeit non-transactional signatures are not specified by the YP, one would expect it
1249         // to match the YP range of [27, 28]
1250         //
1251         // geth uses [0, 1] and some clients have followed. This might change, see:
1252         //  https://github.com/ethereum/go-ethereum/issues/2053
1253         if (v < 27)
1254           v += 27;
1255 
1256         if (v != 27 && v != 28)
1257             return (false, 0);
1258 
1259         return safer_ecrecover(hash, v, r, s);
1260     }
1261 
1262 }
1263 // </ORACLIZE_API>
1264 
1265 /**
1266  * @title Ownable
1267  * @dev The Ownable contract has an owner address, and provides basic authorization control
1268  * functions, this simplifies the implementation of "user permissions".
1269  */
1270 contract Ownable {
1271 
1272   address public owner;
1273 
1274   address public newOwner;
1275 
1276   /**
1277    * @dev Throws if called by any account other than the owner.
1278    */
1279   modifier onlyOwner() {
1280     require(msg.sender == owner);
1281     _;
1282   }
1283 
1284   /**
1285    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1286    * account.
1287    */
1288   constructor() public {
1289     owner = msg.sender;
1290   }
1291 
1292   /**
1293    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1294    * @param _newOwner The address to transfer ownership to.
1295    */
1296   function transferOwnership(address _newOwner) public onlyOwner {
1297     require(_newOwner != address(0));
1298     emit OwnershipTransferred(owner, _newOwner);
1299     owner = _newOwner;
1300   }
1301   
1302   event OwnershipTransferred(address oldOwner, address newOwner);
1303 }
1304 
1305 /**
1306  * @title FUNToken
1307  * @dev ERC20-compliant abstract Token contract.
1308  */
1309 contract FUNToken{
1310   function setCrowdsaleContract (address) public;
1311   function sendCrowdsaleTokens(address, uint256)  public;
1312 }
1313 
1314 /**
1315  * @title FUNCrowdsale
1316  * @dev Crowdsale contract for FUNToken.
1317  */
1318 contract FUNCrowdsale is Ownable, usingOraclize{
1319 
1320   using SafeMath for uint;
1321 
1322   uint decimals = 18;
1323 
1324   // Token contract address
1325   FUNToken public token;
1326 
1327   /* @dev Starting rate ETH/USD
1328   * 1ETH / 'startingExchangePrice' = ~800USD
1329   */
1330   uint public startingExchangePrice = 1165134514779731;
1331 
1332   /* @dev Current rate ETH/USD
1333   * 1ETH / 'USD' = how many USD cost 1 ether
1334   */
1335   uint public USD; //1 USD
1336 
1337   //@dev address to whom will send all Ether from this contract
1338   address public distributionAddress = 0xeb7929309a3E99D6cD8Df875F67487a5F226f7F4;
1339 
1340   /** @dev Crowdsale cunstructor
1341     */
1342   constructor (address _tokenAddress, uint _preIcoStart, uint _preIcoFinish, uint _icoStart, uint _icoFinish) public payable{
1343     // require (msg.value > 0);
1344 
1345     PRE_ICO_START = _preIcoStart;
1346     PRE_ICO_FINISH = _preIcoFinish;
1347 
1348     ICO_START = _icoStart;
1349     ICO_FINISH = _icoFinish;
1350 
1351     token = FUNToken(_tokenAddress);
1352     owner = 0x85BC7DC54c637Dd432e90B91FE803AaA7744E158;
1353     distributionAddress = 0x54f5E2147830083890293a62feee3535eC7d091D;
1354     token.setCrowdsaleContract(this);
1355     
1356     oraclize_setNetwork(networkID_auto);
1357     oraclize = OraclizeI(OAR.getAddress());
1358     
1359     USD = startingExchangePrice;
1360 
1361     oraclizeBalance = msg.value;
1362     
1363     updateFlag = false;
1364     oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
1365   }
1366 
1367   //@dev min deposit for token buyers
1368   uint public constant MIN_DEPOSIT = 0.04 ether;
1369 
1370   //PRE ICO block
1371   //@dev maximum tokens for sell in pre ico stage 
1372   uint public PRE_ICO_MAX_CAP = 7500000 ether; //7 500 000 Tokens
1373 
1374   //@dev pre ico start (timestamp in seconds)
1375   uint public PRE_ICO_START = 0; 
1376 
1377   //@dev pre ico finish (timestamp in seconds)
1378   uint public PRE_ICO_FINISH = 0;
1379 
1380   //@dev how many tokens sold in pre ico stage
1381   uint public preIcoTokensSold;
1382 
1383   /**
1384   * @dev The way to setup pre ico stage.
1385   * @param _start Start pre ico (timestamp in seconds)
1386   * @param _finish Finish pre ico (timestamp in seconds)
1387   */
1388   function setupPreIco (uint _start, uint _finish) public onlyOwner {
1389 
1390     require (PRE_ICO_START == PRE_ICO_FINISH);
1391     
1392     PRE_ICO_START = _start;
1393     PRE_ICO_FINISH = _finish;
1394   }
1395   
1396   //END PRE ICO block
1397 
1398   //ICO block
1399   //@dev ico start (timestamp in seconds)
1400   uint public ICO_START = 0;
1401   //@dev ico start (timestamp in seconds)
1402   uint public ICO_FINISH = 0;
1403 
1404   /**
1405   * @dev The way to setup pre ico stage.
1406   * @param _start Start ico (timestamp in seconds)
1407   * @param _finish Finish ico (timestamp in seconds)
1408   */
1409   function setupIco (uint _start, uint _finish) public onlyOwner{
1410 
1411     require (ICO_START == ICO_FINISH);
1412     
1413     ICO_START = _start;
1414     ICO_FINISH = _finish;
1415   }
1416 
1417   //END ICO Block
1418 
1419   /**
1420   * @dev The way to check is pre ico stage in variable time.
1421   * @param _time Timestamp in seconds
1422   * @return boolean true or false
1423   */
1424   function isPreIco (uint _time) public view returns (bool) {
1425     if (_time == 0){
1426         _time = now;
1427     }
1428     if (PRE_ICO_START < _time && _time <= PRE_ICO_FINISH){
1429         return true;
1430     }
1431     return false;
1432   }
1433 
1434   /**
1435   * @dev The way to check is ico stage in variable time.
1436   * @param _time Timestamp in seconds
1437   * @return boolean true or false
1438   */
1439   function isIco (uint _time) public view returns (bool) {
1440     if (_time == 0){
1441         _time = now;
1442     }
1443     if (ICO_START < _time && _time <= ICO_FINISH){
1444         return true;
1445     }
1446     return false;
1447   }
1448 
1449   /**
1450   * @dev The way to get current token price.
1451   * @param _time Timestamp in seconds
1452   * @return token price in view ETH/result = tokens count 
1453   */
1454   function getTokenPrice (uint _time) public view returns(uint) {
1455     if (_time == 0){
1456         _time = now;
1457     }
1458     if (isPreIco(_time)){
1459         return USD.mul(uint(95))/100;
1460     }
1461     if (isIco(_time)){
1462         if (ICO_START + 2 days <= _time){
1463             return USD;
1464         }
1465         if (ICO_START + 4 weeks <= _time){
1466             return USD.mul(uint(105)/100);
1467         }
1468         return USD.mul(uint(110)/100);
1469     }
1470     return 0;
1471   }
1472 
1473   /**
1474   * @dev The way in which ether is converted to tokens.
1475   * @param _value Value in wei to be converted into tokens
1476   * @param _time Timestamp in seconds
1477   * @return Number of tokens that can be purchased
1478   */
1479   function tokenCalculate (uint _value, uint _time) public view returns(uint)  {
1480     if(_time == 0){
1481         _time = now;
1482     } 
1483     uint tokenPrice = getTokenPrice(_time);
1484     if(tokenPrice == 0){
1485         return 0;
1486     }
1487 
1488     return _value.mul((uint)(10)**(decimals))/tokenPrice;    
1489   }
1490   
1491   //@dev ether achived by this contract
1492   uint public ethCollected = 0;
1493 
1494   //@dev tokens sold by this contract
1495   uint public tokensSold = 0;
1496 
1497   //@dev how many ether sended by each token buyer
1498   mapping (address => uint) public contributorEthCollected;
1499 
1500   //@dev event when someone bought tokens by ETH
1501   event OnSuccessBuy (address indexed _address, uint indexed _EthValue, uint _tokenValue);
1502 
1503    /// @dev in payable we shold keep only forwarding call
1504   function () public payable {
1505     require (msg.value >= MIN_DEPOSIT);
1506     require (isIco(now) || isPreIco(now));
1507     require (buy(msg.sender, msg.value, now));
1508   }
1509   
1510   /**
1511    * @dev gets `_address`, `_value` and '_time' as input and sells tokens
1512    * throws if not enough tokens after calculation
1513    * @return isSold bool whether tokens bought
1514    */
1515   function buy (address _address, uint _value, uint _time) internal returns(bool) {
1516     uint tokensToSend = tokenCalculate(_value, _time);
1517     
1518     if (isPreIco(_time)){
1519         require (preIcoTokensSold.add(tokensToSend) <= PRE_ICO_MAX_CAP);
1520         
1521         preIcoTokensSold = preIcoTokensSold.add(tokensToSend);
1522         token.sendCrowdsaleTokens(_address,tokensToSend);
1523         distributeEther();
1524     }else{
1525         contributorEthCollected[_address] += _value;
1526         token.sendCrowdsaleTokens(_address,tokensToSend);
1527         distributeEther();
1528     }
1529 
1530     ethCollected = ethCollected.add(_value);
1531     tokensSold = tokensSold.add(tokensToSend);
1532 
1533     emit OnSuccessBuy(_address, _value, tokensToSend);
1534 
1535     return true;
1536   }
1537 
1538   //@dev function to send all contract ether to 'distributionAddress'
1539   function distributeEther () internal {
1540     distributionAddress.transfer(address(this).balance);
1541   }
1542   
1543   /*@dev function to manual send ETH
1544    *@param _address Address to whom will send tokens
1545    *@param _value For how many ETH mus count tokens 
1546   */  
1547   function manualSendEther (address _address, uint _value) external onlyOwner {
1548     uint tokensToSend = tokenCalculate(_value, now);
1549     token.sendCrowdsaleTokens(_address,tokensToSend);
1550     ethCollected = ethCollected.add(_value);
1551     tokensSold = tokensSold.add(tokensToSend);
1552   }
1553 
1554   function manualSendTokens (address _address, uint _value) external onlyOwner {
1555     token.sendCrowdsaleTokens(_address,_value);
1556     tokensSold = tokensSold.add(_value);
1557   }
1558   
1559   // ORACLIZE functions
1560 
1561   //@dev balance for update current rates
1562   uint public oraclizeBalance;
1563 
1564   //@dev automatically updete flag
1565   bool public updateFlag;
1566 
1567   //@dev last rates updated (timestamp in seconds)
1568   uint public priceUpdateAt;
1569 
1570   //@dev function to update current rate. Each update cost ~0.004ETH
1571   function update() internal {
1572     oraclize_query(86400,"URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
1573     //86400 - 1 day (seconds)
1574   
1575     oraclizeBalance = oraclizeBalance.sub(oraclize_getPrice("URL")); //request to oraclize
1576   }
1577 
1578   //@dev function to start updating current rates
1579   //can be called only when 'updateFlag' is false
1580   function startOraclize (uint _time) public onlyOwner {
1581     require (_time != 0);
1582     require (!updateFlag);
1583     
1584     updateFlag = true;
1585     oraclize_query(_time,"URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
1586     oraclizeBalance = oraclizeBalance.sub(oraclize_getPrice("URL"));
1587   }
1588 
1589   //@dev add some ETH for oraclize updater 
1590   function addEtherForOraclize () public payable {
1591     oraclizeBalance = oraclizeBalance.add(msg.value);
1592   }
1593 
1594   //@dev Take all oraclize ether to contract owner and
1595   //stop automatically update
1596   function requestOraclizeBalance () public onlyOwner {
1597     updateFlag = false;
1598     if (address(this).balance >= oraclizeBalance){
1599       owner.transfer(oraclizeBalance);
1600     }else{
1601       owner.transfer(address(this).balance);
1602     }
1603     oraclizeBalance = 0;
1604   }
1605   
1606   //@dev Stop oraclize automatically update manual
1607   function stopOraclize () public onlyOwner {
1608     updateFlag = false;
1609   }
1610 
1611   //@dev function to take current rates info from Oraclize
1612   //this function updating current price('USD') and 'priceUpdateAt'
1613   function __callback(bytes32, string result, bytes) public {
1614     require(msg.sender == oraclize_cbAddress());
1615 
1616     uint256 price = 10 ** 23 / parseInt(result, 5);
1617 
1618     require(price > 0);
1619     USD = price;
1620 
1621     priceUpdateAt = block.timestamp;
1622             
1623     if(updateFlag){
1624       update();
1625     }
1626   }
1627   //end ORACLIZE functions
1628 }