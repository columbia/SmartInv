1 pragma solidity 0.5.8;
2 // import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
3 // import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/ownership/Ownable.sol";
4 // import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
5 // import "https://github.com/oraclize/ethereum-api/oraclizeAPI.sol";
6 
7 
8 
9 /**
10  * @title ERC20 interface
11  * @dev see https://eips.ethereum.org/EIPS/eip-20
12  */
13 interface IERC20 {
14     function transfer(address to, uint256 value) external returns (bool);
15 
16     function approve(address spender, uint256 value) external returns (bool);
17 
18     function transferFrom(address from, address to, uint256 value) external returns (bool);
19 
20     function totalSupply() external view returns (uint256);
21 
22     function balanceOf(address who) external view returns (uint256);
23 
24     function allowance(address owner, address spender) external view returns (uint256);
25 
26     event Transfer(address indexed from, address indexed to, uint256 value);
27 
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 
32 /**
33  * @title Ownable
34  * @dev The Ownable contract has an owner address, and provides basic authorization control
35  * functions, this simplifies the implementation of "user permissions".
36  */
37 contract Ownable {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44      * account.
45      */
46     constructor () internal {
47         _owner = msg.sender;
48         emit OwnershipTransferred(address(0), _owner);
49     }
50 
51     /**
52      * @return the address of the owner.
53      */
54     function owner() public view returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(isOwner(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     /**
67      * @return true if `msg.sender` is the owner of the contract.
68      */
69     function isOwner() public view returns (bool) {
70         return msg.sender == _owner;
71     }
72 
73     /**
74      * @dev Allows the current owner to relinquish control of the contract.
75      * It will not be possible to call the functions with the `onlyOwner`
76      * modifier anymore.
77      * @notice Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85     /**
86      * @dev Allows the current owner to transfer control of the contract to a newOwner.
87      * @param newOwner The address to transfer ownership to.
88      */
89     function transferOwnership(address newOwner) public onlyOwner {
90         _transferOwnership(newOwner);
91     }
92 
93     /**
94      * @dev Transfers control of the contract to a newOwner.
95      * @param newOwner The address to transfer ownership to.
96      */
97     function _transferOwnership(address newOwner) internal {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         emit OwnershipTransferred(_owner, newOwner);
100         _owner = newOwner;
101     }
102 }
103 
104 /**
105  * @title SafeMath
106  * @dev Unsigned math operations with safety checks that revert on error.
107  */
108 library SafeMath {
109     /**
110      * @dev Multiplies two unsigned integers, reverts on overflow.
111      */
112     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
113         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
114         // benefit is lost if 'b' is also tested.
115         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
116         if (a == 0) {
117             return 0;
118         }
119 
120         uint256 c = a * b;
121         require(c / a == b, "SafeMath: multiplication overflow");
122 
123         return c;
124     }
125 
126     /**
127      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
128      */
129     function div(uint256 a, uint256 b) internal pure returns (uint256) {
130         // Solidity only automatically asserts when dividing by 0
131         require(b > 0, "SafeMath: division by zero");
132         uint256 c = a / b;
133         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134 
135         return c;
136     }
137 
138     /**
139      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
140      */
141     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142         require(b <= a, "SafeMath: subtraction overflow");
143         uint256 c = a - b;
144 
145         return c;
146     }
147 
148     /**
149      * @dev Adds two unsigned integers, reverts on overflow.
150      */
151     function add(uint256 a, uint256 b) internal pure returns (uint256) {
152         uint256 c = a + b;
153         require(c >= a, "SafeMath: addition overflow");
154 
155         return c;
156     }
157 
158     /**
159      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
160      * reverts when dividing by zero.
161      */
162     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
163         require(b != 0, "SafeMath: modulo by zero");
164         return a % b;
165     }
166 }
167 
168 
169 /*
170 ORACLIZE_API
171 Copyright (c) 2015-2016 Oraclize SRL
172 Copyright (c) 2016 Oraclize LTD
173 Permission is hereby granted, free of charge, to any person obtaining a copy
174 of this software and associated documentation files (the "Software"), to deal
175 in the Software without restriction, including without limitation the rights
176 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
177 copies of the Software, and to permit persons to whom the Software is
178 furnished to do so, subject to the following conditions:
179 The above copyright notice and this permission notice shall be included in
180 all copies or substantial portions of the Software.
181 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
182 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
183 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
184 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
185 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
186 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
187 THE SOFTWARE.
188 */
189 pragma solidity >= 0.5.0 < 0.6.0; // Incompatible compiler version - please select a compiler within the stated pragma range, or use a different version of the oraclizeAPI!
190 
191 // Dummy contract only used to emit to end-user they are using wrong solc
192 contract solcChecker {
193 /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;
194 }
195 
196 contract OraclizeI {
197 
198     address public cbAddress;
199 
200     function setProofType(byte _proofType) external;
201     function setCustomGasPrice(uint _gasPrice) external;
202     function getPrice(string memory _datasource) public returns (uint _dsprice);
203     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
204     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
205     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
206     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
207     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
208     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
209     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
210     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
211 }
212 
213 contract OraclizeAddrResolverI {
214     function getAddress() public returns (address _address);
215 }
216 /*
217 Begin solidity-cborutils
218 https://github.com/smartcontractkit/solidity-cborutils
219 MIT License
220 Copyright (c) 2018 SmartContract ChainLink, Ltd.
221 Permission is hereby granted, free of charge, to any person obtaining a copy
222 of this software and associated documentation files (the "Software"), to deal
223 in the Software without restriction, including without limitation the rights
224 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
225 copies of the Software, and to permit persons to whom the Software is
226 furnished to do so, subject to the following conditions:
227 The above copyright notice and this permission notice shall be included in all
228 copies or substantial portions of the Software.
229 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
230 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
231 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
232 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
233 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
234 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
235 SOFTWARE.
236 */
237 library Buffer {
238 
239     struct buffer {
240         bytes buf;
241         uint capacity;
242     }
243 
244     function init(buffer memory _buf, uint _capacity) internal pure {
245         uint capacity = _capacity;
246         if (capacity % 32 != 0) {
247             capacity += 32 - (capacity % 32);
248         }
249         _buf.capacity = capacity; // Allocate space for the buffer data
250         assembly {
251             let ptr := mload(0x40)
252             mstore(_buf, ptr)
253             mstore(ptr, 0)
254             mstore(0x40, add(ptr, capacity))
255         }
256     }
257 
258     function resize(buffer memory _buf, uint _capacity) private pure {
259         bytes memory oldbuf = _buf.buf;
260         init(_buf, _capacity);
261         append(_buf, oldbuf);
262     }
263 
264     function max(uint _a, uint _b) private pure returns (uint _max) {
265         if (_a > _b) {
266             return _a;
267         }
268         return _b;
269     }
270     /**
271       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
272       *      would exceed the capacity of the buffer.
273       * @param _buf The buffer to append to.
274       * @param _data The data to append.
275       * @return The original buffer.
276       *
277       */
278     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
279         if (_data.length + _buf.buf.length > _buf.capacity) {
280             resize(_buf, max(_buf.capacity, _data.length) * 2);
281         }
282         uint dest;
283         uint src;
284         uint len = _data.length;
285         assembly {
286             let bufptr := mload(_buf) // Memory address of the buffer data
287             let buflen := mload(bufptr) // Length of existing buffer data
288             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
289             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
290             src := add(_data, 32)
291         }
292         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
293             assembly {
294                 mstore(dest, mload(src))
295             }
296             dest += 32;
297             src += 32;
298         }
299         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
300         assembly {
301             let srcpart := and(mload(src), not(mask))
302             let destpart := and(mload(dest), mask)
303             mstore(dest, or(destpart, srcpart))
304         }
305         return _buf;
306     }
307     /**
308       *
309       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
310       * exceed the capacity of the buffer.
311       * @param _buf The buffer to append to.
312       * @param _data The data to append.
313       * @return The original buffer.
314       *
315       */
316     function append(buffer memory _buf, uint8 _data) internal pure {
317         if (_buf.buf.length + 1 > _buf.capacity) {
318             resize(_buf, _buf.capacity * 2);
319         }
320         assembly {
321             let bufptr := mload(_buf) // Memory address of the buffer data
322             let buflen := mload(bufptr) // Length of existing buffer data
323             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
324             mstore8(dest, _data)
325             mstore(bufptr, add(buflen, 1)) // Update buffer length
326         }
327     }
328     /**
329       *
330       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
331       * exceed the capacity of the buffer.
332       * @param _buf The buffer to append to.
333       * @param _data The data to append.
334       * @return The original buffer.
335       *
336       */
337     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
338         if (_len + _buf.buf.length > _buf.capacity) {
339             resize(_buf, max(_buf.capacity, _len) * 2);
340         }
341         uint mask = 256 ** _len - 1;
342         assembly {
343             let bufptr := mload(_buf) // Memory address of the buffer data
344             let buflen := mload(bufptr) // Length of existing buffer data
345             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
346             mstore(dest, or(and(mload(dest), not(mask)), _data))
347             mstore(bufptr, add(buflen, _len)) // Update buffer length
348         }
349         return _buf;
350     }
351 }
352 
353 library CBOR {
354 
355     using Buffer for Buffer.buffer;
356 
357     uint8 private constant MAJOR_TYPE_INT = 0;
358     uint8 private constant MAJOR_TYPE_MAP = 5;
359     uint8 private constant MAJOR_TYPE_BYTES = 2;
360     uint8 private constant MAJOR_TYPE_ARRAY = 4;
361     uint8 private constant MAJOR_TYPE_STRING = 3;
362     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
363     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
364 
365     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
366         if (_value <= 23) {
367             _buf.append(uint8((_major << 5) | _value));
368         } else if (_value <= 0xFF) {
369             _buf.append(uint8((_major << 5) | 24));
370             _buf.appendInt(_value, 1);
371         } else if (_value <= 0xFFFF) {
372             _buf.append(uint8((_major << 5) | 25));
373             _buf.appendInt(_value, 2);
374         } else if (_value <= 0xFFFFFFFF) {
375             _buf.append(uint8((_major << 5) | 26));
376             _buf.appendInt(_value, 4);
377         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
378             _buf.append(uint8((_major << 5) | 27));
379             _buf.appendInt(_value, 8);
380         }
381     }
382 
383     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
384         _buf.append(uint8((_major << 5) | 31));
385     }
386 
387     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
388         encodeType(_buf, MAJOR_TYPE_INT, _value);
389     }
390 
391     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
392         if (_value >= 0) {
393             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
394         } else {
395             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
396         }
397     }
398 
399     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
400         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
401         _buf.append(_value);
402     }
403 
404     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
405         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
406         _buf.append(bytes(_value));
407     }
408 
409     function startArray(Buffer.buffer memory _buf) internal pure {
410         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
411     }
412 
413     function startMap(Buffer.buffer memory _buf) internal pure {
414         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
415     }
416 
417     function endSequence(Buffer.buffer memory _buf) internal pure {
418         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
419     }
420 }
421 /*
422 End solidity-cborutils
423 */
424 contract usingOraclize {
425 
426     using CBOR for Buffer.buffer;
427 
428     OraclizeI oraclize;
429     OraclizeAddrResolverI OAR;
430 
431     uint constant day = 60 * 60 * 24;
432     uint constant week = 60 * 60 * 24 * 7;
433     uint constant month = 60 * 60 * 24 * 30;
434 
435     byte constant proofType_NONE = 0x00;
436     byte constant proofType_Ledger = 0x30;
437     byte constant proofType_Native = 0xF0;
438     byte constant proofStorage_IPFS = 0x01;
439     byte constant proofType_Android = 0x40;
440     byte constant proofType_TLSNotary = 0x10;
441 
442     string oraclize_network_name;
443     uint8 constant networkID_auto = 0;
444     uint8 constant networkID_morden = 2;
445     uint8 constant networkID_mainnet = 1;
446     uint8 constant networkID_testnet = 2;
447     uint8 constant networkID_consensys = 161;
448 
449     mapping(bytes32 => bytes32) oraclize_randomDS_args;
450     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
451 
452     modifier oraclizeAPI {
453         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
454             oraclize_setNetwork(networkID_auto);
455         }
456         if (address(oraclize) != OAR.getAddress()) {
457             oraclize = OraclizeI(OAR.getAddress());
458         }
459         _;
460     }
461 
462     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
463         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
464         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
465         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
466         require(proofVerified);
467         _;
468     }
469 
470     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
471       _networkID; // silence the warning and remain backwards compatible
472       return oraclize_setNetwork();
473     }
474 
475     function oraclize_setNetworkName(string memory _network_name) internal {
476         oraclize_network_name = _network_name;
477     }
478 
479     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
480         return oraclize_network_name;
481     }
482 
483     function oraclize_setNetwork() internal returns (bool _networkSet) {
484         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
485             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
486             oraclize_setNetworkName("eth_mainnet");
487             return true;
488         }
489         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
490             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
491             oraclize_setNetworkName("eth_ropsten3");
492             return true;
493         }
494         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
495             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
496             oraclize_setNetworkName("eth_kovan");
497             return true;
498         }
499         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
500             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
501             oraclize_setNetworkName("eth_rinkeby");
502             return true;
503         }
504         if (getCodeSize(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41) > 0) { //goerli testnet
505             OAR = OraclizeAddrResolverI(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41);
506             oraclize_setNetworkName("eth_goerli");
507             return true;
508         }
509         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
510             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
511             return true;
512         }
513         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
514             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
515             return true;
516         }
517         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
518             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
519             return true;
520         }
521         return false;
522     }
523 
524     function __callback(bytes32 _myid, string memory _result) public {
525         __callback(_myid, _result, new bytes(0));
526     }
527 
528     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
529         _myid; _result; _proof; // Silence compiler warnings
530       return;
531     }
532 
533     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
534         return oraclize.getPrice(_datasource);
535     }
536 
537     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
538         return oraclize.getPrice(_datasource, _gasLimit);
539     }
540 
541     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
542         uint price = oraclize.getPrice(_datasource);
543         if (price > 1 ether + tx.gasprice * 200000) {
544             return 0; // Unexpectedly high price
545         }
546         return oraclize.query.value(price)(0, _datasource, _arg);
547     }
548 
549     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
550         uint price = oraclize.getPrice(_datasource);
551         if (price > 1 ether + tx.gasprice * 200000) {
552             return 0; // Unexpectedly high price
553         }
554         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
555     }
556 
557     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
558         uint price = oraclize.getPrice(_datasource,_gasLimit);
559         if (price > 1 ether + tx.gasprice * _gasLimit) {
560             return 0; // Unexpectedly high price
561         }
562         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
563     }
564 
565     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
566         uint price = oraclize.getPrice(_datasource, _gasLimit);
567         if (price > 1 ether + tx.gasprice * _gasLimit) {
568            return 0; // Unexpectedly high price
569         }
570         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
571     }
572 
573     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
574         uint price = oraclize.getPrice(_datasource);
575         if (price > 1 ether + tx.gasprice * 200000) {
576             return 0; // Unexpectedly high price
577         }
578         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
579     }
580 
581     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
582         uint price = oraclize.getPrice(_datasource);
583         if (price > 1 ether + tx.gasprice * 200000) {
584             return 0; // Unexpectedly high price
585         }
586         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
587     }
588 
589     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
590         uint price = oraclize.getPrice(_datasource, _gasLimit);
591         if (price > 1 ether + tx.gasprice * _gasLimit) {
592             return 0; // Unexpectedly high price
593         }
594         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
595     }
596 
597     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
598         uint price = oraclize.getPrice(_datasource, _gasLimit);
599         if (price > 1 ether + tx.gasprice * _gasLimit) {
600             return 0; // Unexpectedly high price
601         }
602         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
603     }
604 
605     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
606         uint price = oraclize.getPrice(_datasource);
607         if (price > 1 ether + tx.gasprice * 200000) {
608             return 0; // Unexpectedly high price
609         }
610         bytes memory args = stra2cbor(_argN);
611         return oraclize.queryN.value(price)(0, _datasource, args);
612     }
613 
614     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
615         uint price = oraclize.getPrice(_datasource);
616         if (price > 1 ether + tx.gasprice * 200000) {
617             return 0; // Unexpectedly high price
618         }
619         bytes memory args = stra2cbor(_argN);
620         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
621     }
622 
623     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
624         uint price = oraclize.getPrice(_datasource, _gasLimit);
625         if (price > 1 ether + tx.gasprice * _gasLimit) {
626             return 0; // Unexpectedly high price
627         }
628         bytes memory args = stra2cbor(_argN);
629         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
630     }
631 
632     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
633         uint price = oraclize.getPrice(_datasource, _gasLimit);
634         if (price > 1 ether + tx.gasprice * _gasLimit) {
635             return 0; // Unexpectedly high price
636         }
637         bytes memory args = stra2cbor(_argN);
638         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
639     }
640 
641     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
642         string[] memory dynargs = new string[](1);
643         dynargs[0] = _args[0];
644         return oraclize_query(_datasource, dynargs);
645     }
646 
647     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
648         string[] memory dynargs = new string[](1);
649         dynargs[0] = _args[0];
650         return oraclize_query(_timestamp, _datasource, dynargs);
651     }
652 
653     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
654         string[] memory dynargs = new string[](1);
655         dynargs[0] = _args[0];
656         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
657     }
658 
659     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
660         string[] memory dynargs = new string[](1);
661         dynargs[0] = _args[0];
662         return oraclize_query(_datasource, dynargs, _gasLimit);
663     }
664 
665     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
666         string[] memory dynargs = new string[](2);
667         dynargs[0] = _args[0];
668         dynargs[1] = _args[1];
669         return oraclize_query(_datasource, dynargs);
670     }
671 
672     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
673         string[] memory dynargs = new string[](2);
674         dynargs[0] = _args[0];
675         dynargs[1] = _args[1];
676         return oraclize_query(_timestamp, _datasource, dynargs);
677     }
678 
679     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
680         string[] memory dynargs = new string[](2);
681         dynargs[0] = _args[0];
682         dynargs[1] = _args[1];
683         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
684     }
685 
686     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
687         string[] memory dynargs = new string[](2);
688         dynargs[0] = _args[0];
689         dynargs[1] = _args[1];
690         return oraclize_query(_datasource, dynargs, _gasLimit);
691     }
692 
693     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
694         string[] memory dynargs = new string[](3);
695         dynargs[0] = _args[0];
696         dynargs[1] = _args[1];
697         dynargs[2] = _args[2];
698         return oraclize_query(_datasource, dynargs);
699     }
700 
701     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
702         string[] memory dynargs = new string[](3);
703         dynargs[0] = _args[0];
704         dynargs[1] = _args[1];
705         dynargs[2] = _args[2];
706         return oraclize_query(_timestamp, _datasource, dynargs);
707     }
708 
709     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
710         string[] memory dynargs = new string[](3);
711         dynargs[0] = _args[0];
712         dynargs[1] = _args[1];
713         dynargs[2] = _args[2];
714         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
715     }
716 
717     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
718         string[] memory dynargs = new string[](3);
719         dynargs[0] = _args[0];
720         dynargs[1] = _args[1];
721         dynargs[2] = _args[2];
722         return oraclize_query(_datasource, dynargs, _gasLimit);
723     }
724 
725     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
726         string[] memory dynargs = new string[](4);
727         dynargs[0] = _args[0];
728         dynargs[1] = _args[1];
729         dynargs[2] = _args[2];
730         dynargs[3] = _args[3];
731         return oraclize_query(_datasource, dynargs);
732     }
733 
734     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
735         string[] memory dynargs = new string[](4);
736         dynargs[0] = _args[0];
737         dynargs[1] = _args[1];
738         dynargs[2] = _args[2];
739         dynargs[3] = _args[3];
740         return oraclize_query(_timestamp, _datasource, dynargs);
741     }
742 
743     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
744         string[] memory dynargs = new string[](4);
745         dynargs[0] = _args[0];
746         dynargs[1] = _args[1];
747         dynargs[2] = _args[2];
748         dynargs[3] = _args[3];
749         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
750     }
751 
752     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
753         string[] memory dynargs = new string[](4);
754         dynargs[0] = _args[0];
755         dynargs[1] = _args[1];
756         dynargs[2] = _args[2];
757         dynargs[3] = _args[3];
758         return oraclize_query(_datasource, dynargs, _gasLimit);
759     }
760 
761     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
762         string[] memory dynargs = new string[](5);
763         dynargs[0] = _args[0];
764         dynargs[1] = _args[1];
765         dynargs[2] = _args[2];
766         dynargs[3] = _args[3];
767         dynargs[4] = _args[4];
768         return oraclize_query(_datasource, dynargs);
769     }
770 
771     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
772         string[] memory dynargs = new string[](5);
773         dynargs[0] = _args[0];
774         dynargs[1] = _args[1];
775         dynargs[2] = _args[2];
776         dynargs[3] = _args[3];
777         dynargs[4] = _args[4];
778         return oraclize_query(_timestamp, _datasource, dynargs);
779     }
780 
781     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
782         string[] memory dynargs = new string[](5);
783         dynargs[0] = _args[0];
784         dynargs[1] = _args[1];
785         dynargs[2] = _args[2];
786         dynargs[3] = _args[3];
787         dynargs[4] = _args[4];
788         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
789     }
790 
791     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
792         string[] memory dynargs = new string[](5);
793         dynargs[0] = _args[0];
794         dynargs[1] = _args[1];
795         dynargs[2] = _args[2];
796         dynargs[3] = _args[3];
797         dynargs[4] = _args[4];
798         return oraclize_query(_datasource, dynargs, _gasLimit);
799     }
800 
801     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
802         uint price = oraclize.getPrice(_datasource);
803         if (price > 1 ether + tx.gasprice * 200000) {
804             return 0; // Unexpectedly high price
805         }
806         bytes memory args = ba2cbor(_argN);
807         return oraclize.queryN.value(price)(0, _datasource, args);
808     }
809 
810     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
811         uint price = oraclize.getPrice(_datasource);
812         if (price > 1 ether + tx.gasprice * 200000) {
813             return 0; // Unexpectedly high price
814         }
815         bytes memory args = ba2cbor(_argN);
816         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
817     }
818 
819     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
820         uint price = oraclize.getPrice(_datasource, _gasLimit);
821         if (price > 1 ether + tx.gasprice * _gasLimit) {
822             return 0; // Unexpectedly high price
823         }
824         bytes memory args = ba2cbor(_argN);
825         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
826     }
827 
828     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
829         uint price = oraclize.getPrice(_datasource, _gasLimit);
830         if (price > 1 ether + tx.gasprice * _gasLimit) {
831             return 0; // Unexpectedly high price
832         }
833         bytes memory args = ba2cbor(_argN);
834         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
835     }
836 
837     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
838         bytes[] memory dynargs = new bytes[](1);
839         dynargs[0] = _args[0];
840         return oraclize_query(_datasource, dynargs);
841     }
842 
843     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
844         bytes[] memory dynargs = new bytes[](1);
845         dynargs[0] = _args[0];
846         return oraclize_query(_timestamp, _datasource, dynargs);
847     }
848 
849     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
850         bytes[] memory dynargs = new bytes[](1);
851         dynargs[0] = _args[0];
852         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
853     }
854 
855     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
856         bytes[] memory dynargs = new bytes[](1);
857         dynargs[0] = _args[0];
858         return oraclize_query(_datasource, dynargs, _gasLimit);
859     }
860 
861     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
862         bytes[] memory dynargs = new bytes[](2);
863         dynargs[0] = _args[0];
864         dynargs[1] = _args[1];
865         return oraclize_query(_datasource, dynargs);
866     }
867 
868     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
869         bytes[] memory dynargs = new bytes[](2);
870         dynargs[0] = _args[0];
871         dynargs[1] = _args[1];
872         return oraclize_query(_timestamp, _datasource, dynargs);
873     }
874 
875     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
876         bytes[] memory dynargs = new bytes[](2);
877         dynargs[0] = _args[0];
878         dynargs[1] = _args[1];
879         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
880     }
881 
882     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
883         bytes[] memory dynargs = new bytes[](2);
884         dynargs[0] = _args[0];
885         dynargs[1] = _args[1];
886         return oraclize_query(_datasource, dynargs, _gasLimit);
887     }
888 
889     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
890         bytes[] memory dynargs = new bytes[](3);
891         dynargs[0] = _args[0];
892         dynargs[1] = _args[1];
893         dynargs[2] = _args[2];
894         return oraclize_query(_datasource, dynargs);
895     }
896 
897     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
898         bytes[] memory dynargs = new bytes[](3);
899         dynargs[0] = _args[0];
900         dynargs[1] = _args[1];
901         dynargs[2] = _args[2];
902         return oraclize_query(_timestamp, _datasource, dynargs);
903     }
904 
905     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
906         bytes[] memory dynargs = new bytes[](3);
907         dynargs[0] = _args[0];
908         dynargs[1] = _args[1];
909         dynargs[2] = _args[2];
910         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
911     }
912 
913     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
914         bytes[] memory dynargs = new bytes[](3);
915         dynargs[0] = _args[0];
916         dynargs[1] = _args[1];
917         dynargs[2] = _args[2];
918         return oraclize_query(_datasource, dynargs, _gasLimit);
919     }
920 
921     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
922         bytes[] memory dynargs = new bytes[](4);
923         dynargs[0] = _args[0];
924         dynargs[1] = _args[1];
925         dynargs[2] = _args[2];
926         dynargs[3] = _args[3];
927         return oraclize_query(_datasource, dynargs);
928     }
929 
930     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
931         bytes[] memory dynargs = new bytes[](4);
932         dynargs[0] = _args[0];
933         dynargs[1] = _args[1];
934         dynargs[2] = _args[2];
935         dynargs[3] = _args[3];
936         return oraclize_query(_timestamp, _datasource, dynargs);
937     }
938 
939     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
940         bytes[] memory dynargs = new bytes[](4);
941         dynargs[0] = _args[0];
942         dynargs[1] = _args[1];
943         dynargs[2] = _args[2];
944         dynargs[3] = _args[3];
945         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
946     }
947 
948     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
949         bytes[] memory dynargs = new bytes[](4);
950         dynargs[0] = _args[0];
951         dynargs[1] = _args[1];
952         dynargs[2] = _args[2];
953         dynargs[3] = _args[3];
954         return oraclize_query(_datasource, dynargs, _gasLimit);
955     }
956 
957     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
958         bytes[] memory dynargs = new bytes[](5);
959         dynargs[0] = _args[0];
960         dynargs[1] = _args[1];
961         dynargs[2] = _args[2];
962         dynargs[3] = _args[3];
963         dynargs[4] = _args[4];
964         return oraclize_query(_datasource, dynargs);
965     }
966 
967     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
968         bytes[] memory dynargs = new bytes[](5);
969         dynargs[0] = _args[0];
970         dynargs[1] = _args[1];
971         dynargs[2] = _args[2];
972         dynargs[3] = _args[3];
973         dynargs[4] = _args[4];
974         return oraclize_query(_timestamp, _datasource, dynargs);
975     }
976 
977     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
978         bytes[] memory dynargs = new bytes[](5);
979         dynargs[0] = _args[0];
980         dynargs[1] = _args[1];
981         dynargs[2] = _args[2];
982         dynargs[3] = _args[3];
983         dynargs[4] = _args[4];
984         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
985     }
986 
987     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
988         bytes[] memory dynargs = new bytes[](5);
989         dynargs[0] = _args[0];
990         dynargs[1] = _args[1];
991         dynargs[2] = _args[2];
992         dynargs[3] = _args[3];
993         dynargs[4] = _args[4];
994         return oraclize_query(_datasource, dynargs, _gasLimit);
995     }
996 
997     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
998         return oraclize.setProofType(_proofP);
999     }
1000 
1001 
1002     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
1003         return oraclize.cbAddress();
1004     }
1005 
1006     function getCodeSize(address _addr) view internal returns (uint _size) {
1007         assembly {
1008             _size := extcodesize(_addr)
1009         }
1010     }
1011 
1012     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
1013         return oraclize.setCustomGasPrice(_gasPrice);
1014     }
1015 
1016     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
1017         return oraclize.randomDS_getSessionPubKeyHash();
1018     }
1019 
1020     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
1021         bytes memory tmp = bytes(_a);
1022         uint160 iaddr = 0;
1023         uint160 b1;
1024         uint160 b2;
1025         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
1026             iaddr *= 256;
1027             b1 = uint160(uint8(tmp[i]));
1028             b2 = uint160(uint8(tmp[i + 1]));
1029             if ((b1 >= 97) && (b1 <= 102)) {
1030                 b1 -= 87;
1031             } else if ((b1 >= 65) && (b1 <= 70)) {
1032                 b1 -= 55;
1033             } else if ((b1 >= 48) && (b1 <= 57)) {
1034                 b1 -= 48;
1035             }
1036             if ((b2 >= 97) && (b2 <= 102)) {
1037                 b2 -= 87;
1038             } else if ((b2 >= 65) && (b2 <= 70)) {
1039                 b2 -= 55;
1040             } else if ((b2 >= 48) && (b2 <= 57)) {
1041                 b2 -= 48;
1042             }
1043             iaddr += (b1 * 16 + b2);
1044         }
1045         return address(iaddr);
1046     }
1047 
1048     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
1049         bytes memory a = bytes(_a);
1050         bytes memory b = bytes(_b);
1051         uint minLength = a.length;
1052         if (b.length < minLength) {
1053             minLength = b.length;
1054         }
1055         for (uint i = 0; i < minLength; i ++) {
1056             if (a[i] < b[i]) {
1057                 return -1;
1058             } else if (a[i] > b[i]) {
1059                 return 1;
1060             }
1061         }
1062         if (a.length < b.length) {
1063             return -1;
1064         } else if (a.length > b.length) {
1065             return 1;
1066         } else {
1067             return 0;
1068         }
1069     }
1070 
1071     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
1072         bytes memory h = bytes(_haystack);
1073         bytes memory n = bytes(_needle);
1074         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
1075             return -1;
1076         } else if (h.length > (2 ** 128 - 1)) {
1077             return -1;
1078         } else {
1079             uint subindex = 0;
1080             for (uint i = 0; i < h.length; i++) {
1081                 if (h[i] == n[0]) {
1082                     subindex = 1;
1083                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
1084                         subindex++;
1085                     }
1086                     if (subindex == n.length) {
1087                         return int(i);
1088                     }
1089                 }
1090             }
1091             return -1;
1092         }
1093     }
1094 
1095     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
1096         return strConcat(_a, _b, "", "", "");
1097     }
1098 
1099     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
1100         return strConcat(_a, _b, _c, "", "");
1101     }
1102 
1103     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
1104         return strConcat(_a, _b, _c, _d, "");
1105     }
1106 
1107     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
1108         bytes memory _ba = bytes(_a);
1109         bytes memory _bb = bytes(_b);
1110         bytes memory _bc = bytes(_c);
1111         bytes memory _bd = bytes(_d);
1112         bytes memory _be = bytes(_e);
1113         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1114         bytes memory babcde = bytes(abcde);
1115         uint k = 0;
1116         uint i = 0;
1117         for (i = 0; i < _ba.length; i++) {
1118             babcde[k++] = _ba[i];
1119         }
1120         for (i = 0; i < _bb.length; i++) {
1121             babcde[k++] = _bb[i];
1122         }
1123         for (i = 0; i < _bc.length; i++) {
1124             babcde[k++] = _bc[i];
1125         }
1126         for (i = 0; i < _bd.length; i++) {
1127             babcde[k++] = _bd[i];
1128         }
1129         for (i = 0; i < _be.length; i++) {
1130             babcde[k++] = _be[i];
1131         }
1132         return string(babcde);
1133     }
1134 
1135     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
1136         return safeParseInt(_a, 0);
1137     }
1138 
1139     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1140         bytes memory bresult = bytes(_a);
1141         uint mint = 0;
1142         bool decimals = false;
1143         for (uint i = 0; i < bresult.length; i++) {
1144             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1145                 if (decimals) {
1146                    if (_b == 0) break;
1147                     else _b--;
1148                 }
1149                 mint *= 10;
1150                 mint += uint(uint8(bresult[i])) - 48;
1151             } else if (uint(uint8(bresult[i])) == 46) {
1152                 require(!decimals, 'More than one decimal encountered in string!');
1153                 decimals = true;
1154             } else {
1155                 revert("Non-numeral character encountered in string!");
1156             }
1157         }
1158         if (_b > 0) {
1159             mint *= 10 ** _b;
1160         }
1161         return mint;
1162     }
1163 
1164     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
1165         return parseInt(_a, 0);
1166     }
1167 
1168     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1169         bytes memory bresult = bytes(_a);
1170         uint mint = 0;
1171         bool decimals = false;
1172         for (uint i = 0; i < bresult.length; i++) {
1173             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1174                 if (decimals) {
1175                    if (_b == 0) {
1176                        break;
1177                    } else {
1178                        _b--;
1179                    }
1180                 }
1181                 mint *= 10;
1182                 mint += uint(uint8(bresult[i])) - 48;
1183             } else if (uint(uint8(bresult[i])) == 46) {
1184                 decimals = true;
1185             }
1186         }
1187         if (_b > 0) {
1188             mint *= 10 ** _b;
1189         }
1190         return mint;
1191     }
1192 
1193     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1194         if (_i == 0) {
1195             return "0";
1196         }
1197         uint j = _i;
1198         uint len;
1199         while (j != 0) {
1200             len++;
1201             j /= 10;
1202         }
1203         bytes memory bstr = new bytes(len);
1204         uint k = len - 1;
1205         while (_i != 0) {
1206             bstr[k--] = byte(uint8(48 + _i % 10));
1207             _i /= 10;
1208         }
1209         return string(bstr);
1210     }
1211 
1212     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1213         safeMemoryCleaner();
1214         Buffer.buffer memory buf;
1215         Buffer.init(buf, 1024);
1216         buf.startArray();
1217         for (uint i = 0; i < _arr.length; i++) {
1218             buf.encodeString(_arr[i]);
1219         }
1220         buf.endSequence();
1221         return buf.buf;
1222     }
1223 
1224     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1225         safeMemoryCleaner();
1226         Buffer.buffer memory buf;
1227         Buffer.init(buf, 1024);
1228         buf.startArray();
1229         for (uint i = 0; i < _arr.length; i++) {
1230             buf.encodeBytes(_arr[i]);
1231         }
1232         buf.endSequence();
1233         return buf.buf;
1234     }
1235 
1236     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1237         require((_nbytes > 0) && (_nbytes <= 32));
1238         _delay *= 10; // Convert from seconds to ledger timer ticks
1239         bytes memory nbytes = new bytes(1);
1240         nbytes[0] = byte(uint8(_nbytes));
1241         bytes memory unonce = new bytes(32);
1242         bytes memory sessionKeyHash = new bytes(32);
1243         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1244         assembly {
1245             mstore(unonce, 0x20)
1246             /*
1247              The following variables can be relaxed.
1248              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1249              for an idea on how to override and replace commit hash variables.
1250             */
1251             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1252             mstore(sessionKeyHash, 0x20)
1253             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1254         }
1255         bytes memory delay = new bytes(32);
1256         assembly {
1257             mstore(add(delay, 0x20), _delay)
1258         }
1259         bytes memory delay_bytes8 = new bytes(8);
1260         copyBytes(delay, 24, 8, delay_bytes8, 0);
1261         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1262         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1263         bytes memory delay_bytes8_left = new bytes(8);
1264         assembly {
1265             let x := mload(add(delay_bytes8, 0x20))
1266             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1267             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1268             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1269             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1270             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1271             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1272             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1273             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1274         }
1275         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1276         return queryId;
1277     }
1278 
1279     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1280         oraclize_randomDS_args[_queryId] = _commitment;
1281     }
1282 
1283     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1284         bool sigok;
1285         address signer;
1286         bytes32 sigr;
1287         bytes32 sigs;
1288         bytes memory sigr_ = new bytes(32);
1289         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1290         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1291         bytes memory sigs_ = new bytes(32);
1292         offset += 32 + 2;
1293         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1294         assembly {
1295             sigr := mload(add(sigr_, 32))
1296             sigs := mload(add(sigs_, 32))
1297         }
1298         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1299         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1300             return true;
1301         } else {
1302             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1303             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1304         }
1305     }
1306 
1307     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1308         bool sigok;
1309         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1310         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1311         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1312         bytes memory appkey1_pubkey = new bytes(64);
1313         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1314         bytes memory tosign2 = new bytes(1 + 65 + 32);
1315         tosign2[0] = byte(uint8(1)); //role
1316         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1317         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1318         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1319         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1320         if (!sigok) {
1321             return false;
1322         }
1323         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1324         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1325         bytes memory tosign3 = new bytes(1 + 65);
1326         tosign3[0] = 0xFE;
1327         copyBytes(_proof, 3, 65, tosign3, 1);
1328         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1329         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1330         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1331         return sigok;
1332     }
1333 
1334     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1335         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1336         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1337             return 1;
1338         }
1339         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1340         if (!proofVerified) {
1341             return 2;
1342         }
1343         return 0;
1344     }
1345 
1346     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1347         bool match_ = true;
1348         require(_prefix.length == _nRandomBytes);
1349         for (uint256 i = 0; i< _nRandomBytes; i++) {
1350             if (_content[i] != _prefix[i]) {
1351                 match_ = false;
1352             }
1353         }
1354         return match_;
1355     }
1356 
1357     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1358         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1359         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1360         bytes memory keyhash = new bytes(32);
1361         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1362         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1363             return false;
1364         }
1365         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1366         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1367         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1368         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1369             return false;
1370         }
1371         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1372         // This is to verify that the computed args match with the ones specified in the query.
1373         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1374         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1375         bytes memory sessionPubkey = new bytes(64);
1376         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1377         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1378         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1379         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1380             delete oraclize_randomDS_args[_queryId];
1381         } else return false;
1382         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1383         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1384         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1385         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1386             return false;
1387         }
1388         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1389         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1390             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1391         }
1392         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1393     }
1394     /*
1395      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1396     */
1397     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1398         uint minLength = _length + _toOffset;
1399         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1400         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1401         uint j = 32 + _toOffset;
1402         while (i < (32 + _fromOffset + _length)) {
1403             assembly {
1404                 let tmp := mload(add(_from, i))
1405                 mstore(add(_to, j), tmp)
1406             }
1407             i += 32;
1408             j += 32;
1409         }
1410         return _to;
1411     }
1412     /*
1413      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1414      Duplicate Solidity's ecrecover, but catching the CALL return value
1415     */
1416     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1417         /*
1418          We do our own memory management here. Solidity uses memory offset
1419          0x40 to store the current end of memory. We write past it (as
1420          writes are memory extensions), but don't update the offset so
1421          Solidity will reuse it. The memory used here is only needed for
1422          this context.
1423          FIXME: inline assembly can't access return values
1424         */
1425         bool ret;
1426         address addr;
1427         assembly {
1428             let size := mload(0x40)
1429             mstore(size, _hash)
1430             mstore(add(size, 32), _v)
1431             mstore(add(size, 64), _r)
1432             mstore(add(size, 96), _s)
1433             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1434             addr := mload(size)
1435         }
1436         return (ret, addr);
1437     }
1438     /*
1439      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1440     */
1441     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1442         bytes32 r;
1443         bytes32 s;
1444         uint8 v;
1445         if (_sig.length != 65) {
1446             return (false, address(0));
1447         }
1448         /*
1449          The signature format is a compact form of:
1450            {bytes32 r}{bytes32 s}{uint8 v}
1451          Compact means, uint8 is not padded to 32 bytes.
1452         */
1453         assembly {
1454             r := mload(add(_sig, 32))
1455             s := mload(add(_sig, 64))
1456             /*
1457              Here we are loading the last 32 bytes. We exploit the fact that
1458              'mload' will pad with zeroes if we overread.
1459              There is no 'mload8' to do this, but that would be nicer.
1460             */
1461             v := byte(0, mload(add(_sig, 96)))
1462             /*
1463               Alternative solution:
1464               'byte' is not working due to the Solidity parser, so lets
1465               use the second best option, 'and'
1466               v := and(mload(add(_sig, 65)), 255)
1467             */
1468         }
1469         /*
1470          albeit non-transactional signatures are not specified by the YP, one would expect it
1471          to match the YP range of [27, 28]
1472          geth uses [0, 1] and some clients have followed. This might change, see:
1473          https://github.com/ethereum/go-ethereum/issues/2053
1474         */
1475         if (v < 27) {
1476             v += 27;
1477         }
1478         if (v != 27 && v != 28) {
1479             return (false, address(0));
1480         }
1481         return safer_ecrecover(_hash, v, r, s);
1482     }
1483 
1484     function safeMemoryCleaner() internal pure {
1485         assembly {
1486             let fmem := mload(0x40)
1487             codecopy(fmem, codesize, sub(msize, fmem))
1488         }
1489     }
1490 }
1491 /*
1492 END ORACLIZE_API
1493 */
1494 
1495 contract Pool is Ownable{
1496     function () external payable {}
1497     function send(address payable to, uint value) public onlyOwner  {
1498         to.transfer(value);
1499     }  
1500     function balance() public view returns(uint) {
1501         return address(this).balance;
1502     }
1503 }
1504 
1505 
1506 contract SODA is usingOraclize, Ownable {
1507     uint constant ORACLIZE_GASLIMIT = 300000;
1508     using SafeMath for uint;
1509     IERC20 WBTC;
1510     Pool public pool;
1511     event Log(string message);
1512     mapping (address => Deposit) deposits;
1513     
1514     modifier oraclized() {
1515         uint price = oraclize_getPrice("URL", ORACLIZE_GASLIMIT);
1516         require(price <= msg.value, "need more eth");
1517         msg.sender.transfer( msg.value - price);
1518         _;
1519     }
1520     
1521     mapping (bytes32 => Transaction) queries;
1522     constructor(address WBTCaddr) public payable {
1523         WBTC = IERC20(WBTCaddr);
1524         pool = new Pool();
1525         address(pool).transfer(msg.value);
1526     }
1527     function deposit(uint256 value) public payable oraclized returns(bytes32 id) {
1528         require(WBTC.allowance(msg.sender, address(this)) >= value, "need approving");
1529         require(WBTC.balanceOf(msg.sender) >= value, "need more WBTC");
1530         require(deposits[msg.sender].state != DepositState.Active, "already Active");
1531         id = oraclize_query("URL", "json(https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT).price", ORACLIZE_GASLIMIT);
1532         queries[id] = Transaction(TransactionType.Deposit, msg.sender, value);
1533     }
1534     
1535     function getWbtcBalance() view public returns (uint256) {
1536         return WBTC.balanceOf(address(this));
1537     }
1538     function parseUsdPrice(string memory s) pure public returns (uint result) {
1539         bytes memory b = bytes(s);
1540         uint i;
1541         result = 0;
1542         uint dotted = 2;
1543         uint stop = b.length;
1544         for (i = 0; i < stop; i++) {
1545             if(b[i] == ".") {
1546                 if(b.length - i > 3){
1547                     stop = i + 3;
1548                     dotted = 0;
1549                 } else
1550                     dotted -= b.length - i-1;
1551             }
1552             else {
1553                 uint c = uint(uint8(b[i]));
1554                 if (c >= 48 && c <= 57) {
1555                     result = result * 10 + (c - 48);
1556                 }
1557             }
1558         }
1559         result *= 10 **dotted;
1560     }
1561     function __callback(bytes32 myid, string memory result) public {
1562         if (msg.sender != oraclize_cbAddress()) revert();
1563         uint price = parseUsdPrice(result);
1564         Transaction storage txn = queries[myid];
1565        
1566         if(txn._type == TransactionType.Deposit){
1567             WBTC.transferFrom(txn.sender, address(this), txn.value);
1568             uint soda_dep = txn.value.mul(price).mul(10**10).mul(10).div(14);
1569             
1570             // comission = 1%
1571             uint comission =txn.value.div(100);
1572             WBTC.transfer(owner(), comission);
1573             deposits[txn.sender] = Deposit(DepositState.Active, txn.value.sub(comission), price, soda_dep, soda_dep, now);
1574         } else if(txn._type == TransactionType.SodaSpend){
1575             Deposit storage d = deposits[txn.sender];
1576             d.balance = d.balance.sub(txn.value);
1577             pool.send(txn.sender,txn.value.div(price));
1578         } else if(txn._type == TransactionType.SodaReparing){
1579             Deposit storage _deposit = deposits[txn.sender];
1580             uint valSoda = txn.value.mul(price);
1581             if(valSoda >= _deposit.debt){
1582                 uint change = valSoda.sub(_deposit.debt).div(price);
1583                 address(pool).transfer(txn.value.sub(change));
1584                 txn.sender.transfer(change);
1585                 WBTC.transfer(txn.sender, _deposit.WBTCamount);
1586                 delete deposits[txn.sender];
1587             } else {
1588                 address(pool).transfer(txn.value);
1589                 _deposit.debt = _deposit.debt.sub(valSoda);
1590             }
1591         } else if(txn._type == TransactionType.LiquidqtionRequest){
1592             if(deposits[txn.sender].usdStartPrice.mul(11) > price.mul(14))
1593                 _liquidate(txn.sender);
1594         }
1595         delete queries[myid];
1596     }
1597     
1598     function balanceOf(address addr) view public returns(uint){
1599         return deposits[addr].balance;
1600     }
1601     function myBalance() view public returns(uint){
1602         return deposits[msg.sender].balance;
1603     }
1604     function myDebt() view public returns(uint){
1605         return deposits[msg.sender].debt;
1606     }
1607     function repayDebt() public payable returns(bytes32 id){
1608         uint o_price = oraclize_getPrice("URL", ORACLIZE_GASLIMIT);
1609         require(o_price < msg.value);
1610         id = oraclize_query("URL", "json(https://api.binance.com/api/v3/ticker/price?symbol=ETHUSDT).price", ORACLIZE_GASLIMIT);
1611         queries[id] = Transaction(TransactionType.SodaReparing, msg.sender, msg.value.sub(o_price));
1612     }
1613     function spendSODA(uint value) public payable oraclized returns(bytes32 id){
1614         require(deposits[msg.sender].balance >= value);
1615         id = oraclize_query("URL", "json(https://api.binance.com/api/v3/ticker/price?symbol=ETHUSDT).price", ORACLIZE_GASLIMIT);
1616         queries[id] = Transaction(TransactionType.SodaSpend, msg.sender, value);
1617     }
1618     
1619     enum TransactionType { Deposit, SodaSpend, SodaReparing, LiquidqtionRequest }
1620     struct Transaction {
1621         TransactionType _type;
1622         address payable sender;
1623         uint256 value;
1624     }
1625     enum DepositState {Closed, Active}
1626     struct Deposit {
1627         DepositState state;
1628         uint WBTCamount;
1629         uint usdStartPrice;
1630         uint debt;
1631         uint balance;
1632         uint timeStamp;
1633     }
1634     function drainPool() public onlyOwner {
1635         pool.send(msg.sender, pool.balance());
1636     }
1637     
1638     function _liquidationRequest(address payable user) private oraclized returns(bytes32 id){
1639         id = oraclize_query("URL", "json(https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT).price", ORACLIZE_GASLIMIT);
1640         queries[id] = Transaction(TransactionType.LiquidqtionRequest, user, 0);
1641     }
1642     
1643     function _liquidate(address user) private {
1644         Deposit storage d = deposits[user];
1645         require(d.state == DepositState.Active);
1646         WBTC.transfer(owner(), d.WBTCamount);
1647         delete deposits[user];
1648     } 
1649     
1650     function liquidate(address payable user) public onlyOwner payable {
1651         Deposit storage _deposit = deposits[user];
1652         require(_deposit.state == DepositState.Active, "Deposit is Closed or doesn't exist");
1653         if(now > _deposit.timeStamp + 10 minutes)
1654             _liquidate(user);
1655         else
1656             _liquidationRequest(user);
1657     }
1658 }