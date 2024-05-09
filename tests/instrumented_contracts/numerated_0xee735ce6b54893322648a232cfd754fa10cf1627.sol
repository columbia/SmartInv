1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
21    */
22   constructor() public {
23     owner = msg.sender;
24   }
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   /**
35    * @dev Allows the current owner to relinquish control of the contract.
36    */
37   function renounceOwnership() public onlyOwner {
38     emit OwnershipRenounced(owner);
39     owner = address(0);
40   }
41 
42   /**
43    * @dev Allows the current owner to transfer control of the contract to a newOwner.
44    * @param _newOwner The address to transfer ownership to.
45    */
46   function transferOwnership(address _newOwner) public onlyOwner {
47     _transferOwnership(_newOwner);
48   }
49 
50   /**
51    * @dev Transfers control of the contract to a newOwner.
52    * @param _newOwner The address to transfer ownership to.
53    */
54   function _transferOwnership(address _newOwner) internal {
55     require(_newOwner != address(0));
56     emit OwnershipTransferred(owner, _newOwner);
57     owner = _newOwner;
58   }
59 }
60 /**
61  * @title SafeMath
62  * @dev Math operations with safety checks that throw on error
63  */
64 library SafeMath {
65 
66   /**
67   * @dev Multiplies two numbers, throws on overflow.
68   */
69   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
70     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
71     // benefit is lost if 'b' is also tested.
72     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
73     if (a == 0) {
74       return 0;
75     }
76 
77     c = a * b;
78     assert(c / a == b);
79     return c;
80   }
81 
82   /**
83   * @dev Integer division of two numbers, truncating the quotient.
84   */
85   function div(uint256 a, uint256 b) internal pure returns (uint256) {
86     // assert(b > 0); // Solidity automatically throws when dividing by 0
87     // uint256 c = a / b;
88     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89     return a / b;
90   }
91 
92   /**
93   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
94   */
95   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96     assert(b <= a);
97     return a - b;
98   }
99 
100   /**
101   * @dev Adds two numbers, throws on overflow.
102   */
103   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
104     c = a + b;
105     assert(c >= a);
106     return c;
107   }
108 }
109 // <ORACLIZE_API>
110 /*
111 Copyright (c) 2015-2016 Oraclize SRL
112 Copyright (c) 2016 Oraclize LTD
113 
114 
115 
116 Permission is hereby granted, free of charge, to any person obtaining a copy
117 of this software and associated documentation files (the "Software"), to deal
118 in the Software without restriction, including without limitation the rights
119 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
120 copies of the Software, and to permit persons to whom the Software is
121 furnished to do so, subject to the following conditions:
122 
123 
124 
125 The above copyright notice and this permission notice shall be included in
126 all copies or substantial portions of the Software.
127 
128 
129 
130 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
131 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
132 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
133 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
134 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
135 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
136 THE SOFTWARE.
137 */
138 
139 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
140 
141 pragma solidity >=0.4.18;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
142 
143 contract OraclizeI {
144     address public cbAddress;
145     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
146     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
147     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
148     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
149     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
150     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
151     function getPrice(string _datasource) public returns (uint _dsprice);
152     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
153     function setProofType(byte _proofType) external;
154     function setCustomGasPrice(uint _gasPrice) external;
155     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
156 }
157 
158 contract OraclizeAddrResolverI {
159     function getAddress() public returns (address _addr);
160 }
161 
162 /*
163 Begin solidity-cborutils
164 
165 https://github.com/smartcontractkit/solidity-cborutils
166 
167 MIT License
168 
169 Copyright (c) 2018 SmartContract ChainLink, Ltd.
170 
171 Permission is hereby granted, free of charge, to any person obtaining a copy
172 of this software and associated documentation files (the "Software"), to deal
173 in the Software without restriction, including without limitation the rights
174 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
175 copies of the Software, and to permit persons to whom the Software is
176 furnished to do so, subject to the following conditions:
177 
178 The above copyright notice and this permission notice shall be included in all
179 copies or substantial portions of the Software.
180 
181 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
182 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
183 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
184 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
185 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
186 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
187 SOFTWARE.
188  */
189 
190 library Buffer {
191     struct buffer {
192         bytes buf;
193         uint capacity;
194     }
195 
196     function init(buffer memory buf, uint _capacity) internal pure {
197         uint capacity = _capacity;
198         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
199         // Allocate space for the buffer data
200         buf.capacity = capacity;
201         assembly {
202             let ptr := mload(0x40)
203             mstore(buf, ptr)
204             mstore(ptr, 0)
205             mstore(0x40, add(ptr, capacity))
206         }
207     }
208 
209     function resize(buffer memory buf, uint capacity) private pure {
210         bytes memory oldbuf = buf.buf;
211         init(buf, capacity);
212         append(buf, oldbuf);
213     }
214 
215     function max(uint a, uint b) private pure returns(uint) {
216         if(a > b) {
217             return a;
218         }
219         return b;
220     }
221 
222     /**
223      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
224      *      would exceed the capacity of the buffer.
225      * @param buf The buffer to append to.
226      * @param data The data to append.
227      * @return The original buffer.
228      */
229     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
230         if(data.length + buf.buf.length > buf.capacity) {
231             resize(buf, max(buf.capacity, data.length) * 2);
232         }
233 
234         uint dest;
235         uint src;
236         uint len = data.length;
237         assembly {
238         // Memory address of the buffer data
239             let bufptr := mload(buf)
240         // Length of existing buffer data
241             let buflen := mload(bufptr)
242         // Start address = buffer address + buffer length + sizeof(buffer length)
243             dest := add(add(bufptr, buflen), 32)
244         // Update buffer length
245             mstore(bufptr, add(buflen, mload(data)))
246             src := add(data, 32)
247         }
248 
249         // Copy word-length chunks while possible
250         for(; len >= 32; len -= 32) {
251             assembly {
252                 mstore(dest, mload(src))
253             }
254             dest += 32;
255             src += 32;
256         }
257 
258         // Copy remaining bytes
259         uint mask = 256 ** (32 - len) - 1;
260         assembly {
261             let srcpart := and(mload(src), not(mask))
262             let destpart := and(mload(dest), mask)
263             mstore(dest, or(destpart, srcpart))
264         }
265 
266         return buf;
267     }
268 
269     /**
270      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
271      * exceed the capacity of the buffer.
272      * @param buf The buffer to append to.
273      * @param data The data to append.
274      * @return The original buffer.
275      */
276     function append(buffer memory buf, uint8 data) internal pure {
277         if(buf.buf.length + 1 > buf.capacity) {
278             resize(buf, buf.capacity * 2);
279         }
280 
281         assembly {
282         // Memory address of the buffer data
283             let bufptr := mload(buf)
284         // Length of existing buffer data
285             let buflen := mload(bufptr)
286         // Address = buffer address + buffer length + sizeof(buffer length)
287             let dest := add(add(bufptr, buflen), 32)
288             mstore8(dest, data)
289         // Update buffer length
290             mstore(bufptr, add(buflen, 1))
291         }
292     }
293 
294     /**
295      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
296      * exceed the capacity of the buffer.
297      * @param buf The buffer to append to.
298      * @param data The data to append.
299      * @return The original buffer.
300      */
301     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
302         if(len + buf.buf.length > buf.capacity) {
303             resize(buf, max(buf.capacity, len) * 2);
304         }
305 
306         uint mask = 256 ** len - 1;
307         assembly {
308         // Memory address of the buffer data
309             let bufptr := mload(buf)
310         // Length of existing buffer data
311             let buflen := mload(bufptr)
312         // Address = buffer address + buffer length + sizeof(buffer length) + len
313             let dest := add(add(bufptr, buflen), len)
314             mstore(dest, or(and(mload(dest), not(mask)), data))
315         // Update buffer length
316             mstore(bufptr, add(buflen, len))
317         }
318         return buf;
319     }
320 }
321 
322 library CBOR {
323     using Buffer for Buffer.buffer;
324 
325     uint8 private constant MAJOR_TYPE_INT = 0;
326     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
327     uint8 private constant MAJOR_TYPE_BYTES = 2;
328     uint8 private constant MAJOR_TYPE_STRING = 3;
329     uint8 private constant MAJOR_TYPE_ARRAY = 4;
330     uint8 private constant MAJOR_TYPE_MAP = 5;
331     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
332 
333     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
334         if(value <= 23) {
335             buf.append(uint8((major << 5) | value));
336         } else if(value <= 0xFF) {
337             buf.append(uint8((major << 5) | 24));
338             buf.appendInt(value, 1);
339         } else if(value <= 0xFFFF) {
340             buf.append(uint8((major << 5) | 25));
341             buf.appendInt(value, 2);
342         } else if(value <= 0xFFFFFFFF) {
343             buf.append(uint8((major << 5) | 26));
344             buf.appendInt(value, 4);
345         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
346             buf.append(uint8((major << 5) | 27));
347             buf.appendInt(value, 8);
348         }
349     }
350 
351     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
352         buf.append(uint8((major << 5) | 31));
353     }
354 
355     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
356         encodeType(buf, MAJOR_TYPE_INT, value);
357     }
358 
359     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
360         if(value >= 0) {
361             encodeType(buf, MAJOR_TYPE_INT, uint(value));
362         } else {
363             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
364         }
365     }
366 
367     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
368         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
369         buf.append(value);
370     }
371 
372     function encodeString(Buffer.buffer memory buf, string value) internal pure {
373         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
374         buf.append(bytes(value));
375     }
376 
377     function startArray(Buffer.buffer memory buf) internal pure {
378         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
379     }
380 
381     function startMap(Buffer.buffer memory buf) internal pure {
382         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
383     }
384 
385     function endSequence(Buffer.buffer memory buf) internal pure {
386         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
387     }
388 }
389 
390 /*
391 End solidity-cborutils
392  */
393 
394 contract usingOraclize {
395     uint constant day = 60*60*24;
396     uint constant week = 60*60*24*7;
397     uint constant month = 60*60*24*30;
398     byte constant proofType_NONE = 0x00;
399     byte constant proofType_TLSNotary = 0x10;
400     byte constant proofType_Ledger = 0x30;
401     byte constant proofType_Android = 0x40;
402     byte constant proofType_Native = 0xF0;
403     byte constant proofStorage_IPFS = 0x01;
404     uint8 constant networkID_auto = 0;
405     uint8 constant networkID_mainnet = 1;
406     uint8 constant networkID_testnet = 2;
407     uint8 constant networkID_morden = 2;
408     uint8 constant networkID_consensys = 161;
409 
410     OraclizeAddrResolverI OAR;
411 
412     OraclizeI oraclize;
413     modifier oraclizeAPI {
414         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
415             oraclize_setNetwork(networkID_auto);
416 
417         if(address(oraclize) != OAR.getAddress())
418             oraclize = OraclizeI(OAR.getAddress());
419 
420         _;
421     }
422     modifier coupon(string code){
423         oraclize = OraclizeI(OAR.getAddress());
424         _;
425     }
426 
427     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
428         return oraclize_setNetwork();
429         networkID; // silence the warning and remain backwards compatible
430     }
431     function oraclize_setNetwork() internal returns(bool){
432         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
433             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
434             oraclize_setNetworkName("eth_mainnet");
435             return true;
436         }
437         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
438             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
439             oraclize_setNetworkName("eth_ropsten3");
440             return true;
441         }
442         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
443             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
444             oraclize_setNetworkName("eth_kovan");
445             return true;
446         }
447         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
448             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
449             oraclize_setNetworkName("eth_rinkeby");
450             return true;
451         }
452         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
453             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
454             return true;
455         }
456         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
457             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
458             return true;
459         }
460         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
461             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
462             return true;
463         }
464         return false;
465     }
466 
467     function __callback(bytes32 myid, string result) public {
468         __callback(myid, result, new bytes(0));
469     }
470     function __callback(bytes32 myid, string result, bytes proof) public {
471         return;
472         myid; result; proof; // Silence compiler warnings
473     }
474 
475     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
476         return oraclize.getPrice(datasource);
477     }
478 
479     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
480         return oraclize.getPrice(datasource, gaslimit);
481     }
482 
483     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
484         uint price = oraclize.getPrice(datasource);
485         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
486         return oraclize.query.value(price)(0, datasource, arg);
487     }
488     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
489         uint price = oraclize.getPrice(datasource);
490         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
491         return oraclize.query.value(price)(timestamp, datasource, arg);
492     }
493     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
494         uint price = oraclize.getPrice(datasource, gaslimit);
495         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
496         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
497     }
498     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
499         uint price = oraclize.getPrice(datasource, gaslimit);
500         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
501         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
502     }
503     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
504         uint price = oraclize.getPrice(datasource);
505         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
506         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
507     }
508     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
509         uint price = oraclize.getPrice(datasource);
510         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
511         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
512     }
513     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
514         uint price = oraclize.getPrice(datasource, gaslimit);
515         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
516         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
517     }
518     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
519         uint price = oraclize.getPrice(datasource, gaslimit);
520         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
521         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
522     }
523     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
524         uint price = oraclize.getPrice(datasource);
525         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
526         bytes memory args = stra2cbor(argN);
527         return oraclize.queryN.value(price)(0, datasource, args);
528     }
529     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
530         uint price = oraclize.getPrice(datasource);
531         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
532         bytes memory args = stra2cbor(argN);
533         return oraclize.queryN.value(price)(timestamp, datasource, args);
534     }
535     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
536         uint price = oraclize.getPrice(datasource, gaslimit);
537         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
538         bytes memory args = stra2cbor(argN);
539         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
540     }
541     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
542         uint price = oraclize.getPrice(datasource, gaslimit);
543         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
544         bytes memory args = stra2cbor(argN);
545         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
546     }
547     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
548         string[] memory dynargs = new string[](1);
549         dynargs[0] = args[0];
550         return oraclize_query(datasource, dynargs);
551     }
552     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
553         string[] memory dynargs = new string[](1);
554         dynargs[0] = args[0];
555         return oraclize_query(timestamp, datasource, dynargs);
556     }
557     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
558         string[] memory dynargs = new string[](1);
559         dynargs[0] = args[0];
560         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
561     }
562     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
563         string[] memory dynargs = new string[](1);
564         dynargs[0] = args[0];
565         return oraclize_query(datasource, dynargs, gaslimit);
566     }
567 
568     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
569         string[] memory dynargs = new string[](2);
570         dynargs[0] = args[0];
571         dynargs[1] = args[1];
572         return oraclize_query(datasource, dynargs);
573     }
574     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
575         string[] memory dynargs = new string[](2);
576         dynargs[0] = args[0];
577         dynargs[1] = args[1];
578         return oraclize_query(timestamp, datasource, dynargs);
579     }
580     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
581         string[] memory dynargs = new string[](2);
582         dynargs[0] = args[0];
583         dynargs[1] = args[1];
584         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
585     }
586     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
587         string[] memory dynargs = new string[](2);
588         dynargs[0] = args[0];
589         dynargs[1] = args[1];
590         return oraclize_query(datasource, dynargs, gaslimit);
591     }
592     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
593         string[] memory dynargs = new string[](3);
594         dynargs[0] = args[0];
595         dynargs[1] = args[1];
596         dynargs[2] = args[2];
597         return oraclize_query(datasource, dynargs);
598     }
599     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
600         string[] memory dynargs = new string[](3);
601         dynargs[0] = args[0];
602         dynargs[1] = args[1];
603         dynargs[2] = args[2];
604         return oraclize_query(timestamp, datasource, dynargs);
605     }
606     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
607         string[] memory dynargs = new string[](3);
608         dynargs[0] = args[0];
609         dynargs[1] = args[1];
610         dynargs[2] = args[2];
611         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
612     }
613     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
614         string[] memory dynargs = new string[](3);
615         dynargs[0] = args[0];
616         dynargs[1] = args[1];
617         dynargs[2] = args[2];
618         return oraclize_query(datasource, dynargs, gaslimit);
619     }
620 
621     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
622         string[] memory dynargs = new string[](4);
623         dynargs[0] = args[0];
624         dynargs[1] = args[1];
625         dynargs[2] = args[2];
626         dynargs[3] = args[3];
627         return oraclize_query(datasource, dynargs);
628     }
629     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
630         string[] memory dynargs = new string[](4);
631         dynargs[0] = args[0];
632         dynargs[1] = args[1];
633         dynargs[2] = args[2];
634         dynargs[3] = args[3];
635         return oraclize_query(timestamp, datasource, dynargs);
636     }
637     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
638         string[] memory dynargs = new string[](4);
639         dynargs[0] = args[0];
640         dynargs[1] = args[1];
641         dynargs[2] = args[2];
642         dynargs[3] = args[3];
643         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
644     }
645     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
646         string[] memory dynargs = new string[](4);
647         dynargs[0] = args[0];
648         dynargs[1] = args[1];
649         dynargs[2] = args[2];
650         dynargs[3] = args[3];
651         return oraclize_query(datasource, dynargs, gaslimit);
652     }
653     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
654         string[] memory dynargs = new string[](5);
655         dynargs[0] = args[0];
656         dynargs[1] = args[1];
657         dynargs[2] = args[2];
658         dynargs[3] = args[3];
659         dynargs[4] = args[4];
660         return oraclize_query(datasource, dynargs);
661     }
662     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
663         string[] memory dynargs = new string[](5);
664         dynargs[0] = args[0];
665         dynargs[1] = args[1];
666         dynargs[2] = args[2];
667         dynargs[3] = args[3];
668         dynargs[4] = args[4];
669         return oraclize_query(timestamp, datasource, dynargs);
670     }
671     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
672         string[] memory dynargs = new string[](5);
673         dynargs[0] = args[0];
674         dynargs[1] = args[1];
675         dynargs[2] = args[2];
676         dynargs[3] = args[3];
677         dynargs[4] = args[4];
678         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
679     }
680     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
681         string[] memory dynargs = new string[](5);
682         dynargs[0] = args[0];
683         dynargs[1] = args[1];
684         dynargs[2] = args[2];
685         dynargs[3] = args[3];
686         dynargs[4] = args[4];
687         return oraclize_query(datasource, dynargs, gaslimit);
688     }
689     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
690         uint price = oraclize.getPrice(datasource);
691         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
692         bytes memory args = ba2cbor(argN);
693         return oraclize.queryN.value(price)(0, datasource, args);
694     }
695     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
696         uint price = oraclize.getPrice(datasource);
697         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
698         bytes memory args = ba2cbor(argN);
699         return oraclize.queryN.value(price)(timestamp, datasource, args);
700     }
701     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
702         uint price = oraclize.getPrice(datasource, gaslimit);
703         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
704         bytes memory args = ba2cbor(argN);
705         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
706     }
707     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
708         uint price = oraclize.getPrice(datasource, gaslimit);
709         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
710         bytes memory args = ba2cbor(argN);
711         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
712     }
713     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
714         bytes[] memory dynargs = new bytes[](1);
715         dynargs[0] = args[0];
716         return oraclize_query(datasource, dynargs);
717     }
718     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
719         bytes[] memory dynargs = new bytes[](1);
720         dynargs[0] = args[0];
721         return oraclize_query(timestamp, datasource, dynargs);
722     }
723     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
724         bytes[] memory dynargs = new bytes[](1);
725         dynargs[0] = args[0];
726         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
727     }
728     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
729         bytes[] memory dynargs = new bytes[](1);
730         dynargs[0] = args[0];
731         return oraclize_query(datasource, dynargs, gaslimit);
732     }
733 
734     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
735         bytes[] memory dynargs = new bytes[](2);
736         dynargs[0] = args[0];
737         dynargs[1] = args[1];
738         return oraclize_query(datasource, dynargs);
739     }
740     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
741         bytes[] memory dynargs = new bytes[](2);
742         dynargs[0] = args[0];
743         dynargs[1] = args[1];
744         return oraclize_query(timestamp, datasource, dynargs);
745     }
746     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
747         bytes[] memory dynargs = new bytes[](2);
748         dynargs[0] = args[0];
749         dynargs[1] = args[1];
750         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
751     }
752     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
753         bytes[] memory dynargs = new bytes[](2);
754         dynargs[0] = args[0];
755         dynargs[1] = args[1];
756         return oraclize_query(datasource, dynargs, gaslimit);
757     }
758     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
759         bytes[] memory dynargs = new bytes[](3);
760         dynargs[0] = args[0];
761         dynargs[1] = args[1];
762         dynargs[2] = args[2];
763         return oraclize_query(datasource, dynargs);
764     }
765     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
766         bytes[] memory dynargs = new bytes[](3);
767         dynargs[0] = args[0];
768         dynargs[1] = args[1];
769         dynargs[2] = args[2];
770         return oraclize_query(timestamp, datasource, dynargs);
771     }
772     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
773         bytes[] memory dynargs = new bytes[](3);
774         dynargs[0] = args[0];
775         dynargs[1] = args[1];
776         dynargs[2] = args[2];
777         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
778     }
779     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
780         bytes[] memory dynargs = new bytes[](3);
781         dynargs[0] = args[0];
782         dynargs[1] = args[1];
783         dynargs[2] = args[2];
784         return oraclize_query(datasource, dynargs, gaslimit);
785     }
786 
787     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
788         bytes[] memory dynargs = new bytes[](4);
789         dynargs[0] = args[0];
790         dynargs[1] = args[1];
791         dynargs[2] = args[2];
792         dynargs[3] = args[3];
793         return oraclize_query(datasource, dynargs);
794     }
795     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
796         bytes[] memory dynargs = new bytes[](4);
797         dynargs[0] = args[0];
798         dynargs[1] = args[1];
799         dynargs[2] = args[2];
800         dynargs[3] = args[3];
801         return oraclize_query(timestamp, datasource, dynargs);
802     }
803     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
804         bytes[] memory dynargs = new bytes[](4);
805         dynargs[0] = args[0];
806         dynargs[1] = args[1];
807         dynargs[2] = args[2];
808         dynargs[3] = args[3];
809         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
810     }
811     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
812         bytes[] memory dynargs = new bytes[](4);
813         dynargs[0] = args[0];
814         dynargs[1] = args[1];
815         dynargs[2] = args[2];
816         dynargs[3] = args[3];
817         return oraclize_query(datasource, dynargs, gaslimit);
818     }
819     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
820         bytes[] memory dynargs = new bytes[](5);
821         dynargs[0] = args[0];
822         dynargs[1] = args[1];
823         dynargs[2] = args[2];
824         dynargs[3] = args[3];
825         dynargs[4] = args[4];
826         return oraclize_query(datasource, dynargs);
827     }
828     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
829         bytes[] memory dynargs = new bytes[](5);
830         dynargs[0] = args[0];
831         dynargs[1] = args[1];
832         dynargs[2] = args[2];
833         dynargs[3] = args[3];
834         dynargs[4] = args[4];
835         return oraclize_query(timestamp, datasource, dynargs);
836     }
837     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
838         bytes[] memory dynargs = new bytes[](5);
839         dynargs[0] = args[0];
840         dynargs[1] = args[1];
841         dynargs[2] = args[2];
842         dynargs[3] = args[3];
843         dynargs[4] = args[4];
844         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
845     }
846     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
847         bytes[] memory dynargs = new bytes[](5);
848         dynargs[0] = args[0];
849         dynargs[1] = args[1];
850         dynargs[2] = args[2];
851         dynargs[3] = args[3];
852         dynargs[4] = args[4];
853         return oraclize_query(datasource, dynargs, gaslimit);
854     }
855 
856     function oraclize_cbAddress() oraclizeAPI internal returns (address){
857         return oraclize.cbAddress();
858     }
859     function oraclize_setProof(byte proofP) oraclizeAPI internal {
860         return oraclize.setProofType(proofP);
861     }
862     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
863         return oraclize.setCustomGasPrice(gasPrice);
864     }
865 
866     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
867         return oraclize.randomDS_getSessionPubKeyHash();
868     }
869 
870     function getCodeSize(address _addr) constant internal returns(uint _size) {
871         assembly {
872             _size := extcodesize(_addr)
873         }
874     }
875 
876     function parseAddr(string _a) internal pure returns (address){
877         bytes memory tmp = bytes(_a);
878         uint160 iaddr = 0;
879         uint160 b1;
880         uint160 b2;
881         for (uint i=2; i<2+2*20; i+=2){
882             iaddr *= 256;
883             b1 = uint160(tmp[i]);
884             b2 = uint160(tmp[i+1]);
885             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
886             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
887             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
888             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
889             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
890             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
891             iaddr += (b1*16+b2);
892         }
893         return address(iaddr);
894     }
895 
896     function strCompare(string _a, string _b) internal pure returns (int) {
897         bytes memory a = bytes(_a);
898         bytes memory b = bytes(_b);
899         uint minLength = a.length;
900         if (b.length < minLength) minLength = b.length;
901         for (uint i = 0; i < minLength; i ++)
902             if (a[i] < b[i])
903                 return -1;
904             else if (a[i] > b[i])
905                 return 1;
906         if (a.length < b.length)
907             return -1;
908         else if (a.length > b.length)
909             return 1;
910         else
911             return 0;
912     }
913 
914     function indexOf(string _haystack, string _needle) internal pure returns (int) {
915         bytes memory h = bytes(_haystack);
916         bytes memory n = bytes(_needle);
917         if(h.length < 1 || n.length < 1 || (n.length > h.length))
918             return -1;
919         else if(h.length > (2**128 -1))
920             return -1;
921         else
922         {
923             uint subindex = 0;
924             for (uint i = 0; i < h.length; i ++)
925             {
926                 if (h[i] == n[0])
927                 {
928                     subindex = 1;
929                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
930                     {
931                         subindex++;
932                     }
933                     if(subindex == n.length)
934                         return int(i);
935                 }
936             }
937             return -1;
938         }
939     }
940 
941     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
942         bytes memory _ba = bytes(_a);
943         bytes memory _bb = bytes(_b);
944         bytes memory _bc = bytes(_c);
945         bytes memory _bd = bytes(_d);
946         bytes memory _be = bytes(_e);
947         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
948         bytes memory babcde = bytes(abcde);
949         uint k = 0;
950         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
951         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
952         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
953         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
954         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
955         return string(babcde);
956     }
957 
958     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
959         return strConcat(_a, _b, _c, _d, "");
960     }
961 
962     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
963         return strConcat(_a, _b, _c, "", "");
964     }
965 
966     function strConcat(string _a, string _b) internal pure returns (string) {
967         return strConcat(_a, _b, "", "", "");
968     }
969 
970     // parseInt
971     function parseInt(string _a) internal pure returns (uint) {
972         return parseInt(_a, 0);
973     }
974 
975     // parseInt(parseFloat*10^_b)
976     function parseInt(string _a, uint _b) internal pure returns (uint) {
977         bytes memory bresult = bytes(_a);
978         uint mint = 0;
979         bool decimals = false;
980         for (uint i=0; i<bresult.length; i++){
981             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
982                 if (decimals){
983                     if (_b == 0) break;
984                     else _b--;
985                 }
986                 mint *= 10;
987                 mint += uint(bresult[i]) - 48;
988             } else if (bresult[i] == 46) decimals = true;
989         }
990         if (_b > 0) mint *= 10**_b;
991         return mint;
992     }
993 
994     function uint2str(uint i) internal pure returns (string){
995         if (i == 0) return "0";
996         uint j = i;
997         uint len;
998         while (j != 0){
999             len++;
1000             j /= 10;
1001         }
1002         bytes memory bstr = new bytes(len);
1003         uint k = len - 1;
1004         while (i != 0){
1005             bstr[k--] = byte(48 + i % 10);
1006             i /= 10;
1007         }
1008         return string(bstr);
1009     }
1010 
1011     using CBOR for Buffer.buffer;
1012     function stra2cbor(string[] arr) internal pure returns (bytes) {
1013         safeMemoryCleaner();
1014         Buffer.buffer memory buf;
1015         Buffer.init(buf, 1024);
1016         buf.startArray();
1017         for (uint i = 0; i < arr.length; i++) {
1018             buf.encodeString(arr[i]);
1019         }
1020         buf.endSequence();
1021         return buf.buf;
1022     }
1023 
1024     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
1025         safeMemoryCleaner();
1026         Buffer.buffer memory buf;
1027         Buffer.init(buf, 1024);
1028         buf.startArray();
1029         for (uint i = 0; i < arr.length; i++) {
1030             buf.encodeBytes(arr[i]);
1031         }
1032         buf.endSequence();
1033         return buf.buf;
1034     }
1035 
1036     string oraclize_network_name;
1037     function oraclize_setNetworkName(string _network_name) internal {
1038         oraclize_network_name = _network_name;
1039     }
1040 
1041     function oraclize_getNetworkName() internal view returns (string) {
1042         return oraclize_network_name;
1043     }
1044 
1045     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1046         require((_nbytes > 0) && (_nbytes <= 32));
1047         // Convert from seconds to ledger timer ticks
1048         _delay *= 10;
1049         bytes memory nbytes = new bytes(1);
1050         nbytes[0] = byte(_nbytes);
1051         bytes memory unonce = new bytes(32);
1052         bytes memory sessionKeyHash = new bytes(32);
1053         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1054         assembly {
1055             mstore(unonce, 0x20)
1056         // the following variables can be relaxed
1057         // check relaxed random contract under ethereum-examples repo
1058         // for an idea on how to override and replace comit hash vars
1059             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1060             mstore(sessionKeyHash, 0x20)
1061             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1062         }
1063         bytes memory delay = new bytes(32);
1064         assembly {
1065             mstore(add(delay, 0x20), _delay)
1066         }
1067 
1068         bytes memory delay_bytes8 = new bytes(8);
1069         copyBytes(delay, 24, 8, delay_bytes8, 0);
1070 
1071         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1072         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1073 
1074         bytes memory delay_bytes8_left = new bytes(8);
1075 
1076         assembly {
1077             let x := mload(add(delay_bytes8, 0x20))
1078             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1079             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1080             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1081             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1082             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1083             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1084             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1085             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1086 
1087         }
1088 
1089         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1090         return queryId;
1091     }
1092 
1093     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1094         oraclize_randomDS_args[queryId] = commitment;
1095     }
1096 
1097     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1098     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1099 
1100     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1101         bool sigok;
1102         address signer;
1103 
1104         bytes32 sigr;
1105         bytes32 sigs;
1106 
1107         bytes memory sigr_ = new bytes(32);
1108         uint offset = 4+(uint(dersig[3]) - 0x20);
1109         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1110         bytes memory sigs_ = new bytes(32);
1111         offset += 32 + 2;
1112         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1113 
1114         assembly {
1115             sigr := mload(add(sigr_, 32))
1116             sigs := mload(add(sigs_, 32))
1117         }
1118 
1119 
1120         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1121         if (address(keccak256(pubkey)) == signer) return true;
1122         else {
1123             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1124             return (address(keccak256(pubkey)) == signer);
1125         }
1126     }
1127 
1128     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1129         bool sigok;
1130 
1131         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1132         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1133         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1134 
1135         bytes memory appkey1_pubkey = new bytes(64);
1136         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1137 
1138         bytes memory tosign2 = new bytes(1+65+32);
1139         tosign2[0] = byte(1); //role
1140         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1141         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1142         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1143         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1144 
1145         if (sigok == false) return false;
1146 
1147 
1148         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1149         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1150 
1151         bytes memory tosign3 = new bytes(1+65);
1152         tosign3[0] = 0xFE;
1153         copyBytes(proof, 3, 65, tosign3, 1);
1154 
1155         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1156         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1157 
1158         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1159 
1160         return sigok;
1161     }
1162 
1163     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1164         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1165         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1166 
1167         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1168         require(proofVerified);
1169 
1170         _;
1171     }
1172 
1173     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1174         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1175         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1176 
1177         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1178         if (proofVerified == false) return 2;
1179 
1180         return 0;
1181     }
1182 
1183     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1184         bool match_ = true;
1185 
1186         require(prefix.length == n_random_bytes);
1187 
1188         for (uint256 i=0; i< n_random_bytes; i++) {
1189             if (content[i] != prefix[i]) match_ = false;
1190         }
1191 
1192         return match_;
1193     }
1194 
1195     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1196 
1197         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1198         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1199         bytes memory keyhash = new bytes(32);
1200         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1201         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1202 
1203         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1204         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1205 
1206         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1207         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1208 
1209         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1210         // This is to verify that the computed args match with the ones specified in the query.
1211         bytes memory commitmentSlice1 = new bytes(8+1+32);
1212         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1213 
1214         bytes memory sessionPubkey = new bytes(64);
1215         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1216         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1217 
1218         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1219         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1220             delete oraclize_randomDS_args[queryId];
1221         } else return false;
1222 
1223 
1224         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1225         bytes memory tosign1 = new bytes(32+8+1+32);
1226         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1227         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1228 
1229         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1230         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1231             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1232         }
1233 
1234         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1235     }
1236 
1237     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1238     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1239         uint minLength = length + toOffset;
1240 
1241         // Buffer too small
1242         require(to.length >= minLength); // Should be a better way?
1243 
1244         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1245         uint i = 32 + fromOffset;
1246         uint j = 32 + toOffset;
1247 
1248         while (i < (32 + fromOffset + length)) {
1249             assembly {
1250                 let tmp := mload(add(from, i))
1251                 mstore(add(to, j), tmp)
1252             }
1253             i += 32;
1254             j += 32;
1255         }
1256 
1257         return to;
1258     }
1259 
1260     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1261     // Duplicate Solidity's ecrecover, but catching the CALL return value
1262     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1263         // We do our own memory management here. Solidity uses memory offset
1264         // 0x40 to store the current end of memory. We write past it (as
1265         // writes are memory extensions), but don't update the offset so
1266         // Solidity will reuse it. The memory used here is only needed for
1267         // this context.
1268 
1269         // FIXME: inline assembly can't access return values
1270         bool ret;
1271         address addr;
1272 
1273         assembly {
1274             let size := mload(0x40)
1275             mstore(size, hash)
1276             mstore(add(size, 32), v)
1277             mstore(add(size, 64), r)
1278             mstore(add(size, 96), s)
1279 
1280         // NOTE: we can reuse the request memory because we deal with
1281         //       the return code
1282             ret := call(3000, 1, 0, size, 128, size, 32)
1283             addr := mload(size)
1284         }
1285 
1286         return (ret, addr);
1287     }
1288 
1289     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1290     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1291         bytes32 r;
1292         bytes32 s;
1293         uint8 v;
1294 
1295         if (sig.length != 65)
1296             return (false, 0);
1297 
1298         // The signature format is a compact form of:
1299         //   {bytes32 r}{bytes32 s}{uint8 v}
1300         // Compact means, uint8 is not padded to 32 bytes.
1301         assembly {
1302             r := mload(add(sig, 32))
1303             s := mload(add(sig, 64))
1304 
1305         // Here we are loading the last 32 bytes. We exploit the fact that
1306         // 'mload' will pad with zeroes if we overread.
1307         // There is no 'mload8' to do this, but that would be nicer.
1308             v := byte(0, mload(add(sig, 96)))
1309 
1310         // Alternative solution:
1311         // 'byte' is not working due to the Solidity parser, so lets
1312         // use the second best option, 'and'
1313         // v := and(mload(add(sig, 65)), 255)
1314         }
1315 
1316         // albeit non-transactional signatures are not specified by the YP, one would expect it
1317         // to match the YP range of [27, 28]
1318         //
1319         // geth uses [0, 1] and some clients have followed. This might change, see:
1320         //  https://github.com/ethereum/go-ethereum/issues/2053
1321         if (v < 27)
1322             v += 27;
1323 
1324         if (v != 27 && v != 28)
1325             return (false, 0);
1326 
1327         return safer_ecrecover(hash, v, r, s);
1328     }
1329 
1330     function safeMemoryCleaner() internal pure {
1331         assembly {
1332             let fmem := mload(0x40)
1333             codecopy(fmem, codesize, sub(msize, fmem))
1334         }
1335     }
1336 
1337 }
1338 // </ORACLIZE_API>
1339 
1340 contract Fiat {
1341     function calculatedTokens(address _src, uint256 _amount) public;
1342 }
1343 
1344 /**
1345 * @title LockEther
1346 **/
1347 contract LockEther is Ownable, usingOraclize {
1348     using SafeMath for uint256;
1349 
1350     struct Sender {
1351         address senderAddress;
1352         uint256 amount;
1353         uint256 previousPrice;
1354         uint256 prepreviousPrice;
1355         uint32 currentUrl;
1356     }
1357 
1358     uint256 amountConverted;
1359 
1360     Fiat eUSD;
1361 
1362     mapping (bytes32 => Sender) pendingQueries;
1363     mapping(uint32 => string) urlRank;
1364 
1365     uint32 maxRankIndex = 0;
1366 
1367     bool eUSDSet = false;
1368 
1369     event NewOraclizeQuery(string message);
1370     event Price(uint256 _price);
1371     event EtherSend(uint256 _amount);
1372 
1373     /**
1374     * @dev constructor function - set gas price to 8 Gwei
1375     **/
1376     constructor() public {
1377         oraclize_setCustomGasPrice(8000000000);
1378 
1379     }
1380 
1381     /**
1382     * @dev callback for Oraclize
1383     * @param myid query ID
1384     * @param result API call result
1385     **/
1386     function __callback(bytes32 myid, string result) public {
1387         require(msg.sender == oraclize_cbAddress());
1388         require (pendingQueries[myid].amount > 0);
1389 
1390         bytes32 queryId;
1391         uint256 amountOfTokens;
1392 
1393         Sender storage sender = pendingQueries[myid];
1394 
1395         uint256 price = parseInt(result, 2);
1396         emit Price(price);
1397 
1398         if(price == 0 && sender.currentUrl < maxRankIndex - 1) {
1399             sender.currentUrl += 1;
1400             emit NewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1401             queryId = oraclize_query("URL", urlRank[sender.currentUrl], 400000);
1402             pendingQueries[queryId] = sender;
1403         }
1404         else if(sender.currentUrl == 0) {
1405             sender.previousPrice = price;
1406             sender.currentUrl += 1;
1407 
1408             emit NewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1409             queryId = oraclize_query("URL", urlRank[sender.currentUrl], 400000);
1410             pendingQueries[queryId] = sender;
1411         }
1412 
1413         else if(sender.currentUrl == 1) {
1414             if(calculateDiffPercent(sender.previousPrice, price) <= 14) {
1415                 amountOfTokens = (sender.amount.mul(sender.previousPrice)).div(100);
1416                 eUSD.calculatedTokens(sender.senderAddress, amountOfTokens);
1417                 amountConverted = amountConverted.add(sender.amount);
1418             }
1419             else {
1420                 sender.prepreviousPrice = sender.previousPrice;
1421                 sender.previousPrice = price;
1422                 sender.currentUrl += 1;
1423 
1424                 emit NewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1425                 queryId = oraclize_query("URL", urlRank[sender.currentUrl], 400000);
1426                 pendingQueries[queryId] = sender;
1427             }
1428         }
1429 
1430         else if(sender.currentUrl > 1) {
1431             if(calculateDiffPercent(sender.previousPrice, price) <= 14) {
1432                 amountOfTokens = (sender.amount.mul(sender.previousPrice)).div(100);
1433                 eUSD.calculatedTokens(sender.senderAddress, amountOfTokens);
1434                 amountConverted = amountConverted.add(sender.amount);
1435             }
1436             else if(calculateDiffPercent(sender.prepreviousPrice, price) <= 14) {
1437                 amountOfTokens = (sender.amount.mul(sender.prepreviousPrice)).div(100);
1438                 eUSD.calculatedTokens(sender.senderAddress, amountOfTokens);
1439                 amountConverted = amountConverted.add(sender.amount);
1440             }
1441             else {
1442                 sender.prepreviousPrice = sender.previousPrice;
1443                 sender.previousPrice = price;
1444                 sender.currentUrl += 1;
1445                 if(sender.currentUrl == maxRankIndex) {
1446                     eUSD.calculatedTokens(sender.senderAddress, 0);
1447                 }
1448                 else {
1449                     queryId = oraclize_query("URL", urlRank[sender.currentUrl]);
1450                     pendingQueries[queryId] = sender;
1451                 }
1452             }
1453         }
1454 
1455         delete pendingQueries[myid];
1456     }
1457 
1458     /**
1459     * @dev Initial oracle call triggered by eUSD contract
1460     * @param _src Ether received from address
1461     * @param _amount Received Ether amount
1462     **/
1463     function callOracle(address _src, uint256 _amount) public {
1464         require(msg.sender == address(eUSD));
1465         emit EtherSend(_amount);
1466         if (oraclize_getPrice("URL") > address(this).balance) {
1467             emit NewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1468         } else {
1469             emit NewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1470             Sender memory sender = Sender({senderAddress: _src, amount: _amount, previousPrice: 0, prepreviousPrice: 0, currentUrl: 0});
1471             bytes32 queryId = oraclize_query("URL", urlRank[0], 400000);
1472             pendingQueries[queryId] = sender;
1473         }
1474     }
1475 
1476     /**
1477     * @dev Change eUSD contract address
1478     * @param _efiat eUSD contract address
1479     **/
1480     function seteUSD(address _efiat) public onlyOwner {
1481         require(!eUSDSet);
1482         eUSD = Fiat(_efiat);
1483         eUSDSet = true;
1484     }
1485 
1486     /**
1487     * @dev Calculate the percent variance between Benchmark value and Comparison value
1488     * @param _firstValue First value for calculating variance (Benchmark value)
1489     * @param _secondValue Second value for calculating variance (Comparison value)
1490     **/
1491     function calculateDiffPercent(uint256 _firstValue, uint256 _secondValue) private pure returns(uint256) {
1492         if(_firstValue == 0) return 100;
1493         if(_secondValue == 0) return 100;
1494         if(_firstValue >= _secondValue) {
1495 
1496             return ((_firstValue.sub(_secondValue)).mul(1000)).div(_secondValue);
1497         }
1498         else {
1499             return ((_secondValue.sub(_firstValue)).mul(1000)).div(_secondValue);
1500         }
1501     }
1502 
1503     /**
1504     * @dev add new url to mapping
1505     * @param _url New url
1506     **/
1507     function addNewUrl(string _url) public onlyOwner {
1508         urlRank[maxRankIndex] = _url;
1509         maxRankIndex += 1;
1510     }
1511 
1512     /**
1513     * @dev fallback function which only receives ether from eUSD contract
1514     **/
1515     function () payable public {
1516         require(msg.sender == address(eUSD));
1517     }
1518 
1519     /**
1520     * @dev returns amount of ether converted into eUSD
1521     **/
1522     function getAmountConverted() constant public returns(uint256) {
1523         return amountConverted;
1524     }
1525 }