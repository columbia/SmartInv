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
27 //pragma solidity >= 0.5.0; // Incompatible compiler version - please select a compiler within the stated pragma range, or use a different version of the oraclizeAPI!
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
1340 /*
1341  * Copyright 2019 Authpaper Team
1342  *
1343  * Licensed under the Apache License, Version 2.0 (the "License");
1344  * you may not use this file except in compliance with the License.
1345  * You may obtain a copy of the License at
1346  *
1347  *      http://www.apache.org/licenses/LICENSE-2.0
1348  *
1349  * Unless required by applicable law or agreed to in writing, software
1350  * distributed under the License is distributed on an "AS IS" BASIS,
1351  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1352  * See the License for the specific language governing permissions and
1353  * limitations under the License.
1354  */
1355 pragma solidity ^0.5.3;
1356 //import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";
1357 
1358 contract Adminstrator {
1359   address public admin;
1360   address payable public owner;
1361 
1362   modifier onlyAdmin() { 
1363         require(msg.sender == admin || msg.sender == owner,"Not authorized"); 
1364         _;
1365   } 
1366 
1367   constructor() public {
1368     admin = msg.sender;
1369 	owner = msg.sender;
1370   }
1371 
1372   function transferAdmin(address newAdmin) public onlyAdmin {
1373     admin = newAdmin; 
1374   }
1375 }
1376 contract FiftyContract is Adminstrator,usingOraclize {
1377     uint public mRate = 200 finney; //membership fee
1378 	uint public membershiptime = 183 * 86400; //183 days, around 0.5 year
1379 	uint public divideRadio = 485; //The divide ratio, each uplevel will get 0.485 by default
1380 	uint public divideRadioBase = 1000;
1381 	mapping (address => uint) public membership;
1382 	mapping(address => mapping(uint => uint)) public memberOrders;
1383 	event membershipExtended(address indexed _self, uint newexpiretime);
1384 	
1385 	string public website="http://portal.globalcfo.org/getOrderVer4.php?eth=";
1386 	string[] public websiteString = ["http://portal.globalcfo.org/getOrderVer4.php?room=1&eth=",
1387 	"http://portal.globalcfo.org/getOrderVer4.php?room=2&eth=",
1388 	"http://portal.globalcfo.org/getOrderVer4.php?room=3&eth=",
1389 	"http://portal.globalcfo.org/getOrderVer4.php?room=5&eth=",
1390 	"http://portal.globalcfo.org/getOrderVer4.php?room=10&eth=",
1391 	"http://portal.globalcfo.org/getOrderVer4.php?room=50&eth="
1392 	];
1393 	mapping (bytes32 => treeNode) public oraclizeCallbacks;
1394 	
1395 	//About the tree
1396 	event completeTree(address indexed _self, uint indexed _nodeID, uint indexed _amount);
1397 	event startTree(address indexed _self, uint indexed _nodeID, uint indexed _amount);	
1398 	mapping (address => mapping (uint => uint)) public nodeIDIndex;	
1399 	mapping (address => mapping (uint => bool)) public isReatingTree;
1400 	mapping (address => mapping (uint => mapping (uint => mapping (uint => treeNode)))) public treeChildren;
1401 	mapping (address => mapping (uint => mapping (uint => treeNode))) public treeParent;
1402 	mapping (address => mapping (uint => mapping (uint => uint))) public treeCompleteTime;
1403 	//Keep the current running nodes given an address
1404 	mapping (address => mapping (uint => bool)) public currentNodes;
1405 	//Temporary direct referral
1406 	mapping (address => mapping (uint => mapping (uint => address))) public tempDirRefer;
1407 	uint public spread=2;
1408 	uint public minimumTreeNodeReferred=2;
1409 	uint[] public possibleNodeType = [1,2,3,5,10,50];
1410 	
1411 	struct treeNode {
1412 		 address payable ethAddress; 
1413 		 uint nodeType; 
1414 		 uint nodeID;
1415 	}
1416 	struct rewardDistribution {
1417 		address payable first;
1418 		address payable second;
1419 	}
1420 	
1421 	//Statistic issue
1422 	uint256 public ethIN=0;
1423 	uint256 public ethOut=0;
1424 	uint256 public receivedAmount=0;
1425 	uint256 public sentAmount=0;
1426 	bool public paused=false;
1427 	mapping (address => uint) public nodeReceivedETH;
1428 	event Paused(address account);
1429 	event Unpaused(address account);
1430 	event makeQuery(address indexed account, string msg);
1431 	event refundEvent(address indexed _self, uint sentETH, uint requireETH, uint shopID, 
1432 	address parent, address grandparent, bool isOpeningExistingRoom);
1433 	
1434 	//Setting the variables
1435 	function setMembershipFee(uint rateFinney, uint memberDays) public onlyAdmin{
1436 		require(rateFinney > 0, "new rate must be positive");
1437 		require(memberDays > 0, "new membership time must be positive");
1438 		mRate = rateFinney * 10 ** uint256(15); //In finney
1439 		membershiptime = memberDays * 86400; //In days
1440 		
1441 	}
1442 	function setTreeSpec(uint newSpread, uint newDivideRate, uint newDivideBase, 
1443 	uint newTreeNodeReferred, uint[] memory newNodeType) public onlyAdmin{
1444 		require(newSpread > 0, "new spread must > 0");
1445 		require(newDivideRate > 0, "new divide level must > 0");
1446 		require(newDivideBase > newDivideRate, "new divide level base must > ratio");
1447 		require(newTreeNodeReferred >= 1, "new min tree nodes referred by root must > 1");
1448 		require(newNodeType.length >= 1, "invalid possible node type");
1449 		spread = newSpread;
1450 		divideRadio = newDivideRate;
1451 		divideRadioBase = newDivideBase;
1452 		minimumTreeNodeReferred = newTreeNodeReferred;
1453 		possibleNodeType=newNodeType;
1454 	}
1455 	function pause(bool isPause) public onlyAdmin{
1456 		paused = isPause;
1457 		if(isPause) emit Paused(msg.sender);
1458 		else emit Unpaused(msg.sender);
1459 	}
1460 	function withdraw(uint amount) public onlyAdmin returns(bool) {
1461         require(amount < address(this).balance);
1462         owner.transfer(amount);
1463         return true;
1464     }
1465     function withdrawAll() public onlyAdmin returns(bool) {
1466         uint balanceOld = address(this).balance;
1467         owner.transfer(balanceOld);
1468         return true;
1469     }
1470 	function _addMember(address _member) internal {
1471 		require(_member != address(0));
1472 		if(membership[_member] <= now) membership[_member] = now;
1473 		membership[_member] += membershiptime;
1474 		emit membershipExtended(_member,membership[_member]);
1475 	}
1476 	function addMember(address member) public onlyAdmin {
1477 		_addMember(member);
1478 	}
1479 	function banMember(address member) public onlyAdmin {
1480 		require(member != address(0));
1481 		membership[member] = 0;
1482 	}
1483 		
1484 	function() external payable { 
1485 		require(!paused,"The contract is paused");
1486 		require(address(this).balance + msg.value > address(this).balance);
1487 		ethIN += msg.value;
1488 		//Make web call to find the shopping order
1489 		//Remember, each query burns 0.01 USD from the contract !!
1490 		string memory queryStr = strConcating(website,addressToString(msg.sender));
1491 		emit makeQuery(msg.sender,"Oraclize query sent");
1492 		bytes32 queryId=oraclize_query("URL", queryStr, 800000);
1493 		//emit makeQuery(msg.sender,queryStr);
1494 		//bytes32 queryId=bytes32("AAA");
1495         oraclizeCallbacks[queryId] = treeNode(msg.sender,msg.value,0);
1496 	}
1497 		
1498 	function __callback(bytes32 myid, string memory result) public {
1499         if (msg.sender != oraclize_cbAddress()) revert();
1500 		bytes memory _baseBytes = bytes(result);
1501 		//require(_baseBytes.length == 84 || _baseBytes.length == 105, "The return string is not valid");
1502 		treeNode memory o = oraclizeCallbacks[myid];
1503 		address payable treeRoot = o.ethAddress;
1504 		uint totalETH = o.nodeType;
1505 		require(treeRoot != address(0),"Invalid root address");
1506 		require(totalETH >= 0, "No ETH send in");
1507 		if(_baseBytes.length != 231 && _baseBytes.length != 211){
1508 			//invalid response or opening existing room, refund
1509 			distributeETH(treeRoot,treeRoot,treeRoot,totalETH,true);
1510 			emit refundEvent(treeRoot,totalETH,_baseBytes.length,0,address(0),address(0),false);
1511 			return;
1512 		}
1513 		if(_baseBytes.length == 211){
1514 			uint isReatingRoom = extractUintFromByte(_baseBytes,0,1);
1515 			address payable parentAddress = extractOneAddrFromByte(_baseBytes,1);
1516 			address payable grandAddress = extractOneAddrFromByte(_baseBytes,43);
1517 			address payable grandgrandAddress = extractOneAddrFromByte(_baseBytes,85);
1518 			address payable ghostAddress1 = extractOneAddrFromByte(_baseBytes,127);
1519 			address payable ghostAddress2 = extractOneAddrFromByte(_baseBytes,169);
1520 			
1521 			currentNodes[treeRoot][totalETH] = true;
1522 			uint totalRequireETH = nodeIDIndex[treeRoot][totalETH];
1523 			nodeIDIndex[treeRoot][totalETH] += 1;
1524 			isReatingTree[treeRoot][totalETH] = (isReatingRoom==1)? true:false;
1525 			emit startTree(treeRoot,totalRequireETH,totalETH);
1526 			
1527 			if(parentAddress != address(0))
1528 				tempDirRefer[treeRoot][totalETH][totalRequireETH] = parentAddress;
1529 			rewardDistribution memory rewardResult = 
1530 				_placeChildTree(parentAddress,totalETH,treeRoot,totalRequireETH);
1531 			if(rewardResult.first == address(0) && grandAddress != address(0)){
1532 				//Try grandparent
1533 				rewardResult = _placeChildTree(grandAddress,totalETH,treeRoot,totalRequireETH);
1534 			}
1535 			if(rewardResult.first == address(0) && grandgrandAddress != address(0)){
1536 				//Try grandparent
1537 				rewardResult = _placeChildTree(grandgrandAddress,totalETH,treeRoot,totalRequireETH);
1538 			}
1539 			if(rewardResult.first == address(0)){
1540 				//Try grandparent
1541 				rewardResult = rewardDistribution(ghostAddress1,ghostAddress2);
1542 			}
1543 			//if(rewardResult.first != address(0))
1544 			distributeETH(treeRoot,rewardResult.first,rewardResult.second,totalETH,false);
1545 			//else isOpeningExistingRoom=true;
1546 			return;
1547 		}
1548 		if(_baseBytes.length == 231){
1549 			//Getting the shop order from the website
1550 			//The first 9 bytes return the purchase order, the second 12 bytes returns the order details
1551 			//the following 42 bytes return the parent address, the following 42 bytes return the grandparent address
1552 			uint shopOrderID = extractUintFromByte(_baseBytes,0,9);
1553 			address payable parentAddress = extractOneAddrFromByte(_baseBytes,21);
1554 			address payable grandAddress = extractOneAddrFromByte(_baseBytes,63);
1555 			address payable grandgrandAddress = extractOneAddrFromByte(_baseBytes,105);
1556 			address payable ghostAddress1 = extractOneAddrFromByte(_baseBytes,147);
1557 			address payable ghostAddress2 = extractOneAddrFromByte(_baseBytes,189);
1558 			bool[] memory isStartTreeHere = new bool[](2*possibleNodeType.length);
1559 			bool isOpeningExistingRoom=false;
1560 			uint totalRequireETH = 0;			
1561 			for(uint i=0;i<possibleNodeType.length;i++){
1562 				isStartTreeHere[i]
1563 					= (getOneDigit(_baseBytes,(i+21)-possibleNodeType.length) ==1)? 
1564 					true:false;
1565 				isStartTreeHere[i+possibleNodeType.length]
1566 					= (getOneDigit(_baseBytes,(i+21)-(2*possibleNodeType.length)) ==1)? 
1567 					true:false;
1568 				if(isStartTreeHere[i]){
1569 					totalRequireETH += possibleNodeType[i] * 10 ** uint256(18);
1570 					uint testTreeType = possibleNodeType[i] * 10 ** uint256(18);
1571 					if(currentNodes[treeRoot][testTreeType] 
1572 						|| nodeIDIndex[treeRoot][testTreeType] >= (2 ** 32) -1){
1573 						isOpeningExistingRoom=true;
1574 					}
1575 				}
1576 			}
1577 			if(membership[treeRoot] <= now) totalRequireETH += mRate;
1578 			if(totalRequireETH > totalETH || shopOrderID ==0 || isOpeningExistingRoom){
1579 				//No enough ETH or invalid response or openning existing room, refund
1580 				distributeETH(treeRoot,treeRoot,treeRoot,totalETH,true);
1581 				memberOrders[treeRoot][shopOrderID]=3;//3 means refund
1582 				emit refundEvent(treeRoot,totalETH,totalRequireETH,shopOrderID,
1583 				    parentAddress,grandAddress,isOpeningExistingRoom);
1584 				return;
1585 			}else{
1586 				//Has enough ETH, open the rooms and find a place from parent one by one
1587 				//First, record the receive money and extend the membership
1588 				receivedAmount += totalRequireETH;
1589 				memberOrders[treeRoot][shopOrderID]=1;
1590 				if(membership[treeRoot] <= now) _addMember(treeRoot);
1591 				//First, send out the extra ETH
1592 				totalRequireETH = totalETH - totalRequireETH;
1593 				require(totalRequireETH < address(this).balance, "Too much remainder");
1594 				//The remainder is enough for extend the membership
1595 				if(( membership[treeRoot] <= now + (7*86400) ) && totalRequireETH >= mRate){
1596 					//Auto extend membership
1597 					_addMember(treeRoot);
1598 					totalRequireETH -= mRate;
1599 					receivedAmount += mRate;
1600 				}
1601 				if(totalRequireETH >0){
1602 					totalETH = address(this).balance;
1603 					treeRoot.transfer(totalRequireETH);
1604 					ethOut += totalRequireETH;
1605 					assert(address(this).balance + totalRequireETH >= totalETH);
1606 				}
1607 				for(uint i=0;i<possibleNodeType.length;i++){
1608 					//For each type of tree, start a node and look for parent
1609 					if(!isStartTreeHere[i]) continue;
1610 					totalETH = possibleNodeType[i] * 10 ** uint256(18);
1611 					currentNodes[treeRoot][totalETH] = true;
1612 					totalRequireETH = nodeIDIndex[treeRoot][totalETH];
1613 					nodeIDIndex[treeRoot][totalETH] += 1;
1614 					isReatingTree[treeRoot][totalETH] = isStartTreeHere[i+possibleNodeType.length];
1615 					emit startTree(treeRoot,totalRequireETH,totalETH);
1616 					
1617 					if(parentAddress != address(0))
1618 						tempDirRefer[treeRoot][totalETH][totalRequireETH] = parentAddress;
1619 					rewardDistribution memory rewardResult = 
1620 						_placeChildTree(parentAddress,totalETH,treeRoot,totalRequireETH);
1621 					if(rewardResult.first == address(0) && grandAddress != address(0)){
1622 						//Try grandparent
1623 						rewardResult = _placeChildTree(grandAddress,totalETH,treeRoot,totalRequireETH);
1624 					}
1625 					if(rewardResult.first == address(0) && grandgrandAddress != address(0)){
1626 						//Try grandparent
1627 						rewardResult = _placeChildTree(grandgrandAddress,totalETH,treeRoot,totalRequireETH);
1628 					}
1629 					if(rewardResult.first == address(0)){
1630 						//Try grandparent
1631 						rewardResult = rewardDistribution(ghostAddress1,ghostAddress2);
1632 					}
1633 					//if(rewardResult.first != address(0))
1634 					distributeETH(treeRoot,rewardResult.first,rewardResult.second,totalETH,false);
1635 					//else isOpeningExistingRoom=true;
1636 				}
1637 			}
1638 			return;
1639 		}
1640 
1641     }
1642 	function _placeChildTree(address payable firstUpline, uint treeType, address payable treeRoot, uint treeNodeID) internal returns(rewardDistribution memory) {
1643 		//We do BFS here, so need to search layer by layer
1644 		if(firstUpline == address(0)) return rewardDistribution(address(0),address(0));
1645 		address payable getETHOne = address(0); address payable getETHTwo = address(0);
1646 		uint8 firstLevelSearch=_placeChild(firstUpline,treeType,treeRoot,treeNodeID); 
1647 		if(firstLevelSearch == 1){
1648 			getETHOne=firstUpline;
1649 			uint cNodeID=nodeIDIndex[firstUpline][treeType] - 1;
1650 			//So the firstUpline will get the money, as well as the parent of the firstUpline
1651 			if(treeParent[firstUpline][treeType][cNodeID].nodeType != 0){
1652 				getETHTwo = treeParent[firstUpline][treeType][cNodeID].ethAddress;
1653 			}
1654 		}
1655 		//The same address has been here before
1656 		if(firstLevelSearch == 2) return rewardDistribution(address(0),address(0));
1657 		if(getETHOne == address(0)){
1658 			//Now search the grandchildren of the firstUpline for a place
1659 			if(currentNodes[firstUpline][treeType] && nodeIDIndex[firstUpline][treeType] <(2 ** 32) -1){
1660 				uint cNodeID=nodeIDIndex[firstUpline][treeType] - 1;
1661 				for (uint256 i=0; i < spread; i++) {
1662 					if(treeChildren[firstUpline][treeType][cNodeID][i].nodeType != 0){
1663 						treeNode memory kids = treeChildren[firstUpline][treeType][cNodeID][i];
1664 						if(_placeChild(kids.ethAddress,treeType,treeRoot,treeNodeID) == 1){
1665 							getETHOne=kids.ethAddress;
1666 							//So the child of firstUpline will get the money, as well as the child
1667 							getETHTwo = firstUpline;
1668 							break;
1669 						}
1670 					}
1671 				}
1672 			}
1673 		}
1674 		return rewardDistribution(getETHOne,getETHTwo);
1675 	}
1676 	//Return 0, there is no place for the node, 1, there is a place and placed, 2, duplicate node is found
1677 	function _placeChild(address payable firstUpline, uint treeType, address payable treeRoot, uint treeNodeID) 
1678 		internal returns(uint8) {
1679 		if(currentNodes[firstUpline][treeType] && nodeIDIndex[firstUpline][treeType] <(2 ** 32) -1){
1680 			uint cNodeID=nodeIDIndex[firstUpline][treeType] - 1;
1681 			for (uint256 i=0; i < spread; i++) {
1682 				if(treeChildren[firstUpline][treeType][cNodeID][i].nodeType == 0){
1683 					//firstUpline has a place
1684 					treeChildren[firstUpline][treeType][cNodeID][i]
1685 						= treeNode(treeRoot,treeType,treeNodeID);
1686 					//Set parent
1687 					treeParent[treeRoot][treeType][treeNodeID] 
1688 						= treeNode(firstUpline,treeType,cNodeID);
1689 					return 1;
1690 				}else{
1691 				    treeNode memory kids = treeChildren[firstUpline][treeType][cNodeID][i];
1692 				    //The child has been here in previous project
1693 				    if(kids.ethAddress == treeRoot) return 2;
1694 				}
1695 			}
1696 		}
1697 		return 0;
1698 	}
1699 	function _checkTreeComplete(address payable _root, uint _treeType, uint _nodeID) internal {
1700 		require(_root != address(0), "Tree root to check completness is 0");
1701 		bool _isCompleted = true;
1702 		uint _isDirectRefCount = 0;
1703 		for (uint256 i=0; i < spread; i++) {
1704 			if(treeChildren[_root][_treeType][_nodeID][i].nodeType == 0){
1705 				_isCompleted = false;
1706 				break;
1707 			}else{
1708 				//Search the grandchildren
1709 				treeNode memory _child = treeChildren[_root][_treeType][_nodeID][i];
1710 				address referral = tempDirRefer[_child.ethAddress][_child.nodeType][_child.nodeID];
1711 				if(referral == _root) _isDirectRefCount += 1;
1712 				for (uint256 a=0; a < spread; a++) {
1713 					if(treeChildren[_child.ethAddress][_treeType][_child.nodeID][a].nodeType == 0){
1714 						_isCompleted = false;
1715 						break;
1716 					}else{
1717 						treeNode memory _gChild=treeChildren[_child.ethAddress][_treeType][_child.nodeID][a];
1718 						address referral2 = tempDirRefer[_gChild.ethAddress][_gChild.nodeType][_gChild.nodeID];
1719 						if(referral2 == _root) _isDirectRefCount += 1;
1720 					}
1721 				}
1722 				if(!_isCompleted) break;
1723 			}
1724 		}
1725 		if(!_isCompleted) return;
1726 		//The tree is completed, root can start over again
1727 		currentNodes[_root][_treeType] = false;
1728 		treeCompleteTime[_root][_treeType][nodeIDIndex[_root][_treeType]-1]=now;
1729 		//Ban this user
1730 		if(nodeIDIndex[_root][_treeType] == 1 && _isDirectRefCount < minimumTreeNodeReferred) 
1731 			nodeIDIndex[_root][_treeType] = (2 ** 32) -1;
1732 		emit completeTree(_root, nodeIDIndex[_root][_treeType], _treeType);
1733 		
1734 		if(isReatingTree[_root][_treeType]){
1735 			string memory queryStr = addressToString(_root);
1736 			for(uint i=0;i<possibleNodeType.length;i++){
1737 				if(_treeType == possibleNodeType[i] * 10 ** uint256(18))
1738 					queryStr = strConcating(websiteString[i],queryStr);
1739 			}
1740 			emit makeQuery(msg.sender,"Oraclize query sent");
1741 			bytes32 queryId=oraclize_query("URL", queryStr, 800000);
1742 			oraclizeCallbacks[queryId] = treeNode(_root,_treeType,0);
1743 		}
1744 	}
1745 	function findChildFromTop(address searchTarget, address _root, uint _treeType, uint _nodeID) internal returns(uint8){
1746 		require(_root != address(0), "Tree root to check completness is 0");
1747 		for (uint8 i=0; i < spread; i++) {
1748 			if(treeChildren[_root][_treeType][_nodeID][i].nodeType == 0){
1749 				continue;
1750 			}else{
1751 				//Search the grandchildren
1752 				treeNode memory _child = treeChildren[_root][_treeType][_nodeID][i];
1753 				if(_child.ethAddress == searchTarget) return (i+1);
1754 				for (uint8 a=0; a < spread; a++) {
1755 					if(treeChildren[_child.ethAddress][_treeType][_child.nodeID][a].nodeType == 0){
1756 						continue;
1757 					}else{
1758 						treeNode memory _gChild=treeChildren[_child.ethAddress][_treeType][_child.nodeID][a];
1759 						if(_gChild.ethAddress == searchTarget) return ((i*2)+a+3);
1760 					}
1761 				}
1762 			}
1763 		}
1764 		return 0;
1765 	}
1766 	function distributeETH(address treeRoot, address payable rewardFirst, address payable rewardSecond, uint totalETH, 
1767 		bool isFund) internal{
1768 		//Distribute the award
1769 		uint moneyToDistribute = (totalETH * divideRadio) / divideRadioBase;
1770 		require(totalETH > 2*moneyToDistribute, "Too much ether to send");
1771 		require(address(this).balance > 2*moneyToDistribute, "Nothing to send");
1772 		uint previousBalances = address(this).balance;
1773 		if(rewardFirst != address(0)){
1774 			rewardFirst.transfer(moneyToDistribute);
1775 			ethOut += moneyToDistribute;
1776 			if(!isFund){
1777 				sentAmount += moneyToDistribute;
1778 				nodeReceivedETH[rewardFirst] += moneyToDistribute;
1779 			}
1780 			//emit distributeETH(rewardResult.first, treeRoot, moneyToDistribute);
1781 		} 
1782 		if(rewardSecond != address(0)){
1783 			//If it is repeating, the fourth children will send 0.03 less, or 30
1784 			//The fifth and sixth children will not send out
1785 			uint cNodeID=nodeIDIndex[rewardSecond][totalETH] - 1;
1786 			uint8 childNum = findChildFromTop(treeRoot,rewardSecond,totalETH,cNodeID);
1787 			if(childNum == 4){
1788 				moneyToDistribute = (totalETH * (divideRadio-30)) / divideRadioBase;
1789 				require(totalETH > 2*moneyToDistribute, "Too much ether to send");
1790 				require(address(this).balance > 2*moneyToDistribute, "Nothing to send");
1791 			}
1792 			if(childNum !=5 && childNum !=6){
1793 				rewardSecond.transfer(moneyToDistribute);
1794 				ethOut += moneyToDistribute;
1795 			}
1796 			if(!isFund){
1797 				if(childNum !=5 && childNum !=6){
1798 					sentAmount += moneyToDistribute;
1799 					nodeReceivedETH[rewardSecond] += moneyToDistribute;
1800 				}
1801 				//emit distributeETH(rewardResult.second, treeRoot, moneyToDistribute);
1802 				//Check if the node is now completed
1803 				_checkTreeComplete(rewardSecond,totalETH,cNodeID);
1804 			}
1805 		}
1806 		// Asserts are used to find bugs in your code. They should never fail
1807         assert(address(this).balance + (2*moneyToDistribute) >= previousBalances);
1808 	}
1809     function strConcating(string memory _a, string memory _b) internal pure returns (string memory){
1810         bytes memory _ba = bytes(_a);
1811         bytes memory _bb = bytes(_b);
1812         string memory ab = new string(_ba.length + _bb.length);
1813         bytes memory bab = bytes(ab);
1814         uint k = 0;
1815         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
1816         for (uint i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
1817         return string(bab);
1818     }
1819     function addressToString(address _addr) public pure returns(string memory) {
1820         bytes32 value = bytes32(uint256(_addr));
1821         bytes memory alphabet = "0123456789abcdef";    
1822         bytes memory str = new bytes(42);
1823         str[0] = '0';
1824         str[1] = 'x';
1825         for (uint i = 0; i < 20; i++) {
1826             str[2+i*2] = alphabet[uint8(value[i + 12] >> 4)];
1827             str[3+i*2] = alphabet[uint8(value[i + 12] & 0x0f)];
1828         }
1829         return string(str);
1830     }
1831 
1832     function extractOneAddrFromByte(bytes memory tmp, uint start) internal pure returns (address payable){
1833 		 if(tmp.length < start+42) return address(0); 
1834          uint160 iaddr = 0;
1835          uint160 b1;
1836          uint160 b2;
1837 		 uint e=start+42;
1838          for (uint i=start+2; i<e; i+=2){
1839              iaddr *= 256;
1840              b1 = uint8(tmp[i]);
1841              b2 = uint8(tmp[i+1]);
1842              if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1843              else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1844              if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1845              else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1846              iaddr += (b1*16+b2);
1847          }
1848          return address(iaddr);
1849 	}
1850 	function getOneDigit(bytes memory b, uint start) internal pure returns (uint){
1851 		if(b.length <= start) return 0;
1852 		uint digit = uint8(b[start]);
1853 		if(digit >=48 && digit<=57) return digit-48;
1854 		return 0;
1855 	}
1856 	function extractUintFromByte(bytes memory b, uint start, uint length) internal pure returns (uint){
1857 		if(b.length < start+length) return 0;
1858 		uint result = 0;
1859 		uint l=start+length;
1860 		for(uint i=start;i < l; i++){
1861 		    uint digit = uint8(b[i]);
1862 			if(digit >=48 && digit<=57) result = (result * 10) + (digit - 48);
1863 		}
1864 		return result;
1865 	}
1866 }