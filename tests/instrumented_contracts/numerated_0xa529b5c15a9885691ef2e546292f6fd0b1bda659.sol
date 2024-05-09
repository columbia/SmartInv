1 pragma solidity ^0.4.25;
2 
3 pragma solidity ^0.4.25;
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, reverts on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     uint256 c = a * b;
23     require(c / a == b);
24 
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b > 0); // Solidity only automatically asserts when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36     return c;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     require(b <= a);
44     uint256 c = a - b;
45 
46     return c;
47   }
48 
49   /**
50   * @dev Adds two numbers, reverts on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     require(c >= a);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61   * reverts when dividing by zero.
62   */
63   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b != 0);
65     return a % b;
66   }
67 }
68 pragma solidity ^0.4.24;
69 
70 contract Owned {
71     address public owner;
72     address public newOwner;
73     modifier onlyOwner {
74         require(msg.sender == owner);
75         _;
76     }
77     function transferOwnership(address _newOwner) public onlyOwner {
78         newOwner = _newOwner;
79     }
80     function acceptOwnership() public {
81         require(msg.sender == newOwner);
82         owner = newOwner;
83     }
84 }
85 pragma solidity ^0.4.25;
86 
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  */
91  
92 interface IERC20 {
93   function totalSupply() external view returns (uint256);
94 
95   function balanceOf(address who) external view returns (uint256);
96 
97   function allowance(address owner, address spender)
98     external view returns (uint256);
99 
100   function transfer(address to, uint256 value) external returns (bool);
101 
102   function approve(address spender, uint256 value)
103     external returns (bool);
104 
105   function transferFrom(address from, address to, uint256 value)
106     external returns (bool);
107 
108   event Transfer(
109     address indexed from,
110     address indexed to,
111     uint256 value
112   );
113 
114   event Approval(
115     address indexed owner,
116     address indexed spender,
117     uint256 value
118   );
119 }
120 // <ORACLIZE_API>
121 // Release targetted at solc 0.4.25 to silence compiler warning/error messages, compatible down to 0.4.22
122 /*
123 Copyright (c) 2015-2016 Oraclize SRL
124 Copyright (c) 2016 Oraclize LTD
125 
126 
127 
128 Permission is hereby granted, free of charge, to any person obtaining a copy
129 of this software and associated documentation files (the "Software"), to deal
130 in the Software without restriction, including without limitation the rights
131 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
132 copies of the Software, and to permit persons to whom the Software is
133 furnished to do so, subject to the following conditions:
134 
135 
136 
137 The above copyright notice and this permission notice shall be included in
138 all copies or substantial portions of the Software.
139 
140 
141 
142 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
143 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
144 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
145 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
146 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
147 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
148 THE SOFTWARE.
149 */
150 
151 // This api is currently targeted at 0.4.22 to 0.4.25 (stable builds), please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
152 
153 pragma solidity >=0.4.22;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
154 
155 contract OraclizeI {
156     address public cbAddress;
157     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
158     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
159     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
160     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
161     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
162     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
163     function getPrice(string _datasource) public returns (uint _dsprice);
164     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
165     function setProofType(byte _proofType) external;
166     function setCustomGasPrice(uint _gasPrice) external;
167     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
168 }
169 
170 contract OraclizeAddrResolverI {
171     function getAddress() public returns (address _addr);
172 }
173 
174 /*
175 Begin solidity-cborutils
176 
177 https://github.com/smartcontractkit/solidity-cborutils
178 
179 MIT License
180 
181 Copyright (c) 2018 SmartContract ChainLink, Ltd.
182 
183 Permission is hereby granted, free of charge, to any person obtaining a copy
184 of this software and associated documentation files (the "Software"), to deal
185 in the Software without restriction, including without limitation the rights
186 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
187 copies of the Software, and to permit persons to whom the Software is
188 furnished to do so, subject to the following conditions:
189 
190 The above copyright notice and this permission notice shall be included in all
191 copies or substantial portions of the Software.
192 
193 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
194 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
195 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
196 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
197 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
198 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
199 SOFTWARE.
200  */
201 
202 library Buffer {
203     struct buffer {
204         bytes buf;
205         uint capacity;
206     }
207 
208     function init(buffer memory buf, uint _capacity) internal pure {
209         uint capacity = _capacity;
210         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
211         // Allocate space for the buffer data
212         buf.capacity = capacity;
213         assembly {
214             let ptr := mload(0x40)
215             mstore(buf, ptr)
216             mstore(ptr, 0)
217             mstore(0x40, add(ptr, capacity))
218         }
219     }
220 
221     function resize(buffer memory buf, uint capacity) private pure {
222         bytes memory oldbuf = buf.buf;
223         init(buf, capacity);
224         append(buf, oldbuf);
225     }
226 
227     function max(uint a, uint b) private pure returns(uint) {
228         if(a > b) {
229             return a;
230         }
231         return b;
232     }
233 
234     /**
235      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
236      *      would exceed the capacity of the buffer.
237      * @param buf The buffer to append to.
238      * @param data The data to append.
239      * @return The original buffer.
240      */
241     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
242         if(data.length + buf.buf.length > buf.capacity) {
243             resize(buf, max(buf.capacity, data.length) * 2);
244         }
245 
246         uint dest;
247         uint src;
248         uint len = data.length;
249         assembly {
250             // Memory address of the buffer data
251             let bufptr := mload(buf)
252             // Length of existing buffer data
253             let buflen := mload(bufptr)
254             // Start address = buffer address + buffer length + sizeof(buffer length)
255             dest := add(add(bufptr, buflen), 32)
256             // Update buffer length
257             mstore(bufptr, add(buflen, mload(data)))
258             src := add(data, 32)
259         }
260 
261         // Copy word-length chunks while possible
262         for(; len >= 32; len -= 32) {
263             assembly {
264                 mstore(dest, mload(src))
265             }
266             dest += 32;
267             src += 32;
268         }
269 
270         // Copy remaining bytes
271         uint mask = 256 ** (32 - len) - 1;
272         assembly {
273             let srcpart := and(mload(src), not(mask))
274             let destpart := and(mload(dest), mask)
275             mstore(dest, or(destpart, srcpart))
276         }
277 
278         return buf;
279     }
280 
281     /**
282      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
283      * exceed the capacity of the buffer.
284      * @param buf The buffer to append to.
285      * @param data The data to append.
286      * @return The original buffer.
287      */
288     function append(buffer memory buf, uint8 data) internal pure {
289         if(buf.buf.length + 1 > buf.capacity) {
290             resize(buf, buf.capacity * 2);
291         }
292 
293         assembly {
294             // Memory address of the buffer data
295             let bufptr := mload(buf)
296             // Length of existing buffer data
297             let buflen := mload(bufptr)
298             // Address = buffer address + buffer length + sizeof(buffer length)
299             let dest := add(add(bufptr, buflen), 32)
300             mstore8(dest, data)
301             // Update buffer length
302             mstore(bufptr, add(buflen, 1))
303         }
304     }
305 
306     /**
307      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
308      * exceed the capacity of the buffer.
309      * @param buf The buffer to append to.
310      * @param data The data to append.
311      * @return The original buffer.
312      */
313     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
314         if(len + buf.buf.length > buf.capacity) {
315             resize(buf, max(buf.capacity, len) * 2);
316         }
317 
318         uint mask = 256 ** len - 1;
319         assembly {
320             // Memory address of the buffer data
321             let bufptr := mload(buf)
322             // Length of existing buffer data
323             let buflen := mload(bufptr)
324             // Address = buffer address + buffer length + sizeof(buffer length) + len
325             let dest := add(add(bufptr, buflen), len)
326             mstore(dest, or(and(mload(dest), not(mask)), data))
327             // Update buffer length
328             mstore(bufptr, add(buflen, len))
329         }
330         return buf;
331     }
332 }
333 
334 library CBOR {
335     using Buffer for Buffer.buffer;
336 
337     uint8 private constant MAJOR_TYPE_INT = 0;
338     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
339     uint8 private constant MAJOR_TYPE_BYTES = 2;
340     uint8 private constant MAJOR_TYPE_STRING = 3;
341     uint8 private constant MAJOR_TYPE_ARRAY = 4;
342     uint8 private constant MAJOR_TYPE_MAP = 5;
343     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
344 
345     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
346         if(value <= 23) {
347             buf.append(uint8((major << 5) | value));
348         } else if(value <= 0xFF) {
349             buf.append(uint8((major << 5) | 24));
350             buf.appendInt(value, 1);
351         } else if(value <= 0xFFFF) {
352             buf.append(uint8((major << 5) | 25));
353             buf.appendInt(value, 2);
354         } else if(value <= 0xFFFFFFFF) {
355             buf.append(uint8((major << 5) | 26));
356             buf.appendInt(value, 4);
357         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
358             buf.append(uint8((major << 5) | 27));
359             buf.appendInt(value, 8);
360         }
361     }
362 
363     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
364         buf.append(uint8((major << 5) | 31));
365     }
366 
367     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
368         encodeType(buf, MAJOR_TYPE_INT, value);
369     }
370 
371     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
372         if(value >= 0) {
373             encodeType(buf, MAJOR_TYPE_INT, uint(value));
374         } else {
375             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
376         }
377     }
378 
379     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
380         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
381         buf.append(value);
382     }
383 
384     function encodeString(Buffer.buffer memory buf, string value) internal pure {
385         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
386         buf.append(bytes(value));
387     }
388 
389     function startArray(Buffer.buffer memory buf) internal pure {
390         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
391     }
392 
393     function startMap(Buffer.buffer memory buf) internal pure {
394         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
395     }
396 
397     function endSequence(Buffer.buffer memory buf) internal pure {
398         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
399     }
400 }
401 
402 /*
403 End solidity-cborutils
404  */
405 
406 contract usingOraclize {
407     uint constant day = 60*60*24;
408     uint constant week = 60*60*24*7;
409     uint constant month = 60*60*24*30;
410     byte constant proofType_NONE = 0x00;
411     byte constant proofType_TLSNotary = 0x10;
412     byte constant proofType_Ledger = 0x30;
413     byte constant proofType_Android = 0x40;
414     byte constant proofType_Native = 0xF0;
415     byte constant proofStorage_IPFS = 0x01;
416     uint8 constant networkID_auto = 0;
417     uint8 constant networkID_mainnet = 1;
418     uint8 constant networkID_testnet = 2;
419     uint8 constant networkID_morden = 2;
420     uint8 constant networkID_consensys = 161;
421 
422     OraclizeAddrResolverI OAR;
423 
424     OraclizeI oraclize;
425     modifier oraclizeAPI {
426         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
427             oraclize_setNetwork(networkID_auto);
428 
429         if(address(oraclize) != OAR.getAddress())
430             oraclize = OraclizeI(OAR.getAddress());
431 
432         _;
433     }
434     modifier coupon(string code){
435         oraclize = OraclizeI(OAR.getAddress());
436         _;
437     }
438 
439     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
440       return oraclize_setNetwork();
441       networkID; // silence the warning and remain backwards compatible
442     }
443     function oraclize_setNetwork() internal returns(bool){
444         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
445             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
446             oraclize_setNetworkName("eth_mainnet");
447             return true;
448         }
449         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
450             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
451             oraclize_setNetworkName("eth_ropsten3");
452             return true;
453         }
454         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
455             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
456             oraclize_setNetworkName("eth_kovan");
457             return true;
458         }
459         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
460             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
461             oraclize_setNetworkName("eth_rinkeby");
462             return true;
463         }
464         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
465             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
466             return true;
467         }
468         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
469             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
470             return true;
471         }
472         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
473             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
474             return true;
475         }
476         return false;
477     }
478 
479     function __callback(bytes32 myid, string result) public {
480         __callback(myid, result, new bytes(0));
481     }
482     function __callback(bytes32 myid, string result, bytes proof) public {
483       return;
484       // Following should never be reached with a preceding return, however
485       // this is just a placeholder function, ideally meant to be defined in
486       // child contract when proofs are used
487       myid; result; proof; // Silence compiler warnings
488       oraclize = OraclizeI(0); // Additional compiler silence about making function pure/view. 
489     }
490 
491     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
492         return oraclize.getPrice(datasource);
493     }
494 
495     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
496         return oraclize.getPrice(datasource, gaslimit);
497     }
498 
499     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
500         uint price = oraclize.getPrice(datasource);
501         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
502         return oraclize.query.value(price)(0, datasource, arg);
503     }
504     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
505         uint price = oraclize.getPrice(datasource);
506         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
507         return oraclize.query.value(price)(timestamp, datasource, arg);
508     }
509     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
510         uint price = oraclize.getPrice(datasource, gaslimit);
511         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
512         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
513     }
514     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
515         uint price = oraclize.getPrice(datasource, gaslimit);
516         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
517         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
518     }
519     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
520         uint price = oraclize.getPrice(datasource);
521         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
522         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
523     }
524     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
525         uint price = oraclize.getPrice(datasource);
526         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
527         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
528     }
529     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
530         uint price = oraclize.getPrice(datasource, gaslimit);
531         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
532         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
533     }
534     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
535         uint price = oraclize.getPrice(datasource, gaslimit);
536         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
537         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
538     }
539     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
540         uint price = oraclize.getPrice(datasource);
541         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
542         bytes memory args = stra2cbor(argN);
543         return oraclize.queryN.value(price)(0, datasource, args);
544     }
545     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
546         uint price = oraclize.getPrice(datasource);
547         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
548         bytes memory args = stra2cbor(argN);
549         return oraclize.queryN.value(price)(timestamp, datasource, args);
550     }
551     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
552         uint price = oraclize.getPrice(datasource, gaslimit);
553         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
554         bytes memory args = stra2cbor(argN);
555         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
556     }
557     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
558         uint price = oraclize.getPrice(datasource, gaslimit);
559         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
560         bytes memory args = stra2cbor(argN);
561         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
562     }
563     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
564         string[] memory dynargs = new string[](1);
565         dynargs[0] = args[0];
566         return oraclize_query(datasource, dynargs);
567     }
568     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
569         string[] memory dynargs = new string[](1);
570         dynargs[0] = args[0];
571         return oraclize_query(timestamp, datasource, dynargs);
572     }
573     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
574         string[] memory dynargs = new string[](1);
575         dynargs[0] = args[0];
576         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
577     }
578     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
579         string[] memory dynargs = new string[](1);
580         dynargs[0] = args[0];
581         return oraclize_query(datasource, dynargs, gaslimit);
582     }
583 
584     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
585         string[] memory dynargs = new string[](2);
586         dynargs[0] = args[0];
587         dynargs[1] = args[1];
588         return oraclize_query(datasource, dynargs);
589     }
590     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
591         string[] memory dynargs = new string[](2);
592         dynargs[0] = args[0];
593         dynargs[1] = args[1];
594         return oraclize_query(timestamp, datasource, dynargs);
595     }
596     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
597         string[] memory dynargs = new string[](2);
598         dynargs[0] = args[0];
599         dynargs[1] = args[1];
600         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
601     }
602     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
603         string[] memory dynargs = new string[](2);
604         dynargs[0] = args[0];
605         dynargs[1] = args[1];
606         return oraclize_query(datasource, dynargs, gaslimit);
607     }
608     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
609         string[] memory dynargs = new string[](3);
610         dynargs[0] = args[0];
611         dynargs[1] = args[1];
612         dynargs[2] = args[2];
613         return oraclize_query(datasource, dynargs);
614     }
615     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
616         string[] memory dynargs = new string[](3);
617         dynargs[0] = args[0];
618         dynargs[1] = args[1];
619         dynargs[2] = args[2];
620         return oraclize_query(timestamp, datasource, dynargs);
621     }
622     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
623         string[] memory dynargs = new string[](3);
624         dynargs[0] = args[0];
625         dynargs[1] = args[1];
626         dynargs[2] = args[2];
627         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
628     }
629     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
630         string[] memory dynargs = new string[](3);
631         dynargs[0] = args[0];
632         dynargs[1] = args[1];
633         dynargs[2] = args[2];
634         return oraclize_query(datasource, dynargs, gaslimit);
635     }
636 
637     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
638         string[] memory dynargs = new string[](4);
639         dynargs[0] = args[0];
640         dynargs[1] = args[1];
641         dynargs[2] = args[2];
642         dynargs[3] = args[3];
643         return oraclize_query(datasource, dynargs);
644     }
645     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
646         string[] memory dynargs = new string[](4);
647         dynargs[0] = args[0];
648         dynargs[1] = args[1];
649         dynargs[2] = args[2];
650         dynargs[3] = args[3];
651         return oraclize_query(timestamp, datasource, dynargs);
652     }
653     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
654         string[] memory dynargs = new string[](4);
655         dynargs[0] = args[0];
656         dynargs[1] = args[1];
657         dynargs[2] = args[2];
658         dynargs[3] = args[3];
659         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
660     }
661     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
662         string[] memory dynargs = new string[](4);
663         dynargs[0] = args[0];
664         dynargs[1] = args[1];
665         dynargs[2] = args[2];
666         dynargs[3] = args[3];
667         return oraclize_query(datasource, dynargs, gaslimit);
668     }
669     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
670         string[] memory dynargs = new string[](5);
671         dynargs[0] = args[0];
672         dynargs[1] = args[1];
673         dynargs[2] = args[2];
674         dynargs[3] = args[3];
675         dynargs[4] = args[4];
676         return oraclize_query(datasource, dynargs);
677     }
678     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
679         string[] memory dynargs = new string[](5);
680         dynargs[0] = args[0];
681         dynargs[1] = args[1];
682         dynargs[2] = args[2];
683         dynargs[3] = args[3];
684         dynargs[4] = args[4];
685         return oraclize_query(timestamp, datasource, dynargs);
686     }
687     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
688         string[] memory dynargs = new string[](5);
689         dynargs[0] = args[0];
690         dynargs[1] = args[1];
691         dynargs[2] = args[2];
692         dynargs[3] = args[3];
693         dynargs[4] = args[4];
694         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
695     }
696     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
697         string[] memory dynargs = new string[](5);
698         dynargs[0] = args[0];
699         dynargs[1] = args[1];
700         dynargs[2] = args[2];
701         dynargs[3] = args[3];
702         dynargs[4] = args[4];
703         return oraclize_query(datasource, dynargs, gaslimit);
704     }
705     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
706         uint price = oraclize.getPrice(datasource);
707         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
708         bytes memory args = ba2cbor(argN);
709         return oraclize.queryN.value(price)(0, datasource, args);
710     }
711     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
712         uint price = oraclize.getPrice(datasource);
713         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
714         bytes memory args = ba2cbor(argN);
715         return oraclize.queryN.value(price)(timestamp, datasource, args);
716     }
717     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
718         uint price = oraclize.getPrice(datasource, gaslimit);
719         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
720         bytes memory args = ba2cbor(argN);
721         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
722     }
723     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
724         uint price = oraclize.getPrice(datasource, gaslimit);
725         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
726         bytes memory args = ba2cbor(argN);
727         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
728     }
729     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
730         bytes[] memory dynargs = new bytes[](1);
731         dynargs[0] = args[0];
732         return oraclize_query(datasource, dynargs);
733     }
734     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
735         bytes[] memory dynargs = new bytes[](1);
736         dynargs[0] = args[0];
737         return oraclize_query(timestamp, datasource, dynargs);
738     }
739     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
740         bytes[] memory dynargs = new bytes[](1);
741         dynargs[0] = args[0];
742         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
743     }
744     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
745         bytes[] memory dynargs = new bytes[](1);
746         dynargs[0] = args[0];
747         return oraclize_query(datasource, dynargs, gaslimit);
748     }
749 
750     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
751         bytes[] memory dynargs = new bytes[](2);
752         dynargs[0] = args[0];
753         dynargs[1] = args[1];
754         return oraclize_query(datasource, dynargs);
755     }
756     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
757         bytes[] memory dynargs = new bytes[](2);
758         dynargs[0] = args[0];
759         dynargs[1] = args[1];
760         return oraclize_query(timestamp, datasource, dynargs);
761     }
762     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
763         bytes[] memory dynargs = new bytes[](2);
764         dynargs[0] = args[0];
765         dynargs[1] = args[1];
766         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
767     }
768     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
769         bytes[] memory dynargs = new bytes[](2);
770         dynargs[0] = args[0];
771         dynargs[1] = args[1];
772         return oraclize_query(datasource, dynargs, gaslimit);
773     }
774     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
775         bytes[] memory dynargs = new bytes[](3);
776         dynargs[0] = args[0];
777         dynargs[1] = args[1];
778         dynargs[2] = args[2];
779         return oraclize_query(datasource, dynargs);
780     }
781     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
782         bytes[] memory dynargs = new bytes[](3);
783         dynargs[0] = args[0];
784         dynargs[1] = args[1];
785         dynargs[2] = args[2];
786         return oraclize_query(timestamp, datasource, dynargs);
787     }
788     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
789         bytes[] memory dynargs = new bytes[](3);
790         dynargs[0] = args[0];
791         dynargs[1] = args[1];
792         dynargs[2] = args[2];
793         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
794     }
795     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
796         bytes[] memory dynargs = new bytes[](3);
797         dynargs[0] = args[0];
798         dynargs[1] = args[1];
799         dynargs[2] = args[2];
800         return oraclize_query(datasource, dynargs, gaslimit);
801     }
802 
803     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
804         bytes[] memory dynargs = new bytes[](4);
805         dynargs[0] = args[0];
806         dynargs[1] = args[1];
807         dynargs[2] = args[2];
808         dynargs[3] = args[3];
809         return oraclize_query(datasource, dynargs);
810     }
811     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
812         bytes[] memory dynargs = new bytes[](4);
813         dynargs[0] = args[0];
814         dynargs[1] = args[1];
815         dynargs[2] = args[2];
816         dynargs[3] = args[3];
817         return oraclize_query(timestamp, datasource, dynargs);
818     }
819     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
820         bytes[] memory dynargs = new bytes[](4);
821         dynargs[0] = args[0];
822         dynargs[1] = args[1];
823         dynargs[2] = args[2];
824         dynargs[3] = args[3];
825         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
826     }
827     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
828         bytes[] memory dynargs = new bytes[](4);
829         dynargs[0] = args[0];
830         dynargs[1] = args[1];
831         dynargs[2] = args[2];
832         dynargs[3] = args[3];
833         return oraclize_query(datasource, dynargs, gaslimit);
834     }
835     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
836         bytes[] memory dynargs = new bytes[](5);
837         dynargs[0] = args[0];
838         dynargs[1] = args[1];
839         dynargs[2] = args[2];
840         dynargs[3] = args[3];
841         dynargs[4] = args[4];
842         return oraclize_query(datasource, dynargs);
843     }
844     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
845         bytes[] memory dynargs = new bytes[](5);
846         dynargs[0] = args[0];
847         dynargs[1] = args[1];
848         dynargs[2] = args[2];
849         dynargs[3] = args[3];
850         dynargs[4] = args[4];
851         return oraclize_query(timestamp, datasource, dynargs);
852     }
853     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
854         bytes[] memory dynargs = new bytes[](5);
855         dynargs[0] = args[0];
856         dynargs[1] = args[1];
857         dynargs[2] = args[2];
858         dynargs[3] = args[3];
859         dynargs[4] = args[4];
860         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
861     }
862     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
863         bytes[] memory dynargs = new bytes[](5);
864         dynargs[0] = args[0];
865         dynargs[1] = args[1];
866         dynargs[2] = args[2];
867         dynargs[3] = args[3];
868         dynargs[4] = args[4];
869         return oraclize_query(datasource, dynargs, gaslimit);
870     }
871 
872     function oraclize_cbAddress() oraclizeAPI internal returns (address){
873         return oraclize.cbAddress();
874     }
875     function oraclize_setProof(byte proofP) oraclizeAPI internal {
876         return oraclize.setProofType(proofP);
877     }
878     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
879         return oraclize.setCustomGasPrice(gasPrice);
880     }
881 
882     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
883         return oraclize.randomDS_getSessionPubKeyHash();
884     }
885 
886     function getCodeSize(address _addr) view internal returns(uint _size) {
887         assembly {
888             _size := extcodesize(_addr)
889         }
890     }
891 
892     function parseAddr(string _a) internal pure returns (address){
893         bytes memory tmp = bytes(_a);
894         uint160 iaddr = 0;
895         uint160 b1;
896         uint160 b2;
897         for (uint i=2; i<2+2*20; i+=2){
898             iaddr *= 256;
899             b1 = uint160(tmp[i]);
900             b2 = uint160(tmp[i+1]);
901             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
902             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
903             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
904             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
905             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
906             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
907             iaddr += (b1*16+b2);
908         }
909         return address(iaddr);
910     }
911 
912     function strCompare(string _a, string _b) internal pure returns (int) {
913         bytes memory a = bytes(_a);
914         bytes memory b = bytes(_b);
915         uint minLength = a.length;
916         if (b.length < minLength) minLength = b.length;
917         for (uint i = 0; i < minLength; i ++)
918             if (a[i] < b[i])
919                 return -1;
920             else if (a[i] > b[i])
921                 return 1;
922         if (a.length < b.length)
923             return -1;
924         else if (a.length > b.length)
925             return 1;
926         else
927             return 0;
928     }
929 
930     function indexOf(string _haystack, string _needle) internal pure returns (int) {
931         bytes memory h = bytes(_haystack);
932         bytes memory n = bytes(_needle);
933         if(h.length < 1 || n.length < 1 || (n.length > h.length))
934             return -1;
935         else if(h.length > (2**128 -1))
936             return -1;
937         else
938         {
939             uint subindex = 0;
940             for (uint i = 0; i < h.length; i ++)
941             {
942                 if (h[i] == n[0])
943                 {
944                     subindex = 1;
945                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
946                     {
947                         subindex++;
948                     }
949                     if(subindex == n.length)
950                         return int(i);
951                 }
952             }
953             return -1;
954         }
955     }
956 
957     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
958         bytes memory _ba = bytes(_a);
959         bytes memory _bb = bytes(_b);
960         bytes memory _bc = bytes(_c);
961         bytes memory _bd = bytes(_d);
962         bytes memory _be = bytes(_e);
963         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
964         bytes memory babcde = bytes(abcde);
965         uint k = 0;
966         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
967         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
968         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
969         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
970         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
971         return string(babcde);
972     }
973 
974     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
975         return strConcat(_a, _b, _c, _d, "");
976     }
977 
978     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
979         return strConcat(_a, _b, _c, "", "");
980     }
981 
982     function strConcat(string _a, string _b) internal pure returns (string) {
983         return strConcat(_a, _b, "", "", "");
984     }
985 
986     // parseInt
987     function parseInt(string _a) internal pure returns (uint) {
988         return parseInt(_a, 0);
989     }
990 
991     // parseInt(parseFloat*10^_b)
992     function parseInt(string _a, uint _b) internal pure returns (uint) {
993         bytes memory bresult = bytes(_a);
994         uint mint = 0;
995         bool decimals = false;
996         for (uint i=0; i<bresult.length; i++){
997             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
998                 if (decimals){
999                    if (_b == 0) break;
1000                     else _b--;
1001                 }
1002                 mint *= 10;
1003                 mint += uint(bresult[i]) - 48;
1004             } else if (bresult[i] == 46) decimals = true;
1005         }
1006         if (_b > 0) mint *= 10**_b;
1007         return mint;
1008     }
1009 
1010     function uint2str(uint i) internal pure returns (string){
1011         if (i == 0) return "0";
1012         uint j = i;
1013         uint len;
1014         while (j != 0){
1015             len++;
1016             j /= 10;
1017         }
1018         bytes memory bstr = new bytes(len);
1019         uint k = len - 1;
1020         while (i != 0){
1021             bstr[k--] = byte(48 + i % 10);
1022             i /= 10;
1023         }
1024         return string(bstr);
1025     }
1026 
1027     using CBOR for Buffer.buffer;
1028     function stra2cbor(string[] arr) internal pure returns (bytes) {
1029         safeMemoryCleaner();
1030         Buffer.buffer memory buf;
1031         Buffer.init(buf, 1024);
1032         buf.startArray();
1033         for (uint i = 0; i < arr.length; i++) {
1034             buf.encodeString(arr[i]);
1035         }
1036         buf.endSequence();
1037         return buf.buf;
1038     }
1039 
1040     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
1041         safeMemoryCleaner();
1042         Buffer.buffer memory buf;
1043         Buffer.init(buf, 1024);
1044         buf.startArray();
1045         for (uint i = 0; i < arr.length; i++) {
1046             buf.encodeBytes(arr[i]);
1047         }
1048         buf.endSequence();
1049         return buf.buf;
1050     }
1051 
1052     string oraclize_network_name;
1053     function oraclize_setNetworkName(string _network_name) internal {
1054         oraclize_network_name = _network_name;
1055     }
1056 
1057     function oraclize_getNetworkName() internal view returns (string) {
1058         return oraclize_network_name;
1059     }
1060 
1061     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1062         require((_nbytes > 0) && (_nbytes <= 32));
1063         // Convert from seconds to ledger timer ticks
1064         _delay *= 10;
1065         bytes memory nbytes = new bytes(1);
1066         nbytes[0] = byte(_nbytes);
1067         bytes memory unonce = new bytes(32);
1068         bytes memory sessionKeyHash = new bytes(32);
1069         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1070         assembly {
1071             mstore(unonce, 0x20)
1072             // the following variables can be relaxed
1073             // check relaxed random contract under ethereum-examples repo
1074             // for an idea on how to override and replace comit hash vars
1075             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1076             mstore(sessionKeyHash, 0x20)
1077             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1078         }
1079         bytes memory delay = new bytes(32);
1080         assembly {
1081             mstore(add(delay, 0x20), _delay)
1082         }
1083 
1084         bytes memory delay_bytes8 = new bytes(8);
1085         copyBytes(delay, 24, 8, delay_bytes8, 0);
1086 
1087         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1088         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1089 
1090         bytes memory delay_bytes8_left = new bytes(8);
1091 
1092         assembly {
1093             let x := mload(add(delay_bytes8, 0x20))
1094             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1095             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1096             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1097             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1098             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1099             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1100             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1101             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1102 
1103         }
1104 
1105         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1106         return queryId;
1107     }
1108 
1109     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1110         oraclize_randomDS_args[queryId] = commitment;
1111     }
1112 
1113     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1114     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1115 
1116     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1117         bool sigok;
1118         address signer;
1119 
1120         bytes32 sigr;
1121         bytes32 sigs;
1122 
1123         bytes memory sigr_ = new bytes(32);
1124         uint offset = 4+(uint(dersig[3]) - 0x20);
1125         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1126         bytes memory sigs_ = new bytes(32);
1127         offset += 32 + 2;
1128         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1129 
1130         assembly {
1131             sigr := mload(add(sigr_, 32))
1132             sigs := mload(add(sigs_, 32))
1133         }
1134 
1135 
1136         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1137         if (address(keccak256(pubkey)) == signer) return true;
1138         else {
1139             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1140             return (address(keccak256(pubkey)) == signer);
1141         }
1142     }
1143 
1144     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1145         bool sigok;
1146 
1147         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1148         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1149         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1150 
1151         bytes memory appkey1_pubkey = new bytes(64);
1152         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1153 
1154         bytes memory tosign2 = new bytes(1+65+32);
1155         tosign2[0] = byte(1); //role
1156         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1157         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1158         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1159         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1160 
1161         if (sigok == false) return false;
1162 
1163 
1164         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1165         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1166 
1167         bytes memory tosign3 = new bytes(1+65);
1168         tosign3[0] = 0xFE;
1169         copyBytes(proof, 3, 65, tosign3, 1);
1170 
1171         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1172         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1173 
1174         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1175 
1176         return sigok;
1177     }
1178 
1179     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1180         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1181         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1182 
1183         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1184         require(proofVerified);
1185 
1186         _;
1187     }
1188 
1189     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1190         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1191         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1192 
1193         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1194         if (proofVerified == false) return 2;
1195 
1196         return 0;
1197     }
1198 
1199     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1200         bool match_ = true;
1201 
1202         require(prefix.length == n_random_bytes);
1203 
1204         for (uint256 i=0; i< n_random_bytes; i++) {
1205             if (content[i] != prefix[i]) match_ = false;
1206         }
1207 
1208         return match_;
1209     }
1210 
1211     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1212 
1213         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1214         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1215         bytes memory keyhash = new bytes(32);
1216         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1217         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(context_name, queryId)))))) return false;
1218 
1219         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1220         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1221 
1222         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1223         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1224 
1225         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1226         // This is to verify that the computed args match with the ones specified in the query.
1227         bytes memory commitmentSlice1 = new bytes(8+1+32);
1228         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1229 
1230         bytes memory sessionPubkey = new bytes(64);
1231         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1232         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1233 
1234         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1235         if (oraclize_randomDS_args[queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))){ //unonce, nbytes and sessionKeyHash match
1236             delete oraclize_randomDS_args[queryId];
1237         } else return false;
1238 
1239 
1240         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1241         bytes memory tosign1 = new bytes(32+8+1+32);
1242         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1243         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1244 
1245         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1246         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1247             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1248         }
1249 
1250         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1251     }
1252 
1253     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1254     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1255         uint minLength = length + toOffset;
1256 
1257         // Buffer too small
1258         require(to.length >= minLength); // Should be a better way?
1259 
1260         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1261         uint i = 32 + fromOffset;
1262         uint j = 32 + toOffset;
1263 
1264         while (i < (32 + fromOffset + length)) {
1265             assembly {
1266                 let tmp := mload(add(from, i))
1267                 mstore(add(to, j), tmp)
1268             }
1269             i += 32;
1270             j += 32;
1271         }
1272 
1273         return to;
1274     }
1275 
1276     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1277     // Duplicate Solidity's ecrecover, but catching the CALL return value
1278     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1279         // We do our own memory management here. Solidity uses memory offset
1280         // 0x40 to store the current end of memory. We write past it (as
1281         // writes are memory extensions), but don't update the offset so
1282         // Solidity will reuse it. The memory used here is only needed for
1283         // this context.
1284 
1285         // FIXME: inline assembly can't access return values
1286         bool ret;
1287         address addr;
1288 
1289         assembly {
1290             let size := mload(0x40)
1291             mstore(size, hash)
1292             mstore(add(size, 32), v)
1293             mstore(add(size, 64), r)
1294             mstore(add(size, 96), s)
1295 
1296             // NOTE: we can reuse the request memory because we deal with
1297             //       the return code
1298             ret := call(3000, 1, 0, size, 128, size, 32)
1299             addr := mload(size)
1300         }
1301 
1302         return (ret, addr);
1303     }
1304 
1305     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1306     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1307         bytes32 r;
1308         bytes32 s;
1309         uint8 v;
1310 
1311         if (sig.length != 65)
1312           return (false, 0);
1313 
1314         // The signature format is a compact form of:
1315         //   {bytes32 r}{bytes32 s}{uint8 v}
1316         // Compact means, uint8 is not padded to 32 bytes.
1317         assembly {
1318             r := mload(add(sig, 32))
1319             s := mload(add(sig, 64))
1320 
1321             // Here we are loading the last 32 bytes. We exploit the fact that
1322             // 'mload' will pad with zeroes if we overread.
1323             // There is no 'mload8' to do this, but that would be nicer.
1324             v := byte(0, mload(add(sig, 96)))
1325 
1326             // Alternative solution:
1327             // 'byte' is not working due to the Solidity parser, so lets
1328             // use the second best option, 'and'
1329             // v := and(mload(add(sig, 65)), 255)
1330         }
1331 
1332         // albeit non-transactional signatures are not specified by the YP, one would expect it
1333         // to match the YP range of [27, 28]
1334         //
1335         // geth uses [0, 1] and some clients have followed. This might change, see:
1336         //  https://github.com/ethereum/go-ethereum/issues/2053
1337         if (v < 27)
1338           v += 27;
1339 
1340         if (v != 27 && v != 28)
1341             return (false, 0);
1342 
1343         return safer_ecrecover(hash, v, r, s);
1344     }
1345 
1346     function safeMemoryCleaner() internal pure {
1347         assembly {
1348             let fmem := mload(0x40)
1349             codecopy(fmem, codesize, sub(msize, fmem))
1350         }
1351     }
1352 
1353 }
1354 // </ORACLIZE_API>
1355 
1356 contract PAXTokenContract is IERC20, Owned, usingOraclize {
1357     using SafeMath for uint256;
1358     
1359     // Constructor - Sets the token Owner
1360     constructor() public {
1361         owner = 0x7645Ad8D4a2cD5b07D8Bc4ea1690d5c1F765aabC;
1362         treasury = 0x7645Ad8D4a2cD5b07D8Bc4ea1690d5c1F765aabC;
1363         _balances[owner] = 6000*76*10000000000000000;
1364         emit Transfer(contractAddress, owner, 6000*76*10000000000000000);
1365         contractAddress = this;
1366     }
1367     
1368     // Events
1369     event Error(string err);
1370     event Mint(uint mintAmount, uint newSupply, uint block);
1371     event PriceUpdate(uint price, uint block);
1372     event Burn(address from, uint amount);
1373     
1374     // Token Setup
1375     string public constant name = "PAX";
1376     string public constant symbol = "PXC";
1377     uint256 public constant decimals = 8;
1378     uint256 public price = 0;
1379     uint256 public supply = 6000*76*10000000000000000;
1380     
1381     uint256 public priceUpdateFrequency = 1440; // 1440 is average amount of blocks in 6 hours.
1382     uint256 public mintFrequency = 40320; // 40320 is average amount of blocks per weeek
1383     uint256 public demurrageFrequency = 2102400; // 2102400 is average amount of blocks per year
1384     uint256 public demurrageAmount = 2; // In percent
1385     uint256 public treasuryRatio = 25; // Amount of new minted tokens to be sent to treasury address in percent
1386 
1387     uint256 public lastMint;
1388     uint256 public lastPriceUpdate;
1389     address public contractAddress;
1390     address public treasury;
1391     
1392     string public oraclePriceURL = "json(https://spreadsheets.google.com/feeds/list/1pL8-QrNJrN1OFUmFNqt0IMDc6uepEuYLLAS-d8LxprI/od6/public/values?alt=json).feed.entry[1].['gsx$_ciyn3'].['$t']";
1393     string public oracleWorldPopulationURL = "json(http://api.population.io/1.0/population/World/today-and-tomorrow/?format=json).total_population[0].population";
1394     
1395     string public constant LegalAcknowledgement = "https://ipfs.io/ipfs/QmYv5yLgs77bcbPSXYvUFbB9WivxPX2ehPTemM8tycDQG2";
1396     
1397     // Fallback function
1398     function () public payable {}
1399     
1400     // Balances for each account
1401     mapping(address => uint256) _balances;
1402     
1403     // Block of last transaction, used for demurrage
1404     mapping(address => uint256) public lastTX;
1405     
1406     // Mapping to check oraclize query function
1407     mapping(bytes32 => bool) public queryType;
1408  
1409     // Owner of account approves the transfer of an amount to another account
1410     mapping(address => mapping (address => uint256)) _allowed;
1411  
1412     // Get the total supply of tokens
1413     function totalSupply() public constant returns (uint) {
1414         return supply;
1415     }
1416  
1417     // Get the token balance for account `tokenOwner`
1418     function balanceOf(address tokenOwner) public constant returns (uint balance) {
1419         return _balances[tokenOwner];
1420     }
1421  
1422     // Get the allowance of funds beteen a token holder and a spender
1423     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
1424         return _allowed[tokenOwner][spender];
1425     }
1426  
1427     // Transfer the balance from owner's account to another account
1428     function transfer(address to, uint value) public returns (bool success) {
1429         demurrageBalance(msg.sender);
1430         _balances[msg.sender] = _balances[msg.sender].sub(value);
1431         _balances[to] = _balances[to].add(value);
1432         emit Transfer(msg.sender, to, value);
1433         pushUpdate();
1434         return true;
1435     }
1436     
1437     // Sets how much a sender is allowed to use of an owners funds
1438     function approve(address spender, uint value) public returns (bool success) {
1439         _allowed[msg.sender][spender] = value;
1440         emit Approval(msg.sender, spender, value);
1441         return true;
1442     }
1443     
1444     // Transfer from function, pulls from allowance
1445     function transferFrom(address from, address to, uint value) public returns (bool success) {
1446         demurrageBalance(from);
1447         require(value <= balanceOf(from));
1448         require(value <= allowance(from, to));
1449         _balances[from] = _balances[from].sub(value);
1450         _balances[to] = _balances[to].add(value);
1451         _allowed[from][to] = _allowed[from][to].sub(value);
1452         emit Transfer(from, to, value);
1453         return true;
1454     }
1455     
1456     // Burn tokens
1457     function burn(uint256 _amount, address _from) onlyOwner public returns (bool success) {
1458         require(_balances[_from] >= _amount);
1459         _balances[_from] -= _amount;
1460         supply -= _amount;
1461         emit Transfer(_from, address(0), _amount);
1462         emit Burn(_from, _amount);
1463         return true;
1464     }
1465     
1466     // Sets a new Price Update Frequency
1467     function setPriceUpdateFrequency(uint256 _new) onlyOwner public returns (bool success) {
1468         priceUpdateFrequency = _new;
1469         return true;
1470     }
1471     
1472     // Sets a new Mint Frequency
1473     function setMintFrequency(uint256 _new) onlyOwner public returns (bool success) {
1474         mintFrequency = _new;
1475         return true;
1476     }
1477     
1478     // Sets a new demurrage Frequency
1479     function setDemurrageFrequency(uint256 _new) onlyOwner public returns (bool success) {
1480         demurrageFrequency = _new;
1481         return true;
1482     }
1483     
1484     // Sets a new demurrage amount
1485     function setDemurrageAmount(uint256 _new) public onlyOwner returns (bool success) {
1486         demurrageAmount = _new;
1487         return true;
1488     }
1489     
1490     // Sets a new treasury ratio
1491     function setTreasuryRatio(uint256 _new) public onlyOwner returns (bool success) {
1492         treasuryRatio = _new;
1493         return true;
1494     }
1495     
1496     // Sets a new treasury address
1497     function setTreasuryRatio(address _new) public onlyOwner returns (bool success) {
1498         treasury = _new;
1499         return true;
1500     }
1501     
1502     // Sets a new URL for getting price via Oraclize
1503     function setOraclePriceURL(string _new) public onlyOwner returns (bool success) {
1504         oraclePriceURL = _new;
1505         return true;
1506     }
1507     // Sets a new URL for getting world population via Oraclize
1508     function setOracleWorldPopulationURL(string _new) public onlyOwner returns (bool success) {
1509         oracleWorldPopulationURL = _new;
1510         return true;
1511     }
1512     
1513     // Check Demurrage
1514     function demurrageBalance(address _address) public {
1515         require(lastTX[_address] <= block.number + demurrageFrequency);
1516         uint256 _times = (block.number - lastTX[_address]) / demurrageFrequency;
1517         uint256 _amount = _balances[_address] / 100 * demurrageAmount;
1518         uint256 _demurrage = _times * _amount;
1519         emit Transfer(_address, owner, _demurrage);
1520         _balances[_address] -= _demurrage;
1521         _balances[owner] += _demurrage;
1522         lastTX[_address] = block.number;
1523     }
1524     
1525     // String to Interger paserser for oracle
1526     function parseInt(string _a, uint _b) internal pure returns (uint) {
1527         bytes memory bresult = bytes(_a);
1528         uint mint = 0;
1529         bool _decimals = false;
1530         for (uint i = 0; i < bresult.length; i++) {
1531             if ((bresult[i] >= 48) && (bresult[i] <= 57)) {
1532                 if (_decimals) {
1533                     if (_b == 0) break;
1534                     else _b--;
1535                 }
1536                 mint *= 10;
1537                 mint += uint(bresult[i]) - 48;
1538             } else if (bresult[i] == 46) _decimals = true;
1539         }
1540         return mint;
1541     }
1542     
1543     /* ~~~ Get oracle information ~~~ */
1544     
1545     // Push update checks if there needs to be an update call
1546     function pushUpdate() public {
1547         // Mint tokens by calling oracle
1548         if (block.number >= (lastMint + mintFrequency)) {
1549             if (oraclize_getPrice("URL") > contractAddress.balance) {
1550                 emit Error("Not enought ETH to call Oraclize!");
1551             } else {
1552                 bytes32 queryId = oraclize_query("URL", oracleWorldPopulationURL);
1553                 queryType[queryId] = true;
1554             }
1555         }
1556         // Updates the price using oracle
1557         if (block.number >= (lastPriceUpdate + priceUpdateFrequency)) {
1558             if (oraclize_getPrice("URL") > contractAddress.balance) {
1559                 emit Error("Not enought ETH to call Oraclize!");
1560             } else {
1561                 oraclize_query("URL", oraclePriceURL);
1562             }
1563         }
1564     }
1565     
1566     // Oraclize Callback function
1567     function __callback(bytes32 queryID, string result) public {
1568         if (msg.sender != oraclize_cbAddress()) revert();
1569         
1570         if (queryType[queryID] == true) {
1571             uint _newTotal = parseInt(result);
1572             uint256 newTotal = uint256(_newTotal) * 6000 * 10 ** decimals;
1573             uint256 mintAmount = newTotal - supply;
1574             uint256 treasuryDistribution = mintAmount * treasuryRatio / 100;
1575             _balances[owner] = _balances[owner] + mintAmount - treasuryDistribution;
1576             _balances[treasury] = _balances[treasury] + treasuryDistribution;
1577             supply = newTotal;
1578             lastMint = block.number;
1579             emit Mint(mintAmount, newTotal, lastMint);
1580             emit Transfer(contractAddress, owner, mintAmount - treasuryDistribution);
1581             emit Transfer(contractAddress, treasury, treasuryDistribution);
1582         } else {
1583             uint _newPrice = parseInt(result);
1584             price = _newPrice;
1585             lastPriceUpdate = block.number;
1586             emit PriceUpdate(price, lastPriceUpdate);
1587         }
1588     }
1589     
1590     // Will send all ETH in contract to the owner
1591     function withdrawETH() onlyOwner public returns (bool success) {
1592         owner.transfer(contractAddress.balance);
1593         return true;
1594     }
1595 }