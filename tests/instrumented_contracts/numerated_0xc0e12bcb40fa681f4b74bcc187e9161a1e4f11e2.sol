1 pragma solidity ^0.5.1;
2 
3 contract OraclizeI {
4 
5     address public cbAddress;
6 
7     function setProofType(byte _proofType) external;
8     function setCustomGasPrice(uint _gasPrice) external;
9     function getPrice(string memory _datasource) public returns (uint _dsprice);
10     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
11     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
12     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
13     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
14     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
15     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
16     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
17     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
18 }
19 
20 contract OraclizeAddrResolverI {
21     function getAddress() public returns (address _address);
22 }
23 /*
24 
25 Begin solidity-cborutils
26 
27 https://github.com/smartcontractkit/solidity-cborutils
28 
29 MIT License
30 
31 Copyright (c) 2018 SmartContract ChainLink, Ltd.
32 
33 Permission is hereby granted, free of charge, to any person obtaining a copy
34 of this software and associated documentation files (the "Software"), to deal
35 in the Software without restriction, including without limitation the rights
36 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
37 copies of the Software, and to permit persons to whom the Software is
38 furnished to do so, subject to the following conditions:
39 
40 The above copyright notice and this permission notice shall be included in all
41 copies or substantial portions of the Software.
42 
43 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
44 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
45 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
46 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
47 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
48 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
49 SOFTWARE.
50 
51 */
52 library Buffer {
53 
54     struct buffer {
55         bytes buf;
56         uint capacity;
57     }
58 
59     function init(buffer memory _buf, uint _capacity) internal pure {
60         uint capacity = _capacity;
61         if (capacity % 32 != 0) {
62             capacity += 32 - (capacity % 32);
63         }
64         _buf.capacity = capacity; // Allocate space for the buffer data
65         assembly {
66             let ptr := mload(0x40)
67             mstore(_buf, ptr)
68             mstore(ptr, 0)
69             mstore(0x40, add(ptr, capacity))
70         }
71     }
72 
73     function resize(buffer memory _buf, uint _capacity) private pure {
74         bytes memory oldbuf = _buf.buf;
75         init(_buf, _capacity);
76         append(_buf, oldbuf);
77     }
78 
79     function max(uint _a, uint _b) private pure returns (uint _max) {
80         if (_a > _b) {
81             return _a;
82         }
83         return _b;
84     }
85     /**
86       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
87       *      would exceed the capacity of the buffer.
88       * @param _buf The buffer to append to.
89       * @param _data The data to append.
90       * @return The original buffer.
91       *
92       */
93     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
94         if (_data.length + _buf.buf.length > _buf.capacity) {
95             resize(_buf, max(_buf.capacity, _data.length) * 2);
96         }
97         uint dest;
98         uint src;
99         uint len = _data.length;
100         assembly {
101             let bufptr := mload(_buf) // Memory address of the buffer data
102             let buflen := mload(bufptr) // Length of existing buffer data
103             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
104             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
105             src := add(_data, 32)
106         }
107         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
108             assembly {
109                 mstore(dest, mload(src))
110             }
111             dest += 32;
112             src += 32;
113         }
114         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
115         assembly {
116             let srcpart := and(mload(src), not(mask))
117             let destpart := and(mload(dest), mask)
118             mstore(dest, or(destpart, srcpart))
119         }
120         return _buf;
121     }
122     /**
123       *
124       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
125       * exceed the capacity of the buffer.
126       * @param _buf The buffer to append to.
127       * @param _data The data to append.
128       * @return The original buffer.
129       *
130       */
131     function append(buffer memory _buf, uint8 _data) internal pure {
132         if (_buf.buf.length + 1 > _buf.capacity) {
133             resize(_buf, _buf.capacity * 2);
134         }
135         assembly {
136             let bufptr := mload(_buf) // Memory address of the buffer data
137             let buflen := mload(bufptr) // Length of existing buffer data
138             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
139             mstore8(dest, _data)
140             mstore(bufptr, add(buflen, 1)) // Update buffer length
141         }
142     }
143     /**
144       *
145       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
146       * exceed the capacity of the buffer.
147       * @param _buf The buffer to append to.
148       * @param _data The data to append.
149       * @return The original buffer.
150       *
151       */
152     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
153         if (_len + _buf.buf.length > _buf.capacity) {
154             resize(_buf, max(_buf.capacity, _len) * 2);
155         }
156         uint mask = 256 ** _len - 1;
157         assembly {
158             let bufptr := mload(_buf) // Memory address of the buffer data
159             let buflen := mload(bufptr) // Length of existing buffer data
160             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
161             mstore(dest, or(and(mload(dest), not(mask)), _data))
162             mstore(bufptr, add(buflen, _len)) // Update buffer length
163         }
164         return _buf;
165     }
166 }
167 
168 library CBOR {
169 
170     using Buffer for Buffer.buffer;
171 
172     uint8 private constant MAJOR_TYPE_INT = 0;
173     uint8 private constant MAJOR_TYPE_MAP = 5;
174     uint8 private constant MAJOR_TYPE_BYTES = 2;
175     uint8 private constant MAJOR_TYPE_ARRAY = 4;
176     uint8 private constant MAJOR_TYPE_STRING = 3;
177     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
178     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
179 
180     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
181         if (_value <= 23) {
182             _buf.append(uint8((_major << 5) | _value));
183         } else if (_value <= 0xFF) {
184             _buf.append(uint8((_major << 5) | 24));
185             _buf.appendInt(_value, 1);
186         } else if (_value <= 0xFFFF) {
187             _buf.append(uint8((_major << 5) | 25));
188             _buf.appendInt(_value, 2);
189         } else if (_value <= 0xFFFFFFFF) {
190             _buf.append(uint8((_major << 5) | 26));
191             _buf.appendInt(_value, 4);
192         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
193             _buf.append(uint8((_major << 5) | 27));
194             _buf.appendInt(_value, 8);
195         }
196     }
197 
198     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
199         _buf.append(uint8((_major << 5) | 31));
200     }
201 
202     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
203         encodeType(_buf, MAJOR_TYPE_INT, _value);
204     }
205 
206     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
207         if (_value >= 0) {
208             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
209         } else {
210             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
211         }
212     }
213 
214     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
215         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
216         _buf.append(_value);
217     }
218 
219     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
220         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
221         _buf.append(bytes(_value));
222     }
223 
224     function startArray(Buffer.buffer memory _buf) internal pure {
225         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
226     }
227 
228     function startMap(Buffer.buffer memory _buf) internal pure {
229         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
230     }
231 
232     function endSequence(Buffer.buffer memory _buf) internal pure {
233         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
234     }
235 }
236 /*
237 
238 End solidity-cborutils
239 
240 */
241 contract usingOraclize {
242 
243     using CBOR for Buffer.buffer;
244 
245     OraclizeI oraclize;
246     OraclizeAddrResolverI OAR;
247 
248     uint constant day = 60 * 60 * 24;
249     uint constant week = 60 * 60 * 24 * 7;
250     uint constant month = 60 * 60 * 24 * 30;
251 
252     byte constant proofType_NONE = 0x00;
253     byte constant proofType_Ledger = 0x30;
254     byte constant proofType_Native = 0xF0;
255     byte constant proofStorage_IPFS = 0x01;
256     byte constant proofType_Android = 0x40;
257     byte constant proofType_TLSNotary = 0x10;
258 
259     string oraclize_network_name;
260     uint8 constant networkID_auto = 0;
261     uint8 constant networkID_morden = 2;
262     uint8 constant networkID_mainnet = 1;
263     uint8 constant networkID_testnet = 2;
264     uint8 constant networkID_consensys = 161;
265 
266     mapping(bytes32 => bytes32) oraclize_randomDS_args;
267     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
268 
269     modifier oraclizeAPI {
270         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
271             oraclize_setNetwork(networkID_auto);
272         }
273         if (address(oraclize) != OAR.getAddress()) {
274             oraclize = OraclizeI(OAR.getAddress());
275         }
276         _;
277     }
278 
279     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
280         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
281         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
282         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
283         require(proofVerified);
284         _;
285     }
286 
287     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
288       return oraclize_setNetwork();
289       _networkID; // silence the warning and remain backwards compatible
290     }
291 
292     function oraclize_setNetworkName(string memory _network_name) internal {
293         oraclize_network_name = _network_name;
294     }
295 
296     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
297         return oraclize_network_name;
298     }
299 
300     function oraclize_setNetwork() internal returns (bool _networkSet) {
301         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
302             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
303             oraclize_setNetworkName("eth_mainnet");
304             return true;
305         }
306         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
307             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
308             oraclize_setNetworkName("eth_ropsten3");
309             return true;
310         }
311         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
312             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
313             oraclize_setNetworkName("eth_kovan");
314             return true;
315         }
316         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
317             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
318             oraclize_setNetworkName("eth_rinkeby");
319             return true;
320         }
321         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
322             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
323             return true;
324         }
325         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
326             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
327             return true;
328         }
329         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
330             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
331             return true;
332         }
333         return false;
334     }
335 
336     function __callback(bytes32 _myid, string memory _result) public {
337         __callback(_myid, _result, new bytes(0));
338     }
339 
340     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
341       return;
342       _myid; _result; _proof; // Silence compiler warnings
343     }
344 
345     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
346         return oraclize.getPrice(_datasource);
347     }
348 
349     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
350         return oraclize.getPrice(_datasource, _gasLimit);
351     }
352 
353     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
354         uint price = oraclize.getPrice(_datasource);
355         if (price > 1 ether + tx.gasprice * 200000) {
356             return 0; // Unexpectedly high price
357         }
358         return oraclize.query.value(price)(0, _datasource, _arg);
359     }
360 
361     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
362         uint price = oraclize.getPrice(_datasource);
363         if (price > 1 ether + tx.gasprice * 200000) {
364             return 0; // Unexpectedly high price
365         }
366         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
367     }
368 
369     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
370         uint price = oraclize.getPrice(_datasource,_gasLimit);
371         if (price > 1 ether + tx.gasprice * _gasLimit) {
372             return 0; // Unexpectedly high price
373         }
374         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
375     }
376 
377     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
378         uint price = oraclize.getPrice(_datasource, _gasLimit);
379         if (price > 1 ether + tx.gasprice * _gasLimit) {
380            return 0; // Unexpectedly high price
381         }
382         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
383     }
384 
385     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
386         uint price = oraclize.getPrice(_datasource);
387         if (price > 1 ether + tx.gasprice * 200000) {
388             return 0; // Unexpectedly high price
389         }
390         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
391     }
392 
393     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
394         uint price = oraclize.getPrice(_datasource);
395         if (price > 1 ether + tx.gasprice * 200000) {
396             return 0; // Unexpectedly high price
397         }
398         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
399     }
400 
401     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
402         uint price = oraclize.getPrice(_datasource, _gasLimit);
403         if (price > 1 ether + tx.gasprice * _gasLimit) {
404             return 0; // Unexpectedly high price
405         }
406         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
407     }
408 
409     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
410         uint price = oraclize.getPrice(_datasource, _gasLimit);
411         if (price > 1 ether + tx.gasprice * _gasLimit) {
412             return 0; // Unexpectedly high price
413         }
414         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
415     }
416 
417     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
418         uint price = oraclize.getPrice(_datasource);
419         if (price > 1 ether + tx.gasprice * 200000) {
420             return 0; // Unexpectedly high price
421         }
422         bytes memory args = stra2cbor(_argN);
423         return oraclize.queryN.value(price)(0, _datasource, args);
424     }
425 
426     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
427         uint price = oraclize.getPrice(_datasource);
428         if (price > 1 ether + tx.gasprice * 200000) {
429             return 0; // Unexpectedly high price
430         }
431         bytes memory args = stra2cbor(_argN);
432         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
433     }
434 
435     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
436         uint price = oraclize.getPrice(_datasource, _gasLimit);
437         if (price > 1 ether + tx.gasprice * _gasLimit) {
438             return 0; // Unexpectedly high price
439         }
440         bytes memory args = stra2cbor(_argN);
441         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
442     }
443 
444     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
445         uint price = oraclize.getPrice(_datasource, _gasLimit);
446         if (price > 1 ether + tx.gasprice * _gasLimit) {
447             return 0; // Unexpectedly high price
448         }
449         bytes memory args = stra2cbor(_argN);
450         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
451     }
452 
453     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
454         string[] memory dynargs = new string[](1);
455         dynargs[0] = _args[0];
456         return oraclize_query(_datasource, dynargs);
457     }
458 
459     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
460         string[] memory dynargs = new string[](1);
461         dynargs[0] = _args[0];
462         return oraclize_query(_timestamp, _datasource, dynargs);
463     }
464 
465     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
466         string[] memory dynargs = new string[](1);
467         dynargs[0] = _args[0];
468         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
469     }
470 
471     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
472         string[] memory dynargs = new string[](1);
473         dynargs[0] = _args[0];
474         return oraclize_query(_datasource, dynargs, _gasLimit);
475     }
476 
477     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
478         string[] memory dynargs = new string[](2);
479         dynargs[0] = _args[0];
480         dynargs[1] = _args[1];
481         return oraclize_query(_datasource, dynargs);
482     }
483 
484     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
485         string[] memory dynargs = new string[](2);
486         dynargs[0] = _args[0];
487         dynargs[1] = _args[1];
488         return oraclize_query(_timestamp, _datasource, dynargs);
489     }
490 
491     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
492         string[] memory dynargs = new string[](2);
493         dynargs[0] = _args[0];
494         dynargs[1] = _args[1];
495         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
496     }
497 
498     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
499         string[] memory dynargs = new string[](2);
500         dynargs[0] = _args[0];
501         dynargs[1] = _args[1];
502         return oraclize_query(_datasource, dynargs, _gasLimit);
503     }
504 
505     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
506         string[] memory dynargs = new string[](3);
507         dynargs[0] = _args[0];
508         dynargs[1] = _args[1];
509         dynargs[2] = _args[2];
510         return oraclize_query(_datasource, dynargs);
511     }
512 
513     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
514         string[] memory dynargs = new string[](3);
515         dynargs[0] = _args[0];
516         dynargs[1] = _args[1];
517         dynargs[2] = _args[2];
518         return oraclize_query(_timestamp, _datasource, dynargs);
519     }
520 
521     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
522         string[] memory dynargs = new string[](3);
523         dynargs[0] = _args[0];
524         dynargs[1] = _args[1];
525         dynargs[2] = _args[2];
526         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
527     }
528 
529     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
530         string[] memory dynargs = new string[](3);
531         dynargs[0] = _args[0];
532         dynargs[1] = _args[1];
533         dynargs[2] = _args[2];
534         return oraclize_query(_datasource, dynargs, _gasLimit);
535     }
536 
537     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
538         string[] memory dynargs = new string[](4);
539         dynargs[0] = _args[0];
540         dynargs[1] = _args[1];
541         dynargs[2] = _args[2];
542         dynargs[3] = _args[3];
543         return oraclize_query(_datasource, dynargs);
544     }
545 
546     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
547         string[] memory dynargs = new string[](4);
548         dynargs[0] = _args[0];
549         dynargs[1] = _args[1];
550         dynargs[2] = _args[2];
551         dynargs[3] = _args[3];
552         return oraclize_query(_timestamp, _datasource, dynargs);
553     }
554 
555     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
556         string[] memory dynargs = new string[](4);
557         dynargs[0] = _args[0];
558         dynargs[1] = _args[1];
559         dynargs[2] = _args[2];
560         dynargs[3] = _args[3];
561         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
562     }
563 
564     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
565         string[] memory dynargs = new string[](4);
566         dynargs[0] = _args[0];
567         dynargs[1] = _args[1];
568         dynargs[2] = _args[2];
569         dynargs[3] = _args[3];
570         return oraclize_query(_datasource, dynargs, _gasLimit);
571     }
572 
573     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
574         string[] memory dynargs = new string[](5);
575         dynargs[0] = _args[0];
576         dynargs[1] = _args[1];
577         dynargs[2] = _args[2];
578         dynargs[3] = _args[3];
579         dynargs[4] = _args[4];
580         return oraclize_query(_datasource, dynargs);
581     }
582 
583     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
584         string[] memory dynargs = new string[](5);
585         dynargs[0] = _args[0];
586         dynargs[1] = _args[1];
587         dynargs[2] = _args[2];
588         dynargs[3] = _args[3];
589         dynargs[4] = _args[4];
590         return oraclize_query(_timestamp, _datasource, dynargs);
591     }
592 
593     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
594         string[] memory dynargs = new string[](5);
595         dynargs[0] = _args[0];
596         dynargs[1] = _args[1];
597         dynargs[2] = _args[2];
598         dynargs[3] = _args[3];
599         dynargs[4] = _args[4];
600         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
601     }
602 
603     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
604         string[] memory dynargs = new string[](5);
605         dynargs[0] = _args[0];
606         dynargs[1] = _args[1];
607         dynargs[2] = _args[2];
608         dynargs[3] = _args[3];
609         dynargs[4] = _args[4];
610         return oraclize_query(_datasource, dynargs, _gasLimit);
611     }
612 
613     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
614         uint price = oraclize.getPrice(_datasource);
615         if (price > 1 ether + tx.gasprice * 200000) {
616             return 0; // Unexpectedly high price
617         }
618         bytes memory args = ba2cbor(_argN);
619         return oraclize.queryN.value(price)(0, _datasource, args);
620     }
621 
622     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
623         uint price = oraclize.getPrice(_datasource);
624         if (price > 1 ether + tx.gasprice * 200000) {
625             return 0; // Unexpectedly high price
626         }
627         bytes memory args = ba2cbor(_argN);
628         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
629     }
630 
631     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
632         uint price = oraclize.getPrice(_datasource, _gasLimit);
633         if (price > 1 ether + tx.gasprice * _gasLimit) {
634             return 0; // Unexpectedly high price
635         }
636         bytes memory args = ba2cbor(_argN);
637         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
638     }
639 
640     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
641         uint price = oraclize.getPrice(_datasource, _gasLimit);
642         if (price > 1 ether + tx.gasprice * _gasLimit) {
643             return 0; // Unexpectedly high price
644         }
645         bytes memory args = ba2cbor(_argN);
646         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
647     }
648 
649     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
650         bytes[] memory dynargs = new bytes[](1);
651         dynargs[0] = _args[0];
652         return oraclize_query(_datasource, dynargs);
653     }
654 
655     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
656         bytes[] memory dynargs = new bytes[](1);
657         dynargs[0] = _args[0];
658         return oraclize_query(_timestamp, _datasource, dynargs);
659     }
660 
661     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
662         bytes[] memory dynargs = new bytes[](1);
663         dynargs[0] = _args[0];
664         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
665     }
666 
667     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
668         bytes[] memory dynargs = new bytes[](1);
669         dynargs[0] = _args[0];
670         return oraclize_query(_datasource, dynargs, _gasLimit);
671     }
672 
673     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
674         bytes[] memory dynargs = new bytes[](2);
675         dynargs[0] = _args[0];
676         dynargs[1] = _args[1];
677         return oraclize_query(_datasource, dynargs);
678     }
679 
680     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
681         bytes[] memory dynargs = new bytes[](2);
682         dynargs[0] = _args[0];
683         dynargs[1] = _args[1];
684         return oraclize_query(_timestamp, _datasource, dynargs);
685     }
686 
687     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
688         bytes[] memory dynargs = new bytes[](2);
689         dynargs[0] = _args[0];
690         dynargs[1] = _args[1];
691         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
692     }
693 
694     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
695         bytes[] memory dynargs = new bytes[](2);
696         dynargs[0] = _args[0];
697         dynargs[1] = _args[1];
698         return oraclize_query(_datasource, dynargs, _gasLimit);
699     }
700 
701     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
702         bytes[] memory dynargs = new bytes[](3);
703         dynargs[0] = _args[0];
704         dynargs[1] = _args[1];
705         dynargs[2] = _args[2];
706         return oraclize_query(_datasource, dynargs);
707     }
708 
709     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
710         bytes[] memory dynargs = new bytes[](3);
711         dynargs[0] = _args[0];
712         dynargs[1] = _args[1];
713         dynargs[2] = _args[2];
714         return oraclize_query(_timestamp, _datasource, dynargs);
715     }
716 
717     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
718         bytes[] memory dynargs = new bytes[](3);
719         dynargs[0] = _args[0];
720         dynargs[1] = _args[1];
721         dynargs[2] = _args[2];
722         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
723     }
724 
725     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
726         bytes[] memory dynargs = new bytes[](3);
727         dynargs[0] = _args[0];
728         dynargs[1] = _args[1];
729         dynargs[2] = _args[2];
730         return oraclize_query(_datasource, dynargs, _gasLimit);
731     }
732 
733     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
734         bytes[] memory dynargs = new bytes[](4);
735         dynargs[0] = _args[0];
736         dynargs[1] = _args[1];
737         dynargs[2] = _args[2];
738         dynargs[3] = _args[3];
739         return oraclize_query(_datasource, dynargs);
740     }
741 
742     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
743         bytes[] memory dynargs = new bytes[](4);
744         dynargs[0] = _args[0];
745         dynargs[1] = _args[1];
746         dynargs[2] = _args[2];
747         dynargs[3] = _args[3];
748         return oraclize_query(_timestamp, _datasource, dynargs);
749     }
750 
751     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
752         bytes[] memory dynargs = new bytes[](4);
753         dynargs[0] = _args[0];
754         dynargs[1] = _args[1];
755         dynargs[2] = _args[2];
756         dynargs[3] = _args[3];
757         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
758     }
759 
760     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
761         bytes[] memory dynargs = new bytes[](4);
762         dynargs[0] = _args[0];
763         dynargs[1] = _args[1];
764         dynargs[2] = _args[2];
765         dynargs[3] = _args[3];
766         return oraclize_query(_datasource, dynargs, _gasLimit);
767     }
768 
769     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
770         bytes[] memory dynargs = new bytes[](5);
771         dynargs[0] = _args[0];
772         dynargs[1] = _args[1];
773         dynargs[2] = _args[2];
774         dynargs[3] = _args[3];
775         dynargs[4] = _args[4];
776         return oraclize_query(_datasource, dynargs);
777     }
778 
779     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
780         bytes[] memory dynargs = new bytes[](5);
781         dynargs[0] = _args[0];
782         dynargs[1] = _args[1];
783         dynargs[2] = _args[2];
784         dynargs[3] = _args[3];
785         dynargs[4] = _args[4];
786         return oraclize_query(_timestamp, _datasource, dynargs);
787     }
788 
789     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
790         bytes[] memory dynargs = new bytes[](5);
791         dynargs[0] = _args[0];
792         dynargs[1] = _args[1];
793         dynargs[2] = _args[2];
794         dynargs[3] = _args[3];
795         dynargs[4] = _args[4];
796         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
797     }
798 
799     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
800         bytes[] memory dynargs = new bytes[](5);
801         dynargs[0] = _args[0];
802         dynargs[1] = _args[1];
803         dynargs[2] = _args[2];
804         dynargs[3] = _args[3];
805         dynargs[4] = _args[4];
806         return oraclize_query(_datasource, dynargs, _gasLimit);
807     }
808 
809     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
810         return oraclize.setProofType(_proofP);
811     }
812 
813 
814     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
815         return oraclize.cbAddress();
816     }
817 
818     function getCodeSize(address _addr) view internal returns (uint _size) {
819         assembly {
820             _size := extcodesize(_addr)
821         }
822     }
823 
824     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
825         return oraclize.setCustomGasPrice(_gasPrice);
826     }
827 
828     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
829         return oraclize.randomDS_getSessionPubKeyHash();
830     }
831 
832     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
833         bytes memory tmp = bytes(_a);
834         uint160 iaddr = 0;
835         uint160 b1;
836         uint160 b2;
837         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
838             iaddr *= 256;
839             b1 = uint160(uint8(tmp[i]));
840             b2 = uint160(uint8(tmp[i + 1]));
841             if ((b1 >= 97) && (b1 <= 102)) {
842                 b1 -= 87;
843             } else if ((b1 >= 65) && (b1 <= 70)) {
844                 b1 -= 55;
845             } else if ((b1 >= 48) && (b1 <= 57)) {
846                 b1 -= 48;
847             }
848             if ((b2 >= 97) && (b2 <= 102)) {
849                 b2 -= 87;
850             } else if ((b2 >= 65) && (b2 <= 70)) {
851                 b2 -= 55;
852             } else if ((b2 >= 48) && (b2 <= 57)) {
853                 b2 -= 48;
854             }
855             iaddr += (b1 * 16 + b2);
856         }
857         return address(iaddr);
858     }
859 
860     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
861         bytes memory a = bytes(_a);
862         bytes memory b = bytes(_b);
863         uint minLength = a.length;
864         if (b.length < minLength) {
865             minLength = b.length;
866         }
867         for (uint i = 0; i < minLength; i ++) {
868             if (a[i] < b[i]) {
869                 return -1;
870             } else if (a[i] > b[i]) {
871                 return 1;
872             }
873         }
874         if (a.length < b.length) {
875             return -1;
876         } else if (a.length > b.length) {
877             return 1;
878         } else {
879             return 0;
880         }
881     }
882 
883     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
884         bytes memory h = bytes(_haystack);
885         bytes memory n = bytes(_needle);
886         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
887             return -1;
888         } else if (h.length > (2 ** 128 - 1)) {
889             return -1;
890         } else {
891             uint subindex = 0;
892             for (uint i = 0; i < h.length; i++) {
893                 if (h[i] == n[0]) {
894                     subindex = 1;
895                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
896                         subindex++;
897                     }
898                     if (subindex == n.length) {
899                         return int(i);
900                     }
901                 }
902             }
903             return -1;
904         }
905     }
906 
907     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
908         return strConcat(_a, _b, "", "", "");
909     }
910 
911     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
912         return strConcat(_a, _b, _c, "", "");
913     }
914 
915     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
916         return strConcat(_a, _b, _c, _d, "");
917     }
918 
919     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
920         bytes memory _ba = bytes(_a);
921         bytes memory _bb = bytes(_b);
922         bytes memory _bc = bytes(_c);
923         bytes memory _bd = bytes(_d);
924         bytes memory _be = bytes(_e);
925         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
926         bytes memory babcde = bytes(abcde);
927         uint k = 0;
928         uint i = 0;
929         for (i = 0; i < _ba.length; i++) {
930             babcde[k++] = _ba[i];
931         }
932         for (i = 0; i < _bb.length; i++) {
933             babcde[k++] = _bb[i];
934         }
935         for (i = 0; i < _bc.length; i++) {
936             babcde[k++] = _bc[i];
937         }
938         for (i = 0; i < _bd.length; i++) {
939             babcde[k++] = _bd[i];
940         }
941         for (i = 0; i < _be.length; i++) {
942             babcde[k++] = _be[i];
943         }
944         return string(babcde);
945     }
946 
947     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
948         return safeParseInt(_a, 0);
949     }
950 
951     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
952         bytes memory bresult = bytes(_a);
953         uint mint = 0;
954         bool decimals = false;
955         for (uint i = 0; i < bresult.length; i++) {
956             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
957                 if (decimals) {
958                    if (_b == 0) break;
959                     else _b--;
960                 }
961                 mint *= 10;
962                 mint += uint(uint8(bresult[i])) - 48;
963             } else if (uint(uint8(bresult[i])) == 46) {
964                 require(!decimals, 'More than one decimal encountered in string!');
965                 decimals = true;
966             } else {
967                 revert("Non-numeral character encountered in string!");
968             }
969         }
970         if (_b > 0) {
971             mint *= 10 ** _b;
972         }
973         return mint;
974     }
975 
976     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
977         return parseInt(_a, 0);
978     }
979 
980     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
981         bytes memory bresult = bytes(_a);
982         uint mint = 0;
983         bool decimals = false;
984         for (uint i = 0; i < bresult.length; i++) {
985             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
986                 if (decimals) {
987                    if (_b == 0) {
988                        break;
989                    } else {
990                        _b--;
991                    }
992                 }
993                 mint *= 10;
994                 mint += uint(uint8(bresult[i])) - 48;
995             } else if (uint(uint8(bresult[i])) == 46) {
996                 decimals = true;
997             }
998         }
999         if (_b > 0) {
1000             mint *= 10 ** _b;
1001         }
1002         return mint;
1003     }
1004 
1005     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1006         if (_i == 0) {
1007             return "0";
1008         }
1009         uint j = _i;
1010         uint len;
1011         while (j != 0) {
1012             len++;
1013             j /= 10;
1014         }
1015         bytes memory bstr = new bytes(len);
1016         uint k = len - 1;
1017         while (_i != 0) {
1018             bstr[k--] = byte(uint8(48 + _i % 10));
1019             _i /= 10;
1020         }
1021         return string(bstr);
1022     }
1023 
1024     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1025         safeMemoryCleaner();
1026         Buffer.buffer memory buf;
1027         Buffer.init(buf, 1024);
1028         buf.startArray();
1029         for (uint i = 0; i < _arr.length; i++) {
1030             buf.encodeString(_arr[i]);
1031         }
1032         buf.endSequence();
1033         return buf.buf;
1034     }
1035 
1036     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1037         safeMemoryCleaner();
1038         Buffer.buffer memory buf;
1039         Buffer.init(buf, 1024);
1040         buf.startArray();
1041         for (uint i = 0; i < _arr.length; i++) {
1042             buf.encodeBytes(_arr[i]);
1043         }
1044         buf.endSequence();
1045         return buf.buf;
1046     }
1047 
1048     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1049         require((_nbytes > 0) && (_nbytes <= 32));
1050         _delay *= 10; // Convert from seconds to ledger timer ticks
1051         bytes memory nbytes = new bytes(1);
1052         nbytes[0] = byte(uint8(_nbytes));
1053         bytes memory unonce = new bytes(32);
1054         bytes memory sessionKeyHash = new bytes(32);
1055         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1056         assembly {
1057             mstore(unonce, 0x20)
1058             /*
1059              The following variables can be relaxed.
1060              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1061              for an idea on how to override and replace commit hash variables.
1062             */
1063             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1064             mstore(sessionKeyHash, 0x20)
1065             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1066         }
1067         bytes memory delay = new bytes(32);
1068         assembly {
1069             mstore(add(delay, 0x20), _delay)
1070         }
1071         bytes memory delay_bytes8 = new bytes(8);
1072         copyBytes(delay, 24, 8, delay_bytes8, 0);
1073         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1074         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1075         bytes memory delay_bytes8_left = new bytes(8);
1076         assembly {
1077             let x := mload(add(delay_bytes8, 0x20))
1078             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1079             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1080             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1081             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1082             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1083             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1084             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1085             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1086         }
1087         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1088         return queryId;
1089     }
1090 
1091     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1092         oraclize_randomDS_args[_queryId] = _commitment;
1093     }
1094 
1095     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1096         bool sigok;
1097         address signer;
1098         bytes32 sigr;
1099         bytes32 sigs;
1100         bytes memory sigr_ = new bytes(32);
1101         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1102         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1103         bytes memory sigs_ = new bytes(32);
1104         offset += 32 + 2;
1105         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1106         assembly {
1107             sigr := mload(add(sigr_, 32))
1108             sigs := mload(add(sigs_, 32))
1109         }
1110         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1111         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1112             return true;
1113         } else {
1114             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1115             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1116         }
1117     }
1118 
1119     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1120         bool sigok;
1121         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1122         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1123         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1124         bytes memory appkey1_pubkey = new bytes(64);
1125         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1126         bytes memory tosign2 = new bytes(1 + 65 + 32);
1127         tosign2[0] = byte(uint8(1)); //role
1128         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1129         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1130         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1131         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1132         if (!sigok) {
1133             return false;
1134         }
1135         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1136         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1137         bytes memory tosign3 = new bytes(1 + 65);
1138         tosign3[0] = 0xFE;
1139         copyBytes(_proof, 3, 65, tosign3, 1);
1140         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1141         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1142         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1143         return sigok;
1144     }
1145 
1146     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1147         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1148         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1149             return 1;
1150         }
1151         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1152         if (!proofVerified) {
1153             return 2;
1154         }
1155         return 0;
1156     }
1157 
1158     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1159         bool match_ = true;
1160         require(_prefix.length == _nRandomBytes);
1161         for (uint256 i = 0; i< _nRandomBytes; i++) {
1162             if (_content[i] != _prefix[i]) {
1163                 match_ = false;
1164             }
1165         }
1166         return match_;
1167     }
1168 
1169     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1170         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1171         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1172         bytes memory keyhash = new bytes(32);
1173         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1174         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1175             return false;
1176         }
1177         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1178         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1179         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1180         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1181             return false;
1182         }
1183         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1184         // This is to verify that the computed args match with the ones specified in the query.
1185         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1186         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1187         bytes memory sessionPubkey = new bytes(64);
1188         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1189         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1190         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1191         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1192             delete oraclize_randomDS_args[_queryId];
1193         } else return false;
1194         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1195         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1196         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1197         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1198             return false;
1199         }
1200         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1201         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1202             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1203         }
1204         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1205     }
1206     /*
1207      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1208     */
1209     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1210         uint minLength = _length + _toOffset;
1211         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1212         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1213         uint j = 32 + _toOffset;
1214         while (i < (32 + _fromOffset + _length)) {
1215             assembly {
1216                 let tmp := mload(add(_from, i))
1217                 mstore(add(_to, j), tmp)
1218             }
1219             i += 32;
1220             j += 32;
1221         }
1222         return _to;
1223     }
1224     /*
1225      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1226      Duplicate Solidity's ecrecover, but catching the CALL return value
1227     */
1228     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1229         /*
1230          We do our own memory management here. Solidity uses memory offset
1231          0x40 to store the current end of memory. We write past it (as
1232          writes are memory extensions), but don't update the offset so
1233          Solidity will reuse it. The memory used here is only needed for
1234          this context.
1235          FIXME: inline assembly can't access return values
1236         */
1237         bool ret;
1238         address addr;
1239         assembly {
1240             let size := mload(0x40)
1241             mstore(size, _hash)
1242             mstore(add(size, 32), _v)
1243             mstore(add(size, 64), _r)
1244             mstore(add(size, 96), _s)
1245             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1246             addr := mload(size)
1247         }
1248         return (ret, addr);
1249     }
1250     /*
1251      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1252     */
1253     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1254         bytes32 r;
1255         bytes32 s;
1256         uint8 v;
1257         if (_sig.length != 65) {
1258             return (false, address(0));
1259         }
1260         /*
1261          The signature format is a compact form of:
1262            {bytes32 r}{bytes32 s}{uint8 v}
1263          Compact means, uint8 is not padded to 32 bytes.
1264         */
1265         assembly {
1266             r := mload(add(_sig, 32))
1267             s := mload(add(_sig, 64))
1268             /*
1269              Here we are loading the last 32 bytes. We exploit the fact that
1270              'mload' will pad with zeroes if we overread.
1271              There is no 'mload8' to do this, but that would be nicer.
1272             */
1273             v := byte(0, mload(add(_sig, 96)))
1274             /*
1275               Alternative solution:
1276               'byte' is not working due to the Solidity parser, so lets
1277               use the second best option, 'and'
1278               v := and(mload(add(_sig, 65)), 255)
1279             */
1280         }
1281         /*
1282          albeit non-transactional signatures are not specified by the YP, one would expect it
1283          to match the YP range of [27, 28]
1284          geth uses [0, 1] and some clients have followed. This might change, see:
1285          https://github.com/ethereum/go-ethereum/issues/2053
1286         */
1287         if (v < 27) {
1288             v += 27;
1289         }
1290         if (v != 27 && v != 28) {
1291             return (false, address(0));
1292         }
1293         return safer_ecrecover(_hash, v, r, s);
1294     }
1295 
1296     function safeMemoryCleaner() internal pure {
1297         assembly {
1298             let fmem := mload(0x40)
1299             codecopy(fmem, codesize, sub(msize, fmem))
1300         }
1301     }
1302 }
1303 /*
1304 
1305 END ORACLIZE_API
1306 
1307 */
1308 
1309 contract Owned {
1310     address payable public owner;
1311     address payable public newOwner;
1312     modifier onlyOwner {
1313         require(msg.sender == owner);
1314         _;
1315     }
1316     function transferContractOwnership(address payable _newOwner) public onlyOwner {
1317         newOwner = _newOwner;
1318     }
1319     function acceptContractOwnership() public returns(bool successful) {
1320         if (newOwner == msg.sender) {
1321             owner = newOwner;
1322             return true;
1323         } else {
1324             return false;
1325         }
1326     }
1327 }
1328 
1329 interface PAXTRInterface {
1330     function mint(address account, address refferer) external;
1331 }
1332 
1333 contract MinterWithCivic is Owned, usingOraclize {
1334     constructor() public {
1335         owner = 0x7645Ad8D4a2cD5b07D8Bc4ea1690d5c1F765aabC;
1336     }
1337     
1338     address public PAXTRContract = 0x6d86091B051799e05CC8D7b2452A7Cb123F018D8;
1339     mapping(bytes32 => bool) public accountId;
1340     mapping(address => bool) public accountWallet;
1341     uint256 public claimPriceInWei = 100000000000000000;
1342     
1343     struct AccountCheck {
1344         address wallet;
1345         address reff;
1346         bytes32 uniqueId;
1347     }
1348     mapping(bytes32 => AccountCheck) public accountCheck;
1349     
1350     bool public contractPaused = false;
1351     
1352     function setClaimPrice(uint256 priceInWei) public onlyOwner {
1353         claimPriceInWei = priceInWei;
1354     }
1355     
1356     function setContractActiveState(bool state) public onlyOwner {
1357         contractPaused = state;
1358     }
1359     
1360     function activateClaim(address account, string memory addressString, address refferer, string memory idString) public payable {
1361         bytes32 id = stringToBytes32(idString);
1362         require(contractPaused == false);
1363         require(accountId[id] == false);
1364         require(msg.value >= claimPriceInWei);
1365         string memory _url = strConcat("https://paxco.in:10101/verify?wallet=", addressString);
1366         bytes32 queryId = oraclize_query("URL", _url, 1000000);
1367         accountCheck[queryId].wallet = account;
1368         accountCheck[queryId].uniqueId = id;
1369         accountCheck[queryId].reff = refferer;
1370         emit Return(queryId, addressString);
1371     }
1372     
1373     event Return(bytes32 _id, string _data);
1374     
1375     function __callback(bytes32 myid, string memory result) public {
1376         if (msg.sender != oraclize_cbAddress()) revert();
1377         
1378         require(accountId[accountCheck[myid].uniqueId] == false);
1379         require(accountWallet[accountCheck[myid].wallet] == false);
1380         
1381         bytes32 __id = stringToBytes32(result);
1382         require(accountCheck[myid].uniqueId == __id);
1383        
1384         accountId[accountCheck[myid].uniqueId] = true;
1385         accountWallet[accountCheck[myid].wallet] = true;
1386         
1387         address _reff;
1388         if (accountCheck[myid].reff == accountCheck[myid].wallet) {
1389             _reff = address(0);
1390         } else {
1391             _reff = accountCheck[myid].reff;
1392         }
1393         
1394         PAXTRInterface(PAXTRContract).mint(accountCheck[myid].wallet, _reff);
1395         owner.transfer(address(this).balance);
1396         
1397         emit Return(myid, result);
1398     }
1399     
1400     function stringToBytes32(string memory source) public pure returns (bytes32 result) {
1401         bytes memory tempEmptyStringTest = bytes(source);
1402         if (tempEmptyStringTest.length == 0) {
1403             return 0x0;
1404         }
1405 
1406         assembly {
1407             result := mload(add(source, 32))
1408         }
1409     }
1410     
1411     function withdrawEth() public onlyOwner {
1412         owner.transfer(address(this).balance);
1413     }
1414         
1415 }