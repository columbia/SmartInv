1 pragma solidity ^0.4.11;
2 pragma solidity ^0.4.24;
3 
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
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 pragma solidity ^0.4.24;
56 
57 
58 /**
59  * @title Ownable
60  * @dev The Ownable contract has an owner address, and provides basic authorization control
61  * functions, this simplifies the implementation of "user permissions".
62  */
63 contract Ownable {
64   address public owner;
65 
66 
67   event OwnershipRenounced(address indexed previousOwner);
68   event OwnershipTransferred(
69     address indexed previousOwner,
70     address indexed newOwner
71   );
72 
73 
74   /**
75    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
76    * account.
77    */
78   constructor() public {
79     owner = msg.sender;
80   }
81 
82   /**
83    * @dev Throws if called by any account other than the owner.
84    */
85   modifier onlyOwner() {
86     require(msg.sender == owner);
87     _;
88   }
89 
90   /**
91    * @dev Allows the current owner to relinquish control of the contract.
92    * @notice Renouncing to ownership will leave the contract without an owner.
93    * It will not be possible to call the functions with the `onlyOwner`
94    * modifier anymore.
95    */
96   function renounceOwnership() public onlyOwner {
97     emit OwnershipRenounced(owner);
98     owner = address(0);
99   }
100 
101   /**
102    * @dev Allows the current owner to transfer control of the contract to a newOwner.
103    * @param _newOwner The address to transfer ownership to.
104    */
105   function transferOwnership(address _newOwner) public onlyOwner {
106     _transferOwnership(_newOwner);
107   }
108 
109   /**
110    * @dev Transfers control of the contract to a newOwner.
111    * @param _newOwner The address to transfer ownership to.
112    */
113   function _transferOwnership(address _newOwner) internal {
114     require(_newOwner != address(0));
115     emit OwnershipTransferred(owner, _newOwner);
116     owner = _newOwner;
117   }
118 }
119 
120 // <ORACLIZE_API>
121 /*
122 Copyright (c) 2015-2016 Oraclize SRL
123 Copyright (c) 2016 Oraclize LTD
124 
125 
126 
127 Permission is hereby granted, free of charge, to any person obtaining a copy
128 of this software and associated documentation files (the "Software"), to deal
129 in the Software without restriction, including without limitation the rights
130 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
131 copies of the Software, and to permit persons to whom the Software is
132 furnished to do so, subject to the following conditions:
133 
134 
135 
136 The above copyright notice and this permission notice shall be included in
137 all copies or substantial portions of the Software.
138 
139 
140 
141 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
142 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
143 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
144 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
145 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
146 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
147 THE SOFTWARE.
148 */
149 
150 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
151 
152 pragma solidity >=0.4.18;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
153 
154 contract OraclizeI {
155     address public cbAddress;
156     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
157     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
158     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
159     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
160     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
161     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
162     function getPrice(string _datasource) public returns (uint _dsprice);
163     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
164     function setProofType(byte _proofType) external;
165     function setCustomGasPrice(uint _gasPrice) external;
166     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
167 }
168 
169 contract OraclizeAddrResolverI {
170     function getAddress() public returns (address _addr);
171 }
172 
173 /*
174 Begin solidity-cborutils
175 
176 https://github.com/smartcontractkit/solidity-cborutils
177 
178 MIT License
179 
180 Copyright (c) 2018 SmartContract ChainLink, Ltd.
181 
182 Permission is hereby granted, free of charge, to any person obtaining a copy
183 of this software and associated documentation files (the "Software"), to deal
184 in the Software without restriction, including without limitation the rights
185 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
186 copies of the Software, and to permit persons to whom the Software is
187 furnished to do so, subject to the following conditions:
188 
189 The above copyright notice and this permission notice shall be included in all
190 copies or substantial portions of the Software.
191 
192 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
193 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
194 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
195 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
196 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
197 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
198 SOFTWARE.
199  */
200 
201 library Buffer {
202     struct buffer {
203         bytes buf;
204         uint capacity;
205     }
206 
207     function init(buffer memory buf, uint _capacity) internal pure {
208         uint capacity = _capacity;
209         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
210         // Allocate space for the buffer data
211         buf.capacity = capacity;
212         assembly {
213             let ptr := mload(0x40)
214             mstore(buf, ptr)
215             mstore(ptr, 0)
216             mstore(0x40, add(ptr, capacity))
217         }
218     }
219 
220     function resize(buffer memory buf, uint capacity) private pure {
221         bytes memory oldbuf = buf.buf;
222         init(buf, capacity);
223         append(buf, oldbuf);
224     }
225 
226     function max(uint a, uint b) private pure returns(uint) {
227         if(a > b) {
228             return a;
229         }
230         return b;
231     }
232 
233     /**
234      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
235      *      would exceed the capacity of the buffer.
236      * @param buf The buffer to append to.
237      * @param data The data to append.
238      * @return The original buffer.
239      */
240     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
241         if(data.length + buf.buf.length > buf.capacity) {
242             resize(buf, max(buf.capacity, data.length) * 2);
243         }
244 
245         uint dest;
246         uint src;
247         uint len = data.length;
248         assembly {
249             // Memory address of the buffer data
250             let bufptr := mload(buf)
251             // Length of existing buffer data
252             let buflen := mload(bufptr)
253             // Start address = buffer address + buffer length + sizeof(buffer length)
254             dest := add(add(bufptr, buflen), 32)
255             // Update buffer length
256             mstore(bufptr, add(buflen, mload(data)))
257             src := add(data, 32)
258         }
259 
260         // Copy word-length chunks while possible
261         for(; len >= 32; len -= 32) {
262             assembly {
263                 mstore(dest, mload(src))
264             }
265             dest += 32;
266             src += 32;
267         }
268 
269         // Copy remaining bytes
270         uint mask = 256 ** (32 - len) - 1;
271         assembly {
272             let srcpart := and(mload(src), not(mask))
273             let destpart := and(mload(dest), mask)
274             mstore(dest, or(destpart, srcpart))
275         }
276 
277         return buf;
278     }
279 
280     /**
281      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
282      * exceed the capacity of the buffer.
283      * @param buf The buffer to append to.
284      * @param data The data to append.
285      * @return The original buffer.
286      */
287     function append(buffer memory buf, uint8 data) internal pure {
288         if(buf.buf.length + 1 > buf.capacity) {
289             resize(buf, buf.capacity * 2);
290         }
291 
292         assembly {
293             // Memory address of the buffer data
294             let bufptr := mload(buf)
295             // Length of existing buffer data
296             let buflen := mload(bufptr)
297             // Address = buffer address + buffer length + sizeof(buffer length)
298             let dest := add(add(bufptr, buflen), 32)
299             mstore8(dest, data)
300             // Update buffer length
301             mstore(bufptr, add(buflen, 1))
302         }
303     }
304 
305     /**
306      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
307      * exceed the capacity of the buffer.
308      * @param buf The buffer to append to.
309      * @param data The data to append.
310      * @return The original buffer.
311      */
312     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
313         if(len + buf.buf.length > buf.capacity) {
314             resize(buf, max(buf.capacity, len) * 2);
315         }
316 
317         uint mask = 256 ** len - 1;
318         assembly {
319             // Memory address of the buffer data
320             let bufptr := mload(buf)
321             // Length of existing buffer data
322             let buflen := mload(bufptr)
323             // Address = buffer address + buffer length + sizeof(buffer length) + len
324             let dest := add(add(bufptr, buflen), len)
325             mstore(dest, or(and(mload(dest), not(mask)), data))
326             // Update buffer length
327             mstore(bufptr, add(buflen, len))
328         }
329         return buf;
330     }
331 }
332 
333 library CBOR {
334     using Buffer for Buffer.buffer;
335 
336     uint8 private constant MAJOR_TYPE_INT = 0;
337     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
338     uint8 private constant MAJOR_TYPE_BYTES = 2;
339     uint8 private constant MAJOR_TYPE_STRING = 3;
340     uint8 private constant MAJOR_TYPE_ARRAY = 4;
341     uint8 private constant MAJOR_TYPE_MAP = 5;
342     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
343 
344     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
345         if(value <= 23) {
346             buf.append(uint8((major << 5) | value));
347         } else if(value <= 0xFF) {
348             buf.append(uint8((major << 5) | 24));
349             buf.appendInt(value, 1);
350         } else if(value <= 0xFFFF) {
351             buf.append(uint8((major << 5) | 25));
352             buf.appendInt(value, 2);
353         } else if(value <= 0xFFFFFFFF) {
354             buf.append(uint8((major << 5) | 26));
355             buf.appendInt(value, 4);
356         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
357             buf.append(uint8((major << 5) | 27));
358             buf.appendInt(value, 8);
359         }
360     }
361 
362     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
363         buf.append(uint8((major << 5) | 31));
364     }
365 
366     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
367         encodeType(buf, MAJOR_TYPE_INT, value);
368     }
369 
370     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
371         if(value >= 0) {
372             encodeType(buf, MAJOR_TYPE_INT, uint(value));
373         } else {
374             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
375         }
376     }
377 
378     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
379         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
380         buf.append(value);
381     }
382 
383     function encodeString(Buffer.buffer memory buf, string value) internal pure {
384         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
385         buf.append(bytes(value));
386     }
387 
388     function startArray(Buffer.buffer memory buf) internal pure {
389         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
390     }
391 
392     function startMap(Buffer.buffer memory buf) internal pure {
393         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
394     }
395 
396     function endSequence(Buffer.buffer memory buf) internal pure {
397         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
398     }
399 }
400 
401 /*
402 End solidity-cborutils
403  */
404 
405 contract usingOraclize {
406     uint constant day = 60*60*24;
407     uint constant week = 60*60*24*7;
408     uint constant month = 60*60*24*30;
409     byte constant proofType_NONE = 0x00;
410     byte constant proofType_TLSNotary = 0x10;
411     byte constant proofType_Ledger = 0x30;
412     byte constant proofType_Android = 0x40;
413     byte constant proofType_Native = 0xF0;
414     byte constant proofStorage_IPFS = 0x01;
415     uint8 constant networkID_auto = 0;
416     uint8 constant networkID_mainnet = 1;
417     uint8 constant networkID_testnet = 2;
418     uint8 constant networkID_morden = 2;
419     uint8 constant networkID_consensys = 161;
420 
421     OraclizeAddrResolverI OAR;
422 
423     OraclizeI oraclize;
424     modifier oraclizeAPI {
425         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
426             oraclize_setNetwork(networkID_auto);
427 
428         if(address(oraclize) != OAR.getAddress())
429             oraclize = OraclizeI(OAR.getAddress());
430 
431         _;
432     }
433     modifier coupon(string code){
434         oraclize = OraclizeI(OAR.getAddress());
435         _;
436     }
437 
438     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
439       return oraclize_setNetwork();
440       networkID; // silence the warning and remain backwards compatible
441     }
442     function oraclize_setNetwork() internal returns(bool){
443         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
444             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
445             oraclize_setNetworkName("eth_mainnet");
446             return true;
447         }
448         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
449             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
450             oraclize_setNetworkName("eth_ropsten3");
451             return true;
452         }
453         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
454             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
455             oraclize_setNetworkName("eth_kovan");
456             return true;
457         }
458         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
459             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
460             oraclize_setNetworkName("eth_rinkeby");
461             return true;
462         }
463         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
464             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
465             return true;
466         }
467         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
468             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
469             return true;
470         }
471         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
472             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
473             return true;
474         }
475         return false;
476     }
477 
478     function __callback(bytes32 myid, string result) public {
479         __callback(myid, result, new bytes(0));
480     }
481     function __callback(bytes32 myid, string result, bytes proof) public {
482       return;
483       myid; result; proof; // Silence compiler warnings
484     }
485 
486     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
487         return oraclize.getPrice(datasource);
488     }
489 
490     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
491         return oraclize.getPrice(datasource, gaslimit);
492     }
493 
494     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
495         uint price = oraclize.getPrice(datasource);
496         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
497         return oraclize.query.value(price)(0, datasource, arg);
498     }
499     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
500         uint price = oraclize.getPrice(datasource);
501         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
502         return oraclize.query.value(price)(timestamp, datasource, arg);
503     }
504     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
505         uint price = oraclize.getPrice(datasource, gaslimit);
506         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
507         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
508     }
509     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
510         uint price = oraclize.getPrice(datasource, gaslimit);
511         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
512         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
513     }
514     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
515         uint price = oraclize.getPrice(datasource);
516         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
517         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
518     }
519     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
520         uint price = oraclize.getPrice(datasource);
521         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
522         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
523     }
524     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
525         uint price = oraclize.getPrice(datasource, gaslimit);
526         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
527         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
528     }
529     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
530         uint price = oraclize.getPrice(datasource, gaslimit);
531         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
532         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
533     }
534     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
535         uint price = oraclize.getPrice(datasource);
536         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
537         bytes memory args = stra2cbor(argN);
538         return oraclize.queryN.value(price)(0, datasource, args);
539     }
540     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
541         uint price = oraclize.getPrice(datasource);
542         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
543         bytes memory args = stra2cbor(argN);
544         return oraclize.queryN.value(price)(timestamp, datasource, args);
545     }
546     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
547         uint price = oraclize.getPrice(datasource, gaslimit);
548         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
549         bytes memory args = stra2cbor(argN);
550         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
551     }
552     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
553         uint price = oraclize.getPrice(datasource, gaslimit);
554         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
555         bytes memory args = stra2cbor(argN);
556         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
557     }
558     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
559         string[] memory dynargs = new string[](1);
560         dynargs[0] = args[0];
561         return oraclize_query(datasource, dynargs);
562     }
563     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
564         string[] memory dynargs = new string[](1);
565         dynargs[0] = args[0];
566         return oraclize_query(timestamp, datasource, dynargs);
567     }
568     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
569         string[] memory dynargs = new string[](1);
570         dynargs[0] = args[0];
571         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
572     }
573     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
574         string[] memory dynargs = new string[](1);
575         dynargs[0] = args[0];
576         return oraclize_query(datasource, dynargs, gaslimit);
577     }
578 
579     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
580         string[] memory dynargs = new string[](2);
581         dynargs[0] = args[0];
582         dynargs[1] = args[1];
583         return oraclize_query(datasource, dynargs);
584     }
585     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
586         string[] memory dynargs = new string[](2);
587         dynargs[0] = args[0];
588         dynargs[1] = args[1];
589         return oraclize_query(timestamp, datasource, dynargs);
590     }
591     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
592         string[] memory dynargs = new string[](2);
593         dynargs[0] = args[0];
594         dynargs[1] = args[1];
595         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
596     }
597     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
598         string[] memory dynargs = new string[](2);
599         dynargs[0] = args[0];
600         dynargs[1] = args[1];
601         return oraclize_query(datasource, dynargs, gaslimit);
602     }
603     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
604         string[] memory dynargs = new string[](3);
605         dynargs[0] = args[0];
606         dynargs[1] = args[1];
607         dynargs[2] = args[2];
608         return oraclize_query(datasource, dynargs);
609     }
610     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
611         string[] memory dynargs = new string[](3);
612         dynargs[0] = args[0];
613         dynargs[1] = args[1];
614         dynargs[2] = args[2];
615         return oraclize_query(timestamp, datasource, dynargs);
616     }
617     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
618         string[] memory dynargs = new string[](3);
619         dynargs[0] = args[0];
620         dynargs[1] = args[1];
621         dynargs[2] = args[2];
622         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
623     }
624     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
625         string[] memory dynargs = new string[](3);
626         dynargs[0] = args[0];
627         dynargs[1] = args[1];
628         dynargs[2] = args[2];
629         return oraclize_query(datasource, dynargs, gaslimit);
630     }
631 
632     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
633         string[] memory dynargs = new string[](4);
634         dynargs[0] = args[0];
635         dynargs[1] = args[1];
636         dynargs[2] = args[2];
637         dynargs[3] = args[3];
638         return oraclize_query(datasource, dynargs);
639     }
640     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
641         string[] memory dynargs = new string[](4);
642         dynargs[0] = args[0];
643         dynargs[1] = args[1];
644         dynargs[2] = args[2];
645         dynargs[3] = args[3];
646         return oraclize_query(timestamp, datasource, dynargs);
647     }
648     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
649         string[] memory dynargs = new string[](4);
650         dynargs[0] = args[0];
651         dynargs[1] = args[1];
652         dynargs[2] = args[2];
653         dynargs[3] = args[3];
654         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
655     }
656     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
657         string[] memory dynargs = new string[](4);
658         dynargs[0] = args[0];
659         dynargs[1] = args[1];
660         dynargs[2] = args[2];
661         dynargs[3] = args[3];
662         return oraclize_query(datasource, dynargs, gaslimit);
663     }
664     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
665         string[] memory dynargs = new string[](5);
666         dynargs[0] = args[0];
667         dynargs[1] = args[1];
668         dynargs[2] = args[2];
669         dynargs[3] = args[3];
670         dynargs[4] = args[4];
671         return oraclize_query(datasource, dynargs);
672     }
673     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
674         string[] memory dynargs = new string[](5);
675         dynargs[0] = args[0];
676         dynargs[1] = args[1];
677         dynargs[2] = args[2];
678         dynargs[3] = args[3];
679         dynargs[4] = args[4];
680         return oraclize_query(timestamp, datasource, dynargs);
681     }
682     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
683         string[] memory dynargs = new string[](5);
684         dynargs[0] = args[0];
685         dynargs[1] = args[1];
686         dynargs[2] = args[2];
687         dynargs[3] = args[3];
688         dynargs[4] = args[4];
689         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
690     }
691     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
692         string[] memory dynargs = new string[](5);
693         dynargs[0] = args[0];
694         dynargs[1] = args[1];
695         dynargs[2] = args[2];
696         dynargs[3] = args[3];
697         dynargs[4] = args[4];
698         return oraclize_query(datasource, dynargs, gaslimit);
699     }
700     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
701         uint price = oraclize.getPrice(datasource);
702         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
703         bytes memory args = ba2cbor(argN);
704         return oraclize.queryN.value(price)(0, datasource, args);
705     }
706     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
707         uint price = oraclize.getPrice(datasource);
708         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
709         bytes memory args = ba2cbor(argN);
710         return oraclize.queryN.value(price)(timestamp, datasource, args);
711     }
712     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
713         uint price = oraclize.getPrice(datasource, gaslimit);
714         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
715         bytes memory args = ba2cbor(argN);
716         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
717     }
718     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
719         uint price = oraclize.getPrice(datasource, gaslimit);
720         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
721         bytes memory args = ba2cbor(argN);
722         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
723     }
724     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
725         bytes[] memory dynargs = new bytes[](1);
726         dynargs[0] = args[0];
727         return oraclize_query(datasource, dynargs);
728     }
729     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
730         bytes[] memory dynargs = new bytes[](1);
731         dynargs[0] = args[0];
732         return oraclize_query(timestamp, datasource, dynargs);
733     }
734     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
735         bytes[] memory dynargs = new bytes[](1);
736         dynargs[0] = args[0];
737         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
738     }
739     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
740         bytes[] memory dynargs = new bytes[](1);
741         dynargs[0] = args[0];
742         return oraclize_query(datasource, dynargs, gaslimit);
743     }
744 
745     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
746         bytes[] memory dynargs = new bytes[](2);
747         dynargs[0] = args[0];
748         dynargs[1] = args[1];
749         return oraclize_query(datasource, dynargs);
750     }
751     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
752         bytes[] memory dynargs = new bytes[](2);
753         dynargs[0] = args[0];
754         dynargs[1] = args[1];
755         return oraclize_query(timestamp, datasource, dynargs);
756     }
757     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
758         bytes[] memory dynargs = new bytes[](2);
759         dynargs[0] = args[0];
760         dynargs[1] = args[1];
761         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
762     }
763     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
764         bytes[] memory dynargs = new bytes[](2);
765         dynargs[0] = args[0];
766         dynargs[1] = args[1];
767         return oraclize_query(datasource, dynargs, gaslimit);
768     }
769     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
770         bytes[] memory dynargs = new bytes[](3);
771         dynargs[0] = args[0];
772         dynargs[1] = args[1];
773         dynargs[2] = args[2];
774         return oraclize_query(datasource, dynargs);
775     }
776     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
777         bytes[] memory dynargs = new bytes[](3);
778         dynargs[0] = args[0];
779         dynargs[1] = args[1];
780         dynargs[2] = args[2];
781         return oraclize_query(timestamp, datasource, dynargs);
782     }
783     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
784         bytes[] memory dynargs = new bytes[](3);
785         dynargs[0] = args[0];
786         dynargs[1] = args[1];
787         dynargs[2] = args[2];
788         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
789     }
790     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
791         bytes[] memory dynargs = new bytes[](3);
792         dynargs[0] = args[0];
793         dynargs[1] = args[1];
794         dynargs[2] = args[2];
795         return oraclize_query(datasource, dynargs, gaslimit);
796     }
797 
798     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
799         bytes[] memory dynargs = new bytes[](4);
800         dynargs[0] = args[0];
801         dynargs[1] = args[1];
802         dynargs[2] = args[2];
803         dynargs[3] = args[3];
804         return oraclize_query(datasource, dynargs);
805     }
806     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
807         bytes[] memory dynargs = new bytes[](4);
808         dynargs[0] = args[0];
809         dynargs[1] = args[1];
810         dynargs[2] = args[2];
811         dynargs[3] = args[3];
812         return oraclize_query(timestamp, datasource, dynargs);
813     }
814     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
815         bytes[] memory dynargs = new bytes[](4);
816         dynargs[0] = args[0];
817         dynargs[1] = args[1];
818         dynargs[2] = args[2];
819         dynargs[3] = args[3];
820         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
821     }
822     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
823         bytes[] memory dynargs = new bytes[](4);
824         dynargs[0] = args[0];
825         dynargs[1] = args[1];
826         dynargs[2] = args[2];
827         dynargs[3] = args[3];
828         return oraclize_query(datasource, dynargs, gaslimit);
829     }
830     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
831         bytes[] memory dynargs = new bytes[](5);
832         dynargs[0] = args[0];
833         dynargs[1] = args[1];
834         dynargs[2] = args[2];
835         dynargs[3] = args[3];
836         dynargs[4] = args[4];
837         return oraclize_query(datasource, dynargs);
838     }
839     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
840         bytes[] memory dynargs = new bytes[](5);
841         dynargs[0] = args[0];
842         dynargs[1] = args[1];
843         dynargs[2] = args[2];
844         dynargs[3] = args[3];
845         dynargs[4] = args[4];
846         return oraclize_query(timestamp, datasource, dynargs);
847     }
848     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
849         bytes[] memory dynargs = new bytes[](5);
850         dynargs[0] = args[0];
851         dynargs[1] = args[1];
852         dynargs[2] = args[2];
853         dynargs[3] = args[3];
854         dynargs[4] = args[4];
855         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
856     }
857     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
858         bytes[] memory dynargs = new bytes[](5);
859         dynargs[0] = args[0];
860         dynargs[1] = args[1];
861         dynargs[2] = args[2];
862         dynargs[3] = args[3];
863         dynargs[4] = args[4];
864         return oraclize_query(datasource, dynargs, gaslimit);
865     }
866 
867     function oraclize_cbAddress() oraclizeAPI internal returns (address){
868         return oraclize.cbAddress();
869     }
870     function oraclize_setProof(byte proofP) oraclizeAPI internal {
871         return oraclize.setProofType(proofP);
872     }
873     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
874         return oraclize.setCustomGasPrice(gasPrice);
875     }
876 
877     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
878         return oraclize.randomDS_getSessionPubKeyHash();
879     }
880 
881     function getCodeSize(address _addr) constant internal returns(uint _size) {
882         assembly {
883             _size := extcodesize(_addr)
884         }
885     }
886 
887     function parseAddr(string _a) internal pure returns (address){
888         bytes memory tmp = bytes(_a);
889         uint160 iaddr = 0;
890         uint160 b1;
891         uint160 b2;
892         for (uint i=2; i<2+2*20; i+=2){
893             iaddr *= 256;
894             b1 = uint160(tmp[i]);
895             b2 = uint160(tmp[i+1]);
896             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
897             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
898             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
899             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
900             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
901             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
902             iaddr += (b1*16+b2);
903         }
904         return address(iaddr);
905     }
906 
907     function strCompare(string _a, string _b) internal pure returns (int) {
908         bytes memory a = bytes(_a);
909         bytes memory b = bytes(_b);
910         uint minLength = a.length;
911         if (b.length < minLength) minLength = b.length;
912         for (uint i = 0; i < minLength; i ++)
913             if (a[i] < b[i])
914                 return -1;
915             else if (a[i] > b[i])
916                 return 1;
917         if (a.length < b.length)
918             return -1;
919         else if (a.length > b.length)
920             return 1;
921         else
922             return 0;
923     }
924 
925     function indexOf(string _haystack, string _needle) internal pure returns (int) {
926         bytes memory h = bytes(_haystack);
927         bytes memory n = bytes(_needle);
928         if(h.length < 1 || n.length < 1 || (n.length > h.length))
929             return -1;
930         else if(h.length > (2**128 -1))
931             return -1;
932         else
933         {
934             uint subindex = 0;
935             for (uint i = 0; i < h.length; i ++)
936             {
937                 if (h[i] == n[0])
938                 {
939                     subindex = 1;
940                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
941                     {
942                         subindex++;
943                     }
944                     if(subindex == n.length)
945                         return int(i);
946                 }
947             }
948             return -1;
949         }
950     }
951 
952     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
953         bytes memory _ba = bytes(_a);
954         bytes memory _bb = bytes(_b);
955         bytes memory _bc = bytes(_c);
956         bytes memory _bd = bytes(_d);
957         bytes memory _be = bytes(_e);
958         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
959         bytes memory babcde = bytes(abcde);
960         uint k = 0;
961         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
962         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
963         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
964         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
965         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
966         return string(babcde);
967     }
968 
969     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
970         return strConcat(_a, _b, _c, _d, "");
971     }
972 
973     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
974         return strConcat(_a, _b, _c, "", "");
975     }
976 
977     function strConcat(string _a, string _b) internal pure returns (string) {
978         return strConcat(_a, _b, "", "", "");
979     }
980 
981     // parseInt
982     function parseInt(string _a) internal pure returns (uint) {
983         return parseInt(_a, 0);
984     }
985 
986     // parseInt(parseFloat*10^_b)
987     function parseInt(string _a, uint _b) internal pure returns (uint) {
988         bytes memory bresult = bytes(_a);
989         uint mint = 0;
990         bool decimals = false;
991         for (uint i=0; i<bresult.length; i++){
992             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
993                 if (decimals){
994                    if (_b == 0) break;
995                     else _b--;
996                 }
997                 mint *= 10;
998                 mint += uint(bresult[i]) - 48;
999             } else if (bresult[i] == 46) decimals = true;
1000         }
1001         if (_b > 0) mint *= 10**_b;
1002         return mint;
1003     }
1004 
1005     function uint2str(uint i) internal pure returns (string){
1006         if (i == 0) return "0";
1007         uint j = i;
1008         uint len;
1009         while (j != 0){
1010             len++;
1011             j /= 10;
1012         }
1013         bytes memory bstr = new bytes(len);
1014         uint k = len - 1;
1015         while (i != 0){
1016             bstr[k--] = byte(48 + i % 10);
1017             i /= 10;
1018         }
1019         return string(bstr);
1020     }
1021 
1022     using CBOR for Buffer.buffer;
1023     function stra2cbor(string[] arr) internal pure returns (bytes) {
1024         safeMemoryCleaner();
1025         Buffer.buffer memory buf;
1026         Buffer.init(buf, 1024);
1027         buf.startArray();
1028         for (uint i = 0; i < arr.length; i++) {
1029             buf.encodeString(arr[i]);
1030         }
1031         buf.endSequence();
1032         return buf.buf;
1033     }
1034 
1035     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
1036         safeMemoryCleaner();
1037         Buffer.buffer memory buf;
1038         Buffer.init(buf, 1024);
1039         buf.startArray();
1040         for (uint i = 0; i < arr.length; i++) {
1041             buf.encodeBytes(arr[i]);
1042         }
1043         buf.endSequence();
1044         return buf.buf;
1045     }
1046 
1047     string oraclize_network_name;
1048     function oraclize_setNetworkName(string _network_name) internal {
1049         oraclize_network_name = _network_name;
1050     }
1051 
1052     function oraclize_getNetworkName() internal view returns (string) {
1053         return oraclize_network_name;
1054     }
1055 
1056     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1057         require((_nbytes > 0) && (_nbytes <= 32));
1058         // Convert from seconds to ledger timer ticks
1059         _delay *= 10;
1060         bytes memory nbytes = new bytes(1);
1061         nbytes[0] = byte(_nbytes);
1062         bytes memory unonce = new bytes(32);
1063         bytes memory sessionKeyHash = new bytes(32);
1064         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1065         assembly {
1066             mstore(unonce, 0x20)
1067             // the following variables can be relaxed
1068             // check relaxed random contract under ethereum-examples repo
1069             // for an idea on how to override and replace comit hash vars
1070             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1071             mstore(sessionKeyHash, 0x20)
1072             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1073         }
1074         bytes memory delay = new bytes(32);
1075         assembly {
1076             mstore(add(delay, 0x20), _delay)
1077         }
1078 
1079         bytes memory delay_bytes8 = new bytes(8);
1080         copyBytes(delay, 24, 8, delay_bytes8, 0);
1081 
1082         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1083         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1084 
1085         bytes memory delay_bytes8_left = new bytes(8);
1086 
1087         assembly {
1088             let x := mload(add(delay_bytes8, 0x20))
1089             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1090             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1091             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1092             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1093             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1094             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1095             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1096             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1097 
1098         }
1099 
1100         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1101         return queryId;
1102     }
1103 
1104     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1105         oraclize_randomDS_args[queryId] = commitment;
1106     }
1107 
1108     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1109     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1110 
1111     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1112         bool sigok;
1113         address signer;
1114 
1115         bytes32 sigr;
1116         bytes32 sigs;
1117 
1118         bytes memory sigr_ = new bytes(32);
1119         uint offset = 4+(uint(dersig[3]) - 0x20);
1120         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1121         bytes memory sigs_ = new bytes(32);
1122         offset += 32 + 2;
1123         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1124 
1125         assembly {
1126             sigr := mload(add(sigr_, 32))
1127             sigs := mload(add(sigs_, 32))
1128         }
1129 
1130 
1131         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1132         if (address(keccak256(pubkey)) == signer) return true;
1133         else {
1134             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1135             return (address(keccak256(pubkey)) == signer);
1136         }
1137     }
1138 
1139     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1140         bool sigok;
1141 
1142         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1143         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1144         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1145 
1146         bytes memory appkey1_pubkey = new bytes(64);
1147         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1148 
1149         bytes memory tosign2 = new bytes(1+65+32);
1150         tosign2[0] = byte(1); //role
1151         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1152         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1153         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1154         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1155 
1156         if (sigok == false) return false;
1157 
1158 
1159         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1160         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1161 
1162         bytes memory tosign3 = new bytes(1+65);
1163         tosign3[0] = 0xFE;
1164         copyBytes(proof, 3, 65, tosign3, 1);
1165 
1166         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1167         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1168 
1169         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1170 
1171         return sigok;
1172     }
1173 
1174     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1175         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1176         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1177 
1178         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1179         require(proofVerified);
1180 
1181         _;
1182     }
1183 
1184     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1185         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1186         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1187 
1188         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1189         if (proofVerified == false) return 2;
1190 
1191         return 0;
1192     }
1193 
1194     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1195         bool match_ = true;
1196 
1197         require(prefix.length == n_random_bytes);
1198 
1199         for (uint256 i=0; i< n_random_bytes; i++) {
1200             if (content[i] != prefix[i]) match_ = false;
1201         }
1202 
1203         return match_;
1204     }
1205 
1206     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1207 
1208         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1209         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1210         bytes memory keyhash = new bytes(32);
1211         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1212         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1213 
1214         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1215         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1216 
1217         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1218         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1219 
1220         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1221         // This is to verify that the computed args match with the ones specified in the query.
1222         bytes memory commitmentSlice1 = new bytes(8+1+32);
1223         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1224 
1225         bytes memory sessionPubkey = new bytes(64);
1226         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1227         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1228 
1229         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1230         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1231             delete oraclize_randomDS_args[queryId];
1232         } else return false;
1233 
1234 
1235         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1236         bytes memory tosign1 = new bytes(32+8+1+32);
1237         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1238         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1239 
1240         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1241         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1242             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1243         }
1244 
1245         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1246     }
1247 
1248     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1249     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1250         uint minLength = length + toOffset;
1251 
1252         // Buffer too small
1253         require(to.length >= minLength); // Should be a better way?
1254 
1255         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1256         uint i = 32 + fromOffset;
1257         uint j = 32 + toOffset;
1258 
1259         while (i < (32 + fromOffset + length)) {
1260             assembly {
1261                 let tmp := mload(add(from, i))
1262                 mstore(add(to, j), tmp)
1263             }
1264             i += 32;
1265             j += 32;
1266         }
1267 
1268         return to;
1269     }
1270 
1271     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1272     // Duplicate Solidity's ecrecover, but catching the CALL return value
1273     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1274         // We do our own memory management here. Solidity uses memory offset
1275         // 0x40 to store the current end of memory. We write past it (as
1276         // writes are memory extensions), but don't update the offset so
1277         // Solidity will reuse it. The memory used here is only needed for
1278         // this context.
1279 
1280         // FIXME: inline assembly can't access return values
1281         bool ret;
1282         address addr;
1283 
1284         assembly {
1285             let size := mload(0x40)
1286             mstore(size, hash)
1287             mstore(add(size, 32), v)
1288             mstore(add(size, 64), r)
1289             mstore(add(size, 96), s)
1290 
1291             // NOTE: we can reuse the request memory because we deal with
1292             //       the return code
1293             ret := call(3000, 1, 0, size, 128, size, 32)
1294             addr := mload(size)
1295         }
1296 
1297         return (ret, addr);
1298     }
1299 
1300     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1301     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1302         bytes32 r;
1303         bytes32 s;
1304         uint8 v;
1305 
1306         if (sig.length != 65)
1307           return (false, 0);
1308 
1309         // The signature format is a compact form of:
1310         //   {bytes32 r}{bytes32 s}{uint8 v}
1311         // Compact means, uint8 is not padded to 32 bytes.
1312         assembly {
1313             r := mload(add(sig, 32))
1314             s := mload(add(sig, 64))
1315 
1316             // Here we are loading the last 32 bytes. We exploit the fact that
1317             // 'mload' will pad with zeroes if we overread.
1318             // There is no 'mload8' to do this, but that would be nicer.
1319             v := byte(0, mload(add(sig, 96)))
1320 
1321             // Alternative solution:
1322             // 'byte' is not working due to the Solidity parser, so lets
1323             // use the second best option, 'and'
1324             // v := and(mload(add(sig, 65)), 255)
1325         }
1326 
1327         // albeit non-transactional signatures are not specified by the YP, one would expect it
1328         // to match the YP range of [27, 28]
1329         //
1330         // geth uses [0, 1] and some clients have followed. This might change, see:
1331         //  https://github.com/ethereum/go-ethereum/issues/2053
1332         if (v < 27)
1333           v += 27;
1334 
1335         if (v != 27 && v != 28)
1336             return (false, 0);
1337 
1338         return safer_ecrecover(hash, v, r, s);
1339     }
1340 
1341     function safeMemoryCleaner() internal pure {
1342         assembly {
1343             let fmem := mload(0x40)
1344             codecopy(fmem, codesize, sub(msize, fmem))
1345         }
1346     }
1347 
1348 }
1349 // </ORACLIZE_API>
1350 
1351 
1352 pragma solidity ^0.4.11;
1353 
1354 /// @title EtherHiLo
1355 /// @dev the contract than handles the EtherHiLo app
1356 contract EtherHiLo is usingOraclize, Ownable {
1357 
1358     uint8 constant NUM_DICE_SIDES = 13;
1359     uint8 constant FAILED_ROLE = 69;
1360 
1361     // settings
1362     uint public rngCallbackGas;
1363     uint public minBet;
1364     uint public maxBetThresholdPct;
1365     bool public gameRunning;
1366 
1367     // state
1368     uint public balanceInPlay;
1369 
1370     mapping(address => Game) private gamesInProgress;
1371     mapping(bytes32 => address) private rollIdToGameAddress;
1372     mapping(bytes32 => uint) private failedRolls;
1373 
1374     event GameFinished(address indexed player, uint indexed playerGameNumber, uint bet, uint8 firstRoll, uint8 finalRoll, uint winnings, uint payout);
1375     event GameError(address indexed player, uint indexed playerGameNumber, bytes32 rollId);
1376 
1377     enum BetDirection {
1378         None,
1379         Low,
1380         High
1381     }
1382 
1383     enum GameState {
1384         None,
1385         WaitingForFirstCard,
1386         WaitingForDirection,
1387         WaitingForFinalCard,
1388         Finished
1389     }
1390 
1391     // the game object
1392     struct Game {
1393         address player;
1394         GameState state;
1395         uint id;
1396         BetDirection direction;
1397         uint bet;
1398         uint8 firstRoll;
1399         uint8 finalRoll;
1400         uint winnings;
1401     }
1402 
1403     // the constructor
1404     function EtherHiLo() public {
1405     }
1406 
1407     /// Default function
1408     function() external payable {
1409 
1410     }
1411 
1412 
1413     /// =======================
1414     /// EXTERNAL GAME RELATED FUNCTIONS
1415 
1416     // begins a game
1417     function beginGame() public payable {
1418         address player = msg.sender;
1419         uint bet = msg.value;
1420 
1421         require(player != address(0), "Invalid player");
1422         require(gamesInProgress[player].state == GameState.None
1423                 || gamesInProgress[player].state == GameState.Finished,
1424                 "Invalid game state");
1425         require(gameRunning, "Game is not currently running");
1426         require(bet >= minBet && bet <= getMaxBet(), "Invalid bet");
1427 
1428         Game memory game = Game({
1429                 id:         uint(keccak256(block.number, player, bet)),
1430                 player:     player,
1431                 state:      GameState.WaitingForFirstCard,
1432                 bet:        bet,
1433                 firstRoll:  0,
1434                 finalRoll:  0,
1435                 winnings:   0,
1436                 direction:  BetDirection.None
1437             });
1438 
1439         balanceInPlay = SafeMath.add(balanceInPlay, game.bet);
1440         gamesInProgress[player] = game;
1441 
1442         require(rollDie(player), "Dice roll failed");
1443     }
1444 
1445     // finishes a game that is in progress
1446     function finishGame(BetDirection direction) public {
1447         address player = msg.sender;
1448 
1449         require(player != address(0), "Invalid player");
1450         require(gamesInProgress[player].state == GameState.WaitingForDirection,
1451             "Invalid game state");
1452 
1453         Game storage game = gamesInProgress[player];
1454         game.direction = direction;
1455         game.state = GameState.WaitingForFinalCard;
1456         gamesInProgress[player] = game;
1457 
1458         require(rollDie(player), "Dice roll failed");
1459     }
1460 
1461     // returns current game state
1462     function getGameState(address player) public view returns
1463             (GameState, uint, BetDirection, uint, uint8, uint8, uint) {
1464         return (
1465             gamesInProgress[player].state,
1466             gamesInProgress[player].id,
1467             gamesInProgress[player].direction,
1468             gamesInProgress[player].bet,
1469             gamesInProgress[player].firstRoll,
1470             gamesInProgress[player].finalRoll,
1471             gamesInProgress[player].winnings
1472         );
1473     }
1474 
1475     // Returns the minimum bet
1476     function getMinBet() public view returns (uint) {
1477         return minBet;
1478     }
1479 
1480     // Returns the maximum bet
1481     function getMaxBet() public view returns (uint) {
1482         return SafeMath.div(SafeMath.div(SafeMath.mul(SafeMath.sub(this.balance, balanceInPlay), maxBetThresholdPct), 100), 12);
1483     }
1484 
1485     // calculates winnings for the given bet and percent
1486     function calculateWinnings(uint bet, uint percent) public pure returns (uint) {
1487         return SafeMath.div(SafeMath.mul(bet, percent), 100);
1488     }
1489 
1490     // Returns the win percent when going low on the given number
1491     function getLowWinPercent(uint number) public pure returns (uint) {
1492         require(number >= 2 && number <= NUM_DICE_SIDES, "Invalid number");
1493         if (number == 2) {
1494             return 1200;
1495         } else if (number == 3) {
1496             return 500;
1497         } else if (number == 4) {
1498             return 300;
1499         } else if (number == 5) {
1500             return 300;
1501         } else if (number == 6) {
1502             return 200;
1503         } else if (number == 7) {
1504             return 180;
1505         } else if (number == 8) {
1506             return 150;
1507         } else if (number == 9) {
1508             return 140;
1509         } else if (number == 10) {
1510             return 130;
1511         } else if (number == 11) {
1512             return 120;
1513         } else if (number == 12) {
1514             return 110;
1515         } else if (number == 13) {
1516             return 100;
1517         }
1518     }
1519 
1520     // Returns the win percent when going high on the given number
1521     function getHighWinPercent(uint number) public pure returns (uint) {
1522         require(number >= 1 && number < NUM_DICE_SIDES, "Invalid number");
1523         if (number == 1) {
1524             return 100;
1525         } else if (number == 2) {
1526             return 110;
1527         } else if (number == 3) {
1528             return 120;
1529         } else if (number == 4) {
1530             return 130;
1531         } else if (number == 5) {
1532             return 140;
1533         } else if (number == 6) {
1534             return 150;
1535         } else if (number == 7) {
1536             return 180;
1537         } else if (number == 8) {
1538             return 200;
1539         } else if (number == 9) {
1540             return 300;
1541         } else if (number == 10) {
1542             return 300;
1543         } else if (number == 11) {
1544             return 500;
1545         } else if (number == 12) {
1546             return 1200;
1547         }
1548     }
1549 
1550 
1551     /// =======================
1552     /// INTERNAL GAME RELATED FUNCTIONS
1553 
1554     // process a successful roll
1555     function processDiceRoll(address player, uint8 roll) private {
1556 
1557         Game storage game = gamesInProgress[player];
1558 
1559         if (game.firstRoll == 0) {
1560 
1561             game.firstRoll = roll;
1562             game.state = GameState.WaitingForDirection;
1563             gamesInProgress[player] = game;
1564 
1565             return;
1566         }
1567 
1568         require(gamesInProgress[player].state == GameState.WaitingForFinalCard,
1569             "Invalid game state");
1570 
1571         uint8 finalRoll = roll;
1572         uint winnings = 0;
1573 
1574         if (game.direction == BetDirection.High && finalRoll > game.firstRoll) {
1575             winnings = calculateWinnings(game.bet, getHighWinPercent(game.firstRoll));
1576         } else if (game.direction == BetDirection.Low && finalRoll < game.firstRoll) {
1577             winnings = calculateWinnings(game.bet, getLowWinPercent(game.firstRoll));
1578         }
1579 
1580         // this should never happen according to the odds,
1581         // and the fact that we don't allow people to bet
1582         // so large that they can take the whole pot in one
1583         // fell swoop - however, a number of people could
1584         // theoretically all win simultaneously and cause
1585         // this scenario.  This will try to at a minimum
1586         // send them back what they bet and then since it
1587         // is recorded on the blockchain we can verify that
1588         // the winnings sent don't match what they should be
1589         // and we can manually send the rest to the player.
1590         uint transferAmount = winnings;
1591         if (transferAmount > this.balance) {
1592             if (game.bet < this.balance) {
1593                 transferAmount = game.bet;
1594             } else {
1595                 transferAmount = SafeMath.div(SafeMath.mul(this.balance, 90), 100);
1596             }
1597         }
1598 
1599         balanceInPlay = SafeMath.add(balanceInPlay, game.bet);
1600 
1601         game.finalRoll = finalRoll;
1602         game.winnings = winnings;
1603         game.state = GameState.Finished;
1604         gamesInProgress[player] = game;
1605 
1606         if (transferAmount > 0) {
1607             game.player.transfer(transferAmount);
1608         }
1609 
1610         GameFinished(player, game.id, game.bet, game.firstRoll, finalRoll, winnings, transferAmount);
1611     }
1612 
1613     // roll the dice for a player
1614     function rollDie(address player) private returns (bool) {
1615         bytes32 rollId = oraclize_newRandomDSQuery(0, 7, rngCallbackGas);
1616         if (failedRolls[rollId] == FAILED_ROLE) {
1617             delete failedRolls[rollId];
1618             return false;
1619         }
1620         rollIdToGameAddress[rollId] = player;
1621         return true;
1622     }
1623 
1624 
1625     /// =======================
1626     /// ORACLIZE RELATED FUNCTIONS
1627 
1628     // the callback function is called by Oraclize when the result is ready
1629     // the oraclize_randomDS_proofVerify modifier prevents an invalid proof to execute this function code:
1630     // the proof validity is fully verified on-chain
1631     function __callback(bytes32 rollId, string _result, bytes _proof) public {
1632         require(msg.sender == oraclize_cbAddress(), "Only Oraclize can call this method");
1633 
1634         address player = rollIdToGameAddress[rollId];
1635 
1636         // avoid reorgs
1637         if (player == address(0)) {
1638             failedRolls[rollId] = FAILED_ROLE;
1639             return;
1640         }
1641 
1642         if (oraclize_randomDS_proofVerify__returnCode(rollId, _result, _proof) != 0) {
1643 
1644             Game storage game = gamesInProgress[player];
1645             if (game.bet > 0) {
1646                 game.player.transfer(game.bet);
1647             }
1648 
1649             delete gamesInProgress[player];
1650             delete rollIdToGameAddress[rollId];
1651             delete failedRolls[rollId];
1652             GameError(player, game.id, rollId);
1653 
1654         } else {
1655             uint8 randomNumber = uint8((uint(keccak256(_result)) % NUM_DICE_SIDES) + 1);
1656             processDiceRoll(player, randomNumber);
1657             delete rollIdToGameAddress[rollId];
1658 
1659         }
1660 
1661     }
1662 
1663 
1664     /// OWNER / MANAGEMENT RELATED FUNCTIONS
1665 
1666     // fail safe for balance transfer
1667     function transferBalance(address to, uint amount) public onlyOwner {
1668         to.transfer(amount);
1669     }
1670 
1671     // cleans up a player abandoned game, but only if it's
1672     // greater than 24 hours old.
1673     function cleanupAbandonedGame(address player) public onlyOwner {
1674         require(player != address(0), "Invalid player");
1675 
1676         Game storage game = gamesInProgress[player];
1677         require(game.player != address(0), "Invalid game player");
1678 
1679         game.player.transfer(game.bet);
1680         delete gamesInProgress[game.player];
1681     }
1682 
1683     // set RNG callback gas
1684     function setRNGCallbackGasConfig(uint gas, uint price) public onlyOwner {
1685         rngCallbackGas = gas;
1686         oraclize_setCustomGasPrice(price);
1687     }
1688 
1689     // set the minimum bet
1690     function setMinBet(uint bet) public onlyOwner {
1691         minBet = bet;
1692     }
1693 
1694     // set whether or not the game is running
1695     function setGameRunning(bool v) public onlyOwner {
1696         gameRunning = v;
1697     }
1698 
1699     // set the max bet threshold percent
1700     function setMaxBetThresholdPct(uint v) public onlyOwner {
1701         maxBetThresholdPct = v;
1702     }
1703 
1704     // Transfers the current balance to the recepient and terminates the contract.
1705     function destroyAndSend(address _recipient) public onlyOwner {
1706         selfdestruct(_recipient);
1707     }
1708 
1709 }