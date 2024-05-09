1 /*
2  * Copyright 2019 Authpaper Team
3  *
4  * Licensed under the Apache License, Version 2.0 (the "License");
5  * you may not use this file except in compliance with the License.
6  * You may obtain a copy of the License at
7  *
8  *      http://www.apache.org/licenses/LICENSE-2.0
9  *
10  * Unless required by applicable law or agreed to in writing, software
11  * distributed under the License is distributed on an "AS IS" BASIS,
12  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
13  * See the License for the specific language governing permissions and
14  * limitations under the License.
15  */
16 pragma solidity ^0.5.3;
17 //import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";
18 
19 
20 
21 
22 
23 
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
51 
52 Begin solidity-cborutils
53 
54 https://github.com/smartcontractkit/solidity-cborutils
55 
56 MIT License
57 
58 Copyright (c) 2018 SmartContract ChainLink, Ltd.
59 
60 Permission is hereby granted, free of charge, to any person obtaining a copy
61 of this software and associated documentation files (the "Software"), to deal
62 in the Software without restriction, including without limitation the rights
63 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
64 copies of the Software, and to permit persons to whom the Software is
65 furnished to do so, subject to the following conditions:
66 
67 The above copyright notice and this permission notice shall be included in all
68 copies or substantial portions of the Software.
69 
70 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
71 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
72 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
73 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
74 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
75 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
76 SOFTWARE.
77 
78 */
79 library Buffer {
80 
81     struct buffer {
82         bytes buf;
83         uint capacity;
84     }
85 
86     function init(buffer memory _buf, uint _capacity) internal pure {
87         uint capacity = _capacity;
88         if (capacity % 32 != 0) {
89             capacity += 32 - (capacity % 32);
90         }
91         _buf.capacity = capacity; // Allocate space for the buffer data
92         assembly {
93             let ptr := mload(0x40)
94             mstore(_buf, ptr)
95             mstore(ptr, 0)
96             mstore(0x40, add(ptr, capacity))
97         }
98     }
99 
100     function resize(buffer memory _buf, uint _capacity) private pure {
101         bytes memory oldbuf = _buf.buf;
102         init(_buf, _capacity);
103         append(_buf, oldbuf);
104     }
105 
106     function max(uint _a, uint _b) private pure returns (uint _max) {
107         if (_a > _b) {
108             return _a;
109         }
110         return _b;
111     }
112     /**
113       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
114       *      would exceed the capacity of the buffer.
115       * @param _buf The buffer to append to.
116       * @param _data The data to append.
117       * @return The original buffer.
118       *
119       */
120     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
121         if (_data.length + _buf.buf.length > _buf.capacity) {
122             resize(_buf, max(_buf.capacity, _data.length) * 2);
123         }
124         uint dest;
125         uint src;
126         uint len = _data.length;
127         assembly {
128             let bufptr := mload(_buf) // Memory address of the buffer data
129             let buflen := mload(bufptr) // Length of existing buffer data
130             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
131             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
132             src := add(_data, 32)
133         }
134         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
135             assembly {
136                 mstore(dest, mload(src))
137             }
138             dest += 32;
139             src += 32;
140         }
141         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
142         assembly {
143             let srcpart := and(mload(src), not(mask))
144             let destpart := and(mload(dest), mask)
145             mstore(dest, or(destpart, srcpart))
146         }
147         return _buf;
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
158     function append(buffer memory _buf, uint8 _data) internal pure {
159         if (_buf.buf.length + 1 > _buf.capacity) {
160             resize(_buf, _buf.capacity * 2);
161         }
162         assembly {
163             let bufptr := mload(_buf) // Memory address of the buffer data
164             let buflen := mload(bufptr) // Length of existing buffer data
165             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
166             mstore8(dest, _data)
167             mstore(bufptr, add(buflen, 1)) // Update buffer length
168         }
169     }
170     /**
171       *
172       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
173       * exceed the capacity of the buffer.
174       * @param _buf The buffer to append to.
175       * @param _data The data to append.
176       * @return The original buffer.
177       *
178       */
179     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
180         if (_len + _buf.buf.length > _buf.capacity) {
181             resize(_buf, max(_buf.capacity, _len) * 2);
182         }
183         uint mask = 256 ** _len - 1;
184         assembly {
185             let bufptr := mload(_buf) // Memory address of the buffer data
186             let buflen := mload(bufptr) // Length of existing buffer data
187             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
188             mstore(dest, or(and(mload(dest), not(mask)), _data))
189             mstore(bufptr, add(buflen, _len)) // Update buffer length
190         }
191         return _buf;
192     }
193 }
194 
195 library CBOR {
196 
197     using Buffer for Buffer.buffer;
198 
199     uint8 private constant MAJOR_TYPE_INT = 0;
200     uint8 private constant MAJOR_TYPE_MAP = 5;
201     uint8 private constant MAJOR_TYPE_BYTES = 2;
202     uint8 private constant MAJOR_TYPE_ARRAY = 4;
203     uint8 private constant MAJOR_TYPE_STRING = 3;
204     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
205     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
206 
207     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
208         if (_value <= 23) {
209             _buf.append(uint8((_major << 5) | _value));
210         } else if (_value <= 0xFF) {
211             _buf.append(uint8((_major << 5) | 24));
212             _buf.appendInt(_value, 1);
213         } else if (_value <= 0xFFFF) {
214             _buf.append(uint8((_major << 5) | 25));
215             _buf.appendInt(_value, 2);
216         } else if (_value <= 0xFFFFFFFF) {
217             _buf.append(uint8((_major << 5) | 26));
218             _buf.appendInt(_value, 4);
219         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
220             _buf.append(uint8((_major << 5) | 27));
221             _buf.appendInt(_value, 8);
222         }
223     }
224 
225     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
226         _buf.append(uint8((_major << 5) | 31));
227     }
228 
229     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
230         encodeType(_buf, MAJOR_TYPE_INT, _value);
231     }
232 
233     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
234         if (_value >= 0) {
235             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
236         } else {
237             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
238         }
239     }
240 
241     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
242         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
243         _buf.append(_value);
244     }
245 
246     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
247         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
248         _buf.append(bytes(_value));
249     }
250 
251     function startArray(Buffer.buffer memory _buf) internal pure {
252         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
253     }
254 
255     function startMap(Buffer.buffer memory _buf) internal pure {
256         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
257     }
258 
259     function endSequence(Buffer.buffer memory _buf) internal pure {
260         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
261     }
262 }
263 /*
264 
265 End solidity-cborutils
266 
267 */
268 contract usingOraclize {
269 
270     using CBOR for Buffer.buffer;
271 
272     OraclizeI oraclize;
273     OraclizeAddrResolverI OAR;
274 
275     uint constant day = 60 * 60 * 24;
276     uint constant week = 60 * 60 * 24 * 7;
277     uint constant month = 60 * 60 * 24 * 30;
278 
279     byte constant proofType_NONE = 0x00;
280     byte constant proofType_Ledger = 0x30;
281     byte constant proofType_Native = 0xF0;
282     byte constant proofStorage_IPFS = 0x01;
283     byte constant proofType_Android = 0x40;
284     byte constant proofType_TLSNotary = 0x10;
285 
286     string oraclize_network_name;
287     uint8 constant networkID_auto = 0;
288     uint8 constant networkID_morden = 2;
289     uint8 constant networkID_mainnet = 1;
290     uint8 constant networkID_testnet = 2;
291     uint8 constant networkID_consensys = 161;
292 
293     mapping(bytes32 => bytes32) oraclize_randomDS_args;
294     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
295 
296     modifier oraclizeAPI {
297         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
298             oraclize_setNetwork(networkID_auto);
299         }
300         if (address(oraclize) != OAR.getAddress()) {
301             oraclize = OraclizeI(OAR.getAddress());
302         }
303         _;
304     }
305 
306     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
307         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
308         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
309         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
310         require(proofVerified);
311         _;
312     }
313 
314     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
315       return oraclize_setNetwork();
316       _networkID; // silence the warning and remain backwards compatible
317     }
318 
319     function oraclize_setNetworkName(string memory _network_name) internal {
320         oraclize_network_name = _network_name;
321     }
322 
323     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
324         return oraclize_network_name;
325     }
326 
327     function oraclize_setNetwork() internal returns (bool _networkSet) {
328         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
329             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
330             oraclize_setNetworkName("eth_mainnet");
331             return true;
332         }
333         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
334             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
335             oraclize_setNetworkName("eth_ropsten3");
336             return true;
337         }
338         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
339             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
340             oraclize_setNetworkName("eth_kovan");
341             return true;
342         }
343         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
344             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
345             oraclize_setNetworkName("eth_rinkeby");
346             return true;
347         }
348         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
349             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
350             return true;
351         }
352         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
353             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
354             return true;
355         }
356         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
357             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
358             return true;
359         }
360         return false;
361     }
362 
363     function __callback(bytes32 _myid, string memory _result) public {
364         __callback(_myid, _result, new bytes(0));
365     }
366 
367     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
368       return;
369       _myid; _result; _proof; // Silence compiler warnings
370     }
371 
372     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
373         return oraclize.getPrice(_datasource);
374     }
375 
376     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
377         return oraclize.getPrice(_datasource, _gasLimit);
378     }
379 
380     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
381         uint price = oraclize.getPrice(_datasource);
382         if (price > 1 ether + tx.gasprice * 200000) {
383             return 0; // Unexpectedly high price
384         }
385         return oraclize.query.value(price)(0, _datasource, _arg);
386     }
387 
388     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
389         uint price = oraclize.getPrice(_datasource);
390         if (price > 1 ether + tx.gasprice * 200000) {
391             return 0; // Unexpectedly high price
392         }
393         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
394     }
395 
396     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
397         uint price = oraclize.getPrice(_datasource,_gasLimit);
398         if (price > 1 ether + tx.gasprice * _gasLimit) {
399             return 0; // Unexpectedly high price
400         }
401         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
402     }
403 
404     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
405         uint price = oraclize.getPrice(_datasource, _gasLimit);
406         if (price > 1 ether + tx.gasprice * _gasLimit) {
407            return 0; // Unexpectedly high price
408         }
409         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
410     }
411 
412     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
413         uint price = oraclize.getPrice(_datasource);
414         if (price > 1 ether + tx.gasprice * 200000) {
415             return 0; // Unexpectedly high price
416         }
417         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
418     }
419 
420     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
421         uint price = oraclize.getPrice(_datasource);
422         if (price > 1 ether + tx.gasprice * 200000) {
423             return 0; // Unexpectedly high price
424         }
425         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
426     }
427 
428     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
429         uint price = oraclize.getPrice(_datasource, _gasLimit);
430         if (price > 1 ether + tx.gasprice * _gasLimit) {
431             return 0; // Unexpectedly high price
432         }
433         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
434     }
435 
436     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
437         uint price = oraclize.getPrice(_datasource, _gasLimit);
438         if (price > 1 ether + tx.gasprice * _gasLimit) {
439             return 0; // Unexpectedly high price
440         }
441         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
442     }
443 
444     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
445         uint price = oraclize.getPrice(_datasource);
446         if (price > 1 ether + tx.gasprice * 200000) {
447             return 0; // Unexpectedly high price
448         }
449         bytes memory args = stra2cbor(_argN);
450         return oraclize.queryN.value(price)(0, _datasource, args);
451     }
452 
453     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
454         uint price = oraclize.getPrice(_datasource);
455         if (price > 1 ether + tx.gasprice * 200000) {
456             return 0; // Unexpectedly high price
457         }
458         bytes memory args = stra2cbor(_argN);
459         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
460     }
461 
462     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
463         uint price = oraclize.getPrice(_datasource, _gasLimit);
464         if (price > 1 ether + tx.gasprice * _gasLimit) {
465             return 0; // Unexpectedly high price
466         }
467         bytes memory args = stra2cbor(_argN);
468         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
469     }
470 
471     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
472         uint price = oraclize.getPrice(_datasource, _gasLimit);
473         if (price > 1 ether + tx.gasprice * _gasLimit) {
474             return 0; // Unexpectedly high price
475         }
476         bytes memory args = stra2cbor(_argN);
477         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
478     }
479 
480     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
481         string[] memory dynargs = new string[](1);
482         dynargs[0] = _args[0];
483         return oraclize_query(_datasource, dynargs);
484     }
485 
486     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
487         string[] memory dynargs = new string[](1);
488         dynargs[0] = _args[0];
489         return oraclize_query(_timestamp, _datasource, dynargs);
490     }
491 
492     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
493         string[] memory dynargs = new string[](1);
494         dynargs[0] = _args[0];
495         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
496     }
497 
498     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
499         string[] memory dynargs = new string[](1);
500         dynargs[0] = _args[0];
501         return oraclize_query(_datasource, dynargs, _gasLimit);
502     }
503 
504     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
505         string[] memory dynargs = new string[](2);
506         dynargs[0] = _args[0];
507         dynargs[1] = _args[1];
508         return oraclize_query(_datasource, dynargs);
509     }
510 
511     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
512         string[] memory dynargs = new string[](2);
513         dynargs[0] = _args[0];
514         dynargs[1] = _args[1];
515         return oraclize_query(_timestamp, _datasource, dynargs);
516     }
517 
518     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
519         string[] memory dynargs = new string[](2);
520         dynargs[0] = _args[0];
521         dynargs[1] = _args[1];
522         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
523     }
524 
525     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
526         string[] memory dynargs = new string[](2);
527         dynargs[0] = _args[0];
528         dynargs[1] = _args[1];
529         return oraclize_query(_datasource, dynargs, _gasLimit);
530     }
531 
532     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
533         string[] memory dynargs = new string[](3);
534         dynargs[0] = _args[0];
535         dynargs[1] = _args[1];
536         dynargs[2] = _args[2];
537         return oraclize_query(_datasource, dynargs);
538     }
539 
540     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
541         string[] memory dynargs = new string[](3);
542         dynargs[0] = _args[0];
543         dynargs[1] = _args[1];
544         dynargs[2] = _args[2];
545         return oraclize_query(_timestamp, _datasource, dynargs);
546     }
547 
548     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
549         string[] memory dynargs = new string[](3);
550         dynargs[0] = _args[0];
551         dynargs[1] = _args[1];
552         dynargs[2] = _args[2];
553         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
554     }
555 
556     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
557         string[] memory dynargs = new string[](3);
558         dynargs[0] = _args[0];
559         dynargs[1] = _args[1];
560         dynargs[2] = _args[2];
561         return oraclize_query(_datasource, dynargs, _gasLimit);
562     }
563 
564     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
565         string[] memory dynargs = new string[](4);
566         dynargs[0] = _args[0];
567         dynargs[1] = _args[1];
568         dynargs[2] = _args[2];
569         dynargs[3] = _args[3];
570         return oraclize_query(_datasource, dynargs);
571     }
572 
573     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
574         string[] memory dynargs = new string[](4);
575         dynargs[0] = _args[0];
576         dynargs[1] = _args[1];
577         dynargs[2] = _args[2];
578         dynargs[3] = _args[3];
579         return oraclize_query(_timestamp, _datasource, dynargs);
580     }
581 
582     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
583         string[] memory dynargs = new string[](4);
584         dynargs[0] = _args[0];
585         dynargs[1] = _args[1];
586         dynargs[2] = _args[2];
587         dynargs[3] = _args[3];
588         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
589     }
590 
591     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
592         string[] memory dynargs = new string[](4);
593         dynargs[0] = _args[0];
594         dynargs[1] = _args[1];
595         dynargs[2] = _args[2];
596         dynargs[3] = _args[3];
597         return oraclize_query(_datasource, dynargs, _gasLimit);
598     }
599 
600     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
601         string[] memory dynargs = new string[](5);
602         dynargs[0] = _args[0];
603         dynargs[1] = _args[1];
604         dynargs[2] = _args[2];
605         dynargs[3] = _args[3];
606         dynargs[4] = _args[4];
607         return oraclize_query(_datasource, dynargs);
608     }
609 
610     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
611         string[] memory dynargs = new string[](5);
612         dynargs[0] = _args[0];
613         dynargs[1] = _args[1];
614         dynargs[2] = _args[2];
615         dynargs[3] = _args[3];
616         dynargs[4] = _args[4];
617         return oraclize_query(_timestamp, _datasource, dynargs);
618     }
619 
620     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
621         string[] memory dynargs = new string[](5);
622         dynargs[0] = _args[0];
623         dynargs[1] = _args[1];
624         dynargs[2] = _args[2];
625         dynargs[3] = _args[3];
626         dynargs[4] = _args[4];
627         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
628     }
629 
630     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
631         string[] memory dynargs = new string[](5);
632         dynargs[0] = _args[0];
633         dynargs[1] = _args[1];
634         dynargs[2] = _args[2];
635         dynargs[3] = _args[3];
636         dynargs[4] = _args[4];
637         return oraclize_query(_datasource, dynargs, _gasLimit);
638     }
639 
640     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
641         uint price = oraclize.getPrice(_datasource);
642         if (price > 1 ether + tx.gasprice * 200000) {
643             return 0; // Unexpectedly high price
644         }
645         bytes memory args = ba2cbor(_argN);
646         return oraclize.queryN.value(price)(0, _datasource, args);
647     }
648 
649     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
650         uint price = oraclize.getPrice(_datasource);
651         if (price > 1 ether + tx.gasprice * 200000) {
652             return 0; // Unexpectedly high price
653         }
654         bytes memory args = ba2cbor(_argN);
655         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
656     }
657 
658     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
659         uint price = oraclize.getPrice(_datasource, _gasLimit);
660         if (price > 1 ether + tx.gasprice * _gasLimit) {
661             return 0; // Unexpectedly high price
662         }
663         bytes memory args = ba2cbor(_argN);
664         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
665     }
666 
667     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
668         uint price = oraclize.getPrice(_datasource, _gasLimit);
669         if (price > 1 ether + tx.gasprice * _gasLimit) {
670             return 0; // Unexpectedly high price
671         }
672         bytes memory args = ba2cbor(_argN);
673         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
674     }
675 
676     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
677         bytes[] memory dynargs = new bytes[](1);
678         dynargs[0] = _args[0];
679         return oraclize_query(_datasource, dynargs);
680     }
681 
682     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
683         bytes[] memory dynargs = new bytes[](1);
684         dynargs[0] = _args[0];
685         return oraclize_query(_timestamp, _datasource, dynargs);
686     }
687 
688     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
689         bytes[] memory dynargs = new bytes[](1);
690         dynargs[0] = _args[0];
691         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
692     }
693 
694     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
695         bytes[] memory dynargs = new bytes[](1);
696         dynargs[0] = _args[0];
697         return oraclize_query(_datasource, dynargs, _gasLimit);
698     }
699 
700     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
701         bytes[] memory dynargs = new bytes[](2);
702         dynargs[0] = _args[0];
703         dynargs[1] = _args[1];
704         return oraclize_query(_datasource, dynargs);
705     }
706 
707     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
708         bytes[] memory dynargs = new bytes[](2);
709         dynargs[0] = _args[0];
710         dynargs[1] = _args[1];
711         return oraclize_query(_timestamp, _datasource, dynargs);
712     }
713 
714     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
715         bytes[] memory dynargs = new bytes[](2);
716         dynargs[0] = _args[0];
717         dynargs[1] = _args[1];
718         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
719     }
720 
721     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
722         bytes[] memory dynargs = new bytes[](2);
723         dynargs[0] = _args[0];
724         dynargs[1] = _args[1];
725         return oraclize_query(_datasource, dynargs, _gasLimit);
726     }
727 
728     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
729         bytes[] memory dynargs = new bytes[](3);
730         dynargs[0] = _args[0];
731         dynargs[1] = _args[1];
732         dynargs[2] = _args[2];
733         return oraclize_query(_datasource, dynargs);
734     }
735 
736     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
737         bytes[] memory dynargs = new bytes[](3);
738         dynargs[0] = _args[0];
739         dynargs[1] = _args[1];
740         dynargs[2] = _args[2];
741         return oraclize_query(_timestamp, _datasource, dynargs);
742     }
743 
744     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
745         bytes[] memory dynargs = new bytes[](3);
746         dynargs[0] = _args[0];
747         dynargs[1] = _args[1];
748         dynargs[2] = _args[2];
749         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
750     }
751 
752     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
753         bytes[] memory dynargs = new bytes[](3);
754         dynargs[0] = _args[0];
755         dynargs[1] = _args[1];
756         dynargs[2] = _args[2];
757         return oraclize_query(_datasource, dynargs, _gasLimit);
758     }
759 
760     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
761         bytes[] memory dynargs = new bytes[](4);
762         dynargs[0] = _args[0];
763         dynargs[1] = _args[1];
764         dynargs[2] = _args[2];
765         dynargs[3] = _args[3];
766         return oraclize_query(_datasource, dynargs);
767     }
768 
769     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
770         bytes[] memory dynargs = new bytes[](4);
771         dynargs[0] = _args[0];
772         dynargs[1] = _args[1];
773         dynargs[2] = _args[2];
774         dynargs[3] = _args[3];
775         return oraclize_query(_timestamp, _datasource, dynargs);
776     }
777 
778     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
779         bytes[] memory dynargs = new bytes[](4);
780         dynargs[0] = _args[0];
781         dynargs[1] = _args[1];
782         dynargs[2] = _args[2];
783         dynargs[3] = _args[3];
784         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
785     }
786 
787     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
788         bytes[] memory dynargs = new bytes[](4);
789         dynargs[0] = _args[0];
790         dynargs[1] = _args[1];
791         dynargs[2] = _args[2];
792         dynargs[3] = _args[3];
793         return oraclize_query(_datasource, dynargs, _gasLimit);
794     }
795 
796     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
797         bytes[] memory dynargs = new bytes[](5);
798         dynargs[0] = _args[0];
799         dynargs[1] = _args[1];
800         dynargs[2] = _args[2];
801         dynargs[3] = _args[3];
802         dynargs[4] = _args[4];
803         return oraclize_query(_datasource, dynargs);
804     }
805 
806     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
807         bytes[] memory dynargs = new bytes[](5);
808         dynargs[0] = _args[0];
809         dynargs[1] = _args[1];
810         dynargs[2] = _args[2];
811         dynargs[3] = _args[3];
812         dynargs[4] = _args[4];
813         return oraclize_query(_timestamp, _datasource, dynargs);
814     }
815 
816     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
817         bytes[] memory dynargs = new bytes[](5);
818         dynargs[0] = _args[0];
819         dynargs[1] = _args[1];
820         dynargs[2] = _args[2];
821         dynargs[3] = _args[3];
822         dynargs[4] = _args[4];
823         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
824     }
825 
826     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
827         bytes[] memory dynargs = new bytes[](5);
828         dynargs[0] = _args[0];
829         dynargs[1] = _args[1];
830         dynargs[2] = _args[2];
831         dynargs[3] = _args[3];
832         dynargs[4] = _args[4];
833         return oraclize_query(_datasource, dynargs, _gasLimit);
834     }
835 
836     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
837         return oraclize.setProofType(_proofP);
838     }
839 
840 
841     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
842         return oraclize.cbAddress();
843     }
844 
845     function getCodeSize(address _addr) view internal returns (uint _size) {
846         assembly {
847             _size := extcodesize(_addr)
848         }
849     }
850 
851     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
852         return oraclize.setCustomGasPrice(_gasPrice);
853     }
854 
855     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
856         return oraclize.randomDS_getSessionPubKeyHash();
857     }
858 
859     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
860         bytes memory tmp = bytes(_a);
861         uint160 iaddr = 0;
862         uint160 b1;
863         uint160 b2;
864         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
865             iaddr *= 256;
866             b1 = uint160(uint8(tmp[i]));
867             b2 = uint160(uint8(tmp[i + 1]));
868             if ((b1 >= 97) && (b1 <= 102)) {
869                 b1 -= 87;
870             } else if ((b1 >= 65) && (b1 <= 70)) {
871                 b1 -= 55;
872             } else if ((b1 >= 48) && (b1 <= 57)) {
873                 b1 -= 48;
874             }
875             if ((b2 >= 97) && (b2 <= 102)) {
876                 b2 -= 87;
877             } else if ((b2 >= 65) && (b2 <= 70)) {
878                 b2 -= 55;
879             } else if ((b2 >= 48) && (b2 <= 57)) {
880                 b2 -= 48;
881             }
882             iaddr += (b1 * 16 + b2);
883         }
884         return address(iaddr);
885     }
886 
887     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
888         bytes memory a = bytes(_a);
889         bytes memory b = bytes(_b);
890         uint minLength = a.length;
891         if (b.length < minLength) {
892             minLength = b.length;
893         }
894         for (uint i = 0; i < minLength; i ++) {
895             if (a[i] < b[i]) {
896                 return -1;
897             } else if (a[i] > b[i]) {
898                 return 1;
899             }
900         }
901         if (a.length < b.length) {
902             return -1;
903         } else if (a.length > b.length) {
904             return 1;
905         } else {
906             return 0;
907         }
908     }
909 
910     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
911         bytes memory h = bytes(_haystack);
912         bytes memory n = bytes(_needle);
913         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
914             return -1;
915         } else if (h.length > (2 ** 128 - 1)) {
916             return -1;
917         } else {
918             uint subindex = 0;
919             for (uint i = 0; i < h.length; i++) {
920                 if (h[i] == n[0]) {
921                     subindex = 1;
922                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
923                         subindex++;
924                     }
925                     if (subindex == n.length) {
926                         return int(i);
927                     }
928                 }
929             }
930             return -1;
931         }
932     }
933 
934     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
935         return strConcat(_a, _b, "", "", "");
936     }
937 
938     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
939         return strConcat(_a, _b, _c, "", "");
940     }
941 
942     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
943         return strConcat(_a, _b, _c, _d, "");
944     }
945 
946     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
947         bytes memory _ba = bytes(_a);
948         bytes memory _bb = bytes(_b);
949         bytes memory _bc = bytes(_c);
950         bytes memory _bd = bytes(_d);
951         bytes memory _be = bytes(_e);
952         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
953         bytes memory babcde = bytes(abcde);
954         uint k = 0;
955         uint i = 0;
956         for (i = 0; i < _ba.length; i++) {
957             babcde[k++] = _ba[i];
958         }
959         for (i = 0; i < _bb.length; i++) {
960             babcde[k++] = _bb[i];
961         }
962         for (i = 0; i < _bc.length; i++) {
963             babcde[k++] = _bc[i];
964         }
965         for (i = 0; i < _bd.length; i++) {
966             babcde[k++] = _bd[i];
967         }
968         for (i = 0; i < _be.length; i++) {
969             babcde[k++] = _be[i];
970         }
971         return string(babcde);
972     }
973 
974     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
975         return safeParseInt(_a, 0);
976     }
977 
978     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
979         bytes memory bresult = bytes(_a);
980         uint mint = 0;
981         bool decimals = false;
982         for (uint i = 0; i < bresult.length; i++) {
983             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
984                 if (decimals) {
985                    if (_b == 0) break;
986                     else _b--;
987                 }
988                 mint *= 10;
989                 mint += uint(uint8(bresult[i])) - 48;
990             } else if (uint(uint8(bresult[i])) == 46) {
991                 require(!decimals, 'More than one decimal encountered in string!');
992                 decimals = true;
993             } else {
994                 revert("Non-numeral character encountered in string!");
995             }
996         }
997         if (_b > 0) {
998             mint *= 10 ** _b;
999         }
1000         return mint;
1001     }
1002 
1003     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
1004         return parseInt(_a, 0);
1005     }
1006 
1007     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1008         bytes memory bresult = bytes(_a);
1009         uint mint = 0;
1010         bool decimals = false;
1011         for (uint i = 0; i < bresult.length; i++) {
1012             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1013                 if (decimals) {
1014                    if (_b == 0) {
1015                        break;
1016                    } else {
1017                        _b--;
1018                    }
1019                 }
1020                 mint *= 10;
1021                 mint += uint(uint8(bresult[i])) - 48;
1022             } else if (uint(uint8(bresult[i])) == 46) {
1023                 decimals = true;
1024             }
1025         }
1026         if (_b > 0) {
1027             mint *= 10 ** _b;
1028         }
1029         return mint;
1030     }
1031 
1032     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1033         if (_i == 0) {
1034             return "0";
1035         }
1036         uint j = _i;
1037         uint len;
1038         while (j != 0) {
1039             len++;
1040             j /= 10;
1041         }
1042         bytes memory bstr = new bytes(len);
1043         uint k = len - 1;
1044         while (_i != 0) {
1045             bstr[k--] = byte(uint8(48 + _i % 10));
1046             _i /= 10;
1047         }
1048         return string(bstr);
1049     }
1050 
1051     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1052         safeMemoryCleaner();
1053         Buffer.buffer memory buf;
1054         Buffer.init(buf, 1024);
1055         buf.startArray();
1056         for (uint i = 0; i < _arr.length; i++) {
1057             buf.encodeString(_arr[i]);
1058         }
1059         buf.endSequence();
1060         return buf.buf;
1061     }
1062 
1063     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1064         safeMemoryCleaner();
1065         Buffer.buffer memory buf;
1066         Buffer.init(buf, 1024);
1067         buf.startArray();
1068         for (uint i = 0; i < _arr.length; i++) {
1069             buf.encodeBytes(_arr[i]);
1070         }
1071         buf.endSequence();
1072         return buf.buf;
1073     }
1074 
1075     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1076         require((_nbytes > 0) && (_nbytes <= 32));
1077         _delay *= 10; // Convert from seconds to ledger timer ticks
1078         bytes memory nbytes = new bytes(1);
1079         nbytes[0] = byte(uint8(_nbytes));
1080         bytes memory unonce = new bytes(32);
1081         bytes memory sessionKeyHash = new bytes(32);
1082         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1083         assembly {
1084             mstore(unonce, 0x20)
1085             /*
1086              The following variables can be relaxed.
1087              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1088              for an idea on how to override and replace commit hash variables.
1089             */
1090             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1091             mstore(sessionKeyHash, 0x20)
1092             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1093         }
1094         bytes memory delay = new bytes(32);
1095         assembly {
1096             mstore(add(delay, 0x20), _delay)
1097         }
1098         bytes memory delay_bytes8 = new bytes(8);
1099         copyBytes(delay, 24, 8, delay_bytes8, 0);
1100         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1101         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1102         bytes memory delay_bytes8_left = new bytes(8);
1103         assembly {
1104             let x := mload(add(delay_bytes8, 0x20))
1105             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1106             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1107             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1108             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1109             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1110             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1111             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1112             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1113         }
1114         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1115         return queryId;
1116     }
1117 
1118     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1119         oraclize_randomDS_args[_queryId] = _commitment;
1120     }
1121 
1122     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1123         bool sigok;
1124         address signer;
1125         bytes32 sigr;
1126         bytes32 sigs;
1127         bytes memory sigr_ = new bytes(32);
1128         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1129         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1130         bytes memory sigs_ = new bytes(32);
1131         offset += 32 + 2;
1132         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1133         assembly {
1134             sigr := mload(add(sigr_, 32))
1135             sigs := mload(add(sigs_, 32))
1136         }
1137         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1138         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1139             return true;
1140         } else {
1141             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1142             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1143         }
1144     }
1145 
1146     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1147         bool sigok;
1148         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1149         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1150         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1151         bytes memory appkey1_pubkey = new bytes(64);
1152         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1153         bytes memory tosign2 = new bytes(1 + 65 + 32);
1154         tosign2[0] = byte(uint8(1)); //role
1155         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1156         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1157         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1158         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1159         if (!sigok) {
1160             return false;
1161         }
1162         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1163         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1164         bytes memory tosign3 = new bytes(1 + 65);
1165         tosign3[0] = 0xFE;
1166         copyBytes(_proof, 3, 65, tosign3, 1);
1167         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1168         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1169         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1170         return sigok;
1171     }
1172 
1173     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1174         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1175         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1176             return 1;
1177         }
1178         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1179         if (!proofVerified) {
1180             return 2;
1181         }
1182         return 0;
1183     }
1184 
1185     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1186         bool match_ = true;
1187         require(_prefix.length == _nRandomBytes);
1188         for (uint256 i = 0; i< _nRandomBytes; i++) {
1189             if (_content[i] != _prefix[i]) {
1190                 match_ = false;
1191             }
1192         }
1193         return match_;
1194     }
1195 
1196     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1197         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1198         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1199         bytes memory keyhash = new bytes(32);
1200         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1201         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1202             return false;
1203         }
1204         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1205         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1206         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1207         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1208             return false;
1209         }
1210         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1211         // This is to verify that the computed args match with the ones specified in the query.
1212         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1213         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1214         bytes memory sessionPubkey = new bytes(64);
1215         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1216         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1217         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1218         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1219             delete oraclize_randomDS_args[_queryId];
1220         } else return false;
1221         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1222         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1223         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1224         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1225             return false;
1226         }
1227         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1228         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1229             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1230         }
1231         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1232     }
1233     /*
1234      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1235     */
1236     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1237         uint minLength = _length + _toOffset;
1238         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1239         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1240         uint j = 32 + _toOffset;
1241         while (i < (32 + _fromOffset + _length)) {
1242             assembly {
1243                 let tmp := mload(add(_from, i))
1244                 mstore(add(_to, j), tmp)
1245             }
1246             i += 32;
1247             j += 32;
1248         }
1249         return _to;
1250     }
1251     /*
1252      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1253      Duplicate Solidity's ecrecover, but catching the CALL return value
1254     */
1255     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1256         /*
1257          We do our own memory management here. Solidity uses memory offset
1258          0x40 to store the current end of memory. We write past it (as
1259          writes are memory extensions), but don't update the offset so
1260          Solidity will reuse it. The memory used here is only needed for
1261          this context.
1262          FIXME: inline assembly can't access return values
1263         */
1264         bool ret;
1265         address addr;
1266         assembly {
1267             let size := mload(0x40)
1268             mstore(size, _hash)
1269             mstore(add(size, 32), _v)
1270             mstore(add(size, 64), _r)
1271             mstore(add(size, 96), _s)
1272             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1273             addr := mload(size)
1274         }
1275         return (ret, addr);
1276     }
1277     /*
1278      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1279     */
1280     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1281         bytes32 r;
1282         bytes32 s;
1283         uint8 v;
1284         if (_sig.length != 65) {
1285             return (false, address(0));
1286         }
1287         /*
1288          The signature format is a compact form of:
1289            {bytes32 r}{bytes32 s}{uint8 v}
1290          Compact means, uint8 is not padded to 32 bytes.
1291         */
1292         assembly {
1293             r := mload(add(_sig, 32))
1294             s := mload(add(_sig, 64))
1295             /*
1296              Here we are loading the last 32 bytes. We exploit the fact that
1297              'mload' will pad with zeroes if we overread.
1298              There is no 'mload8' to do this, but that would be nicer.
1299             */
1300             v := byte(0, mload(add(_sig, 96)))
1301             /*
1302               Alternative solution:
1303               'byte' is not working due to the Solidity parser, so lets
1304               use the second best option, 'and'
1305               v := and(mload(add(_sig, 65)), 255)
1306             */
1307         }
1308         /*
1309          albeit non-transactional signatures are not specified by the YP, one would expect it
1310          to match the YP range of [27, 28]
1311          geth uses [0, 1] and some clients have followed. This might change, see:
1312          https://github.com/ethereum/go-ethereum/issues/2053
1313         */
1314         if (v < 27) {
1315             v += 27;
1316         }
1317         if (v != 27 && v != 28) {
1318             return (false, address(0));
1319         }
1320         return safer_ecrecover(_hash, v, r, s);
1321     }
1322 
1323     function safeMemoryCleaner() internal pure {
1324         assembly {
1325             let fmem := mload(0x40)
1326             codecopy(fmem, codesize, sub(msize, fmem))
1327         }
1328     }
1329 }
1330 /*
1331 
1332 END ORACLIZE_API
1333 
1334 */
1335 
1336 
1337 
1338 contract Adminstrator {
1339   address public admin;
1340   address payable public owner;
1341 
1342   modifier onlyAdmin() { 
1343         require(msg.sender == admin || msg.sender == owner,"Not authorized"); 
1344         _;
1345   } 
1346 
1347   constructor() public {
1348     admin = msg.sender;
1349 	owner = msg.sender;
1350   }
1351 
1352   /*function transferAdmin(address newAdmin) public onlyAdmin {
1353     admin = newAdmin; 
1354   }*/
1355 }
1356 contract TokenERC20 {
1357 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
1358 	function burnFrom(address _from, uint256 _value) public returns (bool success);
1359 	mapping (address => mapping (address => uint256)) public allowance;
1360 	mapping (address => uint256) public balanceOf;
1361 }
1362 contract TokenSales is Adminstrator,usingOraclize {
1363 	uint public oneDayTime = 86400;
1364 	//GMT - 12, Make sure anywhere in the world is 16 Aug 2019
1365 	uint public deadline = 1565956800; //Unix time of 16 Aug 2019 00:00 GMT-12
1366 	//Web query related
1367 	string public addrWebsite="https://authpaper.io/getAddresses?eth=";
1368 	string public levelWebsite="https://authpaper.io/getLevels?eth=";
1369 	enum queryType{
1370 		checkLevels,
1371 		findParents
1372 	}
1373 	struct rewardNode{
1374 		address baseAddress;
1375 		uint purchasedETH;
1376 		uint receivedAUPC;
1377 		address lastParent;
1378 		uint levels;
1379 		queryType qtype;
1380 	}
1381 	struct tempLevel{
1382 		uint level;
1383 		uint timeStamp;
1384 	}
1385 	struct tempAddress{
1386 		address payable addr;
1387 		uint timeStamp;
1388 	}
1389 	mapping (bytes32 => rewardNode) public oraclizeCallbacks;
1390 	mapping (address => tempLevel) public savedLevels;
1391 	mapping (address => tempAddress) public savedParents;
1392 	
1393 	//Purchase and distribution related
1394 	address public tokenAddr = 0x500Df47E1dF0ef06039218dCF0960253D89D6658;
1395 	TokenERC20 public AUPC = TokenERC20(tokenAddr);
1396 	uint firstLevelAUPC=10;
1397 	uint firstLevelETH=5;
1398 	uint secondLevelAUPC=6;
1399 	uint secondLevelETH=3;
1400 	uint thirdLevelAUPC=4;
1401 	uint thirdLevelETH=2;
1402 	uint firstLevelDiscount=5;
1403 	uint secondLevelDiscount=3;
1404 	uint thirdLevelDiscount=2;
1405 	uint maxDiscount=15;
1406 	uint public basePrice = 1 finney;
1407 	uint public minPurchase = 100 finney;
1408 	event distributeETH(address indexed _to, address _from, uint _amount);
1409 	event distributeAUPC(address indexed _to, address _from, uint _amount);
1410 	event shouldBurn(address _from, uint _amount);
1411 	
1412 	//Statistic issue
1413 	uint256 public receivedAmount;
1414 	uint256 public sentAmount;
1415 	uint256 public sentAUPC;
1416 	bool public paused=false;
1417 	event Paused(address account);
1418 	event Unpaused(address account);
1419 	event makeQuery(address indexed account, string msg, string url);
1420 	event MasterWithdraw(uint amount);
1421 	mapping (address => uint) public gainedETH;
1422 	mapping (address => uint) public gainedAUPC;
1423 	mapping (address => uint) public payedAUPC;
1424 	mapping (address => uint) public payedETH;
1425 	mapping (address => uint) public payedETHSettled;
1426 	mapping (address => uint) public sentAwayETH;
1427 	mapping (address => uint) public sentAwayAUPC;
1428 	
1429 	//event DebugLog(address addr, string msg, uint amount);
1430 	
1431 	//Setting the variables
1432 	function setWebsite(string memory addr, string memory level) public onlyAdmin{
1433 		require(paused,"The contract is still running");
1434 		addrWebsite = addr;
1435 		levelWebsite = level;
1436 	}
1437 	function setPrice(uint newPrice, uint newMinPurchase) public onlyAdmin{
1438 		require(paused,"The contract is still running");
1439 		require(newPrice > 0, "new price must be positive");
1440 		require(newMinPurchase > 0, "new minipurchase must be positive");
1441 		require(newMinPurchase >= 10*newPrice, "minipurchase not 10 larger than price");
1442 		basePrice = newPrice * (10 ** uint256(15)); //In finney
1443 		minPurchase = newMinPurchase * (10 ** uint256(15)); //In finney
1444 	}
1445 	function pause(bool isPause) public onlyAdmin{
1446 		paused = isPause;
1447 		if(isPause) emit Paused(msg.sender);
1448 		else emit Unpaused(msg.sender);
1449 	}
1450 	function withdraw(uint amount) public onlyAdmin returns(bool) {
1451         require(amount < address(this).balance);
1452         owner.transfer(amount);
1453 		emit MasterWithdraw(amount);
1454         return true;
1455     }
1456     function withdrawAll() public onlyAdmin returns(bool) {
1457         uint balanceOld = address(this).balance;
1458         owner.transfer(balanceOld);
1459 		emit MasterWithdraw(balanceOld);
1460         return true;
1461     }
1462 	
1463 	function() external payable { 
1464 		require(msg.sender != address(0)); //Cannot buy AUPC by empty address
1465 		if(msg.sender == owner) return;
1466 		require(!paused,"The contract is paused");
1467 		require(address(this).balance + msg.value > address(this).balance); //prevent overflow
1468 		require(msg.value >= minPurchase, "Smaller than minimum amount");
1469 		if(now > deadline || AUPC.allowance(owner,address(this)) <=0){
1470 			paused = true;
1471 			//Token sales is over, or all coins are sold, it is time to burn the remaining tokens
1472 			emit shouldBurn(msg.sender, AUPC.allowance(owner,address(this)) );
1473 			//Send back the money
1474 			if(msg.value < address(this).balance)
1475 				msg.sender.transfer(msg.value);
1476 			//Problem: How to make sure all pending ETH and AUPC are sent out before burning all AUPC?
1477 			//AUPC.burnFrom(owner,AUPC.allowance(address(this)));
1478 			return;
1479 		}		
1480 		receivedAmount += msg.value;
1481 		payedETH[msg.sender] += msg.value;
1482 		//The discount info is queried in the previous one day.
1483 		if(savedLevels[msg.sender].timeStamp >0
1484 			&& savedLevels[msg.sender].timeStamp + oneDayTime >now){
1485 			require(purchaseAUPC(msg.sender, msg.value,savedLevels[msg.sender].level));
1486 			return;
1487 		}
1488 		//make query for levels
1489 		//Remember, each query may burn around 0.01 USD from the contract !!
1490 		string memory queryStr = strConcating(levelWebsite,addressToString(msg.sender));
1491 		emit makeQuery(msg.sender,"Oraclize level query sent",queryStr);
1492 		bytes32 queryId=oraclize_query("URL", queryStr, 600000);
1493         oraclizeCallbacks[queryId] = rewardNode(msg.sender,msg.value,0,address(0),0,queryType.checkLevels);
1494 	}
1495 	function __callback(bytes32 myid, string memory result) public {
1496         if (msg.sender != oraclize_cbAddress()) revert();
1497         rewardNode memory o = oraclizeCallbacks[myid];
1498         //emit DebugLog(o.baseAddress, result, o.purchasedETH);
1499         require(o.purchasedETH >0, "Duplicate request"); //Make sure the object exists.
1500 		if(o.qtype == queryType.checkLevels){
1501 			//Checking the number of levels for an address, notice that the AUPC is not sent out yet
1502 			uint levels = stringToUint(result);
1503 			savedLevels[o.baseAddress] = tempLevel(levels, now);
1504 			require(purchaseAUPC(o.baseAddress,o.purchasedETH,levels));
1505 		}
1506 		if(o.qtype == queryType.findParents){
1507 			address payable parentAddr = parseAddrFromStr(result);
1508 			savedParents[o.lastParent] = tempAddress(parentAddr, now);
1509 			require(sendUpline(o.baseAddress,o.purchasedETH,o.receivedAUPC,parentAddr,o.levels));
1510 		}
1511 		delete oraclizeCallbacks[myid];
1512     }
1513 	function purchaseAUPC(address buyer, uint amount, uint levels) internal returns (bool){
1514 		require(buyer != address(0)); //Cannot buy AUPC by empty address
1515 		require(buyer != owner); //Cannot buy AUPC by empty address
1516 		//Make sure the buyer has really pay that money.
1517 		require(payedETH[buyer] >= amount + payedETHSettled[buyer], "Too much ETH to settle");
1518 		require(amount >= minPurchase, "Smaller than minimum amount");
1519 		uint discount=0;
1520 		if(levels >0){
1521 			if(levels >0) discount += firstLevelDiscount;
1522 			if(levels >1) discount += secondLevelDiscount;
1523 			if(levels >2) discount += thirdLevelDiscount;
1524 			if(levels >3) discount += (levels -3);
1525 		}
1526 		if(discount > maxDiscount) discount = maxDiscount; //Make sure the discount is not too large
1527 		require((basePrice * (100 - discount)) > basePrice);
1528 		uint currentPrice = (basePrice * (100 - discount)) / 100;
1529 		require(currentPrice <= basePrice); //There should be discount
1530 		require(currentPrice > 0, "AUPC price becomes 0"); 
1531 		uint amountAUPC = amount * (10 ** uint256(18)) / currentPrice;
1532 		require(amountAUPC > 0, "No AUPC purchased");
1533 		//There should be a round down issue, correct to 18 significant figure only
1534 		require((amount * (10 ** uint256(18)) - (amountAUPC * currentPrice)) >=0);
1535 		
1536 		uint oldBalance = AUPC.allowance(owner,address(this));
1537 		require(AUPC.transferFrom(owner, buyer, amountAUPC)); //Pay out AUPC
1538 		//We have settled this amount of ETH to AUPC and sent out
1539 		payedETHSettled[buyer] += amount;
1540 		payedAUPC[buyer] += amountAUPC;
1541 		sentAUPC += amountAUPC;
1542 		emit distributeAUPC(buyer, owner, amountAUPC);
1543 		assert(oldBalance == (AUPC.allowance(owner,address(this)) + amountAUPC)); //It should never fail
1544 		
1545 		if(levels ==0) return true; //There is no upline
1546 		if(savedParents[buyer].timeStamp >0 
1547 			&& savedParents[buyer].timeStamp + oneDayTime >now){
1548 			require(sendUpline(buyer,amount,amountAUPC,savedParents[buyer].addr,1));
1549 		}else{
1550 			//make query for parent
1551 			string memory queryStr = strConcating(addrWebsite,addressToString(buyer));
1552 			emit makeQuery(msg.sender,"Check parent query sent",queryStr);
1553 			bytes32 queryId=oraclize_query("URL", queryStr, 600000);
1554 			oraclizeCallbacks[queryId] = rewardNode(buyer,amount,amountAUPC,buyer,1,queryType.findParents);
1555 		}
1556 		return true;
1557 	}
1558 	function sendUpline(address buyer,uint amount,uint amountAUPC, address payable dad, uint levels) internal returns (bool){
1559 		require(buyer != address(0)); //empty address cannot be a referrer or buyer
1560 		require(buyer != owner); //Cannot buy AUPC by empty address
1561 		require(dad != address(0)); //Cannot refer by empty address
1562 		if(dad == owner) return true; //The referrer is owner means there is no referral and it is the top already
1563 		require(levels >0);
1564 		if(levels > 3) return true; //Maximum distribute three levels
1565 		uint aupcRate = amountAUPC;
1566 		uint ethRate = amount;
1567 		if(levels ==1){
1568 			aupcRate = aupcRate * firstLevelAUPC;
1569 			ethRate = ethRate * firstLevelETH;
1570 		}else if(levels ==2){
1571 			aupcRate = aupcRate * secondLevelAUPC;
1572 			ethRate = ethRate * secondLevelETH;
1573 		}else if(levels ==3){
1574 			aupcRate = aupcRate * thirdLevelAUPC;
1575 			ethRate = ethRate * thirdLevelETH;
1576 		}else return true;			
1577 		
1578 		//require(aupcRate > amountAUPC);
1579 		//require(ethRate > amount);
1580 		require(aupcRate <= 10*amountAUPC); //We send out max 10%
1581 		require(ethRate <= 5*amount);
1582 		aupcRate = aupcRate / 100;
1583 		ethRate = ethRate / 100;
1584 		require(aupcRate > 0, "No AUPC send out");
1585 		require(ethRate > 0, "No ETH award send out");
1586 		require(ethRate < address(this).balance, "No ETH for award");
1587 		
1588 		uint oldBalance = AUPC.allowance(owner,address(this));
1589 		uint oldETHBalance = address(this).balance;
1590 		
1591 		if(AUPC.balanceOf(dad) >0){
1592     		require(AUPC.transferFrom(owner, dad, aupcRate)); //Pay out AUPC
1593     		dad.transfer(ethRate); //Pay out ETH
1594     		//We have settled this amount of ETH to AUPC and sent out
1595     		gainedETH[dad] += ethRate;
1596     		gainedAUPC[dad] += aupcRate;
1597     		sentAwayETH[buyer] += ethRate;
1598     		sentAwayAUPC[buyer] += aupcRate;
1599     		sentAUPC += aupcRate;
1600     		sentAmount += ethRate;
1601     		emit distributeAUPC(dad, owner, aupcRate);
1602     		emit distributeETH(dad, owner, ethRate);
1603     		assert(oldBalance == (AUPC.allowance(owner,address(this)) + aupcRate)); //It should never fail
1604     		assert(oldETHBalance == (address(this).balance + ethRate)); //It should never fail
1605 		}
1606 		
1607 		if(savedParents[dad].timeStamp >0 
1608 			&& savedParents[dad].timeStamp + oneDayTime >now){
1609 			require(sendUpline(buyer,amount,amountAUPC,savedParents[dad].addr,levels+1));
1610 		}else{
1611 			//make query for parent
1612 			string memory queryStr = strConcating(addrWebsite,addressToString(dad));
1613 			emit makeQuery(msg.sender,"Check parent query sent", queryStr);
1614 			bytes32 queryId=oraclize_query("URL", queryStr, 600000);
1615 			oraclizeCallbacks[queryId] = rewardNode(buyer,amount,amountAUPC,dad,levels+1,queryType.findParents);
1616 		}
1617 		return true;
1618 	}
1619 	function stringToUint(string memory s) internal pure returns (uint){
1620 		bytes memory b = bytes(s);
1621 		uint result = 0;
1622 		for(uint i=0;i < b.length; i++){
1623 		    uint digit = uint8(b[i]);
1624 			if(digit >=48 && digit<=57) result = (result * 10) + (digit - 48);
1625 		}
1626 		return result;
1627 	}
1628     function strConcating(string memory _a, string memory _b) internal pure returns (string memory){
1629         bytes memory _ba = bytes(_a);
1630         bytes memory _bb = bytes(_b);
1631         string memory ab = new string(_ba.length + _bb.length);
1632         bytes memory bab = bytes(ab);
1633         uint k = 0;
1634         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
1635         for (uint i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
1636         return string(bab);
1637     }
1638     function addressToString(address _addr) public pure returns(string memory) {
1639         bytes32 value = bytes32(uint256(_addr));
1640         bytes memory alphabet = "0123456789abcdef";    
1641         bytes memory str = new bytes(42);
1642         str[0] = '0';
1643         str[1] = 'x';
1644         for (uint i = 0; i < 20; i++) {
1645             str[2+i*2] = alphabet[uint8(value[i + 12] >> 4)];
1646             str[3+i*2] = alphabet[uint8(value[i + 12] & 0x0f)];
1647         }
1648         return string(str);
1649     }
1650     //Note: This function only works on addresses with lowercase charactors
1651     function parseAddrFromStr(string memory _a) internal pure returns (address payable){
1652          bytes memory tmp = bytes(_a);
1653          uint160 iaddr = 0;
1654          uint160 b1;
1655          uint160 b2;
1656          for (uint i=2; i<2+2*20; i+=2){
1657              iaddr *= 256;
1658              b1 = uint8(tmp[i]);
1659              b2 = uint8(tmp[i+1]);
1660              if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1661              else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1662              if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1663              else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1664              iaddr += (b1*16+b2);
1665          }
1666          return address(iaddr);
1667     }
1668 }