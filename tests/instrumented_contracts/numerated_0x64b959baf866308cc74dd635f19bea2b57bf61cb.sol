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
29 // Dummy contract only used to emit to end-user they are using wrong solc
30 contract solcChecker {
31 /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;
32 }
33 
34 contract OraclizeI {
35 
36     address public cbAddress;
37 
38     function setProofType(byte _proofType) external;
39     function setCustomGasPrice(uint _gasPrice) external;
40     function getPrice(string memory _datasource) public returns (uint _dsprice);
41     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
42     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
43     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
44     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
45     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
46     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
47     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
48     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
49 }
50 
51 contract OraclizeAddrResolverI {
52     function getAddress() public returns (address _address);
53 }
54 /*
55 
56 Begin solidity-cborutils
57 
58 https://github.com/smartcontractkit/solidity-cborutils
59 
60 MIT License
61 
62 Copyright (c) 2018 SmartContract ChainLink, Ltd.
63 
64 Permission is hereby granted, free of charge, to any person obtaining a copy
65 of this software and associated documentation files (the "Software"), to deal
66 in the Software without restriction, including without limitation the rights
67 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
68 copies of the Software, and to permit persons to whom the Software is
69 furnished to do so, subject to the following conditions:
70 
71 The above copyright notice and this permission notice shall be included in all
72 copies or substantial portions of the Software.
73 
74 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
75 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
76 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
77 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
78 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
79 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
80 SOFTWARE.
81 
82 */
83 library Buffer {
84 
85     struct buffer {
86         bytes buf;
87         uint capacity;
88     }
89 
90     function init(buffer memory _buf, uint _capacity) internal pure {
91         uint capacity = _capacity;
92         if (capacity % 32 != 0) {
93             capacity += 32 - (capacity % 32);
94         }
95         _buf.capacity = capacity; // Allocate space for the buffer data
96         assembly {
97             let ptr := mload(0x40)
98             mstore(_buf, ptr)
99             mstore(ptr, 0)
100             mstore(0x40, add(ptr, capacity))
101         }
102     }
103 
104     function resize(buffer memory _buf, uint _capacity) private pure {
105         bytes memory oldbuf = _buf.buf;
106         init(_buf, _capacity);
107         append(_buf, oldbuf);
108     }
109 
110     function max(uint _a, uint _b) private pure returns (uint _max) {
111         if (_a > _b) {
112             return _a;
113         }
114         return _b;
115     }
116     /**
117       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
118       *      would exceed the capacity of the buffer.
119       * @param _buf The buffer to append to.
120       * @param _data The data to append.
121       * @return The original buffer.
122       *
123       */
124     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
125         if (_data.length + _buf.buf.length > _buf.capacity) {
126             resize(_buf, max(_buf.capacity, _data.length) * 2);
127         }
128         uint dest;
129         uint src;
130         uint len = _data.length;
131         assembly {
132             let bufptr := mload(_buf) // Memory address of the buffer data
133             let buflen := mload(bufptr) // Length of existing buffer data
134             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
135             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
136             src := add(_data, 32)
137         }
138         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
139             assembly {
140                 mstore(dest, mload(src))
141             }
142             dest += 32;
143             src += 32;
144         }
145         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
146         assembly {
147             let srcpart := and(mload(src), not(mask))
148             let destpart := and(mload(dest), mask)
149             mstore(dest, or(destpart, srcpart))
150         }
151         return _buf;
152     }
153     /**
154       *
155       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
156       * exceed the capacity of the buffer.
157       * @param _buf The buffer to append to.
158       * @param _data The data to append.
159       * @return The original buffer.
160       *
161       */
162     function append(buffer memory _buf, uint8 _data) internal pure {
163         if (_buf.buf.length + 1 > _buf.capacity) {
164             resize(_buf, _buf.capacity * 2);
165         }
166         assembly {
167             let bufptr := mload(_buf) // Memory address of the buffer data
168             let buflen := mload(bufptr) // Length of existing buffer data
169             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
170             mstore8(dest, _data)
171             mstore(bufptr, add(buflen, 1)) // Update buffer length
172         }
173     }
174     /**
175       *
176       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
177       * exceed the capacity of the buffer.
178       * @param _buf The buffer to append to.
179       * @param _data The data to append.
180       * @return The original buffer.
181       *
182       */
183     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
184         if (_len + _buf.buf.length > _buf.capacity) {
185             resize(_buf, max(_buf.capacity, _len) * 2);
186         }
187         uint mask = 256 ** _len - 1;
188         assembly {
189             let bufptr := mload(_buf) // Memory address of the buffer data
190             let buflen := mload(bufptr) // Length of existing buffer data
191             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
192             mstore(dest, or(and(mload(dest), not(mask)), _data))
193             mstore(bufptr, add(buflen, _len)) // Update buffer length
194         }
195         return _buf;
196     }
197 }
198 
199 library CBOR {
200 
201     using Buffer for Buffer.buffer;
202 
203     uint8 private constant MAJOR_TYPE_INT = 0;
204     uint8 private constant MAJOR_TYPE_MAP = 5;
205     uint8 private constant MAJOR_TYPE_BYTES = 2;
206     uint8 private constant MAJOR_TYPE_ARRAY = 4;
207     uint8 private constant MAJOR_TYPE_STRING = 3;
208     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
209     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
210 
211     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
212         if (_value <= 23) {
213             _buf.append(uint8((_major << 5) | _value));
214         } else if (_value <= 0xFF) {
215             _buf.append(uint8((_major << 5) | 24));
216             _buf.appendInt(_value, 1);
217         } else if (_value <= 0xFFFF) {
218             _buf.append(uint8((_major << 5) | 25));
219             _buf.appendInt(_value, 2);
220         } else if (_value <= 0xFFFFFFFF) {
221             _buf.append(uint8((_major << 5) | 26));
222             _buf.appendInt(_value, 4);
223         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
224             _buf.append(uint8((_major << 5) | 27));
225             _buf.appendInt(_value, 8);
226         }
227     }
228 
229     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
230         _buf.append(uint8((_major << 5) | 31));
231     }
232 
233     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
234         encodeType(_buf, MAJOR_TYPE_INT, _value);
235     }
236 
237     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
238         if (_value >= 0) {
239             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
240         } else {
241             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
242         }
243     }
244 
245     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
246         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
247         _buf.append(_value);
248     }
249 
250     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
251         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
252         _buf.append(bytes(_value));
253     }
254 
255     function startArray(Buffer.buffer memory _buf) internal pure {
256         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
257     }
258 
259     function startMap(Buffer.buffer memory _buf) internal pure {
260         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
261     }
262 
263     function endSequence(Buffer.buffer memory _buf) internal pure {
264         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
265     }
266 }
267 /*
268 
269 End solidity-cborutils
270 
271 */
272 contract usingOraclize {
273 
274     using CBOR for Buffer.buffer;
275 
276     OraclizeI oraclize;
277     OraclizeAddrResolverI OAR;
278 
279     uint constant day = 60 * 60 * 24;
280     uint constant week = 60 * 60 * 24 * 7;
281     uint constant month = 60 * 60 * 24 * 30;
282 
283     byte constant proofType_NONE = 0x00;
284     byte constant proofType_Ledger = 0x30;
285     byte constant proofType_Native = 0xF0;
286     byte constant proofStorage_IPFS = 0x01;
287     byte constant proofType_Android = 0x40;
288     byte constant proofType_TLSNotary = 0x10;
289 
290     string oraclize_network_name;
291     uint8 constant networkID_auto = 0;
292     uint8 constant networkID_morden = 2;
293     uint8 constant networkID_mainnet = 1;
294     uint8 constant networkID_testnet = 2;
295     uint8 constant networkID_consensys = 161;
296 
297     mapping(bytes32 => bytes32) oraclize_randomDS_args;
298     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
299 
300     modifier oraclizeAPI {
301         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
302             oraclize_setNetwork(networkID_auto);
303         }
304         if (address(oraclize) != OAR.getAddress()) {
305             oraclize = OraclizeI(OAR.getAddress());
306         }
307         _;
308     }
309 
310     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
311         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
312         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
313         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
314         require(proofVerified);
315         _;
316     }
317 
318     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
319       return oraclize_setNetwork();
320       _networkID; // silence the warning and remain backwards compatible
321     }
322 
323     function oraclize_setNetworkName(string memory _network_name) internal {
324         oraclize_network_name = _network_name;
325     }
326 
327     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
328         return oraclize_network_name;
329     }
330 
331     function oraclize_setNetwork() internal returns (bool _networkSet) {
332         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
333             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
334             oraclize_setNetworkName("eth_mainnet");
335             return true;
336         }
337         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
338             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
339             oraclize_setNetworkName("eth_ropsten3");
340             return true;
341         }
342         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
343             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
344             oraclize_setNetworkName("eth_kovan");
345             return true;
346         }
347         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
348             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
349             oraclize_setNetworkName("eth_rinkeby");
350             return true;
351         }
352         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
353             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
354             return true;
355         }
356         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
357             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
358             return true;
359         }
360         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
361             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
362             return true;
363         }
364         return false;
365     }
366 
367     function __callback(bytes32 _myid, string memory _result) public {
368         __callback(_myid, _result, new bytes(0));
369     }
370 
371     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
372       return;
373       _myid; _result; _proof; // Silence compiler warnings
374     }
375 
376     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
377         return oraclize.getPrice(_datasource);
378     }
379 
380     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
381         return oraclize.getPrice(_datasource, _gasLimit);
382     }
383 
384     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
385         uint price = oraclize.getPrice(_datasource);
386         if (price > 1 ether + tx.gasprice * 200000) {
387             return 0; // Unexpectedly high price
388         }
389         return oraclize.query.value(price)(0, _datasource, _arg);
390     }
391 
392     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
393         uint price = oraclize.getPrice(_datasource);
394         if (price > 1 ether + tx.gasprice * 200000) {
395             return 0; // Unexpectedly high price
396         }
397         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
398     }
399 
400     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
401         uint price = oraclize.getPrice(_datasource,_gasLimit);
402         if (price > 1 ether + tx.gasprice * _gasLimit) {
403             return 0; // Unexpectedly high price
404         }
405         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
406     }
407 
408     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
409         uint price = oraclize.getPrice(_datasource, _gasLimit);
410         if (price > 1 ether + tx.gasprice * _gasLimit) {
411            return 0; // Unexpectedly high price
412         }
413         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
414     }
415 
416     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
417         uint price = oraclize.getPrice(_datasource);
418         if (price > 1 ether + tx.gasprice * 200000) {
419             return 0; // Unexpectedly high price
420         }
421         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
422     }
423 
424     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
425         uint price = oraclize.getPrice(_datasource);
426         if (price > 1 ether + tx.gasprice * 200000) {
427             return 0; // Unexpectedly high price
428         }
429         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
430     }
431 
432     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
433         uint price = oraclize.getPrice(_datasource, _gasLimit);
434         if (price > 1 ether + tx.gasprice * _gasLimit) {
435             return 0; // Unexpectedly high price
436         }
437         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
438     }
439 
440     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
441         uint price = oraclize.getPrice(_datasource, _gasLimit);
442         if (price > 1 ether + tx.gasprice * _gasLimit) {
443             return 0; // Unexpectedly high price
444         }
445         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
446     }
447 
448     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
449         uint price = oraclize.getPrice(_datasource);
450         if (price > 1 ether + tx.gasprice * 200000) {
451             return 0; // Unexpectedly high price
452         }
453         bytes memory args = stra2cbor(_argN);
454         return oraclize.queryN.value(price)(0, _datasource, args);
455     }
456 
457     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
458         uint price = oraclize.getPrice(_datasource);
459         if (price > 1 ether + tx.gasprice * 200000) {
460             return 0; // Unexpectedly high price
461         }
462         bytes memory args = stra2cbor(_argN);
463         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
464     }
465 
466     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
467         uint price = oraclize.getPrice(_datasource, _gasLimit);
468         if (price > 1 ether + tx.gasprice * _gasLimit) {
469             return 0; // Unexpectedly high price
470         }
471         bytes memory args = stra2cbor(_argN);
472         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
473     }
474 
475     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
476         uint price = oraclize.getPrice(_datasource, _gasLimit);
477         if (price > 1 ether + tx.gasprice * _gasLimit) {
478             return 0; // Unexpectedly high price
479         }
480         bytes memory args = stra2cbor(_argN);
481         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
482     }
483 
484     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
485         string[] memory dynargs = new string[](1);
486         dynargs[0] = _args[0];
487         return oraclize_query(_datasource, dynargs);
488     }
489 
490     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
491         string[] memory dynargs = new string[](1);
492         dynargs[0] = _args[0];
493         return oraclize_query(_timestamp, _datasource, dynargs);
494     }
495 
496     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
497         string[] memory dynargs = new string[](1);
498         dynargs[0] = _args[0];
499         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
500     }
501 
502     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
503         string[] memory dynargs = new string[](1);
504         dynargs[0] = _args[0];
505         return oraclize_query(_datasource, dynargs, _gasLimit);
506     }
507 
508     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
509         string[] memory dynargs = new string[](2);
510         dynargs[0] = _args[0];
511         dynargs[1] = _args[1];
512         return oraclize_query(_datasource, dynargs);
513     }
514 
515     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
516         string[] memory dynargs = new string[](2);
517         dynargs[0] = _args[0];
518         dynargs[1] = _args[1];
519         return oraclize_query(_timestamp, _datasource, dynargs);
520     }
521 
522     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
523         string[] memory dynargs = new string[](2);
524         dynargs[0] = _args[0];
525         dynargs[1] = _args[1];
526         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
527     }
528 
529     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
530         string[] memory dynargs = new string[](2);
531         dynargs[0] = _args[0];
532         dynargs[1] = _args[1];
533         return oraclize_query(_datasource, dynargs, _gasLimit);
534     }
535 
536     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
537         string[] memory dynargs = new string[](3);
538         dynargs[0] = _args[0];
539         dynargs[1] = _args[1];
540         dynargs[2] = _args[2];
541         return oraclize_query(_datasource, dynargs);
542     }
543 
544     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
545         string[] memory dynargs = new string[](3);
546         dynargs[0] = _args[0];
547         dynargs[1] = _args[1];
548         dynargs[2] = _args[2];
549         return oraclize_query(_timestamp, _datasource, dynargs);
550     }
551 
552     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
553         string[] memory dynargs = new string[](3);
554         dynargs[0] = _args[0];
555         dynargs[1] = _args[1];
556         dynargs[2] = _args[2];
557         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
558     }
559 
560     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
561         string[] memory dynargs = new string[](3);
562         dynargs[0] = _args[0];
563         dynargs[1] = _args[1];
564         dynargs[2] = _args[2];
565         return oraclize_query(_datasource, dynargs, _gasLimit);
566     }
567 
568     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
569         string[] memory dynargs = new string[](4);
570         dynargs[0] = _args[0];
571         dynargs[1] = _args[1];
572         dynargs[2] = _args[2];
573         dynargs[3] = _args[3];
574         return oraclize_query(_datasource, dynargs);
575     }
576 
577     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
578         string[] memory dynargs = new string[](4);
579         dynargs[0] = _args[0];
580         dynargs[1] = _args[1];
581         dynargs[2] = _args[2];
582         dynargs[3] = _args[3];
583         return oraclize_query(_timestamp, _datasource, dynargs);
584     }
585 
586     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
587         string[] memory dynargs = new string[](4);
588         dynargs[0] = _args[0];
589         dynargs[1] = _args[1];
590         dynargs[2] = _args[2];
591         dynargs[3] = _args[3];
592         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
593     }
594 
595     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
596         string[] memory dynargs = new string[](4);
597         dynargs[0] = _args[0];
598         dynargs[1] = _args[1];
599         dynargs[2] = _args[2];
600         dynargs[3] = _args[3];
601         return oraclize_query(_datasource, dynargs, _gasLimit);
602     }
603 
604     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
605         string[] memory dynargs = new string[](5);
606         dynargs[0] = _args[0];
607         dynargs[1] = _args[1];
608         dynargs[2] = _args[2];
609         dynargs[3] = _args[3];
610         dynargs[4] = _args[4];
611         return oraclize_query(_datasource, dynargs);
612     }
613 
614     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
615         string[] memory dynargs = new string[](5);
616         dynargs[0] = _args[0];
617         dynargs[1] = _args[1];
618         dynargs[2] = _args[2];
619         dynargs[3] = _args[3];
620         dynargs[4] = _args[4];
621         return oraclize_query(_timestamp, _datasource, dynargs);
622     }
623 
624     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
625         string[] memory dynargs = new string[](5);
626         dynargs[0] = _args[0];
627         dynargs[1] = _args[1];
628         dynargs[2] = _args[2];
629         dynargs[3] = _args[3];
630         dynargs[4] = _args[4];
631         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
632     }
633 
634     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
635         string[] memory dynargs = new string[](5);
636         dynargs[0] = _args[0];
637         dynargs[1] = _args[1];
638         dynargs[2] = _args[2];
639         dynargs[3] = _args[3];
640         dynargs[4] = _args[4];
641         return oraclize_query(_datasource, dynargs, _gasLimit);
642     }
643 
644     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
645         uint price = oraclize.getPrice(_datasource);
646         if (price > 1 ether + tx.gasprice * 200000) {
647             return 0; // Unexpectedly high price
648         }
649         bytes memory args = ba2cbor(_argN);
650         return oraclize.queryN.value(price)(0, _datasource, args);
651     }
652 
653     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
654         uint price = oraclize.getPrice(_datasource);
655         if (price > 1 ether + tx.gasprice * 200000) {
656             return 0; // Unexpectedly high price
657         }
658         bytes memory args = ba2cbor(_argN);
659         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
660     }
661 
662     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
663         uint price = oraclize.getPrice(_datasource, _gasLimit);
664         if (price > 1 ether + tx.gasprice * _gasLimit) {
665             return 0; // Unexpectedly high price
666         }
667         bytes memory args = ba2cbor(_argN);
668         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
669     }
670 
671     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
672         uint price = oraclize.getPrice(_datasource, _gasLimit);
673         if (price > 1 ether + tx.gasprice * _gasLimit) {
674             return 0; // Unexpectedly high price
675         }
676         bytes memory args = ba2cbor(_argN);
677         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
678     }
679 
680     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
681         bytes[] memory dynargs = new bytes[](1);
682         dynargs[0] = _args[0];
683         return oraclize_query(_datasource, dynargs);
684     }
685 
686     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
687         bytes[] memory dynargs = new bytes[](1);
688         dynargs[0] = _args[0];
689         return oraclize_query(_timestamp, _datasource, dynargs);
690     }
691 
692     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
693         bytes[] memory dynargs = new bytes[](1);
694         dynargs[0] = _args[0];
695         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
696     }
697 
698     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
699         bytes[] memory dynargs = new bytes[](1);
700         dynargs[0] = _args[0];
701         return oraclize_query(_datasource, dynargs, _gasLimit);
702     }
703 
704     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
705         bytes[] memory dynargs = new bytes[](2);
706         dynargs[0] = _args[0];
707         dynargs[1] = _args[1];
708         return oraclize_query(_datasource, dynargs);
709     }
710 
711     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
712         bytes[] memory dynargs = new bytes[](2);
713         dynargs[0] = _args[0];
714         dynargs[1] = _args[1];
715         return oraclize_query(_timestamp, _datasource, dynargs);
716     }
717 
718     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
719         bytes[] memory dynargs = new bytes[](2);
720         dynargs[0] = _args[0];
721         dynargs[1] = _args[1];
722         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
723     }
724 
725     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
726         bytes[] memory dynargs = new bytes[](2);
727         dynargs[0] = _args[0];
728         dynargs[1] = _args[1];
729         return oraclize_query(_datasource, dynargs, _gasLimit);
730     }
731 
732     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
733         bytes[] memory dynargs = new bytes[](3);
734         dynargs[0] = _args[0];
735         dynargs[1] = _args[1];
736         dynargs[2] = _args[2];
737         return oraclize_query(_datasource, dynargs);
738     }
739 
740     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
741         bytes[] memory dynargs = new bytes[](3);
742         dynargs[0] = _args[0];
743         dynargs[1] = _args[1];
744         dynargs[2] = _args[2];
745         return oraclize_query(_timestamp, _datasource, dynargs);
746     }
747 
748     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
749         bytes[] memory dynargs = new bytes[](3);
750         dynargs[0] = _args[0];
751         dynargs[1] = _args[1];
752         dynargs[2] = _args[2];
753         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
754     }
755 
756     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
757         bytes[] memory dynargs = new bytes[](3);
758         dynargs[0] = _args[0];
759         dynargs[1] = _args[1];
760         dynargs[2] = _args[2];
761         return oraclize_query(_datasource, dynargs, _gasLimit);
762     }
763 
764     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
765         bytes[] memory dynargs = new bytes[](4);
766         dynargs[0] = _args[0];
767         dynargs[1] = _args[1];
768         dynargs[2] = _args[2];
769         dynargs[3] = _args[3];
770         return oraclize_query(_datasource, dynargs);
771     }
772 
773     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
774         bytes[] memory dynargs = new bytes[](4);
775         dynargs[0] = _args[0];
776         dynargs[1] = _args[1];
777         dynargs[2] = _args[2];
778         dynargs[3] = _args[3];
779         return oraclize_query(_timestamp, _datasource, dynargs);
780     }
781 
782     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
783         bytes[] memory dynargs = new bytes[](4);
784         dynargs[0] = _args[0];
785         dynargs[1] = _args[1];
786         dynargs[2] = _args[2];
787         dynargs[3] = _args[3];
788         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
789     }
790 
791     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
792         bytes[] memory dynargs = new bytes[](4);
793         dynargs[0] = _args[0];
794         dynargs[1] = _args[1];
795         dynargs[2] = _args[2];
796         dynargs[3] = _args[3];
797         return oraclize_query(_datasource, dynargs, _gasLimit);
798     }
799 
800     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
801         bytes[] memory dynargs = new bytes[](5);
802         dynargs[0] = _args[0];
803         dynargs[1] = _args[1];
804         dynargs[2] = _args[2];
805         dynargs[3] = _args[3];
806         dynargs[4] = _args[4];
807         return oraclize_query(_datasource, dynargs);
808     }
809 
810     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
811         bytes[] memory dynargs = new bytes[](5);
812         dynargs[0] = _args[0];
813         dynargs[1] = _args[1];
814         dynargs[2] = _args[2];
815         dynargs[3] = _args[3];
816         dynargs[4] = _args[4];
817         return oraclize_query(_timestamp, _datasource, dynargs);
818     }
819 
820     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
821         bytes[] memory dynargs = new bytes[](5);
822         dynargs[0] = _args[0];
823         dynargs[1] = _args[1];
824         dynargs[2] = _args[2];
825         dynargs[3] = _args[3];
826         dynargs[4] = _args[4];
827         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
828     }
829 
830     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
831         bytes[] memory dynargs = new bytes[](5);
832         dynargs[0] = _args[0];
833         dynargs[1] = _args[1];
834         dynargs[2] = _args[2];
835         dynargs[3] = _args[3];
836         dynargs[4] = _args[4];
837         return oraclize_query(_datasource, dynargs, _gasLimit);
838     }
839 
840     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
841         return oraclize.setProofType(_proofP);
842     }
843 
844 
845     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
846         return oraclize.cbAddress();
847     }
848 
849     function getCodeSize(address _addr) view internal returns (uint _size) {
850         assembly {
851             _size := extcodesize(_addr)
852         }
853     }
854 
855     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
856         return oraclize.setCustomGasPrice(_gasPrice);
857     }
858 
859     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
860         return oraclize.randomDS_getSessionPubKeyHash();
861     }
862 
863     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
864         bytes memory tmp = bytes(_a);
865         uint160 iaddr = 0;
866         uint160 b1;
867         uint160 b2;
868         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
869             iaddr *= 256;
870             b1 = uint160(uint8(tmp[i]));
871             b2 = uint160(uint8(tmp[i + 1]));
872             if ((b1 >= 97) && (b1 <= 102)) {
873                 b1 -= 87;
874             } else if ((b1 >= 65) && (b1 <= 70)) {
875                 b1 -= 55;
876             } else if ((b1 >= 48) && (b1 <= 57)) {
877                 b1 -= 48;
878             }
879             if ((b2 >= 97) && (b2 <= 102)) {
880                 b2 -= 87;
881             } else if ((b2 >= 65) && (b2 <= 70)) {
882                 b2 -= 55;
883             } else if ((b2 >= 48) && (b2 <= 57)) {
884                 b2 -= 48;
885             }
886             iaddr += (b1 * 16 + b2);
887         }
888         return address(iaddr);
889     }
890 
891     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
892         bytes memory a = bytes(_a);
893         bytes memory b = bytes(_b);
894         uint minLength = a.length;
895         if (b.length < minLength) {
896             minLength = b.length;
897         }
898         for (uint i = 0; i < minLength; i ++) {
899             if (a[i] < b[i]) {
900                 return -1;
901             } else if (a[i] > b[i]) {
902                 return 1;
903             }
904         }
905         if (a.length < b.length) {
906             return -1;
907         } else if (a.length > b.length) {
908             return 1;
909         } else {
910             return 0;
911         }
912     }
913 
914     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
915         bytes memory h = bytes(_haystack);
916         bytes memory n = bytes(_needle);
917         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
918             return -1;
919         } else if (h.length > (2 ** 128 - 1)) {
920             return -1;
921         } else {
922             uint subindex = 0;
923             for (uint i = 0; i < h.length; i++) {
924                 if (h[i] == n[0]) {
925                     subindex = 1;
926                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
927                         subindex++;
928                     }
929                     if (subindex == n.length) {
930                         return int(i);
931                     }
932                 }
933             }
934             return -1;
935         }
936     }
937 
938     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
939         return strConcat(_a, _b, "", "", "");
940     }
941 
942     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
943         return strConcat(_a, _b, _c, "", "");
944     }
945 
946     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
947         return strConcat(_a, _b, _c, _d, "");
948     }
949 
950     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
951         bytes memory _ba = bytes(_a);
952         bytes memory _bb = bytes(_b);
953         bytes memory _bc = bytes(_c);
954         bytes memory _bd = bytes(_d);
955         bytes memory _be = bytes(_e);
956         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
957         bytes memory babcde = bytes(abcde);
958         uint k = 0;
959         uint i = 0;
960         for (i = 0; i < _ba.length; i++) {
961             babcde[k++] = _ba[i];
962         }
963         for (i = 0; i < _bb.length; i++) {
964             babcde[k++] = _bb[i];
965         }
966         for (i = 0; i < _bc.length; i++) {
967             babcde[k++] = _bc[i];
968         }
969         for (i = 0; i < _bd.length; i++) {
970             babcde[k++] = _bd[i];
971         }
972         for (i = 0; i < _be.length; i++) {
973             babcde[k++] = _be[i];
974         }
975         return string(babcde);
976     }
977 
978     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
979         return safeParseInt(_a, 0);
980     }
981 
982     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
983         bytes memory bresult = bytes(_a);
984         uint mint = 0;
985         bool decimals = false;
986         for (uint i = 0; i < bresult.length; i++) {
987             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
988                 if (decimals) {
989                    if (_b == 0) break;
990                     else _b--;
991                 }
992                 mint *= 10;
993                 mint += uint(uint8(bresult[i])) - 48;
994             } else if (uint(uint8(bresult[i])) == 46) {
995                 require(!decimals, 'More than one decimal encountered in string!');
996                 decimals = true;
997             } else {
998                 revert("Non-numeral character encountered in string!");
999             }
1000         }
1001         if (_b > 0) {
1002             mint *= 10 ** _b;
1003         }
1004         return mint;
1005     }
1006 
1007     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
1008         return parseInt(_a, 0);
1009     }
1010 
1011     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1012         bytes memory bresult = bytes(_a);
1013         uint mint = 0;
1014         bool decimals = false;
1015         for (uint i = 0; i < bresult.length; i++) {
1016             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1017                 if (decimals) {
1018                    if (_b == 0) {
1019                        break;
1020                    } else {
1021                        _b--;
1022                    }
1023                 }
1024                 mint *= 10;
1025                 mint += uint(uint8(bresult[i])) - 48;
1026             } else if (uint(uint8(bresult[i])) == 46) {
1027                 decimals = true;
1028             }
1029         }
1030         if (_b > 0) {
1031             mint *= 10 ** _b;
1032         }
1033         return mint;
1034     }
1035 
1036     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1037         if (_i == 0) {
1038             return "0";
1039         }
1040         uint j = _i;
1041         uint len;
1042         while (j != 0) {
1043             len++;
1044             j /= 10;
1045         }
1046         bytes memory bstr = new bytes(len);
1047         uint k = len - 1;
1048         while (_i != 0) {
1049             bstr[k--] = byte(uint8(48 + _i % 10));
1050             _i /= 10;
1051         }
1052         return string(bstr);
1053     }
1054 
1055     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1056         safeMemoryCleaner();
1057         Buffer.buffer memory buf;
1058         Buffer.init(buf, 1024);
1059         buf.startArray();
1060         for (uint i = 0; i < _arr.length; i++) {
1061             buf.encodeString(_arr[i]);
1062         }
1063         buf.endSequence();
1064         return buf.buf;
1065     }
1066 
1067     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1068         safeMemoryCleaner();
1069         Buffer.buffer memory buf;
1070         Buffer.init(buf, 1024);
1071         buf.startArray();
1072         for (uint i = 0; i < _arr.length; i++) {
1073             buf.encodeBytes(_arr[i]);
1074         }
1075         buf.endSequence();
1076         return buf.buf;
1077     }
1078 
1079     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1080         require((_nbytes > 0) && (_nbytes <= 32));
1081         _delay *= 10; // Convert from seconds to ledger timer ticks
1082         bytes memory nbytes = new bytes(1);
1083         nbytes[0] = byte(uint8(_nbytes));
1084         bytes memory unonce = new bytes(32);
1085         bytes memory sessionKeyHash = new bytes(32);
1086         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1087         assembly {
1088             mstore(unonce, 0x20)
1089             /*
1090              The following variables can be relaxed.
1091              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1092              for an idea on how to override and replace commit hash variables.
1093             */
1094             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1095             mstore(sessionKeyHash, 0x20)
1096             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1097         }
1098         bytes memory delay = new bytes(32);
1099         assembly {
1100             mstore(add(delay, 0x20), _delay)
1101         }
1102         bytes memory delay_bytes8 = new bytes(8);
1103         copyBytes(delay, 24, 8, delay_bytes8, 0);
1104         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1105         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1106         bytes memory delay_bytes8_left = new bytes(8);
1107         assembly {
1108             let x := mload(add(delay_bytes8, 0x20))
1109             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1110             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1111             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1112             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1113             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1114             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1115             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1116             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1117         }
1118         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1119         return queryId;
1120     }
1121 
1122     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1123         oraclize_randomDS_args[_queryId] = _commitment;
1124     }
1125 
1126     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1127         bool sigok;
1128         address signer;
1129         bytes32 sigr;
1130         bytes32 sigs;
1131         bytes memory sigr_ = new bytes(32);
1132         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1133         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1134         bytes memory sigs_ = new bytes(32);
1135         offset += 32 + 2;
1136         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1137         assembly {
1138             sigr := mload(add(sigr_, 32))
1139             sigs := mload(add(sigs_, 32))
1140         }
1141         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1142         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1143             return true;
1144         } else {
1145             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1146             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1147         }
1148     }
1149 
1150     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1151         bool sigok;
1152         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1153         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1154         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1155         bytes memory appkey1_pubkey = new bytes(64);
1156         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1157         bytes memory tosign2 = new bytes(1 + 65 + 32);
1158         tosign2[0] = byte(uint8(1)); //role
1159         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1160         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1161         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1162         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1163         if (!sigok) {
1164             return false;
1165         }
1166         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1167         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1168         bytes memory tosign3 = new bytes(1 + 65);
1169         tosign3[0] = 0xFE;
1170         copyBytes(_proof, 3, 65, tosign3, 1);
1171         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1172         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1173         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1174         return sigok;
1175     }
1176 
1177     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1178         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1179         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1180             return 1;
1181         }
1182         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1183         if (!proofVerified) {
1184             return 2;
1185         }
1186         return 0;
1187     }
1188 
1189     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1190         bool match_ = true;
1191         require(_prefix.length == _nRandomBytes);
1192         for (uint256 i = 0; i< _nRandomBytes; i++) {
1193             if (_content[i] != _prefix[i]) {
1194                 match_ = false;
1195             }
1196         }
1197         return match_;
1198     }
1199 
1200     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1201         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1202         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1203         bytes memory keyhash = new bytes(32);
1204         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1205         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1206             return false;
1207         }
1208         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1209         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1210         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1211         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1212             return false;
1213         }
1214         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1215         // This is to verify that the computed args match with the ones specified in the query.
1216         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1217         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1218         bytes memory sessionPubkey = new bytes(64);
1219         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1220         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1221         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1222         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1223             delete oraclize_randomDS_args[_queryId];
1224         } else return false;
1225         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1226         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1227         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1228         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1229             return false;
1230         }
1231         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1232         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1233             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1234         }
1235         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1236     }
1237     /*
1238      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1239     */
1240     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1241         uint minLength = _length + _toOffset;
1242         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1243         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1244         uint j = 32 + _toOffset;
1245         while (i < (32 + _fromOffset + _length)) {
1246             assembly {
1247                 let tmp := mload(add(_from, i))
1248                 mstore(add(_to, j), tmp)
1249             }
1250             i += 32;
1251             j += 32;
1252         }
1253         return _to;
1254     }
1255     /*
1256      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1257      Duplicate Solidity's ecrecover, but catching the CALL return value
1258     */
1259     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1260         /*
1261          We do our own memory management here. Solidity uses memory offset
1262          0x40 to store the current end of memory. We write past it (as
1263          writes are memory extensions), but don't update the offset so
1264          Solidity will reuse it. The memory used here is only needed for
1265          this context.
1266          FIXME: inline assembly can't access return values
1267         */
1268         bool ret;
1269         address addr;
1270         assembly {
1271             let size := mload(0x40)
1272             mstore(size, _hash)
1273             mstore(add(size, 32), _v)
1274             mstore(add(size, 64), _r)
1275             mstore(add(size, 96), _s)
1276             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1277             addr := mload(size)
1278         }
1279         return (ret, addr);
1280     }
1281     /*
1282      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1283     */
1284     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1285         bytes32 r;
1286         bytes32 s;
1287         uint8 v;
1288         if (_sig.length != 65) {
1289             return (false, address(0));
1290         }
1291         /*
1292          The signature format is a compact form of:
1293            {bytes32 r}{bytes32 s}{uint8 v}
1294          Compact means, uint8 is not padded to 32 bytes.
1295         */
1296         assembly {
1297             r := mload(add(_sig, 32))
1298             s := mload(add(_sig, 64))
1299             /*
1300              Here we are loading the last 32 bytes. We exploit the fact that
1301              'mload' will pad with zeroes if we overread.
1302              There is no 'mload8' to do this, but that would be nicer.
1303             */
1304             v := byte(0, mload(add(_sig, 96)))
1305             /*
1306               Alternative solution:
1307               'byte' is not working due to the Solidity parser, so lets
1308               use the second best option, 'and'
1309               v := and(mload(add(_sig, 65)), 255)
1310             */
1311         }
1312         /*
1313          albeit non-transactional signatures are not specified by the YP, one would expect it
1314          to match the YP range of [27, 28]
1315          geth uses [0, 1] and some clients have followed. This might change, see:
1316          https://github.com/ethereum/go-ethereum/issues/2053
1317         */
1318         if (v < 27) {
1319             v += 27;
1320         }
1321         if (v != 27 && v != 28) {
1322             return (false, address(0));
1323         }
1324         return safer_ecrecover(_hash, v, r, s);
1325     }
1326 
1327     function safeMemoryCleaner() internal pure {
1328         assembly {
1329             let fmem := mload(0x40)
1330             codecopy(fmem, codesize, sub(msize, fmem))
1331         }
1332     }
1333 }
1334 /*
1335 
1336 END ORACLIZE_API
1337 
1338 */
1339 
1340 
1341 library SafeMath {
1342     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
1343         if (a == 0) {
1344             return 0;
1345         }
1346         c = a * b;
1347         assert(c / a == b);
1348         return c;
1349     }
1350 
1351     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1352         return a / b;
1353     }
1354 
1355     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1356         assert(b <= a);
1357         return a - b;
1358     }
1359 
1360     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1361         c = a + b;
1362         assert(c >= a);
1363         return c;
1364     }
1365 }
1366 
1367 contract Ownable {
1368     address payable owner; //for tokens
1369     mapping(address => bool) owners;
1370 
1371     event OwnerAdded(address indexed newOwner);
1372     event OwnerDeleted(address indexed owner);
1373 
1374     /**
1375      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1376      * account.
1377      */
1378     constructor() public {
1379         owners[msg.sender] = true;
1380         owner = msg.sender;
1381     }
1382 
1383 
1384     modifier onlyOwner() {
1385         require(isOwner(msg.sender));
1386         _;
1387     }
1388 
1389     function addOwner(address _newOwner) external onlyOwner {
1390         require(_newOwner != address(0));
1391         owners[_newOwner] = true;
1392         emit OwnerAdded(_newOwner);
1393     }
1394 
1395     function delOwner(address _owner) external onlyOwner {
1396         require(owners[_owner]);
1397         owners[_owner] = false;
1398         emit OwnerDeleted(_owner);
1399     }
1400 
1401     function isOwner(address _owner) public view returns (bool) {
1402         return owners[_owner];
1403     }
1404 }
1405 
1406 interface tokenRecipient {
1407     function receiveApproval(
1408         address _from,
1409         uint256 _value,
1410         address _token,
1411         bytes calldata _extraData
1412     ) external;
1413 }
1414 
1415 contract MCL is Ownable, usingOraclize {
1416     using SafeMath for uint256;
1417 
1418     string public name = "MCL";
1419     string public symbol = "MCL";
1420     uint8 public decimals = 18;
1421     uint256 DEC = 10 ** uint256(decimals);
1422 
1423     uint256 public totalSupply = 1000000000 * DEC;
1424     uint256 public tokensForSale = 680000000 * DEC;
1425     uint256 minPurchase = 25 ether;
1426     uint256 public curs = 120;
1427     uint256 public oraclizeBalance;
1428     uint256 public goal = 10000000 ether;
1429     uint256 public cap = 50000000 ether;
1430     uint256 public USDRaised;
1431 
1432     mapping(address => uint256) deposited;
1433     mapping(address => uint256) public balanceOf;
1434     mapping(address => mapping(address => uint256)) public allowance;
1435 
1436     event Transfer(address indexed from, address indexed to, uint256 value);
1437     event Approval(address indexed owner, address indexed spender, uint256 value);
1438     event Burn(address indexed from, uint256 value);
1439     event RefundsEnabled();
1440     event Closed();
1441     event Refunded(address indexed beneficiary, uint256 weiAmount);
1442     event LogPriceUpdated(string price);
1443     event LogNewOraclizeQuery(string description);
1444 
1445     enum State {Active, Refunding, Closed}
1446     State public state;
1447 
1448     modifier transferredIsOn {
1449         require(state == State.Closed);
1450         _;
1451     }
1452 
1453     modifier sellIsOn {
1454         require(state == State.Active);
1455         _;
1456     }
1457 
1458     constructor() public {
1459         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1460         balanceOf[msg.sender] = totalSupply;
1461         state = State.Active;
1462     }
1463 
1464     function() external payable {
1465         buyTokens(msg.sender);
1466     }
1467 
1468 
1469 
1470     function __callback(bytes32 myid, string memory result, bytes memory proof) public {
1471         myid;
1472         proof;
1473         if (msg.sender != oraclize_cbAddress()) revert();
1474         curs = parseInt(result);
1475         emit LogPriceUpdated(result);
1476         updatePrice();
1477     }
1478 
1479 
1480     function transfer(address _to, uint256 _value) transferredIsOn public {
1481         _transfer(msg.sender, _to, _value);
1482     }
1483 
1484     function transferFrom(address _from, address _to, uint256 _value) transferredIsOn public returns (bool success) {
1485         require(_value <= allowance[_from][msg.sender]);
1486         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
1487         _transfer(_from, _to, _value);
1488         return true;
1489     }
1490 
1491     function approve(address _spender, uint256 _value) public returns (bool success) {
1492         require((_value == 0) || (allowance[msg.sender][_spender] == 0));
1493 
1494         allowance[msg.sender][_spender] = _value;
1495         emit Approval(msg.sender, _spender, _value);
1496         return true;
1497     }
1498 
1499     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
1500     public
1501     returns (bool success) {
1502         tokenRecipient spender = tokenRecipient(_spender);
1503         if (approve(_spender, _value)) {
1504             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
1505             return true;
1506         }
1507     }
1508 
1509     function transferOwner(address _to, uint256 _value) onlyOwner public {
1510         _transfer(msg.sender, _to, _value);
1511     }
1512 
1513     function _transfer(address _from, address _to, uint _value) internal {
1514         require(_to != address(0));
1515         require(balanceOf[_from] >= _value);
1516         require(balanceOf[_to].add(_value) >= balanceOf[_to]);
1517         balanceOf[_from] = balanceOf[_from].sub(_value);
1518         balanceOf[_to] = balanceOf[_to].add(_value);
1519         emit Transfer(_from, _to, _value);
1520     }
1521 
1522 
1523     function buyTokens(address beneficiary) sellIsOn payable public {
1524         uint cost;
1525         uint bonus;
1526 
1527         (cost, bonus) = getCostAndBonus();
1528         uint rate = 1 ether * curs / cost;
1529         uint amount = rate.mul(msg.value);
1530 
1531         require(amount >= minPurchase && amount >= tokensForSale);
1532 
1533         amount = amount.add(amount.mul(bonus).div(100));
1534 
1535         _transfer(owner, beneficiary, amount);
1536 
1537         tokensForSale = tokensForSale.sub(amount);
1538         USDRaised = USDRaised.add(msg.value.mul(curs));
1539         deposited[beneficiary] = deposited[beneficiary].add(msg.value);
1540     }
1541 
1542 
1543     function manualSale(address beneficiary, uint amount, uint ethValue) onlyOwner public {
1544         _transfer(owner, beneficiary, amount);
1545 
1546         tokensForSale = tokensForSale.sub(amount);
1547         USDRaised = USDRaised.add(ethValue.mul(curs));
1548         deposited[beneficiary] = deposited[beneficiary].add(ethValue);
1549     }
1550 
1551     function enableRefunds() onlyOwner sellIsOn public {
1552         require(USDRaised < goal);
1553         state = State.Refunding;
1554         emit RefundsEnabled();
1555     }
1556 
1557     function close() onlyOwner public {
1558         require(USDRaised >= goal);
1559         state = State.Closed;
1560         emit Closed();
1561     }
1562 
1563     function refund(address payable investor) public {
1564         require(state == State.Refunding);
1565         require(deposited[investor] > 0);
1566         uint256 depositedValue = deposited[investor];
1567         investor.transfer(depositedValue);
1568         emit Refunded(investor, depositedValue);
1569         deposited[investor] = 0;
1570     }
1571 
1572     function withdrawBalance() onlyOwner external {
1573         require(state == State.Closed);
1574         require(address(this).balance > 0);
1575         owner.transfer(address(this).balance);
1576     }
1577 
1578     function burn(uint256 _value) public returns (bool success) {
1579         require(balanceOf[msg.sender] >= _value);
1580         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
1581         emit Burn(msg.sender, _value);
1582         return true;
1583     }
1584 
1585     function updateCurs(uint256 _value) onlyOwner public {
1586         curs = _value;
1587     }
1588 
1589 
1590     //15 March 2019 to 14 April 2019 1552597200 1555275600
1591     //15 April 2019 to 14 May 2019 1555275600 1557867600
1592     //15 May 2019 to 14 June 2019 1557867600 1560546000
1593     //15 June 2019 to 14 July 2019 1560546000 1563138000
1594     //15 July 2019 to 14 August 2019 1563138000 1565816400
1595     //15 August 2019 to 14 September 2019 1565816400 1568494800
1596 
1597     //15 September 2019 to 14 October 2019 1568494800 1571086800
1598     //15 October 2019 to 14 November 2019 1571086800 1573765200
1599     //15 November 2019 1573765200
1600 
1601     function getCostAndBonus() internal view returns(uint, uint) {
1602         uint cost;
1603         if (block.timestamp >= 1552597200 && block.timestamp < 1555275600) {
1604             cost = 10 * DEC / 100;
1605             return (cost, 30);
1606         } else if (block.timestamp >= 1555275600 && block.timestamp < 1557867600) {
1607             cost = 14 * DEC / 100;
1608             return (cost, 30);
1609         } else if (block.timestamp >= 1557867600 && block.timestamp < 1560546000) {
1610             cost = 15 * DEC / 100;
1611             return (cost, 25);
1612         } else if (block.timestamp >= 1560546000 && block.timestamp < 1563138000) {
1613             cost = 16 * DEC / 100;
1614             return (cost, 20);
1615         } else if (block.timestamp >= 1563138000 && block.timestamp < 1565816400) {
1616             cost = 17 * DEC / 100;
1617             return (cost, 15);
1618         } else if (block.timestamp >= 1565816400 && block.timestamp < 1568494800) {
1619             cost = 18 * DEC / 100;
1620             return (cost, 10);
1621         } else if (block.timestamp >= 1568494800 && block.timestamp < 1571086800) {
1622             cost = 19 * DEC / 100;
1623             return (cost, 5);
1624         } else if (block.timestamp >= 1571086800 && block.timestamp < 1573765200) {
1625             cost = 20 * DEC / 100;
1626             return (cost, 0);
1627         } else if (block.timestamp >= 1573765200) {
1628             cost = 20 * DEC / 100;
1629             return (cost, 0);
1630         } else return (0,0);
1631     }
1632 
1633     function updatePrice() sellIsOn payable public {
1634         if (oraclize_getPrice("URL") > address(this).balance) {
1635             emit LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1636         } else {
1637             emit LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1638             //43200 = 12 hour
1639             oraclize_query(43200, "URL", "json(https://api.gdax.com/products/ETH-USD/ticker).price");
1640         }
1641     }
1642 
1643     function setGasPrice(uint _newPrice) onlyOwner public {
1644         oraclize_setCustomGasPrice(_newPrice * 1 wei);
1645     }
1646 
1647     function addBalanceForOraclize() payable external {
1648         oraclizeBalance = oraclizeBalance.add(msg.value);
1649     }
1650 }