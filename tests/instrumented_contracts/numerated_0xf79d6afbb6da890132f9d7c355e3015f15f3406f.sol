1 /**
2 * @dev A library for working with mutable byte buffers in Solidity.
3 *
4 * Byte buffers are mutable and expandable, and provide a variety of primitives
5 * for writing to them. At any time you can fetch a bytes object containing the
6 * current contents of the buffer. The bytes object should not be stored between
7 * operations, as it may change due to resizing of the buffer.
8 */
9 library Buffer {
10   /**
11   * @dev Represents a mutable buffer. Buffers have a current value (buf) and
12   *      a capacity. The capacity may be longer than the current value, in
13   *      which case it can be extended without the need to allocate more memory.
14   */
15   struct buffer {
16     bytes buf;
17     uint capacity;
18   }
19 
20   /**
21   * @dev Initializes a buffer with an initial capacity.
22   * @param buf The buffer to initialize.
23   * @param capacity The number of bytes of space to allocate the buffer.
24   * @return The buffer, for chaining.
25   */
26   function init(buffer memory buf, uint capacity) internal pure returns(buffer memory) {
27     if (capacity % 32 != 0) {
28       capacity += 32 - (capacity % 32);
29     }
30     // Allocate space for the buffer data
31     buf.capacity = capacity;
32     assembly {
33       let ptr := mload(0x40)
34       mstore(buf, ptr)
35       mstore(ptr, 0)
36       mstore(0x40, add(32, add(ptr, capacity)))
37     }
38     return buf;
39   }
40 
41   /**
42   * @dev Initializes a new buffer from an existing bytes object.
43   *      Changes to the buffer may mutate the original value.
44   * @param b The bytes object to initialize the buffer with.
45   * @return A new buffer.
46   */
47   function fromBytes(bytes memory b) internal pure returns(buffer memory) {
48     buffer memory buf;
49     buf.buf = b;
50     buf.capacity = b.length;
51     return buf;
52   }
53 
54   function resize(buffer memory buf, uint capacity) private pure {
55     bytes memory oldbuf = buf.buf;
56     init(buf, capacity);
57     append(buf, oldbuf);
58   }
59 
60   function max(uint a, uint b) private pure returns(uint) {
61     if (a > b) {
62       return a;
63     }
64     return b;
65   }
66 
67   /**
68   * @dev Sets buffer length to 0.
69   * @param buf The buffer to truncate.
70   * @return The original buffer, for chaining..
71   */
72   function truncate(buffer memory buf) internal pure returns (buffer memory) {
73     assembly {
74       let bufptr := mload(buf)
75       mstore(bufptr, 0)
76     }
77     return buf;
78   }
79 
80   /**
81   * @dev Writes a byte string to a buffer. Resizes if doing so would exceed
82   *      the capacity of the buffer.
83   * @param buf The buffer to append to.
84   * @param off The start offset to write to.
85   * @param data The data to append.
86   * @param len The number of bytes to copy.
87   * @return The original buffer, for chaining.
88   */
89   function write(buffer memory buf, uint off, bytes memory data, uint len) internal pure returns(buffer memory) {
90     require(len <= data.length);
91 
92     if (off + len > buf.capacity) {
93       resize(buf, max(buf.capacity, len + off) * 2);
94     }
95 
96     uint dest;
97     uint src;
98     assembly {
99       // Memory address of the buffer data
100       let bufptr := mload(buf)
101       // Length of existing buffer data
102       let buflen := mload(bufptr)
103       // Start address = buffer address + offset + sizeof(buffer length)
104       dest := add(add(bufptr, 32), off)
105       // Update buffer length if we're extending it
106       if gt(add(len, off), buflen) {
107         mstore(bufptr, add(len, off))
108       }
109       src := add(data, 32)
110     }
111 
112     // Copy word-length chunks while possible
113     for (; len >= 32; len -= 32) {
114       assembly {
115         mstore(dest, mload(src))
116       }
117       dest += 32;
118       src += 32;
119     }
120 
121     // Copy remaining bytes
122     uint mask = 256 ** (32 - len) - 1;
123     assembly {
124       let srcpart := and(mload(src), not(mask))
125       let destpart := and(mload(dest), mask)
126       mstore(dest, or(destpart, srcpart))
127     }
128 
129     return buf;
130   }
131 
132   /**
133   * @dev Appends a byte string to a buffer. Resizes if doing so would exceed
134   *      the capacity of the buffer.
135   * @param buf The buffer to append to.
136   * @param data The data to append.
137   * @param len The number of bytes to copy.
138   * @return The original buffer, for chaining.
139   */
140   function append(buffer memory buf, bytes memory data, uint len) internal pure returns (buffer memory) {
141     return write(buf, buf.buf.length, data, len);
142   }
143 
144   /**
145   * @dev Appends a byte string to a buffer. Resizes if doing so would exceed
146   *      the capacity of the buffer.
147   * @param buf The buffer to append to.
148   * @param data The data to append.
149   * @return The original buffer, for chaining.
150   */
151   function append(buffer memory buf, bytes memory data) internal pure returns (buffer memory) {
152     return write(buf, buf.buf.length, data, data.length);
153   }
154 
155   /**
156   * @dev Writes a byte to the buffer. Resizes if doing so would exceed the
157   *      capacity of the buffer.
158   * @param buf The buffer to append to.
159   * @param off The offset to write the byte at.
160   * @param data The data to append.
161   * @return The original buffer, for chaining.
162   */
163   function writeUint8(buffer memory buf, uint off, uint8 data) internal pure returns(buffer memory) {
164     if (off >= buf.capacity) {
165       resize(buf, buf.capacity * 2);
166     }
167 
168     assembly {
169       // Memory address of the buffer data
170       let bufptr := mload(buf)
171       // Length of existing buffer data
172       let buflen := mload(bufptr)
173       // Address = buffer address + sizeof(buffer length) + off
174       let dest := add(add(bufptr, off), 32)
175       mstore8(dest, data)
176       // Update buffer length if we extended it
177       if eq(off, buflen) {
178         mstore(bufptr, add(buflen, 1))
179       }
180     }
181     return buf;
182   }
183 
184   /**
185   * @dev Appends a byte to the buffer. Resizes if doing so would exceed the
186   *      capacity of the buffer.
187   * @param buf The buffer to append to.
188   * @param data The data to append.
189   * @return The original buffer, for chaining.
190   */
191   function appendUint8(buffer memory buf, uint8 data) internal pure returns(buffer memory) {
192     return writeUint8(buf, buf.buf.length, data);
193   }
194 
195   /**
196   * @dev Writes up to 32 bytes to the buffer. Resizes if doing so would
197   *      exceed the capacity of the buffer.
198   * @param buf The buffer to append to.
199   * @param off The offset to write at.
200   * @param data The data to append.
201   * @param len The number of bytes to write (left-aligned).
202   * @return The original buffer, for chaining.
203   */
204   function write(buffer memory buf, uint off, bytes32 data, uint len) private pure returns(buffer memory) {
205     if (len + off > buf.capacity) {
206       resize(buf, (len + off) * 2);
207     }
208 
209     uint mask = 256 ** len - 1;
210     // Right-align data
211     data = data >> (8 * (32 - len));
212     assembly {
213       // Memory address of the buffer data
214       let bufptr := mload(buf)
215       // Address = buffer address + sizeof(buffer length) + off + len
216       let dest := add(add(bufptr, off), len)
217       mstore(dest, or(and(mload(dest), not(mask)), data))
218       // Update buffer length if we extended it
219       if gt(add(off, len), mload(bufptr)) {
220         mstore(bufptr, add(off, len))
221       }
222     }
223     return buf;
224   }
225 
226   /**
227   * @dev Writes a bytes20 to the buffer. Resizes if doing so would exceed the
228   *      capacity of the buffer.
229   * @param buf The buffer to append to.
230   * @param off The offset to write at.
231   * @param data The data to append.
232   * @return The original buffer, for chaining.
233   */
234   function writeBytes20(buffer memory buf, uint off, bytes20 data) internal pure returns (buffer memory) {
235     return write(buf, off, bytes32(data), 20);
236   }
237 
238   /**
239   * @dev Appends a bytes20 to the buffer. Resizes if doing so would exceed
240   *      the capacity of the buffer.
241   * @param buf The buffer to append to.
242   * @param data The data to append.
243   * @return The original buffer, for chhaining.
244   */
245   function appendBytes20(buffer memory buf, bytes20 data) internal pure returns (buffer memory) {
246     return write(buf, buf.buf.length, bytes32(data), 20);
247   }
248 
249   /**
250   * @dev Appends a bytes32 to the buffer. Resizes if doing so would exceed
251   *      the capacity of the buffer.
252   * @param buf The buffer to append to.
253   * @param data The data to append.
254   * @return The original buffer, for chaining.
255   */
256   function appendBytes32(buffer memory buf, bytes32 data) internal pure returns (buffer memory) {
257     return write(buf, buf.buf.length, data, 32);
258   }
259 
260   /**
261   * @dev Writes an integer to the buffer. Resizes if doing so would exceed
262   *      the capacity of the buffer.
263   * @param buf The buffer to append to.
264   * @param off The offset to write at.
265   * @param data The data to append.
266   * @param len The number of bytes to write (right-aligned).
267   * @return The original buffer, for chaining.
268   */
269   function writeInt(buffer memory buf, uint off, uint data, uint len) private pure returns(buffer memory) {
270     if (len + off > buf.capacity) {
271       resize(buf, (len + off) * 2);
272     }
273 
274     uint mask = 256 ** len - 1;
275     assembly {
276       // Memory address of the buffer data
277       let bufptr := mload(buf)
278       // Address = buffer address + off + sizeof(buffer length) + len
279       let dest := add(add(bufptr, off), len)
280       mstore(dest, or(and(mload(dest), not(mask)), data))
281       // Update buffer length if we extended it
282       if gt(add(off, len), mload(bufptr)) {
283         mstore(bufptr, add(off, len))
284       }
285     }
286     return buf;
287   }
288 
289   /**
290    * @dev Appends a byte to the end of the buffer. Resizes if doing so would
291    * exceed the capacity of the buffer.
292    * @param buf The buffer to append to.
293    * @param data The data to append.
294    * @return The original buffer.
295    */
296   function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
297     return writeInt(buf, buf.buf.length, data, len);
298   }
299 }
300 
301 library CBOR {
302   using Buffer for Buffer.buffer;
303 
304   uint8 private constant MAJOR_TYPE_INT = 0;
305   uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
306   uint8 private constant MAJOR_TYPE_BYTES = 2;
307   uint8 private constant MAJOR_TYPE_STRING = 3;
308   uint8 private constant MAJOR_TYPE_ARRAY = 4;
309   uint8 private constant MAJOR_TYPE_MAP = 5;
310   uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
311 
312   function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
313     if(value <= 23) {
314       buf.appendUint8(uint8((major << 5) | value));
315     } else if(value <= 0xFF) {
316       buf.appendUint8(uint8((major << 5) | 24));
317       buf.appendInt(value, 1);
318     } else if(value <= 0xFFFF) {
319       buf.appendUint8(uint8((major << 5) | 25));
320       buf.appendInt(value, 2);
321     } else if(value <= 0xFFFFFFFF) {
322       buf.appendUint8(uint8((major << 5) | 26));
323       buf.appendInt(value, 4);
324     } else if(value <= 0xFFFFFFFFFFFFFFFF) {
325       buf.appendUint8(uint8((major << 5) | 27));
326       buf.appendInt(value, 8);
327     }
328   }
329 
330   function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
331     buf.appendUint8(uint8((major << 5) | 31));
332   }
333 
334   function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
335     encodeType(buf, MAJOR_TYPE_INT, value);
336   }
337 
338   function encodeInt(Buffer.buffer memory buf, int value) internal pure {
339     if(value >= 0) {
340       encodeType(buf, MAJOR_TYPE_INT, uint(value));
341     } else {
342       encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
343     }
344   }
345 
346   function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
347     encodeType(buf, MAJOR_TYPE_BYTES, value.length);
348     buf.append(value);
349   }
350 
351   function encodeString(Buffer.buffer memory buf, string value) internal pure {
352     encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
353     buf.append(bytes(value));
354   }
355 
356   function startArray(Buffer.buffer memory buf) internal pure {
357     encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
358   }
359 
360   function startMap(Buffer.buffer memory buf) internal pure {
361     encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
362   }
363 
364   function endSequence(Buffer.buffer memory buf) internal pure {
365     encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
366   }
367 }
368 
369 /**
370  * @title Library for common Chainlink functions
371  * @dev Uses imported CBOR library for encoding to buffer
372  */
373 library Chainlink {
374   uint256 internal constant defaultBufferSize = 256; // solhint-disable-line const-name-snakecase
375 
376   using CBOR for Buffer.buffer;
377 
378   struct Request {
379     bytes32 id;
380     address callbackAddress;
381     bytes4 callbackFunctionId;
382     uint256 nonce;
383     Buffer.buffer buf;
384   }
385 
386   /**
387    * @notice Initializes a Chainlink request
388    * @dev Sets the ID, callback address, and callback function signature on the request
389    * @param self The uninitialized request
390    * @param _id The Job Specification ID
391    * @param _callbackAddress The callback address
392    * @param _callbackFunction The callback function signature
393    * @return The initialized request
394    */
395   function initialize(
396     Request memory self,
397     bytes32 _id,
398     address _callbackAddress,
399     bytes4 _callbackFunction
400   ) internal pure returns (Chainlink.Request memory) {
401     Buffer.init(self.buf, defaultBufferSize);
402     self.id = _id;
403     self.callbackAddress = _callbackAddress;
404     self.callbackFunctionId = _callbackFunction;
405     return self;
406   }
407 
408   /**
409    * @notice Sets the data for the buffer without encoding CBOR on-chain
410    * @dev CBOR can be closed with curly-brackets {} or they can be left off
411    * @param self The initialized request
412    * @param _data The CBOR data
413    */
414   function setBuffer(Request memory self, bytes _data)
415     internal pure
416   {
417     Buffer.init(self.buf, _data.length);
418     Buffer.append(self.buf, _data);
419   }
420 
421   /**
422    * @notice Adds a string value to the request with a given key name
423    * @param self The initialized request
424    * @param _key The name of the key
425    * @param _value The string value to add
426    */
427   function add(Request memory self, string _key, string _value)
428     internal pure
429   {
430     self.buf.encodeString(_key);
431     self.buf.encodeString(_value);
432   }
433 
434   /**
435    * @notice Adds a bytes value to the request with a given key name
436    * @param self The initialized request
437    * @param _key The name of the key
438    * @param _value The bytes value to add
439    */
440   function addBytes(Request memory self, string _key, bytes _value)
441     internal pure
442   {
443     self.buf.encodeString(_key);
444     self.buf.encodeBytes(_value);
445   }
446 
447   /**
448    * @notice Adds a int256 value to the request with a given key name
449    * @param self The initialized request
450    * @param _key The name of the key
451    * @param _value The int256 value to add
452    */
453   function addInt(Request memory self, string _key, int256 _value)
454     internal pure
455   {
456     self.buf.encodeString(_key);
457     self.buf.encodeInt(_value);
458   }
459 
460   /**
461    * @notice Adds a uint256 value to the request with a given key name
462    * @param self The initialized request
463    * @param _key The name of the key
464    * @param _value The uint256 value to add
465    */
466   function addUint(Request memory self, string _key, uint256 _value)
467     internal pure
468   {
469     self.buf.encodeString(_key);
470     self.buf.encodeUInt(_value);
471   }
472 
473   /**
474    * @notice Adds an array of strings to the request with a given key name
475    * @param self The initialized request
476    * @param _key The name of the key
477    * @param _values The array of string values to add
478    */
479   function addStringArray(Request memory self, string _key, string[] memory _values)
480     internal pure
481   {
482     self.buf.encodeString(_key);
483     self.buf.startArray();
484     for (uint256 i = 0; i < _values.length; i++) {
485       self.buf.encodeString(_values[i]);
486     }
487     self.buf.endSequence();
488   }
489 }
490 
491 interface ENSInterface {
492 
493   // Logged when the owner of a node assigns a new owner to a subnode.
494   event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
495 
496   // Logged when the owner of a node transfers ownership to a new account.
497   event Transfer(bytes32 indexed node, address owner);
498 
499   // Logged when the resolver for a node changes.
500   event NewResolver(bytes32 indexed node, address resolver);
501 
502   // Logged when the TTL of a node changes
503   event NewTTL(bytes32 indexed node, uint64 ttl);
504 
505 
506   function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
507   function setResolver(bytes32 node, address resolver) external;
508   function setOwner(bytes32 node, address owner) external;
509   function setTTL(bytes32 node, uint64 ttl) external;
510   function owner(bytes32 node) external view returns (address);
511   function resolver(bytes32 node) external view returns (address);
512   function ttl(bytes32 node) external view returns (uint64);
513 
514 }
515 
516 interface LinkTokenInterface {
517   function allowance(address owner, address spender) external returns (uint256 remaining);
518   function approve(address spender, uint256 value) external returns (bool success);
519   function balanceOf(address owner) external returns (uint256 balance);
520   function decimals() external returns (uint8 decimalPlaces);
521   function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
522   function increaseApproval(address spender, uint256 subtractedValue) external;
523   function name() external returns (string tokenName);
524   function symbol() external returns (string tokenSymbol);
525   function totalSupply() external returns (uint256 totalTokensIssued);
526   function transfer(address to, uint256 value) external returns (bool success);
527   function transferAndCall(address to, uint256 value, bytes data) external returns (bool success);
528   function transferFrom(address from, address to, uint256 value) external returns (bool success);
529 }
530 
531 interface ChainlinkRequestInterface {
532   function oracleRequest(
533     address sender,
534     uint256 payment,
535     bytes32 id,
536     address callbackAddress,
537     bytes4 callbackFunctionId,
538     uint256 nonce,
539     uint256 version,
540     bytes data
541   ) external;
542 
543   function cancelOracleRequest(
544     bytes32 requestId,
545     uint256 payment,
546     bytes4 callbackFunctionId,
547     uint256 expiration
548   ) external;
549 }
550 
551 interface PointerInterface {
552   function getAddress() external view returns (address);
553 }
554 
555 
556 contract ENSResolver {
557   function addr(bytes32 node) public view returns (address);
558 }
559 
560 
561 /**
562  * @title SafeMath
563  * @dev Math operations with safety checks that throw on error
564  */
565 library SafeMath {
566 
567   /**
568   * @dev Multiplies two numbers, throws on overflow.
569   */
570   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
571     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
572     // benefit is lost if 'b' is also tested.
573     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
574     if (_a == 0) {
575       return 0;
576     }
577 
578     c = _a * _b;
579     assert(c / _a == _b);
580     return c;
581   }
582 
583   /**
584   * @dev Integer division of two numbers, truncating the quotient.
585   */
586   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
587     // assert(_b > 0); // Solidity automatically throws when dividing by 0
588     // uint256 c = _a / _b;
589     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
590     return _a / _b;
591   }
592 
593   /**
594   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
595   */
596   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
597     assert(_b <= _a);
598     return _a - _b;
599   }
600 
601   /**
602   * @dev Adds two numbers, throws on overflow.
603   */
604   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
605     c = _a + _b;
606     assert(c >= _a);
607     return c;
608   }
609 }
610 
611 /**
612  * @title The ChainlinkClient contract
613  * @notice Contract writers can inherit this contract in order to create requests for the
614  * Chainlink network
615  */
616 contract ChainlinkClient {
617   using Chainlink for Chainlink.Request;
618   using SafeMath for uint256;
619 
620   uint256 constant internal LINK = 10**18;
621   uint256 constant private AMOUNT_OVERRIDE = 0;
622   address constant private SENDER_OVERRIDE = 0x0;
623   uint256 constant private ARGS_VERSION = 1;
624   bytes32 constant private ENS_TOKEN_SUBNAME = keccak256("link");
625   bytes32 constant private ENS_ORACLE_SUBNAME = keccak256("oracle");
626   address constant private LINK_TOKEN_POINTER = 0xC89bD4E1632D3A43CB03AAAd5262cbe4038Bc571;
627 
628   ENSInterface private ens;
629   bytes32 private ensNode;
630   LinkTokenInterface private link;
631   ChainlinkRequestInterface private oracle;
632   uint256 private requests = 1;
633   mapping(bytes32 => address) private pendingRequests;
634 
635   event ChainlinkRequested(bytes32 indexed id);
636   event ChainlinkFulfilled(bytes32 indexed id);
637   event ChainlinkCancelled(bytes32 indexed id);
638 
639   /**
640    * @notice Creates a request that can hold additional parameters
641    * @param _specId The Job Specification ID that the request will be created for
642    * @param _callbackAddress The callback address that the response will be sent to
643    * @param _callbackFunctionSignature The callback function signature to use for the callback address
644    * @return A Chainlink Request struct in memory
645    */
646   function buildChainlinkRequest(
647     bytes32 _specId,
648     address _callbackAddress,
649     bytes4 _callbackFunctionSignature
650   ) internal pure returns (Chainlink.Request memory) {
651     Chainlink.Request memory req;
652     return req.initialize(_specId, _callbackAddress, _callbackFunctionSignature);
653   }
654 
655   /**
656    * @notice Creates a Chainlink request to the stored oracle address
657    * @dev Calls `chainlinkRequestTo` with the stored oracle address
658    * @param _req The initialized Chainlink Request
659    * @param _payment The amount of LINK to send for the request
660    * @return The request ID
661    */
662   function sendChainlinkRequest(Chainlink.Request memory _req, uint256 _payment)
663     internal
664     returns (bytes32)
665   {
666     return sendChainlinkRequestTo(oracle, _req, _payment);
667   }
668 
669   /**
670    * @notice Creates a Chainlink request to the specified oracle address
671    * @dev Generates and stores a request ID, increments the local nonce, and uses `transferAndCall` to
672    * send LINK which creates a request on the target oracle contract.
673    * Emits ChainlinkRequested event.
674    * @param _oracle The address of the oracle for the request
675    * @param _req The initialized Chainlink Request
676    * @param _payment The amount of LINK to send for the request
677    * @return The request ID
678    */
679   function sendChainlinkRequestTo(address _oracle, Chainlink.Request memory _req, uint256 _payment)
680     internal
681     returns (bytes32 requestId)
682   {
683     requestId = keccak256(abi.encodePacked(this, requests));
684     _req.nonce = requests;
685     pendingRequests[requestId] = _oracle;
686     emit ChainlinkRequested(requestId);
687     require(link.transferAndCall(_oracle, _payment, encodeRequest(_req)), "unable to transferAndCall to oracle");
688     requests += 1;
689 
690     return requestId;
691   }
692 
693   /**
694    * @notice Allows a request to be cancelled if it has not been fulfilled
695    * @dev Requires keeping track of the expiration value emitted from the oracle contract.
696    * Deletes the request from the `pendingRequests` mapping.
697    * Emits ChainlinkCancelled event.
698    * @param _requestId The request ID
699    * @param _payment The amount of LINK sent for the request
700    * @param _callbackFunc The callback function specified for the request
701    * @param _expiration The time of the expiration for the request
702    */
703   function cancelChainlinkRequest(
704     bytes32 _requestId,
705     uint256 _payment,
706     bytes4 _callbackFunc,
707     uint256 _expiration
708   )
709     internal
710   {
711     ChainlinkRequestInterface requested = ChainlinkRequestInterface(pendingRequests[_requestId]);
712     delete pendingRequests[_requestId];
713     emit ChainlinkCancelled(_requestId);
714     requested.cancelOracleRequest(_requestId, _payment, _callbackFunc, _expiration);
715   }
716 
717   /**
718    * @notice Sets the stored oracle address
719    * @param _oracle The address of the oracle contract
720    */
721   function setChainlinkOracle(address _oracle) internal {
722     oracle = ChainlinkRequestInterface(_oracle);
723   }
724 
725   /**
726    * @notice Sets the LINK token address
727    * @param _link The address of the LINK token contract
728    */
729   function setChainlinkToken(address _link) internal {
730     link = LinkTokenInterface(_link);
731   }
732 
733   /**
734    * @notice Sets the Chainlink token address for the public
735    * network as given by the Pointer contract
736    */
737   function setPublicChainlinkToken() internal {
738     setChainlinkToken(PointerInterface(LINK_TOKEN_POINTER).getAddress());
739   }
740 
741   /**
742    * @notice Retrieves the stored address of the LINK token
743    * @return The address of the LINK token
744    */
745   function chainlinkTokenAddress()
746     internal
747     view
748     returns (address)
749   {
750     return address(link);
751   }
752 
753   /**
754    * @notice Retrieves the stored address of the oracle contract
755    * @return The address of the oracle contract
756    */
757   function chainlinkOracleAddress()
758     internal
759     view
760     returns (address)
761   {
762     return address(oracle);
763   }
764 
765   /**
766    * @notice Allows for a request which was created on another contract to be fulfilled
767    * on this contract
768    * @param _oracle The address of the oracle contract that will fulfill the request
769    * @param _requestId The request ID used for the response
770    */
771   function addChainlinkExternalRequest(address _oracle, bytes32 _requestId)
772     internal
773     notPendingRequest(_requestId)
774   {
775     pendingRequests[_requestId] = _oracle;
776   }
777 
778   /**
779    * @notice Sets the stored oracle and LINK token contracts with the addresses resolved by ENS
780    * @dev Accounts for subnodes having different resolvers
781    * @param _ens The address of the ENS contract
782    * @param _node The ENS node hash
783    */
784   function useChainlinkWithENS(address _ens, bytes32 _node)
785     internal
786   {
787     ens = ENSInterface(_ens);
788     ensNode = _node;
789     bytes32 linkSubnode = keccak256(abi.encodePacked(ensNode, ENS_TOKEN_SUBNAME));
790     ENSResolver resolver = ENSResolver(ens.resolver(linkSubnode));
791     setChainlinkToken(resolver.addr(linkSubnode));
792     updateChainlinkOracleWithENS();
793   }
794 
795   /**
796    * @notice Sets the stored oracle contract with the address resolved by ENS
797    * @dev This may be called on its own as long as `useChainlinkWithENS` has been called previously
798    */
799   function updateChainlinkOracleWithENS()
800     internal
801   {
802     bytes32 oracleSubnode = keccak256(abi.encodePacked(ensNode, ENS_ORACLE_SUBNAME));
803     ENSResolver resolver = ENSResolver(ens.resolver(oracleSubnode));
804     setChainlinkOracle(resolver.addr(oracleSubnode));
805   }
806 
807   /**
808    * @notice Encodes the request to be sent to the oracle contract
809    * @dev The Chainlink node expects values to be in order for the request to be picked up. Order of types
810    * will be validated in the oracle contract.
811    * @param _req The initialized Chainlink Request
812    * @return The bytes payload for the `transferAndCall` method
813    */
814   function encodeRequest(Chainlink.Request memory _req)
815     private
816     view
817     returns (bytes memory)
818   {
819     return abi.encodeWithSelector(
820       oracle.oracleRequest.selector,
821       SENDER_OVERRIDE, // Sender value - overridden by onTokenTransfer by the requesting contract's address
822       AMOUNT_OVERRIDE, // Amount value - overridden by onTokenTransfer by the actual amount of LINK sent
823       _req.id,
824       _req.callbackAddress,
825       _req.callbackFunctionId,
826       _req.nonce,
827       ARGS_VERSION,
828       _req.buf.buf);
829   }
830 
831   /**
832    * @notice Ensures that the fulfillment is valid for this contract
833    * @dev Use if the contract developer prefers methods instead of modifiers for validation
834    * @param _requestId The request ID for fulfillment
835    */
836   function validateChainlinkCallback(bytes32 _requestId)
837     internal
838     recordChainlinkFulfillment(_requestId)
839     // solhint-disable-next-line no-empty-blocks
840   {}
841 
842   /**
843    * @dev Reverts if the sender is not the oracle of the request.
844    * Emits ChainlinkFulfilled event.
845    * @param _requestId The request ID for fulfillment
846    */
847   modifier recordChainlinkFulfillment(bytes32 _requestId) {
848     require(msg.sender == pendingRequests[_requestId], "Source must be the oracle of the request");
849     delete pendingRequests[_requestId];
850     emit ChainlinkFulfilled(_requestId);
851     _;
852   }
853 
854   /**
855    * @dev Reverts if the request is already pending
856    * @param _requestId The request ID for fulfillment
857    */
858   modifier notPendingRequest(bytes32 _requestId) {
859     require(pendingRequests[_requestId] == address(0), "Request is already pending");
860     _;
861   }
862 }
863 
864 interface AggregatorInterface {
865   function latestAnswer() external view returns (int256);
866   function latestTimestamp() external view returns (uint256);
867   function latestRound() external view returns (uint256);
868   function getAnswer(uint256 roundId) external view returns (int256);
869   function getTimestamp(uint256 roundId) external view returns (uint256);
870 
871   event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 timestamp);
872   event NewRound(uint256 indexed roundId, address indexed startedBy);
873 }
874 
875 library SignedSafeMath {
876 
877   /**
878    * @dev Adds two int256s and makes sure the result doesn't overflow. Signed
879    * integers aren't supported by the SafeMath library, thus this method
880    * @param _a The first number to be added
881    * @param _a The second number to be added
882    */
883   function add(int256 _a, int256 _b)
884     internal
885     pure
886     returns (int256)
887   {
888     int256 c = _a + _b;
889     require((_b >= 0 && c >= _a) || (_b < 0 && c < _a), "SignedSafeMath: addition overflow");
890 
891     return c;
892   }
893 }
894 
895 /**
896  * @title Ownable
897  * @dev The Ownable contract has an owner address, and provides basic authorization control
898  * functions, this simplifies the implementation of "user permissions".
899  */
900 contract Ownable {
901   address public owner;
902 
903 
904   event OwnershipRenounced(address indexed previousOwner);
905   event OwnershipTransferred(
906     address indexed previousOwner,
907     address indexed newOwner
908   );
909 
910 
911   /**
912    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
913    * account.
914    */
915   constructor() public {
916     owner = msg.sender;
917   }
918 
919   /**
920    * @dev Throws if called by any account other than the owner.
921    */
922   modifier onlyOwner() {
923     require(msg.sender == owner);
924     _;
925   }
926 
927   /**
928    * @dev Allows the current owner to relinquish control of the contract.
929    * @notice Renouncing to ownership will leave the contract without an owner.
930    * It will not be possible to call the functions with the `onlyOwner`
931    * modifier anymore.
932    */
933   function renounceOwnership() public onlyOwner {
934     emit OwnershipRenounced(owner);
935     owner = address(0);
936   }
937 
938   /**
939    * @dev Allows the current owner to transfer control of the contract to a newOwner.
940    * @param _newOwner The address to transfer ownership to.
941    */
942   function transferOwnership(address _newOwner) public onlyOwner {
943     _transferOwnership(_newOwner);
944   }
945 
946   /**
947    * @dev Transfers control of the contract to a newOwner.
948    * @param _newOwner The address to transfer ownership to.
949    */
950   function _transferOwnership(address _newOwner) internal {
951     require(_newOwner != address(0));
952     emit OwnershipTransferred(owner, _newOwner);
953     owner = _newOwner;
954   }
955 }
956 
957 /**
958  * @title An example Chainlink contract with aggregation
959  * @notice Requesters can use this contract as a framework for creating
960  * requests to multiple Chainlink nodes and running aggregation
961  * as the contract receives answers.
962  */
963 contract Aggregator is AggregatorInterface, ChainlinkClient, Ownable {
964   using SignedSafeMath for int256;
965 
966   struct Answer {
967     uint128 minimumResponses;
968     uint128 maxResponses;
969     int256[] responses;
970   }
971 
972   event ResponseReceived(int256 indexed response, uint256 indexed answerId, address indexed sender);
973 
974   int256 private currentAnswerValue;
975   uint256 private updatedTimestampValue;
976   uint256 private latestCompletedAnswer;
977   uint128 public paymentAmount;
978   uint128 public minimumResponses;
979   bytes32[] public jobIds;
980   address[] public oracles;
981 
982   uint256 private answerCounter = 1;
983   mapping(address => bool) public authorizedRequesters;
984   mapping(bytes32 => uint256) private requestAnswers;
985   mapping(uint256 => Answer) private answers;
986   mapping(uint256 => int256) private currentAnswers;
987   mapping(uint256 => uint256) private updatedTimestamps;
988 
989   uint256 constant private MAX_ORACLE_COUNT = 45;
990 
991   /**
992    * @notice Deploy with the address of the LINK token and arrays of matching
993    * length containing the addresses of the oracles and their corresponding
994    * Job IDs.
995    * @dev Sets the LinkToken address for the network, addresses of the oracles,
996    * and jobIds in storage.
997    * @param _link The address of the LINK token
998    * @param _paymentAmount the amount of LINK to be sent to each oracle for each request
999    * @param _minimumResponses the minimum number of responses
1000    * before an answer will be calculated
1001    * @param _oracles An array of oracle addresses
1002    * @param _jobIds An array of Job IDs
1003    */
1004   constructor(
1005     address _link,
1006     uint128 _paymentAmount,
1007     uint128 _minimumResponses,
1008     address[] _oracles,
1009     bytes32[] _jobIds
1010   ) public Ownable() {
1011     setChainlinkToken(_link);
1012     updateRequestDetails(_paymentAmount, _minimumResponses, _oracles, _jobIds);
1013   }
1014 
1015   /**
1016    * @notice Creates a Chainlink request for each oracle in the oracles array.
1017    * @dev This example does not include request parameters. Reference any documentation
1018    * associated with the Job IDs used to determine the required parameters per-request.
1019    */
1020   function requestRateUpdate()
1021     external
1022     ensureAuthorizedRequester()
1023   {
1024     Chainlink.Request memory request;
1025     bytes32 requestId;
1026     uint256 oraclePayment = paymentAmount;
1027 
1028     for (uint i = 0; i < oracles.length; i++) {
1029       request = buildChainlinkRequest(jobIds[i], this, this.chainlinkCallback.selector);
1030       requestId = sendChainlinkRequestTo(oracles[i], request, oraclePayment);
1031       requestAnswers[requestId] = answerCounter;
1032     }
1033     answers[answerCounter].minimumResponses = minimumResponses;
1034     answers[answerCounter].maxResponses = uint128(oracles.length);
1035     answerCounter = answerCounter.add(1);
1036 
1037     emit NewRound(answerCounter, msg.sender);
1038   }
1039 
1040   /**
1041    * @notice Receives the answer from the Chainlink node.
1042    * @dev This function can only be called by the oracle that received the request.
1043    * @param _clRequestId The Chainlink request ID associated with the answer
1044    * @param _response The answer provided by the Chainlink node
1045    */
1046   function chainlinkCallback(bytes32 _clRequestId, int256 _response)
1047     external
1048   {
1049     validateChainlinkCallback(_clRequestId);
1050 
1051     uint256 answerId = requestAnswers[_clRequestId];
1052     delete requestAnswers[_clRequestId];
1053 
1054     answers[answerId].responses.push(_response);
1055     emit ResponseReceived(_response, answerId, msg.sender);
1056     updateLatestAnswer(answerId);
1057     deleteAnswer(answerId);
1058   }
1059 
1060   /**
1061    * @notice Updates the arrays of oracles and jobIds with new values,
1062    * overwriting the old values.
1063    * @dev Arrays are validated to be equal length.
1064    * @param _paymentAmount the amount of LINK to be sent to each oracle for each request
1065    * @param _minimumResponses the minimum number of responses
1066    * before an answer will be calculated
1067    * @param _oracles An array of oracle addresses
1068    * @param _jobIds An array of Job IDs
1069    */
1070   function updateRequestDetails(
1071     uint128 _paymentAmount,
1072     uint128 _minimumResponses,
1073     address[] _oracles,
1074     bytes32[] _jobIds
1075   )
1076     public
1077     onlyOwner()
1078     validateAnswerRequirements(_minimumResponses, _oracles, _jobIds)
1079   {
1080     paymentAmount = _paymentAmount;
1081     minimumResponses = _minimumResponses;
1082     jobIds = _jobIds;
1083     oracles = _oracles;
1084   }
1085 
1086   /**
1087    * @notice Allows the owner of the contract to withdraw any LINK balance
1088    * available on the contract.
1089    * @dev The contract will need to have a LINK balance in order to create requests.
1090    * @param _recipient The address to receive the LINK tokens
1091    * @param _amount The amount of LINK to send from the contract
1092    */
1093   function transferLINK(address _recipient, uint256 _amount)
1094     public
1095     onlyOwner()
1096   {
1097     LinkTokenInterface linkToken = LinkTokenInterface(chainlinkTokenAddress());
1098     require(linkToken.transfer(_recipient, _amount), "LINK transfer failed");
1099   }
1100 
1101   /**
1102    * @notice Called by the owner to permission other addresses to generate new
1103    * requests to oracles.
1104    * @param _requester the address whose permissions are being set
1105    * @param _allowed boolean that determines whether the requester is
1106    * permissioned or not
1107    */
1108   function setAuthorization(address _requester, bool _allowed)
1109     external
1110     onlyOwner()
1111   {
1112     authorizedRequesters[_requester] = _allowed;
1113   }
1114 
1115   /**
1116    * @notice Cancels an outstanding Chainlink request.
1117    * The oracle contract requires the request ID and additional metadata to
1118    * validate the cancellation. Only old answers can be cancelled.
1119    * @param _requestId is the identifier for the chainlink request being cancelled
1120    * @param _payment is the amount of LINK paid to the oracle for the request
1121    * @param _expiration is the time when the request expires
1122    */
1123   function cancelRequest(
1124     bytes32 _requestId,
1125     uint256 _payment,
1126     uint256 _expiration
1127   )
1128     external
1129     ensureAuthorizedRequester()
1130   {
1131     uint256 answerId = requestAnswers[_requestId];
1132     require(answerId < latestCompletedAnswer, "Cannot modify an in-progress answer");
1133 
1134     delete requestAnswers[_requestId];
1135     answers[answerId].responses.push(0);
1136     deleteAnswer(answerId);
1137 
1138     cancelChainlinkRequest(
1139       _requestId,
1140       _payment,
1141       this.chainlinkCallback.selector,
1142       _expiration
1143     );
1144   }
1145 
1146   /**
1147    * @notice Called by the owner to kill the contract. This transfers all LINK
1148    * balance and ETH balance (if there is any) to the owner.
1149    */
1150   function destroy()
1151     external
1152     onlyOwner()
1153   {
1154     LinkTokenInterface linkToken = LinkTokenInterface(chainlinkTokenAddress());
1155     transferLINK(owner, linkToken.balanceOf(address(this)));
1156     selfdestruct(owner);
1157   }
1158 
1159   /**
1160    * @dev Performs aggregation of the answers received from the Chainlink nodes.
1161    * Assumes that at least half the oracles are honest and so can't contol the
1162    * middle of the ordered responses.
1163    * @param _answerId The answer ID associated with the group of requests
1164    */
1165   function updateLatestAnswer(uint256 _answerId)
1166     private
1167     ensureMinResponsesReceived(_answerId)
1168     ensureOnlyLatestAnswer(_answerId)
1169   {
1170     uint256 responseLength = answers[_answerId].responses.length;
1171     uint256 middleIndex = responseLength.div(2);
1172     int256 currentAnswerTemp;
1173     if (responseLength % 2 == 0) {
1174       int256 median1 = quickselect(answers[_answerId].responses, middleIndex);
1175       int256 median2 = quickselect(answers[_answerId].responses, middleIndex.add(1)); // quickselect is 1 indexed
1176       currentAnswerTemp = median1.add(median2) / 2; // signed integers are not supported by SafeMath
1177     } else {
1178       currentAnswerTemp = quickselect(answers[_answerId].responses, middleIndex.add(1)); // quickselect is 1 indexed
1179     }
1180     currentAnswerValue = currentAnswerTemp;
1181     latestCompletedAnswer = _answerId;
1182     updatedTimestampValue = now;
1183     updatedTimestamps[_answerId] = now;
1184     currentAnswers[_answerId] = currentAnswerTemp;
1185     emit AnswerUpdated(currentAnswerTemp, _answerId, now);
1186   }
1187 
1188   /**
1189    * @notice get the most recently reported answer
1190    */
1191   function latestAnswer()
1192     external
1193     view
1194     returns (int256)
1195   {
1196     return currentAnswers[latestCompletedAnswer];
1197   }
1198 
1199   /**
1200    * @notice get the last updated at block timestamp
1201    */
1202   function latestTimestamp()
1203     external
1204     view
1205     returns (uint256)
1206   {
1207     return updatedTimestamps[latestCompletedAnswer];
1208   }
1209 
1210   /**
1211    * @notice get past rounds answers
1212    * @param _roundId the answer number to retrieve the answer for
1213    */
1214   function getAnswer(uint256 _roundId)
1215     external
1216     view
1217     returns (int256)
1218   {
1219     return currentAnswers[_roundId];
1220   }
1221 
1222   /**
1223    * @notice get block timestamp when an answer was last updated
1224    * @param _roundId the answer number to retrieve the updated timestamp for
1225    */
1226   function getTimestamp(uint256 _roundId)
1227     external
1228     view
1229     returns (uint256)
1230   {
1231     return updatedTimestamps[_roundId];
1232   }
1233 
1234   /**
1235    * @notice get the latest completed round where the answer was updated
1236    */
1237   function latestRound() external view returns (uint256) {
1238     return latestCompletedAnswer;
1239   }
1240 
1241   /**
1242    * @dev Returns the kth value of the ordered array
1243    * See: http://www.cs.yale.edu/homes/aspnes/pinewiki/QuickSelect.html
1244    * @param _a The list of elements to pull from
1245    * @param _k The index, 1 based, of the elements you want to pull from when ordered
1246    */
1247   function quickselect(int256[] memory _a, uint256 _k)
1248     private
1249     pure
1250     returns (int256)
1251   {
1252     int256[] memory a = _a;
1253     uint256 k = _k;
1254     uint256 aLen = a.length;
1255     int256[] memory a1 = new int256[](aLen);
1256     int256[] memory a2 = new int256[](aLen);
1257     uint256 a1Len;
1258     uint256 a2Len;
1259     int256 pivot;
1260     uint256 i;
1261 
1262     while (true) {
1263       pivot = a[aLen.div(2)];
1264       a1Len = 0;
1265       a2Len = 0;
1266       for (i = 0; i < aLen; i++) {
1267         if (a[i] < pivot) {
1268           a1[a1Len] = a[i];
1269           a1Len++;
1270         } else if (a[i] > pivot) {
1271           a2[a2Len] = a[i];
1272           a2Len++;
1273         }
1274       }
1275       if (k <= a1Len) {
1276         aLen = a1Len;
1277         (a, a1) = swap(a, a1);
1278       } else if (k > (aLen.sub(a2Len))) {
1279         k = k.sub(aLen.sub(a2Len));
1280         aLen = a2Len;
1281         (a, a2) = swap(a, a2);
1282       } else {
1283         return pivot;
1284       }
1285     }
1286   }
1287 
1288   /**
1289    * @dev Swaps the pointers to two uint256 arrays in memory
1290    * @param _a The pointer to the first in memory array
1291    * @param _b The pointer to the second in memory array
1292    */
1293   function swap(int256[] memory _a, int256[] memory _b)
1294     private
1295     pure
1296     returns(int256[] memory, int256[] memory)
1297   {
1298     return (_b, _a);
1299   }
1300 
1301   /**
1302    * @dev Cleans up the answer record if all responses have been received.
1303    * @param _answerId The identifier of the answer to be deleted
1304    */
1305   function deleteAnswer(uint256 _answerId)
1306     private
1307     ensureAllResponsesReceived(_answerId)
1308   {
1309     delete answers[_answerId];
1310   }
1311 
1312   /**
1313    * @dev Prevents taking an action if the minimum number of responses has not
1314    * been received for an answer.
1315    * @param _answerId The the identifier of the answer that keeps track of the responses.
1316    */
1317   modifier ensureMinResponsesReceived(uint256 _answerId) {
1318     if (answers[_answerId].responses.length >= answers[_answerId].minimumResponses) {
1319       _;
1320     }
1321   }
1322 
1323   /**
1324    * @dev Prevents taking an action if not all responses are received for an answer.
1325    * @param _answerId The the identifier of the answer that keeps track of the responses.
1326    */
1327   modifier ensureAllResponsesReceived(uint256 _answerId) {
1328     if (answers[_answerId].responses.length == answers[_answerId].maxResponses) {
1329       _;
1330     }
1331   }
1332 
1333   /**
1334    * @dev Prevents taking an action if a newer answer has been recorded.
1335    * @param _answerId The current answer's identifier.
1336    * Answer IDs are in ascending order.
1337    */
1338   modifier ensureOnlyLatestAnswer(uint256 _answerId) {
1339     if (latestCompletedAnswer <= _answerId) {
1340       _;
1341     }
1342   }
1343 
1344   /**
1345    * @dev Ensures corresponding number of oracles and jobs.
1346    * @param _oracles The list of oracles.
1347    * @param _jobIds The list of jobs.
1348    */
1349   modifier validateAnswerRequirements(
1350     uint256 _minimumResponses,
1351     address[] _oracles,
1352     bytes32[] _jobIds
1353   ) {
1354     require(_oracles.length <= MAX_ORACLE_COUNT, "cannot have more than 45 oracles");
1355     require(_oracles.length >= _minimumResponses, "must have at least as many oracles as responses");
1356     require(_oracles.length == _jobIds.length, "must have exactly as many oracles as job IDs");
1357     _;
1358   }
1359 
1360   /**
1361    * @dev Reverts if `msg.sender` is not authorized to make requests.
1362    */
1363   modifier ensureAuthorizedRequester() {
1364     require(authorizedRequesters[msg.sender] || msg.sender == owner, "Not an authorized address for creating requests");
1365     _;
1366   }
1367 
1368 }