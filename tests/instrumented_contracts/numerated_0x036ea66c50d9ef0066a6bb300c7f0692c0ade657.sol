1 pragma solidity ^0.5.0;
2 
3 /*
4 
5 ORACLIZE_API
6 
7 Copyright (c) 2015-2016 Oraclize SRL
8 Copyright (c) 2016 Oraclize LTD
9 
10 Permission is hereby granted, free of charge, to any person obtaining a copy
11 of this software and associated documentation files (the "Software"), to deal
12 in the Software without restriction, including without limitation the rights
13 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
14 copies of the Software, and to permit persons to whom the Software is
15 furnished to do so, subject to the following conditions:
16 
17 The above copyright notice and this permission notice shall be included in
18 all copies or substantial portions of the Software.
19 
20 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
21 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
22 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
23 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
24 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
25 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
26 THE SOFTWARE.
27 
28 */
29  // Incompatible compiler version - please select a compiler within the stated pragma range, or use a different version of the oraclizeAPI!
30 
31 // Dummy contract only used to emit to end-user they are using wrong solc
32 contract solcChecker {
33 /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;
34 }
35 
36 contract OraclizeI {
37 
38     address public cbAddress;
39 
40     function setProofType(byte _proofType) external;
41     function setCustomGasPrice(uint _gasPrice) external;
42     function getPrice(string memory _datasource) public view returns (uint _dsprice);
43     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
44     function getPrice(string memory _datasource, uint _gasLimit) public view returns (uint _dsprice);
45     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
46     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
47     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
48     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
49     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
50     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
51 }
52 
53 contract OraclizeAddrResolverI {
54     function getAddress() public returns (address _address);
55 }
56 /*
57 
58 Begin solidity-cborutils
59 
60 https://github.com/smartcontractkit/solidity-cborutils
61 
62 MIT License
63 
64 Copyright (c) 2018 SmartContract ChainLink, Ltd.
65 
66 Permission is hereby granted, free of charge, to any person obtaining a copy
67 of this software and associated documentation files (the "Software"), to deal
68 in the Software without restriction, including without limitation the rights
69 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
70 copies of the Software, and to permit persons to whom the Software is
71 furnished to do so, subject to the following conditions:
72 
73 The above copyright notice and this permission notice shall be included in all
74 copies or substantial portions of the Software.
75 
76 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
77 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
78 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
79 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
80 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
81 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
82 SOFTWARE.
83 
84 */
85 library Buffer {
86 
87     struct buffer {
88         bytes buf;
89         uint capacity;
90     }
91 
92     function init(buffer memory _buf, uint _capacity) internal pure {
93         uint capacity = _capacity;
94         if (capacity % 32 != 0) {
95             capacity += 32 - (capacity % 32);
96         }
97         _buf.capacity = capacity; // Allocate space for the buffer data
98         assembly {
99             let ptr := mload(0x40)
100             mstore(_buf, ptr)
101             mstore(ptr, 0)
102             mstore(0x40, add(ptr, capacity))
103         }
104     }
105 
106     function resize(buffer memory _buf, uint _capacity) private pure {
107         bytes memory oldbuf = _buf.buf;
108         init(_buf, _capacity);
109         append(_buf, oldbuf);
110     }
111 
112     function max(uint _a, uint _b) private pure returns (uint _max) {
113         if (_a > _b) {
114             return _a;
115         }
116         return _b;
117     }
118     /**
119       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
120       *      would exceed the capacity of the buffer.
121       * @param _buf The buffer to append to.
122       * @param _data The data to append.
123       * @return The original buffer.
124       *
125       */
126     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
127         if (_data.length + _buf.buf.length > _buf.capacity) {
128             resize(_buf, max(_buf.capacity, _data.length) * 2);
129         }
130         uint dest;
131         uint src;
132         uint len = _data.length;
133         assembly {
134             let bufptr := mload(_buf) // Memory address of the buffer data
135             let buflen := mload(bufptr) // Length of existing buffer data
136             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
137             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
138             src := add(_data, 32)
139         }
140         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
141             assembly {
142                 mstore(dest, mload(src))
143             }
144             dest += 32;
145             src += 32;
146         }
147         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
148         assembly {
149             let srcpart := and(mload(src), not(mask))
150             let destpart := and(mload(dest), mask)
151             mstore(dest, or(destpart, srcpart))
152         }
153         return _buf;
154     }
155     /**
156       *
157       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
158       * exceed the capacity of the buffer.
159       * @param _buf The buffer to append to.
160       * @param _data The data to append.
161       * @return The original buffer.
162       *
163       */
164     function append(buffer memory _buf, uint8 _data) internal pure {
165         if (_buf.buf.length + 1 > _buf.capacity) {
166             resize(_buf, _buf.capacity * 2);
167         }
168         assembly {
169             let bufptr := mload(_buf) // Memory address of the buffer data
170             let buflen := mload(bufptr) // Length of existing buffer data
171             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
172             mstore8(dest, _data)
173             mstore(bufptr, add(buflen, 1)) // Update buffer length
174         }
175     }
176     /**
177       *
178       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
179       * exceed the capacity of the buffer.
180       * @param _buf The buffer to append to.
181       * @param _data The data to append.
182       * @return The original buffer.
183       *
184       */
185     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
186         if (_len + _buf.buf.length > _buf.capacity) {
187             resize(_buf, max(_buf.capacity, _len) * 2);
188         }
189         uint mask = 256 ** _len - 1;
190         assembly {
191             let bufptr := mload(_buf) // Memory address of the buffer data
192             let buflen := mload(bufptr) // Length of existing buffer data
193             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
194             mstore(dest, or(and(mload(dest), not(mask)), _data))
195             mstore(bufptr, add(buflen, _len)) // Update buffer length
196         }
197         return _buf;
198     }
199 }
200 
201 library CBOR {
202 
203     using Buffer for Buffer.buffer;
204 
205     uint8 private constant MAJOR_TYPE_INT = 0;
206     uint8 private constant MAJOR_TYPE_MAP = 5;
207     uint8 private constant MAJOR_TYPE_BYTES = 2;
208     uint8 private constant MAJOR_TYPE_ARRAY = 4;
209     uint8 private constant MAJOR_TYPE_STRING = 3;
210     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
211     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
212 
213     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
214         if (_value <= 23) {
215             _buf.append(uint8((_major << 5) | _value));
216         } else if (_value <= 0xFF) {
217             _buf.append(uint8((_major << 5) | 24));
218             _buf.appendInt(_value, 1);
219         } else if (_value <= 0xFFFF) {
220             _buf.append(uint8((_major << 5) | 25));
221             _buf.appendInt(_value, 2);
222         } else if (_value <= 0xFFFFFFFF) {
223             _buf.append(uint8((_major << 5) | 26));
224             _buf.appendInt(_value, 4);
225         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
226             _buf.append(uint8((_major << 5) | 27));
227             _buf.appendInt(_value, 8);
228         }
229     }
230 
231     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
232         _buf.append(uint8((_major << 5) | 31));
233     }
234 
235     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
236         encodeType(_buf, MAJOR_TYPE_INT, _value);
237     }
238 
239     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
240         if (_value >= 0) {
241             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
242         } else {
243             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
244         }
245     }
246 
247     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
248         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
249         _buf.append(_value);
250     }
251 
252     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
253         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
254         _buf.append(bytes(_value));
255     }
256 
257     function startArray(Buffer.buffer memory _buf) internal pure {
258         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
259     }
260 
261     function startMap(Buffer.buffer memory _buf) internal pure {
262         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
263     }
264 
265     function endSequence(Buffer.buffer memory _buf) internal pure {
266         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
267     }
268 }
269 /*
270 
271 End solidity-cborutils
272 
273 */
274 contract usingOraclize {
275 
276     using CBOR for Buffer.buffer;
277 
278     OraclizeI oraclize;
279     OraclizeAddrResolverI OAR;
280 
281     uint constant day = 60 * 60 * 24;
282     uint constant week = 60 * 60 * 24 * 7;
283     uint constant month = 60 * 60 * 24 * 30;
284 
285     byte constant proofType_NONE = 0x00;
286     byte constant proofType_Ledger = 0x30;
287     byte constant proofType_Native = 0xF0;
288     byte constant proofStorage_IPFS = 0x01;
289     byte constant proofType_Android = 0x40;
290     byte constant proofType_TLSNotary = 0x10;
291 
292     string oraclize_network_name;
293     uint8 constant networkID_auto = 0;
294     uint8 constant networkID_morden = 2;
295     uint8 constant networkID_mainnet = 1;
296     uint8 constant networkID_testnet = 2;
297     uint8 constant networkID_consensys = 161;
298 
299     mapping(bytes32 => bytes32) oraclize_randomDS_args;
300     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
301 
302     modifier oraclizeAPI {
303         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
304             oraclize_setNetwork(networkID_auto);
305         }
306         if (address(oraclize) != OAR.getAddress()) {
307             oraclize = OraclizeI(OAR.getAddress());
308         }
309         _;
310     }
311 
312     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
313         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
314         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
315         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
316         require(proofVerified);
317         _;
318     }
319 
320     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
321       return oraclize_setNetwork();
322       _networkID; // silence the warning and remain backwards compatible
323     }
324 
325     function oraclize_setNetworkName(string memory _network_name) internal {
326         oraclize_network_name = _network_name;
327     }
328 
329     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
330         return oraclize_network_name;
331     }
332 
333     function oraclize_setNetwork() internal returns (bool _networkSet) {
334         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
335             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
336             oraclize_setNetworkName("eth_mainnet");
337             return true;
338         }
339         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
340             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
341             oraclize_setNetworkName("eth_kovan");
342             return true;
343         }
344         return false;
345     }
346 
347     function __callback(bytes32 _myid, string memory _result) public {
348         __callback(_myid, _result, new bytes(0));
349     }
350 
351     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
352       return;
353       _myid; _result; _proof; // Silence compiler warnings
354     }
355 
356     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
357         return oraclize.getPrice(_datasource, _gasLimit);
358     }
359 
360     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
361         uint price = oraclize.getPrice(_datasource,_gasLimit);
362         if (price > 1 ether + tx.gasprice * _gasLimit) {
363             return 0; // Unexpectedly high price
364         }
365         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
366     }
367 
368     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
369         uint price = oraclize.getPrice(_datasource, _gasLimit);
370         if (price > 1 ether + tx.gasprice * _gasLimit) {
371             return 0; // Unexpectedly high price
372         }
373         bytes memory args = ba2cbor(_argN);
374         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
375     }
376 
377 
378     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
379         bytes[] memory dynargs = new bytes[](4);
380         dynargs[0] = _args[0];
381         dynargs[1] = _args[1];
382         dynargs[2] = _args[2];
383         dynargs[3] = _args[3];
384         return oraclize_query(_datasource, dynargs, _gasLimit);
385     }
386 
387     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
388         return oraclize.cbAddress();
389     }
390 
391     function getCodeSize(address _addr) view internal returns (uint _size) {
392         assembly {
393             _size := extcodesize(_addr)
394         }
395     }
396 
397     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
398         return oraclize.setCustomGasPrice(_gasPrice);
399     }
400 
401     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
402         return oraclize.randomDS_getSessionPubKeyHash();
403     }
404 
405     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
406         safeMemoryCleaner();
407         Buffer.buffer memory buf;
408         Buffer.init(buf, 1024);
409         buf.startArray();
410         for (uint i = 0; i < _arr.length; i++) {
411             buf.encodeBytes(_arr[i]);
412         }
413         buf.endSequence();
414         return buf.buf;
415     }
416 
417     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
418         require((_nbytes > 0) && (_nbytes <= 32));
419         _delay *= 10; // Convert from seconds to ledger timer ticks
420         bytes memory nbytes = new bytes(1);
421         nbytes[0] = byte(uint8(_nbytes));
422         bytes memory unonce = new bytes(32);
423         bytes memory sessionKeyHash = new bytes(32);
424         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
425         assembly {
426             mstore(unonce, 0x20)
427             /*
428              The following variables can be relaxed.
429              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
430              for an idea on how to override and replace commit hash variables.
431             */
432             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
433             mstore(sessionKeyHash, 0x20)
434             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
435         }
436         bytes memory delay = new bytes(32);
437         assembly {
438             mstore(add(delay, 0x20), _delay)
439         }
440         bytes memory delay_bytes8 = new bytes(8);
441         copyBytes(delay, 24, 8, delay_bytes8, 0);
442         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
443         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
444         bytes memory delay_bytes8_left = new bytes(8);
445         assembly {
446             let x := mload(add(delay_bytes8, 0x20))
447             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
448             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
449             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
450             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
451             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
452             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
453             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
454             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
455         }
456         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
457         return queryId;
458     }
459 
460     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
461         oraclize_randomDS_args[_queryId] = _commitment;
462     }
463 
464     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
465         bool sigok;
466         address signer;
467         bytes32 sigr;
468         bytes32 sigs;
469         bytes memory sigr_ = new bytes(32);
470         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
471         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
472         bytes memory sigs_ = new bytes(32);
473         offset += 32 + 2;
474         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
475         assembly {
476             sigr := mload(add(sigr_, 32))
477             sigs := mload(add(sigs_, 32))
478         }
479         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
480         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
481             return true;
482         } else {
483             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
484             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
485         }
486     }
487 
488     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
489         bool sigok;
490         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
491         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
492         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
493         bytes memory appkey1_pubkey = new bytes(64);
494         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
495         bytes memory tosign2 = new bytes(1 + 65 + 32);
496         tosign2[0] = byte(uint8(1)); //role
497         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
498         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
499         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
500         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
501         if (!sigok) {
502             return false;
503         }
504         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
505         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
506         bytes memory tosign3 = new bytes(1 + 65);
507         tosign3[0] = 0xFE;
508         copyBytes(_proof, 3, 65, tosign3, 1);
509         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
510         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
511         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
512         return sigok;
513     }
514 
515     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
516         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
517         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
518             return 1;
519         }
520         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
521         if (!proofVerified) {
522             return 2;
523         }
524         return 0;
525     }
526 
527     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
528         bool match_ = true;
529         require(_prefix.length == _nRandomBytes);
530         for (uint256 i = 0; i< _nRandomBytes; i++) {
531             if (_content[i] != _prefix[i]) {
532                 match_ = false;
533             }
534         }
535         return match_;
536     }
537 
538     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
539         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
540         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
541         bytes memory keyhash = new bytes(32);
542         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
543         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
544             return false;
545         }
546         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
547         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
548         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
549         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
550             return false;
551         }
552         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
553         // This is to verify that the computed args match with the ones specified in the query.
554         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
555         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
556         bytes memory sessionPubkey = new bytes(64);
557         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
558         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
559         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
560         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
561             delete oraclize_randomDS_args[_queryId];
562         } else return false;
563         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
564         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
565         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
566         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
567             return false;
568         }
569         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
570         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
571             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
572         }
573         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
574     }
575     /*
576      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
577     */
578     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
579         uint minLength = _length + _toOffset;
580         require(_to.length >= minLength); // Buffer too small. Should be a better way?
581         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
582         uint j = 32 + _toOffset;
583         while (i < (32 + _fromOffset + _length)) {
584             assembly {
585                 let tmp := mload(add(_from, i))
586                 mstore(add(_to, j), tmp)
587             }
588             i += 32;
589             j += 32;
590         }
591         return _to;
592     }
593     /*
594      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
595      Duplicate Solidity's ecrecover, but catching the CALL return value
596     */
597     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
598         /*
599          We do our own memory management here. Solidity uses memory offset
600          0x40 to store the current end of memory. We write past it (as
601          writes are memory extensions), but don't update the offset so
602          Solidity will reuse it. The memory used here is only needed for
603          this context.
604          FIXME: inline assembly can't access return values
605         */
606         bool ret;
607         address addr;
608         assembly {
609             let size := mload(0x40)
610             mstore(size, _hash)
611             mstore(add(size, 32), _v)
612             mstore(add(size, 64), _r)
613             mstore(add(size, 96), _s)
614             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
615             addr := mload(size)
616         }
617         return (ret, addr);
618     }
619     /*
620      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
621     */
622     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
623         bytes32 r;
624         bytes32 s;
625         uint8 v;
626         if (_sig.length != 65) {
627             return (false, address(0));
628         }
629         /*
630          The signature format is a compact form of:
631            {bytes32 r}{bytes32 s}{uint8 v}
632          Compact means, uint8 is not padded to 32 bytes.
633         */
634         assembly {
635             r := mload(add(_sig, 32))
636             s := mload(add(_sig, 64))
637             /*
638              Here we are loading the last 32 bytes. We exploit the fact that
639              'mload' will pad with zeroes if we overread.
640              There is no 'mload8' to do this, but that would be nicer.
641             */
642             v := byte(0, mload(add(_sig, 96)))
643             /*
644               Alternative solution:
645               'byte' is not working due to the Solidity parser, so lets
646               use the second best option, 'and'
647               v := and(mload(add(_sig, 65)), 255)
648             */
649         }
650         /*
651          albeit non-transactional signatures are not specified by the YP, one would expect it
652          to match the YP range of [27, 28]
653          geth uses [0, 1] and some clients have followed. This might change, see:
654          https://github.com/ethereum/go-ethereum/issues/2053
655         */
656         if (v < 27) {
657             v += 27;
658         }
659         if (v != 27 && v != 28) {
660             return (false, address(0));
661         }
662         return safer_ecrecover(_hash, v, r, s);
663     }
664 
665     function safeMemoryCleaner() internal pure {
666         assembly {
667             let fmem := mload(0x40)
668             codecopy(fmem, codesize, sub(msize, fmem))
669         }
670     }
671 }
672 /*
673 
674 END ORACLIZE_API
675 
676 */
677 
678 /**
679  * @title SafeMath
680  * @dev Unsigned math operations with safety checks that revert on error
681  */
682 library SafeMath {
683     /**
684      * @dev Multiplies two unsigned integers, reverts on overflow.
685      */
686     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
687         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
688         // benefit is lost if 'b' is also tested.
689         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
690         if (a == 0) {
691             return 0;
692         }
693 
694         uint256 c = a * b;
695         require(c / a == b);
696 
697         return c;
698     }
699 
700     /**
701      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
702      */
703     function div(uint256 a, uint256 b) internal pure returns (uint256) {
704         // Solidity only automatically asserts when dividing by 0
705         require(b > 0);
706         uint256 c = a / b;
707         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
708 
709         return c;
710     }
711 
712     /**
713      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
714      */
715     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
716         require(b <= a);
717         uint256 c = a - b;
718 
719         return c;
720     }
721 
722     /**
723      * @dev Adds two unsigned integers, reverts on overflow.
724      */
725     function add(uint256 a, uint256 b) internal pure returns (uint256) {
726         uint256 c = a + b;
727         require(c >= a);
728 
729         return c;
730     }
731 
732     /**
733      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
734      * reverts when dividing by zero.
735      */
736     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
737         require(b != 0);
738         return a % b;
739     }
740 }
741 
742 contract BadBitSettings {
743 
744     uint public constant GWEI_TO_WEI = 1000000000;
745     uint public constant ETH_TO_WEI = 1000000000000000000;
746     uint public ORACLIZE_GAS_LIMIT = 220000;
747     uint public MAX_GAS_PRICE = 30000000000; // in wei
748     uint public MIN_GAS_PRICE = 1000000000; // in wei
749     uint public BIG_WIN_THRESHOLD = 3 ether;
750     uint public MAX_CHANCE_FOR_BONUS_BETTING = 25;
751     uint public MAX_DON_IN_ROW = 3;
752     uint public HOUSE_EDGE = 2000;
753     uint public MAX_WP = 9500;
754     uint public MIN_WP = 476;
755     uint public REVENUE_TO_INITIAL_DEPOSIT_RATIO = 2;
756     bool public BETS_ALLOWED = true;
757     bool public USE_BLOCKHASH_RANDOM_SEED = false;
758 
759     /**
760     * @dev mapping holding game addresses
761     */
762     mapping(address => bool) public isGameAddress;
763     /**
764     * @dev mapping holding operator addresses
765     */
766     mapping(address => bool) public isOperatorAddress;
767     /**
768     * @dev keeps track of all games
769     */
770     address[] public gameContractAddresses;
771     /**
772     * @dev keeps track of all operators
773     */
774     address[] public operators;
775     /**
776     * @dev keep token win chance reward for each level, stored as percentage times 100
777     */
778     uint[] public tokenWinChanceRewardForLevel;
779     /**
780     * @dev keep bonus balance reward for each level
781     */
782     uint[] public bonusBalanceRewardForLevel;
783 
784     event GamePaused(bool indexed yes);
785     event MaxGasPriceSet(uint amount);
786     event MinGasPriceSet(uint amount);
787     event BigWinThresholdSet(uint amount);
788     event MaxChanceForBonusBetSet(uint amount);
789     event MaxDonInRowSet(uint count);
790     event HouseEdgeSet(uint houseEdge);
791     event MaxWPSet(uint maxWp);
792     event MinWPSet(uint minWp);
793 
794     modifier onlyOperators() {
795         require (isOperatorAddress[msg.sender]);
796         _;
797     }
798 
799     constructor() public {
800         operators.push(msg.sender);
801         isOperatorAddress[msg.sender] = true;
802 
803         bonusBalanceRewardForLevel = [0, 0, 0.01 ether, 0.02 ether, 0,
804             0.03 ether, 0.04 ether, 0.05 ether, 0, 0.06 ether, 0.07 ether,
805             0.08 ether, 0, 0.09 ether, 0.10 ether, 0.11 ether, 0, 0.12 ether,
806             0.13 ether, 0.14 ether, 0, 0.15 ether, 0.16 ether, 0.17 ether, 0,
807             0.18 ether, 0.19 ether, 0.20 ether, 0, 0.21 ether, 0.22 ether,
808             0.23 ether, 0, 0.24 ether, 0.25 ether, 0.26 ether, 0, 0.27 ether,
809             0.28 ether, 0.29 ether, 0, 0.30 ether, 0.31 ether, 0.32 ether, 0,
810             0.33 ether, 0.34 ether, 0.35 ether, 0, 0.36 ether, 0.37 ether,
811             0.38 ether, 0, 0.39 ether, 0.40 ether, 0.41 ether, 0, 0.42 ether,
812             0.43 ether, 0.44 ether, 0, 0.45 ether, 0.46 ether, 0.47 ether, 0,
813             0.48 ether, 0.49 ether, 0.50 ether, 0, 0.51 ether, 0.52 ether,
814             0.53 ether, 0, 0.54 ether, 0.55 ether, 0.56 ether, 0, 0.57 ether,
815             0.58 ether, 0.59 ether, 0, 0.60 ether, 0.61 ether, 0.62 ether, 0,
816             0.63 ether, 0.64 ether, 0.65 ether, 0, 0.66 ether, 0.67 ether,
817             0.68 ether, 0, 0.69 ether, 0.70 ether, 0.71 ether, 0, 0.72 ether,
818             0.73 ether, 0.74 ether, 0];
819 
820 
821         tokenWinChanceRewardForLevel = [0, 0, 0, 0, 40, 40, 40, 40, 80, 80, 80, 80,
822             120, 120, 120, 120, 160, 160, 160, 160, 200, 200, 200, 200, 250, 250, 250, 250, 300, 300, 300, 300,
823             350, 350, 350, 350, 400, 400, 400, 400, 450, 450, 450, 450, 510, 510, 510, 510, 570, 570, 570, 570,
824             630, 630, 630, 630, 690, 690, 690, 690, 750, 750, 750, 750, 820, 820, 820, 820, 890, 890, 890, 890,
825             960, 960, 960, 960, 1030, 1030, 1030, 1030, 1100, 1100, 1100, 1100, 1180, 1180, 1180, 1180, 1260, 1260, 1260, 1260,
826             1340, 1340, 1340, 1340, 1420, 1420, 1420, 1420, 1500];
827     }
828 
829     /**
830     * @dev Method that allows operators to add allowed address
831     * @param _address represents address that should be added
832     */
833     function addGame(address _address) public onlyOperators {
834         require(!isGameAddress[_address]);
835 
836         gameContractAddresses.push(_address);
837         isGameAddress[_address] = true;
838     }
839 
840     /**
841     * @dev Method that allows operators to remove allowed address
842     * @param _address represents address that should be removed
843     */
844     function removeGame(address _address) public onlyOperators {
845         require(isGameAddress[_address]);
846 
847         uint len = gameContractAddresses.length;
848 
849         for (uint i=0; i<len; i++) {
850             if (gameContractAddresses[i] == _address) {
851                 // move last game to i-th position
852                 gameContractAddresses[i] = gameContractAddresses[len-1];
853                 // delete last game in array (its already moved so its duplicate)
854                 delete gameContractAddresses[len-1];
855                 // resize gameContractAddresses array
856                 gameContractAddresses.length--;
857                 // remove allowed address
858                 isGameAddress[_address] = false;
859                 break;
860             }
861         }
862 
863     }
864 
865     /**
866     * @dev Method that allows operators to add allowed address
867     * @param _address represents address that should be added
868     */
869     function addOperator(address _address) public onlyOperators {
870         require(!isOperatorAddress[_address]);
871 
872         operators.push(_address);
873         isOperatorAddress[_address] = true;
874     }
875 
876     /**
877     * @dev Method that allows operators to remove allowed address
878     * @param _address represents address that should be removed
879     */
880     function removeOperator(address _address) public onlyOperators {
881         require(isOperatorAddress[_address]);
882 
883         uint len = operators.length;
884 
885         for (uint i=0; i<len; i++) {
886             if (operators[i] == _address) {
887                 // move last game to i-th position
888                 operators[i] = operators[len-1];
889                 // delete last game in array (its already moved so its duplicate)
890                 delete operators[len-1];
891                 // resize operators array
892                 operators.length--;
893                 // remove allowed address
894                 isOperatorAddress[_address] = false;
895                 break;
896             }
897         }
898 
899     }
900 
901     function setMaxGasPriceInGwei(uint _maxGasPrice) public onlyOperators {
902         MAX_GAS_PRICE = _maxGasPrice * GWEI_TO_WEI;
903 
904         emit MaxGasPriceSet(MAX_GAS_PRICE);
905     }
906 
907     function setMinGasPriceInGwei(uint _minGasPrice) public onlyOperators {
908         MIN_GAS_PRICE = _minGasPrice * GWEI_TO_WEI;
909 
910         emit MinGasPriceSet(MIN_GAS_PRICE);
911     }
912 
913     function setBetsAllowed(bool _betsAllowed) public onlyOperators {
914         BETS_ALLOWED = _betsAllowed;
915 
916         emit GamePaused(!_betsAllowed);
917     }
918 
919     function setBigWin(uint _bigWin) public onlyOperators {
920         BIG_WIN_THRESHOLD = _bigWin;
921 
922         emit BigWinThresholdSet(BIG_WIN_THRESHOLD);
923     }
924 
925     function setMaxChanceForBonus(uint _chance) public onlyOperators {
926         MAX_CHANCE_FOR_BONUS_BETTING = _chance;
927 
928         emit MaxChanceForBonusBetSet(MAX_CHANCE_FOR_BONUS_BETTING);
929     }
930 
931     function setMaxDonInRow(uint _count) public onlyOperators {
932         MAX_DON_IN_ROW = _count;
933 
934         emit MaxDonInRowSet(MAX_DON_IN_ROW);
935     }
936 
937     function setHouseEdge(uint _edge) public onlyOperators {
938         // we allow three decimal places, so it is 100 * 1000
939         require(_edge < 100000);
940 
941         HOUSE_EDGE = _edge;
942 
943         emit HouseEdgeSet(HOUSE_EDGE);
944     }
945 
946     function setOraclizeGasLimit(uint _gas) public onlyOperators {
947         ORACLIZE_GAS_LIMIT = _gas;
948     }
949 
950     function setMaxWp(uint _wp) public onlyOperators {
951         MAX_WP = _wp;
952 
953         emit MaxWPSet(_wp);
954     }
955 
956     function setMinWp(uint _wp) public onlyOperators {
957         MIN_WP = _wp;
958 
959         emit MinWPSet(_wp);
960     }
961 
962     function setUseBlockhashRandomSeed(bool _use) public onlyOperators {
963         USE_BLOCKHASH_RANDOM_SEED = _use;
964     }
965 
966     function setRevenueToInitialDepositRatio(uint _ratio) public onlyOperators {
967         require(_ratio >= 2);
968 
969         REVENUE_TO_INITIAL_DEPOSIT_RATIO = _ratio;
970     }
971 
972     function getOperators() public view returns(address[] memory) {
973         return operators;
974     }
975 
976     function getGames() public view returns(address[] memory) {
977         return gameContractAddresses;
978     }
979 
980     function getNumberOfGames() public view returns(uint) {
981         return gameContractAddresses.length;
982     }
983 }
984 
985 contract RollGameSettings {
986 
987     uint public ROUND_TIME = 60;
988     uint public ORACLIZE_GAS_LIMIT_CALL_1 = 230000;
989     uint public ORACLIZE_GAS_LIMIT_CALL_2 = 90000;
990     uint public BENCHMARK_MAXIMUM_BET_SIZE = 1;
991     uint public HOUSE_EDGE = 2000; // percenteges * 1000 (supporting 3 decimal places)
992     uint public MIN_BET = 0.001 ether;
993     uint public MAX_BET = 50 ether;
994     uint public GWP = 6;
995     uint public GBS = 18;
996     bool public USE_DYNAMIC_MAX_BET = true;
997     bool public BETS_ALLOWED = true;
998     uint public MINIMUM_BALANCE_THRESHOLD = 0.01 ether;
999     uint public ROUND_MULTIPLIER_FOR_ORACLIZE_POOL = 50;
1000 
1001     BadBitSettings public settings;
1002 
1003     event GamePaused(bool indexed yes);
1004     event UseDynamicBetChanged(bool useDynamic);
1005     event RoundTimeSet(uint roundTime);
1006     event BenchmarkParameterSet(uint b);
1007     event HouseEdgeSet(uint houseEdge);
1008     event MinBetSet(uint amount);
1009     event MaxBetSet(uint amount);
1010 
1011     modifier onlyOperator() {
1012         require (settings.isOperatorAddress(msg.sender));
1013         _;
1014     }
1015 
1016     constructor(address payable _settings) public {
1017 
1018         settings = BadBitSettings(_settings);
1019     }
1020 
1021     function setRoundTime(uint _roundTime) public onlyOperator {
1022         ROUND_TIME = _roundTime;
1023 
1024         emit RoundTimeSet(ROUND_TIME);
1025     }
1026 
1027     function setBenchmarkParam(uint _b) public onlyOperator {
1028         BENCHMARK_MAXIMUM_BET_SIZE = _b;
1029 
1030         emit BenchmarkParameterSet(BENCHMARK_MAXIMUM_BET_SIZE);
1031     }
1032 
1033     function setFirstOraclizeGasLimit(uint _gasLimit) public onlyOperator {
1034 
1035         ORACLIZE_GAS_LIMIT_CALL_1 = _gasLimit;
1036     }
1037 
1038     function setSecondOraclizeGasLimit(uint _gasLimit) public onlyOperator {
1039 
1040         ORACLIZE_GAS_LIMIT_CALL_2 = _gasLimit;
1041     }
1042 
1043     function setHouseEdge(uint _edge) public onlyOperator {
1044         // we allow three decimal places, so it is 100 * 1000
1045         require(_edge < 100000);
1046 
1047         HOUSE_EDGE = _edge;
1048 
1049         emit HouseEdgeSet(HOUSE_EDGE);
1050     }
1051 
1052     function setMinBet(uint _minBet) public onlyOperator {
1053         MIN_BET = _minBet;
1054 
1055         emit MinBetSet(MIN_BET);
1056     }
1057 
1058     function setMaxBet(uint _maxBet) public onlyOperator {
1059         MAX_BET = _maxBet;
1060 
1061         emit MaxBetSet(MAX_BET);
1062     }
1063 
1064     function setUseDynamicMaxBet(bool _yes) public onlyOperator {
1065         USE_DYNAMIC_MAX_BET = _yes;
1066 
1067         emit UseDynamicBetChanged(_yes);
1068     }
1069 
1070     function setBetsAllowed(bool _betsAllowed) public onlyOperator {
1071         BETS_ALLOWED = _betsAllowed;
1072 
1073         emit GamePaused(!_betsAllowed);
1074     }
1075 
1076     function setRoundMultiplierForOraclizePool(uint _value) public onlyOperator {
1077         ROUND_MULTIPLIER_FOR_ORACLIZE_POOL = _value;
1078     }
1079 
1080     function setMinimumBalanceThreshold(uint _value) public onlyOperator {
1081         MINIMUM_BALANCE_THRESHOLD = _value;
1082     }
1083 
1084     function setGbs(uint _gbs) public onlyOperator {
1085         GBS = _gbs;
1086     }
1087 
1088     function setGwp(uint _gwp) public onlyOperator {
1089         GWP = _gwp;
1090     }
1091 }
1092 
1093 contract IBadBitCasino {
1094 	function add(address _user, uint _amount) public payable returns(bool);
1095 	function placeBet(address _user, uint _betId, uint _amount, bool bonus) public;
1096 	function getCurrentBalance(address _user) public view returns(uint);
1097 	function sendEthToGame(uint _amount) public;
1098 }
1099 
1100 contract GameInterface {
1101 
1102     uint public commissionEarned;
1103     uint public totalFundsLostByPlayers;
1104 
1105     function finalizeBet(address _user, uint _betId) public returns(uint profit, uint totalWon);
1106     function canFinalizeBet(address _user, uint _betId) public view returns (bool success);
1107     function getUserProfitForFinishedBet(address _user, uint _betId) public view returns(uint);
1108     function getTotalBets(address _user) public view returns(uint);
1109     function getPossibleWinnings(uint _chance, uint _amount) public view returns(uint);
1110     function getBetInfo(address _user, uint _betId) public view returns(uint amount, bool finalized, bool won, bool bonus);
1111     function getParamsForTokenCaluclation(uint _chance) public view returns(uint minB, uint maxB, uint gbs, uint gwp);
1112     function emergencyWithdraw(address payable _sender) public;
1113 }
1114 
1115 /**
1116  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
1117  * the optional functions; to access them see `ERC20Detailed`.
1118  */
1119 interface IERC20 {
1120     /**
1121      * @dev Returns the amount of tokens in existence.
1122      */
1123     function totalSupply() external view returns (uint256);
1124 
1125     /**
1126      * @dev Returns the amount of tokens owned by `account`.
1127      */
1128     function balanceOf(address account) external view returns (uint256);
1129 
1130     /**
1131      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1132      *
1133      * Returns a boolean value indicating whether the operation succeeded.
1134      *
1135      * Emits a `Transfer` event.
1136      */
1137     function transfer(address recipient, uint256 amount) external returns (bool);
1138 
1139     /**
1140      * @dev Returns the remaining number of tokens that `spender` will be
1141      * allowed to spend on behalf of `owner` through `transferFrom`. This is
1142      * zero by default.
1143      *
1144      * This value changes when `approve` or `transferFrom` are called.
1145      */
1146     function allowance(address owner, address spender) external view returns (uint256);
1147 
1148     /**
1149      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1150      *
1151      * Returns a boolean value indicating whether the operation succeeded.
1152      *
1153      * > Beware that changing an allowance with this method brings the risk
1154      * that someone may use both the old and the new allowance by unfortunate
1155      * transaction ordering. One possible solution to mitigate this race
1156      * condition is to first reduce the spender's allowance to 0 and set the
1157      * desired value afterwards:
1158      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1159      *
1160      * Emits an `Approval` event.
1161      */
1162     function approve(address spender, uint256 amount) external returns (bool);
1163 
1164     /**
1165      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1166      * allowance mechanism. `amount` is then deducted from the caller's
1167      * allowance.
1168      *
1169      * Returns a boolean value indicating whether the operation succeeded.
1170      *
1171      * Emits a `Transfer` event.
1172      */
1173     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1174 
1175     /**
1176      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1177      * another (`to`).
1178      *
1179      * Note that `value` may be zero.
1180      */
1181     event Transfer(address indexed from, address indexed to, uint256 value);
1182 
1183     /**
1184      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1185      * a call to `approve`. `value` is the new allowance.
1186      */
1187     event Approval(address indexed owner, address indexed spender, uint256 value);
1188 }
1189 
1190 contract IBadBitDistributor{
1191 	function sendTokens(address _user, uint _amount) public;
1192 	function getStandardLot() public view returns(uint);
1193 	function shouldWinTokens(address _contract, bytes32 _hash, address _user, uint[] memory _betSizes, uint[] memory _chances, uint _maxNumOfBets) public view returns (bool);
1194 	function winTokens(address _user) public;
1195 
1196 }
1197 
1198 contract RollGame is usingOraclize, RollGameSettings, GameInterface {
1199     using SafeMath for uint256;
1200 
1201     enum GameType { RollOver, RollUnder, IndividualNumber, EvenOrOdd, DragonOrTiger }
1202     enum RoundState { Active, Closed, Finished }
1203     enum OraclizeCallType { None, CloseRound, FinalizeRound, Used }
1204 
1205     struct Round {
1206         uint224 selectedNumber;
1207         RoundState state;
1208         bytes32 randomHash;
1209     }
1210 
1211     struct Bet {
1212         uint8 number;
1213         GameType gameType;
1214         uint128 amount;
1215         uint64 round;
1216         bool won;
1217         bool finished;
1218         bool bonus;
1219     }
1220 
1221     /**
1222     * @dev keep total commission earned
1223     */
1224     uint public commissionEarned;
1225     /**
1226     * @dev keep how many ethers is lost by player
1227     */
1228     uint public totalFundsLostByPlayers;
1229     /**
1230     * @dev keep track of all funds sent directly to contract
1231     */
1232     uint public totalFundsSentByOwner;
1233     /**
1234     * @dev Mapping that keep what is type of queryId sent to Oraclize
1235     */
1236     mapping(bytes32 => OraclizeCallType) public idToType;
1237     /**
1238     * @dev Holds all bets of user with specific address
1239     */
1240     mapping(address => Bet[]) public bets;
1241     /**
1242     * @dev Array containing all played rounds, round id is its place in array
1243     */
1244     Round[] public rounds;
1245 
1246     IBadBitCasino public casino;
1247     IBadBitDistributor public distributor;
1248 
1249     event RoundStarted(uint indexed id);
1250     event RoundFinished(uint indexed id, uint selectedNumber);
1251     event BetPlayed(uint indexed round, address indexed user, GameType gameType, uint amount, uint number, uint history);
1252     event BetDenied(uint indexed round, address indexed user);
1253 
1254     /**
1255     * @dev betting amount can be only between MIN_BET and MAX_BET
1256     */
1257     modifier onlyAllowedAmount(uint _amount, uint _chance) {
1258         require(MIN_BET <= _amount && _amount <= maxBetSize(_chance));
1259         _;
1260     }
1261 
1262     /**
1263     * @dev we set network and starting gasPrice
1264     * @dev create dummy finished round to avoid edge cases
1265     */
1266     constructor(address payable _casino, address payable _settings) RollGameSettings(_settings) public {
1267 
1268         casino = IBadBitCasino(_casino);
1269 
1270         rounds.push(Round({
1271                 selectedNumber: 0,
1272                 state: RoundState.Finished,
1273                 randomHash: bytes32(0)
1274             }));
1275 
1276         oraclize_setNetwork();
1277         // equals to 1 gwei
1278         oraclize_setCustomGasPrice(10000000000);
1279     }
1280 
1281     function setDistributor(address _distributor) public onlyOperator {
1282         distributor = IBadBitDistributor(_distributor);
1283     }
1284 
1285     function changeCasinoAddress(address payable _casino) public onlyOperator {
1286         casino = IBadBitCasino(_casino);
1287     }
1288 
1289     /**
1290     * @dev Betting function for all game types that should be played with on-contract bonus balance
1291     * @param _number number user wants to bet
1292     * @param _amount amount that user is betting for this specific bet
1293     * @param _type represents which game will be played
1294     */
1295     function placeBonusBet(uint8 _number, uint128 _amount, GameType _type) public
1296         onlyAllowedAmount(_amount, getChance(_type, _number)) {
1297 
1298         require(getChance(_type, _number) < settings.MAX_CHANCE_FOR_BONUS_BETTING());
1299 
1300         _bet(_number, _amount, _type, tx.gasprice + 1000000000, true);
1301     }
1302 
1303     /**
1304     * @dev Betting function for all game types that should be played with on-contract balance
1305     * @param _number number user wants to bet
1306     * @param _amount amount that user is betting for this specific bet
1307     * @param _type represents which game will be played
1308     */
1309     function placeBetWithContractBalance(uint8 _number, uint128 _amount, GameType _type) public
1310         onlyAllowedAmount(_amount, getChance(_type, _number)) {
1311 
1312         _bet(_number, _amount, _type, tx.gasprice + 1000000000, false);
1313     }
1314 
1315     /**
1316     * @dev Betting function for all game types that should be played with msg.value
1317     * @param _number number user wants to bet
1318     * @param _amount amount that user is betting for this specific bet
1319     * @param _type represents which game will be played
1320     */
1321     function placeBet(uint8 _number, uint128 _amount, GameType _type) public
1322         onlyAllowedAmount(_amount, getChance(_type, _number))
1323         payable {
1324 
1325         require(msg.value >= _amount);
1326 
1327         require(casino.add.value(msg.value)(msg.sender, _amount));
1328 
1329         _bet(_number, _amount, _type, tx.gasprice + 1000000000, false);
1330     }
1331 
1332     /**
1333     * @dev Internal betting function that creates actual bet and starts round if there is no active round
1334     * @param _number number user wants to bet
1335     * @param _amount amount that user is betting for this specific bet
1336     * @param _type represents which game will be played
1337     * @param _gasPriceInWei sets gasPrice for oraclize call, should always be a bit higher than current average
1338     * @param _bonus flag that says is it played with bonus balance
1339     */
1340     function _bet(uint8 _number, uint128 _amount, GameType _type, uint _gasPriceInWei, bool _bonus) internal {
1341         require(isValidNumber(_type, _number));
1342         require(BETS_ALLOWED);
1343         require(_type != GameType.IndividualNumber);
1344 
1345         // @dev we don't want to revert if gasPrice is not valid, we just set it to MIN or MAX
1346         if (_gasPriceInWei < settings.MIN_GAS_PRICE()) {
1347             _gasPriceInWei = settings.MIN_GAS_PRICE();
1348         } else if (_gasPriceInWei > settings.MAX_GAS_PRICE()) {
1349             _gasPriceInWei = settings.MAX_GAS_PRICE();
1350         }
1351 
1352         if (address(this).balance < MINIMUM_BALANCE_THRESHOLD) {
1353             pullEthFromCasino();
1354         }
1355 
1356         // @dev if last round is finished we need to start new round
1357         if (rounds[rounds.length-1].state == RoundState.Finished) {
1358             oraclize_setCustomGasPrice(_gasPriceInWei);
1359 
1360             bytes32 queryId = oraclize_query(ROUND_TIME, "URL", "", ORACLIZE_GAS_LIMIT_CALL_1);
1361             idToType[queryId] = OraclizeCallType.CloseRound;
1362 
1363             rounds.push(Round({
1364                     selectedNumber: 0,
1365                     state: RoundState.Active,
1366                     randomHash: bytes32(0)
1367                 }));
1368 
1369             emit RoundStarted(rounds.length-1);
1370         }
1371 
1372         // @dev at this point we definitely have non finished round, but it can be closed, so we need to check if its active
1373         if (rounds[rounds.length-1].state == RoundState.Active) {
1374 
1375             // @dev if this is not your first bet you can't bet twice in same round
1376             if (bets[msg.sender].length > 0) {
1377                 require(bets[msg.sender][bets[msg.sender].length-1].round != rounds.length-1);
1378             }
1379 
1380             // this will also update last bets
1381             casino.placeBet(msg.sender, bets[msg.sender].length, _amount, _bonus);
1382 
1383             // @dev returns history of last (up to 5) bets before pushing new bet
1384             uint history = getUsersBettingHistory(msg.sender);
1385 
1386             bets[msg.sender].push(Bet({
1387                     number: _number,
1388                     gameType: _type,
1389                     amount: _amount,
1390                     round: uint64(rounds.length-1),
1391                     won: false,
1392                     finished: false,
1393                     bonus: _bonus
1394                 }));
1395 
1396             emit BetPlayed(rounds.length-1, msg.sender, _type, _amount, _number, history);
1397         } else {
1398             // @dev if round is closed, emit event saying that bet is denied
1399             emit BetDenied(rounds.length-1, msg.sender);
1400         }
1401     }
1402 
1403     function __callback(bytes32 myid, string memory result) public {
1404         if (msg.sender != oraclize_cbAddress() && !settings.isOperatorAddress(msg.sender)) revert();
1405 
1406         // @dev Oraclize sometimes rebroadcast transactions, so we need to make sure thats not the case
1407         if (idToType[myid] == OraclizeCallType.Used) {
1408             return;
1409         }
1410 
1411         if (idToType[myid] == OraclizeCallType.CloseRound) {
1412             // In case finalization callback was executed first
1413             if(rounds[rounds.length-1].state ==  RoundState.Finished) {
1414                 return;
1415             }
1416 
1417             bytes32 queryId;
1418 
1419             if(settings.USE_BLOCKHASH_RANDOM_SEED()) {
1420                 queryId = oraclize_query(0, "URL", "", ORACLIZE_GAS_LIMIT_CALL_2);
1421             } else {
1422                 queryId = oraclize_newRandomDSQuery(0, 8, ORACLIZE_GAS_LIMIT_CALL_2);
1423             }
1424 
1425             idToType[queryId] = OraclizeCallType.FinalizeRound;
1426             rounds[rounds.length-1].state = RoundState.Closed;
1427         } else if (idToType[myid] == OraclizeCallType.None || idToType[myid] == OraclizeCallType.FinalizeRound) {
1428             require(settings.USE_BLOCKHASH_RANDOM_SEED() || bytes(result).length != 0);
1429             uint224 randomNumber;
1430 
1431             if(settings.isOperatorAddress(msg.sender) || settings.USE_BLOCKHASH_RANDOM_SEED()) {
1432                 randomNumber = uint224(uint(blockhash(block.number - 1)).mod(100));
1433             } else {
1434                 randomNumber = uint224(uint(keccak256(abi.encodePacked(result, blockhash(block.number - 1)))).mod(100));
1435             }
1436 
1437             // Store random string which will be used later to determine token win result
1438             rounds[rounds.length-1].randomHash = keccak256(abi.encodePacked(result));
1439             rounds[rounds.length-1].selectedNumber = randomNumber;
1440             rounds[rounds.length-1].state = RoundState.Finished;
1441 
1442             emit RoundFinished(rounds.length-1, randomNumber);
1443         }
1444 
1445         idToType[myid] = OraclizeCallType.Used;
1446     }
1447 
1448     function finalizeBet(address _user, uint _betId) public returns(uint profit, uint totalWon) {
1449         require(msg.sender == address(casino));
1450 
1451         profit = getUserProfitForFinishedBet(_user, _betId);
1452 
1453         Bet memory betObject = bets[_user][_betId];
1454 
1455         uint[] memory betSizes = new uint[](1);
1456         betSizes[0] = betObject.amount;
1457         uint[] memory chances = new uint[](1);
1458         chances[0] = getChance(betObject.gameType, betObject.number);
1459 
1460         if (distributor.shouldWinTokens(address(this), rounds[betObject.round].randomHash, _user, betSizes, chances, 1)) {
1461             distributor.winTokens(_user);
1462         }
1463 
1464         if (profit > 0) {
1465             totalWon = betObject.amount + profit;
1466             //storage variable
1467             bets[_user][_betId].won = true;
1468 
1469             // @dev updates global states
1470             if(!betObject.bonus) {
1471                 commissionEarned += getCommission(getChance(betObject.gameType, betObject.number), betObject.amount);
1472             }
1473         } else if(!betObject.bonus) {
1474             totalFundsLostByPlayers = totalFundsLostByPlayers.add(betObject.amount);
1475         }
1476         //storage variable
1477         bets[_user][_betId].finished = true;
1478     }
1479 
1480     function pullEthFromCasino() internal {
1481         uint price = oraclize_getPrice("url", ORACLIZE_GAS_LIMIT_CALL_1);
1482         price += settings.USE_BLOCKHASH_RANDOM_SEED() ? oraclize_getPrice("url", ORACLIZE_GAS_LIMIT_CALL_2) : oraclize_getPrice("random", ORACLIZE_GAS_LIMIT_CALL_2);
1483 
1484         casino.sendEthToGame(price * ROUND_MULTIPLIER_FOR_ORACLIZE_POOL);
1485     }
1486 
1487     function canFinalizeBet(address _user, uint _betId) public view returns (bool success) {
1488         if (rounds[bets[_user][_betId].round].state == RoundState.Finished) {
1489             return true;
1490         }
1491 
1492         return false;
1493     }
1494 
1495     /**
1496     * @dev Checks for player winning history (up to 5 bets)
1497     * @param _user represents address of user
1498     * @return returns history of user in format of uint where each decimal 2 means that bet is won, and 1 means that bet is lost
1499     */
1500     function getUsersBettingHistory(address _user) public view returns(uint history) {
1501         uint len = bets[_user].length;
1502 
1503         if (len > 0) {
1504             while (len >= 0) {
1505                 len--;
1506 
1507                 if (bets[_user][len].won) {
1508                     history = history * 10 + 2;
1509                 } else {
1510                     history = history * 10 + 1;
1511                 }
1512 
1513                 if (len == 0 || history > 10000) {
1514                     break;
1515                 }
1516             }
1517         }
1518     }
1519 
1520     /**
1521     * @dev Calculate possible winning with specific chance and amount
1522     * @param _chance represents chance of winning bet
1523     * @param _amount represents amount that is played for bet
1524     * @return returns uint of players profit with specific chance and amount
1525     */
1526     function getPossibleWinnings(uint _chance, uint _amount) public view returns(uint) {
1527         uint chanceOfMiss = uint(100).sub(_chance);
1528 
1529         uint commission = HOUSE_EDGE.mul(100).div(chanceOfMiss);
1530         // using 100000 because we keep house edge with three decimals, and that is 100 * 1000
1531         return commission < 100000 ? (_amount.mul(chanceOfMiss).div(_chance)).mul(100000-commission).div(100000) : 0;
1532     }
1533 
1534     /**
1535     * @dev Calculate house commission with specific chance and amount
1536     * @param _chance represents chance of winning bet
1537     * @param _amount represents amount that is played for bet
1538     * @return returns uint of house commission with specific chance and amount
1539     */
1540     function getCommission(uint _chance, uint _amount) public view returns(uint) {
1541         uint chanceOfMiss = uint(100).sub(_chance);
1542 
1543         uint commission = HOUSE_EDGE.mul(100).div(chanceOfMiss);
1544         // using 100000 because we keep house edge with three decimals, and that is 100 * 1000
1545         return commission < 100000 ? (_amount.mul(chanceOfMiss).div(_chance)).mul(commission).div(100000) : _amount;
1546     }
1547 
1548     /**
1549     * @dev check chances for specific game type and number
1550     * @param _gameType represents type of game
1551     * @param _number represents number that is being played for that gameType
1552     * @return return value that represents chance of winning with specific number and gameType
1553     */
1554     function getChance(GameType _gameType, uint _number) public pure returns(uint) {
1555         if (_gameType == GameType.RollUnder) {
1556             return _number;
1557         }
1558 
1559         if (_gameType == GameType.RollOver) {
1560             return 99 - _number;
1561         }
1562 
1563         if (_gameType == GameType.IndividualNumber) {
1564             return 1;
1565         }
1566 
1567         if (_gameType == GameType.EvenOrOdd) {
1568             if (_number == 0) {
1569                 return 49;
1570             } else {
1571                 return 50;
1572             }
1573         }
1574 
1575         if (_gameType == GameType.DragonOrTiger) {
1576             if (_number == 2) {
1577                 return 10;
1578             } else {
1579                 return 45;
1580             }
1581         }
1582 
1583         return 0;
1584     }
1585 
1586     /**
1587     * @dev check winning for specific bet for user
1588     * @param _user represents address of user
1589     * @param _betId represents id of bet for specific user
1590     * @return return value that represents users profit, in case round is not finished or bet is lost, returns 0
1591     */
1592     function getUserProfitForFinishedBet(address _user, uint _betId) public view returns(uint) {
1593         Bet memory betObject = bets[_user][_betId];
1594         uint selectedNumber = rounds[betObject.round].selectedNumber;
1595         uint chance = getChance(betObject.gameType, betObject.number);
1596 
1597         if (rounds[betObject.round].state == RoundState.Finished) {
1598             if (betObject.gameType == GameType.RollUnder) {
1599                 if (selectedNumber < betObject.number) {
1600                     return getPossibleWinnings(chance, betObject.amount);
1601                 }
1602             }
1603 
1604             if (betObject.gameType == GameType.RollOver) {
1605                 if (selectedNumber > betObject.number) {
1606                     return getPossibleWinnings(chance, betObject.amount);
1607                 }
1608             }
1609 
1610             if (betObject.gameType == GameType.IndividualNumber) {
1611                 if (selectedNumber == betObject.number) {
1612                     return getPossibleWinnings(chance, betObject.amount);
1613                 }
1614             }
1615 
1616             if (betObject.gameType == GameType.EvenOrOdd) {
1617                 // 0 is not even or odd
1618                 if (selectedNumber % 2 == betObject.number && selectedNumber != 0) {
1619                     return getPossibleWinnings(chance, betObject.amount);
1620                 }
1621             }
1622 
1623             if (betObject.gameType == GameType.DragonOrTiger) {
1624                 uint firstDigit = selectedNumber.div(10);
1625                 uint lastDigit = selectedNumber.mod(10);
1626 
1627                 // dragon
1628                 if (betObject.number == 0 && firstDigit > lastDigit) {
1629                     return getPossibleWinnings(chance, betObject.amount);
1630                 }
1631 
1632                 // tiger
1633                 if (betObject.number == 1 && lastDigit > firstDigit) {
1634                     return getPossibleWinnings(chance, betObject.amount);
1635                 }
1636 
1637                 // tie
1638                 if (betObject.number == 2 && firstDigit == lastDigit) {
1639                     return getPossibleWinnings(chance, betObject.amount);
1640                 }
1641             }
1642         }
1643 
1644         return 0;
1645     }
1646 
1647     function getTokensWonParameters(address _user) public view returns(bytes32, uint, uint) {
1648         Bet memory lastBet = bets[_user][getTotalBets(_user) - 1];
1649 
1650         return (rounds[lastBet.round].randomHash, lastBet.amount, getChance(lastBet.gameType, lastBet.number));
1651     }
1652 
1653     function maxBetSize(uint _chance) public view returns(uint) {
1654         if (USE_DYNAMIC_MAX_BET) {
1655             if (_chance < 13 && _chance > 4) {
1656                 return (_chance * 3 - 5).mul(BENCHMARK_MAXIMUM_BET_SIZE * settings.ETH_TO_WEI()).div(100);
1657             }
1658 
1659             if (_chance < 46) {
1660                 return (_chance * 2 + 8).mul(BENCHMARK_MAXIMUM_BET_SIZE * settings.ETH_TO_WEI()).div(100);
1661             }
1662             if (_chance < 56) {
1663                 return (BENCHMARK_MAXIMUM_BET_SIZE * settings.ETH_TO_WEI());
1664             }
1665 
1666             return (_chance - 55).mul(5).add(100).mul(BENCHMARK_MAXIMUM_BET_SIZE * settings.ETH_TO_WEI()).div(100);
1667         } else {
1668             return MAX_BET;
1669         }
1670     }
1671 
1672     function getBet(address _user, uint _betId) public view returns(uint number, uint round, GameType gameType, uint amount, uint selectedNumber, bool won) {
1673         Bet memory betObject = bets[_user][_betId];
1674 
1675         return (betObject.number, betObject.round, betObject.gameType, betObject.amount, rounds[betObject.round].selectedNumber, getUserProfitForFinishedBet(_user, _betId) > 0);
1676     }
1677 
1678     function getBetInfo(address _user, uint _betId) public view returns(uint amount, bool finalized, bool won, bool isBonus) {
1679         Bet memory betObject = bets[_user][_betId];
1680 
1681         return (betObject.amount, betObject.finished, betObject.won, betObject.bonus);
1682     }
1683 
1684     /**
1685     * @dev checks if number is valid for specific gameType
1686     * @param _gameType represents type of game
1687     * @param _number represents number that is being played for that gameType
1688     * @return return bool true if number is valid and false if that number can't be combined with that gameType
1689     */
1690     function isValidNumber(GameType _gameType, uint _number) public pure returns(bool) {
1691         if (_gameType == GameType.RollUnder) {
1692             return (_number > 4 && _number < 96);
1693         }
1694 
1695         if (_gameType == GameType.RollOver) {
1696             return (_number > 3 && _number < 95);
1697         }
1698 
1699         if (_gameType == GameType.IndividualNumber) {
1700             return (_number < 100);
1701         }
1702 
1703         if (_gameType == GameType.EvenOrOdd) {
1704             return (_number < 2);
1705         }
1706 
1707         if (_gameType == GameType.DragonOrTiger) {
1708             return (_number < 3);
1709         }
1710 
1711         return false;
1712     }
1713 
1714     function getCurrentBalance(address _user) public view returns(uint) {
1715         return casino.getCurrentBalance(_user);
1716     }
1717 
1718     /**
1719     * @dev Checks for number of bets user played
1720     * @param _user address of user
1721     * @return returns uint representing number of total bets played by user
1722     */
1723     function getTotalBets(address _user) public view returns(uint) {
1724         return bets[_user].length;
1725     }
1726 
1727     function lastRound() public view returns(uint) {
1728         return rounds.length-1;
1729     }
1730 
1731     function getParamsForTokenCaluclation(uint _chance) public view returns(uint minB, uint maxB, uint gbs, uint gwp) {
1732         minB = MIN_BET;
1733         maxB = maxBetSize(_chance);
1734         gbs = GBS;
1735         gwp = GWP;
1736     }
1737 
1738     function emergencyWithdraw(address payable _sender) public {
1739         require(msg.sender == address(casino));
1740 
1741         _sender.transfer(address(this).balance);
1742     }
1743 
1744     /**
1745     * @dev Allows anyone to just send ether to contract
1746     */
1747     function() external payable {
1748     }
1749 }