1 pragma solidity 0.5.6;
2 pragma experimental ABIEncoderV2;
3 
4 
5 contract Ownable {
6     address public owner;
7 
8     constructor() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner() {
13         require(msg.sender == owner, "");
14         _;
15     }
16 
17     function transferOwnership(address newOwner) public onlyOwner {
18         require(newOwner != address(0), "");
19         owner = newOwner;
20     }
21 
22 }
23 
24 contract iGames {
25     function processRound(uint round, uint randomNumber) public payable returns (bool);
26     function getPeriod() public view returns (uint);
27 }
28 
29 contract iRandao {
30     function newCampaign(
31         uint32 _bnum,
32         uint96 _deposit,
33         uint16 _commitBalkline,
34         uint16 _commitDeadline
35     )
36         public payable returns (uint256 _campaignID);
37 }
38 
39 
40 // Dummy contract only used to emit to end-user they are using wrong solc
41 contract solcChecker {
42 /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;
43 }
44 
45 contract OraclizeI {
46 
47     address public cbAddress;
48 
49     function setProofType(byte _proofType) external;
50     function setCustomGasPrice(uint _gasPrice) external;
51     function getPrice(string memory _datasource) public returns (uint _dsprice);
52     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
53     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
54     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
55     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
56     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
57     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
58     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
59     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
60 }
61 
62 contract OraclizeAddrResolverI {
63     function getAddress() public returns (address _address);
64 }
65 /*
66 
67 Begin solidity-cborutils
68 
69 https://github.com/smartcontractkit/solidity-cborutils
70 
71 MIT License
72 
73 Copyright (c) 2018 SmartContract ChainLink, Ltd.
74 
75 Permission is hereby granted, free of charge, to any person obtaining a copy
76 of this software and associated documentation files (the "Software"), to deal
77 in the Software without restriction, including without limitation the rights
78 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
79 copies of the Software, and to permit persons to whom the Software is
80 furnished to do so, subject to the following conditions:
81 
82 The above copyright notice and this permission notice shall be included in all
83 copies or substantial portions of the Software.
84 
85 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
86 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
87 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
88 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
89 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
90 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
91 SOFTWARE.
92 
93 */
94 library Buffer {
95 
96     struct buffer {
97         bytes buf;
98         uint capacity;
99     }
100 
101     function init(buffer memory _buf, uint _capacity) internal pure {
102         uint capacity = _capacity;
103         if (capacity % 32 != 0) {
104             capacity += 32 - (capacity % 32);
105         }
106         _buf.capacity = capacity; // Allocate space for the buffer data
107         assembly {
108             let ptr := mload(0x40)
109             mstore(_buf, ptr)
110             mstore(ptr, 0)
111             mstore(0x40, add(ptr, capacity))
112         }
113     }
114 
115     function resize(buffer memory _buf, uint _capacity) private pure {
116         bytes memory oldbuf = _buf.buf;
117         init(_buf, _capacity);
118         append(_buf, oldbuf);
119     }
120 
121     function max(uint _a, uint _b) private pure returns (uint _max) {
122         if (_a > _b) {
123             return _a;
124         }
125         return _b;
126     }
127     /**
128       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
129       *      would exceed the capacity of the buffer.
130       * @param _buf The buffer to append to.
131       * @param _data The data to append.
132       * @return The original buffer.
133       *
134       */
135     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
136         if (_data.length + _buf.buf.length > _buf.capacity) {
137             resize(_buf, max(_buf.capacity, _data.length) * 2);
138         }
139         uint dest;
140         uint src;
141         uint len = _data.length;
142         assembly {
143             let bufptr := mload(_buf) // Memory address of the buffer data
144             let buflen := mload(bufptr) // Length of existing buffer data
145             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
146             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
147             src := add(_data, 32)
148         }
149         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
150             assembly {
151                 mstore(dest, mload(src))
152             }
153             dest += 32;
154             src += 32;
155         }
156         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
157         assembly {
158             let srcpart := and(mload(src), not(mask))
159             let destpart := and(mload(dest), mask)
160             mstore(dest, or(destpart, srcpart))
161         }
162         return _buf;
163     }
164     /**
165       *
166       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
167       * exceed the capacity of the buffer.
168       * @param _buf The buffer to append to.
169       * @param _data The data to append.
170       * @return The original buffer.
171       *
172       */
173     function append(buffer memory _buf, uint8 _data) internal pure {
174         if (_buf.buf.length + 1 > _buf.capacity) {
175             resize(_buf, _buf.capacity * 2);
176         }
177         assembly {
178             let bufptr := mload(_buf) // Memory address of the buffer data
179             let buflen := mload(bufptr) // Length of existing buffer data
180             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
181             mstore8(dest, _data)
182             mstore(bufptr, add(buflen, 1)) // Update buffer length
183         }
184     }
185     /**
186       *
187       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
188       * exceed the capacity of the buffer.
189       * @param _buf The buffer to append to.
190       * @param _data The data to append.
191       * @return The original buffer.
192       *
193       */
194     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
195         if (_len + _buf.buf.length > _buf.capacity) {
196             resize(_buf, max(_buf.capacity, _len) * 2);
197         }
198         uint mask = 256 ** _len - 1;
199         assembly {
200             let bufptr := mload(_buf) // Memory address of the buffer data
201             let buflen := mload(bufptr) // Length of existing buffer data
202             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
203             mstore(dest, or(and(mload(dest), not(mask)), _data))
204             mstore(bufptr, add(buflen, _len)) // Update buffer length
205         }
206         return _buf;
207     }
208 }
209 
210 library CBOR {
211 
212     using Buffer for Buffer.buffer;
213 
214     uint8 private constant MAJOR_TYPE_INT = 0;
215     uint8 private constant MAJOR_TYPE_MAP = 5;
216     uint8 private constant MAJOR_TYPE_BYTES = 2;
217     uint8 private constant MAJOR_TYPE_ARRAY = 4;
218     uint8 private constant MAJOR_TYPE_STRING = 3;
219     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
220     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
221 
222     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
223         if (_value <= 23) {
224             _buf.append(uint8((_major << 5) | _value));
225         } else if (_value <= 0xFF) {
226             _buf.append(uint8((_major << 5) | 24));
227             _buf.appendInt(_value, 1);
228         } else if (_value <= 0xFFFF) {
229             _buf.append(uint8((_major << 5) | 25));
230             _buf.appendInt(_value, 2);
231         } else if (_value <= 0xFFFFFFFF) {
232             _buf.append(uint8((_major << 5) | 26));
233             _buf.appendInt(_value, 4);
234         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
235             _buf.append(uint8((_major << 5) | 27));
236             _buf.appendInt(_value, 8);
237         }
238     }
239 
240     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
241         _buf.append(uint8((_major << 5) | 31));
242     }
243 
244     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
245         encodeType(_buf, MAJOR_TYPE_INT, _value);
246     }
247 
248     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
249         if (_value >= 0) {
250             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
251         } else {
252             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
253         }
254     }
255 
256     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
257         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
258         _buf.append(_value);
259     }
260 
261     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
262         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
263         _buf.append(bytes(_value));
264     }
265 
266     function startArray(Buffer.buffer memory _buf) internal pure {
267         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
268     }
269 
270     function startMap(Buffer.buffer memory _buf) internal pure {
271         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
272     }
273 
274     function endSequence(Buffer.buffer memory _buf) internal pure {
275         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
276     }
277 }
278 /*
279 
280 End solidity-cborutils
281 
282 */
283 contract usingOraclize {
284 
285     using CBOR for Buffer.buffer;
286 
287     OraclizeI oraclize;
288     OraclizeAddrResolverI OAR;
289 
290     uint constant day = 60 * 60 * 24;
291     uint constant week = 60 * 60 * 24 * 7;
292     uint constant month = 60 * 60 * 24 * 30;
293 
294     byte constant proofType_NONE = 0x00;
295     byte constant proofType_Ledger = 0x30;
296     byte constant proofType_Native = 0xF0;
297     byte constant proofStorage_IPFS = 0x01;
298     byte constant proofType_Android = 0x40;
299     byte constant proofType_TLSNotary = 0x10;
300 
301     string oraclize_network_name;
302     uint8 constant networkID_auto = 0;
303     uint8 constant networkID_morden = 2;
304     uint8 constant networkID_mainnet = 1;
305     uint8 constant networkID_testnet = 2;
306     uint8 constant networkID_consensys = 161;
307 
308     mapping(bytes32 => bytes32) oraclize_randomDS_args;
309     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
310 
311     modifier oraclizeAPI {
312         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
313             oraclize_setNetwork(networkID_auto);
314         }
315         if (address(oraclize) != OAR.getAddress()) {
316             oraclize = OraclizeI(OAR.getAddress());
317         }
318         _;
319     }
320 
321     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
322         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
323         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
324         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
325         require(proofVerified);
326         _;
327     }
328 
329     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
330       return oraclize_setNetwork();
331       _networkID; // silence the warning and remain backwards compatible
332     }
333 
334     function oraclize_setNetworkName(string memory _network_name) internal {
335         oraclize_network_name = _network_name;
336     }
337 
338     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
339         return oraclize_network_name;
340     }
341 
342     function oraclize_setNetwork() internal returns (bool _networkSet) {
343         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
344             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
345             oraclize_setNetworkName("eth_mainnet");
346             return true;
347         }
348         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
349             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
350             oraclize_setNetworkName("eth_ropsten3");
351             return true;
352         }
353         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
354             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
355             oraclize_setNetworkName("eth_kovan");
356             return true;
357         }
358         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
359             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
360             oraclize_setNetworkName("eth_rinkeby");
361             return true;
362         }
363         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
364             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
365             return true;
366         }
367         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
368             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
369             return true;
370         }
371         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
372             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
373             return true;
374         }
375         return false;
376     }
377 
378     function __callback(bytes32 _myid, string memory _result) public {
379         __callback(_myid, _result, new bytes(0));
380     }
381 
382     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
383       return;
384       _myid; _result; _proof; // Silence compiler warnings
385     }
386 
387     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
388         return oraclize.getPrice(_datasource);
389     }
390 
391     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
392         return oraclize.getPrice(_datasource, _gasLimit);
393     }
394 
395     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
396         uint price = oraclize.getPrice(_datasource);
397         if (price > 1 ether + tx.gasprice * 200000) {
398             return 0; // Unexpectedly high price
399         }
400         return oraclize.query.value(price)(0, _datasource, _arg);
401     }
402 
403     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
404         uint price = oraclize.getPrice(_datasource);
405         if (price > 1 ether + tx.gasprice * 200000) {
406             return 0; // Unexpectedly high price
407         }
408         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
409     }
410 
411     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
412         uint price = oraclize.getPrice(_datasource,_gasLimit);
413         if (price > 1 ether + tx.gasprice * _gasLimit) {
414             return 0; // Unexpectedly high price
415         }
416         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
417     }
418 
419     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
420         uint price = oraclize.getPrice(_datasource, _gasLimit);
421         if (price > 1 ether + tx.gasprice * _gasLimit) {
422            return 0; // Unexpectedly high price
423         }
424         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
425     }
426 
427     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
428         uint price = oraclize.getPrice(_datasource);
429         if (price > 1 ether + tx.gasprice * 200000) {
430             return 0; // Unexpectedly high price
431         }
432         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
433     }
434 
435     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
436         uint price = oraclize.getPrice(_datasource);
437         if (price > 1 ether + tx.gasprice * 200000) {
438             return 0; // Unexpectedly high price
439         }
440         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
441     }
442 
443     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
444         uint price = oraclize.getPrice(_datasource, _gasLimit);
445         if (price > 1 ether + tx.gasprice * _gasLimit) {
446             return 0; // Unexpectedly high price
447         }
448         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
449     }
450 
451     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
452         uint price = oraclize.getPrice(_datasource, _gasLimit);
453         if (price > 1 ether + tx.gasprice * _gasLimit) {
454             return 0; // Unexpectedly high price
455         }
456         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
457     }
458 
459     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
460         uint price = oraclize.getPrice(_datasource);
461         if (price > 1 ether + tx.gasprice * 200000) {
462             return 0; // Unexpectedly high price
463         }
464         bytes memory args = stra2cbor(_argN);
465         return oraclize.queryN.value(price)(0, _datasource, args);
466     }
467 
468     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
469         uint price = oraclize.getPrice(_datasource);
470         if (price > 1 ether + tx.gasprice * 200000) {
471             return 0; // Unexpectedly high price
472         }
473         bytes memory args = stra2cbor(_argN);
474         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
475     }
476 
477     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
478         uint price = oraclize.getPrice(_datasource, _gasLimit);
479         if (price > 1 ether + tx.gasprice * _gasLimit) {
480             return 0; // Unexpectedly high price
481         }
482         bytes memory args = stra2cbor(_argN);
483         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
484     }
485 
486     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
487         uint price = oraclize.getPrice(_datasource, _gasLimit);
488         if (price > 1 ether + tx.gasprice * _gasLimit) {
489             return 0; // Unexpectedly high price
490         }
491         bytes memory args = stra2cbor(_argN);
492         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
493     }
494 
495     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
496         string[] memory dynargs = new string[](1);
497         dynargs[0] = _args[0];
498         return oraclize_query(_datasource, dynargs);
499     }
500 
501     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
502         string[] memory dynargs = new string[](1);
503         dynargs[0] = _args[0];
504         return oraclize_query(_timestamp, _datasource, dynargs);
505     }
506 
507     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
508         string[] memory dynargs = new string[](1);
509         dynargs[0] = _args[0];
510         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
511     }
512 
513     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
514         string[] memory dynargs = new string[](1);
515         dynargs[0] = _args[0];
516         return oraclize_query(_datasource, dynargs, _gasLimit);
517     }
518 
519     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
520         string[] memory dynargs = new string[](2);
521         dynargs[0] = _args[0];
522         dynargs[1] = _args[1];
523         return oraclize_query(_datasource, dynargs);
524     }
525 
526     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
527         string[] memory dynargs = new string[](2);
528         dynargs[0] = _args[0];
529         dynargs[1] = _args[1];
530         return oraclize_query(_timestamp, _datasource, dynargs);
531     }
532 
533     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
534         string[] memory dynargs = new string[](2);
535         dynargs[0] = _args[0];
536         dynargs[1] = _args[1];
537         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
538     }
539 
540     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
541         string[] memory dynargs = new string[](2);
542         dynargs[0] = _args[0];
543         dynargs[1] = _args[1];
544         return oraclize_query(_datasource, dynargs, _gasLimit);
545     }
546 
547     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
548         string[] memory dynargs = new string[](3);
549         dynargs[0] = _args[0];
550         dynargs[1] = _args[1];
551         dynargs[2] = _args[2];
552         return oraclize_query(_datasource, dynargs);
553     }
554 
555     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
556         string[] memory dynargs = new string[](3);
557         dynargs[0] = _args[0];
558         dynargs[1] = _args[1];
559         dynargs[2] = _args[2];
560         return oraclize_query(_timestamp, _datasource, dynargs);
561     }
562 
563     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
564         string[] memory dynargs = new string[](3);
565         dynargs[0] = _args[0];
566         dynargs[1] = _args[1];
567         dynargs[2] = _args[2];
568         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
569     }
570 
571     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
572         string[] memory dynargs = new string[](3);
573         dynargs[0] = _args[0];
574         dynargs[1] = _args[1];
575         dynargs[2] = _args[2];
576         return oraclize_query(_datasource, dynargs, _gasLimit);
577     }
578 
579     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
580         string[] memory dynargs = new string[](4);
581         dynargs[0] = _args[0];
582         dynargs[1] = _args[1];
583         dynargs[2] = _args[2];
584         dynargs[3] = _args[3];
585         return oraclize_query(_datasource, dynargs);
586     }
587 
588     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
589         string[] memory dynargs = new string[](4);
590         dynargs[0] = _args[0];
591         dynargs[1] = _args[1];
592         dynargs[2] = _args[2];
593         dynargs[3] = _args[3];
594         return oraclize_query(_timestamp, _datasource, dynargs);
595     }
596 
597     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
598         string[] memory dynargs = new string[](4);
599         dynargs[0] = _args[0];
600         dynargs[1] = _args[1];
601         dynargs[2] = _args[2];
602         dynargs[3] = _args[3];
603         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
604     }
605 
606     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
607         string[] memory dynargs = new string[](4);
608         dynargs[0] = _args[0];
609         dynargs[1] = _args[1];
610         dynargs[2] = _args[2];
611         dynargs[3] = _args[3];
612         return oraclize_query(_datasource, dynargs, _gasLimit);
613     }
614 
615     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
616         string[] memory dynargs = new string[](5);
617         dynargs[0] = _args[0];
618         dynargs[1] = _args[1];
619         dynargs[2] = _args[2];
620         dynargs[3] = _args[3];
621         dynargs[4] = _args[4];
622         return oraclize_query(_datasource, dynargs);
623     }
624 
625     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
626         string[] memory dynargs = new string[](5);
627         dynargs[0] = _args[0];
628         dynargs[1] = _args[1];
629         dynargs[2] = _args[2];
630         dynargs[3] = _args[3];
631         dynargs[4] = _args[4];
632         return oraclize_query(_timestamp, _datasource, dynargs);
633     }
634 
635     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
636         string[] memory dynargs = new string[](5);
637         dynargs[0] = _args[0];
638         dynargs[1] = _args[1];
639         dynargs[2] = _args[2];
640         dynargs[3] = _args[3];
641         dynargs[4] = _args[4];
642         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
643     }
644 
645     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
646         string[] memory dynargs = new string[](5);
647         dynargs[0] = _args[0];
648         dynargs[1] = _args[1];
649         dynargs[2] = _args[2];
650         dynargs[3] = _args[3];
651         dynargs[4] = _args[4];
652         return oraclize_query(_datasource, dynargs, _gasLimit);
653     }
654 
655     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
656         uint price = oraclize.getPrice(_datasource);
657         if (price > 1 ether + tx.gasprice * 200000) {
658             return 0; // Unexpectedly high price
659         }
660         bytes memory args = ba2cbor(_argN);
661         return oraclize.queryN.value(price)(0, _datasource, args);
662     }
663 
664     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
665         uint price = oraclize.getPrice(_datasource);
666         if (price > 1 ether + tx.gasprice * 200000) {
667             return 0; // Unexpectedly high price
668         }
669         bytes memory args = ba2cbor(_argN);
670         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
671     }
672 
673     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
674         uint price = oraclize.getPrice(_datasource, _gasLimit);
675         if (price > 1 ether + tx.gasprice * _gasLimit) {
676             return 0; // Unexpectedly high price
677         }
678         bytes memory args = ba2cbor(_argN);
679         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
680     }
681 
682     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
683         uint price = oraclize.getPrice(_datasource, _gasLimit);
684         if (price > 1 ether + tx.gasprice * _gasLimit) {
685             return 0; // Unexpectedly high price
686         }
687         bytes memory args = ba2cbor(_argN);
688         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
689     }
690 
691     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
692         bytes[] memory dynargs = new bytes[](1);
693         dynargs[0] = _args[0];
694         return oraclize_query(_datasource, dynargs);
695     }
696 
697     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
698         bytes[] memory dynargs = new bytes[](1);
699         dynargs[0] = _args[0];
700         return oraclize_query(_timestamp, _datasource, dynargs);
701     }
702 
703     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
704         bytes[] memory dynargs = new bytes[](1);
705         dynargs[0] = _args[0];
706         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
707     }
708 
709     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
710         bytes[] memory dynargs = new bytes[](1);
711         dynargs[0] = _args[0];
712         return oraclize_query(_datasource, dynargs, _gasLimit);
713     }
714 
715     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
716         bytes[] memory dynargs = new bytes[](2);
717         dynargs[0] = _args[0];
718         dynargs[1] = _args[1];
719         return oraclize_query(_datasource, dynargs);
720     }
721 
722     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
723         bytes[] memory dynargs = new bytes[](2);
724         dynargs[0] = _args[0];
725         dynargs[1] = _args[1];
726         return oraclize_query(_timestamp, _datasource, dynargs);
727     }
728 
729     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
730         bytes[] memory dynargs = new bytes[](2);
731         dynargs[0] = _args[0];
732         dynargs[1] = _args[1];
733         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
734     }
735 
736     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
737         bytes[] memory dynargs = new bytes[](2);
738         dynargs[0] = _args[0];
739         dynargs[1] = _args[1];
740         return oraclize_query(_datasource, dynargs, _gasLimit);
741     }
742 
743     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
744         bytes[] memory dynargs = new bytes[](3);
745         dynargs[0] = _args[0];
746         dynargs[1] = _args[1];
747         dynargs[2] = _args[2];
748         return oraclize_query(_datasource, dynargs);
749     }
750 
751     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
752         bytes[] memory dynargs = new bytes[](3);
753         dynargs[0] = _args[0];
754         dynargs[1] = _args[1];
755         dynargs[2] = _args[2];
756         return oraclize_query(_timestamp, _datasource, dynargs);
757     }
758 
759     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
760         bytes[] memory dynargs = new bytes[](3);
761         dynargs[0] = _args[0];
762         dynargs[1] = _args[1];
763         dynargs[2] = _args[2];
764         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
765     }
766 
767     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
768         bytes[] memory dynargs = new bytes[](3);
769         dynargs[0] = _args[0];
770         dynargs[1] = _args[1];
771         dynargs[2] = _args[2];
772         return oraclize_query(_datasource, dynargs, _gasLimit);
773     }
774 
775     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
776         bytes[] memory dynargs = new bytes[](4);
777         dynargs[0] = _args[0];
778         dynargs[1] = _args[1];
779         dynargs[2] = _args[2];
780         dynargs[3] = _args[3];
781         return oraclize_query(_datasource, dynargs);
782     }
783 
784     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
785         bytes[] memory dynargs = new bytes[](4);
786         dynargs[0] = _args[0];
787         dynargs[1] = _args[1];
788         dynargs[2] = _args[2];
789         dynargs[3] = _args[3];
790         return oraclize_query(_timestamp, _datasource, dynargs);
791     }
792 
793     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
794         bytes[] memory dynargs = new bytes[](4);
795         dynargs[0] = _args[0];
796         dynargs[1] = _args[1];
797         dynargs[2] = _args[2];
798         dynargs[3] = _args[3];
799         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
800     }
801 
802     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
803         bytes[] memory dynargs = new bytes[](4);
804         dynargs[0] = _args[0];
805         dynargs[1] = _args[1];
806         dynargs[2] = _args[2];
807         dynargs[3] = _args[3];
808         return oraclize_query(_datasource, dynargs, _gasLimit);
809     }
810 
811     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
812         bytes[] memory dynargs = new bytes[](5);
813         dynargs[0] = _args[0];
814         dynargs[1] = _args[1];
815         dynargs[2] = _args[2];
816         dynargs[3] = _args[3];
817         dynargs[4] = _args[4];
818         return oraclize_query(_datasource, dynargs);
819     }
820 
821     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
822         bytes[] memory dynargs = new bytes[](5);
823         dynargs[0] = _args[0];
824         dynargs[1] = _args[1];
825         dynargs[2] = _args[2];
826         dynargs[3] = _args[3];
827         dynargs[4] = _args[4];
828         return oraclize_query(_timestamp, _datasource, dynargs);
829     }
830 
831     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
832         bytes[] memory dynargs = new bytes[](5);
833         dynargs[0] = _args[0];
834         dynargs[1] = _args[1];
835         dynargs[2] = _args[2];
836         dynargs[3] = _args[3];
837         dynargs[4] = _args[4];
838         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
839     }
840 
841     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
842         bytes[] memory dynargs = new bytes[](5);
843         dynargs[0] = _args[0];
844         dynargs[1] = _args[1];
845         dynargs[2] = _args[2];
846         dynargs[3] = _args[3];
847         dynargs[4] = _args[4];
848         return oraclize_query(_datasource, dynargs, _gasLimit);
849     }
850 
851     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
852         return oraclize.setProofType(_proofP);
853     }
854 
855 
856     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
857         return oraclize.cbAddress();
858     }
859 
860     function getCodeSize(address _addr) view internal returns (uint _size) {
861         assembly {
862             _size := extcodesize(_addr)
863         }
864     }
865 
866     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
867         return oraclize.setCustomGasPrice(_gasPrice);
868     }
869 
870     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
871         return oraclize.randomDS_getSessionPubKeyHash();
872     }
873 
874     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
875         bytes memory tmp = bytes(_a);
876         uint160 iaddr = 0;
877         uint160 b1;
878         uint160 b2;
879         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
880             iaddr *= 256;
881             b1 = uint160(uint8(tmp[i]));
882             b2 = uint160(uint8(tmp[i + 1]));
883             if ((b1 >= 97) && (b1 <= 102)) {
884                 b1 -= 87;
885             } else if ((b1 >= 65) && (b1 <= 70)) {
886                 b1 -= 55;
887             } else if ((b1 >= 48) && (b1 <= 57)) {
888                 b1 -= 48;
889             }
890             if ((b2 >= 97) && (b2 <= 102)) {
891                 b2 -= 87;
892             } else if ((b2 >= 65) && (b2 <= 70)) {
893                 b2 -= 55;
894             } else if ((b2 >= 48) && (b2 <= 57)) {
895                 b2 -= 48;
896             }
897             iaddr += (b1 * 16 + b2);
898         }
899         return address(iaddr);
900     }
901 
902     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
903         bytes memory a = bytes(_a);
904         bytes memory b = bytes(_b);
905         uint minLength = a.length;
906         if (b.length < minLength) {
907             minLength = b.length;
908         }
909         for (uint i = 0; i < minLength; i ++) {
910             if (a[i] < b[i]) {
911                 return -1;
912             } else if (a[i] > b[i]) {
913                 return 1;
914             }
915         }
916         if (a.length < b.length) {
917             return -1;
918         } else if (a.length > b.length) {
919             return 1;
920         } else {
921             return 0;
922         }
923     }
924 
925     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
926         bytes memory h = bytes(_haystack);
927         bytes memory n = bytes(_needle);
928         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
929             return -1;
930         } else if (h.length > (2 ** 128 - 1)) {
931             return -1;
932         } else {
933             uint subindex = 0;
934             for (uint i = 0; i < h.length; i++) {
935                 if (h[i] == n[0]) {
936                     subindex = 1;
937                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
938                         subindex++;
939                     }
940                     if (subindex == n.length) {
941                         return int(i);
942                     }
943                 }
944             }
945             return -1;
946         }
947     }
948 
949     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
950         return strConcat(_a, _b, "", "", "");
951     }
952 
953     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
954         return strConcat(_a, _b, _c, "", "");
955     }
956 
957     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
958         return strConcat(_a, _b, _c, _d, "");
959     }
960 
961     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
962         bytes memory _ba = bytes(_a);
963         bytes memory _bb = bytes(_b);
964         bytes memory _bc = bytes(_c);
965         bytes memory _bd = bytes(_d);
966         bytes memory _be = bytes(_e);
967         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
968         bytes memory babcde = bytes(abcde);
969         uint k = 0;
970         uint i = 0;
971         for (i = 0; i < _ba.length; i++) {
972             babcde[k++] = _ba[i];
973         }
974         for (i = 0; i < _bb.length; i++) {
975             babcde[k++] = _bb[i];
976         }
977         for (i = 0; i < _bc.length; i++) {
978             babcde[k++] = _bc[i];
979         }
980         for (i = 0; i < _bd.length; i++) {
981             babcde[k++] = _bd[i];
982         }
983         for (i = 0; i < _be.length; i++) {
984             babcde[k++] = _be[i];
985         }
986         return string(babcde);
987     }
988 
989     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
990         return safeParseInt(_a, 0);
991     }
992 
993     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
994         bytes memory bresult = bytes(_a);
995         uint mint = 0;
996         bool decimals = false;
997         for (uint i = 0; i < bresult.length; i++) {
998             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
999                 if (decimals) {
1000                    if (_b == 0) break;
1001                     else _b--;
1002                 }
1003                 mint *= 10;
1004                 mint += uint(uint8(bresult[i])) - 48;
1005             } else if (uint(uint8(bresult[i])) == 46) {
1006                 require(!decimals, 'More than one decimal encountered in string!');
1007                 decimals = true;
1008             } else {
1009                 revert("Non-numeral character encountered in string!");
1010             }
1011         }
1012         if (_b > 0) {
1013             mint *= 10 ** _b;
1014         }
1015         return mint;
1016     }
1017 
1018     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
1019         return parseInt(_a, 0);
1020     }
1021 
1022     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1023         bytes memory bresult = bytes(_a);
1024         uint mint = 0;
1025         bool decimals = false;
1026         for (uint i = 0; i < bresult.length; i++) {
1027             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1028                 if (decimals) {
1029                    if (_b == 0) {
1030                        break;
1031                    } else {
1032                        _b--;
1033                    }
1034                 }
1035                 mint *= 10;
1036                 mint += uint(uint8(bresult[i])) - 48;
1037             } else if (uint(uint8(bresult[i])) == 46) {
1038                 decimals = true;
1039             }
1040         }
1041         if (_b > 0) {
1042             mint *= 10 ** _b;
1043         }
1044         return mint;
1045     }
1046 
1047     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1048         if (_i == 0) {
1049             return "0";
1050         }
1051         uint j = _i;
1052         uint len;
1053         while (j != 0) {
1054             len++;
1055             j /= 10;
1056         }
1057         bytes memory bstr = new bytes(len);
1058         uint k = len - 1;
1059         while (_i != 0) {
1060             bstr[k--] = byte(uint8(48 + _i % 10));
1061             _i /= 10;
1062         }
1063         return string(bstr);
1064     }
1065 
1066     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1067         safeMemoryCleaner();
1068         Buffer.buffer memory buf;
1069         Buffer.init(buf, 1024);
1070         buf.startArray();
1071         for (uint i = 0; i < _arr.length; i++) {
1072             buf.encodeString(_arr[i]);
1073         }
1074         buf.endSequence();
1075         return buf.buf;
1076     }
1077 
1078     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1079         safeMemoryCleaner();
1080         Buffer.buffer memory buf;
1081         Buffer.init(buf, 1024);
1082         buf.startArray();
1083         for (uint i = 0; i < _arr.length; i++) {
1084             buf.encodeBytes(_arr[i]);
1085         }
1086         buf.endSequence();
1087         return buf.buf;
1088     }
1089 
1090     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1091         require((_nbytes > 0) && (_nbytes <= 32));
1092         _delay *= 10; // Convert from seconds to ledger timer ticks
1093         bytes memory nbytes = new bytes(1);
1094         nbytes[0] = byte(uint8(_nbytes));
1095         bytes memory unonce = new bytes(32);
1096         bytes memory sessionKeyHash = new bytes(32);
1097         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1098         assembly {
1099             mstore(unonce, 0x20)
1100             /*
1101              The following variables can be relaxed.
1102              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1103              for an idea on how to override and replace commit hash variables.
1104             */
1105             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1106             mstore(sessionKeyHash, 0x20)
1107             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1108         }
1109         bytes memory delay = new bytes(32);
1110         assembly {
1111             mstore(add(delay, 0x20), _delay)
1112         }
1113         bytes memory delay_bytes8 = new bytes(8);
1114         copyBytes(delay, 24, 8, delay_bytes8, 0);
1115         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1116         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1117         bytes memory delay_bytes8_left = new bytes(8);
1118         assembly {
1119             let x := mload(add(delay_bytes8, 0x20))
1120             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1121             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1122             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1123             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1124             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1125             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1126             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1127             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1128         }
1129         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1130         return queryId;
1131     }
1132 
1133     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1134         oraclize_randomDS_args[_queryId] = _commitment;
1135     }
1136 
1137     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1138         bool sigok;
1139         address signer;
1140         bytes32 sigr;
1141         bytes32 sigs;
1142         bytes memory sigr_ = new bytes(32);
1143         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1144         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1145         bytes memory sigs_ = new bytes(32);
1146         offset += 32 + 2;
1147         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1148         assembly {
1149             sigr := mload(add(sigr_, 32))
1150             sigs := mload(add(sigs_, 32))
1151         }
1152         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1153         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1154             return true;
1155         } else {
1156             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1157             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1158         }
1159     }
1160 
1161     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1162         bool sigok;
1163         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1164         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1165         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1166         bytes memory appkey1_pubkey = new bytes(64);
1167         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1168         bytes memory tosign2 = new bytes(1 + 65 + 32);
1169         tosign2[0] = byte(uint8(1)); //role
1170         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1171         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1172         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1173         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1174         if (!sigok) {
1175             return false;
1176         }
1177         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1178         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1179         bytes memory tosign3 = new bytes(1 + 65);
1180         tosign3[0] = 0xFE;
1181         copyBytes(_proof, 3, 65, tosign3, 1);
1182         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1183         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1184         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1185         return sigok;
1186     }
1187 
1188     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1189         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1190         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1191             return 1;
1192         }
1193         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1194         if (!proofVerified) {
1195             return 2;
1196         }
1197         return 0;
1198     }
1199 
1200     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1201         bool match_ = true;
1202         require(_prefix.length == _nRandomBytes);
1203         for (uint256 i = 0; i< _nRandomBytes; i++) {
1204             if (_content[i] != _prefix[i]) {
1205                 match_ = false;
1206             }
1207         }
1208         return match_;
1209     }
1210 
1211     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1212         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1213         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1214         bytes memory keyhash = new bytes(32);
1215         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1216         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1217             return false;
1218         }
1219         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1220         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1221         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1222         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1223             return false;
1224         }
1225         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1226         // This is to verify that the computed args match with the ones specified in the query.
1227         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1228         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1229         bytes memory sessionPubkey = new bytes(64);
1230         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1231         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1232         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1233         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1234             delete oraclize_randomDS_args[_queryId];
1235         } else return false;
1236         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1237         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1238         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1239         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1240             return false;
1241         }
1242         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1243         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1244             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1245         }
1246         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1247     }
1248     /*
1249      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1250     */
1251     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1252         uint minLength = _length + _toOffset;
1253         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1254         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1255         uint j = 32 + _toOffset;
1256         while (i < (32 + _fromOffset + _length)) {
1257             assembly {
1258                 let tmp := mload(add(_from, i))
1259                 mstore(add(_to, j), tmp)
1260             }
1261             i += 32;
1262             j += 32;
1263         }
1264         return _to;
1265     }
1266     /*
1267      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1268      Duplicate Solidity's ecrecover, but catching the CALL return value
1269     */
1270     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1271         /*
1272          We do our own memory management here. Solidity uses memory offset
1273          0x40 to store the current end of memory. We write past it (as
1274          writes are memory extensions), but don't update the offset so
1275          Solidity will reuse it. The memory used here is only needed for
1276          this context.
1277          FIXME: inline assembly can't access return values
1278         */
1279         bool ret;
1280         address addr;
1281         assembly {
1282             let size := mload(0x40)
1283             mstore(size, _hash)
1284             mstore(add(size, 32), _v)
1285             mstore(add(size, 64), _r)
1286             mstore(add(size, 96), _s)
1287             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1288             addr := mload(size)
1289         }
1290         return (ret, addr);
1291     }
1292     /*
1293      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1294     */
1295     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1296         bytes32 r;
1297         bytes32 s;
1298         uint8 v;
1299         if (_sig.length != 65) {
1300             return (false, address(0));
1301         }
1302         /*
1303          The signature format is a compact form of:
1304            {bytes32 r}{bytes32 s}{uint8 v}
1305          Compact means, uint8 is not padded to 32 bytes.
1306         */
1307         assembly {
1308             r := mload(add(_sig, 32))
1309             s := mload(add(_sig, 64))
1310             /*
1311              Here we are loading the last 32 bytes. We exploit the fact that
1312              'mload' will pad with zeroes if we overread.
1313              There is no 'mload8' to do this, but that would be nicer.
1314             */
1315             v := byte(0, mload(add(_sig, 96)))
1316             /*
1317               Alternative solution:
1318               'byte' is not working due to the Solidity parser, so lets
1319               use the second best option, 'and'
1320               v := and(mload(add(_sig, 65)), 255)
1321             */
1322         }
1323         /*
1324          albeit non-transactional signatures are not specified by the YP, one would expect it
1325          to match the YP range of [27, 28]
1326          geth uses [0, 1] and some clients have followed. This might change, see:
1327          https://github.com/ethereum/go-ethereum/issues/2053
1328         */
1329         if (v < 27) {
1330             v += 27;
1331         }
1332         if (v != 27 && v != 28) {
1333             return (false, address(0));
1334         }
1335         return safer_ecrecover(_hash, v, r, s);
1336     }
1337 
1338     function safeMemoryCleaner() internal pure {
1339         assembly {
1340             let fmem := mload(0x40)
1341             codecopy(fmem, codesize, sub(msize, fmem))
1342         }
1343     }
1344 }
1345 /*
1346 
1347 END ORACLIZE_API
1348 
1349 */
1350 
1351 
1352 contract Whitelist is Ownable {
1353     mapping(address => bool) public whitelist;
1354 
1355     event WhitelistedAddressAdded(address addr);
1356     event WhitelistedAddressRemoved(address addr);
1357 
1358     modifier onlyWhitelisted() {
1359         require(whitelist[msg.sender], "");
1360         _;
1361     }
1362 
1363     function addAddressToWhitelist(address addr) public onlyOwner returns (bool success) {
1364         if ((!whitelist[addr]) && (addr != address(0))) {
1365             whitelist[addr] = true;
1366             emit WhitelistedAddressAdded(addr);
1367             success = true;
1368         }
1369     }
1370 
1371     function addAddressesToWhitelist(address[] memory addrs) public onlyOwner returns (bool success) {
1372         for (uint256 i = 0; i < addrs.length; i++) {
1373             if (addAddressToWhitelist(addrs[i])) {
1374                 success = true;
1375             }
1376         }
1377     }
1378 
1379     function removeAddressFromWhitelist(address addr) public onlyOwner returns(bool success) {
1380         if (whitelist[addr]) {
1381             whitelist[addr] = false;
1382             emit WhitelistedAddressRemoved(addr);
1383             success = true;
1384         }
1385     }
1386 
1387     function removeAddressesFromWhitelist(address[] memory addrs) public onlyOwner returns(bool success) {
1388         for (uint256 i = 0; i < addrs.length; i++) {
1389             if (removeAddressFromWhitelist(addrs[i])) {
1390                 success = true;
1391             }
1392         }
1393     }
1394 
1395 }
1396 
1397 
1398 
1399 contract RNG is usingOraclize, Ownable, Whitelist {
1400 
1401     struct Request {
1402         address game;
1403         uint round;
1404     }
1405 
1406     mapping(bytes32 => Request) public requests; // requests from game to oraclize
1407 
1408     uint public callbackGas = 2000000;
1409 
1410     bool public useOraclize;
1411 
1412     address randao;
1413 
1414     event RequestIsSended(address game, uint round, bytes32 queryId);
1415     event CallbackIsNotCorrect(address game, bytes32  queryId);
1416     event Withdraw(address to, uint value);
1417 
1418     constructor(bool _useOraclize) public {
1419         useOraclize = _useOraclize;
1420         if (useOraclize) oraclize_setProof(proofType_Ledger);
1421     }
1422 
1423     function () external payable {
1424 
1425     }
1426 
1427     function __callback(bytes32 _queryId, string memory _result, bytes memory _proof) public {
1428         if (msg.sender != oraclize_cbAddress()) revert("");
1429 
1430         if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0) {
1431             emit CallbackIsNotCorrect(address(requests[_queryId].game), _queryId);
1432         } else {
1433             iGames temp = iGames(requests[_queryId].game);
1434 
1435             assert(temp.processRound(requests[_queryId].round, uint(keccak256(abi.encodePacked(_result)))));
1436         }
1437     }
1438 
1439     function __callback(bytes32 _queryId, uint _result) public {
1440         if (msg.sender != randao) revert("");
1441 
1442         iGames temp = iGames(requests[_queryId].game);
1443 
1444         assert(temp.processRound(requests[_queryId].round, uint(keccak256(abi.encodePacked(_result)))));
1445 
1446     }
1447 
1448     function update(uint _roundNumber, uint _additionalNonce, uint _period) public payable {
1449         uint n = 32; // number of random bytes we want the datasource to return
1450         uint delay = 0; // number of seconds to wait before the execution takes place
1451 
1452         bytes32 queryId;
1453         if (!useOraclize) {
1454             queryId = bytes32(iRandao(randao).newCampaign.value(350 finney)(uint32(block.number+101), uint96(200 finney), uint16(100), uint16(50)));
1455         } else {
1456             queryId = custom_oraclize_newRandomDSQuery(_period, delay, n, callbackGas, _additionalNonce);
1457         }
1458 
1459         requests[queryId].game = msg.sender;
1460         requests[queryId].round = _roundNumber;
1461 
1462         emit RequestIsSended(msg.sender, _roundNumber, queryId);
1463     }
1464 
1465     function withdraw(address payable _to, uint256 _value) public onlyOwner {
1466         emit Withdraw(_to, _value);
1467         _to.transfer(_value);
1468     }
1469 
1470     function setCallbackGas(uint _callbackGas) public onlyOwner {
1471         callbackGas = _callbackGas;
1472     }
1473 
1474     function setUseOraclize(bool _useOraclize) public onlyOwner {
1475         useOraclize = _useOraclize;
1476     }
1477 
1478     function setRandao(address _randao) public onlyOwner {
1479         require(_randao != address(0));
1480 
1481         randao = _randao;
1482     }
1483 
1484     function getRequest(bytes32 _queryId) public view returns (address, uint) {
1485         return (requests[_queryId].game, requests[_queryId].round);
1486     }
1487 
1488     function getCallbackGas() public view returns (uint) {
1489         return callbackGas;
1490     }
1491 
1492     function custom_oraclize_newRandomDSQuery(
1493         uint _period,
1494         uint _delay,
1495         uint _nbytes,
1496         uint _customGasLimit,
1497         uint _additionalNonce
1498     )
1499         internal
1500         returns (bytes32)
1501     {
1502         require((_nbytes > 0) && (_nbytes <= 32), "");
1503 
1504         // Convert from seconds to ledger timer ticks
1505         _delay *= 10;
1506         bytes memory nbytes = new bytes(1);
1507         nbytes[0] = byte(uint8(_nbytes));
1508         bytes memory unonce = new bytes(32);
1509         bytes memory sessionKeyHash = new bytes(32);
1510         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1511 
1512         assembly {
1513             mstore(unonce, 0x20)
1514             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, xor(timestamp, _additionalNonce))))
1515             mstore(sessionKeyHash, 0x20)
1516             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1517         }
1518 
1519         bytes memory delay = new bytes(32);
1520 
1521         assembly {
1522             mstore(add(delay, 0x20), _delay)
1523         }
1524 
1525         bytes memory delay_bytes8 = new bytes(8);
1526 
1527         copyBytes(delay, 24, 8, delay_bytes8, 0);
1528 
1529         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1530         bytes32 queryId = oraclize_query(_period, "random", args, _customGasLimit);
1531 
1532         bytes memory delay_bytes8_left = new bytes(8);
1533 
1534         assembly {
1535             let x := mload(add(delay_bytes8, 0x20))
1536             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1537             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1538             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1539             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1540             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1541             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1542             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1543             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1544 
1545         }
1546 
1547         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1548         return queryId;
1549     }
1550 }