1 pragma solidity ^0.5.4;
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
29 pragma solidity >= 0.5.0; // Incompatible compiler version - please select a compiler within the stated pragma range, or use a different version of the oraclizeAPI!
30 
31 // Dummy contract only used to emit to end-user they are using wrong solc
32 contract solcChecker {
33 /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;
34 }
35 
36 contract OraclizeI {
37 
38     address public cbAddress;
39 
40     function setProofType(byte _proofType) external;
41     function setCustomGasPrice(uint _gasPrice) external;
42     function getPrice(string memory _datasource) public returns (uint _dsprice);
43     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
44     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
45     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
46     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
47     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
48     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
49     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
50     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
51 }
52 
53 contract OraclizeAddrResolverI {
54     function getAddress() public returns (address _address);
55 }
56 /*
57 
58 Begin solidity-cborutils
59 
60 https://github.com/smartcontractkit/solidity-cborutils
61 
62 MIT License
63 
64 Copyright (c) 2018 SmartContract ChainLink, Ltd.
65 
66 Permission is hereby granted, free of charge, to any person obtaining a copy
67 of this software and associated documentation files (the "Software"), to deal
68 in the Software without restriction, including without limitation the rights
69 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
70 copies of the Software, and to permit persons to whom the Software is
71 furnished to do so, subject to the following conditions:
72 
73 The above copyright notice and this permission notice shall be included in all
74 copies or substantial portions of the Software.
75 
76 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
77 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
78 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
79 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
80 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
81 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
82 SOFTWARE.
83 
84 */
85 library Buffer {
86 
87     struct buffer {
88         bytes buf;
89         uint capacity;
90     }
91 
92     function init(buffer memory _buf, uint _capacity) internal pure {
93         uint capacity = _capacity;
94         if (capacity % 32 != 0) {
95             capacity += 32 - (capacity % 32);
96         }
97         _buf.capacity = capacity; // Allocate space for the buffer data
98         assembly {
99             let ptr := mload(0x40)
100             mstore(_buf, ptr)
101             mstore(ptr, 0)
102             mstore(0x40, add(ptr, capacity))
103         }
104     }
105 
106     function resize(buffer memory _buf, uint _capacity) private pure {
107         bytes memory oldbuf = _buf.buf;
108         init(_buf, _capacity);
109         append(_buf, oldbuf);
110     }
111 
112     function max(uint _a, uint _b) private pure returns (uint _max) {
113         if (_a > _b) {
114             return _a;
115         }
116         return _b;
117     }
118     /**
119       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
120       *      would exceed the capacity of the buffer.
121       * @param _buf The buffer to append to.
122       * @param _data The data to append.
123       * @return The original buffer.
124       *
125       */
126     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
127         if (_data.length + _buf.buf.length > _buf.capacity) {
128             resize(_buf, max(_buf.capacity, _data.length) * 2);
129         }
130         uint dest;
131         uint src;
132         uint len = _data.length;
133         assembly {
134             let bufptr := mload(_buf) // Memory address of the buffer data
135             let buflen := mload(bufptr) // Length of existing buffer data
136             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
137             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
138             src := add(_data, 32)
139         }
140         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
141             assembly {
142                 mstore(dest, mload(src))
143             }
144             dest += 32;
145             src += 32;
146         }
147         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
148         assembly {
149             let srcpart := and(mload(src), not(mask))
150             let destpart := and(mload(dest), mask)
151             mstore(dest, or(destpart, srcpart))
152         }
153         return _buf;
154     }
155     /**
156       *
157       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
158       * exceed the capacity of the buffer.
159       * @param _buf The buffer to append to.
160       * @param _data The data to append.
161       * @return The original buffer.
162       *
163       */
164     function append(buffer memory _buf, uint8 _data) internal pure {
165         if (_buf.buf.length + 1 > _buf.capacity) {
166             resize(_buf, _buf.capacity * 2);
167         }
168         assembly {
169             let bufptr := mload(_buf) // Memory address of the buffer data
170             let buflen := mload(bufptr) // Length of existing buffer data
171             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
172             mstore8(dest, _data)
173             mstore(bufptr, add(buflen, 1)) // Update buffer length
174         }
175     }
176     /**
177       *
178       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
179       * exceed the capacity of the buffer.
180       * @param _buf The buffer to append to.
181       * @param _data The data to append.
182       * @return The original buffer.
183       *
184       */
185     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
186         if (_len + _buf.buf.length > _buf.capacity) {
187             resize(_buf, max(_buf.capacity, _len) * 2);
188         }
189         uint mask = 256 ** _len - 1;
190         assembly {
191             let bufptr := mload(_buf) // Memory address of the buffer data
192             let buflen := mload(bufptr) // Length of existing buffer data
193             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
194             mstore(dest, or(and(mload(dest), not(mask)), _data))
195             mstore(bufptr, add(buflen, _len)) // Update buffer length
196         }
197         return _buf;
198     }
199 }
200 
201 library CBOR {
202 
203     using Buffer for Buffer.buffer;
204 
205     uint8 private constant MAJOR_TYPE_INT = 0;
206     uint8 private constant MAJOR_TYPE_MAP = 5;
207     uint8 private constant MAJOR_TYPE_BYTES = 2;
208     uint8 private constant MAJOR_TYPE_ARRAY = 4;
209     uint8 private constant MAJOR_TYPE_STRING = 3;
210     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
211     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
212 
213     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
214         if (_value <= 23) {
215             _buf.append(uint8((_major << 5) | _value));
216         } else if (_value <= 0xFF) {
217             _buf.append(uint8((_major << 5) | 24));
218             _buf.appendInt(_value, 1);
219         } else if (_value <= 0xFFFF) {
220             _buf.append(uint8((_major << 5) | 25));
221             _buf.appendInt(_value, 2);
222         } else if (_value <= 0xFFFFFFFF) {
223             _buf.append(uint8((_major << 5) | 26));
224             _buf.appendInt(_value, 4);
225         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
226             _buf.append(uint8((_major << 5) | 27));
227             _buf.appendInt(_value, 8);
228         }
229     }
230 
231     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
232         _buf.append(uint8((_major << 5) | 31));
233     }
234 
235     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
236         encodeType(_buf, MAJOR_TYPE_INT, _value);
237     }
238 
239     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
240         if (_value >= 0) {
241             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
242         } else {
243             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
244         }
245     }
246 
247     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
248         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
249         _buf.append(_value);
250     }
251 
252     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
253         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
254         _buf.append(bytes(_value));
255     }
256 
257     function startArray(Buffer.buffer memory _buf) internal pure {
258         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
259     }
260 
261     function startMap(Buffer.buffer memory _buf) internal pure {
262         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
263     }
264 
265     function endSequence(Buffer.buffer memory _buf) internal pure {
266         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
267     }
268 }
269 /*
270 
271 End solidity-cborutils
272 
273 */
274 contract usingOraclize {
275 
276     using CBOR for Buffer.buffer;
277 
278     OraclizeI oraclize;
279     OraclizeAddrResolverI OAR;
280 
281     uint constant day = 60 * 60 * 24;
282     uint constant week = 60 * 60 * 24 * 7;
283     uint constant month = 60 * 60 * 24 * 30;
284 
285     byte constant proofType_NONE = 0x00;
286     byte constant proofType_Ledger = 0x30;
287     byte constant proofType_Native = 0xF0;
288     byte constant proofStorage_IPFS = 0x01;
289     byte constant proofType_Android = 0x40;
290     byte constant proofType_TLSNotary = 0x10;
291 
292     string oraclize_network_name;
293     uint8 constant networkID_auto = 0;
294     uint8 constant networkID_morden = 2;
295     uint8 constant networkID_mainnet = 1;
296     uint8 constant networkID_testnet = 2;
297     uint8 constant networkID_consensys = 161;
298 
299     mapping(bytes32 => bytes32) oraclize_randomDS_args;
300     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
301 
302     modifier oraclizeAPI {
303         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
304             oraclize_setNetwork(networkID_auto);
305         }
306         if (address(oraclize) != OAR.getAddress()) {
307             oraclize = OraclizeI(OAR.getAddress());
308         }
309         _;
310     }
311 
312     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
313         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
314         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
315         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
316         require(proofVerified);
317         _;
318     }
319 
320     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
321       return oraclize_setNetwork();
322       _networkID; // silence the warning and remain backwards compatible
323     }
324 
325     function oraclize_setNetworkName(string memory _network_name) internal {
326         oraclize_network_name = _network_name;
327     }
328 
329     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
330         return oraclize_network_name;
331     }
332 
333     function oraclize_setNetwork() internal returns (bool _networkSet) {
334         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
335             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
336             oraclize_setNetworkName("eth_mainnet");
337             return true;
338         }
339         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
340             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
341             oraclize_setNetworkName("eth_ropsten3");
342             return true;
343         }
344         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
345             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
346             oraclize_setNetworkName("eth_kovan");
347             return true;
348         }
349         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
350             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
351             oraclize_setNetworkName("eth_rinkeby");
352             return true;
353         }
354         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
355             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
356             return true;
357         }
358         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
359             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
360             return true;
361         }
362         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
363             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
364             return true;
365         }
366         return false;
367     }
368 
369     function __callback(bytes32 _myid, string memory _result) public {
370         __callback(_myid, _result, new bytes(0));
371     }
372 
373     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
374       return;
375       _myid; _result; _proof; // Silence compiler warnings
376     }
377 
378     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
379         return oraclize.getPrice(_datasource);
380     }
381 
382     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
383         return oraclize.getPrice(_datasource, _gasLimit);
384     }
385 
386     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
387         uint price = oraclize.getPrice(_datasource);
388         if (price > 1 ether + tx.gasprice * 200000) {
389             return 0; // Unexpectedly high price
390         }
391         return oraclize.query.value(price)(0, _datasource, _arg);
392     }
393 
394     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
395         uint price = oraclize.getPrice(_datasource);
396         if (price > 1 ether + tx.gasprice * 200000) {
397             return 0; // Unexpectedly high price
398         }
399         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
400     }
401 
402     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
403         uint price = oraclize.getPrice(_datasource,_gasLimit);
404         if (price > 1 ether + tx.gasprice * _gasLimit) {
405             return 0; // Unexpectedly high price
406         }
407         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
408     }
409 
410     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
411         uint price = oraclize.getPrice(_datasource, _gasLimit);
412         if (price > 1 ether + tx.gasprice * _gasLimit) {
413            return 0; // Unexpectedly high price
414         }
415         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
416     }
417 
418     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
419         uint price = oraclize.getPrice(_datasource);
420         if (price > 1 ether + tx.gasprice * 200000) {
421             return 0; // Unexpectedly high price
422         }
423         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
424     }
425 
426     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
427         uint price = oraclize.getPrice(_datasource);
428         if (price > 1 ether + tx.gasprice * 200000) {
429             return 0; // Unexpectedly high price
430         }
431         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
432     }
433 
434     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
435         uint price = oraclize.getPrice(_datasource, _gasLimit);
436         if (price > 1 ether + tx.gasprice * _gasLimit) {
437             return 0; // Unexpectedly high price
438         }
439         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
440     }
441 
442     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
443         uint price = oraclize.getPrice(_datasource, _gasLimit);
444         if (price > 1 ether + tx.gasprice * _gasLimit) {
445             return 0; // Unexpectedly high price
446         }
447         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
448     }
449 
450     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
451         uint price = oraclize.getPrice(_datasource);
452         if (price > 1 ether + tx.gasprice * 200000) {
453             return 0; // Unexpectedly high price
454         }
455         bytes memory args = stra2cbor(_argN);
456         return oraclize.queryN.value(price)(0, _datasource, args);
457     }
458 
459     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
460         uint price = oraclize.getPrice(_datasource);
461         if (price > 1 ether + tx.gasprice * 200000) {
462             return 0; // Unexpectedly high price
463         }
464         bytes memory args = stra2cbor(_argN);
465         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
466     }
467 
468     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
469         uint price = oraclize.getPrice(_datasource, _gasLimit);
470         if (price > 1 ether + tx.gasprice * _gasLimit) {
471             return 0; // Unexpectedly high price
472         }
473         bytes memory args = stra2cbor(_argN);
474         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
475     }
476 
477     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
478         uint price = oraclize.getPrice(_datasource, _gasLimit);
479         if (price > 1 ether + tx.gasprice * _gasLimit) {
480             return 0; // Unexpectedly high price
481         }
482         bytes memory args = stra2cbor(_argN);
483         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
484     }
485 
486     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
487         string[] memory dynargs = new string[](1);
488         dynargs[0] = _args[0];
489         return oraclize_query(_datasource, dynargs);
490     }
491 
492     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
493         string[] memory dynargs = new string[](1);
494         dynargs[0] = _args[0];
495         return oraclize_query(_timestamp, _datasource, dynargs);
496     }
497 
498     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
499         string[] memory dynargs = new string[](1);
500         dynargs[0] = _args[0];
501         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
502     }
503 
504     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
505         string[] memory dynargs = new string[](1);
506         dynargs[0] = _args[0];
507         return oraclize_query(_datasource, dynargs, _gasLimit);
508     }
509 
510     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
511         string[] memory dynargs = new string[](2);
512         dynargs[0] = _args[0];
513         dynargs[1] = _args[1];
514         return oraclize_query(_datasource, dynargs);
515     }
516 
517     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
518         string[] memory dynargs = new string[](2);
519         dynargs[0] = _args[0];
520         dynargs[1] = _args[1];
521         return oraclize_query(_timestamp, _datasource, dynargs);
522     }
523 
524     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
525         string[] memory dynargs = new string[](2);
526         dynargs[0] = _args[0];
527         dynargs[1] = _args[1];
528         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
529     }
530 
531     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
532         string[] memory dynargs = new string[](2);
533         dynargs[0] = _args[0];
534         dynargs[1] = _args[1];
535         return oraclize_query(_datasource, dynargs, _gasLimit);
536     }
537 
538     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
539         string[] memory dynargs = new string[](3);
540         dynargs[0] = _args[0];
541         dynargs[1] = _args[1];
542         dynargs[2] = _args[2];
543         return oraclize_query(_datasource, dynargs);
544     }
545 
546     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
547         string[] memory dynargs = new string[](3);
548         dynargs[0] = _args[0];
549         dynargs[1] = _args[1];
550         dynargs[2] = _args[2];
551         return oraclize_query(_timestamp, _datasource, dynargs);
552     }
553 
554     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
555         string[] memory dynargs = new string[](3);
556         dynargs[0] = _args[0];
557         dynargs[1] = _args[1];
558         dynargs[2] = _args[2];
559         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
560     }
561 
562     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
563         string[] memory dynargs = new string[](3);
564         dynargs[0] = _args[0];
565         dynargs[1] = _args[1];
566         dynargs[2] = _args[2];
567         return oraclize_query(_datasource, dynargs, _gasLimit);
568     }
569 
570     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
571         string[] memory dynargs = new string[](4);
572         dynargs[0] = _args[0];
573         dynargs[1] = _args[1];
574         dynargs[2] = _args[2];
575         dynargs[3] = _args[3];
576         return oraclize_query(_datasource, dynargs);
577     }
578 
579     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
580         string[] memory dynargs = new string[](4);
581         dynargs[0] = _args[0];
582         dynargs[1] = _args[1];
583         dynargs[2] = _args[2];
584         dynargs[3] = _args[3];
585         return oraclize_query(_timestamp, _datasource, dynargs);
586     }
587 
588     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
589         string[] memory dynargs = new string[](4);
590         dynargs[0] = _args[0];
591         dynargs[1] = _args[1];
592         dynargs[2] = _args[2];
593         dynargs[3] = _args[3];
594         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
595     }
596 
597     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
598         string[] memory dynargs = new string[](4);
599         dynargs[0] = _args[0];
600         dynargs[1] = _args[1];
601         dynargs[2] = _args[2];
602         dynargs[3] = _args[3];
603         return oraclize_query(_datasource, dynargs, _gasLimit);
604     }
605 
606     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
607         string[] memory dynargs = new string[](5);
608         dynargs[0] = _args[0];
609         dynargs[1] = _args[1];
610         dynargs[2] = _args[2];
611         dynargs[3] = _args[3];
612         dynargs[4] = _args[4];
613         return oraclize_query(_datasource, dynargs);
614     }
615 
616     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
617         string[] memory dynargs = new string[](5);
618         dynargs[0] = _args[0];
619         dynargs[1] = _args[1];
620         dynargs[2] = _args[2];
621         dynargs[3] = _args[3];
622         dynargs[4] = _args[4];
623         return oraclize_query(_timestamp, _datasource, dynargs);
624     }
625 
626     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
627         string[] memory dynargs = new string[](5);
628         dynargs[0] = _args[0];
629         dynargs[1] = _args[1];
630         dynargs[2] = _args[2];
631         dynargs[3] = _args[3];
632         dynargs[4] = _args[4];
633         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
634     }
635 
636     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
637         string[] memory dynargs = new string[](5);
638         dynargs[0] = _args[0];
639         dynargs[1] = _args[1];
640         dynargs[2] = _args[2];
641         dynargs[3] = _args[3];
642         dynargs[4] = _args[4];
643         return oraclize_query(_datasource, dynargs, _gasLimit);
644     }
645 
646     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
647         uint price = oraclize.getPrice(_datasource);
648         if (price > 1 ether + tx.gasprice * 200000) {
649             return 0; // Unexpectedly high price
650         }
651         bytes memory args = ba2cbor(_argN);
652         return oraclize.queryN.value(price)(0, _datasource, args);
653     }
654 
655     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
656         uint price = oraclize.getPrice(_datasource);
657         if (price > 1 ether + tx.gasprice * 200000) {
658             return 0; // Unexpectedly high price
659         }
660         bytes memory args = ba2cbor(_argN);
661         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
662     }
663 
664     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
665         uint price = oraclize.getPrice(_datasource, _gasLimit);
666         if (price > 1 ether + tx.gasprice * _gasLimit) {
667             return 0; // Unexpectedly high price
668         }
669         bytes memory args = ba2cbor(_argN);
670         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
671     }
672 
673     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
674         uint price = oraclize.getPrice(_datasource, _gasLimit);
675         if (price > 1 ether + tx.gasprice * _gasLimit) {
676             return 0; // Unexpectedly high price
677         }
678         bytes memory args = ba2cbor(_argN);
679         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
680     }
681 
682     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
683         bytes[] memory dynargs = new bytes[](1);
684         dynargs[0] = _args[0];
685         return oraclize_query(_datasource, dynargs);
686     }
687 
688     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
689         bytes[] memory dynargs = new bytes[](1);
690         dynargs[0] = _args[0];
691         return oraclize_query(_timestamp, _datasource, dynargs);
692     }
693 
694     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
695         bytes[] memory dynargs = new bytes[](1);
696         dynargs[0] = _args[0];
697         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
698     }
699 
700     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
701         bytes[] memory dynargs = new bytes[](1);
702         dynargs[0] = _args[0];
703         return oraclize_query(_datasource, dynargs, _gasLimit);
704     }
705 
706     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
707         bytes[] memory dynargs = new bytes[](2);
708         dynargs[0] = _args[0];
709         dynargs[1] = _args[1];
710         return oraclize_query(_datasource, dynargs);
711     }
712 
713     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
714         bytes[] memory dynargs = new bytes[](2);
715         dynargs[0] = _args[0];
716         dynargs[1] = _args[1];
717         return oraclize_query(_timestamp, _datasource, dynargs);
718     }
719 
720     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
721         bytes[] memory dynargs = new bytes[](2);
722         dynargs[0] = _args[0];
723         dynargs[1] = _args[1];
724         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
725     }
726 
727     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
728         bytes[] memory dynargs = new bytes[](2);
729         dynargs[0] = _args[0];
730         dynargs[1] = _args[1];
731         return oraclize_query(_datasource, dynargs, _gasLimit);
732     }
733 
734     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
735         bytes[] memory dynargs = new bytes[](3);
736         dynargs[0] = _args[0];
737         dynargs[1] = _args[1];
738         dynargs[2] = _args[2];
739         return oraclize_query(_datasource, dynargs);
740     }
741 
742     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
743         bytes[] memory dynargs = new bytes[](3);
744         dynargs[0] = _args[0];
745         dynargs[1] = _args[1];
746         dynargs[2] = _args[2];
747         return oraclize_query(_timestamp, _datasource, dynargs);
748     }
749 
750     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
751         bytes[] memory dynargs = new bytes[](3);
752         dynargs[0] = _args[0];
753         dynargs[1] = _args[1];
754         dynargs[2] = _args[2];
755         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
756     }
757 
758     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
759         bytes[] memory dynargs = new bytes[](3);
760         dynargs[0] = _args[0];
761         dynargs[1] = _args[1];
762         dynargs[2] = _args[2];
763         return oraclize_query(_datasource, dynargs, _gasLimit);
764     }
765 
766     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
767         bytes[] memory dynargs = new bytes[](4);
768         dynargs[0] = _args[0];
769         dynargs[1] = _args[1];
770         dynargs[2] = _args[2];
771         dynargs[3] = _args[3];
772         return oraclize_query(_datasource, dynargs);
773     }
774 
775     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
776         bytes[] memory dynargs = new bytes[](4);
777         dynargs[0] = _args[0];
778         dynargs[1] = _args[1];
779         dynargs[2] = _args[2];
780         dynargs[3] = _args[3];
781         return oraclize_query(_timestamp, _datasource, dynargs);
782     }
783 
784     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
785         bytes[] memory dynargs = new bytes[](4);
786         dynargs[0] = _args[0];
787         dynargs[1] = _args[1];
788         dynargs[2] = _args[2];
789         dynargs[3] = _args[3];
790         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
791     }
792 
793     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
794         bytes[] memory dynargs = new bytes[](4);
795         dynargs[0] = _args[0];
796         dynargs[1] = _args[1];
797         dynargs[2] = _args[2];
798         dynargs[3] = _args[3];
799         return oraclize_query(_datasource, dynargs, _gasLimit);
800     }
801 
802     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
803         bytes[] memory dynargs = new bytes[](5);
804         dynargs[0] = _args[0];
805         dynargs[1] = _args[1];
806         dynargs[2] = _args[2];
807         dynargs[3] = _args[3];
808         dynargs[4] = _args[4];
809         return oraclize_query(_datasource, dynargs);
810     }
811 
812     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
813         bytes[] memory dynargs = new bytes[](5);
814         dynargs[0] = _args[0];
815         dynargs[1] = _args[1];
816         dynargs[2] = _args[2];
817         dynargs[3] = _args[3];
818         dynargs[4] = _args[4];
819         return oraclize_query(_timestamp, _datasource, dynargs);
820     }
821 
822     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
823         bytes[] memory dynargs = new bytes[](5);
824         dynargs[0] = _args[0];
825         dynargs[1] = _args[1];
826         dynargs[2] = _args[2];
827         dynargs[3] = _args[3];
828         dynargs[4] = _args[4];
829         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
830     }
831 
832     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
833         bytes[] memory dynargs = new bytes[](5);
834         dynargs[0] = _args[0];
835         dynargs[1] = _args[1];
836         dynargs[2] = _args[2];
837         dynargs[3] = _args[3];
838         dynargs[4] = _args[4];
839         return oraclize_query(_datasource, dynargs, _gasLimit);
840     }
841 
842     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
843         return oraclize.setProofType(_proofP);
844     }
845 
846 
847     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
848         return oraclize.cbAddress();
849     }
850 
851     function getCodeSize(address _addr) view internal returns (uint _size) {
852         assembly {
853             _size := extcodesize(_addr)
854         }
855     }
856 
857     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
858         return oraclize.setCustomGasPrice(_gasPrice);
859     }
860 
861     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
862         return oraclize.randomDS_getSessionPubKeyHash();
863     }
864 
865     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
866         bytes memory tmp = bytes(_a);
867         uint160 iaddr = 0;
868         uint160 b1;
869         uint160 b2;
870         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
871             iaddr *= 256;
872             b1 = uint160(uint8(tmp[i]));
873             b2 = uint160(uint8(tmp[i + 1]));
874             if ((b1 >= 97) && (b1 <= 102)) {
875                 b1 -= 87;
876             } else if ((b1 >= 65) && (b1 <= 70)) {
877                 b1 -= 55;
878             } else if ((b1 >= 48) && (b1 <= 57)) {
879                 b1 -= 48;
880             }
881             if ((b2 >= 97) && (b2 <= 102)) {
882                 b2 -= 87;
883             } else if ((b2 >= 65) && (b2 <= 70)) {
884                 b2 -= 55;
885             } else if ((b2 >= 48) && (b2 <= 57)) {
886                 b2 -= 48;
887             }
888             iaddr += (b1 * 16 + b2);
889         }
890         return address(iaddr);
891     }
892 
893     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
894         bytes memory a = bytes(_a);
895         bytes memory b = bytes(_b);
896         uint minLength = a.length;
897         if (b.length < minLength) {
898             minLength = b.length;
899         }
900         for (uint i = 0; i < minLength; i ++) {
901             if (a[i] < b[i]) {
902                 return -1;
903             } else if (a[i] > b[i]) {
904                 return 1;
905             }
906         }
907         if (a.length < b.length) {
908             return -1;
909         } else if (a.length > b.length) {
910             return 1;
911         } else {
912             return 0;
913         }
914     }
915 
916     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
917         bytes memory h = bytes(_haystack);
918         bytes memory n = bytes(_needle);
919         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
920             return -1;
921         } else if (h.length > (2 ** 128 - 1)) {
922             return -1;
923         } else {
924             uint subindex = 0;
925             for (uint i = 0; i < h.length; i++) {
926                 if (h[i] == n[0]) {
927                     subindex = 1;
928                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
929                         subindex++;
930                     }
931                     if (subindex == n.length) {
932                         return int(i);
933                     }
934                 }
935             }
936             return -1;
937         }
938     }
939 
940     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
941         return strConcat(_a, _b, "", "", "");
942     }
943 
944     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
945         return strConcat(_a, _b, _c, "", "");
946     }
947 
948     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
949         return strConcat(_a, _b, _c, _d, "");
950     }
951 
952     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
953         bytes memory _ba = bytes(_a);
954         bytes memory _bb = bytes(_b);
955         bytes memory _bc = bytes(_c);
956         bytes memory _bd = bytes(_d);
957         bytes memory _be = bytes(_e);
958         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
959         bytes memory babcde = bytes(abcde);
960         uint k = 0;
961         uint i = 0;
962         for (i = 0; i < _ba.length; i++) {
963             babcde[k++] = _ba[i];
964         }
965         for (i = 0; i < _bb.length; i++) {
966             babcde[k++] = _bb[i];
967         }
968         for (i = 0; i < _bc.length; i++) {
969             babcde[k++] = _bc[i];
970         }
971         for (i = 0; i < _bd.length; i++) {
972             babcde[k++] = _bd[i];
973         }
974         for (i = 0; i < _be.length; i++) {
975             babcde[k++] = _be[i];
976         }
977         return string(babcde);
978     }
979 
980     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
981         return safeParseInt(_a, 0);
982     }
983 
984     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
985         bytes memory bresult = bytes(_a);
986         uint mint = 0;
987         bool decimals = false;
988         for (uint i = 0; i < bresult.length; i++) {
989             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
990                 if (decimals) {
991                    if (_b == 0) break;
992                     else _b--;
993                 }
994                 mint *= 10;
995                 mint += uint(uint8(bresult[i])) - 48;
996             } else if (uint(uint8(bresult[i])) == 46) {
997                 require(!decimals, 'More than one decimal encountered in string!');
998                 decimals = true;
999             } else {
1000                 revert("Non-numeral character encountered in string!");
1001             }
1002         }
1003         if (_b > 0) {
1004             mint *= 10 ** _b;
1005         }
1006         return mint;
1007     }
1008 
1009     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
1010         return parseInt(_a, 0);
1011     }
1012 
1013     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1014         bytes memory bresult = bytes(_a);
1015         uint mint = 0;
1016         bool decimals = false;
1017         for (uint i = 0; i < bresult.length; i++) {
1018             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1019                 if (decimals) {
1020                    if (_b == 0) {
1021                        break;
1022                    } else {
1023                        _b--;
1024                    }
1025                 }
1026                 mint *= 10;
1027                 mint += uint(uint8(bresult[i])) - 48;
1028             } else if (uint(uint8(bresult[i])) == 46) {
1029                 decimals = true;
1030             }
1031         }
1032         if (_b > 0) {
1033             mint *= 10 ** _b;
1034         }
1035         return mint;
1036     }
1037 
1038     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1039         if (_i == 0) {
1040             return "0";
1041         }
1042         uint j = _i;
1043         uint len;
1044         while (j != 0) {
1045             len++;
1046             j /= 10;
1047         }
1048         bytes memory bstr = new bytes(len);
1049         uint k = len - 1;
1050         while (_i != 0) {
1051             bstr[k--] = byte(uint8(48 + _i % 10));
1052             _i /= 10;
1053         }
1054         return string(bstr);
1055     }
1056 
1057     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1058         safeMemoryCleaner();
1059         Buffer.buffer memory buf;
1060         Buffer.init(buf, 1024);
1061         buf.startArray();
1062         for (uint i = 0; i < _arr.length; i++) {
1063             buf.encodeString(_arr[i]);
1064         }
1065         buf.endSequence();
1066         return buf.buf;
1067     }
1068 
1069     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1070         safeMemoryCleaner();
1071         Buffer.buffer memory buf;
1072         Buffer.init(buf, 1024);
1073         buf.startArray();
1074         for (uint i = 0; i < _arr.length; i++) {
1075             buf.encodeBytes(_arr[i]);
1076         }
1077         buf.endSequence();
1078         return buf.buf;
1079     }
1080 
1081     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1082         require((_nbytes > 0) && (_nbytes <= 32));
1083         _delay *= 10; // Convert from seconds to ledger timer ticks
1084         bytes memory nbytes = new bytes(1);
1085         nbytes[0] = byte(uint8(_nbytes));
1086         bytes memory unonce = new bytes(32);
1087         bytes memory sessionKeyHash = new bytes(32);
1088         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1089         assembly {
1090             mstore(unonce, 0x20)
1091             /*
1092              The following variables can be relaxed.
1093              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1094              for an idea on how to override and replace commit hash variables.
1095             */
1096             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1097             mstore(sessionKeyHash, 0x20)
1098             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1099         }
1100         bytes memory delay = new bytes(32);
1101         assembly {
1102             mstore(add(delay, 0x20), _delay)
1103         }
1104         bytes memory delay_bytes8 = new bytes(8);
1105         copyBytes(delay, 24, 8, delay_bytes8, 0);
1106         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1107         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1108         bytes memory delay_bytes8_left = new bytes(8);
1109         assembly {
1110             let x := mload(add(delay_bytes8, 0x20))
1111             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1112             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1113             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1114             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1115             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1116             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1117             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1118             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1119         }
1120         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1121         return queryId;
1122     }
1123 
1124     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1125         oraclize_randomDS_args[_queryId] = _commitment;
1126     }
1127 
1128     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1129         bool sigok;
1130         address signer;
1131         bytes32 sigr;
1132         bytes32 sigs;
1133         bytes memory sigr_ = new bytes(32);
1134         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1135         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1136         bytes memory sigs_ = new bytes(32);
1137         offset += 32 + 2;
1138         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1139         assembly {
1140             sigr := mload(add(sigr_, 32))
1141             sigs := mload(add(sigs_, 32))
1142         }
1143         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1144         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1145             return true;
1146         } else {
1147             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1148             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1149         }
1150     }
1151 
1152     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1153         bool sigok;
1154         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1155         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1156         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1157         bytes memory appkey1_pubkey = new bytes(64);
1158         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1159         bytes memory tosign2 = new bytes(1 + 65 + 32);
1160         tosign2[0] = byte(uint8(1)); //role
1161         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1162         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1163         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1164         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1165         if (!sigok) {
1166             return false;
1167         }
1168         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1169         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1170         bytes memory tosign3 = new bytes(1 + 65);
1171         tosign3[0] = 0xFE;
1172         copyBytes(_proof, 3, 65, tosign3, 1);
1173         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1174         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1175         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1176         return sigok;
1177     }
1178 
1179     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1180         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1181         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1182             return 1;
1183         }
1184         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1185         if (!proofVerified) {
1186             return 2;
1187         }
1188         return 0;
1189     }
1190 
1191     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1192         bool match_ = true;
1193         require(_prefix.length == _nRandomBytes);
1194         for (uint256 i = 0; i< _nRandomBytes; i++) {
1195             if (_content[i] != _prefix[i]) {
1196                 match_ = false;
1197             }
1198         }
1199         return match_;
1200     }
1201 
1202     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1203         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1204         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1205         bytes memory keyhash = new bytes(32);
1206         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1207         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1208             return false;
1209         }
1210         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1211         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1212         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1213         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1214             return false;
1215         }
1216         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1217         // This is to verify that the computed args match with the ones specified in the query.
1218         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1219         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1220         bytes memory sessionPubkey = new bytes(64);
1221         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1222         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1223         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1224         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1225             delete oraclize_randomDS_args[_queryId];
1226         } else return false;
1227         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1228         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1229         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1230         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1231             return false;
1232         }
1233         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1234         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1235             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1236         }
1237         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1238     }
1239     /*
1240      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1241     */
1242     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1243         uint minLength = _length + _toOffset;
1244         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1245         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1246         uint j = 32 + _toOffset;
1247         while (i < (32 + _fromOffset + _length)) {
1248             assembly {
1249                 let tmp := mload(add(_from, i))
1250                 mstore(add(_to, j), tmp)
1251             }
1252             i += 32;
1253             j += 32;
1254         }
1255         return _to;
1256     }
1257     /*
1258      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1259      Duplicate Solidity's ecrecover, but catching the CALL return value
1260     */
1261     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1262         /*
1263          We do our own memory management here. Solidity uses memory offset
1264          0x40 to store the current end of memory. We write past it (as
1265          writes are memory extensions), but don't update the offset so
1266          Solidity will reuse it. The memory used here is only needed for
1267          this context.
1268          FIXME: inline assembly can't access return values
1269         */
1270         bool ret;
1271         address addr;
1272         assembly {
1273             let size := mload(0x40)
1274             mstore(size, _hash)
1275             mstore(add(size, 32), _v)
1276             mstore(add(size, 64), _r)
1277             mstore(add(size, 96), _s)
1278             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1279             addr := mload(size)
1280         }
1281         return (ret, addr);
1282     }
1283     /*
1284      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1285     */
1286     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1287         bytes32 r;
1288         bytes32 s;
1289         uint8 v;
1290         if (_sig.length != 65) {
1291             return (false, address(0));
1292         }
1293         /*
1294          The signature format is a compact form of:
1295            {bytes32 r}{bytes32 s}{uint8 v}
1296          Compact means, uint8 is not padded to 32 bytes.
1297         */
1298         assembly {
1299             r := mload(add(_sig, 32))
1300             s := mload(add(_sig, 64))
1301             /*
1302              Here we are loading the last 32 bytes. We exploit the fact that
1303              'mload' will pad with zeroes if we overread.
1304              There is no 'mload8' to do this, but that would be nicer.
1305             */
1306             v := byte(0, mload(add(_sig, 96)))
1307             /*
1308               Alternative solution:
1309               'byte' is not working due to the Solidity parser, so lets
1310               use the second best option, 'and'
1311               v := and(mload(add(_sig, 65)), 255)
1312             */
1313         }
1314         /*
1315          albeit non-transactional signatures are not specified by the YP, one would expect it
1316          to match the YP range of [27, 28]
1317          geth uses [0, 1] and some clients have followed. This might change, see:
1318          https://github.com/ethereum/go-ethereum/issues/2053
1319         */
1320         if (v < 27) {
1321             v += 27;
1322         }
1323         if (v != 27 && v != 28) {
1324             return (false, address(0));
1325         }
1326         return safer_ecrecover(_hash, v, r, s);
1327     }
1328 
1329     function safeMemoryCleaner() internal pure {
1330         assembly {
1331             let fmem := mload(0x40)
1332             codecopy(fmem, codesize, sub(msize, fmem))
1333         }
1334     }
1335 }
1336 /*
1337 
1338 END ORACLIZE_API
1339 
1340 */ 
1341 
1342 interface PriceWatcherI
1343 {
1344     function getUSDcentsPerETH() external view returns (uint256 _USDcentsPerETH);
1345 }
1346 
1347 contract PriceWatcher is usingOraclize, PriceWatcherI
1348 {
1349     uint256 private lastOracleUSDcentsPerETH;
1350     uint256 private lastOracleUpdateTime = 0;
1351     uint256 public errorCounter = 0;
1352     string public errorString;
1353     
1354     mapping(address => bool) public administrators;
1355     bool public adminOverrideEnabled = false;
1356     uint256 private adminOverrideUDScentsPerETH = 0;
1357     mapping(address => bool) public whitelistedUsers;
1358     
1359     // Oracle settings
1360     uint256 public oracleQueryIntervalSeconds = 10 * 60;
1361     string public oracleQueryType = "URL";
1362     string public oracleQueryString = "json(https://api.pro.coinbase.com/products/ETH-USD/ticker).price";
1363     bool public oracleStopped = false;
1364     uint256 public oracleCallbackGasLimit = 150000;
1365     
1366     
1367     constructor() payable public
1368     {
1369         administrators[msg.sender] = true;
1370         
1371         triggerPriceUpdate(1);
1372     }
1373     
1374     // Administrative functions
1375     
1376     // Deposit ETH
1377     function () payable external
1378     {
1379     }
1380     
1381     // Withdraw ETH
1382     function withdraw(uint256 _amount) external
1383     {
1384         require(administrators[msg.sender]);
1385         msg.sender.transfer(_amount);
1386     }
1387     function withdrawAll() external
1388     {
1389         require(administrators[msg.sender]);
1390         msg.sender.transfer(address(this).balance);
1391     }
1392     
1393     // Add/remove administrators
1394     function addAdministrator(address _newAdministrator) external
1395     {
1396         require(administrators[msg.sender]);
1397         administrators[_newAdministrator] = true;
1398     }
1399     function removeAdministrator(address _administrator) external
1400     {
1401         require(administrators[msg.sender]);
1402         administrators[_administrator] = false;
1403     }
1404     
1405     // Admin override
1406     function enableAdminOverride(uint256 _USDcentsPerETH) external
1407     {
1408         require(administrators[msg.sender]);
1409         adminOverrideEnabled = true;
1410         adminOverrideUDScentsPerETH = _USDcentsPerETH;
1411     }
1412     function disableAdminOverride() external
1413     {
1414         require(administrators[msg.sender]);
1415         adminOverrideEnabled = false;
1416     }
1417     
1418     // Oracle settings
1419     function setOracleCallbackGasLimit(uint256 _gasLimit) external
1420     {
1421         require(administrators[msg.sender]);
1422         oracleCallbackGasLimit = _gasLimit;
1423     }
1424     function setOracleCallbackGasPrice(uint256 _gasPrice) external
1425     {
1426         require(administrators[msg.sender]);
1427         oraclize_setCustomGasPrice(_gasPrice);
1428     }
1429     function setOracleInterval(uint256 _intervalSeconds) external
1430     {
1431         require(administrators[msg.sender]);
1432         oracleQueryIntervalSeconds = _intervalSeconds;
1433     }
1434     function setOracleSource(string calldata _queryType, string calldata _queryString) external
1435     {
1436         require(administrators[msg.sender]);
1437         oracleQueryType = _queryType;
1438         oracleQueryString = _queryString;
1439     }
1440     function setOracleStopped(bool _stopped) external
1441     {
1442         require(administrators[msg.sender]);
1443         oracleStopped = _stopped;
1444     }
1445     
1446     // User whitelisting
1447     function setUserWhitelisted(address _user, bool _whitelisted) external
1448     {
1449         require(administrators[msg.sender]);
1450         whitelistedUsers[_user] = _whitelisted;
1451     }
1452     
1453     function getUSDcentsPerETH() external view returns (uint256 _USDcentsPerETH)
1454     {
1455         require(whitelistedUsers[msg.sender] || !isContract(msg.sender));
1456         
1457         if (adminOverrideEnabled)
1458         {
1459             return adminOverrideUDScentsPerETH;
1460         }
1461         else
1462         {
1463             return lastOracleUSDcentsPerETH;
1464         }
1465     }
1466     
1467     function triggerPriceUpdate(uint256 _delaySeconds) public
1468     {
1469         require(administrators[msg.sender] || msg.sender == oraclize_cbAddress());
1470         
1471         oraclize_query(_delaySeconds, oracleQueryType, oracleQueryString, oracleCallbackGasLimit);
1472     }
1473     
1474     // (str="123.89421", decimals=2) => (success=true, 12389)
1475     // (str="123.8"    , decimals=2) => (success=true, 12380)
1476     // (str="77"       , decimals=2) => (success=true,  7700)
1477     function numberString_to_uint(string memory _str, uint256 _decimals) public pure returns (bool _success, uint256 _uint)
1478     {
1479         _uint = 0;
1480         bool seenDecimalPoint = false;
1481         uint256 decimalsSeen = 0;
1482         
1483         // Loop over the characters of the string
1484         for (uint256 i=0; i<bytes(_str).length; i++)
1485         {
1486             uint8 digit = uint8(bytes(_str)[i]);
1487             if (digit == 46) // .
1488             {
1489                 if (seenDecimalPoint)
1490                 {
1491                     // Error: There were two decimal points in the number
1492                     return (false, _uint);
1493                 }
1494                 seenDecimalPoint = true;
1495             }
1496             else if (digit >= 0x30 && digit <= 0x39) // 0 - 9
1497             {
1498                 _uint *= 10;
1499                 _uint += digit - 0x30;
1500                 if (seenDecimalPoint)
1501                 {
1502                     decimalsSeen++;
1503                     if (decimalsSeen == _decimals)
1504                     {
1505                         break;
1506                     }
1507                 }
1508             }
1509             else
1510             {
1511                 // Invalid non-numerical character in response string!
1512                 return (false, _uint);
1513             }
1514         }
1515         
1516         while (decimalsSeen < _decimals)
1517         {
1518             _uint *= 10;
1519             decimalsSeen++;
1520         }
1521         
1522         _success = true;
1523     }
1524     
1525     function __callback(bytes32 myid, string memory result) public
1526     {
1527         require(msg.sender == oraclize_cbAddress());
1528         
1529         bool parseSuccess;
1530         uint256 centsPerETH;
1531         
1532         (parseSuccess, centsPerETH) = numberString_to_uint(result, 2);
1533         
1534         if (!parseSuccess || centsPerETH == 0)
1535         {
1536             errorCounter++;
1537             errorString = result;
1538         }
1539         else
1540         {
1541             if (!oracleStopped)
1542             {
1543                 lastOracleUSDcentsPerETH = centsPerETH;
1544                 lastOracleUpdateTime = block.timestamp;
1545                 triggerPriceUpdate(oracleQueryIntervalSeconds);
1546             }
1547         }
1548     }
1549     
1550     function isContract(address _addr) private view returns (bool)
1551     {
1552         uint256 size;
1553         assembly
1554         {
1555             size := extcodesize(_addr)
1556         }
1557         return size != 0;
1558     }
1559 }