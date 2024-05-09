1 // File: @dev-protocol/protocol/contracts/src/market/IMarket.sol
2 
3 pragma solidity ^0.5.0;
4 
5 contract IMarket {
6 	function calculate(address _metrics, uint256 _start, uint256 _end)
7 		external
8 		returns (bool);
9 
10 	function authenticate(
11 		address _prop,
12 		string memory _args1,
13 		string memory _args2,
14 		string memory _args3,
15 		string memory _args4,
16 		string memory _args5
17 	)
18 		public
19 		returns (
20 			// solium-disable-next-line indentation
21 			address
22 		);
23 
24 	function getAuthenticationFee(address _property)
25 		private
26 		view
27 		returns (uint256);
28 
29 	function authenticatedCallback(address _property, bytes32 _idHash)
30 		external
31 		returns (address);
32 
33 	function vote(address _property, bool _agree) external;
34 
35 	function schema() external view returns (string memory);
36 }
37 
38 // File: @dev-protocol/protocol/contracts/src/allocator/IAllocator.sol
39 
40 pragma solidity ^0.5.0;
41 
42 contract IAllocator {
43 	function allocate(address _metrics) external;
44 
45 	function calculatedCallback(address _metrics, uint256 _value) external;
46 
47 	function beforeBalanceChange(address _property, address _from, address _to)
48 		external;
49 
50 	function getRewardsAmount(address _property)
51 		external
52 		view
53 		returns (uint256);
54 
55 	function allocation(
56 		uint256 _blocks,
57 		uint256 _mint,
58 		uint256 _value,
59 		uint256 _marketValue,
60 		uint256 _assets,
61 		uint256 _totalAssets
62 	)
63 		public
64 		pure
65 		returns (
66 			// solium-disable-next-line indentation
67 			uint256
68 		);
69 
70 }
71 
72 // File: @openzeppelin/contracts/GSN/Context.sol
73 
74 pragma solidity ^0.5.0;
75 
76 /*
77  * @dev Provides information about the current execution context, including the
78  * sender of the transaction and its data. While these are generally available
79  * via msg.sender and msg.data, they should not be accessed in such a direct
80  * manner, since when dealing with GSN meta-transactions the account sending and
81  * paying for execution may not be the actual sender (as far as an application
82  * is concerned).
83  *
84  * This contract is only required for intermediate, library-like contracts.
85  */
86 contract Context {
87     // Empty internal constructor, to prevent people from mistakenly deploying
88     // an instance of this contract, which should be used via inheritance.
89     constructor () internal { }
90     // solhint-disable-previous-line no-empty-blocks
91 
92     function _msgSender() internal view returns (address payable) {
93         return msg.sender;
94     }
95 
96     function _msgData() internal view returns (bytes memory) {
97         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
98         return msg.data;
99     }
100 }
101 
102 // File: @openzeppelin/contracts/ownership/Ownable.sol
103 
104 pragma solidity ^0.5.0;
105 
106 /**
107  * @dev Contract module which provides a basic access control mechanism, where
108  * there is an account (an owner) that can be granted exclusive access to
109  * specific functions.
110  *
111  * This module is used through inheritance. It will make available the modifier
112  * `onlyOwner`, which can be applied to your functions to restrict their use to
113  * the owner.
114  */
115 contract Ownable is Context {
116     address private _owner;
117 
118     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
119 
120     /**
121      * @dev Initializes the contract setting the deployer as the initial owner.
122      */
123     constructor () internal {
124         _owner = _msgSender();
125         emit OwnershipTransferred(address(0), _owner);
126     }
127 
128     /**
129      * @dev Returns the address of the current owner.
130      */
131     function owner() public view returns (address) {
132         return _owner;
133     }
134 
135     /**
136      * @dev Throws if called by any account other than the owner.
137      */
138     modifier onlyOwner() {
139         require(isOwner(), "Ownable: caller is not the owner");
140         _;
141     }
142 
143     /**
144      * @dev Returns true if the caller is the current owner.
145      */
146     function isOwner() public view returns (bool) {
147         return _msgSender() == _owner;
148     }
149 
150     /**
151      * @dev Leaves the contract without owner. It will not be possible to call
152      * `onlyOwner` functions anymore. Can only be called by the current owner.
153      *
154      * NOTE: Renouncing ownership will leave the contract without an owner,
155      * thereby removing any functionality that is only available to the owner.
156      */
157     function renounceOwnership() public onlyOwner {
158         emit OwnershipTransferred(_owner, address(0));
159         _owner = address(0);
160     }
161 
162     /**
163      * @dev Transfers ownership of the contract to a new account (`newOwner`).
164      * Can only be called by the current owner.
165      */
166     function transferOwnership(address newOwner) public onlyOwner {
167         _transferOwnership(newOwner);
168     }
169 
170     /**
171      * @dev Transfers ownership of the contract to a new account (`newOwner`).
172      */
173     function _transferOwnership(address newOwner) internal {
174         require(newOwner != address(0), "Ownable: new owner is the zero address");
175         emit OwnershipTransferred(_owner, newOwner);
176         _owner = newOwner;
177     }
178 }
179 
180 // File: contracts/lib/Chargeable.sol
181 
182 pragma solidity ^0.5.0;
183 
184 
185 contract Chargeable {
186 	function charge() public payable {}
187 
188 	function charged() public view returns (uint256) {
189 		return address(this).balance;
190 	}
191 }
192 
193 // File: contracts/module/provableAPI.sol
194 
195 // <provableAPI>
196 /*
197 
198 
199 Copyright (c) 2015-2016 Oraclize SRL
200 Copyright (c) 2016-2019 Oraclize LTD
201 Copyright (c) 2019 Provable Things Limited
202 
203 Permission is hereby granted, free of charge, to any person obtaining a copy
204 of this software and associated documentation files (the "Software"), to deal
205 in the Software without restriction, including without limitation the rights
206 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
207 copies of the Software, and to permit persons to whom the Software is
208 furnished to do so, subject to the following conditions:
209 
210 The above copyright notice and this permission notice shall be included in
211 all copies or substantial portions of the Software.
212 
213 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
214 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
215 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
216 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
217 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
218 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
219 THE SOFTWARE.
220 
221 */
222 pragma solidity >= 0.5.0 < 0.6.0; // Incompatible compiler version - please select a compiler within the stated pragma range, or use a different version of the provableAPI!
223 
224 // Dummy contract only used to emit to end-user they are using wrong solc
225 contract solcChecker {
226 /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;
227 }
228 
229 contract ProvableI {
230 
231     address public cbAddress;
232 
233     function setProofType(byte _proofType) external;
234     function setCustomGasPrice(uint _gasPrice) external;
235     function getPrice(string memory _datasource) public returns (uint _dsprice);
236     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
237     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
238     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
239     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
240     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
241     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
242     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
243     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
244 }
245 
246 contract OracleAddrResolverI {
247     function getAddress() public returns (address _address);
248 }
249 /*
250 
251 Begin solidity-cborutils
252 
253 https://github.com/smartcontractkit/solidity-cborutils
254 
255 MIT License
256 
257 Copyright (c) 2018 SmartContract ChainLink, Ltd.
258 
259 Permission is hereby granted, free of charge, to any person obtaining a copy
260 of this software and associated documentation files (the "Software"), to deal
261 in the Software without restriction, including without limitation the rights
262 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
263 copies of the Software, and to permit persons to whom the Software is
264 furnished to do so, subject to the following conditions:
265 
266 The above copyright notice and this permission notice shall be included in all
267 copies or substantial portions of the Software.
268 
269 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
270 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
271 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
272 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
273 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
274 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
275 SOFTWARE.
276 
277 */
278 library Buffer {
279 
280     struct buffer {
281         bytes buf;
282         uint capacity;
283     }
284 
285     function init(buffer memory _buf, uint _capacity) internal pure {
286         uint capacity = _capacity;
287         if (capacity % 32 != 0) {
288             capacity += 32 - (capacity % 32);
289         }
290         _buf.capacity = capacity; // Allocate space for the buffer data
291         assembly {
292             let ptr := mload(0x40)
293             mstore(_buf, ptr)
294             mstore(ptr, 0)
295             mstore(0x40, add(ptr, capacity))
296         }
297     }
298 
299     function resize(buffer memory _buf, uint _capacity) private pure {
300         bytes memory oldbuf = _buf.buf;
301         init(_buf, _capacity);
302         append(_buf, oldbuf);
303     }
304 
305     function max(uint _a, uint _b) private pure returns (uint _max) {
306         if (_a > _b) {
307             return _a;
308         }
309         return _b;
310     }
311     /**
312       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
313       *      would exceed the capacity of the buffer.
314       * @param _buf The buffer to append to.
315       * @param _data The data to append.
316       * @return The original buffer.
317       *
318       */
319     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
320         if (_data.length + _buf.buf.length > _buf.capacity) {
321             resize(_buf, max(_buf.capacity, _data.length) * 2);
322         }
323         uint dest;
324         uint src;
325         uint len = _data.length;
326         assembly {
327             let bufptr := mload(_buf) // Memory address of the buffer data
328             let buflen := mload(bufptr) // Length of existing buffer data
329             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
330             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
331             src := add(_data, 32)
332         }
333         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
334             assembly {
335                 mstore(dest, mload(src))
336             }
337             dest += 32;
338             src += 32;
339         }
340         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
341         assembly {
342             let srcpart := and(mload(src), not(mask))
343             let destpart := and(mload(dest), mask)
344             mstore(dest, or(destpart, srcpart))
345         }
346         return _buf;
347     }
348     /**
349       *
350       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
351       * exceed the capacity of the buffer.
352       * @param _buf The buffer to append to.
353       * @param _data The data to append.
354       * @return The original buffer.
355       *
356       */
357     function append(buffer memory _buf, uint8 _data) internal pure {
358         if (_buf.buf.length + 1 > _buf.capacity) {
359             resize(_buf, _buf.capacity * 2);
360         }
361         assembly {
362             let bufptr := mload(_buf) // Memory address of the buffer data
363             let buflen := mload(bufptr) // Length of existing buffer data
364             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
365             mstore8(dest, _data)
366             mstore(bufptr, add(buflen, 1)) // Update buffer length
367         }
368     }
369     /**
370       *
371       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
372       * exceed the capacity of the buffer.
373       * @param _buf The buffer to append to.
374       * @param _data The data to append.
375       * @return The original buffer.
376       *
377       */
378     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
379         if (_len + _buf.buf.length > _buf.capacity) {
380             resize(_buf, max(_buf.capacity, _len) * 2);
381         }
382         uint mask = 256 ** _len - 1;
383         assembly {
384             let bufptr := mload(_buf) // Memory address of the buffer data
385             let buflen := mload(bufptr) // Length of existing buffer data
386             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
387             mstore(dest, or(and(mload(dest), not(mask)), _data))
388             mstore(bufptr, add(buflen, _len)) // Update buffer length
389         }
390         return _buf;
391     }
392 }
393 
394 library CBOR {
395 
396     using Buffer for Buffer.buffer;
397 
398     uint8 private constant MAJOR_TYPE_INT = 0;
399     uint8 private constant MAJOR_TYPE_MAP = 5;
400     uint8 private constant MAJOR_TYPE_BYTES = 2;
401     uint8 private constant MAJOR_TYPE_ARRAY = 4;
402     uint8 private constant MAJOR_TYPE_STRING = 3;
403     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
404     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
405 
406     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
407         if (_value <= 23) {
408             _buf.append(uint8((_major << 5) | _value));
409         } else if (_value <= 0xFF) {
410             _buf.append(uint8((_major << 5) | 24));
411             _buf.appendInt(_value, 1);
412         } else if (_value <= 0xFFFF) {
413             _buf.append(uint8((_major << 5) | 25));
414             _buf.appendInt(_value, 2);
415         } else if (_value <= 0xFFFFFFFF) {
416             _buf.append(uint8((_major << 5) | 26));
417             _buf.appendInt(_value, 4);
418         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
419             _buf.append(uint8((_major << 5) | 27));
420             _buf.appendInt(_value, 8);
421         }
422     }
423 
424     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
425         _buf.append(uint8((_major << 5) | 31));
426     }
427 
428     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
429         encodeType(_buf, MAJOR_TYPE_INT, _value);
430     }
431 
432     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
433         if (_value >= 0) {
434             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
435         } else {
436             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
437         }
438     }
439 
440     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
441         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
442         _buf.append(_value);
443     }
444 
445     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
446         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
447         _buf.append(bytes(_value));
448     }
449 
450     function startArray(Buffer.buffer memory _buf) internal pure {
451         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
452     }
453 
454     function startMap(Buffer.buffer memory _buf) internal pure {
455         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
456     }
457 
458     function endSequence(Buffer.buffer memory _buf) internal pure {
459         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
460     }
461 }
462 /*
463 
464 End solidity-cborutils
465 
466 */
467 contract usingProvable {
468 
469     using CBOR for Buffer.buffer;
470 
471     ProvableI provable;
472     OracleAddrResolverI OAR;
473 
474     uint constant day = 60 * 60 * 24;
475     uint constant week = 60 * 60 * 24 * 7;
476     uint constant month = 60 * 60 * 24 * 30;
477 
478     byte constant proofType_NONE = 0x00;
479     byte constant proofType_Ledger = 0x30;
480     byte constant proofType_Native = 0xF0;
481     byte constant proofStorage_IPFS = 0x01;
482     byte constant proofType_Android = 0x40;
483     byte constant proofType_TLSNotary = 0x10;
484 
485     string provable_network_name;
486     uint8 constant networkID_auto = 0;
487     uint8 constant networkID_morden = 2;
488     uint8 constant networkID_mainnet = 1;
489     uint8 constant networkID_testnet = 2;
490     uint8 constant networkID_consensys = 161;
491 
492     mapping(bytes32 => bytes32) provable_randomDS_args;
493     mapping(bytes32 => bool) provable_randomDS_sessionKeysHashVerified;
494 
495     modifier provableAPI {
496         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
497             provable_setNetwork(networkID_auto);
498         }
499         if (address(provable) != OAR.getAddress()) {
500             provable = ProvableI(OAR.getAddress());
501         }
502         _;
503     }
504 
505     modifier provable_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
506         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
507         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
508         bool proofVerified = provable_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), provable_getNetworkName());
509         require(proofVerified);
510         _;
511     }
512 
513     function provable_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
514       _networkID; // NOTE: Silence the warning and remain backwards compatible
515       return provable_setNetwork();
516     }
517 
518     function provable_setNetworkName(string memory _network_name) internal {
519         provable_network_name = _network_name;
520     }
521 
522     function provable_getNetworkName() internal view returns (string memory _networkName) {
523         return provable_network_name;
524     }
525 
526     function provable_setNetwork() internal returns (bool _networkSet) {
527         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
528             OAR = OracleAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
529             provable_setNetworkName("eth_mainnet");
530             return true;
531         }
532         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
533             OAR = OracleAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
534             provable_setNetworkName("eth_ropsten3");
535             return true;
536         }
537         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
538             OAR = OracleAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
539             provable_setNetworkName("eth_kovan");
540             return true;
541         }
542         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
543             OAR = OracleAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
544             provable_setNetworkName("eth_rinkeby");
545             return true;
546         }
547         if (getCodeSize(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41) > 0) { //goerli testnet
548             OAR = OracleAddrResolverI(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41);
549             provable_setNetworkName("eth_goerli");
550             return true;
551         }
552         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
553             OAR = OracleAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
554             return true;
555         }
556         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
557             OAR = OracleAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
558             return true;
559         }
560         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
561             OAR = OracleAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
562             return true;
563         }
564         return false;
565     }
566     /**
567      * @dev The following `__callback` functions are just placeholders ideally
568      *      meant to be defined in child contract when proofs are used.
569      *      The function bodies simply silence compiler warnings.
570      */
571     function __callback(bytes32 _myid, string memory _result) public {
572         __callback(_myid, _result, new bytes(0));
573     }
574 
575     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
576       _myid; _result; _proof;
577       provable_randomDS_args[bytes32(0)] = bytes32(0);
578     }
579 
580     function provable_getPrice(string memory _datasource) provableAPI internal returns (uint _queryPrice) {
581         return provable.getPrice(_datasource);
582     }
583 
584     function provable_getPrice(string memory _datasource, uint _gasLimit) provableAPI internal returns (uint _queryPrice) {
585         return provable.getPrice(_datasource, _gasLimit);
586     }
587 
588     function provable_query(string memory _datasource, string memory _arg) provableAPI internal returns (bytes32 _id) {
589         uint price = provable.getPrice(_datasource);
590         if (price > 1 ether + tx.gasprice * 200000) {
591             return 0; // Unexpectedly high price
592         }
593         return provable.query.value(price)(0, _datasource, _arg);
594     }
595 
596     function provable_query(uint _timestamp, string memory _datasource, string memory _arg) provableAPI internal returns (bytes32 _id) {
597         uint price = provable.getPrice(_datasource);
598         if (price > 1 ether + tx.gasprice * 200000) {
599             return 0; // Unexpectedly high price
600         }
601         return provable.query.value(price)(_timestamp, _datasource, _arg);
602     }
603 
604     function provable_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
605         uint price = provable.getPrice(_datasource,_gasLimit);
606         if (price > 1 ether + tx.gasprice * _gasLimit) {
607             return 0; // Unexpectedly high price
608         }
609         return provable.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
610     }
611 
612     function provable_query(string memory _datasource, string memory _arg, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
613         uint price = provable.getPrice(_datasource, _gasLimit);
614         if (price > 1 ether + tx.gasprice * _gasLimit) {
615            return 0; // Unexpectedly high price
616         }
617         return provable.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
618     }
619 
620     function provable_query(string memory _datasource, string memory _arg1, string memory _arg2) provableAPI internal returns (bytes32 _id) {
621         uint price = provable.getPrice(_datasource);
622         if (price > 1 ether + tx.gasprice * 200000) {
623             return 0; // Unexpectedly high price
624         }
625         return provable.query2.value(price)(0, _datasource, _arg1, _arg2);
626     }
627 
628     function provable_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) provableAPI internal returns (bytes32 _id) {
629         uint price = provable.getPrice(_datasource);
630         if (price > 1 ether + tx.gasprice * 200000) {
631             return 0; // Unexpectedly high price
632         }
633         return provable.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
634     }
635 
636     function provable_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
637         uint price = provable.getPrice(_datasource, _gasLimit);
638         if (price > 1 ether + tx.gasprice * _gasLimit) {
639             return 0; // Unexpectedly high price
640         }
641         return provable.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
642     }
643 
644     function provable_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
645         uint price = provable.getPrice(_datasource, _gasLimit);
646         if (price > 1 ether + tx.gasprice * _gasLimit) {
647             return 0; // Unexpectedly high price
648         }
649         return provable.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
650     }
651 
652     function provable_query(string memory _datasource, string[] memory _argN) provableAPI internal returns (bytes32 _id) {
653         uint price = provable.getPrice(_datasource);
654         if (price > 1 ether + tx.gasprice * 200000) {
655             return 0; // Unexpectedly high price
656         }
657         bytes memory args = stra2cbor(_argN);
658         return provable.queryN.value(price)(0, _datasource, args);
659     }
660 
661     function provable_query(uint _timestamp, string memory _datasource, string[] memory _argN) provableAPI internal returns (bytes32 _id) {
662         uint price = provable.getPrice(_datasource);
663         if (price > 1 ether + tx.gasprice * 200000) {
664             return 0; // Unexpectedly high price
665         }
666         bytes memory args = stra2cbor(_argN);
667         return provable.queryN.value(price)(_timestamp, _datasource, args);
668     }
669 
670     function provable_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
671         uint price = provable.getPrice(_datasource, _gasLimit);
672         if (price > 1 ether + tx.gasprice * _gasLimit) {
673             return 0; // Unexpectedly high price
674         }
675         bytes memory args = stra2cbor(_argN);
676         return provable.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
677     }
678 
679     function provable_query(string memory _datasource, string[] memory _argN, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
680         uint price = provable.getPrice(_datasource, _gasLimit);
681         if (price > 1 ether + tx.gasprice * _gasLimit) {
682             return 0; // Unexpectedly high price
683         }
684         bytes memory args = stra2cbor(_argN);
685         return provable.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
686     }
687 
688     function provable_query(string memory _datasource, string[1] memory _args) provableAPI internal returns (bytes32 _id) {
689         string[] memory dynargs = new string[](1);
690         dynargs[0] = _args[0];
691         return provable_query(_datasource, dynargs);
692     }
693 
694     function provable_query(uint _timestamp, string memory _datasource, string[1] memory _args) provableAPI internal returns (bytes32 _id) {
695         string[] memory dynargs = new string[](1);
696         dynargs[0] = _args[0];
697         return provable_query(_timestamp, _datasource, dynargs);
698     }
699 
700     function provable_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
701         string[] memory dynargs = new string[](1);
702         dynargs[0] = _args[0];
703         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
704     }
705 
706     function provable_query(string memory _datasource, string[1] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
707         string[] memory dynargs = new string[](1);
708         dynargs[0] = _args[0];
709         return provable_query(_datasource, dynargs, _gasLimit);
710     }
711 
712     function provable_query(string memory _datasource, string[2] memory _args) provableAPI internal returns (bytes32 _id) {
713         string[] memory dynargs = new string[](2);
714         dynargs[0] = _args[0];
715         dynargs[1] = _args[1];
716         return provable_query(_datasource, dynargs);
717     }
718 
719     function provable_query(uint _timestamp, string memory _datasource, string[2] memory _args) provableAPI internal returns (bytes32 _id) {
720         string[] memory dynargs = new string[](2);
721         dynargs[0] = _args[0];
722         dynargs[1] = _args[1];
723         return provable_query(_timestamp, _datasource, dynargs);
724     }
725 
726     function provable_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
727         string[] memory dynargs = new string[](2);
728         dynargs[0] = _args[0];
729         dynargs[1] = _args[1];
730         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
731     }
732 
733     function provable_query(string memory _datasource, string[2] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
734         string[] memory dynargs = new string[](2);
735         dynargs[0] = _args[0];
736         dynargs[1] = _args[1];
737         return provable_query(_datasource, dynargs, _gasLimit);
738     }
739 
740     function provable_query(string memory _datasource, string[3] memory _args) provableAPI internal returns (bytes32 _id) {
741         string[] memory dynargs = new string[](3);
742         dynargs[0] = _args[0];
743         dynargs[1] = _args[1];
744         dynargs[2] = _args[2];
745         return provable_query(_datasource, dynargs);
746     }
747 
748     function provable_query(uint _timestamp, string memory _datasource, string[3] memory _args) provableAPI internal returns (bytes32 _id) {
749         string[] memory dynargs = new string[](3);
750         dynargs[0] = _args[0];
751         dynargs[1] = _args[1];
752         dynargs[2] = _args[2];
753         return provable_query(_timestamp, _datasource, dynargs);
754     }
755 
756     function provable_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
757         string[] memory dynargs = new string[](3);
758         dynargs[0] = _args[0];
759         dynargs[1] = _args[1];
760         dynargs[2] = _args[2];
761         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
762     }
763 
764     function provable_query(string memory _datasource, string[3] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
765         string[] memory dynargs = new string[](3);
766         dynargs[0] = _args[0];
767         dynargs[1] = _args[1];
768         dynargs[2] = _args[2];
769         return provable_query(_datasource, dynargs, _gasLimit);
770     }
771 
772     function provable_query(string memory _datasource, string[4] memory _args) provableAPI internal returns (bytes32 _id) {
773         string[] memory dynargs = new string[](4);
774         dynargs[0] = _args[0];
775         dynargs[1] = _args[1];
776         dynargs[2] = _args[2];
777         dynargs[3] = _args[3];
778         return provable_query(_datasource, dynargs);
779     }
780 
781     function provable_query(uint _timestamp, string memory _datasource, string[4] memory _args) provableAPI internal returns (bytes32 _id) {
782         string[] memory dynargs = new string[](4);
783         dynargs[0] = _args[0];
784         dynargs[1] = _args[1];
785         dynargs[2] = _args[2];
786         dynargs[3] = _args[3];
787         return provable_query(_timestamp, _datasource, dynargs);
788     }
789 
790     function provable_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
791         string[] memory dynargs = new string[](4);
792         dynargs[0] = _args[0];
793         dynargs[1] = _args[1];
794         dynargs[2] = _args[2];
795         dynargs[3] = _args[3];
796         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
797     }
798 
799     function provable_query(string memory _datasource, string[4] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
800         string[] memory dynargs = new string[](4);
801         dynargs[0] = _args[0];
802         dynargs[1] = _args[1];
803         dynargs[2] = _args[2];
804         dynargs[3] = _args[3];
805         return provable_query(_datasource, dynargs, _gasLimit);
806     }
807 
808     function provable_query(string memory _datasource, string[5] memory _args) provableAPI internal returns (bytes32 _id) {
809         string[] memory dynargs = new string[](5);
810         dynargs[0] = _args[0];
811         dynargs[1] = _args[1];
812         dynargs[2] = _args[2];
813         dynargs[3] = _args[3];
814         dynargs[4] = _args[4];
815         return provable_query(_datasource, dynargs);
816     }
817 
818     function provable_query(uint _timestamp, string memory _datasource, string[5] memory _args) provableAPI internal returns (bytes32 _id) {
819         string[] memory dynargs = new string[](5);
820         dynargs[0] = _args[0];
821         dynargs[1] = _args[1];
822         dynargs[2] = _args[2];
823         dynargs[3] = _args[3];
824         dynargs[4] = _args[4];
825         return provable_query(_timestamp, _datasource, dynargs);
826     }
827 
828     function provable_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
829         string[] memory dynargs = new string[](5);
830         dynargs[0] = _args[0];
831         dynargs[1] = _args[1];
832         dynargs[2] = _args[2];
833         dynargs[3] = _args[3];
834         dynargs[4] = _args[4];
835         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
836     }
837 
838     function provable_query(string memory _datasource, string[5] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
839         string[] memory dynargs = new string[](5);
840         dynargs[0] = _args[0];
841         dynargs[1] = _args[1];
842         dynargs[2] = _args[2];
843         dynargs[3] = _args[3];
844         dynargs[4] = _args[4];
845         return provable_query(_datasource, dynargs, _gasLimit);
846     }
847 
848     function provable_query(string memory _datasource, bytes[] memory _argN) provableAPI internal returns (bytes32 _id) {
849         uint price = provable.getPrice(_datasource);
850         if (price > 1 ether + tx.gasprice * 200000) {
851             return 0; // Unexpectedly high price
852         }
853         bytes memory args = ba2cbor(_argN);
854         return provable.queryN.value(price)(0, _datasource, args);
855     }
856 
857     function provable_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) provableAPI internal returns (bytes32 _id) {
858         uint price = provable.getPrice(_datasource);
859         if (price > 1 ether + tx.gasprice * 200000) {
860             return 0; // Unexpectedly high price
861         }
862         bytes memory args = ba2cbor(_argN);
863         return provable.queryN.value(price)(_timestamp, _datasource, args);
864     }
865 
866     function provable_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
867         uint price = provable.getPrice(_datasource, _gasLimit);
868         if (price > 1 ether + tx.gasprice * _gasLimit) {
869             return 0; // Unexpectedly high price
870         }
871         bytes memory args = ba2cbor(_argN);
872         return provable.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
873     }
874 
875     function provable_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
876         uint price = provable.getPrice(_datasource, _gasLimit);
877         if (price > 1 ether + tx.gasprice * _gasLimit) {
878             return 0; // Unexpectedly high price
879         }
880         bytes memory args = ba2cbor(_argN);
881         return provable.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
882     }
883 
884     function provable_query(string memory _datasource, bytes[1] memory _args) provableAPI internal returns (bytes32 _id) {
885         bytes[] memory dynargs = new bytes[](1);
886         dynargs[0] = _args[0];
887         return provable_query(_datasource, dynargs);
888     }
889 
890     function provable_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) provableAPI internal returns (bytes32 _id) {
891         bytes[] memory dynargs = new bytes[](1);
892         dynargs[0] = _args[0];
893         return provable_query(_timestamp, _datasource, dynargs);
894     }
895 
896     function provable_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
897         bytes[] memory dynargs = new bytes[](1);
898         dynargs[0] = _args[0];
899         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
900     }
901 
902     function provable_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
903         bytes[] memory dynargs = new bytes[](1);
904         dynargs[0] = _args[0];
905         return provable_query(_datasource, dynargs, _gasLimit);
906     }
907 
908     function provable_query(string memory _datasource, bytes[2] memory _args) provableAPI internal returns (bytes32 _id) {
909         bytes[] memory dynargs = new bytes[](2);
910         dynargs[0] = _args[0];
911         dynargs[1] = _args[1];
912         return provable_query(_datasource, dynargs);
913     }
914 
915     function provable_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) provableAPI internal returns (bytes32 _id) {
916         bytes[] memory dynargs = new bytes[](2);
917         dynargs[0] = _args[0];
918         dynargs[1] = _args[1];
919         return provable_query(_timestamp, _datasource, dynargs);
920     }
921 
922     function provable_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
923         bytes[] memory dynargs = new bytes[](2);
924         dynargs[0] = _args[0];
925         dynargs[1] = _args[1];
926         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
927     }
928 
929     function provable_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
930         bytes[] memory dynargs = new bytes[](2);
931         dynargs[0] = _args[0];
932         dynargs[1] = _args[1];
933         return provable_query(_datasource, dynargs, _gasLimit);
934     }
935 
936     function provable_query(string memory _datasource, bytes[3] memory _args) provableAPI internal returns (bytes32 _id) {
937         bytes[] memory dynargs = new bytes[](3);
938         dynargs[0] = _args[0];
939         dynargs[1] = _args[1];
940         dynargs[2] = _args[2];
941         return provable_query(_datasource, dynargs);
942     }
943 
944     function provable_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) provableAPI internal returns (bytes32 _id) {
945         bytes[] memory dynargs = new bytes[](3);
946         dynargs[0] = _args[0];
947         dynargs[1] = _args[1];
948         dynargs[2] = _args[2];
949         return provable_query(_timestamp, _datasource, dynargs);
950     }
951 
952     function provable_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
953         bytes[] memory dynargs = new bytes[](3);
954         dynargs[0] = _args[0];
955         dynargs[1] = _args[1];
956         dynargs[2] = _args[2];
957         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
958     }
959 
960     function provable_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
961         bytes[] memory dynargs = new bytes[](3);
962         dynargs[0] = _args[0];
963         dynargs[1] = _args[1];
964         dynargs[2] = _args[2];
965         return provable_query(_datasource, dynargs, _gasLimit);
966     }
967 
968     function provable_query(string memory _datasource, bytes[4] memory _args) provableAPI internal returns (bytes32 _id) {
969         bytes[] memory dynargs = new bytes[](4);
970         dynargs[0] = _args[0];
971         dynargs[1] = _args[1];
972         dynargs[2] = _args[2];
973         dynargs[3] = _args[3];
974         return provable_query(_datasource, dynargs);
975     }
976 
977     function provable_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) provableAPI internal returns (bytes32 _id) {
978         bytes[] memory dynargs = new bytes[](4);
979         dynargs[0] = _args[0];
980         dynargs[1] = _args[1];
981         dynargs[2] = _args[2];
982         dynargs[3] = _args[3];
983         return provable_query(_timestamp, _datasource, dynargs);
984     }
985 
986     function provable_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
987         bytes[] memory dynargs = new bytes[](4);
988         dynargs[0] = _args[0];
989         dynargs[1] = _args[1];
990         dynargs[2] = _args[2];
991         dynargs[3] = _args[3];
992         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
993     }
994 
995     function provable_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
996         bytes[] memory dynargs = new bytes[](4);
997         dynargs[0] = _args[0];
998         dynargs[1] = _args[1];
999         dynargs[2] = _args[2];
1000         dynargs[3] = _args[3];
1001         return provable_query(_datasource, dynargs, _gasLimit);
1002     }
1003 
1004     function provable_query(string memory _datasource, bytes[5] memory _args) provableAPI internal returns (bytes32 _id) {
1005         bytes[] memory dynargs = new bytes[](5);
1006         dynargs[0] = _args[0];
1007         dynargs[1] = _args[1];
1008         dynargs[2] = _args[2];
1009         dynargs[3] = _args[3];
1010         dynargs[4] = _args[4];
1011         return provable_query(_datasource, dynargs);
1012     }
1013 
1014     function provable_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) provableAPI internal returns (bytes32 _id) {
1015         bytes[] memory dynargs = new bytes[](5);
1016         dynargs[0] = _args[0];
1017         dynargs[1] = _args[1];
1018         dynargs[2] = _args[2];
1019         dynargs[3] = _args[3];
1020         dynargs[4] = _args[4];
1021         return provable_query(_timestamp, _datasource, dynargs);
1022     }
1023 
1024     function provable_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
1025         bytes[] memory dynargs = new bytes[](5);
1026         dynargs[0] = _args[0];
1027         dynargs[1] = _args[1];
1028         dynargs[2] = _args[2];
1029         dynargs[3] = _args[3];
1030         dynargs[4] = _args[4];
1031         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
1032     }
1033 
1034     function provable_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
1035         bytes[] memory dynargs = new bytes[](5);
1036         dynargs[0] = _args[0];
1037         dynargs[1] = _args[1];
1038         dynargs[2] = _args[2];
1039         dynargs[3] = _args[3];
1040         dynargs[4] = _args[4];
1041         return provable_query(_datasource, dynargs, _gasLimit);
1042     }
1043 
1044     function provable_setProof(byte _proofP) provableAPI internal {
1045         return provable.setProofType(_proofP);
1046     }
1047 
1048 
1049     function provable_cbAddress() provableAPI internal returns (address _callbackAddress) {
1050         return provable.cbAddress();
1051     }
1052 
1053     function getCodeSize(address _addr) view internal returns (uint _size) {
1054         assembly {
1055             _size := extcodesize(_addr)
1056         }
1057     }
1058 
1059     function provable_setCustomGasPrice(uint _gasPrice) provableAPI internal {
1060         return provable.setCustomGasPrice(_gasPrice);
1061     }
1062 
1063     function provable_randomDS_getSessionPubKeyHash() provableAPI internal returns (bytes32 _sessionKeyHash) {
1064         return provable.randomDS_getSessionPubKeyHash();
1065     }
1066 
1067     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
1068         bytes memory tmp = bytes(_a);
1069         uint160 iaddr = 0;
1070         uint160 b1;
1071         uint160 b2;
1072         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
1073             iaddr *= 256;
1074             b1 = uint160(uint8(tmp[i]));
1075             b2 = uint160(uint8(tmp[i + 1]));
1076             if ((b1 >= 97) && (b1 <= 102)) {
1077                 b1 -= 87;
1078             } else if ((b1 >= 65) && (b1 <= 70)) {
1079                 b1 -= 55;
1080             } else if ((b1 >= 48) && (b1 <= 57)) {
1081                 b1 -= 48;
1082             }
1083             if ((b2 >= 97) && (b2 <= 102)) {
1084                 b2 -= 87;
1085             } else if ((b2 >= 65) && (b2 <= 70)) {
1086                 b2 -= 55;
1087             } else if ((b2 >= 48) && (b2 <= 57)) {
1088                 b2 -= 48;
1089             }
1090             iaddr += (b1 * 16 + b2);
1091         }
1092         return address(iaddr);
1093     }
1094 
1095     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
1096         bytes memory a = bytes(_a);
1097         bytes memory b = bytes(_b);
1098         uint minLength = a.length;
1099         if (b.length < minLength) {
1100             minLength = b.length;
1101         }
1102         for (uint i = 0; i < minLength; i ++) {
1103             if (a[i] < b[i]) {
1104                 return -1;
1105             } else if (a[i] > b[i]) {
1106                 return 1;
1107             }
1108         }
1109         if (a.length < b.length) {
1110             return -1;
1111         } else if (a.length > b.length) {
1112             return 1;
1113         } else {
1114             return 0;
1115         }
1116     }
1117 
1118     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
1119         bytes memory h = bytes(_haystack);
1120         bytes memory n = bytes(_needle);
1121         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
1122             return -1;
1123         } else if (h.length > (2 ** 128 - 1)) {
1124             return -1;
1125         } else {
1126             uint subindex = 0;
1127             for (uint i = 0; i < h.length; i++) {
1128                 if (h[i] == n[0]) {
1129                     subindex = 1;
1130                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
1131                         subindex++;
1132                     }
1133                     if (subindex == n.length) {
1134                         return int(i);
1135                     }
1136                 }
1137             }
1138             return -1;
1139         }
1140     }
1141 
1142     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
1143         return strConcat(_a, _b, "", "", "");
1144     }
1145 
1146     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
1147         return strConcat(_a, _b, _c, "", "");
1148     }
1149 
1150     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
1151         return strConcat(_a, _b, _c, _d, "");
1152     }
1153 
1154     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
1155         bytes memory _ba = bytes(_a);
1156         bytes memory _bb = bytes(_b);
1157         bytes memory _bc = bytes(_c);
1158         bytes memory _bd = bytes(_d);
1159         bytes memory _be = bytes(_e);
1160         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1161         bytes memory babcde = bytes(abcde);
1162         uint k = 0;
1163         uint i = 0;
1164         for (i = 0; i < _ba.length; i++) {
1165             babcde[k++] = _ba[i];
1166         }
1167         for (i = 0; i < _bb.length; i++) {
1168             babcde[k++] = _bb[i];
1169         }
1170         for (i = 0; i < _bc.length; i++) {
1171             babcde[k++] = _bc[i];
1172         }
1173         for (i = 0; i < _bd.length; i++) {
1174             babcde[k++] = _bd[i];
1175         }
1176         for (i = 0; i < _be.length; i++) {
1177             babcde[k++] = _be[i];
1178         }
1179         return string(babcde);
1180     }
1181 
1182     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
1183         return safeParseInt(_a, 0);
1184     }
1185 
1186     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1187         bytes memory bresult = bytes(_a);
1188         uint mint = 0;
1189         bool decimals = false;
1190         for (uint i = 0; i < bresult.length; i++) {
1191             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1192                 if (decimals) {
1193                    if (_b == 0) break;
1194                     else _b--;
1195                 }
1196                 mint *= 10;
1197                 mint += uint(uint8(bresult[i])) - 48;
1198             } else if (uint(uint8(bresult[i])) == 46) {
1199                 require(!decimals, 'More than one decimal encountered in string!');
1200                 decimals = true;
1201             } else {
1202                 revert("Non-numeral character encountered in string!");
1203             }
1204         }
1205         if (_b > 0) {
1206             mint *= 10 ** _b;
1207         }
1208         return mint;
1209     }
1210 
1211     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
1212         return parseInt(_a, 0);
1213     }
1214 
1215     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1216         bytes memory bresult = bytes(_a);
1217         uint mint = 0;
1218         bool decimals = false;
1219         for (uint i = 0; i < bresult.length; i++) {
1220             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1221                 if (decimals) {
1222                    if (_b == 0) {
1223                        break;
1224                    } else {
1225                        _b--;
1226                    }
1227                 }
1228                 mint *= 10;
1229                 mint += uint(uint8(bresult[i])) - 48;
1230             } else if (uint(uint8(bresult[i])) == 46) {
1231                 decimals = true;
1232             }
1233         }
1234         if (_b > 0) {
1235             mint *= 10 ** _b;
1236         }
1237         return mint;
1238     }
1239 
1240     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1241         if (_i == 0) {
1242             return "0";
1243         }
1244         uint j = _i;
1245         uint len;
1246         while (j != 0) {
1247             len++;
1248             j /= 10;
1249         }
1250         bytes memory bstr = new bytes(len);
1251         uint k = len - 1;
1252         while (_i != 0) {
1253             bstr[k--] = byte(uint8(48 + _i % 10));
1254             _i /= 10;
1255         }
1256         return string(bstr);
1257     }
1258 
1259     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1260         safeMemoryCleaner();
1261         Buffer.buffer memory buf;
1262         Buffer.init(buf, 1024);
1263         buf.startArray();
1264         for (uint i = 0; i < _arr.length; i++) {
1265             buf.encodeString(_arr[i]);
1266         }
1267         buf.endSequence();
1268         return buf.buf;
1269     }
1270 
1271     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1272         safeMemoryCleaner();
1273         Buffer.buffer memory buf;
1274         Buffer.init(buf, 1024);
1275         buf.startArray();
1276         for (uint i = 0; i < _arr.length; i++) {
1277             buf.encodeBytes(_arr[i]);
1278         }
1279         buf.endSequence();
1280         return buf.buf;
1281     }
1282 
1283     function provable_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1284         require((_nbytes > 0) && (_nbytes <= 32));
1285         _delay *= 10; // Convert from seconds to ledger timer ticks
1286         bytes memory nbytes = new bytes(1);
1287         nbytes[0] = byte(uint8(_nbytes));
1288         bytes memory unonce = new bytes(32);
1289         bytes memory sessionKeyHash = new bytes(32);
1290         bytes32 sessionKeyHash_bytes32 = provable_randomDS_getSessionPubKeyHash();
1291         assembly {
1292             mstore(unonce, 0x20)
1293             /*
1294              The following variables can be relaxed.
1295              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1296              for an idea on how to override and replace commit hash variables.
1297             */
1298             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1299             mstore(sessionKeyHash, 0x20)
1300             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1301         }
1302         bytes memory delay = new bytes(32);
1303         assembly {
1304             mstore(add(delay, 0x20), _delay)
1305         }
1306         bytes memory delay_bytes8 = new bytes(8);
1307         copyBytes(delay, 24, 8, delay_bytes8, 0);
1308         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1309         bytes32 queryId = provable_query("random", args, _customGasLimit);
1310         bytes memory delay_bytes8_left = new bytes(8);
1311         assembly {
1312             let x := mload(add(delay_bytes8, 0x20))
1313             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1314             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1315             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1316             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1317             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1318             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1319             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1320             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1321         }
1322         provable_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1323         return queryId;
1324     }
1325 
1326     function provable_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1327         provable_randomDS_args[_queryId] = _commitment;
1328     }
1329 
1330     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1331         bool sigok;
1332         address signer;
1333         bytes32 sigr;
1334         bytes32 sigs;
1335         bytes memory sigr_ = new bytes(32);
1336         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1337         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1338         bytes memory sigs_ = new bytes(32);
1339         offset += 32 + 2;
1340         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1341         assembly {
1342             sigr := mload(add(sigr_, 32))
1343             sigs := mload(add(sigs_, 32))
1344         }
1345         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1346         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1347             return true;
1348         } else {
1349             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1350             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1351         }
1352     }
1353 
1354     function provable_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1355         bool sigok;
1356         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1357         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1358         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1359         bytes memory appkey1_pubkey = new bytes(64);
1360         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1361         bytes memory tosign2 = new bytes(1 + 65 + 32);
1362         tosign2[0] = byte(uint8(1)); //role
1363         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1364         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1365         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1366         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1367         if (!sigok) {
1368             return false;
1369         }
1370         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1371         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1372         bytes memory tosign3 = new bytes(1 + 65);
1373         tosign3[0] = 0xFE;
1374         copyBytes(_proof, 3, 65, tosign3, 1);
1375         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1376         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1377         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1378         return sigok;
1379     }
1380 
1381     function provable_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1382         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1383         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1384             return 1;
1385         }
1386         bool proofVerified = provable_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), provable_getNetworkName());
1387         if (!proofVerified) {
1388             return 2;
1389         }
1390         return 0;
1391     }
1392 
1393     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1394         bool match_ = true;
1395         require(_prefix.length == _nRandomBytes);
1396         for (uint256 i = 0; i< _nRandomBytes; i++) {
1397             if (_content[i] != _prefix[i]) {
1398                 match_ = false;
1399             }
1400         }
1401         return match_;
1402     }
1403 
1404     function provable_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1405         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1406         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1407         bytes memory keyhash = new bytes(32);
1408         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1409         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1410             return false;
1411         }
1412         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1413         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1414         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1415         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1416             return false;
1417         }
1418         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1419         // This is to verify that the computed args match with the ones specified in the query.
1420         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1421         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1422         bytes memory sessionPubkey = new bytes(64);
1423         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1424         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1425         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1426         if (provable_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1427             delete provable_randomDS_args[_queryId];
1428         } else return false;
1429         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1430         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1431         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1432         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1433             return false;
1434         }
1435         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1436         if (!provable_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1437             provable_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = provable_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1438         }
1439         return provable_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1440     }
1441     /*
1442      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1443     */
1444     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1445         uint minLength = _length + _toOffset;
1446         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1447         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1448         uint j = 32 + _toOffset;
1449         while (i < (32 + _fromOffset + _length)) {
1450             assembly {
1451                 let tmp := mload(add(_from, i))
1452                 mstore(add(_to, j), tmp)
1453             }
1454             i += 32;
1455             j += 32;
1456         }
1457         return _to;
1458     }
1459     /*
1460      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1461      Duplicate Solidity's ecrecover, but catching the CALL return value
1462     */
1463     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1464         /*
1465          We do our own memory management here. Solidity uses memory offset
1466          0x40 to store the current end of memory. We write past it (as
1467          writes are memory extensions), but don't update the offset so
1468          Solidity will reuse it. The memory used here is only needed for
1469          this context.
1470          FIXME: inline assembly can't access return values
1471         */
1472         bool ret;
1473         address addr;
1474         assembly {
1475             let size := mload(0x40)
1476             mstore(size, _hash)
1477             mstore(add(size, 32), _v)
1478             mstore(add(size, 64), _r)
1479             mstore(add(size, 96), _s)
1480             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1481             addr := mload(size)
1482         }
1483         return (ret, addr);
1484     }
1485     /*
1486      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1487     */
1488     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1489         bytes32 r;
1490         bytes32 s;
1491         uint8 v;
1492         if (_sig.length != 65) {
1493             return (false, address(0));
1494         }
1495         /*
1496          The signature format is a compact form of:
1497            {bytes32 r}{bytes32 s}{uint8 v}
1498          Compact means, uint8 is not padded to 32 bytes.
1499         */
1500         assembly {
1501             r := mload(add(_sig, 32))
1502             s := mload(add(_sig, 64))
1503             /*
1504              Here we are loading the last 32 bytes. We exploit the fact that
1505              'mload' will pad with zeroes if we overread.
1506              There is no 'mload8' to do this, but that would be nicer.
1507             */
1508             v := byte(0, mload(add(_sig, 96)))
1509             /*
1510               Alternative solution:
1511               'byte' is not working due to the Solidity parser, so lets
1512               use the second best option, 'and'
1513               v := and(mload(add(_sig, 65)), 255)
1514             */
1515         }
1516         /*
1517          albeit non-transactional signatures are not specified by the YP, one would expect it
1518          to match the YP range of [27, 28]
1519          geth uses [0, 1] and some clients have followed. This might change, see:
1520          https://github.com/ethereum/go-ethereum/issues/2053
1521         */
1522         if (v < 27) {
1523             v += 27;
1524         }
1525         if (v != 27 && v != 28) {
1526             return (false, address(0));
1527         }
1528         return safer_ecrecover(_hash, v, r, s);
1529     }
1530 
1531     function safeMemoryCleaner() internal pure {
1532         assembly {
1533             let fmem := mload(0x40)
1534             codecopy(fmem, codesize, sub(msize, fmem))
1535         }
1536     }
1537 }
1538 // </provableAPI>
1539 
1540 // File: contracts/lib/Queryable.sol
1541 
1542 pragma solidity ^0.5.0;
1543 
1544 
1545 
1546 
1547 contract Queryable is usingProvable, Ownable {
1548 	uint32 public queryGasLimit = 700000;
1549 
1550 	function setQueryGasLimit(uint32 _gasLimit) public onlyOwner {
1551 		queryGasLimit = _gasLimit;
1552 	}
1553 }
1554 
1555 // File: contracts/QueryNpmAuthentication.sol
1556 
1557 pragma solidity ^0.5.0;
1558 
1559 
1560 
1561 
1562 contract QueryNpmAuthentication is Queryable, Chargeable {
1563 	mapping(bytes32 => address) internal callbackDestinations;
1564 
1565 	function query(string calldata _package, string calldata _readOnlyToken)
1566 		external
1567 		returns (bytes32)
1568 	{
1569 		require(
1570 			provable_getPrice("URL", queryGasLimit) < charged(),
1571 			"Calculation query was NOT sent"
1572 		);
1573 		string memory url = string(
1574 			abi.encodePacked(
1575 				"https://dev-protocol-npm-market.now.sh/",
1576 				_package,
1577 				"/",
1578 				_readOnlyToken
1579 			)
1580 		);
1581 		bytes32 id = provable_query("URL", url, queryGasLimit);
1582 		callbackDestinations[id] = msg.sender;
1583 		return id;
1584 	}
1585 
1586 	// It is expected to be called by [Oraclize](https://docs.oraclize.it/#ethereum-quick-start).
1587 	function __callback(bytes32 _id, string memory _result) public {
1588 		if (msg.sender != provable_cbAddress()) {
1589 			revert("mismatch oraclize_cbAddress");
1590 		}
1591 		address callback = callbackDestinations[_id];
1592 		uint256 result = parseInt(_result);
1593 		NpmMarket(callback).authenticated(_id, result);
1594 	}
1595 }
1596 
1597 // File: @openzeppelin/contracts/math/SafeMath.sol
1598 
1599 pragma solidity ^0.5.0;
1600 
1601 /**
1602  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1603  * checks.
1604  *
1605  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1606  * in bugs, because programmers usually assume that an overflow raises an
1607  * error, which is the standard behavior in high level programming languages.
1608  * `SafeMath` restores this intuition by reverting the transaction when an
1609  * operation overflows.
1610  *
1611  * Using this library instead of the unchecked operations eliminates an entire
1612  * class of bugs, so it's recommended to use it always.
1613  */
1614 library SafeMath {
1615     /**
1616      * @dev Returns the addition of two unsigned integers, reverting on
1617      * overflow.
1618      *
1619      * Counterpart to Solidity's `+` operator.
1620      *
1621      * Requirements:
1622      * - Addition cannot overflow.
1623      */
1624     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1625         uint256 c = a + b;
1626         require(c >= a, "SafeMath: addition overflow");
1627 
1628         return c;
1629     }
1630 
1631     /**
1632      * @dev Returns the subtraction of two unsigned integers, reverting on
1633      * overflow (when the result is negative).
1634      *
1635      * Counterpart to Solidity's `-` operator.
1636      *
1637      * Requirements:
1638      * - Subtraction cannot overflow.
1639      */
1640     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1641         return sub(a, b, "SafeMath: subtraction overflow");
1642     }
1643 
1644     /**
1645      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1646      * overflow (when the result is negative).
1647      *
1648      * Counterpart to Solidity's `-` operator.
1649      *
1650      * Requirements:
1651      * - Subtraction cannot overflow.
1652      *
1653      * _Available since v2.4.0._
1654      */
1655     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1656         require(b <= a, errorMessage);
1657         uint256 c = a - b;
1658 
1659         return c;
1660     }
1661 
1662     /**
1663      * @dev Returns the multiplication of two unsigned integers, reverting on
1664      * overflow.
1665      *
1666      * Counterpart to Solidity's `*` operator.
1667      *
1668      * Requirements:
1669      * - Multiplication cannot overflow.
1670      */
1671     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1672         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1673         // benefit is lost if 'b' is also tested.
1674         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1675         if (a == 0) {
1676             return 0;
1677         }
1678 
1679         uint256 c = a * b;
1680         require(c / a == b, "SafeMath: multiplication overflow");
1681 
1682         return c;
1683     }
1684 
1685     /**
1686      * @dev Returns the integer division of two unsigned integers. Reverts on
1687      * division by zero. The result is rounded towards zero.
1688      *
1689      * Counterpart to Solidity's `/` operator. Note: this function uses a
1690      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1691      * uses an invalid opcode to revert (consuming all remaining gas).
1692      *
1693      * Requirements:
1694      * - The divisor cannot be zero.
1695      */
1696     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1697         return div(a, b, "SafeMath: division by zero");
1698     }
1699 
1700     /**
1701      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1702      * division by zero. The result is rounded towards zero.
1703      *
1704      * Counterpart to Solidity's `/` operator. Note: this function uses a
1705      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1706      * uses an invalid opcode to revert (consuming all remaining gas).
1707      *
1708      * Requirements:
1709      * - The divisor cannot be zero.
1710      *
1711      * _Available since v2.4.0._
1712      */
1713     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1714         // Solidity only automatically asserts when dividing by 0
1715         require(b > 0, errorMessage);
1716         uint256 c = a / b;
1717         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1718 
1719         return c;
1720     }
1721 
1722     /**
1723      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1724      * Reverts when dividing by zero.
1725      *
1726      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1727      * opcode (which leaves remaining gas untouched) while Solidity uses an
1728      * invalid opcode to revert (consuming all remaining gas).
1729      *
1730      * Requirements:
1731      * - The divisor cannot be zero.
1732      */
1733     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1734         return mod(a, b, "SafeMath: modulo by zero");
1735     }
1736 
1737     /**
1738      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1739      * Reverts with custom message when dividing by zero.
1740      *
1741      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1742      * opcode (which leaves remaining gas untouched) while Solidity uses an
1743      * invalid opcode to revert (consuming all remaining gas).
1744      *
1745      * Requirements:
1746      * - The divisor cannot be zero.
1747      *
1748      * _Available since v2.4.0._
1749      */
1750     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1751         require(b != 0, errorMessage);
1752         return a % b;
1753     }
1754 }
1755 
1756 // File: contracts/lib/Timebased.sol
1757 
1758 pragma solidity ^0.5.0;
1759 
1760 
1761 
1762 
1763 contract Timebased is Ownable {
1764 	using SafeMath for uint256;
1765 	struct BaseTime {
1766 		uint256 timestamp;
1767 		uint256 blockHeight;
1768 	}
1769 	BaseTime internal baseTime;
1770 	uint256 internal secondsPerBlock = 15;
1771 
1772 	constructor() public {
1773 		// solium-disable-next-line security/no-block-members
1774 		baseTime = BaseTime(now, block.number);
1775 	}
1776 
1777 	function setSecondsPerBlock(uint256 _sec) public onlyOwner {
1778 		secondsPerBlock = _sec;
1779 	}
1780 
1781 	function timestamp(uint256 _blockNumber) public view returns (uint256) {
1782 		uint256 diff = _blockNumber.sub(baseTime.blockHeight);
1783 		uint256 sec = diff.mul(secondsPerBlock);
1784 		return baseTime.timestamp.add(sec);
1785 	}
1786 
1787 	function getBaseTime()
1788 		public
1789 		view
1790 		returns (uint256 _timestamp, uint256 _blockHeight)
1791 	{
1792 		return (baseTime.timestamp, baseTime.blockHeight);
1793 	}
1794 
1795 	function setBaseTime(uint256 __timestamp, uint256 __blockHeight)
1796 		public
1797 		onlyOwner
1798 		returns (uint256 _timestamp, uint256 _blockHeight)
1799 	{
1800 		baseTime = BaseTime(__timestamp, __blockHeight);
1801 		return (baseTime.timestamp, baseTime.blockHeight);
1802 	}
1803 }
1804 
1805 // File: contracts/QueryNpmDownloads.sol
1806 
1807 pragma solidity ^0.5.0;
1808 
1809 
1810 
1811 
1812 
1813 contract QueryNpmDownloads is Queryable, Chargeable, Timebased {
1814 	uint24 constant SECONDS_PER_DAY = 86400;
1815 
1816 	mapping(bytes32 => address) internal callbackDestinations;
1817 	event Queried(uint256 _begin, uint256 _end, string _package);
1818 
1819 	function query(
1820 		uint256 _beginTime,
1821 		uint256 _endTime,
1822 		string calldata _package
1823 	) external returns (bytes32) {
1824 		require(
1825 			provable_getPrice("URL", queryGasLimit) < charged(),
1826 			"Calculation query was NOT sent"
1827 		);
1828 		uint256 beginTime = timestamp(_beginTime);
1829 		uint256 endTime = timestamp(_endTime) - SECONDS_PER_DAY;
1830 		require(
1831 			endTime - beginTime > SECONDS_PER_DAY,
1832 			"The calculation period must be at more than 48 hours"
1833 		);
1834 		(string memory begin, string memory end) = date(beginTime, endTime);
1835 		string memory url = string(
1836 			abi.encodePacked(
1837 				"https://api.npmjs.org/downloads/point/",
1838 				begin,
1839 				":",
1840 				end,
1841 				"/",
1842 				_package
1843 			)
1844 		);
1845 		string memory param = string(
1846 			abi.encodePacked("json(", url, ").downloads")
1847 		);
1848 		bytes32 id = provable_query("URL", param, queryGasLimit);
1849 		emit Queried(beginTime, endTime, _package);
1850 		callbackDestinations[id] = msg.sender;
1851 		return id;
1852 	}
1853 
1854 	// It is expected to be called by [Oraclize](https://docs.oraclize.it/#ethereum-quick-start).
1855 	function __callback(bytes32 _id, string memory _result) public {
1856 		if (msg.sender != provable_cbAddress()) {
1857 			revert("mismatch oraclize_cbAddress");
1858 		}
1859 		address callback = callbackDestinations[_id];
1860 		uint256 result = parseInt(_result);
1861 		NpmMarket(callback).calculated(_id, result);
1862 	}
1863 
1864 	// The function is based on bokkypoobah/BokkyPooBahsDateTimeLibrary._daysToDate
1865 	// https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary
1866 	function secondsToDate(uint256 _seconds)
1867 		private
1868 		pure
1869 		returns (uint256 year, uint256 month, uint256 day)
1870 	{
1871 		int256 __days = int256(_seconds / 86400);
1872 
1873 		int256 L = __days + 68569 + 2440588;
1874 		int256 N = (4 * L) / 146097;
1875 		L = L - (146097 * N + 3) / 4;
1876 		int256 _year = (4000 * (L + 1)) / 1461001;
1877 		L = L - (1461 * _year) / 4 + 31;
1878 		int256 _month = (80 * L) / 2447;
1879 		int256 _day = L - (2447 * _month) / 80;
1880 		L = _month / 11;
1881 		_month = _month + 2 - 12 * L;
1882 		_year = 100 * (N - 49) + _year + L;
1883 
1884 		year = uint256(_year);
1885 		month = uint256(_month);
1886 		day = uint256(_day);
1887 	}
1888 
1889 	function dateFormat(uint256 _y, uint256 _m, uint256 _d)
1890 		private
1891 		pure
1892 		returns (string memory)
1893 	{
1894 		return
1895 			string(
1896 				abi.encodePacked(
1897 					uint2str(_y),
1898 					"-",
1899 					uint2str(_m),
1900 					"-",
1901 					uint2str(_d)
1902 				)
1903 			);
1904 	}
1905 
1906 	function date(uint256 _begin, uint256 _end)
1907 		private
1908 		pure
1909 		returns (string memory begin, string memory end)
1910 	{
1911 		(uint256 beginY, uint256 beginM, uint256 beginD) = secondsToDate(
1912 			_begin
1913 		);
1914 		(uint256 endY, uint256 endM, uint256 endD) = secondsToDate(_end);
1915 		string memory beginDate = dateFormat(beginY, beginM, beginD);
1916 		string memory endDate = dateFormat(endY, endM, endD);
1917 		return (beginDate, endDate);
1918 	}
1919 }
1920 
1921 // File: contracts/NpmMarket.sol
1922 
1923 pragma solidity ^0.5.0;
1924 
1925 // prettier-ignore
1926 
1927 
1928 
1929 
1930 
1931 
1932 contract NpmMarket is Ownable {
1933 	string public schema = "['npm package', 'npm token']";
1934 	address public queryNpmAuthentication;
1935 	address public queryNpmDownloads;
1936 	bool public migratable = true;
1937 
1938 	mapping(address => string) internal packages;
1939 	mapping(bytes32 => address) internal metrics;
1940 	mapping(bytes32 => address) internal callbackMarket;
1941 	mapping(bytes32 => address) internal callbackAllocator;
1942 	mapping(bytes32 => address) internal pendingAuthentication;
1943 	mapping(bytes32 => string) internal pendingAuthenticationPackage;
1944 	mapping(bytes32 => address) internal pendingMetrics;
1945 	event Registered(address _metrics, string _package);
1946 	event Authenticated(bytes32 _id, uint256 _result);
1947 	event Calculated(bytes32 _id, uint256 _result);
1948 
1949 	constructor(address _queryNpmAuthentication, address _queryNpmDownloads)
1950 		public
1951 	{
1952 		queryNpmAuthentication = _queryNpmAuthentication;
1953 		queryNpmDownloads = _queryNpmDownloads;
1954 	}
1955 
1956 	function authenticate(
1957 		address _prop,
1958 		string calldata _npmPackage,
1959 		string calldata _npmReadOnlyToken,
1960 		string calldata,
1961 		string calldata,
1962 		string calldata,
1963 		address _dest
1964 	) external returns (bool) {
1965 		bytes32 id = QueryNpmAuthentication(queryNpmAuthentication).query(
1966 			_npmPackage,
1967 			_npmReadOnlyToken
1968 		);
1969 		pendingAuthentication[id] = _prop;
1970 		pendingAuthenticationPackage[id] = _npmPackage;
1971 		callbackMarket[id] = _dest;
1972 		return true;
1973 	}
1974 
1975 	function authenticated(bytes32 _id, uint256 _result) external {
1976 		emit Authenticated(_id, _result);
1977 		address property = pendingAuthentication[_id];
1978 		address dest = callbackMarket[_id];
1979 		string memory package = pendingAuthenticationPackage[_id];
1980 		delete pendingAuthentication[_id];
1981 		delete callbackMarket[_id];
1982 		delete pendingAuthenticationPackage[_id];
1983 		if (_result == 0) {
1984 			return;
1985 		}
1986 		register(property, package, dest);
1987 	}
1988 
1989 	function calculate(address _metrics, uint256 _begin, uint256 _end)
1990 		external
1991 		returns (bool)
1992 	{
1993 		string memory package = packages[_metrics];
1994 		bytes32 id = QueryNpmDownloads(queryNpmDownloads).query(
1995 			_begin,
1996 			_end,
1997 			package
1998 		);
1999 		pendingMetrics[id] = _metrics;
2000 		callbackAllocator[id] = msg.sender;
2001 		return true;
2002 	}
2003 
2004 	function calculated(bytes32 _id, uint256 _result) external {
2005 		emit Calculated(_id, _result);
2006 		address _metrics = pendingMetrics[_id];
2007 		address dest = callbackAllocator[_id];
2008 		delete pendingMetrics[_id];
2009 		delete callbackAllocator[_id];
2010 		IAllocator(dest).calculatedCallback(_metrics, _result);
2011 	}
2012 
2013 	function register(
2014 		address _property,
2015 		string memory _package,
2016 		address _market
2017 	) private {
2018 		bytes32 key = createKey(_package);
2019 		address _metrics = IMarket(_market).authenticatedCallback(
2020 			_property,
2021 			key
2022 		);
2023 		packages[_metrics] = _package;
2024 		metrics[key] = _metrics;
2025 		emit Registered(_metrics, _package);
2026 	}
2027 
2028 	function createKey(string memory _package) private view returns (bytes32) {
2029 		return keccak256(abi.encodePacked(_package));
2030 	}
2031 
2032 	function getPackage(address _metrics)
2033 		external
2034 		view
2035 		returns (string memory)
2036 	{
2037 		return packages[_metrics];
2038 	}
2039 
2040 	function getMetrics(string calldata _package)
2041 		external
2042 		view
2043 		returns (address)
2044 	{
2045 		return metrics[createKey(_package)];
2046 	}
2047 
2048 	function migrate(address _property, string memory _package, address _market)
2049 		public
2050 		onlyOwner
2051 	{
2052 		require(migratable, "now is not migratable");
2053 		register(_property, _package, _market);
2054 	}
2055 
2056 	function done() public onlyOwner {
2057 		migratable = false;
2058 	}
2059 }