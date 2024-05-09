1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract Ownable {
6   address private _owner;
7 
8   event OwnershipRenounced(address indexed previousOwner);
9   event OwnershipTransferred(
10     address indexed previousOwner,
11     address indexed newOwner
12   );
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     _owner = msg.sender;
20   }
21 
22   /**
23    * @return the address of the owner.
24    */
25   function owner() public view returns(address) {
26     return _owner;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(isOwner());
34     _;
35   }
36 
37   /**
38    * @return true if `msg.sender` is the owner of the contract.
39    */
40   function isOwner() public view returns(bool) {
41     return msg.sender == _owner;
42   }
43 
44   /**
45    * @dev Allows the current owner to relinquish control of the contract.
46    * @notice Renouncing to ownership will leave the contract without an owner.
47    * It will not be possible to call the functions with the `onlyOwner`
48    * modifier anymore.
49    */
50   function renounceOwnership() public onlyOwner {
51     emit OwnershipRenounced(_owner);
52     _owner = address(0);
53   }
54 
55   /**
56    * @dev Allows the current owner to transfer control of the contract to a newOwner.
57    * @param newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address newOwner) public onlyOwner {
60     _transferOwnership(newOwner);
61   }
62 
63   /**
64    * @dev Transfers control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function _transferOwnership(address newOwner) internal {
68     require(newOwner != address(0));
69     emit OwnershipTransferred(_owner, newOwner);
70     _owner = newOwner;
71   }
72 }
73 
74 library SafeMath {
75 
76   /**
77   * @dev Multiplies two numbers, reverts on overflow.
78   */
79   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81     // benefit is lost if 'b' is also tested.
82     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
83     if (a == 0) {
84       return 0;
85     }
86 
87     uint256 c = a * b;
88     require(c / a == b);
89 
90     return c;
91   }
92 
93   /**
94   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
95   */
96   function div(uint256 a, uint256 b) internal pure returns (uint256) {
97     require(b > 0); // Solidity only automatically asserts when dividing by 0
98     uint256 c = a / b;
99     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
100 
101     return c;
102   }
103 
104   /**
105   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
106   */
107   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108     require(b <= a);
109     uint256 c = a - b;
110 
111     return c;
112   }
113 
114   /**
115   * @dev Adds two numbers, reverts on overflow.
116   */
117   function add(uint256 a, uint256 b) internal pure returns (uint256) {
118     uint256 c = a + b;
119     require(c >= a);
120 
121     return c;
122   }
123 
124   /**
125   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
126   * reverts when dividing by zero.
127   */
128   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
129     require(b != 0);
130     return a % b;
131   }
132 }
133 
134 contract OraclizeI {
135     address public cbAddress;
136     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
137     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
138     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
139     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
140     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
141     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
142     function getPrice(string _datasource) public returns (uint _dsprice);
143     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
144     function setProofType(byte _proofType) external;
145     function setCustomGasPrice(uint _gasPrice) external;
146     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
147 }
148 
149 contract OraclizeAddrResolverI {
150     function getAddress() public returns (address _addr);
151 }
152 
153 /*
154 Begin solidity-cborutils
155 
156 https://github.com/smartcontractkit/solidity-cborutils
157 
158 MIT License
159 
160 Copyright (c) 2018 SmartContract ChainLink, Ltd.
161 
162 Permission is hereby granted, free of charge, to any person obtaining a copy
163 of this software and associated documentation files (the "Software"), to deal
164 in the Software without restriction, including without limitation the rights
165 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
166 copies of the Software, and to permit persons to whom the Software is
167 furnished to do so, subject to the following conditions:
168 
169 The above copyright notice and this permission notice shall be included in all
170 copies or substantial portions of the Software.
171 
172 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
173 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
174 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
175 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
176 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
177 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
178 SOFTWARE.
179  */
180 
181 library Buffer {
182     struct buffer {
183         bytes buf;
184         uint capacity;
185     }
186 
187     function init(buffer memory buf, uint _capacity) internal pure {
188         uint capacity = _capacity;
189         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
190         // Allocate space for the buffer data
191         buf.capacity = capacity;
192         assembly {
193             let ptr := mload(0x40)
194             mstore(buf, ptr)
195             mstore(ptr, 0)
196             mstore(0x40, add(ptr, capacity))
197         }
198     }
199 
200     function resize(buffer memory buf, uint capacity) private pure {
201         bytes memory oldbuf = buf.buf;
202         init(buf, capacity);
203         append(buf, oldbuf);
204     }
205 
206     function max(uint a, uint b) private pure returns(uint) {
207         if(a > b) {
208             return a;
209         }
210         return b;
211     }
212 
213     /**
214      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
215      *      would exceed the capacity of the buffer.
216      * @param buf The buffer to append to.
217      * @param data The data to append.
218      * @return The original buffer.
219      */
220     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
221         if(data.length + buf.buf.length > buf.capacity) {
222             resize(buf, max(buf.capacity, data.length) * 2);
223         }
224 
225         uint dest;
226         uint src;
227         uint len = data.length;
228         assembly {
229             // Memory address of the buffer data
230             let bufptr := mload(buf)
231             // Length of existing buffer data
232             let buflen := mload(bufptr)
233             // Start address = buffer address + buffer length + sizeof(buffer length)
234             dest := add(add(bufptr, buflen), 32)
235             // Update buffer length
236             mstore(bufptr, add(buflen, mload(data)))
237             src := add(data, 32)
238         }
239 
240         // Copy word-length chunks while possible
241         for(; len >= 32; len -= 32) {
242             assembly {
243                 mstore(dest, mload(src))
244             }
245             dest += 32;
246             src += 32;
247         }
248 
249         // Copy remaining bytes
250         uint mask = 256 ** (32 - len) - 1;
251         assembly {
252             let srcpart := and(mload(src), not(mask))
253             let destpart := and(mload(dest), mask)
254             mstore(dest, or(destpart, srcpart))
255         }
256 
257         return buf;
258     }
259 
260     /**
261      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
262      * exceed the capacity of the buffer.
263      * @param buf The buffer to append to.
264      * @param data The data to append.
265      * @return The original buffer.
266      */
267     function append(buffer memory buf, uint8 data) internal pure {
268         if(buf.buf.length + 1 > buf.capacity) {
269             resize(buf, buf.capacity * 2);
270         }
271 
272         assembly {
273             // Memory address of the buffer data
274             let bufptr := mload(buf)
275             // Length of existing buffer data
276             let buflen := mload(bufptr)
277             // Address = buffer address + buffer length + sizeof(buffer length)
278             let dest := add(add(bufptr, buflen), 32)
279             mstore8(dest, data)
280             // Update buffer length
281             mstore(bufptr, add(buflen, 1))
282         }
283     }
284 
285     /**
286      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
287      * exceed the capacity of the buffer.
288      * @param buf The buffer to append to.
289      * @param data The data to append.
290      * @return The original buffer.
291      */
292     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
293         if(len + buf.buf.length > buf.capacity) {
294             resize(buf, max(buf.capacity, len) * 2);
295         }
296 
297         uint mask = 256 ** len - 1;
298         assembly {
299             // Memory address of the buffer data
300             let bufptr := mload(buf)
301             // Length of existing buffer data
302             let buflen := mload(bufptr)
303             // Address = buffer address + buffer length + sizeof(buffer length) + len
304             let dest := add(add(bufptr, buflen), len)
305             mstore(dest, or(and(mload(dest), not(mask)), data))
306             // Update buffer length
307             mstore(bufptr, add(buflen, len))
308         }
309         return buf;
310     }
311 }
312 
313 library CBOR {
314     using Buffer for Buffer.buffer;
315 
316     uint8 private constant MAJOR_TYPE_INT = 0;
317     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
318     uint8 private constant MAJOR_TYPE_BYTES = 2;
319     uint8 private constant MAJOR_TYPE_STRING = 3;
320     uint8 private constant MAJOR_TYPE_ARRAY = 4;
321     uint8 private constant MAJOR_TYPE_MAP = 5;
322     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
323 
324     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
325         if(value <= 23) {
326             buf.append(uint8((major << 5) | value));
327         } else if(value <= 0xFF) {
328             buf.append(uint8((major << 5) | 24));
329             buf.appendInt(value, 1);
330         } else if(value <= 0xFFFF) {
331             buf.append(uint8((major << 5) | 25));
332             buf.appendInt(value, 2);
333         } else if(value <= 0xFFFFFFFF) {
334             buf.append(uint8((major << 5) | 26));
335             buf.appendInt(value, 4);
336         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
337             buf.append(uint8((major << 5) | 27));
338             buf.appendInt(value, 8);
339         }
340     }
341 
342     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
343         buf.append(uint8((major << 5) | 31));
344     }
345 
346     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
347         encodeType(buf, MAJOR_TYPE_INT, value);
348     }
349 
350     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
351         if(value >= 0) {
352             encodeType(buf, MAJOR_TYPE_INT, uint(value));
353         } else {
354             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
355         }
356     }
357 
358     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
359         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
360         buf.append(value);
361     }
362 
363     function encodeString(Buffer.buffer memory buf, string value) internal pure {
364         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
365         buf.append(bytes(value));
366     }
367 
368     function startArray(Buffer.buffer memory buf) internal pure {
369         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
370     }
371 
372     function startMap(Buffer.buffer memory buf) internal pure {
373         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
374     }
375 
376     function endSequence(Buffer.buffer memory buf) internal pure {
377         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
378     }
379 }
380 
381 /*
382 End solidity-cborutils
383  */
384 
385 contract usingOraclize {
386     uint constant day = 60*60*24;
387     uint constant week = 60*60*24*7;
388     uint constant month = 60*60*24*30;
389     byte constant proofType_NONE = 0x00;
390     byte constant proofType_TLSNotary = 0x10;
391     byte constant proofType_Ledger = 0x30;
392     byte constant proofType_Android = 0x40;
393     byte constant proofType_Native = 0xF0;
394     byte constant proofStorage_IPFS = 0x01;
395     uint8 constant networkID_auto = 0;
396     uint8 constant networkID_mainnet = 1;
397     uint8 constant networkID_testnet = 2;
398     uint8 constant networkID_morden = 2;
399     uint8 constant networkID_consensys = 161;
400 
401     OraclizeAddrResolverI OAR;
402 
403     OraclizeI oraclize;
404     modifier oraclizeAPI {
405         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
406             oraclize_setNetwork(networkID_auto);
407 
408         if(address(oraclize) != OAR.getAddress())
409             oraclize = OraclizeI(OAR.getAddress());
410 
411         _;
412     }
413     modifier coupon(string code){
414         oraclize = OraclizeI(OAR.getAddress());
415         _;
416     }
417 
418     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
419       return oraclize_setNetwork();
420       networkID; // silence the warning and remain backwards compatible
421     }
422     function oraclize_setNetwork() internal returns(bool){
423         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
424             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
425             oraclize_setNetworkName("eth_mainnet");
426             return true;
427         }
428         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
429             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
430             oraclize_setNetworkName("eth_ropsten3");
431             return true;
432         }
433         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
434             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
435             oraclize_setNetworkName("eth_kovan");
436             return true;
437         }
438         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
439             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
440             oraclize_setNetworkName("eth_rinkeby");
441             return true;
442         }
443         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
444             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
445             return true;
446         }
447         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
448             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
449             return true;
450         }
451         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
452             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
453             return true;
454         }
455         return false;
456     }
457 
458     function __callback(bytes32 myid, string result) public {
459         __callback(myid, result, new bytes(0));
460     }
461     function __callback(bytes32 myid, string result, bytes proof) public {
462       return;
463       myid; result; proof; // Silence compiler warnings
464     }
465 
466     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
467         return oraclize.getPrice(datasource);
468     }
469 
470     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
471         return oraclize.getPrice(datasource, gaslimit);
472     }
473 
474     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
475         uint price = oraclize.getPrice(datasource);
476         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
477         return oraclize.query.value(price)(0, datasource, arg);
478     }
479     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
480         uint price = oraclize.getPrice(datasource);
481         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
482         return oraclize.query.value(price)(timestamp, datasource, arg);
483     }
484     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
485         uint price = oraclize.getPrice(datasource, gaslimit);
486         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
487         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
488     }
489     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
490         uint price = oraclize.getPrice(datasource, gaslimit);
491         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
492         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
493     }
494     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
495         uint price = oraclize.getPrice(datasource);
496         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
497         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
498     }
499     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
500         uint price = oraclize.getPrice(datasource);
501         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
502         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
503     }
504     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
505         uint price = oraclize.getPrice(datasource, gaslimit);
506         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
507         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
508     }
509     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
510         uint price = oraclize.getPrice(datasource, gaslimit);
511         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
512         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
513     }
514     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
515         uint price = oraclize.getPrice(datasource);
516         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
517         bytes memory args = stra2cbor(argN);
518         return oraclize.queryN.value(price)(0, datasource, args);
519     }
520     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
521         uint price = oraclize.getPrice(datasource);
522         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
523         bytes memory args = stra2cbor(argN);
524         return oraclize.queryN.value(price)(timestamp, datasource, args);
525     }
526     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
527         uint price = oraclize.getPrice(datasource, gaslimit);
528         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
529         bytes memory args = stra2cbor(argN);
530         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
531     }
532     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
533         uint price = oraclize.getPrice(datasource, gaslimit);
534         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
535         bytes memory args = stra2cbor(argN);
536         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
537     }
538     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
539         string[] memory dynargs = new string[](1);
540         dynargs[0] = args[0];
541         return oraclize_query(datasource, dynargs);
542     }
543     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
544         string[] memory dynargs = new string[](1);
545         dynargs[0] = args[0];
546         return oraclize_query(timestamp, datasource, dynargs);
547     }
548     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
549         string[] memory dynargs = new string[](1);
550         dynargs[0] = args[0];
551         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
552     }
553     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
554         string[] memory dynargs = new string[](1);
555         dynargs[0] = args[0];
556         return oraclize_query(datasource, dynargs, gaslimit);
557     }
558 
559     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
560         string[] memory dynargs = new string[](2);
561         dynargs[0] = args[0];
562         dynargs[1] = args[1];
563         return oraclize_query(datasource, dynargs);
564     }
565     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
566         string[] memory dynargs = new string[](2);
567         dynargs[0] = args[0];
568         dynargs[1] = args[1];
569         return oraclize_query(timestamp, datasource, dynargs);
570     }
571     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
572         string[] memory dynargs = new string[](2);
573         dynargs[0] = args[0];
574         dynargs[1] = args[1];
575         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
576     }
577     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
578         string[] memory dynargs = new string[](2);
579         dynargs[0] = args[0];
580         dynargs[1] = args[1];
581         return oraclize_query(datasource, dynargs, gaslimit);
582     }
583     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
584         string[] memory dynargs = new string[](3);
585         dynargs[0] = args[0];
586         dynargs[1] = args[1];
587         dynargs[2] = args[2];
588         return oraclize_query(datasource, dynargs);
589     }
590     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
591         string[] memory dynargs = new string[](3);
592         dynargs[0] = args[0];
593         dynargs[1] = args[1];
594         dynargs[2] = args[2];
595         return oraclize_query(timestamp, datasource, dynargs);
596     }
597     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
598         string[] memory dynargs = new string[](3);
599         dynargs[0] = args[0];
600         dynargs[1] = args[1];
601         dynargs[2] = args[2];
602         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
603     }
604     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
605         string[] memory dynargs = new string[](3);
606         dynargs[0] = args[0];
607         dynargs[1] = args[1];
608         dynargs[2] = args[2];
609         return oraclize_query(datasource, dynargs, gaslimit);
610     }
611 
612     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
613         string[] memory dynargs = new string[](4);
614         dynargs[0] = args[0];
615         dynargs[1] = args[1];
616         dynargs[2] = args[2];
617         dynargs[3] = args[3];
618         return oraclize_query(datasource, dynargs);
619     }
620     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
621         string[] memory dynargs = new string[](4);
622         dynargs[0] = args[0];
623         dynargs[1] = args[1];
624         dynargs[2] = args[2];
625         dynargs[3] = args[3];
626         return oraclize_query(timestamp, datasource, dynargs);
627     }
628     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
629         string[] memory dynargs = new string[](4);
630         dynargs[0] = args[0];
631         dynargs[1] = args[1];
632         dynargs[2] = args[2];
633         dynargs[3] = args[3];
634         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
635     }
636     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
637         string[] memory dynargs = new string[](4);
638         dynargs[0] = args[0];
639         dynargs[1] = args[1];
640         dynargs[2] = args[2];
641         dynargs[3] = args[3];
642         return oraclize_query(datasource, dynargs, gaslimit);
643     }
644     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
645         string[] memory dynargs = new string[](5);
646         dynargs[0] = args[0];
647         dynargs[1] = args[1];
648         dynargs[2] = args[2];
649         dynargs[3] = args[3];
650         dynargs[4] = args[4];
651         return oraclize_query(datasource, dynargs);
652     }
653     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
654         string[] memory dynargs = new string[](5);
655         dynargs[0] = args[0];
656         dynargs[1] = args[1];
657         dynargs[2] = args[2];
658         dynargs[3] = args[3];
659         dynargs[4] = args[4];
660         return oraclize_query(timestamp, datasource, dynargs);
661     }
662     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
663         string[] memory dynargs = new string[](5);
664         dynargs[0] = args[0];
665         dynargs[1] = args[1];
666         dynargs[2] = args[2];
667         dynargs[3] = args[3];
668         dynargs[4] = args[4];
669         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
670     }
671     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
672         string[] memory dynargs = new string[](5);
673         dynargs[0] = args[0];
674         dynargs[1] = args[1];
675         dynargs[2] = args[2];
676         dynargs[3] = args[3];
677         dynargs[4] = args[4];
678         return oraclize_query(datasource, dynargs, gaslimit);
679     }
680     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
681         uint price = oraclize.getPrice(datasource);
682         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
683         bytes memory args = ba2cbor(argN);
684         return oraclize.queryN.value(price)(0, datasource, args);
685     }
686     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
687         uint price = oraclize.getPrice(datasource);
688         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
689         bytes memory args = ba2cbor(argN);
690         return oraclize.queryN.value(price)(timestamp, datasource, args);
691     }
692     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
693         uint price = oraclize.getPrice(datasource, gaslimit);
694         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
695         bytes memory args = ba2cbor(argN);
696         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
697     }
698     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
699         uint price = oraclize.getPrice(datasource, gaslimit);
700         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
701         bytes memory args = ba2cbor(argN);
702         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
703     }
704     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
705         bytes[] memory dynargs = new bytes[](1);
706         dynargs[0] = args[0];
707         return oraclize_query(datasource, dynargs);
708     }
709     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
710         bytes[] memory dynargs = new bytes[](1);
711         dynargs[0] = args[0];
712         return oraclize_query(timestamp, datasource, dynargs);
713     }
714     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
715         bytes[] memory dynargs = new bytes[](1);
716         dynargs[0] = args[0];
717         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
718     }
719     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
720         bytes[] memory dynargs = new bytes[](1);
721         dynargs[0] = args[0];
722         return oraclize_query(datasource, dynargs, gaslimit);
723     }
724 
725     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
726         bytes[] memory dynargs = new bytes[](2);
727         dynargs[0] = args[0];
728         dynargs[1] = args[1];
729         return oraclize_query(datasource, dynargs);
730     }
731     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
732         bytes[] memory dynargs = new bytes[](2);
733         dynargs[0] = args[0];
734         dynargs[1] = args[1];
735         return oraclize_query(timestamp, datasource, dynargs);
736     }
737     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
738         bytes[] memory dynargs = new bytes[](2);
739         dynargs[0] = args[0];
740         dynargs[1] = args[1];
741         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
742     }
743     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
744         bytes[] memory dynargs = new bytes[](2);
745         dynargs[0] = args[0];
746         dynargs[1] = args[1];
747         return oraclize_query(datasource, dynargs, gaslimit);
748     }
749     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
750         bytes[] memory dynargs = new bytes[](3);
751         dynargs[0] = args[0];
752         dynargs[1] = args[1];
753         dynargs[2] = args[2];
754         return oraclize_query(datasource, dynargs);
755     }
756     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
757         bytes[] memory dynargs = new bytes[](3);
758         dynargs[0] = args[0];
759         dynargs[1] = args[1];
760         dynargs[2] = args[2];
761         return oraclize_query(timestamp, datasource, dynargs);
762     }
763     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
764         bytes[] memory dynargs = new bytes[](3);
765         dynargs[0] = args[0];
766         dynargs[1] = args[1];
767         dynargs[2] = args[2];
768         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
769     }
770     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
771         bytes[] memory dynargs = new bytes[](3);
772         dynargs[0] = args[0];
773         dynargs[1] = args[1];
774         dynargs[2] = args[2];
775         return oraclize_query(datasource, dynargs, gaslimit);
776     }
777 
778     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
779         bytes[] memory dynargs = new bytes[](4);
780         dynargs[0] = args[0];
781         dynargs[1] = args[1];
782         dynargs[2] = args[2];
783         dynargs[3] = args[3];
784         return oraclize_query(datasource, dynargs);
785     }
786     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
787         bytes[] memory dynargs = new bytes[](4);
788         dynargs[0] = args[0];
789         dynargs[1] = args[1];
790         dynargs[2] = args[2];
791         dynargs[3] = args[3];
792         return oraclize_query(timestamp, datasource, dynargs);
793     }
794     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
795         bytes[] memory dynargs = new bytes[](4);
796         dynargs[0] = args[0];
797         dynargs[1] = args[1];
798         dynargs[2] = args[2];
799         dynargs[3] = args[3];
800         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
801     }
802     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
803         bytes[] memory dynargs = new bytes[](4);
804         dynargs[0] = args[0];
805         dynargs[1] = args[1];
806         dynargs[2] = args[2];
807         dynargs[3] = args[3];
808         return oraclize_query(datasource, dynargs, gaslimit);
809     }
810     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
811         bytes[] memory dynargs = new bytes[](5);
812         dynargs[0] = args[0];
813         dynargs[1] = args[1];
814         dynargs[2] = args[2];
815         dynargs[3] = args[3];
816         dynargs[4] = args[4];
817         return oraclize_query(datasource, dynargs);
818     }
819     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
820         bytes[] memory dynargs = new bytes[](5);
821         dynargs[0] = args[0];
822         dynargs[1] = args[1];
823         dynargs[2] = args[2];
824         dynargs[3] = args[3];
825         dynargs[4] = args[4];
826         return oraclize_query(timestamp, datasource, dynargs);
827     }
828     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
829         bytes[] memory dynargs = new bytes[](5);
830         dynargs[0] = args[0];
831         dynargs[1] = args[1];
832         dynargs[2] = args[2];
833         dynargs[3] = args[3];
834         dynargs[4] = args[4];
835         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
836     }
837     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
838         bytes[] memory dynargs = new bytes[](5);
839         dynargs[0] = args[0];
840         dynargs[1] = args[1];
841         dynargs[2] = args[2];
842         dynargs[3] = args[3];
843         dynargs[4] = args[4];
844         return oraclize_query(datasource, dynargs, gaslimit);
845     }
846 
847     function oraclize_cbAddress() oraclizeAPI internal returns (address){
848         return oraclize.cbAddress();
849     }
850     function oraclize_setProof(byte proofP) oraclizeAPI internal {
851         return oraclize.setProofType(proofP);
852     }
853     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
854         return oraclize.setCustomGasPrice(gasPrice);
855     }
856 
857     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
858         return oraclize.randomDS_getSessionPubKeyHash();
859     }
860 
861     function getCodeSize(address _addr) constant internal returns(uint _size) {
862         assembly {
863             _size := extcodesize(_addr)
864         }
865     }
866 
867     function parseAddr(string _a) internal pure returns (address){
868         bytes memory tmp = bytes(_a);
869         uint160 iaddr = 0;
870         uint160 b1;
871         uint160 b2;
872         for (uint i=2; i<2+2*20; i+=2){
873             iaddr *= 256;
874             b1 = uint160(tmp[i]);
875             b2 = uint160(tmp[i+1]);
876             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
877             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
878             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
879             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
880             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
881             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
882             iaddr += (b1*16+b2);
883         }
884         return address(iaddr);
885     }
886 
887     function strCompare(string _a, string _b) internal pure returns (int) {
888         bytes memory a = bytes(_a);
889         bytes memory b = bytes(_b);
890         uint minLength = a.length;
891         if (b.length < minLength) minLength = b.length;
892         for (uint i = 0; i < minLength; i ++)
893             if (a[i] < b[i])
894                 return -1;
895             else if (a[i] > b[i])
896                 return 1;
897         if (a.length < b.length)
898             return -1;
899         else if (a.length > b.length)
900             return 1;
901         else
902             return 0;
903     }
904 
905     function indexOf(string _haystack, string _needle) internal pure returns (int) {
906         bytes memory h = bytes(_haystack);
907         bytes memory n = bytes(_needle);
908         if(h.length < 1 || n.length < 1 || (n.length > h.length))
909             return -1;
910         else if(h.length > (2**128 -1))
911             return -1;
912         else
913         {
914             uint subindex = 0;
915             for (uint i = 0; i < h.length; i ++)
916             {
917                 if (h[i] == n[0])
918                 {
919                     subindex = 1;
920                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
921                     {
922                         subindex++;
923                     }
924                     if(subindex == n.length)
925                         return int(i);
926                 }
927             }
928             return -1;
929         }
930     }
931 
932     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
933         bytes memory _ba = bytes(_a);
934         bytes memory _bb = bytes(_b);
935         bytes memory _bc = bytes(_c);
936         bytes memory _bd = bytes(_d);
937         bytes memory _be = bytes(_e);
938         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
939         bytes memory babcde = bytes(abcde);
940         uint k = 0;
941         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
942         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
943         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
944         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
945         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
946         return string(babcde);
947     }
948 
949     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
950         return strConcat(_a, _b, _c, _d, "");
951     }
952 
953     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
954         return strConcat(_a, _b, _c, "", "");
955     }
956 
957     function strConcat(string _a, string _b) internal pure returns (string) {
958         return strConcat(_a, _b, "", "", "");
959     }
960 
961     // parseInt
962     function parseInt(string _a) internal pure returns (uint) {
963         return parseInt(_a, 0);
964     }
965 
966     // parseInt(parseFloat*10^_b)
967     function parseInt(string _a, uint _b) internal pure returns (uint) {
968         bytes memory bresult = bytes(_a);
969         uint mint = 0;
970         bool decimals = false;
971         for (uint i=0; i<bresult.length; i++){
972             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
973                 if (decimals){
974                    if (_b == 0) break;
975                     else _b--;
976                 }
977                 mint *= 10;
978                 mint += uint(bresult[i]) - 48;
979             } else if (bresult[i] == 46) decimals = true;
980         }
981         if (_b > 0) mint *= 10**_b;
982         return mint;
983     }
984 
985     function uint2str(uint i) internal pure returns (string){
986         if (i == 0) return "0";
987         uint j = i;
988         uint len;
989         while (j != 0){
990             len++;
991             j /= 10;
992         }
993         bytes memory bstr = new bytes(len);
994         uint k = len - 1;
995         while (i != 0){
996             bstr[k--] = byte(48 + i % 10);
997             i /= 10;
998         }
999         return string(bstr);
1000     }
1001 
1002     using CBOR for Buffer.buffer;
1003     function stra2cbor(string[] arr) internal pure returns (bytes) {
1004         safeMemoryCleaner();
1005         Buffer.buffer memory buf;
1006         Buffer.init(buf, 1024);
1007         buf.startArray();
1008         for (uint i = 0; i < arr.length; i++) {
1009             buf.encodeString(arr[i]);
1010         }
1011         buf.endSequence();
1012         return buf.buf;
1013     }
1014 
1015     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
1016         safeMemoryCleaner();
1017         Buffer.buffer memory buf;
1018         Buffer.init(buf, 1024);
1019         buf.startArray();
1020         for (uint i = 0; i < arr.length; i++) {
1021             buf.encodeBytes(arr[i]);
1022         }
1023         buf.endSequence();
1024         return buf.buf;
1025     }
1026 
1027     string oraclize_network_name;
1028     function oraclize_setNetworkName(string _network_name) internal {
1029         oraclize_network_name = _network_name;
1030     }
1031 
1032     function oraclize_getNetworkName() internal view returns (string) {
1033         return oraclize_network_name;
1034     }
1035 
1036     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1037         require((_nbytes > 0) && (_nbytes <= 32));
1038         // Convert from seconds to ledger timer ticks
1039         _delay *= 10;
1040         bytes memory nbytes = new bytes(1);
1041         nbytes[0] = byte(_nbytes);
1042         bytes memory unonce = new bytes(32);
1043         bytes memory sessionKeyHash = new bytes(32);
1044         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1045         assembly {
1046             mstore(unonce, 0x20)
1047             // the following variables can be relaxed
1048             // check relaxed random contract under ethereum-examples repo
1049             // for an idea on how to override and replace comit hash vars
1050             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1051             mstore(sessionKeyHash, 0x20)
1052             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1053         }
1054         bytes memory delay = new bytes(32);
1055         assembly {
1056             mstore(add(delay, 0x20), _delay)
1057         }
1058 
1059         bytes memory delay_bytes8 = new bytes(8);
1060         copyBytes(delay, 24, 8, delay_bytes8, 0);
1061 
1062         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1063         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1064 
1065         bytes memory delay_bytes8_left = new bytes(8);
1066 
1067         assembly {
1068             let x := mload(add(delay_bytes8, 0x20))
1069             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1070             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1071             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1072             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1073             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1074             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1075             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1076             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1077 
1078         }
1079 
1080         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1081         return queryId;
1082     }
1083 
1084     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1085         oraclize_randomDS_args[queryId] = commitment;
1086     }
1087 
1088     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1089     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1090 
1091     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1092         bool sigok;
1093         address signer;
1094 
1095         bytes32 sigr;
1096         bytes32 sigs;
1097 
1098         bytes memory sigr_ = new bytes(32);
1099         uint offset = 4+(uint(dersig[3]) - 0x20);
1100         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1101         bytes memory sigs_ = new bytes(32);
1102         offset += 32 + 2;
1103         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1104 
1105         assembly {
1106             sigr := mload(add(sigr_, 32))
1107             sigs := mload(add(sigs_, 32))
1108         }
1109 
1110 
1111         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1112         if (address(keccak256(pubkey)) == signer) return true;
1113         else {
1114             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1115             return (address(keccak256(pubkey)) == signer);
1116         }
1117     }
1118 
1119     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1120         bool sigok;
1121 
1122         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1123         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1124         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1125 
1126         bytes memory appkey1_pubkey = new bytes(64);
1127         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1128 
1129         bytes memory tosign2 = new bytes(1+65+32);
1130         tosign2[0] = byte(1); //role
1131         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1132         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1133         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1134         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1135 
1136         if (sigok == false) return false;
1137 
1138 
1139         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1140         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1141 
1142         bytes memory tosign3 = new bytes(1+65);
1143         tosign3[0] = 0xFE;
1144         copyBytes(proof, 3, 65, tosign3, 1);
1145 
1146         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1147         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1148 
1149         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1150 
1151         return sigok;
1152     }
1153 
1154     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1155         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1156         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1157 
1158         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1159         require(proofVerified);
1160 
1161         _;
1162     }
1163 
1164     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1165         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1166         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1167 
1168         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1169         if (proofVerified == false) return 2;
1170 
1171         return 0;
1172     }
1173 
1174     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1175         bool match_ = true;
1176 
1177         require(prefix.length == n_random_bytes);
1178 
1179         for (uint256 i=0; i< n_random_bytes; i++) {
1180             if (content[i] != prefix[i]) match_ = false;
1181         }
1182 
1183         return match_;
1184     }
1185 
1186     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1187 
1188         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1189         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1190         bytes memory keyhash = new bytes(32);
1191         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1192         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1193 
1194         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1195         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1196 
1197         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1198         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1199 
1200         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1201         // This is to verify that the computed args match with the ones specified in the query.
1202         bytes memory commitmentSlice1 = new bytes(8+1+32);
1203         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1204 
1205         bytes memory sessionPubkey = new bytes(64);
1206         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1207         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1208 
1209         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1210         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1211             delete oraclize_randomDS_args[queryId];
1212         } else return false;
1213 
1214 
1215         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1216         bytes memory tosign1 = new bytes(32+8+1+32);
1217         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1218         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1219 
1220         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1221         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1222             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1223         }
1224 
1225         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1226     }
1227 
1228     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1229     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1230         uint minLength = length + toOffset;
1231 
1232         // Buffer too small
1233         require(to.length >= minLength); // Should be a better way?
1234 
1235         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1236         uint i = 32 + fromOffset;
1237         uint j = 32 + toOffset;
1238 
1239         while (i < (32 + fromOffset + length)) {
1240             assembly {
1241                 let tmp := mload(add(from, i))
1242                 mstore(add(to, j), tmp)
1243             }
1244             i += 32;
1245             j += 32;
1246         }
1247 
1248         return to;
1249     }
1250 
1251     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1252     // Duplicate Solidity's ecrecover, but catching the CALL return value
1253     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1254         // We do our own memory management here. Solidity uses memory offset
1255         // 0x40 to store the current end of memory. We write past it (as
1256         // writes are memory extensions), but don't update the offset so
1257         // Solidity will reuse it. The memory used here is only needed for
1258         // this context.
1259 
1260         // FIXME: inline assembly can't access return values
1261         bool ret;
1262         address addr;
1263 
1264         assembly {
1265             let size := mload(0x40)
1266             mstore(size, hash)
1267             mstore(add(size, 32), v)
1268             mstore(add(size, 64), r)
1269             mstore(add(size, 96), s)
1270 
1271             // NOTE: we can reuse the request memory because we deal with
1272             //       the return code
1273             ret := call(3000, 1, 0, size, 128, size, 32)
1274             addr := mload(size)
1275         }
1276 
1277         return (ret, addr);
1278     }
1279 
1280     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1281     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1282         bytes32 r;
1283         bytes32 s;
1284         uint8 v;
1285 
1286         if (sig.length != 65)
1287           return (false, 0);
1288 
1289         // The signature format is a compact form of:
1290         //   {bytes32 r}{bytes32 s}{uint8 v}
1291         // Compact means, uint8 is not padded to 32 bytes.
1292         assembly {
1293             r := mload(add(sig, 32))
1294             s := mload(add(sig, 64))
1295 
1296             // Here we are loading the last 32 bytes. We exploit the fact that
1297             // 'mload' will pad with zeroes if we overread.
1298             // There is no 'mload8' to do this, but that would be nicer.
1299             v := byte(0, mload(add(sig, 96)))
1300 
1301             // Alternative solution:
1302             // 'byte' is not working due to the Solidity parser, so lets
1303             // use the second best option, 'and'
1304             // v := and(mload(add(sig, 65)), 255)
1305         }
1306 
1307         // albeit non-transactional signatures are not specified by the YP, one would expect it
1308         // to match the YP range of [27, 28]
1309         //
1310         // geth uses [0, 1] and some clients have followed. This might change, see:
1311         //  https://github.com/ethereum/go-ethereum/issues/2053
1312         if (v < 27)
1313           v += 27;
1314 
1315         if (v != 27 && v != 28)
1316             return (false, 0);
1317 
1318         return safer_ecrecover(hash, v, r, s);
1319     }
1320 
1321     function safeMemoryCleaner() internal pure {
1322         assembly {
1323             let fmem := mload(0x40)
1324             codecopy(fmem, codesize, sub(msize, fmem))
1325         }
1326     }
1327 
1328 }
1329 // </ORACLIZE_API>
1330 
1331 contract GamePool is Ownable, usingOraclize {
1332     using SafeMath for uint256;
1333     
1334     enum RecordType { StartExRate, EndExRate, RandY }
1335     
1336     struct QueryRecord {
1337         RecordType recordType;
1338         uint256 gameId;
1339         uint256 arg;
1340     }
1341     
1342     mapping (bytes32 => QueryRecord) public queryRecords;
1343     
1344     GameLogic.Instance[] public games;
1345     GameLogic.GameBets[] gameBets;
1346     
1347     address public txFeeReceiver;
1348     uint256 public oraclizeFee;
1349     
1350     uint256 public MIN_BET = 100 finney; // 0.1 ether.
1351     uint256 public HIDDEN_TIME_BEFORE_CLOSE = 5 minutes;
1352     uint256 public ORICALIZE_GAS_LIMIT = 120000;
1353     uint256 public CLAIM_AWARD_TIME_AFTER_CLOSE = 30 days;
1354     uint256 public CLAIM_REFUND_TIME_AFTER_CLOSE = 6 hours;
1355     uint256 public MAX_FETCHING_TIME_FOR_END_EXRATE = 3 hours;
1356     
1357     event StartExRateUpdated(uint256 indexed gameId, uint256 coinId, int32 rate, uint256 timeStamp);
1358     event EndExRateUpdated(uint256 indexed gameId, uint256 coinId, int32 rate, uint256 timeStamp);
1359     event GameYChoosed(uint256 indexed gameId, uint8 Y);
1360     
1361     event Log(string message);
1362     event LogAddr(address addr);
1363     event CoinBet(uint256 indexed gameId, uint256 coinId, address player, uint256 amount);
1364     event CoinLargestBetChanged(uint256 indexed gameId, uint256 coinId, uint256 amount);
1365     event SendAwards(uint256 indexed gameId, address player, uint256 awards);
1366     event RefundClaimed(uint256 indexed gameId, address player, uint256 amount);
1367     event OraclizeFeeReceived(uint256 received);
1368     event OraclizeFeeUsed(uint256 used);
1369     event SentOraclizeQuery(bytes32 queryId);
1370     event SendTxFee(address receiver, uint256 feeAmount);
1371     event GetUnclaimedAwards(uint256 indexed gameId, address receiver, uint256 feeAmount);
1372     event GetUnclaimedRefunds(uint256 indexed gameId, address receiver, uint256 feeAmount);
1373     
1374     event GameCreated(uint256 gameId);
1375     
1376     event GameClosed(uint256 indexed gameId);
1377     event GameExtended(uint256 indexed gameId, uint256 closeTime);
1378     event GameWaitToClose(uint256 indexed gameId);
1379     event GameReady(uint256 indexed gameId);
1380     event GameOpened(uint256 indexed gameId);
1381     
1382     modifier hasGameId(uint256 _gameId) {
1383          require(_gameId < games.length && games.length == gameBets.length);
1384          _;
1385     }
1386     
1387     modifier hasCoinId(uint256 _coinId) {
1388          require(_coinId < 5);
1389          _;
1390     }
1391     
1392     constructor(address _txFeeReceiver) public {
1393         require(address(0) != _txFeeReceiver);
1394         txFeeReceiver = _txFeeReceiver;
1395         
1396         //OAR = OraclizeAddrResolverI(0x0BffB729b30063E53A341ba6a05dfE8f817E7a53);
1397         //emit LogAddr(oraclize_cbAddress());
1398     }
1399     
1400     function packedCommonData() 
1401         public 
1402         view 
1403         returns (address _txFeeReceiver
1404             , uint256 _minimumBets
1405             , uint256 _hiddenTimeLengthBeforeClose
1406             , uint256 _claimAwardTimeAfterClose
1407             , uint256 _claimRefundTimeAfterColose
1408             , uint256 _maximumFetchingTimeForEndExRate
1409             , uint256 _numberOfGames)
1410     {
1411         _txFeeReceiver = txFeeReceiver;
1412         _minimumBets = MIN_BET;
1413         _hiddenTimeLengthBeforeClose = HIDDEN_TIME_BEFORE_CLOSE;
1414         _claimAwardTimeAfterClose = CLAIM_AWARD_TIME_AFTER_CLOSE;
1415         _claimRefundTimeAfterColose = CLAIM_REFUND_TIME_AFTER_CLOSE;
1416         _maximumFetchingTimeForEndExRate = MAX_FETCHING_TIME_FOR_END_EXRATE;
1417         _numberOfGames = games.length;
1418     }
1419     
1420     function createNewGame(uint256 _openTime
1421         , uint256 _duration
1422         , string _coinName0
1423         , string _coinName1
1424         , string _coinName2
1425         , string _coinName3
1426         , string _coinName4
1427         , uint8[50] _YDistribution
1428         , uint8 _A
1429         , uint8 _B
1430         , uint16 _txFee
1431         , uint256 _minDiffBets) onlyOwner public
1432     {
1433         // Check inputs.
1434         require(_A <= 100 && _B <= 100 && _A + _B <= 100);
1435         
1436         require(_YDistribution[0] <= 100);
1437         require(_YDistribution[1] <= 100);
1438         require(_YDistribution[2] <= 100);
1439         require(_YDistribution[3] <= 100);
1440         require(_YDistribution[4] <= 100);
1441         require(_YDistribution[5] <= 100);
1442         require(_YDistribution[6] <= 100);
1443         require(_YDistribution[7] <= 100);
1444         require(_YDistribution[8] <= 100);
1445         require(_YDistribution[9] <= 100);
1446         require(_YDistribution[10] <= 100);
1447         require(_YDistribution[11] <= 100);
1448         require(_YDistribution[12] <= 100);
1449         require(_YDistribution[13] <= 100);
1450         require(_YDistribution[14] <= 100);
1451         require(_YDistribution[15] <= 100);
1452         require(_YDistribution[16] <= 100);
1453         require(_YDistribution[17] <= 100);
1454         require(_YDistribution[18] <= 100);
1455         require(_YDistribution[19] <= 100);
1456         require(_YDistribution[20] <= 100);
1457         require(_YDistribution[21] <= 100);
1458         require(_YDistribution[22] <= 100);
1459         require(_YDistribution[23] <= 100);
1460         require(_YDistribution[24] <= 100);
1461         require(_YDistribution[25] <= 100);
1462         require(_YDistribution[26] <= 100);
1463         require(_YDistribution[27] <= 100);
1464         require(_YDistribution[28] <= 100);
1465         require(_YDistribution[29] <= 100);
1466         require(_YDistribution[30] <= 100);
1467         require(_YDistribution[31] <= 100);
1468         require(_YDistribution[32] <= 100);
1469         require(_YDistribution[33] <= 100);
1470         require(_YDistribution[34] <= 100);
1471         require(_YDistribution[35] <= 100);
1472         require(_YDistribution[36] <= 100);
1473         require(_YDistribution[37] <= 100);
1474         require(_YDistribution[38] <= 100);
1475         require(_YDistribution[39] <= 100);
1476         require(_YDistribution[40] <= 100);
1477         require(_YDistribution[41] <= 100);
1478         require(_YDistribution[42] <= 100);
1479         require(_YDistribution[43] <= 100);
1480         require(_YDistribution[44] <= 100);
1481         require(_YDistribution[45] <= 100);
1482         require(_YDistribution[46] <= 100);
1483         require(_YDistribution[47] <= 100);
1484         require(_YDistribution[48] <= 100);
1485         require(_YDistribution[49] <= 100);
1486         
1487         require(_openTime >= now);
1488         require(_duration > 0);
1489         
1490         require(_txFee <= 1000); // < 100%
1491         
1492         if (0 != games.length) {
1493             GameLogic.State state = GameLogic.state(games[games.length - 1]
1494                 , gameBets[games.length - 1]);
1495             require(GameLogic.State.Closed == state || GameLogic.State.Error == state);
1496         }
1497         
1498         // Create new game data.
1499         games.length++;
1500         gameBets.length++;
1501         
1502         GameLogic.Instance storage game = games[games.length - 1];
1503         
1504         game.id = games.length - 1;
1505         game.openTime = _openTime;
1506         game.closeTime = _openTime + _duration - 1;
1507         game.duration = _duration;
1508         game.hiddenTimeBeforeClose = HIDDEN_TIME_BEFORE_CLOSE;
1509         game.claimTimeAfterClose = CLAIM_AWARD_TIME_AFTER_CLOSE
1510             | (CLAIM_REFUND_TIME_AFTER_CLOSE << 128);
1511         game.maximumFetchingTimeForEndExRate = MAX_FETCHING_TIME_FOR_END_EXRATE;
1512         
1513         game.coins[0].name = _coinName0;
1514         game.coins[1].name = _coinName1;
1515         game.coins[2].name = _coinName2;
1516         game.coins[3].name = _coinName3;
1517         game.coins[4].name = _coinName4;
1518         
1519         game.YDistribution = _YDistribution;
1520         game.A = _A;
1521         game.B = _B;
1522         game.txFee = _txFee;
1523         game.minDiffBets = _minDiffBets;
1524         game.isFinished = false;
1525         game.isYChoosed = false;
1526         
1527         emit GameCreated(game.id);
1528     }
1529     
1530     function gamePackedCommonData(uint256 _gameId)
1531         hasGameId(_gameId)
1532         public
1533         view
1534         returns (uint256 openTime
1535             , uint256 closeTime
1536             , uint256 duration
1537             , uint8[50] YDistribution
1538             , uint8 Y
1539             , uint8 A
1540             , uint8 B
1541             , uint8 state
1542             , uint8 winnerMasks
1543             , uint16 txFee
1544             , uint256 minDiffBets)
1545     {
1546         GameLogic.Instance storage game = games[_gameId];
1547         GameLogic.GameBets storage bets = gameBets[_gameId];
1548         
1549         openTime = game.openTime;
1550         closeTime = game.closeTime;
1551         duration = game.duration;
1552         YDistribution = game.YDistribution;
1553         Y = game.Y;
1554         A = game.A;
1555         B = game.B;
1556         state = uint8(GameLogic.state(game, bets));
1557         txFee = game.txFee;
1558         minDiffBets = game.minDiffBets;
1559         
1560         winnerMasks = gameWinnerMask(_gameId);
1561     }
1562     
1563     function gameWinnerMask(uint256 _gameId)
1564         hasGameId(_gameId)
1565         public
1566         view
1567         returns (uint8 winnerMasks)
1568     {
1569         GameLogic.Instance storage game = games[_gameId];
1570         
1571         winnerMasks = 0;
1572         for (_gameId = 0; _gameId < game.winnerCoinIds.length; ++_gameId) {
1573             winnerMasks |= uint8(1 << game.winnerCoinIds[_gameId]);
1574         }
1575     }
1576     
1577     
1578     function gameCoinData(uint256 _gameId, uint256 _coinId)
1579         hasGameId(_gameId)
1580         hasCoinId(_coinId)
1581         public 
1582         view 
1583         returns (string name, int32 startExRate, uint256 timeStampOfStartExRate
1584                  , int32 endExRate, uint256 timeStampOfEndExRate)
1585     {
1586         GameLogic.Instance storage game = games[_gameId];
1587         
1588         name = game.coins[_coinId].name;
1589         startExRate = int32(game.coins[_coinId].startExRate);
1590         timeStampOfStartExRate = game.coins[_coinId].timeStampOfStartExRate;
1591         endExRate = int32(game.coins[_coinId].endExRate);
1592         timeStampOfEndExRate = game.coins[_coinId].timeStampOfEndExRate;
1593     }
1594     
1595     function gamePackedCoinData(uint256 _gameId)
1596         hasGameId(_gameId)
1597         public 
1598         view 
1599         returns (bytes32[5] encodedName
1600             , uint256[5] timeStampOfStartExRate
1601             , uint256[5] timeStampOfEndExRate
1602             , int32[5] startExRate
1603             , int32[5] endExRate)
1604     {
1605         GameLogic.Instance storage game = games[_gameId];
1606         
1607         for (uint256 i = 0 ; i < 5; ++i) {
1608             encodedName[i] = GameLogic.encodeCoinName(game.coins[i].name);
1609             startExRate[i] = int32(game.coins[i].startExRate);
1610             timeStampOfStartExRate[i] = game.coins[i].timeStampOfStartExRate;
1611             endExRate[i] = int32(game.coins[i].endExRate);
1612             timeStampOfEndExRate[i] = game.coins[i].timeStampOfEndExRate;
1613         }
1614     }
1615     
1616     function gameBetData(uint256 _gameId, uint256 _coinId)
1617         hasGameId(_gameId)
1618         hasCoinId(_coinId)
1619         public 
1620         view 
1621         returns (uint256 totalBets, uint256 largestBets, uint256 numberOfBets)
1622     {
1623         GameLogic.Instance storage game = games[_gameId];
1624         GameLogic.GameBets storage bets = gameBets[_gameId];
1625         
1626         if (!GameLogic.isBetInformationHidden(game)) {
1627             GameLogic.CoinBets storage c = bets.coinbets[_coinId];
1628             totalBets = c.totalBetAmount;
1629             numberOfBets = c.bets.length;
1630             largestBets = c.largestBetAmount;
1631         }
1632     }
1633     
1634     function gamePackedBetData(uint256 _gameId)
1635         hasGameId(_gameId)
1636         public 
1637         view 
1638         returns (uint256[5] totalBets
1639             , uint256[5] largestBets
1640             , uint256[5] numberOfBets)
1641     {
1642         GameLogic.Instance storage game = games[_gameId];
1643         GameLogic.GameBets storage bets = gameBets[_gameId];
1644         
1645         for (uint256 i = 0; i < 5; ++i) {
1646             if (GameLogic.isBetInformationHidden(game)) {
1647                 totalBets[i] = largestBets[i] = numberOfBets[i] = 0;
1648             } else {
1649                 GameLogic.CoinBets storage c = bets.coinbets[i];
1650                 
1651                 totalBets[i] = c.totalBetAmount;
1652                 largestBets[i] = c.largestBetAmount;
1653                 numberOfBets[i] = c.bets.length;
1654             }
1655         }
1656     }
1657     
1658     function numberOfGames() public view returns (uint256) {
1659         return games.length;
1660     }
1661     
1662     function gameNumberOfWinnerCoinIds(uint256 _gameId) 
1663         hasGameId(_gameId)
1664         public 
1665         view 
1666         returns (uint256)
1667     {
1668         return games[_gameId].winnerCoinIds.length;
1669     }
1670     
1671     function gameWinnerCoinIds(uint256 _gameId, uint256 _winnerId) 
1672         hasGameId(_gameId)
1673         public
1674         view
1675         returns (uint256)
1676     {
1677         GameLogic.Instance storage game = games[_gameId];
1678         require(_winnerId < game.winnerCoinIds.length);
1679         
1680         return game.winnerCoinIds[_winnerId];
1681     }
1682     
1683     function gameState(uint256 _gameId) public view returns (GameLogic.State) {
1684         if (_gameId < games.length) {
1685             return GameLogic.state(games[_gameId], gameBets[_gameId]);
1686         } else {
1687             return GameLogic.State.NotExists;
1688         }
1689     }
1690     
1691     function isBetInformationHidden(uint256 _gameId) 
1692         hasGameId(_gameId)
1693         public
1694         view
1695         returns (bool)
1696     {
1697         return GameLogic.isBetInformationHidden(games[_gameId]);
1698     }
1699     
1700     function bet(uint256 _gameId, uint256 _coinId) 
1701         hasGameId(_gameId)
1702         hasCoinId(_coinId)
1703         public 
1704         payable
1705     {
1706         require(msg.value >= MIN_BET);
1707         
1708         GameLogic.Instance storage game = games[_gameId];
1709         GameLogic.GameBets storage bets = gameBets[_gameId];
1710         
1711         GameLogic.bet(game, bets, _coinId, txFeeReceiver);
1712     }
1713     
1714     function fetchStartExRate(uint256 _gameId) 
1715         hasGameId(_gameId)
1716         onlyOwner
1717         public
1718     {
1719         // Check the game state.
1720         GameLogic.Instance storage game = games[_gameId];
1721         require(GameLogic.state(game, gameBets[_gameId]) == GameLogic.State.Created);
1722         
1723         // Check the tx fee amount.
1724         require(address(this).balance >= oraclizeFee);
1725         
1726         // Query all start exchange rate.
1727         string memory url;
1728         bytes32 queryId;
1729         
1730         for (uint256 i = 0; i < 5; ++i) {
1731             url = strConcat("json(https://api.binance.com/api/v3/ticker/price?symbol=", game.coins[i].name, "USDT).price");
1732             queryId = _doOraclizeQuery(url);
1733             queryRecords[queryId] = QueryRecord(RecordType.StartExRate, game.id, i);
1734         }
1735     }    
1736     
1737     function fetchEndExRate(uint256 _gameId) 
1738         hasGameId(_gameId)
1739         onlyOwner
1740         public 
1741     {
1742         // Check the game state.
1743         GameLogic.Instance storage game = games[_gameId];
1744         require(GameLogic.state(game, gameBets[_gameId]) == GameLogic.State.Stop);
1745         
1746         // Check the tx fee amount.
1747         require(address(this).balance >= oraclizeFee);
1748         
1749         // Query all end exchange rate.
1750         string memory url;
1751         bytes32 queryId;
1752         
1753         for (uint256 i = 0; i < 5; ++i) {
1754             url = strConcat("json(https://api.binance.com/api/v3/ticker/price?symbol=", game.coins[i].name, "USDT).price");
1755             queryId = _doOraclizeQuery(url);
1756             queryRecords[queryId] = QueryRecord(RecordType.EndExRate, game.id, i);
1757         }
1758         
1759         // Query rand y.
1760         queryId = _doOraclizeQuery("https://www.random.org/integers/?num=1&min=0&max=49&col=1&base=10&format=plain&rnd=new");
1761         queryRecords[queryId] = QueryRecord(RecordType.RandY, game.id, 0);
1762     }
1763     
1764     function close(uint256 _gameId) 
1765         hasGameId(_gameId)
1766         onlyOwner 
1767         public
1768         returns (bool)
1769     {
1770         GameLogic.Instance storage game = games[_gameId];
1771         GameLogic.GameBets storage bets = gameBets[_gameId];
1772             
1773         require(GameLogic.state(game, bets) == GameLogic.State.WaitToClose);
1774         
1775         if (0 != bets.totalAwards) {
1776             GameLogic.tryClose(game, bets);
1777         }
1778 
1779         if (game.isFinished) {
1780             GameLogic.calculateAwardForCoin(game, bets, bets.totalAwards);
1781             emit GameClosed(_gameId);
1782         } else {
1783             game.Y = 0;
1784             game.isYChoosed = false;
1785             game.coins[0].endExRate = 0;
1786             game.coins[1].endExRate = 0;
1787             game.coins[2].endExRate = 0;
1788             game.coins[3].endExRate = 0;
1789             game.coins[4].endExRate = 0;
1790             game.coins[0].timeStampOfEndExRate = 0;
1791             game.coins[1].timeStampOfEndExRate = 0;
1792             game.coins[2].timeStampOfEndExRate = 0;
1793             game.coins[3].timeStampOfEndExRate = 0;
1794             game.coins[4].timeStampOfEndExRate = 0;
1795             
1796             // ((now - open) / duration + 1) * duration + open - 1;
1797             game.closeTime = now.sub(game.openTime).div(game.duration).add(1).mul(game.duration).add(game.openTime).sub(1);
1798             emit GameExtended(_gameId, game.closeTime);
1799         }
1800         
1801         return game.isFinished;
1802     }
1803     
1804     function calculateAwardAmount(uint256 _gameId) 
1805         hasGameId(_gameId)
1806         public
1807         view
1808         returns (uint256)
1809     {
1810         GameLogic.State queryGameState = gameState(_gameId);
1811         if (GameLogic.State.Closed == queryGameState) {
1812             GameLogic.Instance storage game = games[_gameId];
1813             GameLogic.GameBets storage bets = gameBets[_gameId];
1814         
1815             return GameLogic.calculateAwardAmount(game, bets);
1816         } else {
1817             return 0;
1818         }
1819     }
1820     
1821     function calculateRefund(uint256 _gameId) 
1822         hasGameId(_gameId)
1823         public
1824         view
1825         returns (uint256)
1826     {
1827         GameLogic.State queryGameState = gameState(_gameId);
1828         if (GameLogic.State.Error == queryGameState) {
1829             GameLogic.Instance storage game = games[_gameId];
1830             GameLogic.GameBets storage bets = gameBets[_gameId];
1831         
1832             return GameLogic.calculateRefundAmount(game, bets);
1833         } else {
1834             return 0;
1835         }
1836     }
1837     
1838     function getAwards(uint256 _gameId) hasGameId(_gameId) public {
1839         uint256 amount = calculateAwardAmount(_gameId);
1840         if (0 < amount) {
1841             GameLogic.GameBets storage bets = gameBets[_gameId];
1842             require(bets.totalAwards.sub(bets.claimedAwards) >= amount);
1843             
1844             bets.isAwardTransfered[msg.sender] = true;
1845             bets.claimedAwards = bets.claimedAwards.add(amount);
1846             
1847             msg.sender.transfer(amount);
1848             emit SendAwards(_gameId, msg.sender, amount);
1849         }
1850     }
1851     
1852     function claimRefunds(uint256 _gameId) hasGameId(_gameId) public {
1853         uint256 amount = calculateRefund(_gameId);
1854         if (0 < amount) {
1855             GameLogic.GameBets storage bets = gameBets[_gameId];
1856             
1857             bets.isRefunded[msg.sender] = true;
1858             bets.claimedRefunds = bets.claimedRefunds.add(amount);
1859             
1860             msg.sender.transfer(amount);
1861             emit RefundClaimed(_gameId, msg.sender, amount);
1862         }
1863     }
1864     
1865     function withdrawOraclizeFee() public onlyOwner {
1866         require(address(this).balance >= oraclizeFee);
1867         uint256 amount = oraclizeFee;
1868         oraclizeFee = 0;
1869         owner().transfer(amount);
1870     }
1871     
1872     function getUnclaimedAward(uint256 _gameId) 
1873         hasGameId(_gameId) 
1874         onlyOwner 
1875         public
1876     {
1877         GameLogic.Instance storage game = games[_gameId];
1878         require(GameLogic.endTimeOfAwardsClaiming(game) < now);
1879         
1880         GameLogic.GameBets storage bets = gameBets[_gameId];
1881         
1882         uint256 amount = bets.totalAwards.sub(bets.claimedAwards);
1883         bets.claimedAwards = bets.totalAwards;
1884         
1885         owner().transfer(amount);
1886         emit GetUnclaimedAwards(_gameId, owner(), amount);
1887     }
1888     
1889     function getUnclaimedRefunds(uint256 _gameId) 
1890         hasGameId(_gameId) 
1891         onlyOwner 
1892         public
1893     {
1894         GameLogic.Instance storage game = games[_gameId];
1895         require(GameLogic.endTimeOfRefundsClaiming(game) < now);
1896         
1897         GameLogic.GameBets storage bets = gameBets[_gameId];
1898         
1899         uint256 amount = bets.totalAwards.sub(bets.claimedRefunds);
1900         bets.claimedRefunds = bets.totalAwards;
1901         
1902         owner().transfer(amount);
1903         emit GetUnclaimedRefunds(_gameId, owner(), amount);
1904     }
1905     
1906     function sendOraclizeFee() public payable {
1907         oraclizeFee = oraclizeFee.add(msg.value);
1908         emit OraclizeFeeReceived(msg.value);
1909     }
1910     
1911     function () public payable {
1912         sendOraclizeFee();
1913     }
1914     
1915     // Callback for oraclize query.
1916     function __callback(bytes32 _id, string _result) public {
1917         assert(msg.sender == oraclize_cbAddress());
1918         
1919         uint256 gameId = queryRecords[_id].gameId;
1920         GameLogic.Instance storage game = games[gameId];
1921         GameLogic.GameBets storage gameBet = gameBets[gameId];
1922         
1923         if (RecordType.RandY == queryRecords[_id].recordType) {
1924             if (now <= game.closeTime.add(game.maximumFetchingTimeForEndExRate)) {
1925                 game.Y = game.YDistribution[parseInt(_result)];
1926                 game.isYChoosed = true;
1927                 delete queryRecords[_id];
1928                 emit GameYChoosed(gameId, game.Y);
1929             
1930                 if (GameLogic.state(game, gameBet) == GameLogic.State.WaitToClose) {
1931                     emit GameWaitToClose(gameId);
1932                 }   
1933             } else {
1934                 delete queryRecords[_id];
1935             }
1936             
1937         } else {
1938             uint256 coinId = queryRecords[_id].arg;
1939             if (RecordType.StartExRate == queryRecords[_id].recordType) {
1940                 if (now <= game.closeTime) {
1941                     game.coins[coinId].startExRate = int256(parseInt(_result, 5));
1942                     game.coins[coinId].timeStampOfStartExRate = now;
1943                     
1944                     delete queryRecords[_id];
1945                     emit StartExRateUpdated(gameId, coinId, int32(game.coins[coinId].startExRate), now);
1946                 
1947                     if (GameLogic.state(game, gameBet) == GameLogic.State.Ready) {
1948                         emit GameReady(gameId);
1949                     } else if (GameLogic.state(game, gameBet) == GameLogic.State.Open) {
1950                         emit GameOpened(gameId);
1951                     }
1952                 } else {
1953                     delete queryRecords[_id];
1954                 }
1955             } else if (RecordType.EndExRate == queryRecords[_id].recordType) {
1956                 if (now <= game.closeTime.add(game.maximumFetchingTimeForEndExRate)) {
1957                     game.coins[coinId].endExRate = int256(parseInt(_result, 5));
1958                     game.coins[coinId].timeStampOfEndExRate = now;
1959                     delete queryRecords[_id];
1960                     emit EndExRateUpdated(gameId, coinId, int32(game.coins[coinId].endExRate), now);
1961                 
1962                     if (GameLogic.state(game, gameBet) == GameLogic.State.WaitToClose) {
1963                         emit GameWaitToClose(gameId);
1964                     }
1965                 } else {
1966                     delete queryRecords[_id];
1967                 }
1968             } else {
1969                 revert();
1970             }
1971         }
1972     }
1973     
1974     function _doOraclizeQuery(string url) private returns (bytes32) {
1975         uint256 fee = oraclize_getPrice("URL", ORICALIZE_GAS_LIMIT);
1976         require(fee <= oraclizeFee);
1977         oraclizeFee = oraclizeFee.sub(fee);
1978         
1979         bytes32 queryId = oraclize_query("URL", url, ORICALIZE_GAS_LIMIT);
1980         
1981         emit OraclizeFeeUsed(fee);
1982         emit SentOraclizeQuery(queryId);
1983         
1984         return queryId;
1985     }
1986 }
1987 library GameLogic {
1988     using SafeMath for uint256;
1989 
1990     enum State { NotExists, Created, Ready, Open, Stop, WaitToClose, Closed, Error }
1991     enum CompareResult { Equal, Less, Greater }
1992 
1993     struct Bets {
1994         uint256 betAmount;
1995         uint256 totalBetAmountByFar;
1996     }
1997 
1998     struct Coin {
1999         string name;
2000         int256 startExRate;
2001         uint256 timeStampOfStartExRate;
2002         int256 endExRate;
2003         uint256 timeStampOfEndExRate;
2004     }
2005 
2006     struct CoinBets {
2007         uint256 largestBetAmount;
2008         uint256 numberOfLargestBetTx;
2009         uint256 totalBetAmount;
2010         Bets[] bets;
2011         mapping (address => uint256[]) playerBetMap;
2012         uint256 yThreshold;
2013         uint256 awardAmountBeforeY;
2014         uint256 awardAmountAfterY;
2015         uint256 awardAmountForLargestBetPlayers;
2016         uint256 totalBetAmountBeforeY;
2017         uint256 totalBetAmountAfterY;
2018     }
2019 
2020     struct Instance {
2021         uint256 id;
2022         
2023         uint256 openTime;
2024         uint256 closeTime;
2025         uint256 duration;
2026         uint256 hiddenTimeBeforeClose;
2027         uint256 claimTimeAfterClose;    // [0~127] award, [128~255]refunds
2028         uint256 maximumFetchingTimeForEndExRate;
2029         
2030         uint8[50] YDistribution;
2031         uint8 Y;
2032         uint8 A;
2033         uint8 B;
2034         uint16 txFee;
2035         bool isFinished;
2036         bool isYChoosed;
2037         uint256 minDiffBets;
2038         
2039         uint256[] winnerCoinIds;
2040         
2041         Coin[5] coins;
2042     }
2043 
2044     struct GameBets {
2045         CoinBets[5] coinbets;
2046         mapping (address => bool) isAwardTransfered;
2047         mapping (address => bool) isRefunded;
2048         uint256 totalAwards;
2049         uint256 claimedAwards;
2050         uint256 claimedRefunds;
2051     }
2052     
2053     event CoinBet(uint256 indexed gameId, uint256 coinId, address player, uint256 amount);
2054     event CoinLargestBetChanged(uint256 indexed gameId, uint256 coinId, uint256 amount);
2055     event SendTxFee(address receiver, uint256 feeAmount);
2056 
2057     function isEndExRateAndYFetched(Instance storage game) 
2058         public
2059         view
2060         returns (bool)
2061     {
2062         return (0 != game.coins[0].endExRate && 
2063                 0 != game.coins[1].endExRate &&
2064                 0 != game.coins[2].endExRate &&
2065                 0 != game.coins[3].endExRate &&
2066                 0 != game.coins[4].endExRate &&
2067                 game.isYChoosed);
2068     }
2069 
2070     function isStartExRateFetched(Instance storage game) 
2071         public
2072         view
2073         returns (bool)
2074     {
2075         return (0 != game.coins[0].startExRate && 
2076                 0 != game.coins[1].startExRate &&
2077                 0 != game.coins[2].startExRate &&
2078                 0 != game.coins[3].startExRate &&
2079                 0 != game.coins[4].startExRate);
2080     }
2081 
2082     function state(Instance storage game, GameBets storage bets) 
2083         public 
2084         view 
2085         returns (State)
2086     {
2087         if (game.isFinished) {
2088             return State.Closed;
2089         } else if (now > game.closeTime.add(game.maximumFetchingTimeForEndExRate)) {
2090             if (!isEndExRateAndYFetched(game)) {
2091                 return State.Error;
2092             } else {
2093                 return State.WaitToClose;
2094             }
2095         } else if (now > game.closeTime) {
2096             if (!isStartExRateFetched(game)) {
2097                 return State.Error;
2098             } else if (isEndExRateAndYFetched(game) || 0 == bets.totalAwards) {
2099                 return State.WaitToClose;
2100             } else {
2101                 return State.Stop;
2102             }
2103         } else {
2104             if (isStartExRateFetched(game)) {
2105                 if (now >= game.openTime) {
2106                     return State.Open;
2107                 } else {
2108                     return State.Ready;
2109                 }
2110             } else {
2111                 return State.Created;
2112             }
2113         }
2114     }
2115 
2116     function tryClose(Instance storage game, GameBets storage bets)
2117         public 
2118         returns (bool) 
2119     {
2120         require(state(game, bets) == State.WaitToClose);
2121         
2122         uint256 largestIds = 0;
2123         uint256 smallestIds = 0;
2124         uint256 otherIds = 0;
2125         
2126         uint256 i = 0;
2127         CompareResult result;
2128         for (; i < 5; ++i) {
2129             // Remove the orphan coins which no one has bet.
2130             if (bets.coinbets[i].totalBetAmount == 0) {
2131                 continue;
2132             }
2133             
2134             // Compare with the largest coin id.
2135             if (0 == (largestIds & 0x7)) {
2136                 largestIds = i + 1;
2137                 continue;
2138             } else {
2139                 result = compare(game.coins[(largestIds & 0x7) - 1], game.coins[i]);
2140                 if (CompareResult.Equal == result) {
2141                     largestIds = pushToLargestOrSmallestIds(bets, largestIds, i);
2142                     continue;
2143                 } else if (CompareResult.Less == result) {
2144                     if (0 == (smallestIds & 0x7)) {
2145                         smallestIds = largestIds;
2146                     } else {
2147                         otherIds = pushToOtherIds(bets, otherIds, largestIds);
2148                     }
2149                     
2150                     largestIds = i + 1;
2151                     continue;
2152                 }
2153             }
2154             
2155             // Compare with the smallest coin id.
2156             if (0 == (smallestIds & 0x7)) {
2157                 smallestIds = i + 1;
2158                 continue;
2159             } else {
2160                 result = compare(game.coins[(smallestIds & 0x7) - 1], game.coins[i]);
2161                 if (CompareResult.Equal == result) {
2162                     smallestIds = pushToLargestOrSmallestIds(bets, smallestIds, i);
2163                     continue;
2164                 } else if (CompareResult.Greater == result) {
2165                     if (0 == (largestIds & 0x7)) {
2166                         largestIds = smallestIds;
2167                     } else {
2168                         otherIds = pushToOtherIds(bets, otherIds, smallestIds);
2169                     }
2170                         
2171                     smallestIds = i + 1;
2172                     continue;
2173                 }
2174             }
2175             
2176             // Assign to 'other' group.
2177             otherIds = pushToOtherIds(bets, otherIds, i + 1);
2178         }
2179         
2180         // Choose winners.
2181         require(otherIds < 512);
2182         
2183         if (smallestIds == 0) {
2184             if (largestIds != 0) {
2185                 game.isFinished = true;
2186                 convertTempIdsToWinnerIds(game, largestIds);
2187                 return true;
2188             } else {
2189                 return false;
2190             }
2191         }
2192         
2193         i = bets.coinbets[(largestIds & 0x7) - 1].largestBetAmount;
2194         uint256 j = bets.coinbets[(smallestIds & 0x7) - 1].largestBetAmount;
2195         
2196         // Compare largest and smallest group.
2197         if (i > j.add(game.minDiffBets)) {
2198             game.isFinished = true;
2199             convertTempIdsToWinnerIds(game, largestIds);
2200         } else if (j > i.add(game.minDiffBets)) {
2201             game.isFinished = true;
2202             convertTempIdsToWinnerIds(game, smallestIds);
2203         } else {
2204             // Compare other group.
2205             if (otherIds < 8 && otherIds != 0) {
2206                 // sole winner.
2207                 game.isFinished = true;
2208                 convertTempIdsToWinnerIds(game, otherIds);
2209             } else if (otherIds >= 8) {
2210 				// compare.
2211 				i = bets.coinbets[(otherIds & 0x7) - 1].totalBetAmount;
2212 				j = bets.coinbets[((otherIds >> 3) & 0x7) - 1].totalBetAmount;
2213 
2214 				if (i > j + game.minDiffBets) {
2215 					game.isFinished = true;
2216 					convertTempIdsToWinnerIds(game, otherIds & 0x7);
2217 				} 
2218 			}
2219         }
2220         
2221         return game.isFinished;
2222     }
2223 
2224     function bet(Instance storage game, GameBets storage gameBets, uint256 coinId, address txFeeReceiver)
2225         public 
2226     {
2227         require(coinId < 5);
2228         require(state(game, gameBets) == State.Open);
2229         require(address(0) != txFeeReceiver && address(this) != txFeeReceiver);
2230         
2231         uint256 txFeeAmount = msg.value.mul(game.txFee).div(1000);
2232         if (0 < txFeeAmount) {
2233             txFeeReceiver.transfer(txFeeAmount);
2234             emit SendTxFee(txFeeReceiver, txFeeAmount);
2235         }
2236         
2237         CoinBets storage c = gameBets.coinbets[coinId];
2238         
2239         c.bets.length++;
2240         Bets storage b = c.bets[c.bets.length - 1];
2241         b.betAmount = msg.value.sub(txFeeAmount);
2242         
2243         c.totalBetAmount = b.betAmount.add(c.totalBetAmount);
2244         b.totalBetAmountByFar = c.totalBetAmount;
2245         gameBets.totalAwards =  gameBets.totalAwards.add(b.betAmount);
2246         
2247         c.playerBetMap[msg.sender].push(c.bets.length - 1);
2248         
2249         if (b.betAmount > c.largestBetAmount) {
2250             c.largestBetAmount = b.betAmount;
2251             c.numberOfLargestBetTx = 1;
2252             
2253             emit CoinLargestBetChanged(game.id, coinId, b.betAmount);
2254             
2255         } else if (b.betAmount == c.largestBetAmount) {
2256             ++c.numberOfLargestBetTx;
2257         }
2258         
2259         emit CoinBet(game.id, coinId, msg.sender, b.betAmount);
2260     }
2261 
2262     function isBetInformationHidden(Instance storage game) 
2263         public 
2264         view 
2265         returns (bool)
2266     {
2267         return now <= game.closeTime 
2268             && now.add(game.hiddenTimeBeforeClose) > game.closeTime;
2269     }
2270 
2271     function calculateAwardForCoin(Instance storage game
2272         , GameBets storage bets
2273         , uint256 awardAmount
2274     ) 
2275         public
2276     {
2277         require(state(game, bets) == State.Closed);
2278         awardAmount = awardAmount.div(game.winnerCoinIds.length);
2279         
2280         for (uint256 i = 0; i < game.winnerCoinIds.length; ++i) {
2281             CoinBets storage c = bets.coinbets[game.winnerCoinIds[i]];
2282             require(c.bets.length > 0);
2283             
2284             c.yThreshold = c.bets.length.mul(uint256(game.Y)).div(100);
2285             if (c.yThreshold.mul(100) < c.bets.length.mul(uint256(game.Y))) {
2286                 ++c.yThreshold;
2287             }
2288             
2289             c.awardAmountAfterY = awardAmount.mul(game.B).div(100);
2290            
2291             if (c.yThreshold == 0) {
2292                 c.awardAmountBeforeY = 0;
2293                 c.totalBetAmountBeforeY = 0;
2294             } else if (c.bets.length == 1) {
2295                 c.awardAmountBeforeY = awardAmount;
2296                 c.awardAmountAfterY = 0;
2297                 c.totalBetAmountBeforeY = c.totalBetAmount;
2298             } else {
2299                 c.awardAmountBeforeY = awardAmount.mul(game.A).div(100);
2300                 c.totalBetAmountBeforeY = c.bets[c.yThreshold - 1].totalBetAmountByFar;
2301             }
2302             
2303             c.awardAmountForLargestBetPlayers = awardAmount
2304                 .sub(c.awardAmountBeforeY)
2305                 .sub(c.awardAmountAfterY)
2306                 .div(c.numberOfLargestBetTx);
2307             
2308             c.totalBetAmountAfterY = c.totalBetAmount.sub(c.totalBetAmountBeforeY);
2309         }
2310     }
2311 
2312     function calculateAwardAmount(Instance storage game, GameBets storage bets)
2313         public 
2314         view 
2315         returns (uint256 amount)
2316     {
2317         require(state(game, bets) == State.Closed);
2318         require(0 < game.winnerCoinIds.length);
2319         
2320         if (bets.isAwardTransfered[msg.sender]) {
2321             return 0;
2322         } else if (endTimeOfAwardsClaiming(game) < now) {
2323             return 0;
2324         }
2325     
2326         amount = 0;
2327         
2328         for (uint256 i = 0; i < game.winnerCoinIds.length; ++i) {
2329             CoinBets storage c = bets.coinbets[game.winnerCoinIds[i]];
2330             uint256[] storage betIdList = c.playerBetMap[msg.sender];
2331             
2332             for (uint256 j = 0; j < betIdList.length; ++j) {
2333                 Bets storage b = c.bets[betIdList[j]];
2334                 if (betIdList[j] < c.yThreshold) {
2335                     amount = amount.add(
2336                         c.awardAmountBeforeY.mul(b.betAmount).div(c.totalBetAmountBeforeY));
2337                 } else {
2338                     amount = amount.add(
2339                         c.awardAmountAfterY.mul(b.betAmount).div(c.totalBetAmountAfterY));
2340                 }
2341                 
2342                 if (b.betAmount == c.largestBetAmount) {
2343                     amount = amount.add(c.awardAmountForLargestBetPlayers);
2344                 }
2345             }
2346         }
2347     }
2348 
2349     function calculateRefundAmount(Instance storage game, GameBets storage bets)
2350         public 
2351         view 
2352         returns (uint256 amount)
2353     {
2354         require(state(game, bets) == State.Error);
2355         amount = 0;
2356         
2357         if (bets.isRefunded[msg.sender]) {
2358             return 0;
2359         } else if (endTimeOfRefundsClaiming(game) < now) {
2360             return 0;
2361         }
2362         
2363         for (uint256 i = 0; i < 5; ++i) {
2364             CoinBets storage c = bets.coinbets[i];
2365             uint256[] storage betIdList = c.playerBetMap[msg.sender];
2366             
2367             for (uint256 j = 0; j < betIdList.length; ++j) {
2368                 Bets storage b = c.bets[betIdList[j]];
2369                 amount = amount.add(b.betAmount);
2370             }
2371         }
2372     }
2373 
2374     function compare(Coin storage coin0, Coin storage coin1) 
2375         public
2376         view
2377         returns (CompareResult)
2378     {
2379         int256 value0 = (coin0.endExRate - coin0.startExRate) * coin1.startExRate;
2380         int256 value1 = (coin1.endExRate - coin1.startExRate) * coin0.startExRate;
2381         
2382         if (value0 == value1) {
2383             return CompareResult.Equal;
2384         } else if (value0 < value1) {
2385             return CompareResult.Less;
2386         } else {
2387             return CompareResult.Greater;
2388         }
2389     }
2390 
2391     function pushToLargestOrSmallestIds(GameBets storage bets
2392         , uint256 currentIds
2393         , uint256 newId
2394     )
2395         public
2396         view
2397         returns (uint256)
2398     {
2399         require(currentIds < 2048); // maximum capacity is 5.
2400     
2401         if (currentIds == 0) {
2402             return newId + 1;
2403         } else {
2404             uint256 id = (currentIds & 0x7) - 1;
2405             if (bets.coinbets[newId].largestBetAmount >= bets.coinbets[id].largestBetAmount) {
2406                 return (currentIds << 3) | (newId + 1);
2407             } else {
2408                 return (id + 1) | (pushToLargestOrSmallestIds(bets, currentIds >> 3, newId) << 3);
2409             }
2410         }
2411     }
2412 
2413     function pushToOtherIds(GameBets storage bets, uint256 currentIds, uint256 newIds)
2414         public
2415         view
2416         returns (uint256)
2417     {
2418         require(currentIds < 2048);
2419         require(newIds < 2048 && newIds > 0);
2420     
2421         if (newIds >= 8) {
2422             return pushToOtherIds(bets
2423                 , pushToOtherIds(bets, currentIds, newIds >> 3)
2424                 , newIds & 0x7);
2425         } else {
2426             if (currentIds == 0) {
2427                 return newIds;
2428             } else {
2429                 uint256 id = (currentIds & 0x7) - 1;
2430                 if (bets.coinbets[newIds - 1].totalBetAmount >= bets.coinbets[id].totalBetAmount) {
2431                     return (currentIds << 3) | newIds;
2432                 } else {
2433                     return (id + 1) | (pushToOtherIds(bets, currentIds >> 3, newIds) << 3);
2434                 }
2435             }
2436         }
2437     }
2438 
2439     function convertTempIdsToWinnerIds(Instance storage game, uint256 ids) public
2440     {
2441         if (ids > 0) {
2442             game.winnerCoinIds.push((ids & 0x7) - 1);
2443             convertTempIdsToWinnerIds(game, ids >> 3);
2444         }
2445     }
2446 
2447     function utf8ToUint(byte char) public pure returns (uint256) {
2448         uint256 utf8Num = uint256(char);
2449         if (utf8Num > 47 && utf8Num < 58) {
2450             return utf8Num;
2451         } else if (utf8Num > 64 && utf8Num < 91) {
2452             return utf8Num;
2453         } else {
2454             revert();
2455         }
2456     }
2457 
2458     function encodeCoinName(string str) pure public returns (bytes32) {
2459         bytes memory bString = bytes(str);
2460         require(bString.length <= 32);
2461         
2462         uint256 retVal = 0;
2463         uint256 offset = 248;
2464         for (uint256 i = 0; i < bString.length; ++i) {
2465             retVal |= utf8ToUint(bString[i]) << offset;
2466             offset -= 8;
2467         }
2468         return bytes32(retVal);
2469     }
2470     
2471     function endTimeOfAwardsClaiming(Instance storage game) 
2472         view 
2473         public 
2474         returns (uint256)
2475     {
2476         return game.closeTime.add(game.claimTimeAfterClose & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
2477     }
2478     
2479     function endTimeOfRefundsClaiming(Instance storage game) 
2480         view 
2481         public 
2482         returns (uint256)
2483     {
2484         return  game.closeTime.add(game.claimTimeAfterClose >> 128);
2485     }
2486 }