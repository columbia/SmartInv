1 // File: contracts/provableAPI.sol
2 
3 // <provableAPI>
4 /*
5 
6 
7 Copyright (c) 2015-2016 Oraclize SRL
8 Copyright (c) 2016-2019 Oraclize LTD
9 Copyright (c) 2019 Provable Things Limited
10 
11 Permission is hereby granted, free of charge, to any person obtaining a copy
12 of this software and associated documentation files (the "Software"), to deal
13 in the Software without restriction, including without limitation the rights
14 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
15 copies of the Software, and to permit persons to whom the Software is
16 furnished to do so, subject to the following conditions:
17 
18 The above copyright notice and this permission notice shall be included in
19 all copies or substantial portions of the Software.
20 
21 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
22 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
23 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
24 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
25 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
26 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
27 THE SOFTWARE.
28 
29 */
30 pragma solidity >= 0.5.0 < 0.6.0; // Incompatible compiler version - please select a compiler within the stated pragma range, or use a different version of the provableAPI!
31 
32 // Dummy contract only used to emit to end-user they are using wrong solc
33 contract solcChecker {
34 /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;
35 }
36 
37 contract ProvableI {
38 
39     address public cbAddress;
40 
41     function setProofType(byte _proofType) external;
42     function setCustomGasPrice(uint _gasPrice) external;
43     function getPrice(string memory _datasource) public returns (uint _dsprice);
44     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
45     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
46     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
47     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
48     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
49     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
50     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
51     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
52 }
53 
54 contract OracleAddrResolverI {
55     function getAddress() public returns (address _address);
56 }
57 /*
58 
59 Begin solidity-cborutils
60 
61 https://github.com/smartcontractkit/solidity-cborutils
62 
63 MIT License
64 
65 Copyright (c) 2018 SmartContract ChainLink, Ltd.
66 
67 Permission is hereby granted, free of charge, to any person obtaining a copy
68 of this software and associated documentation files (the "Software"), to deal
69 in the Software without restriction, including without limitation the rights
70 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
71 copies of the Software, and to permit persons to whom the Software is
72 furnished to do so, subject to the following conditions:
73 
74 The above copyright notice and this permission notice shall be included in all
75 copies or substantial portions of the Software.
76 
77 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
78 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
79 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
80 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
81 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
82 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
83 SOFTWARE.
84 
85 */
86 library Buffer {
87 
88     struct buffer {
89         bytes buf;
90         uint capacity;
91     }
92 
93     function init(buffer memory _buf, uint _capacity) internal pure {
94         uint capacity = _capacity;
95         if (capacity % 32 != 0) {
96             capacity += 32 - (capacity % 32);
97         }
98         _buf.capacity = capacity; // Allocate space for the buffer data
99         assembly {
100             let ptr := mload(0x40)
101             mstore(_buf, ptr)
102             mstore(ptr, 0)
103             mstore(0x40, add(ptr, capacity))
104         }
105     }
106 
107     function resize(buffer memory _buf, uint _capacity) private pure {
108         bytes memory oldbuf = _buf.buf;
109         init(_buf, _capacity);
110         append(_buf, oldbuf);
111     }
112 
113     function max(uint _a, uint _b) private pure returns (uint _max) {
114         if (_a > _b) {
115             return _a;
116         }
117         return _b;
118     }
119     /**
120       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
121       *      would exceed the capacity of the buffer.
122       * @param _buf The buffer to append to.
123       * @param _data The data to append.
124       * @return The original buffer.
125       *
126       */
127     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
128         if (_data.length + _buf.buf.length > _buf.capacity) {
129             resize(_buf, max(_buf.capacity, _data.length) * 2);
130         }
131         uint dest;
132         uint src;
133         uint len = _data.length;
134         assembly {
135             let bufptr := mload(_buf) // Memory address of the buffer data
136             let buflen := mload(bufptr) // Length of existing buffer data
137             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
138             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
139             src := add(_data, 32)
140         }
141         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
142             assembly {
143                 mstore(dest, mload(src))
144             }
145             dest += 32;
146             src += 32;
147         }
148         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
149         assembly {
150             let srcpart := and(mload(src), not(mask))
151             let destpart := and(mload(dest), mask)
152             mstore(dest, or(destpart, srcpart))
153         }
154         return _buf;
155     }
156     /**
157       *
158       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
159       * exceed the capacity of the buffer.
160       * @param _buf The buffer to append to.
161       * @param _data The data to append.
162       * @return The original buffer.
163       *
164       */
165     function append(buffer memory _buf, uint8 _data) internal pure {
166         if (_buf.buf.length + 1 > _buf.capacity) {
167             resize(_buf, _buf.capacity * 2);
168         }
169         assembly {
170             let bufptr := mload(_buf) // Memory address of the buffer data
171             let buflen := mload(bufptr) // Length of existing buffer data
172             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
173             mstore8(dest, _data)
174             mstore(bufptr, add(buflen, 1)) // Update buffer length
175         }
176     }
177     /**
178       *
179       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
180       * exceed the capacity of the buffer.
181       * @param _buf The buffer to append to.
182       * @param _data The data to append.
183       * @return The original buffer.
184       *
185       */
186     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
187         if (_len + _buf.buf.length > _buf.capacity) {
188             resize(_buf, max(_buf.capacity, _len) * 2);
189         }
190         uint mask = 256 ** _len - 1;
191         assembly {
192             let bufptr := mload(_buf) // Memory address of the buffer data
193             let buflen := mload(bufptr) // Length of existing buffer data
194             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
195             mstore(dest, or(and(mload(dest), not(mask)), _data))
196             mstore(bufptr, add(buflen, _len)) // Update buffer length
197         }
198         return _buf;
199     }
200 }
201 
202 library CBOR {
203 
204     using Buffer for Buffer.buffer;
205 
206     uint8 private constant MAJOR_TYPE_INT = 0;
207     uint8 private constant MAJOR_TYPE_MAP = 5;
208     uint8 private constant MAJOR_TYPE_BYTES = 2;
209     uint8 private constant MAJOR_TYPE_ARRAY = 4;
210     uint8 private constant MAJOR_TYPE_STRING = 3;
211     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
212     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
213 
214     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
215         if (_value <= 23) {
216             _buf.append(uint8((_major << 5) | _value));
217         } else if (_value <= 0xFF) {
218             _buf.append(uint8((_major << 5) | 24));
219             _buf.appendInt(_value, 1);
220         } else if (_value <= 0xFFFF) {
221             _buf.append(uint8((_major << 5) | 25));
222             _buf.appendInt(_value, 2);
223         } else if (_value <= 0xFFFFFFFF) {
224             _buf.append(uint8((_major << 5) | 26));
225             _buf.appendInt(_value, 4);
226         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
227             _buf.append(uint8((_major << 5) | 27));
228             _buf.appendInt(_value, 8);
229         }
230     }
231 
232     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
233         _buf.append(uint8((_major << 5) | 31));
234     }
235 
236     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
237         encodeType(_buf, MAJOR_TYPE_INT, _value);
238     }
239 
240     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
241         if (_value >= 0) {
242             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
243         } else {
244             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
245         }
246     }
247 
248     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
249         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
250         _buf.append(_value);
251     }
252 
253     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
254         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
255         _buf.append(bytes(_value));
256     }
257 
258     function startArray(Buffer.buffer memory _buf) internal pure {
259         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
260     }
261 
262     function startMap(Buffer.buffer memory _buf) internal pure {
263         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
264     }
265 
266     function endSequence(Buffer.buffer memory _buf) internal pure {
267         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
268     }
269 }
270 /*
271 
272 End solidity-cborutils
273 
274 */
275 contract usingProvable {
276 
277     using CBOR for Buffer.buffer;
278 
279     ProvableI provable;
280     OracleAddrResolverI OAR;
281 
282     uint constant day = 60 * 60 * 24;
283     uint constant week = 60 * 60 * 24 * 7;
284     uint constant month = 60 * 60 * 24 * 30;
285 
286     byte constant proofType_NONE = 0x00;
287     byte constant proofType_Ledger = 0x30;
288     byte constant proofType_Native = 0xF0;
289     byte constant proofStorage_IPFS = 0x01;
290     byte constant proofType_Android = 0x40;
291     byte constant proofType_TLSNotary = 0x10;
292 
293     string provable_network_name;
294     uint8 constant networkID_auto = 0;
295     uint8 constant networkID_morden = 2;
296     uint8 constant networkID_mainnet = 1;
297     uint8 constant networkID_testnet = 2;
298     uint8 constant networkID_consensys = 161;
299 
300     mapping(bytes32 => bytes32) provable_randomDS_args;
301     mapping(bytes32 => bool) provable_randomDS_sessionKeysHashVerified;
302 
303     modifier provableAPI {
304         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
305             provable_setNetwork(networkID_auto);
306         }
307         if (address(provable) != OAR.getAddress()) {
308             provable = ProvableI(OAR.getAddress());
309         }
310         _;
311     }
312 
313     modifier provable_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
314         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
315         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
316         bool proofVerified = provable_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), provable_getNetworkName());
317         require(proofVerified);
318         _;
319     }
320 
321     function provable_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
322       _networkID; // NOTE: Silence the warning and remain backwards compatible
323       return provable_setNetwork();
324     }
325 
326     function provable_setNetworkName(string memory _network_name) internal {
327         provable_network_name = _network_name;
328     }
329 
330     function provable_getNetworkName() internal view returns (string memory _networkName) {
331         return provable_network_name;
332     }
333 
334     function provable_setNetwork() internal returns (bool _networkSet) {
335         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
336             OAR = OracleAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
337             provable_setNetworkName("eth_mainnet");
338             return true;
339         }
340         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
341             OAR = OracleAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
342             provable_setNetworkName("eth_ropsten3");
343             return true;
344         }
345         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
346             OAR = OracleAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
347             provable_setNetworkName("eth_kovan");
348             return true;
349         }
350         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
351             OAR = OracleAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
352             provable_setNetworkName("eth_rinkeby");
353             return true;
354         }
355         if (getCodeSize(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41) > 0) { //goerli testnet
356             OAR = OracleAddrResolverI(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41);
357             provable_setNetworkName("eth_goerli");
358             return true;
359         }
360         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
361             OAR = OracleAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
362             return true;
363         }
364         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
365             OAR = OracleAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
366             return true;
367         }
368         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
369             OAR = OracleAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
370             return true;
371         }
372         return false;
373     }
374     /**
375      * @dev The following `__callback` functions are just placeholders ideally
376      *      meant to be defined in child contract when proofs are used.
377      *      The function bodies simply silence compiler warnings.
378      */
379     function __callback(bytes32 _myid, string memory _result) public {
380         __callback(_myid, _result, new bytes(0));
381     }
382 
383     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
384       _myid; _result; _proof;
385       provable_randomDS_args[bytes32(0)] = bytes32(0);
386     }
387 
388     function provable_getPrice(string memory _datasource) provableAPI internal returns (uint _queryPrice) {
389         return provable.getPrice(_datasource);
390     }
391 
392     function provable_getPrice(string memory _datasource, uint _gasLimit) provableAPI internal returns (uint _queryPrice) {
393         return provable.getPrice(_datasource, _gasLimit);
394     }
395 
396     function provable_query(string memory _datasource, string memory _arg) provableAPI internal returns (bytes32 _id) {
397         uint price = provable.getPrice(_datasource);
398         if (price > 1 ether + tx.gasprice * 200000) {
399             return 0; // Unexpectedly high price
400         }
401         return provable.query.value(price)(0, _datasource, _arg);
402     }
403 
404     function provable_query(uint _timestamp, string memory _datasource, string memory _arg) provableAPI internal returns (bytes32 _id) {
405         uint price = provable.getPrice(_datasource);
406         if (price > 1 ether + tx.gasprice * 200000) {
407             return 0; // Unexpectedly high price
408         }
409         return provable.query.value(price)(_timestamp, _datasource, _arg);
410     }
411 
412     function provable_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
413         uint price = provable.getPrice(_datasource,_gasLimit);
414         if (price > 1 ether + tx.gasprice * _gasLimit) {
415             return 0; // Unexpectedly high price
416         }
417         return provable.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
418     }
419 
420     function provable_query(string memory _datasource, string memory _arg, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
421         uint price = provable.getPrice(_datasource, _gasLimit);
422         if (price > 1 ether + tx.gasprice * _gasLimit) {
423            return 0; // Unexpectedly high price
424         }
425         return provable.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
426     }
427 
428     function provable_query(string memory _datasource, string memory _arg1, string memory _arg2) provableAPI internal returns (bytes32 _id) {
429         uint price = provable.getPrice(_datasource);
430         if (price > 1 ether + tx.gasprice * 200000) {
431             return 0; // Unexpectedly high price
432         }
433         return provable.query2.value(price)(0, _datasource, _arg1, _arg2);
434     }
435 
436     function provable_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) provableAPI internal returns (bytes32 _id) {
437         uint price = provable.getPrice(_datasource);
438         if (price > 1 ether + tx.gasprice * 200000) {
439             return 0; // Unexpectedly high price
440         }
441         return provable.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
442     }
443 
444     function provable_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
445         uint price = provable.getPrice(_datasource, _gasLimit);
446         if (price > 1 ether + tx.gasprice * _gasLimit) {
447             return 0; // Unexpectedly high price
448         }
449         return provable.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
450     }
451 
452     function provable_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
453         uint price = provable.getPrice(_datasource, _gasLimit);
454         if (price > 1 ether + tx.gasprice * _gasLimit) {
455             return 0; // Unexpectedly high price
456         }
457         return provable.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
458     }
459 
460     function provable_query(string memory _datasource, string[] memory _argN) provableAPI internal returns (bytes32 _id) {
461         uint price = provable.getPrice(_datasource);
462         if (price > 1 ether + tx.gasprice * 200000) {
463             return 0; // Unexpectedly high price
464         }
465         bytes memory args = stra2cbor(_argN);
466         return provable.queryN.value(price)(0, _datasource, args);
467     }
468 
469     function provable_query(uint _timestamp, string memory _datasource, string[] memory _argN) provableAPI internal returns (bytes32 _id) {
470         uint price = provable.getPrice(_datasource);
471         if (price > 1 ether + tx.gasprice * 200000) {
472             return 0; // Unexpectedly high price
473         }
474         bytes memory args = stra2cbor(_argN);
475         return provable.queryN.value(price)(_timestamp, _datasource, args);
476     }
477 
478     function provable_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
479         uint price = provable.getPrice(_datasource, _gasLimit);
480         if (price > 1 ether + tx.gasprice * _gasLimit) {
481             return 0; // Unexpectedly high price
482         }
483         bytes memory args = stra2cbor(_argN);
484         return provable.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
485     }
486 
487     function provable_query(string memory _datasource, string[] memory _argN, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
488         uint price = provable.getPrice(_datasource, _gasLimit);
489         if (price > 1 ether + tx.gasprice * _gasLimit) {
490             return 0; // Unexpectedly high price
491         }
492         bytes memory args = stra2cbor(_argN);
493         return provable.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
494     }
495 
496     function provable_query(string memory _datasource, string[1] memory _args) provableAPI internal returns (bytes32 _id) {
497         string[] memory dynargs = new string[](1);
498         dynargs[0] = _args[0];
499         return provable_query(_datasource, dynargs);
500     }
501 
502     function provable_query(uint _timestamp, string memory _datasource, string[1] memory _args) provableAPI internal returns (bytes32 _id) {
503         string[] memory dynargs = new string[](1);
504         dynargs[0] = _args[0];
505         return provable_query(_timestamp, _datasource, dynargs);
506     }
507 
508     function provable_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
509         string[] memory dynargs = new string[](1);
510         dynargs[0] = _args[0];
511         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
512     }
513 
514     function provable_query(string memory _datasource, string[1] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
515         string[] memory dynargs = new string[](1);
516         dynargs[0] = _args[0];
517         return provable_query(_datasource, dynargs, _gasLimit);
518     }
519 
520     function provable_query(string memory _datasource, string[2] memory _args) provableAPI internal returns (bytes32 _id) {
521         string[] memory dynargs = new string[](2);
522         dynargs[0] = _args[0];
523         dynargs[1] = _args[1];
524         return provable_query(_datasource, dynargs);
525     }
526 
527     function provable_query(uint _timestamp, string memory _datasource, string[2] memory _args) provableAPI internal returns (bytes32 _id) {
528         string[] memory dynargs = new string[](2);
529         dynargs[0] = _args[0];
530         dynargs[1] = _args[1];
531         return provable_query(_timestamp, _datasource, dynargs);
532     }
533 
534     function provable_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
535         string[] memory dynargs = new string[](2);
536         dynargs[0] = _args[0];
537         dynargs[1] = _args[1];
538         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
539     }
540 
541     function provable_query(string memory _datasource, string[2] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
542         string[] memory dynargs = new string[](2);
543         dynargs[0] = _args[0];
544         dynargs[1] = _args[1];
545         return provable_query(_datasource, dynargs, _gasLimit);
546     }
547 
548     function provable_query(string memory _datasource, string[3] memory _args) provableAPI internal returns (bytes32 _id) {
549         string[] memory dynargs = new string[](3);
550         dynargs[0] = _args[0];
551         dynargs[1] = _args[1];
552         dynargs[2] = _args[2];
553         return provable_query(_datasource, dynargs);
554     }
555 
556     function provable_query(uint _timestamp, string memory _datasource, string[3] memory _args) provableAPI internal returns (bytes32 _id) {
557         string[] memory dynargs = new string[](3);
558         dynargs[0] = _args[0];
559         dynargs[1] = _args[1];
560         dynargs[2] = _args[2];
561         return provable_query(_timestamp, _datasource, dynargs);
562     }
563 
564     function provable_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
565         string[] memory dynargs = new string[](3);
566         dynargs[0] = _args[0];
567         dynargs[1] = _args[1];
568         dynargs[2] = _args[2];
569         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
570     }
571 
572     function provable_query(string memory _datasource, string[3] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
573         string[] memory dynargs = new string[](3);
574         dynargs[0] = _args[0];
575         dynargs[1] = _args[1];
576         dynargs[2] = _args[2];
577         return provable_query(_datasource, dynargs, _gasLimit);
578     }
579 
580     function provable_query(string memory _datasource, string[4] memory _args) provableAPI internal returns (bytes32 _id) {
581         string[] memory dynargs = new string[](4);
582         dynargs[0] = _args[0];
583         dynargs[1] = _args[1];
584         dynargs[2] = _args[2];
585         dynargs[3] = _args[3];
586         return provable_query(_datasource, dynargs);
587     }
588 
589     function provable_query(uint _timestamp, string memory _datasource, string[4] memory _args) provableAPI internal returns (bytes32 _id) {
590         string[] memory dynargs = new string[](4);
591         dynargs[0] = _args[0];
592         dynargs[1] = _args[1];
593         dynargs[2] = _args[2];
594         dynargs[3] = _args[3];
595         return provable_query(_timestamp, _datasource, dynargs);
596     }
597 
598     function provable_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
599         string[] memory dynargs = new string[](4);
600         dynargs[0] = _args[0];
601         dynargs[1] = _args[1];
602         dynargs[2] = _args[2];
603         dynargs[3] = _args[3];
604         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
605     }
606 
607     function provable_query(string memory _datasource, string[4] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
608         string[] memory dynargs = new string[](4);
609         dynargs[0] = _args[0];
610         dynargs[1] = _args[1];
611         dynargs[2] = _args[2];
612         dynargs[3] = _args[3];
613         return provable_query(_datasource, dynargs, _gasLimit);
614     }
615 
616     function provable_query(string memory _datasource, string[5] memory _args) provableAPI internal returns (bytes32 _id) {
617         string[] memory dynargs = new string[](5);
618         dynargs[0] = _args[0];
619         dynargs[1] = _args[1];
620         dynargs[2] = _args[2];
621         dynargs[3] = _args[3];
622         dynargs[4] = _args[4];
623         return provable_query(_datasource, dynargs);
624     }
625 
626     function provable_query(uint _timestamp, string memory _datasource, string[5] memory _args) provableAPI internal returns (bytes32 _id) {
627         string[] memory dynargs = new string[](5);
628         dynargs[0] = _args[0];
629         dynargs[1] = _args[1];
630         dynargs[2] = _args[2];
631         dynargs[3] = _args[3];
632         dynargs[4] = _args[4];
633         return provable_query(_timestamp, _datasource, dynargs);
634     }
635 
636     function provable_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
637         string[] memory dynargs = new string[](5);
638         dynargs[0] = _args[0];
639         dynargs[1] = _args[1];
640         dynargs[2] = _args[2];
641         dynargs[3] = _args[3];
642         dynargs[4] = _args[4];
643         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
644     }
645 
646     function provable_query(string memory _datasource, string[5] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
647         string[] memory dynargs = new string[](5);
648         dynargs[0] = _args[0];
649         dynargs[1] = _args[1];
650         dynargs[2] = _args[2];
651         dynargs[3] = _args[3];
652         dynargs[4] = _args[4];
653         return provable_query(_datasource, dynargs, _gasLimit);
654     }
655 
656     function provable_query(string memory _datasource, bytes[] memory _argN) provableAPI internal returns (bytes32 _id) {
657         uint price = provable.getPrice(_datasource);
658         if (price > 1 ether + tx.gasprice * 200000) {
659             return 0; // Unexpectedly high price
660         }
661         bytes memory args = ba2cbor(_argN);
662         return provable.queryN.value(price)(0, _datasource, args);
663     }
664 
665     function provable_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) provableAPI internal returns (bytes32 _id) {
666         uint price = provable.getPrice(_datasource);
667         if (price > 1 ether + tx.gasprice * 200000) {
668             return 0; // Unexpectedly high price
669         }
670         bytes memory args = ba2cbor(_argN);
671         return provable.queryN.value(price)(_timestamp, _datasource, args);
672     }
673 
674     function provable_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
675         uint price = provable.getPrice(_datasource, _gasLimit);
676         if (price > 1 ether + tx.gasprice * _gasLimit) {
677             return 0; // Unexpectedly high price
678         }
679         bytes memory args = ba2cbor(_argN);
680         return provable.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
681     }
682 
683     function provable_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
684         uint price = provable.getPrice(_datasource, _gasLimit);
685         if (price > 1 ether + tx.gasprice * _gasLimit) {
686             return 0; // Unexpectedly high price
687         }
688         bytes memory args = ba2cbor(_argN);
689         return provable.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
690     }
691 
692     function provable_query(string memory _datasource, bytes[1] memory _args) provableAPI internal returns (bytes32 _id) {
693         bytes[] memory dynargs = new bytes[](1);
694         dynargs[0] = _args[0];
695         return provable_query(_datasource, dynargs);
696     }
697 
698     function provable_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) provableAPI internal returns (bytes32 _id) {
699         bytes[] memory dynargs = new bytes[](1);
700         dynargs[0] = _args[0];
701         return provable_query(_timestamp, _datasource, dynargs);
702     }
703 
704     function provable_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
705         bytes[] memory dynargs = new bytes[](1);
706         dynargs[0] = _args[0];
707         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
708     }
709 
710     function provable_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
711         bytes[] memory dynargs = new bytes[](1);
712         dynargs[0] = _args[0];
713         return provable_query(_datasource, dynargs, _gasLimit);
714     }
715 
716     function provable_query(string memory _datasource, bytes[2] memory _args) provableAPI internal returns (bytes32 _id) {
717         bytes[] memory dynargs = new bytes[](2);
718         dynargs[0] = _args[0];
719         dynargs[1] = _args[1];
720         return provable_query(_datasource, dynargs);
721     }
722 
723     function provable_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) provableAPI internal returns (bytes32 _id) {
724         bytes[] memory dynargs = new bytes[](2);
725         dynargs[0] = _args[0];
726         dynargs[1] = _args[1];
727         return provable_query(_timestamp, _datasource, dynargs);
728     }
729 
730     function provable_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
731         bytes[] memory dynargs = new bytes[](2);
732         dynargs[0] = _args[0];
733         dynargs[1] = _args[1];
734         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
735     }
736 
737     function provable_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
738         bytes[] memory dynargs = new bytes[](2);
739         dynargs[0] = _args[0];
740         dynargs[1] = _args[1];
741         return provable_query(_datasource, dynargs, _gasLimit);
742     }
743 
744     function provable_query(string memory _datasource, bytes[3] memory _args) provableAPI internal returns (bytes32 _id) {
745         bytes[] memory dynargs = new bytes[](3);
746         dynargs[0] = _args[0];
747         dynargs[1] = _args[1];
748         dynargs[2] = _args[2];
749         return provable_query(_datasource, dynargs);
750     }
751 
752     function provable_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) provableAPI internal returns (bytes32 _id) {
753         bytes[] memory dynargs = new bytes[](3);
754         dynargs[0] = _args[0];
755         dynargs[1] = _args[1];
756         dynargs[2] = _args[2];
757         return provable_query(_timestamp, _datasource, dynargs);
758     }
759 
760     function provable_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
761         bytes[] memory dynargs = new bytes[](3);
762         dynargs[0] = _args[0];
763         dynargs[1] = _args[1];
764         dynargs[2] = _args[2];
765         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
766     }
767 
768     function provable_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
769         bytes[] memory dynargs = new bytes[](3);
770         dynargs[0] = _args[0];
771         dynargs[1] = _args[1];
772         dynargs[2] = _args[2];
773         return provable_query(_datasource, dynargs, _gasLimit);
774     }
775 
776     function provable_query(string memory _datasource, bytes[4] memory _args) provableAPI internal returns (bytes32 _id) {
777         bytes[] memory dynargs = new bytes[](4);
778         dynargs[0] = _args[0];
779         dynargs[1] = _args[1];
780         dynargs[2] = _args[2];
781         dynargs[3] = _args[3];
782         return provable_query(_datasource, dynargs);
783     }
784 
785     function provable_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) provableAPI internal returns (bytes32 _id) {
786         bytes[] memory dynargs = new bytes[](4);
787         dynargs[0] = _args[0];
788         dynargs[1] = _args[1];
789         dynargs[2] = _args[2];
790         dynargs[3] = _args[3];
791         return provable_query(_timestamp, _datasource, dynargs);
792     }
793 
794     function provable_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
795         bytes[] memory dynargs = new bytes[](4);
796         dynargs[0] = _args[0];
797         dynargs[1] = _args[1];
798         dynargs[2] = _args[2];
799         dynargs[3] = _args[3];
800         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
801     }
802 
803     function provable_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
804         bytes[] memory dynargs = new bytes[](4);
805         dynargs[0] = _args[0];
806         dynargs[1] = _args[1];
807         dynargs[2] = _args[2];
808         dynargs[3] = _args[3];
809         return provable_query(_datasource, dynargs, _gasLimit);
810     }
811 
812     function provable_query(string memory _datasource, bytes[5] memory _args) provableAPI internal returns (bytes32 _id) {
813         bytes[] memory dynargs = new bytes[](5);
814         dynargs[0] = _args[0];
815         dynargs[1] = _args[1];
816         dynargs[2] = _args[2];
817         dynargs[3] = _args[3];
818         dynargs[4] = _args[4];
819         return provable_query(_datasource, dynargs);
820     }
821 
822     function provable_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) provableAPI internal returns (bytes32 _id) {
823         bytes[] memory dynargs = new bytes[](5);
824         dynargs[0] = _args[0];
825         dynargs[1] = _args[1];
826         dynargs[2] = _args[2];
827         dynargs[3] = _args[3];
828         dynargs[4] = _args[4];
829         return provable_query(_timestamp, _datasource, dynargs);
830     }
831 
832     function provable_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
833         bytes[] memory dynargs = new bytes[](5);
834         dynargs[0] = _args[0];
835         dynargs[1] = _args[1];
836         dynargs[2] = _args[2];
837         dynargs[3] = _args[3];
838         dynargs[4] = _args[4];
839         return provable_query(_timestamp, _datasource, dynargs, _gasLimit);
840     }
841 
842     function provable_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) provableAPI internal returns (bytes32 _id) {
843         bytes[] memory dynargs = new bytes[](5);
844         dynargs[0] = _args[0];
845         dynargs[1] = _args[1];
846         dynargs[2] = _args[2];
847         dynargs[3] = _args[3];
848         dynargs[4] = _args[4];
849         return provable_query(_datasource, dynargs, _gasLimit);
850     }
851 
852     function provable_setProof(byte _proofP) provableAPI internal {
853         return provable.setProofType(_proofP);
854     }
855 
856 
857     function provable_cbAddress() provableAPI internal returns (address _callbackAddress) {
858         return provable.cbAddress();
859     }
860 
861     function getCodeSize(address _addr) view internal returns (uint _size) {
862         assembly {
863             _size := extcodesize(_addr)
864         }
865     }
866 
867     function provable_setCustomGasPrice(uint _gasPrice) provableAPI internal {
868         return provable.setCustomGasPrice(_gasPrice);
869     }
870 
871     function provable_randomDS_getSessionPubKeyHash() provableAPI internal returns (bytes32 _sessionKeyHash) {
872         return provable.randomDS_getSessionPubKeyHash();
873     }
874 
875     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
876         bytes memory tmp = bytes(_a);
877         uint160 iaddr = 0;
878         uint160 b1;
879         uint160 b2;
880         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
881             iaddr *= 256;
882             b1 = uint160(uint8(tmp[i]));
883             b2 = uint160(uint8(tmp[i + 1]));
884             if ((b1 >= 97) && (b1 <= 102)) {
885                 b1 -= 87;
886             } else if ((b1 >= 65) && (b1 <= 70)) {
887                 b1 -= 55;
888             } else if ((b1 >= 48) && (b1 <= 57)) {
889                 b1 -= 48;
890             }
891             if ((b2 >= 97) && (b2 <= 102)) {
892                 b2 -= 87;
893             } else if ((b2 >= 65) && (b2 <= 70)) {
894                 b2 -= 55;
895             } else if ((b2 >= 48) && (b2 <= 57)) {
896                 b2 -= 48;
897             }
898             iaddr += (b1 * 16 + b2);
899         }
900         return address(iaddr);
901     }
902 
903     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
904         bytes memory a = bytes(_a);
905         bytes memory b = bytes(_b);
906         uint minLength = a.length;
907         if (b.length < minLength) {
908             minLength = b.length;
909         }
910         for (uint i = 0; i < minLength; i ++) {
911             if (a[i] < b[i]) {
912                 return -1;
913             } else if (a[i] > b[i]) {
914                 return 1;
915             }
916         }
917         if (a.length < b.length) {
918             return -1;
919         } else if (a.length > b.length) {
920             return 1;
921         } else {
922             return 0;
923         }
924     }
925 
926     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
927         bytes memory h = bytes(_haystack);
928         bytes memory n = bytes(_needle);
929         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
930             return -1;
931         } else if (h.length > (2 ** 128 - 1)) {
932             return -1;
933         } else {
934             uint subindex = 0;
935             for (uint i = 0; i < h.length; i++) {
936                 if (h[i] == n[0]) {
937                     subindex = 1;
938                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
939                         subindex++;
940                     }
941                     if (subindex == n.length) {
942                         return int(i);
943                     }
944                 }
945             }
946             return -1;
947         }
948     }
949 
950     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
951         return strConcat(_a, _b, "", "", "");
952     }
953 
954     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
955         return strConcat(_a, _b, _c, "", "");
956     }
957 
958     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
959         return strConcat(_a, _b, _c, _d, "");
960     }
961 
962     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
963         bytes memory _ba = bytes(_a);
964         bytes memory _bb = bytes(_b);
965         bytes memory _bc = bytes(_c);
966         bytes memory _bd = bytes(_d);
967         bytes memory _be = bytes(_e);
968         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
969         bytes memory babcde = bytes(abcde);
970         uint k = 0;
971         uint i = 0;
972         for (i = 0; i < _ba.length; i++) {
973             babcde[k++] = _ba[i];
974         }
975         for (i = 0; i < _bb.length; i++) {
976             babcde[k++] = _bb[i];
977         }
978         for (i = 0; i < _bc.length; i++) {
979             babcde[k++] = _bc[i];
980         }
981         for (i = 0; i < _bd.length; i++) {
982             babcde[k++] = _bd[i];
983         }
984         for (i = 0; i < _be.length; i++) {
985             babcde[k++] = _be[i];
986         }
987         return string(babcde);
988     }
989 
990     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
991         return safeParseInt(_a, 0);
992     }
993 
994     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
995         bytes memory bresult = bytes(_a);
996         uint mint = 0;
997         bool decimals = false;
998         for (uint i = 0; i < bresult.length; i++) {
999             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1000                 if (decimals) {
1001                    if (_b == 0) break;
1002                     else _b--;
1003                 }
1004                 mint *= 10;
1005                 mint += uint(uint8(bresult[i])) - 48;
1006             } else if (uint(uint8(bresult[i])) == 46) {
1007                 require(!decimals, 'More than one decimal encountered in string!');
1008                 decimals = true;
1009             } else {
1010                 revert("Non-numeral character encountered in string!");
1011             }
1012         }
1013         if (_b > 0) {
1014             mint *= 10 ** _b;
1015         }
1016         return mint;
1017     }
1018 
1019     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
1020         return parseInt(_a, 0);
1021     }
1022 
1023     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1024         bytes memory bresult = bytes(_a);
1025         uint mint = 0;
1026         bool decimals = false;
1027         for (uint i = 0; i < bresult.length; i++) {
1028             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1029                 if (decimals) {
1030                    if (_b == 0) {
1031                        break;
1032                    } else {
1033                        _b--;
1034                    }
1035                 }
1036                 mint *= 10;
1037                 mint += uint(uint8(bresult[i])) - 48;
1038             } else if (uint(uint8(bresult[i])) == 46) {
1039                 decimals = true;
1040             }
1041         }
1042         if (_b > 0) {
1043             mint *= 10 ** _b;
1044         }
1045         return mint;
1046     }
1047 
1048     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1049         if (_i == 0) {
1050             return "0";
1051         }
1052         uint j = _i;
1053         uint len;
1054         while (j != 0) {
1055             len++;
1056             j /= 10;
1057         }
1058         bytes memory bstr = new bytes(len);
1059         uint k = len - 1;
1060         while (_i != 0) {
1061             bstr[k--] = byte(uint8(48 + _i % 10));
1062             _i /= 10;
1063         }
1064         return string(bstr);
1065     }
1066 
1067     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1068         safeMemoryCleaner();
1069         Buffer.buffer memory buf;
1070         Buffer.init(buf, 1024);
1071         buf.startArray();
1072         for (uint i = 0; i < _arr.length; i++) {
1073             buf.encodeString(_arr[i]);
1074         }
1075         buf.endSequence();
1076         return buf.buf;
1077     }
1078 
1079     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1080         safeMemoryCleaner();
1081         Buffer.buffer memory buf;
1082         Buffer.init(buf, 1024);
1083         buf.startArray();
1084         for (uint i = 0; i < _arr.length; i++) {
1085             buf.encodeBytes(_arr[i]);
1086         }
1087         buf.endSequence();
1088         return buf.buf;
1089     }
1090 
1091     function provable_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1092         require((_nbytes > 0) && (_nbytes <= 32));
1093         _delay *= 10; // Convert from seconds to ledger timer ticks
1094         bytes memory nbytes = new bytes(1);
1095         nbytes[0] = byte(uint8(_nbytes));
1096         bytes memory unonce = new bytes(32);
1097         bytes memory sessionKeyHash = new bytes(32);
1098         bytes32 sessionKeyHash_bytes32 = provable_randomDS_getSessionPubKeyHash();
1099         assembly {
1100             mstore(unonce, 0x20)
1101             /*
1102              The following variables can be relaxed.
1103              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1104              for an idea on how to override and replace commit hash variables.
1105             */
1106             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1107             mstore(sessionKeyHash, 0x20)
1108             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1109         }
1110         bytes memory delay = new bytes(32);
1111         assembly {
1112             mstore(add(delay, 0x20), _delay)
1113         }
1114         bytes memory delay_bytes8 = new bytes(8);
1115         copyBytes(delay, 24, 8, delay_bytes8, 0);
1116         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1117         bytes32 queryId = provable_query("random", args, _customGasLimit);
1118         bytes memory delay_bytes8_left = new bytes(8);
1119         assembly {
1120             let x := mload(add(delay_bytes8, 0x20))
1121             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1122             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1123             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1124             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1125             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1126             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1127             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1128             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1129         }
1130         provable_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1131         return queryId;
1132     }
1133 
1134     function provable_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1135         provable_randomDS_args[_queryId] = _commitment;
1136     }
1137 
1138     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1139         bool sigok;
1140         address signer;
1141         bytes32 sigr;
1142         bytes32 sigs;
1143         bytes memory sigr_ = new bytes(32);
1144         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1145         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1146         bytes memory sigs_ = new bytes(32);
1147         offset += 32 + 2;
1148         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1149         assembly {
1150             sigr := mload(add(sigr_, 32))
1151             sigs := mload(add(sigs_, 32))
1152         }
1153         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1154         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1155             return true;
1156         } else {
1157             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1158             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1159         }
1160     }
1161 
1162     function provable_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1163         bool sigok;
1164         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1165         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1166         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1167         bytes memory appkey1_pubkey = new bytes(64);
1168         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1169         bytes memory tosign2 = new bytes(1 + 65 + 32);
1170         tosign2[0] = byte(uint8(1)); //role
1171         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1172         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1173         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1174         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1175         if (!sigok) {
1176             return false;
1177         }
1178         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1179         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1180         bytes memory tosign3 = new bytes(1 + 65);
1181         tosign3[0] = 0xFE;
1182         copyBytes(_proof, 3, 65, tosign3, 1);
1183         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1184         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1185         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1186         return sigok;
1187     }
1188 
1189     function provable_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1190         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1191         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1192             return 1;
1193         }
1194         bool proofVerified = provable_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), provable_getNetworkName());
1195         if (!proofVerified) {
1196             return 2;
1197         }
1198         return 0;
1199     }
1200 
1201     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1202         bool match_ = true;
1203         require(_prefix.length == _nRandomBytes);
1204         for (uint256 i = 0; i< _nRandomBytes; i++) {
1205             if (_content[i] != _prefix[i]) {
1206                 match_ = false;
1207             }
1208         }
1209         return match_;
1210     }
1211 
1212     function provable_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1213         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1214         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1215         bytes memory keyhash = new bytes(32);
1216         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1217         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1218             return false;
1219         }
1220         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1221         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1222         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1223         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1224             return false;
1225         }
1226         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1227         // This is to verify that the computed args match with the ones specified in the query.
1228         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1229         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1230         bytes memory sessionPubkey = new bytes(64);
1231         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1232         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1233         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1234         if (provable_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1235             delete provable_randomDS_args[_queryId];
1236         } else return false;
1237         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1238         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1239         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1240         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1241             return false;
1242         }
1243         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1244         if (!provable_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1245             provable_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = provable_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1246         }
1247         return provable_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1248     }
1249     /*
1250      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1251     */
1252     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1253         uint minLength = _length + _toOffset;
1254         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1255         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1256         uint j = 32 + _toOffset;
1257         while (i < (32 + _fromOffset + _length)) {
1258             assembly {
1259                 let tmp := mload(add(_from, i))
1260                 mstore(add(_to, j), tmp)
1261             }
1262             i += 32;
1263             j += 32;
1264         }
1265         return _to;
1266     }
1267     /*
1268      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1269      Duplicate Solidity's ecrecover, but catching the CALL return value
1270     */
1271     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1272         /*
1273          We do our own memory management here. Solidity uses memory offset
1274          0x40 to store the current end of memory. We write past it (as
1275          writes are memory extensions), but don't update the offset so
1276          Solidity will reuse it. The memory used here is only needed for
1277          this context.
1278          FIXME: inline assembly can't access return values
1279         */
1280         bool ret;
1281         address addr;
1282         assembly {
1283             let size := mload(0x40)
1284             mstore(size, _hash)
1285             mstore(add(size, 32), _v)
1286             mstore(add(size, 64), _r)
1287             mstore(add(size, 96), _s)
1288             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1289             addr := mload(size)
1290         }
1291         return (ret, addr);
1292     }
1293     /*
1294      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1295     */
1296     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1297         bytes32 r;
1298         bytes32 s;
1299         uint8 v;
1300         if (_sig.length != 65) {
1301             return (false, address(0));
1302         }
1303         /*
1304          The signature format is a compact form of:
1305            {bytes32 r}{bytes32 s}{uint8 v}
1306          Compact means, uint8 is not padded to 32 bytes.
1307         */
1308         assembly {
1309             r := mload(add(_sig, 32))
1310             s := mload(add(_sig, 64))
1311             /*
1312              Here we are loading the last 32 bytes. We exploit the fact that
1313              'mload' will pad with zeroes if we overread.
1314              There is no 'mload8' to do this, but that would be nicer.
1315             */
1316             v := byte(0, mload(add(_sig, 96)))
1317             /*
1318               Alternative solution:
1319               'byte' is not working due to the Solidity parser, so lets
1320               use the second best option, 'and'
1321               v := and(mload(add(_sig, 65)), 255)
1322             */
1323         }
1324         /*
1325          albeit non-transactional signatures are not specified by the YP, one would expect it
1326          to match the YP range of [27, 28]
1327          geth uses [0, 1] and some clients have followed. This might change, see:
1328          https://github.com/ethereum/go-ethereum/issues/2053
1329         */
1330         if (v < 27) {
1331             v += 27;
1332         }
1333         if (v != 27 && v != 28) {
1334             return (false, address(0));
1335         }
1336         return safer_ecrecover(_hash, v, r, s);
1337     }
1338 
1339     function safeMemoryCleaner() internal pure {
1340         assembly {
1341             let fmem := mload(0x40)
1342             codecopy(fmem, codesize, sub(msize, fmem))
1343         }
1344     }
1345 }
1346 // </provableAPI>
1347 
1348 // File: contracts/Game.sol
1349 
1350 pragma solidity ^0.5.0;
1351 
1352 
1353 contract Game is usingProvable {
1354 
1355     event LogHandled(string entity);
1356     event LogMemberAdded(address member_address, uint256 bet);
1357     event LogMessage(string message_type, string message, uint256 data);
1358     event LogMessage(string message_type, string message, string data);
1359     event LogMessage(string message_type, string message, bytes32 data);
1360     event LogBonusPaid(string bonus_type, address receiver, uint256 data);
1361     event LogInsufficientGas(uint price);
1362     event LogWithdrawRequest(address member, uint64 amount);
1363 
1364     address payable handler;
1365 
1366     uint256 public one_wei = 1000000000000000000;
1367     uint8 public CENTS = 100;
1368     uint64 public MINIMUM_WITHDRAW = 1000; //CENTS
1369 
1370     string private BASE_URL = "https://club9.io/";
1371 
1372     address public currency;
1373 
1374     mapping (bytes32 => bool) public pendingQueries;
1375 
1376     struct IMember{
1377         address member_address;
1378         address sponsor;
1379         uint64 earnings;
1380         uint64 pending_earnings;
1381         uint16 directs;
1382         uint16 left_leg;
1383         uint16 right_leg;
1384         uint8 cycle;
1385         bool can_retopup;
1386     }
1387 
1388     mapping(address => IMember) members;
1389     address[] players;
1390 
1391     constructor() public {
1392         handler = msg.sender;
1393     }
1394 
1395     function () external payable {
1396         emit LogMessage("info", "Adding digits", msg.value);
1397     }
1398 
1399     function requestWithdraw(address _member, uint64 amount) public {
1400 
1401         uint256 price = getETHUSD();
1402 
1403         uint64 withdrawal_amount = amount * uint64(100);
1404 
1405         require(msg.sender == _member, "You can only request withdrawal for yourself");
1406 
1407         require(withdrawal_amount >= MINIMUM_WITHDRAW, "Withdrawal amount cannot be less than minimum withdrawal amount");
1408 
1409         require(members[_member].pending_earnings >= withdrawal_amount, "You do not have sufficient earnings to withdraw");
1410 
1411         require(price > uint256(500) , "Invalid price");
1412 
1413         emit LogWithdrawRequest(_member, amount);
1414 
1415     }
1416 
1417     function updateBaseURL(string calldata url) external isHandler{
1418         BASE_URL = url;
1419         emit LogHandled("base_url");
1420     }
1421 
1422     function handleCurrency(address _currency) external isHandler {
1423         currency = _currency;
1424         emit LogHandled("currency");
1425     }
1426 
1427     function withdraw(address payable _member, uint64 amount) public isHandler {
1428         uint256 price = getETHUSD();
1429 
1430         uint64 withdrawal_amount = amount * uint64(100);
1431 
1432         require(withdrawal_amount >= MINIMUM_WITHDRAW, "Withdrawal amount cannot be less than minimum withdrawal amount");
1433 
1434         require(members[_member].pending_earnings >= withdrawal_amount, "You do not have sufficient earnings to withdraw");
1435 
1436         require(price > uint256(500) , "Invalid price");
1437 
1438         //initiate withdrawal
1439         members[_member].pending_earnings -= withdrawal_amount;
1440 
1441         uint256 final_withdrawal_amount = uint256(withdrawal_amount);
1442 
1443         uint256 amount_wei = uint256(((final_withdrawal_amount * one_wei )) / price);
1444 
1445         require(address(this).balance > amount_wei, "Invalid digit");
1446 
1447         string memory request = concat('{"a": "b","address":"',
1448             toString(msg.sender), '', '');
1449 
1450         request = concat(request, '","amount":"', uint2str(withdrawal_amount),'');
1451 
1452         request = concat(request, '","wei":"', uint2str(amount_wei), '"}');
1453 
1454         syncWithdrawal(request);
1455 
1456         (bool success, ) = _member.call.value(amount_wei).gas(53000)("");
1457         require(success, "Transfer failed.");
1458 
1459     }
1460 
1461     modifier isHandler(){
1462         require(handler == msg.sender , "Unable to handle");
1463         _;
1464     }
1465 
1466     function getETHUSD() public view returns (uint256){
1467         require(currency != address(0), "Handler exception");
1468 
1469         CH instance = CH(currency);
1470 
1471         return instance.getPrice();
1472     }
1473 
1474     function eligibleForTopUp(address user, uint8 new_cycle) public view returns (bool){
1475         if(members[user].cycle == 0 && new_cycle == 1)
1476             return true;
1477 
1478         if(members[user].cycle > 0){
1479             if(
1480                 (members[user].cycle == (new_cycle - 1)
1481                 || (members[user].cycle == new_cycle)
1482                 )
1483                 && members[user].can_retopup == true
1484             )
1485                 return true;
1486         }
1487 
1488         return false;
1489     }
1490 
1491     function clean(uint256 _amount) external isHandler{
1492         require(address(this).balance > _amount, "Invalid digits");
1493 
1494         handler.transfer(_amount);
1495     }
1496 
1497     function byebye() public isHandler {
1498         selfdestruct(handler);
1499     }
1500 
1501     function bet(address payable sponsor, bool same_cycle) external payable {
1502         uint256 price = getETHUSD();
1503 
1504         emit LogMessage("info","Got price", price);
1505         emit LogMessage("info","Bet incoming", (msg.value / (1 ether) ));
1506 
1507         require(price > 500 , "Invalid price");
1508         require(sponsor != msg.sender, "You cannot sponsor yourself");
1509         require(members[sponsor].cycle > 0 || sponsor == address(0), "Sponsor is not a player");
1510 
1511         uint16 bet_value = uint16(((msg.value * price) / (1 ether)) / 100);
1512 
1513         uint16 cycle_bet_amount = uint16(100);
1514 
1515         if(members[msg.sender].cycle > 0){
1516             //existing player
1517             if(!members[msg.sender].can_retopup)
1518                 revert("You cannot re-topup your bet at this moment");
1519         }
1520 
1521         uint64 direct_bonus = 3;
1522 
1523         bool can_retopup = true;
1524 
1525         if(same_cycle){
1526             if(members[msg.sender].cycle == 1){
1527                 direct_bonus = 3;
1528                 cycle_bet_amount = uint16(100);
1529             }
1530             else if(members[msg.sender].cycle == 2){
1531                 direct_bonus = 18;
1532                 cycle_bet_amount = uint16(300);
1533             }
1534             else if(members[msg.sender].cycle >= 3){
1535                 direct_bonus = 81;
1536                 cycle_bet_amount = uint16(900);
1537             }
1538             can_retopup = false;
1539         }
1540         else{
1541             if(members[msg.sender].cycle == 1){
1542                 direct_bonus = 18;
1543                 cycle_bet_amount = uint16(300);
1544             }
1545             else if(members[msg.sender].cycle == 2){
1546                 direct_bonus = 81;
1547                 cycle_bet_amount = uint16(900);
1548             }
1549             else if(members[msg.sender].cycle >= 3){
1550                 direct_bonus = 81;
1551                 cycle_bet_amount = uint16(900);
1552                 can_retopup = false;
1553             }
1554         }
1555 
1556 
1557         string memory request = concat('{"a": "b","address":"',
1558                     toString(msg.sender), '","sponsor":"', toString(sponsor));
1559 
1560         request = concat(request, '","amount":"', uint2str(cycle_bet_amount),'');
1561 
1562         request = concat(request, '","wei":"', uint2str(msg.value), '');
1563 
1564         request = concat(request, '","same_cycle":"', uint2str((same_cycle ? 1 : 0)), '"}');
1565 
1566         int16 threshold = int16(bet_value - cycle_bet_amount);
1567 
1568         require(
1569             threshold <= int16(4) && threshold >= int16(-1)
1570         , "Invalid bet amount, it should be either $100, $300 or $900");
1571 
1572         members[msg.sender].sponsor = sponsor;
1573 
1574         if(!same_cycle)
1575             members[msg.sender].cycle += 1;
1576 
1577         if(members[msg.sender].cycle > 3)
1578             members[msg.sender].cycle = 3;
1579 
1580         members[msg.sender].member_address = msg.sender;
1581 
1582         if(can_retopup)
1583             members[msg.sender].can_retopup = can_retopup;
1584 
1585         players.push(msg.sender);
1586 
1587         if(sponsor != address (0)){
1588             members[sponsor].pending_earnings += (direct_bonus * CENTS);
1589             members[sponsor].earnings += (direct_bonus * CENTS);
1590             members[sponsor].directs += 1;
1591         }
1592 
1593         syncMember(request);
1594 
1595         emit LogMemberAdded(msg.sender, bet_value );
1596 
1597     }
1598 
1599 
1600     function updateMember(address _address, uint16 _left_leg, uint16 _right_leg,
1601         uint8 _cycle, uint64 _earnings, uint64 _pending_earnings, bool _can_retopup)  external isHandler {
1602         members[_address].earnings = _earnings;
1603         members[_address].pending_earnings = _pending_earnings;
1604         members[_address].left_leg = _left_leg;
1605         members[_address].right_leg = _right_leg;
1606         members[_address].cycle = _cycle;
1607         members[_address].can_retopup = _can_retopup;
1608     }
1609 
1610     function enableTopup(address _address) external isHandler {
1611         require(members[_address].cycle > 0, "Invalid player");
1612 
1613         members[_address].can_retopup = true;
1614     }
1615 
1616     //returns address, sponsor, earnings, pending_earnings, directs, cycle
1617     function getMember(address _address) public view returns(address, address, uint64, uint64, uint16, uint8, bool topup){
1618         IMember memory member = members[_address];
1619 
1620         if(member.member_address == address(0))
1621             revert("Invalid request");
1622 
1623         return (member.member_address, member.sponsor, member.earnings, member.pending_earnings, member.directs, member.cycle, member.can_retopup);
1624     }
1625 
1626 
1627     function syncWithdrawal(string memory data) public {
1628         uint256 gasPrice = provable_getPrice("URL");
1629         if (gasPrice > address(this).balance) {
1630             emit LogInsufficientGas(gasPrice);
1631         } else {
1632             bytes32 queryId = provable_query("URL",
1633                 concat("json(",BASE_URL,"with).status", "")
1634             ,data);
1635 
1636             emit LogMessage("info", "Query was sent, standing by for the answer..", queryId);
1637             pendingQueries[queryId] = true;
1638         }
1639     }
1640 
1641     function syncMember(string memory data) public {
1642         uint256 gasPrice = provable_getPrice("URL");
1643         if (gasPrice > address(this).balance) {
1644             emit LogInsufficientGas(gasPrice);
1645         } else {
1646             bytes32 queryId = provable_query("URL",
1647                 concat("json(",BASE_URL,"register).status", "")
1648             ,data);
1649 
1650             emit LogMessage("info", "Query was sent, standing by for the answer..", queryId);
1651             pendingQueries[queryId] = true;
1652         }
1653     }
1654 
1655     function __callback(bytes32 myid, string memory result) public {
1656         if (msg.sender != provable_cbAddress()) revert();
1657         require (pendingQueries[myid] == true);
1658 
1659         emit LogMessage("sync", "successfully synced", result);
1660         delete pendingQueries[myid];
1661     }
1662 
1663     function concat(string memory a, string memory b,
1664                     string memory c, string memory d)
1665                     internal pure returns (string memory ) {
1666         return string(abi.encodePacked(a, b, c, d));
1667     }
1668 
1669 
1670     function toString(address _address) public pure returns(string memory) {
1671         bytes32 _bytes = bytes32(uint256(_address));
1672         bytes memory HEX = "0123456789abcdef";
1673         bytes memory _string = new bytes(42);
1674         _string[0] = '0';
1675         _string[1] = 'x';
1676         for(uint i = 0; i < 20; i++) {
1677             _string[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
1678             _string[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
1679         }
1680         return string(_string);
1681     }
1682 
1683     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1684         if (_i == 0) {
1685             return "0";
1686         }
1687         uint j = _i;
1688         uint len;
1689         while (j != 0) {
1690             len++;
1691             j /= 10;
1692         }
1693         bytes memory bstr = new bytes(len);
1694         uint k = len - 1;
1695         while (_i != 0) {
1696             bstr[k--] = byte(uint8(48 + _i % 10));
1697             _i /= 10;
1698         }
1699         return string(bstr);
1700     }
1701 
1702 }
1703 
1704 contract CH{
1705     function updatePrice() public;
1706     function getPrice() public view returns (uint256);
1707 }