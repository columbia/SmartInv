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
34     assembly {let ptr := mload(0x40)
35       mstore(buf, ptr)
36       mstore(ptr, 0)
37       mstore(0x40, add(32, add(ptr, capacity)))
38     }
39     return buf;
40   }
41 
42   /**
43   * @dev Initializes a new buffer from an existing bytes object.
44   *      Changes to the buffer may mutate the original value.
45   * @param b The bytes object to initialize the buffer with.
46   * @return A new buffer.
47   */
48   function fromBytes(bytes memory b) internal pure returns(buffer memory) {
49     buffer memory buf;
50     buf.buf = b;
51     buf.capacity = b.length;
52     return buf;
53   }
54 
55   function resize(buffer memory buf, uint capacity) private pure {
56     bytes memory oldbuf = buf.buf;
57     init(buf, capacity);
58     append(buf, oldbuf);
59   }
60 
61   function max(uint a, uint b) private pure returns(uint) {
62     if (a > b) {
63       return a;
64     }
65     return b;
66   }
67 
68   /**
69   * @dev Sets buffer length to 0.
70   * @param buf The buffer to truncate.
71   * @return The original buffer, for chaining..
72   */
73   function truncate(buffer memory buf) internal pure returns (buffer memory) {
74     assembly {
75       let bufptr := mload(buf)
76       mstore(bufptr, 0)
77     }
78     return buf;
79   }
80 
81   /**
82   * @dev Writes a byte string to a buffer. Resizes if doing so would exceed
83   *      the capacity of the buffer.
84   * @param buf The buffer to append to.
85   * @param off The start offset to write to.
86   * @param data The data to append.
87   * @param len The number of bytes to copy.
88   * @return The original buffer, for chaining.
89   */
90   function write(buffer memory buf, uint off, bytes memory data, uint len) internal pure returns(buffer memory) {
91     require(len <= data.length);
92 
93     if (off + len > buf.capacity) {
94       resize(buf, max(buf.capacity, len + off) * 2);
95     }
96 
97     uint dest;
98     uint src;
99     assembly {
100       // Memory address of the buffer data
101       let bufptr := mload(buf)
102       // Length of existing buffer data
103       let buflen := mload(bufptr)
104       // Start address = buffer address + offset + sizeof(buffer length)
105       dest := add(add(bufptr, 32), off)
106       // Update buffer length if we're extending it
107       if gt(add(len, off), buflen) {
108         mstore(bufptr, add(len, off))
109       }
110       src := add(data, 32)
111     }
112 
113     // Copy word-length chunks while possible
114     for (; len >= 32; len -= 32) {
115       assembly {
116         mstore(dest, mload(src))
117       }
118       dest += 32;
119       src += 32;
120     }
121 
122     // Copy remaining bytes
123     uint mask = 256 ** (32 - len) - 1;
124     assembly {
125       let srcpart := and(mload(src), not(mask))
126       let destpart := and(mload(dest), mask)
127       mstore(dest, or(destpart, srcpart))
128     }
129 
130     return buf;
131   }
132 
133   /**
134   * @dev Appends a byte string to a buffer. Resizes if doing so would exceed
135   *      the capacity of the buffer.
136   * @param buf The buffer to append to.
137   * @param data The data to append.
138   * @param len The number of bytes to copy.
139   * @return The original buffer, for chaining.
140   */
141   function append(buffer memory buf, bytes memory data, uint len) internal pure returns (buffer memory) {
142     return write(buf, buf.buf.length, data, len);
143   }
144 
145   /**
146   * @dev Appends a byte string to a buffer. Resizes if doing so would exceed
147   *      the capacity of the buffer.
148   * @param buf The buffer to append to.
149   * @param data The data to append.
150   * @return The original buffer, for chaining.
151   */
152   function append(buffer memory buf, bytes memory data) internal pure returns (buffer memory) {
153     return write(buf, buf.buf.length, data, data.length);
154   }
155 
156   /**
157   * @dev Writes a byte to the buffer. Resizes if doing so would exceed the
158   *      capacity of the buffer.
159   * @param buf The buffer to append to.
160   * @param off The offset to write the byte at.
161   * @param data The data to append.
162   * @return The original buffer, for chaining.
163   */
164   function writeUint8(buffer memory buf, uint off, uint8 data) internal pure returns(buffer memory) {
165     if (off >= buf.capacity) {
166       resize(buf, buf.capacity * 2);
167     }
168 
169     assembly {
170       // Memory address of the buffer data
171       let bufptr := mload(buf)
172       // Length of existing buffer data
173       let buflen := mload(bufptr)
174       // Address = buffer address + sizeof(buffer length) + off
175       let dest := add(add(bufptr, off), 32)
176       mstore8(dest, data)
177       // Update buffer length if we extended it
178       if eq(off, buflen) {
179         mstore(bufptr, add(buflen, 1))
180       }
181     }
182     return buf;
183   }
184 
185   /**
186   * @dev Appends a byte to the buffer. Resizes if doing so would exceed the
187   *      capacity of the buffer.
188   * @param buf The buffer to append to.
189   * @param data The data to append.
190   * @return The original buffer, for chaining.
191   */
192   function appendUint8(buffer memory buf, uint8 data) internal pure returns(buffer memory) {
193     return writeUint8(buf, buf.buf.length, data);
194   }
195 
196   /**
197   * @dev Writes up to 32 bytes to the buffer. Resizes if doing so would
198   *      exceed the capacity of the buffer.
199   * @param buf The buffer to append to.
200   * @param off The offset to write at.
201   * @param data The data to append.
202   * @param len The number of bytes to write (left-aligned).
203   * @return The original buffer, for chaining.
204   */
205   function write(buffer memory buf, uint off, bytes32 data, uint len) private pure returns(buffer memory) {
206     if (len + off > buf.capacity) {
207       resize(buf, (len + off) * 2);
208     }
209 
210     uint mask = 256 ** len - 1;
211     // Right-align data
212     data = data >> (8 * (32 - len));
213     assembly {
214       // Memory address of the buffer data
215       let bufptr := mload(buf)
216       // Address = buffer address + sizeof(buffer length) + off + len
217       let dest := add(add(bufptr, off), len)
218       mstore(dest, or(and(mload(dest), not(mask)), data))
219       // Update buffer length if we extended it
220       if gt(add(off, len), mload(bufptr)) {
221         mstore(bufptr, add(off, len))
222       }
223     }
224     return buf;
225   }
226 
227   /**
228   * @dev Writes a bytes20 to the buffer. Resizes if doing so would exceed the
229   *      capacity of the buffer.
230   * @param buf The buffer to append to.
231   * @param off The offset to write at.
232   * @param data The data to append.
233   * @return The original buffer, for chaining.
234   */
235   function writeBytes20(buffer memory buf, uint off, bytes20 data) internal pure returns (buffer memory) {
236     return write(buf, off, bytes32(data), 20);
237   }
238 
239   /**
240   * @dev Appends a bytes20 to the buffer. Resizes if doing so would exceed
241   *      the capacity of the buffer.
242   * @param buf The buffer to append to.
243   * @param data The data to append.
244   * @return The original buffer, for chhaining.
245   */
246   function appendBytes20(buffer memory buf, bytes20 data) internal pure returns (buffer memory) {
247     return write(buf, buf.buf.length, bytes32(data), 20);
248   }
249 
250   /**
251   * @dev Appends a bytes32 to the buffer. Resizes if doing so would exceed
252   *      the capacity of the buffer.
253   * @param buf The buffer to append to.
254   * @param data The data to append.
255   * @return The original buffer, for chaining.
256   */
257   function appendBytes32(buffer memory buf, bytes32 data) internal pure returns (buffer memory) {
258     return write(buf, buf.buf.length, data, 32);
259   }
260 
261   /**
262   * @dev Writes an integer to the buffer. Resizes if doing so would exceed
263   *      the capacity of the buffer.
264   * @param buf The buffer to append to.
265   * @param off The offset to write at.
266   * @param data The data to append.
267   * @param len The number of bytes to write (right-aligned).
268   * @return The original buffer, for chaining.
269   */
270   function writeInt(buffer memory buf, uint off, uint data, uint len) private pure returns(buffer memory) {
271     if (len + off > buf.capacity) {
272       resize(buf, (len + off) * 2);
273     }
274 
275     uint mask = 256 ** len - 1;
276     assembly {
277       // Memory address of the buffer data
278       let bufptr := mload(buf)
279       // Address = buffer address + off + sizeof(buffer length) + len
280       let dest := add(add(bufptr, off), len)
281       mstore(dest, or(and(mload(dest), not(mask)), data))
282       // Update buffer length if we extended it
283       if gt(add(off, len), mload(bufptr)) {
284         mstore(bufptr, add(off, len))
285       }
286     }
287     return buf;
288   }
289 
290   /**
291    * @dev Appends a byte to the end of the buffer. Resizes if doing so would
292    * exceed the capacity of the buffer.
293    * @param buf The buffer to append to.
294    * @param data The data to append.
295    * @return The original buffer.
296    */
297   function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
298     return writeInt(buf, buf.buf.length, data, len);
299   }
300 }
301 
302 library CBOR {
303   using Buffer for Buffer.buffer;
304 
305   uint8 private constant MAJOR_TYPE_INT = 0;
306   uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
307   uint8 private constant MAJOR_TYPE_BYTES = 2;
308   uint8 private constant MAJOR_TYPE_STRING = 3;
309   uint8 private constant MAJOR_TYPE_ARRAY = 4;
310   uint8 private constant MAJOR_TYPE_MAP = 5;
311   uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
312 
313   function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
314     if(value <= 23) {
315       buf.appendUint8(uint8((major << 5) | value));
316     } else if(value <= 0xFF) {
317       buf.appendUint8(uint8((major << 5) | 24));
318       buf.appendInt(value, 1);
319     } else if(value <= 0xFFFF) {
320       buf.appendUint8(uint8((major << 5) | 25));
321       buf.appendInt(value, 2);
322     } else if(value <= 0xFFFFFFFF) {
323       buf.appendUint8(uint8((major << 5) | 26));
324       buf.appendInt(value, 4);
325     } else if(value <= 0xFFFFFFFFFFFFFFFF) {
326       buf.appendUint8(uint8((major << 5) | 27));
327       buf.appendInt(value, 8);
328     }
329   }
330 
331   function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
332     buf.appendUint8(uint8((major << 5) | 31));
333   }
334 
335   function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
336     encodeType(buf, MAJOR_TYPE_INT, value);
337   }
338 
339   function encodeInt(Buffer.buffer memory buf, int value) internal pure {
340     if(value >= 0) {
341       encodeType(buf, MAJOR_TYPE_INT, uint(value));
342     } else {
343       encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
344     }
345   }
346 
347   function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
348     encodeType(buf, MAJOR_TYPE_BYTES, value.length);
349     buf.append(value);
350   }
351 
352   function encodeString(Buffer.buffer memory buf, string value) internal pure {
353     encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
354     buf.append(bytes(value));
355   }
356 
357   function startArray(Buffer.buffer memory buf) internal pure {
358     encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
359   }
360 
361   function startMap(Buffer.buffer memory buf) internal pure {
362     encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
363   }
364 
365   function endSequence(Buffer.buffer memory buf) internal pure {
366     encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
367   }
368 }
369 
370 /**
371  * @title Library for common Chainlink functions
372  * @dev Uses imported CBOR library for encoding to buffer
373  */
374 library Chainlink {
375   uint256 internal constant defaultBufferSize = 256; // solhint-disable-line const-name-snakecase
376 
377   using CBOR for Buffer.buffer;
378 
379   struct Request {
380     bytes32 id;
381     address callbackAddress;
382     bytes4 callbackFunctionId;
383     uint256 nonce;
384     Buffer.buffer buf;
385   }
386 
387   /**
388    * @notice Initializes a Chainlink request
389    * @dev Sets the ID, callback address, and callback function signature on the request
390    * @param self The uninitialized request
391    * @param _id The Job Specification ID
392    * @param _callbackAddress The callback address
393    * @param _callbackFunction The callback function signature
394    * @return The initialized request
395    */
396   function initialize(
397     Request memory self,
398     bytes32 _id,
399     address _callbackAddress,
400     bytes4 _callbackFunction
401   ) internal pure returns (Chainlink.Request memory) {
402     Buffer.init(self.buf, defaultBufferSize);
403     self.id = _id;
404     self.callbackAddress = _callbackAddress;
405     self.callbackFunctionId = _callbackFunction;
406     return self;
407   }
408 
409   /**
410    * @notice Sets the data for the buffer without encoding CBOR on-chain
411    * @dev CBOR can be closed with curly-brackets {} or they can be left off
412    * @param self The initialized request
413    * @param _data The CBOR data
414    */
415   function setBuffer(Request memory self, bytes _data)
416     internal pure
417   {
418     Buffer.init(self.buf, _data.length);
419     Buffer.append(self.buf, _data);
420   }
421 
422   /**
423    * @notice Adds a string value to the request with a given key name
424    * @param self The initialized request
425    * @param _key The name of the key
426    * @param _value The string value to add
427    */
428   function add(Request memory self, string _key, string _value)
429     internal pure
430   {
431     self.buf.encodeString(_key);
432     self.buf.encodeString(_value);
433   }
434 
435   /**
436    * @notice Adds a bytes value to the request with a given key name
437    * @param self The initialized request
438    * @param _key The name of the key
439    * @param _value The bytes value to add
440    */
441   function addBytes(Request memory self, string _key, bytes _value)
442     internal pure
443   {
444     self.buf.encodeString(_key);
445     self.buf.encodeBytes(_value);
446   }
447 
448   /**
449    * @notice Adds a int256 value to the request with a given key name
450    * @param self The initialized request
451    * @param _key The name of the key
452    * @param _value The int256 value to add
453    */
454   function addInt(Request memory self, string _key, int256 _value)
455     internal pure
456   {
457     self.buf.encodeString(_key);
458     self.buf.encodeInt(_value);
459   }
460 
461   /**
462    * @notice Adds a uint256 value to the request with a given key name
463    * @param self The initialized request
464    * @param _key The name of the key
465    * @param _value The uint256 value to add
466    */
467   function addUint(Request memory self, string _key, uint256 _value)
468     internal pure
469   {
470     self.buf.encodeString(_key);
471     self.buf.encodeUInt(_value);
472   }
473 
474   /**
475    * @notice Adds an array of strings to the request with a given key name
476    * @param self The initialized request
477    * @param _key The name of the key
478    * @param _values The array of string values to add
479    */
480   function addStringArray(Request memory self, string _key, string[] memory _values)
481     internal pure
482   {
483     self.buf.encodeString(_key);
484     self.buf.startArray();
485     for (uint256 i = 0; i < _values.length; i++) {
486       self.buf.encodeString(_values[i]);
487     }
488     self.buf.endSequence();
489   }
490 }
491 
492 interface ENSInterface {
493 
494   // Logged when the owner of a node assigns a new owner to a subnode.
495   event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
496 
497   // Logged when the owner of a node transfers ownership to a new account.
498   event Transfer(bytes32 indexed node, address owner);
499 
500   // Logged when the resolver for a node changes.
501   event NewResolver(bytes32 indexed node, address resolver);
502 
503   // Logged when the TTL of a node changes
504   event NewTTL(bytes32 indexed node, uint64 ttl);
505 
506 
507   function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
508   function setResolver(bytes32 node, address resolver) external;
509   function setOwner(bytes32 node, address owner) external;
510   function setTTL(bytes32 node, uint64 ttl) external;
511   function owner(bytes32 node) external view returns (address);
512   function resolver(bytes32 node) external view returns (address);
513   function ttl(bytes32 node) external view returns (uint64);
514 
515 }
516 
517 interface LinkTokenInterface {
518   function allowance(address owner, address spender) external returns (uint256 remaining);
519   function approve(address spender, uint256 value) external returns (bool success);
520   function balanceOf(address owner) external returns (uint256 balance);
521   function decimals() external returns (uint8 decimalPlaces);
522   function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
523   function increaseApproval(address spender, uint256 subtractedValue) external;
524   function name() external returns (string tokenName);
525   function symbol() external returns (string tokenSymbol);
526   function totalSupply() external returns (uint256 totalTokensIssued);
527   function transfer(address to, uint256 value) external returns (bool success);
528   function transferAndCall(address to, uint256 value, bytes data) external returns (bool success);
529   function transferFrom(address from, address to, uint256 value) external returns (bool success);
530 }
531 
532 interface ChainlinkRequestInterface {
533   function oracleRequest(
534     address sender,
535     uint256 payment,
536     bytes32 id,
537     address callbackAddress,
538     bytes4 callbackFunctionId,
539     uint256 nonce,
540     uint256 version,
541     bytes data
542   ) external;
543 
544   function cancelOracleRequest(
545     bytes32 requestId,
546     uint256 payment,
547     bytes4 callbackFunctionId,
548     uint256 expiration
549   ) external;
550 }
551 
552 interface PointerInterface {
553   function getAddress() external view returns (address);
554 }
555 
556 
557 contract ENSResolver {
558   function addr(bytes32 node) public view returns (address);
559 }
560 
561 
562 /**
563  * @title SafeMath
564  * @dev Math operations with safety checks that throw on error
565  */
566 library SafeMath {
567 
568   /**
569   * @dev Multiplies two numbers, throws on overflow.
570   */
571   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
572     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
573     // benefit is lost if 'b' is also tested.
574     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
575     if (_a == 0) {
576       return 0;
577     }
578 
579     c = _a * _b;
580     assert(c / _a == _b);
581     return c;
582   }
583 
584   /**
585   * @dev Integer division of two numbers, truncating the quotient.
586   */
587   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
588     // assert(_b > 0); // Solidity automatically throws when dividing by 0
589     // uint256 c = _a / _b;
590     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
591     return _a / _b;
592   }
593 
594   /**
595   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
596   */
597   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
598     assert(_b <= _a);
599     return _a - _b;
600   }
601 
602   /**
603   * @dev Adds two numbers, throws on overflow.
604   */
605   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
606     c = _a + _b;
607     assert(c >= _a);
608     return c;
609   }
610 }
611 
612 /**
613  * @title The ChainlinkClient contract
614  * @notice Contract writers can inherit this contract in order to create requests for the
615  * Chainlink network
616  */
617 contract ChainlinkClient {
618   using Chainlink for Chainlink.Request;
619   using SafeMath for uint256;
620 
621   uint256 constant internal LINK = 10**18;
622   uint256 constant private AMOUNT_OVERRIDE = 0;
623   address constant private SENDER_OVERRIDE = 0x0;
624   uint256 constant private ARGS_VERSION = 1;
625   bytes32 constant private ENS_TOKEN_SUBNAME = keccak256("link");
626   bytes32 constant private ENS_ORACLE_SUBNAME = keccak256("oracle");
627   address constant private LINK_TOKEN_POINTER = 0xC89bD4E1632D3A43CB03AAAd5262cbe4038Bc571;
628 
629   ENSInterface private ens;
630   bytes32 private ensNode;
631   LinkTokenInterface private link;
632   ChainlinkRequestInterface private oracle;
633   uint256 private requests = 1;
634   mapping(bytes32 => address) private pendingRequests;
635 
636   event ChainlinkRequested(bytes32 indexed id);
637   event ChainlinkFulfilled(bytes32 indexed id);
638   event ChainlinkCancelled(bytes32 indexed id);
639 
640   /**
641    * @notice Creates a request that can hold additional parameters
642    * @param _specId The Job Specification ID that the request will be created for
643    * @param _callbackAddress The callback address that the response will be sent to
644    * @param _callbackFunctionSignature The callback function signature to use for the callback address
645    * @return A Chainlink Request struct in memory
646    */
647   function buildChainlinkRequest(
648     bytes32 _specId,
649     address _callbackAddress,
650     bytes4 _callbackFunctionSignature
651   ) internal pure returns (Chainlink.Request memory) {
652     Chainlink.Request memory req;
653     return req.initialize(_specId, _callbackAddress, _callbackFunctionSignature);
654   }
655 
656   /**
657    * @notice Creates a Chainlink request to the stored oracle address
658    * @dev Calls `chainlinkRequestTo` with the stored oracle address
659    * @param _req The initialized Chainlink Request
660    * @param _payment The amount of LINK to send for the request
661    * @return The request ID
662    */
663   function sendChainlinkRequest(Chainlink.Request memory _req, uint256 _payment)
664     internal
665     returns (bytes32)
666   {
667     return sendChainlinkRequestTo(oracle, _req, _payment);
668   }
669 
670   /**
671    * @notice Creates a Chainlink request to the specified oracle address
672    * @dev Generates and stores a request ID, increments the local nonce, and uses `transferAndCall` to
673    * send LINK which creates a request on the target oracle contract.
674    * Emits ChainlinkRequested event.
675    * @param _oracle The address of the oracle for the request
676    * @param _req The initialized Chainlink Request
677    * @param _payment The amount of LINK to send for the request
678    * @return The request ID
679    */
680   function sendChainlinkRequestTo(address _oracle, Chainlink.Request memory _req, uint256 _payment)
681     internal
682     returns (bytes32 requestId)
683   {
684     requestId = keccak256(abi.encodePacked(this, requests));
685     _req.nonce = requests;
686     pendingRequests[requestId] = _oracle;
687     emit ChainlinkRequested(requestId);
688     require(link.transferAndCall(_oracle, _payment, encodeRequest(_req)), "unable to transferAndCall to oracle");
689     requests += 1;
690 
691     return requestId;
692   }
693 
694   /**
695    * @notice Allows a request to be cancelled if it has not been fulfilled
696    * @dev Requires keeping track of the expiration value emitted from the oracle contract.
697    * Deletes the request from the `pendingRequests` mapping.
698    * Emits ChainlinkCancelled event.
699    * @param _requestId The request ID
700    * @param _payment The amount of LINK sent for the request
701    * @param _callbackFunc The callback function specified for the request
702    * @param _expiration The time of the expiration for the request
703    */
704   function cancelChainlinkRequest(
705     bytes32 _requestId,
706     uint256 _payment,
707     bytes4 _callbackFunc,
708     uint256 _expiration
709   )
710     internal
711   {
712     ChainlinkRequestInterface requested = ChainlinkRequestInterface(pendingRequests[_requestId]);
713     delete pendingRequests[_requestId];
714     emit ChainlinkCancelled(_requestId);
715     requested.cancelOracleRequest(_requestId, _payment, _callbackFunc, _expiration);
716   }
717 
718   /**
719    * @notice Sets the stored oracle address
720    * @param _oracle The address of the oracle contract
721    */
722   function setChainlinkOracle(address _oracle) internal {
723     oracle = ChainlinkRequestInterface(_oracle);
724   }
725 
726   /**
727    * @notice Sets the LINK token address
728    * @param _link The address of the LINK token contract
729    */
730   function setChainlinkToken(address _link) internal {
731     link = LinkTokenInterface(_link);
732   }
733 
734   /**
735    * @notice Sets the Chainlink token address for the public
736    * network as given by the Pointer contract
737    */
738   function setPublicChainlinkToken() internal {
739     setChainlinkToken(PointerInterface(LINK_TOKEN_POINTER).getAddress());
740   }
741 
742   /**
743    * @notice Retrieves the stored address of the LINK token
744    * @return The address of the LINK token
745    */
746   function chainlinkTokenAddress()
747     internal
748     view
749     returns (address)
750   {
751     return address(link);
752   }
753 
754   /**
755    * @notice Retrieves the stored address of the oracle contract
756    * @return The address of the oracle contract
757    */
758   function chainlinkOracleAddress()
759     internal
760     view
761     returns (address)
762   {
763     return address(oracle);
764   }
765 
766   /**
767    * @notice Allows for a request which was created on another contract to be fulfilled
768    * on this contract
769    * @param _oracle The address of the oracle contract that will fulfill the request
770    * @param _requestId The request ID used for the response
771    */
772   function addChainlinkExternalRequest(address _oracle, bytes32 _requestId)
773     internal
774     notPendingRequest(_requestId)
775   {
776     pendingRequests[_requestId] = _oracle;
777   }
778 
779   /**
780    * @notice Sets the stored oracle and LINK token contracts with the addresses resolved by ENS
781    * @dev Accounts for subnodes having different resolvers
782    * @param _ens The address of the ENS contract
783    * @param _node The ENS node hash
784    */
785   function useChainlinkWithENS(address _ens, bytes32 _node)
786     internal
787   {
788     ens = ENSInterface(_ens);
789     ensNode = _node;
790     bytes32 linkSubnode = keccak256(abi.encodePacked(ensNode, ENS_TOKEN_SUBNAME));
791     ENSResolver resolver = ENSResolver(ens.resolver(linkSubnode));
792     setChainlinkToken(resolver.addr(linkSubnode));
793     updateChainlinkOracleWithENS();
794   }
795 
796   /**
797    * @notice Sets the stored oracle contract with the address resolved by ENS
798    * @dev This may be called on its own as long as `useChainlinkWithENS` has been called previously
799    */
800   function updateChainlinkOracleWithENS()
801     internal
802   {
803     bytes32 oracleSubnode = keccak256(abi.encodePacked(ensNode, ENS_ORACLE_SUBNAME));
804     ENSResolver resolver = ENSResolver(ens.resolver(oracleSubnode));
805     setChainlinkOracle(resolver.addr(oracleSubnode));
806   }
807 
808   /**
809    * @notice Encodes the request to be sent to the oracle contract
810    * @dev The Chainlink node expects values to be in order for the request to be picked up. Order of types
811    * will be validated in the oracle contract.
812    * @param _req The initialized Chainlink Request
813    * @return The bytes payload for the `transferAndCall` method
814    */
815   function encodeRequest(Chainlink.Request memory _req)
816     private
817     view
818     returns (bytes memory)
819   {
820     return abi.encodeWithSelector(
821       oracle.oracleRequest.selector,
822       SENDER_OVERRIDE, // Sender value - overridden by onTokenTransfer by the requesting contract's address
823       AMOUNT_OVERRIDE, // Amount value - overridden by onTokenTransfer by the actual amount of LINK sent
824       _req.id,
825       _req.callbackAddress,
826       _req.callbackFunctionId,
827       _req.nonce,
828       ARGS_VERSION,
829       _req.buf.buf);
830   }
831 
832   /**
833    * @notice Ensures that the fulfillment is valid for this contract
834    * @dev Use if the contract developer prefers methods instead of modifiers for validation
835    * @param _requestId The request ID for fulfillment
836    */
837   function validateChainlinkCallback(bytes32 _requestId)
838     internal
839     recordChainlinkFulfillment(_requestId)
840     // solhint-disable-next-line no-empty-blocks
841   {}
842 
843   /**
844    * @dev Reverts if the sender is not the oracle of the request.
845    * Emits ChainlinkFulfilled event.
846    * @param _requestId The request ID for fulfillment
847    */
848   modifier recordChainlinkFulfillment(bytes32 _requestId) {
849     require(msg.sender == pendingRequests[_requestId], "Source must be the oracle of the request");
850     delete pendingRequests[_requestId];
851     emit ChainlinkFulfilled(_requestId);
852     _;
853   }
854 
855   /**
856    * @dev Reverts if the request is already pending
857    * @param _requestId The request ID for fulfillment
858    */
859   modifier notPendingRequest(bytes32 _requestId) {
860     require(pendingRequests[_requestId] == address(0), "Request is already pending");
861     _;
862   }
863 }
864 
865 interface AggregatorInterface {
866   function latestAnswer() external view returns (int256);
867   function latestTimestamp() external view returns (uint256);
868   function latestRound() external view returns (uint256);
869   function getAnswer(uint256 roundId) external view returns (int256);
870   function getTimestamp(uint256 roundId) external view returns (uint256);
871 
872   event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 timestamp);
873   event NewRound(uint256 indexed roundId, address indexed startedBy);
874 }
875 
876 library SignedSafeMath {
877 
878   /**
879    * @dev Adds two int256s and makes sure the result doesn't overflow. Signed
880    * integers aren't supported by the SafeMath library, thus this method
881    * @param _a The first number to be added
882    * @param _a The second number to be added
883    */
884   function add(int256 _a, int256 _b)
885     internal
886     pure
887     returns (int256)
888   {
889     int256 c = _a + _b;
890     require((_b >= 0 && c >= _a) || (_b < 0 && c < _a), "SignedSafeMath: addition overflow");
891 
892     return c;
893   }
894 }
895 
896 /**
897  * @title Ownable
898  * @dev The Ownable contract has an owner address, and provides basic authorization control
899  * functions, this simplifies the implementation of "user permissions".
900  */
901 contract Ownable {
902   address public owner;
903 
904 
905   event OwnershipRenounced(address indexed previousOwner);
906   event OwnershipTransferred(
907     address indexed previousOwner,
908     address indexed newOwner
909   );
910 
911 
912   /**
913    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
914    * account.
915    */
916   constructor() public {
917     owner = msg.sender;
918   }
919 
920   /**
921    * @dev Throws if called by any account other than the owner.
922    */
923   modifier onlyOwner() {
924     require(msg.sender == owner);
925     _;
926   }
927 
928   /**
929    * @dev Allows the current owner to relinquish control of the contract.
930    * @notice Renouncing to ownership will leave the contract without an owner.
931    * It will not be possible to call the functions with the `onlyOwner`
932    * modifier anymore.
933    */
934   function renounceOwnership() public onlyOwner {
935     emit OwnershipRenounced(owner);
936     owner = address(0);
937   }
938 
939   /**
940    * @dev Allows the current owner to transfer control of the contract to a newOwner.
941    * @param _newOwner The address to transfer ownership to.
942    */
943   function transferOwnership(address _newOwner) public onlyOwner {
944     _transferOwnership(_newOwner);
945   }
946 
947   /**
948    * @dev Transfers control of the contract to a newOwner.
949    * @param _newOwner The address to transfer ownership to.
950    */
951   function _transferOwnership(address _newOwner) internal {
952     require(_newOwner != address(0));
953     emit OwnershipTransferred(owner, _newOwner);
954     owner = _newOwner;
955   }
956 }
957 
958 /**
959  * @title An example Chainlink contract with aggregation
960  * @notice Requesters can use this contract as a framework for creating
961  * requests to multiple Chainlink nodes and running aggregation
962  * as the contract receives answers.
963  */
964 contract Aggregator is AggregatorInterface, ChainlinkClient, Ownable {
965   using SignedSafeMath for int256;
966 
967   struct Answer {
968     uint128 minimumResponses;
969     uint128 maxResponses;
970     int256[] responses;
971   }
972 
973   event ResponseReceived(int256 indexed response, uint256 indexed answerId, address indexed sender);
974 
975   int256 private currentAnswerValue;
976   uint256 private updatedTimestampValue;
977   uint256 private latestCompletedAnswer;
978   uint128 public paymentAmount;
979   uint128 public minimumResponses;
980   bytes32[] public jobIds;
981   address[] public oracles;
982 
983   uint256 private answerCounter = 1;
984   mapping(address => bool) public authorizedRequesters;
985   mapping(bytes32 => uint256) private requestAnswers;
986   mapping(uint256 => Answer) private answers;
987   mapping(uint256 => int256) private currentAnswers;
988   mapping(uint256 => uint256) private updatedTimestamps;
989 
990   uint256 constant private MAX_ORACLE_COUNT = 45;
991 
992   /**
993    * @notice Deploy with the address of the LINK token and arrays of matching
994    * length containing the addresses of the oracles and their corresponding
995    * Job IDs.
996    * @dev Sets the LinkToken address for the network, addresses of the oracles,
997    * and jobIds in storage.
998    * @param _link The address of the LINK token
999    * @param _paymentAmount the amount of LINK to be sent to each oracle for each request
1000    * @param _minimumResponses the minimum number of responses
1001    * before an answer will be calculated
1002    * @param _oracles An array of oracle addresses
1003    * @param _jobIds An array of Job IDs
1004    */
1005   constructor(
1006     address _link,
1007     uint128 _paymentAmount,
1008     uint128 _minimumResponses,
1009     address[] _oracles,
1010     bytes32[] _jobIds
1011   ) public Ownable() {
1012     setChainlinkToken(_link);
1013     updateRequestDetails(_paymentAmount, _minimumResponses, _oracles, _jobIds);
1014   }
1015 
1016   /**
1017    * @notice Creates a Chainlink request for each oracle in the oracles array.
1018    * @dev This example does not include request parameters. Reference any documentation
1019    * associated with the Job IDs used to determine the required parameters per-request.
1020    */
1021   function requestRateUpdate()
1022     external
1023     ensureAuthorizedRequester()
1024   {
1025     Chainlink.Request memory request;
1026     bytes32 requestId;
1027     uint256 oraclePayment = paymentAmount;
1028 
1029     for (uint i = 0; i < oracles.length; i++) {
1030       request = buildChainlinkRequest(jobIds[i], this, this.chainlinkCallback.selector);
1031       requestId = sendChainlinkRequestTo(oracles[i], request, oraclePayment);
1032       requestAnswers[requestId] = answerCounter;
1033     }
1034     answers[answerCounter].minimumResponses = minimumResponses;
1035     answers[answerCounter].maxResponses = uint128(oracles.length);
1036     answerCounter = answerCounter.add(1);
1037 
1038     emit NewRound(answerCounter, msg.sender);
1039   }
1040 
1041   /**
1042    * @notice Receives the answer from the Chainlink node.
1043    * @dev This function can only be called by the oracle that received the request.
1044    * @param _clRequestId The Chainlink request ID associated with the answer
1045    * @param _response The answer provided by the Chainlink node
1046    */
1047   function chainlinkCallback(bytes32 _clRequestId, int256 _response)
1048     external
1049   {
1050     validateChainlinkCallback(_clRequestId);
1051 
1052     uint256 answerId = requestAnswers[_clRequestId];
1053     delete requestAnswers[_clRequestId];
1054 
1055     answers[answerId].responses.push(_response);
1056     emit ResponseReceived(_response, answerId, msg.sender);
1057     updateLatestAnswer(answerId);
1058     deleteAnswer(answerId);
1059   }
1060 
1061   /**
1062    * @notice Updates the arrays of oracles and jobIds with new values,
1063    * overwriting the old values.
1064    * @dev Arrays are validated to be equal length.
1065    * @param _paymentAmount the amount of LINK to be sent to each oracle for each request
1066    * @param _minimumResponses the minimum number of responses
1067    * before an answer will be calculated
1068    * @param _oracles An array of oracle addresses
1069    * @param _jobIds An array of Job IDs
1070    */
1071   function updateRequestDetails(
1072     uint128 _paymentAmount,
1073     uint128 _minimumResponses,
1074     address[] _oracles,
1075     bytes32[] _jobIds
1076   )
1077     public
1078     onlyOwner()
1079     validateAnswerRequirements(_minimumResponses, _oracles, _jobIds)
1080   {
1081     paymentAmount = _paymentAmount;
1082     minimumResponses = _minimumResponses;
1083     jobIds = _jobIds;
1084     oracles = _oracles;
1085   }
1086 
1087   /**
1088    * @notice Allows the owner of the contract to withdraw any LINK balance
1089    * available on the contract.
1090    * @dev The contract will need to have a LINK balance in order to create requests.
1091    * @param _recipient The address to receive the LINK tokens
1092    * @param _amount The amount of LINK to send from the contract
1093    */
1094   function transferLINK(address _recipient, uint256 _amount)
1095     public
1096     onlyOwner()
1097   {
1098     LinkTokenInterface linkToken = LinkTokenInterface(chainlinkTokenAddress());
1099     require(linkToken.transfer(_recipient, _amount), "LINK transfer failed");
1100   }
1101 
1102   /**
1103    * @notice Called by the owner to permission other addresses to generate new
1104    * requests to oracles.
1105    * @param _requester the address whose permissions are being set
1106    * @param _allowed boolean that determines whether the requester is
1107    * permissioned or not
1108    */
1109   function setAuthorization(address _requester, bool _allowed)
1110     external
1111     onlyOwner()
1112   {
1113     authorizedRequesters[_requester] = _allowed;
1114   }
1115 
1116   /**
1117    * @notice Cancels an outstanding Chainlink request.
1118    * The oracle contract requires the request ID and additional metadata to
1119    * validate the cancellation. Only old answers can be cancelled.
1120    * @param _requestId is the identifier for the chainlink request being cancelled
1121    * @param _payment is the amount of LINK paid to the oracle for the request
1122    * @param _expiration is the time when the request expires
1123    */
1124   function cancelRequest(
1125     bytes32 _requestId,
1126     uint256 _payment,
1127     uint256 _expiration
1128   )
1129     external
1130     ensureAuthorizedRequester()
1131   {
1132     uint256 answerId = requestAnswers[_requestId];
1133     require(answerId < latestCompletedAnswer, "Cannot modify an in-progress answer");
1134 
1135     delete requestAnswers[_requestId];
1136     answers[answerId].responses.push(0);
1137     deleteAnswer(answerId);
1138 
1139     cancelChainlinkRequest(
1140       _requestId,
1141       _payment,
1142       this.chainlinkCallback.selector,
1143       _expiration
1144     );
1145   }
1146 
1147   /**
1148    * @notice Called by the owner to kill the contract. This transfers all LINK
1149    * balance and ETH balance (if there is any) to the owner.
1150    */
1151   function destroy()
1152     external
1153     onlyOwner()
1154   {
1155     LinkTokenInterface linkToken = LinkTokenInterface(chainlinkTokenAddress());
1156     transferLINK(owner, linkToken.balanceOf(address(this)));
1157     selfdestruct(owner);
1158   }
1159 
1160   /**
1161    * @dev Performs aggregation of the answers received from the Chainlink nodes.
1162    * Assumes that at least half the oracles are honest and so can't contol the
1163    * middle of the ordered responses.
1164    * @param _answerId The answer ID associated with the group of requests
1165    */
1166   function updateLatestAnswer(uint256 _answerId)
1167     private
1168     ensureMinResponsesReceived(_answerId)
1169     ensureOnlyLatestAnswer(_answerId)
1170   {
1171     uint256 responseLength = answers[_answerId].responses.length;
1172     uint256 middleIndex = responseLength.div(2);
1173     int256 currentAnswerTemp;
1174     if (responseLength % 2 == 0) {
1175       int256 median1 = quickselect(answers[_answerId].responses, middleIndex);
1176       int256 median2 = quickselect(answers[_answerId].responses, middleIndex.add(1)); // quickselect is 1 indexed
1177       currentAnswerTemp = median1.add(median2) / 2; // signed integers are not supported by SafeMath
1178     } else {
1179       currentAnswerTemp = quickselect(answers[_answerId].responses, middleIndex.add(1)); // quickselect is 1 indexed
1180     }
1181     currentAnswerValue = currentAnswerTemp;
1182     latestCompletedAnswer = _answerId;
1183     updatedTimestampValue = now;
1184     updatedTimestamps[_answerId] = now;
1185     currentAnswers[_answerId] = currentAnswerTemp;
1186     emit AnswerUpdated(currentAnswerTemp, _answerId, now);
1187   }
1188 
1189   /**
1190    * @notice get the most recently reported answer
1191    */
1192   function latestAnswer()
1193     external
1194     view
1195     returns (int256)
1196   {
1197     return currentAnswers[latestCompletedAnswer];
1198   }
1199 
1200   /**
1201    * @notice get the last updated at block timestamp
1202    */
1203   function latestTimestamp()
1204     external
1205     view
1206     returns (uint256)
1207   {
1208     return updatedTimestamps[latestCompletedAnswer];
1209   }
1210 
1211   /**
1212    * @notice get past rounds answers
1213    * @param _roundId the answer number to retrieve the answer for
1214    */
1215   function getAnswer(uint256 _roundId)
1216     external
1217     view
1218     returns (int256)
1219   {
1220     return currentAnswers[_roundId];
1221   }
1222 
1223   /**
1224    * @notice get block timestamp when an answer was last updated
1225    * @param _roundId the answer number to retrieve the updated timestamp for
1226    */
1227   function getTimestamp(uint256 _roundId)
1228     external
1229     view
1230     returns (uint256)
1231   {
1232     return updatedTimestamps[_roundId];
1233   }
1234 
1235   /**
1236    * @notice get the latest completed round where the answer was updated
1237    */
1238   function latestRound() external view returns (uint256) {
1239     return latestCompletedAnswer;
1240   }
1241 
1242   /**
1243    * @dev Returns the kth value of the ordered array
1244    * See: http://www.cs.yale.edu/homes/aspnes/pinewiki/QuickSelect.html
1245    * @param _a The list of elements to pull from
1246    * @param _k The index, 1 based, of the elements you want to pull from when ordered
1247    */
1248   function quickselect(int256[] memory _a, uint256 _k)
1249     private
1250     pure
1251     returns (int256)
1252   {
1253     int256[] memory a = _a;
1254     uint256 k = _k;
1255     uint256 aLen = a.length;
1256     int256[] memory a1 = new int256[](aLen);
1257     int256[] memory a2 = new int256[](aLen);
1258     uint256 a1Len;
1259     uint256 a2Len;
1260     int256 pivot;
1261     uint256 i;
1262 
1263     while (true) {
1264       pivot = a[aLen.div(2)];
1265       a1Len = 0;
1266       a2Len = 0;
1267       for (i = 0; i < aLen; i++) {
1268         if (a[i] < pivot) {
1269           a1[a1Len] = a[i];
1270           a1Len++;
1271         } else if (a[i] > pivot) {
1272           a2[a2Len] = a[i];
1273           a2Len++;
1274         }
1275       }
1276       if (k <= a1Len) {
1277         aLen = a1Len;
1278         (a, a1) = swap(a, a1);
1279       } else if (k > (aLen.sub(a2Len))) {
1280         k = k.sub(aLen.sub(a2Len));
1281         aLen = a2Len;
1282         (a, a2) = swap(a, a2);
1283       } else {
1284         return pivot;
1285       }
1286     }
1287   }
1288 
1289   /**
1290    * @dev Swaps the pointers to two uint256 arrays in memory
1291    * @param _a The pointer to the first in memory array
1292    * @param _b The pointer to the second in memory array
1293    */
1294   function swap(int256[] memory _a, int256[] memory _b)
1295     private
1296     pure
1297     returns(int256[] memory, int256[] memory)
1298   {
1299     return (_b, _a);
1300   }
1301 
1302   /**
1303    * @dev Cleans up the answer record if all responses have been received.
1304    * @param _answerId The identifier of the answer to be deleted
1305    */
1306   function deleteAnswer(uint256 _answerId)
1307     private
1308     ensureAllResponsesReceived(_answerId)
1309   {
1310     delete answers[_answerId];
1311   }
1312 
1313   /**
1314    * @dev Prevents taking an action if the minimum number of responses has not
1315    * been received for an answer.
1316    * @param _answerId The the identifier of the answer that keeps track of the responses.
1317    */
1318   modifier ensureMinResponsesReceived(uint256 _answerId) {
1319     if (answers[_answerId].responses.length >= answers[_answerId].minimumResponses) {
1320       _;
1321     }
1322   }
1323 
1324   /**
1325    * @dev Prevents taking an action if not all responses are received for an answer.
1326    * @param _answerId The the identifier of the answer that keeps track of the responses.
1327    */
1328   modifier ensureAllResponsesReceived(uint256 _answerId) {
1329     if (answers[_answerId].responses.length == answers[_answerId].maxResponses) {
1330       _;
1331     }
1332   }
1333 
1334   /**
1335    * @dev Prevents taking an action if a newer answer has been recorded.
1336    * @param _answerId The current answer's identifier.
1337    * Answer IDs are in ascending order.
1338    */
1339   modifier ensureOnlyLatestAnswer(uint256 _answerId) {
1340     if (latestCompletedAnswer <= _answerId) {
1341       _;
1342     }
1343   }
1344 
1345   /**
1346    * @dev Ensures corresponding number of oracles and jobs.
1347    * @param _oracles The list of oracles.
1348    * @param _jobIds The list of jobs.
1349    */
1350   modifier validateAnswerRequirements(
1351     uint256 _minimumResponses,
1352     address[] _oracles,
1353     bytes32[] _jobIds
1354   ) {
1355     require(_oracles.length <= MAX_ORACLE_COUNT, "cannot have more than 45 oracles");
1356     require(_oracles.length >= _minimumResponses, "must have at least as many oracles as responses");
1357     require(_oracles.length == _jobIds.length, "must have exactly as many oracles as job IDs");
1358     _;
1359   }
1360 
1361   /**
1362    * @dev Reverts if `msg.sender` is not authorized to make requests.
1363    */
1364   modifier ensureAuthorizedRequester() {
1365     require(authorizedRequesters[msg.sender] || msg.sender == owner, "Not an authorized address for creating requests");
1366     _;
1367   }
1368 
1369 }