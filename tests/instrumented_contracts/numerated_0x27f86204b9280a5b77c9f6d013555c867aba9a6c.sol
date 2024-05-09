1 pragma solidity 0.5.2;
2 pragma experimental ABIEncoderV2;
3 
4 // Dummy contract only used to emit to end-user they are using wrong solc
5 contract solcChecker {
6 /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;
7 }
8 
9 contract OraclizeI {
10 
11     address public cbAddress;
12 
13     function setProofType(byte _proofType) external;
14     function setCustomGasPrice(uint _gasPrice) external;
15     function getPrice(string memory _datasource) public returns (uint _dsprice);
16     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
17     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
18     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
19     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
20     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
21     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
22     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
23     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
24 }
25 
26 contract OraclizeAddrResolverI {
27     function getAddress() public returns (address _address);
28 }
29 /*
30 
31 Begin solidity-cborutils
32 
33 https://github.com/smartcontractkit/solidity-cborutils
34 
35 MIT License
36 
37 Copyright (c) 2018 SmartContract ChainLink, Ltd.
38 
39 Permission is hereby granted, free of charge, to any person obtaining a copy
40 of this software and associated documentation files (the "Software"), to deal
41 in the Software without restriction, including without limitation the rights
42 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
43 copies of the Software, and to permit persons to whom the Software is
44 furnished to do so, subject to the following conditions:
45 
46 The above copyright notice and this permission notice shall be included in all
47 copies or substantial portions of the Software.
48 
49 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
50 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
51 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
52 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
53 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
54 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
55 SOFTWARE.
56 
57 */
58 library Buffer {
59 
60     struct buffer {
61         bytes buf;
62         uint capacity;
63     }
64 
65     function init(buffer memory _buf, uint _capacity) internal pure {
66         uint capacity = _capacity;
67         if (capacity % 32 != 0) {
68             capacity += 32 - (capacity % 32);
69         }
70         _buf.capacity = capacity; // Allocate space for the buffer data
71         assembly {
72             let ptr := mload(0x40)
73             mstore(_buf, ptr)
74             mstore(ptr, 0)
75             mstore(0x40, add(ptr, capacity))
76         }
77     }
78 
79     function resize(buffer memory _buf, uint _capacity) private pure {
80         bytes memory oldbuf = _buf.buf;
81         init(_buf, _capacity);
82         append(_buf, oldbuf);
83     }
84 
85     function max(uint _a, uint _b) private pure returns (uint _max) {
86         if (_a > _b) {
87             return _a;
88         }
89         return _b;
90     }
91     /**
92       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
93       *      would exceed the capacity of the buffer.
94       * @param _buf The buffer to append to.
95       * @param _data The data to append.
96       * @return The original buffer.
97       *
98       */
99     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
100         if (_data.length + _buf.buf.length > _buf.capacity) {
101             resize(_buf, max(_buf.capacity, _data.length) * 2);
102         }
103         uint dest;
104         uint src;
105         uint len = _data.length;
106         assembly {
107             let bufptr := mload(_buf) // Memory address of the buffer data
108             let buflen := mload(bufptr) // Length of existing buffer data
109             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
110             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
111             src := add(_data, 32)
112         }
113         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
114             assembly {
115                 mstore(dest, mload(src))
116             }
117             dest += 32;
118             src += 32;
119         }
120         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
121         assembly {
122             let srcpart := and(mload(src), not(mask))
123             let destpart := and(mload(dest), mask)
124             mstore(dest, or(destpart, srcpart))
125         }
126         return _buf;
127     }
128     /**
129       *
130       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
131       * exceed the capacity of the buffer.
132       * @param _buf The buffer to append to.
133       * @param _data The data to append.
134       * @return The original buffer.
135       *
136       */
137     function append(buffer memory _buf, uint8 _data) internal pure {
138         if (_buf.buf.length + 1 > _buf.capacity) {
139             resize(_buf, _buf.capacity * 2);
140         }
141         assembly {
142             let bufptr := mload(_buf) // Memory address of the buffer data
143             let buflen := mload(bufptr) // Length of existing buffer data
144             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
145             mstore8(dest, _data)
146             mstore(bufptr, add(buflen, 1)) // Update buffer length
147         }
148     }
149     /**
150       *
151       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
152       * exceed the capacity of the buffer.
153       * @param _buf The buffer to append to.
154       * @param _data The data to append.
155       * @return The original buffer.
156       *
157       */
158     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
159         if (_len + _buf.buf.length > _buf.capacity) {
160             resize(_buf, max(_buf.capacity, _len) * 2);
161         }
162         uint mask = 256 ** _len - 1;
163         assembly {
164             let bufptr := mload(_buf) // Memory address of the buffer data
165             let buflen := mload(bufptr) // Length of existing buffer data
166             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
167             mstore(dest, or(and(mload(dest), not(mask)), _data))
168             mstore(bufptr, add(buflen, _len)) // Update buffer length
169         }
170         return _buf;
171     }
172 }
173 
174 library CBOR {
175 
176     using Buffer for Buffer.buffer;
177 
178     uint8 private constant MAJOR_TYPE_INT = 0;
179     uint8 private constant MAJOR_TYPE_MAP = 5;
180     uint8 private constant MAJOR_TYPE_BYTES = 2;
181     uint8 private constant MAJOR_TYPE_ARRAY = 4;
182     uint8 private constant MAJOR_TYPE_STRING = 3;
183     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
184     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
185 
186     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
187         if (_value <= 23) {
188             _buf.append(uint8((_major << 5) | _value));
189         } else if (_value <= 0xFF) {
190             _buf.append(uint8((_major << 5) | 24));
191             _buf.appendInt(_value, 1);
192         } else if (_value <= 0xFFFF) {
193             _buf.append(uint8((_major << 5) | 25));
194             _buf.appendInt(_value, 2);
195         } else if (_value <= 0xFFFFFFFF) {
196             _buf.append(uint8((_major << 5) | 26));
197             _buf.appendInt(_value, 4);
198         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
199             _buf.append(uint8((_major << 5) | 27));
200             _buf.appendInt(_value, 8);
201         }
202     }
203 
204     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
205         _buf.append(uint8((_major << 5) | 31));
206     }
207 
208     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
209         encodeType(_buf, MAJOR_TYPE_INT, _value);
210     }
211 
212     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
213         if (_value >= 0) {
214             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
215         } else {
216             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
217         }
218     }
219 
220     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
221         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
222         _buf.append(_value);
223     }
224 
225     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
226         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
227         _buf.append(bytes(_value));
228     }
229 
230     function startArray(Buffer.buffer memory _buf) internal pure {
231         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
232     }
233 
234     function startMap(Buffer.buffer memory _buf) internal pure {
235         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
236     }
237 
238     function endSequence(Buffer.buffer memory _buf) internal pure {
239         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
240     }
241 }
242 /*
243 
244 End solidity-cborutils
245 
246 */
247 contract usingOraclize {
248 
249     using CBOR for Buffer.buffer;
250 
251     OraclizeI oraclize;
252     OraclizeAddrResolverI OAR;
253 
254     uint constant day = 60 * 60 * 24;
255     uint constant week = 60 * 60 * 24 * 7;
256     uint constant month = 60 * 60 * 24 * 30;
257 
258     byte constant proofType_NONE = 0x00;
259     byte constant proofType_Ledger = 0x30;
260     byte constant proofType_Native = 0xF0;
261     byte constant proofStorage_IPFS = 0x01;
262     byte constant proofType_Android = 0x40;
263     byte constant proofType_TLSNotary = 0x10;
264 
265     string oraclize_network_name;
266     uint8 constant networkID_auto = 0;
267     uint8 constant networkID_morden = 2;
268     uint8 constant networkID_mainnet = 1;
269     uint8 constant networkID_testnet = 2;
270     uint8 constant networkID_consensys = 161;
271 
272     mapping(bytes32 => bytes32) oraclize_randomDS_args;
273     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
274 
275     modifier oraclizeAPI {
276         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
277             oraclize_setNetwork(networkID_auto);
278         }
279         if (address(oraclize) != OAR.getAddress()) {
280             oraclize = OraclizeI(OAR.getAddress());
281         }
282         _;
283     }
284 
285     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
286         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
287         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
288         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
289         require(proofVerified);
290         _;
291     }
292 
293     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
294       return oraclize_setNetwork();
295       _networkID; // silence the warning and remain backwards compatible
296     }
297 
298     function oraclize_setNetworkName(string memory _network_name) internal {
299         oraclize_network_name = _network_name;
300     }
301 
302     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
303         return oraclize_network_name;
304     }
305 
306     function oraclize_setNetwork() internal returns (bool _networkSet) {
307         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
308             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
309             oraclize_setNetworkName("eth_mainnet");
310             return true;
311         }
312         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
313             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
314             oraclize_setNetworkName("eth_ropsten3");
315             return true;
316         }
317         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
318             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
319             oraclize_setNetworkName("eth_kovan");
320             return true;
321         }
322         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
323             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
324             oraclize_setNetworkName("eth_rinkeby");
325             return true;
326         }
327         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
328             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
329             return true;
330         }
331         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
332             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
333             return true;
334         }
335         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
336             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
337             return true;
338         }
339         return false;
340     }
341 
342     function __callback(bytes32 _myid, string memory _result) public {
343         __callback(_myid, _result, new bytes(0));
344     }
345 
346     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
347       return;
348       _myid; _result; _proof; // Silence compiler warnings
349     }
350 
351     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
352         return oraclize.getPrice(_datasource);
353     }
354 
355     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
356         return oraclize.getPrice(_datasource, _gasLimit);
357     }
358 
359     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
360         uint price = oraclize.getPrice(_datasource);
361         if (price > 1 ether + tx.gasprice * 200000) {
362             return 0; // Unexpectedly high price
363         }
364         return oraclize.query.value(price)(0, _datasource, _arg);
365     }
366 
367     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
368         uint price = oraclize.getPrice(_datasource);
369         if (price > 1 ether + tx.gasprice * 200000) {
370             return 0; // Unexpectedly high price
371         }
372         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
373     }
374 
375     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
376         uint price = oraclize.getPrice(_datasource,_gasLimit);
377         if (price > 1 ether + tx.gasprice * _gasLimit) {
378             return 0; // Unexpectedly high price
379         }
380         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
381     }
382 
383     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
384         uint price = oraclize.getPrice(_datasource, _gasLimit);
385         if (price > 1 ether + tx.gasprice * _gasLimit) {
386            return 0; // Unexpectedly high price
387         }
388         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
389     }
390 
391     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
392         uint price = oraclize.getPrice(_datasource);
393         if (price > 1 ether + tx.gasprice * 200000) {
394             return 0; // Unexpectedly high price
395         }
396         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
397     }
398 
399     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
400         uint price = oraclize.getPrice(_datasource);
401         if (price > 1 ether + tx.gasprice * 200000) {
402             return 0; // Unexpectedly high price
403         }
404         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
405     }
406 
407     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
408         uint price = oraclize.getPrice(_datasource, _gasLimit);
409         if (price > 1 ether + tx.gasprice * _gasLimit) {
410             return 0; // Unexpectedly high price
411         }
412         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
413     }
414 
415     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
416         uint price = oraclize.getPrice(_datasource, _gasLimit);
417         if (price > 1 ether + tx.gasprice * _gasLimit) {
418             return 0; // Unexpectedly high price
419         }
420         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
421     }
422 
423     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
424         uint price = oraclize.getPrice(_datasource);
425         if (price > 1 ether + tx.gasprice * 200000) {
426             return 0; // Unexpectedly high price
427         }
428         bytes memory args = stra2cbor(_argN);
429         return oraclize.queryN.value(price)(0, _datasource, args);
430     }
431 
432     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
433         uint price = oraclize.getPrice(_datasource);
434         if (price > 1 ether + tx.gasprice * 200000) {
435             return 0; // Unexpectedly high price
436         }
437         bytes memory args = stra2cbor(_argN);
438         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
439     }
440 
441     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
442         uint price = oraclize.getPrice(_datasource, _gasLimit);
443         if (price > 1 ether + tx.gasprice * _gasLimit) {
444             return 0; // Unexpectedly high price
445         }
446         bytes memory args = stra2cbor(_argN);
447         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
448     }
449 
450     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
451         uint price = oraclize.getPrice(_datasource, _gasLimit);
452         if (price > 1 ether + tx.gasprice * _gasLimit) {
453             return 0; // Unexpectedly high price
454         }
455         bytes memory args = stra2cbor(_argN);
456         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
457     }
458 
459     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
460         string[] memory dynargs = new string[](1);
461         dynargs[0] = _args[0];
462         return oraclize_query(_datasource, dynargs);
463     }
464 
465     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
466         string[] memory dynargs = new string[](1);
467         dynargs[0] = _args[0];
468         return oraclize_query(_timestamp, _datasource, dynargs);
469     }
470 
471     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
472         string[] memory dynargs = new string[](1);
473         dynargs[0] = _args[0];
474         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
475     }
476 
477     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
478         string[] memory dynargs = new string[](1);
479         dynargs[0] = _args[0];
480         return oraclize_query(_datasource, dynargs, _gasLimit);
481     }
482 
483     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
484         string[] memory dynargs = new string[](2);
485         dynargs[0] = _args[0];
486         dynargs[1] = _args[1];
487         return oraclize_query(_datasource, dynargs);
488     }
489 
490     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
491         string[] memory dynargs = new string[](2);
492         dynargs[0] = _args[0];
493         dynargs[1] = _args[1];
494         return oraclize_query(_timestamp, _datasource, dynargs);
495     }
496 
497     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
498         string[] memory dynargs = new string[](2);
499         dynargs[0] = _args[0];
500         dynargs[1] = _args[1];
501         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
502     }
503 
504     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
505         string[] memory dynargs = new string[](2);
506         dynargs[0] = _args[0];
507         dynargs[1] = _args[1];
508         return oraclize_query(_datasource, dynargs, _gasLimit);
509     }
510 
511     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
512         string[] memory dynargs = new string[](3);
513         dynargs[0] = _args[0];
514         dynargs[1] = _args[1];
515         dynargs[2] = _args[2];
516         return oraclize_query(_datasource, dynargs);
517     }
518 
519     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
520         string[] memory dynargs = new string[](3);
521         dynargs[0] = _args[0];
522         dynargs[1] = _args[1];
523         dynargs[2] = _args[2];
524         return oraclize_query(_timestamp, _datasource, dynargs);
525     }
526 
527     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
528         string[] memory dynargs = new string[](3);
529         dynargs[0] = _args[0];
530         dynargs[1] = _args[1];
531         dynargs[2] = _args[2];
532         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
533     }
534 
535     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
536         string[] memory dynargs = new string[](3);
537         dynargs[0] = _args[0];
538         dynargs[1] = _args[1];
539         dynargs[2] = _args[2];
540         return oraclize_query(_datasource, dynargs, _gasLimit);
541     }
542 
543     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
544         string[] memory dynargs = new string[](4);
545         dynargs[0] = _args[0];
546         dynargs[1] = _args[1];
547         dynargs[2] = _args[2];
548         dynargs[3] = _args[3];
549         return oraclize_query(_datasource, dynargs);
550     }
551 
552     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
553         string[] memory dynargs = new string[](4);
554         dynargs[0] = _args[0];
555         dynargs[1] = _args[1];
556         dynargs[2] = _args[2];
557         dynargs[3] = _args[3];
558         return oraclize_query(_timestamp, _datasource, dynargs);
559     }
560 
561     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
562         string[] memory dynargs = new string[](4);
563         dynargs[0] = _args[0];
564         dynargs[1] = _args[1];
565         dynargs[2] = _args[2];
566         dynargs[3] = _args[3];
567         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
568     }
569 
570     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
571         string[] memory dynargs = new string[](4);
572         dynargs[0] = _args[0];
573         dynargs[1] = _args[1];
574         dynargs[2] = _args[2];
575         dynargs[3] = _args[3];
576         return oraclize_query(_datasource, dynargs, _gasLimit);
577     }
578 
579     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
580         string[] memory dynargs = new string[](5);
581         dynargs[0] = _args[0];
582         dynargs[1] = _args[1];
583         dynargs[2] = _args[2];
584         dynargs[3] = _args[3];
585         dynargs[4] = _args[4];
586         return oraclize_query(_datasource, dynargs);
587     }
588 
589     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
590         string[] memory dynargs = new string[](5);
591         dynargs[0] = _args[0];
592         dynargs[1] = _args[1];
593         dynargs[2] = _args[2];
594         dynargs[3] = _args[3];
595         dynargs[4] = _args[4];
596         return oraclize_query(_timestamp, _datasource, dynargs);
597     }
598 
599     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
600         string[] memory dynargs = new string[](5);
601         dynargs[0] = _args[0];
602         dynargs[1] = _args[1];
603         dynargs[2] = _args[2];
604         dynargs[3] = _args[3];
605         dynargs[4] = _args[4];
606         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
607     }
608 
609     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
610         string[] memory dynargs = new string[](5);
611         dynargs[0] = _args[0];
612         dynargs[1] = _args[1];
613         dynargs[2] = _args[2];
614         dynargs[3] = _args[3];
615         dynargs[4] = _args[4];
616         return oraclize_query(_datasource, dynargs, _gasLimit);
617     }
618 
619     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
620         uint price = oraclize.getPrice(_datasource);
621         if (price > 1 ether + tx.gasprice * 200000) {
622             return 0; // Unexpectedly high price
623         }
624         bytes memory args = ba2cbor(_argN);
625         return oraclize.queryN.value(price)(0, _datasource, args);
626     }
627 
628     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
629         uint price = oraclize.getPrice(_datasource);
630         if (price > 1 ether + tx.gasprice * 200000) {
631             return 0; // Unexpectedly high price
632         }
633         bytes memory args = ba2cbor(_argN);
634         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
635     }
636 
637     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
638         uint price = oraclize.getPrice(_datasource, _gasLimit);
639         if (price > 1 ether + tx.gasprice * _gasLimit) {
640             return 0; // Unexpectedly high price
641         }
642         bytes memory args = ba2cbor(_argN);
643         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
644     }
645 
646     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
647         uint price = oraclize.getPrice(_datasource, _gasLimit);
648         if (price > 1 ether + tx.gasprice * _gasLimit) {
649             return 0; // Unexpectedly high price
650         }
651         bytes memory args = ba2cbor(_argN);
652         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
653     }
654 
655     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
656         bytes[] memory dynargs = new bytes[](1);
657         dynargs[0] = _args[0];
658         return oraclize_query(_datasource, dynargs);
659     }
660 
661     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
662         bytes[] memory dynargs = new bytes[](1);
663         dynargs[0] = _args[0];
664         return oraclize_query(_timestamp, _datasource, dynargs);
665     }
666 
667     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
668         bytes[] memory dynargs = new bytes[](1);
669         dynargs[0] = _args[0];
670         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
671     }
672 
673     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
674         bytes[] memory dynargs = new bytes[](1);
675         dynargs[0] = _args[0];
676         return oraclize_query(_datasource, dynargs, _gasLimit);
677     }
678 
679     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
680         bytes[] memory dynargs = new bytes[](2);
681         dynargs[0] = _args[0];
682         dynargs[1] = _args[1];
683         return oraclize_query(_datasource, dynargs);
684     }
685 
686     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
687         bytes[] memory dynargs = new bytes[](2);
688         dynargs[0] = _args[0];
689         dynargs[1] = _args[1];
690         return oraclize_query(_timestamp, _datasource, dynargs);
691     }
692 
693     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
694         bytes[] memory dynargs = new bytes[](2);
695         dynargs[0] = _args[0];
696         dynargs[1] = _args[1];
697         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
698     }
699 
700     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
701         bytes[] memory dynargs = new bytes[](2);
702         dynargs[0] = _args[0];
703         dynargs[1] = _args[1];
704         return oraclize_query(_datasource, dynargs, _gasLimit);
705     }
706 
707     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
708         bytes[] memory dynargs = new bytes[](3);
709         dynargs[0] = _args[0];
710         dynargs[1] = _args[1];
711         dynargs[2] = _args[2];
712         return oraclize_query(_datasource, dynargs);
713     }
714 
715     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
716         bytes[] memory dynargs = new bytes[](3);
717         dynargs[0] = _args[0];
718         dynargs[1] = _args[1];
719         dynargs[2] = _args[2];
720         return oraclize_query(_timestamp, _datasource, dynargs);
721     }
722 
723     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
724         bytes[] memory dynargs = new bytes[](3);
725         dynargs[0] = _args[0];
726         dynargs[1] = _args[1];
727         dynargs[2] = _args[2];
728         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
729     }
730 
731     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
732         bytes[] memory dynargs = new bytes[](3);
733         dynargs[0] = _args[0];
734         dynargs[1] = _args[1];
735         dynargs[2] = _args[2];
736         return oraclize_query(_datasource, dynargs, _gasLimit);
737     }
738 
739     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
740         bytes[] memory dynargs = new bytes[](4);
741         dynargs[0] = _args[0];
742         dynargs[1] = _args[1];
743         dynargs[2] = _args[2];
744         dynargs[3] = _args[3];
745         return oraclize_query(_datasource, dynargs);
746     }
747 
748     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
749         bytes[] memory dynargs = new bytes[](4);
750         dynargs[0] = _args[0];
751         dynargs[1] = _args[1];
752         dynargs[2] = _args[2];
753         dynargs[3] = _args[3];
754         return oraclize_query(_timestamp, _datasource, dynargs);
755     }
756 
757     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
758         bytes[] memory dynargs = new bytes[](4);
759         dynargs[0] = _args[0];
760         dynargs[1] = _args[1];
761         dynargs[2] = _args[2];
762         dynargs[3] = _args[3];
763         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
764     }
765 
766     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
767         bytes[] memory dynargs = new bytes[](4);
768         dynargs[0] = _args[0];
769         dynargs[1] = _args[1];
770         dynargs[2] = _args[2];
771         dynargs[3] = _args[3];
772         return oraclize_query(_datasource, dynargs, _gasLimit);
773     }
774 
775     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
776         bytes[] memory dynargs = new bytes[](5);
777         dynargs[0] = _args[0];
778         dynargs[1] = _args[1];
779         dynargs[2] = _args[2];
780         dynargs[3] = _args[3];
781         dynargs[4] = _args[4];
782         return oraclize_query(_datasource, dynargs);
783     }
784 
785     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
786         bytes[] memory dynargs = new bytes[](5);
787         dynargs[0] = _args[0];
788         dynargs[1] = _args[1];
789         dynargs[2] = _args[2];
790         dynargs[3] = _args[3];
791         dynargs[4] = _args[4];
792         return oraclize_query(_timestamp, _datasource, dynargs);
793     }
794 
795     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
796         bytes[] memory dynargs = new bytes[](5);
797         dynargs[0] = _args[0];
798         dynargs[1] = _args[1];
799         dynargs[2] = _args[2];
800         dynargs[3] = _args[3];
801         dynargs[4] = _args[4];
802         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
803     }
804 
805     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
806         bytes[] memory dynargs = new bytes[](5);
807         dynargs[0] = _args[0];
808         dynargs[1] = _args[1];
809         dynargs[2] = _args[2];
810         dynargs[3] = _args[3];
811         dynargs[4] = _args[4];
812         return oraclize_query(_datasource, dynargs, _gasLimit);
813     }
814 
815     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
816         return oraclize.setProofType(_proofP);
817     }
818 
819 
820     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
821         return oraclize.cbAddress();
822     }
823 
824     function getCodeSize(address _addr) view internal returns (uint _size) {
825         assembly {
826             _size := extcodesize(_addr)
827         }
828     }
829 
830     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
831         return oraclize.setCustomGasPrice(_gasPrice);
832     }
833 
834     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
835         return oraclize.randomDS_getSessionPubKeyHash();
836     }
837 
838     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
839         bytes memory tmp = bytes(_a);
840         uint160 iaddr = 0;
841         uint160 b1;
842         uint160 b2;
843         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
844             iaddr *= 256;
845             b1 = uint160(uint8(tmp[i]));
846             b2 = uint160(uint8(tmp[i + 1]));
847             if ((b1 >= 97) && (b1 <= 102)) {
848                 b1 -= 87;
849             } else if ((b1 >= 65) && (b1 <= 70)) {
850                 b1 -= 55;
851             } else if ((b1 >= 48) && (b1 <= 57)) {
852                 b1 -= 48;
853             }
854             if ((b2 >= 97) && (b2 <= 102)) {
855                 b2 -= 87;
856             } else if ((b2 >= 65) && (b2 <= 70)) {
857                 b2 -= 55;
858             } else if ((b2 >= 48) && (b2 <= 57)) {
859                 b2 -= 48;
860             }
861             iaddr += (b1 * 16 + b2);
862         }
863         return address(iaddr);
864     }
865 
866     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
867         bytes memory a = bytes(_a);
868         bytes memory b = bytes(_b);
869         uint minLength = a.length;
870         if (b.length < minLength) {
871             minLength = b.length;
872         }
873         for (uint i = 0; i < minLength; i ++) {
874             if (a[i] < b[i]) {
875                 return -1;
876             } else if (a[i] > b[i]) {
877                 return 1;
878             }
879         }
880         if (a.length < b.length) {
881             return -1;
882         } else if (a.length > b.length) {
883             return 1;
884         } else {
885             return 0;
886         }
887     }
888 
889     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
890         bytes memory h = bytes(_haystack);
891         bytes memory n = bytes(_needle);
892         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
893             return -1;
894         } else if (h.length > (2 ** 128 - 1)) {
895             return -1;
896         } else {
897             uint subindex = 0;
898             for (uint i = 0; i < h.length; i++) {
899                 if (h[i] == n[0]) {
900                     subindex = 1;
901                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
902                         subindex++;
903                     }
904                     if (subindex == n.length) {
905                         return int(i);
906                     }
907                 }
908             }
909             return -1;
910         }
911     }
912 
913     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
914         return strConcat(_a, _b, "", "", "");
915     }
916 
917     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
918         return strConcat(_a, _b, _c, "", "");
919     }
920 
921     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
922         return strConcat(_a, _b, _c, _d, "");
923     }
924 
925     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
926         bytes memory _ba = bytes(_a);
927         bytes memory _bb = bytes(_b);
928         bytes memory _bc = bytes(_c);
929         bytes memory _bd = bytes(_d);
930         bytes memory _be = bytes(_e);
931         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
932         bytes memory babcde = bytes(abcde);
933         uint k = 0;
934         uint i = 0;
935         for (i = 0; i < _ba.length; i++) {
936             babcde[k++] = _ba[i];
937         }
938         for (i = 0; i < _bb.length; i++) {
939             babcde[k++] = _bb[i];
940         }
941         for (i = 0; i < _bc.length; i++) {
942             babcde[k++] = _bc[i];
943         }
944         for (i = 0; i < _bd.length; i++) {
945             babcde[k++] = _bd[i];
946         }
947         for (i = 0; i < _be.length; i++) {
948             babcde[k++] = _be[i];
949         }
950         return string(babcde);
951     }
952 
953     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
954         return safeParseInt(_a, 0);
955     }
956 
957     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
958         bytes memory bresult = bytes(_a);
959         uint mint = 0;
960         bool decimals = false;
961         for (uint i = 0; i < bresult.length; i++) {
962             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
963                 if (decimals) {
964                    if (_b == 0) break;
965                     else _b--;
966                 }
967                 mint *= 10;
968                 mint += uint(uint8(bresult[i])) - 48;
969             } else if (uint(uint8(bresult[i])) == 46) {
970                 require(!decimals, 'More than one decimal encountered in string!');
971                 decimals = true;
972             } else {
973                 revert("Non-numeral character encountered in string!");
974             }
975         }
976         if (_b > 0) {
977             mint *= 10 ** _b;
978         }
979         return mint;
980     }
981 
982     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
983         return parseInt(_a, 0);
984     }
985 
986     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
987         bytes memory bresult = bytes(_a);
988         uint mint = 0;
989         bool decimals = false;
990         for (uint i = 0; i < bresult.length; i++) {
991             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
992                 if (decimals) {
993                    if (_b == 0) {
994                        break;
995                    } else {
996                        _b--;
997                    }
998                 }
999                 mint *= 10;
1000                 mint += uint(uint8(bresult[i])) - 48;
1001             } else if (uint(uint8(bresult[i])) == 46) {
1002                 decimals = true;
1003             }
1004         }
1005         if (_b > 0) {
1006             mint *= 10 ** _b;
1007         }
1008         return mint;
1009     }
1010 
1011     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1012         if (_i == 0) {
1013             return "0";
1014         }
1015         uint j = _i;
1016         uint len;
1017         while (j != 0) {
1018             len++;
1019             j /= 10;
1020         }
1021         bytes memory bstr = new bytes(len);
1022         uint k = len - 1;
1023         while (_i != 0) {
1024             bstr[k--] = byte(uint8(48 + _i % 10));
1025             _i /= 10;
1026         }
1027         return string(bstr);
1028     }
1029 
1030     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1031         safeMemoryCleaner();
1032         Buffer.buffer memory buf;
1033         Buffer.init(buf, 1024);
1034         buf.startArray();
1035         for (uint i = 0; i < _arr.length; i++) {
1036             buf.encodeString(_arr[i]);
1037         }
1038         buf.endSequence();
1039         return buf.buf;
1040     }
1041 
1042     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1043         safeMemoryCleaner();
1044         Buffer.buffer memory buf;
1045         Buffer.init(buf, 1024);
1046         buf.startArray();
1047         for (uint i = 0; i < _arr.length; i++) {
1048             buf.encodeBytes(_arr[i]);
1049         }
1050         buf.endSequence();
1051         return buf.buf;
1052     }
1053 
1054     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1055         require((_nbytes > 0) && (_nbytes <= 32));
1056         _delay *= 10; // Convert from seconds to ledger timer ticks
1057         bytes memory nbytes = new bytes(1);
1058         nbytes[0] = byte(uint8(_nbytes));
1059         bytes memory unonce = new bytes(32);
1060         bytes memory sessionKeyHash = new bytes(32);
1061         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1062         assembly {
1063             mstore(unonce, 0x20)
1064             /*
1065              The following variables can be relaxed.
1066              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1067              for an idea on how to override and replace commit hash variables.
1068             */
1069             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1070             mstore(sessionKeyHash, 0x20)
1071             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1072         }
1073         bytes memory delay = new bytes(32);
1074         assembly {
1075             mstore(add(delay, 0x20), _delay)
1076         }
1077         bytes memory delay_bytes8 = new bytes(8);
1078         copyBytes(delay, 24, 8, delay_bytes8, 0);
1079         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1080         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1081         bytes memory delay_bytes8_left = new bytes(8);
1082         assembly {
1083             let x := mload(add(delay_bytes8, 0x20))
1084             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1085             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1086             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1087             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1088             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1089             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1090             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1091             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1092         }
1093         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1094         return queryId;
1095     }
1096 
1097     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1098         oraclize_randomDS_args[_queryId] = _commitment;
1099     }
1100 
1101     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1102         bool sigok;
1103         address signer;
1104         bytes32 sigr;
1105         bytes32 sigs;
1106         bytes memory sigr_ = new bytes(32);
1107         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1108         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1109         bytes memory sigs_ = new bytes(32);
1110         offset += 32 + 2;
1111         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1112         assembly {
1113             sigr := mload(add(sigr_, 32))
1114             sigs := mload(add(sigs_, 32))
1115         }
1116         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1117         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1118             return true;
1119         } else {
1120             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1121             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1122         }
1123     }
1124 
1125     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1126         bool sigok;
1127         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1128         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1129         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1130         bytes memory appkey1_pubkey = new bytes(64);
1131         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1132         bytes memory tosign2 = new bytes(1 + 65 + 32);
1133         tosign2[0] = byte(uint8(1)); //role
1134         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1135         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1136         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1137         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1138         if (!sigok) {
1139             return false;
1140         }
1141         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1142         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1143         bytes memory tosign3 = new bytes(1 + 65);
1144         tosign3[0] = 0xFE;
1145         copyBytes(_proof, 3, 65, tosign3, 1);
1146         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1147         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1148         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1149         return sigok;
1150     }
1151 
1152     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1153         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1154         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1155             return 1;
1156         }
1157         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1158         if (!proofVerified) {
1159             return 2;
1160         }
1161         return 0;
1162     }
1163 
1164     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1165         bool match_ = true;
1166         require(_prefix.length == _nRandomBytes);
1167         for (uint256 i = 0; i< _nRandomBytes; i++) {
1168             if (_content[i] != _prefix[i]) {
1169                 match_ = false;
1170             }
1171         }
1172         return match_;
1173     }
1174 
1175     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1176         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1177         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1178         bytes memory keyhash = new bytes(32);
1179         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1180         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1181             return false;
1182         }
1183         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1184         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1185         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1186         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1187             return false;
1188         }
1189         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1190         // This is to verify that the computed args match with the ones specified in the query.
1191         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1192         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1193         bytes memory sessionPubkey = new bytes(64);
1194         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1195         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1196         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1197         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1198             delete oraclize_randomDS_args[_queryId];
1199         } else return false;
1200         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1201         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1202         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1203         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1204             return false;
1205         }
1206         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1207         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1208             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1209         }
1210         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1211     }
1212     /*
1213      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1214     */
1215     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1216         uint minLength = _length + _toOffset;
1217         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1218         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1219         uint j = 32 + _toOffset;
1220         while (i < (32 + _fromOffset + _length)) {
1221             assembly {
1222                 let tmp := mload(add(_from, i))
1223                 mstore(add(_to, j), tmp)
1224             }
1225             i += 32;
1226             j += 32;
1227         }
1228         return _to;
1229     }
1230     /*
1231      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1232      Duplicate Solidity's ecrecover, but catching the CALL return value
1233     */
1234     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1235         /*
1236          We do our own memory management here. Solidity uses memory offset
1237          0x40 to store the current end of memory. We write past it (as
1238          writes are memory extensions), but don't update the offset so
1239          Solidity will reuse it. The memory used here is only needed for
1240          this context.
1241          FIXME: inline assembly can't access return values
1242         */
1243         bool ret;
1244         address addr;
1245         assembly {
1246             let size := mload(0x40)
1247             mstore(size, _hash)
1248             mstore(add(size, 32), _v)
1249             mstore(add(size, 64), _r)
1250             mstore(add(size, 96), _s)
1251             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1252             addr := mload(size)
1253         }
1254         return (ret, addr);
1255     }
1256     /*
1257      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1258     */
1259     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1260         bytes32 r;
1261         bytes32 s;
1262         uint8 v;
1263         if (_sig.length != 65) {
1264             return (false, address(0));
1265         }
1266         /*
1267          The signature format is a compact form of:
1268            {bytes32 r}{bytes32 s}{uint8 v}
1269          Compact means, uint8 is not padded to 32 bytes.
1270         */
1271         assembly {
1272             r := mload(add(_sig, 32))
1273             s := mload(add(_sig, 64))
1274             /*
1275              Here we are loading the last 32 bytes. We exploit the fact that
1276              'mload' will pad with zeroes if we overread.
1277              There is no 'mload8' to do this, but that would be nicer.
1278             */
1279             v := byte(0, mload(add(_sig, 96)))
1280             /*
1281               Alternative solution:
1282               'byte' is not working due to the Solidity parser, so lets
1283               use the second best option, 'and'
1284               v := and(mload(add(_sig, 65)), 255)
1285             */
1286         }
1287         /*
1288          albeit non-transactional signatures are not specified by the YP, one would expect it
1289          to match the YP range of [27, 28]
1290          geth uses [0, 1] and some clients have followed. This might change, see:
1291          https://github.com/ethereum/go-ethereum/issues/2053
1292         */
1293         if (v < 27) {
1294             v += 27;
1295         }
1296         if (v != 27 && v != 28) {
1297             return (false, address(0));
1298         }
1299         return safer_ecrecover(_hash, v, r, s);
1300     }
1301 
1302     function safeMemoryCleaner() internal pure {
1303         assembly {
1304             let fmem := mload(0x40)
1305             codecopy(fmem, codesize, sub(msize, fmem))
1306         }
1307     }
1308 }
1309 /*
1310 
1311 END ORACLIZE_API
1312 
1313 */
1314 
1315 
1316 contract Ownable {
1317     address public owner;
1318 
1319     constructor() public {
1320         owner = msg.sender;
1321     }
1322 
1323     modifier onlyOwner() {
1324         require(msg.sender == owner, "");
1325         _;
1326     }
1327 
1328     function transferOwnership(address newOwner) public onlyOwner {
1329         require(newOwner != address(0), "");
1330         owner = newOwner;
1331     }
1332 
1333 }
1334 
1335 contract Whitelist is Ownable {
1336     mapping(address => bool) public whitelist;
1337 
1338     event WhitelistedAddressAdded(address addr);
1339     event WhitelistedAddressRemoved(address addr);
1340 
1341     modifier onlyWhitelisted() {
1342         require(whitelist[msg.sender], "");
1343         _;
1344     }
1345 
1346     function addAddressToWhitelist(address addr) public onlyOwner returns (bool success) {
1347         if ((!whitelist[addr]) && (addr != address(0))) {
1348             whitelist[addr] = true;
1349             emit WhitelistedAddressAdded(addr);
1350             success = true;
1351         }
1352     }
1353 
1354     function addAddressesToWhitelist(address[] memory addrs) public onlyOwner returns (bool success) {
1355         for (uint256 i = 0; i < addrs.length; i++) {
1356             if (addAddressToWhitelist(addrs[i])) {
1357                 success = true;
1358             }
1359         }
1360     }
1361 
1362     function removeAddressFromWhitelist(address addr) public onlyOwner returns(bool success) {
1363         if (whitelist[addr]) {
1364             whitelist[addr] = false;
1365             emit WhitelistedAddressRemoved(addr);
1366             success = true;
1367         }
1368     }
1369 
1370     function removeAddressesFromWhitelist(address[] memory addrs) public onlyOwner returns(bool success) {
1371         for (uint256 i = 0; i < addrs.length; i++) {
1372             if (removeAddressFromWhitelist(addrs[i])) {
1373                 success = true;
1374             }
1375         }
1376     }
1377 
1378 }
1379 
1380 contract iLotteries {
1381     function processRound(uint round, uint randomNumber) public payable returns (bool);
1382     function getPeriod() public view returns (uint);
1383 }
1384 
1385 contract iRandao {
1386     function newCampaign(
1387         uint32 _bnum,
1388         uint96 _deposit,
1389         uint16 _commitBalkline,
1390         uint16 _commitDeadline
1391     )
1392         public payable returns (uint256 _campaignID);
1393 }
1394 
1395 contract RNG is usingOraclize, Ownable, Whitelist {
1396 
1397     struct Request {
1398         address lottery;
1399         uint round;
1400     }
1401     
1402     mapping(bytes32 => Request) public requests; // requests from lottery to oraclize
1403 
1404     uint public callbackGas = 2000000;
1405 
1406     bool public useOraclize;
1407 
1408     address randao;
1409 
1410     event RequestIsSended(address lottery, uint round, bytes32 queryId);
1411     event CallbackIsNotCorrect(address lottery, bytes32  queryId);
1412     event Withdraw(address to, uint value);
1413 
1414     constructor(bool _useOraclize) public {
1415         useOraclize = _useOraclize;
1416         if (useOraclize) oraclize_setProof(proofType_Ledger);
1417     }
1418 
1419     function () external payable {
1420 
1421     }
1422 
1423     function __callback(bytes32 _queryId, string memory _result, bytes memory _proof) public {
1424         if (msg.sender != oraclize_cbAddress()) revert("");
1425 
1426         if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0) {
1427             emit CallbackIsNotCorrect(address(requests[_queryId].lottery), _queryId);
1428         } else {
1429             iLotteries temp = iLotteries(requests[_queryId].lottery);
1430 
1431             assert(temp.processRound(requests[_queryId].round, uint(keccak256(abi.encodePacked(_result)))));
1432         }
1433     }
1434 
1435     function __callback(bytes32 _queryId, uint _result) public {
1436         if (msg.sender != randao) revert("");
1437 
1438         iLotteries temp = iLotteries(requests[_queryId].lottery);
1439 
1440         assert(temp.processRound(requests[_queryId].round, uint(keccak256(abi.encodePacked(_result)))));
1441 
1442     }
1443     
1444     function update(uint _roundNumber, uint _additionalNonce, uint _period) public payable {
1445         uint n = 32; // number of random bytes we want the datasource to return
1446         uint delay = 0; // number of seconds to wait before the execution takes place
1447 
1448         bytes32 queryId;
1449         if (!useOraclize) {
1450             queryId = bytes32(iRandao(randao).newCampaign.value(350 finney)(uint32(block.number+101), uint96(200 finney), uint16(100), uint16(50)));
1451         } else {
1452             queryId = custom_oraclize_newRandomDSQuery(_period, delay, n, callbackGas, _additionalNonce);
1453         }
1454 
1455         requests[queryId].lottery = msg.sender;
1456         requests[queryId].round = _roundNumber;
1457 
1458         emit RequestIsSended(msg.sender, _roundNumber, queryId);
1459     }
1460     
1461     function withdraw(address payable _to, uint256 _value) public onlyOwner {
1462         emit Withdraw(_to, _value);
1463         _to.transfer(_value);
1464     }
1465 
1466     function setCallbackGas(uint _callbackGas) public onlyOwner {
1467         callbackGas = _callbackGas;
1468     }
1469 
1470     function setUseOraclize(bool _useOraclize) public onlyOwner {
1471         useOraclize = _useOraclize;
1472     }
1473 
1474     function setRandao(address _randao) public onlyOwner {
1475         require(_randao != address(0));
1476 
1477         randao = _randao;
1478     }
1479 
1480     function getRequest(bytes32 _queryId) public view returns (address, uint) {
1481         return (requests[_queryId].lottery, requests[_queryId].round);
1482     }
1483 
1484     function getCallbackGas() public view returns (uint) {
1485         return callbackGas;
1486     }
1487 
1488     function custom_oraclize_newRandomDSQuery(
1489         uint _period,
1490         uint _delay,
1491         uint _nbytes,
1492         uint _customGasLimit,
1493         uint _additionalNonce
1494     )
1495         internal
1496         returns (bytes32)
1497     {
1498         require((_nbytes > 0) && (_nbytes <= 32), "");
1499         
1500         // Convert from seconds to ledger timer ticks
1501         _delay *= 10;
1502         bytes memory nbytes = new bytes(1);
1503         nbytes[0] = byte(uint8(_nbytes));
1504         bytes memory unonce = new bytes(32);
1505         bytes memory sessionKeyHash = new bytes(32);
1506         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1507         
1508         assembly {
1509             mstore(unonce, 0x20)
1510             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, xor(timestamp, _additionalNonce))))
1511             mstore(sessionKeyHash, 0x20)
1512             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1513         }
1514         
1515         bytes memory delay = new bytes(32);
1516         
1517         assembly {
1518             mstore(add(delay, 0x20), _delay)
1519         }
1520 
1521         bytes memory delay_bytes8 = new bytes(8);
1522         
1523         copyBytes(delay, 24, 8, delay_bytes8, 0);
1524 
1525         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1526         bytes32 queryId = oraclize_query(_period, "random", args, _customGasLimit);
1527 
1528         bytes memory delay_bytes8_left = new bytes(8);
1529 
1530         assembly {
1531             let x := mload(add(delay_bytes8, 0x20))
1532             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1533             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1534             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1535             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1536             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1537             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1538             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1539             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1540 
1541         }
1542 
1543         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1544         return queryId;
1545     }
1546 }