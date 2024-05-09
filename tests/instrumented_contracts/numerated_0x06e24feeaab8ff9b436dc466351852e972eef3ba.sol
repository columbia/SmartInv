1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     c = _a * _b;
22     assert(c / _a == _b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // assert(_b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33     return _a / _b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     assert(_b <= _a);
41     return _a - _b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
48     c = _a + _b;
49     assert(c >= _a);
50     return c;
51   }
52 }
53 
54 pragma solidity ^0.4.24;
55 
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    * @notice Renouncing to ownership will leave the contract without an owner.
92    * It will not be possible to call the functions with the `onlyOwner`
93    * modifier anymore.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address _newOwner) public onlyOwner {
105     _transferOwnership(_newOwner);
106   }
107 
108   /**
109    * @dev Transfers control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function _transferOwnership(address _newOwner) internal {
113     require(_newOwner != address(0));
114     emit OwnershipTransferred(owner, _newOwner);
115     owner = _newOwner;
116   }
117 }
118 
119 // <ORACLIZE_API>
120 /*
121 Copyright (c) 2015-2016 Oraclize SRL
122 Copyright (c) 2016 Oraclize LTD
123 
124 
125 
126 Permission is hereby granted, free of charge, to any person obtaining a copy
127 of this software and associated documentation files (the "Software"), to deal
128 in the Software without restriction, including without limitation the rights
129 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
130 copies of the Software, and to permit persons to whom the Software is
131 furnished to do so, subject to the following conditions:
132 
133 
134 
135 The above copyright notice and this permission notice shall be included in
136 all copies or substantial portions of the Software.
137 
138 
139 
140 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
141 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
142 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
143 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
144 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
145 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
146 THE SOFTWARE.
147 */
148 
149 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
150 
151 pragma solidity >=0.4.18;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
152 
153 contract OraclizeI {
154     address public cbAddress;
155     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
156     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
157     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
158     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
159     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
160     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
161     function getPrice(string _datasource) public returns (uint _dsprice);
162     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
163     function setProofType(byte _proofType) external;
164     function setCustomGasPrice(uint _gasPrice) external;
165     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
166 }
167 
168 contract OraclizeAddrResolverI {
169     function getAddress() public returns (address _addr);
170 }
171 
172 /*
173 Begin solidity-cborutils
174 
175 https://github.com/smartcontractkit/solidity-cborutils
176 
177 MIT License
178 
179 Copyright (c) 2018 SmartContract ChainLink, Ltd.
180 
181 Permission is hereby granted, free of charge, to any person obtaining a copy
182 of this software and associated documentation files (the "Software"), to deal
183 in the Software without restriction, including without limitation the rights
184 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
185 copies of the Software, and to permit persons to whom the Software is
186 furnished to do so, subject to the following conditions:
187 
188 The above copyright notice and this permission notice shall be included in all
189 copies or substantial portions of the Software.
190 
191 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
192 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
193 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
194 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
195 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
196 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
197 SOFTWARE.
198  */
199 
200 library Buffer {
201     struct buffer {
202         bytes buf;
203         uint capacity;
204     }
205 
206     function init(buffer memory buf, uint _capacity) internal pure {
207         uint capacity = _capacity;
208         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
209         // Allocate space for the buffer data
210         buf.capacity = capacity;
211         assembly {
212             let ptr := mload(0x40)
213             mstore(buf, ptr)
214             mstore(ptr, 0)
215             mstore(0x40, add(ptr, capacity))
216         }
217     }
218 
219     function resize(buffer memory buf, uint capacity) private pure {
220         bytes memory oldbuf = buf.buf;
221         init(buf, capacity);
222         append(buf, oldbuf);
223     }
224 
225     function max(uint a, uint b) private pure returns(uint) {
226         if(a > b) {
227             return a;
228         }
229         return b;
230     }
231 
232     /**
233      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
234      *      would exceed the capacity of the buffer.
235      * @param buf The buffer to append to.
236      * @param data The data to append.
237      * @return The original buffer.
238      */
239     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
240         if(data.length + buf.buf.length > buf.capacity) {
241             resize(buf, max(buf.capacity, data.length) * 2);
242         }
243 
244         uint dest;
245         uint src;
246         uint len = data.length;
247         assembly {
248             // Memory address of the buffer data
249             let bufptr := mload(buf)
250             // Length of existing buffer data
251             let buflen := mload(bufptr)
252             // Start address = buffer address + buffer length + sizeof(buffer length)
253             dest := add(add(bufptr, buflen), 32)
254             // Update buffer length
255             mstore(bufptr, add(buflen, mload(data)))
256             src := add(data, 32)
257         }
258 
259         // Copy word-length chunks while possible
260         for(; len >= 32; len -= 32) {
261             assembly {
262                 mstore(dest, mload(src))
263             }
264             dest += 32;
265             src += 32;
266         }
267 
268         // Copy remaining bytes
269         uint mask = 256 ** (32 - len) - 1;
270         assembly {
271             let srcpart := and(mload(src), not(mask))
272             let destpart := and(mload(dest), mask)
273             mstore(dest, or(destpart, srcpart))
274         }
275 
276         return buf;
277     }
278 
279     /**
280      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
281      * exceed the capacity of the buffer.
282      * @param buf The buffer to append to.
283      * @param data The data to append.
284      * @return The original buffer.
285      */
286     function append(buffer memory buf, uint8 data) internal pure {
287         if(buf.buf.length + 1 > buf.capacity) {
288             resize(buf, buf.capacity * 2);
289         }
290 
291         assembly {
292             // Memory address of the buffer data
293             let bufptr := mload(buf)
294             // Length of existing buffer data
295             let buflen := mload(bufptr)
296             // Address = buffer address + buffer length + sizeof(buffer length)
297             let dest := add(add(bufptr, buflen), 32)
298             mstore8(dest, data)
299             // Update buffer length
300             mstore(bufptr, add(buflen, 1))
301         }
302     }
303 
304     /**
305      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
306      * exceed the capacity of the buffer.
307      * @param buf The buffer to append to.
308      * @param data The data to append.
309      * @return The original buffer.
310      */
311     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
312         if(len + buf.buf.length > buf.capacity) {
313             resize(buf, max(buf.capacity, len) * 2);
314         }
315 
316         uint mask = 256 ** len - 1;
317         assembly {
318             // Memory address of the buffer data
319             let bufptr := mload(buf)
320             // Length of existing buffer data
321             let buflen := mload(bufptr)
322             // Address = buffer address + buffer length + sizeof(buffer length) + len
323             let dest := add(add(bufptr, buflen), len)
324             mstore(dest, or(and(mload(dest), not(mask)), data))
325             // Update buffer length
326             mstore(bufptr, add(buflen, len))
327         }
328         return buf;
329     }
330 }
331 
332 library CBOR {
333     using Buffer for Buffer.buffer;
334 
335     uint8 private constant MAJOR_TYPE_INT = 0;
336     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
337     uint8 private constant MAJOR_TYPE_BYTES = 2;
338     uint8 private constant MAJOR_TYPE_STRING = 3;
339     uint8 private constant MAJOR_TYPE_ARRAY = 4;
340     uint8 private constant MAJOR_TYPE_MAP = 5;
341     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
342 
343     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
344         if(value <= 23) {
345             buf.append(uint8((major << 5) | value));
346         } else if(value <= 0xFF) {
347             buf.append(uint8((major << 5) | 24));
348             buf.appendInt(value, 1);
349         } else if(value <= 0xFFFF) {
350             buf.append(uint8((major << 5) | 25));
351             buf.appendInt(value, 2);
352         } else if(value <= 0xFFFFFFFF) {
353             buf.append(uint8((major << 5) | 26));
354             buf.appendInt(value, 4);
355         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
356             buf.append(uint8((major << 5) | 27));
357             buf.appendInt(value, 8);
358         }
359     }
360 
361     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
362         buf.append(uint8((major << 5) | 31));
363     }
364 
365     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
366         encodeType(buf, MAJOR_TYPE_INT, value);
367     }
368 
369     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
370         if(value >= 0) {
371             encodeType(buf, MAJOR_TYPE_INT, uint(value));
372         } else {
373             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
374         }
375     }
376 
377     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
378         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
379         buf.append(value);
380     }
381 
382     function encodeString(Buffer.buffer memory buf, string value) internal pure {
383         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
384         buf.append(bytes(value));
385     }
386 
387     function startArray(Buffer.buffer memory buf) internal pure {
388         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
389     }
390 
391     function startMap(Buffer.buffer memory buf) internal pure {
392         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
393     }
394 
395     function endSequence(Buffer.buffer memory buf) internal pure {
396         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
397     }
398 }
399 
400 /*
401 End solidity-cborutils
402  */
403 
404 contract usingOraclize {
405     uint constant day = 60*60*24;
406     uint constant week = 60*60*24*7;
407     uint constant month = 60*60*24*30;
408     byte constant proofType_NONE = 0x00;
409     byte constant proofType_TLSNotary = 0x10;
410     byte constant proofType_Ledger = 0x30;
411     byte constant proofType_Android = 0x40;
412     byte constant proofType_Native = 0xF0;
413     byte constant proofStorage_IPFS = 0x01;
414     uint8 constant networkID_auto = 0;
415     uint8 constant networkID_mainnet = 1;
416     uint8 constant networkID_testnet = 2;
417     uint8 constant networkID_morden = 2;
418     uint8 constant networkID_consensys = 161;
419 
420     OraclizeAddrResolverI OAR;
421 
422     OraclizeI oraclize;
423     modifier oraclizeAPI {
424         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
425             oraclize_setNetwork(networkID_auto);
426 
427         if(address(oraclize) != OAR.getAddress())
428             oraclize = OraclizeI(OAR.getAddress());
429 
430         _;
431     }
432     modifier coupon(string code){
433         oraclize = OraclizeI(OAR.getAddress());
434         _;
435     }
436 
437     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
438       return oraclize_setNetwork();
439       networkID; // silence the warning and remain backwards compatible
440     }
441     function oraclize_setNetwork() internal returns(bool){
442         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
443             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
444             oraclize_setNetworkName("eth_mainnet");
445             return true;
446         }
447         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
448             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
449             oraclize_setNetworkName("eth_ropsten3");
450             return true;
451         }
452         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
453             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
454             oraclize_setNetworkName("eth_kovan");
455             return true;
456         }
457         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
458             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
459             oraclize_setNetworkName("eth_rinkeby");
460             return true;
461         }
462         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
463             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
464             return true;
465         }
466         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
467             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
468             return true;
469         }
470         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
471             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
472             return true;
473         }
474         return false;
475     }
476 
477     function __callback(bytes32 myid, string result) public {
478         __callback(myid, result, new bytes(0));
479     }
480     function __callback(bytes32 myid, string result, bytes proof) public {
481       return;
482       myid; result; proof; // Silence compiler warnings
483     }
484 
485     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
486         return oraclize.getPrice(datasource);
487     }
488 
489     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
490         return oraclize.getPrice(datasource, gaslimit);
491     }
492 
493     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
494         uint price = oraclize.getPrice(datasource);
495         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
496         return oraclize.query.value(price)(0, datasource, arg);
497     }
498     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
499         uint price = oraclize.getPrice(datasource);
500         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
501         return oraclize.query.value(price)(timestamp, datasource, arg);
502     }
503     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
504         uint price = oraclize.getPrice(datasource, gaslimit);
505         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
506         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
507     }
508     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
509         uint price = oraclize.getPrice(datasource, gaslimit);
510         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
511         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
512     }
513     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
514         uint price = oraclize.getPrice(datasource);
515         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
516         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
517     }
518     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
519         uint price = oraclize.getPrice(datasource);
520         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
521         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
522     }
523     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
524         uint price = oraclize.getPrice(datasource, gaslimit);
525         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
526         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
527     }
528     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
529         uint price = oraclize.getPrice(datasource, gaslimit);
530         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
531         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
532     }
533     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
534         uint price = oraclize.getPrice(datasource);
535         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
536         bytes memory args = stra2cbor(argN);
537         return oraclize.queryN.value(price)(0, datasource, args);
538     }
539     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
540         uint price = oraclize.getPrice(datasource);
541         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
542         bytes memory args = stra2cbor(argN);
543         return oraclize.queryN.value(price)(timestamp, datasource, args);
544     }
545     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
546         uint price = oraclize.getPrice(datasource, gaslimit);
547         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
548         bytes memory args = stra2cbor(argN);
549         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
550     }
551     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
552         uint price = oraclize.getPrice(datasource, gaslimit);
553         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
554         bytes memory args = stra2cbor(argN);
555         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
556     }
557     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
558         string[] memory dynargs = new string[](1);
559         dynargs[0] = args[0];
560         return oraclize_query(datasource, dynargs);
561     }
562     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
563         string[] memory dynargs = new string[](1);
564         dynargs[0] = args[0];
565         return oraclize_query(timestamp, datasource, dynargs);
566     }
567     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
568         string[] memory dynargs = new string[](1);
569         dynargs[0] = args[0];
570         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
571     }
572     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
573         string[] memory dynargs = new string[](1);
574         dynargs[0] = args[0];
575         return oraclize_query(datasource, dynargs, gaslimit);
576     }
577 
578     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
579         string[] memory dynargs = new string[](2);
580         dynargs[0] = args[0];
581         dynargs[1] = args[1];
582         return oraclize_query(datasource, dynargs);
583     }
584     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
585         string[] memory dynargs = new string[](2);
586         dynargs[0] = args[0];
587         dynargs[1] = args[1];
588         return oraclize_query(timestamp, datasource, dynargs);
589     }
590     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
591         string[] memory dynargs = new string[](2);
592         dynargs[0] = args[0];
593         dynargs[1] = args[1];
594         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
595     }
596     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
597         string[] memory dynargs = new string[](2);
598         dynargs[0] = args[0];
599         dynargs[1] = args[1];
600         return oraclize_query(datasource, dynargs, gaslimit);
601     }
602     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
603         string[] memory dynargs = new string[](3);
604         dynargs[0] = args[0];
605         dynargs[1] = args[1];
606         dynargs[2] = args[2];
607         return oraclize_query(datasource, dynargs);
608     }
609     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
610         string[] memory dynargs = new string[](3);
611         dynargs[0] = args[0];
612         dynargs[1] = args[1];
613         dynargs[2] = args[2];
614         return oraclize_query(timestamp, datasource, dynargs);
615     }
616     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
617         string[] memory dynargs = new string[](3);
618         dynargs[0] = args[0];
619         dynargs[1] = args[1];
620         dynargs[2] = args[2];
621         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
622     }
623     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
624         string[] memory dynargs = new string[](3);
625         dynargs[0] = args[0];
626         dynargs[1] = args[1];
627         dynargs[2] = args[2];
628         return oraclize_query(datasource, dynargs, gaslimit);
629     }
630 
631     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
632         string[] memory dynargs = new string[](4);
633         dynargs[0] = args[0];
634         dynargs[1] = args[1];
635         dynargs[2] = args[2];
636         dynargs[3] = args[3];
637         return oraclize_query(datasource, dynargs);
638     }
639     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
640         string[] memory dynargs = new string[](4);
641         dynargs[0] = args[0];
642         dynargs[1] = args[1];
643         dynargs[2] = args[2];
644         dynargs[3] = args[3];
645         return oraclize_query(timestamp, datasource, dynargs);
646     }
647     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
648         string[] memory dynargs = new string[](4);
649         dynargs[0] = args[0];
650         dynargs[1] = args[1];
651         dynargs[2] = args[2];
652         dynargs[3] = args[3];
653         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
654     }
655     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
656         string[] memory dynargs = new string[](4);
657         dynargs[0] = args[0];
658         dynargs[1] = args[1];
659         dynargs[2] = args[2];
660         dynargs[3] = args[3];
661         return oraclize_query(datasource, dynargs, gaslimit);
662     }
663     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
664         string[] memory dynargs = new string[](5);
665         dynargs[0] = args[0];
666         dynargs[1] = args[1];
667         dynargs[2] = args[2];
668         dynargs[3] = args[3];
669         dynargs[4] = args[4];
670         return oraclize_query(datasource, dynargs);
671     }
672     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
673         string[] memory dynargs = new string[](5);
674         dynargs[0] = args[0];
675         dynargs[1] = args[1];
676         dynargs[2] = args[2];
677         dynargs[3] = args[3];
678         dynargs[4] = args[4];
679         return oraclize_query(timestamp, datasource, dynargs);
680     }
681     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
682         string[] memory dynargs = new string[](5);
683         dynargs[0] = args[0];
684         dynargs[1] = args[1];
685         dynargs[2] = args[2];
686         dynargs[3] = args[3];
687         dynargs[4] = args[4];
688         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
689     }
690     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
691         string[] memory dynargs = new string[](5);
692         dynargs[0] = args[0];
693         dynargs[1] = args[1];
694         dynargs[2] = args[2];
695         dynargs[3] = args[3];
696         dynargs[4] = args[4];
697         return oraclize_query(datasource, dynargs, gaslimit);
698     }
699     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
700         uint price = oraclize.getPrice(datasource);
701         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
702         bytes memory args = ba2cbor(argN);
703         return oraclize.queryN.value(price)(0, datasource, args);
704     }
705     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
706         uint price = oraclize.getPrice(datasource);
707         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
708         bytes memory args = ba2cbor(argN);
709         return oraclize.queryN.value(price)(timestamp, datasource, args);
710     }
711     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
712         uint price = oraclize.getPrice(datasource, gaslimit);
713         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
714         bytes memory args = ba2cbor(argN);
715         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
716     }
717     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
718         uint price = oraclize.getPrice(datasource, gaslimit);
719         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
720         bytes memory args = ba2cbor(argN);
721         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
722     }
723     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
724         bytes[] memory dynargs = new bytes[](1);
725         dynargs[0] = args[0];
726         return oraclize_query(datasource, dynargs);
727     }
728     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
729         bytes[] memory dynargs = new bytes[](1);
730         dynargs[0] = args[0];
731         return oraclize_query(timestamp, datasource, dynargs);
732     }
733     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
734         bytes[] memory dynargs = new bytes[](1);
735         dynargs[0] = args[0];
736         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
737     }
738     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
739         bytes[] memory dynargs = new bytes[](1);
740         dynargs[0] = args[0];
741         return oraclize_query(datasource, dynargs, gaslimit);
742     }
743 
744     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
745         bytes[] memory dynargs = new bytes[](2);
746         dynargs[0] = args[0];
747         dynargs[1] = args[1];
748         return oraclize_query(datasource, dynargs);
749     }
750     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
751         bytes[] memory dynargs = new bytes[](2);
752         dynargs[0] = args[0];
753         dynargs[1] = args[1];
754         return oraclize_query(timestamp, datasource, dynargs);
755     }
756     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
757         bytes[] memory dynargs = new bytes[](2);
758         dynargs[0] = args[0];
759         dynargs[1] = args[1];
760         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
761     }
762     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
763         bytes[] memory dynargs = new bytes[](2);
764         dynargs[0] = args[0];
765         dynargs[1] = args[1];
766         return oraclize_query(datasource, dynargs, gaslimit);
767     }
768     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
769         bytes[] memory dynargs = new bytes[](3);
770         dynargs[0] = args[0];
771         dynargs[1] = args[1];
772         dynargs[2] = args[2];
773         return oraclize_query(datasource, dynargs);
774     }
775     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
776         bytes[] memory dynargs = new bytes[](3);
777         dynargs[0] = args[0];
778         dynargs[1] = args[1];
779         dynargs[2] = args[2];
780         return oraclize_query(timestamp, datasource, dynargs);
781     }
782     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
783         bytes[] memory dynargs = new bytes[](3);
784         dynargs[0] = args[0];
785         dynargs[1] = args[1];
786         dynargs[2] = args[2];
787         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
788     }
789     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
790         bytes[] memory dynargs = new bytes[](3);
791         dynargs[0] = args[0];
792         dynargs[1] = args[1];
793         dynargs[2] = args[2];
794         return oraclize_query(datasource, dynargs, gaslimit);
795     }
796 
797     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
798         bytes[] memory dynargs = new bytes[](4);
799         dynargs[0] = args[0];
800         dynargs[1] = args[1];
801         dynargs[2] = args[2];
802         dynargs[3] = args[3];
803         return oraclize_query(datasource, dynargs);
804     }
805     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
806         bytes[] memory dynargs = new bytes[](4);
807         dynargs[0] = args[0];
808         dynargs[1] = args[1];
809         dynargs[2] = args[2];
810         dynargs[3] = args[3];
811         return oraclize_query(timestamp, datasource, dynargs);
812     }
813     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
814         bytes[] memory dynargs = new bytes[](4);
815         dynargs[0] = args[0];
816         dynargs[1] = args[1];
817         dynargs[2] = args[2];
818         dynargs[3] = args[3];
819         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
820     }
821     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
822         bytes[] memory dynargs = new bytes[](4);
823         dynargs[0] = args[0];
824         dynargs[1] = args[1];
825         dynargs[2] = args[2];
826         dynargs[3] = args[3];
827         return oraclize_query(datasource, dynargs, gaslimit);
828     }
829     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
830         bytes[] memory dynargs = new bytes[](5);
831         dynargs[0] = args[0];
832         dynargs[1] = args[1];
833         dynargs[2] = args[2];
834         dynargs[3] = args[3];
835         dynargs[4] = args[4];
836         return oraclize_query(datasource, dynargs);
837     }
838     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
839         bytes[] memory dynargs = new bytes[](5);
840         dynargs[0] = args[0];
841         dynargs[1] = args[1];
842         dynargs[2] = args[2];
843         dynargs[3] = args[3];
844         dynargs[4] = args[4];
845         return oraclize_query(timestamp, datasource, dynargs);
846     }
847     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
848         bytes[] memory dynargs = new bytes[](5);
849         dynargs[0] = args[0];
850         dynargs[1] = args[1];
851         dynargs[2] = args[2];
852         dynargs[3] = args[3];
853         dynargs[4] = args[4];
854         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
855     }
856     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
857         bytes[] memory dynargs = new bytes[](5);
858         dynargs[0] = args[0];
859         dynargs[1] = args[1];
860         dynargs[2] = args[2];
861         dynargs[3] = args[3];
862         dynargs[4] = args[4];
863         return oraclize_query(datasource, dynargs, gaslimit);
864     }
865 
866     function oraclize_cbAddress() oraclizeAPI internal returns (address){
867         return oraclize.cbAddress();
868     }
869     function oraclize_setProof(byte proofP) oraclizeAPI internal {
870         return oraclize.setProofType(proofP);
871     }
872     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
873         return oraclize.setCustomGasPrice(gasPrice);
874     }
875 
876     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
877         return oraclize.randomDS_getSessionPubKeyHash();
878     }
879 
880     function getCodeSize(address _addr) constant internal returns(uint _size) {
881         assembly {
882             _size := extcodesize(_addr)
883         }
884     }
885 
886     function parseAddr(string _a) internal pure returns (address){
887         bytes memory tmp = bytes(_a);
888         uint160 iaddr = 0;
889         uint160 b1;
890         uint160 b2;
891         for (uint i=2; i<2+2*20; i+=2){
892             iaddr *= 256;
893             b1 = uint160(tmp[i]);
894             b2 = uint160(tmp[i+1]);
895             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
896             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
897             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
898             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
899             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
900             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
901             iaddr += (b1*16+b2);
902         }
903         return address(iaddr);
904     }
905 
906     function strCompare(string _a, string _b) internal pure returns (int) {
907         bytes memory a = bytes(_a);
908         bytes memory b = bytes(_b);
909         uint minLength = a.length;
910         if (b.length < minLength) minLength = b.length;
911         for (uint i = 0; i < minLength; i ++)
912             if (a[i] < b[i])
913                 return -1;
914             else if (a[i] > b[i])
915                 return 1;
916         if (a.length < b.length)
917             return -1;
918         else if (a.length > b.length)
919             return 1;
920         else
921             return 0;
922     }
923 
924     function indexOf(string _haystack, string _needle) internal pure returns (int) {
925         bytes memory h = bytes(_haystack);
926         bytes memory n = bytes(_needle);
927         if(h.length < 1 || n.length < 1 || (n.length > h.length))
928             return -1;
929         else if(h.length > (2**128 -1))
930             return -1;
931         else
932         {
933             uint subindex = 0;
934             for (uint i = 0; i < h.length; i ++)
935             {
936                 if (h[i] == n[0])
937                 {
938                     subindex = 1;
939                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
940                     {
941                         subindex++;
942                     }
943                     if(subindex == n.length)
944                         return int(i);
945                 }
946             }
947             return -1;
948         }
949     }
950 
951     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
952         bytes memory _ba = bytes(_a);
953         bytes memory _bb = bytes(_b);
954         bytes memory _bc = bytes(_c);
955         bytes memory _bd = bytes(_d);
956         bytes memory _be = bytes(_e);
957         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
958         bytes memory babcde = bytes(abcde);
959         uint k = 0;
960         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
961         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
962         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
963         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
964         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
965         return string(babcde);
966     }
967 
968     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
969         return strConcat(_a, _b, _c, _d, "");
970     }
971 
972     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
973         return strConcat(_a, _b, _c, "", "");
974     }
975 
976     function strConcat(string _a, string _b) internal pure returns (string) {
977         return strConcat(_a, _b, "", "", "");
978     }
979 
980     // parseInt
981     function parseInt(string _a) internal pure returns (uint) {
982         return parseInt(_a, 0);
983     }
984 
985     // parseInt(parseFloat*10^_b)
986     function parseInt(string _a, uint _b) internal pure returns (uint) {
987         bytes memory bresult = bytes(_a);
988         uint mint = 0;
989         bool decimals = false;
990         for (uint i=0; i<bresult.length; i++){
991             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
992                 if (decimals){
993                    if (_b == 0) break;
994                     else _b--;
995                 }
996                 mint *= 10;
997                 mint += uint(bresult[i]) - 48;
998             } else if (bresult[i] == 46) decimals = true;
999         }
1000         if (_b > 0) mint *= 10**_b;
1001         return mint;
1002     }
1003 
1004     function uint2str(uint i) internal pure returns (string){
1005         if (i == 0) return "0";
1006         uint j = i;
1007         uint len;
1008         while (j != 0){
1009             len++;
1010             j /= 10;
1011         }
1012         bytes memory bstr = new bytes(len);
1013         uint k = len - 1;
1014         while (i != 0){
1015             bstr[k--] = byte(48 + i % 10);
1016             i /= 10;
1017         }
1018         return string(bstr);
1019     }
1020 
1021     using CBOR for Buffer.buffer;
1022     function stra2cbor(string[] arr) internal pure returns (bytes) {
1023         safeMemoryCleaner();
1024         Buffer.buffer memory buf;
1025         Buffer.init(buf, 1024);
1026         buf.startArray();
1027         for (uint i = 0; i < arr.length; i++) {
1028             buf.encodeString(arr[i]);
1029         }
1030         buf.endSequence();
1031         return buf.buf;
1032     }
1033 
1034     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
1035         safeMemoryCleaner();
1036         Buffer.buffer memory buf;
1037         Buffer.init(buf, 1024);
1038         buf.startArray();
1039         for (uint i = 0; i < arr.length; i++) {
1040             buf.encodeBytes(arr[i]);
1041         }
1042         buf.endSequence();
1043         return buf.buf;
1044     }
1045 
1046     string oraclize_network_name;
1047     function oraclize_setNetworkName(string _network_name) internal {
1048         oraclize_network_name = _network_name;
1049     }
1050 
1051     function oraclize_getNetworkName() internal view returns (string) {
1052         return oraclize_network_name;
1053     }
1054 
1055     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1056         require((_nbytes > 0) && (_nbytes <= 32));
1057         // Convert from seconds to ledger timer ticks
1058         _delay *= 10;
1059         bytes memory nbytes = new bytes(1);
1060         nbytes[0] = byte(_nbytes);
1061         bytes memory unonce = new bytes(32);
1062         bytes memory sessionKeyHash = new bytes(32);
1063         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1064         assembly {
1065             mstore(unonce, 0x20)
1066             // the following variables can be relaxed
1067             // check relaxed random contract under ethereum-examples repo
1068             // for an idea on how to override and replace comit hash vars
1069             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1070             mstore(sessionKeyHash, 0x20)
1071             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1072         }
1073         bytes memory delay = new bytes(32);
1074         assembly {
1075             mstore(add(delay, 0x20), _delay)
1076         }
1077 
1078         bytes memory delay_bytes8 = new bytes(8);
1079         copyBytes(delay, 24, 8, delay_bytes8, 0);
1080 
1081         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1082         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1083 
1084         bytes memory delay_bytes8_left = new bytes(8);
1085 
1086         assembly {
1087             let x := mload(add(delay_bytes8, 0x20))
1088             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1089             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1090             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1091             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1092             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1093             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1094             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1095             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1096 
1097         }
1098 
1099         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1100         return queryId;
1101     }
1102 
1103     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1104         oraclize_randomDS_args[queryId] = commitment;
1105     }
1106 
1107     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1108     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1109 
1110     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1111         bool sigok;
1112         address signer;
1113 
1114         bytes32 sigr;
1115         bytes32 sigs;
1116 
1117         bytes memory sigr_ = new bytes(32);
1118         uint offset = 4+(uint(dersig[3]) - 0x20);
1119         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1120         bytes memory sigs_ = new bytes(32);
1121         offset += 32 + 2;
1122         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1123 
1124         assembly {
1125             sigr := mload(add(sigr_, 32))
1126             sigs := mload(add(sigs_, 32))
1127         }
1128 
1129 
1130         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1131         if (address(keccak256(pubkey)) == signer) return true;
1132         else {
1133             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1134             return (address(keccak256(pubkey)) == signer);
1135         }
1136     }
1137 
1138     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1139         bool sigok;
1140 
1141         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1142         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1143         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1144 
1145         bytes memory appkey1_pubkey = new bytes(64);
1146         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1147 
1148         bytes memory tosign2 = new bytes(1+65+32);
1149         tosign2[0] = byte(1); //role
1150         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1151         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1152         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1153         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1154 
1155         if (sigok == false) return false;
1156 
1157 
1158         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1159         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1160 
1161         bytes memory tosign3 = new bytes(1+65);
1162         tosign3[0] = 0xFE;
1163         copyBytes(proof, 3, 65, tosign3, 1);
1164 
1165         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1166         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1167 
1168         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1169 
1170         return sigok;
1171     }
1172 
1173     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1174         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1175         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1176 
1177         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1178         require(proofVerified);
1179 
1180         _;
1181     }
1182 
1183     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1184         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1185         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1186 
1187         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1188         if (proofVerified == false) return 2;
1189 
1190         return 0;
1191     }
1192 
1193     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1194         bool match_ = true;
1195 
1196         require(prefix.length == n_random_bytes);
1197 
1198         for (uint256 i=0; i< n_random_bytes; i++) {
1199             if (content[i] != prefix[i]) match_ = false;
1200         }
1201 
1202         return match_;
1203     }
1204 
1205     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1206 
1207         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1208         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1209         bytes memory keyhash = new bytes(32);
1210         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1211         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1212 
1213         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1214         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1215 
1216         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1217         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1218 
1219         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1220         // This is to verify that the computed args match with the ones specified in the query.
1221         bytes memory commitmentSlice1 = new bytes(8+1+32);
1222         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1223 
1224         bytes memory sessionPubkey = new bytes(64);
1225         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1226         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1227 
1228         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1229         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1230             delete oraclize_randomDS_args[queryId];
1231         } else return false;
1232 
1233 
1234         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1235         bytes memory tosign1 = new bytes(32+8+1+32);
1236         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1237         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1238 
1239         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1240         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1241             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1242         }
1243 
1244         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1245     }
1246 
1247     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1248     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1249         uint minLength = length + toOffset;
1250 
1251         // Buffer too small
1252         require(to.length >= minLength); // Should be a better way?
1253 
1254         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1255         uint i = 32 + fromOffset;
1256         uint j = 32 + toOffset;
1257 
1258         while (i < (32 + fromOffset + length)) {
1259             assembly {
1260                 let tmp := mload(add(from, i))
1261                 mstore(add(to, j), tmp)
1262             }
1263             i += 32;
1264             j += 32;
1265         }
1266 
1267         return to;
1268     }
1269 
1270     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1271     // Duplicate Solidity's ecrecover, but catching the CALL return value
1272     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1273         // We do our own memory management here. Solidity uses memory offset
1274         // 0x40 to store the current end of memory. We write past it (as
1275         // writes are memory extensions), but don't update the offset so
1276         // Solidity will reuse it. The memory used here is only needed for
1277         // this context.
1278 
1279         // FIXME: inline assembly can't access return values
1280         bool ret;
1281         address addr;
1282 
1283         assembly {
1284             let size := mload(0x40)
1285             mstore(size, hash)
1286             mstore(add(size, 32), v)
1287             mstore(add(size, 64), r)
1288             mstore(add(size, 96), s)
1289 
1290             // NOTE: we can reuse the request memory because we deal with
1291             //       the return code
1292             ret := call(3000, 1, 0, size, 128, size, 32)
1293             addr := mload(size)
1294         }
1295 
1296         return (ret, addr);
1297     }
1298 
1299     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1300     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1301         bytes32 r;
1302         bytes32 s;
1303         uint8 v;
1304 
1305         if (sig.length != 65)
1306           return (false, 0);
1307 
1308         // The signature format is a compact form of:
1309         //   {bytes32 r}{bytes32 s}{uint8 v}
1310         // Compact means, uint8 is not padded to 32 bytes.
1311         assembly {
1312             r := mload(add(sig, 32))
1313             s := mload(add(sig, 64))
1314 
1315             // Here we are loading the last 32 bytes. We exploit the fact that
1316             // 'mload' will pad with zeroes if we overread.
1317             // There is no 'mload8' to do this, but that would be nicer.
1318             v := byte(0, mload(add(sig, 96)))
1319 
1320             // Alternative solution:
1321             // 'byte' is not working due to the Solidity parser, so lets
1322             // use the second best option, 'and'
1323             // v := and(mload(add(sig, 65)), 255)
1324         }
1325 
1326         // albeit non-transactional signatures are not specified by the YP, one would expect it
1327         // to match the YP range of [27, 28]
1328         //
1329         // geth uses [0, 1] and some clients have followed. This might change, see:
1330         //  https://github.com/ethereum/go-ethereum/issues/2053
1331         if (v < 27)
1332           v += 27;
1333 
1334         if (v != 27 && v != 28)
1335             return (false, 0);
1336 
1337         return safer_ecrecover(hash, v, r, s);
1338     }
1339 
1340     function safeMemoryCleaner() internal pure {
1341         assembly {
1342             let fmem := mload(0x40)
1343             codecopy(fmem, codesize, sub(msize, fmem))
1344         }
1345     }
1346 
1347 }
1348 // </ORACLIZE_API>
1349 
1350 
1351 pragma solidity ^0.4.20;
1352 
1353 /// @title EtherHiLo
1354 /// @dev the contract than handles the EtherHiLo app
1355 contract EtherHiLo is usingOraclize, Ownable {
1356 
1357     uint8 constant NUM_DICE_SIDES = 13;
1358     uint8 constant FAILED_ROLE = 69;
1359 
1360     // settings
1361     uint public rngCallbackGas = 500000;
1362     uint public minBet = 100 finney;
1363     uint public maxBetThresholdPct = 75;
1364     bool public gameRunning = false;
1365 
1366     // state
1367     uint public balanceInPlay;
1368 
1369     mapping(address => Game) private gamesInProgress;
1370     mapping(bytes32 => address) private rollIdToGameAddress;
1371     mapping(bytes32 => uint) private failedRolls;
1372 
1373     event GameFinished(address indexed player, uint indexed playerGameNumber, uint bet, uint8 firstRoll, uint8 finalRoll, uint winnings, uint payout);
1374     event GameError(address indexed player, uint indexed playerGameNumber, bytes32 rollId);
1375 
1376     enum BetDirection {
1377         None,
1378         Low,
1379         High
1380     }
1381 
1382     enum GameState {
1383         None,
1384         WaitingForFirstCard,
1385         WaitingForDirection,
1386         WaitingForFinalCard,
1387         Finished
1388     }
1389 
1390     // the game object
1391     struct Game {
1392         address player;
1393         GameState state;
1394         uint id;
1395         BetDirection direction;
1396         uint bet;
1397         uint8 firstRoll;
1398         uint8 finalRoll;
1399         uint winnings;
1400     }
1401 
1402     // the constructor
1403     function EtherHiLo() public {
1404     }
1405 
1406     /// Default function
1407     function() external payable {
1408 
1409     }
1410 
1411 
1412     /// =======================
1413     /// EXTERNAL GAME RELATED FUNCTIONS
1414 
1415     // begins a game
1416     function beginGame() public payable {
1417         address player = msg.sender;
1418         uint bet = msg.value;
1419 
1420         require(player != address(0));
1421         require(gamesInProgress[player].state == GameState.None
1422                 || gamesInProgress[player].state == GameState.Finished,
1423                 "Invalid game state");
1424         require(gameRunning, "Game is not currently running");
1425         require(bet >= minBet && bet <= getMaxBet(), "Invalid bet");
1426 
1427         Game memory game = Game({
1428                 id:         uint(keccak256(block.number, player, bet)),
1429                 player:     player,
1430                 state:      GameState.WaitingForFirstCard,
1431                 bet:        bet,
1432                 firstRoll:  0,
1433                 finalRoll:  0,
1434                 winnings:   0,
1435                 direction:  BetDirection.None
1436             });
1437 
1438         balanceInPlay = SafeMath.add(balanceInPlay, game.bet);
1439         gamesInProgress[player] = game;
1440 
1441         require(rollDie(player), "Dice roll failed");
1442     }
1443 
1444     // finishes a game that is in progress
1445     function finishGame(BetDirection direction) public {
1446         address player = msg.sender;
1447 
1448         require(player != address(0));
1449         require(gamesInProgress[player].state == GameState.WaitingForDirection,
1450             "Invalid game state");
1451 
1452         Game storage game = gamesInProgress[player];
1453         game.direction = direction;
1454         game.state = GameState.WaitingForFinalCard;
1455         gamesInProgress[player] = game;
1456 
1457         require(rollDie(player), "Dice roll failed");
1458     }
1459 
1460     // returns current game state
1461     function getGameState(address player) public view returns
1462             (GameState, uint, BetDirection, uint, uint8, uint8, uint) {
1463         return (
1464             gamesInProgress[player].state,
1465             gamesInProgress[player].id,
1466             gamesInProgress[player].direction,
1467             gamesInProgress[player].bet,
1468             gamesInProgress[player].firstRoll,
1469             gamesInProgress[player].finalRoll,
1470             gamesInProgress[player].winnings
1471         );
1472     }
1473 
1474     // Returns the minimum bet
1475     function getMinBet() public view returns (uint) {
1476         return minBet;
1477     }
1478 
1479     // Returns the maximum bet
1480     function getMaxBet() public view returns (uint) {
1481         return SafeMath.div(SafeMath.div(SafeMath.mul(SafeMath.sub(this.balance, balanceInPlay), maxBetThresholdPct), 100), 12);
1482     }
1483 
1484     // calculates winnings for the given bet and percent
1485     function calculateWinnings(uint bet, uint percent) public pure returns (uint) {
1486         return SafeMath.div(SafeMath.mul(bet, percent), 100);
1487     }
1488 
1489     // Returns the win percent when going low on the given number
1490     function getLowWinPercent(uint number) public pure returns (uint) {
1491         require(number >= 2 && number <= NUM_DICE_SIDES, "Invalid number");
1492         if (number == 2) {
1493             return 1200;
1494         } else if (number == 3) {
1495             return 500;
1496         } else if (number == 4) {
1497             return 300;
1498         } else if (number == 5) {
1499             return 300;
1500         } else if (number == 6) {
1501             return 200;
1502         } else if (number == 7) {
1503             return 180;
1504         } else if (number == 8) {
1505             return 150;
1506         } else if (number == 9) {
1507             return 140;
1508         } else if (number == 10) {
1509             return 130;
1510         } else if (number == 11) {
1511             return 120;
1512         } else if (number == 12) {
1513             return 110;
1514         } else if (number == 13) {
1515             return 100;
1516         }
1517     }
1518 
1519     // Returns the win percent when going high on the given number
1520     function getHighWinPercent(uint number) public pure returns (uint) {
1521         require(number >= 1 && number < NUM_DICE_SIDES, "Invalid number");
1522         if (number == 1) {
1523             return 100;
1524         } else if (number == 2) {
1525             return 110;
1526         } else if (number == 3) {
1527             return 120;
1528         } else if (number == 4) {
1529             return 130;
1530         } else if (number == 5) {
1531             return 140;
1532         } else if (number == 6) {
1533             return 150;
1534         } else if (number == 7) {
1535             return 180;
1536         } else if (number == 8) {
1537             return 200;
1538         } else if (number == 9) {
1539             return 300;
1540         } else if (number == 10) {
1541             return 300;
1542         } else if (number == 11) {
1543             return 500;
1544         } else if (number == 12) {
1545             return 1200;
1546         }
1547     }
1548 
1549 
1550     /// =======================
1551     /// INTERNAL GAME RELATED FUNCTIONS
1552 
1553     // process a successful roll
1554     function processDiceRoll(address player, uint8 roll) private {
1555 
1556         Game storage game = gamesInProgress[player];
1557 
1558         if (game.firstRoll == 0) {
1559 
1560             game.firstRoll = roll;
1561             game.state = GameState.WaitingForDirection;
1562             gamesInProgress[player] = game;
1563 
1564             return;
1565         }
1566 
1567         require(gamesInProgress[player].state == GameState.WaitingForFinalCard,
1568             "Invalid game state");
1569 
1570         uint8 finalRoll = roll;
1571         uint winnings = 0;
1572 
1573         if (game.direction == BetDirection.High && finalRoll > game.firstRoll) {
1574             winnings = calculateWinnings(game.bet, getHighWinPercent(game.firstRoll));
1575         } else if (game.direction == BetDirection.Low && finalRoll < game.firstRoll) {
1576             winnings = calculateWinnings(game.bet, getLowWinPercent(game.firstRoll));
1577         }
1578 
1579         // this should never happen according to the odds,
1580         // and the fact that we don't allow people to bet
1581         // so large that they can take the whole pot in one
1582         // fell swoop - however, a number of people could
1583         // theoretically all win simultaneously and cause
1584         // this scenario.  This will try to at a minimum
1585         // send them back what they bet and then since it
1586         // is recorded on the blockchain we can verify that
1587         // the winnings sent don't match what they should be
1588         // and we can manually send the rest to the player.
1589         uint transferAmount = winnings;
1590         if (transferAmount > this.balance) {
1591             if (game.bet < this.balance) {
1592                 transferAmount = game.bet;
1593             } else {
1594                 transferAmount = SafeMath.div(SafeMath.mul(this.balance, 90), 100);
1595             }
1596         }
1597 
1598         balanceInPlay = SafeMath.add(balanceInPlay, game.bet);
1599 
1600         game.finalRoll = finalRoll;
1601         game.winnings = winnings;
1602         game.state = GameState.Finished;
1603         gamesInProgress[player] = game;
1604 
1605         if (transferAmount > 0) {
1606             game.player.transfer(transferAmount);
1607         }
1608 
1609         GameFinished(player, game.id, game.bet, game.firstRoll, finalRoll, winnings, transferAmount);
1610     }
1611 
1612     // roll the dice for a player
1613     function rollDie(address player) private returns (bool) {
1614         bytes32 rollId = oraclize_newRandomDSQuery(0, 7, rngCallbackGas);
1615         if (failedRolls[rollId] == FAILED_ROLE) {
1616             delete failedRolls[rollId];
1617             return false;
1618         }
1619         rollIdToGameAddress[rollId] = player;
1620         return true;
1621     }
1622 
1623 
1624     /// =======================
1625     /// ORACLIZE RELATED FUNCTIONS
1626 
1627     // the callback function is called by Oraclize when the result is ready
1628     // the oraclize_randomDS_proofVerify modifier prevents an invalid proof to execute this function code:
1629     // the proof validity is fully verified on-chain
1630     function __callback(bytes32 rollId, string _result, bytes _proof) public {
1631         require(msg.sender == oraclize_cbAddress(), "Only Oraclize can call this method");
1632 
1633         address player = rollIdToGameAddress[rollId];
1634 
1635         // avoid reorgs
1636         if (player == address(0)) {
1637             failedRolls[rollId] = FAILED_ROLE;
1638             return;
1639         }
1640 
1641         if (oraclize_randomDS_proofVerify__returnCode(rollId, _result, _proof) != 0) {
1642 
1643             Game storage game = gamesInProgress[player];
1644             if (game.bet > 0) {
1645                 game.player.transfer(game.bet);
1646             }
1647 
1648             delete gamesInProgress[player];
1649             delete rollIdToGameAddress[rollId];
1650             delete failedRolls[rollId];
1651             GameError(player, game.id, rollId);
1652 
1653         } else {
1654             uint8 randomNumber = uint8((uint(keccak256(_result)) % NUM_DICE_SIDES) + 1);
1655             processDiceRoll(player, randomNumber);
1656             delete rollIdToGameAddress[rollId];
1657 
1658         }
1659 
1660     }
1661 
1662 
1663     /// OWNER / MANAGEMENT RELATED FUNCTIONS
1664 
1665     // fail safe for balance transfer
1666     function transferBalance(address to, uint amount) public onlyOwner {
1667         to.transfer(amount);
1668     }
1669 
1670     // cleans up a player abandoned game, but only if it's
1671     // greater than 24 hours old.
1672     function cleanupAbandonedGame(address player) public onlyOwner {
1673         require(player != address(0));
1674 
1675         Game storage game = gamesInProgress[player];
1676         require(game.player != address(0));
1677 
1678         game.player.transfer(game.bet);
1679         delete gamesInProgress[game.player];
1680     }
1681 
1682     // set RNG callback gas
1683     function setRNGCallbackGasConfig(uint gas, uint price) public onlyOwner {
1684         rngCallbackGas = gas;
1685         oraclize_setProof(proofType_Ledger);
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