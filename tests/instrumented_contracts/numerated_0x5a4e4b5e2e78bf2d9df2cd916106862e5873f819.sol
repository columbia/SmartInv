1 pragma solidity ^0.5.13;
2 
3 /* Start of the Oraclize API, search for '<ENDORACLIZE>' to get to the main contract */
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
31 pragma solidity >= 0.5.0 < 0.6.0; // Incompatible compiler version - please select a compiler within the stated pragma range, or use a different version of the oraclizeAPI!
32 
33 // Dummy contract only used to emit to end-user they are using wrong solc
34 contract solcChecker {
35 /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;
36 }
37 
38 contract OraclizeI {
39 
40 		address public cbAddress;
41 
42 		function setProofType(byte _proofType) external;
43 		function setCustomGasPrice(uint _gasPrice) external;
44 		function getPrice(string memory _datasource) public returns (uint _dsprice);
45 		function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
46 		function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
47 		function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
48 		function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
49 		function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
50 		function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
51 		function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
52 		function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
53 }
54 
55 contract OraclizeAddrResolverI {
56 		function getAddress() public returns (address _address);
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
89 		struct buffer {
90 				bytes buf;
91 				uint capacity;
92 		}
93 
94 		function init(buffer memory _buf, uint _capacity) internal pure {
95 				uint capacity = _capacity;
96 				if (capacity % 32 != 0) {
97 						capacity += 32 - (capacity % 32);
98 				}
99 				_buf.capacity = capacity; // Allocate space for the buffer data
100 				assembly {
101 						let ptr := mload(0x40)
102 						mstore(_buf, ptr)
103 						mstore(ptr, 0)
104 						mstore(0x40, add(ptr, capacity))
105 				}
106 		}
107 
108 		function resize(buffer memory _buf, uint _capacity) private pure {
109 				bytes memory oldbuf = _buf.buf;
110 				init(_buf, _capacity);
111 				append(_buf, oldbuf);
112 		}
113 
114 		function max(uint _a, uint _b) private pure returns (uint _max) {
115 				if (_a > _b) {
116 						return _a;
117 				}
118 				return _b;
119 		}
120 		/**
121 			* @dev Appends a byte array to the end of the buffer. Resizes if doing so
122 			*      would exceed the capacity of the buffer.
123 			* @param _buf The buffer to append to.
124 			* @param _data The data to append.
125 			* @return The original buffer.
126 			*
127 			*/
128 		function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
129 				if (_data.length + _buf.buf.length > _buf.capacity) {
130 						resize(_buf, max(_buf.capacity, _data.length) * 2);
131 				}
132 				uint dest;
133 				uint src;
134 				uint len = _data.length;
135 				assembly {
136 						let bufptr := mload(_buf) // Memory address of the buffer data
137 						let buflen := mload(bufptr) // Length of existing buffer data
138 						dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
139 						mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
140 						src := add(_data, 32)
141 				}
142 				for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
143 						assembly {
144 								mstore(dest, mload(src))
145 						}
146 						dest += 32;
147 						src += 32;
148 				}
149 				uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
150 				assembly {
151 						let srcpart := and(mload(src), not(mask))
152 						let destpart := and(mload(dest), mask)
153 						mstore(dest, or(destpart, srcpart))
154 				}
155 				return _buf;
156 		}
157 		/**
158 			*
159 			* @dev Appends a byte to the end of the buffer. Resizes if doing so would
160 			* exceed the capacity of the buffer.
161 			* @param _buf The buffer to append to.
162 			* @param _data The data to append.
163 			* @return The original buffer.
164 			*
165 			*/
166 		function append(buffer memory _buf, uint8 _data) internal pure {
167 				if (_buf.buf.length + 1 > _buf.capacity) {
168 						resize(_buf, _buf.capacity * 2);
169 				}
170 				assembly {
171 						let bufptr := mload(_buf) // Memory address of the buffer data
172 						let buflen := mload(bufptr) // Length of existing buffer data
173 						let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
174 						mstore8(dest, _data)
175 						mstore(bufptr, add(buflen, 1)) // Update buffer length
176 				}
177 		}
178 		/**
179 			*
180 			* @dev Appends a byte to the end of the buffer. Resizes if doing so would
181 			* exceed the capacity of the buffer.
182 			* @param _buf The buffer to append to.
183 			* @param _data The data to append.
184 			* @return The original buffer.
185 			*
186 			*/
187 		function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
188 				if (_len + _buf.buf.length > _buf.capacity) {
189 						resize(_buf, max(_buf.capacity, _len) * 2);
190 				}
191 				uint mask = 256 ** _len - 1;
192 				assembly {
193 						let bufptr := mload(_buf) // Memory address of the buffer data
194 						let buflen := mload(bufptr) // Length of existing buffer data
195 						let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
196 						mstore(dest, or(and(mload(dest), not(mask)), _data))
197 						mstore(bufptr, add(buflen, _len)) // Update buffer length
198 				}
199 				return _buf;
200 		}
201 }
202 
203 library CBOR {
204 
205 		using Buffer for Buffer.buffer;
206 
207 		uint8 private constant MAJOR_TYPE_INT = 0;
208 		uint8 private constant MAJOR_TYPE_MAP = 5;
209 		uint8 private constant MAJOR_TYPE_BYTES = 2;
210 		uint8 private constant MAJOR_TYPE_ARRAY = 4;
211 		uint8 private constant MAJOR_TYPE_STRING = 3;
212 		uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
213 		uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
214 
215 		function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
216 				if (_value <= 23) {
217 						_buf.append(uint8((_major << 5) | _value));
218 				} else if (_value <= 0xFF) {
219 						_buf.append(uint8((_major << 5) | 24));
220 						_buf.appendInt(_value, 1);
221 				} else if (_value <= 0xFFFF) {
222 						_buf.append(uint8((_major << 5) | 25));
223 						_buf.appendInt(_value, 2);
224 				} else if (_value <= 0xFFFFFFFF) {
225 						_buf.append(uint8((_major << 5) | 26));
226 						_buf.appendInt(_value, 4);
227 				} else if (_value <= 0xFFFFFFFFFFFFFFFF) {
228 						_buf.append(uint8((_major << 5) | 27));
229 						_buf.appendInt(_value, 8);
230 				}
231 		}
232 
233 		function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
234 				_buf.append(uint8((_major << 5) | 31));
235 		}
236 
237 		function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
238 				encodeType(_buf, MAJOR_TYPE_INT, _value);
239 		}
240 
241 		function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
242 				if (_value >= 0) {
243 						encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
244 				} else {
245 						encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
246 				}
247 		}
248 
249 		function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
250 				encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
251 				_buf.append(_value);
252 		}
253 
254 		function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
255 				encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
256 				_buf.append(bytes(_value));
257 		}
258 
259 		function startArray(Buffer.buffer memory _buf) internal pure {
260 				encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
261 		}
262 
263 		function startMap(Buffer.buffer memory _buf) internal pure {
264 				encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
265 		}
266 
267 		function endSequence(Buffer.buffer memory _buf) internal pure {
268 				encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
269 		}
270 }
271 /*
272 
273 End solidity-cborutils
274 
275 */
276 contract usingOraclize {
277 
278 		using CBOR for Buffer.buffer;
279 
280 		OraclizeI oraclize;
281 		OraclizeAddrResolverI OAR;
282 
283 		uint constant day = 60 * 60 * 24;
284 		uint constant week = 60 * 60 * 24 * 7;
285 		uint constant month = 60 * 60 * 24 * 30;
286 
287 		byte constant proofType_NONE = 0x00;
288 		byte constant proofType_Ledger = 0x30;
289 		byte constant proofType_Native = 0xF0;
290 		byte constant proofStorage_IPFS = 0x01;
291 		byte constant proofType_Android = 0x40;
292 		byte constant proofType_TLSNotary = 0x10;
293 
294 		string oraclize_network_name;
295 		uint8 constant networkID_auto = 0;
296 		uint8 constant networkID_morden = 2;
297 		uint8 constant networkID_mainnet = 1;
298 		uint8 constant networkID_testnet = 2;
299 		uint8 constant networkID_consensys = 161;
300 
301 		mapping(bytes32 => bytes32) oraclize_randomDS_args;
302 		mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
303 
304 		modifier oraclizeAPI {
305 				if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
306 						oraclize_setNetwork(networkID_auto);
307 				}
308 				if (address(oraclize) != OAR.getAddress()) {
309 						oraclize = OraclizeI(OAR.getAddress());
310 				}
311 				_;
312 		}
313 
314 		modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
315 				// RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
316 				require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
317 				bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
318 				require(proofVerified);
319 				_;
320 		}
321 
322 		function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
323 			_networkID; // NOTE: Silence the warning and remain backwards compatible
324 			return oraclize_setNetwork();
325 		}
326 
327 		function oraclize_setNetworkName(string memory _network_name) internal {
328 				oraclize_network_name = _network_name;
329 		}
330 
331 		function oraclize_getNetworkName() internal view returns (string memory _networkName) {
332 				return oraclize_network_name;
333 		}
334 
335 		function oraclize_setNetwork() internal returns (bool _networkSet) {
336 				if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
337 						OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
338 						oraclize_setNetworkName("eth_mainnet");
339 						return true;
340 				}
341 				if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
342 						OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
343 						oraclize_setNetworkName("eth_ropsten3");
344 						return true;
345 				}
346 				if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
347 						OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
348 						oraclize_setNetworkName("eth_kovan");
349 						return true;
350 				}
351 				if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
352 						OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
353 						oraclize_setNetworkName("eth_rinkeby");
354 						return true;
355 				}
356 				if (getCodeSize(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41) > 0) { //goerli testnet
357 						OAR = OraclizeAddrResolverI(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41);
358 						oraclize_setNetworkName("eth_goerli");
359 						return true;
360 				}
361 				if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
362 						OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
363 						return true;
364 				}
365 				if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
366 						OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
367 						return true;
368 				}
369 				if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
370 						OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
371 						return true;
372 				}
373 				return false;
374 		}
375 		/**
376 		 * @dev The following `__callback` functions are just placeholders ideally
377 		 *      meant to be defined in child contract when proofs are used.
378 		 *      The function bodies simply silence compiler warnings.
379 		 */
380 		function __callback(bytes32 _myid, string memory _result) public {
381 				__callback(_myid, _result, new bytes(0));
382 		}
383 
384 		function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
385 			_myid; _result; _proof;
386 			oraclize_randomDS_args[bytes32(0)] = bytes32(0);
387 		}
388 
389 		function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
390 				return oraclize.getPrice(_datasource);
391 		}
392 
393 		function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
394 				return oraclize.getPrice(_datasource, _gasLimit);
395 		}
396 
397 		function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
398 				uint price = oraclize.getPrice(_datasource);
399 				if (price > 1 ether + tx.gasprice * 200000) {
400 						return 0; // Unexpectedly high price
401 				}
402 				return oraclize.query.value(price)(0, _datasource, _arg);
403 		}
404 
405 		function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
406 				uint price = oraclize.getPrice(_datasource);
407 				if (price > 1 ether + tx.gasprice * 200000) {
408 						return 0; // Unexpectedly high price
409 				}
410 				return oraclize.query.value(price)(_timestamp, _datasource, _arg);
411 		}
412 
413 		function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
414 				uint price = oraclize.getPrice(_datasource,_gasLimit);
415 				if (price > 1 ether + tx.gasprice * _gasLimit) {
416 						return 0; // Unexpectedly high price
417 				}
418 				return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
419 		}
420 
421 		function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
422 				uint price = oraclize.getPrice(_datasource, _gasLimit);
423 				if (price > 1 ether + tx.gasprice * _gasLimit) {
424 					 return 0; // Unexpectedly high price
425 				}
426 				return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
427 		}
428 
429 		function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
430 				uint price = oraclize.getPrice(_datasource);
431 				if (price > 1 ether + tx.gasprice * 200000) {
432 						return 0; // Unexpectedly high price
433 				}
434 				return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
435 		}
436 
437 		function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
438 				uint price = oraclize.getPrice(_datasource);
439 				if (price > 1 ether + tx.gasprice * 200000) {
440 						return 0; // Unexpectedly high price
441 				}
442 				return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
443 		}
444 
445 		function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
446 				uint price = oraclize.getPrice(_datasource, _gasLimit);
447 				if (price > 1 ether + tx.gasprice * _gasLimit) {
448 						return 0; // Unexpectedly high price
449 				}
450 				return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
451 		}
452 
453 		function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
454 				uint price = oraclize.getPrice(_datasource, _gasLimit);
455 				if (price > 1 ether + tx.gasprice * _gasLimit) {
456 						return 0; // Unexpectedly high price
457 				}
458 				return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
459 		}
460 
461 		function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
462 				uint price = oraclize.getPrice(_datasource);
463 				if (price > 1 ether + tx.gasprice * 200000) {
464 						return 0; // Unexpectedly high price
465 				}
466 				bytes memory args = stra2cbor(_argN);
467 				return oraclize.queryN.value(price)(0, _datasource, args);
468 		}
469 
470 		function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
471 				uint price = oraclize.getPrice(_datasource);
472 				if (price > 1 ether + tx.gasprice * 200000) {
473 						return 0; // Unexpectedly high price
474 				}
475 				bytes memory args = stra2cbor(_argN);
476 				return oraclize.queryN.value(price)(_timestamp, _datasource, args);
477 		}
478 
479 		function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
480 				uint price = oraclize.getPrice(_datasource, _gasLimit);
481 				if (price > 1 ether + tx.gasprice * _gasLimit) {
482 						return 0; // Unexpectedly high price
483 				}
484 				bytes memory args = stra2cbor(_argN);
485 				return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
486 		}
487 
488 		function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
489 				uint price = oraclize.getPrice(_datasource, _gasLimit);
490 				if (price > 1 ether + tx.gasprice * _gasLimit) {
491 						return 0; // Unexpectedly high price
492 				}
493 				bytes memory args = stra2cbor(_argN);
494 				return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
495 		}
496 
497 		function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
498 				string[] memory dynargs = new string[](1);
499 				dynargs[0] = _args[0];
500 				return oraclize_query(_datasource, dynargs);
501 		}
502 
503 		function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
504 				string[] memory dynargs = new string[](1);
505 				dynargs[0] = _args[0];
506 				return oraclize_query(_timestamp, _datasource, dynargs);
507 		}
508 
509 		function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
510 				string[] memory dynargs = new string[](1);
511 				dynargs[0] = _args[0];
512 				return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
513 		}
514 
515 		function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
516 				string[] memory dynargs = new string[](1);
517 				dynargs[0] = _args[0];
518 				return oraclize_query(_datasource, dynargs, _gasLimit);
519 		}
520 
521 		function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
522 				string[] memory dynargs = new string[](2);
523 				dynargs[0] = _args[0];
524 				dynargs[1] = _args[1];
525 				return oraclize_query(_datasource, dynargs);
526 		}
527 
528 		function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
529 				string[] memory dynargs = new string[](2);
530 				dynargs[0] = _args[0];
531 				dynargs[1] = _args[1];
532 				return oraclize_query(_timestamp, _datasource, dynargs);
533 		}
534 
535 		function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
536 				string[] memory dynargs = new string[](2);
537 				dynargs[0] = _args[0];
538 				dynargs[1] = _args[1];
539 				return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
540 		}
541 
542 		function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
543 				string[] memory dynargs = new string[](2);
544 				dynargs[0] = _args[0];
545 				dynargs[1] = _args[1];
546 				return oraclize_query(_datasource, dynargs, _gasLimit);
547 		}
548 
549 		function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
550 				string[] memory dynargs = new string[](3);
551 				dynargs[0] = _args[0];
552 				dynargs[1] = _args[1];
553 				dynargs[2] = _args[2];
554 				return oraclize_query(_datasource, dynargs);
555 		}
556 
557 		function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
558 				string[] memory dynargs = new string[](3);
559 				dynargs[0] = _args[0];
560 				dynargs[1] = _args[1];
561 				dynargs[2] = _args[2];
562 				return oraclize_query(_timestamp, _datasource, dynargs);
563 		}
564 
565 		function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
566 				string[] memory dynargs = new string[](3);
567 				dynargs[0] = _args[0];
568 				dynargs[1] = _args[1];
569 				dynargs[2] = _args[2];
570 				return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
571 		}
572 
573 		function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
574 				string[] memory dynargs = new string[](3);
575 				dynargs[0] = _args[0];
576 				dynargs[1] = _args[1];
577 				dynargs[2] = _args[2];
578 				return oraclize_query(_datasource, dynargs, _gasLimit);
579 		}
580 
581 		function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
582 				string[] memory dynargs = new string[](4);
583 				dynargs[0] = _args[0];
584 				dynargs[1] = _args[1];
585 				dynargs[2] = _args[2];
586 				dynargs[3] = _args[3];
587 				return oraclize_query(_datasource, dynargs);
588 		}
589 
590 		function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
591 				string[] memory dynargs = new string[](4);
592 				dynargs[0] = _args[0];
593 				dynargs[1] = _args[1];
594 				dynargs[2] = _args[2];
595 				dynargs[3] = _args[3];
596 				return oraclize_query(_timestamp, _datasource, dynargs);
597 		}
598 
599 		function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
600 				string[] memory dynargs = new string[](4);
601 				dynargs[0] = _args[0];
602 				dynargs[1] = _args[1];
603 				dynargs[2] = _args[2];
604 				dynargs[3] = _args[3];
605 				return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
606 		}
607 
608 		function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
609 				string[] memory dynargs = new string[](4);
610 				dynargs[0] = _args[0];
611 				dynargs[1] = _args[1];
612 				dynargs[2] = _args[2];
613 				dynargs[3] = _args[3];
614 				return oraclize_query(_datasource, dynargs, _gasLimit);
615 		}
616 
617 		function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
618 				string[] memory dynargs = new string[](5);
619 				dynargs[0] = _args[0];
620 				dynargs[1] = _args[1];
621 				dynargs[2] = _args[2];
622 				dynargs[3] = _args[3];
623 				dynargs[4] = _args[4];
624 				return oraclize_query(_datasource, dynargs);
625 		}
626 
627 		function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
628 				string[] memory dynargs = new string[](5);
629 				dynargs[0] = _args[0];
630 				dynargs[1] = _args[1];
631 				dynargs[2] = _args[2];
632 				dynargs[3] = _args[3];
633 				dynargs[4] = _args[4];
634 				return oraclize_query(_timestamp, _datasource, dynargs);
635 		}
636 
637 		function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
638 				string[] memory dynargs = new string[](5);
639 				dynargs[0] = _args[0];
640 				dynargs[1] = _args[1];
641 				dynargs[2] = _args[2];
642 				dynargs[3] = _args[3];
643 				dynargs[4] = _args[4];
644 				return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
645 		}
646 
647 		function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
648 				string[] memory dynargs = new string[](5);
649 				dynargs[0] = _args[0];
650 				dynargs[1] = _args[1];
651 				dynargs[2] = _args[2];
652 				dynargs[3] = _args[3];
653 				dynargs[4] = _args[4];
654 				return oraclize_query(_datasource, dynargs, _gasLimit);
655 		}
656 
657 		function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
658 				uint price = oraclize.getPrice(_datasource);
659 				if (price > 1 ether + tx.gasprice * 200000) {
660 						return 0; // Unexpectedly high price
661 				}
662 				bytes memory args = ba2cbor(_argN);
663 				return oraclize.queryN.value(price)(0, _datasource, args);
664 		}
665 
666 		function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
667 				uint price = oraclize.getPrice(_datasource);
668 				if (price > 1 ether + tx.gasprice * 200000) {
669 						return 0; // Unexpectedly high price
670 				}
671 				bytes memory args = ba2cbor(_argN);
672 				return oraclize.queryN.value(price)(_timestamp, _datasource, args);
673 		}
674 
675 		function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
676 				uint price = oraclize.getPrice(_datasource, _gasLimit);
677 				if (price > 1 ether + tx.gasprice * _gasLimit) {
678 						return 0; // Unexpectedly high price
679 				}
680 				bytes memory args = ba2cbor(_argN);
681 				return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
682 		}
683 
684 		function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
685 				uint price = oraclize.getPrice(_datasource, _gasLimit);
686 				if (price > 1 ether + tx.gasprice * _gasLimit) {
687 						return 0; // Unexpectedly high price
688 				}
689 				bytes memory args = ba2cbor(_argN);
690 				return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
691 		}
692 
693 		function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
694 				bytes[] memory dynargs = new bytes[](1);
695 				dynargs[0] = _args[0];
696 				return oraclize_query(_datasource, dynargs);
697 		}
698 
699 		function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
700 				bytes[] memory dynargs = new bytes[](1);
701 				dynargs[0] = _args[0];
702 				return oraclize_query(_timestamp, _datasource, dynargs);
703 		}
704 
705 		function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
706 				bytes[] memory dynargs = new bytes[](1);
707 				dynargs[0] = _args[0];
708 				return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
709 		}
710 
711 		function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
712 				bytes[] memory dynargs = new bytes[](1);
713 				dynargs[0] = _args[0];
714 				return oraclize_query(_datasource, dynargs, _gasLimit);
715 		}
716 
717 		function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
718 				bytes[] memory dynargs = new bytes[](2);
719 				dynargs[0] = _args[0];
720 				dynargs[1] = _args[1];
721 				return oraclize_query(_datasource, dynargs);
722 		}
723 
724 		function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
725 				bytes[] memory dynargs = new bytes[](2);
726 				dynargs[0] = _args[0];
727 				dynargs[1] = _args[1];
728 				return oraclize_query(_timestamp, _datasource, dynargs);
729 		}
730 
731 		function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
732 				bytes[] memory dynargs = new bytes[](2);
733 				dynargs[0] = _args[0];
734 				dynargs[1] = _args[1];
735 				return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
736 		}
737 
738 		function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
739 				bytes[] memory dynargs = new bytes[](2);
740 				dynargs[0] = _args[0];
741 				dynargs[1] = _args[1];
742 				return oraclize_query(_datasource, dynargs, _gasLimit);
743 		}
744 
745 		function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
746 				bytes[] memory dynargs = new bytes[](3);
747 				dynargs[0] = _args[0];
748 				dynargs[1] = _args[1];
749 				dynargs[2] = _args[2];
750 				return oraclize_query(_datasource, dynargs);
751 		}
752 
753 		function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
754 				bytes[] memory dynargs = new bytes[](3);
755 				dynargs[0] = _args[0];
756 				dynargs[1] = _args[1];
757 				dynargs[2] = _args[2];
758 				return oraclize_query(_timestamp, _datasource, dynargs);
759 		}
760 
761 		function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
762 				bytes[] memory dynargs = new bytes[](3);
763 				dynargs[0] = _args[0];
764 				dynargs[1] = _args[1];
765 				dynargs[2] = _args[2];
766 				return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
767 		}
768 
769 		function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
770 				bytes[] memory dynargs = new bytes[](3);
771 				dynargs[0] = _args[0];
772 				dynargs[1] = _args[1];
773 				dynargs[2] = _args[2];
774 				return oraclize_query(_datasource, dynargs, _gasLimit);
775 		}
776 
777 		function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
778 				bytes[] memory dynargs = new bytes[](4);
779 				dynargs[0] = _args[0];
780 				dynargs[1] = _args[1];
781 				dynargs[2] = _args[2];
782 				dynargs[3] = _args[3];
783 				return oraclize_query(_datasource, dynargs);
784 		}
785 
786 		function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
787 				bytes[] memory dynargs = new bytes[](4);
788 				dynargs[0] = _args[0];
789 				dynargs[1] = _args[1];
790 				dynargs[2] = _args[2];
791 				dynargs[3] = _args[3];
792 				return oraclize_query(_timestamp, _datasource, dynargs);
793 		}
794 
795 		function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
796 				bytes[] memory dynargs = new bytes[](4);
797 				dynargs[0] = _args[0];
798 				dynargs[1] = _args[1];
799 				dynargs[2] = _args[2];
800 				dynargs[3] = _args[3];
801 				return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
802 		}
803 
804 		function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
805 				bytes[] memory dynargs = new bytes[](4);
806 				dynargs[0] = _args[0];
807 				dynargs[1] = _args[1];
808 				dynargs[2] = _args[2];
809 				dynargs[3] = _args[3];
810 				return oraclize_query(_datasource, dynargs, _gasLimit);
811 		}
812 
813 		function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
814 				bytes[] memory dynargs = new bytes[](5);
815 				dynargs[0] = _args[0];
816 				dynargs[1] = _args[1];
817 				dynargs[2] = _args[2];
818 				dynargs[3] = _args[3];
819 				dynargs[4] = _args[4];
820 				return oraclize_query(_datasource, dynargs);
821 		}
822 
823 		function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
824 				bytes[] memory dynargs = new bytes[](5);
825 				dynargs[0] = _args[0];
826 				dynargs[1] = _args[1];
827 				dynargs[2] = _args[2];
828 				dynargs[3] = _args[3];
829 				dynargs[4] = _args[4];
830 				return oraclize_query(_timestamp, _datasource, dynargs);
831 		}
832 
833 		function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
834 				bytes[] memory dynargs = new bytes[](5);
835 				dynargs[0] = _args[0];
836 				dynargs[1] = _args[1];
837 				dynargs[2] = _args[2];
838 				dynargs[3] = _args[3];
839 				dynargs[4] = _args[4];
840 				return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
841 		}
842 
843 		function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
844 				bytes[] memory dynargs = new bytes[](5);
845 				dynargs[0] = _args[0];
846 				dynargs[1] = _args[1];
847 				dynargs[2] = _args[2];
848 				dynargs[3] = _args[3];
849 				dynargs[4] = _args[4];
850 				return oraclize_query(_datasource, dynargs, _gasLimit);
851 		}
852 
853 		function oraclize_setProof(byte _proofP) oraclizeAPI internal {
854 				return oraclize.setProofType(_proofP);
855 		}
856 
857 
858 		function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
859 				return oraclize.cbAddress();
860 		}
861 
862 		function getCodeSize(address _addr) view internal returns (uint _size) {
863 				assembly {
864 						_size := extcodesize(_addr)
865 				}
866 		}
867 
868 		function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
869 				return oraclize.setCustomGasPrice(_gasPrice);
870 		}
871 
872 		function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
873 				return oraclize.randomDS_getSessionPubKeyHash();
874 		}
875 
876 		function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
877 				bytes memory tmp = bytes(_a);
878 				uint160 iaddr = 0;
879 				uint160 b1;
880 				uint160 b2;
881 				for (uint i = 2; i < 2 + 2 * 20; i += 2) {
882 						iaddr *= 256;
883 						b1 = uint160(uint8(tmp[i]));
884 						b2 = uint160(uint8(tmp[i + 1]));
885 						if ((b1 >= 97) && (b1 <= 102)) {
886 								b1 -= 87;
887 						} else if ((b1 >= 65) && (b1 <= 70)) {
888 								b1 -= 55;
889 						} else if ((b1 >= 48) && (b1 <= 57)) {
890 								b1 -= 48;
891 						}
892 						if ((b2 >= 97) && (b2 <= 102)) {
893 								b2 -= 87;
894 						} else if ((b2 >= 65) && (b2 <= 70)) {
895 								b2 -= 55;
896 						} else if ((b2 >= 48) && (b2 <= 57)) {
897 								b2 -= 48;
898 						}
899 						iaddr += (b1 * 16 + b2);
900 				}
901 				return address(iaddr);
902 		}
903 
904 		function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
905 				bytes memory a = bytes(_a);
906 				bytes memory b = bytes(_b);
907 				uint minLength = a.length;
908 				if (b.length < minLength) {
909 						minLength = b.length;
910 				}
911 				for (uint i = 0; i < minLength; i ++) {
912 						if (a[i] < b[i]) {
913 								return -1;
914 						} else if (a[i] > b[i]) {
915 								return 1;
916 						}
917 				}
918 				if (a.length < b.length) {
919 						return -1;
920 				} else if (a.length > b.length) {
921 						return 1;
922 				} else {
923 						return 0;
924 				}
925 		}
926 
927 		function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
928 				bytes memory h = bytes(_haystack);
929 				bytes memory n = bytes(_needle);
930 				if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
931 						return -1;
932 				} else if (h.length > (2 ** 128 - 1)) {
933 						return -1;
934 				} else {
935 						uint subindex = 0;
936 						for (uint i = 0; i < h.length; i++) {
937 								if (h[i] == n[0]) {
938 										subindex = 1;
939 										while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
940 												subindex++;
941 										}
942 										if (subindex == n.length) {
943 												return int(i);
944 										}
945 								}
946 						}
947 						return -1;
948 				}
949 		}
950 
951 		function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
952 				return strConcat(_a, _b, "", "", "");
953 		}
954 
955 		function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
956 				return strConcat(_a, _b, _c, "", "");
957 		}
958 
959 		function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
960 				return strConcat(_a, _b, _c, _d, "");
961 		}
962 
963 		function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
964 				bytes memory _ba = bytes(_a);
965 				bytes memory _bb = bytes(_b);
966 				bytes memory _bc = bytes(_c);
967 				bytes memory _bd = bytes(_d);
968 				bytes memory _be = bytes(_e);
969 				string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
970 				bytes memory babcde = bytes(abcde);
971 				uint k = 0;
972 				uint i = 0;
973 				for (i = 0; i < _ba.length; i++) {
974 						babcde[k++] = _ba[i];
975 				}
976 				for (i = 0; i < _bb.length; i++) {
977 						babcde[k++] = _bb[i];
978 				}
979 				for (i = 0; i < _bc.length; i++) {
980 						babcde[k++] = _bc[i];
981 				}
982 				for (i = 0; i < _bd.length; i++) {
983 						babcde[k++] = _bd[i];
984 				}
985 				for (i = 0; i < _be.length; i++) {
986 						babcde[k++] = _be[i];
987 				}
988 				return string(babcde);
989 		}
990 
991 		function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
992 				return safeParseInt(_a, 0);
993 		}
994 
995 		function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
996 				bytes memory bresult = bytes(_a);
997 				uint mint = 0;
998 				bool decimals = false;
999 				for (uint i = 0; i < bresult.length; i++) {
1000 						if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1001 								if (decimals) {
1002 									 if (_b == 0) break;
1003 										else _b--;
1004 								}
1005 								mint *= 10;
1006 								mint += uint(uint8(bresult[i])) - 48;
1007 						} else if (uint(uint8(bresult[i])) == 46) {
1008 								require(!decimals, 'More than one decimal encountered in string!');
1009 								decimals = true;
1010 						} else {
1011 								revert("Non-numeral character encountered in string!");
1012 						}
1013 				}
1014 				if (_b > 0) {
1015 						mint *= 10 ** _b;
1016 				}
1017 				return mint;
1018 		}
1019 
1020 		function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
1021 				return parseInt(_a, 0);
1022 		}
1023 
1024 		function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1025 				bytes memory bresult = bytes(_a);
1026 				uint mint = 0;
1027 				bool decimals = false;
1028 				for (uint i = 0; i < bresult.length; i++) {
1029 						if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1030 								if (decimals) {
1031 									 if (_b == 0) {
1032 											 break;
1033 									 } else {
1034 											 _b--;
1035 									 }
1036 								}
1037 								mint *= 10;
1038 								mint += uint(uint8(bresult[i])) - 48;
1039 						} else if (uint(uint8(bresult[i])) == 46) {
1040 								decimals = true;
1041 						}
1042 				}
1043 				if (_b > 0) {
1044 						mint *= 10 ** _b;
1045 				}
1046 				return mint;
1047 		}
1048 
1049 		function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1050 				if (_i == 0) {
1051 						return "0";
1052 				}
1053 				uint j = _i;
1054 				uint len;
1055 				while (j != 0) {
1056 						len++;
1057 						j /= 10;
1058 				}
1059 				bytes memory bstr = new bytes(len);
1060 				uint k = len - 1;
1061 				while (_i != 0) {
1062 						bstr[k--] = byte(uint8(48 + _i % 10));
1063 						_i /= 10;
1064 				}
1065 				return string(bstr);
1066 		}
1067 
1068 		function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1069 				safeMemoryCleaner();
1070 				Buffer.buffer memory buf;
1071 				Buffer.init(buf, 1024);
1072 				buf.startArray();
1073 				for (uint i = 0; i < _arr.length; i++) {
1074 						buf.encodeString(_arr[i]);
1075 				}
1076 				buf.endSequence();
1077 				return buf.buf;
1078 		}
1079 
1080 		function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1081 				safeMemoryCleaner();
1082 				Buffer.buffer memory buf;
1083 				Buffer.init(buf, 1024);
1084 				buf.startArray();
1085 				for (uint i = 0; i < _arr.length; i++) {
1086 						buf.encodeBytes(_arr[i]);
1087 				}
1088 				buf.endSequence();
1089 				return buf.buf;
1090 		}
1091 
1092 		function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1093 				require((_nbytes > 0) && (_nbytes <= 32));
1094 				_delay *= 10; // Convert from seconds to ledger timer ticks
1095 				bytes memory nbytes = new bytes(1);
1096 				nbytes[0] = byte(uint8(_nbytes));
1097 				bytes memory unonce = new bytes(32);
1098 				bytes memory sessionKeyHash = new bytes(32);
1099 				bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1100 				assembly {
1101 						mstore(unonce, 0x20)
1102 						/*
1103 						 The following variables can be relaxed.
1104 						 Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1105 						 for an idea on how to override and replace commit hash variables.
1106 						*/
1107 						mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1108 						mstore(sessionKeyHash, 0x20)
1109 						mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1110 				}
1111 				bytes memory delay = new bytes(32);
1112 				assembly {
1113 						mstore(add(delay, 0x20), _delay)
1114 				}
1115 				bytes memory delay_bytes8 = new bytes(8);
1116 				copyBytes(delay, 24, 8, delay_bytes8, 0);
1117 				bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1118 				bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1119 				bytes memory delay_bytes8_left = new bytes(8);
1120 				assembly {
1121 						let x := mload(add(delay_bytes8, 0x20))
1122 						mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1123 						mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1124 						mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1125 						mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1126 						mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1127 						mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1128 						mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1129 						mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1130 				}
1131 				oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1132 				return queryId;
1133 		}
1134 
1135 		function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1136 				oraclize_randomDS_args[_queryId] = _commitment;
1137 		}
1138 
1139 		function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1140 				bool sigok;
1141 				address signer;
1142 				bytes32 sigr;
1143 				bytes32 sigs;
1144 				bytes memory sigr_ = new bytes(32);
1145 				uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1146 				sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1147 				bytes memory sigs_ = new bytes(32);
1148 				offset += 32 + 2;
1149 				sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1150 				assembly {
1151 						sigr := mload(add(sigr_, 32))
1152 						sigs := mload(add(sigs_, 32))
1153 				}
1154 				(sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1155 				if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1156 						return true;
1157 				} else {
1158 						(sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1159 						return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1160 				}
1161 		}
1162 
1163 		function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1164 				bool sigok;
1165 				// Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1166 				bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1167 				copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1168 				bytes memory appkey1_pubkey = new bytes(64);
1169 				copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1170 				bytes memory tosign2 = new bytes(1 + 65 + 32);
1171 				tosign2[0] = byte(uint8(1)); //role
1172 				copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1173 				bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1174 				copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1175 				sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1176 				if (!sigok) {
1177 						return false;
1178 				}
1179 				// Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1180 				bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1181 				bytes memory tosign3 = new bytes(1 + 65);
1182 				tosign3[0] = 0xFE;
1183 				copyBytes(_proof, 3, 65, tosign3, 1);
1184 				bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1185 				copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1186 				sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1187 				return sigok;
1188 		}
1189 
1190 		function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1191 				// Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1192 				if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1193 						return 1;
1194 				}
1195 				bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1196 				if (!proofVerified) {
1197 						return 2;
1198 				}
1199 				return 0;
1200 		}
1201 
1202 		function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1203 				bool match_ = true;
1204 				require(_prefix.length == _nRandomBytes);
1205 				for (uint256 i = 0; i< _nRandomBytes; i++) {
1206 						if (_content[i] != _prefix[i]) {
1207 								match_ = false;
1208 						}
1209 				}
1210 				return match_;
1211 		}
1212 
1213 		function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1214 				// Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1215 				uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1216 				bytes memory keyhash = new bytes(32);
1217 				copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1218 				if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1219 						return false;
1220 				}
1221 				bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1222 				copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1223 				// Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1224 				if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1225 						return false;
1226 				}
1227 				// Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1228 				// This is to verify that the computed args match with the ones specified in the query.
1229 				bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1230 				copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1231 				bytes memory sessionPubkey = new bytes(64);
1232 				uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1233 				copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1234 				bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1235 				if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1236 						delete oraclize_randomDS_args[_queryId];
1237 				} else return false;
1238 				// Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1239 				bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1240 				copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1241 				if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1242 						return false;
1243 				}
1244 				// Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1245 				if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1246 						oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1247 				}
1248 				return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1249 		}
1250 		/*
1251 		 The following function has been written by Alex Beregszaszi, use it under the terms of the MIT license
1252 		*/
1253 		function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1254 				uint minLength = _length + _toOffset;
1255 				require(_to.length >= minLength); // Buffer too small. Should be a better way?
1256 				uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1257 				uint j = 32 + _toOffset;
1258 				while (i < (32 + _fromOffset + _length)) {
1259 						assembly {
1260 								let tmp := mload(add(_from, i))
1261 								mstore(add(_to, j), tmp)
1262 						}
1263 						i += 32;
1264 						j += 32;
1265 				}
1266 				return _to;
1267 		}
1268 		/*
1269 		 The following function has been written by Alex Beregszaszi, use it under the terms of the MIT license
1270 		 Duplicate Solidity's ecrecover, but catching the CALL return value
1271 		*/
1272 		function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1273 				/*
1274 				 We do our own memory management here. Solidity uses memory offset
1275 				 0x40 to store the current end of memory. We write past it (as
1276 				 writes are memory extensions), but don't update the offset so
1277 				 Solidity will reuse it. The memory used here is only needed for
1278 				 this context.
1279 				 FIXME: inline assembly can't access return values
1280 				*/
1281 				bool ret;
1282 				address addr;
1283 				assembly {
1284 						let size := mload(0x40)
1285 						mstore(size, _hash)
1286 						mstore(add(size, 32), _v)
1287 						mstore(add(size, 64), _r)
1288 						mstore(add(size, 96), _s)
1289 						ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1290 						addr := mload(size)
1291 				}
1292 				return (ret, addr);
1293 		}
1294 		/*
1295 		 The following function has been written by Alex Beregszaszi, use it under the terms of the MIT license
1296 		*/
1297 		function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1298 				bytes32 r;
1299 				bytes32 s;
1300 				uint8 v;
1301 				if (_sig.length != 65) {
1302 						return (false, address(0));
1303 				}
1304 				/*
1305 				 The signature format is a compact form of:
1306 					 {bytes32 r}{bytes32 s}{uint8 v}
1307 				 Compact means, uint8 is not padded to 32 bytes.
1308 				*/
1309 				assembly {
1310 						r := mload(add(_sig, 32))
1311 						s := mload(add(_sig, 64))
1312 						/*
1313 						 Here we are loading the last 32 bytes. We exploit the fact that
1314 						 'mload' will pad with zeroes if we overread.
1315 						 There is no 'mload8' to do this, but that would be nicer.
1316 						*/
1317 						v := byte(0, mload(add(_sig, 96)))
1318 						/*
1319 							Alternative solution:
1320 							'byte' is not working due to the Solidity parser, so lets
1321 							use the second best option, 'and'
1322 							v := and(mload(add(_sig, 65)), 255)
1323 						*/
1324 				}
1325 				/*
1326 				 albeit non-transactional signatures are not specified by the YP, one would expect it
1327 				 to match the YP range of [27, 28]
1328 				 geth uses [0, 1] and some clients have followed. This might change, see:
1329 				 https://github.com/ethereum/go-ethereum/issues/2053
1330 				*/
1331 				if (v < 27) {
1332 						v += 27;
1333 				}
1334 				if (v != 27 && v != 28) {
1335 						return (false, address(0));
1336 				}
1337 				return safer_ecrecover(_hash, v, r, s);
1338 		}
1339 
1340 		function safeMemoryCleaner() internal pure {
1341 				assembly {
1342 						let fmem := mload(0x40)
1343 						codecopy(fmem, codesize, sub(msize, fmem))
1344 				}
1345 		}
1346 }
1347 /*
1348 
1349 END ORACLIZE_API
1350 
1351 */
1352 
1353 /**************************************************************/
1354 /* <ENDORACLIZE> */
1355 
1356 
1357 interface Caller {
1358 	function randomCallback(bytes32 _queryId, bytes32 _randomData) external;
1359 	function modulusCallback(bytes32 _queryId, uint256 _resolution, uint256 _result) external;
1360 	function seriesCallback(bytes32 _queryId, uint256 _resolution, uint256[] calldata _results) external;
1361 	function queryFailed(bytes32 _queryId) external;
1362 }
1363 
1364 contract RNGOracle is usingOraclize {
1365 
1366 	uint256 constant private UINT256_MAX = uint256(-1);
1367 	uint256 constant private FLOAT_SCALAR = 2**64;
1368 
1369 	mapping(address => uint256) public queryWallet;
1370 
1371 	enum RequestType {
1372 		RANDOM,
1373 		MODULUS,
1374 		SERIES
1375 	}
1376 
1377 	struct RequestInfo {
1378 		bytes32 seed;
1379 		Caller caller;
1380 		uint32 placedBlockNumber;
1381 		RequestType requestType;
1382 		uint32 requestIndex;
1383 	}
1384 	mapping(bytes32 => RequestInfo) private requestMap;
1385 
1386 	struct ModulusInfo {
1387 		uint256 modulus;
1388 		uint256 betmask;
1389 	}
1390 	ModulusInfo[] private modulusInfo;
1391 
1392 	struct SeriesInfo {
1393 		uint128 seriesIndex;
1394 		uint128 runs;
1395 	}
1396 	SeriesInfo[] private seriesInfo;
1397 
1398 	struct Series {
1399 		uint256 sum;
1400 		uint256 maxRuns;
1401 		uint256[] series;
1402 		uint256[] cumulativeSum;
1403 		uint256[] resolutions;
1404 	}
1405 	Series[] private series;
1406 
1407 
1408 	constructor() public {
1409 		oraclize_setProof(proofType_Ledger);
1410 	}
1411 
1412 	function addQueryBalance() public payable {
1413 		queryWallet[msg.sender] += msg.value;
1414 	}
1415 
1416 	function withdrawAllQueryBalance() public {
1417 		withdrawQueryBalance(queryWallet[msg.sender]);
1418 	}
1419 
1420 	function withdrawQueryBalance(uint256 _amount) public {
1421 		require(queryWallet[msg.sender] >= _amount);
1422 		queryWallet[msg.sender] -= _amount;
1423 		msg.sender.transfer(_amount);
1424 	}
1425 
1426 	function createSeries(uint256[] memory _newSeries) public returns (uint256 seriesIndex) {
1427 		require(_newSeries.length > 0);
1428 
1429 		uint256 _sum = 0;
1430 		uint256 _zeros = 0;
1431 		uint256 _length = _newSeries.length;
1432 		uint256[] memory _cumulativeSum = new uint256[](_length);
1433 		for (uint256 i = 0; i < _length; i++) {
1434 			_sum += _newSeries[i];
1435 			_cumulativeSum[i] = _sum;
1436 			if (_newSeries[i] == 0) {
1437 				_zeros++;
1438 			}
1439 		}
1440 		require(_sum > 1);
1441 
1442 		uint256 _maxRuns = 0;
1443 		uint256 _tmp = UINT256_MAX;
1444 		while (_tmp > _sum) {
1445 			_tmp /= _sum;
1446 			_maxRuns++;
1447 		}
1448 		if (_tmp == _sum - 1) {
1449 			_maxRuns++;
1450 		}
1451 
1452 		uint256[] memory _resolutions = new uint256[](_length);
1453 		for (uint256 i = 0; i < _length; i++) {
1454 			_resolutions[i] = (_newSeries[i] == 0 ? 0 : FLOAT_SCALAR * _sum / _newSeries[i] / (_length - _zeros));
1455 		}
1456 
1457 		Series memory _series = Series({
1458 			sum: _sum,
1459 			maxRuns: _maxRuns,
1460 			series: _newSeries,
1461 			cumulativeSum: _cumulativeSum,
1462 			resolutions: _resolutions
1463 		});
1464 		return series.push(_series) - 1;
1465 	}
1466 
1467 	function randomRequest(bytes32 _seed, uint256 _callbackGasLimit) public returns (bytes32 queryId) {
1468 		return _request(RequestType.RANDOM, 0, _seed, _callbackGasLimit);
1469 	}
1470 
1471 	function modulusRequest(uint256 _modulus, uint256 _betmask, bytes32 _seed, uint256 _callbackGasLimit) public returns (bytes32 queryId) {
1472 		require(_modulus >= 2 && _modulus <= 256);
1473 		require(_betmask > 0 && _betmask < 2**_modulus - 1);
1474 
1475 		ModulusInfo memory _modulusInfo = ModulusInfo({
1476 			modulus: _modulus,
1477 			betmask: _betmask
1478 		});
1479 		uint256 _requestIndex = modulusInfo.push(_modulusInfo) - 1;
1480 		return _request(RequestType.MODULUS, _requestIndex, _seed, _callbackGasLimit);
1481 	}
1482 
1483 	function seriesRequest(uint256 _seriesIndex, uint256 _runs, bytes32 _seed, uint256 _callbackGasLimit) public returns (bytes32 queryId) {
1484 		require(_seriesIndex < series.length);
1485 		require(_runs > 0 && _runs <= series[_seriesIndex].maxRuns);
1486 
1487 		SeriesInfo memory _seriesInfo = SeriesInfo({
1488 			seriesIndex: uint128(_seriesIndex),
1489 			runs: uint128(_runs)
1490 		});
1491 		uint256 _requestIndex = seriesInfo.push(_seriesInfo) - 1;
1492 		return _request(RequestType.SERIES, _requestIndex, _seed, _callbackGasLimit);
1493 	}
1494 
1495 	function resolveQuery(bytes32 _queryId) public {
1496 		require(block.number - requestMap[_queryId].placedBlockNumber > 256);
1497 		_queryFailed(_queryId);
1498 	}
1499 
1500 	function __callback(bytes32 _queryId, string memory _result, bytes memory _proof) public {
1501 		require(msg.sender == oraclize_cbAddress());
1502 		if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) == 0) {
1503 			_handleCallback(_queryId, _result);
1504 		} else {
1505 			_queryFailed(_queryId);
1506 		}
1507 	}
1508 
1509 
1510 	function getSeries(uint256 _seriesIndex) public view returns (uint256 sum, uint256 maxRuns, uint256[] memory values, uint256[] memory cumulativeSum, uint256[] memory resolutions) {
1511 		require(_seriesIndex < series.length);
1512 		Series memory _series = series[_seriesIndex];
1513 		return (_series.sum, _series.maxRuns, _series.series, _series.cumulativeSum, _series.resolutions);
1514 	}
1515 
1516 
1517 	function _request(RequestType _requestType, uint256 _requestIndex, bytes32 _seed, uint256 _callbackGasLimit) internal returns (bytes32 queryId) {
1518 		oraclize_setCustomGasPrice(tx.gasprice + 1e9);
1519 		uint256 _queryFee = oraclize_getPrice("random", _callbackGasLimit);
1520 		require(queryWallet[tx.origin] >= _queryFee);
1521 		queryWallet[tx.origin] -= _queryFee;
1522 
1523 		queryId = oraclize_newRandomDSQuery(0, 32, _callbackGasLimit);
1524 		RequestInfo memory _requestInfo = RequestInfo({
1525 			seed: keccak256(abi.encodePacked(_seed, queryId)),
1526 			caller: Caller(msg.sender),
1527 			placedBlockNumber: uint32(block.number),
1528 			requestType: _requestType,
1529 			requestIndex: uint32(_requestIndex)
1530 		});
1531 		requestMap[queryId] = _requestInfo;
1532 	}
1533 
1534 	function _handleCallback(bytes32 _queryId, string memory _result) internal {
1535 		RequestInfo memory _requestInfo = requestMap[_queryId];
1536 		require(address(_requestInfo.caller) != address(0x0));
1537 
1538 		if (_requestInfo.placedBlockNumber < block.number && block.number - _requestInfo.placedBlockNumber < 256) {
1539 			if (_requestInfo.requestType == RequestType.RANDOM) { _randomCallback(_queryId, _result); }
1540 			else if (_requestInfo.requestType == RequestType.MODULUS) { _modulusCallback(_queryId, _result); }
1541 			else if (_requestInfo.requestType == RequestType.SERIES) { _seriesCallback(_queryId, _result); }
1542 		} else {
1543 			_queryFailed(_queryId);
1544 		}
1545 	}
1546 
1547 	function _randomCallback(bytes32 _queryId, string memory _result) internal {
1548 		Caller _caller = requestMap[_queryId].caller;
1549 		bytes32 _randomData = _generateRNG(_queryId, _result);
1550 		delete requestMap[_queryId];
1551 		_caller.randomCallback(_queryId, _randomData);
1552 	}
1553 
1554 	function _modulusCallback(bytes32 _queryId, string memory _result) internal {
1555 		RequestInfo memory _requestInfo = requestMap[_queryId];
1556 		uint256 _rng = uint256(_generateRNG(_queryId, _result));
1557 
1558 		ModulusInfo memory _modulusInfo = modulusInfo[_requestInfo.requestIndex];
1559 		uint256 _roll = _rng % _modulusInfo.modulus;
1560 		uint256 _resolution = 0;
1561 		if (2**_roll & _modulusInfo.betmask != 0) {
1562 			uint256 _selected = 0;
1563 			uint256 _n = _modulusInfo.betmask;
1564 			while (_n > 0) {
1565 				if (_n % 2 == 1) _selected++;
1566 				_n /= 2;
1567 			}
1568 			_resolution = FLOAT_SCALAR * _modulusInfo.modulus / _selected;
1569 		}
1570 
1571 		Caller _caller = _requestInfo.caller;
1572 		delete modulusInfo[_requestInfo.requestIndex];
1573 		delete requestMap[_queryId];
1574 		_caller.modulusCallback(_queryId, _resolution, _roll);
1575 	}
1576 
1577 	function _seriesCallback(bytes32 _queryId, string memory _result) internal {
1578 		RequestInfo memory _requestInfo = requestMap[_queryId];
1579 		uint256 _rng = uint256(_generateRNG(_queryId, _result));
1580 
1581 		SeriesInfo memory _seriesInfo = seriesInfo[_requestInfo.requestIndex];
1582 		Series memory _series = series[_seriesInfo.seriesIndex];
1583 
1584 		uint256[] memory _results = new uint256[](_seriesInfo.runs);
1585 		uint256 _resolution = 0;
1586 		for (uint256 i = 0; i < _seriesInfo.runs; i++) {
1587 			uint256 _roll = _rng % _series.sum;
1588 			_rng /= _series.sum;
1589 
1590 			uint256 _outcome;
1591 			for (uint256 j = 0; j < _series.cumulativeSum.length; j++) {
1592 				if (_roll < _series.cumulativeSum[j]) {
1593 					_outcome = j;
1594 					break;
1595 				}
1596 			}
1597 
1598 			_results[i] = _outcome;
1599 			_resolution += _series.resolutions[_outcome];
1600 		}
1601 		_resolution /= _seriesInfo.runs;
1602 
1603 		Caller _caller = _requestInfo.caller;
1604 		delete seriesInfo[_requestInfo.requestIndex];
1605 		delete requestMap[_queryId];
1606 		_caller.seriesCallback(_queryId, _resolution, _results);
1607 	}
1608 
1609 	function _queryFailed(bytes32 _queryId) internal {
1610 		RequestInfo memory _requestInfo = requestMap[_queryId];
1611 		require(address(_requestInfo.caller) != address(0x0));
1612 
1613 		Caller _caller = _requestInfo.caller;
1614 		if (_requestInfo.requestType == RequestType.MODULUS) { delete modulusInfo[_requestInfo.requestIndex]; }
1615 		else if (_requestInfo.requestType == RequestType.SERIES) { delete seriesInfo[_requestInfo.requestIndex]; }
1616 		delete requestMap[_queryId];
1617 		_caller.queryFailed(_queryId);
1618 	}
1619 
1620 
1621 	function _generateRNG(bytes32 _queryId, string memory _result) internal view returns (bytes32 _randomData) {
1622 		RequestInfo memory _requestInfo = requestMap[_queryId];
1623 		bytes32 _staticData = keccak256(abi.encodePacked(_requestInfo.seed, _queryId, blockhash(_requestInfo.placedBlockNumber), blockhash(block.number - 1)));
1624 		return keccak256(abi.encodePacked(_staticData, _result));
1625 	}
1626 }