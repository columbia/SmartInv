1 /*
2 
3 ORACLIZE_API
4 
5 Copyright (c) 2015-2016 Oraclize SRL
6 Copyright (c) 2016 Oraclize LTD
7 
8 Permission is hereby granted, free of charge, to any person obtaining a copy
9 of this software and associated documentation files (the "Software"), to deal
10 in the Software without restriction, including without limitation the rights
11 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
12 copies of the Software, and to permit persons to whom the Software is
13 furnished to do so, subject to the following conditions:
14 
15 The above copyright notice and this permission notice shall be included in
16 all copies or substantial portions of the Software.
17 
18 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
19 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
20 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
21 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
22 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
23 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
24 THE SOFTWARE.
25 
26 */
27 pragma solidity >= 0.5.0; // Incompatible compiler version - please select a compiler within the stated pragma range, or use a different version of the oraclizeAPI!
28 
29 contract OraclizeI {
30 
31     address public cbAddress;
32 
33     function setProofType(byte _proofType) external;
34     function setCustomGasPrice(uint _gasPrice) external;
35     function getPrice(string memory _datasource) public returns (uint _dsprice);
36     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
37     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
38     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
39     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
40     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
41     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
42     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
43     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
44 }
45 
46 contract OraclizeAddrResolverI {
47     function getAddress() public returns (address _address);
48 }
49 /*
50 
51 Begin solidity-cborutils
52 
53 https://github.com/smartcontractkit/solidity-cborutils
54 
55 MIT License
56 
57 Copyright (c) 2018 SmartContract ChainLink, Ltd.
58 
59 Permission is hereby granted, free of charge, to any person obtaining a copy
60 of this software and associated documentation files (the "Software"), to deal
61 in the Software without restriction, including without limitation the rights
62 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
63 copies of the Software, and to permit persons to whom the Software is
64 furnished to do so, subject to the following conditions:
65 
66 The above copyright notice and this permission notice shall be included in all
67 copies or substantial portions of the Software.
68 
69 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
70 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
71 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
72 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
73 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
74 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
75 SOFTWARE.
76 
77 */
78 library Buffer {
79 
80     struct buffer {
81         bytes buf;
82         uint capacity;
83     }
84 
85     function init(buffer memory _buf, uint _capacity) internal pure {
86         uint capacity = _capacity;
87         if (capacity % 32 != 0) {
88             capacity += 32 - (capacity % 32);
89         }
90         _buf.capacity = capacity; // Allocate space for the buffer data
91         assembly {
92             let ptr := mload(0x40)
93             mstore(_buf, ptr)
94             mstore(ptr, 0)
95             mstore(0x40, add(ptr, capacity))
96         }
97     }
98 
99     function resize(buffer memory _buf, uint _capacity) private pure {
100         bytes memory oldbuf = _buf.buf;
101         init(_buf, _capacity);
102         append(_buf, oldbuf);
103     }
104 
105     function max(uint _a, uint _b) private pure returns (uint _max) {
106         if (_a > _b) {
107             return _a;
108         }
109         return _b;
110     }
111     /**
112       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
113       *      would exceed the capacity of the buffer.
114       * @param _buf The buffer to append to.
115       * @param _data The data to append.
116       * @return The original buffer.
117       *
118       */
119     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
120         if (_data.length + _buf.buf.length > _buf.capacity) {
121             resize(_buf, max(_buf.capacity, _data.length) * 2);
122         }
123         uint dest;
124         uint src;
125         uint len = _data.length;
126         assembly {
127             let bufptr := mload(_buf) // Memory address of the buffer data
128             let buflen := mload(bufptr) // Length of existing buffer data
129             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
130             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
131             src := add(_data, 32)
132         }
133         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
134             assembly {
135                 mstore(dest, mload(src))
136             }
137             dest += 32;
138             src += 32;
139         }
140         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
141         assembly {
142             let srcpart := and(mload(src), not(mask))
143             let destpart := and(mload(dest), mask)
144             mstore(dest, or(destpart, srcpart))
145         }
146         return _buf;
147     }
148     /**
149       *
150       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
151       * exceed the capacity of the buffer.
152       * @param _buf The buffer to append to.
153       * @param _data The data to append.
154       * @return The original buffer.
155       *
156       */
157     function append(buffer memory _buf, uint8 _data) internal pure {
158         if (_buf.buf.length + 1 > _buf.capacity) {
159             resize(_buf, _buf.capacity * 2);
160         }
161         assembly {
162             let bufptr := mload(_buf) // Memory address of the buffer data
163             let buflen := mload(bufptr) // Length of existing buffer data
164             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
165             mstore8(dest, _data)
166             mstore(bufptr, add(buflen, 1)) // Update buffer length
167         }
168     }
169     /**
170       *
171       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
172       * exceed the capacity of the buffer.
173       * @param _buf The buffer to append to.
174       * @param _data The data to append.
175       * @return The original buffer.
176       *
177       */
178     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
179         if (_len + _buf.buf.length > _buf.capacity) {
180             resize(_buf, max(_buf.capacity, _len) * 2);
181         }
182         uint mask = 256 ** _len - 1;
183         assembly {
184             let bufptr := mload(_buf) // Memory address of the buffer data
185             let buflen := mload(bufptr) // Length of existing buffer data
186             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
187             mstore(dest, or(and(mload(dest), not(mask)), _data))
188             mstore(bufptr, add(buflen, _len)) // Update buffer length
189         }
190         return _buf;
191     }
192 }
193 
194 library CBOR {
195 
196     using Buffer for Buffer.buffer;
197 
198     uint8 private constant MAJOR_TYPE_INT = 0;
199     uint8 private constant MAJOR_TYPE_MAP = 5;
200     uint8 private constant MAJOR_TYPE_BYTES = 2;
201     uint8 private constant MAJOR_TYPE_ARRAY = 4;
202     uint8 private constant MAJOR_TYPE_STRING = 3;
203     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
204     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
205 
206     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
207         if (_value <= 23) {
208             _buf.append(uint8((_major << 5) | _value));
209         } else if (_value <= 0xFF) {
210             _buf.append(uint8((_major << 5) | 24));
211             _buf.appendInt(_value, 1);
212         } else if (_value <= 0xFFFF) {
213             _buf.append(uint8((_major << 5) | 25));
214             _buf.appendInt(_value, 2);
215         } else if (_value <= 0xFFFFFFFF) {
216             _buf.append(uint8((_major << 5) | 26));
217             _buf.appendInt(_value, 4);
218         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
219             _buf.append(uint8((_major << 5) | 27));
220             _buf.appendInt(_value, 8);
221         }
222     }
223 
224     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
225         _buf.append(uint8((_major << 5) | 31));
226     }
227 
228     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
229         encodeType(_buf, MAJOR_TYPE_INT, _value);
230     }
231 
232     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
233         if (_value >= 0) {
234             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
235         } else {
236             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
237         }
238     }
239 
240     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
241         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
242         _buf.append(_value);
243     }
244 
245     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
246         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
247         _buf.append(bytes(_value));
248     }
249 
250     function startArray(Buffer.buffer memory _buf) internal pure {
251         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
252     }
253 
254     function startMap(Buffer.buffer memory _buf) internal pure {
255         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
256     }
257 
258     function endSequence(Buffer.buffer memory _buf) internal pure {
259         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
260     }
261 }
262 /*
263 
264 End solidity-cborutils
265 
266 */
267 contract usingOraclize {
268 
269     using CBOR for Buffer.buffer;
270 
271     OraclizeI oraclize;
272     OraclizeAddrResolverI OAR;
273 
274     uint constant day = 60 * 60 * 24;
275     uint constant week = 60 * 60 * 24 * 7;
276     uint constant month = 60 * 60 * 24 * 30;
277 
278     byte constant proofType_NONE = 0x00;
279     byte constant proofType_Ledger = 0x30;
280     byte constant proofType_Native = 0xF0;
281     byte constant proofStorage_IPFS = 0x01;
282     byte constant proofType_Android = 0x40;
283     byte constant proofType_TLSNotary = 0x10;
284 
285     string oraclize_network_name;
286     uint8 constant networkID_auto = 0;
287     uint8 constant networkID_morden = 2;
288     uint8 constant networkID_mainnet = 1;
289     uint8 constant networkID_testnet = 2;
290     uint8 constant networkID_consensys = 161;
291 
292     mapping(bytes32 => bytes32) oraclize_randomDS_args;
293     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
294 
295     modifier oraclizeAPI {
296         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
297             oraclize_setNetwork(networkID_auto);
298         }
299         if (address(oraclize) != OAR.getAddress()) {
300             oraclize = OraclizeI(OAR.getAddress());
301         }
302         _;
303     }
304 
305     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
306         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
307         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
308         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
309         require(proofVerified);
310         _;
311     }
312 
313     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
314       return oraclize_setNetwork();
315       _networkID; // silence the warning and remain backwards compatible
316     }
317 
318     function oraclize_setNetworkName(string memory _network_name) internal {
319         oraclize_network_name = _network_name;
320     }
321 
322     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
323         return oraclize_network_name;
324     }
325 
326     function oraclize_setNetwork() internal returns (bool _networkSet) {
327         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
328             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
329             oraclize_setNetworkName("eth_mainnet");
330             return true;
331         }
332         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
333             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
334             oraclize_setNetworkName("eth_ropsten3");
335             return true;
336         }
337         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
338             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
339             oraclize_setNetworkName("eth_kovan");
340             return true;
341         }
342         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
343             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
344             oraclize_setNetworkName("eth_rinkeby");
345             return true;
346         }
347         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
348             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
349             return true;
350         }
351         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
352             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
353             return true;
354         }
355         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
356             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
357             return true;
358         }
359         return false;
360     }
361 
362     function __callback(bytes32 _myid, string memory _result) public {
363         __callback(_myid, _result, new bytes(0));
364     }
365 
366     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
367       return;
368       _myid; _result; _proof; // Silence compiler warnings
369     }
370 
371     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
372         return oraclize.getPrice(_datasource);
373     }
374 
375     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
376         return oraclize.getPrice(_datasource, _gasLimit);
377     }
378 
379     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
380         uint price = oraclize.getPrice(_datasource);
381         if (price > 1 ether + tx.gasprice * 200000) {
382             return 0; // Unexpectedly high price
383         }
384         return oraclize.query.value(price)(0, _datasource, _arg);
385     }
386 
387     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
388         uint price = oraclize.getPrice(_datasource);
389         if (price > 1 ether + tx.gasprice * 200000) {
390             return 0; // Unexpectedly high price
391         }
392         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
393     }
394 
395     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
396         uint price = oraclize.getPrice(_datasource,_gasLimit);
397         if (price > 1 ether + tx.gasprice * _gasLimit) {
398             return 0; // Unexpectedly high price
399         }
400         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
401     }
402 
403     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
404         uint price = oraclize.getPrice(_datasource, _gasLimit);
405         if (price > 1 ether + tx.gasprice * _gasLimit) {
406            return 0; // Unexpectedly high price
407         }
408         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
409     }
410 
411     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
412         uint price = oraclize.getPrice(_datasource);
413         if (price > 1 ether + tx.gasprice * 200000) {
414             return 0; // Unexpectedly high price
415         }
416         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
417     }
418 
419     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
420         uint price = oraclize.getPrice(_datasource);
421         if (price > 1 ether + tx.gasprice * 200000) {
422             return 0; // Unexpectedly high price
423         }
424         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
425     }
426 
427     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
428         uint price = oraclize.getPrice(_datasource, _gasLimit);
429         if (price > 1 ether + tx.gasprice * _gasLimit) {
430             return 0; // Unexpectedly high price
431         }
432         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
433     }
434 
435     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
436         uint price = oraclize.getPrice(_datasource, _gasLimit);
437         if (price > 1 ether + tx.gasprice * _gasLimit) {
438             return 0; // Unexpectedly high price
439         }
440         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
441     }
442 
443     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
444         uint price = oraclize.getPrice(_datasource);
445         if (price > 1 ether + tx.gasprice * 200000) {
446             return 0; // Unexpectedly high price
447         }
448         bytes memory args = stra2cbor(_argN);
449         return oraclize.queryN.value(price)(0, _datasource, args);
450     }
451 
452     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
453         uint price = oraclize.getPrice(_datasource);
454         if (price > 1 ether + tx.gasprice * 200000) {
455             return 0; // Unexpectedly high price
456         }
457         bytes memory args = stra2cbor(_argN);
458         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
459     }
460 
461     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
462         uint price = oraclize.getPrice(_datasource, _gasLimit);
463         if (price > 1 ether + tx.gasprice * _gasLimit) {
464             return 0; // Unexpectedly high price
465         }
466         bytes memory args = stra2cbor(_argN);
467         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
468     }
469 
470     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
471         uint price = oraclize.getPrice(_datasource, _gasLimit);
472         if (price > 1 ether + tx.gasprice * _gasLimit) {
473             return 0; // Unexpectedly high price
474         }
475         bytes memory args = stra2cbor(_argN);
476         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
477     }
478 
479     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
480         string[] memory dynargs = new string[](1);
481         dynargs[0] = _args[0];
482         return oraclize_query(_datasource, dynargs);
483     }
484 
485     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
486         string[] memory dynargs = new string[](1);
487         dynargs[0] = _args[0];
488         return oraclize_query(_timestamp, _datasource, dynargs);
489     }
490 
491     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
492         string[] memory dynargs = new string[](1);
493         dynargs[0] = _args[0];
494         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
495     }
496 
497     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
498         string[] memory dynargs = new string[](1);
499         dynargs[0] = _args[0];
500         return oraclize_query(_datasource, dynargs, _gasLimit);
501     }
502 
503     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
504         string[] memory dynargs = new string[](2);
505         dynargs[0] = _args[0];
506         dynargs[1] = _args[1];
507         return oraclize_query(_datasource, dynargs);
508     }
509 
510     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
511         string[] memory dynargs = new string[](2);
512         dynargs[0] = _args[0];
513         dynargs[1] = _args[1];
514         return oraclize_query(_timestamp, _datasource, dynargs);
515     }
516 
517     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
518         string[] memory dynargs = new string[](2);
519         dynargs[0] = _args[0];
520         dynargs[1] = _args[1];
521         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
522     }
523 
524     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
525         string[] memory dynargs = new string[](2);
526         dynargs[0] = _args[0];
527         dynargs[1] = _args[1];
528         return oraclize_query(_datasource, dynargs, _gasLimit);
529     }
530 
531     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
532         string[] memory dynargs = new string[](3);
533         dynargs[0] = _args[0];
534         dynargs[1] = _args[1];
535         dynargs[2] = _args[2];
536         return oraclize_query(_datasource, dynargs);
537     }
538 
539     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
540         string[] memory dynargs = new string[](3);
541         dynargs[0] = _args[0];
542         dynargs[1] = _args[1];
543         dynargs[2] = _args[2];
544         return oraclize_query(_timestamp, _datasource, dynargs);
545     }
546 
547     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
548         string[] memory dynargs = new string[](3);
549         dynargs[0] = _args[0];
550         dynargs[1] = _args[1];
551         dynargs[2] = _args[2];
552         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
553     }
554 
555     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
556         string[] memory dynargs = new string[](3);
557         dynargs[0] = _args[0];
558         dynargs[1] = _args[1];
559         dynargs[2] = _args[2];
560         return oraclize_query(_datasource, dynargs, _gasLimit);
561     }
562 
563     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
564         string[] memory dynargs = new string[](4);
565         dynargs[0] = _args[0];
566         dynargs[1] = _args[1];
567         dynargs[2] = _args[2];
568         dynargs[3] = _args[3];
569         return oraclize_query(_datasource, dynargs);
570     }
571 
572     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
573         string[] memory dynargs = new string[](4);
574         dynargs[0] = _args[0];
575         dynargs[1] = _args[1];
576         dynargs[2] = _args[2];
577         dynargs[3] = _args[3];
578         return oraclize_query(_timestamp, _datasource, dynargs);
579     }
580 
581     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
582         string[] memory dynargs = new string[](4);
583         dynargs[0] = _args[0];
584         dynargs[1] = _args[1];
585         dynargs[2] = _args[2];
586         dynargs[3] = _args[3];
587         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
588     }
589 
590     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
591         string[] memory dynargs = new string[](4);
592         dynargs[0] = _args[0];
593         dynargs[1] = _args[1];
594         dynargs[2] = _args[2];
595         dynargs[3] = _args[3];
596         return oraclize_query(_datasource, dynargs, _gasLimit);
597     }
598 
599     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
600         string[] memory dynargs = new string[](5);
601         dynargs[0] = _args[0];
602         dynargs[1] = _args[1];
603         dynargs[2] = _args[2];
604         dynargs[3] = _args[3];
605         dynargs[4] = _args[4];
606         return oraclize_query(_datasource, dynargs);
607     }
608 
609     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
610         string[] memory dynargs = new string[](5);
611         dynargs[0] = _args[0];
612         dynargs[1] = _args[1];
613         dynargs[2] = _args[2];
614         dynargs[3] = _args[3];
615         dynargs[4] = _args[4];
616         return oraclize_query(_timestamp, _datasource, dynargs);
617     }
618 
619     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
620         string[] memory dynargs = new string[](5);
621         dynargs[0] = _args[0];
622         dynargs[1] = _args[1];
623         dynargs[2] = _args[2];
624         dynargs[3] = _args[3];
625         dynargs[4] = _args[4];
626         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
627     }
628 
629     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
630         string[] memory dynargs = new string[](5);
631         dynargs[0] = _args[0];
632         dynargs[1] = _args[1];
633         dynargs[2] = _args[2];
634         dynargs[3] = _args[3];
635         dynargs[4] = _args[4];
636         return oraclize_query(_datasource, dynargs, _gasLimit);
637     }
638 
639     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
640         uint price = oraclize.getPrice(_datasource);
641         if (price > 1 ether + tx.gasprice * 200000) {
642             return 0; // Unexpectedly high price
643         }
644         bytes memory args = ba2cbor(_argN);
645         return oraclize.queryN.value(price)(0, _datasource, args);
646     }
647 
648     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
649         uint price = oraclize.getPrice(_datasource);
650         if (price > 1 ether + tx.gasprice * 200000) {
651             return 0; // Unexpectedly high price
652         }
653         bytes memory args = ba2cbor(_argN);
654         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
655     }
656 
657     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
658         uint price = oraclize.getPrice(_datasource, _gasLimit);
659         if (price > 1 ether + tx.gasprice * _gasLimit) {
660             return 0; // Unexpectedly high price
661         }
662         bytes memory args = ba2cbor(_argN);
663         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
664     }
665 
666     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
667         uint price = oraclize.getPrice(_datasource, _gasLimit);
668         if (price > 1 ether + tx.gasprice * _gasLimit) {
669             return 0; // Unexpectedly high price
670         }
671         bytes memory args = ba2cbor(_argN);
672         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
673     }
674 
675     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
676         bytes[] memory dynargs = new bytes[](1);
677         dynargs[0] = _args[0];
678         return oraclize_query(_datasource, dynargs);
679     }
680 
681     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
682         bytes[] memory dynargs = new bytes[](1);
683         dynargs[0] = _args[0];
684         return oraclize_query(_timestamp, _datasource, dynargs);
685     }
686 
687     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
688         bytes[] memory dynargs = new bytes[](1);
689         dynargs[0] = _args[0];
690         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
691     }
692 
693     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
694         bytes[] memory dynargs = new bytes[](1);
695         dynargs[0] = _args[0];
696         return oraclize_query(_datasource, dynargs, _gasLimit);
697     }
698 
699     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
700         bytes[] memory dynargs = new bytes[](2);
701         dynargs[0] = _args[0];
702         dynargs[1] = _args[1];
703         return oraclize_query(_datasource, dynargs);
704     }
705 
706     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
707         bytes[] memory dynargs = new bytes[](2);
708         dynargs[0] = _args[0];
709         dynargs[1] = _args[1];
710         return oraclize_query(_timestamp, _datasource, dynargs);
711     }
712 
713     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
714         bytes[] memory dynargs = new bytes[](2);
715         dynargs[0] = _args[0];
716         dynargs[1] = _args[1];
717         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
718     }
719 
720     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
721         bytes[] memory dynargs = new bytes[](2);
722         dynargs[0] = _args[0];
723         dynargs[1] = _args[1];
724         return oraclize_query(_datasource, dynargs, _gasLimit);
725     }
726 
727     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
728         bytes[] memory dynargs = new bytes[](3);
729         dynargs[0] = _args[0];
730         dynargs[1] = _args[1];
731         dynargs[2] = _args[2];
732         return oraclize_query(_datasource, dynargs);
733     }
734 
735     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
736         bytes[] memory dynargs = new bytes[](3);
737         dynargs[0] = _args[0];
738         dynargs[1] = _args[1];
739         dynargs[2] = _args[2];
740         return oraclize_query(_timestamp, _datasource, dynargs);
741     }
742 
743     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
744         bytes[] memory dynargs = new bytes[](3);
745         dynargs[0] = _args[0];
746         dynargs[1] = _args[1];
747         dynargs[2] = _args[2];
748         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
749     }
750 
751     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
752         bytes[] memory dynargs = new bytes[](3);
753         dynargs[0] = _args[0];
754         dynargs[1] = _args[1];
755         dynargs[2] = _args[2];
756         return oraclize_query(_datasource, dynargs, _gasLimit);
757     }
758 
759     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
760         bytes[] memory dynargs = new bytes[](4);
761         dynargs[0] = _args[0];
762         dynargs[1] = _args[1];
763         dynargs[2] = _args[2];
764         dynargs[3] = _args[3];
765         return oraclize_query(_datasource, dynargs);
766     }
767 
768     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
769         bytes[] memory dynargs = new bytes[](4);
770         dynargs[0] = _args[0];
771         dynargs[1] = _args[1];
772         dynargs[2] = _args[2];
773         dynargs[3] = _args[3];
774         return oraclize_query(_timestamp, _datasource, dynargs);
775     }
776 
777     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
778         bytes[] memory dynargs = new bytes[](4);
779         dynargs[0] = _args[0];
780         dynargs[1] = _args[1];
781         dynargs[2] = _args[2];
782         dynargs[3] = _args[3];
783         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
784     }
785 
786     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
787         bytes[] memory dynargs = new bytes[](4);
788         dynargs[0] = _args[0];
789         dynargs[1] = _args[1];
790         dynargs[2] = _args[2];
791         dynargs[3] = _args[3];
792         return oraclize_query(_datasource, dynargs, _gasLimit);
793     }
794 
795     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
796         bytes[] memory dynargs = new bytes[](5);
797         dynargs[0] = _args[0];
798         dynargs[1] = _args[1];
799         dynargs[2] = _args[2];
800         dynargs[3] = _args[3];
801         dynargs[4] = _args[4];
802         return oraclize_query(_datasource, dynargs);
803     }
804 
805     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
806         bytes[] memory dynargs = new bytes[](5);
807         dynargs[0] = _args[0];
808         dynargs[1] = _args[1];
809         dynargs[2] = _args[2];
810         dynargs[3] = _args[3];
811         dynargs[4] = _args[4];
812         return oraclize_query(_timestamp, _datasource, dynargs);
813     }
814 
815     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
816         bytes[] memory dynargs = new bytes[](5);
817         dynargs[0] = _args[0];
818         dynargs[1] = _args[1];
819         dynargs[2] = _args[2];
820         dynargs[3] = _args[3];
821         dynargs[4] = _args[4];
822         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
823     }
824 
825     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
826         bytes[] memory dynargs = new bytes[](5);
827         dynargs[0] = _args[0];
828         dynargs[1] = _args[1];
829         dynargs[2] = _args[2];
830         dynargs[3] = _args[3];
831         dynargs[4] = _args[4];
832         return oraclize_query(_datasource, dynargs, _gasLimit);
833     }
834 
835     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
836         return oraclize.setProofType(_proofP);
837     }
838 
839 
840     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
841         return oraclize.cbAddress();
842     }
843 
844     function getCodeSize(address _addr) view internal returns (uint _size) {
845         assembly {
846             _size := extcodesize(_addr)
847         }
848     }
849 
850     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
851         return oraclize.setCustomGasPrice(_gasPrice);
852     }
853 
854     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
855         return oraclize.randomDS_getSessionPubKeyHash();
856     }
857 
858     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
859         bytes memory tmp = bytes(_a);
860         uint160 iaddr = 0;
861         uint160 b1;
862         uint160 b2;
863         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
864             iaddr *= 256;
865             b1 = uint160(uint8(tmp[i]));
866             b2 = uint160(uint8(tmp[i + 1]));
867             if ((b1 >= 97) && (b1 <= 102)) {
868                 b1 -= 87;
869             } else if ((b1 >= 65) && (b1 <= 70)) {
870                 b1 -= 55;
871             } else if ((b1 >= 48) && (b1 <= 57)) {
872                 b1 -= 48;
873             }
874             if ((b2 >= 97) && (b2 <= 102)) {
875                 b2 -= 87;
876             } else if ((b2 >= 65) && (b2 <= 70)) {
877                 b2 -= 55;
878             } else if ((b2 >= 48) && (b2 <= 57)) {
879                 b2 -= 48;
880             }
881             iaddr += (b1 * 16 + b2);
882         }
883         return address(iaddr);
884     }
885 
886     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
887         bytes memory a = bytes(_a);
888         bytes memory b = bytes(_b);
889         uint minLength = a.length;
890         if (b.length < minLength) {
891             minLength = b.length;
892         }
893         for (uint i = 0; i < minLength; i ++) {
894             if (a[i] < b[i]) {
895                 return -1;
896             } else if (a[i] > b[i]) {
897                 return 1;
898             }
899         }
900         if (a.length < b.length) {
901             return -1;
902         } else if (a.length > b.length) {
903             return 1;
904         } else {
905             return 0;
906         }
907     }
908 
909     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
910         bytes memory h = bytes(_haystack);
911         bytes memory n = bytes(_needle);
912         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
913             return -1;
914         } else if (h.length > (2 ** 128 - 1)) {
915             return -1;
916         } else {
917             uint subindex = 0;
918             for (uint i = 0; i < h.length; i++) {
919                 if (h[i] == n[0]) {
920                     subindex = 1;
921                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
922                         subindex++;
923                     }
924                     if (subindex == n.length) {
925                         return int(i);
926                     }
927                 }
928             }
929             return -1;
930         }
931     }
932 
933     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
934         return strConcat(_a, _b, "", "", "");
935     }
936 
937     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
938         return strConcat(_a, _b, _c, "", "");
939     }
940 
941     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
942         return strConcat(_a, _b, _c, _d, "");
943     }
944 
945     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
946         bytes memory _ba = bytes(_a);
947         bytes memory _bb = bytes(_b);
948         bytes memory _bc = bytes(_c);
949         bytes memory _bd = bytes(_d);
950         bytes memory _be = bytes(_e);
951         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
952         bytes memory babcde = bytes(abcde);
953         uint k = 0;
954         uint i = 0;
955         for (i = 0; i < _ba.length; i++) {
956             babcde[k++] = _ba[i];
957         }
958         for (i = 0; i < _bb.length; i++) {
959             babcde[k++] = _bb[i];
960         }
961         for (i = 0; i < _bc.length; i++) {
962             babcde[k++] = _bc[i];
963         }
964         for (i = 0; i < _bd.length; i++) {
965             babcde[k++] = _bd[i];
966         }
967         for (i = 0; i < _be.length; i++) {
968             babcde[k++] = _be[i];
969         }
970         return string(babcde);
971     }
972 
973     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
974         return safeParseInt(_a, 0);
975     }
976 
977     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
978         bytes memory bresult = bytes(_a);
979         uint mint = 0;
980         bool decimals = false;
981         for (uint i = 0; i < bresult.length; i++) {
982             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
983                 if (decimals) {
984                    if (_b == 0) break;
985                     else _b--;
986                 }
987                 mint *= 10;
988                 mint += uint(uint8(bresult[i])) - 48;
989             } else if (uint(uint8(bresult[i])) == 46) {
990                  decimals = true;
991             } else {
992                 revert("Non-numeral character encountered in string!");
993             }
994         }
995         if (_b > 0) {
996             mint *= 10 ** _b;
997         }
998         return mint;
999     }
1000 
1001     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
1002         return parseInt(_a, 0);
1003     }
1004 
1005     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1006         bytes memory bresult = bytes(_a);
1007         uint mint = 0;
1008         bool decimals = false;
1009         for (uint i = 0; i < bresult.length; i++) {
1010             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1011                 if (decimals) {
1012                    if (_b == 0) {
1013                        break;
1014                    } else {
1015                        _b--;
1016                    }
1017                 }
1018                 mint *= 10;
1019                 mint += uint(uint8(bresult[i])) - 48;
1020             } else if (uint(uint8(bresult[i])) == 46) {
1021                 decimals = true;
1022             }
1023         }
1024         if (_b > 0) {
1025             mint *= 10 ** _b;
1026         }
1027         return mint;
1028     }
1029 
1030     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1031         if (_i == 0) {
1032             return "0";
1033         }
1034         uint j = _i;
1035         uint len;
1036         while (j != 0) {
1037             len++;
1038             j /= 10;
1039         }
1040         bytes memory bstr = new bytes(len);
1041         uint k = len - 1;
1042         while (_i != 0) {
1043             bstr[k--] = byte(uint8(48 + _i % 10));
1044             _i /= 10;
1045         }
1046         return string(bstr);
1047     }
1048 
1049     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1050         safeMemoryCleaner();
1051         Buffer.buffer memory buf;
1052         Buffer.init(buf, 1024);
1053         buf.startArray();
1054         for (uint i = 0; i < _arr.length; i++) {
1055             buf.encodeString(_arr[i]);
1056         }
1057         buf.endSequence();
1058         return buf.buf;
1059     }
1060 
1061     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1062         safeMemoryCleaner();
1063         Buffer.buffer memory buf;
1064         Buffer.init(buf, 1024);
1065         buf.startArray();
1066         for (uint i = 0; i < _arr.length; i++) {
1067             buf.encodeBytes(_arr[i]);
1068         }
1069         buf.endSequence();
1070         return buf.buf;
1071     }
1072 
1073     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1074         require((_nbytes > 0) && (_nbytes <= 32));
1075         _delay *= 10; // Convert from seconds to ledger timer ticks
1076         bytes memory nbytes = new bytes(1);
1077         nbytes[0] = byte(uint8(_nbytes));
1078         bytes memory unonce = new bytes(32);
1079         bytes memory sessionKeyHash = new bytes(32);
1080         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1081         assembly {
1082             mstore(unonce, 0x20)
1083             /*
1084              The following variables can be relaxed.
1085              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1086              for an idea on how to override and replace commit hash variables.
1087             */
1088             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1089             mstore(sessionKeyHash, 0x20)
1090             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1091         }
1092         bytes memory delay = new bytes(32);
1093         assembly {
1094             mstore(add(delay, 0x20), _delay)
1095         }
1096         bytes memory delay_bytes8 = new bytes(8);
1097         copyBytes(delay, 24, 8, delay_bytes8, 0);
1098         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1099         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1100         bytes memory delay_bytes8_left = new bytes(8);
1101         assembly {
1102             let x := mload(add(delay_bytes8, 0x20))
1103             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1104             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1105             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1106             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1107             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1108             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1109             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1110             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1111         }
1112         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1113         return queryId;
1114     }
1115 
1116     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1117         oraclize_randomDS_args[_queryId] = _commitment;
1118     }
1119 
1120     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1121         bool sigok;
1122         address signer;
1123         bytes32 sigr;
1124         bytes32 sigs;
1125         bytes memory sigr_ = new bytes(32);
1126         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1127         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1128         bytes memory sigs_ = new bytes(32);
1129         offset += 32 + 2;
1130         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1131         assembly {
1132             sigr := mload(add(sigr_, 32))
1133             sigs := mload(add(sigs_, 32))
1134         }
1135         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1136         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1137             return true;
1138         } else {
1139             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1140             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1141         }
1142     }
1143 
1144     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1145         bool sigok;
1146         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1147         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1148         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1149         bytes memory appkey1_pubkey = new bytes(64);
1150         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1151         bytes memory tosign2 = new bytes(1 + 65 + 32);
1152         tosign2[0] = byte(uint8(1)); //role
1153         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1154         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1155         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1156         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1157         if (!sigok) {
1158             return false;
1159         }
1160         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1161         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1162         bytes memory tosign3 = new bytes(1 + 65);
1163         tosign3[0] = 0xFE;
1164         copyBytes(_proof, 3, 65, tosign3, 1);
1165         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1166         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1167         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1168         return sigok;
1169     }
1170 
1171     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1172         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1173         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1174             return 1;
1175         }
1176         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1177         if (!proofVerified) {
1178             return 2;
1179         }
1180         return 0;
1181     }
1182 
1183     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1184         bool match_ = true;
1185         require(_prefix.length == _nRandomBytes);
1186         for (uint256 i = 0; i< _nRandomBytes; i++) {
1187             if (_content[i] != _prefix[i]) {
1188                 match_ = false;
1189             }
1190         }
1191         return match_;
1192     }
1193 
1194     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1195         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1196         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1197         bytes memory keyhash = new bytes(32);
1198         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1199         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1200             return false;
1201         }
1202         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1203         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1204         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1205         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1206             return false;
1207         }
1208         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1209         // This is to verify that the computed args match with the ones specified in the query.
1210         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1211         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1212         bytes memory sessionPubkey = new bytes(64);
1213         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1214         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1215         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1216         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1217             delete oraclize_randomDS_args[_queryId];
1218         } else return false;
1219         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1220         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1221         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1222         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1223             return false;
1224         }
1225         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1226         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1227             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1228         }
1229         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1230     }
1231     /*
1232      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1233     */
1234     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1235         uint minLength = _length + _toOffset;
1236         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1237         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1238         uint j = 32 + _toOffset;
1239         while (i < (32 + _fromOffset + _length)) {
1240             assembly {
1241                 let tmp := mload(add(_from, i))
1242                 mstore(add(_to, j), tmp)
1243             }
1244             i += 32;
1245             j += 32;
1246         }
1247         return _to;
1248     }
1249     /*
1250      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1251      Duplicate Solidity's ecrecover, but catching the CALL return value
1252     */
1253     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1254         /*
1255          We do our own memory management here. Solidity uses memory offset
1256          0x40 to store the current end of memory. We write past it (as
1257          writes are memory extensions), but don't update the offset so
1258          Solidity will reuse it. The memory used here is only needed for
1259          this context.
1260          FIXME: inline assembly can't access return values
1261         */
1262         bool ret;
1263         address addr;
1264         assembly {
1265             let size := mload(0x40)
1266             mstore(size, _hash)
1267             mstore(add(size, 32), _v)
1268             mstore(add(size, 64), _r)
1269             mstore(add(size, 96), _s)
1270             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1271             addr := mload(size)
1272         }
1273         return (ret, addr);
1274     }
1275     /*
1276      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1277     */
1278     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1279         bytes32 r;
1280         bytes32 s;
1281         uint8 v;
1282         if (_sig.length != 65) {
1283             return (false, address(0));
1284         }
1285         /*
1286          The signature format is a compact form of:
1287            {bytes32 r}{bytes32 s}{uint8 v}
1288          Compact means, uint8 is not padded to 32 bytes.
1289         */
1290         assembly {
1291             r := mload(add(_sig, 32))
1292             s := mload(add(_sig, 64))
1293             /*
1294              Here we are loading the last 32 bytes. We exploit the fact that
1295              'mload' will pad with zeroes if we overread.
1296              There is no 'mload8' to do this, but that would be nicer.
1297             */
1298             v := byte(0, mload(add(_sig, 96)))
1299             /*
1300               Alternative solution:
1301               'byte' is not working due to the Solidity parser, so lets
1302               use the second best option, 'and'
1303               v := and(mload(add(_sig, 65)), 255)
1304             */
1305         }
1306         /*
1307          albeit non-transactional signatures are not specified by the YP, one would expect it
1308          to match the YP range of [27, 28]
1309          geth uses [0, 1] and some clients have followed. This might change, see:
1310          https://github.com/ethereum/go-ethereum/issues/2053
1311         */
1312         if (v < 27) {
1313             v += 27;
1314         }
1315         if (v != 27 && v != 28) {
1316             return (false, address(0));
1317         }
1318         return safer_ecrecover(_hash, v, r, s);
1319     }
1320 
1321     function safeMemoryCleaner() internal pure {
1322         assembly {
1323             let fmem := mload(0x40)
1324             codecopy(fmem, codesize, sub(msize, fmem))
1325         }
1326     }
1327 }
1328 /*
1329 
1330 END ORACLIZE_API
1331 
1332 */
1333 
1334 /*
1335    swarm example
1336 */
1337 
1338 
1339 pragma solidity ^0.5.0;
1340 
1341 
1342 contract Swarmer is usingOraclize {
1343     
1344     string public swarmContent;
1345     bytes32 public result;
1346 
1347     event newOraclizeQuery(string description);
1348     event newSwarmContent(string swarmContent);
1349 
1350     function swarm() public{
1351         update();
1352     }
1353     
1354     function update() payable public {
1355         oraclize_query("swarm", "e942c86508f8a09fbc35019961301fbdaf88894ddc9b9d86060eb97b3edf81f4");
1356     }
1357     
1358 }