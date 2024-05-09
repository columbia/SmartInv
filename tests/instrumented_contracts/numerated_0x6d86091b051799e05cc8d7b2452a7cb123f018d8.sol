1 pragma solidity ^0.5.4;
2 
3 interface IERC20 {
4   function totalSupply() external view returns (uint256);
5 
6   function balanceOf(address who) external view returns (uint256);
7 
8   function allowance(address owner, address spender)
9     external view returns (uint256);
10 
11   function transfer(address to, uint256 value) external returns (bool);
12 
13   function approve(address spender, uint256 value)
14     external returns (bool);
15 
16   function transferFrom(address from, address to, uint256 value)
17     external returns (bool);
18 
19   event Transfer(
20     address indexed from,
21     address indexed to,
22     uint256 value
23   );
24 
25   event Approval(
26     address indexed owner,
27     address indexed spender,
28     uint256 value
29   );
30 }
31 
32 library SafeMath {
33 
34   /**
35   * @dev Multiplies two numbers, reverts on overflow.
36   */
37   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39     // benefit is lost if 'b' is also tested.
40     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41     if (a == 0) {
42       return 0;
43     }
44 
45     uint256 c = a * b;
46     require(c / a == b);
47 
48     return c;
49   }
50 
51   /**
52   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
53   */
54   function div(uint256 a, uint256 b) internal pure returns (uint256) {
55     require(b > 0); // Solidity only automatically asserts when dividing by 0
56     uint256 c = a / b;
57     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58 
59     return c;
60   }
61 
62   /**
63   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
64   */
65   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66     require(b <= a);
67     uint256 c = a - b;
68 
69     return c;
70   }
71 
72   /**
73   * @dev Adds two numbers, reverts on overflow.
74   */
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     require(c >= a);
78 
79     return c;
80   }
81 
82   /**
83   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
84   * reverts when dividing by zero.
85   */
86   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
87     require(b != 0);
88     return a % b;
89   }
90 }
91 
92 contract Owned {
93     address public owner;
94     address public newOwner;
95     modifier onlyOwner {
96         require(msg.sender == owner);
97         _;
98     }
99     function transferOwnership(address _newOwner) public onlyOwner {
100         newOwner = _newOwner;
101     }
102     function acceptOwnership() public {
103         require(msg.sender == newOwner);
104         owner = newOwner;
105     }
106 }
107 
108 contract OraclizeI {
109 
110     address public cbAddress;
111 
112     function setProofType(byte _proofType) external;
113     function setCustomGasPrice(uint _gasPrice) external;
114     function getPrice(string memory _datasource) public returns (uint _dsprice);
115     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
116     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
117     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
118     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
119     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
120     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
121     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
122     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
123 }
124 
125 contract OraclizeAddrResolverI {
126     function getAddress() public returns (address _address);
127 }
128 
129 library Buffer {
130 
131     struct buffer {
132         bytes buf;
133         uint capacity;
134     }
135 
136     function init(buffer memory _buf, uint _capacity) internal pure {
137         uint capacity = _capacity;
138         if (capacity % 32 != 0) {
139             capacity += 32 - (capacity % 32);
140         }
141         _buf.capacity = capacity; // Allocate space for the buffer data
142         assembly {
143             let ptr := mload(0x40)
144             mstore(_buf, ptr)
145             mstore(ptr, 0)
146             mstore(0x40, add(ptr, capacity))
147         }
148     }
149 
150     function resize(buffer memory _buf, uint _capacity) private pure {
151         bytes memory oldbuf = _buf.buf;
152         init(_buf, _capacity);
153         append(_buf, oldbuf);
154     }
155 
156     function max(uint _a, uint _b) private pure returns (uint _max) {
157         if (_a > _b) {
158             return _a;
159         }
160         return _b;
161     }
162     /**
163       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
164       *      would exceed the capacity of the buffer.
165       * @param _buf The buffer to append to.
166       * @param _data The data to append.
167       * @return The original buffer.
168       *
169       */
170     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
171         if (_data.length + _buf.buf.length > _buf.capacity) {
172             resize(_buf, max(_buf.capacity, _data.length) * 2);
173         }
174         uint dest;
175         uint src;
176         uint len = _data.length;
177         assembly {
178             let bufptr := mload(_buf) // Memory address of the buffer data
179             let buflen := mload(bufptr) // Length of existing buffer data
180             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
181             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
182             src := add(_data, 32)
183         }
184         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
185             assembly {
186                 mstore(dest, mload(src))
187             }
188             dest += 32;
189             src += 32;
190         }
191         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
192         assembly {
193             let srcpart := and(mload(src), not(mask))
194             let destpart := and(mload(dest), mask)
195             mstore(dest, or(destpart, srcpart))
196         }
197         return _buf;
198     }
199     /**
200       *
201       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
202       * exceed the capacity of the buffer.
203       * @param _buf The buffer to append to.
204       * @param _data The data to append.
205       * @return The original buffer.
206       *
207       */
208     function append(buffer memory _buf, uint8 _data) internal pure {
209         if (_buf.buf.length + 1 > _buf.capacity) {
210             resize(_buf, _buf.capacity * 2);
211         }
212         assembly {
213             let bufptr := mload(_buf) // Memory address of the buffer data
214             let buflen := mload(bufptr) // Length of existing buffer data
215             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
216             mstore8(dest, _data)
217             mstore(bufptr, add(buflen, 1)) // Update buffer length
218         }
219     }
220     /**
221       *
222       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
223       * exceed the capacity of the buffer.
224       * @param _buf The buffer to append to.
225       * @param _data The data to append.
226       * @return The original buffer.
227       *
228       */
229     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
230         if (_len + _buf.buf.length > _buf.capacity) {
231             resize(_buf, max(_buf.capacity, _len) * 2);
232         }
233         uint mask = 256 ** _len - 1;
234         assembly {
235             let bufptr := mload(_buf) // Memory address of the buffer data
236             let buflen := mload(bufptr) // Length of existing buffer data
237             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
238             mstore(dest, or(and(mload(dest), not(mask)), _data))
239             mstore(bufptr, add(buflen, _len)) // Update buffer length
240         }
241         return _buf;
242     }
243 }
244 
245 library CBOR {
246 
247     using Buffer for Buffer.buffer;
248 
249     uint8 private constant MAJOR_TYPE_INT = 0;
250     uint8 private constant MAJOR_TYPE_MAP = 5;
251     uint8 private constant MAJOR_TYPE_BYTES = 2;
252     uint8 private constant MAJOR_TYPE_ARRAY = 4;
253     uint8 private constant MAJOR_TYPE_STRING = 3;
254     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
255     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
256 
257     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
258         if (_value <= 23) {
259             _buf.append(uint8((_major << 5) | _value));
260         } else if (_value <= 0xFF) {
261             _buf.append(uint8((_major << 5) | 24));
262             _buf.appendInt(_value, 1);
263         } else if (_value <= 0xFFFF) {
264             _buf.append(uint8((_major << 5) | 25));
265             _buf.appendInt(_value, 2);
266         } else if (_value <= 0xFFFFFFFF) {
267             _buf.append(uint8((_major << 5) | 26));
268             _buf.appendInt(_value, 4);
269         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
270             _buf.append(uint8((_major << 5) | 27));
271             _buf.appendInt(_value, 8);
272         }
273     }
274 
275     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
276         _buf.append(uint8((_major << 5) | 31));
277     }
278 
279     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
280         encodeType(_buf, MAJOR_TYPE_INT, _value);
281     }
282 
283     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
284         if (_value >= 0) {
285             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
286         } else {
287             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
288         }
289     }
290 
291     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
292         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
293         _buf.append(_value);
294     }
295 
296     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
297         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
298         _buf.append(bytes(_value));
299     }
300 
301     function startArray(Buffer.buffer memory _buf) internal pure {
302         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
303     }
304 
305     function startMap(Buffer.buffer memory _buf) internal pure {
306         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
307     }
308 
309     function endSequence(Buffer.buffer memory _buf) internal pure {
310         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
311     }
312 }
313 
314 contract usingOraclize {
315 
316     using CBOR for Buffer.buffer;
317 
318     OraclizeI oraclize;
319     OraclizeAddrResolverI OAR;
320 
321     uint constant day = 60 * 60 * 24;
322     uint constant week = 60 * 60 * 24 * 7;
323     uint constant month = 60 * 60 * 24 * 30;
324 
325     byte constant proofType_NONE = 0x00;
326     byte constant proofType_Ledger = 0x30;
327     byte constant proofType_Native = 0xF0;
328     byte constant proofStorage_IPFS = 0x01;
329     byte constant proofType_Android = 0x40;
330     byte constant proofType_TLSNotary = 0x10;
331 
332     string oraclize_network_name;
333     uint8 constant networkID_auto = 0;
334     uint8 constant networkID_morden = 2;
335     uint8 constant networkID_mainnet = 1;
336     uint8 constant networkID_testnet = 2;
337     uint8 constant networkID_consensys = 161;
338 
339     mapping(bytes32 => bytes32) oraclize_randomDS_args;
340     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
341 
342     modifier oraclizeAPI {
343         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
344             oraclize_setNetwork(networkID_auto);
345         }
346         if (address(oraclize) != OAR.getAddress()) {
347             oraclize = OraclizeI(OAR.getAddress());
348         }
349         _;
350     }
351 
352     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
353         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
354         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
355         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
356         require(proofVerified);
357         _;
358     }
359 
360     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
361       return oraclize_setNetwork();
362       _networkID; // silence the warning and remain backwards compatible
363     }
364 
365     function oraclize_setNetworkName(string memory _network_name) internal {
366         oraclize_network_name = _network_name;
367     }
368 
369     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
370         return oraclize_network_name;
371     }
372 
373     function oraclize_setNetwork() internal returns (bool _networkSet) {
374         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
375             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
376             oraclize_setNetworkName("eth_mainnet");
377             return true;
378         }
379         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
380             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
381             oraclize_setNetworkName("eth_ropsten3");
382             return true;
383         }
384         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
385             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
386             oraclize_setNetworkName("eth_kovan");
387             return true;
388         }
389         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
390             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
391             oraclize_setNetworkName("eth_rinkeby");
392             return true;
393         }
394         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
395             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
396             return true;
397         }
398         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
399             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
400             return true;
401         }
402         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
403             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
404             return true;
405         }
406         return false;
407     }
408 
409     function __callback(bytes32 _myid, string memory _result) public {
410         __callback(_myid, _result, new bytes(0));
411     }
412 
413     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
414       return;
415       _myid; _result; _proof; // Silence compiler warnings
416     }
417 
418     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
419         return oraclize.getPrice(_datasource);
420     }
421 
422     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
423         return oraclize.getPrice(_datasource, _gasLimit);
424     }
425 
426     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
427         uint price = oraclize.getPrice(_datasource);
428         if (price > 1 ether + tx.gasprice * 200000) {
429             return 0; // Unexpectedly high price
430         }
431         return oraclize.query.value(price)(0, _datasource, _arg);
432     }
433 
434     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
435         uint price = oraclize.getPrice(_datasource);
436         if (price > 1 ether + tx.gasprice * 200000) {
437             return 0; // Unexpectedly high price
438         }
439         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
440     }
441 
442     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
443         uint price = oraclize.getPrice(_datasource,_gasLimit);
444         if (price > 1 ether + tx.gasprice * _gasLimit) {
445             return 0; // Unexpectedly high price
446         }
447         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
448     }
449 
450     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
451         uint price = oraclize.getPrice(_datasource, _gasLimit);
452         if (price > 1 ether + tx.gasprice * _gasLimit) {
453            return 0; // Unexpectedly high price
454         }
455         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
456     }
457 
458     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
459         uint price = oraclize.getPrice(_datasource);
460         if (price > 1 ether + tx.gasprice * 200000) {
461             return 0; // Unexpectedly high price
462         }
463         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
464     }
465 
466     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
467         uint price = oraclize.getPrice(_datasource);
468         if (price > 1 ether + tx.gasprice * 200000) {
469             return 0; // Unexpectedly high price
470         }
471         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
472     }
473 
474     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
475         uint price = oraclize.getPrice(_datasource, _gasLimit);
476         if (price > 1 ether + tx.gasprice * _gasLimit) {
477             return 0; // Unexpectedly high price
478         }
479         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
480     }
481 
482     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
483         uint price = oraclize.getPrice(_datasource, _gasLimit);
484         if (price > 1 ether + tx.gasprice * _gasLimit) {
485             return 0; // Unexpectedly high price
486         }
487         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
488     }
489 
490     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
491         uint price = oraclize.getPrice(_datasource);
492         if (price > 1 ether + tx.gasprice * 200000) {
493             return 0; // Unexpectedly high price
494         }
495         bytes memory args = stra2cbor(_argN);
496         return oraclize.queryN.value(price)(0, _datasource, args);
497     }
498 
499     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
500         uint price = oraclize.getPrice(_datasource);
501         if (price > 1 ether + tx.gasprice * 200000) {
502             return 0; // Unexpectedly high price
503         }
504         bytes memory args = stra2cbor(_argN);
505         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
506     }
507 
508     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
509         uint price = oraclize.getPrice(_datasource, _gasLimit);
510         if (price > 1 ether + tx.gasprice * _gasLimit) {
511             return 0; // Unexpectedly high price
512         }
513         bytes memory args = stra2cbor(_argN);
514         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
515     }
516 
517     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
518         uint price = oraclize.getPrice(_datasource, _gasLimit);
519         if (price > 1 ether + tx.gasprice * _gasLimit) {
520             return 0; // Unexpectedly high price
521         }
522         bytes memory args = stra2cbor(_argN);
523         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
524     }
525 
526     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
527         string[] memory dynargs = new string[](1);
528         dynargs[0] = _args[0];
529         return oraclize_query(_datasource, dynargs);
530     }
531 
532     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
533         string[] memory dynargs = new string[](1);
534         dynargs[0] = _args[0];
535         return oraclize_query(_timestamp, _datasource, dynargs);
536     }
537 
538     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
539         string[] memory dynargs = new string[](1);
540         dynargs[0] = _args[0];
541         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
542     }
543 
544     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
545         string[] memory dynargs = new string[](1);
546         dynargs[0] = _args[0];
547         return oraclize_query(_datasource, dynargs, _gasLimit);
548     }
549 
550     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
551         string[] memory dynargs = new string[](2);
552         dynargs[0] = _args[0];
553         dynargs[1] = _args[1];
554         return oraclize_query(_datasource, dynargs);
555     }
556 
557     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
558         string[] memory dynargs = new string[](2);
559         dynargs[0] = _args[0];
560         dynargs[1] = _args[1];
561         return oraclize_query(_timestamp, _datasource, dynargs);
562     }
563 
564     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
565         string[] memory dynargs = new string[](2);
566         dynargs[0] = _args[0];
567         dynargs[1] = _args[1];
568         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
569     }
570 
571     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
572         string[] memory dynargs = new string[](2);
573         dynargs[0] = _args[0];
574         dynargs[1] = _args[1];
575         return oraclize_query(_datasource, dynargs, _gasLimit);
576     }
577 
578     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
579         string[] memory dynargs = new string[](3);
580         dynargs[0] = _args[0];
581         dynargs[1] = _args[1];
582         dynargs[2] = _args[2];
583         return oraclize_query(_datasource, dynargs);
584     }
585 
586     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
587         string[] memory dynargs = new string[](3);
588         dynargs[0] = _args[0];
589         dynargs[1] = _args[1];
590         dynargs[2] = _args[2];
591         return oraclize_query(_timestamp, _datasource, dynargs);
592     }
593 
594     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
595         string[] memory dynargs = new string[](3);
596         dynargs[0] = _args[0];
597         dynargs[1] = _args[1];
598         dynargs[2] = _args[2];
599         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
600     }
601 
602     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
603         string[] memory dynargs = new string[](3);
604         dynargs[0] = _args[0];
605         dynargs[1] = _args[1];
606         dynargs[2] = _args[2];
607         return oraclize_query(_datasource, dynargs, _gasLimit);
608     }
609 
610     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
611         string[] memory dynargs = new string[](4);
612         dynargs[0] = _args[0];
613         dynargs[1] = _args[1];
614         dynargs[2] = _args[2];
615         dynargs[3] = _args[3];
616         return oraclize_query(_datasource, dynargs);
617     }
618 
619     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
620         string[] memory dynargs = new string[](4);
621         dynargs[0] = _args[0];
622         dynargs[1] = _args[1];
623         dynargs[2] = _args[2];
624         dynargs[3] = _args[3];
625         return oraclize_query(_timestamp, _datasource, dynargs);
626     }
627 
628     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
629         string[] memory dynargs = new string[](4);
630         dynargs[0] = _args[0];
631         dynargs[1] = _args[1];
632         dynargs[2] = _args[2];
633         dynargs[3] = _args[3];
634         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
635     }
636 
637     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
638         string[] memory dynargs = new string[](4);
639         dynargs[0] = _args[0];
640         dynargs[1] = _args[1];
641         dynargs[2] = _args[2];
642         dynargs[3] = _args[3];
643         return oraclize_query(_datasource, dynargs, _gasLimit);
644     }
645 
646     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
647         string[] memory dynargs = new string[](5);
648         dynargs[0] = _args[0];
649         dynargs[1] = _args[1];
650         dynargs[2] = _args[2];
651         dynargs[3] = _args[3];
652         dynargs[4] = _args[4];
653         return oraclize_query(_datasource, dynargs);
654     }
655 
656     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
657         string[] memory dynargs = new string[](5);
658         dynargs[0] = _args[0];
659         dynargs[1] = _args[1];
660         dynargs[2] = _args[2];
661         dynargs[3] = _args[3];
662         dynargs[4] = _args[4];
663         return oraclize_query(_timestamp, _datasource, dynargs);
664     }
665 
666     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
667         string[] memory dynargs = new string[](5);
668         dynargs[0] = _args[0];
669         dynargs[1] = _args[1];
670         dynargs[2] = _args[2];
671         dynargs[3] = _args[3];
672         dynargs[4] = _args[4];
673         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
674     }
675 
676     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
677         string[] memory dynargs = new string[](5);
678         dynargs[0] = _args[0];
679         dynargs[1] = _args[1];
680         dynargs[2] = _args[2];
681         dynargs[3] = _args[3];
682         dynargs[4] = _args[4];
683         return oraclize_query(_datasource, dynargs, _gasLimit);
684     }
685 
686     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
687         uint price = oraclize.getPrice(_datasource);
688         if (price > 1 ether + tx.gasprice * 200000) {
689             return 0; // Unexpectedly high price
690         }
691         bytes memory args = ba2cbor(_argN);
692         return oraclize.queryN.value(price)(0, _datasource, args);
693     }
694 
695     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
696         uint price = oraclize.getPrice(_datasource);
697         if (price > 1 ether + tx.gasprice * 200000) {
698             return 0; // Unexpectedly high price
699         }
700         bytes memory args = ba2cbor(_argN);
701         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
702     }
703 
704     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
705         uint price = oraclize.getPrice(_datasource, _gasLimit);
706         if (price > 1 ether + tx.gasprice * _gasLimit) {
707             return 0; // Unexpectedly high price
708         }
709         bytes memory args = ba2cbor(_argN);
710         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
711     }
712 
713     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
714         uint price = oraclize.getPrice(_datasource, _gasLimit);
715         if (price > 1 ether + tx.gasprice * _gasLimit) {
716             return 0; // Unexpectedly high price
717         }
718         bytes memory args = ba2cbor(_argN);
719         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
720     }
721 
722     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
723         bytes[] memory dynargs = new bytes[](1);
724         dynargs[0] = _args[0];
725         return oraclize_query(_datasource, dynargs);
726     }
727 
728     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
729         bytes[] memory dynargs = new bytes[](1);
730         dynargs[0] = _args[0];
731         return oraclize_query(_timestamp, _datasource, dynargs);
732     }
733 
734     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
735         bytes[] memory dynargs = new bytes[](1);
736         dynargs[0] = _args[0];
737         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
738     }
739 
740     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
741         bytes[] memory dynargs = new bytes[](1);
742         dynargs[0] = _args[0];
743         return oraclize_query(_datasource, dynargs, _gasLimit);
744     }
745 
746     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
747         bytes[] memory dynargs = new bytes[](2);
748         dynargs[0] = _args[0];
749         dynargs[1] = _args[1];
750         return oraclize_query(_datasource, dynargs);
751     }
752 
753     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
754         bytes[] memory dynargs = new bytes[](2);
755         dynargs[0] = _args[0];
756         dynargs[1] = _args[1];
757         return oraclize_query(_timestamp, _datasource, dynargs);
758     }
759 
760     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
761         bytes[] memory dynargs = new bytes[](2);
762         dynargs[0] = _args[0];
763         dynargs[1] = _args[1];
764         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
765     }
766 
767     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
768         bytes[] memory dynargs = new bytes[](2);
769         dynargs[0] = _args[0];
770         dynargs[1] = _args[1];
771         return oraclize_query(_datasource, dynargs, _gasLimit);
772     }
773 
774     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
775         bytes[] memory dynargs = new bytes[](3);
776         dynargs[0] = _args[0];
777         dynargs[1] = _args[1];
778         dynargs[2] = _args[2];
779         return oraclize_query(_datasource, dynargs);
780     }
781 
782     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
783         bytes[] memory dynargs = new bytes[](3);
784         dynargs[0] = _args[0];
785         dynargs[1] = _args[1];
786         dynargs[2] = _args[2];
787         return oraclize_query(_timestamp, _datasource, dynargs);
788     }
789 
790     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
791         bytes[] memory dynargs = new bytes[](3);
792         dynargs[0] = _args[0];
793         dynargs[1] = _args[1];
794         dynargs[2] = _args[2];
795         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
796     }
797 
798     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
799         bytes[] memory dynargs = new bytes[](3);
800         dynargs[0] = _args[0];
801         dynargs[1] = _args[1];
802         dynargs[2] = _args[2];
803         return oraclize_query(_datasource, dynargs, _gasLimit);
804     }
805 
806     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
807         bytes[] memory dynargs = new bytes[](4);
808         dynargs[0] = _args[0];
809         dynargs[1] = _args[1];
810         dynargs[2] = _args[2];
811         dynargs[3] = _args[3];
812         return oraclize_query(_datasource, dynargs);
813     }
814 
815     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
816         bytes[] memory dynargs = new bytes[](4);
817         dynargs[0] = _args[0];
818         dynargs[1] = _args[1];
819         dynargs[2] = _args[2];
820         dynargs[3] = _args[3];
821         return oraclize_query(_timestamp, _datasource, dynargs);
822     }
823 
824     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
825         bytes[] memory dynargs = new bytes[](4);
826         dynargs[0] = _args[0];
827         dynargs[1] = _args[1];
828         dynargs[2] = _args[2];
829         dynargs[3] = _args[3];
830         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
831     }
832 
833     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
834         bytes[] memory dynargs = new bytes[](4);
835         dynargs[0] = _args[0];
836         dynargs[1] = _args[1];
837         dynargs[2] = _args[2];
838         dynargs[3] = _args[3];
839         return oraclize_query(_datasource, dynargs, _gasLimit);
840     }
841 
842     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
843         bytes[] memory dynargs = new bytes[](5);
844         dynargs[0] = _args[0];
845         dynargs[1] = _args[1];
846         dynargs[2] = _args[2];
847         dynargs[3] = _args[3];
848         dynargs[4] = _args[4];
849         return oraclize_query(_datasource, dynargs);
850     }
851 
852     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
853         bytes[] memory dynargs = new bytes[](5);
854         dynargs[0] = _args[0];
855         dynargs[1] = _args[1];
856         dynargs[2] = _args[2];
857         dynargs[3] = _args[3];
858         dynargs[4] = _args[4];
859         return oraclize_query(_timestamp, _datasource, dynargs);
860     }
861 
862     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
863         bytes[] memory dynargs = new bytes[](5);
864         dynargs[0] = _args[0];
865         dynargs[1] = _args[1];
866         dynargs[2] = _args[2];
867         dynargs[3] = _args[3];
868         dynargs[4] = _args[4];
869         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
870     }
871 
872     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
873         bytes[] memory dynargs = new bytes[](5);
874         dynargs[0] = _args[0];
875         dynargs[1] = _args[1];
876         dynargs[2] = _args[2];
877         dynargs[3] = _args[3];
878         dynargs[4] = _args[4];
879         return oraclize_query(_datasource, dynargs, _gasLimit);
880     }
881 
882     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
883         return oraclize.setProofType(_proofP);
884     }
885 
886 
887     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
888         return oraclize.cbAddress();
889     }
890 
891     function getCodeSize(address _addr) view internal returns (uint _size) {
892         assembly {
893             _size := extcodesize(_addr)
894         }
895     }
896 
897     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
898         return oraclize.setCustomGasPrice(_gasPrice);
899     }
900 
901     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
902         return oraclize.randomDS_getSessionPubKeyHash();
903     }
904 
905     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
906         bytes memory tmp = bytes(_a);
907         uint160 iaddr = 0;
908         uint160 b1;
909         uint160 b2;
910         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
911             iaddr *= 256;
912             b1 = uint160(uint8(tmp[i]));
913             b2 = uint160(uint8(tmp[i + 1]));
914             if ((b1 >= 97) && (b1 <= 102)) {
915                 b1 -= 87;
916             } else if ((b1 >= 65) && (b1 <= 70)) {
917                 b1 -= 55;
918             } else if ((b1 >= 48) && (b1 <= 57)) {
919                 b1 -= 48;
920             }
921             if ((b2 >= 97) && (b2 <= 102)) {
922                 b2 -= 87;
923             } else if ((b2 >= 65) && (b2 <= 70)) {
924                 b2 -= 55;
925             } else if ((b2 >= 48) && (b2 <= 57)) {
926                 b2 -= 48;
927             }
928             iaddr += (b1 * 16 + b2);
929         }
930         return address(iaddr);
931     }
932 
933     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
934         bytes memory a = bytes(_a);
935         bytes memory b = bytes(_b);
936         uint minLength = a.length;
937         if (b.length < minLength) {
938             minLength = b.length;
939         }
940         for (uint i = 0; i < minLength; i ++) {
941             if (a[i] < b[i]) {
942                 return -1;
943             } else if (a[i] > b[i]) {
944                 return 1;
945             }
946         }
947         if (a.length < b.length) {
948             return -1;
949         } else if (a.length > b.length) {
950             return 1;
951         } else {
952             return 0;
953         }
954     }
955 
956     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
957         bytes memory h = bytes(_haystack);
958         bytes memory n = bytes(_needle);
959         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
960             return -1;
961         } else if (h.length > (2 ** 128 - 1)) {
962             return -1;
963         } else {
964             uint subindex = 0;
965             for (uint i = 0; i < h.length; i++) {
966                 if (h[i] == n[0]) {
967                     subindex = 1;
968                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
969                         subindex++;
970                     }
971                     if (subindex == n.length) {
972                         return int(i);
973                     }
974                 }
975             }
976             return -1;
977         }
978     }
979 
980     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
981         return strConcat(_a, _b, "", "", "");
982     }
983 
984     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
985         return strConcat(_a, _b, _c, "", "");
986     }
987 
988     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
989         return strConcat(_a, _b, _c, _d, "");
990     }
991 
992     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
993         bytes memory _ba = bytes(_a);
994         bytes memory _bb = bytes(_b);
995         bytes memory _bc = bytes(_c);
996         bytes memory _bd = bytes(_d);
997         bytes memory _be = bytes(_e);
998         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
999         bytes memory babcde = bytes(abcde);
1000         uint k = 0;
1001         uint i = 0;
1002         for (i = 0; i < _ba.length; i++) {
1003             babcde[k++] = _ba[i];
1004         }
1005         for (i = 0; i < _bb.length; i++) {
1006             babcde[k++] = _bb[i];
1007         }
1008         for (i = 0; i < _bc.length; i++) {
1009             babcde[k++] = _bc[i];
1010         }
1011         for (i = 0; i < _bd.length; i++) {
1012             babcde[k++] = _bd[i];
1013         }
1014         for (i = 0; i < _be.length; i++) {
1015             babcde[k++] = _be[i];
1016         }
1017         return string(babcde);
1018     }
1019 
1020     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
1021         return safeParseInt(_a, 0);
1022     }
1023 
1024     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1025         bytes memory bresult = bytes(_a);
1026         uint mint = 0;
1027         bool decimals = false;
1028         for (uint i = 0; i < bresult.length; i++) {
1029             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1030                 if (decimals) {
1031                    if (_b == 0) break;
1032                     else _b--;
1033                 }
1034                 mint *= 10;
1035                 mint += uint(uint8(bresult[i])) - 48;
1036             } else if (uint(uint8(bresult[i])) == 46) {
1037                 require(!decimals, 'More than one decimal encountered in string!');
1038                 decimals = true;
1039             } else {
1040                 revert("Non-numeral character encountered in string!");
1041             }
1042         }
1043         if (_b > 0) {
1044             mint *= 10 ** _b;
1045         }
1046         return mint;
1047     }
1048 
1049     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
1050         return parseInt(_a, 0);
1051     }
1052 
1053     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1054         bytes memory bresult = bytes(_a);
1055         uint mint = 0;
1056         bool decimals = false;
1057         for (uint i = 0; i < bresult.length; i++) {
1058             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1059                 if (decimals) {
1060                    if (_b == 0) {
1061                        break;
1062                    } else {
1063                        _b--;
1064                    }
1065                 }
1066                 mint *= 10;
1067                 mint += uint(uint8(bresult[i])) - 48;
1068             } else if (uint(uint8(bresult[i])) == 46) {
1069                 decimals = true;
1070             }
1071         }
1072         if (_b > 0) {
1073             mint *= 10 ** _b;
1074         }
1075         return mint;
1076     }
1077 
1078     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1079         if (_i == 0) {
1080             return "0";
1081         }
1082         uint j = _i;
1083         uint len;
1084         while (j != 0) {
1085             len++;
1086             j /= 10;
1087         }
1088         bytes memory bstr = new bytes(len);
1089         uint k = len - 1;
1090         while (_i != 0) {
1091             bstr[k--] = byte(uint8(48 + _i % 10));
1092             _i /= 10;
1093         }
1094         return string(bstr);
1095     }
1096 
1097     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1098         safeMemoryCleaner();
1099         Buffer.buffer memory buf;
1100         Buffer.init(buf, 1024);
1101         buf.startArray();
1102         for (uint i = 0; i < _arr.length; i++) {
1103             buf.encodeString(_arr[i]);
1104         }
1105         buf.endSequence();
1106         return buf.buf;
1107     }
1108 
1109     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1110         safeMemoryCleaner();
1111         Buffer.buffer memory buf;
1112         Buffer.init(buf, 1024);
1113         buf.startArray();
1114         for (uint i = 0; i < _arr.length; i++) {
1115             buf.encodeBytes(_arr[i]);
1116         }
1117         buf.endSequence();
1118         return buf.buf;
1119     }
1120 
1121     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1122         require((_nbytes > 0) && (_nbytes <= 32));
1123         _delay *= 10; // Convert from seconds to ledger timer ticks
1124         bytes memory nbytes = new bytes(1);
1125         nbytes[0] = byte(uint8(_nbytes));
1126         bytes memory unonce = new bytes(32);
1127         bytes memory sessionKeyHash = new bytes(32);
1128         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1129         assembly {
1130             mstore(unonce, 0x20)
1131             /*
1132              The following variables can be relaxed.
1133              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1134              for an idea on how to override and replace commit hash variables.
1135             */
1136             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1137             mstore(sessionKeyHash, 0x20)
1138             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1139         }
1140         bytes memory delay = new bytes(32);
1141         assembly {
1142             mstore(add(delay, 0x20), _delay)
1143         }
1144         bytes memory delay_bytes8 = new bytes(8);
1145         copyBytes(delay, 24, 8, delay_bytes8, 0);
1146         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1147         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1148         bytes memory delay_bytes8_left = new bytes(8);
1149         assembly {
1150             let x := mload(add(delay_bytes8, 0x20))
1151             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1152             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1153             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1154             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1155             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1156             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1157             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1158             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1159         }
1160         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1161         return queryId;
1162     }
1163 
1164     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1165         oraclize_randomDS_args[_queryId] = _commitment;
1166     }
1167 
1168     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1169         bool sigok;
1170         address signer;
1171         bytes32 sigr;
1172         bytes32 sigs;
1173         bytes memory sigr_ = new bytes(32);
1174         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1175         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1176         bytes memory sigs_ = new bytes(32);
1177         offset += 32 + 2;
1178         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1179         assembly {
1180             sigr := mload(add(sigr_, 32))
1181             sigs := mload(add(sigs_, 32))
1182         }
1183         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1184         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1185             return true;
1186         } else {
1187             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1188             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1189         }
1190     }
1191 
1192     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1193         bool sigok;
1194         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1195         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1196         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1197         bytes memory appkey1_pubkey = new bytes(64);
1198         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1199         bytes memory tosign2 = new bytes(1 + 65 + 32);
1200         tosign2[0] = byte(uint8(1)); //role
1201         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1202         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1203         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1204         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1205         if (!sigok) {
1206             return false;
1207         }
1208         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1209         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1210         bytes memory tosign3 = new bytes(1 + 65);
1211         tosign3[0] = 0xFE;
1212         copyBytes(_proof, 3, 65, tosign3, 1);
1213         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1214         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1215         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1216         return sigok;
1217     }
1218 
1219     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1220         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1221         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1222             return 1;
1223         }
1224         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1225         if (!proofVerified) {
1226             return 2;
1227         }
1228         return 0;
1229     }
1230 
1231     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1232         bool match_ = true;
1233         require(_prefix.length == _nRandomBytes);
1234         for (uint256 i = 0; i< _nRandomBytes; i++) {
1235             if (_content[i] != _prefix[i]) {
1236                 match_ = false;
1237             }
1238         }
1239         return match_;
1240     }
1241 
1242     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1243         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1244         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1245         bytes memory keyhash = new bytes(32);
1246         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1247         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1248             return false;
1249         }
1250         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1251         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1252         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1253         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1254             return false;
1255         }
1256         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1257         // This is to verify that the computed args match with the ones specified in the query.
1258         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1259         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1260         bytes memory sessionPubkey = new bytes(64);
1261         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1262         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1263         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1264         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1265             delete oraclize_randomDS_args[_queryId];
1266         } else return false;
1267         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1268         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1269         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1270         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1271             return false;
1272         }
1273         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1274         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1275             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1276         }
1277         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1278     }
1279     /*
1280      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1281     */
1282     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1283         uint minLength = _length + _toOffset;
1284         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1285         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1286         uint j = 32 + _toOffset;
1287         while (i < (32 + _fromOffset + _length)) {
1288             assembly {
1289                 let tmp := mload(add(_from, i))
1290                 mstore(add(_to, j), tmp)
1291             }
1292             i += 32;
1293             j += 32;
1294         }
1295         return _to;
1296     }
1297     /*
1298      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1299      Duplicate Solidity's ecrecover, but catching the CALL return value
1300     */
1301     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1302         /*
1303          We do our own memory management here. Solidity uses memory offset
1304          0x40 to store the current end of memory. We write past it (as
1305          writes are memory extensions), but don't update the offset so
1306          Solidity will reuse it. The memory used here is only needed for
1307          this context.
1308          FIXME: inline assembly can't access return values
1309         */
1310         bool ret;
1311         address addr;
1312         assembly {
1313             let size := mload(0x40)
1314             mstore(size, _hash)
1315             mstore(add(size, 32), _v)
1316             mstore(add(size, 64), _r)
1317             mstore(add(size, 96), _s)
1318             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1319             addr := mload(size)
1320         }
1321         return (ret, addr);
1322     }
1323     /*
1324      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1325     */
1326     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1327         bytes32 r;
1328         bytes32 s;
1329         uint8 v;
1330         if (_sig.length != 65) {
1331             return (false, address(0));
1332         }
1333         /*
1334          The signature format is a compact form of:
1335            {bytes32 r}{bytes32 s}{uint8 v}
1336          Compact means, uint8 is not padded to 32 bytes.
1337         */
1338         assembly {
1339             r := mload(add(_sig, 32))
1340             s := mload(add(_sig, 64))
1341             /*
1342              Here we are loading the last 32 bytes. We exploit the fact that
1343              'mload' will pad with zeroes if we overread.
1344              There is no 'mload8' to do this, but that would be nicer.
1345             */
1346             v := byte(0, mload(add(_sig, 96)))
1347             /*
1348               Alternative solution:
1349               'byte' is not working due to the Solidity parser, so lets
1350               use the second best option, 'and'
1351               v := and(mload(add(_sig, 65)), 255)
1352             */
1353         }
1354         /*
1355          albeit non-transactional signatures are not specified by the YP, one would expect it
1356          to match the YP range of [27, 28]
1357          geth uses [0, 1] and some clients have followed. This might change, see:
1358          https://github.com/ethereum/go-ethereum/issues/2053
1359         */
1360         if (v < 27) {
1361             v += 27;
1362         }
1363         if (v != 27 && v != 28) {
1364             return (false, address(0));
1365         }
1366         return safer_ecrecover(_hash, v, r, s);
1367     }
1368 
1369     function safeMemoryCleaner() internal pure {
1370         assembly {
1371             let fmem := mload(0x40)
1372             codecopy(fmem, codesize, sub(msize, fmem))
1373         }
1374     }
1375 }
1376 
1377 contract PAXTokenReserve is IERC20, Owned, usingOraclize {
1378     using SafeMath for uint256;
1379 
1380     constructor() public {
1381         timestampOfNextMonth = 1554076800;
1382         minterAddress = 0x7645Ad8D4a2cD5b07D8Bc4ea1690d5c1F765aabC;
1383         anticipationAddress = 0x7645Ad8D4a2cD5b07D8Bc4ea1690d5c1F765aabC;
1384         worldTreasuryAddress = 0x7645Ad8D4a2cD5b07D8Bc4ea1690d5c1F765aabC;
1385         freeFloat = 0x7645Ad8D4a2cD5b07D8Bc4ea1690d5c1F765aabC;
1386         owner = 0x7645Ad8D4a2cD5b07D8Bc4ea1690d5c1F765aabC;
1387     }
1388 
1389     // Token Setup
1390     string public constant name = "PAX Treasure Reserve";
1391     string public constant TermsOfUse = "";
1392     string public constant symbol = "PAXTR";
1393     uint256 public constant decimals = 8;
1394     uint256 private supply;
1395     uint256 private circulatingSupply;
1396     uint256 public totalReleased;
1397     
1398     // Treasure Setup
1399     uint256 public activeAccounts = 0;
1400     mapping(uint256 => uint256) internal closingAccounts;
1401     uint256 public constant monthlyClaim = 585970464;
1402     address public minterAddress;
1403     address public worldTreasuryAddress;
1404     address public freeFloat;
1405     address public anticipationAddress;
1406     
1407     uint256 public currentMonth = 1;
1408     uint256 internal timestampOfNextMonth;
1409 
1410     // Demurrage Global variables
1411     mapping(uint256 => uint256) public undermurraged;
1412     mapping(uint256 => uint256) public claimedTokens;
1413     
1414     uint256 public totalMonthlyAnticipation;
1415     mapping(uint256 => uint256) public monthlyClaimAnticipationEnd;
1416     
1417     bool internal pendingOracle = false;
1418     
1419     // Events
1420     event ClaimDemurrage(address to, uint256 amount);
1421     event PayDemurrage(address from, uint256 amount);
1422     event OpenTreasury(address account);
1423     event CloseTreasury(address account);
1424     event Unlock(address account, uint256 amount);
1425     event NewAnticipation(address account, uint256 amount);
1426     
1427     // Accounts and Balances
1428     mapping(address => uint256) private _balances;
1429     mapping(address => mapping(uint256 => uint256)) private monthsLowestBalance;
1430     mapping(address => mapping(uint256 => bool)) private transacted;
1431     mapping(address => mapping (address => uint256)) public _allowed;
1432     
1433     // Treasure Account
1434     struct TreasureStruct {
1435         uint256 balance;
1436         uint256 claimed;
1437         mapping(uint256 => uint256) monthsClaim;
1438         uint256 totalRefferals;
1439         mapping(uint256 => uint256) monthsRefferals;
1440         uint256 lastUpdate;
1441         uint256 endMonth;
1442         uint256 monthlyAnticipation;
1443     }
1444     
1445     mapping(address => TreasureStruct) public treasury;
1446     mapping(address => bool) public activeTreasury;
1447     
1448     // Calculate Demurrage
1449     function calcUnrealisedDemurrage(address account, uint256 month) public view returns(uint256) {
1450         if (transacted[account][month] == true) {
1451             return ((monthsLowestBalance[account][month] * 118511851) / 100000000000);
1452         } else {
1453             return ((_balances[account] * 118511851) / 100000000000);
1454         }
1455     }
1456     function calcTreasuryDemurrage(address account, uint256 month) public view returns(uint256) {
1457         if (activeTreasury[account] == true && currentMonth != month) {
1458             return (monthlyClaim - treasury[account].monthsClaim[month]);
1459         } else {
1460             return 0;
1461         }
1462     }
1463     
1464     // Pay Demurrage
1465     function payDemurrage(address account) public {
1466         while (treasury[account].lastUpdate < currentMonth - 1) {
1467             uint256 month = treasury[account].lastUpdate + 1;
1468             uint256 treasuryDemurrage = calcTreasuryDemurrage(account, month);
1469             uint256 balanceDemurrage = calcUnrealisedDemurrage(account, month);
1470             treasury[account].balance = treasury[account].balance.sub(treasuryDemurrage);
1471             _balances[account] = _balances[account].sub(balanceDemurrage);
1472             emit Transfer(account, address(this), balanceDemurrage);
1473             emit PayDemurrage(account, treasuryDemurrage + balanceDemurrage);
1474             treasury[account].lastUpdate++;
1475         }
1476     }
1477     
1478     // Get the total supply of tokens
1479     function totalSupply() public view returns (uint) {
1480         return supply;
1481     }
1482 
1483     string public oraclizeURL = "https://paxco.in:10101/date";
1484     
1485     function setOraclizeURL(string memory _newURL) public onlyOwner {
1486         oraclizeURL = _newURL;
1487     }
1488      // Get the token balance for account `tokenOwner`
1489     function balanceOf(address tokenOwner) public view returns (uint balance) {
1490         return _balances[tokenOwner];
1491     }
1492     
1493     // Get the allowance of funds beteen a token holder and a spender
1494     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
1495         return _allowed[tokenOwner][spender];
1496     }
1497     
1498     // Sets how much a sender is allowed to use of an owners funds
1499     function approve(address spender, uint value) public returns (bool success) {
1500         payDemurrage(spender);
1501         payDemurrage(msg.sender);
1502         
1503         _allowed[msg.sender][spender] = value;
1504         emit Approval(msg.sender, spender, value);
1505         return true;
1506     }
1507     
1508     // Transfer the balance from owner's account to another account
1509     function transfer(address to, uint value) public returns (bool success) {
1510         if (now >= timestampOfNextMonth && pendingOracle == false) {
1511             pendingOracle = true;
1512             oraclize_query("URL", oraclizeURL);
1513         }
1514         
1515         if (treasury[msg.sender].endMonth <= currentMonth) {
1516             activeTreasury[msg.sender] = false;
1517         }
1518         if (treasury[to].endMonth <= currentMonth) {
1519             activeTreasury[to] = false;
1520         }
1521         
1522         payDemurrage(msg.sender);
1523         payDemurrage(to);
1524         if (_balances[msg.sender] >= value) {
1525             // Minimum Balance
1526             if (transacted[to][currentMonth] == false) {
1527                 monthsLowestBalance[to][currentMonth] = _balances[to];
1528             }
1529             if (transacted[msg.sender][currentMonth] == false || monthsLowestBalance[msg.sender][currentMonth] > _balances[msg.sender] - value) {
1530                 monthsLowestBalance[msg.sender][currentMonth] = _balances[msg.sender] - value;
1531             }
1532             // Unlock Treasure
1533             if (activeTreasury[msg.sender] == true) {
1534                 unlockTreasure(msg.sender, to, value);
1535             }
1536             // Make Transfer
1537             if (msg.sender == worldTreasuryAddress) {
1538                 circulatingSupply = circulatingSupply.add(value);
1539             }
1540             if (to == worldTreasuryAddress) {
1541                 circulatingSupply = circulatingSupply.sub(value);
1542             }
1543             _balances[msg.sender] = _balances[msg.sender].sub(value);
1544             _balances[to] = _balances[to].add(value);
1545             emit Transfer(msg.sender, to, value);
1546             return true;
1547         } else {
1548             return false;
1549         }
1550     }
1551     
1552     string public oraclizeUrl = '';
1553     
1554     
1555     
1556     // Transfer from function, pulls from allowance
1557     function transferFrom(address from, address to, uint value) public returns (bool success) {
1558         if (now >= timestampOfNextMonth && pendingOracle == false) {
1559             pendingOracle = true;
1560             oraclize_query("URL", oraclizeUrl);
1561         }
1562         
1563         if (treasury[to].endMonth <= currentMonth) {
1564             activeTreasury[to] = false;
1565         }
1566         if (treasury[to].endMonth <= currentMonth) {
1567             activeTreasury[to] = false;
1568         }
1569         
1570         payDemurrage(from);
1571         payDemurrage(to);
1572         if (value <= balanceOf(from) && value <= allowance(from, msg.sender)) {
1573             // Minimum Balance
1574             if (transacted[to][currentMonth] == false) {
1575                 monthsLowestBalance[to][currentMonth] = _balances[to];
1576             }
1577             if (transacted[from][currentMonth] == false || monthsLowestBalance[from][currentMonth] > _balances[from] - value) {
1578                 monthsLowestBalance[from][currentMonth] = _balances[from] - value;
1579                 undermurraged[currentMonth] = undermurraged[currentMonth].add(_balances[from].sub(monthsLowestBalance[from][currentMonth]));
1580             }
1581             // Unlock Treasure
1582             if (activeTreasury[from] == true) {
1583                 unlockTreasure(from, to, value);
1584             }
1585             // Make Transfer
1586             if (from == worldTreasuryAddress) {
1587                 circulatingSupply = circulatingSupply.add(value);
1588             }
1589             if (to == worldTreasuryAddress) {
1590                 circulatingSupply = circulatingSupply.sub(value);
1591             }
1592             _balances[from] = _balances[from].sub(value);
1593             _balances[to] = _balances[to].add(value);
1594             _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
1595             emit Transfer(from, to, value);
1596             return true;
1597         } else {
1598             return false;
1599         }
1600     }
1601     
1602     // Unlocks tokens from treasury
1603     function unlockTreasure(address account, address to, uint256 value) private {
1604         if (to != account) {
1605             // If account can give tokens
1606             if (activeTreasury[account] == true && treasury[account].balance < 555500000000 && treasury[account].monthsClaim[currentMonth] < (monthlyClaim - treasury[account].monthlyAnticipation)) {
1607                 // If account has refferals
1608                 if (treasury[account].totalRefferals == 5 || treasury[account].monthsRefferals[currentMonth] >= 1) {
1609                     uint256 amount = monthlyClaim - treasury[account].monthsClaim[currentMonth] - treasury[account].monthlyAnticipation;
1610                     treasury[account].monthsClaim[currentMonth] = monthlyClaim - treasury[account].monthlyAnticipation;
1611                     treasury[account].balance = treasury[account].balance.sub(amount);
1612                     circulatingSupply = circulatingSupply.add(amount);
1613                     supply = supply.add(amount);
1614                     _balances[account] = _balances[account].add(amount);
1615                     claimedTokens[currentMonth] = currentMonth.add(amount);
1616                     treasury[account].claimed = treasury[account].claimed.add(amount);
1617                     totalReleased = totalReleased.add(amount);
1618                     emit Transfer(address(0), account, amount);
1619                     emit Unlock(account, amount);
1620                 } else if (treasury[account].monthsClaim[currentMonth] + value < monthlyClaim - treasury[account].monthlyAnticipation) {
1621                     treasury[account].monthsClaim[currentMonth] = treasury[account].monthsClaim[currentMonth].add(value);
1622                     _balances[account] = _balances[account].add(value);
1623                     supply = supply.add(value);
1624                     treasury[account].balance = treasury[account].balance.sub(value);
1625                     claimedTokens[currentMonth] = currentMonth.add(value);
1626                     treasury[account].claimed = treasury[account].claimed.add(value);
1627                     totalReleased = totalReleased.add(value);
1628                     emit Transfer(address(0), account, value);
1629                     emit Unlock(account, value);
1630                 } else {
1631                     uint256 amount = monthlyClaim - treasury[account].monthsClaim[currentMonth] - treasury[account].monthlyAnticipation;
1632                     treasury[account].monthsClaim[currentMonth] = monthlyClaim - treasury[account].monthlyAnticipation;
1633                     _balances[account] = _balances[account].add(amount);
1634                     claimedTokens[currentMonth] = currentMonth.add(amount);
1635                     supply = supply.add(amount);
1636                     circulatingSupply = circulatingSupply.add(amount);
1637                     treasury[account].claimed = treasury[account].claimed.add(amount);
1638                     totalReleased = totalReleased.add(amount);
1639                     emit Transfer(address(0), account, amount);
1640                     emit Unlock(account, amount);
1641                 }
1642             }
1643         }
1644     }
1645     
1646     // World treasury
1647     function setWorldTreasuryAddress(address newWorldTreasuryAddress) public onlyOwner {
1648         circulatingSupply = circulatingSupply.sub(_balances[worldTreasuryAddress]);
1649         circulatingSupply = circulatingSupply.sub(_balances[newWorldTreasuryAddress]);
1650         worldTreasuryAddress = newWorldTreasuryAddress;
1651     }
1652     
1653     // Minting
1654     function setMinter(address newMinter) public onlyOwner {
1655         minterAddress = newMinter;
1656     }
1657     function setFreeFloat(address newFreeFloadAddress) public onlyOwner {
1658         freeFloat = newFreeFloadAddress;
1659     }
1660     function mint(address account, address refferer) public {
1661         require(msg.sender == minterAddress);
1662         require(treasury[account].claimed == 0);
1663         require(activeTreasury[account] == false);
1664         // Credits refferal
1665         treasury[refferer].totalRefferals = treasury[refferer].totalRefferals.add(1);
1666         treasury[refferer].monthsRefferals[currentMonth] = treasury[refferer].monthsRefferals[currentMonth].add(1);
1667         // Sets Up account
1668         activeTreasury[account] = true;
1669         treasury[account].claimed = 50000000;
1670         _balances[account] = _balances[account].add(50000000);
1671         treasury[account].balance = 555450000000;
1672         treasury[account].monthsClaim[currentMonth] = 50000000;
1673         transacted[account][currentMonth] = true;
1674         monthsLowestBalance[account][currentMonth] = 50000000;
1675         treasury[account].lastUpdate = currentMonth - 1;
1676         treasury[account].endMonth = currentMonth + 948;
1677         claimedTokens[currentMonth] += 50000000;
1678         // Sets up the global variables
1679         circulatingSupply = circulatingSupply.add(50000000);
1680         supply = supply.add(44550000000);
1681         _balances[freeFloat] = _balances[freeFloat].add(44500000000);
1682         activeAccounts = activeAccounts.add(1);
1683         closingAccounts[currentMonth + 948] = closingAccounts[currentMonth + 948].add(1);
1684         emit Transfer(address(0), account, 50000000);
1685         emit Transfer(address(0), freeFloat, 44500000000);
1686         emit Unlock(account, 50000000);
1687     }
1688     
1689     // Oraclize Callback function
1690     function __callback(bytes32 queryID, string memory result) public {
1691         require(msg.sender == oraclize_cbAddress());
1692         require(pendingOracle == true);
1693       
1694         uint256 unspentTokens = circulatingSupply.sub(undermurraged[currentMonth]);
1695         uint256 unspentDemurrage =  (unspentTokens.mul(118511851)).div(100000000000);
1696         uint256 unclaimedTokens = ((activeAccounts.mul(monthlyClaim)).sub(claimedTokens[currentMonth])).sub(totalMonthlyAnticipation);
1697         uint256 totalDemurrage = unspentDemurrage.add(unclaimedTokens);
1698         
1699         circulatingSupply = circulatingSupply.sub(unspentDemurrage);
1700         _balances[worldTreasuryAddress] = _balances[worldTreasuryAddress].add(totalDemurrage);
1701         emit Transfer(address(this), worldTreasuryAddress, totalDemurrage);
1702         emit ClaimDemurrage(worldTreasuryAddress, totalDemurrage);
1703       
1704         activeAccounts = activeAccounts.sub(closingAccounts[currentMonth]);
1705         totalMonthlyAnticipation = totalMonthlyAnticipation.sub(monthlyClaimAnticipationEnd[currentMonth]);
1706         
1707         currentMonth++;
1708         timestampOfNextMonth = parseInt(result);
1709         pendingOracle = false;
1710     }
1711     
1712     // Force new Oracle
1713     function resetOracle() public onlyOwner {
1714         pendingOracle = true;
1715     }
1716     // Withdraw Ether
1717     function withdrawEther(uint256 amount) public onlyOwner {
1718         require(address(this).balance >= amount);
1719         msg.sender.transfer(amount);
1720     }
1721     
1722     // Artificialy jump to next month
1723     // @Dev - remove this on the mainnet release
1724     function insertMonth() public onlyOwner {
1725         pendingOracle = true;
1726         oraclize_query("URL", "http://pax-api.herokuapp.com/");
1727     }
1728     
1729     // Lifetime Anticipation
1730     function setAnticipationAddress(address newAnticipationAddress) public onlyOwner {
1731         anticipationAddress = newAnticipationAddress;
1732     }
1733     function newAnticipation(address account, uint256 amount) public {
1734         require(msg.sender == anticipationAddress);
1735         require(treasury[account].balance >= amount);
1736         uint256 remainingMonths = treasury[account].endMonth - currentMonth;
1737         require(remainingMonths > 0);
1738         uint256 newMonthlyAnticipation = amount / remainingMonths;
1739         treasury[account].monthlyAnticipation = treasury[account].monthlyAnticipation.add(newMonthlyAnticipation);
1740         totalMonthlyAnticipation = totalMonthlyAnticipation.add(newMonthlyAnticipation);
1741         monthlyClaimAnticipationEnd[treasury[account].endMonth] = monthlyClaimAnticipationEnd[treasury[account].endMonth].add(newMonthlyAnticipation);
1742         _balances[anticipationAddress] = _balances[anticipationAddress].add(amount);
1743         
1744         emit Transfer(address(this), anticipationAddress, amount);
1745         emit NewAnticipation(account, amount);
1746         
1747     }
1748     
1749     // Public Getters for implementing with DAPP (For some data in treasury mapping to stuct)
1750     function getReferrals(address account) public view returns (uint256 total, uint256 monthly) {
1751         return (treasury[account].totalRefferals, treasury[account].monthsRefferals[currentMonth]);
1752     }
1753     function tresureBalance(address account) public view returns (uint256 balance, uint256 remainingClaim, uint256 claimed) {
1754         return (treasury[account].balance, monthlyClaim - treasury[account].monthsClaim[currentMonth], treasury[account].claimed);
1755     }
1756     
1757     // Makes Deposit Possible
1758     function () external payable {}
1759     
1760     
1761 }