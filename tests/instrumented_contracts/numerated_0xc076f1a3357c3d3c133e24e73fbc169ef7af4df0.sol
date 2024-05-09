1 pragma solidity ^0.5.0;
2 
3 interface IERC20 {
4   function totalSupply() external view returns (uint256);
5 
6   function balanceOf(address who) external view returns (uint256);
7 
8   function allowance(address owner, address spender)
9     external view returns (uint256);
10 
11   function transfer(address to, uint256 value) external returns (bool);
12 
13   function approve(address spender, uint256 value)
14     external returns (bool);
15 
16   function transferFrom(address from, address to, uint256 value)
17     external returns (bool);
18 
19   event Transfer(
20     address indexed from,
21     address indexed to,
22     uint256 value
23   );
24 
25   event Approval(
26     address indexed owner,
27     address indexed spender,
28     uint256 value
29   );
30 }
31 
32 contract Owned {
33     address public owner;
34     address public newOwner;
35     modifier onlyOwner {
36         require(msg.sender == owner);
37         _;
38     }
39     function transferOwnership(address _newOwner) public onlyOwner {
40         newOwner = _newOwner;
41     }
42     function acceptOwnership() public {
43         require(msg.sender == newOwner);
44         owner = newOwner;
45     }
46 }
47 
48 library SafeMath {
49 
50   /**
51   * @dev Multiplies two numbers, reverts on overflow.
52   */
53   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
55     // benefit is lost if 'b' is also tested.
56     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
57     if (a == 0) {
58       return 0;
59     }
60 
61     uint256 c = a * b;
62     require(c / a == b);
63 
64     return c;
65   }
66 
67   /**
68   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
69   */
70   function div(uint256 a, uint256 b) internal pure returns (uint256) {
71     require(b > 0); // Solidity only automatically asserts when dividing by 0
72     uint256 c = a / b;
73     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74 
75     return c;
76   }
77 
78   /**
79   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
80   */
81   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82     require(b <= a);
83     uint256 c = a - b;
84 
85     return c;
86   }
87 
88   /**
89   * @dev Adds two numbers, reverts on overflow.
90   */
91   function add(uint256 a, uint256 b) internal pure returns (uint256) {
92     uint256 c = a + b;
93     require(c >= a);
94 
95     return c;
96   }
97 
98   /**
99   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
100   * reverts when dividing by zero.
101   */
102   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
103     require(b != 0);
104     return a % b;
105   }
106 }
107 
108 /*
109 
110 ORACLIZE_API
111 
112 Copyright (c) 2015-2016 Oraclize SRL
113 Copyright (c) 2016 Oraclize LTD
114 
115 Permission is hereby granted, free of charge, to any person obtaining a copy
116 of this software and associated documentation files (the "Software"), to deal
117 in the Software without restriction, including without limitation the rights
118 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
119 copies of the Software, and to permit persons to whom the Software is
120 furnished to do so, subject to the following conditions:
121 
122 The above copyright notice and this permission notice shall be included in
123 all copies or substantial portions of the Software.
124 
125 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
126 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
127 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
128 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
129 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
130 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
131 THE SOFTWARE.
132 
133 */
134 contract OraclizeI {
135 
136     address public cbAddress;
137 
138     function setProofType(byte _proofType) external;
139     function setCustomGasPrice(uint _gasPrice) external;
140     function getPrice(string memory _datasource) public returns (uint _dsprice);
141     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
142     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
143     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
144     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
145     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
146     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
147     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
148     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
149 }
150 contract OraclizeAddrResolverI {
151     function getAddress() public returns (address _address);
152 }
153 /*
154 
155 Begin solidity-cborutils
156 
157 https://github.com/smartcontractkit/solidity-cborutils
158 
159 MIT License
160 
161 Copyright (c) 2018 SmartContract ChainLink, Ltd.
162 
163 Permission is hereby granted, free of charge, to any person obtaining a copy
164 of this software and associated documentation files (the "Software"), to deal
165 in the Software without restriction, including without limitation the rights
166 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
167 copies of the Software, and to permit persons to whom the Software is
168 furnished to do so, subject to the following conditions:
169 
170 The above copyright notice and this permission notice shall be included in all
171 copies or substantial portions of the Software.
172 
173 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
174 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
175 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
176 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
177 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
178 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
179 SOFTWARE.
180 
181 */
182 library Buffer {
183 
184     struct buffer {
185         bytes buf;
186         uint capacity;
187     }
188 
189     function init(buffer memory _buf, uint _capacity) internal pure {
190         uint capacity = _capacity;
191         if (capacity % 32 != 0) {
192             capacity += 32 - (capacity % 32);
193         }
194         _buf.capacity = capacity; // Allocate space for the buffer data
195         assembly {
196             let ptr := mload(0x40)
197             mstore(_buf, ptr)
198             mstore(ptr, 0)
199             mstore(0x40, add(ptr, capacity))
200         }
201     }
202 
203     function resize(buffer memory _buf, uint _capacity) private pure {
204         bytes memory oldbuf = _buf.buf;
205         init(_buf, _capacity);
206         append(_buf, oldbuf);
207     }
208 
209     function max(uint _a, uint _b) private pure returns (uint _max) {
210         if (_a > _b) {
211             return _a;
212         }
213         return _b;
214     }
215     /**
216       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
217       *      would exceed the capacity of the buffer.
218       * @param _buf The buffer to append to.
219       * @param _data The data to append.
220       * @return The original buffer.
221       *
222       */
223     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
224         if (_data.length + _buf.buf.length > _buf.capacity) {
225             resize(_buf, max(_buf.capacity, _data.length) * 2);
226         }
227         uint dest;
228         uint src;
229         uint len = _data.length;
230         assembly {
231             let bufptr := mload(_buf) // Memory address of the buffer data
232             let buflen := mload(bufptr) // Length of existing buffer data
233             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
234             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
235             src := add(_data, 32)
236         }
237         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
238             assembly {
239                 mstore(dest, mload(src))
240             }
241             dest += 32;
242             src += 32;
243         }
244         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
245         assembly {
246             let srcpart := and(mload(src), not(mask))
247             let destpart := and(mload(dest), mask)
248             mstore(dest, or(destpart, srcpart))
249         }
250         return _buf;
251     }
252     /**
253       *
254       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
255       * exceed the capacity of the buffer.
256       * @param _buf The buffer to append to.
257       * @param _data The data to append.
258       * @return The original buffer.
259       *
260       */
261     function append(buffer memory _buf, uint8 _data) internal pure {
262         if (_buf.buf.length + 1 > _buf.capacity) {
263             resize(_buf, _buf.capacity * 2);
264         }
265         assembly {
266             let bufptr := mload(_buf) // Memory address of the buffer data
267             let buflen := mload(bufptr) // Length of existing buffer data
268             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
269             mstore8(dest, _data)
270             mstore(bufptr, add(buflen, 1)) // Update buffer length
271         }
272     }
273     /**
274       *
275       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
276       * exceed the capacity of the buffer.
277       * @param _buf The buffer to append to.
278       * @param _data The data to append.
279       * @return The original buffer.
280       *
281       */
282     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
283         if (_len + _buf.buf.length > _buf.capacity) {
284             resize(_buf, max(_buf.capacity, _len) * 2);
285         }
286         uint mask = 256 ** _len - 1;
287         assembly {
288             let bufptr := mload(_buf) // Memory address of the buffer data
289             let buflen := mload(bufptr) // Length of existing buffer data
290             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
291             mstore(dest, or(and(mload(dest), not(mask)), _data))
292             mstore(bufptr, add(buflen, _len)) // Update buffer length
293         }
294         return _buf;
295     }
296 }
297 library CBOR {
298 
299     using Buffer for Buffer.buffer;
300 
301     uint8 private constant MAJOR_TYPE_INT = 0;
302     uint8 private constant MAJOR_TYPE_MAP = 5;
303     uint8 private constant MAJOR_TYPE_BYTES = 2;
304     uint8 private constant MAJOR_TYPE_ARRAY = 4;
305     uint8 private constant MAJOR_TYPE_STRING = 3;
306     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
307     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
308 
309     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
310         if (_value <= 23) {
311             _buf.append(uint8((_major << 5) | _value));
312         } else if (_value <= 0xFF) {
313             _buf.append(uint8((_major << 5) | 24));
314             _buf.appendInt(_value, 1);
315         } else if (_value <= 0xFFFF) {
316             _buf.append(uint8((_major << 5) | 25));
317             _buf.appendInt(_value, 2);
318         } else if (_value <= 0xFFFFFFFF) {
319             _buf.append(uint8((_major << 5) | 26));
320             _buf.appendInt(_value, 4);
321         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
322             _buf.append(uint8((_major << 5) | 27));
323             _buf.appendInt(_value, 8);
324         }
325     }
326 
327     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
328         _buf.append(uint8((_major << 5) | 31));
329     }
330 
331     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
332         encodeType(_buf, MAJOR_TYPE_INT, _value);
333     }
334 
335     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
336         if (_value >= 0) {
337             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
338         } else {
339             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
340         }
341     }
342 
343     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
344         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
345         _buf.append(_value);
346     }
347 
348     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
349         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
350         _buf.append(bytes(_value));
351     }
352 
353     function startArray(Buffer.buffer memory _buf) internal pure {
354         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
355     }
356 
357     function startMap(Buffer.buffer memory _buf) internal pure {
358         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
359     }
360 
361     function endSequence(Buffer.buffer memory _buf) internal pure {
362         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
363     }
364 }
365 contract usingOraclize {
366 
367     using CBOR for Buffer.buffer;
368 
369     OraclizeI oraclize;
370     OraclizeAddrResolverI OAR;
371 
372     uint constant day = 60 * 60 * 24;
373     uint constant week = 60 * 60 * 24 * 7;
374     uint constant month = 60 * 60 * 24 * 30;
375 
376     byte constant proofType_NONE = 0x00;
377     byte constant proofType_Ledger = 0x30;
378     byte constant proofType_Native = 0xF0;
379     byte constant proofStorage_IPFS = 0x01;
380     byte constant proofType_Android = 0x40;
381     byte constant proofType_TLSNotary = 0x10;
382 
383     string oraclize_network_name;
384     uint8 constant networkID_auto = 0;
385     uint8 constant networkID_morden = 2;
386     uint8 constant networkID_mainnet = 1;
387     uint8 constant networkID_testnet = 2;
388     uint8 constant networkID_consensys = 161;
389 
390     mapping(bytes32 => bytes32) oraclize_randomDS_args;
391     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
392 
393     modifier oraclizeAPI {
394         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
395             oraclize_setNetwork(networkID_auto);
396         }
397         if (address(oraclize) != OAR.getAddress()) {
398             oraclize = OraclizeI(OAR.getAddress());
399         }
400         _;
401     }
402 
403     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
404         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
405         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
406         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
407         require(proofVerified);
408         _;
409     }
410 
411     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
412       return oraclize_setNetwork();
413       _networkID; // silence the warning and remain backwards compatible
414     }
415 
416     function oraclize_setNetworkName(string memory _network_name) internal {
417         oraclize_network_name = _network_name;
418     }
419 
420     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
421         return oraclize_network_name;
422     }
423 
424     function oraclize_setNetwork() internal returns (bool _networkSet) {
425         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
426             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
427             oraclize_setNetworkName("eth_mainnet");
428             return true;
429         }
430         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
431             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
432             oraclize_setNetworkName("eth_ropsten3");
433             return true;
434         }
435         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
436             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
437             oraclize_setNetworkName("eth_kovan");
438             return true;
439         }
440         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
441             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
442             oraclize_setNetworkName("eth_rinkeby");
443             return true;
444         }
445         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
446             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
447             return true;
448         }
449         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
450             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
451             return true;
452         }
453         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
454             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
455             return true;
456         }
457         return false;
458     }
459 
460     function __callback(bytes32 _myid, string memory _result) public {
461         __callback(_myid, _result, new bytes(0));
462     }
463 
464     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
465       return;
466       _myid; _result; _proof; // Silence compiler warnings
467     }
468 
469     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
470         return oraclize.getPrice(_datasource);
471     }
472 
473     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
474         return oraclize.getPrice(_datasource, _gasLimit);
475     }
476 
477     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
478         uint price = oraclize.getPrice(_datasource);
479         if (price > 1 ether + tx.gasprice * 200000) {
480             return 0; // Unexpectedly high price
481         }
482         return oraclize.query.value(price)(0, _datasource, _arg);
483     }
484 
485     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
486         uint price = oraclize.getPrice(_datasource);
487         if (price > 1 ether + tx.gasprice * 200000) {
488             return 0; // Unexpectedly high price
489         }
490         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
491     }
492 
493     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
494         uint price = oraclize.getPrice(_datasource,_gasLimit);
495         if (price > 1 ether + tx.gasprice * _gasLimit) {
496             return 0; // Unexpectedly high price
497         }
498         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
499     }
500 
501     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
502         uint price = oraclize.getPrice(_datasource, _gasLimit);
503         if (price > 1 ether + tx.gasprice * _gasLimit) {
504            return 0; // Unexpectedly high price
505         }
506         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
507     }
508 
509     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
510         uint price = oraclize.getPrice(_datasource);
511         if (price > 1 ether + tx.gasprice * 200000) {
512             return 0; // Unexpectedly high price
513         }
514         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
515     }
516 
517     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
518         uint price = oraclize.getPrice(_datasource);
519         if (price > 1 ether + tx.gasprice * 200000) {
520             return 0; // Unexpectedly high price
521         }
522         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
523     }
524 
525     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
526         uint price = oraclize.getPrice(_datasource, _gasLimit);
527         if (price > 1 ether + tx.gasprice * _gasLimit) {
528             return 0; // Unexpectedly high price
529         }
530         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
531     }
532 
533     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
534         uint price = oraclize.getPrice(_datasource, _gasLimit);
535         if (price > 1 ether + tx.gasprice * _gasLimit) {
536             return 0; // Unexpectedly high price
537         }
538         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
539     }
540 
541     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
542         uint price = oraclize.getPrice(_datasource);
543         if (price > 1 ether + tx.gasprice * 200000) {
544             return 0; // Unexpectedly high price
545         }
546         bytes memory args = stra2cbor(_argN);
547         return oraclize.queryN.value(price)(0, _datasource, args);
548     }
549 
550     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
551         uint price = oraclize.getPrice(_datasource);
552         if (price > 1 ether + tx.gasprice * 200000) {
553             return 0; // Unexpectedly high price
554         }
555         bytes memory args = stra2cbor(_argN);
556         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
557     }
558 
559     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
560         uint price = oraclize.getPrice(_datasource, _gasLimit);
561         if (price > 1 ether + tx.gasprice * _gasLimit) {
562             return 0; // Unexpectedly high price
563         }
564         bytes memory args = stra2cbor(_argN);
565         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
566     }
567 
568     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
569         uint price = oraclize.getPrice(_datasource, _gasLimit);
570         if (price > 1 ether + tx.gasprice * _gasLimit) {
571             return 0; // Unexpectedly high price
572         }
573         bytes memory args = stra2cbor(_argN);
574         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
575     }
576 
577     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
578         string[] memory dynargs = new string[](1);
579         dynargs[0] = _args[0];
580         return oraclize_query(_datasource, dynargs);
581     }
582 
583     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
584         string[] memory dynargs = new string[](1);
585         dynargs[0] = _args[0];
586         return oraclize_query(_timestamp, _datasource, dynargs);
587     }
588 
589     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
590         string[] memory dynargs = new string[](1);
591         dynargs[0] = _args[0];
592         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
593     }
594 
595     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
596         string[] memory dynargs = new string[](1);
597         dynargs[0] = _args[0];
598         return oraclize_query(_datasource, dynargs, _gasLimit);
599     }
600 
601     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
602         string[] memory dynargs = new string[](2);
603         dynargs[0] = _args[0];
604         dynargs[1] = _args[1];
605         return oraclize_query(_datasource, dynargs);
606     }
607 
608     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
609         string[] memory dynargs = new string[](2);
610         dynargs[0] = _args[0];
611         dynargs[1] = _args[1];
612         return oraclize_query(_timestamp, _datasource, dynargs);
613     }
614 
615     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
616         string[] memory dynargs = new string[](2);
617         dynargs[0] = _args[0];
618         dynargs[1] = _args[1];
619         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
620     }
621 
622     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
623         string[] memory dynargs = new string[](2);
624         dynargs[0] = _args[0];
625         dynargs[1] = _args[1];
626         return oraclize_query(_datasource, dynargs, _gasLimit);
627     }
628 
629     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
630         string[] memory dynargs = new string[](3);
631         dynargs[0] = _args[0];
632         dynargs[1] = _args[1];
633         dynargs[2] = _args[2];
634         return oraclize_query(_datasource, dynargs);
635     }
636 
637     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
638         string[] memory dynargs = new string[](3);
639         dynargs[0] = _args[0];
640         dynargs[1] = _args[1];
641         dynargs[2] = _args[2];
642         return oraclize_query(_timestamp, _datasource, dynargs);
643     }
644 
645     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
646         string[] memory dynargs = new string[](3);
647         dynargs[0] = _args[0];
648         dynargs[1] = _args[1];
649         dynargs[2] = _args[2];
650         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
651     }
652 
653     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
654         string[] memory dynargs = new string[](3);
655         dynargs[0] = _args[0];
656         dynargs[1] = _args[1];
657         dynargs[2] = _args[2];
658         return oraclize_query(_datasource, dynargs, _gasLimit);
659     }
660 
661     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
662         string[] memory dynargs = new string[](4);
663         dynargs[0] = _args[0];
664         dynargs[1] = _args[1];
665         dynargs[2] = _args[2];
666         dynargs[3] = _args[3];
667         return oraclize_query(_datasource, dynargs);
668     }
669 
670     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
671         string[] memory dynargs = new string[](4);
672         dynargs[0] = _args[0];
673         dynargs[1] = _args[1];
674         dynargs[2] = _args[2];
675         dynargs[3] = _args[3];
676         return oraclize_query(_timestamp, _datasource, dynargs);
677     }
678 
679     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
680         string[] memory dynargs = new string[](4);
681         dynargs[0] = _args[0];
682         dynargs[1] = _args[1];
683         dynargs[2] = _args[2];
684         dynargs[3] = _args[3];
685         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
686     }
687 
688     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
689         string[] memory dynargs = new string[](4);
690         dynargs[0] = _args[0];
691         dynargs[1] = _args[1];
692         dynargs[2] = _args[2];
693         dynargs[3] = _args[3];
694         return oraclize_query(_datasource, dynargs, _gasLimit);
695     }
696 
697     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
698         string[] memory dynargs = new string[](5);
699         dynargs[0] = _args[0];
700         dynargs[1] = _args[1];
701         dynargs[2] = _args[2];
702         dynargs[3] = _args[3];
703         dynargs[4] = _args[4];
704         return oraclize_query(_datasource, dynargs);
705     }
706 
707     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
708         string[] memory dynargs = new string[](5);
709         dynargs[0] = _args[0];
710         dynargs[1] = _args[1];
711         dynargs[2] = _args[2];
712         dynargs[3] = _args[3];
713         dynargs[4] = _args[4];
714         return oraclize_query(_timestamp, _datasource, dynargs);
715     }
716 
717     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
718         string[] memory dynargs = new string[](5);
719         dynargs[0] = _args[0];
720         dynargs[1] = _args[1];
721         dynargs[2] = _args[2];
722         dynargs[3] = _args[3];
723         dynargs[4] = _args[4];
724         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
725     }
726 
727     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
728         string[] memory dynargs = new string[](5);
729         dynargs[0] = _args[0];
730         dynargs[1] = _args[1];
731         dynargs[2] = _args[2];
732         dynargs[3] = _args[3];
733         dynargs[4] = _args[4];
734         return oraclize_query(_datasource, dynargs, _gasLimit);
735     }
736 
737     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
738         uint price = oraclize.getPrice(_datasource);
739         if (price > 1 ether + tx.gasprice * 200000) {
740             return 0; // Unexpectedly high price
741         }
742         bytes memory args = ba2cbor(_argN);
743         return oraclize.queryN.value(price)(0, _datasource, args);
744     }
745 
746     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
747         uint price = oraclize.getPrice(_datasource);
748         if (price > 1 ether + tx.gasprice * 200000) {
749             return 0; // Unexpectedly high price
750         }
751         bytes memory args = ba2cbor(_argN);
752         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
753     }
754 
755     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
756         uint price = oraclize.getPrice(_datasource, _gasLimit);
757         if (price > 1 ether + tx.gasprice * _gasLimit) {
758             return 0; // Unexpectedly high price
759         }
760         bytes memory args = ba2cbor(_argN);
761         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
762     }
763 
764     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
765         uint price = oraclize.getPrice(_datasource, _gasLimit);
766         if (price > 1 ether + tx.gasprice * _gasLimit) {
767             return 0; // Unexpectedly high price
768         }
769         bytes memory args = ba2cbor(_argN);
770         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
771     }
772 
773     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
774         bytes[] memory dynargs = new bytes[](1);
775         dynargs[0] = _args[0];
776         return oraclize_query(_datasource, dynargs);
777     }
778 
779     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
780         bytes[] memory dynargs = new bytes[](1);
781         dynargs[0] = _args[0];
782         return oraclize_query(_timestamp, _datasource, dynargs);
783     }
784 
785     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
786         bytes[] memory dynargs = new bytes[](1);
787         dynargs[0] = _args[0];
788         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
789     }
790 
791     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
792         bytes[] memory dynargs = new bytes[](1);
793         dynargs[0] = _args[0];
794         return oraclize_query(_datasource, dynargs, _gasLimit);
795     }
796 
797     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
798         bytes[] memory dynargs = new bytes[](2);
799         dynargs[0] = _args[0];
800         dynargs[1] = _args[1];
801         return oraclize_query(_datasource, dynargs);
802     }
803 
804     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
805         bytes[] memory dynargs = new bytes[](2);
806         dynargs[0] = _args[0];
807         dynargs[1] = _args[1];
808         return oraclize_query(_timestamp, _datasource, dynargs);
809     }
810 
811     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
812         bytes[] memory dynargs = new bytes[](2);
813         dynargs[0] = _args[0];
814         dynargs[1] = _args[1];
815         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
816     }
817 
818     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
819         bytes[] memory dynargs = new bytes[](2);
820         dynargs[0] = _args[0];
821         dynargs[1] = _args[1];
822         return oraclize_query(_datasource, dynargs, _gasLimit);
823     }
824 
825     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
826         bytes[] memory dynargs = new bytes[](3);
827         dynargs[0] = _args[0];
828         dynargs[1] = _args[1];
829         dynargs[2] = _args[2];
830         return oraclize_query(_datasource, dynargs);
831     }
832 
833     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
834         bytes[] memory dynargs = new bytes[](3);
835         dynargs[0] = _args[0];
836         dynargs[1] = _args[1];
837         dynargs[2] = _args[2];
838         return oraclize_query(_timestamp, _datasource, dynargs);
839     }
840 
841     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
842         bytes[] memory dynargs = new bytes[](3);
843         dynargs[0] = _args[0];
844         dynargs[1] = _args[1];
845         dynargs[2] = _args[2];
846         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
847     }
848 
849     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
850         bytes[] memory dynargs = new bytes[](3);
851         dynargs[0] = _args[0];
852         dynargs[1] = _args[1];
853         dynargs[2] = _args[2];
854         return oraclize_query(_datasource, dynargs, _gasLimit);
855     }
856 
857     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
858         bytes[] memory dynargs = new bytes[](4);
859         dynargs[0] = _args[0];
860         dynargs[1] = _args[1];
861         dynargs[2] = _args[2];
862         dynargs[3] = _args[3];
863         return oraclize_query(_datasource, dynargs);
864     }
865 
866     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
867         bytes[] memory dynargs = new bytes[](4);
868         dynargs[0] = _args[0];
869         dynargs[1] = _args[1];
870         dynargs[2] = _args[2];
871         dynargs[3] = _args[3];
872         return oraclize_query(_timestamp, _datasource, dynargs);
873     }
874 
875     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
876         bytes[] memory dynargs = new bytes[](4);
877         dynargs[0] = _args[0];
878         dynargs[1] = _args[1];
879         dynargs[2] = _args[2];
880         dynargs[3] = _args[3];
881         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
882     }
883 
884     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
885         bytes[] memory dynargs = new bytes[](4);
886         dynargs[0] = _args[0];
887         dynargs[1] = _args[1];
888         dynargs[2] = _args[2];
889         dynargs[3] = _args[3];
890         return oraclize_query(_datasource, dynargs, _gasLimit);
891     }
892 
893     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
894         bytes[] memory dynargs = new bytes[](5);
895         dynargs[0] = _args[0];
896         dynargs[1] = _args[1];
897         dynargs[2] = _args[2];
898         dynargs[3] = _args[3];
899         dynargs[4] = _args[4];
900         return oraclize_query(_datasource, dynargs);
901     }
902 
903     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
904         bytes[] memory dynargs = new bytes[](5);
905         dynargs[0] = _args[0];
906         dynargs[1] = _args[1];
907         dynargs[2] = _args[2];
908         dynargs[3] = _args[3];
909         dynargs[4] = _args[4];
910         return oraclize_query(_timestamp, _datasource, dynargs);
911     }
912 
913     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
914         bytes[] memory dynargs = new bytes[](5);
915         dynargs[0] = _args[0];
916         dynargs[1] = _args[1];
917         dynargs[2] = _args[2];
918         dynargs[3] = _args[3];
919         dynargs[4] = _args[4];
920         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
921     }
922 
923     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
924         bytes[] memory dynargs = new bytes[](5);
925         dynargs[0] = _args[0];
926         dynargs[1] = _args[1];
927         dynargs[2] = _args[2];
928         dynargs[3] = _args[3];
929         dynargs[4] = _args[4];
930         return oraclize_query(_datasource, dynargs, _gasLimit);
931     }
932 
933     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
934         return oraclize.setProofType(_proofP);
935     }
936 
937 
938     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
939         return oraclize.cbAddress();
940     }
941 
942     function getCodeSize(address _addr) view internal returns (uint _size) {
943         assembly {
944             _size := extcodesize(_addr)
945         }
946     }
947 
948     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
949         return oraclize.setCustomGasPrice(_gasPrice);
950     }
951 
952     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
953         return oraclize.randomDS_getSessionPubKeyHash();
954     }
955 
956     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
957         bytes memory tmp = bytes(_a);
958         uint160 iaddr = 0;
959         uint160 b1;
960         uint160 b2;
961         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
962             iaddr *= 256;
963             b1 = uint160(uint8(tmp[i]));
964             b2 = uint160(uint8(tmp[i + 1]));
965             if ((b1 >= 97) && (b1 <= 102)) {
966                 b1 -= 87;
967             } else if ((b1 >= 65) && (b1 <= 70)) {
968                 b1 -= 55;
969             } else if ((b1 >= 48) && (b1 <= 57)) {
970                 b1 -= 48;
971             }
972             if ((b2 >= 97) && (b2 <= 102)) {
973                 b2 -= 87;
974             } else if ((b2 >= 65) && (b2 <= 70)) {
975                 b2 -= 55;
976             } else if ((b2 >= 48) && (b2 <= 57)) {
977                 b2 -= 48;
978             }
979             iaddr += (b1 * 16 + b2);
980         }
981         return address(iaddr);
982     }
983 
984     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
985         bytes memory a = bytes(_a);
986         bytes memory b = bytes(_b);
987         uint minLength = a.length;
988         if (b.length < minLength) {
989             minLength = b.length;
990         }
991         for (uint i = 0; i < minLength; i ++) {
992             if (a[i] < b[i]) {
993                 return -1;
994             } else if (a[i] > b[i]) {
995                 return 1;
996             }
997         }
998         if (a.length < b.length) {
999             return -1;
1000         } else if (a.length > b.length) {
1001             return 1;
1002         } else {
1003             return 0;
1004         }
1005     }
1006 
1007     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
1008         bytes memory h = bytes(_haystack);
1009         bytes memory n = bytes(_needle);
1010         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
1011             return -1;
1012         } else if (h.length > (2 ** 128 - 1)) {
1013             return -1;
1014         } else {
1015             uint subindex = 0;
1016             for (uint i = 0; i < h.length; i++) {
1017                 if (h[i] == n[0]) {
1018                     subindex = 1;
1019                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
1020                         subindex++;
1021                     }
1022                     if (subindex == n.length) {
1023                         return int(i);
1024                     }
1025                 }
1026             }
1027             return -1;
1028         }
1029     }
1030 
1031     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
1032         return strConcat(_a, _b, "", "", "");
1033     }
1034 
1035     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
1036         return strConcat(_a, _b, _c, "", "");
1037     }
1038 
1039     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
1040         return strConcat(_a, _b, _c, _d, "");
1041     }
1042 
1043     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
1044         bytes memory _ba = bytes(_a);
1045         bytes memory _bb = bytes(_b);
1046         bytes memory _bc = bytes(_c);
1047         bytes memory _bd = bytes(_d);
1048         bytes memory _be = bytes(_e);
1049         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1050         bytes memory babcde = bytes(abcde);
1051         uint k = 0;
1052         uint i = 0;
1053         for (i = 0; i < _ba.length; i++) {
1054             babcde[k++] = _ba[i];
1055         }
1056         for (i = 0; i < _bb.length; i++) {
1057             babcde[k++] = _bb[i];
1058         }
1059         for (i = 0; i < _bc.length; i++) {
1060             babcde[k++] = _bc[i];
1061         }
1062         for (i = 0; i < _bd.length; i++) {
1063             babcde[k++] = _bd[i];
1064         }
1065         for (i = 0; i < _be.length; i++) {
1066             babcde[k++] = _be[i];
1067         }
1068         return string(babcde);
1069     }
1070 
1071     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
1072         return safeParseInt(_a, 0);
1073     }
1074 
1075     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1076         bytes memory bresult = bytes(_a);
1077         uint mint = 0;
1078         bool decimals = false;
1079         for (uint i = 0; i < bresult.length; i++) {
1080             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1081                 if (decimals) {
1082                    if (_b == 0) break;
1083                     else _b--;
1084                 }
1085                 mint *= 10;
1086                 mint += uint(uint8(bresult[i])) - 48;
1087             } else if (uint(uint8(bresult[i])) == 46) {
1088                 require(!decimals, 'More than one decimal encountered in string!');
1089                 decimals = true;
1090             } else {
1091                 revert("Non-numeral character encountered in string!");
1092             }
1093         }
1094         if (_b > 0) {
1095             mint *= 10 ** _b;
1096         }
1097         return mint;
1098     }
1099 
1100     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
1101         return parseInt(_a, 0);
1102     }
1103 
1104     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1105         bytes memory bresult = bytes(_a);
1106         uint mint = 0;
1107         bool decimals = false;
1108         for (uint i = 0; i < bresult.length; i++) {
1109             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1110                 if (decimals) {
1111                    if (_b == 0) {
1112                        break;
1113                    } else {
1114                        _b--;
1115                    }
1116                 }
1117                 mint *= 10;
1118                 mint += uint(uint8(bresult[i])) - 48;
1119             } else if (uint(uint8(bresult[i])) == 46) {
1120                 decimals = true;
1121             }
1122         }
1123         if (_b > 0) {
1124             mint *= 10 ** _b;
1125         }
1126         return mint;
1127     }
1128 
1129     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1130         if (_i == 0) {
1131             return "0";
1132         }
1133         uint j = _i;
1134         uint len;
1135         while (j != 0) {
1136             len++;
1137             j /= 10;
1138         }
1139         bytes memory bstr = new bytes(len);
1140         uint k = len - 1;
1141         while (_i != 0) {
1142             bstr[k--] = byte(uint8(48 + _i % 10));
1143             _i /= 10;
1144         }
1145         return string(bstr);
1146     }
1147 
1148     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1149         safeMemoryCleaner();
1150         Buffer.buffer memory buf;
1151         Buffer.init(buf, 1024);
1152         buf.startArray();
1153         for (uint i = 0; i < _arr.length; i++) {
1154             buf.encodeString(_arr[i]);
1155         }
1156         buf.endSequence();
1157         return buf.buf;
1158     }
1159 
1160     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1161         safeMemoryCleaner();
1162         Buffer.buffer memory buf;
1163         Buffer.init(buf, 1024);
1164         buf.startArray();
1165         for (uint i = 0; i < _arr.length; i++) {
1166             buf.encodeBytes(_arr[i]);
1167         }
1168         buf.endSequence();
1169         return buf.buf;
1170     }
1171 
1172     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1173         require((_nbytes > 0) && (_nbytes <= 32));
1174         _delay *= 10; // Convert from seconds to ledger timer ticks
1175         bytes memory nbytes = new bytes(1);
1176         nbytes[0] = byte(uint8(_nbytes));
1177         bytes memory unonce = new bytes(32);
1178         bytes memory sessionKeyHash = new bytes(32);
1179         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1180         assembly {
1181             mstore(unonce, 0x20)
1182             /*
1183              The following variables can be relaxed.
1184              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1185              for an idea on how to override and replace commit hash variables.
1186             */
1187             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1188             mstore(sessionKeyHash, 0x20)
1189             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1190         }
1191         bytes memory delay = new bytes(32);
1192         assembly {
1193             mstore(add(delay, 0x20), _delay)
1194         }
1195         bytes memory delay_bytes8 = new bytes(8);
1196         copyBytes(delay, 24, 8, delay_bytes8, 0);
1197         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1198         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1199         bytes memory delay_bytes8_left = new bytes(8);
1200         assembly {
1201             let x := mload(add(delay_bytes8, 0x20))
1202             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1203             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1204             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1205             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1206             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1207             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1208             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1209             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1210         }
1211         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1212         return queryId;
1213     }
1214 
1215     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1216         oraclize_randomDS_args[_queryId] = _commitment;
1217     }
1218 
1219     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1220         bool sigok;
1221         address signer;
1222         bytes32 sigr;
1223         bytes32 sigs;
1224         bytes memory sigr_ = new bytes(32);
1225         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1226         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1227         bytes memory sigs_ = new bytes(32);
1228         offset += 32 + 2;
1229         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1230         assembly {
1231             sigr := mload(add(sigr_, 32))
1232             sigs := mload(add(sigs_, 32))
1233         }
1234         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1235         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1236             return true;
1237         } else {
1238             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1239             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1240         }
1241     }
1242 
1243     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1244         bool sigok;
1245         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1246         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1247         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1248         bytes memory appkey1_pubkey = new bytes(64);
1249         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1250         bytes memory tosign2 = new bytes(1 + 65 + 32);
1251         tosign2[0] = byte(uint8(1)); //role
1252         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1253         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1254         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1255         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1256         if (!sigok) {
1257             return false;
1258         }
1259         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1260         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1261         bytes memory tosign3 = new bytes(1 + 65);
1262         tosign3[0] = 0xFE;
1263         copyBytes(_proof, 3, 65, tosign3, 1);
1264         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1265         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1266         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1267         return sigok;
1268     }
1269 
1270     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1271         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1272         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1273             return 1;
1274         }
1275         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1276         if (!proofVerified) {
1277             return 2;
1278         }
1279         return 0;
1280     }
1281 
1282     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1283         bool match_ = true;
1284         require(_prefix.length == _nRandomBytes);
1285         for (uint256 i = 0; i< _nRandomBytes; i++) {
1286             if (_content[i] != _prefix[i]) {
1287                 match_ = false;
1288             }
1289         }
1290         return match_;
1291     }
1292 
1293     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1294         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1295         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1296         bytes memory keyhash = new bytes(32);
1297         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1298         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1299             return false;
1300         }
1301         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1302         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1303         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1304         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1305             return false;
1306         }
1307         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1308         // This is to verify that the computed args match with the ones specified in the query.
1309         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1310         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1311         bytes memory sessionPubkey = new bytes(64);
1312         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1313         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1314         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1315         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1316             delete oraclize_randomDS_args[_queryId];
1317         } else return false;
1318         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1319         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1320         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1321         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1322             return false;
1323         }
1324         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1325         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1326             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1327         }
1328         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1329     }
1330     /*
1331      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1332     */
1333     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1334         uint minLength = _length + _toOffset;
1335         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1336         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1337         uint j = 32 + _toOffset;
1338         while (i < (32 + _fromOffset + _length)) {
1339             assembly {
1340                 let tmp := mload(add(_from, i))
1341                 mstore(add(_to, j), tmp)
1342             }
1343             i += 32;
1344             j += 32;
1345         }
1346         return _to;
1347     }
1348     /*
1349      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1350      Duplicate Solidity's ecrecover, but catching the CALL return value
1351     */
1352     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1353         /*
1354          We do our own memory management here. Solidity uses memory offset
1355          0x40 to store the current end of memory. We write past it (as
1356          writes are memory extensions), but don't update the offset so
1357          Solidity will reuse it. The memory used here is only needed for
1358          this context.
1359          FIXME: inline assembly can't access return values
1360         */
1361         bool ret;
1362         address addr;
1363         assembly {
1364             let size := mload(0x40)
1365             mstore(size, _hash)
1366             mstore(add(size, 32), _v)
1367             mstore(add(size, 64), _r)
1368             mstore(add(size, 96), _s)
1369             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1370             addr := mload(size)
1371         }
1372         return (ret, addr);
1373     }
1374     /*
1375      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1376     */
1377     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1378         bytes32 r;
1379         bytes32 s;
1380         uint8 v;
1381         if (_sig.length != 65) {
1382             return (false, address(0));
1383         }
1384         /*
1385          The signature format is a compact form of:
1386            {bytes32 r}{bytes32 s}{uint8 v}
1387          Compact means, uint8 is not padded to 32 bytes.
1388         */
1389         assembly {
1390             r := mload(add(_sig, 32))
1391             s := mload(add(_sig, 64))
1392             /*
1393              Here we are loading the last 32 bytes. We exploit the fact that
1394              'mload' will pad with zeroes if we overread.
1395              There is no 'mload8' to do this, but that would be nicer.
1396             */
1397             v := byte(0, mload(add(_sig, 96)))
1398             /*
1399               Alternative solution:
1400               'byte' is not working due to the Solidity parser, so lets
1401               use the second best option, 'and'
1402               v := and(mload(add(_sig, 65)), 255)
1403             */
1404         }
1405         /*
1406          albeit non-transactional signatures are not specified by the YP, one would expect it
1407          to match the YP range of [27, 28]
1408          geth uses [0, 1] and some clients have followed. This might change, see:
1409          https://github.com/ethereum/go-ethereum/issues/2053
1410         */
1411         if (v < 27) {
1412             v += 27;
1413         }
1414         if (v != 27 && v != 28) {
1415             return (false, address(0));
1416         }
1417         return safer_ecrecover(_hash, v, r, s);
1418     }
1419 
1420     function safeMemoryCleaner() internal pure {
1421         assembly {
1422             let fmem := mload(0x40)
1423             codecopy(fmem, codesize, sub(msize, fmem))
1424         }
1425     }
1426 }
1427 
1428 contract PAXTRExchange is Owned, usingOraclize {
1429     using SafeMath for uint256;
1430     
1431     constructor() public payable {
1432         owner = msg.sender;
1433         oraclePriceURL = "json(https://spreadsheets.google.com/feeds/list/1pL8-QrNJrN1OFUmFNqt0IMDc6uepEuYLLAS-d8LxprI/od6/public/values?alt=json).feed.entry[4].['gsx$_ciyn3'].['$t']";
1434         oraclize_setCustomGasPrice(5000000000);
1435         bytes32 queryId = oraclize_query("URL", oraclePriceURL);
1436         queryIsValid[queryId] = true;
1437         lastPriceUpdate = block.number;
1438     }
1439     
1440     function () external payable {
1441         revert();
1442     }
1443     
1444     function changeTokenAddress(address newTokenAddress) public onlyOwner {
1445         tokenAddress = newTokenAddress;
1446     }
1447     
1448     // Events
1449     event Deposit(string _type, uint256 amount, address to);
1450     event Withdraw(string _type, uint256 amount, address from);
1451     
1452     // Global Variables
1453     address public tokenAddress = 0x6d86091B051799e05CC8D7b2452A7Cb123F018D8;
1454     uint256 public tokenPrice;
1455     uint256 constant private tokenDecimals = 8;
1456     mapping(bytes32 => bool) private queryIsValid;
1457     string public oraclePriceURL;
1458     uint256 private lastPriceUpdate = 0;
1459     
1460     // Order Variables
1461     struct accountStuct {
1462         uint256 tokenBalance;
1463         uint256 etherBalance;
1464         uint256 tokenOrder;
1465         uint256 tokenOrderIndex;
1466         uint256 etherOrder;
1467         uint256 etherOrderIndex;
1468     }
1469     mapping(address => accountStuct) public account; // Account and order data 
1470     address[] public etherOrders; // Key for addresses with active ether orders
1471     uint256 public usedEtherOrders;
1472     address[] public tokenOrders; // Key for addresses with active token orders
1473     uint256 public usedTokenOrders;
1474     
1475     // Get Array Lengths
1476     function getEtherOrdersLength() public view returns(uint256) {
1477         return etherOrders.length;
1478     }
1479     function getTokenOrdersLength() public view returns(uint256) {
1480         return tokenOrders.length;
1481     }
1482     
1483     // Deposit Functions
1484     function depositETH() public payable {
1485         account[msg.sender].etherBalance = account[msg.sender].etherBalance.add(msg.value);
1486         emit Deposit("Ether", msg.value, msg.sender);
1487     }
1488     function depositPAXTR(uint256 amount) public {
1489         require(IERC20(tokenAddress).allowance(msg.sender, address(this)) >= amount);
1490         IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount);
1491         account[msg.sender].tokenBalance = account[msg.sender].tokenBalance.add(amount);
1492         emit Deposit("PAXTR", amount, msg.sender);
1493     }
1494     
1495     // Withdrawal Functions
1496     function withdrawETH(uint256 amount) public {
1497         require((account[msg.sender].etherBalance - account[msg.sender].etherOrder) >= amount);
1498         account[msg.sender].etherBalance = account[msg.sender].etherBalance.sub(amount);
1499         msg.sender.transfer(amount);
1500         emit Withdraw("Ether", amount, msg.sender);
1501     }
1502     function withdrawPAXTR(uint256 amount) public {
1503         require((account[msg.sender].tokenBalance - account[msg.sender].tokenOrder) >= amount);
1504         account[msg.sender].tokenBalance = account[msg.sender].tokenBalance.sub(amount);
1505         IERC20(tokenAddress).transfer(msg.sender, amount);
1506         emit Withdraw("PAXTR", amount, msg.sender);
1507     }
1508     
1509     // Place Limit
1510     function limitBuy(uint256 amount) public {  // Place buy order with Ether
1511         require(account[msg.sender].etherBalance >= amount);
1512         require(account[msg.sender].etherOrder == 0);
1513         account[msg.sender].etherOrder = amount;
1514         etherOrders.push(msg.sender);
1515         account[msg.sender].etherOrderIndex = etherOrders.length - 1;
1516     }
1517     function limitSell(uint256 amount) public { // Place a sell order with PAXTR
1518         require(account[msg.sender].tokenBalance >= amount);
1519         require(account[msg.sender].tokenOrder == 0);
1520         account[msg.sender].tokenOrder = amount;
1521         tokenOrders.push(msg.sender);
1522         account[msg.sender].tokenOrderIndex = tokenOrders.length - 1;
1523     }
1524     
1525     // Cancel limits
1526     function cancelBuy() public {   // Cancels the buy order using Ether
1527         require(account[msg.sender].etherOrder > 0);
1528         for (uint256 i = account[msg.sender].etherOrderIndex; i < (etherOrders.length - 1); i++) {
1529             etherOrders[i] = etherOrders[i+1];
1530         }
1531         etherOrders.length -= 1;
1532         account[msg.sender].etherOrder = 0;
1533     }
1534     function cancelSell() public {  // Cancels the sell order of PAXTR
1535         require(account[msg.sender].tokenOrder > 0);
1536         for (uint256 i = account[msg.sender].tokenOrderIndex; i < (tokenOrders.length - 1); i++) {
1537             tokenOrders[i] = tokenOrders[i+1];
1538         }
1539         tokenOrders.length -= 1;
1540         account[msg.sender].tokenOrder = 0;
1541     }
1542     
1543     
1544     // Send Market Orders
1545     function sendMarketSells(uint256[] memory amounts, uint256 limit) public {
1546         uint256 amount = amounts.length;
1547         for (uint i = 0; i < amount; i++) {
1548             marketSell(amounts[i]);
1549         }
1550         if (limit > 0) {
1551             limitSell(limit);
1552         }
1553     }
1554     function sendMarketBuys(uint256[] memory amounts, uint256 limit) public {
1555         uint256 amount = amounts.length;
1556         for (uint i = 0; i < amount; i++) {
1557             marketBuy(amounts[i]);
1558         }
1559         if (limit > 0) {
1560             limitBuy(limit);
1561         }
1562     }
1563     
1564     // Call each
1565     function marketBuy(uint256 amount) public {
1566         require(account[tokenOrders[usedTokenOrders]].tokenOrder >= ((amount * (10 ** tokenDecimals)) / tokenPrice)); // Buy amount is not too big
1567         require(account[msg.sender].etherBalance >= amount); // Buyer has enough ETH
1568         account[tokenOrders[usedTokenOrders]].tokenOrder -= (amount * (10 ** tokenDecimals)) / tokenPrice; // Removes tokens
1569         account[tokenOrders[usedTokenOrders]].tokenBalance -= (amount * (10 ** tokenDecimals)) / tokenPrice; // Removes tokens
1570         account[msg.sender].tokenBalance += (amount * (10 ** tokenDecimals)) / tokenPrice; // Adds tokens
1571         account[msg.sender].etherBalance -= amount; // Removes ether
1572         account[tokenOrders[usedTokenOrders]].etherBalance += (amount - oraclize_getPrice("URL"));
1573         if (((account[tokenOrders[usedTokenOrders]].tokenOrder * tokenPrice) / (10 ** tokenDecimals)) == 0) {
1574             account[tokenOrders[usedTokenOrders]].tokenBalance -= account[tokenOrders[usedTokenOrders]].tokenOrder;
1575             account[tokenOrders[usedTokenOrders]].tokenOrder = 0;
1576         }
1577         if (account[tokenOrders[usedTokenOrders]].tokenOrder == 0) {
1578             usedTokenOrders += 1;
1579         }
1580         updatePrice();
1581     }
1582     function marketSell(uint256 amount) public {
1583         require(account[etherOrders[usedEtherOrders]].etherOrder >= ((amount * tokenPrice) / (10 ** tokenDecimals))); // Sell amount is not too big
1584         require(account[msg.sender].tokenBalance >= amount); // Seller has enough tokens
1585         account[msg.sender].tokenBalance -= amount; // Removes tokens
1586         account[etherOrders[usedEtherOrders]].tokenBalance += amount; // Add tokens
1587         
1588         account[etherOrders[usedEtherOrders]].etherOrder -= ((amount * tokenPrice) / (10 ** tokenDecimals)); // Removes ether
1589         account[etherOrders[usedEtherOrders]].etherBalance -= ((amount * tokenPrice) / (10 ** tokenDecimals)); // Removes ether
1590         account[msg.sender].etherBalance += (((amount * tokenPrice) / (10 ** tokenDecimals)) - oraclize_getPrice("URL"));
1591         if (((account[etherOrders[usedEtherOrders]].etherOrder * (10 ** tokenDecimals)) / tokenPrice) == 0) {
1592             account[etherOrders[usedEtherOrders]].etherBalance -= account[etherOrders[usedEtherOrders]].etherOrder;
1593             account[etherOrders[usedEtherOrders]].etherOrder = 0;
1594         }
1595         if (account[etherOrders[usedEtherOrders]].etherOrder == 0) {
1596             usedEtherOrders += 1;
1597         }
1598         updatePrice();
1599     }
1600 
1601     // Administration
1602     function donateEther() public payable {}
1603     
1604     function withdrawFees(uint256 amount) public onlyOwner {
1605         msg.sender.transfer(amount);
1606     }
1607     
1608     
1609     // Oracalize
1610     function setOraclizeGasPrice(uint256 newPriceInWEI) public onlyOwner {
1611         oraclize_setCustomGasPrice(newPriceInWEI);
1612     }
1613     function updatePrice() internal {
1614         if (block.number >= (lastPriceUpdate + 40)) {
1615             bytes32 queryId = oraclize_query("URL", oraclePriceURL);
1616             queryIsValid[queryId] = true;
1617             lastPriceUpdate = block.number;
1618         }
1619     }
1620     function __callback(bytes32 queryID, string memory result) public {
1621         require(msg.sender == oraclize_cbAddress());
1622         require(queryIsValid[queryID] == true);
1623         tokenPrice = safeParseInt(result);
1624     }
1625     function setOraclePriceURL(string memory newURL) public onlyOwner {
1626         oraclePriceURL = newURL;
1627     }
1628     function manualUpdatePrice() public payable {
1629         require(msg.value >= oraclize_getPrice("URL"));
1630         updatePrice();
1631     }
1632 }