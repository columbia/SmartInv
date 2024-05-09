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
141 contract OraclizeI {
142     address public cbAddress;
143     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
144     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
145     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
146     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
147     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
148     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
149     function getPrice(string _datasource) public returns (uint _dsprice);
150     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
151     function setProofType(byte _proofType) external;
152     function setCustomGasPrice(uint _gasPrice) external;
153     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
154 }
155 
156 contract OraclizeAddrResolverI {
157     function getAddress() public returns (address _addr);
158 }
159 
160 /*
161 Begin solidity-cborutils
162 
163 https://github.com/smartcontractkit/solidity-cborutils
164 
165 MIT License
166 
167 Copyright (c) 2018 SmartContract ChainLink, Ltd.
168 
169 Permission is hereby granted, free of charge, to any person obtaining a copy
170 of this software and associated documentation files (the "Software"), to deal
171 in the Software without restriction, including without limitation the rights
172 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
173 copies of the Software, and to permit persons to whom the Software is
174 furnished to do so, subject to the following conditions:
175 
176 The above copyright notice and this permission notice shall be included in all
177 copies or substantial portions of the Software.
178 
179 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
180 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
181 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
182 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
183 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
184 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
185 SOFTWARE.
186  */
187 
188 library Buffer {
189     struct buffer {
190         bytes buf;
191         uint capacity;
192     }
193 
194     function init(buffer memory buf, uint _capacity) internal pure {
195         uint capacity = _capacity;
196         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
197         // Allocate space for the buffer data
198         buf.capacity = capacity;
199         assembly {
200             let ptr := mload(0x40)
201             mstore(buf, ptr)
202             mstore(ptr, 0)
203             mstore(0x40, add(ptr, capacity))
204         }
205     }
206 
207     function resize(buffer memory buf, uint capacity) private pure {
208         bytes memory oldbuf = buf.buf;
209         init(buf, capacity);
210         append(buf, oldbuf);
211     }
212 
213     function max(uint a, uint b) private pure returns(uint) {
214         if(a > b) {
215             return a;
216         }
217         return b;
218     }
219 
220     /**
221      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
222      *      would exceed the capacity of the buffer.
223      * @param buf The buffer to append to.
224      * @param data The data to append.
225      * @return The original buffer.
226      */
227     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
228         if(data.length + buf.buf.length > buf.capacity) {
229             resize(buf, max(buf.capacity, data.length) * 2);
230         }
231 
232         uint dest;
233         uint src;
234         uint len = data.length;
235         assembly {
236         // Memory address of the buffer data
237             let bufptr := mload(buf)
238         // Length of existing buffer data
239             let buflen := mload(bufptr)
240         // Start address = buffer address + buffer length + sizeof(buffer length)
241             dest := add(add(bufptr, buflen), 32)
242         // Update buffer length
243             mstore(bufptr, add(buflen, mload(data)))
244             src := add(data, 32)
245         }
246 
247         // Copy word-length chunks while possible
248         for(; len >= 32; len -= 32) {
249             assembly {
250                 mstore(dest, mload(src))
251             }
252             dest += 32;
253             src += 32;
254         }
255 
256         // Copy remaining bytes
257         uint mask = 256 ** (32 - len) - 1;
258         assembly {
259             let srcpart := and(mload(src), not(mask))
260             let destpart := and(mload(dest), mask)
261             mstore(dest, or(destpart, srcpart))
262         }
263 
264         return buf;
265     }
266 
267     /**
268      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
269      * exceed the capacity of the buffer.
270      * @param buf The buffer to append to.
271      * @param data The data to append.
272      * @return The original buffer.
273      */
274     function append(buffer memory buf, uint8 data) internal pure {
275         if(buf.buf.length + 1 > buf.capacity) {
276             resize(buf, buf.capacity * 2);
277         }
278 
279         assembly {
280         // Memory address of the buffer data
281             let bufptr := mload(buf)
282         // Length of existing buffer data
283             let buflen := mload(bufptr)
284         // Address = buffer address + buffer length + sizeof(buffer length)
285             let dest := add(add(bufptr, buflen), 32)
286             mstore8(dest, data)
287         // Update buffer length
288             mstore(bufptr, add(buflen, 1))
289         }
290     }
291 
292     /**
293      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
294      * exceed the capacity of the buffer.
295      * @param buf The buffer to append to.
296      * @param data The data to append.
297      * @return The original buffer.
298      */
299     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
300         if(len + buf.buf.length > buf.capacity) {
301             resize(buf, max(buf.capacity, len) * 2);
302         }
303 
304         uint mask = 256 ** len - 1;
305         assembly {
306         // Memory address of the buffer data
307             let bufptr := mload(buf)
308         // Length of existing buffer data
309             let buflen := mload(bufptr)
310         // Address = buffer address + buffer length + sizeof(buffer length) + len
311             let dest := add(add(bufptr, buflen), len)
312             mstore(dest, or(and(mload(dest), not(mask)), data))
313         // Update buffer length
314             mstore(bufptr, add(buflen, len))
315         }
316         return buf;
317     }
318 }
319 
320 library CBOR {
321     using Buffer for Buffer.buffer;
322 
323     uint8 private constant MAJOR_TYPE_INT = 0;
324     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
325     uint8 private constant MAJOR_TYPE_BYTES = 2;
326     uint8 private constant MAJOR_TYPE_STRING = 3;
327     uint8 private constant MAJOR_TYPE_ARRAY = 4;
328     uint8 private constant MAJOR_TYPE_MAP = 5;
329     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
330 
331     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
332         if(value <= 23) {
333             buf.append(uint8((major << 5) | value));
334         } else if(value <= 0xFF) {
335             buf.append(uint8((major << 5) | 24));
336             buf.appendInt(value, 1);
337         } else if(value <= 0xFFFF) {
338             buf.append(uint8((major << 5) | 25));
339             buf.appendInt(value, 2);
340         } else if(value <= 0xFFFFFFFF) {
341             buf.append(uint8((major << 5) | 26));
342             buf.appendInt(value, 4);
343         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
344             buf.append(uint8((major << 5) | 27));
345             buf.appendInt(value, 8);
346         }
347     }
348 
349     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
350         buf.append(uint8((major << 5) | 31));
351     }
352 
353     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
354         encodeType(buf, MAJOR_TYPE_INT, value);
355     }
356 
357     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
358         if(value >= 0) {
359             encodeType(buf, MAJOR_TYPE_INT, uint(value));
360         } else {
361             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
362         }
363     }
364 
365     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
366         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
367         buf.append(value);
368     }
369 
370     function encodeString(Buffer.buffer memory buf, string value) internal pure {
371         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
372         buf.append(bytes(value));
373     }
374 
375     function startArray(Buffer.buffer memory buf) internal pure {
376         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
377     }
378 
379     function startMap(Buffer.buffer memory buf) internal pure {
380         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
381     }
382 
383     function endSequence(Buffer.buffer memory buf) internal pure {
384         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
385     }
386 }
387 
388 /*
389 End solidity-cborutils
390  */
391 
392 contract usingOraclize {
393     uint constant day = 60*60*24;
394     uint constant week = 60*60*24*7;
395     uint constant month = 60*60*24*30;
396     byte constant proofType_NONE = 0x00;
397     byte constant proofType_TLSNotary = 0x10;
398     byte constant proofType_Ledger = 0x30;
399     byte constant proofType_Android = 0x40;
400     byte constant proofType_Native = 0xF0;
401     byte constant proofStorage_IPFS = 0x01;
402     uint8 constant networkID_auto = 0;
403     uint8 constant networkID_mainnet = 1;
404     uint8 constant networkID_testnet = 2;
405     uint8 constant networkID_morden = 2;
406     uint8 constant networkID_consensys = 161;
407 
408     OraclizeAddrResolverI OAR;
409 
410     OraclizeI oraclize;
411     modifier oraclizeAPI {
412         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
413             oraclize_setNetwork(networkID_auto);
414 
415         if(address(oraclize) != OAR.getAddress())
416             oraclize = OraclizeI(OAR.getAddress());
417 
418         _;
419     }
420     modifier coupon(string code){
421         oraclize = OraclizeI(OAR.getAddress());
422         _;
423     }
424 
425     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
426         return oraclize_setNetwork();
427         networkID; // silence the warning and remain backwards compatible
428     }
429     function oraclize_setNetwork() internal returns(bool){
430         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
431             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
432             oraclize_setNetworkName("eth_mainnet");
433             return true;
434         }
435         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
436             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
437             oraclize_setNetworkName("eth_ropsten3");
438             return true;
439         }
440         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
441             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
442             oraclize_setNetworkName("eth_kovan");
443             return true;
444         }
445         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
446             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
447             oraclize_setNetworkName("eth_rinkeby");
448             return true;
449         }
450         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
451             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
452             return true;
453         }
454         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
455             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
456             return true;
457         }
458         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
459             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
460             return true;
461         }
462         return false;
463     }
464 
465     function __callback(bytes32 myid, string result) public {
466         __callback(myid, result, new bytes(0));
467     }
468     function __callback(bytes32 myid, string result, bytes proof) public {
469         return;
470         myid; result; proof; // Silence compiler warnings
471     }
472 
473     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
474         return oraclize.getPrice(datasource);
475     }
476 
477     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
478         return oraclize.getPrice(datasource, gaslimit);
479     }
480 
481     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
482         uint price = oraclize.getPrice(datasource);
483         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
484         return oraclize.query.value(price)(0, datasource, arg);
485     }
486     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
487         uint price = oraclize.getPrice(datasource);
488         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
489         return oraclize.query.value(price)(timestamp, datasource, arg);
490     }
491     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
492         uint price = oraclize.getPrice(datasource, gaslimit);
493         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
494         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
495     }
496     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
497         uint price = oraclize.getPrice(datasource, gaslimit);
498         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
499         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
500     }
501     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
502         uint price = oraclize.getPrice(datasource);
503         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
504         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
505     }
506     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
507         uint price = oraclize.getPrice(datasource);
508         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
509         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
510     }
511     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
512         uint price = oraclize.getPrice(datasource, gaslimit);
513         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
514         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
515     }
516     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
517         uint price = oraclize.getPrice(datasource, gaslimit);
518         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
519         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
520     }
521     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
522         uint price = oraclize.getPrice(datasource);
523         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
524         bytes memory args = stra2cbor(argN);
525         return oraclize.queryN.value(price)(0, datasource, args);
526     }
527     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
528         uint price = oraclize.getPrice(datasource);
529         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
530         bytes memory args = stra2cbor(argN);
531         return oraclize.queryN.value(price)(timestamp, datasource, args);
532     }
533     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
534         uint price = oraclize.getPrice(datasource, gaslimit);
535         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
536         bytes memory args = stra2cbor(argN);
537         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
538     }
539     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
540         uint price = oraclize.getPrice(datasource, gaslimit);
541         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
542         bytes memory args = stra2cbor(argN);
543         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
544     }
545     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
546         string[] memory dynargs = new string[](1);
547         dynargs[0] = args[0];
548         return oraclize_query(datasource, dynargs);
549     }
550     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
551         string[] memory dynargs = new string[](1);
552         dynargs[0] = args[0];
553         return oraclize_query(timestamp, datasource, dynargs);
554     }
555     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
556         string[] memory dynargs = new string[](1);
557         dynargs[0] = args[0];
558         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
559     }
560     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
561         string[] memory dynargs = new string[](1);
562         dynargs[0] = args[0];
563         return oraclize_query(datasource, dynargs, gaslimit);
564     }
565 
566     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
567         string[] memory dynargs = new string[](2);
568         dynargs[0] = args[0];
569         dynargs[1] = args[1];
570         return oraclize_query(datasource, dynargs);
571     }
572     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
573         string[] memory dynargs = new string[](2);
574         dynargs[0] = args[0];
575         dynargs[1] = args[1];
576         return oraclize_query(timestamp, datasource, dynargs);
577     }
578     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
579         string[] memory dynargs = new string[](2);
580         dynargs[0] = args[0];
581         dynargs[1] = args[1];
582         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
583     }
584     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
585         string[] memory dynargs = new string[](2);
586         dynargs[0] = args[0];
587         dynargs[1] = args[1];
588         return oraclize_query(datasource, dynargs, gaslimit);
589     }
590     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
591         string[] memory dynargs = new string[](3);
592         dynargs[0] = args[0];
593         dynargs[1] = args[1];
594         dynargs[2] = args[2];
595         return oraclize_query(datasource, dynargs);
596     }
597     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
598         string[] memory dynargs = new string[](3);
599         dynargs[0] = args[0];
600         dynargs[1] = args[1];
601         dynargs[2] = args[2];
602         return oraclize_query(timestamp, datasource, dynargs);
603     }
604     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
605         string[] memory dynargs = new string[](3);
606         dynargs[0] = args[0];
607         dynargs[1] = args[1];
608         dynargs[2] = args[2];
609         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
610     }
611     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
612         string[] memory dynargs = new string[](3);
613         dynargs[0] = args[0];
614         dynargs[1] = args[1];
615         dynargs[2] = args[2];
616         return oraclize_query(datasource, dynargs, gaslimit);
617     }
618 
619     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
620         string[] memory dynargs = new string[](4);
621         dynargs[0] = args[0];
622         dynargs[1] = args[1];
623         dynargs[2] = args[2];
624         dynargs[3] = args[3];
625         return oraclize_query(datasource, dynargs);
626     }
627     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
628         string[] memory dynargs = new string[](4);
629         dynargs[0] = args[0];
630         dynargs[1] = args[1];
631         dynargs[2] = args[2];
632         dynargs[3] = args[3];
633         return oraclize_query(timestamp, datasource, dynargs);
634     }
635     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
636         string[] memory dynargs = new string[](4);
637         dynargs[0] = args[0];
638         dynargs[1] = args[1];
639         dynargs[2] = args[2];
640         dynargs[3] = args[3];
641         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
642     }
643     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
644         string[] memory dynargs = new string[](4);
645         dynargs[0] = args[0];
646         dynargs[1] = args[1];
647         dynargs[2] = args[2];
648         dynargs[3] = args[3];
649         return oraclize_query(datasource, dynargs, gaslimit);
650     }
651     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
652         string[] memory dynargs = new string[](5);
653         dynargs[0] = args[0];
654         dynargs[1] = args[1];
655         dynargs[2] = args[2];
656         dynargs[3] = args[3];
657         dynargs[4] = args[4];
658         return oraclize_query(datasource, dynargs);
659     }
660     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
661         string[] memory dynargs = new string[](5);
662         dynargs[0] = args[0];
663         dynargs[1] = args[1];
664         dynargs[2] = args[2];
665         dynargs[3] = args[3];
666         dynargs[4] = args[4];
667         return oraclize_query(timestamp, datasource, dynargs);
668     }
669     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
670         string[] memory dynargs = new string[](5);
671         dynargs[0] = args[0];
672         dynargs[1] = args[1];
673         dynargs[2] = args[2];
674         dynargs[3] = args[3];
675         dynargs[4] = args[4];
676         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
677     }
678     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
679         string[] memory dynargs = new string[](5);
680         dynargs[0] = args[0];
681         dynargs[1] = args[1];
682         dynargs[2] = args[2];
683         dynargs[3] = args[3];
684         dynargs[4] = args[4];
685         return oraclize_query(datasource, dynargs, gaslimit);
686     }
687     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
688         uint price = oraclize.getPrice(datasource);
689         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
690         bytes memory args = ba2cbor(argN);
691         return oraclize.queryN.value(price)(0, datasource, args);
692     }
693     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
694         uint price = oraclize.getPrice(datasource);
695         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
696         bytes memory args = ba2cbor(argN);
697         return oraclize.queryN.value(price)(timestamp, datasource, args);
698     }
699     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
700         uint price = oraclize.getPrice(datasource, gaslimit);
701         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
702         bytes memory args = ba2cbor(argN);
703         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
704     }
705     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
706         uint price = oraclize.getPrice(datasource, gaslimit);
707         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
708         bytes memory args = ba2cbor(argN);
709         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
710     }
711     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
712         bytes[] memory dynargs = new bytes[](1);
713         dynargs[0] = args[0];
714         return oraclize_query(datasource, dynargs);
715     }
716     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
717         bytes[] memory dynargs = new bytes[](1);
718         dynargs[0] = args[0];
719         return oraclize_query(timestamp, datasource, dynargs);
720     }
721     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
722         bytes[] memory dynargs = new bytes[](1);
723         dynargs[0] = args[0];
724         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
725     }
726     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
727         bytes[] memory dynargs = new bytes[](1);
728         dynargs[0] = args[0];
729         return oraclize_query(datasource, dynargs, gaslimit);
730     }
731 
732     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
733         bytes[] memory dynargs = new bytes[](2);
734         dynargs[0] = args[0];
735         dynargs[1] = args[1];
736         return oraclize_query(datasource, dynargs);
737     }
738     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
739         bytes[] memory dynargs = new bytes[](2);
740         dynargs[0] = args[0];
741         dynargs[1] = args[1];
742         return oraclize_query(timestamp, datasource, dynargs);
743     }
744     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
745         bytes[] memory dynargs = new bytes[](2);
746         dynargs[0] = args[0];
747         dynargs[1] = args[1];
748         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
749     }
750     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
751         bytes[] memory dynargs = new bytes[](2);
752         dynargs[0] = args[0];
753         dynargs[1] = args[1];
754         return oraclize_query(datasource, dynargs, gaslimit);
755     }
756     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
757         bytes[] memory dynargs = new bytes[](3);
758         dynargs[0] = args[0];
759         dynargs[1] = args[1];
760         dynargs[2] = args[2];
761         return oraclize_query(datasource, dynargs);
762     }
763     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
764         bytes[] memory dynargs = new bytes[](3);
765         dynargs[0] = args[0];
766         dynargs[1] = args[1];
767         dynargs[2] = args[2];
768         return oraclize_query(timestamp, datasource, dynargs);
769     }
770     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
771         bytes[] memory dynargs = new bytes[](3);
772         dynargs[0] = args[0];
773         dynargs[1] = args[1];
774         dynargs[2] = args[2];
775         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
776     }
777     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
778         bytes[] memory dynargs = new bytes[](3);
779         dynargs[0] = args[0];
780         dynargs[1] = args[1];
781         dynargs[2] = args[2];
782         return oraclize_query(datasource, dynargs, gaslimit);
783     }
784 
785     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
786         bytes[] memory dynargs = new bytes[](4);
787         dynargs[0] = args[0];
788         dynargs[1] = args[1];
789         dynargs[2] = args[2];
790         dynargs[3] = args[3];
791         return oraclize_query(datasource, dynargs);
792     }
793     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
794         bytes[] memory dynargs = new bytes[](4);
795         dynargs[0] = args[0];
796         dynargs[1] = args[1];
797         dynargs[2] = args[2];
798         dynargs[3] = args[3];
799         return oraclize_query(timestamp, datasource, dynargs);
800     }
801     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
802         bytes[] memory dynargs = new bytes[](4);
803         dynargs[0] = args[0];
804         dynargs[1] = args[1];
805         dynargs[2] = args[2];
806         dynargs[3] = args[3];
807         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
808     }
809     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
810         bytes[] memory dynargs = new bytes[](4);
811         dynargs[0] = args[0];
812         dynargs[1] = args[1];
813         dynargs[2] = args[2];
814         dynargs[3] = args[3];
815         return oraclize_query(datasource, dynargs, gaslimit);
816     }
817     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
818         bytes[] memory dynargs = new bytes[](5);
819         dynargs[0] = args[0];
820         dynargs[1] = args[1];
821         dynargs[2] = args[2];
822         dynargs[3] = args[3];
823         dynargs[4] = args[4];
824         return oraclize_query(datasource, dynargs);
825     }
826     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
827         bytes[] memory dynargs = new bytes[](5);
828         dynargs[0] = args[0];
829         dynargs[1] = args[1];
830         dynargs[2] = args[2];
831         dynargs[3] = args[3];
832         dynargs[4] = args[4];
833         return oraclize_query(timestamp, datasource, dynargs);
834     }
835     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
836         bytes[] memory dynargs = new bytes[](5);
837         dynargs[0] = args[0];
838         dynargs[1] = args[1];
839         dynargs[2] = args[2];
840         dynargs[3] = args[3];
841         dynargs[4] = args[4];
842         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
843     }
844     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
845         bytes[] memory dynargs = new bytes[](5);
846         dynargs[0] = args[0];
847         dynargs[1] = args[1];
848         dynargs[2] = args[2];
849         dynargs[3] = args[3];
850         dynargs[4] = args[4];
851         return oraclize_query(datasource, dynargs, gaslimit);
852     }
853 
854     function oraclize_cbAddress() oraclizeAPI internal returns (address){
855         return oraclize.cbAddress();
856     }
857     function oraclize_setProof(byte proofP) oraclizeAPI internal {
858         return oraclize.setProofType(proofP);
859     }
860     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
861         return oraclize.setCustomGasPrice(gasPrice);
862     }
863 
864     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
865         return oraclize.randomDS_getSessionPubKeyHash();
866     }
867 
868     function getCodeSize(address _addr) constant internal returns(uint _size) {
869         assembly {
870             _size := extcodesize(_addr)
871         }
872     }
873 
874     function parseAddr(string _a) internal pure returns (address){
875         bytes memory tmp = bytes(_a);
876         uint160 iaddr = 0;
877         uint160 b1;
878         uint160 b2;
879         for (uint i=2; i<2+2*20; i+=2){
880             iaddr *= 256;
881             b1 = uint160(tmp[i]);
882             b2 = uint160(tmp[i+1]);
883             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
884             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
885             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
886             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
887             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
888             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
889             iaddr += (b1*16+b2);
890         }
891         return address(iaddr);
892     }
893 
894     function strCompare(string _a, string _b) internal pure returns (int) {
895         bytes memory a = bytes(_a);
896         bytes memory b = bytes(_b);
897         uint minLength = a.length;
898         if (b.length < minLength) minLength = b.length;
899         for (uint i = 0; i < minLength; i ++)
900             if (a[i] < b[i])
901                 return -1;
902             else if (a[i] > b[i])
903                 return 1;
904         if (a.length < b.length)
905             return -1;
906         else if (a.length > b.length)
907             return 1;
908         else
909             return 0;
910     }
911 
912     function indexOf(string _haystack, string _needle) internal pure returns (int) {
913         bytes memory h = bytes(_haystack);
914         bytes memory n = bytes(_needle);
915         if(h.length < 1 || n.length < 1 || (n.length > h.length))
916             return -1;
917         else if(h.length > (2**128 -1))
918             return -1;
919         else
920         {
921             uint subindex = 0;
922             for (uint i = 0; i < h.length; i ++)
923             {
924                 if (h[i] == n[0])
925                 {
926                     subindex = 1;
927                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
928                     {
929                         subindex++;
930                     }
931                     if(subindex == n.length)
932                         return int(i);
933                 }
934             }
935             return -1;
936         }
937     }
938 
939     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
940         bytes memory _ba = bytes(_a);
941         bytes memory _bb = bytes(_b);
942         bytes memory _bc = bytes(_c);
943         bytes memory _bd = bytes(_d);
944         bytes memory _be = bytes(_e);
945         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
946         bytes memory babcde = bytes(abcde);
947         uint k = 0;
948         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
949         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
950         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
951         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
952         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
953         return string(babcde);
954     }
955 
956     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
957         return strConcat(_a, _b, _c, _d, "");
958     }
959 
960     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
961         return strConcat(_a, _b, _c, "", "");
962     }
963 
964     function strConcat(string _a, string _b) internal pure returns (string) {
965         return strConcat(_a, _b, "", "", "");
966     }
967 
968     // parseInt
969     function parseInt(string _a) internal pure returns (uint) {
970         return parseInt(_a, 0);
971     }
972 
973     // parseInt(parseFloat*10^_b)
974     function parseInt(string _a, uint _b) internal pure returns (uint) {
975         bytes memory bresult = bytes(_a);
976         uint mint = 0;
977         bool decimals = false;
978         for (uint i=0; i<bresult.length; i++){
979             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
980                 if (decimals){
981                     if (_b == 0) break;
982                     else _b--;
983                 }
984                 mint *= 10;
985                 mint += uint(bresult[i]) - 48;
986             } else if (bresult[i] == 46) decimals = true;
987         }
988         if (_b > 0) mint *= 10**_b;
989         return mint;
990     }
991 
992     function uint2str(uint i) internal pure returns (string){
993         if (i == 0) return "0";
994         uint j = i;
995         uint len;
996         while (j != 0){
997             len++;
998             j /= 10;
999         }
1000         bytes memory bstr = new bytes(len);
1001         uint k = len - 1;
1002         while (i != 0){
1003             bstr[k--] = byte(48 + i % 10);
1004             i /= 10;
1005         }
1006         return string(bstr);
1007     }
1008 
1009     using CBOR for Buffer.buffer;
1010     function stra2cbor(string[] arr) internal pure returns (bytes) {
1011         safeMemoryCleaner();
1012         Buffer.buffer memory buf;
1013         Buffer.init(buf, 1024);
1014         buf.startArray();
1015         for (uint i = 0; i < arr.length; i++) {
1016             buf.encodeString(arr[i]);
1017         }
1018         buf.endSequence();
1019         return buf.buf;
1020     }
1021 
1022     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
1023         safeMemoryCleaner();
1024         Buffer.buffer memory buf;
1025         Buffer.init(buf, 1024);
1026         buf.startArray();
1027         for (uint i = 0; i < arr.length; i++) {
1028             buf.encodeBytes(arr[i]);
1029         }
1030         buf.endSequence();
1031         return buf.buf;
1032     }
1033 
1034     string oraclize_network_name;
1035     function oraclize_setNetworkName(string _network_name) internal {
1036         oraclize_network_name = _network_name;
1037     }
1038 
1039     function oraclize_getNetworkName() internal view returns (string) {
1040         return oraclize_network_name;
1041     }
1042 
1043     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1044         require((_nbytes > 0) && (_nbytes <= 32));
1045         // Convert from seconds to ledger timer ticks
1046         _delay *= 10;
1047         bytes memory nbytes = new bytes(1);
1048         nbytes[0] = byte(_nbytes);
1049         bytes memory unonce = new bytes(32);
1050         bytes memory sessionKeyHash = new bytes(32);
1051         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1052         assembly {
1053             mstore(unonce, 0x20)
1054         // the following variables can be relaxed
1055         // check relaxed random contract under ethereum-examples repo
1056         // for an idea on how to override and replace comit hash vars
1057             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1058             mstore(sessionKeyHash, 0x20)
1059             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1060         }
1061         bytes memory delay = new bytes(32);
1062         assembly {
1063             mstore(add(delay, 0x20), _delay)
1064         }
1065 
1066         bytes memory delay_bytes8 = new bytes(8);
1067         copyBytes(delay, 24, 8, delay_bytes8, 0);
1068 
1069         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1070         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1071 
1072         bytes memory delay_bytes8_left = new bytes(8);
1073 
1074         assembly {
1075             let x := mload(add(delay_bytes8, 0x20))
1076             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1077             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1078             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1079             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1080             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1081             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1082             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1083             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1084 
1085         }
1086 
1087         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1088         return queryId;
1089     }
1090 
1091     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1092         oraclize_randomDS_args[queryId] = commitment;
1093     }
1094 
1095     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1096     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1097 
1098     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1099         bool sigok;
1100         address signer;
1101 
1102         bytes32 sigr;
1103         bytes32 sigs;
1104 
1105         bytes memory sigr_ = new bytes(32);
1106         uint offset = 4+(uint(dersig[3]) - 0x20);
1107         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1108         bytes memory sigs_ = new bytes(32);
1109         offset += 32 + 2;
1110         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1111 
1112         assembly {
1113             sigr := mload(add(sigr_, 32))
1114             sigs := mload(add(sigs_, 32))
1115         }
1116 
1117 
1118         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1119         if (address(keccak256(pubkey)) == signer) return true;
1120         else {
1121             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1122             return (address(keccak256(pubkey)) == signer);
1123         }
1124     }
1125 
1126     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1127         bool sigok;
1128 
1129         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1130         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1131         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1132 
1133         bytes memory appkey1_pubkey = new bytes(64);
1134         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1135 
1136         bytes memory tosign2 = new bytes(1+65+32);
1137         tosign2[0] = byte(1); //role
1138         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1139         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1140         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1141         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1142 
1143         if (sigok == false) return false;
1144 
1145 
1146         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1147         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1148 
1149         bytes memory tosign3 = new bytes(1+65);
1150         tosign3[0] = 0xFE;
1151         copyBytes(proof, 3, 65, tosign3, 1);
1152 
1153         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1154         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1155 
1156         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1157 
1158         return sigok;
1159     }
1160 
1161     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1162         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1163         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1164 
1165         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1166         require(proofVerified);
1167 
1168         _;
1169     }
1170 
1171     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1172         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1173         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1174 
1175         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1176         if (proofVerified == false) return 2;
1177 
1178         return 0;
1179     }
1180 
1181     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1182         bool match_ = true;
1183 
1184         require(prefix.length == n_random_bytes);
1185 
1186         for (uint256 i=0; i< n_random_bytes; i++) {
1187             if (content[i] != prefix[i]) match_ = false;
1188         }
1189 
1190         return match_;
1191     }
1192 
1193     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1194 
1195         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1196         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1197         bytes memory keyhash = new bytes(32);
1198         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1199         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1200 
1201         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1202         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1203 
1204         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1205         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1206 
1207         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1208         // This is to verify that the computed args match with the ones specified in the query.
1209         bytes memory commitmentSlice1 = new bytes(8+1+32);
1210         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1211 
1212         bytes memory sessionPubkey = new bytes(64);
1213         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1214         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1215 
1216         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1217         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1218             delete oraclize_randomDS_args[queryId];
1219         } else return false;
1220 
1221 
1222         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1223         bytes memory tosign1 = new bytes(32+8+1+32);
1224         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1225         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1226 
1227         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1228         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1229             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1230         }
1231 
1232         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1233     }
1234 
1235     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1236     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1237         uint minLength = length + toOffset;
1238 
1239         // Buffer too small
1240         require(to.length >= minLength); // Should be a better way?
1241 
1242         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1243         uint i = 32 + fromOffset;
1244         uint j = 32 + toOffset;
1245 
1246         while (i < (32 + fromOffset + length)) {
1247             assembly {
1248                 let tmp := mload(add(from, i))
1249                 mstore(add(to, j), tmp)
1250             }
1251             i += 32;
1252             j += 32;
1253         }
1254 
1255         return to;
1256     }
1257 
1258     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1259     // Duplicate Solidity's ecrecover, but catching the CALL return value
1260     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1261         // We do our own memory management here. Solidity uses memory offset
1262         // 0x40 to store the current end of memory. We write past it (as
1263         // writes are memory extensions), but don't update the offset so
1264         // Solidity will reuse it. The memory used here is only needed for
1265         // this context.
1266 
1267         // FIXME: inline assembly can't access return values
1268         bool ret;
1269         address addr;
1270 
1271         assembly {
1272             let size := mload(0x40)
1273             mstore(size, hash)
1274             mstore(add(size, 32), v)
1275             mstore(add(size, 64), r)
1276             mstore(add(size, 96), s)
1277 
1278         // NOTE: we can reuse the request memory because we deal with
1279         //       the return code
1280             ret := call(3000, 1, 0, size, 128, size, 32)
1281             addr := mload(size)
1282         }
1283 
1284         return (ret, addr);
1285     }
1286 
1287     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1288     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1289         bytes32 r;
1290         bytes32 s;
1291         uint8 v;
1292 
1293         if (sig.length != 65)
1294             return (false, 0);
1295 
1296         // The signature format is a compact form of:
1297         //   {bytes32 r}{bytes32 s}{uint8 v}
1298         // Compact means, uint8 is not padded to 32 bytes.
1299         assembly {
1300             r := mload(add(sig, 32))
1301             s := mload(add(sig, 64))
1302 
1303         // Here we are loading the last 32 bytes. We exploit the fact that
1304         // 'mload' will pad with zeroes if we overread.
1305         // There is no 'mload8' to do this, but that would be nicer.
1306             v := byte(0, mload(add(sig, 96)))
1307 
1308         // Alternative solution:
1309         // 'byte' is not working due to the Solidity parser, so lets
1310         // use the second best option, 'and'
1311         // v := and(mload(add(sig, 65)), 255)
1312         }
1313 
1314         // albeit non-transactional signatures are not specified by the YP, one would expect it
1315         // to match the YP range of [27, 28]
1316         //
1317         // geth uses [0, 1] and some clients have followed. This might change, see:
1318         //  https://github.com/ethereum/go-ethereum/issues/2053
1319         if (v < 27)
1320             v += 27;
1321 
1322         if (v != 27 && v != 28)
1323             return (false, 0);
1324 
1325         return safer_ecrecover(hash, v, r, s);
1326     }
1327 
1328     function safeMemoryCleaner() internal pure {
1329         assembly {
1330             let fmem := mload(0x40)
1331             codecopy(fmem, codesize, sub(msize, fmem))
1332         }
1333     }
1334 
1335 }
1336 // </ORACLIZE_API>
1337 
1338 contract Fiat {
1339     function calculatedTokens(address _src, uint256 _amount) public;
1340 }
1341 
1342 /**
1343 * @title LockEther
1344 **/
1345 contract LockEther is Ownable, usingOraclize {
1346     using SafeMath for uint256;
1347 
1348     struct Sender {
1349         address senderAddress;
1350         uint256 amount;
1351         uint256 previousPrice;
1352         uint256 prepreviousPrice;
1353         uint32 currentUrl;
1354     }
1355 
1356     uint256 amountConverted;
1357     uint256 gasPrice;
1358 
1359     Fiat eUSD;
1360 
1361     mapping (bytes32 => Sender) pendingQueries;
1362     mapping(uint32 => string) urlRank;
1363 
1364     uint32 maxRankIndex = 0;
1365 
1366     bool eUSDSet = false;
1367 
1368     event NewOraclizeQuery(string message);
1369     event Price(uint256 _price);
1370     event EtherSend(uint256 _amount);
1371 
1372     /**
1373     * @dev constructor function - set gas price to 8 Gwei
1374     **/
1375     constructor() public {
1376         gasPrice = 71000000000;
1377     }
1378 
1379     /**
1380     * @dev callback for Oraclize
1381     * @param myid query ID
1382     * @param result API call result
1383     **/
1384     function __callback(bytes32 myid, string result) public {
1385         require(msg.sender == oraclize_cbAddress());
1386         require (pendingQueries[myid].amount > 0);
1387         
1388         oraclize_setCustomGasPrice(gasPrice);
1389         bytes32 queryId;
1390         uint256 amountOfTokens;
1391 
1392         Sender storage sender = pendingQueries[myid];
1393 
1394         uint256 price = parseInt(result, 2);
1395         emit Price(price);
1396 
1397         if(price == 0 && sender.currentUrl < maxRankIndex - 1) {
1398             sender.currentUrl += 1;
1399             emit NewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1400             queryId = oraclize_query("URL", urlRank[sender.currentUrl], 400000);
1401             pendingQueries[queryId] = sender;
1402         }
1403         else if(sender.currentUrl == 0) {
1404             sender.previousPrice = price;
1405             sender.currentUrl += 1;
1406 
1407             emit NewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1408             queryId = oraclize_query("URL", urlRank[sender.currentUrl], 400000);
1409             pendingQueries[queryId] = sender;
1410         }
1411 
1412         else if(sender.currentUrl == 1) {
1413             if(calculateDiffPercent(sender.previousPrice, price) <= 14) {
1414                 amountOfTokens = (sender.amount.mul(sender.previousPrice)).div(100);
1415                 eUSD.calculatedTokens(sender.senderAddress, amountOfTokens);
1416                 amountConverted = amountConverted.add(sender.amount);
1417             }
1418             else {
1419                 sender.prepreviousPrice = sender.previousPrice;
1420                 sender.previousPrice = price;
1421                 sender.currentUrl += 1;
1422 
1423                 emit NewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1424                 queryId = oraclize_query("URL", urlRank[sender.currentUrl], 400000);
1425                 pendingQueries[queryId] = sender;
1426             }
1427         }
1428 
1429         else if(sender.currentUrl > 1) {
1430             if(calculateDiffPercent(sender.previousPrice, price) <= 14) {
1431                 amountOfTokens = (sender.amount.mul(sender.previousPrice)).div(100);
1432                 eUSD.calculatedTokens(sender.senderAddress, amountOfTokens);
1433                 amountConverted = amountConverted.add(sender.amount);
1434             }
1435             else if(calculateDiffPercent(sender.prepreviousPrice, price) <= 14) {
1436                 amountOfTokens = (sender.amount.mul(sender.prepreviousPrice)).div(100);
1437                 eUSD.calculatedTokens(sender.senderAddress, amountOfTokens);
1438                 amountConverted = amountConverted.add(sender.amount);
1439             }
1440             else {
1441                 sender.prepreviousPrice = sender.previousPrice;
1442                 sender.previousPrice = price;
1443                 sender.currentUrl += 1;
1444                 if(sender.currentUrl == maxRankIndex) {
1445                     eUSD.calculatedTokens(sender.senderAddress, 0);
1446                 }
1447                 else {
1448                     queryId = oraclize_query("URL", urlRank[sender.currentUrl]);
1449                     pendingQueries[queryId] = sender;
1450                 }
1451             }
1452         }
1453 
1454         delete pendingQueries[myid];
1455     }
1456 
1457     /**
1458     * @dev Initial oracle call triggered by eUSD contract
1459     * @param _src Ether received from address
1460     * @param _amount Received Ether amount
1461     **/
1462     function callOracle(address _src, uint256 _amount) public {
1463         require(msg.sender == address(eUSD));
1464         emit EtherSend(_amount);
1465         if (oraclize_getPrice("URL") > address(this).balance) {
1466             emit NewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1467         } else {
1468             emit NewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1469             oraclize_setCustomGasPrice(gasPrice);
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
1513     * @dev change current gas price
1514     * @param _price New gas price
1515     **/
1516     function changeGasPrice(uint256 _price) public onlyOwner {
1517         gasPrice = _price;        
1518     }
1519 
1520     /**
1521     * @dev fallback function which only receives ether from eUSD contract
1522     **/
1523     function () payable public {
1524         require(msg.sender == address(eUSD));
1525     }
1526 
1527     /**
1528     * @dev returns amount of ether converted into eUSD
1529     **/
1530     function getAmountConverted() constant public returns(uint256) {
1531         return amountConverted;
1532     }
1533 
1534     /**
1535     * @dev returns current gas price
1536     **/
1537     function getCurrentGasPrice() constant public returns(uint256) {
1538         return gasPrice;
1539     }
1540 }