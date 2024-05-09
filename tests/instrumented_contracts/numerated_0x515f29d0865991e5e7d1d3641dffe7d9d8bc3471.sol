1 // Dummy contract only used to emit to end-user they are using wrong solc
2 contract solcChecker {
3 /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;
4 }
5 
6 contract OraclizeI {
7 
8     address public cbAddress;
9 
10     function setProofType(byte _proofType) external;
11     function setCustomGasPrice(uint _gasPrice) external;
12     function getPrice(string memory _datasource) public returns (uint _dsprice);
13     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
14     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
15     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
16     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
17     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
18     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
19     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
20     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
21 }
22 
23 contract OraclizeAddrResolverI {
24     function getAddress() public returns (address _address);
25 }
26 /*
27 
28 Begin solidity-cborutils
29 
30 https://github.com/smartcontractkit/solidity-cborutils
31 
32 MIT License
33 
34 Copyright (c) 2018 SmartContract ChainLink, Ltd.
35 
36 Permission is hereby granted, free of charge, to any person obtaining a copy
37 of this software and associated documentation files (the "Software"), to deal
38 in the Software without restriction, including without limitation the rights
39 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
40 copies of the Software, and to permit persons to whom the Software is
41 furnished to do so, subject to the following conditions:
42 
43 The above copyright notice and this permission notice shall be included in all
44 copies or substantial portions of the Software.
45 
46 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
47 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
48 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
49 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
50 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
51 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
52 SOFTWARE.
53 
54 */
55 library Buffer {
56 
57     struct buffer {
58         bytes buf;
59         uint capacity;
60     }
61 
62     function init(buffer memory _buf, uint _capacity) internal pure {
63         uint capacity = _capacity;
64         if (capacity % 32 != 0) {
65             capacity += 32 - (capacity % 32);
66         }
67         _buf.capacity = capacity; // Allocate space for the buffer data
68         assembly {
69             let ptr := mload(0x40)
70             mstore(_buf, ptr)
71             mstore(ptr, 0)
72             mstore(0x40, add(ptr, capacity))
73         }
74     }
75 
76     function resize(buffer memory _buf, uint _capacity) private pure {
77         bytes memory oldbuf = _buf.buf;
78         init(_buf, _capacity);
79         append(_buf, oldbuf);
80     }
81 
82     function max(uint _a, uint _b) private pure returns (uint _max) {
83         if (_a > _b) {
84             return _a;
85         }
86         return _b;
87     }
88     /**
89       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
90       *      would exceed the capacity of the buffer.
91       * @param _buf The buffer to append to.
92       * @param _data The data to append.
93       * @return The original buffer.
94       *
95       */
96     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
97         if (_data.length + _buf.buf.length > _buf.capacity) {
98             resize(_buf, max(_buf.capacity, _data.length) * 2);
99         }
100         uint dest;
101         uint src;
102         uint len = _data.length;
103         assembly {
104             let bufptr := mload(_buf) // Memory address of the buffer data
105             let buflen := mload(bufptr) // Length of existing buffer data
106             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
107             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
108             src := add(_data, 32)
109         }
110         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
111             assembly {
112                 mstore(dest, mload(src))
113             }
114             dest += 32;
115             src += 32;
116         }
117         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
118         assembly {
119             let srcpart := and(mload(src), not(mask))
120             let destpart := and(mload(dest), mask)
121             mstore(dest, or(destpart, srcpart))
122         }
123         return _buf;
124     }
125     /**
126       *
127       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
128       * exceed the capacity of the buffer.
129       * @param _buf The buffer to append to.
130       * @param _data The data to append.
131       * @return The original buffer.
132       *
133       */
134     function append(buffer memory _buf, uint8 _data) internal pure {
135         if (_buf.buf.length + 1 > _buf.capacity) {
136             resize(_buf, _buf.capacity * 2);
137         }
138         assembly {
139             let bufptr := mload(_buf) // Memory address of the buffer data
140             let buflen := mload(bufptr) // Length of existing buffer data
141             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
142             mstore8(dest, _data)
143             mstore(bufptr, add(buflen, 1)) // Update buffer length
144         }
145     }
146     /**
147       *
148       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
149       * exceed the capacity of the buffer.
150       * @param _buf The buffer to append to.
151       * @param _data The data to append.
152       * @return The original buffer.
153       *
154       */
155     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
156         if (_len + _buf.buf.length > _buf.capacity) {
157             resize(_buf, max(_buf.capacity, _len) * 2);
158         }
159         uint mask = 256 ** _len - 1;
160         assembly {
161             let bufptr := mload(_buf) // Memory address of the buffer data
162             let buflen := mload(bufptr) // Length of existing buffer data
163             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
164             mstore(dest, or(and(mload(dest), not(mask)), _data))
165             mstore(bufptr, add(buflen, _len)) // Update buffer length
166         }
167         return _buf;
168     }
169 }
170 
171 library CBOR {
172 
173     using Buffer for Buffer.buffer;
174 
175     uint8 private constant MAJOR_TYPE_INT = 0;
176     uint8 private constant MAJOR_TYPE_MAP = 5;
177     uint8 private constant MAJOR_TYPE_BYTES = 2;
178     uint8 private constant MAJOR_TYPE_ARRAY = 4;
179     uint8 private constant MAJOR_TYPE_STRING = 3;
180     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
181     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
182 
183     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
184         if (_value <= 23) {
185             _buf.append(uint8((_major << 5) | _value));
186         } else if (_value <= 0xFF) {
187             _buf.append(uint8((_major << 5) | 24));
188             _buf.appendInt(_value, 1);
189         } else if (_value <= 0xFFFF) {
190             _buf.append(uint8((_major << 5) | 25));
191             _buf.appendInt(_value, 2);
192         } else if (_value <= 0xFFFFFFFF) {
193             _buf.append(uint8((_major << 5) | 26));
194             _buf.appendInt(_value, 4);
195         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
196             _buf.append(uint8((_major << 5) | 27));
197             _buf.appendInt(_value, 8);
198         }
199     }
200 
201     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
202         _buf.append(uint8((_major << 5) | 31));
203     }
204 
205     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
206         encodeType(_buf, MAJOR_TYPE_INT, _value);
207     }
208 
209     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
210         if (_value >= 0) {
211             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
212         } else {
213             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
214         }
215     }
216 
217     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
218         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
219         _buf.append(_value);
220     }
221 
222     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
223         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
224         _buf.append(bytes(_value));
225     }
226 
227     function startArray(Buffer.buffer memory _buf) internal pure {
228         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
229     }
230 
231     function startMap(Buffer.buffer memory _buf) internal pure {
232         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
233     }
234 
235     function endSequence(Buffer.buffer memory _buf) internal pure {
236         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
237     }
238 }
239 /*
240 
241 End solidity-cborutils
242 
243 */
244 contract usingOraclize {
245 
246     using CBOR for Buffer.buffer;
247 
248     OraclizeI oraclize;
249     OraclizeAddrResolverI OAR;
250 
251     uint constant day = 60 * 60 * 24;
252     uint constant week = 60 * 60 * 24 * 7;
253     uint constant month = 60 * 60 * 24 * 30;
254 
255     byte constant proofType_NONE = 0x00;
256     byte constant proofType_Ledger = 0x30;
257     byte constant proofType_Native = 0xF0;
258     byte constant proofStorage_IPFS = 0x01;
259     byte constant proofType_Android = 0x40;
260     byte constant proofType_TLSNotary = 0x10;
261 
262     string oraclize_network_name;
263     uint8 constant networkID_auto = 0;
264     uint8 constant networkID_morden = 2;
265     uint8 constant networkID_mainnet = 1;
266     uint8 constant networkID_testnet = 2;
267     uint8 constant networkID_consensys = 161;
268 
269     mapping(bytes32 => bytes32) oraclize_randomDS_args;
270     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
271 
272     modifier oraclizeAPI {
273         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
274             oraclize_setNetwork(networkID_auto);
275         }
276         if (address(oraclize) != OAR.getAddress()) {
277             oraclize = OraclizeI(OAR.getAddress());
278         }
279         _;
280     }
281 
282     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
283         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
284         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
285         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
286         require(proofVerified);
287         _;
288     }
289 
290     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
291       return oraclize_setNetwork();
292       _networkID; // silence the warning and remain backwards compatible
293     }
294 
295     function oraclize_setNetworkName(string memory _network_name) internal {
296         oraclize_network_name = _network_name;
297     }
298 
299     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
300         return oraclize_network_name;
301     }
302 
303     function oraclize_setNetwork() internal returns (bool _networkSet) {
304         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
305             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
306             oraclize_setNetworkName("eth_mainnet");
307             return true;
308         }
309         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
310             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
311             oraclize_setNetworkName("eth_ropsten3");
312             return true;
313         }
314         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
315             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
316             oraclize_setNetworkName("eth_kovan");
317             return true;
318         }
319         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
320             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
321             oraclize_setNetworkName("eth_rinkeby");
322             return true;
323         }
324         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
325             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
326             return true;
327         }
328         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
329             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
330             return true;
331         }
332         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
333             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
334             return true;
335         }
336         return false;
337     }
338 
339     function __callback(bytes32 _myid, string memory _result) public {
340         __callback(_myid, _result, new bytes(0));
341     }
342 
343     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
344       return;
345       _myid; _result; _proof; // Silence compiler warnings
346     }
347 
348     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
349         return oraclize.getPrice(_datasource);
350     }
351 
352     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
353         return oraclize.getPrice(_datasource, _gasLimit);
354     }
355 
356     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
357         uint price = oraclize.getPrice(_datasource);
358         if (price > 1 ether + tx.gasprice * 200000) {
359             return 0; // Unexpectedly high price
360         }
361         return oraclize.query.value(price)(0, _datasource, _arg);
362     }
363 
364     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
365         uint price = oraclize.getPrice(_datasource);
366         if (price > 1 ether + tx.gasprice * 200000) {
367             return 0; // Unexpectedly high price
368         }
369         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
370     }
371 
372     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
373         uint price = oraclize.getPrice(_datasource,_gasLimit);
374         if (price > 1 ether + tx.gasprice * _gasLimit) {
375             return 0; // Unexpectedly high price
376         }
377         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
378     }
379 
380     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
381         uint price = oraclize.getPrice(_datasource, _gasLimit);
382         if (price > 1 ether + tx.gasprice * _gasLimit) {
383            return 0; // Unexpectedly high price
384         }
385         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
386     }
387 
388     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
389         uint price = oraclize.getPrice(_datasource);
390         if (price > 1 ether + tx.gasprice * 200000) {
391             return 0; // Unexpectedly high price
392         }
393         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
394     }
395 
396     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
397         uint price = oraclize.getPrice(_datasource);
398         if (price > 1 ether + tx.gasprice * 200000) {
399             return 0; // Unexpectedly high price
400         }
401         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
402     }
403 
404     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
405         uint price = oraclize.getPrice(_datasource, _gasLimit);
406         if (price > 1 ether + tx.gasprice * _gasLimit) {
407             return 0; // Unexpectedly high price
408         }
409         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
410     }
411 
412     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
413         uint price = oraclize.getPrice(_datasource, _gasLimit);
414         if (price > 1 ether + tx.gasprice * _gasLimit) {
415             return 0; // Unexpectedly high price
416         }
417         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
418     }
419 
420     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
421         uint price = oraclize.getPrice(_datasource);
422         if (price > 1 ether + tx.gasprice * 200000) {
423             return 0; // Unexpectedly high price
424         }
425         bytes memory args = stra2cbor(_argN);
426         return oraclize.queryN.value(price)(0, _datasource, args);
427     }
428 
429     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
430         uint price = oraclize.getPrice(_datasource);
431         if (price > 1 ether + tx.gasprice * 200000) {
432             return 0; // Unexpectedly high price
433         }
434         bytes memory args = stra2cbor(_argN);
435         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
436     }
437 
438     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
439         uint price = oraclize.getPrice(_datasource, _gasLimit);
440         if (price > 1 ether + tx.gasprice * _gasLimit) {
441             return 0; // Unexpectedly high price
442         }
443         bytes memory args = stra2cbor(_argN);
444         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
445     }
446 
447     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
448         uint price = oraclize.getPrice(_datasource, _gasLimit);
449         if (price > 1 ether + tx.gasprice * _gasLimit) {
450             return 0; // Unexpectedly high price
451         }
452         bytes memory args = stra2cbor(_argN);
453         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
454     }
455 
456     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
457         string[] memory dynargs = new string[](1);
458         dynargs[0] = _args[0];
459         return oraclize_query(_datasource, dynargs);
460     }
461 
462     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
463         string[] memory dynargs = new string[](1);
464         dynargs[0] = _args[0];
465         return oraclize_query(_timestamp, _datasource, dynargs);
466     }
467 
468     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
469         string[] memory dynargs = new string[](1);
470         dynargs[0] = _args[0];
471         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
472     }
473 
474     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
475         string[] memory dynargs = new string[](1);
476         dynargs[0] = _args[0];
477         return oraclize_query(_datasource, dynargs, _gasLimit);
478     }
479 
480     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
481         string[] memory dynargs = new string[](2);
482         dynargs[0] = _args[0];
483         dynargs[1] = _args[1];
484         return oraclize_query(_datasource, dynargs);
485     }
486 
487     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
488         string[] memory dynargs = new string[](2);
489         dynargs[0] = _args[0];
490         dynargs[1] = _args[1];
491         return oraclize_query(_timestamp, _datasource, dynargs);
492     }
493 
494     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
495         string[] memory dynargs = new string[](2);
496         dynargs[0] = _args[0];
497         dynargs[1] = _args[1];
498         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
499     }
500 
501     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
502         string[] memory dynargs = new string[](2);
503         dynargs[0] = _args[0];
504         dynargs[1] = _args[1];
505         return oraclize_query(_datasource, dynargs, _gasLimit);
506     }
507 
508     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
509         string[] memory dynargs = new string[](3);
510         dynargs[0] = _args[0];
511         dynargs[1] = _args[1];
512         dynargs[2] = _args[2];
513         return oraclize_query(_datasource, dynargs);
514     }
515 
516     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
517         string[] memory dynargs = new string[](3);
518         dynargs[0] = _args[0];
519         dynargs[1] = _args[1];
520         dynargs[2] = _args[2];
521         return oraclize_query(_timestamp, _datasource, dynargs);
522     }
523 
524     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
525         string[] memory dynargs = new string[](3);
526         dynargs[0] = _args[0];
527         dynargs[1] = _args[1];
528         dynargs[2] = _args[2];
529         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
530     }
531 
532     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
533         string[] memory dynargs = new string[](3);
534         dynargs[0] = _args[0];
535         dynargs[1] = _args[1];
536         dynargs[2] = _args[2];
537         return oraclize_query(_datasource, dynargs, _gasLimit);
538     }
539 
540     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
541         string[] memory dynargs = new string[](4);
542         dynargs[0] = _args[0];
543         dynargs[1] = _args[1];
544         dynargs[2] = _args[2];
545         dynargs[3] = _args[3];
546         return oraclize_query(_datasource, dynargs);
547     }
548 
549     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
550         string[] memory dynargs = new string[](4);
551         dynargs[0] = _args[0];
552         dynargs[1] = _args[1];
553         dynargs[2] = _args[2];
554         dynargs[3] = _args[3];
555         return oraclize_query(_timestamp, _datasource, dynargs);
556     }
557 
558     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
559         string[] memory dynargs = new string[](4);
560         dynargs[0] = _args[0];
561         dynargs[1] = _args[1];
562         dynargs[2] = _args[2];
563         dynargs[3] = _args[3];
564         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
565     }
566 
567     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
568         string[] memory dynargs = new string[](4);
569         dynargs[0] = _args[0];
570         dynargs[1] = _args[1];
571         dynargs[2] = _args[2];
572         dynargs[3] = _args[3];
573         return oraclize_query(_datasource, dynargs, _gasLimit);
574     }
575 
576     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
577         string[] memory dynargs = new string[](5);
578         dynargs[0] = _args[0];
579         dynargs[1] = _args[1];
580         dynargs[2] = _args[2];
581         dynargs[3] = _args[3];
582         dynargs[4] = _args[4];
583         return oraclize_query(_datasource, dynargs);
584     }
585 
586     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
587         string[] memory dynargs = new string[](5);
588         dynargs[0] = _args[0];
589         dynargs[1] = _args[1];
590         dynargs[2] = _args[2];
591         dynargs[3] = _args[3];
592         dynargs[4] = _args[4];
593         return oraclize_query(_timestamp, _datasource, dynargs);
594     }
595 
596     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
597         string[] memory dynargs = new string[](5);
598         dynargs[0] = _args[0];
599         dynargs[1] = _args[1];
600         dynargs[2] = _args[2];
601         dynargs[3] = _args[3];
602         dynargs[4] = _args[4];
603         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
604     }
605 
606     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
607         string[] memory dynargs = new string[](5);
608         dynargs[0] = _args[0];
609         dynargs[1] = _args[1];
610         dynargs[2] = _args[2];
611         dynargs[3] = _args[3];
612         dynargs[4] = _args[4];
613         return oraclize_query(_datasource, dynargs, _gasLimit);
614     }
615 
616     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
617         uint price = oraclize.getPrice(_datasource);
618         if (price > 1 ether + tx.gasprice * 200000) {
619             return 0; // Unexpectedly high price
620         }
621         bytes memory args = ba2cbor(_argN);
622         return oraclize.queryN.value(price)(0, _datasource, args);
623     }
624 
625     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
626         uint price = oraclize.getPrice(_datasource);
627         if (price > 1 ether + tx.gasprice * 200000) {
628             return 0; // Unexpectedly high price
629         }
630         bytes memory args = ba2cbor(_argN);
631         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
632     }
633 
634     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
635         uint price = oraclize.getPrice(_datasource, _gasLimit);
636         if (price > 1 ether + tx.gasprice * _gasLimit) {
637             return 0; // Unexpectedly high price
638         }
639         bytes memory args = ba2cbor(_argN);
640         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
641     }
642 
643     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
644         uint price = oraclize.getPrice(_datasource, _gasLimit);
645         if (price > 1 ether + tx.gasprice * _gasLimit) {
646             return 0; // Unexpectedly high price
647         }
648         bytes memory args = ba2cbor(_argN);
649         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
650     }
651 
652     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
653         bytes[] memory dynargs = new bytes[](1);
654         dynargs[0] = _args[0];
655         return oraclize_query(_datasource, dynargs);
656     }
657 
658     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
659         bytes[] memory dynargs = new bytes[](1);
660         dynargs[0] = _args[0];
661         return oraclize_query(_timestamp, _datasource, dynargs);
662     }
663 
664     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
665         bytes[] memory dynargs = new bytes[](1);
666         dynargs[0] = _args[0];
667         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
668     }
669 
670     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
671         bytes[] memory dynargs = new bytes[](1);
672         dynargs[0] = _args[0];
673         return oraclize_query(_datasource, dynargs, _gasLimit);
674     }
675 
676     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
677         bytes[] memory dynargs = new bytes[](2);
678         dynargs[0] = _args[0];
679         dynargs[1] = _args[1];
680         return oraclize_query(_datasource, dynargs);
681     }
682 
683     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
684         bytes[] memory dynargs = new bytes[](2);
685         dynargs[0] = _args[0];
686         dynargs[1] = _args[1];
687         return oraclize_query(_timestamp, _datasource, dynargs);
688     }
689 
690     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
691         bytes[] memory dynargs = new bytes[](2);
692         dynargs[0] = _args[0];
693         dynargs[1] = _args[1];
694         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
695     }
696 
697     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
698         bytes[] memory dynargs = new bytes[](2);
699         dynargs[0] = _args[0];
700         dynargs[1] = _args[1];
701         return oraclize_query(_datasource, dynargs, _gasLimit);
702     }
703 
704     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
705         bytes[] memory dynargs = new bytes[](3);
706         dynargs[0] = _args[0];
707         dynargs[1] = _args[1];
708         dynargs[2] = _args[2];
709         return oraclize_query(_datasource, dynargs);
710     }
711 
712     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
713         bytes[] memory dynargs = new bytes[](3);
714         dynargs[0] = _args[0];
715         dynargs[1] = _args[1];
716         dynargs[2] = _args[2];
717         return oraclize_query(_timestamp, _datasource, dynargs);
718     }
719 
720     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
721         bytes[] memory dynargs = new bytes[](3);
722         dynargs[0] = _args[0];
723         dynargs[1] = _args[1];
724         dynargs[2] = _args[2];
725         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
726     }
727 
728     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
729         bytes[] memory dynargs = new bytes[](3);
730         dynargs[0] = _args[0];
731         dynargs[1] = _args[1];
732         dynargs[2] = _args[2];
733         return oraclize_query(_datasource, dynargs, _gasLimit);
734     }
735 
736     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
737         bytes[] memory dynargs = new bytes[](4);
738         dynargs[0] = _args[0];
739         dynargs[1] = _args[1];
740         dynargs[2] = _args[2];
741         dynargs[3] = _args[3];
742         return oraclize_query(_datasource, dynargs);
743     }
744 
745     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
746         bytes[] memory dynargs = new bytes[](4);
747         dynargs[0] = _args[0];
748         dynargs[1] = _args[1];
749         dynargs[2] = _args[2];
750         dynargs[3] = _args[3];
751         return oraclize_query(_timestamp, _datasource, dynargs);
752     }
753 
754     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
755         bytes[] memory dynargs = new bytes[](4);
756         dynargs[0] = _args[0];
757         dynargs[1] = _args[1];
758         dynargs[2] = _args[2];
759         dynargs[3] = _args[3];
760         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
761     }
762 
763     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
764         bytes[] memory dynargs = new bytes[](4);
765         dynargs[0] = _args[0];
766         dynargs[1] = _args[1];
767         dynargs[2] = _args[2];
768         dynargs[3] = _args[3];
769         return oraclize_query(_datasource, dynargs, _gasLimit);
770     }
771 
772     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
773         bytes[] memory dynargs = new bytes[](5);
774         dynargs[0] = _args[0];
775         dynargs[1] = _args[1];
776         dynargs[2] = _args[2];
777         dynargs[3] = _args[3];
778         dynargs[4] = _args[4];
779         return oraclize_query(_datasource, dynargs);
780     }
781 
782     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
783         bytes[] memory dynargs = new bytes[](5);
784         dynargs[0] = _args[0];
785         dynargs[1] = _args[1];
786         dynargs[2] = _args[2];
787         dynargs[3] = _args[3];
788         dynargs[4] = _args[4];
789         return oraclize_query(_timestamp, _datasource, dynargs);
790     }
791 
792     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
793         bytes[] memory dynargs = new bytes[](5);
794         dynargs[0] = _args[0];
795         dynargs[1] = _args[1];
796         dynargs[2] = _args[2];
797         dynargs[3] = _args[3];
798         dynargs[4] = _args[4];
799         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
800     }
801 
802     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
803         bytes[] memory dynargs = new bytes[](5);
804         dynargs[0] = _args[0];
805         dynargs[1] = _args[1];
806         dynargs[2] = _args[2];
807         dynargs[3] = _args[3];
808         dynargs[4] = _args[4];
809         return oraclize_query(_datasource, dynargs, _gasLimit);
810     }
811 
812     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
813         return oraclize.setProofType(_proofP);
814     }
815 
816 
817     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
818         return oraclize.cbAddress();
819     }
820 
821     function getCodeSize(address _addr) view internal returns (uint _size) {
822         assembly {
823             _size := extcodesize(_addr)
824         }
825     }
826 
827     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
828         return oraclize.setCustomGasPrice(_gasPrice);
829     }
830 
831     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
832         return oraclize.randomDS_getSessionPubKeyHash();
833     }
834 
835     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
836         bytes memory tmp = bytes(_a);
837         uint160 iaddr = 0;
838         uint160 b1;
839         uint160 b2;
840         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
841             iaddr *= 256;
842             b1 = uint160(uint8(tmp[i]));
843             b2 = uint160(uint8(tmp[i + 1]));
844             if ((b1 >= 97) && (b1 <= 102)) {
845                 b1 -= 87;
846             } else if ((b1 >= 65) && (b1 <= 70)) {
847                 b1 -= 55;
848             } else if ((b1 >= 48) && (b1 <= 57)) {
849                 b1 -= 48;
850             }
851             if ((b2 >= 97) && (b2 <= 102)) {
852                 b2 -= 87;
853             } else if ((b2 >= 65) && (b2 <= 70)) {
854                 b2 -= 55;
855             } else if ((b2 >= 48) && (b2 <= 57)) {
856                 b2 -= 48;
857             }
858             iaddr += (b1 * 16 + b2);
859         }
860         return address(iaddr);
861     }
862 
863     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
864         bytes memory a = bytes(_a);
865         bytes memory b = bytes(_b);
866         uint minLength = a.length;
867         if (b.length < minLength) {
868             minLength = b.length;
869         }
870         for (uint i = 0; i < minLength; i ++) {
871             if (a[i] < b[i]) {
872                 return -1;
873             } else if (a[i] > b[i]) {
874                 return 1;
875             }
876         }
877         if (a.length < b.length) {
878             return -1;
879         } else if (a.length > b.length) {
880             return 1;
881         } else {
882             return 0;
883         }
884     }
885 
886     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
887         bytes memory h = bytes(_haystack);
888         bytes memory n = bytes(_needle);
889         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
890             return -1;
891         } else if (h.length > (2 ** 128 - 1)) {
892             return -1;
893         } else {
894             uint subindex = 0;
895             for (uint i = 0; i < h.length; i++) {
896                 if (h[i] == n[0]) {
897                     subindex = 1;
898                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
899                         subindex++;
900                     }
901                     if (subindex == n.length) {
902                         return int(i);
903                     }
904                 }
905             }
906             return -1;
907         }
908     }
909 
910     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
911         return strConcat(_a, _b, "", "", "");
912     }
913 
914     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
915         return strConcat(_a, _b, _c, "", "");
916     }
917 
918     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
919         return strConcat(_a, _b, _c, _d, "");
920     }
921 
922     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
923         bytes memory _ba = bytes(_a);
924         bytes memory _bb = bytes(_b);
925         bytes memory _bc = bytes(_c);
926         bytes memory _bd = bytes(_d);
927         bytes memory _be = bytes(_e);
928         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
929         bytes memory babcde = bytes(abcde);
930         uint k = 0;
931         uint i = 0;
932         for (i = 0; i < _ba.length; i++) {
933             babcde[k++] = _ba[i];
934         }
935         for (i = 0; i < _bb.length; i++) {
936             babcde[k++] = _bb[i];
937         }
938         for (i = 0; i < _bc.length; i++) {
939             babcde[k++] = _bc[i];
940         }
941         for (i = 0; i < _bd.length; i++) {
942             babcde[k++] = _bd[i];
943         }
944         for (i = 0; i < _be.length; i++) {
945             babcde[k++] = _be[i];
946         }
947         return string(babcde);
948     }
949 
950     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
951         return safeParseInt(_a, 0);
952     }
953 
954     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
955         bytes memory bresult = bytes(_a);
956         uint mint = 0;
957         bool decimals = false;
958         for (uint i = 0; i < bresult.length; i++) {
959             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
960                 if (decimals) {
961                    if (_b == 0) break;
962                     else _b--;
963                 }
964                 mint *= 10;
965                 mint += uint(uint8(bresult[i])) - 48;
966             } else if (uint(uint8(bresult[i])) == 46) {
967                 require(!decimals, 'More than one decimal encountered in string!');
968                 decimals = true;
969             } else {
970                 revert("Non-numeral character encountered in string!");
971             }
972         }
973         if (_b > 0) {
974             mint *= 10 ** _b;
975         }
976         return mint;
977     }
978 
979     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
980         return parseInt(_a, 0);
981     }
982 
983     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
984         bytes memory bresult = bytes(_a);
985         uint mint = 0;
986         bool decimals = false;
987         for (uint i = 0; i < bresult.length; i++) {
988             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
989                 if (decimals) {
990                    if (_b == 0) {
991                        break;
992                    } else {
993                        _b--;
994                    }
995                 }
996                 mint *= 10;
997                 mint += uint(uint8(bresult[i])) - 48;
998             } else if (uint(uint8(bresult[i])) == 46) {
999                 decimals = true;
1000             }
1001         }
1002         if (_b > 0) {
1003             mint *= 10 ** _b;
1004         }
1005         return mint;
1006     }
1007 
1008     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1009         if (_i == 0) {
1010             return "0";
1011         }
1012         uint j = _i;
1013         uint len;
1014         while (j != 0) {
1015             len++;
1016             j /= 10;
1017         }
1018         bytes memory bstr = new bytes(len);
1019         uint k = len - 1;
1020         while (_i != 0) {
1021             bstr[k--] = byte(uint8(48 + _i % 10));
1022             _i /= 10;
1023         }
1024         return string(bstr);
1025     }
1026 
1027     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1028         safeMemoryCleaner();
1029         Buffer.buffer memory buf;
1030         Buffer.init(buf, 1024);
1031         buf.startArray();
1032         for (uint i = 0; i < _arr.length; i++) {
1033             buf.encodeString(_arr[i]);
1034         }
1035         buf.endSequence();
1036         return buf.buf;
1037     }
1038 
1039     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1040         safeMemoryCleaner();
1041         Buffer.buffer memory buf;
1042         Buffer.init(buf, 1024);
1043         buf.startArray();
1044         for (uint i = 0; i < _arr.length; i++) {
1045             buf.encodeBytes(_arr[i]);
1046         }
1047         buf.endSequence();
1048         return buf.buf;
1049     }
1050 
1051     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1052         require((_nbytes > 0) && (_nbytes <= 32));
1053         _delay *= 10; // Convert from seconds to ledger timer ticks
1054         bytes memory nbytes = new bytes(1);
1055         nbytes[0] = byte(uint8(_nbytes));
1056         bytes memory unonce = new bytes(32);
1057         bytes memory sessionKeyHash = new bytes(32);
1058         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1059         assembly {
1060             mstore(unonce, 0x20)
1061             /*
1062              The following variables can be relaxed.
1063              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1064              for an idea on how to override and replace commit hash variables.
1065             */
1066             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1067             mstore(sessionKeyHash, 0x20)
1068             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1069         }
1070         bytes memory delay = new bytes(32);
1071         assembly {
1072             mstore(add(delay, 0x20), _delay)
1073         }
1074         bytes memory delay_bytes8 = new bytes(8);
1075         copyBytes(delay, 24, 8, delay_bytes8, 0);
1076         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1077         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1078         bytes memory delay_bytes8_left = new bytes(8);
1079         assembly {
1080             let x := mload(add(delay_bytes8, 0x20))
1081             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1082             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1083             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1084             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1085             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1086             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1087             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1088             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1089         }
1090         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1091         return queryId;
1092     }
1093 
1094     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1095         oraclize_randomDS_args[_queryId] = _commitment;
1096     }
1097 
1098     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1099         bool sigok;
1100         address signer;
1101         bytes32 sigr;
1102         bytes32 sigs;
1103         bytes memory sigr_ = new bytes(32);
1104         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1105         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1106         bytes memory sigs_ = new bytes(32);
1107         offset += 32 + 2;
1108         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1109         assembly {
1110             sigr := mload(add(sigr_, 32))
1111             sigs := mload(add(sigs_, 32))
1112         }
1113         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1114         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1115             return true;
1116         } else {
1117             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1118             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1119         }
1120     }
1121 
1122     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1123         bool sigok;
1124         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1125         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1126         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1127         bytes memory appkey1_pubkey = new bytes(64);
1128         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1129         bytes memory tosign2 = new bytes(1 + 65 + 32);
1130         tosign2[0] = byte(uint8(1)); //role
1131         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1132         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1133         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1134         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1135         if (!sigok) {
1136             return false;
1137         }
1138         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1139         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1140         bytes memory tosign3 = new bytes(1 + 65);
1141         tosign3[0] = 0xFE;
1142         copyBytes(_proof, 3, 65, tosign3, 1);
1143         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1144         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1145         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1146         return sigok;
1147     }
1148 
1149     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1150         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1151         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1152             return 1;
1153         }
1154         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1155         if (!proofVerified) {
1156             return 2;
1157         }
1158         return 0;
1159     }
1160 
1161     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1162         bool match_ = true;
1163         require(_prefix.length == _nRandomBytes);
1164         for (uint256 i = 0; i< _nRandomBytes; i++) {
1165             if (_content[i] != _prefix[i]) {
1166                 match_ = false;
1167             }
1168         }
1169         return match_;
1170     }
1171 
1172     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1173         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1174         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1175         bytes memory keyhash = new bytes(32);
1176         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1177         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1178             return false;
1179         }
1180         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1181         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1182         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1183         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1184             return false;
1185         }
1186         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1187         // This is to verify that the computed args match with the ones specified in the query.
1188         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1189         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1190         bytes memory sessionPubkey = new bytes(64);
1191         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1192         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1193         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1194         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1195             delete oraclize_randomDS_args[_queryId];
1196         } else return false;
1197         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1198         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1199         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1200         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1201             return false;
1202         }
1203         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1204         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1205             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1206         }
1207         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1208     }
1209     /*
1210      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1211     */
1212     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1213         uint minLength = _length + _toOffset;
1214         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1215         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1216         uint j = 32 + _toOffset;
1217         while (i < (32 + _fromOffset + _length)) {
1218             assembly {
1219                 let tmp := mload(add(_from, i))
1220                 mstore(add(_to, j), tmp)
1221             }
1222             i += 32;
1223             j += 32;
1224         }
1225         return _to;
1226     }
1227     /*
1228      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1229      Duplicate Solidity's ecrecover, but catching the CALL return value
1230     */
1231     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1232         /*
1233          We do our own memory management here. Solidity uses memory offset
1234          0x40 to store the current end of memory. We write past it (as
1235          writes are memory extensions), but don't update the offset so
1236          Solidity will reuse it. The memory used here is only needed for
1237          this context.
1238          FIXME: inline assembly can't access return values
1239         */
1240         bool ret;
1241         address addr;
1242         assembly {
1243             let size := mload(0x40)
1244             mstore(size, _hash)
1245             mstore(add(size, 32), _v)
1246             mstore(add(size, 64), _r)
1247             mstore(add(size, 96), _s)
1248             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1249             addr := mload(size)
1250         }
1251         return (ret, addr);
1252     }
1253     /*
1254      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1255     */
1256     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1257         bytes32 r;
1258         bytes32 s;
1259         uint8 v;
1260         if (_sig.length != 65) {
1261             return (false, address(0));
1262         }
1263         /*
1264          The signature format is a compact form of:
1265            {bytes32 r}{bytes32 s}{uint8 v}
1266          Compact means, uint8 is not padded to 32 bytes.
1267         */
1268         assembly {
1269             r := mload(add(_sig, 32))
1270             s := mload(add(_sig, 64))
1271             /*
1272              Here we are loading the last 32 bytes. We exploit the fact that
1273              'mload' will pad with zeroes if we overread.
1274              There is no 'mload8' to do this, but that would be nicer.
1275             */
1276             v := byte(0, mload(add(_sig, 96)))
1277             /*
1278               Alternative solution:
1279               'byte' is not working due to the Solidity parser, so lets
1280               use the second best option, 'and'
1281               v := and(mload(add(_sig, 65)), 255)
1282             */
1283         }
1284         /*
1285          albeit non-transactional signatures are not specified by the YP, one would expect it
1286          to match the YP range of [27, 28]
1287          geth uses [0, 1] and some clients have followed. This might change, see:
1288          https://github.com/ethereum/go-ethereum/issues/2053
1289         */
1290         if (v < 27) {
1291             v += 27;
1292         }
1293         if (v != 27 && v != 28) {
1294             return (false, address(0));
1295         }
1296         return safer_ecrecover(_hash, v, r, s);
1297     }
1298 
1299     function safeMemoryCleaner() internal pure {
1300         assembly {
1301             let fmem := mload(0x40)
1302             codecopy(fmem, codesize, sub(msize, fmem))
1303         }
1304     }
1305 }
1306 /*
1307 
1308 END ORACLIZE_API
1309 
1310 */
1311 
1312 
1313 
1314 
1315 
1316 
1317 
1318 
1319 
1320 
1321 
1322 /*
1323  * Copyright 2019 Authpaper Team
1324  *
1325  * Licensed under the Apache License, Version 2.0 (the "License");
1326  * you may not use this file except in compliance with the License.
1327  * You may obtain a copy of the License at
1328  *
1329  *      http://www.apache.org/licenses/LICENSE-2.0
1330  *
1331  * Unless required by applicable law or agreed to in writing, software
1332  * distributed under the License is distributed on an "AS IS" BASIS,
1333  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1334  * See the License for the specific language governing permissions and
1335  * limitations under the License.
1336  */
1337 pragma solidity ^0.5.1;
1338 
1339 contract Adminstrator {
1340   address public admin;
1341   address payable public owner;
1342 
1343   modifier onlyAdmin() { 
1344         require(msg.sender == admin || msg.sender == owner,"Not authorized to run this function"); 
1345         _;
1346   } 
1347 
1348   constructor() public {
1349     admin = msg.sender;
1350 	owner = msg.sender;
1351   }
1352 
1353   function transferAdminstrator(address newAdmin) public onlyAdmin {
1354     admin = newAdmin; 
1355   }
1356 }
1357 
1358 
1359 
1360 contract FiftyContract is Adminstrator,usingOraclize {
1361 	//About the membership
1362     uint public mRate = 150 finney; //membership fee
1363 	uint public membershiptime = 183 * 86400; //membership valid for 183 days, around 0.5 year
1364 	mapping (address => uint) public membership;
1365 	
1366 	//About reading data from the website
1367 	string public website="http://ec2-54-251-168-235.ap-southeast-1.compute.amazonaws.com/getAddresses.php?eth=";
1368 	enum gettingData { Member, Parent }
1369 	mapping (bytes32 => treeNode) public oraclizeCallbacks;
1370 	
1371 	//About the tree
1372 	event completeTree(address indexed _self, uint indexed _nodeID, uint indexed _amount);
1373 	event startTree(address indexed _self, uint indexed _nodeID, uint indexed _amount);
1374 	event assignTreeNode(address indexed _self, uint indexed _nodeID, uint indexed _amount);
1375 	//Keep the nodeID they are using, (2 ** 32) - 1 means they are rejected from joining a tree of that amount
1376 	mapping (address => mapping (uint => uint)) public nodeIDIndex;
1377 	//Keep children of a node, no matter the tree is already completed or running currently
1378 	//Acts like treeNode => mapping (uint => treeNode)
1379 	mapping (address => mapping (uint => mapping (uint => mapping (uint => treeNode)))) public treeChildren;
1380 	//Acts like treeNode => treeNode
1381 	mapping (address => mapping (uint => mapping (uint => treeNode))) public treeParent;
1382 	//Keep the current running nodes given an address
1383 	mapping (address => mapping (uint => bool)) public currentNodes;
1384 	//Temporary direct referral
1385 	mapping (address => address) public temporaryDirectReferral;
1386 	uint public spread=2;
1387 	uint public level=2;
1388 	uint public minimumTreeNodeReferred=2;
1389 	
1390 	struct treeNode {
1391 		 address payable ethAddress; 
1392 		 uint nodeType; 
1393 		 uint nodeID;
1394 	}
1395 	struct rewardDistribution {
1396 		address payable first;
1397 		address payable second;
1398 	}
1399 	
1400 	//Statistic issue
1401 	uint256 public receivedAmount=0;
1402 	uint256 public sentAmount=0;
1403 	bool public paused=false;
1404 	event Paused(address account);
1405 	event Unpaused(address account);
1406 	event makeQuery(address indexed account, string msg);
1407 	
1408 	//Setting the variables
1409 	function setMembershipFee(uint newMrate, uint newTime) public onlyAdmin{
1410 		require(newMrate > 0, "new rate must be positive");
1411 		require(newTime > 0, "new membership time must be positive");
1412 		mRate = newMrate * 10 ** uint256(15); //The amount is in finney
1413 		membershiptime = newTime * 86400; //The amount is in days
1414 	}
1415 	function setTreeSpec(uint newSpread, uint newLevel, uint newTreeNodeReferred) public onlyAdmin{
1416 		require(newSpread > 1, "new spread must be larger than 1");
1417 		require(newLevel > 1, "new level must be larger than 1");
1418 		require(newTreeNodeReferred > 1, "new minimum tree nodes referred by root must be larger than 1");
1419 		spread = newSpread;
1420 		level = newLevel;
1421 		minimumTreeNodeReferred = newTreeNodeReferred;
1422 	}
1423 	function setWebsite(string memory web) public onlyAdmin{
1424 		website = web;
1425 	}
1426 	function pause(bool isPause) public onlyAdmin{
1427 		paused = isPause;
1428 		if(isPause) emit Paused(msg.sender);
1429 		else emit Unpaused(msg.sender);
1430 	}
1431 	//Just in case there are fronzen money
1432 	function withdraw(uint amount) public onlyAdmin returns(bool) {
1433         require(amount < address(this).balance);
1434         owner.transfer(amount);
1435         return true;
1436     } 
1437 	//The main function, the function is called whenever someone send in either
1438 	function() external payable { 
1439 		require(!paused,"The contract is paused");
1440 		require(address(this).balance + msg.value > address(this).balance);
1441 		if(msg.value == mRate){
1442 			_addMember(msg.sender);
1443 			return;
1444 		}
1445 		require(msg.value >= 1,"Not enough ETH");
1446 		require(membership[msg.sender] > now,"Membership not valid");
1447 		//First of all, create a tree with this node as the root
1448 		//If this node has already start this type of tree, return
1449 		require(currentNodes[msg.sender][msg.value] == false,"You have started this kind of tree already");
1450 		//Now create a node, 2 ** 32 - 1 means it is banned already
1451 		require(nodeIDIndex[msg.sender][msg.value] < (2 ** 32) -1,"You are banned from this kind of tree already");
1452 		
1453 		currentNodes[msg.sender][msg.value] = true;
1454 		nodeIDIndex[msg.sender][msg.value] += 1;
1455 		receivedAmount += msg.value;
1456 		emit startTree(msg.sender, nodeIDIndex[msg.sender][msg.value] - 1, msg.value);
1457 		//Now there are two remaining problems, where should the money goes and whose tree deserves this node as children
1458 		//We need to make a web call for this.
1459 		//Remember, each OraclizeQuery burns 0.004 ETH from the contract !!
1460 		emit makeQuery(msg.sender,"Oraclize query was sent, standing by for the answer..");
1461 		string memory queryStr = strConcating(website,addressToString(msg.sender));
1462 		bytes32 queryId=oraclize_query("URL", queryStr);
1463         oraclizeCallbacks[queryId] = treeNode(msg.sender,msg.value,nodeIDIndex[msg.sender][msg.value]);
1464 		//https://medium.com/coinmonks/a-really-simple-smart-contract-on-how-to-insert-value-into-the-ethereum-blockchain-and-display-it-62c455610e98
1465 		//https://github.com/Alonski/MultiSendEthereum/blob/master/contracts/MultiSend.sol
1466 	}
1467 	function __callback(bytes32 myid, string memory result) public {
1468         if (msg.sender != oraclize_cbAddress()) revert();
1469         treeNode memory o = oraclizeCallbacks[myid];	
1470 		//Now handle the membership data here
1471 		//It is a 85 byte string, with a ":" in the middle
1472 		bytes memory _baseBytes = bytes(result);
1473 		require(_baseBytes.length == 85, "The return string is not valid");
1474 		address payable firstUpline=bytesToAddress(extractSig(_baseBytes,0,42));
1475 		address payable secondUpline=bytesToAddress(extractSig(_baseBytes,43,42));
1476 		require(firstUpline != address(0), "The firstUpline is incorrect");
1477 		require(secondUpline != address(0), "The secondUpline is incorrect");
1478 		
1479 		uint treeType = o.nodeType;
1480 		address payable treeRoot = o.ethAddress;
1481 		uint treeNodeID = o.nodeID;
1482 		temporaryDirectReferral[treeRoot] = firstUpline;
1483 		
1484 		//Now check its parent, if its parent has a tree of this type with empty place, place it there
1485 		rewardDistribution memory rewardResult = _placeChildTree(firstUpline,treeType,treeRoot,treeNodeID);
1486 		if(rewardResult.first == address(0)){
1487 			//Now firstUpline does not have a place for this node, it is time to search the secondUpline
1488 			rewardResult = _placeChildTree(secondUpline,treeType,treeRoot,treeNodeID);
1489 		}
1490 		//Now it is time to distribute the award accordingly
1491 		uint moneyToDistribute = (treeType * 5) / 10;
1492 		require(treeType > 2*moneyToDistribute, "The number is too large to distribute");
1493 		require(address(this).balance > treeType, "No money to distribute");
1494 		uint previousBalances = address(this).balance;
1495 		if(rewardResult.first != address(0)){
1496 			rewardResult.first.transfer(moneyToDistribute);
1497 			sentAmount += moneyToDistribute;
1498 		} 
1499 		if(rewardResult.second != address(0)){
1500 			rewardResult.second.transfer(moneyToDistribute);
1501 			sentAmount += moneyToDistribute;
1502 		}
1503 		emit assignTreeNode(treeRoot,treeNodeID,treeType);
1504 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
1505         assert(address(this).balance + (2*moneyToDistribute) >= previousBalances);
1506     }
1507 	function _addMember(address _member) internal {
1508 		require(_member != address(0));
1509 		if(membership[_member] <= now) membership[_member] = now;
1510 		membership[_member] += membershiptime;
1511 	}
1512 	function addMember(address member) public onlyAdmin {
1513 		_addMember(member);
1514 	}
1515 	function banMember(address member) public onlyAdmin {
1516 		require(member != address(0));
1517 		membership[member] = 0;
1518 	}
1519 	function checkMemberShip(address member) public view returns(uint) {
1520 		require(member != address(0));
1521 		return membership[member];
1522 	}
1523 	function _placeChildTree(address payable firstUpline, uint treeType, address payable treeRoot, uint treeNodeID) internal returns(rewardDistribution memory) {
1524 		//We do BFS here, so need to search layer by layer
1525 		address payable getETHOne = address(0); address payable getETHTwo = address(0);
1526 		if(_placeChild(firstUpline,treeType,treeRoot,treeNodeID)){
1527 			getETHOne=firstUpline;
1528 			uint cNodeID=nodeIDIndex[firstUpline][treeType] - 1;
1529 			//So the firstUpline will get the money, as well as the parent of the firstUpline
1530 			if(treeParent[firstUpline][treeType][cNodeID].nodeType != 0)
1531 				getETHTwo = treeParent[firstUpline][treeType][cNodeID].ethAddress;
1532 		}
1533 		if(getETHOne == address(0)){
1534 			//Now search the grandchildren of the firstUpline for a place
1535 			if(currentNodes[firstUpline][treeType] && nodeIDIndex[firstUpline][treeType] <(2 ** 32) -1){
1536 				uint cNodeID=nodeIDIndex[firstUpline][treeType] - 1;
1537 				for (uint256 i=0; i < spread; i++) {
1538 					if(treeChildren[firstUpline][treeType][cNodeID][i].nodeType != 0){
1539 						treeNode memory kids = treeChildren[firstUpline][treeType][cNodeID][i];
1540 						if(_placeChild(kids.ethAddress,treeType,treeRoot,treeNodeID)){
1541 							getETHOne=kids.ethAddress;
1542 							//So the child of firstUpline will get the money, as well as the child
1543 							getETHTwo = firstUpline;
1544 						}
1545 					}
1546 				}
1547 			}
1548 		}
1549 		return rewardDistribution(getETHOne,getETHTwo);
1550 	}
1551 	function _placeChild(address payable firstUpline, uint treeType, address payable treeRoot, uint treeNodeID) internal returns(bool) {
1552 		if(currentNodes[firstUpline][treeType] && nodeIDIndex[firstUpline][treeType] <(2 ** 32) -1){
1553 			uint cNodeID=nodeIDIndex[firstUpline][treeType] - 1;
1554 			for (uint256 i=0; i < spread; i++) {
1555 				if(treeChildren[firstUpline][treeType][cNodeID][i].nodeType == 0){
1556 					//firstUpline has a place for the node, so place it there
1557 					treeChildren[firstUpline][treeType][cNodeID][i]
1558 						= treeNode(treeRoot,treeType,treeNodeID);
1559 					//Set parent of this node to be that node
1560 					treeParent[treeRoot][treeType][treeNodeID] 
1561 						= treeNode(firstUpline,treeType,cNodeID);
1562 					//Now we need to check if the tree is completed 
1563 					_checkTreeComplete(firstUpline,treeType,cNodeID);
1564 					return true;
1565 				}
1566 			}
1567 		}
1568 		return false;
1569 	}
1570 	function _checkTreeComplete(address _root, uint _treeType, uint _nodeID) internal {
1571 		require(_root != address(0), "The tree root to check completness is null");
1572 		bool _isCompleted = true;
1573 		uint _isDirectRefCount = 0;
1574 		for (uint256 i=0; i < spread; i++) {
1575 			if(treeChildren[_root][_treeType][_nodeID][i].nodeType == 0){
1576 				_isCompleted = false;
1577 				break;
1578 			}else{
1579 				//Search the grandchildren
1580 				treeNode memory _child = treeChildren[_root][_treeType][_nodeID][i];
1581 				if(temporaryDirectReferral[_child.ethAddress] == _root) _isDirectRefCount += 1;
1582 				else{
1583 					if(temporaryDirectReferral[_child.ethAddress] != address(0)
1584 						&& temporaryDirectReferral[temporaryDirectReferral[_child.ethAddress]] == _root)
1585 						_isDirectRefCount += 1;
1586 				}
1587 				for (uint256 a=0; a < spread; a++) {
1588 					if(treeChildren[_child.ethAddress][_treeType][_child.nodeID][a].nodeType == 0){
1589 						_isCompleted = false;
1590 						break;
1591 					}else{
1592 						address grandChildAddress
1593 						    =treeChildren[_child.ethAddress][_treeType][_child.nodeID][a].ethAddress;
1594 						if(temporaryDirectReferral[grandChildAddress] == _root) _isDirectRefCount += 1;
1595 						else{
1596 							if(temporaryDirectReferral[grandChildAddress] != address(0)
1597 								&& temporaryDirectReferral[temporaryDirectReferral[grandChildAddress]] == _root)
1598 								_isDirectRefCount += 1;
1599 						}
1600 					}
1601 				}
1602 				if(!_isCompleted) break;
1603 			}
1604 		}
1605 		if(!_isCompleted) return;
1606 		//The tree is completed, set the current node to be 0 so root can start over again
1607 		currentNodes[_root][_treeType] = false;
1608 		if(_isDirectRefCount < minimumTreeNodeReferred){
1609 			//The tree is completed mostly by someone not referred by root nor someone referred by someone referred by root
1610 			//Ban this user from further starting the same type of tree
1611 			nodeIDIndex[_root][_treeType] = (2 ** 32) -1;
1612 		}
1613 	}
1614 	function getHistory(address _ethAddress) public view returns(string memory){
1615 		return addressToString(temporaryDirectReferral[_ethAddress]);
1616 	}
1617 	
1618 	function extractSig (bytes memory data, uint8 from, uint8 n) public pure returns(bytes memory) {
1619       bytes memory returnValue = new bytes(n);
1620       for (uint8 i = 0; i < n - from; i++) {
1621         returnValue[i] = data[i + from]; 
1622       }
1623       return returnValue;
1624     }
1625     function strConcating(string memory _a, string memory _b) internal pure returns (string memory){
1626         bytes memory _ba = bytes(_a);
1627         bytes memory _bb = bytes(_b);
1628         string memory ab = new string(_ba.length + _bb.length);
1629         bytes memory bab = bytes(ab);
1630         uint k = 0;
1631         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
1632         for (uint i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
1633         return string(bab);
1634     }
1635     function addressToString(address _addr) public pure returns(string memory) {
1636         bytes32 value = bytes32(uint256(_addr));
1637         bytes memory alphabet = "0123456789abcdef";
1638     
1639         bytes memory str = new bytes(42);
1640         str[0] = '0';
1641         str[1] = 'x';
1642         for (uint i = 0; i < 20; i++) {
1643             str[2+i*2] = alphabet[uint8(value[i + 12] >> 4)];
1644             str[3+i*2] = alphabet[uint8(value[i + 12] & 0x0f)];
1645         }
1646         return string(str);
1647     }
1648     function bytesToAddress(bytes memory _address) public pure returns (address payable) {
1649         uint160 m = 0;
1650         uint160 b = 0;
1651     
1652         for (uint8 i = 0; i < 20; i++) {
1653           m *= 256;
1654           b = uint8(_address[i]);
1655           m += (b);
1656         }
1657     
1658         return address(m);
1659       }
1660 }