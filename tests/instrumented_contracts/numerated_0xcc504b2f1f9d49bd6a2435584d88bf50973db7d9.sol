1 pragma solidity 0.5.0;
2 
3 /*
4 
5 ORACLIZE_API
6 
7 Copyright (c) 2015-2016 Oraclize SRL
8 Copyright (c) 2016 Oraclize LTD
9 
10 Permission is hereby granted, free of charge, to any person obtaining a copy
11 of this software and associated documentation files (the "Software"), to deal
12 in the Software without restriction, including without limitation the rights
13 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
14 copies of the Software, and to permit persons to whom the Software is
15 furnished to do so, subject to the following conditions:
16 
17 The above copyright notice and this permission notice shall be included in
18 all copies or substantial portions of the Software.
19 
20 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
21 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
22 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
23 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
24 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
25 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
26 THE SOFTWARE.
27 
28 */
29 
30 // Dummy contract only used to emit to end-user they are using wrong solc
31 contract solcChecker {
32 /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;
33 }
34 
35 contract OraclizeI {
36 
37     address public cbAddress;
38 
39     function setProofType(byte _proofType) external;
40     function setCustomGasPrice(uint _gasPrice) external;
41     function getPrice(string memory _datasource) public returns (uint _dsprice);
42     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
43     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
44     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
45     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
46     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
47     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
48     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
49     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
50 }
51 
52 contract OraclizeAddrResolverI {
53     function getAddress() public returns (address _address);
54 }
55 /*
56 
57 Begin solidity-cborutils
58 
59 https://github.com/smartcontractkit/solidity-cborutils
60 
61 MIT License
62 
63 Copyright (c) 2018 SmartContract ChainLink, Ltd.
64 
65 Permission is hereby granted, free of charge, to any person obtaining a copy
66 of this software and associated documentation files (the "Software"), to deal
67 in the Software without restriction, including without limitation the rights
68 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
69 copies of the Software, and to permit persons to whom the Software is
70 furnished to do so, subject to the following conditions:
71 
72 The above copyright notice and this permission notice shall be included in all
73 copies or substantial portions of the Software.
74 
75 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
76 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
77 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
78 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
79 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
80 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
81 SOFTWARE.
82 
83 */
84 library Buffer {
85 
86     struct buffer {
87         bytes buf;
88         uint capacity;
89     }
90 
91     function init(buffer memory _buf, uint _capacity) internal pure {
92         uint capacity = _capacity;
93         if (capacity % 32 != 0) {
94             capacity += 32 - (capacity % 32);
95         }
96         _buf.capacity = capacity; // Allocate space for the buffer data
97         assembly {
98             let ptr := mload(0x40)
99             mstore(_buf, ptr)
100             mstore(ptr, 0)
101             mstore(0x40, add(ptr, capacity))
102         }
103     }
104 
105     function resize(buffer memory _buf, uint _capacity) private pure {
106         bytes memory oldbuf = _buf.buf;
107         init(_buf, _capacity);
108         append(_buf, oldbuf);
109     }
110 
111     function max(uint _a, uint _b) private pure returns (uint _max) {
112         if (_a > _b) {
113             return _a;
114         }
115         return _b;
116     }
117     /**
118       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
119       *      would exceed the capacity of the buffer.
120       * @param _buf The buffer to append to.
121       * @param _data The data to append.
122       * @return The original buffer.
123       *
124       */
125     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
126         if (_data.length + _buf.buf.length > _buf.capacity) {
127             resize(_buf, max(_buf.capacity, _data.length) * 2);
128         }
129         uint dest;
130         uint src;
131         uint len = _data.length;
132         assembly {
133             let bufptr := mload(_buf) // Memory address of the buffer data
134             let buflen := mload(bufptr) // Length of existing buffer data
135             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
136             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
137             src := add(_data, 32)
138         }
139         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
140             assembly {
141                 mstore(dest, mload(src))
142             }
143             dest += 32;
144             src += 32;
145         }
146         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
147         assembly {
148             let srcpart := and(mload(src), not(mask))
149             let destpart := and(mload(dest), mask)
150             mstore(dest, or(destpart, srcpart))
151         }
152         return _buf;
153     }
154     /**
155       *
156       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
157       * exceed the capacity of the buffer.
158       * @param _buf The buffer to append to.
159       * @param _data The data to append.
160       * @return The original buffer.
161       *
162       */
163     function append(buffer memory _buf, uint8 _data) internal pure {
164         if (_buf.buf.length + 1 > _buf.capacity) {
165             resize(_buf, _buf.capacity * 2);
166         }
167         assembly {
168             let bufptr := mload(_buf) // Memory address of the buffer data
169             let buflen := mload(bufptr) // Length of existing buffer data
170             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
171             mstore8(dest, _data)
172             mstore(bufptr, add(buflen, 1)) // Update buffer length
173         }
174     }
175     /**
176       *
177       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
178       * exceed the capacity of the buffer.
179       * @param _buf The buffer to append to.
180       * @param _data The data to append.
181       * @return The original buffer.
182       *
183       */
184     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
185         if (_len + _buf.buf.length > _buf.capacity) {
186             resize(_buf, max(_buf.capacity, _len) * 2);
187         }
188         uint mask = 256 ** _len - 1;
189         assembly {
190             let bufptr := mload(_buf) // Memory address of the buffer data
191             let buflen := mload(bufptr) // Length of existing buffer data
192             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
193             mstore(dest, or(and(mload(dest), not(mask)), _data))
194             mstore(bufptr, add(buflen, _len)) // Update buffer length
195         }
196         return _buf;
197     }
198 }
199 
200 library CBOR {
201 
202     using Buffer for Buffer.buffer;
203 
204     uint8 private constant MAJOR_TYPE_INT = 0;
205     uint8 private constant MAJOR_TYPE_MAP = 5;
206     uint8 private constant MAJOR_TYPE_BYTES = 2;
207     uint8 private constant MAJOR_TYPE_ARRAY = 4;
208     uint8 private constant MAJOR_TYPE_STRING = 3;
209     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
210     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
211 
212     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
213         if (_value <= 23) {
214             _buf.append(uint8((_major << 5) | _value));
215         } else if (_value <= 0xFF) {
216             _buf.append(uint8((_major << 5) | 24));
217             _buf.appendInt(_value, 1);
218         } else if (_value <= 0xFFFF) {
219             _buf.append(uint8((_major << 5) | 25));
220             _buf.appendInt(_value, 2);
221         } else if (_value <= 0xFFFFFFFF) {
222             _buf.append(uint8((_major << 5) | 26));
223             _buf.appendInt(_value, 4);
224         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
225             _buf.append(uint8((_major << 5) | 27));
226             _buf.appendInt(_value, 8);
227         }
228     }
229 
230     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
231         _buf.append(uint8((_major << 5) | 31));
232     }
233 
234     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
235         encodeType(_buf, MAJOR_TYPE_INT, _value);
236     }
237 
238     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
239         if (_value >= 0) {
240             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
241         } else {
242             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
243         }
244     }
245 
246     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
247         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
248         _buf.append(_value);
249     }
250 
251     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
252         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
253         _buf.append(bytes(_value));
254     }
255 
256     function startArray(Buffer.buffer memory _buf) internal pure {
257         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
258     }
259 
260     function startMap(Buffer.buffer memory _buf) internal pure {
261         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
262     }
263 
264     function endSequence(Buffer.buffer memory _buf) internal pure {
265         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
266     }
267 }
268 /*
269 
270 End solidity-cborutils
271 
272 */
273 contract usingOraclize {
274 
275     using CBOR for Buffer.buffer;
276 
277     OraclizeI oraclize;
278     OraclizeAddrResolverI OAR;
279 
280     uint constant day = 60 * 60 * 24;
281     uint constant week = 60 * 60 * 24 * 7;
282     uint constant month = 60 * 60 * 24 * 30;
283 
284     byte constant proofType_NONE = 0x00;
285     byte constant proofType_Ledger = 0x30;
286     byte constant proofType_Native = 0xF0;
287     byte constant proofStorage_IPFS = 0x01;
288     byte constant proofType_Android = 0x40;
289     byte constant proofType_TLSNotary = 0x10;
290 
291     string oraclize_network_name;
292     uint8 constant networkID_auto = 0;
293     uint8 constant networkID_morden = 2;
294     uint8 constant networkID_mainnet = 1;
295     uint8 constant networkID_testnet = 2;
296     uint8 constant networkID_consensys = 161;
297 
298     mapping(bytes32 => bytes32) oraclize_randomDS_args;
299     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
300 
301     modifier oraclizeAPI {
302         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
303             oraclize_setNetwork(networkID_auto);
304         }
305         if (address(oraclize) != OAR.getAddress()) {
306             oraclize = OraclizeI(OAR.getAddress());
307         }
308         _;
309     }
310 
311     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
312         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
313         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
314         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
315         require(proofVerified);
316         _;
317     }
318 
319     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
320       return oraclize_setNetwork();
321       _networkID; // silence the warning and remain backwards compatible
322     }
323 
324     function oraclize_setNetworkName(string memory _network_name) internal {
325         oraclize_network_name = _network_name;
326     }
327 
328     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
329         return oraclize_network_name;
330     }
331 
332     function oraclize_setNetwork() internal returns (bool _networkSet) {
333         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
334             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
335             oraclize_setNetworkName("eth_mainnet");
336             return true;
337         }
338         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
339             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
340             oraclize_setNetworkName("eth_ropsten3");
341             return true;
342         }
343         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
344             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
345             oraclize_setNetworkName("eth_kovan");
346             return true;
347         }
348         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
349             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
350             oraclize_setNetworkName("eth_rinkeby");
351             return true;
352         }
353         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
354             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
355             return true;
356         }
357         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
358             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
359             return true;
360         }
361         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
362             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
363             return true;
364         }
365         return false;
366     }
367 
368     function __callback(bytes32 _myid, string memory _result) public {
369         __callback(_myid, _result, new bytes(0));
370     }
371 
372     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
373       return;
374       _myid; _result; _proof; // Silence compiler warnings
375     }
376 
377     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
378         return oraclize.getPrice(_datasource);
379     }
380 
381     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
382         return oraclize.getPrice(_datasource, _gasLimit);
383     }
384 
385     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
386         uint price = oraclize.getPrice(_datasource);
387         if (price > 1 ether + tx.gasprice * 200000) {
388             return 0; // Unexpectedly high price
389         }
390         return oraclize.query.value(price)(0, _datasource, _arg);
391     }
392 
393     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
394         uint price = oraclize.getPrice(_datasource);
395         if (price > 1 ether + tx.gasprice * 200000) {
396             return 0; // Unexpectedly high price
397         }
398         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
399     }
400 
401     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
402         uint price = oraclize.getPrice(_datasource,_gasLimit);
403         if (price > 1 ether + tx.gasprice * _gasLimit) {
404             return 0; // Unexpectedly high price
405         }
406         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
407     }
408 
409     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
410         uint price = oraclize.getPrice(_datasource, _gasLimit);
411         if (price > 1 ether + tx.gasprice * _gasLimit) {
412            return 0; // Unexpectedly high price
413         }
414         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
415     }
416 
417     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
418         uint price = oraclize.getPrice(_datasource);
419         if (price > 1 ether + tx.gasprice * 200000) {
420             return 0; // Unexpectedly high price
421         }
422         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
423     }
424 
425     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
426         uint price = oraclize.getPrice(_datasource);
427         if (price > 1 ether + tx.gasprice * 200000) {
428             return 0; // Unexpectedly high price
429         }
430         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
431     }
432 
433     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
434         uint price = oraclize.getPrice(_datasource, _gasLimit);
435         if (price > 1 ether + tx.gasprice * _gasLimit) {
436             return 0; // Unexpectedly high price
437         }
438         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
439     }
440 
441     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
442         uint price = oraclize.getPrice(_datasource, _gasLimit);
443         if (price > 1 ether + tx.gasprice * _gasLimit) {
444             return 0; // Unexpectedly high price
445         }
446         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
447     }
448 
449     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
450         uint price = oraclize.getPrice(_datasource);
451         if (price > 1 ether + tx.gasprice * 200000) {
452             return 0; // Unexpectedly high price
453         }
454         bytes memory args = stra2cbor(_argN);
455         return oraclize.queryN.value(price)(0, _datasource, args);
456     }
457 
458     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
459         uint price = oraclize.getPrice(_datasource);
460         if (price > 1 ether + tx.gasprice * 200000) {
461             return 0; // Unexpectedly high price
462         }
463         bytes memory args = stra2cbor(_argN);
464         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
465     }
466 
467     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
468         uint price = oraclize.getPrice(_datasource, _gasLimit);
469         if (price > 1 ether + tx.gasprice * _gasLimit) {
470             return 0; // Unexpectedly high price
471         }
472         bytes memory args = stra2cbor(_argN);
473         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
474     }
475 
476     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
477         uint price = oraclize.getPrice(_datasource, _gasLimit);
478         if (price > 1 ether + tx.gasprice * _gasLimit) {
479             return 0; // Unexpectedly high price
480         }
481         bytes memory args = stra2cbor(_argN);
482         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
483     }
484 
485     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
486         string[] memory dynargs = new string[](1);
487         dynargs[0] = _args[0];
488         return oraclize_query(_datasource, dynargs);
489     }
490 
491     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
492         string[] memory dynargs = new string[](1);
493         dynargs[0] = _args[0];
494         return oraclize_query(_timestamp, _datasource, dynargs);
495     }
496 
497     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
498         string[] memory dynargs = new string[](1);
499         dynargs[0] = _args[0];
500         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
501     }
502 
503     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
504         string[] memory dynargs = new string[](1);
505         dynargs[0] = _args[0];
506         return oraclize_query(_datasource, dynargs, _gasLimit);
507     }
508 
509     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
510         string[] memory dynargs = new string[](2);
511         dynargs[0] = _args[0];
512         dynargs[1] = _args[1];
513         return oraclize_query(_datasource, dynargs);
514     }
515 
516     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
517         string[] memory dynargs = new string[](2);
518         dynargs[0] = _args[0];
519         dynargs[1] = _args[1];
520         return oraclize_query(_timestamp, _datasource, dynargs);
521     }
522 
523     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
524         string[] memory dynargs = new string[](2);
525         dynargs[0] = _args[0];
526         dynargs[1] = _args[1];
527         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
528     }
529 
530     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
531         string[] memory dynargs = new string[](2);
532         dynargs[0] = _args[0];
533         dynargs[1] = _args[1];
534         return oraclize_query(_datasource, dynargs, _gasLimit);
535     }
536 
537     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
538         string[] memory dynargs = new string[](3);
539         dynargs[0] = _args[0];
540         dynargs[1] = _args[1];
541         dynargs[2] = _args[2];
542         return oraclize_query(_datasource, dynargs);
543     }
544 
545     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
546         string[] memory dynargs = new string[](3);
547         dynargs[0] = _args[0];
548         dynargs[1] = _args[1];
549         dynargs[2] = _args[2];
550         return oraclize_query(_timestamp, _datasource, dynargs);
551     }
552 
553     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
554         string[] memory dynargs = new string[](3);
555         dynargs[0] = _args[0];
556         dynargs[1] = _args[1];
557         dynargs[2] = _args[2];
558         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
559     }
560 
561     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
562         string[] memory dynargs = new string[](3);
563         dynargs[0] = _args[0];
564         dynargs[1] = _args[1];
565         dynargs[2] = _args[2];
566         return oraclize_query(_datasource, dynargs, _gasLimit);
567     }
568 
569     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
570         string[] memory dynargs = new string[](4);
571         dynargs[0] = _args[0];
572         dynargs[1] = _args[1];
573         dynargs[2] = _args[2];
574         dynargs[3] = _args[3];
575         return oraclize_query(_datasource, dynargs);
576     }
577 
578     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
579         string[] memory dynargs = new string[](4);
580         dynargs[0] = _args[0];
581         dynargs[1] = _args[1];
582         dynargs[2] = _args[2];
583         dynargs[3] = _args[3];
584         return oraclize_query(_timestamp, _datasource, dynargs);
585     }
586 
587     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
588         string[] memory dynargs = new string[](4);
589         dynargs[0] = _args[0];
590         dynargs[1] = _args[1];
591         dynargs[2] = _args[2];
592         dynargs[3] = _args[3];
593         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
594     }
595 
596     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
597         string[] memory dynargs = new string[](4);
598         dynargs[0] = _args[0];
599         dynargs[1] = _args[1];
600         dynargs[2] = _args[2];
601         dynargs[3] = _args[3];
602         return oraclize_query(_datasource, dynargs, _gasLimit);
603     }
604 
605     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
606         string[] memory dynargs = new string[](5);
607         dynargs[0] = _args[0];
608         dynargs[1] = _args[1];
609         dynargs[2] = _args[2];
610         dynargs[3] = _args[3];
611         dynargs[4] = _args[4];
612         return oraclize_query(_datasource, dynargs);
613     }
614 
615     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
616         string[] memory dynargs = new string[](5);
617         dynargs[0] = _args[0];
618         dynargs[1] = _args[1];
619         dynargs[2] = _args[2];
620         dynargs[3] = _args[3];
621         dynargs[4] = _args[4];
622         return oraclize_query(_timestamp, _datasource, dynargs);
623     }
624 
625     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
626         string[] memory dynargs = new string[](5);
627         dynargs[0] = _args[0];
628         dynargs[1] = _args[1];
629         dynargs[2] = _args[2];
630         dynargs[3] = _args[3];
631         dynargs[4] = _args[4];
632         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
633     }
634 
635     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
636         string[] memory dynargs = new string[](5);
637         dynargs[0] = _args[0];
638         dynargs[1] = _args[1];
639         dynargs[2] = _args[2];
640         dynargs[3] = _args[3];
641         dynargs[4] = _args[4];
642         return oraclize_query(_datasource, dynargs, _gasLimit);
643     }
644 
645     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
646         uint price = oraclize.getPrice(_datasource);
647         if (price > 1 ether + tx.gasprice * 200000) {
648             return 0; // Unexpectedly high price
649         }
650         bytes memory args = ba2cbor(_argN);
651         return oraclize.queryN.value(price)(0, _datasource, args);
652     }
653 
654     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
655         uint price = oraclize.getPrice(_datasource);
656         if (price > 1 ether + tx.gasprice * 200000) {
657             return 0; // Unexpectedly high price
658         }
659         bytes memory args = ba2cbor(_argN);
660         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
661     }
662 
663     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
664         uint price = oraclize.getPrice(_datasource, _gasLimit);
665         if (price > 1 ether + tx.gasprice * _gasLimit) {
666             return 0; // Unexpectedly high price
667         }
668         bytes memory args = ba2cbor(_argN);
669         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
670     }
671 
672     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
673         uint price = oraclize.getPrice(_datasource, _gasLimit);
674         if (price > 1 ether + tx.gasprice * _gasLimit) {
675             return 0; // Unexpectedly high price
676         }
677         bytes memory args = ba2cbor(_argN);
678         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
679     }
680 
681     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
682         bytes[] memory dynargs = new bytes[](1);
683         dynargs[0] = _args[0];
684         return oraclize_query(_datasource, dynargs);
685     }
686 
687     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
688         bytes[] memory dynargs = new bytes[](1);
689         dynargs[0] = _args[0];
690         return oraclize_query(_timestamp, _datasource, dynargs);
691     }
692 
693     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
694         bytes[] memory dynargs = new bytes[](1);
695         dynargs[0] = _args[0];
696         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
697     }
698 
699     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
700         bytes[] memory dynargs = new bytes[](1);
701         dynargs[0] = _args[0];
702         return oraclize_query(_datasource, dynargs, _gasLimit);
703     }
704 
705     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
706         bytes[] memory dynargs = new bytes[](2);
707         dynargs[0] = _args[0];
708         dynargs[1] = _args[1];
709         return oraclize_query(_datasource, dynargs);
710     }
711 
712     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
713         bytes[] memory dynargs = new bytes[](2);
714         dynargs[0] = _args[0];
715         dynargs[1] = _args[1];
716         return oraclize_query(_timestamp, _datasource, dynargs);
717     }
718 
719     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
720         bytes[] memory dynargs = new bytes[](2);
721         dynargs[0] = _args[0];
722         dynargs[1] = _args[1];
723         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
724     }
725 
726     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
727         bytes[] memory dynargs = new bytes[](2);
728         dynargs[0] = _args[0];
729         dynargs[1] = _args[1];
730         return oraclize_query(_datasource, dynargs, _gasLimit);
731     }
732 
733     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
734         bytes[] memory dynargs = new bytes[](3);
735         dynargs[0] = _args[0];
736         dynargs[1] = _args[1];
737         dynargs[2] = _args[2];
738         return oraclize_query(_datasource, dynargs);
739     }
740 
741     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
742         bytes[] memory dynargs = new bytes[](3);
743         dynargs[0] = _args[0];
744         dynargs[1] = _args[1];
745         dynargs[2] = _args[2];
746         return oraclize_query(_timestamp, _datasource, dynargs);
747     }
748 
749     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
750         bytes[] memory dynargs = new bytes[](3);
751         dynargs[0] = _args[0];
752         dynargs[1] = _args[1];
753         dynargs[2] = _args[2];
754         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
755     }
756 
757     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
758         bytes[] memory dynargs = new bytes[](3);
759         dynargs[0] = _args[0];
760         dynargs[1] = _args[1];
761         dynargs[2] = _args[2];
762         return oraclize_query(_datasource, dynargs, _gasLimit);
763     }
764 
765     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
766         bytes[] memory dynargs = new bytes[](4);
767         dynargs[0] = _args[0];
768         dynargs[1] = _args[1];
769         dynargs[2] = _args[2];
770         dynargs[3] = _args[3];
771         return oraclize_query(_datasource, dynargs);
772     }
773 
774     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
775         bytes[] memory dynargs = new bytes[](4);
776         dynargs[0] = _args[0];
777         dynargs[1] = _args[1];
778         dynargs[2] = _args[2];
779         dynargs[3] = _args[3];
780         return oraclize_query(_timestamp, _datasource, dynargs);
781     }
782 
783     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
784         bytes[] memory dynargs = new bytes[](4);
785         dynargs[0] = _args[0];
786         dynargs[1] = _args[1];
787         dynargs[2] = _args[2];
788         dynargs[3] = _args[3];
789         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
790     }
791 
792     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
793         bytes[] memory dynargs = new bytes[](4);
794         dynargs[0] = _args[0];
795         dynargs[1] = _args[1];
796         dynargs[2] = _args[2];
797         dynargs[3] = _args[3];
798         return oraclize_query(_datasource, dynargs, _gasLimit);
799     }
800 
801     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
802         bytes[] memory dynargs = new bytes[](5);
803         dynargs[0] = _args[0];
804         dynargs[1] = _args[1];
805         dynargs[2] = _args[2];
806         dynargs[3] = _args[3];
807         dynargs[4] = _args[4];
808         return oraclize_query(_datasource, dynargs);
809     }
810 
811     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
812         bytes[] memory dynargs = new bytes[](5);
813         dynargs[0] = _args[0];
814         dynargs[1] = _args[1];
815         dynargs[2] = _args[2];
816         dynargs[3] = _args[3];
817         dynargs[4] = _args[4];
818         return oraclize_query(_timestamp, _datasource, dynargs);
819     }
820 
821     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
822         bytes[] memory dynargs = new bytes[](5);
823         dynargs[0] = _args[0];
824         dynargs[1] = _args[1];
825         dynargs[2] = _args[2];
826         dynargs[3] = _args[3];
827         dynargs[4] = _args[4];
828         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
829     }
830 
831     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
832         bytes[] memory dynargs = new bytes[](5);
833         dynargs[0] = _args[0];
834         dynargs[1] = _args[1];
835         dynargs[2] = _args[2];
836         dynargs[3] = _args[3];
837         dynargs[4] = _args[4];
838         return oraclize_query(_datasource, dynargs, _gasLimit);
839     }
840 
841     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
842         return oraclize.setProofType(_proofP);
843     }
844 
845 
846     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
847         return oraclize.cbAddress();
848     }
849 
850     function getCodeSize(address _addr) view internal returns (uint _size) {
851         assembly {
852             _size := extcodesize(_addr)
853         }
854     }
855 
856     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
857         return oraclize.setCustomGasPrice(_gasPrice);
858     }
859 
860     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
861         return oraclize.randomDS_getSessionPubKeyHash();
862     }
863 
864     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
865         bytes memory tmp = bytes(_a);
866         uint160 iaddr = 0;
867         uint160 b1;
868         uint160 b2;
869         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
870             iaddr *= 256;
871             b1 = uint160(uint8(tmp[i]));
872             b2 = uint160(uint8(tmp[i + 1]));
873             if ((b1 >= 97) && (b1 <= 102)) {
874                 b1 -= 87;
875             } else if ((b1 >= 65) && (b1 <= 70)) {
876                 b1 -= 55;
877             } else if ((b1 >= 48) && (b1 <= 57)) {
878                 b1 -= 48;
879             }
880             if ((b2 >= 97) && (b2 <= 102)) {
881                 b2 -= 87;
882             } else if ((b2 >= 65) && (b2 <= 70)) {
883                 b2 -= 55;
884             } else if ((b2 >= 48) && (b2 <= 57)) {
885                 b2 -= 48;
886             }
887             iaddr += (b1 * 16 + b2);
888         }
889         return address(iaddr);
890     }
891 
892     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
893         bytes memory a = bytes(_a);
894         bytes memory b = bytes(_b);
895         uint minLength = a.length;
896         if (b.length < minLength) {
897             minLength = b.length;
898         }
899         for (uint i = 0; i < minLength; i ++) {
900             if (a[i] < b[i]) {
901                 return -1;
902             } else if (a[i] > b[i]) {
903                 return 1;
904             }
905         }
906         if (a.length < b.length) {
907             return -1;
908         } else if (a.length > b.length) {
909             return 1;
910         } else {
911             return 0;
912         }
913     }
914 
915     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
916         bytes memory h = bytes(_haystack);
917         bytes memory n = bytes(_needle);
918         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
919             return -1;
920         } else if (h.length > (2 ** 128 - 1)) {
921             return -1;
922         } else {
923             uint subindex = 0;
924             for (uint i = 0; i < h.length; i++) {
925                 if (h[i] == n[0]) {
926                     subindex = 1;
927                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
928                         subindex++;
929                     }
930                     if (subindex == n.length) {
931                         return int(i);
932                     }
933                 }
934             }
935             return -1;
936         }
937     }
938 
939     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
940         return strConcat(_a, _b, "", "", "");
941     }
942 
943     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
944         return strConcat(_a, _b, _c, "", "");
945     }
946 
947     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
948         return strConcat(_a, _b, _c, _d, "");
949     }
950 
951     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
952         bytes memory _ba = bytes(_a);
953         bytes memory _bb = bytes(_b);
954         bytes memory _bc = bytes(_c);
955         bytes memory _bd = bytes(_d);
956         bytes memory _be = bytes(_e);
957         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
958         bytes memory babcde = bytes(abcde);
959         uint k = 0;
960         uint i = 0;
961         for (i = 0; i < _ba.length; i++) {
962             babcde[k++] = _ba[i];
963         }
964         for (i = 0; i < _bb.length; i++) {
965             babcde[k++] = _bb[i];
966         }
967         for (i = 0; i < _bc.length; i++) {
968             babcde[k++] = _bc[i];
969         }
970         for (i = 0; i < _bd.length; i++) {
971             babcde[k++] = _bd[i];
972         }
973         for (i = 0; i < _be.length; i++) {
974             babcde[k++] = _be[i];
975         }
976         return string(babcde);
977     }
978 
979     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
980         return safeParseInt(_a, 0);
981     }
982 
983     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
984         bytes memory bresult = bytes(_a);
985         uint mint = 0;
986         bool decimals = false;
987         for (uint i = 0; i < bresult.length; i++) {
988             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
989                 if (decimals) {
990                    if (_b == 0) break;
991                     else _b--;
992                 }
993                 mint *= 10;
994                 mint += uint(uint8(bresult[i])) - 48;
995             } else if (uint(uint8(bresult[i])) == 46) {
996                 require(!decimals, 'More than one decimal encountered in string!');
997                 decimals = true;
998             } else {
999                 revert("Non-numeral character encountered in string!");
1000             }
1001         }
1002         if (_b > 0) {
1003             mint *= 10 ** _b;
1004         }
1005         return mint;
1006     }
1007 
1008     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
1009         return parseInt(_a, 0);
1010     }
1011 
1012     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1013         bytes memory bresult = bytes(_a);
1014         uint mint = 0;
1015         bool decimals = false;
1016         for (uint i = 0; i < bresult.length; i++) {
1017             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1018                 if (decimals) {
1019                    if (_b == 0) {
1020                        break;
1021                    } else {
1022                        _b--;
1023                    }
1024                 }
1025                 mint *= 10;
1026                 mint += uint(uint8(bresult[i])) - 48;
1027             } else if (uint(uint8(bresult[i])) == 46) {
1028                 decimals = true;
1029             }
1030         }
1031         if (_b > 0) {
1032             mint *= 10 ** _b;
1033         }
1034         return mint;
1035     }
1036 
1037     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1038         if (_i == 0) {
1039             return "0";
1040         }
1041         uint j = _i;
1042         uint len;
1043         while (j != 0) {
1044             len++;
1045             j /= 10;
1046         }
1047         bytes memory bstr = new bytes(len);
1048         uint k = len - 1;
1049         while (_i != 0) {
1050             bstr[k--] = byte(uint8(48 + _i % 10));
1051             _i /= 10;
1052         }
1053         return string(bstr);
1054     }
1055 
1056     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1057         safeMemoryCleaner();
1058         Buffer.buffer memory buf;
1059         Buffer.init(buf, 1024);
1060         buf.startArray();
1061         for (uint i = 0; i < _arr.length; i++) {
1062             buf.encodeString(_arr[i]);
1063         }
1064         buf.endSequence();
1065         return buf.buf;
1066     }
1067 
1068     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1069         safeMemoryCleaner();
1070         Buffer.buffer memory buf;
1071         Buffer.init(buf, 1024);
1072         buf.startArray();
1073         for (uint i = 0; i < _arr.length; i++) {
1074             buf.encodeBytes(_arr[i]);
1075         }
1076         buf.endSequence();
1077         return buf.buf;
1078     }
1079 
1080     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1081         require((_nbytes > 0) && (_nbytes <= 32));
1082         _delay *= 10; // Convert from seconds to ledger timer ticks
1083         bytes memory nbytes = new bytes(1);
1084         nbytes[0] = byte(uint8(_nbytes));
1085         bytes memory unonce = new bytes(32);
1086         bytes memory sessionKeyHash = new bytes(32);
1087         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1088         assembly {
1089             mstore(unonce, 0x20)
1090             /*
1091              The following variables can be relaxed.
1092              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1093              for an idea on how to override and replace commit hash variables.
1094             */
1095             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1096             mstore(sessionKeyHash, 0x20)
1097             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1098         }
1099         bytes memory delay = new bytes(32);
1100         assembly {
1101             mstore(add(delay, 0x20), _delay)
1102         }
1103         bytes memory delay_bytes8 = new bytes(8);
1104         copyBytes(delay, 24, 8, delay_bytes8, 0);
1105         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1106         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1107         bytes memory delay_bytes8_left = new bytes(8);
1108         assembly {
1109             let x := mload(add(delay_bytes8, 0x20))
1110             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1111             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1112             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1113             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1114             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1115             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1116             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1117             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1118         }
1119         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1120         return queryId;
1121     }
1122 
1123     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1124         oraclize_randomDS_args[_queryId] = _commitment;
1125     }
1126 
1127     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1128         bool sigok;
1129         address signer;
1130         bytes32 sigr;
1131         bytes32 sigs;
1132         bytes memory sigr_ = new bytes(32);
1133         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1134         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1135         bytes memory sigs_ = new bytes(32);
1136         offset += 32 + 2;
1137         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1138         assembly {
1139             sigr := mload(add(sigr_, 32))
1140             sigs := mload(add(sigs_, 32))
1141         }
1142         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1143         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1144             return true;
1145         } else {
1146             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1147             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1148         }
1149     }
1150 
1151     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1152         bool sigok;
1153         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1154         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1155         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1156         bytes memory appkey1_pubkey = new bytes(64);
1157         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1158         bytes memory tosign2 = new bytes(1 + 65 + 32);
1159         tosign2[0] = byte(uint8(1)); //role
1160         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1161         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1162         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1163         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1164         if (!sigok) {
1165             return false;
1166         }
1167         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1168         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1169         bytes memory tosign3 = new bytes(1 + 65);
1170         tosign3[0] = 0xFE;
1171         copyBytes(_proof, 3, 65, tosign3, 1);
1172         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1173         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1174         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1175         return sigok;
1176     }
1177 
1178     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1179         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1180         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1181             return 1;
1182         }
1183         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1184         if (!proofVerified) {
1185             return 2;
1186         }
1187         return 0;
1188     }
1189 
1190     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1191         bool match_ = true;
1192         require(_prefix.length == _nRandomBytes);
1193         for (uint256 i = 0; i< _nRandomBytes; i++) {
1194             if (_content[i] != _prefix[i]) {
1195                 match_ = false;
1196             }
1197         }
1198         return match_;
1199     }
1200 
1201     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1202         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1203         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1204         bytes memory keyhash = new bytes(32);
1205         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1206         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1207             return false;
1208         }
1209         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1210         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1211         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1212         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1213             return false;
1214         }
1215         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1216         // This is to verify that the computed args match with the ones specified in the query.
1217         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1218         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1219         bytes memory sessionPubkey = new bytes(64);
1220         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1221         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1222         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1223         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1224             delete oraclize_randomDS_args[_queryId];
1225         } else return false;
1226         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1227         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1228         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1229         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1230             return false;
1231         }
1232         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1233         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1234             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1235         }
1236         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1237     }
1238     /*
1239      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1240     */
1241     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1242         uint minLength = _length + _toOffset;
1243         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1244         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1245         uint j = 32 + _toOffset;
1246         while (i < (32 + _fromOffset + _length)) {
1247             assembly {
1248                 let tmp := mload(add(_from, i))
1249                 mstore(add(_to, j), tmp)
1250             }
1251             i += 32;
1252             j += 32;
1253         }
1254         return _to;
1255     }
1256     /*
1257      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1258      Duplicate Solidity's ecrecover, but catching the CALL return value
1259     */
1260     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1261         /*
1262          We do our own memory management here. Solidity uses memory offset
1263          0x40 to store the current end of memory. We write past it (as
1264          writes are memory extensions), but don't update the offset so
1265          Solidity will reuse it. The memory used here is only needed for
1266          this context.
1267          FIXME: inline assembly can't access return values
1268         */
1269         bool ret;
1270         address addr;
1271         assembly {
1272             let size := mload(0x40)
1273             mstore(size, _hash)
1274             mstore(add(size, 32), _v)
1275             mstore(add(size, 64), _r)
1276             mstore(add(size, 96), _s)
1277             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1278             addr := mload(size)
1279         }
1280         return (ret, addr);
1281     }
1282     /*
1283      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1284     */
1285     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1286         bytes32 r;
1287         bytes32 s;
1288         uint8 v;
1289         if (_sig.length != 65) {
1290             return (false, address(0));
1291         }
1292         /*
1293          The signature format is a compact form of:
1294            {bytes32 r}{bytes32 s}{uint8 v}
1295          Compact means, uint8 is not padded to 32 bytes.
1296         */
1297         assembly {
1298             r := mload(add(_sig, 32))
1299             s := mload(add(_sig, 64))
1300             /*
1301              Here we are loading the last 32 bytes. We exploit the fact that
1302              'mload' will pad with zeroes if we overread.
1303              There is no 'mload8' to do this, but that would be nicer.
1304             */
1305             v := byte(0, mload(add(_sig, 96)))
1306             /*
1307               Alternative solution:
1308               'byte' is not working due to the Solidity parser, so lets
1309               use the second best option, 'and'
1310               v := and(mload(add(_sig, 65)), 255)
1311             */
1312         }
1313         /*
1314          albeit non-transactional signatures are not specified by the YP, one would expect it
1315          to match the YP range of [27, 28]
1316          geth uses [0, 1] and some clients have followed. This might change, see:
1317          https://github.com/ethereum/go-ethereum/issues/2053
1318         */
1319         if (v < 27) {
1320             v += 27;
1321         }
1322         if (v != 27 && v != 28) {
1323             return (false, address(0));
1324         }
1325         return safer_ecrecover(_hash, v, r, s);
1326     }
1327 
1328     function safeMemoryCleaner() internal pure {
1329         assembly {
1330             let fmem := mload(0x40)
1331             codecopy(fmem, codesize, sub(msize, fmem))
1332         }
1333     }
1334 }
1335 /*
1336 
1337 END ORACLIZE_API
1338 
1339 */
1340 
1341 contract ERC20Interface {
1342 
1343   function allowance(address tokenOwner, address spender) public view returns(uint remaining);
1344 
1345   function transfer(address to, uint tokens) public returns(bool success);
1346 
1347   function transferFrom(address from, address to, uint tokens) public returns(bool success);
1348 
1349 }
1350 
1351 contract raffleContract is usingOraclize {
1352 
1353   event LogConstructorInitiated(string nextStep);
1354   event LogResult(uint result, address winner, uint amount);
1355   event LogNewOraclizeQuery(string description);
1356   event LogID(bytes32 description);
1357   event LogNewEntry(address player, uint number, uint raffleV);
1358   event Owner(address newOwner);
1359 
1360   address public owner;
1361 
1362   modifier onlyOwner() {
1363     require(msg.sender == owner);
1364     _;
1365   }
1366 
1367   struct raffle {
1368     uint start;
1369     uint end;
1370     uint price;
1371     uint players;
1372     address winner;
1373     mapping(uint => address) player;
1374     mapping(address => bool) already;
1375   }
1376 
1377   uint public defaultTime = 1 days;
1378   uint public defaultPrice = 1 ether;
1379 
1380   uint public raffleToSolve;
1381   uint public currentRaffleVersion;
1382   mapping(uint => raffle) public raffleVersion;
1383 
1384   ERC20Interface btcnnTok;
1385 
1386   constructor(address _btcnnTokAddress) public payable {
1387 
1388     owner = msg.sender;
1389     emit Owner(owner);
1390     
1391     raffleVersion[0].price = defaultPrice;
1392 
1393     btcnnTok = ERC20Interface(_btcnnTokAddress);
1394 
1395   }
1396 
1397   function __callback(bytes32 myid, string memory result, bytes memory proof) public {
1398 
1399     require(currentRaffleVersion > raffleToSolve);
1400     if (msg.sender != oraclize_cbAddress()) revert();
1401     uint maxRange = raffleVersion[raffleToSolve].players;
1402     uint randomNumber = (uint(keccak256(abi.encodePacked(result))) % maxRange) + 1; // this is an efficient way to get the uint out in the [1, maxRange] range
1403     uint amount = raffleVersion[raffleToSolve].players * raffleVersion[raffleToSolve].price;
1404     address winner = raffleVersion[raffleToSolve].player[randomNumber];
1405 
1406     raffleVersion[raffleToSolve].winner = winner;
1407 
1408     btcnnTok.transfer(winner, amount);
1409 
1410     emit LogResult(randomNumber, winner, amount);
1411 
1412     raffleToSolve++;
1413 
1414   }
1415 
1416   function raffleExecute() public payable {
1417 
1418     if (now > raffleVersion[currentRaffleVersion].end) { //Current Version ended
1419 
1420       if (raffleVersion[currentRaffleVersion].players > 0) {
1421 
1422         if (oraclize_getPrice("Random") > address(this).balance) {
1423           emit LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1424         } else {
1425           currentRaffleVersion++; //Next Raffle Verison
1426 
1427           raffleVersion[currentRaffleVersion].start = now;
1428           raffleVersion[currentRaffleVersion].end = now + defaultTime;
1429           raffleVersion[currentRaffleVersion].price = defaultPrice;
1430           btcnnTok.transferFrom(msg.sender, address(this), raffleVersion[currentRaffleVersion].price);
1431           raffleVersion[currentRaffleVersion].already[msg.sender] = true;
1432           raffleVersion[currentRaffleVersion].players++;
1433           raffleVersion[currentRaffleVersion].player[raffleVersion[currentRaffleVersion].players] = msg.sender;
1434 
1435           oraclize_setProof(proofType_Ledger); // sets the Ledger authenticity proof
1436           uint N = 4; // number of random bytes we want the datasource to return
1437           uint delay = 0; // number of seconds to wait before the execution takes place
1438           uint callbackGas = 200000; // amount of gas we want Oraclize to set for the callback function
1439           bytes32 queryId = oraclize_newRandomDSQuery(delay, N, callbackGas);
1440           emit LogID(queryId);
1441         }
1442 
1443       } else {
1444 
1445 
1446         raffleVersion[currentRaffleVersion].start = now;
1447         raffleVersion[currentRaffleVersion].end = now + defaultTime;
1448         raffleVersion[currentRaffleVersion].price = defaultPrice;
1449         btcnnTok.transferFrom(msg.sender, address(this), raffleVersion[currentRaffleVersion].price);
1450 
1451         raffleVersion[currentRaffleVersion].already[msg.sender] = true;
1452         raffleVersion[currentRaffleVersion].players++;
1453         raffleVersion[currentRaffleVersion].player[raffleVersion[currentRaffleVersion].players] = msg.sender;
1454 
1455         emit LogNewEntry(msg.sender, raffleVersion[currentRaffleVersion].players, currentRaffleVersion);
1456 
1457       }
1458 
1459 
1460 
1461     } else {
1462 
1463       require(raffleVersion[currentRaffleVersion].already[msg.sender] == false);
1464       btcnnTok.transferFrom(msg.sender, address(this), raffleVersion[currentRaffleVersion].price);
1465 
1466       raffleVersion[currentRaffleVersion].already[msg.sender] = true;
1467       raffleVersion[currentRaffleVersion].players++;
1468       raffleVersion[currentRaffleVersion].player[raffleVersion[currentRaffleVersion].players] = msg.sender;
1469 
1470       emit LogNewEntry(msg.sender, raffleVersion[currentRaffleVersion].players, currentRaffleVersion);
1471 
1472     }
1473 
1474   }
1475 
1476   function solveRaffle() public payable {
1477 
1478     require(currentRaffleVersion > raffleToSolve);
1479 
1480     oraclize_setProof(proofType_Ledger); // sets the Ledger authenticity proof
1481     uint N = 4; // number of random bytes we want the datasource to return
1482     uint delay = 0; // number of seconds to wait before the execution takes place
1483     uint callbackGas = 200000; // amount of gas we want Oraclize to set for the callback function
1484     bytes32 queryId = oraclize_newRandomDSQuery(delay, N, callbackGas);
1485     emit LogID(queryId);
1486 
1487   }
1488 
1489   function updateDefaults(uint time, uint amount) public onlyOwner {
1490 
1491     defaultTime = time;
1492     defaultPrice = amount;
1493 
1494   }
1495 
1496   function changeOwner(address newOwner) public onlyOwner {
1497     owner = newOwner;
1498     emit Owner(owner);
1499   }
1500 
1501   function tokenFallback(address _from, uint _amountOfTokens, bytes memory _data) public returns(bool) {
1502     return true;
1503   }
1504 
1505   function() external payable onlyOwner {
1506       
1507   }
1508 
1509 }