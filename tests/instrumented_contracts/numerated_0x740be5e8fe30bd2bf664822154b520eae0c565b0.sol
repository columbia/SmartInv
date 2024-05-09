1 pragma solidity 0.4.24;
2 
3 /**
4 * @dev A library for working with mutable byte buffers in Solidity.
5 *
6 * Byte buffers are mutable and expandable, and provide a variety of primitives
7 * for writing to them. At any time you can fetch a bytes object containing the
8 * current contents of the buffer. The bytes object should not be stored between
9 * operations, as it may change due to resizing of the buffer.
10 */
11 library Buffer {
12   /**
13   * @dev Represents a mutable buffer. Buffers have a current value (buf) and
14   *      a capacity. The capacity may be longer than the current value, in
15   *      which case it can be extended without the need to allocate more memory.
16   */
17   struct buffer {
18     bytes buf;
19     uint capacity;
20   }
21 
22   /**
23   * @dev Initializes a buffer with an initial capacity.
24   * @param buf The buffer to initialize.
25   * @param capacity The number of bytes of space to allocate the buffer.
26   * @return The buffer, for chaining.
27   */
28   function init(buffer memory buf, uint capacity) internal pure returns(buffer memory) {
29     if (capacity % 32 != 0) {
30       capacity += 32 - (capacity % 32);
31     }
32     // Allocate space for the buffer data
33     buf.capacity = capacity;
34     assembly {
35       let ptr := mload(0x40)
36       mstore(buf, ptr)
37       mstore(ptr, 0)
38       mstore(0x40, add(32, add(ptr, capacity)))
39     }
40     return buf;
41   }
42 
43   /**
44   * @dev Initializes a new buffer from an existing bytes object.
45   *      Changes to the buffer may mutate the original value.
46   * @param b The bytes object to initialize the buffer with.
47   * @return A new buffer.
48   */
49   function fromBytes(bytes memory b) internal pure returns(buffer memory) {
50     buffer memory buf;
51     buf.buf = b;
52     buf.capacity = b.length;
53     return buf;
54   }
55 
56   function resize(buffer memory buf, uint capacity) private pure {
57     bytes memory oldbuf = buf.buf;
58     init(buf, capacity);
59     append(buf, oldbuf);
60   }
61 
62   function max(uint a, uint b) private pure returns(uint) {
63     if (a > b) {
64       return a;
65     }
66     return b;
67   }
68 
69   /**
70   * @dev Sets buffer length to 0.
71   * @param buf The buffer to truncate.
72   * @return The original buffer, for chaining..
73   */
74   function truncate(buffer memory buf) internal pure returns (buffer memory) {
75     assembly {
76       let bufptr := mload(buf)
77       mstore(bufptr, 0)
78     }
79     return buf;
80   }
81 
82   /**
83   * @dev Writes a byte string to a buffer. Resizes if doing so would exceed
84   *      the capacity of the buffer.
85   * @param buf The buffer to append to.
86   * @param off The start offset to write to.
87   * @param data The data to append.
88   * @param len The number of bytes to copy.
89   * @return The original buffer, for chaining.
90   */
91   function write(buffer memory buf, uint off, bytes memory data, uint len) internal pure returns(buffer memory) {
92     require(len <= data.length);
93 
94     if (off + len > buf.capacity) {
95       resize(buf, max(buf.capacity, len + off) * 2);
96     }
97 
98     uint dest;
99     uint src;
100     assembly {
101       // Memory address of the buffer data
102       let bufptr := mload(buf)
103       // Length of existing buffer data
104       let buflen := mload(bufptr)
105       // Start address = buffer address + offset + sizeof(buffer length)
106       dest := add(add(bufptr, 32), off)
107       // Update buffer length if we're extending it
108       if gt(add(len, off), buflen) {
109         mstore(bufptr, add(len, off))
110       }
111       src := add(data, 32)
112     }
113 
114     // Copy word-length chunks while possible
115     for (; len >= 32; len -= 32) {
116       assembly {
117         mstore(dest, mload(src))
118       }
119       dest += 32;
120       src += 32;
121     }
122 
123     // Copy remaining bytes
124     uint mask = 256 ** (32 - len) - 1;
125     assembly {
126       let srcpart := and(mload(src), not(mask))
127       let destpart := and(mload(dest), mask)
128       mstore(dest, or(destpart, srcpart))
129     }
130 
131     return buf;
132   }
133 
134   /**
135   * @dev Appends a byte string to a buffer. Resizes if doing so would exceed
136   *      the capacity of the buffer.
137   * @param buf The buffer to append to.
138   * @param data The data to append.
139   * @param len The number of bytes to copy.
140   * @return The original buffer, for chaining.
141   */
142   function append(buffer memory buf, bytes memory data, uint len) internal pure returns (buffer memory) {
143     return write(buf, buf.buf.length, data, len);
144   }
145 
146   /**
147   * @dev Appends a byte string to a buffer. Resizes if doing so would exceed
148   *      the capacity of the buffer.
149   * @param buf The buffer to append to.
150   * @param data The data to append.
151   * @return The original buffer, for chaining.
152   */
153   function append(buffer memory buf, bytes memory data) internal pure returns (buffer memory) {
154     return write(buf, buf.buf.length, data, data.length);
155   }
156 
157   /**
158   * @dev Writes a byte to the buffer. Resizes if doing so would exceed the
159   *      capacity of the buffer.
160   * @param buf The buffer to append to.
161   * @param off The offset to write the byte at.
162   * @param data The data to append.
163   * @return The original buffer, for chaining.
164   */
165   function writeUint8(buffer memory buf, uint off, uint8 data) internal pure returns(buffer memory) {
166     if (off >= buf.capacity) {
167       resize(buf, buf.capacity * 2);
168     }
169 
170     assembly {
171       // Memory address of the buffer data
172       let bufptr := mload(buf)
173       // Length of existing buffer data
174       let buflen := mload(bufptr)
175       // Address = buffer address + sizeof(buffer length) + off
176       let dest := add(add(bufptr, off), 32)
177       mstore8(dest, data)
178       // Update buffer length if we extended it
179       if eq(off, buflen) {
180         mstore(bufptr, add(buflen, 1))
181       }
182     }
183     return buf;
184   }
185 
186   /**
187   * @dev Appends a byte to the buffer. Resizes if doing so would exceed the
188   *      capacity of the buffer.
189   * @param buf The buffer to append to.
190   * @param data The data to append.
191   * @return The original buffer, for chaining.
192   */
193   function appendUint8(buffer memory buf, uint8 data) internal pure returns(buffer memory) {
194     return writeUint8(buf, buf.buf.length, data);
195   }
196 
197   /**
198   * @dev Writes up to 32 bytes to the buffer. Resizes if doing so would
199   *      exceed the capacity of the buffer.
200   * @param buf The buffer to append to.
201   * @param off The offset to write at.
202   * @param data The data to append.
203   * @param len The number of bytes to write (left-aligned).
204   * @return The original buffer, for chaining.
205   */
206   function write(buffer memory buf, uint off, bytes32 data, uint len) private pure returns(buffer memory) {
207     if (len + off > buf.capacity) {
208       resize(buf, (len + off) * 2);
209     }
210 
211     uint mask = 256 ** len - 1;
212     // Right-align data
213     data = data >> (8 * (32 - len));
214     assembly {
215       // Memory address of the buffer data
216       let bufptr := mload(buf)
217       // Address = buffer address + sizeof(buffer length) + off + len
218       let dest := add(add(bufptr, off), len)
219       mstore(dest, or(and(mload(dest), not(mask)), data))
220       // Update buffer length if we extended it
221       if gt(add(off, len), mload(bufptr)) {
222         mstore(bufptr, add(off, len))
223       }
224     }
225     return buf;
226   }
227 
228   /**
229   * @dev Writes a bytes20 to the buffer. Resizes if doing so would exceed the
230   *      capacity of the buffer.
231   * @param buf The buffer to append to.
232   * @param off The offset to write at.
233   * @param data The data to append.
234   * @return The original buffer, for chaining.
235   */
236   function writeBytes20(buffer memory buf, uint off, bytes20 data) internal pure returns (buffer memory) {
237     return write(buf, off, bytes32(data), 20);
238   }
239 
240   /**
241   * @dev Appends a bytes20 to the buffer. Resizes if doing so would exceed
242   *      the capacity of the buffer.
243   * @param buf The buffer to append to.
244   * @param data The data to append.
245   * @return The original buffer, for chhaining.
246   */
247   function appendBytes20(buffer memory buf, bytes20 data) internal pure returns (buffer memory) {
248     return write(buf, buf.buf.length, bytes32(data), 20);
249   }
250 
251   /**
252   * @dev Appends a bytes32 to the buffer. Resizes if doing so would exceed
253   *      the capacity of the buffer.
254   * @param buf The buffer to append to.
255   * @param data The data to append.
256   * @return The original buffer, for chaining.
257   */
258   function appendBytes32(buffer memory buf, bytes32 data) internal pure returns (buffer memory) {
259     return write(buf, buf.buf.length, data, 32);
260   }
261 
262   /**
263   * @dev Writes an integer to the buffer. Resizes if doing so would exceed
264   *      the capacity of the buffer.
265   * @param buf The buffer to append to.
266   * @param off The offset to write at.
267   * @param data The data to append.
268   * @param len The number of bytes to write (right-aligned).
269   * @return The original buffer, for chaining.
270   */
271   function writeInt(buffer memory buf, uint off, uint data, uint len) private pure returns(buffer memory) {
272     if (len + off > buf.capacity) {
273       resize(buf, (len + off) * 2);
274     }
275 
276     uint mask = 256 ** len - 1;
277     assembly {
278       // Memory address of the buffer data
279       let bufptr := mload(buf)
280       // Address = buffer address + off + sizeof(buffer length) + len
281       let dest := add(add(bufptr, off), len)
282       mstore(dest, or(and(mload(dest), not(mask)), data))
283       // Update buffer length if we extended it
284       if gt(add(off, len), mload(bufptr)) {
285         mstore(bufptr, add(off, len))
286       }
287     }
288     return buf;
289   }
290 
291   /**
292    * @dev Appends a byte to the end of the buffer. Resizes if doing so would
293    * exceed the capacity of the buffer.
294    * @param buf The buffer to append to.
295    * @param data The data to append.
296    * @return The original buffer.
297    */
298   function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
299     return writeInt(buf, buf.buf.length, data, len);
300   }
301 }
302 
303 library CBOR {
304   using Buffer for Buffer.buffer;
305 
306   uint8 private constant MAJOR_TYPE_INT = 0;
307   uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
308   uint8 private constant MAJOR_TYPE_BYTES = 2;
309   uint8 private constant MAJOR_TYPE_STRING = 3;
310   uint8 private constant MAJOR_TYPE_ARRAY = 4;
311   uint8 private constant MAJOR_TYPE_MAP = 5;
312   uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
313 
314   function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
315     if(value <= 23) {
316       buf.appendUint8(uint8((major << 5) | value));
317     } else if(value <= 0xFF) {
318       buf.appendUint8(uint8((major << 5) | 24));
319       buf.appendInt(value, 1);
320     } else if(value <= 0xFFFF) {
321       buf.appendUint8(uint8((major << 5) | 25));
322       buf.appendInt(value, 2);
323     } else if(value <= 0xFFFFFFFF) {
324       buf.appendUint8(uint8((major << 5) | 26));
325       buf.appendInt(value, 4);
326     } else if(value <= 0xFFFFFFFFFFFFFFFF) {
327       buf.appendUint8(uint8((major << 5) | 27));
328       buf.appendInt(value, 8);
329     }
330   }
331 
332   function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
333     buf.appendUint8(uint8((major << 5) | 31));
334   }
335 
336   function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
337     encodeType(buf, MAJOR_TYPE_INT, value);
338   }
339 
340   function encodeInt(Buffer.buffer memory buf, int value) internal pure {
341     if(value >= 0) {
342       encodeType(buf, MAJOR_TYPE_INT, uint(value));
343     } else {
344       encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
345     }
346   }
347 
348   function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
349     encodeType(buf, MAJOR_TYPE_BYTES, value.length);
350     buf.append(value);
351   }
352 
353   function encodeString(Buffer.buffer memory buf, string value) internal pure {
354     encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
355     buf.append(bytes(value));
356   }
357 
358   function startArray(Buffer.buffer memory buf) internal pure {
359     encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
360   }
361 
362   function startMap(Buffer.buffer memory buf) internal pure {
363     encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
364   }
365 
366   function endSequence(Buffer.buffer memory buf) internal pure {
367     encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
368   }
369 }
370 
371 /**
372  * @title Library for common Chainlink functions
373  * @dev Uses imported CBOR library for encoding to buffer
374  */
375 library Chainlink {
376   uint256 internal constant defaultBufferSize = 256; // solhint-disable-line const-name-snakecase
377 
378   using CBOR for Buffer.buffer;
379 
380   struct Request {
381     bytes32 id;
382     address callbackAddress;
383     bytes4 callbackFunctionId;
384     uint256 nonce;
385     Buffer.buffer buf;
386   }
387 
388   /**
389    * @notice Initializes a Chainlink request
390    * @dev Sets the ID, callback address, and callback function signature on the request
391    * @param self The uninitialized request
392    * @param _id The Job Specification ID
393    * @param _callbackAddress The callback address
394    * @param _callbackFunction The callback function signature
395    * @return The initialized request
396    */
397   function initialize(
398     Request memory self,
399     bytes32 _id,
400     address _callbackAddress,
401     bytes4 _callbackFunction
402   ) internal pure returns (Chainlink.Request memory) {
403     Buffer.init(self.buf, defaultBufferSize);
404     self.id = _id;
405     self.callbackAddress = _callbackAddress;
406     self.callbackFunctionId = _callbackFunction;
407     return self;
408   }
409 
410   /**
411    * @notice Sets the data for the buffer without encoding CBOR on-chain
412    * @dev CBOR can be closed with curly-brackets {} or they can be left off
413    * @param self The initialized request
414    * @param _data The CBOR data
415    */
416   function setBuffer(Request memory self, bytes _data)
417     internal pure
418   {
419     Buffer.init(self.buf, _data.length);
420     Buffer.append(self.buf, _data);
421   }
422 
423   /**
424    * @notice Adds a string value to the request with a given key name
425    * @param self The initialized request
426    * @param _key The name of the key
427    * @param _value The string value to add
428    */
429   function add(Request memory self, string _key, string _value)
430     internal pure
431   {
432     self.buf.encodeString(_key);
433     self.buf.encodeString(_value);
434   }
435 
436   /**
437    * @notice Adds a bytes value to the request with a given key name
438    * @param self The initialized request
439    * @param _key The name of the key
440    * @param _value The bytes value to add
441    */
442   function addBytes(Request memory self, string _key, bytes _value)
443     internal pure
444   {
445     self.buf.encodeString(_key);
446     self.buf.encodeBytes(_value);
447   }
448 
449   /**
450    * @notice Adds a int256 value to the request with a given key name
451    * @param self The initialized request
452    * @param _key The name of the key
453    * @param _value The int256 value to add
454    */
455   function addInt(Request memory self, string _key, int256 _value)
456     internal pure
457   {
458     self.buf.encodeString(_key);
459     self.buf.encodeInt(_value);
460   }
461 
462   /**
463    * @notice Adds a uint256 value to the request with a given key name
464    * @param self The initialized request
465    * @param _key The name of the key
466    * @param _value The uint256 value to add
467    */
468   function addUint(Request memory self, string _key, uint256 _value)
469     internal pure
470   {
471     self.buf.encodeString(_key);
472     self.buf.encodeUInt(_value);
473   }
474 
475   /**
476    * @notice Adds an array of strings to the request with a given key name
477    * @param self The initialized request
478    * @param _key The name of the key
479    * @param _values The array of string values to add
480    */
481   function addStringArray(Request memory self, string _key, string[] memory _values)
482     internal pure
483   {
484     self.buf.encodeString(_key);
485     self.buf.startArray();
486     for (uint256 i = 0; i < _values.length; i++) {
487       self.buf.encodeString(_values[i]);
488     }
489     self.buf.endSequence();
490   }
491 }
492 
493 interface ENSInterface {
494 
495   // Logged when the owner of a node assigns a new owner to a subnode.
496   event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
497 
498   // Logged when the owner of a node transfers ownership to a new account.
499   event Transfer(bytes32 indexed node, address owner);
500 
501   // Logged when the resolver for a node changes.
502   event NewResolver(bytes32 indexed node, address resolver);
503 
504   // Logged when the TTL of a node changes
505   event NewTTL(bytes32 indexed node, uint64 ttl);
506 
507 
508   function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
509   function setResolver(bytes32 node, address resolver) external;
510   function setOwner(bytes32 node, address owner) external;
511   function setTTL(bytes32 node, uint64 ttl) external;
512   function owner(bytes32 node) external view returns (address);
513   function resolver(bytes32 node) external view returns (address);
514   function ttl(bytes32 node) external view returns (uint64);
515 
516 }
517 
518 interface LinkTokenInterface {
519   function allowance(address owner, address spender) external returns (uint256 remaining);
520   function approve(address spender, uint256 value) external returns (bool success);
521   function balanceOf(address owner) external returns (uint256 balance);
522   function decimals() external returns (uint8 decimalPlaces);
523   function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
524   function increaseApproval(address spender, uint256 subtractedValue) external;
525   function name() external returns (string tokenName);
526   function symbol() external returns (string tokenSymbol);
527   function totalSupply() external returns (uint256 totalTokensIssued);
528   function transfer(address to, uint256 value) external returns (bool success);
529   function transferAndCall(address to, uint256 value, bytes data) external returns (bool success);
530   function transferFrom(address from, address to, uint256 value) external returns (bool success);
531 }
532 
533 interface ChainlinkRequestInterface {
534   function oracleRequest(
535     address sender,
536     uint256 payment,
537     bytes32 id,
538     address callbackAddress,
539     bytes4 callbackFunctionId,
540     uint256 nonce,
541     uint256 version,
542     bytes data
543   ) external;
544 
545   function cancelOracleRequest(
546     bytes32 requestId,
547     uint256 payment,
548     bytes4 callbackFunctionId,
549     uint256 expiration
550   ) external;
551 }
552 
553 interface PointerInterface {
554   function getAddress() external view returns (address);
555 }
556 
557 
558 contract ENSResolver {
559   function addr(bytes32 node) public view returns (address);
560 }
561 
562 
563 /**
564  * @title SafeMath
565  * @dev Math operations with safety checks that throw on error
566  */
567 library SafeMath {
568 
569   /**
570   * @dev Multiplies two numbers, throws on overflow.
571   */
572   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
573     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
574     // benefit is lost if 'b' is also tested.
575     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
576     if (_a == 0) {
577       return 0;
578     }
579 
580     c = _a * _b;
581     assert(c / _a == _b);
582     return c;
583   }
584 
585   /**
586   * @dev Integer division of two numbers, truncating the quotient.
587   */
588   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
589     // assert(_b > 0); // Solidity automatically throws when dividing by 0
590     // uint256 c = _a / _b;
591     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
592     return _a / _b;
593   }
594 
595   /**
596   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
597   */
598   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
599     assert(_b <= _a);
600     return _a - _b;
601   }
602 
603   /**
604   * @dev Adds two numbers, throws on overflow.
605   */
606   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
607     c = _a + _b;
608     assert(c >= _a);
609     return c;
610   }
611 }
612 
613 /**
614  * @title The ChainlinkClient contract
615  * @notice Contract writers can inherit this contract in order to create requests for the
616  * Chainlink network
617  */
618 contract ChainlinkClient {
619   using Chainlink for Chainlink.Request;
620   using SafeMath for uint256;
621 
622   uint256 constant internal LINK = 10**18;
623   uint256 constant private AMOUNT_OVERRIDE = 0;
624   address constant private SENDER_OVERRIDE = 0x0;
625   uint256 constant private ARGS_VERSION = 1;
626   bytes32 constant private ENS_TOKEN_SUBNAME = keccak256("link");
627   bytes32 constant private ENS_ORACLE_SUBNAME = keccak256("oracle");
628   address constant private LINK_TOKEN_POINTER = 0xC89bD4E1632D3A43CB03AAAd5262cbe4038Bc571;
629 
630   ENSInterface private ens;
631   bytes32 private ensNode;
632   LinkTokenInterface private link;
633   ChainlinkRequestInterface private oracle;
634   uint256 private requests = 1;
635   mapping(bytes32 => address) private pendingRequests;
636 
637   event ChainlinkRequested(bytes32 indexed id);
638   event ChainlinkFulfilled(bytes32 indexed id);
639   event ChainlinkCancelled(bytes32 indexed id);
640 
641   /**
642    * @notice Creates a request that can hold additional parameters
643    * @param _specId The Job Specification ID that the request will be created for
644    * @param _callbackAddress The callback address that the response will be sent to
645    * @param _callbackFunctionSignature The callback function signature to use for the callback address
646    * @return A Chainlink Request struct in memory
647    */
648   function buildChainlinkRequest(
649     bytes32 _specId,
650     address _callbackAddress,
651     bytes4 _callbackFunctionSignature
652   ) internal pure returns (Chainlink.Request memory) {
653     Chainlink.Request memory req;
654     return req.initialize(_specId, _callbackAddress, _callbackFunctionSignature);
655   }
656 
657   /**
658    * @notice Creates a Chainlink request to the stored oracle address
659    * @dev Calls `chainlinkRequestTo` with the stored oracle address
660    * @param _req The initialized Chainlink Request
661    * @param _payment The amount of LINK to send for the request
662    * @return The request ID
663    */
664   function sendChainlinkRequest(Chainlink.Request memory _req, uint256 _payment)
665     internal
666     returns (bytes32)
667   {
668     return sendChainlinkRequestTo(oracle, _req, _payment);
669   }
670 
671   /**
672    * @notice Creates a Chainlink request to the specified oracle address
673    * @dev Generates and stores a request ID, increments the local nonce, and uses `transferAndCall` to
674    * send LINK which creates a request on the target oracle contract.
675    * Emits ChainlinkRequested event.
676    * @param _oracle The address of the oracle for the request
677    * @param _req The initialized Chainlink Request
678    * @param _payment The amount of LINK to send for the request
679    * @return The request ID
680    */
681   function sendChainlinkRequestTo(address _oracle, Chainlink.Request memory _req, uint256 _payment)
682     internal
683     returns (bytes32 requestId)
684   {
685     requestId = keccak256(abi.encodePacked(this, requests));
686     _req.nonce = requests;
687     pendingRequests[requestId] = _oracle;
688     emit ChainlinkRequested(requestId);
689     require(link.transferAndCall(_oracle, _payment, encodeRequest(_req)), "unable to transferAndCall to oracle");
690     requests += 1;
691 
692     return requestId;
693   }
694 
695   /**
696    * @notice Allows a request to be cancelled if it has not been fulfilled
697    * @dev Requires keeping track of the expiration value emitted from the oracle contract.
698    * Deletes the request from the `pendingRequests` mapping.
699    * Emits ChainlinkCancelled event.
700    * @param _requestId The request ID
701    * @param _payment The amount of LINK sent for the request
702    * @param _callbackFunc The callback function specified for the request
703    * @param _expiration The time of the expiration for the request
704    */
705   function cancelChainlinkRequest(
706     bytes32 _requestId,
707     uint256 _payment,
708     bytes4 _callbackFunc,
709     uint256 _expiration
710   )
711     internal
712   {
713     ChainlinkRequestInterface requested = ChainlinkRequestInterface(pendingRequests[_requestId]);
714     delete pendingRequests[_requestId];
715     emit ChainlinkCancelled(_requestId);
716     requested.cancelOracleRequest(_requestId, _payment, _callbackFunc, _expiration);
717   }
718 
719   /**
720    * @notice Sets the stored oracle address
721    * @param _oracle The address of the oracle contract
722    */
723   function setChainlinkOracle(address _oracle) internal {
724     oracle = ChainlinkRequestInterface(_oracle);
725   }
726 
727   /**
728    * @notice Sets the LINK token address
729    * @param _link The address of the LINK token contract
730    */
731   function setChainlinkToken(address _link) internal {
732     link = LinkTokenInterface(_link);
733   }
734 
735   /**
736    * @notice Sets the Chainlink token address for the public
737    * network as given by the Pointer contract
738    */
739   function setPublicChainlinkToken() internal {
740     setChainlinkToken(PointerInterface(LINK_TOKEN_POINTER).getAddress());
741   }
742 
743   /**
744    * @notice Retrieves the stored address of the LINK token
745    * @return The address of the LINK token
746    */
747   function chainlinkTokenAddress()
748     internal
749     view
750     returns (address)
751   {
752     return address(link);
753   }
754 
755   /**
756    * @notice Retrieves the stored address of the oracle contract
757    * @return The address of the oracle contract
758    */
759   function chainlinkOracleAddress()
760     internal
761     view
762     returns (address)
763   {
764     return address(oracle);
765   }
766 
767   /**
768    * @notice Allows for a request which was created on another contract to be fulfilled
769    * on this contract
770    * @param _oracle The address of the oracle contract that will fulfill the request
771    * @param _requestId The request ID used for the response
772    */
773   function addChainlinkExternalRequest(address _oracle, bytes32 _requestId)
774     internal
775     notPendingRequest(_requestId)
776   {
777     pendingRequests[_requestId] = _oracle;
778   }
779 
780   /**
781    * @notice Sets the stored oracle and LINK token contracts with the addresses resolved by ENS
782    * @dev Accounts for subnodes having different resolvers
783    * @param _ens The address of the ENS contract
784    * @param _node The ENS node hash
785    */
786   function useChainlinkWithENS(address _ens, bytes32 _node)
787     internal
788   {
789     ens = ENSInterface(_ens);
790     ensNode = _node;
791     bytes32 linkSubnode = keccak256(abi.encodePacked(ensNode, ENS_TOKEN_SUBNAME));
792     ENSResolver resolver = ENSResolver(ens.resolver(linkSubnode));
793     setChainlinkToken(resolver.addr(linkSubnode));
794     updateChainlinkOracleWithENS();
795   }
796 
797   /**
798    * @notice Sets the stored oracle contract with the address resolved by ENS
799    * @dev This may be called on its own as long as `useChainlinkWithENS` has been called previously
800    */
801   function updateChainlinkOracleWithENS()
802     internal
803   {
804     bytes32 oracleSubnode = keccak256(abi.encodePacked(ensNode, ENS_ORACLE_SUBNAME));
805     ENSResolver resolver = ENSResolver(ens.resolver(oracleSubnode));
806     setChainlinkOracle(resolver.addr(oracleSubnode));
807   }
808 
809   /**
810    * @notice Encodes the request to be sent to the oracle contract
811    * @dev The Chainlink node expects values to be in order for the request to be picked up. Order of types
812    * will be validated in the oracle contract.
813    * @param _req The initialized Chainlink Request
814    * @return The bytes payload for the `transferAndCall` method
815    */
816   function encodeRequest(Chainlink.Request memory _req)
817     private
818     view
819     returns (bytes memory)
820   {
821     return abi.encodeWithSelector(
822       oracle.oracleRequest.selector,
823       SENDER_OVERRIDE, // Sender value - overridden by onTokenTransfer by the requesting contract's address
824       AMOUNT_OVERRIDE, // Amount value - overridden by onTokenTransfer by the actual amount of LINK sent
825       _req.id,
826       _req.callbackAddress,
827       _req.callbackFunctionId,
828       _req.nonce,
829       ARGS_VERSION,
830       _req.buf.buf);
831   }
832 
833   /**
834    * @notice Ensures that the fulfillment is valid for this contract
835    * @dev Use if the contract developer prefers methods instead of modifiers for validation
836    * @param _requestId The request ID for fulfillment
837    */
838   function validateChainlinkCallback(bytes32 _requestId)
839     internal
840     recordChainlinkFulfillment(_requestId)
841     // solhint-disable-next-line no-empty-blocks
842   {}
843 
844   /**
845    * @dev Reverts if the sender is not the oracle of the request.
846    * Emits ChainlinkFulfilled event.
847    * @param _requestId The request ID for fulfillment
848    */
849   modifier recordChainlinkFulfillment(bytes32 _requestId) {
850     require(msg.sender == pendingRequests[_requestId], "Source must be the oracle of the request");
851     delete pendingRequests[_requestId];
852     emit ChainlinkFulfilled(_requestId);
853     _;
854   }
855 
856   /**
857    * @dev Reverts if the request is already pending
858    * @param _requestId The request ID for fulfillment
859    */
860   modifier notPendingRequest(bytes32 _requestId) {
861     require(pendingRequests[_requestId] == address(0), "Request is already pending");
862     _;
863   }
864 }
865 
866 interface AggregatorInterface {
867   function latestAnswer() external view returns (int256);
868   function latestTimestamp() external view returns (uint256);
869   function latestRound() external view returns (uint256);
870   function getAnswer(uint256 roundId) external view returns (int256);
871   function getTimestamp(uint256 roundId) external view returns (uint256);
872 
873   event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 timestamp);
874   event NewRound(uint256 indexed roundId, address indexed startedBy);
875 }
876 
877 library SignedSafeMath {
878 
879   /**
880    * @dev Adds two int256s and makes sure the result doesn't overflow. Signed
881    * integers aren't supported by the SafeMath library, thus this method
882    * @param _a The first number to be added
883    * @param _a The second number to be added
884    */
885   function add(int256 _a, int256 _b)
886     internal
887     pure
888     returns (int256)
889   {
890     int256 c = _a + _b;
891     require((_b >= 0 && c >= _a) || (_b < 0 && c < _a), "SignedSafeMath: addition overflow");
892 
893     return c;
894   }
895 }
896 
897 /**
898  * @title Ownable
899  * @dev The Ownable contract has an owner address, and provides basic authorization control
900  * functions, this simplifies the implementation of "user permissions".
901  */
902 contract Ownable {
903   address public owner;
904 
905 
906   event OwnershipRenounced(address indexed previousOwner);
907   event OwnershipTransferred(
908     address indexed previousOwner,
909     address indexed newOwner
910   );
911 
912 
913   /**
914    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
915    * account.
916    */
917   constructor() public {
918     owner = msg.sender;
919   }
920 
921   /**
922    * @dev Throws if called by any account other than the owner.
923    */
924   modifier onlyOwner() {
925     require(msg.sender == owner);
926     _;
927   }
928 
929   /**
930    * @dev Allows the current owner to relinquish control of the contract.
931    * @notice Renouncing to ownership will leave the contract without an owner.
932    * It will not be possible to call the functions with the `onlyOwner`
933    * modifier anymore.
934    */
935   function renounceOwnership() public onlyOwner {
936     emit OwnershipRenounced(owner);
937     owner = address(0);
938   }
939 
940   /**
941    * @dev Allows the current owner to transfer control of the contract to a newOwner.
942    * @param _newOwner The address to transfer ownership to.
943    */
944   function transferOwnership(address _newOwner) public onlyOwner {
945     _transferOwnership(_newOwner);
946   }
947 
948   /**
949    * @dev Transfers control of the contract to a newOwner.
950    * @param _newOwner The address to transfer ownership to.
951    */
952   function _transferOwnership(address _newOwner) internal {
953     require(_newOwner != address(0));
954     emit OwnershipTransferred(owner, _newOwner);
955     owner = _newOwner;
956   }
957 }
958 
959 /**
960  * @title An example Chainlink contract with aggregation
961  * @notice Requesters can use this contract as a framework for creating
962  * requests to multiple Chainlink nodes and running aggregation
963  * as the contract receives answers.
964  */
965 contract Aggregator is AggregatorInterface, ChainlinkClient, Ownable {
966   using SignedSafeMath for int256;
967 
968   struct Answer {
969     uint128 minimumResponses;
970     uint128 maxResponses;
971     int256[] responses;
972   }
973 
974   event ResponseReceived(int256 indexed response, uint256 indexed answerId, address indexed sender);
975 
976   int256 private currentAnswerValue;
977   uint256 private updatedTimestampValue;
978   uint256 private latestCompletedAnswer;
979   uint128 public paymentAmount;
980   uint128 public minimumResponses;
981   bytes32[] public jobIds;
982   address[] public oracles;
983 
984   uint256 private answerCounter = 1;
985   mapping(address => bool) public authorizedRequesters;
986   mapping(bytes32 => uint256) private requestAnswers;
987   mapping(uint256 => Answer) private answers;
988   mapping(uint256 => int256) private currentAnswers;
989   mapping(uint256 => uint256) private updatedTimestamps;
990 
991   uint256 constant private MAX_ORACLE_COUNT = 45;
992 
993   /**
994    * @notice Deploy with the address of the LINK token and arrays of matching
995    * length containing the addresses of the oracles and their corresponding
996    * Job IDs.
997    * @dev Sets the LinkToken address for the network, addresses of the oracles,
998    * and jobIds in storage.
999    * @param _link The address of the LINK token
1000    * @param _paymentAmount the amount of LINK to be sent to each oracle for each request
1001    * @param _minimumResponses the minimum number of responses
1002    * before an answer will be calculated
1003    * @param _oracles An array of oracle addresses
1004    * @param _jobIds An array of Job IDs
1005    */
1006   constructor(
1007     address _link,
1008     uint128 _paymentAmount,
1009     uint128 _minimumResponses,
1010     address[] _oracles,
1011     bytes32[] _jobIds
1012   ) public Ownable() {
1013     setChainlinkToken(_link);
1014     updateRequestDetails(_paymentAmount, _minimumResponses, _oracles, _jobIds);
1015   }
1016 
1017   /**
1018    * @notice Creates a Chainlink request for each oracle in the oracles array.
1019    * @dev This example does not include request parameters. Reference any documentation
1020    * associated with the Job IDs used to determine the required parameters per-request.
1021    */
1022   function requestRateUpdate()
1023     external
1024     ensureAuthorizedRequester()
1025   {
1026     Chainlink.Request memory request;
1027     bytes32 requestId;
1028     uint256 oraclePayment = paymentAmount;
1029 
1030     for (uint i = 0; i < oracles.length; i++) {
1031       request = buildChainlinkRequest(jobIds[i], this, this.chainlinkCallback.selector);
1032       requestId = sendChainlinkRequestTo(oracles[i], request, oraclePayment);
1033       requestAnswers[requestId] = answerCounter;
1034     }
1035     answers[answerCounter].minimumResponses = minimumResponses;
1036     answers[answerCounter].maxResponses = uint128(oracles.length);
1037     answerCounter = answerCounter.add(1);
1038 
1039     emit NewRound(answerCounter, msg.sender);
1040   }
1041 
1042   /**
1043    * @notice Receives the answer from the Chainlink node.
1044    * @dev This function can only be called by the oracle that received the request.
1045    * @param _clRequestId The Chainlink request ID associated with the answer
1046    * @param _response The answer provided by the Chainlink node
1047    */
1048   function chainlinkCallback(bytes32 _clRequestId, int256 _response)
1049     external
1050   {
1051     validateChainlinkCallback(_clRequestId);
1052 
1053     uint256 answerId = requestAnswers[_clRequestId];
1054     delete requestAnswers[_clRequestId];
1055 
1056     answers[answerId].responses.push(_response);
1057     emit ResponseReceived(_response, answerId, msg.sender);
1058     updateLatestAnswer(answerId);
1059     deleteAnswer(answerId);
1060   }
1061 
1062   /**
1063    * @notice Updates the arrays of oracles and jobIds with new values,
1064    * overwriting the old values.
1065    * @dev Arrays are validated to be equal length.
1066    * @param _paymentAmount the amount of LINK to be sent to each oracle for each request
1067    * @param _minimumResponses the minimum number of responses
1068    * before an answer will be calculated
1069    * @param _oracles An array of oracle addresses
1070    * @param _jobIds An array of Job IDs
1071    */
1072   function updateRequestDetails(
1073     uint128 _paymentAmount,
1074     uint128 _minimumResponses,
1075     address[] _oracles,
1076     bytes32[] _jobIds
1077   )
1078     public
1079     onlyOwner()
1080     validateAnswerRequirements(_minimumResponses, _oracles, _jobIds)
1081   {
1082     paymentAmount = _paymentAmount;
1083     minimumResponses = _minimumResponses;
1084     jobIds = _jobIds;
1085     oracles = _oracles;
1086   }
1087 
1088   /**
1089    * @notice Allows the owner of the contract to withdraw any LINK balance
1090    * available on the contract.
1091    * @dev The contract will need to have a LINK balance in order to create requests.
1092    * @param _recipient The address to receive the LINK tokens
1093    * @param _amount The amount of LINK to send from the contract
1094    */
1095   function transferLINK(address _recipient, uint256 _amount)
1096     public
1097     onlyOwner()
1098   {
1099     LinkTokenInterface linkToken = LinkTokenInterface(chainlinkTokenAddress());
1100     require(linkToken.transfer(_recipient, _amount), "LINK transfer failed");
1101   }
1102 
1103   /**
1104    * @notice Called by the owner to permission other addresses to generate new
1105    * requests to oracles.
1106    * @param _requester the address whose permissions are being set
1107    * @param _allowed boolean that determines whether the requester is
1108    * permissioned or not
1109    */
1110   function setAuthorization(address _requester, bool _allowed)
1111     external
1112     onlyOwner()
1113   {
1114     authorizedRequesters[_requester] = _allowed;
1115   }
1116 
1117   /**
1118    * @notice Cancels an outstanding Chainlink request.
1119    * The oracle contract requires the request ID and additional metadata to
1120    * validate the cancellation. Only old answers can be cancelled.
1121    * @param _requestId is the identifier for the chainlink request being cancelled
1122    * @param _payment is the amount of LINK paid to the oracle for the request
1123    * @param _expiration is the time when the request expires
1124    */
1125   function cancelRequest(
1126     bytes32 _requestId,
1127     uint256 _payment,
1128     uint256 _expiration
1129   )
1130     external
1131     ensureAuthorizedRequester()
1132   {
1133     uint256 answerId = requestAnswers[_requestId];
1134     require(answerId < latestCompletedAnswer, "Cannot modify an in-progress answer");
1135 
1136     delete requestAnswers[_requestId];
1137     answers[answerId].responses.push(0);
1138     deleteAnswer(answerId);
1139 
1140     cancelChainlinkRequest(
1141       _requestId,
1142       _payment,
1143       this.chainlinkCallback.selector,
1144       _expiration
1145     );
1146   }
1147 
1148   /**
1149    * @notice Called by the owner to kill the contract. This transfers all LINK
1150    * balance and ETH balance (if there is any) to the owner.
1151    */
1152   function destroy()
1153     external
1154     onlyOwner()
1155   {
1156     LinkTokenInterface linkToken = LinkTokenInterface(chainlinkTokenAddress());
1157     transferLINK(owner, linkToken.balanceOf(address(this)));
1158     selfdestruct(owner);
1159   }
1160 
1161   /**
1162    * @dev Performs aggregation of the answers received from the Chainlink nodes.
1163    * Assumes that at least half the oracles are honest and so can't contol the
1164    * middle of the ordered responses.
1165    * @param _answerId The answer ID associated with the group of requests
1166    */
1167   function updateLatestAnswer(uint256 _answerId)
1168     private
1169     ensureMinResponsesReceived(_answerId)
1170     ensureOnlyLatestAnswer(_answerId)
1171   {
1172     uint256 responseLength = answers[_answerId].responses.length;
1173     uint256 middleIndex = responseLength.div(2);
1174     int256 currentAnswerTemp;
1175     if (responseLength % 2 == 0) {
1176       int256 median1 = quickselect(answers[_answerId].responses, middleIndex);
1177       int256 median2 = quickselect(answers[_answerId].responses, middleIndex.add(1)); // quickselect is 1 indexed
1178       currentAnswerTemp = median1.add(median2) / 2; // signed integers are not supported by SafeMath
1179     } else {
1180       currentAnswerTemp = quickselect(answers[_answerId].responses, middleIndex.add(1)); // quickselect is 1 indexed
1181     }
1182     currentAnswerValue = currentAnswerTemp;
1183     latestCompletedAnswer = _answerId;
1184     updatedTimestampValue = now;
1185     updatedTimestamps[_answerId] = now;
1186     currentAnswers[_answerId] = currentAnswerTemp;
1187     emit AnswerUpdated(currentAnswerTemp, _answerId, now);
1188   }
1189 
1190   /**
1191    * @notice get the most recently reported answer
1192    */
1193   function latestAnswer()
1194     external
1195     view
1196     returns (int256)
1197   {
1198     return currentAnswers[latestCompletedAnswer];
1199   }
1200 
1201   /**
1202    * @notice get the last updated at block timestamp
1203    */
1204   function latestTimestamp()
1205     external
1206     view
1207     returns (uint256)
1208   {
1209     return updatedTimestamps[latestCompletedAnswer];
1210   }
1211 
1212   /**
1213    * @notice get past rounds answers
1214    * @param _roundId the answer number to retrieve the answer for
1215    */
1216   function getAnswer(uint256 _roundId)
1217     external
1218     view
1219     returns (int256)
1220   {
1221     return currentAnswers[_roundId];
1222   }
1223 
1224   /**
1225    * @notice get block timestamp when an answer was last updated
1226    * @param _roundId the answer number to retrieve the updated timestamp for
1227    */
1228   function getTimestamp(uint256 _roundId)
1229     external
1230     view
1231     returns (uint256)
1232   {
1233     return updatedTimestamps[_roundId];
1234   }
1235 
1236   /**
1237    * @notice get the latest completed round where the answer was updated
1238    */
1239   function latestRound() external view returns (uint256) {
1240     return latestCompletedAnswer;
1241   }
1242 
1243   /**
1244    * @dev Returns the kth value of the ordered array
1245    * See: http://www.cs.yale.edu/homes/aspnes/pinewiki/QuickSelect.html
1246    * @param _a The list of elements to pull from
1247    * @param _k The index, 1 based, of the elements you want to pull from when ordered
1248    */
1249   function quickselect(int256[] memory _a, uint256 _k)
1250     private
1251     pure
1252     returns (int256)
1253   {
1254     int256[] memory a = _a;
1255     uint256 k = _k;
1256     uint256 aLen = a.length;
1257     int256[] memory a1 = new int256[](aLen);
1258     int256[] memory a2 = new int256[](aLen);
1259     uint256 a1Len;
1260     uint256 a2Len;
1261     int256 pivot;
1262     uint256 i;
1263 
1264     while (true) {
1265       pivot = a[aLen.div(2)];
1266       a1Len = 0;
1267       a2Len = 0;
1268       for (i = 0; i < aLen; i++) {
1269         if (a[i] < pivot) {
1270           a1[a1Len] = a[i];
1271           a1Len++;
1272         } else if (a[i] > pivot) {
1273           a2[a2Len] = a[i];
1274           a2Len++;
1275         }
1276       }
1277       if (k <= a1Len) {
1278         aLen = a1Len;
1279         (a, a1) = swap(a, a1);
1280       } else if (k > (aLen.sub(a2Len))) {
1281         k = k.sub(aLen.sub(a2Len));
1282         aLen = a2Len;
1283         (a, a2) = swap(a, a2);
1284       } else {
1285         return pivot;
1286       }
1287     }
1288   }
1289 
1290   /**
1291    * @dev Swaps the pointers to two uint256 arrays in memory
1292    * @param _a The pointer to the first in memory array
1293    * @param _b The pointer to the second in memory array
1294    */
1295   function swap(int256[] memory _a, int256[] memory _b)
1296     private
1297     pure
1298     returns(int256[] memory, int256[] memory)
1299   {
1300     return (_b, _a);
1301   }
1302 
1303   /**
1304    * @dev Cleans up the answer record if all responses have been received.
1305    * @param _answerId The identifier of the answer to be deleted
1306    */
1307   function deleteAnswer(uint256 _answerId)
1308     private
1309     ensureAllResponsesReceived(_answerId)
1310   {
1311     delete answers[_answerId];
1312   }
1313 
1314   /**
1315    * @dev Prevents taking an action if the minimum number of responses has not
1316    * been received for an answer.
1317    * @param _answerId The the identifier of the answer that keeps track of the responses.
1318    */
1319   modifier ensureMinResponsesReceived(uint256 _answerId) {
1320     if (answers[_answerId].responses.length >= answers[_answerId].minimumResponses) {
1321       _;
1322     }
1323   }
1324 
1325   /**
1326    * @dev Prevents taking an action if not all responses are received for an answer.
1327    * @param _answerId The the identifier of the answer that keeps track of the responses.
1328    */
1329   modifier ensureAllResponsesReceived(uint256 _answerId) {
1330     if (answers[_answerId].responses.length == answers[_answerId].maxResponses) {
1331       _;
1332     }
1333   }
1334 
1335   /**
1336    * @dev Prevents taking an action if a newer answer has been recorded.
1337    * @param _answerId The current answer's identifier.
1338    * Answer IDs are in ascending order.
1339    */
1340   modifier ensureOnlyLatestAnswer(uint256 _answerId) {
1341     if (latestCompletedAnswer <= _answerId) {
1342       _;
1343     }
1344   }
1345 
1346   /**
1347    * @dev Ensures corresponding number of oracles and jobs.
1348    * @param _oracles The list of oracles.
1349    * @param _jobIds The list of jobs.
1350    */
1351   modifier validateAnswerRequirements(
1352     uint256 _minimumResponses,
1353     address[] _oracles,
1354     bytes32[] _jobIds
1355   ) {
1356     require(_oracles.length <= MAX_ORACLE_COUNT, "cannot have more than 45 oracles");
1357     require(_oracles.length >= _minimumResponses, "must have at least as many oracles as responses");
1358     require(_oracles.length == _jobIds.length, "must have exactly as many oracles as job IDs");
1359     _;
1360   }
1361 
1362   /**
1363    * @dev Reverts if `msg.sender` is not authorized to make requests.
1364    */
1365   modifier ensureAuthorizedRequester() {
1366     require(authorizedRequesters[msg.sender] || msg.sender == owner, "Not an authorized address for creating requests");
1367     _;
1368   }
1369 
1370 }