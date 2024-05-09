1 pragma solidity 0.5.2;
2 
3 // Dummy contract only used to emit to end-user they are using wrong solc
4 contract solcChecker {
5 /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;
6 }
7 
8 contract OraclizeI {
9 
10     address public cbAddress;
11 
12     function setProofType(byte _proofType) external;
13     function setCustomGasPrice(uint _gasPrice) external;
14     function getPrice(string memory _datasource) public returns (uint _dsprice);
15     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
16     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
17     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
18     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
19     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
20     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
21     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
22     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
23 }
24 
25 contract OraclizeAddrResolverI {
26     function getAddress() public returns (address _address);
27 }
28 /*
29 
30 Begin solidity-cborutils
31 
32 https://github.com/smartcontractkit/solidity-cborutils
33 
34 MIT License
35 
36 Copyright (c) 2018 SmartContract ChainLink, Ltd.
37 
38 Permission is hereby granted, free of charge, to any person obtaining a copy
39 of this software and associated documentation files (the "Software"), to deal
40 in the Software without restriction, including without limitation the rights
41 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
42 copies of the Software, and to permit persons to whom the Software is
43 furnished to do so, subject to the following conditions:
44 
45 The above copyright notice and this permission notice shall be included in all
46 copies or substantial portions of the Software.
47 
48 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
49 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
50 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
51 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
52 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
53 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
54 SOFTWARE.
55 
56 */
57 library Buffer {
58 
59     struct buffer {
60         bytes buf;
61         uint capacity;
62     }
63 
64     function init(buffer memory _buf, uint _capacity) internal pure {
65         uint capacity = _capacity;
66         if (capacity % 32 != 0) {
67             capacity += 32 - (capacity % 32);
68         }
69         _buf.capacity = capacity; // Allocate space for the buffer data
70         assembly {
71             let ptr := mload(0x40)
72             mstore(_buf, ptr)
73             mstore(ptr, 0)
74             mstore(0x40, add(ptr, capacity))
75         }
76     }
77 
78     function resize(buffer memory _buf, uint _capacity) private pure {
79         bytes memory oldbuf = _buf.buf;
80         init(_buf, _capacity);
81         append(_buf, oldbuf);
82     }
83 
84     function max(uint _a, uint _b) private pure returns (uint _max) {
85         if (_a > _b) {
86             return _a;
87         }
88         return _b;
89     }
90     /**
91       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
92       *      would exceed the capacity of the buffer.
93       * @param _buf The buffer to append to.
94       * @param _data The data to append.
95       * @return The original buffer.
96       *
97       */
98     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
99         if (_data.length + _buf.buf.length > _buf.capacity) {
100             resize(_buf, max(_buf.capacity, _data.length) * 2);
101         }
102         uint dest;
103         uint src;
104         uint len = _data.length;
105         assembly {
106             let bufptr := mload(_buf) // Memory address of the buffer data
107             let buflen := mload(bufptr) // Length of existing buffer data
108             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
109             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
110             src := add(_data, 32)
111         }
112         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
113             assembly {
114                 mstore(dest, mload(src))
115             }
116             dest += 32;
117             src += 32;
118         }
119         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
120         assembly {
121             let srcpart := and(mload(src), not(mask))
122             let destpart := and(mload(dest), mask)
123             mstore(dest, or(destpart, srcpart))
124         }
125         return _buf;
126     }
127     /**
128       *
129       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
130       * exceed the capacity of the buffer.
131       * @param _buf The buffer to append to.
132       * @param _data The data to append.
133       * @return The original buffer.
134       *
135       */
136     function append(buffer memory _buf, uint8 _data) internal pure {
137         if (_buf.buf.length + 1 > _buf.capacity) {
138             resize(_buf, _buf.capacity * 2);
139         }
140         assembly {
141             let bufptr := mload(_buf) // Memory address of the buffer data
142             let buflen := mload(bufptr) // Length of existing buffer data
143             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
144             mstore8(dest, _data)
145             mstore(bufptr, add(buflen, 1)) // Update buffer length
146         }
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
157     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
158         if (_len + _buf.buf.length > _buf.capacity) {
159             resize(_buf, max(_buf.capacity, _len) * 2);
160         }
161         uint mask = 256 ** _len - 1;
162         assembly {
163             let bufptr := mload(_buf) // Memory address of the buffer data
164             let buflen := mload(bufptr) // Length of existing buffer data
165             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
166             mstore(dest, or(and(mload(dest), not(mask)), _data))
167             mstore(bufptr, add(buflen, _len)) // Update buffer length
168         }
169         return _buf;
170     }
171 }
172 
173 library CBOR {
174 
175     using Buffer for Buffer.buffer;
176 
177     uint8 private constant MAJOR_TYPE_INT = 0;
178     uint8 private constant MAJOR_TYPE_MAP = 5;
179     uint8 private constant MAJOR_TYPE_BYTES = 2;
180     uint8 private constant MAJOR_TYPE_ARRAY = 4;
181     uint8 private constant MAJOR_TYPE_STRING = 3;
182     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
183     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
184 
185     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
186         if (_value <= 23) {
187             _buf.append(uint8((_major << 5) | _value));
188         } else if (_value <= 0xFF) {
189             _buf.append(uint8((_major << 5) | 24));
190             _buf.appendInt(_value, 1);
191         } else if (_value <= 0xFFFF) {
192             _buf.append(uint8((_major << 5) | 25));
193             _buf.appendInt(_value, 2);
194         } else if (_value <= 0xFFFFFFFF) {
195             _buf.append(uint8((_major << 5) | 26));
196             _buf.appendInt(_value, 4);
197         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
198             _buf.append(uint8((_major << 5) | 27));
199             _buf.appendInt(_value, 8);
200         }
201     }
202 
203     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
204         _buf.append(uint8((_major << 5) | 31));
205     }
206 
207     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
208         encodeType(_buf, MAJOR_TYPE_INT, _value);
209     }
210 
211     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
212         if (_value >= 0) {
213             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
214         } else {
215             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
216         }
217     }
218 
219     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
220         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
221         _buf.append(_value);
222     }
223 
224     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
225         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
226         _buf.append(bytes(_value));
227     }
228 
229     function startArray(Buffer.buffer memory _buf) internal pure {
230         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
231     }
232 
233     function startMap(Buffer.buffer memory _buf) internal pure {
234         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
235     }
236 
237     function endSequence(Buffer.buffer memory _buf) internal pure {
238         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
239     }
240 }
241 /*
242 
243 End solidity-cborutils
244 
245 */
246 contract usingOraclize {
247 
248     using CBOR for Buffer.buffer;
249 
250     OraclizeI oraclize;
251     OraclizeAddrResolverI OAR;
252 
253     uint constant day = 60 * 60 * 24;
254     uint constant week = 60 * 60 * 24 * 7;
255     uint constant month = 60 * 60 * 24 * 30;
256 
257     byte constant proofType_NONE = 0x00;
258     byte constant proofType_Ledger = 0x30;
259     byte constant proofType_Native = 0xF0;
260     byte constant proofStorage_IPFS = 0x01;
261     byte constant proofType_Android = 0x40;
262     byte constant proofType_TLSNotary = 0x10;
263 
264     string oraclize_network_name;
265     uint8 constant networkID_auto = 0;
266     uint8 constant networkID_morden = 2;
267     uint8 constant networkID_mainnet = 1;
268     uint8 constant networkID_testnet = 2;
269     uint8 constant networkID_consensys = 161;
270 
271     mapping(bytes32 => bytes32) oraclize_randomDS_args;
272     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
273 
274     modifier oraclizeAPI {
275         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
276             oraclize_setNetwork(networkID_auto);
277         }
278         if (address(oraclize) != OAR.getAddress()) {
279             oraclize = OraclizeI(OAR.getAddress());
280         }
281         _;
282     }
283 
284     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
285         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
286         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
287         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
288         require(proofVerified);
289         _;
290     }
291 
292     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
293       return oraclize_setNetwork();
294       _networkID; // silence the warning and remain backwards compatible
295     }
296 
297     function oraclize_setNetworkName(string memory _network_name) internal {
298         oraclize_network_name = _network_name;
299     }
300 
301     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
302         return oraclize_network_name;
303     }
304 
305     function oraclize_setNetwork() internal returns (bool _networkSet) {
306         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
307             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
308             oraclize_setNetworkName("eth_mainnet");
309             return true;
310         }
311         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
312             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
313             oraclize_setNetworkName("eth_ropsten3");
314             return true;
315         }
316         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
317             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
318             oraclize_setNetworkName("eth_kovan");
319             return true;
320         }
321         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
322             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
323             oraclize_setNetworkName("eth_rinkeby");
324             return true;
325         }
326         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
327             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
328             return true;
329         }
330         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
331             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
332             return true;
333         }
334         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
335             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
336             return true;
337         }
338         return false;
339     }
340 
341     function __callback(bytes32 _myid, string memory _result) public {
342         __callback(_myid, _result, new bytes(0));
343     }
344 
345     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
346       return;
347       _myid; _result; _proof; // Silence compiler warnings
348     }
349 
350     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
351         return oraclize.getPrice(_datasource);
352     }
353 
354     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
355         return oraclize.getPrice(_datasource, _gasLimit);
356     }
357 
358     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
359         uint price = oraclize.getPrice(_datasource);
360         if (price > 1 ether + tx.gasprice * 200000) {
361             return 0; // Unexpectedly high price
362         }
363         return oraclize.query.value(price)(0, _datasource, _arg);
364     }
365 
366     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
367         uint price = oraclize.getPrice(_datasource);
368         if (price > 1 ether + tx.gasprice * 200000) {
369             return 0; // Unexpectedly high price
370         }
371         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
372     }
373 
374     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
375         uint price = oraclize.getPrice(_datasource,_gasLimit);
376         if (price > 1 ether + tx.gasprice * _gasLimit) {
377             return 0; // Unexpectedly high price
378         }
379         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
380     }
381 
382     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
383         uint price = oraclize.getPrice(_datasource, _gasLimit);
384         if (price > 1 ether + tx.gasprice * _gasLimit) {
385            return 0; // Unexpectedly high price
386         }
387         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
388     }
389 
390     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
391         uint price = oraclize.getPrice(_datasource);
392         if (price > 1 ether + tx.gasprice * 200000) {
393             return 0; // Unexpectedly high price
394         }
395         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
396     }
397 
398     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
399         uint price = oraclize.getPrice(_datasource);
400         if (price > 1 ether + tx.gasprice * 200000) {
401             return 0; // Unexpectedly high price
402         }
403         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
404     }
405 
406     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
407         uint price = oraclize.getPrice(_datasource, _gasLimit);
408         if (price > 1 ether + tx.gasprice * _gasLimit) {
409             return 0; // Unexpectedly high price
410         }
411         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
412     }
413 
414     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
415         uint price = oraclize.getPrice(_datasource, _gasLimit);
416         if (price > 1 ether + tx.gasprice * _gasLimit) {
417             return 0; // Unexpectedly high price
418         }
419         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
420     }
421 
422     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
423         uint price = oraclize.getPrice(_datasource);
424         if (price > 1 ether + tx.gasprice * 200000) {
425             return 0; // Unexpectedly high price
426         }
427         bytes memory args = stra2cbor(_argN);
428         return oraclize.queryN.value(price)(0, _datasource, args);
429     }
430 
431     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
432         uint price = oraclize.getPrice(_datasource);
433         if (price > 1 ether + tx.gasprice * 200000) {
434             return 0; // Unexpectedly high price
435         }
436         bytes memory args = stra2cbor(_argN);
437         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
438     }
439 
440     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
441         uint price = oraclize.getPrice(_datasource, _gasLimit);
442         if (price > 1 ether + tx.gasprice * _gasLimit) {
443             return 0; // Unexpectedly high price
444         }
445         bytes memory args = stra2cbor(_argN);
446         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
447     }
448 
449     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
450         uint price = oraclize.getPrice(_datasource, _gasLimit);
451         if (price > 1 ether + tx.gasprice * _gasLimit) {
452             return 0; // Unexpectedly high price
453         }
454         bytes memory args = stra2cbor(_argN);
455         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
456     }
457 
458     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
459         string[] memory dynargs = new string[](1);
460         dynargs[0] = _args[0];
461         return oraclize_query(_datasource, dynargs);
462     }
463 
464     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
465         string[] memory dynargs = new string[](1);
466         dynargs[0] = _args[0];
467         return oraclize_query(_timestamp, _datasource, dynargs);
468     }
469 
470     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
471         string[] memory dynargs = new string[](1);
472         dynargs[0] = _args[0];
473         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
474     }
475 
476     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
477         string[] memory dynargs = new string[](1);
478         dynargs[0] = _args[0];
479         return oraclize_query(_datasource, dynargs, _gasLimit);
480     }
481 
482     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
483         string[] memory dynargs = new string[](2);
484         dynargs[0] = _args[0];
485         dynargs[1] = _args[1];
486         return oraclize_query(_datasource, dynargs);
487     }
488 
489     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
490         string[] memory dynargs = new string[](2);
491         dynargs[0] = _args[0];
492         dynargs[1] = _args[1];
493         return oraclize_query(_timestamp, _datasource, dynargs);
494     }
495 
496     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
497         string[] memory dynargs = new string[](2);
498         dynargs[0] = _args[0];
499         dynargs[1] = _args[1];
500         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
501     }
502 
503     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
504         string[] memory dynargs = new string[](2);
505         dynargs[0] = _args[0];
506         dynargs[1] = _args[1];
507         return oraclize_query(_datasource, dynargs, _gasLimit);
508     }
509 
510     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
511         string[] memory dynargs = new string[](3);
512         dynargs[0] = _args[0];
513         dynargs[1] = _args[1];
514         dynargs[2] = _args[2];
515         return oraclize_query(_datasource, dynargs);
516     }
517 
518     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
519         string[] memory dynargs = new string[](3);
520         dynargs[0] = _args[0];
521         dynargs[1] = _args[1];
522         dynargs[2] = _args[2];
523         return oraclize_query(_timestamp, _datasource, dynargs);
524     }
525 
526     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
527         string[] memory dynargs = new string[](3);
528         dynargs[0] = _args[0];
529         dynargs[1] = _args[1];
530         dynargs[2] = _args[2];
531         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
532     }
533 
534     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
535         string[] memory dynargs = new string[](3);
536         dynargs[0] = _args[0];
537         dynargs[1] = _args[1];
538         dynargs[2] = _args[2];
539         return oraclize_query(_datasource, dynargs, _gasLimit);
540     }
541 
542     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
543         string[] memory dynargs = new string[](4);
544         dynargs[0] = _args[0];
545         dynargs[1] = _args[1];
546         dynargs[2] = _args[2];
547         dynargs[3] = _args[3];
548         return oraclize_query(_datasource, dynargs);
549     }
550 
551     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
552         string[] memory dynargs = new string[](4);
553         dynargs[0] = _args[0];
554         dynargs[1] = _args[1];
555         dynargs[2] = _args[2];
556         dynargs[3] = _args[3];
557         return oraclize_query(_timestamp, _datasource, dynargs);
558     }
559 
560     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
561         string[] memory dynargs = new string[](4);
562         dynargs[0] = _args[0];
563         dynargs[1] = _args[1];
564         dynargs[2] = _args[2];
565         dynargs[3] = _args[3];
566         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
567     }
568 
569     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
570         string[] memory dynargs = new string[](4);
571         dynargs[0] = _args[0];
572         dynargs[1] = _args[1];
573         dynargs[2] = _args[2];
574         dynargs[3] = _args[3];
575         return oraclize_query(_datasource, dynargs, _gasLimit);
576     }
577 
578     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
579         string[] memory dynargs = new string[](5);
580         dynargs[0] = _args[0];
581         dynargs[1] = _args[1];
582         dynargs[2] = _args[2];
583         dynargs[3] = _args[3];
584         dynargs[4] = _args[4];
585         return oraclize_query(_datasource, dynargs);
586     }
587 
588     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
589         string[] memory dynargs = new string[](5);
590         dynargs[0] = _args[0];
591         dynargs[1] = _args[1];
592         dynargs[2] = _args[2];
593         dynargs[3] = _args[3];
594         dynargs[4] = _args[4];
595         return oraclize_query(_timestamp, _datasource, dynargs);
596     }
597 
598     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
599         string[] memory dynargs = new string[](5);
600         dynargs[0] = _args[0];
601         dynargs[1] = _args[1];
602         dynargs[2] = _args[2];
603         dynargs[3] = _args[3];
604         dynargs[4] = _args[4];
605         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
606     }
607 
608     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
609         string[] memory dynargs = new string[](5);
610         dynargs[0] = _args[0];
611         dynargs[1] = _args[1];
612         dynargs[2] = _args[2];
613         dynargs[3] = _args[3];
614         dynargs[4] = _args[4];
615         return oraclize_query(_datasource, dynargs, _gasLimit);
616     }
617 
618     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
619         uint price = oraclize.getPrice(_datasource);
620         if (price > 1 ether + tx.gasprice * 200000) {
621             return 0; // Unexpectedly high price
622         }
623         bytes memory args = ba2cbor(_argN);
624         return oraclize.queryN.value(price)(0, _datasource, args);
625     }
626 
627     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
628         uint price = oraclize.getPrice(_datasource);
629         if (price > 1 ether + tx.gasprice * 200000) {
630             return 0; // Unexpectedly high price
631         }
632         bytes memory args = ba2cbor(_argN);
633         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
634     }
635 
636     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
637         uint price = oraclize.getPrice(_datasource, _gasLimit);
638         if (price > 1 ether + tx.gasprice * _gasLimit) {
639             return 0; // Unexpectedly high price
640         }
641         bytes memory args = ba2cbor(_argN);
642         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
643     }
644 
645     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
646         uint price = oraclize.getPrice(_datasource, _gasLimit);
647         if (price > 1 ether + tx.gasprice * _gasLimit) {
648             return 0; // Unexpectedly high price
649         }
650         bytes memory args = ba2cbor(_argN);
651         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
652     }
653 
654     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
655         bytes[] memory dynargs = new bytes[](1);
656         dynargs[0] = _args[0];
657         return oraclize_query(_datasource, dynargs);
658     }
659 
660     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
661         bytes[] memory dynargs = new bytes[](1);
662         dynargs[0] = _args[0];
663         return oraclize_query(_timestamp, _datasource, dynargs);
664     }
665 
666     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
667         bytes[] memory dynargs = new bytes[](1);
668         dynargs[0] = _args[0];
669         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
670     }
671 
672     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
673         bytes[] memory dynargs = new bytes[](1);
674         dynargs[0] = _args[0];
675         return oraclize_query(_datasource, dynargs, _gasLimit);
676     }
677 
678     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
679         bytes[] memory dynargs = new bytes[](2);
680         dynargs[0] = _args[0];
681         dynargs[1] = _args[1];
682         return oraclize_query(_datasource, dynargs);
683     }
684 
685     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
686         bytes[] memory dynargs = new bytes[](2);
687         dynargs[0] = _args[0];
688         dynargs[1] = _args[1];
689         return oraclize_query(_timestamp, _datasource, dynargs);
690     }
691 
692     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
693         bytes[] memory dynargs = new bytes[](2);
694         dynargs[0] = _args[0];
695         dynargs[1] = _args[1];
696         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
697     }
698 
699     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
700         bytes[] memory dynargs = new bytes[](2);
701         dynargs[0] = _args[0];
702         dynargs[1] = _args[1];
703         return oraclize_query(_datasource, dynargs, _gasLimit);
704     }
705 
706     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
707         bytes[] memory dynargs = new bytes[](3);
708         dynargs[0] = _args[0];
709         dynargs[1] = _args[1];
710         dynargs[2] = _args[2];
711         return oraclize_query(_datasource, dynargs);
712     }
713 
714     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
715         bytes[] memory dynargs = new bytes[](3);
716         dynargs[0] = _args[0];
717         dynargs[1] = _args[1];
718         dynargs[2] = _args[2];
719         return oraclize_query(_timestamp, _datasource, dynargs);
720     }
721 
722     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
723         bytes[] memory dynargs = new bytes[](3);
724         dynargs[0] = _args[0];
725         dynargs[1] = _args[1];
726         dynargs[2] = _args[2];
727         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
728     }
729 
730     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
731         bytes[] memory dynargs = new bytes[](3);
732         dynargs[0] = _args[0];
733         dynargs[1] = _args[1];
734         dynargs[2] = _args[2];
735         return oraclize_query(_datasource, dynargs, _gasLimit);
736     }
737 
738     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
739         bytes[] memory dynargs = new bytes[](4);
740         dynargs[0] = _args[0];
741         dynargs[1] = _args[1];
742         dynargs[2] = _args[2];
743         dynargs[3] = _args[3];
744         return oraclize_query(_datasource, dynargs);
745     }
746 
747     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
748         bytes[] memory dynargs = new bytes[](4);
749         dynargs[0] = _args[0];
750         dynargs[1] = _args[1];
751         dynargs[2] = _args[2];
752         dynargs[3] = _args[3];
753         return oraclize_query(_timestamp, _datasource, dynargs);
754     }
755 
756     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
757         bytes[] memory dynargs = new bytes[](4);
758         dynargs[0] = _args[0];
759         dynargs[1] = _args[1];
760         dynargs[2] = _args[2];
761         dynargs[3] = _args[3];
762         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
763     }
764 
765     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
766         bytes[] memory dynargs = new bytes[](4);
767         dynargs[0] = _args[0];
768         dynargs[1] = _args[1];
769         dynargs[2] = _args[2];
770         dynargs[3] = _args[3];
771         return oraclize_query(_datasource, dynargs, _gasLimit);
772     }
773 
774     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
775         bytes[] memory dynargs = new bytes[](5);
776         dynargs[0] = _args[0];
777         dynargs[1] = _args[1];
778         dynargs[2] = _args[2];
779         dynargs[3] = _args[3];
780         dynargs[4] = _args[4];
781         return oraclize_query(_datasource, dynargs);
782     }
783 
784     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
785         bytes[] memory dynargs = new bytes[](5);
786         dynargs[0] = _args[0];
787         dynargs[1] = _args[1];
788         dynargs[2] = _args[2];
789         dynargs[3] = _args[3];
790         dynargs[4] = _args[4];
791         return oraclize_query(_timestamp, _datasource, dynargs);
792     }
793 
794     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
795         bytes[] memory dynargs = new bytes[](5);
796         dynargs[0] = _args[0];
797         dynargs[1] = _args[1];
798         dynargs[2] = _args[2];
799         dynargs[3] = _args[3];
800         dynargs[4] = _args[4];
801         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
802     }
803 
804     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
805         bytes[] memory dynargs = new bytes[](5);
806         dynargs[0] = _args[0];
807         dynargs[1] = _args[1];
808         dynargs[2] = _args[2];
809         dynargs[3] = _args[3];
810         dynargs[4] = _args[4];
811         return oraclize_query(_datasource, dynargs, _gasLimit);
812     }
813 
814     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
815         return oraclize.setProofType(_proofP);
816     }
817 
818 
819     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
820         return oraclize.cbAddress();
821     }
822 
823     function getCodeSize(address _addr) view internal returns (uint _size) {
824         assembly {
825             _size := extcodesize(_addr)
826         }
827     }
828 
829     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
830         return oraclize.setCustomGasPrice(_gasPrice);
831     }
832 
833     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
834         return oraclize.randomDS_getSessionPubKeyHash();
835     }
836 
837     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
838         bytes memory tmp = bytes(_a);
839         uint160 iaddr = 0;
840         uint160 b1;
841         uint160 b2;
842         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
843             iaddr *= 256;
844             b1 = uint160(uint8(tmp[i]));
845             b2 = uint160(uint8(tmp[i + 1]));
846             if ((b1 >= 97) && (b1 <= 102)) {
847                 b1 -= 87;
848             } else if ((b1 >= 65) && (b1 <= 70)) {
849                 b1 -= 55;
850             } else if ((b1 >= 48) && (b1 <= 57)) {
851                 b1 -= 48;
852             }
853             if ((b2 >= 97) && (b2 <= 102)) {
854                 b2 -= 87;
855             } else if ((b2 >= 65) && (b2 <= 70)) {
856                 b2 -= 55;
857             } else if ((b2 >= 48) && (b2 <= 57)) {
858                 b2 -= 48;
859             }
860             iaddr += (b1 * 16 + b2);
861         }
862         return address(iaddr);
863     }
864 
865     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
866         bytes memory a = bytes(_a);
867         bytes memory b = bytes(_b);
868         uint minLength = a.length;
869         if (b.length < minLength) {
870             minLength = b.length;
871         }
872         for (uint i = 0; i < minLength; i ++) {
873             if (a[i] < b[i]) {
874                 return -1;
875             } else if (a[i] > b[i]) {
876                 return 1;
877             }
878         }
879         if (a.length < b.length) {
880             return -1;
881         } else if (a.length > b.length) {
882             return 1;
883         } else {
884             return 0;
885         }
886     }
887 
888     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
889         bytes memory h = bytes(_haystack);
890         bytes memory n = bytes(_needle);
891         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
892             return -1;
893         } else if (h.length > (2 ** 128 - 1)) {
894             return -1;
895         } else {
896             uint subindex = 0;
897             for (uint i = 0; i < h.length; i++) {
898                 if (h[i] == n[0]) {
899                     subindex = 1;
900                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
901                         subindex++;
902                     }
903                     if (subindex == n.length) {
904                         return int(i);
905                     }
906                 }
907             }
908             return -1;
909         }
910     }
911 
912     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
913         return strConcat(_a, _b, "", "", "");
914     }
915 
916     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
917         return strConcat(_a, _b, _c, "", "");
918     }
919 
920     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
921         return strConcat(_a, _b, _c, _d, "");
922     }
923 
924     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
925         bytes memory _ba = bytes(_a);
926         bytes memory _bb = bytes(_b);
927         bytes memory _bc = bytes(_c);
928         bytes memory _bd = bytes(_d);
929         bytes memory _be = bytes(_e);
930         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
931         bytes memory babcde = bytes(abcde);
932         uint k = 0;
933         uint i = 0;
934         for (i = 0; i < _ba.length; i++) {
935             babcde[k++] = _ba[i];
936         }
937         for (i = 0; i < _bb.length; i++) {
938             babcde[k++] = _bb[i];
939         }
940         for (i = 0; i < _bc.length; i++) {
941             babcde[k++] = _bc[i];
942         }
943         for (i = 0; i < _bd.length; i++) {
944             babcde[k++] = _bd[i];
945         }
946         for (i = 0; i < _be.length; i++) {
947             babcde[k++] = _be[i];
948         }
949         return string(babcde);
950     }
951 
952     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
953         return safeParseInt(_a, 0);
954     }
955 
956     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
957         bytes memory bresult = bytes(_a);
958         uint mint = 0;
959         bool decimals = false;
960         for (uint i = 0; i < bresult.length; i++) {
961             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
962                 if (decimals) {
963                    if (_b == 0) break;
964                     else _b--;
965                 }
966                 mint *= 10;
967                 mint += uint(uint8(bresult[i])) - 48;
968             } else if (uint(uint8(bresult[i])) == 46) {
969                 require(!decimals, 'More than one decimal encountered in string!');
970                 decimals = true;
971             } else {
972                 revert("Non-numeral character encountered in string!");
973             }
974         }
975         if (_b > 0) {
976             mint *= 10 ** _b;
977         }
978         return mint;
979     }
980 
981     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
982         return parseInt(_a, 0);
983     }
984 
985     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
986         bytes memory bresult = bytes(_a);
987         uint mint = 0;
988         bool decimals = false;
989         for (uint i = 0; i < bresult.length; i++) {
990             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
991                 if (decimals) {
992                    if (_b == 0) {
993                        break;
994                    } else {
995                        _b--;
996                    }
997                 }
998                 mint *= 10;
999                 mint += uint(uint8(bresult[i])) - 48;
1000             } else if (uint(uint8(bresult[i])) == 46) {
1001                 decimals = true;
1002             }
1003         }
1004         if (_b > 0) {
1005             mint *= 10 ** _b;
1006         }
1007         return mint;
1008     }
1009 
1010     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1011         if (_i == 0) {
1012             return "0";
1013         }
1014         uint j = _i;
1015         uint len;
1016         while (j != 0) {
1017             len++;
1018             j /= 10;
1019         }
1020         bytes memory bstr = new bytes(len);
1021         uint k = len - 1;
1022         while (_i != 0) {
1023             bstr[k--] = byte(uint8(48 + _i % 10));
1024             _i /= 10;
1025         }
1026         return string(bstr);
1027     }
1028 
1029     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1030         safeMemoryCleaner();
1031         Buffer.buffer memory buf;
1032         Buffer.init(buf, 1024);
1033         buf.startArray();
1034         for (uint i = 0; i < _arr.length; i++) {
1035             buf.encodeString(_arr[i]);
1036         }
1037         buf.endSequence();
1038         return buf.buf;
1039     }
1040 
1041     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1042         safeMemoryCleaner();
1043         Buffer.buffer memory buf;
1044         Buffer.init(buf, 1024);
1045         buf.startArray();
1046         for (uint i = 0; i < _arr.length; i++) {
1047             buf.encodeBytes(_arr[i]);
1048         }
1049         buf.endSequence();
1050         return buf.buf;
1051     }
1052 
1053     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1054         require((_nbytes > 0) && (_nbytes <= 32));
1055         _delay *= 10; // Convert from seconds to ledger timer ticks
1056         bytes memory nbytes = new bytes(1);
1057         nbytes[0] = byte(uint8(_nbytes));
1058         bytes memory unonce = new bytes(32);
1059         bytes memory sessionKeyHash = new bytes(32);
1060         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1061         assembly {
1062             mstore(unonce, 0x20)
1063             /*
1064              The following variables can be relaxed.
1065              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1066              for an idea on how to override and replace commit hash variables.
1067             */
1068             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1069             mstore(sessionKeyHash, 0x20)
1070             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1071         }
1072         bytes memory delay = new bytes(32);
1073         assembly {
1074             mstore(add(delay, 0x20), _delay)
1075         }
1076         bytes memory delay_bytes8 = new bytes(8);
1077         copyBytes(delay, 24, 8, delay_bytes8, 0);
1078         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1079         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1080         bytes memory delay_bytes8_left = new bytes(8);
1081         assembly {
1082             let x := mload(add(delay_bytes8, 0x20))
1083             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1084             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1085             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1086             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1087             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1088             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1089             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1090             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1091         }
1092         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1093         return queryId;
1094     }
1095 
1096     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1097         oraclize_randomDS_args[_queryId] = _commitment;
1098     }
1099 
1100     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1101         bool sigok;
1102         address signer;
1103         bytes32 sigr;
1104         bytes32 sigs;
1105         bytes memory sigr_ = new bytes(32);
1106         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1107         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1108         bytes memory sigs_ = new bytes(32);
1109         offset += 32 + 2;
1110         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1111         assembly {
1112             sigr := mload(add(sigr_, 32))
1113             sigs := mload(add(sigs_, 32))
1114         }
1115         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1116         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1117             return true;
1118         } else {
1119             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1120             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1121         }
1122     }
1123 
1124     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1125         bool sigok;
1126         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1127         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1128         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1129         bytes memory appkey1_pubkey = new bytes(64);
1130         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1131         bytes memory tosign2 = new bytes(1 + 65 + 32);
1132         tosign2[0] = byte(uint8(1)); //role
1133         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1134         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1135         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1136         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1137         if (!sigok) {
1138             return false;
1139         }
1140         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1141         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1142         bytes memory tosign3 = new bytes(1 + 65);
1143         tosign3[0] = 0xFE;
1144         copyBytes(_proof, 3, 65, tosign3, 1);
1145         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1146         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1147         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1148         return sigok;
1149     }
1150 
1151     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1152         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1153         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1154             return 1;
1155         }
1156         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1157         if (!proofVerified) {
1158             return 2;
1159         }
1160         return 0;
1161     }
1162 
1163     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1164         bool match_ = true;
1165         require(_prefix.length == _nRandomBytes);
1166         for (uint256 i = 0; i< _nRandomBytes; i++) {
1167             if (_content[i] != _prefix[i]) {
1168                 match_ = false;
1169             }
1170         }
1171         return match_;
1172     }
1173 
1174     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1175         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1176         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1177         bytes memory keyhash = new bytes(32);
1178         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1179         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1180             return false;
1181         }
1182         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1183         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1184         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1185         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1186             return false;
1187         }
1188         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1189         // This is to verify that the computed args match with the ones specified in the query.
1190         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1191         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1192         bytes memory sessionPubkey = new bytes(64);
1193         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1194         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1195         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1196         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1197             delete oraclize_randomDS_args[_queryId];
1198         } else return false;
1199         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1200         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1201         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1202         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1203             return false;
1204         }
1205         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1206         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1207             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1208         }
1209         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1210     }
1211     /*
1212      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1213     */
1214     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1215         uint minLength = _length + _toOffset;
1216         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1217         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1218         uint j = 32 + _toOffset;
1219         while (i < (32 + _fromOffset + _length)) {
1220             assembly {
1221                 let tmp := mload(add(_from, i))
1222                 mstore(add(_to, j), tmp)
1223             }
1224             i += 32;
1225             j += 32;
1226         }
1227         return _to;
1228     }
1229     /*
1230      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1231      Duplicate Solidity's ecrecover, but catching the CALL return value
1232     */
1233     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1234         /*
1235          We do our own memory management here. Solidity uses memory offset
1236          0x40 to store the current end of memory. We write past it (as
1237          writes are memory extensions), but don't update the offset so
1238          Solidity will reuse it. The memory used here is only needed for
1239          this context.
1240          FIXME: inline assembly can't access return values
1241         */
1242         bool ret;
1243         address addr;
1244         assembly {
1245             let size := mload(0x40)
1246             mstore(size, _hash)
1247             mstore(add(size, 32), _v)
1248             mstore(add(size, 64), _r)
1249             mstore(add(size, 96), _s)
1250             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1251             addr := mload(size)
1252         }
1253         return (ret, addr);
1254     }
1255     /*
1256      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1257     */
1258     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1259         bytes32 r;
1260         bytes32 s;
1261         uint8 v;
1262         if (_sig.length != 65) {
1263             return (false, address(0));
1264         }
1265         /*
1266          The signature format is a compact form of:
1267            {bytes32 r}{bytes32 s}{uint8 v}
1268          Compact means, uint8 is not padded to 32 bytes.
1269         */
1270         assembly {
1271             r := mload(add(_sig, 32))
1272             s := mload(add(_sig, 64))
1273             /*
1274              Here we are loading the last 32 bytes. We exploit the fact that
1275              'mload' will pad with zeroes if we overread.
1276              There is no 'mload8' to do this, but that would be nicer.
1277             */
1278             v := byte(0, mload(add(_sig, 96)))
1279             /*
1280               Alternative solution:
1281               'byte' is not working due to the Solidity parser, so lets
1282               use the second best option, 'and'
1283               v := and(mload(add(_sig, 65)), 255)
1284             */
1285         }
1286         /*
1287          albeit non-transactional signatures are not specified by the YP, one would expect it
1288          to match the YP range of [27, 28]
1289          geth uses [0, 1] and some clients have followed. This might change, see:
1290          https://github.com/ethereum/go-ethereum/issues/2053
1291         */
1292         if (v < 27) {
1293             v += 27;
1294         }
1295         if (v != 27 && v != 28) {
1296             return (false, address(0));
1297         }
1298         return safer_ecrecover(_hash, v, r, s);
1299     }
1300 
1301     function safeMemoryCleaner() internal pure {
1302         assembly {
1303             let fmem := mload(0x40)
1304             codecopy(fmem, codesize, sub(msize, fmem))
1305         }
1306     }
1307 }
1308 /*
1309 
1310 END ORACLIZE_API
1311 
1312 */
1313 
1314 
1315 contract Ownable {
1316     address public owner;
1317 
1318     constructor() public {
1319         owner = msg.sender;
1320     }
1321 
1322     modifier onlyOwner() {
1323         require(msg.sender == owner, "");
1324         _;
1325     }
1326 
1327     function transferOwnership(address newOwner) public onlyOwner {
1328         require(newOwner != address(0), "");
1329         owner = newOwner;
1330     }
1331 
1332 }
1333 
1334 library SafeMath {
1335 
1336     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1337         if (a == 0) {
1338             return 0;
1339         }
1340 
1341         uint256 c = a * b;
1342         require(c / a == b, "");
1343 
1344         return c;
1345     }
1346 
1347     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1348         require(b > 0, ""); // Solidity only automatically asserts when dividing by 0
1349         uint256 c = a / b;
1350 
1351         return c;
1352     }
1353 
1354     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1355         require(b <= a, "");
1356         uint256 c = a - b;
1357 
1358         return c;
1359     }
1360 
1361     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1362         uint256 c = a + b;
1363         require(c >= a, "");
1364 
1365         return c;
1366     }
1367 
1368     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1369         require(b != 0, "");
1370         return a % b;
1371     }
1372 }
1373 
1374 
1375 contract iJackPot {
1376     function processLottery() public payable;
1377     function getCurrentRound() public view returns (uint);
1378     function getRoundFunds(uint _round) public view returns (uint);
1379 }
1380 
1381 
1382 contract JackPotChecker is usingOraclize, Ownable {
1383     using SafeMath for uint;
1384 
1385     string public url = "json(https://api.etherscan.io/api?module=stats&action=ethprice&apikey=91DFNHV3CJDJE12PG4DD66FUZEK71TC6NW).result.ethusd";
1386 
1387     uint public superJackPotStartValue = 10**9*100; //  $ 1 000 000 000 in cents
1388     uint public jackPotStartValue = 10**6*100; //  $ 1 000 000 in cents
1389 
1390     uint public ETHInUSD;
1391     uint public CUSTOM_GASLIMIT = 350000;
1392     uint public timeout = 86400; //1 day in sec
1393 
1394     uint public lastCallbackTimestamp;
1395     uint public minTimeUpdate = 600; // 10 min in sec
1396 
1397     iJackPot public superJackPot;
1398     iJackPot public jackPot;
1399 
1400     event NewOraclizeQuery(string description);
1401     event NewPrice(uint price);
1402     event CallbackIsFailed(address lottery, bytes32 queryId);
1403     event Withdraw(address to, uint amount);
1404 
1405     constructor () public {
1406         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1407     }
1408 
1409     function () external payable {
1410 
1411     }
1412 
1413     function __callback(bytes32 _queryId, string memory _result, bytes memory _proof) public {
1414         require(msg.sender == oraclize_cbAddress());
1415         require(now > lastCallbackTimestamp + minTimeUpdate);
1416         ETHInUSD = parseInt(_result, 2);
1417         emit NewPrice(ETHInUSD);
1418         processJackPot();
1419         processSuperJackPot();
1420 
1421         lastCallbackTimestamp = now;
1422         update();
1423     }
1424 
1425     function update() public payable {
1426         require(msg.sender == oraclize_cbAddress() || msg.sender == address(owner) || msg.sender == address(superJackPot));
1427 
1428         if (oraclize_getPrice("URL", CUSTOM_GASLIMIT) > address(this).balance) {
1429             emit NewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1430         } else {
1431             emit NewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1432             oraclize_query(
1433                 timeout,
1434                 "URL",
1435                 url,
1436                 CUSTOM_GASLIMIT
1437             );
1438         }
1439     }
1440 
1441     function processJackPot() public {
1442         uint currentRound = jackPot.getCurrentRound();
1443         uint roundFunds = jackPot.getRoundFunds(currentRound);
1444 
1445         if (ETHInUSD.mul(roundFunds).div(10**18) >= jackPotStartValue) {
1446             jackPot.processLottery();
1447         }
1448     }
1449 
1450     function processSuperJackPot() public {
1451         uint currentRound = superJackPot.getCurrentRound();
1452         uint roundFunds = superJackPot.getRoundFunds(currentRound);
1453 
1454         if (ETHInUSD.mul(roundFunds).div(10**18) >= superJackPotStartValue) {
1455             superJackPot.processLottery();
1456         }
1457     }
1458 
1459     function setContracts(address _jackPot, address _superJackPot) public onlyOwner {
1460         require(_jackPot != address(0), "");
1461         require(_superJackPot != address(0), "");
1462 
1463         jackPot = iJackPot(_jackPot);
1464         superJackPot = iJackPot(_superJackPot);
1465     }
1466 
1467     function setUrl(string memory _url) public onlyOwner {
1468         url = _url;
1469     }
1470 
1471     function getPrice() public view returns (uint) {
1472         return ETHInUSD;
1473     }
1474 
1475     function setOraclizeCallbackGasLimit(uint _limit) public onlyOwner {
1476         CUSTOM_GASLIMIT = _limit;
1477     }
1478 
1479     function setOraclizeTimeout(uint _timeout) public onlyOwner {
1480         timeout = _timeout;
1481     }
1482 
1483     function withdraw(address payable _to, uint _amount) public onlyOwner {
1484         address(_to).transfer(_amount);
1485         emit Withdraw(_to, _amount);
1486     }
1487 
1488 }