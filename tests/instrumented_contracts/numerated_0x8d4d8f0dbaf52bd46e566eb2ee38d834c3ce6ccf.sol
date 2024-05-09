1 pragma solidity ^0.5.0;
2 
3 
4 /*
5 
6 ORACLIZE_API
7 github.com/oraclize/ethereum-api/oraclizeAPI.sol
8 
9 */
10 
11 contract solcChecker {
12     /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.5.sol" */ function f(bytes calldata x) external;
13 }
14 
15 contract OraclizeI {
16 
17     address public cbAddress;
18 
19     function setProofType(byte _proofType) external;
20     function setCustomGasPrice(uint _gasPrice) external;
21     function getPrice(string memory _datasource) public returns (uint _dsprice);
22     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
23     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
24     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
25     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
26     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
27     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
28     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
29     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
30 }
31 
32 contract OraclizeAddrResolverI {
33     function getAddress() public returns (address _address);
34 }
35 
36 /*
37 
38 Begin solidity-cborutils
39 
40 */
41 library Buffer {
42 
43     struct buffer {
44         bytes buf;
45         uint capacity;
46     }
47 
48     function init(buffer memory _buf, uint _capacity) internal pure {
49         uint capacity = _capacity;
50         if (capacity % 32 != 0) {
51             capacity += 32 - (capacity % 32);
52         }
53         _buf.capacity = capacity; // Allocate space for the buffer data
54         assembly {
55             let ptr := mload(0x40)
56             mstore(_buf, ptr)
57             mstore(ptr, 0)
58             mstore(0x40, add(ptr, capacity))
59         }
60     }
61 
62     function resize(buffer memory _buf, uint _capacity) private pure {
63         bytes memory oldbuf = _buf.buf;
64         init(_buf, _capacity);
65         append(_buf, oldbuf);
66     }
67 
68     function max(uint _a, uint _b) private pure returns (uint _max) {
69         if (_a > _b) {
70             return _a;
71         }
72         return _b;
73     }
74     /**
75       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
76       *      would exceed the capacity of the buffer.
77       * @param _buf The buffer to append to.
78       * @param _data The data to append.
79       * @return The original buffer.
80       *
81       */
82     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
83         if (_data.length + _buf.buf.length > _buf.capacity) {
84             resize(_buf, max(_buf.capacity, _data.length) * 2);
85         }
86         uint dest;
87         uint src;
88         uint len = _data.length;
89         assembly {
90             let bufptr := mload(_buf) // Memory address of the buffer data
91             let buflen := mload(bufptr) // Length of existing buffer data
92             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
93             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
94             src := add(_data, 32)
95         }
96         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
97             assembly {
98                 mstore(dest, mload(src))
99             }
100             dest += 32;
101             src += 32;
102         }
103         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
104         assembly {
105             let srcpart := and(mload(src), not(mask))
106             let destpart := and(mload(dest), mask)
107             mstore(dest, or(destpart, srcpart))
108         }
109         return _buf;
110     }
111     /**
112       *
113       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
114       * exceed the capacity of the buffer.
115       * @param _buf The buffer to append to.
116       * @param _data The data to append.
117       * @return The original buffer.
118       *
119       */
120     function append(buffer memory _buf, uint8 _data) internal pure {
121         if (_buf.buf.length + 1 > _buf.capacity) {
122             resize(_buf, _buf.capacity * 2);
123         }
124         assembly {
125             let bufptr := mload(_buf) // Memory address of the buffer data
126             let buflen := mload(bufptr) // Length of existing buffer data
127             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
128             mstore8(dest, _data)
129             mstore(bufptr, add(buflen, 1)) // Update buffer length
130         }
131     }
132     /**
133       *
134       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
135       * exceed the capacity of the buffer.
136       * @param _buf The buffer to append to.
137       * @param _data The data to append.
138       * @return The original buffer.
139       *
140       */
141     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
142         if (_len + _buf.buf.length > _buf.capacity) {
143             resize(_buf, max(_buf.capacity, _len) * 2);
144         }
145         uint mask = 256 ** _len - 1;
146         assembly {
147             let bufptr := mload(_buf) // Memory address of the buffer data
148             let buflen := mload(bufptr) // Length of existing buffer data
149             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
150             mstore(dest, or(and(mload(dest), not(mask)), _data))
151             mstore(bufptr, add(buflen, _len)) // Update buffer length
152         }
153         return _buf;
154     }
155 }
156 
157 library CBOR {
158 
159     using Buffer for Buffer.buffer;
160 
161     uint8 private constant MAJOR_TYPE_INT = 0;
162     uint8 private constant MAJOR_TYPE_MAP = 5;
163     uint8 private constant MAJOR_TYPE_BYTES = 2;
164     uint8 private constant MAJOR_TYPE_ARRAY = 4;
165     uint8 private constant MAJOR_TYPE_STRING = 3;
166     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
167     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
168 
169     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
170         if (_value <= 23) {
171             _buf.append(uint8((_major << 5) | _value));
172         } else if (_value <= 0xFF) {
173             _buf.append(uint8((_major << 5) | 24));
174             _buf.appendInt(_value, 1);
175         } else if (_value <= 0xFFFF) {
176             _buf.append(uint8((_major << 5) | 25));
177             _buf.appendInt(_value, 2);
178         } else if (_value <= 0xFFFFFFFF) {
179             _buf.append(uint8((_major << 5) | 26));
180             _buf.appendInt(_value, 4);
181         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
182             _buf.append(uint8((_major << 5) | 27));
183             _buf.appendInt(_value, 8);
184         }
185     }
186 
187     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
188         _buf.append(uint8((_major << 5) | 31));
189     }
190 
191     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
192         encodeType(_buf, MAJOR_TYPE_INT, _value);
193     }
194 
195     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
196         if (_value >= 0) {
197             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
198         } else {
199             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
200         }
201     }
202 
203     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
204         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
205         _buf.append(_value);
206     }
207 
208     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
209         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
210         _buf.append(bytes(_value));
211     }
212 
213     function startArray(Buffer.buffer memory _buf) internal pure {
214         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
215     }
216 
217     function startMap(Buffer.buffer memory _buf) internal pure {
218         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
219     }
220 
221     function endSequence(Buffer.buffer memory _buf) internal pure {
222         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
223     }
224 }
225 /*
226 
227 End solidity-cborutils
228 
229 */
230 contract usingOraclize {
231 
232     using CBOR for Buffer.buffer;
233 
234     OraclizeI oraclize;
235     OraclizeAddrResolverI OAR;
236 
237     uint constant day = 60 * 60 * 24;
238     uint constant week = 60 * 60 * 24 * 7;
239     uint constant month = 60 * 60 * 24 * 30;
240 
241     byte constant proofType_NONE = 0x00;
242     byte constant proofType_Ledger = 0x30;
243     byte constant proofType_Native = 0xF0;
244     byte constant proofStorage_IPFS = 0x01;
245     byte constant proofType_Android = 0x40;
246     byte constant proofType_TLSNotary = 0x10;
247 
248     string oraclize_network_name;
249     uint8 constant networkID_auto = 0;
250     uint8 constant networkID_morden = 2;
251     uint8 constant networkID_mainnet = 1;
252     uint8 constant networkID_testnet = 2;
253     uint8 constant networkID_consensys = 161;
254 
255     mapping(bytes32 => bytes32) oraclize_randomDS_args;
256     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
257 
258     modifier oraclizeAPI {
259         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
260             oraclize_setNetwork(networkID_auto);
261         }
262         if (address(oraclize) != OAR.getAddress()) {
263             oraclize = OraclizeI(OAR.getAddress());
264         }
265         _;
266     }
267 
268     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
269         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
270         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
271         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
272         require(proofVerified);
273         _;
274     }
275 
276     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
277       return oraclize_setNetwork();
278       _networkID; // silence the warning and remain backwards compatible
279     }
280 
281     function oraclize_setNetworkName(string memory _network_name) internal {
282         oraclize_network_name = _network_name;
283     }
284 
285     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
286         return oraclize_network_name;
287     }
288 
289     function oraclize_setNetwork() internal returns (bool _networkSet) {
290         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
291             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
292             oraclize_setNetworkName("eth_mainnet");
293             return true;
294         }
295         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
296             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
297             oraclize_setNetworkName("eth_ropsten3");
298             return true;
299         }
300         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
301             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
302             oraclize_setNetworkName("eth_kovan");
303             return true;
304         }
305         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
306             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
307             oraclize_setNetworkName("eth_rinkeby");
308             return true;
309         }
310         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
311             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
312             return true;
313         }
314         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
315             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
316             return true;
317         }
318         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
319             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
320             return true;
321         }
322         return false;
323     }
324 
325     function __callback(bytes32 _myid, string memory _result) public payable {
326         __callback(_myid, _result, new bytes(0));
327     }
328 
329     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) pure public {
330       return;
331       _myid; _result; _proof; // Silence compiler warnings
332     }
333 
334     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
335         return oraclize.getPrice(_datasource);
336     }
337 
338     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
339         return oraclize.getPrice(_datasource, _gasLimit);
340     }
341 
342     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
343         uint price = oraclize.getPrice(_datasource);
344         if (price > 1 ether + tx.gasprice * 200000) {
345             return 0; // Unexpectedly high price
346         }
347         return oraclize.query.value(price)(0, _datasource, _arg);
348     }
349 
350     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
351         uint price = oraclize.getPrice(_datasource);
352         if (price > 1 ether + tx.gasprice * 200000) {
353             return 0; // Unexpectedly high price
354         }
355         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
356     }
357 
358     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
359         uint price = oraclize.getPrice(_datasource,_gasLimit);
360         if (price > 1 ether + tx.gasprice * _gasLimit) {
361             return 0; // Unexpectedly high price
362         }
363         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
364     }
365 
366     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
367         uint price = oraclize.getPrice(_datasource, _gasLimit);
368         if (price > 1 ether + tx.gasprice * _gasLimit) {
369            return 0; // Unexpectedly high price
370         }
371         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
372     }
373 
374     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
375         uint price = oraclize.getPrice(_datasource);
376         if (price > 1 ether + tx.gasprice * 200000) {
377             return 0; // Unexpectedly high price
378         }
379         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
380     }
381 
382     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
383         uint price = oraclize.getPrice(_datasource);
384         if (price > 1 ether + tx.gasprice * 200000) {
385             return 0; // Unexpectedly high price
386         }
387         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
388     }
389 
390     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
391         uint price = oraclize.getPrice(_datasource, _gasLimit);
392         if (price > 1 ether + tx.gasprice * _gasLimit) {
393             return 0; // Unexpectedly high price
394         }
395         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
396     }
397 
398     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
399         uint price = oraclize.getPrice(_datasource, _gasLimit);
400         if (price > 1 ether + tx.gasprice * _gasLimit) {
401             return 0; // Unexpectedly high price
402         }
403         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
404     }
405 
406     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
407         uint price = oraclize.getPrice(_datasource);
408         if (price > 1 ether + tx.gasprice * 200000) {
409             return 0; // Unexpectedly high price
410         }
411         bytes memory args = stra2cbor(_argN);
412         return oraclize.queryN.value(price)(0, _datasource, args);
413     }
414 
415     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
416         uint price = oraclize.getPrice(_datasource);
417         if (price > 1 ether + tx.gasprice * 200000) {
418             return 0; // Unexpectedly high price
419         }
420         bytes memory args = stra2cbor(_argN);
421         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
422     }
423 
424     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
425         uint price = oraclize.getPrice(_datasource, _gasLimit);
426         if (price > 1 ether + tx.gasprice * _gasLimit) {
427             return 0; // Unexpectedly high price
428         }
429         bytes memory args = stra2cbor(_argN);
430         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
431     }
432 
433     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
434         uint price = oraclize.getPrice(_datasource, _gasLimit);
435         if (price > 1 ether + tx.gasprice * _gasLimit) {
436             return 0; // Unexpectedly high price
437         }
438         bytes memory args = stra2cbor(_argN);
439         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
440     }
441 
442     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
443         string[] memory dynargs = new string[](1);
444         dynargs[0] = _args[0];
445         return oraclize_query(_datasource, dynargs);
446     }
447 
448     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
449         string[] memory dynargs = new string[](1);
450         dynargs[0] = _args[0];
451         return oraclize_query(_timestamp, _datasource, dynargs);
452     }
453 
454     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
455         string[] memory dynargs = new string[](1);
456         dynargs[0] = _args[0];
457         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
458     }
459 
460     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
461         string[] memory dynargs = new string[](1);
462         dynargs[0] = _args[0];
463         return oraclize_query(_datasource, dynargs, _gasLimit);
464     }
465 
466     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
467         string[] memory dynargs = new string[](2);
468         dynargs[0] = _args[0];
469         dynargs[1] = _args[1];
470         return oraclize_query(_datasource, dynargs);
471     }
472 
473     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
474         string[] memory dynargs = new string[](2);
475         dynargs[0] = _args[0];
476         dynargs[1] = _args[1];
477         return oraclize_query(_timestamp, _datasource, dynargs);
478     }
479 
480     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
481         string[] memory dynargs = new string[](2);
482         dynargs[0] = _args[0];
483         dynargs[1] = _args[1];
484         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
485     }
486 
487     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
488         string[] memory dynargs = new string[](2);
489         dynargs[0] = _args[0];
490         dynargs[1] = _args[1];
491         return oraclize_query(_datasource, dynargs, _gasLimit);
492     }
493 
494     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
495         string[] memory dynargs = new string[](3);
496         dynargs[0] = _args[0];
497         dynargs[1] = _args[1];
498         dynargs[2] = _args[2];
499         return oraclize_query(_datasource, dynargs);
500     }
501 
502     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
503         string[] memory dynargs = new string[](3);
504         dynargs[0] = _args[0];
505         dynargs[1] = _args[1];
506         dynargs[2] = _args[2];
507         return oraclize_query(_timestamp, _datasource, dynargs);
508     }
509 
510     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
511         string[] memory dynargs = new string[](3);
512         dynargs[0] = _args[0];
513         dynargs[1] = _args[1];
514         dynargs[2] = _args[2];
515         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
516     }
517 
518     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
519         string[] memory dynargs = new string[](3);
520         dynargs[0] = _args[0];
521         dynargs[1] = _args[1];
522         dynargs[2] = _args[2];
523         return oraclize_query(_datasource, dynargs, _gasLimit);
524     }
525 
526     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
527         string[] memory dynargs = new string[](4);
528         dynargs[0] = _args[0];
529         dynargs[1] = _args[1];
530         dynargs[2] = _args[2];
531         dynargs[3] = _args[3];
532         return oraclize_query(_datasource, dynargs);
533     }
534 
535     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
536         string[] memory dynargs = new string[](4);
537         dynargs[0] = _args[0];
538         dynargs[1] = _args[1];
539         dynargs[2] = _args[2];
540         dynargs[3] = _args[3];
541         return oraclize_query(_timestamp, _datasource, dynargs);
542     }
543 
544     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
545         string[] memory dynargs = new string[](4);
546         dynargs[0] = _args[0];
547         dynargs[1] = _args[1];
548         dynargs[2] = _args[2];
549         dynargs[3] = _args[3];
550         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
551     }
552 
553     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
554         string[] memory dynargs = new string[](4);
555         dynargs[0] = _args[0];
556         dynargs[1] = _args[1];
557         dynargs[2] = _args[2];
558         dynargs[3] = _args[3];
559         return oraclize_query(_datasource, dynargs, _gasLimit);
560     }
561 
562     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
563         string[] memory dynargs = new string[](5);
564         dynargs[0] = _args[0];
565         dynargs[1] = _args[1];
566         dynargs[2] = _args[2];
567         dynargs[3] = _args[3];
568         dynargs[4] = _args[4];
569         return oraclize_query(_datasource, dynargs);
570     }
571 
572     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
573         string[] memory dynargs = new string[](5);
574         dynargs[0] = _args[0];
575         dynargs[1] = _args[1];
576         dynargs[2] = _args[2];
577         dynargs[3] = _args[3];
578         dynargs[4] = _args[4];
579         return oraclize_query(_timestamp, _datasource, dynargs);
580     }
581 
582     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
583         string[] memory dynargs = new string[](5);
584         dynargs[0] = _args[0];
585         dynargs[1] = _args[1];
586         dynargs[2] = _args[2];
587         dynargs[3] = _args[3];
588         dynargs[4] = _args[4];
589         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
590     }
591 
592     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
593         string[] memory dynargs = new string[](5);
594         dynargs[0] = _args[0];
595         dynargs[1] = _args[1];
596         dynargs[2] = _args[2];
597         dynargs[3] = _args[3];
598         dynargs[4] = _args[4];
599         return oraclize_query(_datasource, dynargs, _gasLimit);
600     }
601 
602     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
603         uint price = oraclize.getPrice(_datasource);
604         if (price > 1 ether + tx.gasprice * 200000) {
605             return 0; // Unexpectedly high price
606         }
607         bytes memory args = ba2cbor(_argN);
608         return oraclize.queryN.value(price)(0, _datasource, args);
609     }
610 
611     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
612         uint price = oraclize.getPrice(_datasource);
613         if (price > 1 ether + tx.gasprice * 200000) {
614             return 0; // Unexpectedly high price
615         }
616         bytes memory args = ba2cbor(_argN);
617         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
618     }
619 
620     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
621         uint price = oraclize.getPrice(_datasource, _gasLimit);
622         if (price > 1 ether + tx.gasprice * _gasLimit) {
623             return 0; // Unexpectedly high price
624         }
625         bytes memory args = ba2cbor(_argN);
626         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
627     }
628 
629     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
630         uint price = oraclize.getPrice(_datasource, _gasLimit);
631         if (price > 1 ether + tx.gasprice * _gasLimit) {
632             return 0; // Unexpectedly high price
633         }
634         bytes memory args = ba2cbor(_argN);
635         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
636     }
637 
638     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
639         bytes[] memory dynargs = new bytes[](1);
640         dynargs[0] = _args[0];
641         return oraclize_query(_datasource, dynargs);
642     }
643 
644     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
645         bytes[] memory dynargs = new bytes[](1);
646         dynargs[0] = _args[0];
647         return oraclize_query(_timestamp, _datasource, dynargs);
648     }
649 
650     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
651         bytes[] memory dynargs = new bytes[](1);
652         dynargs[0] = _args[0];
653         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
654     }
655 
656     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
657         bytes[] memory dynargs = new bytes[](1);
658         dynargs[0] = _args[0];
659         return oraclize_query(_datasource, dynargs, _gasLimit);
660     }
661 
662     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
663         bytes[] memory dynargs = new bytes[](2);
664         dynargs[0] = _args[0];
665         dynargs[1] = _args[1];
666         return oraclize_query(_datasource, dynargs);
667     }
668 
669     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
670         bytes[] memory dynargs = new bytes[](2);
671         dynargs[0] = _args[0];
672         dynargs[1] = _args[1];
673         return oraclize_query(_timestamp, _datasource, dynargs);
674     }
675 
676     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
677         bytes[] memory dynargs = new bytes[](2);
678         dynargs[0] = _args[0];
679         dynargs[1] = _args[1];
680         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
681     }
682 
683     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
684         bytes[] memory dynargs = new bytes[](2);
685         dynargs[0] = _args[0];
686         dynargs[1] = _args[1];
687         return oraclize_query(_datasource, dynargs, _gasLimit);
688     }
689 
690     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
691         bytes[] memory dynargs = new bytes[](3);
692         dynargs[0] = _args[0];
693         dynargs[1] = _args[1];
694         dynargs[2] = _args[2];
695         return oraclize_query(_datasource, dynargs);
696     }
697 
698     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
699         bytes[] memory dynargs = new bytes[](3);
700         dynargs[0] = _args[0];
701         dynargs[1] = _args[1];
702         dynargs[2] = _args[2];
703         return oraclize_query(_timestamp, _datasource, dynargs);
704     }
705 
706     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
707         bytes[] memory dynargs = new bytes[](3);
708         dynargs[0] = _args[0];
709         dynargs[1] = _args[1];
710         dynargs[2] = _args[2];
711         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
712     }
713 
714     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
715         bytes[] memory dynargs = new bytes[](3);
716         dynargs[0] = _args[0];
717         dynargs[1] = _args[1];
718         dynargs[2] = _args[2];
719         return oraclize_query(_datasource, dynargs, _gasLimit);
720     }
721 
722     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
723         bytes[] memory dynargs = new bytes[](4);
724         dynargs[0] = _args[0];
725         dynargs[1] = _args[1];
726         dynargs[2] = _args[2];
727         dynargs[3] = _args[3];
728         return oraclize_query(_datasource, dynargs);
729     }
730 
731     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
732         bytes[] memory dynargs = new bytes[](4);
733         dynargs[0] = _args[0];
734         dynargs[1] = _args[1];
735         dynargs[2] = _args[2];
736         dynargs[3] = _args[3];
737         return oraclize_query(_timestamp, _datasource, dynargs);
738     }
739 
740     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
741         bytes[] memory dynargs = new bytes[](4);
742         dynargs[0] = _args[0];
743         dynargs[1] = _args[1];
744         dynargs[2] = _args[2];
745         dynargs[3] = _args[3];
746         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
747     }
748 
749     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
750         bytes[] memory dynargs = new bytes[](4);
751         dynargs[0] = _args[0];
752         dynargs[1] = _args[1];
753         dynargs[2] = _args[2];
754         dynargs[3] = _args[3];
755         return oraclize_query(_datasource, dynargs, _gasLimit);
756     }
757 
758     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
759         bytes[] memory dynargs = new bytes[](5);
760         dynargs[0] = _args[0];
761         dynargs[1] = _args[1];
762         dynargs[2] = _args[2];
763         dynargs[3] = _args[3];
764         dynargs[4] = _args[4];
765         return oraclize_query(_datasource, dynargs);
766     }
767 
768     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
769         bytes[] memory dynargs = new bytes[](5);
770         dynargs[0] = _args[0];
771         dynargs[1] = _args[1];
772         dynargs[2] = _args[2];
773         dynargs[3] = _args[3];
774         dynargs[4] = _args[4];
775         return oraclize_query(_timestamp, _datasource, dynargs);
776     }
777 
778     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
779         bytes[] memory dynargs = new bytes[](5);
780         dynargs[0] = _args[0];
781         dynargs[1] = _args[1];
782         dynargs[2] = _args[2];
783         dynargs[3] = _args[3];
784         dynargs[4] = _args[4];
785         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
786     }
787 
788     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
789         bytes[] memory dynargs = new bytes[](5);
790         dynargs[0] = _args[0];
791         dynargs[1] = _args[1];
792         dynargs[2] = _args[2];
793         dynargs[3] = _args[3];
794         dynargs[4] = _args[4];
795         return oraclize_query(_datasource, dynargs, _gasLimit);
796     }
797 
798     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
799         return oraclize.setProofType(_proofP);
800     }
801 
802 
803     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
804         return oraclize.cbAddress();
805     }
806 
807     function getCodeSize(address _addr) view internal returns (uint _size) {
808         assembly {
809             _size := extcodesize(_addr)
810         }
811     }
812 
813     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
814         return oraclize.setCustomGasPrice(_gasPrice);
815     }
816 
817     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
818         return oraclize.randomDS_getSessionPubKeyHash();
819     }
820 
821     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
822         bytes memory tmp = bytes(_a);
823         uint160 iaddr = 0;
824         uint160 b1;
825         uint160 b2;
826         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
827             iaddr *= 256;
828             b1 = uint160(uint8(tmp[i]));
829             b2 = uint160(uint8(tmp[i + 1]));
830             if ((b1 >= 97) && (b1 <= 102)) {
831                 b1 -= 87;
832             } else if ((b1 >= 65) && (b1 <= 70)) {
833                 b1 -= 55;
834             } else if ((b1 >= 48) && (b1 <= 57)) {
835                 b1 -= 48;
836             }
837             if ((b2 >= 97) && (b2 <= 102)) {
838                 b2 -= 87;
839             } else if ((b2 >= 65) && (b2 <= 70)) {
840                 b2 -= 55;
841             } else if ((b2 >= 48) && (b2 <= 57)) {
842                 b2 -= 48;
843             }
844             iaddr += (b1 * 16 + b2);
845         }
846         return address(iaddr);
847     }
848 
849     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
850         bytes memory a = bytes(_a);
851         bytes memory b = bytes(_b);
852         uint minLength = a.length;
853         if (b.length < minLength) {
854             minLength = b.length;
855         }
856         for (uint i = 0; i < minLength; i ++) {
857             if (a[i] < b[i]) {
858                 return -1;
859             } else if (a[i] > b[i]) {
860                 return 1;
861             }
862         }
863         if (a.length < b.length) {
864             return -1;
865         } else if (a.length > b.length) {
866             return 1;
867         } else {
868             return 0;
869         }
870     }
871 
872     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
873         bytes memory h = bytes(_haystack);
874         bytes memory n = bytes(_needle);
875         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
876             return -1;
877         } else if (h.length > (2 ** 128 - 1)) {
878             return -1;
879         } else {
880             uint subindex = 0;
881             for (uint i = 0; i < h.length; i++) {
882                 if (h[i] == n[0]) {
883                     subindex = 1;
884                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
885                         subindex++;
886                     }
887                     if (subindex == n.length) {
888                         return int(i);
889                     }
890                 }
891             }
892             return -1;
893         }
894     }
895 
896     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
897         return strConcat(_a, _b, "", "", "");
898     }
899 
900     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
901         return strConcat(_a, _b, _c, "", "");
902     }
903 
904     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
905         return strConcat(_a, _b, _c, _d, "");
906     }
907 
908     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
909         bytes memory _ba = bytes(_a);
910         bytes memory _bb = bytes(_b);
911         bytes memory _bc = bytes(_c);
912         bytes memory _bd = bytes(_d);
913         bytes memory _be = bytes(_e);
914         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
915         bytes memory babcde = bytes(abcde);
916         uint k = 0;
917         uint i = 0;
918         for (i = 0; i < _ba.length; i++) {
919             babcde[k++] = _ba[i];
920         }
921         for (i = 0; i < _bb.length; i++) {
922             babcde[k++] = _bb[i];
923         }
924         for (i = 0; i < _bc.length; i++) {
925             babcde[k++] = _bc[i];
926         }
927         for (i = 0; i < _bd.length; i++) {
928             babcde[k++] = _bd[i];
929         }
930         for (i = 0; i < _be.length; i++) {
931             babcde[k++] = _be[i];
932         }
933         return string(babcde);
934     }
935 
936     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
937         return safeParseInt(_a, 0);
938     }
939 
940     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
941         bytes memory bresult = bytes(_a);
942         uint mint = 0;
943         bool decimals = false;
944         for (uint i = 0; i < bresult.length; i++) {
945             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
946                 if (decimals) {
947                    if (_b == 0) break;
948                     else _b--;
949                 }
950                 mint *= 10;
951                 mint += uint(uint8(bresult[i])) - 48;
952             } else if (uint(uint8(bresult[i])) == 46) {
953                 require(!decimals, 'More than one decimal encountered in string!');
954                 decimals = true;
955             } else {
956                 revert("Non-numeral character encountered in string!");
957             }
958         }
959         if (_b > 0) {
960             mint *= 10 ** _b;
961         }
962         return mint;
963     }
964 
965     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
966         return parseInt(_a, 0);
967     }
968 
969     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
970         bytes memory bresult = bytes(_a);
971         uint mint = 0;
972         bool decimals = false;
973         for (uint i = 0; i < bresult.length; i++) {
974             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
975                 if (decimals) {
976                    if (_b == 0) {
977                        break;
978                    } else {
979                        _b--;
980                    }
981                 }
982                 mint *= 10;
983                 mint += uint(uint8(bresult[i])) - 48;
984             } else if (uint(uint8(bresult[i])) == 46) {
985                 decimals = true;
986             }
987         }
988         if (_b > 0) {
989             mint *= 10 ** _b;
990         }
991         return mint;
992     }
993 
994     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
995         if (_i == 0) {
996             return "0";
997         }
998         uint j = _i;
999         uint len;
1000         while (j != 0) {
1001             len++;
1002             j /= 10;
1003         }
1004         bytes memory bstr = new bytes(len);
1005         uint k = len - 1;
1006         while (_i != 0) {
1007             bstr[k--] = byte(uint8(48 + _i % 10));
1008             _i /= 10;
1009         }
1010         return string(bstr);
1011     }
1012 
1013     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1014         safeMemoryCleaner();
1015         Buffer.buffer memory buf;
1016         Buffer.init(buf, 1024);
1017         buf.startArray();
1018         for (uint i = 0; i < _arr.length; i++) {
1019             buf.encodeString(_arr[i]);
1020         }
1021         buf.endSequence();
1022         return buf.buf;
1023     }
1024 
1025     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1026         safeMemoryCleaner();
1027         Buffer.buffer memory buf;
1028         Buffer.init(buf, 1024);
1029         buf.startArray();
1030         for (uint i = 0; i < _arr.length; i++) {
1031             buf.encodeBytes(_arr[i]);
1032         }
1033         buf.endSequence();
1034         return buf.buf;
1035     }
1036 
1037     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1038         require((_nbytes > 0) && (_nbytes <= 32));
1039         _delay *= 10; // Convert from seconds to ledger timer ticks
1040         bytes memory nbytes = new bytes(1);
1041         nbytes[0] = byte(uint8(_nbytes));
1042         bytes memory unonce = new bytes(32);
1043         bytes memory sessionKeyHash = new bytes(32);
1044         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1045         assembly {
1046             mstore(unonce, 0x20)
1047             /*
1048              The following variables can be relaxed.
1049              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1050              for an idea on how to override and replace commit hash variables.
1051             */
1052             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1053             mstore(sessionKeyHash, 0x20)
1054             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1055         }
1056         bytes memory delay = new bytes(32);
1057         assembly {
1058             mstore(add(delay, 0x20), _delay)
1059         }
1060         bytes memory delay_bytes8 = new bytes(8);
1061         copyBytes(delay, 24, 8, delay_bytes8, 0);
1062         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1063         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1064         bytes memory delay_bytes8_left = new bytes(8);
1065         assembly {
1066             let x := mload(add(delay_bytes8, 0x20))
1067             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1068             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1069             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1070             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1071             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1072             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1073             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1074             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1075         }
1076         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1077         return queryId;
1078     }
1079 
1080     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1081         oraclize_randomDS_args[_queryId] = _commitment;
1082     }
1083 
1084     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1085         bool sigok;
1086         address signer;
1087         bytes32 sigr;
1088         bytes32 sigs;
1089         bytes memory sigr_ = new bytes(32);
1090         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1091         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1092         bytes memory sigs_ = new bytes(32);
1093         offset += 32 + 2;
1094         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1095         assembly {
1096             sigr := mload(add(sigr_, 32))
1097             sigs := mload(add(sigs_, 32))
1098         }
1099         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1100         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1101             return true;
1102         } else {
1103             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1104             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1105         }
1106     }
1107 
1108     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1109         bool sigok;
1110         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1111         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1112         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1113         bytes memory appkey1_pubkey = new bytes(64);
1114         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1115         bytes memory tosign2 = new bytes(1 + 65 + 32);
1116         tosign2[0] = byte(uint8(1)); //role
1117         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1118         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1119         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1120         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1121         if (!sigok) {
1122             return false;
1123         }
1124         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1125         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1126         bytes memory tosign3 = new bytes(1 + 65);
1127         tosign3[0] = 0xFE;
1128         copyBytes(_proof, 3, 65, tosign3, 1);
1129         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1130         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1131         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1132         return sigok;
1133     }
1134 
1135     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1136         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1137         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1138             return 1;
1139         }
1140         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1141         if (!proofVerified) {
1142             return 2;
1143         }
1144         return 0;
1145     }
1146 
1147     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1148         bool match_ = true;
1149         require(_prefix.length == _nRandomBytes);
1150         for (uint256 i = 0; i< _nRandomBytes; i++) {
1151             if (_content[i] != _prefix[i]) {
1152                 match_ = false;
1153             }
1154         }
1155         return match_;
1156     }
1157 
1158     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1159         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1160         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1161         bytes memory keyhash = new bytes(32);
1162         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1163         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1164             return false;
1165         }
1166         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1167         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1168         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1169         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1170             return false;
1171         }
1172         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1173         // This is to verify that the computed args match with the ones specified in the query.
1174         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1175         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1176         bytes memory sessionPubkey = new bytes(64);
1177         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1178         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1179         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1180         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1181             delete oraclize_randomDS_args[_queryId];
1182         } else return false;
1183         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1184         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1185         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1186         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1187             return false;
1188         }
1189         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1190         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1191             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1192         }
1193         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1194     }
1195     /*
1196      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1197     */
1198     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1199         uint minLength = _length + _toOffset;
1200         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1201         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1202         uint j = 32 + _toOffset;
1203         while (i < (32 + _fromOffset + _length)) {
1204             assembly {
1205                 let tmp := mload(add(_from, i))
1206                 mstore(add(_to, j), tmp)
1207             }
1208             i += 32;
1209             j += 32;
1210         }
1211         return _to;
1212     }
1213     /*
1214      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1215      Duplicate Solidity's ecrecover, but catching the CALL return value
1216     */
1217     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1218         /*
1219          We do our own memory management here. Solidity uses memory offset
1220          0x40 to store the current end of memory. We write past it (as
1221          writes are memory extensions), but don't update the offset so
1222          Solidity will reuse it. The memory used here is only needed for
1223          this context.
1224          FIXME: inline assembly can't access return values
1225         */
1226         bool ret;
1227         address addr;
1228         assembly {
1229             let size := mload(0x40)
1230             mstore(size, _hash)
1231             mstore(add(size, 32), _v)
1232             mstore(add(size, 64), _r)
1233             mstore(add(size, 96), _s)
1234             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1235             addr := mload(size)
1236         }
1237         return (ret, addr);
1238     }
1239     /*
1240      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1241     */
1242     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1243         bytes32 r;
1244         bytes32 s;
1245         uint8 v;
1246         if (_sig.length != 65) {
1247             return (false, address(0));
1248         }
1249         /*
1250          The signature format is a compact form of:
1251            {bytes32 r}{bytes32 s}{uint8 v}
1252          Compact means, uint8 is not padded to 32 bytes.
1253         */
1254         assembly {
1255             r := mload(add(_sig, 32))
1256             s := mload(add(_sig, 64))
1257             /*
1258              Here we are loading the last 32 bytes. We exploit the fact that
1259              'mload' will pad with zeroes if we overread.
1260              There is no 'mload8' to do this, but that would be nicer.
1261             */
1262             v := byte(0, mload(add(_sig, 96)))
1263             /*
1264               Alternative solution:
1265               'byte' is not working due to the Solidity parser, so lets
1266               use the second best option, 'and'
1267               v := and(mload(add(_sig, 65)), 255)
1268             */
1269         }
1270         /*
1271          albeit non-transactional signatures are not specified by the YP, one would expect it
1272          to match the YP range of [27, 28]
1273          geth uses [0, 1] and some clients have followed. This might change, see:
1274          https://github.com/ethereum/go-ethereum/issues/2053
1275         */
1276         if (v < 27) {
1277             v += 27;
1278         }
1279         if (v != 27 && v != 28) {
1280             return (false, address(0));
1281         }
1282         return safer_ecrecover(_hash, v, r, s);
1283     }
1284 
1285     function safeMemoryCleaner() internal pure {
1286         assembly {
1287             let fmem := mload(0x40)
1288             codecopy(fmem, codesize, sub(msize, fmem))
1289         }
1290     }
1291 }
1292 
1293 /*
1294 
1295 END ORACLIZE_API
1296 
1297 */
1298 
1299 
1300 contract Dice is usingOraclize {
1301 
1302     uint minimumBet;
1303 
1304     // The oraclize callback structure: we use several oraclize calls.
1305     // All oraclize calls will result in a common callback to __callback(...).
1306     // To keep track of the different queries we the struct callback struct in place.
1307 
1308     struct oraclizeCallback {
1309         address payable player;
1310         bytes32 queryId;
1311         bool    status;
1312         uint[]  betNumbers;
1313         uint    betAmount;
1314         uint    winningNumber;
1315         uint    winAmount;
1316     }
1317     
1318     // Lookup state for oraclizeQueryIds
1319 
1320     mapping (bytes32 => oraclizeCallback) oraclizeStructs;
1321     bytes32[] public oraclizedIndices;
1322 
1323     // General events
1324 
1325     event GameStarted(address _contract);
1326     event PlayerBetAccepted(address _contract, address _player, uint[] _numbers, uint _bet);
1327     event RollDice(address _contract, address _player, string _description);
1328     event NumberGeneratorQuery(address _contract, address _player, bytes32 _randomOrgQueryId);
1329     event AwaitingRandomOrgCallback(address _contract, bytes32 _randomOrgQueryId);
1330     event RandomOrgCallback(address _contract, bytes32 _oraclizeQueryId);
1331     event NumberGeneratorResponse(address _contract, address _player, bytes32 _oraclizeQueryId, string _oraclizeResponse);
1332     event WinningNumber(address _contract, bytes32 _oraclizeQueryId, uint[] _betNumbers, uint _winningNumber);
1333     event DidNotWin(address _contract, uint _winningNumber, uint[] _betNumbers);
1334     event PlayerWins(address _contract, address _winner, uint _winningNumber, uint _winAmount);
1335     event PlayerCashout(address _contract, address _winner, uint _winningNumber, uint _winAmount);
1336     event GameFinalized(address _contract);
1337 
1338     constructor() 
1339         public
1340     {
1341         minimumBet = 0.01 ether;
1342         emit GameStarted(address(this));
1343     }
1344 
1345 
1346     function rollDice(uint[] memory betNumbers) 
1347         public 
1348         payable
1349         returns (bool success)
1350     {
1351         
1352         bytes32 oraclizeQueryId;
1353         
1354         address payable player = msg.sender;
1355         
1356         uint betAmount = msg.value;
1357         
1358         require(betAmount >= minimumBet);
1359         require(betNumbers.length >= 1);
1360 
1361         emit PlayerBetAccepted(address(this), player, betNumbers, betAmount);
1362 
1363         emit RollDice(address(this), player, "Query to random.org was sent, standing by for the answer.");
1364 
1365 
1366         if(betNumbers.length < 6) {
1367 
1368             // Making oraclized query to random.org.
1369 
1370             oraclizeQueryId = oraclize_query("URL", "https://www.random.org/integers/?num=1&min=1&max=6&col=1&base=8&format=plain");
1371 
1372             // Recording the bet info for future reference.
1373             
1374             oraclizeStructs[oraclizeQueryId].status = false;
1375             oraclizeStructs[oraclizeQueryId].queryId = oraclizeQueryId;
1376             oraclizeStructs[oraclizeQueryId].player = player;
1377             oraclizeStructs[oraclizeQueryId].betNumbers = betNumbers;
1378             oraclizeStructs[oraclizeQueryId].betAmount = betAmount;
1379 
1380             // Recording oraclize indices.
1381             
1382             oraclizedIndices.push(oraclizeQueryId) -1;
1383   
1384             emit NumberGeneratorQuery(address(this), player, oraclizeQueryId);
1385  
1386  
1387         } else {
1388             
1389             // Player bets on every number, that's an invalid bet, money are returned back to the player.
1390 
1391             msg.sender.transfer(msg.value);
1392 
1393         }
1394     
1395     
1396         emit AwaitingRandomOrgCallback(address(this), oraclizeQueryId);
1397 
1398         return true;
1399 
1400     }
1401 
1402 
1403     function __callback(bytes32 myid, string memory result) 
1404         public
1405         payable 
1406     {
1407         
1408         // All the action takes place on when we receive a new number from random.org
1409 
1410         bool playerWins;
1411         
1412         uint winAmount;
1413     
1414         emit RandomOrgCallback(address(this), myid);
1415     
1416         address oraclize_cb = oraclize_cbAddress();
1417 
1418         require(msg.sender == oraclize_cb);
1419         
1420         
1421         address payable player = oraclizeStructs[myid].player;
1422 
1423 
1424         emit NumberGeneratorResponse(address(this), msg.sender, myid, result);
1425         
1426         uint winningNumber = parseInt(result);
1427         
1428         
1429         uint[] memory betNumbers = oraclizeStructs[myid].betNumbers;
1430         
1431         emit WinningNumber(address(this), myid, betNumbers, winningNumber);
1432 
1433 
1434         oraclizeStructs[myid].winningNumber = winningNumber;
1435         
1436 
1437         uint betAmount = oraclizeStructs[myid].betAmount;
1438 
1439 
1440         for (uint i = 0; i < betNumbers.length; i++) {
1441 
1442             uint betNumber = betNumbers[i];
1443 
1444             if(betNumber == winningNumber) {
1445                 playerWins = true;
1446                 break;
1447             }
1448 
1449         }
1450         
1451         
1452         if(playerWins) {
1453             
1454             // Calculate how much player wins..
1455 
1456             if(betNumbers.length == 1) {
1457                     winAmount = (betAmount * 589) / 100;
1458             }
1459             if(betNumbers.length == 2) {
1460                     winAmount = (betAmount * 293) / 100;
1461             }
1462             if(betNumbers.length == 3) {
1463                     winAmount = (betAmount * 195) / 100;
1464             }
1465             if(betNumbers.length == 4) {
1466                     winAmount = (betAmount * 142) / 100;
1467             }
1468             if(betNumbers.length == 5) {
1469                     winAmount = (betAmount * 107) / 100;
1470             }
1471             if(betNumbers.length >= 6) {
1472                     winAmount = 0;
1473             }
1474 
1475             emit PlayerWins(address(this), player, winningNumber, winAmount);
1476 
1477             if(winAmount > 0) {
1478 
1479                 // Substract the casino edge 4% and pay the winner..
1480                 
1481                 uint casino_edge = (winAmount / 100) * 4;
1482                 
1483                 winAmount = winAmount - casino_edge;
1484 
1485                 address(player).transfer(winAmount);
1486 
1487                 oraclizeStructs[myid].winAmount = winAmount;
1488 
1489                 emit PlayerCashout(address(this), player, winningNumber, winAmount);
1490             
1491             }
1492             
1493         }
1494 
1495         if(playerWins==false) {
1496 
1497             emit DidNotWin(address(this), winningNumber, betNumbers);
1498 
1499             emit GameFinalized(address(this));
1500 
1501         }
1502 
1503         oraclizeStructs[myid].status = true;
1504 
1505     }
1506     
1507     function payRoyalty()
1508         public
1509         payable
1510         returns (bool success)
1511     {
1512 
1513         // There is a cost associated to provide this service, as an example, it costs 0.004 ether to make a single call to oraclize and we need to somehow cover for the it.
1514         uint royalty = address(this).balance/2;
1515 
1516         address payable trustedParty1 = 0xE2cf529D780bda21D880E1d1A2035E7f4f503e60;
1517         address payable trustedParty2 = 0x07b7b9d3710dC72A0A6B7A8B6D31EB5D0E62cF56;
1518         trustedParty1.transfer(royalty/2);
1519         trustedParty2.transfer(royalty/2);
1520 
1521         return (true);
1522     }
1523 
1524     function gameStatus(bytes32 oraclizeQueryId)
1525         public
1526         view
1527         returns (bool, address, uint[] memory, uint, uint, uint)
1528     {
1529 
1530         bool status = oraclizeStructs[oraclizeQueryId].status;
1531         address player = oraclizeStructs[oraclizeQueryId].player;
1532         uint[] memory betNumbers = oraclizeStructs[oraclizeQueryId].betNumbers;
1533         uint winningNumber = oraclizeStructs[oraclizeQueryId].winningNumber;
1534         uint betAmount = oraclizeStructs[oraclizeQueryId].betAmount;
1535         uint winAmount = oraclizeStructs[oraclizeQueryId].winAmount;
1536 
1537         return (status, player, betNumbers, winningNumber, betAmount, winAmount);
1538     }
1539 
1540     function getBlockTimestamp()
1541         public
1542         view
1543         returns (uint)
1544     {
1545         return (now);
1546     }
1547 
1548     function getContractBalance()
1549         public
1550         view
1551         returns (uint)
1552     {
1553         return (address(this).balance);
1554     }
1555 
1556 }