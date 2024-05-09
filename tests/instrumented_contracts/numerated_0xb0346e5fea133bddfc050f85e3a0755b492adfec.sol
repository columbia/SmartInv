1 /**
2  * Source Code first verified at https://etherscan.io on Friday, March 29, 2019
3  (UTC) */
4 
5 /*
6 
7 ORACLIZE_API
8 
9 Copyright (c) 2015-2016 Oraclize SRL
10 Copyright (c) 2016 Oraclize LTD
11 
12 Permission is hereby granted, free of charge, to any person obtaining a copy
13 of this software and associated documentation files (the "Software"), to deal
14 in the Software without restriction, including without limitation the rights
15 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
16 copies of the Software, and to permit persons to whom the Software is
17 furnished to do so, subject to the following conditions:
18 
19 The above copyright notice and this permission notice shall be included in
20 all copies or substantial portions of the Software.
21 
22 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
23 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
24 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
25 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
26 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
27 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
28 THE SOFTWARE.
29 
30 */
31 pragma solidity >= 0.5.0; // Incompatible compiler version - please select a compiler within the stated pragma range, or use a different version of the oraclizeAPI!
32 
33 // Dummy contract only used to emit to end-user they are using wrong solc
34 contract solcChecker {
35     /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;
36 }
37 
38 contract OraclizeI {
39 
40     address public cbAddress;
41 
42     function setProofType(byte _proofType) external;
43     function setCustomGasPrice(uint _gasPrice) external;
44     function getPrice(string memory _datasource) public returns (uint _dsprice);
45     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
46     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
47     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
48     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
49     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
50     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
51     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
52     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
53 }
54 
55 contract OraclizeAddrResolverI {
56     function getAddress() public returns (address _address);
57 }
58 /*
59 
60 Begin solidity-cborutils
61 
62 https://github.com/smartcontractkit/solidity-cborutils
63 
64 MIT License
65 
66 Copyright (c) 2018 SmartContract ChainLink, Ltd.
67 
68 Permission is hereby granted, free of charge, to any person obtaining a copy
69 of this software and associated documentation files (the "Software"), to deal
70 in the Software without restriction, including without limitation the rights
71 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
72 copies of the Software, and to permit persons to whom the Software is
73 furnished to do so, subject to the following conditions:
74 
75 The above copyright notice and this permission notice shall be included in all
76 copies or substantial portions of the Software.
77 
78 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
79 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
80 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
81 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
82 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
83 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
84 SOFTWARE.
85 
86 */
87 library Buffer {
88 
89     struct buffer {
90         bytes buf;
91         uint capacity;
92     }
93 
94     function init(buffer memory _buf, uint _capacity) internal pure {
95         uint capacity = _capacity;
96         if (capacity % 32 != 0) {
97             capacity += 32 - (capacity % 32);
98         }
99         _buf.capacity = capacity; // Allocate space for the buffer data
100         assembly {
101             let ptr := mload(0x40)
102             mstore(_buf, ptr)
103             mstore(ptr, 0)
104             mstore(0x40, add(ptr, capacity))
105         }
106     }
107 
108     function resize(buffer memory _buf, uint _capacity) private pure {
109         bytes memory oldbuf = _buf.buf;
110         init(_buf, _capacity);
111         append(_buf, oldbuf);
112     }
113 
114     function max(uint _a, uint _b) private pure returns (uint _max) {
115         if (_a > _b) {
116             return _a;
117         }
118         return _b;
119     }
120     /**
121       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
122       *      would exceed the capacity of the buffer.
123       * @param _buf The buffer to append to.
124       * @param _data The data to append.
125       * @return The original buffer.
126       *
127       */
128     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
129         if (_data.length + _buf.buf.length > _buf.capacity) {
130             resize(_buf, max(_buf.capacity, _data.length) * 2);
131         }
132         uint dest;
133         uint src;
134         uint len = _data.length;
135         assembly {
136             let bufptr := mload(_buf) // Memory address of the buffer data
137             let buflen := mload(bufptr) // Length of existing buffer data
138             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
139             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
140             src := add(_data, 32)
141         }
142         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
143             assembly {
144                 mstore(dest, mload(src))
145             }
146             dest += 32;
147             src += 32;
148         }
149         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
150         assembly {
151             let srcpart := and(mload(src), not(mask))
152             let destpart := and(mload(dest), mask)
153             mstore(dest, or(destpart, srcpart))
154         }
155         return _buf;
156     }
157     /**
158       *
159       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
160       * exceed the capacity of the buffer.
161       * @param _buf The buffer to append to.
162       * @param _data The data to append.
163       * @return The original buffer.
164       *
165       */
166     function append(buffer memory _buf, uint8 _data) internal pure {
167         if (_buf.buf.length + 1 > _buf.capacity) {
168             resize(_buf, _buf.capacity * 2);
169         }
170         assembly {
171             let bufptr := mload(_buf) // Memory address of the buffer data
172             let buflen := mload(bufptr) // Length of existing buffer data
173             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
174             mstore8(dest, _data)
175             mstore(bufptr, add(buflen, 1)) // Update buffer length
176         }
177     }
178     /**
179       *
180       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
181       * exceed the capacity of the buffer.
182       * @param _buf The buffer to append to.
183       * @param _data The data to append.
184       * @return The original buffer.
185       *
186       */
187     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
188         if (_len + _buf.buf.length > _buf.capacity) {
189             resize(_buf, max(_buf.capacity, _len) * 2);
190         }
191         uint mask = 256 ** _len - 1;
192         assembly {
193             let bufptr := mload(_buf) // Memory address of the buffer data
194             let buflen := mload(bufptr) // Length of existing buffer data
195             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
196             mstore(dest, or(and(mload(dest), not(mask)), _data))
197             mstore(bufptr, add(buflen, _len)) // Update buffer length
198         }
199         return _buf;
200     }
201 }
202 
203 library CBOR {
204 
205     using Buffer for Buffer.buffer;
206 
207     uint8 private constant MAJOR_TYPE_INT = 0;
208     uint8 private constant MAJOR_TYPE_MAP = 5;
209     uint8 private constant MAJOR_TYPE_BYTES = 2;
210     uint8 private constant MAJOR_TYPE_ARRAY = 4;
211     uint8 private constant MAJOR_TYPE_STRING = 3;
212     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
213     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
214 
215     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
216         if (_value <= 23) {
217             _buf.append(uint8((_major << 5) | _value));
218         } else if (_value <= 0xFF) {
219             _buf.append(uint8((_major << 5) | 24));
220             _buf.appendInt(_value, 1);
221         } else if (_value <= 0xFFFF) {
222             _buf.append(uint8((_major << 5) | 25));
223             _buf.appendInt(_value, 2);
224         } else if (_value <= 0xFFFFFFFF) {
225             _buf.append(uint8((_major << 5) | 26));
226             _buf.appendInt(_value, 4);
227         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
228             _buf.append(uint8((_major << 5) | 27));
229             _buf.appendInt(_value, 8);
230         }
231     }
232 
233     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
234         _buf.append(uint8((_major << 5) | 31));
235     }
236 
237     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
238         encodeType(_buf, MAJOR_TYPE_INT, _value);
239     }
240 
241     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
242         if (_value >= 0) {
243             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
244         } else {
245             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
246         }
247     }
248 
249     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
250         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
251         _buf.append(_value);
252     }
253 
254     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
255         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
256         _buf.append(bytes(_value));
257     }
258 
259     function startArray(Buffer.buffer memory _buf) internal pure {
260         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
261     }
262 
263     function startMap(Buffer.buffer memory _buf) internal pure {
264         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
265     }
266 
267     function endSequence(Buffer.buffer memory _buf) internal pure {
268         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
269     }
270 }
271 /*
272 
273 End solidity-cborutils
274 
275 */
276 contract usingOraclize {
277 
278     using CBOR for Buffer.buffer;
279 
280     OraclizeI oraclize;
281     OraclizeAddrResolverI OAR;
282 
283     uint constant day = 60 * 60 * 24;
284     uint constant week = 60 * 60 * 24 * 7;
285     uint constant month = 60 * 60 * 24 * 30;
286 
287     byte constant proofType_NONE = 0x00;
288     byte constant proofType_Ledger = 0x30;
289     byte constant proofType_Native = 0xF0;
290     byte constant proofStorage_IPFS = 0x01;
291     byte constant proofType_Android = 0x40;
292     byte constant proofType_TLSNotary = 0x10;
293 
294     string oraclize_network_name;
295     uint8 constant networkID_auto = 0;
296     uint8 constant networkID_morden = 2;
297     uint8 constant networkID_mainnet = 1;
298     uint8 constant networkID_testnet = 2;
299     uint8 constant networkID_consensys = 161;
300 
301     mapping(bytes32 => bytes32) oraclize_randomDS_args;
302     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
303 
304     modifier oraclizeAPI {
305         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
306             oraclize_setNetwork(networkID_auto);
307         }
308         if (address(oraclize) != OAR.getAddress()) {
309             oraclize = OraclizeI(OAR.getAddress());
310         }
311         _;
312     }
313 
314     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
315         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
316         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
317         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
318         require(proofVerified);
319         _;
320     }
321 
322     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
323         return oraclize_setNetwork();
324         _networkID; // silence the warning and remain backwards compatible
325     }
326 
327     function oraclize_setNetworkName(string memory _network_name) internal {
328         oraclize_network_name = _network_name;
329     }
330 
331     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
332         return oraclize_network_name;
333     }
334 
335     function oraclize_setNetwork() internal returns (bool _networkSet) {
336         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
337             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
338             oraclize_setNetworkName("eth_mainnet");
339             return true;
340         }
341         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
342             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
343             oraclize_setNetworkName("eth_ropsten3");
344             return true;
345         }
346         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
347             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
348             oraclize_setNetworkName("eth_kovan");
349             return true;
350         }
351         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
352             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
353             oraclize_setNetworkName("eth_rinkeby");
354             return true;
355         }
356         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
357             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
358             return true;
359         }
360         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
361             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
362             return true;
363         }
364         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
365             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
366             return true;
367         }
368         return false;
369     }
370 
371     function __callback(bytes32 _myid, string memory _result) public {
372         __callback(_myid, _result, new bytes(0));
373     }
374 
375     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
376         return;
377         _myid; _result; _proof; // Silence compiler warnings
378     }
379 
380     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
381         return oraclize.getPrice(_datasource);
382     }
383 
384     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
385         return oraclize.getPrice(_datasource, _gasLimit);
386     }
387 
388     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
389         uint price = oraclize.getPrice(_datasource);
390         if (price > 1 ether + tx.gasprice * 200000) {
391             return 0; // Unexpectedly high price
392         }
393         return oraclize.query.value(price)(0, _datasource, _arg);
394     }
395 
396     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
397         uint price = oraclize.getPrice(_datasource);
398         if (price > 1 ether + tx.gasprice * 200000) {
399             return 0; // Unexpectedly high price
400         }
401         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
402     }
403 
404     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
405         uint price = oraclize.getPrice(_datasource,_gasLimit);
406         if (price > 1 ether + tx.gasprice * _gasLimit) {
407             return 0; // Unexpectedly high price
408         }
409         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
410     }
411 
412     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
413         uint price = oraclize.getPrice(_datasource, _gasLimit);
414         if (price > 1 ether + tx.gasprice * _gasLimit) {
415             return 0; // Unexpectedly high price
416         }
417         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
418     }
419 
420     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
421         uint price = oraclize.getPrice(_datasource);
422         if (price > 1 ether + tx.gasprice * 200000) {
423             return 0; // Unexpectedly high price
424         }
425         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
426     }
427 
428     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
429         uint price = oraclize.getPrice(_datasource);
430         if (price > 1 ether + tx.gasprice * 200000) {
431             return 0; // Unexpectedly high price
432         }
433         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
434     }
435 
436     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
437         uint price = oraclize.getPrice(_datasource, _gasLimit);
438         if (price > 1 ether + tx.gasprice * _gasLimit) {
439             return 0; // Unexpectedly high price
440         }
441         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
442     }
443 
444     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
445         uint price = oraclize.getPrice(_datasource, _gasLimit);
446         if (price > 1 ether + tx.gasprice * _gasLimit) {
447             return 0; // Unexpectedly high price
448         }
449         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
450     }
451 
452     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
453         uint price = oraclize.getPrice(_datasource);
454         if (price > 1 ether + tx.gasprice * 200000) {
455             return 0; // Unexpectedly high price
456         }
457         bytes memory args = stra2cbor(_argN);
458         return oraclize.queryN.value(price)(0, _datasource, args);
459     }
460 
461     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
462         uint price = oraclize.getPrice(_datasource);
463         if (price > 1 ether + tx.gasprice * 200000) {
464             return 0; // Unexpectedly high price
465         }
466         bytes memory args = stra2cbor(_argN);
467         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
468     }
469 
470     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
471         uint price = oraclize.getPrice(_datasource, _gasLimit);
472         if (price > 1 ether + tx.gasprice * _gasLimit) {
473             return 0; // Unexpectedly high price
474         }
475         bytes memory args = stra2cbor(_argN);
476         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
477     }
478 
479     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
480         uint price = oraclize.getPrice(_datasource, _gasLimit);
481         if (price > 1 ether + tx.gasprice * _gasLimit) {
482             return 0; // Unexpectedly high price
483         }
484         bytes memory args = stra2cbor(_argN);
485         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
486     }
487 
488     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
489         string[] memory dynargs = new string[](1);
490         dynargs[0] = _args[0];
491         return oraclize_query(_datasource, dynargs);
492     }
493 
494     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
495         string[] memory dynargs = new string[](1);
496         dynargs[0] = _args[0];
497         return oraclize_query(_timestamp, _datasource, dynargs);
498     }
499 
500     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
501         string[] memory dynargs = new string[](1);
502         dynargs[0] = _args[0];
503         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
504     }
505 
506     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
507         string[] memory dynargs = new string[](1);
508         dynargs[0] = _args[0];
509         return oraclize_query(_datasource, dynargs, _gasLimit);
510     }
511 
512     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
513         string[] memory dynargs = new string[](2);
514         dynargs[0] = _args[0];
515         dynargs[1] = _args[1];
516         return oraclize_query(_datasource, dynargs);
517     }
518 
519     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
520         string[] memory dynargs = new string[](2);
521         dynargs[0] = _args[0];
522         dynargs[1] = _args[1];
523         return oraclize_query(_timestamp, _datasource, dynargs);
524     }
525 
526     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
527         string[] memory dynargs = new string[](2);
528         dynargs[0] = _args[0];
529         dynargs[1] = _args[1];
530         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
531     }
532 
533     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
534         string[] memory dynargs = new string[](2);
535         dynargs[0] = _args[0];
536         dynargs[1] = _args[1];
537         return oraclize_query(_datasource, dynargs, _gasLimit);
538     }
539 
540     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
541         string[] memory dynargs = new string[](3);
542         dynargs[0] = _args[0];
543         dynargs[1] = _args[1];
544         dynargs[2] = _args[2];
545         return oraclize_query(_datasource, dynargs);
546     }
547 
548     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
549         string[] memory dynargs = new string[](3);
550         dynargs[0] = _args[0];
551         dynargs[1] = _args[1];
552         dynargs[2] = _args[2];
553         return oraclize_query(_timestamp, _datasource, dynargs);
554     }
555 
556     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
557         string[] memory dynargs = new string[](3);
558         dynargs[0] = _args[0];
559         dynargs[1] = _args[1];
560         dynargs[2] = _args[2];
561         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
562     }
563 
564     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
565         string[] memory dynargs = new string[](3);
566         dynargs[0] = _args[0];
567         dynargs[1] = _args[1];
568         dynargs[2] = _args[2];
569         return oraclize_query(_datasource, dynargs, _gasLimit);
570     }
571 
572     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
573         string[] memory dynargs = new string[](4);
574         dynargs[0] = _args[0];
575         dynargs[1] = _args[1];
576         dynargs[2] = _args[2];
577         dynargs[3] = _args[3];
578         return oraclize_query(_datasource, dynargs);
579     }
580 
581     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
582         string[] memory dynargs = new string[](4);
583         dynargs[0] = _args[0];
584         dynargs[1] = _args[1];
585         dynargs[2] = _args[2];
586         dynargs[3] = _args[3];
587         return oraclize_query(_timestamp, _datasource, dynargs);
588     }
589 
590     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
591         string[] memory dynargs = new string[](4);
592         dynargs[0] = _args[0];
593         dynargs[1] = _args[1];
594         dynargs[2] = _args[2];
595         dynargs[3] = _args[3];
596         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
597     }
598 
599     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
600         string[] memory dynargs = new string[](4);
601         dynargs[0] = _args[0];
602         dynargs[1] = _args[1];
603         dynargs[2] = _args[2];
604         dynargs[3] = _args[3];
605         return oraclize_query(_datasource, dynargs, _gasLimit);
606     }
607 
608     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
609         string[] memory dynargs = new string[](5);
610         dynargs[0] = _args[0];
611         dynargs[1] = _args[1];
612         dynargs[2] = _args[2];
613         dynargs[3] = _args[3];
614         dynargs[4] = _args[4];
615         return oraclize_query(_datasource, dynargs);
616     }
617 
618     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
619         string[] memory dynargs = new string[](5);
620         dynargs[0] = _args[0];
621         dynargs[1] = _args[1];
622         dynargs[2] = _args[2];
623         dynargs[3] = _args[3];
624         dynargs[4] = _args[4];
625         return oraclize_query(_timestamp, _datasource, dynargs);
626     }
627 
628     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
629         string[] memory dynargs = new string[](5);
630         dynargs[0] = _args[0];
631         dynargs[1] = _args[1];
632         dynargs[2] = _args[2];
633         dynargs[3] = _args[3];
634         dynargs[4] = _args[4];
635         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
636     }
637 
638     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
639         string[] memory dynargs = new string[](5);
640         dynargs[0] = _args[0];
641         dynargs[1] = _args[1];
642         dynargs[2] = _args[2];
643         dynargs[3] = _args[3];
644         dynargs[4] = _args[4];
645         return oraclize_query(_datasource, dynargs, _gasLimit);
646     }
647 
648     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
649         uint price = oraclize.getPrice(_datasource);
650         if (price > 1 ether + tx.gasprice * 200000) {
651             return 0; // Unexpectedly high price
652         }
653         bytes memory args = ba2cbor(_argN);
654         return oraclize.queryN.value(price)(0, _datasource, args);
655     }
656 
657     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
658         uint price = oraclize.getPrice(_datasource);
659         if (price > 1 ether + tx.gasprice * 200000) {
660             return 0; // Unexpectedly high price
661         }
662         bytes memory args = ba2cbor(_argN);
663         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
664     }
665 
666     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
667         uint price = oraclize.getPrice(_datasource, _gasLimit);
668         if (price > 1 ether + tx.gasprice * _gasLimit) {
669             return 0; // Unexpectedly high price
670         }
671         bytes memory args = ba2cbor(_argN);
672         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
673     }
674 
675     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
676         uint price = oraclize.getPrice(_datasource, _gasLimit);
677         if (price > 1 ether + tx.gasprice * _gasLimit) {
678             return 0; // Unexpectedly high price
679         }
680         bytes memory args = ba2cbor(_argN);
681         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
682     }
683 
684     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
685         bytes[] memory dynargs = new bytes[](1);
686         dynargs[0] = _args[0];
687         return oraclize_query(_datasource, dynargs);
688     }
689 
690     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
691         bytes[] memory dynargs = new bytes[](1);
692         dynargs[0] = _args[0];
693         return oraclize_query(_timestamp, _datasource, dynargs);
694     }
695 
696     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
697         bytes[] memory dynargs = new bytes[](1);
698         dynargs[0] = _args[0];
699         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
700     }
701 
702     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
703         bytes[] memory dynargs = new bytes[](1);
704         dynargs[0] = _args[0];
705         return oraclize_query(_datasource, dynargs, _gasLimit);
706     }
707 
708     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
709         bytes[] memory dynargs = new bytes[](2);
710         dynargs[0] = _args[0];
711         dynargs[1] = _args[1];
712         return oraclize_query(_datasource, dynargs);
713     }
714 
715     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
716         bytes[] memory dynargs = new bytes[](2);
717         dynargs[0] = _args[0];
718         dynargs[1] = _args[1];
719         return oraclize_query(_timestamp, _datasource, dynargs);
720     }
721 
722     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
723         bytes[] memory dynargs = new bytes[](2);
724         dynargs[0] = _args[0];
725         dynargs[1] = _args[1];
726         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
727     }
728 
729     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
730         bytes[] memory dynargs = new bytes[](2);
731         dynargs[0] = _args[0];
732         dynargs[1] = _args[1];
733         return oraclize_query(_datasource, dynargs, _gasLimit);
734     }
735 
736     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
737         bytes[] memory dynargs = new bytes[](3);
738         dynargs[0] = _args[0];
739         dynargs[1] = _args[1];
740         dynargs[2] = _args[2];
741         return oraclize_query(_datasource, dynargs);
742     }
743 
744     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
745         bytes[] memory dynargs = new bytes[](3);
746         dynargs[0] = _args[0];
747         dynargs[1] = _args[1];
748         dynargs[2] = _args[2];
749         return oraclize_query(_timestamp, _datasource, dynargs);
750     }
751 
752     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
753         bytes[] memory dynargs = new bytes[](3);
754         dynargs[0] = _args[0];
755         dynargs[1] = _args[1];
756         dynargs[2] = _args[2];
757         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
758     }
759 
760     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
761         bytes[] memory dynargs = new bytes[](3);
762         dynargs[0] = _args[0];
763         dynargs[1] = _args[1];
764         dynargs[2] = _args[2];
765         return oraclize_query(_datasource, dynargs, _gasLimit);
766     }
767 
768     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
769         bytes[] memory dynargs = new bytes[](4);
770         dynargs[0] = _args[0];
771         dynargs[1] = _args[1];
772         dynargs[2] = _args[2];
773         dynargs[3] = _args[3];
774         return oraclize_query(_datasource, dynargs);
775     }
776 
777     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
778         bytes[] memory dynargs = new bytes[](4);
779         dynargs[0] = _args[0];
780         dynargs[1] = _args[1];
781         dynargs[2] = _args[2];
782         dynargs[3] = _args[3];
783         return oraclize_query(_timestamp, _datasource, dynargs);
784     }
785 
786     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
787         bytes[] memory dynargs = new bytes[](4);
788         dynargs[0] = _args[0];
789         dynargs[1] = _args[1];
790         dynargs[2] = _args[2];
791         dynargs[3] = _args[3];
792         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
793     }
794 
795     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
796         bytes[] memory dynargs = new bytes[](4);
797         dynargs[0] = _args[0];
798         dynargs[1] = _args[1];
799         dynargs[2] = _args[2];
800         dynargs[3] = _args[3];
801         return oraclize_query(_datasource, dynargs, _gasLimit);
802     }
803 
804     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
805         bytes[] memory dynargs = new bytes[](5);
806         dynargs[0] = _args[0];
807         dynargs[1] = _args[1];
808         dynargs[2] = _args[2];
809         dynargs[3] = _args[3];
810         dynargs[4] = _args[4];
811         return oraclize_query(_datasource, dynargs);
812     }
813 
814     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
815         bytes[] memory dynargs = new bytes[](5);
816         dynargs[0] = _args[0];
817         dynargs[1] = _args[1];
818         dynargs[2] = _args[2];
819         dynargs[3] = _args[3];
820         dynargs[4] = _args[4];
821         return oraclize_query(_timestamp, _datasource, dynargs);
822     }
823 
824     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
825         bytes[] memory dynargs = new bytes[](5);
826         dynargs[0] = _args[0];
827         dynargs[1] = _args[1];
828         dynargs[2] = _args[2];
829         dynargs[3] = _args[3];
830         dynargs[4] = _args[4];
831         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
832     }
833 
834     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
835         bytes[] memory dynargs = new bytes[](5);
836         dynargs[0] = _args[0];
837         dynargs[1] = _args[1];
838         dynargs[2] = _args[2];
839         dynargs[3] = _args[3];
840         dynargs[4] = _args[4];
841         return oraclize_query(_datasource, dynargs, _gasLimit);
842     }
843 
844     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
845         return oraclize.setProofType(_proofP);
846     }
847 
848 
849     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
850         return oraclize.cbAddress();
851     }
852 
853     function getCodeSize(address _addr) view internal returns (uint _size) {
854         assembly {
855             _size := extcodesize(_addr)
856         }
857     }
858 
859     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
860         return oraclize.setCustomGasPrice(_gasPrice);
861     }
862 
863     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
864         return oraclize.randomDS_getSessionPubKeyHash();
865     }
866 
867     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
868         bytes memory tmp = bytes(_a);
869         uint160 iaddr = 0;
870         uint160 b1;
871         uint160 b2;
872         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
873             iaddr *= 256;
874             b1 = uint160(uint8(tmp[i]));
875             b2 = uint160(uint8(tmp[i + 1]));
876             if ((b1 >= 97) && (b1 <= 102)) {
877                 b1 -= 87;
878             } else if ((b1 >= 65) && (b1 <= 70)) {
879                 b1 -= 55;
880             } else if ((b1 >= 48) && (b1 <= 57)) {
881                 b1 -= 48;
882             }
883             if ((b2 >= 97) && (b2 <= 102)) {
884                 b2 -= 87;
885             } else if ((b2 >= 65) && (b2 <= 70)) {
886                 b2 -= 55;
887             } else if ((b2 >= 48) && (b2 <= 57)) {
888                 b2 -= 48;
889             }
890             iaddr += (b1 * 16 + b2);
891         }
892         return address(iaddr);
893     }
894 
895     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
896         bytes memory a = bytes(_a);
897         bytes memory b = bytes(_b);
898         uint minLength = a.length;
899         if (b.length < minLength) {
900             minLength = b.length;
901         }
902         for (uint i = 0; i < minLength; i ++) {
903             if (a[i] < b[i]) {
904                 return -1;
905             } else if (a[i] > b[i]) {
906                 return 1;
907             }
908         }
909         if (a.length < b.length) {
910             return -1;
911         } else if (a.length > b.length) {
912             return 1;
913         } else {
914             return 0;
915         }
916     }
917 
918     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
919         bytes memory h = bytes(_haystack);
920         bytes memory n = bytes(_needle);
921         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
922             return -1;
923         } else if (h.length > (2 ** 128 - 1)) {
924             return -1;
925         } else {
926             uint subindex = 0;
927             for (uint i = 0; i < h.length; i++) {
928                 if (h[i] == n[0]) {
929                     subindex = 1;
930                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
931                         subindex++;
932                     }
933                     if (subindex == n.length) {
934                         return int(i);
935                     }
936                 }
937             }
938             return -1;
939         }
940     }
941 
942     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
943         return strConcat(_a, _b, "", "", "");
944     }
945 
946     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
947         return strConcat(_a, _b, _c, "", "");
948     }
949 
950     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
951         return strConcat(_a, _b, _c, _d, "");
952     }
953 
954     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
955         bytes memory _ba = bytes(_a);
956         bytes memory _bb = bytes(_b);
957         bytes memory _bc = bytes(_c);
958         bytes memory _bd = bytes(_d);
959         bytes memory _be = bytes(_e);
960         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
961         bytes memory babcde = bytes(abcde);
962         uint k = 0;
963         uint i = 0;
964         for (i = 0; i < _ba.length; i++) {
965             babcde[k++] = _ba[i];
966         }
967         for (i = 0; i < _bb.length; i++) {
968             babcde[k++] = _bb[i];
969         }
970         for (i = 0; i < _bc.length; i++) {
971             babcde[k++] = _bc[i];
972         }
973         for (i = 0; i < _bd.length; i++) {
974             babcde[k++] = _bd[i];
975         }
976         for (i = 0; i < _be.length; i++) {
977             babcde[k++] = _be[i];
978         }
979         return string(babcde);
980     }
981 
982     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
983         return safeParseInt(_a, 0);
984     }
985 
986     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
987         bytes memory bresult = bytes(_a);
988         uint mint = 0;
989         bool decimals = false;
990         for (uint i = 0; i < bresult.length; i++) {
991             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
992                 if (decimals) {
993                     if (_b == 0) break;
994                     else _b--;
995                 }
996                 mint *= 10;
997                 mint += uint(uint8(bresult[i])) - 48;
998             } else if (uint(uint8(bresult[i])) == 46) {
999                 require(!decimals, 'More than one decimal encountered in string!');
1000                 decimals = true;
1001             } else {
1002                 revert("Non-numeral character encountered in string!");
1003             }
1004         }
1005         if (_b > 0) {
1006             mint *= 10 ** _b;
1007         }
1008         return mint;
1009     }
1010 
1011     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
1012         return parseInt(_a, 0);
1013     }
1014 
1015     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1016         bytes memory bresult = bytes(_a);
1017         uint mint = 0;
1018         bool decimals = false;
1019         for (uint i = 0; i < bresult.length; i++) {
1020             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1021                 if (decimals) {
1022                     if (_b == 0) {
1023                         break;
1024                     } else {
1025                         _b--;
1026                     }
1027                 }
1028                 mint *= 10;
1029                 mint += uint(uint8(bresult[i])) - 48;
1030             } else if (uint(uint8(bresult[i])) == 46) {
1031                 decimals = true;
1032             }
1033         }
1034         if (_b > 0) {
1035             mint *= 10 ** _b;
1036         }
1037         return mint;
1038     }
1039 
1040     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1041         if (_i == 0) {
1042             return "0";
1043         }
1044         uint j = _i;
1045         uint len;
1046         while (j != 0) {
1047             len++;
1048             j /= 10;
1049         }
1050         bytes memory bstr = new bytes(len);
1051         uint k = len - 1;
1052         while (_i != 0) {
1053             bstr[k--] = byte(uint8(48 + _i % 10));
1054             _i /= 10;
1055         }
1056         return string(bstr);
1057     }
1058 
1059     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1060         safeMemoryCleaner();
1061         Buffer.buffer memory buf;
1062         Buffer.init(buf, 1024);
1063         buf.startArray();
1064         for (uint i = 0; i < _arr.length; i++) {
1065             buf.encodeString(_arr[i]);
1066         }
1067         buf.endSequence();
1068         return buf.buf;
1069     }
1070 
1071     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1072         safeMemoryCleaner();
1073         Buffer.buffer memory buf;
1074         Buffer.init(buf, 1024);
1075         buf.startArray();
1076         for (uint i = 0; i < _arr.length; i++) {
1077             buf.encodeBytes(_arr[i]);
1078         }
1079         buf.endSequence();
1080         return buf.buf;
1081     }
1082 
1083     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1084         require((_nbytes > 0) && (_nbytes <= 32));
1085         _delay *= 10; // Convert from seconds to ledger timer ticks
1086         bytes memory nbytes = new bytes(1);
1087         nbytes[0] = byte(uint8(_nbytes));
1088         bytes memory unonce = new bytes(32);
1089         bytes memory sessionKeyHash = new bytes(32);
1090         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1091         assembly {
1092             mstore(unonce, 0x20)
1093         /*
1094          The following variables can be relaxed.
1095          Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1096          for an idea on how to override and replace commit hash variables.
1097         */
1098             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1099             mstore(sessionKeyHash, 0x20)
1100             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1101         }
1102         bytes memory delay = new bytes(32);
1103         assembly {
1104             mstore(add(delay, 0x20), _delay)
1105         }
1106         bytes memory delay_bytes8 = new bytes(8);
1107         copyBytes(delay, 24, 8, delay_bytes8, 0);
1108         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1109         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1110         bytes memory delay_bytes8_left = new bytes(8);
1111         assembly {
1112             let x := mload(add(delay_bytes8, 0x20))
1113             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1114             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1115             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1116             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1117             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1118             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1119             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1120             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1121         }
1122         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1123         return queryId;
1124     }
1125 
1126     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1127         oraclize_randomDS_args[_queryId] = _commitment;
1128     }
1129 
1130     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1131         bool sigok;
1132         address signer;
1133         bytes32 sigr;
1134         bytes32 sigs;
1135         bytes memory sigr_ = new bytes(32);
1136         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1137         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1138         bytes memory sigs_ = new bytes(32);
1139         offset += 32 + 2;
1140         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1141         assembly {
1142             sigr := mload(add(sigr_, 32))
1143             sigs := mload(add(sigs_, 32))
1144         }
1145         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1146         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1147             return true;
1148         } else {
1149             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1150             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1151         }
1152     }
1153 
1154     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1155         bool sigok;
1156         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1157         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1158         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1159         bytes memory appkey1_pubkey = new bytes(64);
1160         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1161         bytes memory tosign2 = new bytes(1 + 65 + 32);
1162         tosign2[0] = byte(uint8(1)); //role
1163         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1164         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1165         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1166         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1167         if (!sigok) {
1168             return false;
1169         }
1170         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1171         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1172         bytes memory tosign3 = new bytes(1 + 65);
1173         tosign3[0] = 0xFE;
1174         copyBytes(_proof, 3, 65, tosign3, 1);
1175         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1176         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1177         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1178         return sigok;
1179     }
1180 
1181     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1182         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1183         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1184             return 1;
1185         }
1186         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1187         if (!proofVerified) {
1188             return 2;
1189         }
1190         return 0;
1191     }
1192 
1193     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1194         bool match_ = true;
1195         require(_prefix.length == _nRandomBytes);
1196         for (uint256 i = 0; i< _nRandomBytes; i++) {
1197             if (_content[i] != _prefix[i]) {
1198                 match_ = false;
1199             }
1200         }
1201         return match_;
1202     }
1203 
1204     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1205         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1206         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1207         bytes memory keyhash = new bytes(32);
1208         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1209         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1210             return false;
1211         }
1212         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1213         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1214         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1215         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1216             return false;
1217         }
1218         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1219         // This is to verify that the computed args match with the ones specified in the query.
1220         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1221         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1222         bytes memory sessionPubkey = new bytes(64);
1223         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1224         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1225         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1226         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1227             delete oraclize_randomDS_args[_queryId];
1228         } else return false;
1229         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1230         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1231         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1232         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1233             return false;
1234         }
1235         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1236         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1237             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1238         }
1239         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1240     }
1241     /*
1242      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1243     */
1244     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1245         uint minLength = _length + _toOffset;
1246         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1247         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1248         uint j = 32 + _toOffset;
1249         while (i < (32 + _fromOffset + _length)) {
1250             assembly {
1251                 let tmp := mload(add(_from, i))
1252                 mstore(add(_to, j), tmp)
1253             }
1254             i += 32;
1255             j += 32;
1256         }
1257         return _to;
1258     }
1259     /*
1260      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1261      Duplicate Solidity's ecrecover, but catching the CALL return value
1262     */
1263     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1264         /*
1265          We do our own memory management here. Solidity uses memory offset
1266          0x40 to store the current end of memory. We write past it (as
1267          writes are memory extensions), but don't update the offset so
1268          Solidity will reuse it. The memory used here is only needed for
1269          this context.
1270          FIXME: inline assembly can't access return values
1271         */
1272         bool ret;
1273         address addr;
1274         assembly {
1275             let size := mload(0x40)
1276             mstore(size, _hash)
1277             mstore(add(size, 32), _v)
1278             mstore(add(size, 64), _r)
1279             mstore(add(size, 96), _s)
1280             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1281             addr := mload(size)
1282         }
1283         return (ret, addr);
1284     }
1285     /*
1286      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1287     */
1288     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1289         bytes32 r;
1290         bytes32 s;
1291         uint8 v;
1292         if (_sig.length != 65) {
1293             return (false, address(0));
1294         }
1295         /*
1296          The signature format is a compact form of:
1297            {bytes32 r}{bytes32 s}{uint8 v}
1298          Compact means, uint8 is not padded to 32 bytes.
1299         */
1300         assembly {
1301             r := mload(add(_sig, 32))
1302             s := mload(add(_sig, 64))
1303         /*
1304          Here we are loading the last 32 bytes. We exploit the fact that
1305          'mload' will pad with zeroes if we overread.
1306          There is no 'mload8' to do this, but that would be nicer.
1307         */
1308             v := byte(0, mload(add(_sig, 96)))
1309         /*
1310           Alternative solution:
1311           'byte' is not working due to the Solidity parser, so lets
1312           use the second best option, 'and'
1313           v := and(mload(add(_sig, 65)), 255)
1314         */
1315         }
1316         /*
1317          albeit non-transactional signatures are not specified by the YP, one would expect it
1318          to match the YP range of [27, 28]
1319          geth uses [0, 1] and some clients have followed. This might change, see:
1320          https://github.com/ethereum/go-ethereum/issues/2053
1321         */
1322         if (v < 27) {
1323             v += 27;
1324         }
1325         if (v != 27 && v != 28) {
1326             return (false, address(0));
1327         }
1328         return safer_ecrecover(_hash, v, r, s);
1329     }
1330 
1331     function safeMemoryCleaner() internal pure {
1332         assembly {
1333             let fmem := mload(0x40)
1334             codecopy(fmem, codesize, sub(msize, fmem))
1335         }
1336     }
1337 }
1338 /*
1339 
1340 END ORACLIZE_API
1341 
1342 */
1343 
1344 
1345 library SafeMath {
1346     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
1347         if (a == 0) {
1348             return 0;
1349         }
1350         c = a * b;
1351         assert(c / a == b);
1352         return c;
1353     }
1354 
1355     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1356         return a / b;
1357     }
1358 
1359     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1360         assert(b <= a);
1361         return a - b;
1362     }
1363 
1364     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1365         c = a + b;
1366         assert(c >= a);
1367         return c;
1368     }
1369 }
1370 
1371 contract Ownable {
1372     address payable owner; //for tokens
1373     mapping(address => bool) owners;
1374 
1375     event OwnerAdded(address indexed newOwner);
1376     event OwnerDeleted(address indexed owner);
1377 
1378     /**
1379      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1380      * account.
1381      */
1382     constructor() public {
1383         owners[0x2AE5E830981F322A579A8D812D4CEDF161259791] = true;
1384         owner = 0x2AE5E830981F322A579A8D812D4CEDF161259791;
1385     }
1386 
1387 
1388     modifier onlyOwner() {
1389         require(isOwner(msg.sender));
1390         _;
1391     }
1392 
1393     function addOwner(address _newOwner) external onlyOwner {
1394         require(_newOwner != address(0));
1395         owners[_newOwner] = true;
1396         emit OwnerAdded(_newOwner);
1397     }
1398 
1399     function delOwner(address _owner) external onlyOwner {
1400         require(owners[_owner]);
1401         owners[_owner] = false;
1402         emit OwnerDeleted(_owner);
1403     }
1404 
1405     function isOwner(address _owner) public view returns (bool) {
1406         return owners[_owner];
1407     }
1408 
1409     function changeMainOwner(address payable _owner) public {
1410         require(_owner != address(0));
1411         owner = _owner;
1412     }
1413 }
1414 
1415 interface tokenRecipient {
1416     function receiveApproval(
1417         address _from,
1418         uint256 _value,
1419         address _token,
1420         bytes calldata _extraData
1421     ) external;
1422 }
1423 
1424 contract Mitoshi is Ownable, usingOraclize {
1425     using SafeMath for uint256;
1426 
1427     string public name = "Mitoshi";
1428     string public symbol = "MTSH";
1429     uint8 public decimals = 18;
1430     uint256 DEC = 10 ** uint256(decimals);
1431 
1432     uint256 public totalSupply = 100000000 * DEC;
1433     uint256 public tokensForSale = 68000000 * DEC;
1434     uint256 minPurchase = 25 ether;
1435     uint256 public curs = 140;
1436     uint256 public oraclizeBalance;
1437     uint256 public goal = 2000000 ether;
1438     uint256 public cap = 10000000 ether;
1439     uint256 public USDRaised;
1440 
1441     mapping(address => uint256) deposited;
1442     mapping(address => uint256) public balanceOf;
1443     mapping(address => mapping(address => uint256)) public allowance;
1444 
1445     event Transfer(address indexed from, address indexed to, uint256 value);
1446     event Approval(address indexed owner, address indexed spender, uint256 value);
1447     event Burn(address indexed from, uint256 value);
1448     event RefundsEnabled();
1449     event Closed();
1450     event Refunded(address indexed beneficiary, uint256 weiAmount);
1451     event LogPriceUpdated(string price);
1452     event LogNewOraclizeQuery(string description);
1453 
1454     enum State {Active, Refunding, Closed}
1455     State public state;
1456 
1457     modifier transferredIsOn {
1458         require(state == State.Closed);
1459         _;
1460     }
1461 
1462     modifier sellIsOn {
1463         require(state == State.Active);
1464         _;
1465     }
1466 
1467     constructor() public {
1468         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1469         balanceOf[0x2AE5E830981F322A579A8D812D4CEDF161259791] = totalSupply;
1470         state = State.Active;
1471     }
1472 
1473     function() external payable {
1474         buyTokens(msg.sender);
1475     }
1476 
1477 
1478 
1479     function __callback(bytes32 myid, string memory result, bytes memory proof) public {
1480         myid;
1481         proof;
1482         if (msg.sender != oraclize_cbAddress()) revert();
1483         curs = parseInt(result);
1484         emit LogPriceUpdated(result);
1485         updatePrice();
1486     }
1487 
1488 
1489     function transfer(address _to, uint256 _value) transferredIsOn public {
1490         _transfer(msg.sender, _to, _value);
1491     }
1492 
1493     function transferFrom(address _from, address _to, uint256 _value) transferredIsOn public returns (bool success) {
1494         require(_value <= allowance[_from][msg.sender]);
1495         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
1496         _transfer(_from, _to, _value);
1497         return true;
1498     }
1499 
1500     function approve(address _spender, uint256 _value) public returns (bool success) {
1501         require((_value == 0) || (allowance[msg.sender][_spender] == 0));
1502 
1503         allowance[msg.sender][_spender] = _value;
1504         emit Approval(msg.sender, _spender, _value);
1505         return true;
1506     }
1507 
1508     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
1509     public
1510     returns (bool success) {
1511         tokenRecipient spender = tokenRecipient(_spender);
1512         if (approve(_spender, _value)) {
1513             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
1514             return true;
1515         }
1516     }
1517 
1518     function transferOwner(address _to, uint256 _value) onlyOwner public {
1519         _transfer(msg.sender, _to, _value);
1520     }
1521 
1522     function _transfer(address _from, address _to, uint _value) internal {
1523         require(_to != address(0));
1524         require(balanceOf[_from] >= _value);
1525         require(balanceOf[_to].add(_value) >= balanceOf[_to]);
1526         balanceOf[_from] = balanceOf[_from].sub(_value);
1527         balanceOf[_to] = balanceOf[_to].add(_value);
1528         emit Transfer(_from, _to, _value);
1529     }
1530 
1531 
1532     function buyTokens(address beneficiary) sellIsOn payable public {
1533         uint cost;
1534         uint bonus;
1535 
1536         (cost, bonus) = getCostAndBonus();
1537         uint rate = 1 ether * curs / cost;
1538         uint amount = rate.mul(msg.value);
1539 
1540         require(amount >= minPurchase && amount <= tokensForSale);
1541 
1542         amount = amount.add(amount.mul(bonus).div(100));
1543 
1544         _transfer(owner, beneficiary, amount);
1545 
1546         tokensForSale = tokensForSale.sub(amount);
1547         USDRaised = USDRaised.add(msg.value.mul(curs));
1548         deposited[beneficiary] = deposited[beneficiary].add(msg.value);
1549     }
1550 
1551 
1552     function manualSale(address beneficiary, uint amount, uint ethValue) onlyOwner public {
1553         _transfer(owner, beneficiary, amount);
1554 
1555         tokensForSale = tokensForSale.sub(amount);
1556         USDRaised = USDRaised.add(ethValue.mul(curs));
1557         deposited[beneficiary] = deposited[beneficiary].add(ethValue);
1558     }
1559 
1560     function enableRefunds() onlyOwner sellIsOn public {
1561         require(USDRaised < goal);
1562         state = State.Refunding;
1563         emit RefundsEnabled();
1564     }
1565 
1566     function close() onlyOwner public {
1567         require(USDRaised >= goal);
1568         state = State.Closed;
1569         emit Closed();
1570     }
1571 
1572     function refund(address payable investor) public {
1573         require(state == State.Refunding);
1574         require(deposited[investor] > 0);
1575         uint256 depositedValue = deposited[investor];
1576         investor.transfer(depositedValue);
1577         emit Refunded(investor, depositedValue);
1578         deposited[investor] = 0;
1579     }
1580 
1581     function withdrawETH(uint _val) onlyOwner external {
1582         require(address(this).balance > 0);
1583         owner.transfer(_val);
1584     }
1585 
1586     function burn(uint256 _value) public returns (bool success) {
1587         require(balanceOf[msg.sender] >= _value);
1588         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
1589         emit Burn(msg.sender, _value);
1590         return true;
1591     }
1592 
1593     function updateCurs(uint256 _value) onlyOwner public {
1594         curs = _value;
1595     }
1596 
1597 
1598 
1599     //15 June 2019 to 14 July 2019 1560546000 1563138000
1600     //15 July 2019 to 14 August 2019 1563138000 1565816400
1601     //15 August 2019 to 14 September 2019 1565816400 1568494800
1602 
1603     //15 September 2019 to 14 October 2019 1568494800 1571086800
1604     //15 October 2019 to 14 November 2019 1571086800 1573765200
1605     //15 November 2019 1573765200
1606 
1607 
1608     function getCostAndBonus() internal view returns(uint, uint) {
1609         uint cost;
1610         if (block.timestamp >= 1560546000 && block.timestamp < 1563138000) {
1611             cost = 10 * DEC / 100;
1612             return (cost, 30);
1613         } else if (block.timestamp >= 1563138000 && block.timestamp < 1565816400) {
1614             cost = 14 * DEC / 100;
1615             return (cost, 25);
1616         } else if (block.timestamp >= 1565816400 && block.timestamp < 1568494800) {
1617             cost = 16 * DEC / 100;
1618             return (cost, 20);
1619         } else if (block.timestamp >= 1568494800 && block.timestamp < 1571086800) {
1620             cost = 18 * DEC / 100;
1621             return (cost, 15);
1622         } else if (block.timestamp >= 1571086800 && block.timestamp < 1573765200) {
1623             cost = 20 * DEC / 100;
1624             return (cost, 10);
1625         } else if (block.timestamp >= 1573765200) {
1626             cost = 20 * DEC / 100;
1627             return (cost, 0);
1628         } else return (0,0);
1629     }
1630 
1631     function updatePrice() sellIsOn payable public {
1632         if (oraclize_getPrice("URL") > address(this).balance) {
1633             emit LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1634         } else {
1635             emit LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1636             //43200 = 12 hour
1637             oraclize_query(43200, "URL", "json(https://api.gdax.com/products/ETH-USD/ticker).price");
1638         }
1639     }
1640 
1641     function setGasPrice(uint _newPrice) onlyOwner public {
1642         oraclize_setCustomGasPrice(_newPrice * 1 wei);
1643     }
1644 
1645     function addBalanceForOraclize() payable external {
1646         oraclizeBalance = oraclizeBalance.add(msg.value);
1647     }
1648 }