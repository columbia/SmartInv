1 pragma solidity ^0.5.7;
2 
3 /*
4 ORACLIZE_API
5 Copyright (c) 2015-2016 Oraclize SRL
6 Copyright (c) 2016 Oraclize LTD
7 Permission is hereby granted, free of charge, to any person obtaining a copy
8 of this software and associated documentation files (the "Software"), to deal
9 in the Software without restriction, including without limitation the rights
10 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
11 copies of the Software, and to permit persons to whom the Software is
12 furnished to do so, subject to the following conditions:
13 The above copyright notice and this permission notice shall be included in
14 all copies or substantial portions of the Software.
15 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
16 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
17 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
18 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
19 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
20 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
21 THE SOFTWARE.
22 */
23 pragma solidity >= 0.5.0 < 0.6.0; // Incompatible compiler version - please select a compiler within the stated pragma range, or use a different version of the oraclizeAPI!
24 
25 // Dummy contract only used to emit to end-user they are using wrong solc
26 contract solcChecker {
27 /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;
28 }
29 
30 contract OraclizeI {
31 
32     address public cbAddress;
33 
34     function setProofType(byte _proofType) external;
35     function setCustomGasPrice(uint _gasPrice) external;
36     function getPrice(string memory _datasource) public returns (uint _dsprice);
37     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
38     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
39     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
40     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
41     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
42     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
43     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
44     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
45 }
46 
47 contract OraclizeAddrResolverI {
48     function getAddress() public returns (address _address);
49 }
50 /*
51 Begin solidity-cborutils
52 https://github.com/smartcontractkit/solidity-cborutils
53 MIT License
54 Copyright (c) 2018 SmartContract ChainLink, Ltd.
55 Permission is hereby granted, free of charge, to any person obtaining a copy
56 of this software and associated documentation files (the "Software"), to deal
57 in the Software without restriction, including without limitation the rights
58 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
59 copies of the Software, and to permit persons to whom the Software is
60 furnished to do so, subject to the following conditions:
61 The above copyright notice and this permission notice shall be included in all
62 copies or substantial portions of the Software.
63 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
64 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
65 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
66 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
67 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
68 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
69 SOFTWARE.
70 */
71 library Buffer {
72 
73     struct buffer {
74         bytes buf;
75         uint capacity;
76     }
77 
78     function init(buffer memory _buf, uint _capacity) internal pure {
79         uint capacity = _capacity;
80         if (capacity % 32 != 0) {
81             capacity += 32 - (capacity % 32);
82         }
83         _buf.capacity = capacity; // Allocate space for the buffer data
84         assembly {
85             let ptr := mload(0x40)
86             mstore(_buf, ptr)
87             mstore(ptr, 0)
88             mstore(0x40, add(ptr, capacity))
89         }
90     }
91 
92     function resize(buffer memory _buf, uint _capacity) private pure {
93         bytes memory oldbuf = _buf.buf;
94         init(_buf, _capacity);
95         append(_buf, oldbuf);
96     }
97 
98     function max(uint _a, uint _b) private pure returns (uint _max) {
99         if (_a > _b) {
100             return _a;
101         }
102         return _b;
103     }
104     /**
105       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
106       *      would exceed the capacity of the buffer.
107       * @param _buf The buffer to append to.
108       * @param _data The data to append.
109       * @return The original buffer.
110       *
111       */
112     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
113         if (_data.length + _buf.buf.length > _buf.capacity) {
114             resize(_buf, max(_buf.capacity, _data.length) * 2);
115         }
116         uint dest;
117         uint src;
118         uint len = _data.length;
119         assembly {
120             let bufptr := mload(_buf) // Memory address of the buffer data
121             let buflen := mload(bufptr) // Length of existing buffer data
122             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
123             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
124             src := add(_data, 32)
125         }
126         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
127             assembly {
128                 mstore(dest, mload(src))
129             }
130             dest += 32;
131             src += 32;
132         }
133         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
134         assembly {
135             let srcpart := and(mload(src), not(mask))
136             let destpart := and(mload(dest), mask)
137             mstore(dest, or(destpart, srcpart))
138         }
139         return _buf;
140     }
141     /**
142       *
143       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
144       * exceed the capacity of the buffer.
145       * @param _buf The buffer to append to.
146       * @param _data The data to append.
147       * @return The original buffer.
148       *
149       */
150     function append(buffer memory _buf, uint8 _data) internal pure {
151         if (_buf.buf.length + 1 > _buf.capacity) {
152             resize(_buf, _buf.capacity * 2);
153         }
154         assembly {
155             let bufptr := mload(_buf) // Memory address of the buffer data
156             let buflen := mload(bufptr) // Length of existing buffer data
157             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
158             mstore8(dest, _data)
159             mstore(bufptr, add(buflen, 1)) // Update buffer length
160         }
161     }
162     /**
163       *
164       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
165       * exceed the capacity of the buffer.
166       * @param _buf The buffer to append to.
167       * @param _data The data to append.
168       * @return The original buffer.
169       *
170       */
171     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
172         if (_len + _buf.buf.length > _buf.capacity) {
173             resize(_buf, max(_buf.capacity, _len) * 2);
174         }
175         uint mask = 256 ** _len - 1;
176         assembly {
177             let bufptr := mload(_buf) // Memory address of the buffer data
178             let buflen := mload(bufptr) // Length of existing buffer data
179             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
180             mstore(dest, or(and(mload(dest), not(mask)), _data))
181             mstore(bufptr, add(buflen, _len)) // Update buffer length
182         }
183         return _buf;
184     }
185 }
186 
187 library CBOR {
188 
189     using Buffer for Buffer.buffer;
190 
191     uint8 private constant MAJOR_TYPE_INT = 0;
192     uint8 private constant MAJOR_TYPE_MAP = 5;
193     uint8 private constant MAJOR_TYPE_BYTES = 2;
194     uint8 private constant MAJOR_TYPE_ARRAY = 4;
195     uint8 private constant MAJOR_TYPE_STRING = 3;
196     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
197     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
198 
199     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
200         if (_value <= 23) {
201             _buf.append(uint8((_major << 5) | _value));
202         } else if (_value <= 0xFF) {
203             _buf.append(uint8((_major << 5) | 24));
204             _buf.appendInt(_value, 1);
205         } else if (_value <= 0xFFFF) {
206             _buf.append(uint8((_major << 5) | 25));
207             _buf.appendInt(_value, 2);
208         } else if (_value <= 0xFFFFFFFF) {
209             _buf.append(uint8((_major << 5) | 26));
210             _buf.appendInt(_value, 4);
211         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
212             _buf.append(uint8((_major << 5) | 27));
213             _buf.appendInt(_value, 8);
214         }
215     }
216 
217     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
218         _buf.append(uint8((_major << 5) | 31));
219     }
220 
221     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
222         encodeType(_buf, MAJOR_TYPE_INT, _value);
223     }
224 
225     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
226         if (_value >= 0) {
227             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
228         } else {
229             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
230         }
231     }
232 
233     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
234         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
235         _buf.append(_value);
236     }
237 
238     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
239         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
240         _buf.append(bytes(_value));
241     }
242 
243     function startArray(Buffer.buffer memory _buf) internal pure {
244         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
245     }
246 
247     function startMap(Buffer.buffer memory _buf) internal pure {
248         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
249     }
250 
251     function endSequence(Buffer.buffer memory _buf) internal pure {
252         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
253     }
254 }
255 /*
256 End solidity-cborutils
257 */
258 contract usingOraclize {
259 
260     using CBOR for Buffer.buffer;
261 
262     OraclizeI oraclize;
263     OraclizeAddrResolverI OAR;
264 
265     uint constant day = 60 * 60 * 24;
266     uint constant week = 60 * 60 * 24 * 7;
267     uint constant month = 60 * 60 * 24 * 30;
268 
269     byte constant proofType_NONE = 0x00;
270     byte constant proofType_Ledger = 0x30;
271     byte constant proofType_Native = 0xF0;
272     byte constant proofStorage_IPFS = 0x01;
273     byte constant proofType_Android = 0x40;
274     byte constant proofType_TLSNotary = 0x10;
275 
276     string oraclize_network_name;
277     uint8 constant networkID_auto = 0;
278     uint8 constant networkID_morden = 2;
279     uint8 constant networkID_mainnet = 1;
280     uint8 constant networkID_testnet = 2;
281     uint8 constant networkID_consensys = 161;
282 
283     mapping(bytes32 => bytes32) oraclize_randomDS_args;
284     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
285 
286     modifier oraclizeAPI {
287         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
288             oraclize_setNetwork(networkID_auto);
289         }
290         if (address(oraclize) != OAR.getAddress()) {
291             oraclize = OraclizeI(OAR.getAddress());
292         }
293         _;
294     }
295 
296     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
297         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
298         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
299         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
300         require(proofVerified);
301         _;
302     }
303 
304     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
305       return oraclize_setNetwork();
306       _networkID; // silence the warning and remain backwards compatible
307     }
308 
309     function oraclize_setNetworkName(string memory _network_name) internal {
310         oraclize_network_name = _network_name;
311     }
312 
313     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
314         return oraclize_network_name;
315     }
316 
317     function oraclize_setNetwork() internal returns (bool _networkSet) {
318         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
319             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
320             oraclize_setNetworkName("eth_mainnet");
321             return true;
322         }
323         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
324             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
325             oraclize_setNetworkName("eth_ropsten3");
326             return true;
327         }
328         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
329             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
330             oraclize_setNetworkName("eth_kovan");
331             return true;
332         }
333         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
334             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
335             oraclize_setNetworkName("eth_rinkeby");
336             return true;
337         }
338         if (getCodeSize(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41) > 0) { //goerli testnet
339             OAR = OraclizeAddrResolverI(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41);
340             oraclize_setNetworkName("eth_goerli");
341             return true;
342         }
343         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
344             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
345             return true;
346         }
347         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
348             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
349             return true;
350         }
351         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
352             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
353             return true;
354         }
355         return false;
356     }
357 
358     function __callback(bytes32 _myid, string memory _result) public {
359         __callback(_myid, _result, new bytes(0));
360     }
361 
362     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
363       return;
364       _myid; _result; _proof; // Silence compiler warnings
365     }
366 
367     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
368         return oraclize.getPrice(_datasource);
369     }
370 
371     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
372         return oraclize.getPrice(_datasource, _gasLimit);
373     }
374 
375     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
376         uint price = oraclize.getPrice(_datasource);
377         if (price > 1 ether + tx.gasprice * 200000) {
378             return 0; // Unexpectedly high price
379         }
380         return oraclize.query.value(price)(0, _datasource, _arg);
381     }
382 
383     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
384         uint price = oraclize.getPrice(_datasource);
385         if (price > 1 ether + tx.gasprice * 200000) {
386             return 0; // Unexpectedly high price
387         }
388         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
389     }
390 
391     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
392         uint price = oraclize.getPrice(_datasource,_gasLimit);
393         if (price > 1 ether + tx.gasprice * _gasLimit) {
394             return 0; // Unexpectedly high price
395         }
396         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
397     }
398 
399     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
400         uint price = oraclize.getPrice(_datasource, _gasLimit);
401         if (price > 1 ether + tx.gasprice * _gasLimit) {
402            return 0; // Unexpectedly high price
403         }
404         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
405     }
406 
407     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
408         uint price = oraclize.getPrice(_datasource);
409         if (price > 1 ether + tx.gasprice * 200000) {
410             return 0; // Unexpectedly high price
411         }
412         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
413     }
414 
415     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
416         uint price = oraclize.getPrice(_datasource);
417         if (price > 1 ether + tx.gasprice * 200000) {
418             return 0; // Unexpectedly high price
419         }
420         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
421     }
422 
423     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
424         uint price = oraclize.getPrice(_datasource, _gasLimit);
425         if (price > 1 ether + tx.gasprice * _gasLimit) {
426             return 0; // Unexpectedly high price
427         }
428         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
429     }
430 
431     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
432         uint price = oraclize.getPrice(_datasource, _gasLimit);
433         if (price > 1 ether + tx.gasprice * _gasLimit) {
434             return 0; // Unexpectedly high price
435         }
436         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
437     }
438 
439     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
440         uint price = oraclize.getPrice(_datasource);
441         if (price > 1 ether + tx.gasprice * 200000) {
442             return 0; // Unexpectedly high price
443         }
444         bytes memory args = stra2cbor(_argN);
445         return oraclize.queryN.value(price)(0, _datasource, args);
446     }
447 
448     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
449         uint price = oraclize.getPrice(_datasource);
450         if (price > 1 ether + tx.gasprice * 200000) {
451             return 0; // Unexpectedly high price
452         }
453         bytes memory args = stra2cbor(_argN);
454         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
455     }
456 
457     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
458         uint price = oraclize.getPrice(_datasource, _gasLimit);
459         if (price > 1 ether + tx.gasprice * _gasLimit) {
460             return 0; // Unexpectedly high price
461         }
462         bytes memory args = stra2cbor(_argN);
463         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
464     }
465 
466     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
467         uint price = oraclize.getPrice(_datasource, _gasLimit);
468         if (price > 1 ether + tx.gasprice * _gasLimit) {
469             return 0; // Unexpectedly high price
470         }
471         bytes memory args = stra2cbor(_argN);
472         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
473     }
474 
475     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
476         string[] memory dynargs = new string[](1);
477         dynargs[0] = _args[0];
478         return oraclize_query(_datasource, dynargs);
479     }
480 
481     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
482         string[] memory dynargs = new string[](1);
483         dynargs[0] = _args[0];
484         return oraclize_query(_timestamp, _datasource, dynargs);
485     }
486 
487     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
488         string[] memory dynargs = new string[](1);
489         dynargs[0] = _args[0];
490         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
491     }
492 
493     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
494         string[] memory dynargs = new string[](1);
495         dynargs[0] = _args[0];
496         return oraclize_query(_datasource, dynargs, _gasLimit);
497     }
498 
499     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
500         string[] memory dynargs = new string[](2);
501         dynargs[0] = _args[0];
502         dynargs[1] = _args[1];
503         return oraclize_query(_datasource, dynargs);
504     }
505 
506     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
507         string[] memory dynargs = new string[](2);
508         dynargs[0] = _args[0];
509         dynargs[1] = _args[1];
510         return oraclize_query(_timestamp, _datasource, dynargs);
511     }
512 
513     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
514         string[] memory dynargs = new string[](2);
515         dynargs[0] = _args[0];
516         dynargs[1] = _args[1];
517         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
518     }
519 
520     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
521         string[] memory dynargs = new string[](2);
522         dynargs[0] = _args[0];
523         dynargs[1] = _args[1];
524         return oraclize_query(_datasource, dynargs, _gasLimit);
525     }
526 
527     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
528         string[] memory dynargs = new string[](3);
529         dynargs[0] = _args[0];
530         dynargs[1] = _args[1];
531         dynargs[2] = _args[2];
532         return oraclize_query(_datasource, dynargs);
533     }
534 
535     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
536         string[] memory dynargs = new string[](3);
537         dynargs[0] = _args[0];
538         dynargs[1] = _args[1];
539         dynargs[2] = _args[2];
540         return oraclize_query(_timestamp, _datasource, dynargs);
541     }
542 
543     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
544         string[] memory dynargs = new string[](3);
545         dynargs[0] = _args[0];
546         dynargs[1] = _args[1];
547         dynargs[2] = _args[2];
548         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
549     }
550 
551     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
552         string[] memory dynargs = new string[](3);
553         dynargs[0] = _args[0];
554         dynargs[1] = _args[1];
555         dynargs[2] = _args[2];
556         return oraclize_query(_datasource, dynargs, _gasLimit);
557     }
558 
559     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
560         string[] memory dynargs = new string[](4);
561         dynargs[0] = _args[0];
562         dynargs[1] = _args[1];
563         dynargs[2] = _args[2];
564         dynargs[3] = _args[3];
565         return oraclize_query(_datasource, dynargs);
566     }
567 
568     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
569         string[] memory dynargs = new string[](4);
570         dynargs[0] = _args[0];
571         dynargs[1] = _args[1];
572         dynargs[2] = _args[2];
573         dynargs[3] = _args[3];
574         return oraclize_query(_timestamp, _datasource, dynargs);
575     }
576 
577     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
578         string[] memory dynargs = new string[](4);
579         dynargs[0] = _args[0];
580         dynargs[1] = _args[1];
581         dynargs[2] = _args[2];
582         dynargs[3] = _args[3];
583         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
584     }
585 
586     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
587         string[] memory dynargs = new string[](4);
588         dynargs[0] = _args[0];
589         dynargs[1] = _args[1];
590         dynargs[2] = _args[2];
591         dynargs[3] = _args[3];
592         return oraclize_query(_datasource, dynargs, _gasLimit);
593     }
594 
595     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
596         string[] memory dynargs = new string[](5);
597         dynargs[0] = _args[0];
598         dynargs[1] = _args[1];
599         dynargs[2] = _args[2];
600         dynargs[3] = _args[3];
601         dynargs[4] = _args[4];
602         return oraclize_query(_datasource, dynargs);
603     }
604 
605     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
606         string[] memory dynargs = new string[](5);
607         dynargs[0] = _args[0];
608         dynargs[1] = _args[1];
609         dynargs[2] = _args[2];
610         dynargs[3] = _args[3];
611         dynargs[4] = _args[4];
612         return oraclize_query(_timestamp, _datasource, dynargs);
613     }
614 
615     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
616         string[] memory dynargs = new string[](5);
617         dynargs[0] = _args[0];
618         dynargs[1] = _args[1];
619         dynargs[2] = _args[2];
620         dynargs[3] = _args[3];
621         dynargs[4] = _args[4];
622         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
623     }
624 
625     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
626         string[] memory dynargs = new string[](5);
627         dynargs[0] = _args[0];
628         dynargs[1] = _args[1];
629         dynargs[2] = _args[2];
630         dynargs[3] = _args[3];
631         dynargs[4] = _args[4];
632         return oraclize_query(_datasource, dynargs, _gasLimit);
633     }
634 
635     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
636         uint price = oraclize.getPrice(_datasource);
637         if (price > 1 ether + tx.gasprice * 200000) {
638             return 0; // Unexpectedly high price
639         }
640         bytes memory args = ba2cbor(_argN);
641         return oraclize.queryN.value(price)(0, _datasource, args);
642     }
643 
644     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
645         uint price = oraclize.getPrice(_datasource);
646         if (price > 1 ether + tx.gasprice * 200000) {
647             return 0; // Unexpectedly high price
648         }
649         bytes memory args = ba2cbor(_argN);
650         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
651     }
652 
653     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
654         uint price = oraclize.getPrice(_datasource, _gasLimit);
655         if (price > 1 ether + tx.gasprice * _gasLimit) {
656             return 0; // Unexpectedly high price
657         }
658         bytes memory args = ba2cbor(_argN);
659         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
660     }
661 
662     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
663         uint price = oraclize.getPrice(_datasource, _gasLimit);
664         if (price > 1 ether + tx.gasprice * _gasLimit) {
665             return 0; // Unexpectedly high price
666         }
667         bytes memory args = ba2cbor(_argN);
668         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
669     }
670 
671     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
672         bytes[] memory dynargs = new bytes[](1);
673         dynargs[0] = _args[0];
674         return oraclize_query(_datasource, dynargs);
675     }
676 
677     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
678         bytes[] memory dynargs = new bytes[](1);
679         dynargs[0] = _args[0];
680         return oraclize_query(_timestamp, _datasource, dynargs);
681     }
682 
683     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
684         bytes[] memory dynargs = new bytes[](1);
685         dynargs[0] = _args[0];
686         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
687     }
688 
689     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
690         bytes[] memory dynargs = new bytes[](1);
691         dynargs[0] = _args[0];
692         return oraclize_query(_datasource, dynargs, _gasLimit);
693     }
694 
695     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
696         bytes[] memory dynargs = new bytes[](2);
697         dynargs[0] = _args[0];
698         dynargs[1] = _args[1];
699         return oraclize_query(_datasource, dynargs);
700     }
701 
702     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
703         bytes[] memory dynargs = new bytes[](2);
704         dynargs[0] = _args[0];
705         dynargs[1] = _args[1];
706         return oraclize_query(_timestamp, _datasource, dynargs);
707     }
708 
709     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
710         bytes[] memory dynargs = new bytes[](2);
711         dynargs[0] = _args[0];
712         dynargs[1] = _args[1];
713         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
714     }
715 
716     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
717         bytes[] memory dynargs = new bytes[](2);
718         dynargs[0] = _args[0];
719         dynargs[1] = _args[1];
720         return oraclize_query(_datasource, dynargs, _gasLimit);
721     }
722 
723     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
724         bytes[] memory dynargs = new bytes[](3);
725         dynargs[0] = _args[0];
726         dynargs[1] = _args[1];
727         dynargs[2] = _args[2];
728         return oraclize_query(_datasource, dynargs);
729     }
730 
731     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
732         bytes[] memory dynargs = new bytes[](3);
733         dynargs[0] = _args[0];
734         dynargs[1] = _args[1];
735         dynargs[2] = _args[2];
736         return oraclize_query(_timestamp, _datasource, dynargs);
737     }
738 
739     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
740         bytes[] memory dynargs = new bytes[](3);
741         dynargs[0] = _args[0];
742         dynargs[1] = _args[1];
743         dynargs[2] = _args[2];
744         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
745     }
746 
747     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
748         bytes[] memory dynargs = new bytes[](3);
749         dynargs[0] = _args[0];
750         dynargs[1] = _args[1];
751         dynargs[2] = _args[2];
752         return oraclize_query(_datasource, dynargs, _gasLimit);
753     }
754 
755     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
756         bytes[] memory dynargs = new bytes[](4);
757         dynargs[0] = _args[0];
758         dynargs[1] = _args[1];
759         dynargs[2] = _args[2];
760         dynargs[3] = _args[3];
761         return oraclize_query(_datasource, dynargs);
762     }
763 
764     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
765         bytes[] memory dynargs = new bytes[](4);
766         dynargs[0] = _args[0];
767         dynargs[1] = _args[1];
768         dynargs[2] = _args[2];
769         dynargs[3] = _args[3];
770         return oraclize_query(_timestamp, _datasource, dynargs);
771     }
772 
773     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
774         bytes[] memory dynargs = new bytes[](4);
775         dynargs[0] = _args[0];
776         dynargs[1] = _args[1];
777         dynargs[2] = _args[2];
778         dynargs[3] = _args[3];
779         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
780     }
781 
782     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
783         bytes[] memory dynargs = new bytes[](4);
784         dynargs[0] = _args[0];
785         dynargs[1] = _args[1];
786         dynargs[2] = _args[2];
787         dynargs[3] = _args[3];
788         return oraclize_query(_datasource, dynargs, _gasLimit);
789     }
790 
791     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
792         bytes[] memory dynargs = new bytes[](5);
793         dynargs[0] = _args[0];
794         dynargs[1] = _args[1];
795         dynargs[2] = _args[2];
796         dynargs[3] = _args[3];
797         dynargs[4] = _args[4];
798         return oraclize_query(_datasource, dynargs);
799     }
800 
801     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
802         bytes[] memory dynargs = new bytes[](5);
803         dynargs[0] = _args[0];
804         dynargs[1] = _args[1];
805         dynargs[2] = _args[2];
806         dynargs[3] = _args[3];
807         dynargs[4] = _args[4];
808         return oraclize_query(_timestamp, _datasource, dynargs);
809     }
810 
811     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
812         bytes[] memory dynargs = new bytes[](5);
813         dynargs[0] = _args[0];
814         dynargs[1] = _args[1];
815         dynargs[2] = _args[2];
816         dynargs[3] = _args[3];
817         dynargs[4] = _args[4];
818         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
819     }
820 
821     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
822         bytes[] memory dynargs = new bytes[](5);
823         dynargs[0] = _args[0];
824         dynargs[1] = _args[1];
825         dynargs[2] = _args[2];
826         dynargs[3] = _args[3];
827         dynargs[4] = _args[4];
828         return oraclize_query(_datasource, dynargs, _gasLimit);
829     }
830 
831     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
832         return oraclize.setProofType(_proofP);
833     }
834 
835 
836     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
837         return oraclize.cbAddress();
838     }
839 
840     function getCodeSize(address _addr) view internal returns (uint _size) {
841         assembly {
842             _size := extcodesize(_addr)
843         }
844     }
845 
846     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
847         return oraclize.setCustomGasPrice(_gasPrice);
848     }
849 
850     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
851         return oraclize.randomDS_getSessionPubKeyHash();
852     }
853 
854     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
855         bytes memory tmp = bytes(_a);
856         uint160 iaddr = 0;
857         uint160 b1;
858         uint160 b2;
859         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
860             iaddr *= 256;
861             b1 = uint160(uint8(tmp[i]));
862             b2 = uint160(uint8(tmp[i + 1]));
863             if ((b1 >= 97) && (b1 <= 102)) {
864                 b1 -= 87;
865             } else if ((b1 >= 65) && (b1 <= 70)) {
866                 b1 -= 55;
867             } else if ((b1 >= 48) && (b1 <= 57)) {
868                 b1 -= 48;
869             }
870             if ((b2 >= 97) && (b2 <= 102)) {
871                 b2 -= 87;
872             } else if ((b2 >= 65) && (b2 <= 70)) {
873                 b2 -= 55;
874             } else if ((b2 >= 48) && (b2 <= 57)) {
875                 b2 -= 48;
876             }
877             iaddr += (b1 * 16 + b2);
878         }
879         return address(iaddr);
880     }
881 
882     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
883         bytes memory a = bytes(_a);
884         bytes memory b = bytes(_b);
885         uint minLength = a.length;
886         if (b.length < minLength) {
887             minLength = b.length;
888         }
889         for (uint i = 0; i < minLength; i ++) {
890             if (a[i] < b[i]) {
891                 return -1;
892             } else if (a[i] > b[i]) {
893                 return 1;
894             }
895         }
896         if (a.length < b.length) {
897             return -1;
898         } else if (a.length > b.length) {
899             return 1;
900         } else {
901             return 0;
902         }
903     }
904 
905     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
906         bytes memory h = bytes(_haystack);
907         bytes memory n = bytes(_needle);
908         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
909             return -1;
910         } else if (h.length > (2 ** 128 - 1)) {
911             return -1;
912         } else {
913             uint subindex = 0;
914             for (uint i = 0; i < h.length; i++) {
915                 if (h[i] == n[0]) {
916                     subindex = 1;
917                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
918                         subindex++;
919                     }
920                     if (subindex == n.length) {
921                         return int(i);
922                     }
923                 }
924             }
925             return -1;
926         }
927     }
928 
929     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
930         return strConcat(_a, _b, "", "", "");
931     }
932 
933     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
934         return strConcat(_a, _b, _c, "", "");
935     }
936 
937     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
938         return strConcat(_a, _b, _c, _d, "");
939     }
940 
941     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
942         bytes memory _ba = bytes(_a);
943         bytes memory _bb = bytes(_b);
944         bytes memory _bc = bytes(_c);
945         bytes memory _bd = bytes(_d);
946         bytes memory _be = bytes(_e);
947         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
948         bytes memory babcde = bytes(abcde);
949         uint k = 0;
950         uint i = 0;
951         for (i = 0; i < _ba.length; i++) {
952             babcde[k++] = _ba[i];
953         }
954         for (i = 0; i < _bb.length; i++) {
955             babcde[k++] = _bb[i];
956         }
957         for (i = 0; i < _bc.length; i++) {
958             babcde[k++] = _bc[i];
959         }
960         for (i = 0; i < _bd.length; i++) {
961             babcde[k++] = _bd[i];
962         }
963         for (i = 0; i < _be.length; i++) {
964             babcde[k++] = _be[i];
965         }
966         return string(babcde);
967     }
968 
969     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
970         return safeParseInt(_a, 0);
971     }
972 
973     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
974         bytes memory bresult = bytes(_a);
975         uint mint = 0;
976         bool decimals = false;
977         for (uint i = 0; i < bresult.length; i++) {
978             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
979                 if (decimals) {
980                    if (_b == 0) break;
981                     else _b--;
982                 }
983                 mint *= 10;
984                 mint += uint(uint8(bresult[i])) - 48;
985             } else if (uint(uint8(bresult[i])) == 46) {
986                 require(!decimals, 'More than one decimal encountered in string!');
987                 decimals = true;
988             } else {
989                 revert("Non-numeral character encountered in string!");
990             }
991         }
992         if (_b > 0) {
993             mint *= 10 ** _b;
994         }
995         return mint;
996     }
997 
998     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
999         return parseInt(_a, 0);
1000     }
1001 
1002     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1003         bytes memory bresult = bytes(_a);
1004         uint mint = 0;
1005         bool decimals = false;
1006         for (uint i = 0; i < bresult.length; i++) {
1007             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1008                 if (decimals) {
1009                    if (_b == 0) {
1010                        break;
1011                    } else {
1012                        _b--;
1013                    }
1014                 }
1015                 mint *= 10;
1016                 mint += uint(uint8(bresult[i])) - 48;
1017             } else if (uint(uint8(bresult[i])) == 46) {
1018                 decimals = true;
1019             }
1020         }
1021         if (_b > 0) {
1022             mint *= 10 ** _b;
1023         }
1024         return mint;
1025     }
1026 
1027     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1028         if (_i == 0) {
1029             return "0";
1030         }
1031         uint j = _i;
1032         uint len;
1033         while (j != 0) {
1034             len++;
1035             j /= 10;
1036         }
1037         bytes memory bstr = new bytes(len);
1038         uint k = len - 1;
1039         while (_i != 0) {
1040             bstr[k--] = byte(uint8(48 + _i % 10));
1041             _i /= 10;
1042         }
1043         return string(bstr);
1044     }
1045 
1046     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1047         safeMemoryCleaner();
1048         Buffer.buffer memory buf;
1049         Buffer.init(buf, 1024);
1050         buf.startArray();
1051         for (uint i = 0; i < _arr.length; i++) {
1052             buf.encodeString(_arr[i]);
1053         }
1054         buf.endSequence();
1055         return buf.buf;
1056     }
1057 
1058     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1059         safeMemoryCleaner();
1060         Buffer.buffer memory buf;
1061         Buffer.init(buf, 1024);
1062         buf.startArray();
1063         for (uint i = 0; i < _arr.length; i++) {
1064             buf.encodeBytes(_arr[i]);
1065         }
1066         buf.endSequence();
1067         return buf.buf;
1068     }
1069 
1070     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1071         require((_nbytes > 0) && (_nbytes <= 32));
1072         _delay *= 10; // Convert from seconds to ledger timer ticks
1073         bytes memory nbytes = new bytes(1);
1074         nbytes[0] = byte(uint8(_nbytes));
1075         bytes memory unonce = new bytes(32);
1076         bytes memory sessionKeyHash = new bytes(32);
1077         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1078         assembly {
1079             mstore(unonce, 0x20)
1080             /*
1081              The following variables can be relaxed.
1082              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1083              for an idea on how to override and replace commit hash variables.
1084             */
1085             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1086             mstore(sessionKeyHash, 0x20)
1087             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1088         }
1089         bytes memory delay = new bytes(32);
1090         assembly {
1091             mstore(add(delay, 0x20), _delay)
1092         }
1093         bytes memory delay_bytes8 = new bytes(8);
1094         copyBytes(delay, 24, 8, delay_bytes8, 0);
1095         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1096         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1097         bytes memory delay_bytes8_left = new bytes(8);
1098         assembly {
1099             let x := mload(add(delay_bytes8, 0x20))
1100             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1101             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1102             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1103             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1104             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1105             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1106             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1107             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1108         }
1109         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1110         return queryId;
1111     }
1112 
1113     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1114         oraclize_randomDS_args[_queryId] = _commitment;
1115     }
1116 
1117     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1118         bool sigok;
1119         address signer;
1120         bytes32 sigr;
1121         bytes32 sigs;
1122         bytes memory sigr_ = new bytes(32);
1123         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1124         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1125         bytes memory sigs_ = new bytes(32);
1126         offset += 32 + 2;
1127         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1128         assembly {
1129             sigr := mload(add(sigr_, 32))
1130             sigs := mload(add(sigs_, 32))
1131         }
1132         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1133         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1134             return true;
1135         } else {
1136             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1137             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1138         }
1139     }
1140 
1141     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1142         bool sigok;
1143         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1144         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1145         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1146         bytes memory appkey1_pubkey = new bytes(64);
1147         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1148         bytes memory tosign2 = new bytes(1 + 65 + 32);
1149         tosign2[0] = byte(uint8(1)); //role
1150         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1151         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1152         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1153         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1154         if (!sigok) {
1155             return false;
1156         }
1157         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1158         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1159         bytes memory tosign3 = new bytes(1 + 65);
1160         tosign3[0] = 0xFE;
1161         copyBytes(_proof, 3, 65, tosign3, 1);
1162         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1163         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1164         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1165         return sigok;
1166     }
1167 
1168     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1169         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1170         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1171             return 1;
1172         }
1173         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1174         if (!proofVerified) {
1175             return 2;
1176         }
1177         return 0;
1178     }
1179 
1180     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1181         bool match_ = true;
1182         require(_prefix.length == _nRandomBytes);
1183         for (uint256 i = 0; i< _nRandomBytes; i++) {
1184             if (_content[i] != _prefix[i]) {
1185                 match_ = false;
1186             }
1187         }
1188         return match_;
1189     }
1190 
1191     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1192         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1193         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1194         bytes memory keyhash = new bytes(32);
1195         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1196         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1197             return false;
1198         }
1199         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1200         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1201         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1202         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1203             return false;
1204         }
1205         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1206         // This is to verify that the computed args match with the ones specified in the query.
1207         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1208         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1209         bytes memory sessionPubkey = new bytes(64);
1210         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1211         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1212         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1213         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1214             delete oraclize_randomDS_args[_queryId];
1215         } else return false;
1216         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1217         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1218         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1219         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1220             return false;
1221         }
1222         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1223         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1224             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1225         }
1226         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1227     }
1228     /*
1229      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1230     */
1231     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1232         uint minLength = _length + _toOffset;
1233         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1234         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1235         uint j = 32 + _toOffset;
1236         while (i < (32 + _fromOffset + _length)) {
1237             assembly {
1238                 let tmp := mload(add(_from, i))
1239                 mstore(add(_to, j), tmp)
1240             }
1241             i += 32;
1242             j += 32;
1243         }
1244         return _to;
1245     }
1246     /*
1247      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1248      Duplicate Solidity's ecrecover, but catching the CALL return value
1249     */
1250     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1251         /*
1252          We do our own memory management here. Solidity uses memory offset
1253          0x40 to store the current end of memory. We write past it (as
1254          writes are memory extensions), but don't update the offset so
1255          Solidity will reuse it. The memory used here is only needed for
1256          this context.
1257          FIXME: inline assembly can't access return values
1258         */
1259         bool ret;
1260         address addr;
1261         assembly {
1262             let size := mload(0x40)
1263             mstore(size, _hash)
1264             mstore(add(size, 32), _v)
1265             mstore(add(size, 64), _r)
1266             mstore(add(size, 96), _s)
1267             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1268             addr := mload(size)
1269         }
1270         return (ret, addr);
1271     }
1272     /*
1273      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1274     */
1275     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1276         bytes32 r;
1277         bytes32 s;
1278         uint8 v;
1279         if (_sig.length != 65) {
1280             return (false, address(0));
1281         }
1282         /*
1283          The signature format is a compact form of:
1284            {bytes32 r}{bytes32 s}{uint8 v}
1285          Compact means, uint8 is not padded to 32 bytes.
1286         */
1287         assembly {
1288             r := mload(add(_sig, 32))
1289             s := mload(add(_sig, 64))
1290             /*
1291              Here we are loading the last 32 bytes. We exploit the fact that
1292              'mload' will pad with zeroes if we overread.
1293              There is no 'mload8' to do this, but that would be nicer.
1294             */
1295             v := byte(0, mload(add(_sig, 96)))
1296             /*
1297               Alternative solution:
1298               'byte' is not working due to the Solidity parser, so lets
1299               use the second best option, 'and'
1300               v := and(mload(add(_sig, 65)), 255)
1301             */
1302         }
1303         /*
1304          albeit non-transactional signatures are not specified by the YP, one would expect it
1305          to match the YP range of [27, 28]
1306          geth uses [0, 1] and some clients have followed. This might change, see:
1307          https://github.com/ethereum/go-ethereum/issues/2053
1308         */
1309         if (v < 27) {
1310             v += 27;
1311         }
1312         if (v != 27 && v != 28) {
1313             return (false, address(0));
1314         }
1315         return safer_ecrecover(_hash, v, r, s);
1316     }
1317 
1318     function safeMemoryCleaner() internal pure {
1319         assembly {
1320             let fmem := mload(0x40)
1321             codecopy(fmem, codesize, sub(msize, fmem))
1322         }
1323     }
1324 }
1325 /*
1326 END ORACLIZE_API
1327 */
1328 
1329 
1330 /**
1331  * @title SafeMath
1332  * @dev Unsigned math operations with safety checks that revert on error.
1333  */
1334 library SafeMath {
1335 
1336     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1337         if (a == 0) {
1338             return 0;
1339         }
1340 
1341         uint256 c = a * b;
1342         require(c / a == b, "SafeMath: multiplication overflow");
1343 
1344         return c;
1345     }
1346 
1347     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1348         require(b > 0, "SafeMath: division by zero");
1349         uint256 c = a / b;
1350 
1351         return c;
1352     }
1353 
1354     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1355         require(b <= a, "SafeMath: subtraction overflow");
1356         uint256 c = a - b;
1357 
1358         return c;
1359     }
1360 
1361     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1362         uint256 c = a + b;
1363         require(c >= a, "SafeMath: addition overflow");
1364 
1365         return c;
1366     }
1367 
1368     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1369         require(b != 0, "SafeMath: modulo by zero");
1370         return a % b;
1371     }
1372 }
1373 
1374 /**
1375  * @title Ownable
1376  * @dev The Ownable contract has an owner address, and provides basic authorization control
1377  * functions, this simplifies the implementation of "user permissions".
1378  */
1379 contract Ownable {
1380 
1381     address internal _owner;
1382 
1383     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1384 
1385     constructor () internal {
1386         _owner = msg.sender;
1387         emit OwnershipTransferred(address(0), _owner);
1388     }
1389 
1390     function owner() public view returns (address) {
1391         return _owner;
1392     }
1393 
1394     modifier onlyOwner() {
1395         require(isOwner(), "Caller is not the owner");
1396         _;
1397     }
1398 
1399     function isOwner() public view returns (bool) {
1400         return msg.sender == _owner;
1401     }
1402 
1403     function renounceOwnership() public onlyOwner {
1404         emit OwnershipTransferred(_owner, address(0));
1405         _owner = address(0);
1406     }
1407 
1408     function transferOwnership(address newOwner) public onlyOwner {
1409         require(newOwner != address(0), "New owner is the zero address");
1410         emit OwnershipTransferred(_owner, newOwner);
1411         _owner = newOwner;
1412     }
1413 
1414 }
1415 
1416 /**
1417  * @title ERC20 interface
1418  * @dev see https://eips.ethereum.org/EIPS/eip-20
1419  */
1420 interface IERC20 {
1421     function transfer(address to, uint256 value) external returns (bool);
1422     function balanceOf(address who) external view returns (uint256);
1423 }
1424 
1425 /**
1426  * @title PriceReceiver
1427  * @dev The PriceReceiver interface to interact with crowdsale.
1428  */
1429 interface PriceReceiver {
1430     function receiveEthPrice(uint256 ethUsdPrice) external;
1431 }
1432 
1433 /**
1434  * @title PriceProvider
1435  * @dev The PriceProvider contract to interact with oraclizer.
1436  * @author https://grox.solutions
1437  */
1438 contract PriceProvider is Ownable, usingOraclize {
1439     using SafeMath for uint256;
1440 
1441     PriceReceiver public priceReceiver;
1442 
1443     uint256 public updateInterval = 21600;
1444 
1445     uint256 public decimals = 2;
1446 
1447     uint256 public gasLimit;
1448 
1449     uint256 public gasPrice;
1450 
1451     string public url;
1452 
1453     bytes32 validId;
1454 
1455     enum State { Stopped, Active }
1456     State public state = State.Stopped;
1457 
1458     event InsufficientFunds();
1459 
1460     modifier inActiveState() {
1461         require(state == State.Active);
1462         _;
1463     }
1464 
1465     modifier inStoppedState() {
1466         require(state == State.Stopped);
1467         _;
1468     }
1469 
1470     constructor(string memory _url, address newReceiver, uint256 interval, uint256 priceDecimals, uint256 newGasPrice, uint256 newGasLimit, address initialOwner) public {
1471         setUrl(_url);
1472         setReciever(newReceiver);
1473         setUpdateInterval(interval);
1474         setDecimals(priceDecimals);
1475         setGasPrice(newGasPrice);
1476         setGasLimit(newGasLimit);
1477         transferOwnership(initialOwner);
1478     }
1479 
1480     function() external payable {}
1481 
1482     function start_update() external payable onlyOwner inStoppedState {
1483         state = State.Active;
1484         _update();
1485     }
1486 
1487     function stop_update() external onlyOwner inActiveState {
1488         state = State.Stopped;
1489         delete validId;
1490     }
1491 
1492     function setUrl(string memory newUrl) public onlyOwner {
1493         require(bytes(newUrl).length > 0);
1494         url = newUrl;
1495     }
1496 
1497     function setReciever(address newReceiver) public onlyOwner {
1498         require(newReceiver != address(0));
1499         priceReceiver = PriceReceiver(newReceiver);
1500     }
1501 
1502     function setUpdateInterval(uint256 newInterval) public onlyOwner {
1503         require(newInterval > 0);
1504         updateInterval = newInterval;
1505     }
1506 
1507     function setDecimals(uint256 newDecimals) public onlyOwner {
1508         decimals = newDecimals;
1509     }
1510 
1511     function setGasPrice(uint256 newGasPrice) public onlyOwner {
1512         require(newGasPrice > 0);
1513         gasPrice = newGasPrice;
1514         oraclize_setCustomGasPrice(newGasPrice);
1515     }
1516 
1517     function setGasLimit(uint256 newGasLimit) public onlyOwner {
1518         require(newGasLimit > 0);
1519         gasLimit = newGasLimit;
1520     }
1521 
1522     function __callback(bytes32 myid, string memory result, bytes memory proof) public {
1523         require(msg.sender == oraclize_cbAddress());
1524 
1525         uint256 newPrice = parseInt(result, decimals);
1526         require(newPrice > 0);
1527 
1528         if (state == State.Active && validId == myid) {
1529             priceReceiver.receiveEthPrice(newPrice);
1530             _update();
1531         } else if (state == State.Stopped) {
1532             delete validId;
1533         }
1534     }
1535 
1536     function _update() internal {
1537         if (oraclize_getPrice("URL") <= address(this).balance) {
1538             validId = oraclize_query(updateInterval, "URL", url, gasLimit);
1539         } else {
1540             state = State.Stopped;
1541             delete validId;
1542             emit InsufficientFunds();
1543         }
1544     }
1545 
1546     function withdraw(address payable receiver) external onlyOwner {
1547         require(receiver != address(0));
1548         receiver.transfer(address(this).balance);
1549     }
1550 
1551     function withdrawERC20(address ERC20Token, address recipient) external onlyOwner {
1552         uint256 amount = IERC20(ERC20Token).balanceOf(address(this));
1553         IERC20(ERC20Token).transfer(recipient, amount);
1554     }
1555 }