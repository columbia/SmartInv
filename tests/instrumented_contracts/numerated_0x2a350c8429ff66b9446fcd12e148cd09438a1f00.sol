1 pragma solidity 0.5.2;
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
23 
24 // Dummy contract only used to emit to end-user they are using wrong solc
25 contract solcChecker {
26 /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;
27 }
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
50 Begin solidity-cborutils
51 https://github.com/smartcontractkit/solidity-cborutils
52 MIT License
53 Copyright (c) 2018 SmartContract ChainLink, Ltd.
54 Permission is hereby granted, free of charge, to any person obtaining a copy
55 of this software and associated documentation files (the "Software"), to deal
56 in the Software without restriction, including without limitation the rights
57 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
58 copies of the Software, and to permit persons to whom the Software is
59 furnished to do so, subject to the following conditions:
60 The above copyright notice and this permission notice shall be included in all
61 copies or substantial portions of the Software.
62 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
63 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
64 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
65 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
66 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
67 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
68 SOFTWARE.
69 */
70 library Buffer {
71 
72     struct buffer {
73         bytes buf;
74         uint capacity;
75     }
76 
77     function init(buffer memory _buf, uint _capacity) internal pure {
78         uint capacity = _capacity;
79         if (capacity % 32 != 0) {
80             capacity += 32 - (capacity % 32);
81         }
82         _buf.capacity = capacity; // Allocate space for the buffer data
83         assembly {
84             let ptr := mload(0x40)
85             mstore(_buf, ptr)
86             mstore(ptr, 0)
87             mstore(0x40, add(ptr, capacity))
88         }
89     }
90 
91     function resize(buffer memory _buf, uint _capacity) private pure {
92         bytes memory oldbuf = _buf.buf;
93         init(_buf, _capacity);
94         append(_buf, oldbuf);
95     }
96 
97     function max(uint _a, uint _b) private pure returns (uint _max) {
98         if (_a > _b) {
99             return _a;
100         }
101         return _b;
102     }
103     /**
104       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
105       *      would exceed the capacity of the buffer.
106       * @param _buf The buffer to append to.
107       * @param _data The data to append.
108       * @return The original buffer.
109       *
110       */
111     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
112         if (_data.length + _buf.buf.length > _buf.capacity) {
113             resize(_buf, max(_buf.capacity, _data.length) * 2);
114         }
115         uint dest;
116         uint src;
117         uint len = _data.length;
118         assembly {
119             let bufptr := mload(_buf) // Memory address of the buffer data
120             let buflen := mload(bufptr) // Length of existing buffer data
121             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
122             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
123             src := add(_data, 32)
124         }
125         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
126             assembly {
127                 mstore(dest, mload(src))
128             }
129             dest += 32;
130             src += 32;
131         }
132         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
133         assembly {
134             let srcpart := and(mload(src), not(mask))
135             let destpart := and(mload(dest), mask)
136             mstore(dest, or(destpart, srcpart))
137         }
138         return _buf;
139     }
140     /**
141       *
142       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
143       * exceed the capacity of the buffer.
144       * @param _buf The buffer to append to.
145       * @param _data The data to append.
146       * @return The original buffer.
147       *
148       */
149     function append(buffer memory _buf, uint8 _data) internal pure {
150         if (_buf.buf.length + 1 > _buf.capacity) {
151             resize(_buf, _buf.capacity * 2);
152         }
153         assembly {
154             let bufptr := mload(_buf) // Memory address of the buffer data
155             let buflen := mload(bufptr) // Length of existing buffer data
156             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
157             mstore8(dest, _data)
158             mstore(bufptr, add(buflen, 1)) // Update buffer length
159         }
160     }
161     /**
162       *
163       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
164       * exceed the capacity of the buffer.
165       * @param _buf The buffer to append to.
166       * @param _data The data to append.
167       * @return The original buffer.
168       *
169       */
170     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
171         if (_len + _buf.buf.length > _buf.capacity) {
172             resize(_buf, max(_buf.capacity, _len) * 2);
173         }
174         uint mask = 256 ** _len - 1;
175         assembly {
176             let bufptr := mload(_buf) // Memory address of the buffer data
177             let buflen := mload(bufptr) // Length of existing buffer data
178             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
179             mstore(dest, or(and(mload(dest), not(mask)), _data))
180             mstore(bufptr, add(buflen, _len)) // Update buffer length
181         }
182         return _buf;
183     }
184 }
185 
186 library CBOR {
187 
188     using Buffer for Buffer.buffer;
189 
190     uint8 private constant MAJOR_TYPE_INT = 0;
191     uint8 private constant MAJOR_TYPE_MAP = 5;
192     uint8 private constant MAJOR_TYPE_BYTES = 2;
193     uint8 private constant MAJOR_TYPE_ARRAY = 4;
194     uint8 private constant MAJOR_TYPE_STRING = 3;
195     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
196     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
197 
198     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
199         if (_value <= 23) {
200             _buf.append(uint8((_major << 5) | _value));
201         } else if (_value <= 0xFF) {
202             _buf.append(uint8((_major << 5) | 24));
203             _buf.appendInt(_value, 1);
204         } else if (_value <= 0xFFFF) {
205             _buf.append(uint8((_major << 5) | 25));
206             _buf.appendInt(_value, 2);
207         } else if (_value <= 0xFFFFFFFF) {
208             _buf.append(uint8((_major << 5) | 26));
209             _buf.appendInt(_value, 4);
210         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
211             _buf.append(uint8((_major << 5) | 27));
212             _buf.appendInt(_value, 8);
213         }
214     }
215 
216     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
217         _buf.append(uint8((_major << 5) | 31));
218     }
219 
220     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
221         encodeType(_buf, MAJOR_TYPE_INT, _value);
222     }
223 
224     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
225         if (_value >= 0) {
226             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
227         } else {
228             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
229         }
230     }
231 
232     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
233         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
234         _buf.append(_value);
235     }
236 
237     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
238         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
239         _buf.append(bytes(_value));
240     }
241 
242     function startArray(Buffer.buffer memory _buf) internal pure {
243         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
244     }
245 
246     function startMap(Buffer.buffer memory _buf) internal pure {
247         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
248     }
249 
250     function endSequence(Buffer.buffer memory _buf) internal pure {
251         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
252     }
253 }
254 /*
255 End solidity-cborutils
256 */
257 contract usingOraclize {
258 
259     using CBOR for Buffer.buffer;
260 
261     OraclizeI oraclize;
262     OraclizeAddrResolverI OAR;
263 
264     uint constant day = 60 * 60 * 24;
265     uint constant week = 60 * 60 * 24 * 7;
266     uint constant month = 60 * 60 * 24 * 30;
267 
268     byte constant proofType_NONE = 0x00;
269     byte constant proofType_Ledger = 0x30;
270     byte constant proofType_Native = 0xF0;
271     byte constant proofStorage_IPFS = 0x01;
272     byte constant proofType_Android = 0x40;
273     byte constant proofType_TLSNotary = 0x10;
274 
275     string oraclize_network_name;
276     uint8 constant networkID_auto = 0;
277     uint8 constant networkID_morden = 2;
278     uint8 constant networkID_mainnet = 1;
279     uint8 constant networkID_testnet = 2;
280     uint8 constant networkID_consensys = 161;
281 
282     mapping(bytes32 => bytes32) oraclize_randomDS_args;
283     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
284 
285     modifier oraclizeAPI {
286         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
287             oraclize_setNetwork(networkID_auto);
288         }
289         if (address(oraclize) != OAR.getAddress()) {
290             oraclize = OraclizeI(OAR.getAddress());
291         }
292         _;
293     }
294 
295     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
296         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
297         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
298         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
299         require(proofVerified);
300         _;
301     }
302 
303     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
304       return oraclize_setNetwork();
305       _networkID; // silence the warning and remain backwards compatible
306     }
307 
308     function oraclize_setNetworkName(string memory _network_name) internal {
309         oraclize_network_name = _network_name;
310     }
311 
312     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
313         return oraclize_network_name;
314     }
315 
316     function oraclize_setNetwork() internal returns (bool _networkSet) {
317         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
318             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
319             oraclize_setNetworkName("eth_mainnet");
320             return true;
321         }
322         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
323             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
324             oraclize_setNetworkName("eth_ropsten3");
325             return true;
326         }
327         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
328             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
329             oraclize_setNetworkName("eth_kovan");
330             return true;
331         }
332         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
333             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
334             oraclize_setNetworkName("eth_rinkeby");
335             return true;
336         }
337         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
338             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
339             return true;
340         }
341         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
342             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
343             return true;
344         }
345         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
346             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
347             return true;
348         }
349         return false;
350     }
351 
352     function __callback(bytes32 _myid, string memory _result) public {
353         __callback(_myid, _result, new bytes(0));
354     }
355 
356     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
357       return;
358       _myid; _result; _proof; // Silence compiler warnings
359     }
360 
361     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
362         return oraclize.getPrice(_datasource);
363     }
364 
365     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
366         return oraclize.getPrice(_datasource, _gasLimit);
367     }
368 
369     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
370         uint price = oraclize.getPrice(_datasource);
371         if (price > 1 ether + tx.gasprice * 200000) {
372             return 0; // Unexpectedly high price
373         }
374         return oraclize.query.value(price)(0, _datasource, _arg);
375     }
376 
377     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
378         uint price = oraclize.getPrice(_datasource);
379         if (price > 1 ether + tx.gasprice * 200000) {
380             return 0; // Unexpectedly high price
381         }
382         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
383     }
384 
385     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
386         uint price = oraclize.getPrice(_datasource,_gasLimit);
387         if (price > 1 ether + tx.gasprice * _gasLimit) {
388             return 0; // Unexpectedly high price
389         }
390         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
391     }
392 
393     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
394         uint price = oraclize.getPrice(_datasource, _gasLimit);
395         if (price > 1 ether + tx.gasprice * _gasLimit) {
396            return 0; // Unexpectedly high price
397         }
398         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
399     }
400 
401     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
402         uint price = oraclize.getPrice(_datasource);
403         if (price > 1 ether + tx.gasprice * 200000) {
404             return 0; // Unexpectedly high price
405         }
406         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
407     }
408 
409     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
410         uint price = oraclize.getPrice(_datasource);
411         if (price > 1 ether + tx.gasprice * 200000) {
412             return 0; // Unexpectedly high price
413         }
414         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
415     }
416 
417     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
418         uint price = oraclize.getPrice(_datasource, _gasLimit);
419         if (price > 1 ether + tx.gasprice * _gasLimit) {
420             return 0; // Unexpectedly high price
421         }
422         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
423     }
424 
425     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
426         uint price = oraclize.getPrice(_datasource, _gasLimit);
427         if (price > 1 ether + tx.gasprice * _gasLimit) {
428             return 0; // Unexpectedly high price
429         }
430         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
431     }
432 
433     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
434         uint price = oraclize.getPrice(_datasource);
435         if (price > 1 ether + tx.gasprice * 200000) {
436             return 0; // Unexpectedly high price
437         }
438         bytes memory args = stra2cbor(_argN);
439         return oraclize.queryN.value(price)(0, _datasource, args);
440     }
441 
442     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
443         uint price = oraclize.getPrice(_datasource);
444         if (price > 1 ether + tx.gasprice * 200000) {
445             return 0; // Unexpectedly high price
446         }
447         bytes memory args = stra2cbor(_argN);
448         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
449     }
450 
451     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
452         uint price = oraclize.getPrice(_datasource, _gasLimit);
453         if (price > 1 ether + tx.gasprice * _gasLimit) {
454             return 0; // Unexpectedly high price
455         }
456         bytes memory args = stra2cbor(_argN);
457         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
458     }
459 
460     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
461         uint price = oraclize.getPrice(_datasource, _gasLimit);
462         if (price > 1 ether + tx.gasprice * _gasLimit) {
463             return 0; // Unexpectedly high price
464         }
465         bytes memory args = stra2cbor(_argN);
466         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
467     }
468 
469     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
470         string[] memory dynargs = new string[](1);
471         dynargs[0] = _args[0];
472         return oraclize_query(_datasource, dynargs);
473     }
474 
475     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
476         string[] memory dynargs = new string[](1);
477         dynargs[0] = _args[0];
478         return oraclize_query(_timestamp, _datasource, dynargs);
479     }
480 
481     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
482         string[] memory dynargs = new string[](1);
483         dynargs[0] = _args[0];
484         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
485     }
486 
487     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
488         string[] memory dynargs = new string[](1);
489         dynargs[0] = _args[0];
490         return oraclize_query(_datasource, dynargs, _gasLimit);
491     }
492 
493     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
494         string[] memory dynargs = new string[](2);
495         dynargs[0] = _args[0];
496         dynargs[1] = _args[1];
497         return oraclize_query(_datasource, dynargs);
498     }
499 
500     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
501         string[] memory dynargs = new string[](2);
502         dynargs[0] = _args[0];
503         dynargs[1] = _args[1];
504         return oraclize_query(_timestamp, _datasource, dynargs);
505     }
506 
507     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
508         string[] memory dynargs = new string[](2);
509         dynargs[0] = _args[0];
510         dynargs[1] = _args[1];
511         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
512     }
513 
514     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
515         string[] memory dynargs = new string[](2);
516         dynargs[0] = _args[0];
517         dynargs[1] = _args[1];
518         return oraclize_query(_datasource, dynargs, _gasLimit);
519     }
520 
521     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
522         string[] memory dynargs = new string[](3);
523         dynargs[0] = _args[0];
524         dynargs[1] = _args[1];
525         dynargs[2] = _args[2];
526         return oraclize_query(_datasource, dynargs);
527     }
528 
529     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
530         string[] memory dynargs = new string[](3);
531         dynargs[0] = _args[0];
532         dynargs[1] = _args[1];
533         dynargs[2] = _args[2];
534         return oraclize_query(_timestamp, _datasource, dynargs);
535     }
536 
537     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
538         string[] memory dynargs = new string[](3);
539         dynargs[0] = _args[0];
540         dynargs[1] = _args[1];
541         dynargs[2] = _args[2];
542         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
543     }
544 
545     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
546         string[] memory dynargs = new string[](3);
547         dynargs[0] = _args[0];
548         dynargs[1] = _args[1];
549         dynargs[2] = _args[2];
550         return oraclize_query(_datasource, dynargs, _gasLimit);
551     }
552 
553     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
554         string[] memory dynargs = new string[](4);
555         dynargs[0] = _args[0];
556         dynargs[1] = _args[1];
557         dynargs[2] = _args[2];
558         dynargs[3] = _args[3];
559         return oraclize_query(_datasource, dynargs);
560     }
561 
562     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
563         string[] memory dynargs = new string[](4);
564         dynargs[0] = _args[0];
565         dynargs[1] = _args[1];
566         dynargs[2] = _args[2];
567         dynargs[3] = _args[3];
568         return oraclize_query(_timestamp, _datasource, dynargs);
569     }
570 
571     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
572         string[] memory dynargs = new string[](4);
573         dynargs[0] = _args[0];
574         dynargs[1] = _args[1];
575         dynargs[2] = _args[2];
576         dynargs[3] = _args[3];
577         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
578     }
579 
580     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
581         string[] memory dynargs = new string[](4);
582         dynargs[0] = _args[0];
583         dynargs[1] = _args[1];
584         dynargs[2] = _args[2];
585         dynargs[3] = _args[3];
586         return oraclize_query(_datasource, dynargs, _gasLimit);
587     }
588 
589     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
590         string[] memory dynargs = new string[](5);
591         dynargs[0] = _args[0];
592         dynargs[1] = _args[1];
593         dynargs[2] = _args[2];
594         dynargs[3] = _args[3];
595         dynargs[4] = _args[4];
596         return oraclize_query(_datasource, dynargs);
597     }
598 
599     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
600         string[] memory dynargs = new string[](5);
601         dynargs[0] = _args[0];
602         dynargs[1] = _args[1];
603         dynargs[2] = _args[2];
604         dynargs[3] = _args[3];
605         dynargs[4] = _args[4];
606         return oraclize_query(_timestamp, _datasource, dynargs);
607     }
608 
609     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
610         string[] memory dynargs = new string[](5);
611         dynargs[0] = _args[0];
612         dynargs[1] = _args[1];
613         dynargs[2] = _args[2];
614         dynargs[3] = _args[3];
615         dynargs[4] = _args[4];
616         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
617     }
618 
619     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
620         string[] memory dynargs = new string[](5);
621         dynargs[0] = _args[0];
622         dynargs[1] = _args[1];
623         dynargs[2] = _args[2];
624         dynargs[3] = _args[3];
625         dynargs[4] = _args[4];
626         return oraclize_query(_datasource, dynargs, _gasLimit);
627     }
628 
629     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
630         uint price = oraclize.getPrice(_datasource);
631         if (price > 1 ether + tx.gasprice * 200000) {
632             return 0; // Unexpectedly high price
633         }
634         bytes memory args = ba2cbor(_argN);
635         return oraclize.queryN.value(price)(0, _datasource, args);
636     }
637 
638     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
639         uint price = oraclize.getPrice(_datasource);
640         if (price > 1 ether + tx.gasprice * 200000) {
641             return 0; // Unexpectedly high price
642         }
643         bytes memory args = ba2cbor(_argN);
644         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
645     }
646 
647     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
648         uint price = oraclize.getPrice(_datasource, _gasLimit);
649         if (price > 1 ether + tx.gasprice * _gasLimit) {
650             return 0; // Unexpectedly high price
651         }
652         bytes memory args = ba2cbor(_argN);
653         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
654     }
655 
656     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
657         uint price = oraclize.getPrice(_datasource, _gasLimit);
658         if (price > 1 ether + tx.gasprice * _gasLimit) {
659             return 0; // Unexpectedly high price
660         }
661         bytes memory args = ba2cbor(_argN);
662         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
663     }
664 
665     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
666         bytes[] memory dynargs = new bytes[](1);
667         dynargs[0] = _args[0];
668         return oraclize_query(_datasource, dynargs);
669     }
670 
671     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
672         bytes[] memory dynargs = new bytes[](1);
673         dynargs[0] = _args[0];
674         return oraclize_query(_timestamp, _datasource, dynargs);
675     }
676 
677     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
678         bytes[] memory dynargs = new bytes[](1);
679         dynargs[0] = _args[0];
680         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
681     }
682 
683     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
684         bytes[] memory dynargs = new bytes[](1);
685         dynargs[0] = _args[0];
686         return oraclize_query(_datasource, dynargs, _gasLimit);
687     }
688 
689     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
690         bytes[] memory dynargs = new bytes[](2);
691         dynargs[0] = _args[0];
692         dynargs[1] = _args[1];
693         return oraclize_query(_datasource, dynargs);
694     }
695 
696     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
697         bytes[] memory dynargs = new bytes[](2);
698         dynargs[0] = _args[0];
699         dynargs[1] = _args[1];
700         return oraclize_query(_timestamp, _datasource, dynargs);
701     }
702 
703     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
704         bytes[] memory dynargs = new bytes[](2);
705         dynargs[0] = _args[0];
706         dynargs[1] = _args[1];
707         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
708     }
709 
710     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
711         bytes[] memory dynargs = new bytes[](2);
712         dynargs[0] = _args[0];
713         dynargs[1] = _args[1];
714         return oraclize_query(_datasource, dynargs, _gasLimit);
715     }
716 
717     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
718         bytes[] memory dynargs = new bytes[](3);
719         dynargs[0] = _args[0];
720         dynargs[1] = _args[1];
721         dynargs[2] = _args[2];
722         return oraclize_query(_datasource, dynargs);
723     }
724 
725     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
726         bytes[] memory dynargs = new bytes[](3);
727         dynargs[0] = _args[0];
728         dynargs[1] = _args[1];
729         dynargs[2] = _args[2];
730         return oraclize_query(_timestamp, _datasource, dynargs);
731     }
732 
733     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
734         bytes[] memory dynargs = new bytes[](3);
735         dynargs[0] = _args[0];
736         dynargs[1] = _args[1];
737         dynargs[2] = _args[2];
738         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
739     }
740 
741     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
742         bytes[] memory dynargs = new bytes[](3);
743         dynargs[0] = _args[0];
744         dynargs[1] = _args[1];
745         dynargs[2] = _args[2];
746         return oraclize_query(_datasource, dynargs, _gasLimit);
747     }
748 
749     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
750         bytes[] memory dynargs = new bytes[](4);
751         dynargs[0] = _args[0];
752         dynargs[1] = _args[1];
753         dynargs[2] = _args[2];
754         dynargs[3] = _args[3];
755         return oraclize_query(_datasource, dynargs);
756     }
757 
758     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
759         bytes[] memory dynargs = new bytes[](4);
760         dynargs[0] = _args[0];
761         dynargs[1] = _args[1];
762         dynargs[2] = _args[2];
763         dynargs[3] = _args[3];
764         return oraclize_query(_timestamp, _datasource, dynargs);
765     }
766 
767     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
768         bytes[] memory dynargs = new bytes[](4);
769         dynargs[0] = _args[0];
770         dynargs[1] = _args[1];
771         dynargs[2] = _args[2];
772         dynargs[3] = _args[3];
773         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
774     }
775 
776     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
777         bytes[] memory dynargs = new bytes[](4);
778         dynargs[0] = _args[0];
779         dynargs[1] = _args[1];
780         dynargs[2] = _args[2];
781         dynargs[3] = _args[3];
782         return oraclize_query(_datasource, dynargs, _gasLimit);
783     }
784 
785     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
786         bytes[] memory dynargs = new bytes[](5);
787         dynargs[0] = _args[0];
788         dynargs[1] = _args[1];
789         dynargs[2] = _args[2];
790         dynargs[3] = _args[3];
791         dynargs[4] = _args[4];
792         return oraclize_query(_datasource, dynargs);
793     }
794 
795     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
796         bytes[] memory dynargs = new bytes[](5);
797         dynargs[0] = _args[0];
798         dynargs[1] = _args[1];
799         dynargs[2] = _args[2];
800         dynargs[3] = _args[3];
801         dynargs[4] = _args[4];
802         return oraclize_query(_timestamp, _datasource, dynargs);
803     }
804 
805     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
806         bytes[] memory dynargs = new bytes[](5);
807         dynargs[0] = _args[0];
808         dynargs[1] = _args[1];
809         dynargs[2] = _args[2];
810         dynargs[3] = _args[3];
811         dynargs[4] = _args[4];
812         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
813     }
814 
815     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
816         bytes[] memory dynargs = new bytes[](5);
817         dynargs[0] = _args[0];
818         dynargs[1] = _args[1];
819         dynargs[2] = _args[2];
820         dynargs[3] = _args[3];
821         dynargs[4] = _args[4];
822         return oraclize_query(_datasource, dynargs, _gasLimit);
823     }
824 
825     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
826         return oraclize.setProofType(_proofP);
827     }
828 
829 
830     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
831         return oraclize.cbAddress();
832     }
833 
834     function getCodeSize(address _addr) view internal returns (uint _size) {
835         assembly {
836             _size := extcodesize(_addr)
837         }
838     }
839 
840     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
841         return oraclize.setCustomGasPrice(_gasPrice);
842     }
843 
844     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
845         return oraclize.randomDS_getSessionPubKeyHash();
846     }
847 
848     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
849         bytes memory tmp = bytes(_a);
850         uint160 iaddr = 0;
851         uint160 b1;
852         uint160 b2;
853         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
854             iaddr *= 256;
855             b1 = uint160(uint8(tmp[i]));
856             b2 = uint160(uint8(tmp[i + 1]));
857             if ((b1 >= 97) && (b1 <= 102)) {
858                 b1 -= 87;
859             } else if ((b1 >= 65) && (b1 <= 70)) {
860                 b1 -= 55;
861             } else if ((b1 >= 48) && (b1 <= 57)) {
862                 b1 -= 48;
863             }
864             if ((b2 >= 97) && (b2 <= 102)) {
865                 b2 -= 87;
866             } else if ((b2 >= 65) && (b2 <= 70)) {
867                 b2 -= 55;
868             } else if ((b2 >= 48) && (b2 <= 57)) {
869                 b2 -= 48;
870             }
871             iaddr += (b1 * 16 + b2);
872         }
873         return address(iaddr);
874     }
875 
876     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
877         bytes memory a = bytes(_a);
878         bytes memory b = bytes(_b);
879         uint minLength = a.length;
880         if (b.length < minLength) {
881             minLength = b.length;
882         }
883         for (uint i = 0; i < minLength; i ++) {
884             if (a[i] < b[i]) {
885                 return -1;
886             } else if (a[i] > b[i]) {
887                 return 1;
888             }
889         }
890         if (a.length < b.length) {
891             return -1;
892         } else if (a.length > b.length) {
893             return 1;
894         } else {
895             return 0;
896         }
897     }
898 
899     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
900         bytes memory h = bytes(_haystack);
901         bytes memory n = bytes(_needle);
902         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
903             return -1;
904         } else if (h.length > (2 ** 128 - 1)) {
905             return -1;
906         } else {
907             uint subindex = 0;
908             for (uint i = 0; i < h.length; i++) {
909                 if (h[i] == n[0]) {
910                     subindex = 1;
911                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
912                         subindex++;
913                     }
914                     if (subindex == n.length) {
915                         return int(i);
916                     }
917                 }
918             }
919             return -1;
920         }
921     }
922 
923     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
924         return strConcat(_a, _b, "", "", "");
925     }
926 
927     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
928         return strConcat(_a, _b, _c, "", "");
929     }
930 
931     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
932         return strConcat(_a, _b, _c, _d, "");
933     }
934 
935     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
936         bytes memory _ba = bytes(_a);
937         bytes memory _bb = bytes(_b);
938         bytes memory _bc = bytes(_c);
939         bytes memory _bd = bytes(_d);
940         bytes memory _be = bytes(_e);
941         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
942         bytes memory babcde = bytes(abcde);
943         uint k = 0;
944         uint i = 0;
945         for (i = 0; i < _ba.length; i++) {
946             babcde[k++] = _ba[i];
947         }
948         for (i = 0; i < _bb.length; i++) {
949             babcde[k++] = _bb[i];
950         }
951         for (i = 0; i < _bc.length; i++) {
952             babcde[k++] = _bc[i];
953         }
954         for (i = 0; i < _bd.length; i++) {
955             babcde[k++] = _bd[i];
956         }
957         for (i = 0; i < _be.length; i++) {
958             babcde[k++] = _be[i];
959         }
960         return string(babcde);
961     }
962 
963     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
964         return safeParseInt(_a, 0);
965     }
966 
967     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
968         bytes memory bresult = bytes(_a);
969         uint mint = 0;
970         bool decimals = false;
971         for (uint i = 0; i < bresult.length; i++) {
972             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
973                 if (decimals) {
974                    if (_b == 0) break;
975                     else _b--;
976                 }
977                 mint *= 10;
978                 mint += uint(uint8(bresult[i])) - 48;
979             } else if (uint(uint8(bresult[i])) == 46) {
980                 require(!decimals, 'More than one decimal encountered in string!');
981                 decimals = true;
982             } else {
983                 revert("Non-numeral character encountered in string!");
984             }
985         }
986         if (_b > 0) {
987             mint *= 10 ** _b;
988         }
989         return mint;
990     }
991 
992     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
993         return parseInt(_a, 0);
994     }
995 
996     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
997         bytes memory bresult = bytes(_a);
998         uint mint = 0;
999         bool decimals = false;
1000         for (uint i = 0; i < bresult.length; i++) {
1001             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1002                 if (decimals) {
1003                    if (_b == 0) {
1004                        break;
1005                    } else {
1006                        _b--;
1007                    }
1008                 }
1009                 mint *= 10;
1010                 mint += uint(uint8(bresult[i])) - 48;
1011             } else if (uint(uint8(bresult[i])) == 46) {
1012                 decimals = true;
1013             }
1014         }
1015         if (_b > 0) {
1016             mint *= 10 ** _b;
1017         }
1018         return mint;
1019     }
1020 
1021     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1022         if (_i == 0) {
1023             return "0";
1024         }
1025         uint j = _i;
1026         uint len;
1027         while (j != 0) {
1028             len++;
1029             j /= 10;
1030         }
1031         bytes memory bstr = new bytes(len);
1032         uint k = len - 1;
1033         while (_i != 0) {
1034             bstr[k--] = byte(uint8(48 + _i % 10));
1035             _i /= 10;
1036         }
1037         return string(bstr);
1038     }
1039 
1040     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1041         safeMemoryCleaner();
1042         Buffer.buffer memory buf;
1043         Buffer.init(buf, 1024);
1044         buf.startArray();
1045         for (uint i = 0; i < _arr.length; i++) {
1046             buf.encodeString(_arr[i]);
1047         }
1048         buf.endSequence();
1049         return buf.buf;
1050     }
1051 
1052     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1053         safeMemoryCleaner();
1054         Buffer.buffer memory buf;
1055         Buffer.init(buf, 1024);
1056         buf.startArray();
1057         for (uint i = 0; i < _arr.length; i++) {
1058             buf.encodeBytes(_arr[i]);
1059         }
1060         buf.endSequence();
1061         return buf.buf;
1062     }
1063 
1064     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1065         require((_nbytes > 0) && (_nbytes <= 32));
1066         _delay *= 10; // Convert from seconds to ledger timer ticks
1067         bytes memory nbytes = new bytes(1);
1068         nbytes[0] = byte(uint8(_nbytes));
1069         bytes memory unonce = new bytes(32);
1070         bytes memory sessionKeyHash = new bytes(32);
1071         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1072         assembly {
1073             mstore(unonce, 0x20)
1074             /*
1075              The following variables can be relaxed.
1076              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1077              for an idea on how to override and replace commit hash variables.
1078             */
1079             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1080             mstore(sessionKeyHash, 0x20)
1081             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1082         }
1083         bytes memory delay = new bytes(32);
1084         assembly {
1085             mstore(add(delay, 0x20), _delay)
1086         }
1087         bytes memory delay_bytes8 = new bytes(8);
1088         copyBytes(delay, 24, 8, delay_bytes8, 0);
1089         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1090         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1091         bytes memory delay_bytes8_left = new bytes(8);
1092         assembly {
1093             let x := mload(add(delay_bytes8, 0x20))
1094             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1095             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1096             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1097             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1098             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1099             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1100             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1101             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1102         }
1103         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1104         return queryId;
1105     }
1106 
1107     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1108         oraclize_randomDS_args[_queryId] = _commitment;
1109     }
1110 
1111     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1112         bool sigok;
1113         address signer;
1114         bytes32 sigr;
1115         bytes32 sigs;
1116         bytes memory sigr_ = new bytes(32);
1117         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1118         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1119         bytes memory sigs_ = new bytes(32);
1120         offset += 32 + 2;
1121         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1122         assembly {
1123             sigr := mload(add(sigr_, 32))
1124             sigs := mload(add(sigs_, 32))
1125         }
1126         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1127         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1128             return true;
1129         } else {
1130             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1131             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1132         }
1133     }
1134 
1135     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1136         bool sigok;
1137         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1138         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1139         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1140         bytes memory appkey1_pubkey = new bytes(64);
1141         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1142         bytes memory tosign2 = new bytes(1 + 65 + 32);
1143         tosign2[0] = byte(uint8(1)); //role
1144         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1145         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1146         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1147         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1148         if (!sigok) {
1149             return false;
1150         }
1151         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1152         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1153         bytes memory tosign3 = new bytes(1 + 65);
1154         tosign3[0] = 0xFE;
1155         copyBytes(_proof, 3, 65, tosign3, 1);
1156         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1157         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1158         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1159         return sigok;
1160     }
1161 
1162     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1163         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1164         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1165             return 1;
1166         }
1167         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1168         if (!proofVerified) {
1169             return 2;
1170         }
1171         return 0;
1172     }
1173 
1174     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1175         bool match_ = true;
1176         require(_prefix.length == _nRandomBytes);
1177         for (uint256 i = 0; i< _nRandomBytes; i++) {
1178             if (_content[i] != _prefix[i]) {
1179                 match_ = false;
1180             }
1181         }
1182         return match_;
1183     }
1184 
1185     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1186         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1187         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1188         bytes memory keyhash = new bytes(32);
1189         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1190         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1191             return false;
1192         }
1193         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1194         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1195         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1196         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1197             return false;
1198         }
1199         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1200         // This is to verify that the computed args match with the ones specified in the query.
1201         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1202         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1203         bytes memory sessionPubkey = new bytes(64);
1204         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1205         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1206         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1207         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1208             delete oraclize_randomDS_args[_queryId];
1209         } else return false;
1210         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1211         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1212         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1213         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1214             return false;
1215         }
1216         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1217         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1218             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1219         }
1220         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1221     }
1222     /*
1223      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1224     */
1225     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1226         uint minLength = _length + _toOffset;
1227         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1228         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1229         uint j = 32 + _toOffset;
1230         while (i < (32 + _fromOffset + _length)) {
1231             assembly {
1232                 let tmp := mload(add(_from, i))
1233                 mstore(add(_to, j), tmp)
1234             }
1235             i += 32;
1236             j += 32;
1237         }
1238         return _to;
1239     }
1240     /*
1241      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1242      Duplicate Solidity's ecrecover, but catching the CALL return value
1243     */
1244     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1245         /*
1246          We do our own memory management here. Solidity uses memory offset
1247          0x40 to store the current end of memory. We write past it (as
1248          writes are memory extensions), but don't update the offset so
1249          Solidity will reuse it. The memory used here is only needed for
1250          this context.
1251          FIXME: inline assembly can't access return values
1252         */
1253         bool ret;
1254         address addr;
1255         assembly {
1256             let size := mload(0x40)
1257             mstore(size, _hash)
1258             mstore(add(size, 32), _v)
1259             mstore(add(size, 64), _r)
1260             mstore(add(size, 96), _s)
1261             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1262             addr := mload(size)
1263         }
1264         return (ret, addr);
1265     }
1266     /*
1267      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1268     */
1269     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1270         bytes32 r;
1271         bytes32 s;
1272         uint8 v;
1273         if (_sig.length != 65) {
1274             return (false, address(0));
1275         }
1276         /*
1277          The signature format is a compact form of:
1278            {bytes32 r}{bytes32 s}{uint8 v}
1279          Compact means, uint8 is not padded to 32 bytes.
1280         */
1281         assembly {
1282             r := mload(add(_sig, 32))
1283             s := mload(add(_sig, 64))
1284             /*
1285              Here we are loading the last 32 bytes. We exploit the fact that
1286              'mload' will pad with zeroes if we overread.
1287              There is no 'mload8' to do this, but that would be nicer.
1288             */
1289             v := byte(0, mload(add(_sig, 96)))
1290             /*
1291               Alternative solution:
1292               'byte' is not working due to the Solidity parser, so lets
1293               use the second best option, 'and'
1294               v := and(mload(add(_sig, 65)), 255)
1295             */
1296         }
1297         /*
1298          albeit non-transactional signatures are not specified by the YP, one would expect it
1299          to match the YP range of [27, 28]
1300          geth uses [0, 1] and some clients have followed. This might change, see:
1301          https://github.com/ethereum/go-ethereum/issues/2053
1302         */
1303         if (v < 27) {
1304             v += 27;
1305         }
1306         if (v != 27 && v != 28) {
1307             return (false, address(0));
1308         }
1309         return safer_ecrecover(_hash, v, r, s);
1310     }
1311 
1312     function safeMemoryCleaner() internal pure {
1313         assembly {
1314             let fmem := mload(0x40)
1315             codecopy(fmem, codesize, sub(msize, fmem))
1316         }
1317     }
1318 }
1319 /*
1320 END ORACLIZE_API
1321 */
1322 
1323 
1324 contract Ownable {
1325     address public owner;
1326     address public pendingOwner;
1327 
1328     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1329 
1330     /**
1331     * @dev Throws if called by any account other than the owner.
1332     */
1333     modifier onlyOwner() {
1334         require(msg.sender == owner);
1335         _;
1336     }
1337 
1338     /**
1339      * @dev Modifier throws if called by any account other than the pendingOwner.
1340      */
1341     modifier onlyPendingOwner() {
1342         require(msg.sender == pendingOwner);
1343         _;
1344     }
1345 
1346     constructor() public {
1347         owner = msg.sender;
1348     }
1349 
1350     /**
1351      * @dev Allows the current owner to set the pendingOwner address.
1352      * @param newOwner The address to transfer ownership to.
1353      */
1354     function transferOwnership(address newOwner) onlyOwner public {
1355         pendingOwner = newOwner;
1356     }
1357 
1358     /**
1359      * @dev Allows the pendingOwner address to finalize the transfer.
1360      */
1361     function claimOwnership() onlyPendingOwner public {
1362         emit OwnershipTransferred(owner, pendingOwner);
1363         owner = pendingOwner;
1364         pendingOwner = address(0);
1365     }
1366 }
1367 
1368 
1369 contract Manageable is Ownable {
1370     mapping(address => bool) public listOfManagers;
1371 
1372     modifier onlyManager() {
1373         require(listOfManagers[msg.sender], "");
1374         _;
1375     }
1376 
1377     function addManager(address _manager) public onlyOwner returns (bool success) {
1378         if (!listOfManagers[_manager]) {
1379             require(_manager != address(0), "");
1380             listOfManagers[_manager] = true;
1381             success = true;
1382         }
1383     }
1384 
1385     function removeManager(address _manager) public onlyOwner returns (bool success) {
1386         if (listOfManagers[_manager]) {
1387             listOfManagers[_manager] = false;
1388             success = true;
1389         }
1390     }
1391 
1392     function getInfo(address _manager) public view returns (bool) {
1393         return listOfManagers[_manager];
1394     }
1395 }
1396 
1397 
1398 /**
1399  * @title ERC20 interface
1400  * @dev see https://github.com/ethereum/EIPs/issues/20
1401  */
1402 interface IERC20 {
1403     function totalSupply() external view returns (uint256);
1404     function balanceOf(address who) external view returns (uint256);
1405     function allowance(address owner, address spender) external view returns (uint256);
1406     function transfer(address to, uint256 value) external returns (bool);
1407     function approve(address spender, uint256 value) external returns (bool);
1408     function transferFrom(address from, address to, uint256 value) external returns (bool);
1409     function mint(address to, uint256 value) external returns (bool);
1410     event Transfer(address indexed from, address indexed to, uint256 value);
1411     event Approval(address indexed owner, address indexed spender, uint256 value);
1412 }
1413 
1414 
1415 
1416 contract Sale is Ownable, usingOraclize {
1417     using SafeMath for uint256;
1418 
1419     string public url = "json(https://api.etherscan.io/api?module=stats&action=ethprice&apikey=91DFNHV3CJDJE12PG4DD66FUZEK71TC6NW).result.ethusd";
1420 
1421     IERC20 public token;
1422 
1423     address payable public wallet;
1424     uint256 public rate;
1425     uint256 public usdRaised;
1426 
1427     uint public lastCallbackTimestamp;
1428     uint public minTimeUpdate = 600; // 10 min in sec
1429 
1430     uint public gasLimit = 150000;
1431     uint public timeout = 86400; // 1 day in sec
1432 
1433     event NewOraclizeQuery(string description);
1434     event NewPrice(uint price);
1435     event CallbackIsFailed(address lottery, bytes32 queryId);
1436 
1437     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
1438 
1439     constructor(uint256 _rate, address payable _wallet, address _token) public {
1440         require(_rate != 0);
1441         require(_token != address(0));
1442         require(_wallet != address(0));
1443 
1444         rate = _rate;
1445         token = IERC20(_token);
1446         wallet = _wallet;
1447 
1448     }
1449 
1450     function () external payable {
1451         buyTokens(msg.sender);
1452     }
1453 
1454     function sendEth() public payable {
1455 
1456     }
1457 
1458     function buyTokens(address _beneficiary) public payable {
1459         uint256 weiAmount = msg.value;
1460         require(_beneficiary != address(0));
1461         require(weiAmount != 0);
1462 
1463         // calculate token amount to be created
1464         uint256 tokensAmount = checkTokensAmount(weiAmount);
1465 
1466         usdRaised = usdRaised.add(weiAmount.mul(rate).div(10**18));
1467 
1468         token.mint(_beneficiary, tokensAmount);
1469 
1470         wallet.transfer(msg.value);
1471         emit TokenPurchase(
1472             msg.sender,
1473             _beneficiary,
1474             weiAmount,
1475             tokensAmount
1476         );
1477     }
1478 
1479     function checkTokensAmount(uint _weiAmount) public view returns (uint) {
1480         return _weiAmount.mul(rate).div(100).mul(1000).div(getPrice()).div(10**18).mul(10**18);
1481     }
1482 
1483     /**
1484      * @dev Reclaim all ERC20Basic compatible tokens
1485      * @param _token ERC20B The address of the token contract
1486      */
1487     function reclaimToken(IERC20 _token) external onlyOwner {
1488         uint256 balance = _token.balanceOf(address(this));
1489         _token.transfer(owner, balance);
1490     }
1491 
1492     function __callback(bytes32 _queryId, string memory  _result) public {
1493         require(msg.sender == oraclize_cbAddress());
1494         require(now > lastCallbackTimestamp + minTimeUpdate);
1495         rate = parseInt(_result, 2);
1496         emit NewPrice(rate);
1497         lastCallbackTimestamp = now;
1498         update();
1499         _queryId;
1500     }
1501 
1502     function setUrl(string memory _url) public onlyOwner {
1503         url = _url;
1504     }
1505 
1506     function update() public payable {
1507         require(msg.sender == oraclize_cbAddress() || msg.sender == address(owner));
1508 
1509         if (oraclize_getPrice("URL", gasLimit) > address(this).balance) {
1510             emit NewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1511         } else {
1512             emit NewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1513             oraclize_query(
1514                 timeout,
1515                 "URL",
1516                 url,
1517                 gasLimit
1518             );
1519         }
1520     }
1521 
1522     function getPrice() public view returns (uint) {
1523         if (usdRaised >= 10000000000) return 1000;
1524         uint startPrice = 1;
1525         uint step = 10000000;
1526         return startPrice.add(usdRaised.div(step));
1527     }
1528 
1529     function withdrawETH(address payable _to, uint _amount) public onlyOwner {
1530         require(_to != address(0));
1531 
1532         address(_to).transfer(_amount);
1533     }
1534 
1535     function changeWallet(address payable _wallet) public onlyOwner {
1536         require(_wallet != address(0));
1537         wallet = _wallet;
1538     }
1539 
1540     function setTimeout(uint _timeout) public onlyOwner {
1541         timeout = _timeout;
1542     }
1543 
1544     function setGasLimit(uint _gasLimit) public onlyOwner {
1545         gasLimit = _gasLimit;
1546     }
1547 
1548 }
1549 
1550 /**
1551  * @title SafeMath
1552  * @dev Math operations with safety checks that throw on error
1553  */
1554 library SafeMath {
1555 
1556     /**
1557     * @dev Multiplies two numbers, throws on overflow.
1558     */
1559     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1560         if (a == 0) {
1561             return 0;
1562         }
1563         uint256 c = a * b;
1564         assert(c / a == b);
1565         return c;
1566     }
1567 
1568     /**
1569     * @dev Integer division of two numbers, truncating the quotient.
1570     */
1571     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1572         // assert(b > 0); // Solidity automatically throws when dividing by 0
1573         uint256 c = a / b;
1574         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1575         return c;
1576     }
1577 
1578     /**
1579     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1580     */
1581     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1582         assert(b <= a);
1583         return a - b;
1584     }
1585 
1586     /**
1587     * @dev Adds two numbers, throws on overflow.
1588     */
1589     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1590         uint256 c = a + b;
1591         assert(c >= a);
1592         return c;
1593     }
1594 }