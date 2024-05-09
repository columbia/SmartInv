1 pragma solidity ^0.5.2;
2 pragma experimental ABIEncoderV2;
3 // produced by the Solididy File Flattener (c) David Appleton 2018
4 // contact : dave@akomba.com
5 // released under Apache 2.0 licence
6 // input  /Users/yurivisser/Dev/gener8tive/contracts/Gener8tiveKBlocksERC721.sol
7 // flattened :  Saturday, 27-Apr-19 00:28:41 UTC
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () internal {
18         _owner = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20     }
21 
22     /**
23      * @return the address of the owner.
24      */
25     function owner() public view returns (address) {
26         return _owner;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36 
37     /**
38      * @return true if `msg.sender` is the owner of the contract.
39      */
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43 
44     /**
45      * @dev Allows the current owner to relinquish control of the contract.
46      * It will not be possible to call the functions with the `onlyOwner`
47      * modifier anymore.
48      * @notice Renouncing ownership will leave the contract without an owner,
49      * thereby removing any functionality that is only available to the owner.
50      */
51     function renounceOwnership() public onlyOwner {
52         emit OwnershipTransferred(_owner, address(0));
53         _owner = address(0);
54     }
55 
56     /**
57      * @dev Allows the current owner to transfer control of the contract to a newOwner.
58      * @param newOwner The address to transfer ownership to.
59      */
60     function transferOwnership(address newOwner) public onlyOwner {
61         _transferOwnership(newOwner);
62     }
63 
64     /**
65      * @dev Transfers control of the contract to a newOwner.
66      * @param newOwner The address to transfer ownership to.
67      */
68     function _transferOwnership(address newOwner) internal {
69         require(newOwner != address(0));
70         emit OwnershipTransferred(_owner, newOwner);
71         _owner = newOwner;
72     }
73 }
74 
75 contract solcChecker {
76 /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;
77 }
78 
79 contract OraclizeI {
80 
81     address public cbAddress;
82 
83     function setProofType(byte _proofType) external;
84     function setCustomGasPrice(uint _gasPrice) external;
85     function getPrice(string memory _datasource) public returns (uint _dsprice);
86     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
87     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
88     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
89     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
90     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
91     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
92     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
93     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
94 }
95 
96 contract OraclizeAddrResolverI {
97     function getAddress() public returns (address _address);
98 }
99 /*
100 
101 Begin solidity-cborutils
102 
103 https://github.com/smartcontractkit/solidity-cborutils
104 
105 MIT License
106 
107 Copyright (c) 2018 SmartContract ChainLink, Ltd.
108 
109 Permission is hereby granted, free of charge, to any person obtaining a copy
110 of this software and associated documentation files (the "Software"), to deal
111 in the Software without restriction, including without limitation the rights
112 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
113 copies of the Software, and to permit persons to whom the Software is
114 furnished to do so, subject to the following conditions:
115 
116 The above copyright notice and this permission notice shall be included in all
117 copies or substantial portions of the Software.
118 
119 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
120 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
121 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
122 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
123 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
124 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
125 SOFTWARE.
126 
127 */
128 library Buffer {
129 
130     struct buffer {
131         bytes buf;
132         uint capacity;
133     }
134 
135     function init(buffer memory _buf, uint _capacity) internal pure {
136         uint capacity = _capacity;
137         if (capacity % 32 != 0) {
138             capacity += 32 - (capacity % 32);
139         }
140         _buf.capacity = capacity; // Allocate space for the buffer data
141         assembly {
142             let ptr := mload(0x40)
143             mstore(_buf, ptr)
144             mstore(ptr, 0)
145             mstore(0x40, add(ptr, capacity))
146         }
147     }
148 
149     function resize(buffer memory _buf, uint _capacity) private pure {
150         bytes memory oldbuf = _buf.buf;
151         init(_buf, _capacity);
152         append(_buf, oldbuf);
153     }
154 
155     function max(uint _a, uint _b) private pure returns (uint _max) {
156         if (_a > _b) {
157             return _a;
158         }
159         return _b;
160     }
161     /**
162       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
163       *      would exceed the capacity of the buffer.
164       * @param _buf The buffer to append to.
165       * @param _data The data to append.
166       * @return The original buffer.
167       *
168       */
169     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
170         if (_data.length + _buf.buf.length > _buf.capacity) {
171             resize(_buf, max(_buf.capacity, _data.length) * 2);
172         }
173         uint dest;
174         uint src;
175         uint len = _data.length;
176         assembly {
177             let bufptr := mload(_buf) // Memory address of the buffer data
178             let buflen := mload(bufptr) // Length of existing buffer data
179             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
180             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
181             src := add(_data, 32)
182         }
183         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
184             assembly {
185                 mstore(dest, mload(src))
186             }
187             dest += 32;
188             src += 32;
189         }
190         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
191         assembly {
192             let srcpart := and(mload(src), not(mask))
193             let destpart := and(mload(dest), mask)
194             mstore(dest, or(destpart, srcpart))
195         }
196         return _buf;
197     }
198     /**
199       *
200       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
201       * exceed the capacity of the buffer.
202       * @param _buf The buffer to append to.
203       * @param _data The data to append.
204       * @return The original buffer.
205       *
206       */
207     function append(buffer memory _buf, uint8 _data) internal pure {
208         if (_buf.buf.length + 1 > _buf.capacity) {
209             resize(_buf, _buf.capacity * 2);
210         }
211         assembly {
212             let bufptr := mload(_buf) // Memory address of the buffer data
213             let buflen := mload(bufptr) // Length of existing buffer data
214             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
215             mstore8(dest, _data)
216             mstore(bufptr, add(buflen, 1)) // Update buffer length
217         }
218     }
219     /**
220       *
221       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
222       * exceed the capacity of the buffer.
223       * @param _buf The buffer to append to.
224       * @param _data The data to append.
225       * @return The original buffer.
226       *
227       */
228     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
229         if (_len + _buf.buf.length > _buf.capacity) {
230             resize(_buf, max(_buf.capacity, _len) * 2);
231         }
232         uint mask = 256 ** _len - 1;
233         assembly {
234             let bufptr := mload(_buf) // Memory address of the buffer data
235             let buflen := mload(bufptr) // Length of existing buffer data
236             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
237             mstore(dest, or(and(mload(dest), not(mask)), _data))
238             mstore(bufptr, add(buflen, _len)) // Update buffer length
239         }
240         return _buf;
241     }
242 }
243 
244 library CBOR {
245 
246     using Buffer for Buffer.buffer;
247 
248     uint8 private constant MAJOR_TYPE_INT = 0;
249     uint8 private constant MAJOR_TYPE_MAP = 5;
250     uint8 private constant MAJOR_TYPE_BYTES = 2;
251     uint8 private constant MAJOR_TYPE_ARRAY = 4;
252     uint8 private constant MAJOR_TYPE_STRING = 3;
253     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
254     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
255 
256     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
257         if (_value <= 23) {
258             _buf.append(uint8((_major << 5) | _value));
259         } else if (_value <= 0xFF) {
260             _buf.append(uint8((_major << 5) | 24));
261             _buf.appendInt(_value, 1);
262         } else if (_value <= 0xFFFF) {
263             _buf.append(uint8((_major << 5) | 25));
264             _buf.appendInt(_value, 2);
265         } else if (_value <= 0xFFFFFFFF) {
266             _buf.append(uint8((_major << 5) | 26));
267             _buf.appendInt(_value, 4);
268         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
269             _buf.append(uint8((_major << 5) | 27));
270             _buf.appendInt(_value, 8);
271         }
272     }
273 
274     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
275         _buf.append(uint8((_major << 5) | 31));
276     }
277 
278     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
279         encodeType(_buf, MAJOR_TYPE_INT, _value);
280     }
281 
282     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
283         if (_value >= 0) {
284             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
285         } else {
286             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
287         }
288     }
289 
290     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
291         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
292         _buf.append(_value);
293     }
294 
295     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
296         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
297         _buf.append(bytes(_value));
298     }
299 
300     function startArray(Buffer.buffer memory _buf) internal pure {
301         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
302     }
303 
304     function startMap(Buffer.buffer memory _buf) internal pure {
305         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
306     }
307 
308     function endSequence(Buffer.buffer memory _buf) internal pure {
309         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
310     }
311 }
312 /*
313 
314 End solidity-cborutils
315 
316 */
317 contract usingOraclize {
318 
319     using CBOR for Buffer.buffer;
320 
321     OraclizeI oraclize;
322     OraclizeAddrResolverI OAR;
323 
324     uint constant day = 60 * 60 * 24;
325     uint constant week = 60 * 60 * 24 * 7;
326     uint constant month = 60 * 60 * 24 * 30;
327 
328     byte constant proofType_NONE = 0x00;
329     byte constant proofType_Ledger = 0x30;
330     byte constant proofType_Native = 0xF0;
331     byte constant proofStorage_IPFS = 0x01;
332     byte constant proofType_Android = 0x40;
333     byte constant proofType_TLSNotary = 0x10;
334 
335     string oraclize_network_name;
336     uint8 constant networkID_auto = 0;
337     uint8 constant networkID_morden = 2;
338     uint8 constant networkID_mainnet = 1;
339     uint8 constant networkID_testnet = 2;
340     uint8 constant networkID_consensys = 161;
341 
342     mapping(bytes32 => bytes32) oraclize_randomDS_args;
343     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
344 
345     modifier oraclizeAPI {
346         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
347             oraclize_setNetwork(networkID_auto);
348         }
349         if (address(oraclize) != OAR.getAddress()) {
350             oraclize = OraclizeI(OAR.getAddress());
351         }
352         _;
353     }
354 
355     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
356         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
357         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
358         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
359         require(proofVerified);
360         _;
361     }
362 
363     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
364       return oraclize_setNetwork();
365       _networkID; // silence the warning and remain backwards compatible
366     }
367 
368     function oraclize_setNetworkName(string memory _network_name) internal {
369         oraclize_network_name = _network_name;
370     }
371 
372     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
373         return oraclize_network_name;
374     }
375 
376     function oraclize_setNetwork() internal returns (bool _networkSet) {
377         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
378             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
379             oraclize_setNetworkName("eth_mainnet");
380             return true;
381         }
382         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
383             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
384             oraclize_setNetworkName("eth_ropsten3");
385             return true;
386         }
387         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
388             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
389             oraclize_setNetworkName("eth_kovan");
390             return true;
391         }
392         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
393             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
394             oraclize_setNetworkName("eth_rinkeby");
395             return true;
396         }
397         if (getCodeSize(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41) > 0) { //goerli testnet
398             OAR = OraclizeAddrResolverI(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41);
399             oraclize_setNetworkName("eth_goerli");
400             return true;
401         }
402         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
403             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
404             return true;
405         }
406         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
407             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
408             return true;
409         }
410         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
411             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
412             return true;
413         }
414         return false;
415     }
416 
417     function __callback(bytes32 _myid, string memory _result) public {
418         __callback(_myid, _result, new bytes(0));
419     }
420 
421     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
422       return;
423       _myid; _result; _proof; // Silence compiler warnings
424     }
425 
426     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
427         return oraclize.getPrice(_datasource);
428     }
429 
430     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
431         return oraclize.getPrice(_datasource, _gasLimit);
432     }
433 
434     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
435         uint price = oraclize.getPrice(_datasource);
436         if (price > 1 ether + tx.gasprice * 200000) {
437             return 0; // Unexpectedly high price
438         }
439         return oraclize.query.value(price)(0, _datasource, _arg);
440     }
441 
442     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
443         uint price = oraclize.getPrice(_datasource);
444         if (price > 1 ether + tx.gasprice * 200000) {
445             return 0; // Unexpectedly high price
446         }
447         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
448     }
449 
450     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
451         uint price = oraclize.getPrice(_datasource,_gasLimit);
452         if (price > 1 ether + tx.gasprice * _gasLimit) {
453             return 0; // Unexpectedly high price
454         }
455         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
456     }
457 
458     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
459         uint price = oraclize.getPrice(_datasource, _gasLimit);
460         if (price > 1 ether + tx.gasprice * _gasLimit) {
461            return 0; // Unexpectedly high price
462         }
463         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
464     }
465 
466     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
467         uint price = oraclize.getPrice(_datasource);
468         if (price > 1 ether + tx.gasprice * 200000) {
469             return 0; // Unexpectedly high price
470         }
471         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
472     }
473 
474     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
475         uint price = oraclize.getPrice(_datasource);
476         if (price > 1 ether + tx.gasprice * 200000) {
477             return 0; // Unexpectedly high price
478         }
479         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
480     }
481 
482     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
483         uint price = oraclize.getPrice(_datasource, _gasLimit);
484         if (price > 1 ether + tx.gasprice * _gasLimit) {
485             return 0; // Unexpectedly high price
486         }
487         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
488     }
489 
490     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
491         uint price = oraclize.getPrice(_datasource, _gasLimit);
492         if (price > 1 ether + tx.gasprice * _gasLimit) {
493             return 0; // Unexpectedly high price
494         }
495         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
496     }
497 
498     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
499         uint price = oraclize.getPrice(_datasource);
500         if (price > 1 ether + tx.gasprice * 200000) {
501             return 0; // Unexpectedly high price
502         }
503         bytes memory args = stra2cbor(_argN);
504         return oraclize.queryN.value(price)(0, _datasource, args);
505     }
506 
507     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
508         uint price = oraclize.getPrice(_datasource);
509         if (price > 1 ether + tx.gasprice * 200000) {
510             return 0; // Unexpectedly high price
511         }
512         bytes memory args = stra2cbor(_argN);
513         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
514     }
515 
516     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
517         uint price = oraclize.getPrice(_datasource, _gasLimit);
518         if (price > 1 ether + tx.gasprice * _gasLimit) {
519             return 0; // Unexpectedly high price
520         }
521         bytes memory args = stra2cbor(_argN);
522         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
523     }
524 
525     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
526         uint price = oraclize.getPrice(_datasource, _gasLimit);
527         if (price > 1 ether + tx.gasprice * _gasLimit) {
528             return 0; // Unexpectedly high price
529         }
530         bytes memory args = stra2cbor(_argN);
531         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
532     }
533 
534     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
535         string[] memory dynargs = new string[](1);
536         dynargs[0] = _args[0];
537         return oraclize_query(_datasource, dynargs);
538     }
539 
540     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
541         string[] memory dynargs = new string[](1);
542         dynargs[0] = _args[0];
543         return oraclize_query(_timestamp, _datasource, dynargs);
544     }
545 
546     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
547         string[] memory dynargs = new string[](1);
548         dynargs[0] = _args[0];
549         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
550     }
551 
552     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
553         string[] memory dynargs = new string[](1);
554         dynargs[0] = _args[0];
555         return oraclize_query(_datasource, dynargs, _gasLimit);
556     }
557 
558     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
559         string[] memory dynargs = new string[](2);
560         dynargs[0] = _args[0];
561         dynargs[1] = _args[1];
562         return oraclize_query(_datasource, dynargs);
563     }
564 
565     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
566         string[] memory dynargs = new string[](2);
567         dynargs[0] = _args[0];
568         dynargs[1] = _args[1];
569         return oraclize_query(_timestamp, _datasource, dynargs);
570     }
571 
572     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
573         string[] memory dynargs = new string[](2);
574         dynargs[0] = _args[0];
575         dynargs[1] = _args[1];
576         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
577     }
578 
579     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
580         string[] memory dynargs = new string[](2);
581         dynargs[0] = _args[0];
582         dynargs[1] = _args[1];
583         return oraclize_query(_datasource, dynargs, _gasLimit);
584     }
585 
586     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
587         string[] memory dynargs = new string[](3);
588         dynargs[0] = _args[0];
589         dynargs[1] = _args[1];
590         dynargs[2] = _args[2];
591         return oraclize_query(_datasource, dynargs);
592     }
593 
594     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
595         string[] memory dynargs = new string[](3);
596         dynargs[0] = _args[0];
597         dynargs[1] = _args[1];
598         dynargs[2] = _args[2];
599         return oraclize_query(_timestamp, _datasource, dynargs);
600     }
601 
602     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
603         string[] memory dynargs = new string[](3);
604         dynargs[0] = _args[0];
605         dynargs[1] = _args[1];
606         dynargs[2] = _args[2];
607         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
608     }
609 
610     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
611         string[] memory dynargs = new string[](3);
612         dynargs[0] = _args[0];
613         dynargs[1] = _args[1];
614         dynargs[2] = _args[2];
615         return oraclize_query(_datasource, dynargs, _gasLimit);
616     }
617 
618     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
619         string[] memory dynargs = new string[](4);
620         dynargs[0] = _args[0];
621         dynargs[1] = _args[1];
622         dynargs[2] = _args[2];
623         dynargs[3] = _args[3];
624         return oraclize_query(_datasource, dynargs);
625     }
626 
627     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
628         string[] memory dynargs = new string[](4);
629         dynargs[0] = _args[0];
630         dynargs[1] = _args[1];
631         dynargs[2] = _args[2];
632         dynargs[3] = _args[3];
633         return oraclize_query(_timestamp, _datasource, dynargs);
634     }
635 
636     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
637         string[] memory dynargs = new string[](4);
638         dynargs[0] = _args[0];
639         dynargs[1] = _args[1];
640         dynargs[2] = _args[2];
641         dynargs[3] = _args[3];
642         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
643     }
644 
645     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
646         string[] memory dynargs = new string[](4);
647         dynargs[0] = _args[0];
648         dynargs[1] = _args[1];
649         dynargs[2] = _args[2];
650         dynargs[3] = _args[3];
651         return oraclize_query(_datasource, dynargs, _gasLimit);
652     }
653 
654     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
655         string[] memory dynargs = new string[](5);
656         dynargs[0] = _args[0];
657         dynargs[1] = _args[1];
658         dynargs[2] = _args[2];
659         dynargs[3] = _args[3];
660         dynargs[4] = _args[4];
661         return oraclize_query(_datasource, dynargs);
662     }
663 
664     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
665         string[] memory dynargs = new string[](5);
666         dynargs[0] = _args[0];
667         dynargs[1] = _args[1];
668         dynargs[2] = _args[2];
669         dynargs[3] = _args[3];
670         dynargs[4] = _args[4];
671         return oraclize_query(_timestamp, _datasource, dynargs);
672     }
673 
674     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
675         string[] memory dynargs = new string[](5);
676         dynargs[0] = _args[0];
677         dynargs[1] = _args[1];
678         dynargs[2] = _args[2];
679         dynargs[3] = _args[3];
680         dynargs[4] = _args[4];
681         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
682     }
683 
684     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
685         string[] memory dynargs = new string[](5);
686         dynargs[0] = _args[0];
687         dynargs[1] = _args[1];
688         dynargs[2] = _args[2];
689         dynargs[3] = _args[3];
690         dynargs[4] = _args[4];
691         return oraclize_query(_datasource, dynargs, _gasLimit);
692     }
693 
694     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
695         uint price = oraclize.getPrice(_datasource);
696         if (price > 1 ether + tx.gasprice * 200000) {
697             return 0; // Unexpectedly high price
698         }
699         bytes memory args = ba2cbor(_argN);
700         return oraclize.queryN.value(price)(0, _datasource, args);
701     }
702 
703     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
704         uint price = oraclize.getPrice(_datasource);
705         if (price > 1 ether + tx.gasprice * 200000) {
706             return 0; // Unexpectedly high price
707         }
708         bytes memory args = ba2cbor(_argN);
709         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
710     }
711 
712     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
713         uint price = oraclize.getPrice(_datasource, _gasLimit);
714         if (price > 1 ether + tx.gasprice * _gasLimit) {
715             return 0; // Unexpectedly high price
716         }
717         bytes memory args = ba2cbor(_argN);
718         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
719     }
720 
721     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
722         uint price = oraclize.getPrice(_datasource, _gasLimit);
723         if (price > 1 ether + tx.gasprice * _gasLimit) {
724             return 0; // Unexpectedly high price
725         }
726         bytes memory args = ba2cbor(_argN);
727         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
728     }
729 
730     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
731         bytes[] memory dynargs = new bytes[](1);
732         dynargs[0] = _args[0];
733         return oraclize_query(_datasource, dynargs);
734     }
735 
736     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
737         bytes[] memory dynargs = new bytes[](1);
738         dynargs[0] = _args[0];
739         return oraclize_query(_timestamp, _datasource, dynargs);
740     }
741 
742     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
743         bytes[] memory dynargs = new bytes[](1);
744         dynargs[0] = _args[0];
745         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
746     }
747 
748     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
749         bytes[] memory dynargs = new bytes[](1);
750         dynargs[0] = _args[0];
751         return oraclize_query(_datasource, dynargs, _gasLimit);
752     }
753 
754     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
755         bytes[] memory dynargs = new bytes[](2);
756         dynargs[0] = _args[0];
757         dynargs[1] = _args[1];
758         return oraclize_query(_datasource, dynargs);
759     }
760 
761     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
762         bytes[] memory dynargs = new bytes[](2);
763         dynargs[0] = _args[0];
764         dynargs[1] = _args[1];
765         return oraclize_query(_timestamp, _datasource, dynargs);
766     }
767 
768     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
769         bytes[] memory dynargs = new bytes[](2);
770         dynargs[0] = _args[0];
771         dynargs[1] = _args[1];
772         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
773     }
774 
775     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
776         bytes[] memory dynargs = new bytes[](2);
777         dynargs[0] = _args[0];
778         dynargs[1] = _args[1];
779         return oraclize_query(_datasource, dynargs, _gasLimit);
780     }
781 
782     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
783         bytes[] memory dynargs = new bytes[](3);
784         dynargs[0] = _args[0];
785         dynargs[1] = _args[1];
786         dynargs[2] = _args[2];
787         return oraclize_query(_datasource, dynargs);
788     }
789 
790     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
791         bytes[] memory dynargs = new bytes[](3);
792         dynargs[0] = _args[0];
793         dynargs[1] = _args[1];
794         dynargs[2] = _args[2];
795         return oraclize_query(_timestamp, _datasource, dynargs);
796     }
797 
798     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
799         bytes[] memory dynargs = new bytes[](3);
800         dynargs[0] = _args[0];
801         dynargs[1] = _args[1];
802         dynargs[2] = _args[2];
803         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
804     }
805 
806     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
807         bytes[] memory dynargs = new bytes[](3);
808         dynargs[0] = _args[0];
809         dynargs[1] = _args[1];
810         dynargs[2] = _args[2];
811         return oraclize_query(_datasource, dynargs, _gasLimit);
812     }
813 
814     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
815         bytes[] memory dynargs = new bytes[](4);
816         dynargs[0] = _args[0];
817         dynargs[1] = _args[1];
818         dynargs[2] = _args[2];
819         dynargs[3] = _args[3];
820         return oraclize_query(_datasource, dynargs);
821     }
822 
823     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
824         bytes[] memory dynargs = new bytes[](4);
825         dynargs[0] = _args[0];
826         dynargs[1] = _args[1];
827         dynargs[2] = _args[2];
828         dynargs[3] = _args[3];
829         return oraclize_query(_timestamp, _datasource, dynargs);
830     }
831 
832     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
833         bytes[] memory dynargs = new bytes[](4);
834         dynargs[0] = _args[0];
835         dynargs[1] = _args[1];
836         dynargs[2] = _args[2];
837         dynargs[3] = _args[3];
838         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
839     }
840 
841     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
842         bytes[] memory dynargs = new bytes[](4);
843         dynargs[0] = _args[0];
844         dynargs[1] = _args[1];
845         dynargs[2] = _args[2];
846         dynargs[3] = _args[3];
847         return oraclize_query(_datasource, dynargs, _gasLimit);
848     }
849 
850     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
851         bytes[] memory dynargs = new bytes[](5);
852         dynargs[0] = _args[0];
853         dynargs[1] = _args[1];
854         dynargs[2] = _args[2];
855         dynargs[3] = _args[3];
856         dynargs[4] = _args[4];
857         return oraclize_query(_datasource, dynargs);
858     }
859 
860     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
861         bytes[] memory dynargs = new bytes[](5);
862         dynargs[0] = _args[0];
863         dynargs[1] = _args[1];
864         dynargs[2] = _args[2];
865         dynargs[3] = _args[3];
866         dynargs[4] = _args[4];
867         return oraclize_query(_timestamp, _datasource, dynargs);
868     }
869 
870     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
871         bytes[] memory dynargs = new bytes[](5);
872         dynargs[0] = _args[0];
873         dynargs[1] = _args[1];
874         dynargs[2] = _args[2];
875         dynargs[3] = _args[3];
876         dynargs[4] = _args[4];
877         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
878     }
879 
880     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
881         bytes[] memory dynargs = new bytes[](5);
882         dynargs[0] = _args[0];
883         dynargs[1] = _args[1];
884         dynargs[2] = _args[2];
885         dynargs[3] = _args[3];
886         dynargs[4] = _args[4];
887         return oraclize_query(_datasource, dynargs, _gasLimit);
888     }
889 
890     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
891         return oraclize.setProofType(_proofP);
892     }
893 
894 
895     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
896         return oraclize.cbAddress();
897     }
898 
899     function getCodeSize(address _addr) view internal returns (uint _size) {
900         assembly {
901             _size := extcodesize(_addr)
902         }
903     }
904 
905     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
906         return oraclize.setCustomGasPrice(_gasPrice);
907     }
908 
909     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
910         return oraclize.randomDS_getSessionPubKeyHash();
911     }
912 
913     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
914         bytes memory tmp = bytes(_a);
915         uint160 iaddr = 0;
916         uint160 b1;
917         uint160 b2;
918         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
919             iaddr *= 256;
920             b1 = uint160(uint8(tmp[i]));
921             b2 = uint160(uint8(tmp[i + 1]));
922             if ((b1 >= 97) && (b1 <= 102)) {
923                 b1 -= 87;
924             } else if ((b1 >= 65) && (b1 <= 70)) {
925                 b1 -= 55;
926             } else if ((b1 >= 48) && (b1 <= 57)) {
927                 b1 -= 48;
928             }
929             if ((b2 >= 97) && (b2 <= 102)) {
930                 b2 -= 87;
931             } else if ((b2 >= 65) && (b2 <= 70)) {
932                 b2 -= 55;
933             } else if ((b2 >= 48) && (b2 <= 57)) {
934                 b2 -= 48;
935             }
936             iaddr += (b1 * 16 + b2);
937         }
938         return address(iaddr);
939     }
940 
941     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
942         bytes memory a = bytes(_a);
943         bytes memory b = bytes(_b);
944         uint minLength = a.length;
945         if (b.length < minLength) {
946             minLength = b.length;
947         }
948         for (uint i = 0; i < minLength; i ++) {
949             if (a[i] < b[i]) {
950                 return -1;
951             } else if (a[i] > b[i]) {
952                 return 1;
953             }
954         }
955         if (a.length < b.length) {
956             return -1;
957         } else if (a.length > b.length) {
958             return 1;
959         } else {
960             return 0;
961         }
962     }
963 
964     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
965         bytes memory h = bytes(_haystack);
966         bytes memory n = bytes(_needle);
967         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
968             return -1;
969         } else if (h.length > (2 ** 128 - 1)) {
970             return -1;
971         } else {
972             uint subindex = 0;
973             for (uint i = 0; i < h.length; i++) {
974                 if (h[i] == n[0]) {
975                     subindex = 1;
976                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
977                         subindex++;
978                     }
979                     if (subindex == n.length) {
980                         return int(i);
981                     }
982                 }
983             }
984             return -1;
985         }
986     }
987 
988     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
989         return strConcat(_a, _b, "", "", "");
990     }
991 
992     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
993         return strConcat(_a, _b, _c, "", "");
994     }
995 
996     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
997         return strConcat(_a, _b, _c, _d, "");
998     }
999 
1000     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
1001         bytes memory _ba = bytes(_a);
1002         bytes memory _bb = bytes(_b);
1003         bytes memory _bc = bytes(_c);
1004         bytes memory _bd = bytes(_d);
1005         bytes memory _be = bytes(_e);
1006         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1007         bytes memory babcde = bytes(abcde);
1008         uint k = 0;
1009         uint i = 0;
1010         for (i = 0; i < _ba.length; i++) {
1011             babcde[k++] = _ba[i];
1012         }
1013         for (i = 0; i < _bb.length; i++) {
1014             babcde[k++] = _bb[i];
1015         }
1016         for (i = 0; i < _bc.length; i++) {
1017             babcde[k++] = _bc[i];
1018         }
1019         for (i = 0; i < _bd.length; i++) {
1020             babcde[k++] = _bd[i];
1021         }
1022         for (i = 0; i < _be.length; i++) {
1023             babcde[k++] = _be[i];
1024         }
1025         return string(babcde);
1026     }
1027 
1028     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
1029         return safeParseInt(_a, 0);
1030     }
1031 
1032     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1033         bytes memory bresult = bytes(_a);
1034         uint mint = 0;
1035         bool decimals = false;
1036         for (uint i = 0; i < bresult.length; i++) {
1037             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1038                 if (decimals) {
1039                    if (_b == 0) break;
1040                     else _b--;
1041                 }
1042                 mint *= 10;
1043                 mint += uint(uint8(bresult[i])) - 48;
1044             } else if (uint(uint8(bresult[i])) == 46) {
1045                 require(!decimals, 'More than one decimal encountered in string!');
1046                 decimals = true;
1047             } else {
1048                 revert("Non-numeral character encountered in string!");
1049             }
1050         }
1051         if (_b > 0) {
1052             mint *= 10 ** _b;
1053         }
1054         return mint;
1055     }
1056 
1057     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
1058         return parseInt(_a, 0);
1059     }
1060 
1061     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1062         bytes memory bresult = bytes(_a);
1063         uint mint = 0;
1064         bool decimals = false;
1065         for (uint i = 0; i < bresult.length; i++) {
1066             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1067                 if (decimals) {
1068                    if (_b == 0) {
1069                        break;
1070                    } else {
1071                        _b--;
1072                    }
1073                 }
1074                 mint *= 10;
1075                 mint += uint(uint8(bresult[i])) - 48;
1076             } else if (uint(uint8(bresult[i])) == 46) {
1077                 decimals = true;
1078             }
1079         }
1080         if (_b > 0) {
1081             mint *= 10 ** _b;
1082         }
1083         return mint;
1084     }
1085 
1086     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1087         if (_i == 0) {
1088             return "0";
1089         }
1090         uint j = _i;
1091         uint len;
1092         while (j != 0) {
1093             len++;
1094             j /= 10;
1095         }
1096         bytes memory bstr = new bytes(len);
1097         uint k = len - 1;
1098         while (_i != 0) {
1099             bstr[k--] = byte(uint8(48 + _i % 10));
1100             _i /= 10;
1101         }
1102         return string(bstr);
1103     }
1104 
1105     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1106         safeMemoryCleaner();
1107         Buffer.buffer memory buf;
1108         Buffer.init(buf, 1024);
1109         buf.startArray();
1110         for (uint i = 0; i < _arr.length; i++) {
1111             buf.encodeString(_arr[i]);
1112         }
1113         buf.endSequence();
1114         return buf.buf;
1115     }
1116 
1117     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1118         safeMemoryCleaner();
1119         Buffer.buffer memory buf;
1120         Buffer.init(buf, 1024);
1121         buf.startArray();
1122         for (uint i = 0; i < _arr.length; i++) {
1123             buf.encodeBytes(_arr[i]);
1124         }
1125         buf.endSequence();
1126         return buf.buf;
1127     }
1128 
1129     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1130         require((_nbytes > 0) && (_nbytes <= 32));
1131         _delay *= 10; // Convert from seconds to ledger timer ticks
1132         bytes memory nbytes = new bytes(1);
1133         nbytes[0] = byte(uint8(_nbytes));
1134         bytes memory unonce = new bytes(32);
1135         bytes memory sessionKeyHash = new bytes(32);
1136         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1137         assembly {
1138             mstore(unonce, 0x20)
1139             /*
1140              The following variables can be relaxed.
1141              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1142              for an idea on how to override and replace commit hash variables.
1143             */
1144             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1145             mstore(sessionKeyHash, 0x20)
1146             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1147         }
1148         bytes memory delay = new bytes(32);
1149         assembly {
1150             mstore(add(delay, 0x20), _delay)
1151         }
1152         bytes memory delay_bytes8 = new bytes(8);
1153         copyBytes(delay, 24, 8, delay_bytes8, 0);
1154         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1155         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1156         bytes memory delay_bytes8_left = new bytes(8);
1157         assembly {
1158             let x := mload(add(delay_bytes8, 0x20))
1159             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1160             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1161             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1162             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1163             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1164             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1165             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1166             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1167         }
1168         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1169         return queryId;
1170     }
1171 
1172     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1173         oraclize_randomDS_args[_queryId] = _commitment;
1174     }
1175 
1176     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1177         bool sigok;
1178         address signer;
1179         bytes32 sigr;
1180         bytes32 sigs;
1181         bytes memory sigr_ = new bytes(32);
1182         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1183         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1184         bytes memory sigs_ = new bytes(32);
1185         offset += 32 + 2;
1186         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1187         assembly {
1188             sigr := mload(add(sigr_, 32))
1189             sigs := mload(add(sigs_, 32))
1190         }
1191         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1192         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1193             return true;
1194         } else {
1195             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1196             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1197         }
1198     }
1199 
1200     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1201         bool sigok;
1202         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1203         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1204         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1205         bytes memory appkey1_pubkey = new bytes(64);
1206         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1207         bytes memory tosign2 = new bytes(1 + 65 + 32);
1208         tosign2[0] = byte(uint8(1)); //role
1209         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1210         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1211         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1212         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1213         if (!sigok) {
1214             return false;
1215         }
1216         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1217         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1218         bytes memory tosign3 = new bytes(1 + 65);
1219         tosign3[0] = 0xFE;
1220         copyBytes(_proof, 3, 65, tosign3, 1);
1221         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1222         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1223         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1224         return sigok;
1225     }
1226 
1227     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1228         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1229         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1230             return 1;
1231         }
1232         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1233         if (!proofVerified) {
1234             return 2;
1235         }
1236         return 0;
1237     }
1238 
1239     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1240         bool match_ = true;
1241         require(_prefix.length == _nRandomBytes);
1242         for (uint256 i = 0; i< _nRandomBytes; i++) {
1243             if (_content[i] != _prefix[i]) {
1244                 match_ = false;
1245             }
1246         }
1247         return match_;
1248     }
1249 
1250     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1251         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1252         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1253         bytes memory keyhash = new bytes(32);
1254         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1255         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1256             return false;
1257         }
1258         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1259         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1260         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1261         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1262             return false;
1263         }
1264         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1265         // This is to verify that the computed args match with the ones specified in the query.
1266         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1267         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1268         bytes memory sessionPubkey = new bytes(64);
1269         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1270         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1271         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1272         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1273             delete oraclize_randomDS_args[_queryId];
1274         } else return false;
1275         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1276         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1277         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1278         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1279             return false;
1280         }
1281         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1282         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1283             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1284         }
1285         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1286     }
1287     /*
1288      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1289     */
1290     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1291         uint minLength = _length + _toOffset;
1292         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1293         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1294         uint j = 32 + _toOffset;
1295         while (i < (32 + _fromOffset + _length)) {
1296             assembly {
1297                 let tmp := mload(add(_from, i))
1298                 mstore(add(_to, j), tmp)
1299             }
1300             i += 32;
1301             j += 32;
1302         }
1303         return _to;
1304     }
1305     /*
1306      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1307      Duplicate Solidity's ecrecover, but catching the CALL return value
1308     */
1309     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1310         /*
1311          We do our own memory management here. Solidity uses memory offset
1312          0x40 to store the current end of memory. We write past it (as
1313          writes are memory extensions), but don't update the offset so
1314          Solidity will reuse it. The memory used here is only needed for
1315          this context.
1316          FIXME: inline assembly can't access return values
1317         */
1318         bool ret;
1319         address addr;
1320         assembly {
1321             let size := mload(0x40)
1322             mstore(size, _hash)
1323             mstore(add(size, 32), _v)
1324             mstore(add(size, 64), _r)
1325             mstore(add(size, 96), _s)
1326             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1327             addr := mload(size)
1328         }
1329         return (ret, addr);
1330     }
1331     /*
1332      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1333     */
1334     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1335         bytes32 r;
1336         bytes32 s;
1337         uint8 v;
1338         if (_sig.length != 65) {
1339             return (false, address(0));
1340         }
1341         /*
1342          The signature format is a compact form of:
1343            {bytes32 r}{bytes32 s}{uint8 v}
1344          Compact means, uint8 is not padded to 32 bytes.
1345         */
1346         assembly {
1347             r := mload(add(_sig, 32))
1348             s := mload(add(_sig, 64))
1349             /*
1350              Here we are loading the last 32 bytes. We exploit the fact that
1351              'mload' will pad with zeroes if we overread.
1352              There is no 'mload8' to do this, but that would be nicer.
1353             */
1354             v := byte(0, mload(add(_sig, 96)))
1355             /*
1356               Alternative solution:
1357               'byte' is not working due to the Solidity parser, so lets
1358               use the second best option, 'and'
1359               v := and(mload(add(_sig, 65)), 255)
1360             */
1361         }
1362         /*
1363          albeit non-transactional signatures are not specified by the YP, one would expect it
1364          to match the YP range of [27, 28]
1365          geth uses [0, 1] and some clients have followed. This might change, see:
1366          https://github.com/ethereum/go-ethereum/issues/2053
1367         */
1368         if (v < 27) {
1369             v += 27;
1370         }
1371         if (v != 27 && v != 28) {
1372             return (false, address(0));
1373         }
1374         return safer_ecrecover(_hash, v, r, s);
1375     }
1376 
1377     function safeMemoryCleaner() internal pure {
1378         assembly {
1379             let fmem := mload(0x40)
1380             codecopy(fmem, codesize, sub(msize, fmem))
1381         }
1382     }
1383 }
1384 /*
1385 
1386 END ORACLIZE_API
1387 
1388 */
1389 interface IERC165 {
1390     /**
1391      * @notice Query if a contract implements an interface
1392      * @param interfaceId The interface identifier, as specified in ERC-165
1393      * @dev Interface identification is specified in ERC-165. This function
1394      * uses less than 30,000 gas.
1395      */
1396     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1397 }
1398 
1399 library SafeMath {
1400     /**
1401      * @dev Multiplies two unsigned integers, reverts on overflow.
1402      */
1403     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1404         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1405         // benefit is lost if 'b' is also tested.
1406         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1407         if (a == 0) {
1408             return 0;
1409         }
1410 
1411         uint256 c = a * b;
1412         require(c / a == b);
1413 
1414         return c;
1415     }
1416 
1417     /**
1418      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
1419      */
1420     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1421         // Solidity only automatically asserts when dividing by 0
1422         require(b > 0);
1423         uint256 c = a / b;
1424         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1425 
1426         return c;
1427     }
1428 
1429     /**
1430      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
1431      */
1432     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1433         require(b <= a);
1434         uint256 c = a - b;
1435 
1436         return c;
1437     }
1438 
1439     /**
1440      * @dev Adds two unsigned integers, reverts on overflow.
1441      */
1442     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1443         uint256 c = a + b;
1444         require(c >= a);
1445 
1446         return c;
1447     }
1448 
1449     /**
1450      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
1451      * reverts when dividing by zero.
1452      */
1453     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1454         require(b != 0);
1455         return a % b;
1456     }
1457 }
1458 
1459 contract IERC721Receiver {
1460     /**
1461      * @notice Handle the receipt of an NFT
1462      * @dev The ERC721 smart contract calls this function on the recipient
1463      * after a `safeTransfer`. This function MUST return the function selector,
1464      * otherwise the caller will revert the transaction. The selector to be
1465      * returned can be obtained as `this.onERC721Received.selector`. This
1466      * function MAY throw to revert and reject the transfer.
1467      * Note: the ERC721 contract address is always the message sender.
1468      * @param operator The address which called `safeTransferFrom` function
1469      * @param from The address which previously owned the token
1470      * @param tokenId The NFT identifier which is being transferred
1471      * @param data Additional data with no specified format
1472      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1473      */
1474     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
1475     public returns (bytes4);
1476 }
1477 
1478 library Address {
1479     /**
1480      * Returns whether the target address is a contract
1481      * @dev This function will return false if invoked during the constructor of a contract,
1482      * as the code is not actually created until after the constructor finishes.
1483      * @param account address of the account to check
1484      * @return whether the target address is a contract
1485      */
1486     function isContract(address account) internal view returns (bool) {
1487         uint256 size;
1488         // XXX Currently there is no better way to check if there is a contract in an address
1489         // than to check the size of the code at that address.
1490         // See https://ethereum.stackexchange.com/a/14016/36603
1491         // for more details about how this works.
1492         // TODO Check this again before the Serenity release, because all addresses will be
1493         // contracts then.
1494         // solhint-disable-next-line no-inline-assembly
1495         assembly { size := extcodesize(account) }
1496         return size > 0;
1497     }
1498 }
1499 
1500 contract IERC721 is IERC165 {
1501     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1502     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1503     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1504 
1505     function balanceOf(address owner) public view returns (uint256 balance);
1506     function ownerOf(uint256 tokenId) public view returns (address owner);
1507 
1508     function approve(address to, uint256 tokenId) public;
1509     function getApproved(uint256 tokenId) public view returns (address operator);
1510 
1511     function setApprovalForAll(address operator, bool _approved) public;
1512     function isApprovedForAll(address owner, address operator) public view returns (bool);
1513 
1514     function transferFrom(address from, address to, uint256 tokenId) public;
1515     function safeTransferFrom(address from, address to, uint256 tokenId) public;
1516 
1517     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
1518 }
1519 
1520 library Counters {
1521     using SafeMath for uint256;
1522 
1523     struct Counter {
1524         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1525         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1526         // this feature: see https://github.com/ethereum/solidity/issues/4637
1527         uint256 _value; // default: 0
1528     }
1529 
1530     function current(Counter storage counter) internal view returns (uint256) {
1531         return counter._value;
1532     }
1533 
1534     function increment(Counter storage counter) internal {
1535         counter._value += 1;
1536     }
1537 
1538     function decrement(Counter storage counter) internal {
1539         counter._value = counter._value.sub(1);
1540     }
1541 }
1542 
1543 contract ERC165 is IERC165 {
1544     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1545     /*
1546      * 0x01ffc9a7 ===
1547      *     bytes4(keccak256('supportsInterface(bytes4)'))
1548      */
1549 
1550     /**
1551      * @dev a mapping of interface id to whether or not it's supported
1552      */
1553     mapping(bytes4 => bool) private _supportedInterfaces;
1554 
1555     /**
1556      * @dev A contract implementing SupportsInterfaceWithLookup
1557      * implement ERC165 itself
1558      */
1559     constructor () internal {
1560         _registerInterface(_INTERFACE_ID_ERC165);
1561     }
1562 
1563     /**
1564      * @dev implement supportsInterface(bytes4) using a lookup table
1565      */
1566     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
1567         return _supportedInterfaces[interfaceId];
1568     }
1569 
1570     /**
1571      * @dev internal method for registering an interface
1572      */
1573     function _registerInterface(bytes4 interfaceId) internal {
1574         require(interfaceId != 0xffffffff);
1575         _supportedInterfaces[interfaceId] = true;
1576     }
1577 }
1578 
1579 contract ERC721 is ERC165, IERC721 {
1580     using SafeMath for uint256;
1581     using Address for address;
1582     using Counters for Counters.Counter;
1583 
1584     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1585     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1586     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1587 
1588     // Mapping from token ID to owner
1589     mapping (uint256 => address) private _tokenOwner;
1590 
1591     // Mapping from token ID to approved address
1592     mapping (uint256 => address) private _tokenApprovals;
1593 
1594     // Mapping from owner to number of owned token
1595     mapping (address => Counters.Counter) private _ownedTokensCount;
1596 
1597     // Mapping from owner to operator approvals
1598     mapping (address => mapping (address => bool)) private _operatorApprovals;
1599 
1600     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1601     /*
1602      * 0x80ac58cd ===
1603      *     bytes4(keccak256('balanceOf(address)')) ^
1604      *     bytes4(keccak256('ownerOf(uint256)')) ^
1605      *     bytes4(keccak256('approve(address,uint256)')) ^
1606      *     bytes4(keccak256('getApproved(uint256)')) ^
1607      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
1608      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
1609      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
1610      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
1611      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
1612      */
1613 
1614     constructor () public {
1615         // register the supported interfaces to conform to ERC721 via ERC165
1616         _registerInterface(_INTERFACE_ID_ERC721);
1617     }
1618 
1619     /**
1620      * @dev Gets the balance of the specified address
1621      * @param owner address to query the balance of
1622      * @return uint256 representing the amount owned by the passed address
1623      */
1624     function balanceOf(address owner) public view returns (uint256) {
1625         require(owner != address(0));
1626         return _ownedTokensCount[owner].current();
1627     }
1628 
1629     /**
1630      * @dev Gets the owner of the specified token ID
1631      * @param tokenId uint256 ID of the token to query the owner of
1632      * @return address currently marked as the owner of the given token ID
1633      */
1634     function ownerOf(uint256 tokenId) public view returns (address) {
1635         address owner = _tokenOwner[tokenId];
1636         require(owner != address(0));
1637         return owner;
1638     }
1639 
1640     /**
1641      * @dev Approves another address to transfer the given token ID
1642      * The zero address indicates there is no approved address.
1643      * There can only be one approved address per token at a given time.
1644      * Can only be called by the token owner or an approved operator.
1645      * @param to address to be approved for the given token ID
1646      * @param tokenId uint256 ID of the token to be approved
1647      */
1648     function approve(address to, uint256 tokenId) public {
1649         address owner = ownerOf(tokenId);
1650         require(to != owner);
1651         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
1652 
1653         _tokenApprovals[tokenId] = to;
1654         emit Approval(owner, to, tokenId);
1655     }
1656 
1657     /**
1658      * @dev Gets the approved address for a token ID, or zero if no address set
1659      * Reverts if the token ID does not exist.
1660      * @param tokenId uint256 ID of the token to query the approval of
1661      * @return address currently approved for the given token ID
1662      */
1663     function getApproved(uint256 tokenId) public view returns (address) {
1664         require(_exists(tokenId));
1665         return _tokenApprovals[tokenId];
1666     }
1667 
1668     /**
1669      * @dev Sets or unsets the approval of a given operator
1670      * An operator is allowed to transfer all tokens of the sender on their behalf
1671      * @param to operator address to set the approval
1672      * @param approved representing the status of the approval to be set
1673      */
1674     function setApprovalForAll(address to, bool approved) public {
1675         require(to != msg.sender);
1676         _operatorApprovals[msg.sender][to] = approved;
1677         emit ApprovalForAll(msg.sender, to, approved);
1678     }
1679 
1680     /**
1681      * @dev Tells whether an operator is approved by a given owner
1682      * @param owner owner address which you want to query the approval of
1683      * @param operator operator address which you want to query the approval of
1684      * @return bool whether the given operator is approved by the given owner
1685      */
1686     function isApprovedForAll(address owner, address operator) public view returns (bool) {
1687         return _operatorApprovals[owner][operator];
1688     }
1689 
1690     /**
1691      * @dev Transfers the ownership of a given token ID to another address
1692      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
1693      * Requires the msg.sender to be the owner, approved, or operator
1694      * @param from current owner of the token
1695      * @param to address to receive the ownership of the given token ID
1696      * @param tokenId uint256 ID of the token to be transferred
1697      */
1698     function transferFrom(address from, address to, uint256 tokenId) public {
1699         require(_isApprovedOrOwner(msg.sender, tokenId));
1700 
1701         _transferFrom(from, to, tokenId);
1702     }
1703 
1704     /**
1705      * @dev Safely transfers the ownership of a given token ID to another address
1706      * If the target address is a contract, it must implement `onERC721Received`,
1707      * which is called upon a safe transfer, and return the magic value
1708      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1709      * the transfer is reverted.
1710      * Requires the msg.sender to be the owner, approved, or operator
1711      * @param from current owner of the token
1712      * @param to address to receive the ownership of the given token ID
1713      * @param tokenId uint256 ID of the token to be transferred
1714      */
1715     function safeTransferFrom(address from, address to, uint256 tokenId) public {
1716         safeTransferFrom(from, to, tokenId, "");
1717     }
1718 
1719     /**
1720      * @dev Safely transfers the ownership of a given token ID to another address
1721      * If the target address is a contract, it must implement `onERC721Received`,
1722      * which is called upon a safe transfer, and return the magic value
1723      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1724      * the transfer is reverted.
1725      * Requires the msg.sender to be the owner, approved, or operator
1726      * @param from current owner of the token
1727      * @param to address to receive the ownership of the given token ID
1728      * @param tokenId uint256 ID of the token to be transferred
1729      * @param _data bytes data to send along with a safe transfer check
1730      */
1731     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
1732         transferFrom(from, to, tokenId);
1733         require(_checkOnERC721Received(from, to, tokenId, _data));
1734     }
1735 
1736     /**
1737      * @dev Returns whether the specified token exists
1738      * @param tokenId uint256 ID of the token to query the existence of
1739      * @return bool whether the token exists
1740      */
1741     function _exists(uint256 tokenId) internal view returns (bool) {
1742         address owner = _tokenOwner[tokenId];
1743         return owner != address(0);
1744     }
1745 
1746     /**
1747      * @dev Returns whether the given spender can transfer a given token ID
1748      * @param spender address of the spender to query
1749      * @param tokenId uint256 ID of the token to be transferred
1750      * @return bool whether the msg.sender is approved for the given token ID,
1751      * is an operator of the owner, or is the owner of the token
1752      */
1753     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1754         address owner = ownerOf(tokenId);
1755         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1756     }
1757 
1758     /**
1759      * @dev Internal function to mint a new token
1760      * Reverts if the given token ID already exists
1761      * @param to The address that will own the minted token
1762      * @param tokenId uint256 ID of the token to be minted
1763      */
1764     function _mint(address to, uint256 tokenId) internal {
1765         require(to != address(0));
1766         require(!_exists(tokenId));
1767 
1768         _tokenOwner[tokenId] = to;
1769         _ownedTokensCount[to].increment();
1770 
1771         emit Transfer(address(0), to, tokenId);
1772     }
1773 
1774     /**
1775      * @dev Internal function to burn a specific token
1776      * Reverts if the token does not exist
1777      * Deprecated, use _burn(uint256) instead.
1778      * @param owner owner of the token to burn
1779      * @param tokenId uint256 ID of the token being burned
1780      */
1781     function _burn(address owner, uint256 tokenId) internal {
1782         require(ownerOf(tokenId) == owner);
1783 
1784         _clearApproval(tokenId);
1785 
1786         _ownedTokensCount[owner].decrement();
1787         _tokenOwner[tokenId] = address(0);
1788 
1789         emit Transfer(owner, address(0), tokenId);
1790     }
1791 
1792     /**
1793      * @dev Internal function to burn a specific token
1794      * Reverts if the token does not exist
1795      * @param tokenId uint256 ID of the token being burned
1796      */
1797     function _burn(uint256 tokenId) internal {
1798         _burn(ownerOf(tokenId), tokenId);
1799     }
1800 
1801     /**
1802      * @dev Internal function to transfer ownership of a given token ID to another address.
1803      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1804      * @param from current owner of the token
1805      * @param to address to receive the ownership of the given token ID
1806      * @param tokenId uint256 ID of the token to be transferred
1807      */
1808     function _transferFrom(address from, address to, uint256 tokenId) internal {
1809         require(ownerOf(tokenId) == from);
1810         require(to != address(0));
1811 
1812         _clearApproval(tokenId);
1813 
1814         _ownedTokensCount[from].decrement();
1815         _ownedTokensCount[to].increment();
1816 
1817         _tokenOwner[tokenId] = to;
1818 
1819         emit Transfer(from, to, tokenId);
1820     }
1821 
1822     /**
1823      * @dev Internal function to invoke `onERC721Received` on a target address
1824      * The call is not executed if the target address is not a contract
1825      * @param from address representing the previous owner of the given token ID
1826      * @param to target address that will receive the tokens
1827      * @param tokenId uint256 ID of the token to be transferred
1828      * @param _data bytes optional data to send along with the call
1829      * @return bool whether the call correctly returned the expected magic value
1830      */
1831     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1832         internal returns (bool)
1833     {
1834         if (!to.isContract()) {
1835             return true;
1836         }
1837 
1838         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
1839         return (retval == _ERC721_RECEIVED);
1840     }
1841 
1842     /**
1843      * @dev Private function to clear current approval of a given token ID
1844      * @param tokenId uint256 ID of the token to be transferred
1845      */
1846     function _clearApproval(uint256 tokenId) private {
1847         if (_tokenApprovals[tokenId] != address(0)) {
1848             _tokenApprovals[tokenId] = address(0);
1849         }
1850     }
1851 }
1852 
1853 contract IERC721Enumerable is IERC721 {
1854     function totalSupply() public view returns (uint256);
1855     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
1856 
1857     function tokenByIndex(uint256 index) public view returns (uint256);
1858 }
1859 
1860 contract ERC721Holder is IERC721Receiver {
1861     function onERC721Received(address, address, uint256, bytes memory) public returns (bytes4) {
1862         return this.onERC721Received.selector;
1863     }
1864 }
1865 
1866 contract IERC721Metadata is IERC721 {
1867     function name() external view returns (string memory);
1868     function symbol() external view returns (string memory);
1869     function tokenURI(uint256 tokenId) external view returns (string memory);
1870 }
1871 
1872 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
1873     // Mapping from owner to list of owned token IDs
1874     mapping(address => uint256[]) private _ownedTokens;
1875 
1876     // Mapping from token ID to index of the owner tokens list
1877     mapping(uint256 => uint256) private _ownedTokensIndex;
1878 
1879     // Array with all token ids, used for enumeration
1880     uint256[] private _allTokens;
1881 
1882     // Mapping from token id to position in the allTokens array
1883     mapping(uint256 => uint256) private _allTokensIndex;
1884 
1885     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1886     /*
1887      * 0x780e9d63 ===
1888      *     bytes4(keccak256('totalSupply()')) ^
1889      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
1890      *     bytes4(keccak256('tokenByIndex(uint256)'))
1891      */
1892 
1893     /**
1894      * @dev Constructor function
1895      */
1896     constructor () public {
1897         // register the supported interface to conform to ERC721Enumerable via ERC165
1898         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1899     }
1900 
1901     /**
1902      * @dev Gets the token ID at a given index of the tokens list of the requested owner
1903      * @param owner address owning the tokens list to be accessed
1904      * @param index uint256 representing the index to be accessed of the requested tokens list
1905      * @return uint256 token ID at the given index of the tokens list owned by the requested address
1906      */
1907     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
1908         require(index < balanceOf(owner));
1909         return _ownedTokens[owner][index];
1910     }
1911 
1912     /**
1913      * @dev Gets the total amount of tokens stored by the contract
1914      * @return uint256 representing the total amount of tokens
1915      */
1916     function totalSupply() public view returns (uint256) {
1917         return _allTokens.length;
1918     }
1919 
1920     /**
1921      * @dev Gets the token ID at a given index of all the tokens in this contract
1922      * Reverts if the index is greater or equal to the total number of tokens
1923      * @param index uint256 representing the index to be accessed of the tokens list
1924      * @return uint256 token ID at the given index of the tokens list
1925      */
1926     function tokenByIndex(uint256 index) public view returns (uint256) {
1927         require(index < totalSupply());
1928         return _allTokens[index];
1929     }
1930 
1931     /**
1932      * @dev Internal function to transfer ownership of a given token ID to another address.
1933      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1934      * @param from current owner of the token
1935      * @param to address to receive the ownership of the given token ID
1936      * @param tokenId uint256 ID of the token to be transferred
1937      */
1938     function _transferFrom(address from, address to, uint256 tokenId) internal {
1939         super._transferFrom(from, to, tokenId);
1940 
1941         _removeTokenFromOwnerEnumeration(from, tokenId);
1942 
1943         _addTokenToOwnerEnumeration(to, tokenId);
1944     }
1945 
1946     /**
1947      * @dev Internal function to mint a new token
1948      * Reverts if the given token ID already exists
1949      * @param to address the beneficiary that will own the minted token
1950      * @param tokenId uint256 ID of the token to be minted
1951      */
1952     function _mint(address to, uint256 tokenId) internal {
1953         super._mint(to, tokenId);
1954 
1955         _addTokenToOwnerEnumeration(to, tokenId);
1956 
1957         _addTokenToAllTokensEnumeration(tokenId);
1958     }
1959 
1960     /**
1961      * @dev Internal function to burn a specific token
1962      * Reverts if the token does not exist
1963      * Deprecated, use _burn(uint256) instead
1964      * @param owner owner of the token to burn
1965      * @param tokenId uint256 ID of the token being burned
1966      */
1967     function _burn(address owner, uint256 tokenId) internal {
1968         super._burn(owner, tokenId);
1969 
1970         _removeTokenFromOwnerEnumeration(owner, tokenId);
1971         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
1972         _ownedTokensIndex[tokenId] = 0;
1973 
1974         _removeTokenFromAllTokensEnumeration(tokenId);
1975     }
1976 
1977     /**
1978      * @dev Gets the list of token IDs of the requested owner
1979      * @param owner address owning the tokens
1980      * @return uint256[] List of token IDs owned by the requested address
1981      */
1982     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
1983         return _ownedTokens[owner];
1984     }
1985 
1986     /**
1987      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1988      * @param to address representing the new owner of the given token ID
1989      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1990      */
1991     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1992         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
1993         _ownedTokens[to].push(tokenId);
1994     }
1995 
1996     /**
1997      * @dev Private function to add a token to this extension's token tracking data structures.
1998      * @param tokenId uint256 ID of the token to be added to the tokens list
1999      */
2000     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2001         _allTokensIndex[tokenId] = _allTokens.length;
2002         _allTokens.push(tokenId);
2003     }
2004 
2005     /**
2006      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2007      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
2008      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2009      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2010      * @param from address representing the previous owner of the given token ID
2011      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2012      */
2013     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2014         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2015         // then delete the last slot (swap and pop).
2016 
2017         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
2018         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2019 
2020         // When the token to delete is the last token, the swap operation is unnecessary
2021         if (tokenIndex != lastTokenIndex) {
2022             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2023 
2024             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2025             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2026         }
2027 
2028         // This also deletes the contents at the last position of the array
2029         _ownedTokens[from].length--;
2030 
2031         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
2032         // lastTokenId, or just over the end of the array if the token was the last one).
2033     }
2034 
2035     /**
2036      * @dev Private function to remove a token from this extension's token tracking data structures.
2037      * This has O(1) time complexity, but alters the order of the _allTokens array.
2038      * @param tokenId uint256 ID of the token to be removed from the tokens list
2039      */
2040     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2041         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2042         // then delete the last slot (swap and pop).
2043 
2044         uint256 lastTokenIndex = _allTokens.length.sub(1);
2045         uint256 tokenIndex = _allTokensIndex[tokenId];
2046 
2047         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2048         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2049         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2050         uint256 lastTokenId = _allTokens[lastTokenIndex];
2051 
2052         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2053         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2054 
2055         // This also deletes the contents at the last position of the array
2056         _allTokens.length--;
2057         _allTokensIndex[tokenId] = 0;
2058     }
2059 }
2060 
2061 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
2062     // Token name
2063     string private _name;
2064 
2065     // Token symbol
2066     string private _symbol;
2067 
2068     // Optional mapping for token URIs
2069     mapping(uint256 => string) private _tokenURIs;
2070 
2071     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
2072     /*
2073      * 0x5b5e139f ===
2074      *     bytes4(keccak256('name()')) ^
2075      *     bytes4(keccak256('symbol()')) ^
2076      *     bytes4(keccak256('tokenURI(uint256)'))
2077      */
2078 
2079     /**
2080      * @dev Constructor function
2081      */
2082     constructor (string memory name, string memory symbol) public {
2083         _name = name;
2084         _symbol = symbol;
2085 
2086         // register the supported interfaces to conform to ERC721 via ERC165
2087         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
2088     }
2089 
2090     /**
2091      * @dev Gets the token name
2092      * @return string representing the token name
2093      */
2094     function name() external view returns (string memory) {
2095         return _name;
2096     }
2097 
2098     /**
2099      * @dev Gets the token symbol
2100      * @return string representing the token symbol
2101      */
2102     function symbol() external view returns (string memory) {
2103         return _symbol;
2104     }
2105 
2106     /**
2107      * @dev Returns an URI for a given token ID
2108      * Throws if the token ID does not exist. May return an empty string.
2109      * @param tokenId uint256 ID of the token to query
2110      */
2111     function tokenURI(uint256 tokenId) external view returns (string memory) {
2112         require(_exists(tokenId));
2113         return _tokenURIs[tokenId];
2114     }
2115 
2116     /**
2117      * @dev Internal function to set the token URI for a given token
2118      * Reverts if the token ID does not exist
2119      * @param tokenId uint256 ID of the token to set its URI
2120      * @param uri string URI to assign
2121      */
2122     function _setTokenURI(uint256 tokenId, string memory uri) internal {
2123         require(_exists(tokenId));
2124         _tokenURIs[tokenId] = uri;
2125     }
2126 
2127     /**
2128      * @dev Internal function to burn a specific token
2129      * Reverts if the token does not exist
2130      * Deprecated, use _burn(uint256) instead
2131      * @param owner owner of the token to burn
2132      * @param tokenId uint256 ID of the token being burned by the msg.sender
2133      */
2134     function _burn(address owner, uint256 tokenId) internal {
2135         super._burn(owner, tokenId);
2136 
2137         // Clear metadata (if any)
2138         if (bytes(_tokenURIs[tokenId]).length != 0) {
2139             delete _tokenURIs[tokenId];
2140         }
2141     }
2142 }
2143 
2144 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
2145     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
2146         // solhint-disable-previous-line no-empty-blocks
2147     }
2148 }
2149 
2150 contract Gener8tiveKBlocksERC721 is Ownable, ERC721Full, ERC721Holder, usingOraclize
2151 {
2152     using SafeMath for uint8;
2153     using SafeMath for uint16;
2154     using Counters for Counters.Counter;
2155 
2156     // =======================================================
2157     // EVENTS
2158     // =======================================================
2159     event CauseBeneficiaryChanged(address indexed);
2160     event TokenUriUpdated(uint256 indexed tokenId);
2161     event FundsWithdrawn(address recipient, uint256 amount);
2162 
2163     // =======================================================
2164     // STATE
2165     // =======================================================
2166     Counters.Counter private tokenId;
2167     
2168     address payable public causeBeneficiary;
2169     
2170     uint256 public constant price = 275 finney;
2171     uint256 public constant feePercentage = 15;
2172     uint8 public constant maxSupply = 250;
2173     uint8 public constant creatorSupply = 50;
2174     
2175     // =======================================================
2176     // CONSTRUCTOR
2177     // =======================================================
2178     constructor (string memory _name, string memory _symbol, address payable _causeBeneficiary) public
2179         ERC721Full(_name, _symbol)
2180     {
2181         causeBeneficiary = _causeBeneficiary;
2182     }
2183 
2184     // =======================================================
2185     // STRURCTS & ENUMS
2186     // =======================================================
2187     struct Rectangle {
2188         uint8 index;
2189         uint8 x;
2190         uint8 y;
2191         uint8 width;
2192         uint8 height;
2193         uint16 color;
2194         uint16 saturation;
2195         uint16 colorRatio;
2196         uint16 transparency;
2197     }
2198 
2199      struct Circle {
2200          uint8 x;
2201          uint8 y;
2202          uint8 r;
2203          uint16 color;
2204      }
2205 
2206     // =======================================================
2207     // ADMIN
2208     // =======================================================
2209     function changeCauseBeneficiary(address payable newCauseBeneficiary)
2210         public
2211         onlyOwner
2212     {
2213         causeBeneficiary = newCauseBeneficiary;
2214         emit CauseBeneficiaryChanged(causeBeneficiary);
2215     }
2216 
2217     function updateTokenURI(uint256 _tokenId, string memory newTokenURI)
2218         public
2219         onlyOwner
2220     {
2221         super._setTokenURI(_tokenId, newTokenURI);
2222         emit TokenUriUpdated(_tokenId);
2223     }
2224 
2225     function withdrawFunds(address payable recipient, uint256 amount)
2226         public
2227         onlyOwner
2228     {
2229         recipient.transfer(amount);
2230         emit FundsWithdrawn(recipient, amount);
2231     }
2232 
2233     // =======================================================
2234     // UTILS & HELPERS
2235     // =======================================================
2236     function mul16(uint16 a, uint16 b) internal pure returns (uint16) {
2237         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
2238         // benefit is lost if 'b' is also tested.
2239         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
2240         if (a == 0) {
2241             return 0;
2242         }
2243 
2244         uint16 c = a * b;
2245         require(c / a == b);
2246 
2247         return c;
2248     }
2249 
2250     function mul256(uint256 a, uint256 b) internal pure returns (uint256) {
2251         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
2252         // benefit is lost if 'b' is also tested.
2253         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
2254         if (a == 0) {
2255             return 0;
2256         }
2257 
2258         uint256 c = a * b;
2259         require(c / a == b);
2260 
2261         return c;
2262     }
2263 
2264     function div16(uint16 a, uint16 b) internal pure returns (uint16) {
2265         // Solidity only automatically asserts when dividing by 0
2266         require(b > 0);
2267         uint16 c = a / b;
2268         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
2269 
2270         return c;
2271     }
2272 
2273     function div256(uint256 a, uint256 b) internal pure returns (uint256) {
2274         // Solidity only automatically asserts when dividing by 0
2275         require(b > 0);
2276         uint256 c = a / b;
2277         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
2278 
2279         return c;
2280     }
2281 
2282     // =======================================================
2283     // PUBLIC API
2284     // =======================================================
2285     function mint()
2286         external
2287         payable
2288     {
2289         // ensure the max supply has not been reached
2290         require(totalSupply() < maxSupply, "Max tokens issued");
2291         
2292         // the following block applicable for public minting
2293         if(msg.sender != owner()) {
2294             // ensure sufficient funds were sent
2295             require(msg.value >= price, "Insufficient ETH sent with transaction");
2296 
2297             // calculate system fees percentage
2298             uint256 fee = div256(mul256(feePercentage, msg.value), 100);
2299 
2300             // send to cause beneficiary (revert if no beneficiary is set)
2301             require(causeBeneficiary != address(0), "Cause Beneficiary not set");
2302             causeBeneficiary.transfer(msg.value - fee);
2303         }
2304         else {
2305             require(totalSupply() < creatorSupply, "Max number creator tokens already issued");
2306         }
2307 
2308         string memory tokenIdStr = uint2str(tokenId.current());
2309 
2310         super._mint(msg.sender, tokenId.current());
2311         super._setTokenURI(tokenId.current(), strConcat("https://api.gener8tive.io/kcompositions/tokens/metadata/", tokenIdStr));
2312 
2313         tokenId.increment();
2314     }
2315 
2316     function tokensOwned(address ownerAddress)
2317         public
2318         view
2319         returns (uint256[] memory)
2320     {
2321         return super._tokensOfOwner(ownerAddress);
2322     }
2323 
2324     function drawKComposistion(uint256 _tokenId)
2325         public
2326         view
2327         returns(bytes32 idKeccak, Rectangle[] memory rectangles, Circle memory circle)
2328     {
2329         if(!isOwner()) {
2330             // only allow viewing of composition data of tokens that have already been minted
2331             require(_exists(_tokenId), "Requested token does not exist yet");
2332         }
2333 
2334         idKeccak = keccak256(abi.encodePacked(_tokenId));
2335         
2336         uint8 numHashParts = uint8(idKeccak.length);
2337         
2338         rectangles = new Rectangle[](numHashParts / 3);
2339         
2340         uint8 pointer = 0;
2341         for(uint8 i = 0; i < rectangles.length; i++) {
2342             uint8 rectVal1 = uint8((idKeccak[pointer] >> 4) & 0x0f);
2343             uint8 rectVal2 = uint8(idKeccak[pointer] & 0x0f);
2344             uint8 rectVal3 = uint8((idKeccak[++pointer] >> 4) & 0x0f);
2345             uint8 rectVal4 = uint8(uint8(idKeccak[pointer] & 0x0f));
2346             uint8 rectVal5 = uint8((idKeccak[++pointer] >> 4) & 0x0f);
2347             uint8 rectVal6 = uint8(uint8(idKeccak[pointer] & 0x0f));
2348 
2349             //limit colorRatio to avoid whites
2350             uint16 crValue = div16(mul16(rectVal5, 100), 15);
2351             if(crValue > 90) {
2352                 crValue = 90;
2353             }
2354             
2355             uint16 tmpSaturation = div16(mul16(rectVal3, 100), 15);
2356 
2357             Rectangle memory r = Rectangle({
2358                 index: i,
2359                 x: rectVal1,
2360                 y: rectVal2,
2361                 width: rectVal3,
2362                 height: rectVal4,
2363                 color: div16(mul16(rectVal1, 360), 15),
2364                 saturation: tmpSaturation > 95 ? 95 : tmpSaturation,
2365                 colorRatio: crValue,
2366                 transparency: rectVal6 < 1 ? 1 : rectVal6
2367             });
2368 
2369             pointer++;
2370 
2371             rectangles[i] = r;
2372         }
2373 
2374         circle =  Circle({
2375             x: uint8((idKeccak[pointer] >> 4) & 0x0f),
2376             y: uint8(idKeccak[pointer] & 0x0f),
2377             r: uint8((idKeccak[++pointer] >> 4) & 0x0f),
2378             color: div16(mul16(uint8(idKeccak[pointer] & 0x0f), 360), 15)
2379         });
2380     }
2381 
2382     function getSupplyData(address ownerAddress)
2383         external
2384         view
2385         returns(
2386             uint8 supplyDataMaxSupply,
2387             uint8 supplyDataCreatorSupply,
2388             address supplyDataCauseBeneficiary,
2389             uint256 supplyDataPrice,
2390             uint256 supplyDataFeePercentage,
2391             uint256 supplyDataTotalSupply,
2392             uint256[] memory ownedTokens)
2393     {
2394         supplyDataCauseBeneficiary = causeBeneficiary;
2395         supplyDataPrice = price;
2396         supplyDataFeePercentage = feePercentage;
2397         supplyDataMaxSupply = maxSupply;
2398         supplyDataCreatorSupply = creatorSupply;
2399         supplyDataTotalSupply = totalSupply();
2400         ownedTokens = tokensOwned(ownerAddress);
2401     }
2402 
2403     function getTokenData(uint256 _tokenId)
2404         external
2405         view
2406         returns(
2407             bytes32 idKeccak,
2408             Rectangle[] memory rectangles,
2409             Circle memory circle,
2410             string memory tokenURI,
2411             address owner)
2412     {
2413         (idKeccak, rectangles, circle) = drawKComposistion(_tokenId);
2414         tokenURI = this.tokenURI(_tokenId);
2415         owner = ownerOf(_tokenId);
2416     }
2417 }