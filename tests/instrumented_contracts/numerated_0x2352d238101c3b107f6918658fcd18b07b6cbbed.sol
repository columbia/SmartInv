1 pragma solidity ^0.5.7;
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
29 pragma solidity >= 0.5.0 < 0.6.0; // Incompatible compiler version - please select a compiler within the stated pragma range, or use a different version of the oraclizeAPI!
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
354         if (getCodeSize(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41) > 0) { //goerli testnet
355             OAR = OraclizeAddrResolverI(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41);
356             oraclize_setNetworkName("eth_goerli");
357             return true;
358         }
359         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
360             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
361             return true;
362         }
363         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
364             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
365             return true;
366         }
367         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
368             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
369             return true;
370         }
371         return false;
372     }
373 
374     function __callback(bytes32 _myid, string memory _result) public {
375         __callback(_myid, _result, new bytes(0));
376     }
377 
378     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
379       return;
380       _myid; _result; _proof; // Silence compiler warnings
381     }
382 
383     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
384         return oraclize.getPrice(_datasource);
385     }
386 
387     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
388         return oraclize.getPrice(_datasource, _gasLimit);
389     }
390 
391     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
392         uint price = oraclize.getPrice(_datasource);
393         if (price > 1 ether + tx.gasprice * 200000) {
394             return 0; // Unexpectedly high price
395         }
396         return oraclize.query.value(price)(0, _datasource, _arg);
397     }
398 
399     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
400         uint price = oraclize.getPrice(_datasource);
401         if (price > 1 ether + tx.gasprice * 200000) {
402             return 0; // Unexpectedly high price
403         }
404         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
405     }
406 
407     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
408         uint price = oraclize.getPrice(_datasource,_gasLimit);
409         if (price > 1 ether + tx.gasprice * _gasLimit) {
410             return 0; // Unexpectedly high price
411         }
412         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
413     }
414 
415     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
416         uint price = oraclize.getPrice(_datasource, _gasLimit);
417         if (price > 1 ether + tx.gasprice * _gasLimit) {
418            return 0; // Unexpectedly high price
419         }
420         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
421     }
422 
423     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
424         uint price = oraclize.getPrice(_datasource);
425         if (price > 1 ether + tx.gasprice * 200000) {
426             return 0; // Unexpectedly high price
427         }
428         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
429     }
430 
431     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
432         uint price = oraclize.getPrice(_datasource);
433         if (price > 1 ether + tx.gasprice * 200000) {
434             return 0; // Unexpectedly high price
435         }
436         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
437     }
438 
439     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
440         uint price = oraclize.getPrice(_datasource, _gasLimit);
441         if (price > 1 ether + tx.gasprice * _gasLimit) {
442             return 0; // Unexpectedly high price
443         }
444         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
445     }
446 
447     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
448         uint price = oraclize.getPrice(_datasource, _gasLimit);
449         if (price > 1 ether + tx.gasprice * _gasLimit) {
450             return 0; // Unexpectedly high price
451         }
452         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
453     }
454 
455     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
456         uint price = oraclize.getPrice(_datasource);
457         if (price > 1 ether + tx.gasprice * 200000) {
458             return 0; // Unexpectedly high price
459         }
460         bytes memory args = stra2cbor(_argN);
461         return oraclize.queryN.value(price)(0, _datasource, args);
462     }
463 
464     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
465         uint price = oraclize.getPrice(_datasource);
466         if (price > 1 ether + tx.gasprice * 200000) {
467             return 0; // Unexpectedly high price
468         }
469         bytes memory args = stra2cbor(_argN);
470         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
471     }
472 
473     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
474         uint price = oraclize.getPrice(_datasource, _gasLimit);
475         if (price > 1 ether + tx.gasprice * _gasLimit) {
476             return 0; // Unexpectedly high price
477         }
478         bytes memory args = stra2cbor(_argN);
479         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
480     }
481 
482     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
483         uint price = oraclize.getPrice(_datasource, _gasLimit);
484         if (price > 1 ether + tx.gasprice * _gasLimit) {
485             return 0; // Unexpectedly high price
486         }
487         bytes memory args = stra2cbor(_argN);
488         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
489     }
490 
491     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
492         string[] memory dynargs = new string[](1);
493         dynargs[0] = _args[0];
494         return oraclize_query(_datasource, dynargs);
495     }
496 
497     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
498         string[] memory dynargs = new string[](1);
499         dynargs[0] = _args[0];
500         return oraclize_query(_timestamp, _datasource, dynargs);
501     }
502 
503     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
504         string[] memory dynargs = new string[](1);
505         dynargs[0] = _args[0];
506         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
507     }
508 
509     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
510         string[] memory dynargs = new string[](1);
511         dynargs[0] = _args[0];
512         return oraclize_query(_datasource, dynargs, _gasLimit);
513     }
514 
515     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
516         string[] memory dynargs = new string[](2);
517         dynargs[0] = _args[0];
518         dynargs[1] = _args[1];
519         return oraclize_query(_datasource, dynargs);
520     }
521 
522     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
523         string[] memory dynargs = new string[](2);
524         dynargs[0] = _args[0];
525         dynargs[1] = _args[1];
526         return oraclize_query(_timestamp, _datasource, dynargs);
527     }
528 
529     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
530         string[] memory dynargs = new string[](2);
531         dynargs[0] = _args[0];
532         dynargs[1] = _args[1];
533         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
534     }
535 
536     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
537         string[] memory dynargs = new string[](2);
538         dynargs[0] = _args[0];
539         dynargs[1] = _args[1];
540         return oraclize_query(_datasource, dynargs, _gasLimit);
541     }
542 
543     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
544         string[] memory dynargs = new string[](3);
545         dynargs[0] = _args[0];
546         dynargs[1] = _args[1];
547         dynargs[2] = _args[2];
548         return oraclize_query(_datasource, dynargs);
549     }
550 
551     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
552         string[] memory dynargs = new string[](3);
553         dynargs[0] = _args[0];
554         dynargs[1] = _args[1];
555         dynargs[2] = _args[2];
556         return oraclize_query(_timestamp, _datasource, dynargs);
557     }
558 
559     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
560         string[] memory dynargs = new string[](3);
561         dynargs[0] = _args[0];
562         dynargs[1] = _args[1];
563         dynargs[2] = _args[2];
564         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
565     }
566 
567     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
568         string[] memory dynargs = new string[](3);
569         dynargs[0] = _args[0];
570         dynargs[1] = _args[1];
571         dynargs[2] = _args[2];
572         return oraclize_query(_datasource, dynargs, _gasLimit);
573     }
574 
575     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
576         string[] memory dynargs = new string[](4);
577         dynargs[0] = _args[0];
578         dynargs[1] = _args[1];
579         dynargs[2] = _args[2];
580         dynargs[3] = _args[3];
581         return oraclize_query(_datasource, dynargs);
582     }
583 
584     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
585         string[] memory dynargs = new string[](4);
586         dynargs[0] = _args[0];
587         dynargs[1] = _args[1];
588         dynargs[2] = _args[2];
589         dynargs[3] = _args[3];
590         return oraclize_query(_timestamp, _datasource, dynargs);
591     }
592 
593     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
594         string[] memory dynargs = new string[](4);
595         dynargs[0] = _args[0];
596         dynargs[1] = _args[1];
597         dynargs[2] = _args[2];
598         dynargs[3] = _args[3];
599         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
600     }
601 
602     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
603         string[] memory dynargs = new string[](4);
604         dynargs[0] = _args[0];
605         dynargs[1] = _args[1];
606         dynargs[2] = _args[2];
607         dynargs[3] = _args[3];
608         return oraclize_query(_datasource, dynargs, _gasLimit);
609     }
610 
611     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
612         string[] memory dynargs = new string[](5);
613         dynargs[0] = _args[0];
614         dynargs[1] = _args[1];
615         dynargs[2] = _args[2];
616         dynargs[3] = _args[3];
617         dynargs[4] = _args[4];
618         return oraclize_query(_datasource, dynargs);
619     }
620 
621     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
622         string[] memory dynargs = new string[](5);
623         dynargs[0] = _args[0];
624         dynargs[1] = _args[1];
625         dynargs[2] = _args[2];
626         dynargs[3] = _args[3];
627         dynargs[4] = _args[4];
628         return oraclize_query(_timestamp, _datasource, dynargs);
629     }
630 
631     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
632         string[] memory dynargs = new string[](5);
633         dynargs[0] = _args[0];
634         dynargs[1] = _args[1];
635         dynargs[2] = _args[2];
636         dynargs[3] = _args[3];
637         dynargs[4] = _args[4];
638         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
639     }
640 
641     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
642         string[] memory dynargs = new string[](5);
643         dynargs[0] = _args[0];
644         dynargs[1] = _args[1];
645         dynargs[2] = _args[2];
646         dynargs[3] = _args[3];
647         dynargs[4] = _args[4];
648         return oraclize_query(_datasource, dynargs, _gasLimit);
649     }
650 
651     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
652         uint price = oraclize.getPrice(_datasource);
653         if (price > 1 ether + tx.gasprice * 200000) {
654             return 0; // Unexpectedly high price
655         }
656         bytes memory args = ba2cbor(_argN);
657         return oraclize.queryN.value(price)(0, _datasource, args);
658     }
659 
660     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
661         uint price = oraclize.getPrice(_datasource);
662         if (price > 1 ether + tx.gasprice * 200000) {
663             return 0; // Unexpectedly high price
664         }
665         bytes memory args = ba2cbor(_argN);
666         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
667     }
668 
669     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
670         uint price = oraclize.getPrice(_datasource, _gasLimit);
671         if (price > 1 ether + tx.gasprice * _gasLimit) {
672             return 0; // Unexpectedly high price
673         }
674         bytes memory args = ba2cbor(_argN);
675         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
676     }
677 
678     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
679         uint price = oraclize.getPrice(_datasource, _gasLimit);
680         if (price > 1 ether + tx.gasprice * _gasLimit) {
681             return 0; // Unexpectedly high price
682         }
683         bytes memory args = ba2cbor(_argN);
684         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
685     }
686 
687     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
688         bytes[] memory dynargs = new bytes[](1);
689         dynargs[0] = _args[0];
690         return oraclize_query(_datasource, dynargs);
691     }
692 
693     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
694         bytes[] memory dynargs = new bytes[](1);
695         dynargs[0] = _args[0];
696         return oraclize_query(_timestamp, _datasource, dynargs);
697     }
698 
699     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
700         bytes[] memory dynargs = new bytes[](1);
701         dynargs[0] = _args[0];
702         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
703     }
704 
705     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
706         bytes[] memory dynargs = new bytes[](1);
707         dynargs[0] = _args[0];
708         return oraclize_query(_datasource, dynargs, _gasLimit);
709     }
710 
711     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
712         bytes[] memory dynargs = new bytes[](2);
713         dynargs[0] = _args[0];
714         dynargs[1] = _args[1];
715         return oraclize_query(_datasource, dynargs);
716     }
717 
718     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
719         bytes[] memory dynargs = new bytes[](2);
720         dynargs[0] = _args[0];
721         dynargs[1] = _args[1];
722         return oraclize_query(_timestamp, _datasource, dynargs);
723     }
724 
725     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
726         bytes[] memory dynargs = new bytes[](2);
727         dynargs[0] = _args[0];
728         dynargs[1] = _args[1];
729         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
730     }
731 
732     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
733         bytes[] memory dynargs = new bytes[](2);
734         dynargs[0] = _args[0];
735         dynargs[1] = _args[1];
736         return oraclize_query(_datasource, dynargs, _gasLimit);
737     }
738 
739     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
740         bytes[] memory dynargs = new bytes[](3);
741         dynargs[0] = _args[0];
742         dynargs[1] = _args[1];
743         dynargs[2] = _args[2];
744         return oraclize_query(_datasource, dynargs);
745     }
746 
747     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
748         bytes[] memory dynargs = new bytes[](3);
749         dynargs[0] = _args[0];
750         dynargs[1] = _args[1];
751         dynargs[2] = _args[2];
752         return oraclize_query(_timestamp, _datasource, dynargs);
753     }
754 
755     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
756         bytes[] memory dynargs = new bytes[](3);
757         dynargs[0] = _args[0];
758         dynargs[1] = _args[1];
759         dynargs[2] = _args[2];
760         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
761     }
762 
763     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
764         bytes[] memory dynargs = new bytes[](3);
765         dynargs[0] = _args[0];
766         dynargs[1] = _args[1];
767         dynargs[2] = _args[2];
768         return oraclize_query(_datasource, dynargs, _gasLimit);
769     }
770 
771     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
772         bytes[] memory dynargs = new bytes[](4);
773         dynargs[0] = _args[0];
774         dynargs[1] = _args[1];
775         dynargs[2] = _args[2];
776         dynargs[3] = _args[3];
777         return oraclize_query(_datasource, dynargs);
778     }
779 
780     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
781         bytes[] memory dynargs = new bytes[](4);
782         dynargs[0] = _args[0];
783         dynargs[1] = _args[1];
784         dynargs[2] = _args[2];
785         dynargs[3] = _args[3];
786         return oraclize_query(_timestamp, _datasource, dynargs);
787     }
788 
789     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
790         bytes[] memory dynargs = new bytes[](4);
791         dynargs[0] = _args[0];
792         dynargs[1] = _args[1];
793         dynargs[2] = _args[2];
794         dynargs[3] = _args[3];
795         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
796     }
797 
798     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
799         bytes[] memory dynargs = new bytes[](4);
800         dynargs[0] = _args[0];
801         dynargs[1] = _args[1];
802         dynargs[2] = _args[2];
803         dynargs[3] = _args[3];
804         return oraclize_query(_datasource, dynargs, _gasLimit);
805     }
806 
807     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
808         bytes[] memory dynargs = new bytes[](5);
809         dynargs[0] = _args[0];
810         dynargs[1] = _args[1];
811         dynargs[2] = _args[2];
812         dynargs[3] = _args[3];
813         dynargs[4] = _args[4];
814         return oraclize_query(_datasource, dynargs);
815     }
816 
817     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
818         bytes[] memory dynargs = new bytes[](5);
819         dynargs[0] = _args[0];
820         dynargs[1] = _args[1];
821         dynargs[2] = _args[2];
822         dynargs[3] = _args[3];
823         dynargs[4] = _args[4];
824         return oraclize_query(_timestamp, _datasource, dynargs);
825     }
826 
827     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
828         bytes[] memory dynargs = new bytes[](5);
829         dynargs[0] = _args[0];
830         dynargs[1] = _args[1];
831         dynargs[2] = _args[2];
832         dynargs[3] = _args[3];
833         dynargs[4] = _args[4];
834         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
835     }
836 
837     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
838         bytes[] memory dynargs = new bytes[](5);
839         dynargs[0] = _args[0];
840         dynargs[1] = _args[1];
841         dynargs[2] = _args[2];
842         dynargs[3] = _args[3];
843         dynargs[4] = _args[4];
844         return oraclize_query(_datasource, dynargs, _gasLimit);
845     }
846 
847     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
848         return oraclize.setProofType(_proofP);
849     }
850 
851 
852     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
853         return oraclize.cbAddress();
854     }
855 
856     function getCodeSize(address _addr) view internal returns (uint _size) {
857         assembly {
858             _size := extcodesize(_addr)
859         }
860     }
861 
862     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
863         return oraclize.setCustomGasPrice(_gasPrice);
864     }
865 
866     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
867         return oraclize.randomDS_getSessionPubKeyHash();
868     }
869 
870     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
871         bytes memory tmp = bytes(_a);
872         uint160 iaddr = 0;
873         uint160 b1;
874         uint160 b2;
875         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
876             iaddr *= 256;
877             b1 = uint160(uint8(tmp[i]));
878             b2 = uint160(uint8(tmp[i + 1]));
879             if ((b1 >= 97) && (b1 <= 102)) {
880                 b1 -= 87;
881             } else if ((b1 >= 65) && (b1 <= 70)) {
882                 b1 -= 55;
883             } else if ((b1 >= 48) && (b1 <= 57)) {
884                 b1 -= 48;
885             }
886             if ((b2 >= 97) && (b2 <= 102)) {
887                 b2 -= 87;
888             } else if ((b2 >= 65) && (b2 <= 70)) {
889                 b2 -= 55;
890             } else if ((b2 >= 48) && (b2 <= 57)) {
891                 b2 -= 48;
892             }
893             iaddr += (b1 * 16 + b2);
894         }
895         return address(iaddr);
896     }
897 
898     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
899         bytes memory a = bytes(_a);
900         bytes memory b = bytes(_b);
901         uint minLength = a.length;
902         if (b.length < minLength) {
903             minLength = b.length;
904         }
905         for (uint i = 0; i < minLength; i ++) {
906             if (a[i] < b[i]) {
907                 return -1;
908             } else if (a[i] > b[i]) {
909                 return 1;
910             }
911         }
912         if (a.length < b.length) {
913             return -1;
914         } else if (a.length > b.length) {
915             return 1;
916         } else {
917             return 0;
918         }
919     }
920 
921     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
922         bytes memory h = bytes(_haystack);
923         bytes memory n = bytes(_needle);
924         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
925             return -1;
926         } else if (h.length > (2 ** 128 - 1)) {
927             return -1;
928         } else {
929             uint subindex = 0;
930             for (uint i = 0; i < h.length; i++) {
931                 if (h[i] == n[0]) {
932                     subindex = 1;
933                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
934                         subindex++;
935                     }
936                     if (subindex == n.length) {
937                         return int(i);
938                     }
939                 }
940             }
941             return -1;
942         }
943     }
944 
945     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
946         return strConcat(_a, _b, "", "", "");
947     }
948 
949     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
950         return strConcat(_a, _b, _c, "", "");
951     }
952 
953     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
954         return strConcat(_a, _b, _c, _d, "");
955     }
956 
957     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
958         bytes memory _ba = bytes(_a);
959         bytes memory _bb = bytes(_b);
960         bytes memory _bc = bytes(_c);
961         bytes memory _bd = bytes(_d);
962         bytes memory _be = bytes(_e);
963         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
964         bytes memory babcde = bytes(abcde);
965         uint k = 0;
966         uint i = 0;
967         for (i = 0; i < _ba.length; i++) {
968             babcde[k++] = _ba[i];
969         }
970         for (i = 0; i < _bb.length; i++) {
971             babcde[k++] = _bb[i];
972         }
973         for (i = 0; i < _bc.length; i++) {
974             babcde[k++] = _bc[i];
975         }
976         for (i = 0; i < _bd.length; i++) {
977             babcde[k++] = _bd[i];
978         }
979         for (i = 0; i < _be.length; i++) {
980             babcde[k++] = _be[i];
981         }
982         return string(babcde);
983     }
984 
985     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
986         return safeParseInt(_a, 0);
987     }
988 
989     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
990         bytes memory bresult = bytes(_a);
991         uint mint = 0;
992         bool decimals = false;
993         for (uint i = 0; i < bresult.length; i++) {
994             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
995                 if (decimals) {
996                    if (_b == 0) break;
997                     else _b--;
998                 }
999                 mint *= 10;
1000                 mint += uint(uint8(bresult[i])) - 48;
1001             } else if (uint(uint8(bresult[i])) == 46) {
1002                 require(!decimals, 'More than one decimal encountered in string!');
1003                 decimals = true;
1004             } else {
1005                 revert("Non-numeral character encountered in string!");
1006             }
1007         }
1008         if (_b > 0) {
1009             mint *= 10 ** _b;
1010         }
1011         return mint;
1012     }
1013 
1014     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
1015         return parseInt(_a, 0);
1016     }
1017 
1018     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1019         bytes memory bresult = bytes(_a);
1020         uint mint = 0;
1021         bool decimals = false;
1022         for (uint i = 0; i < bresult.length; i++) {
1023             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1024                 if (decimals) {
1025                    if (_b == 0) {
1026                        break;
1027                    } else {
1028                        _b--;
1029                    }
1030                 }
1031                 mint *= 10;
1032                 mint += uint(uint8(bresult[i])) - 48;
1033             } else if (uint(uint8(bresult[i])) == 46) {
1034                 decimals = true;
1035             }
1036         }
1037         if (_b > 0) {
1038             mint *= 10 ** _b;
1039         }
1040         return mint;
1041     }
1042 
1043     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1044         if (_i == 0) {
1045             return "0";
1046         }
1047         uint j = _i;
1048         uint len;
1049         while (j != 0) {
1050             len++;
1051             j /= 10;
1052         }
1053         bytes memory bstr = new bytes(len);
1054         uint k = len - 1;
1055         while (_i != 0) {
1056             bstr[k--] = byte(uint8(48 + _i % 10));
1057             _i /= 10;
1058         }
1059         return string(bstr);
1060     }
1061 
1062     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1063         safeMemoryCleaner();
1064         Buffer.buffer memory buf;
1065         Buffer.init(buf, 1024);
1066         buf.startArray();
1067         for (uint i = 0; i < _arr.length; i++) {
1068             buf.encodeString(_arr[i]);
1069         }
1070         buf.endSequence();
1071         return buf.buf;
1072     }
1073 
1074     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1075         safeMemoryCleaner();
1076         Buffer.buffer memory buf;
1077         Buffer.init(buf, 1024);
1078         buf.startArray();
1079         for (uint i = 0; i < _arr.length; i++) {
1080             buf.encodeBytes(_arr[i]);
1081         }
1082         buf.endSequence();
1083         return buf.buf;
1084     }
1085 
1086     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1087         require((_nbytes > 0) && (_nbytes <= 32));
1088         _delay *= 10; // Convert from seconds to ledger timer ticks
1089         bytes memory nbytes = new bytes(1);
1090         nbytes[0] = byte(uint8(_nbytes));
1091         bytes memory unonce = new bytes(32);
1092         bytes memory sessionKeyHash = new bytes(32);
1093         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1094         assembly {
1095             mstore(unonce, 0x20)
1096             /*
1097              The following variables can be relaxed.
1098              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1099              for an idea on how to override and replace commit hash variables.
1100             */
1101             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1102             mstore(sessionKeyHash, 0x20)
1103             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1104         }
1105         bytes memory delay = new bytes(32);
1106         assembly {
1107             mstore(add(delay, 0x20), _delay)
1108         }
1109         bytes memory delay_bytes8 = new bytes(8);
1110         copyBytes(delay, 24, 8, delay_bytes8, 0);
1111         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1112         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1113         bytes memory delay_bytes8_left = new bytes(8);
1114         assembly {
1115             let x := mload(add(delay_bytes8, 0x20))
1116             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1117             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1118             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1119             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1120             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1121             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1122             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1123             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1124         }
1125         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1126         return queryId;
1127     }
1128 
1129     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1130         oraclize_randomDS_args[_queryId] = _commitment;
1131     }
1132 
1133     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1134         bool sigok;
1135         address signer;
1136         bytes32 sigr;
1137         bytes32 sigs;
1138         bytes memory sigr_ = new bytes(32);
1139         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1140         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1141         bytes memory sigs_ = new bytes(32);
1142         offset += 32 + 2;
1143         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1144         assembly {
1145             sigr := mload(add(sigr_, 32))
1146             sigs := mload(add(sigs_, 32))
1147         }
1148         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1149         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1150             return true;
1151         } else {
1152             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1153             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1154         }
1155     }
1156 
1157     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1158         bool sigok;
1159         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1160         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1161         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1162         bytes memory appkey1_pubkey = new bytes(64);
1163         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1164         bytes memory tosign2 = new bytes(1 + 65 + 32);
1165         tosign2[0] = byte(uint8(1)); //role
1166         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1167         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1168         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1169         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1170         if (!sigok) {
1171             return false;
1172         }
1173         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1174         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1175         bytes memory tosign3 = new bytes(1 + 65);
1176         tosign3[0] = 0xFE;
1177         copyBytes(_proof, 3, 65, tosign3, 1);
1178         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1179         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1180         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1181         return sigok;
1182     }
1183 
1184     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1185         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1186         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1187             return 1;
1188         }
1189         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1190         if (!proofVerified) {
1191             return 2;
1192         }
1193         return 0;
1194     }
1195 
1196     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1197         bool match_ = true;
1198         require(_prefix.length == _nRandomBytes);
1199         for (uint256 i = 0; i< _nRandomBytes; i++) {
1200             if (_content[i] != _prefix[i]) {
1201                 match_ = false;
1202             }
1203         }
1204         return match_;
1205     }
1206 
1207     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1208         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1209         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1210         bytes memory keyhash = new bytes(32);
1211         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1212         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1213             return false;
1214         }
1215         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1216         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1217         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1218         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1219             return false;
1220         }
1221         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1222         // This is to verify that the computed args match with the ones specified in the query.
1223         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1224         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1225         bytes memory sessionPubkey = new bytes(64);
1226         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1227         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1228         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1229         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1230             delete oraclize_randomDS_args[_queryId];
1231         } else return false;
1232         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1233         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1234         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1235         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1236             return false;
1237         }
1238         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1239         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1240             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1241         }
1242         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1243     }
1244     /*
1245      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1246     */
1247     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1248         uint minLength = _length + _toOffset;
1249         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1250         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1251         uint j = 32 + _toOffset;
1252         while (i < (32 + _fromOffset + _length)) {
1253             assembly {
1254                 let tmp := mload(add(_from, i))
1255                 mstore(add(_to, j), tmp)
1256             }
1257             i += 32;
1258             j += 32;
1259         }
1260         return _to;
1261     }
1262     /*
1263      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1264      Duplicate Solidity's ecrecover, but catching the CALL return value
1265     */
1266     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1267         /*
1268          We do our own memory management here. Solidity uses memory offset
1269          0x40 to store the current end of memory. We write past it (as
1270          writes are memory extensions), but don't update the offset so
1271          Solidity will reuse it. The memory used here is only needed for
1272          this context.
1273          FIXME: inline assembly can't access return values
1274         */
1275         bool ret;
1276         address addr;
1277         assembly {
1278             let size := mload(0x40)
1279             mstore(size, _hash)
1280             mstore(add(size, 32), _v)
1281             mstore(add(size, 64), _r)
1282             mstore(add(size, 96), _s)
1283             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1284             addr := mload(size)
1285         }
1286         return (ret, addr);
1287     }
1288     /*
1289      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1290     */
1291     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1292         bytes32 r;
1293         bytes32 s;
1294         uint8 v;
1295         if (_sig.length != 65) {
1296             return (false, address(0));
1297         }
1298         /*
1299          The signature format is a compact form of:
1300            {bytes32 r}{bytes32 s}{uint8 v}
1301          Compact means, uint8 is not padded to 32 bytes.
1302         */
1303         assembly {
1304             r := mload(add(_sig, 32))
1305             s := mload(add(_sig, 64))
1306             /*
1307              Here we are loading the last 32 bytes. We exploit the fact that
1308              'mload' will pad with zeroes if we overread.
1309              There is no 'mload8' to do this, but that would be nicer.
1310             */
1311             v := byte(0, mload(add(_sig, 96)))
1312             /*
1313               Alternative solution:
1314               'byte' is not working due to the Solidity parser, so lets
1315               use the second best option, 'and'
1316               v := and(mload(add(_sig, 65)), 255)
1317             */
1318         }
1319         /*
1320          albeit non-transactional signatures are not specified by the YP, one would expect it
1321          to match the YP range of [27, 28]
1322          geth uses [0, 1] and some clients have followed. This might change, see:
1323          https://github.com/ethereum/go-ethereum/issues/2053
1324         */
1325         if (v < 27) {
1326             v += 27;
1327         }
1328         if (v != 27 && v != 28) {
1329             return (false, address(0));
1330         }
1331         return safer_ecrecover(_hash, v, r, s);
1332     }
1333 
1334     function safeMemoryCleaner() internal pure {
1335         assembly {
1336             let fmem := mload(0x40)
1337             codecopy(fmem, codesize, sub(msize, fmem))
1338         }
1339     }
1340 }
1341 /*
1342 
1343 END ORACLIZE_API
1344 
1345 */
1346 
1347 
1348 /**
1349  * @title SafeMath
1350  * @dev Unsigned math operations with safety checks that revert on error.
1351  */
1352 library SafeMath {
1353 
1354     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1355         if (a == 0) {
1356             return 0;
1357         }
1358 
1359         uint256 c = a * b;
1360         require(c / a == b, "SafeMath: multiplication overflow");
1361 
1362         return c;
1363     }
1364 
1365     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1366         require(b > 0, "SafeMath: division by zero");
1367         uint256 c = a / b;
1368 
1369         return c;
1370     }
1371 
1372     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1373         require(b <= a, "SafeMath: subtraction overflow");
1374         uint256 c = a - b;
1375 
1376         return c;
1377     }
1378 
1379     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1380         uint256 c = a + b;
1381         require(c >= a, "SafeMath: addition overflow");
1382 
1383         return c;
1384     }
1385 
1386     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1387         require(b != 0, "SafeMath: modulo by zero");
1388         return a % b;
1389     }
1390 }
1391 
1392 /**
1393  * @title Ownable
1394  * @dev The Ownable contract has an owner address, and provides basic authorization control
1395  * functions, this simplifies the implementation of "user permissions".
1396  */
1397 contract Ownable {
1398 
1399     address internal _owner;
1400 
1401     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1402 
1403     constructor () internal {
1404         _owner = msg.sender;
1405         emit OwnershipTransferred(address(0), _owner);
1406     }
1407 
1408     function owner() public view returns (address) {
1409         return _owner;
1410     }
1411 
1412     modifier onlyOwner() {
1413         require(isOwner(), "Caller is not the owner");
1414         _;
1415     }
1416 
1417     function isOwner() public view returns (bool) {
1418         return msg.sender == _owner;
1419     }
1420 
1421     function renounceOwnership() public onlyOwner {
1422         emit OwnershipTransferred(_owner, address(0));
1423         _owner = address(0);
1424     }
1425 
1426     function transferOwnership(address newOwner) public onlyOwner {
1427         require(newOwner != address(0), "New owner is the zero address");
1428         emit OwnershipTransferred(_owner, newOwner);
1429         _owner = newOwner;
1430     }
1431 
1432 }
1433 
1434 /**
1435  * @title ERC20 interface
1436  * @dev see https://eips.ethereum.org/EIPS/eip-20
1437  */
1438 interface IERC20 {
1439     function transfer(address to, uint256 value) external returns (bool);
1440     function balanceOf(address who) external view returns (uint256);
1441 }
1442 
1443 /**
1444  * @title PriceReceiver
1445  * @dev The PriceReceiver interface to interact with crowdsale.
1446  */
1447 interface PriceReceiver {
1448     function receiveEthPrice(uint256 ethUsdPrice) external;
1449 }
1450 
1451 /**
1452  * @title PriceProvider
1453  * @dev The PriceProvider contract to query price from oraclizer.
1454  * @author https://grox.solutions
1455  */
1456 contract PriceProvider is Ownable, usingOraclize {
1457     using SafeMath for uint256;
1458 
1459     enum State { Stopped, Active }
1460 
1461     uint256 public updateInterval = 86400;
1462 
1463     string public url;
1464 
1465     mapping (bytes32 => bool) validIds;
1466 
1467     PriceReceiver public watcher;
1468 
1469     State public state = State.Stopped;
1470 
1471     event InsufficientFunds();
1472 
1473     modifier inActiveState() {
1474         require(state == State.Active);
1475         _;
1476     }
1477 
1478     modifier inStoppedState() {
1479         require(state == State.Stopped);
1480         _;
1481     }
1482 
1483     constructor(string memory _url, address newWatcher) public {
1484         url = _url;
1485         setWatcher(newWatcher);
1486     }
1487 
1488     function() external payable {}
1489 
1490     function start_update() external payable onlyOwner inStoppedState {
1491         state = State.Active;
1492 
1493         _update(updateInterval);
1494     }
1495 
1496     function stop_update() external onlyOwner inActiveState {
1497         state = State.Stopped;
1498     }
1499 
1500     function setWatcher(address newWatcher) public onlyOwner {
1501         require(newWatcher != address(0));
1502         watcher = PriceReceiver(newWatcher);
1503     }
1504 
1505     function setCustomGasPrice(uint256 gasPrice) external onlyOwner {
1506         oraclize_setCustomGasPrice(gasPrice);
1507     }
1508 
1509     function setUpdateInterval(uint256 newInterval) external onlyOwner {
1510         require(newInterval > 0);
1511         updateInterval = newInterval;
1512     }
1513 
1514     function setUrl(string calldata newUrl) external onlyOwner {
1515         require(bytes(newUrl).length > 0);
1516         url = newUrl;
1517     }
1518 
1519     function __callback(bytes32 myid, string memory result, bytes memory proof) public {
1520         require(msg.sender == oraclize_cbAddress() && validIds[myid]);
1521         delete validIds[myid];
1522 
1523         uint256 newPrice = parseInt(result, 2);
1524         require(newPrice > 0);
1525 
1526         if (state == State.Active) {
1527             watcher.receiveEthPrice(newPrice);
1528             _update(updateInterval);
1529         }
1530     }
1531 
1532     function _update(uint256 delay) internal {
1533         if (oraclize_getPrice("URL") > address(this).balance) {
1534             emit InsufficientFunds();
1535         } else {
1536             bytes32 queryId = oraclize_query(delay, "URL", url);
1537             validIds[queryId] = true;
1538         }
1539     }
1540 
1541     function withdraw(address payable receiver) external onlyOwner {
1542         require(receiver != address(0));
1543         receiver.transfer(address(this).balance);
1544     }
1545 
1546     function withdrawERC20(address ERC20Token, address recipient) external onlyOwner {
1547 
1548         uint256 amount = IERC20(ERC20Token).balanceOf(address(this));
1549         IERC20(ERC20Token).transfer(recipient, amount);
1550 
1551     }
1552 }