1 // File: @ensdomains/buffer/contracts/Buffer.sol
2 
3 pragma solidity >0.4.18;
4 
5 /**
6 * @dev A library for working with mutable byte buffers in Solidity.
7 *
8 * Byte buffers are mutable and expandable, and provide a variety of primitives
9 * for writing to them. At any time you can fetch a bytes object containing the
10 * current contents of the buffer. The bytes object should not be stored between
11 * operations, as it may change due to resizing of the buffer.
12 */
13 library Buffer {
14     /**
15     * @dev Represents a mutable buffer. Buffers have a current value (buf) and
16     *      a capacity. The capacity may be longer than the current value, in
17     *      which case it can be extended without the need to allocate more memory.
18     */
19     struct buffer {
20         bytes buf;
21         uint capacity;
22     }
23 
24     /**
25     * @dev Initializes a buffer with an initial capacity.
26     * @param buf The buffer to initialize.
27     * @param capacity The number of bytes of space to allocate the buffer.
28     * @return The buffer, for chaining.
29     */
30     function init(buffer memory buf, uint capacity) internal pure returns(buffer memory) {
31         if (capacity % 32 != 0) {
32             capacity += 32 - (capacity % 32);
33         }
34         // Allocate space for the buffer data
35         buf.capacity = capacity;
36         assembly {
37             let ptr := mload(0x40)
38             mstore(buf, ptr)
39             mstore(ptr, 0)
40             mstore(0x40, add(32, add(ptr, capacity)))
41         }
42         return buf;
43     }
44 
45     /**
46     * @dev Initializes a new buffer from an existing bytes object.
47     *      Changes to the buffer may mutate the original value.
48     * @param b The bytes object to initialize the buffer with.
49     * @return A new buffer.
50     */
51     function fromBytes(bytes memory b) internal pure returns(buffer memory) {
52         buffer memory buf;
53         buf.buf = b;
54         buf.capacity = b.length;
55         return buf;
56     }
57 
58     function resize(buffer memory buf, uint capacity) private pure {
59         bytes memory oldbuf = buf.buf;
60         init(buf, capacity);
61         append(buf, oldbuf);
62     }
63 
64     function max(uint a, uint b) private pure returns(uint) {
65         if (a > b) {
66             return a;
67         }
68         return b;
69     }
70 
71     /**
72     * @dev Sets buffer length to 0.
73     * @param buf The buffer to truncate.
74     * @return The original buffer, for chaining..
75     */
76     function truncate(buffer memory buf) internal pure returns (buffer memory) {
77         assembly {
78             let bufptr := mload(buf)
79             mstore(bufptr, 0)
80         }
81         return buf;
82     }
83 
84     /**
85     * @dev Writes a byte string to a buffer. Resizes if doing so would exceed
86     *      the capacity of the buffer.
87     * @param buf The buffer to append to.
88     * @param off The start offset to write to.
89     * @param data The data to append.
90     * @param len The number of bytes to copy.
91     * @return The original buffer, for chaining.
92     */
93     function write(buffer memory buf, uint off, bytes memory data, uint len) internal pure returns(buffer memory) {
94         require(len <= data.length);
95 
96         if (off + len > buf.capacity) {
97             resize(buf, max(buf.capacity, len + off) * 2);
98         }
99 
100         uint dest;
101         uint src;
102         assembly {
103             // Memory address of the buffer data
104             let bufptr := mload(buf)
105             // Length of existing buffer data
106             let buflen := mload(bufptr)
107             // Start address = buffer address + offset + sizeof(buffer length)
108             dest := add(add(bufptr, 32), off)
109             // Update buffer length if we're extending it
110             if gt(add(len, off), buflen) {
111                 mstore(bufptr, add(len, off))
112             }
113             src := add(data, 32)
114         }
115 
116         // Copy word-length chunks while possible
117         for (; len >= 32; len -= 32) {
118             assembly {
119                 mstore(dest, mload(src))
120             }
121             dest += 32;
122             src += 32;
123         }
124 
125         // Copy remaining bytes
126         uint mask = 256 ** (32 - len) - 1;
127         assembly {
128             let srcpart := and(mload(src), not(mask))
129             let destpart := and(mload(dest), mask)
130             mstore(dest, or(destpart, srcpart))
131         }
132 
133         return buf;
134     }
135 
136     /**
137     * @dev Appends a byte string to a buffer. Resizes if doing so would exceed
138     *      the capacity of the buffer.
139     * @param buf The buffer to append to.
140     * @param data The data to append.
141     * @param len The number of bytes to copy.
142     * @return The original buffer, for chaining.
143     */
144     function append(buffer memory buf, bytes memory data, uint len) internal pure returns (buffer memory) {
145         return write(buf, buf.buf.length, data, len);
146     }
147 
148     /**
149     * @dev Appends a byte string to a buffer. Resizes if doing so would exceed
150     *      the capacity of the buffer.
151     * @param buf The buffer to append to.
152     * @param data The data to append.
153     * @return The original buffer, for chaining.
154     */
155     function append(buffer memory buf, bytes memory data) internal pure returns (buffer memory) {
156         return write(buf, buf.buf.length, data, data.length);
157     }
158 
159     /**
160     * @dev Writes a byte to the buffer. Resizes if doing so would exceed the
161     *      capacity of the buffer.
162     * @param buf The buffer to append to.
163     * @param off The offset to write the byte at.
164     * @param data The data to append.
165     * @return The original buffer, for chaining.
166     */
167     function writeUint8(buffer memory buf, uint off, uint8 data) internal pure returns(buffer memory) {
168         if (off >= buf.capacity) {
169             resize(buf, buf.capacity * 2);
170         }
171 
172         assembly {
173             // Memory address of the buffer data
174             let bufptr := mload(buf)
175             // Length of existing buffer data
176             let buflen := mload(bufptr)
177             // Address = buffer address + sizeof(buffer length) + off
178             let dest := add(add(bufptr, off), 32)
179             mstore8(dest, data)
180             // Update buffer length if we extended it
181             if eq(off, buflen) {
182                 mstore(bufptr, add(buflen, 1))
183             }
184         }
185         return buf;
186     }
187 
188     /**
189     * @dev Appends a byte to the buffer. Resizes if doing so would exceed the
190     *      capacity of the buffer.
191     * @param buf The buffer to append to.
192     * @param data The data to append.
193     * @return The original buffer, for chaining.
194     */
195     function appendUint8(buffer memory buf, uint8 data) internal pure returns(buffer memory) {
196         return writeUint8(buf, buf.buf.length, data);
197     }
198 
199     /**
200     * @dev Writes up to 32 bytes to the buffer. Resizes if doing so would
201     *      exceed the capacity of the buffer.
202     * @param buf The buffer to append to.
203     * @param off The offset to write at.
204     * @param data The data to append.
205     * @param len The number of bytes to write (left-aligned).
206     * @return The original buffer, for chaining.
207     */
208     function write(buffer memory buf, uint off, bytes32 data, uint len) private pure returns(buffer memory) {
209         if (len + off > buf.capacity) {
210             resize(buf, (len + off) * 2);
211         }
212 
213         uint mask = 256 ** len - 1;
214         // Right-align data
215         data = data >> (8 * (32 - len));
216         assembly {
217             // Memory address of the buffer data
218             let bufptr := mload(buf)
219             // Address = buffer address + sizeof(buffer length) + off + len
220             let dest := add(add(bufptr, off), len)
221             mstore(dest, or(and(mload(dest), not(mask)), data))
222             // Update buffer length if we extended it
223             if gt(add(off, len), mload(bufptr)) {
224                 mstore(bufptr, add(off, len))
225             }
226         }
227         return buf;
228     }
229 
230     /**
231     * @dev Writes a bytes20 to the buffer. Resizes if doing so would exceed the
232     *      capacity of the buffer.
233     * @param buf The buffer to append to.
234     * @param off The offset to write at.
235     * @param data The data to append.
236     * @return The original buffer, for chaining.
237     */
238     function writeBytes20(buffer memory buf, uint off, bytes20 data) internal pure returns (buffer memory) {
239         return write(buf, off, bytes32(data), 20);
240     }
241 
242     /**
243     * @dev Appends a bytes20 to the buffer. Resizes if doing so would exceed
244     *      the capacity of the buffer.
245     * @param buf The buffer to append to.
246     * @param data The data to append.
247     * @return The original buffer, for chhaining.
248     */
249     function appendBytes20(buffer memory buf, bytes20 data) internal pure returns (buffer memory) {
250         return write(buf, buf.buf.length, bytes32(data), 20);
251     }
252 
253     /**
254     * @dev Appends a bytes32 to the buffer. Resizes if doing so would exceed
255     *      the capacity of the buffer.
256     * @param buf The buffer to append to.
257     * @param data The data to append.
258     * @return The original buffer, for chaining.
259     */
260     function appendBytes32(buffer memory buf, bytes32 data) internal pure returns (buffer memory) {
261         return write(buf, buf.buf.length, data, 32);
262     }
263 
264     /**
265     * @dev Writes an integer to the buffer. Resizes if doing so would exceed
266     *      the capacity of the buffer.
267     * @param buf The buffer to append to.
268     * @param off The offset to write at.
269     * @param data The data to append.
270     * @param len The number of bytes to write (right-aligned).
271     * @return The original buffer, for chaining.
272     */
273     function writeInt(buffer memory buf, uint off, uint data, uint len) private pure returns(buffer memory) {
274         if (len + off > buf.capacity) {
275             resize(buf, (len + off) * 2);
276         }
277 
278         uint mask = 256 ** len - 1;
279         assembly {
280             // Memory address of the buffer data
281             let bufptr := mload(buf)
282             // Address = buffer address + off + sizeof(buffer length) + len
283             let dest := add(add(bufptr, off), len)
284             mstore(dest, or(and(mload(dest), not(mask)), data))
285             // Update buffer length if we extended it
286             if gt(add(off, len), mload(bufptr)) {
287                 mstore(bufptr, add(off, len))
288             }
289         }
290         return buf;
291     }
292 
293     /**
294      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
295      * exceed the capacity of the buffer.
296      * @param buf The buffer to append to.
297      * @param data The data to append.
298      * @return The original buffer.
299      */
300     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
301         return writeInt(buf, buf.buf.length, data, len);
302     }
303 }
304 
305 // File: solidity-cborutils/contracts/CBOR.sol
306 
307 pragma solidity ^0.4.19;
308 
309 
310 library CBOR {
311     using Buffer for Buffer.buffer;
312 
313     uint8 private constant MAJOR_TYPE_INT = 0;
314     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
315     uint8 private constant MAJOR_TYPE_BYTES = 2;
316     uint8 private constant MAJOR_TYPE_STRING = 3;
317     uint8 private constant MAJOR_TYPE_ARRAY = 4;
318     uint8 private constant MAJOR_TYPE_MAP = 5;
319     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
320 
321     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
322         if(value <= 23) {
323             buf.appendUint8(uint8((major << 5) | value));
324         } else if(value <= 0xFF) {
325             buf.appendUint8(uint8((major << 5) | 24));
326             buf.appendInt(value, 1);
327         } else if(value <= 0xFFFF) {
328             buf.appendUint8(uint8((major << 5) | 25));
329             buf.appendInt(value, 2);
330         } else if(value <= 0xFFFFFFFF) {
331             buf.appendUint8(uint8((major << 5) | 26));
332             buf.appendInt(value, 4);
333         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
334             buf.appendUint8(uint8((major << 5) | 27));
335             buf.appendInt(value, 8);
336         }
337     }
338 
339     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
340         buf.appendUint8(uint8((major << 5) | 31));
341     }
342 
343     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
344         encodeType(buf, MAJOR_TYPE_INT, value);
345     }
346 
347     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
348         if(value >= 0) {
349             encodeType(buf, MAJOR_TYPE_INT, uint(value));
350         } else {
351             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
352         }
353     }
354 
355     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
356         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
357         buf.append(value);
358     }
359 
360     function encodeString(Buffer.buffer memory buf, string value) internal pure {
361         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
362         buf.append(bytes(value));
363     }
364 
365     function startArray(Buffer.buffer memory buf) internal pure {
366         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
367     }
368 
369     function startMap(Buffer.buffer memory buf) internal pure {
370         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
371     }
372 
373     function endSequence(Buffer.buffer memory buf) internal pure {
374         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
375     }
376 }
377 
378 // File: contracts/Chainlink.sol
379 
380 pragma solidity 0.4.24;
381 
382 
383 /**
384  * @title Library for common Chainlink functions
385  * @dev Uses imported CBOR library for encoding to buffer
386  */
387 library Chainlink {
388   uint256 internal constant defaultBufferSize = 256;
389 
390   using CBOR for Buffer.buffer;
391 
392   struct Request {
393     bytes32 id;
394     address callbackAddress;
395     bytes4 callbackFunctionId;
396     uint256 nonce;
397     Buffer.buffer buf;
398   }
399 
400   /**
401    * @notice Initializes a Chainlink request
402    * @dev Sets the ID, callback address, and callback function signature on the request
403    * @param self The uninitialized request
404    * @param _id The Job Specification ID
405    * @param _callbackAddress The callback address
406    * @param _callbackFunction The callback function signature
407    * @return The initialized request
408    */
409   function initialize(
410     Request memory self,
411     bytes32 _id,
412     address _callbackAddress,
413     bytes4 _callbackFunction
414   ) internal pure returns (Chainlink.Request memory) {
415     Buffer.init(self.buf, defaultBufferSize);
416     self.id = _id;
417     self.callbackAddress = _callbackAddress;
418     self.callbackFunctionId = _callbackFunction;
419     return self;
420   }
421 
422   /**
423    * @notice Sets the data for the buffer without encoding CBOR on-chain
424    * @dev CBOR can be closed with curly-brackets {} or they can be left off
425    * @param self The initialized request
426    * @param _data The CBOR data
427    */
428   function setBuffer(Request memory self, bytes _data)
429     internal pure
430   {
431     Buffer.init(self.buf, _data.length);
432     Buffer.append(self.buf, _data);
433   }
434 
435   /**
436    * @notice Adds a string value to the request with a given key name
437    * @param self The initialized request
438    * @param _key The name of the key
439    * @param _value The string value to add
440    */
441   function add(Request memory self, string _key, string _value)
442     internal pure
443   {
444     self.buf.encodeString(_key);
445     self.buf.encodeString(_value);
446   }
447 
448   /**
449    * @notice Adds a bytes value to the request with a given key name
450    * @param self The initialized request
451    * @param _key The name of the key
452    * @param _value The bytes value to add
453    */
454   function addBytes(Request memory self, string _key, bytes _value)
455     internal pure
456   {
457     self.buf.encodeString(_key);
458     self.buf.encodeBytes(_value);
459   }
460 
461   /**
462    * @notice Adds a int256 value to the request with a given key name
463    * @param self The initialized request
464    * @param _key The name of the key
465    * @param _value The int256 value to add
466    */
467   function addInt(Request memory self, string _key, int256 _value)
468     internal pure
469   {
470     self.buf.encodeString(_key);
471     self.buf.encodeInt(_value);
472   }
473 
474   /**
475    * @notice Adds a uint256 value to the request with a given key name
476    * @param self The initialized request
477    * @param _key The name of the key
478    * @param _value The uint256 value to add
479    */
480   function addUint(Request memory self, string _key, uint256 _value)
481     internal pure
482   {
483     self.buf.encodeString(_key);
484     self.buf.encodeUInt(_value);
485   }
486 
487   /**
488    * @notice Adds an array of strings to the request with a given key name
489    * @param self The initialized request
490    * @param _key The name of the key
491    * @param _values The array of string values to add
492    */
493   function addStringArray(Request memory self, string _key, string[] memory _values)
494     internal pure
495   {
496     self.buf.encodeString(_key);
497     self.buf.startArray();
498     for (uint256 i = 0; i < _values.length; i++) {
499       self.buf.encodeString(_values[i]);
500     }
501     self.buf.endSequence();
502   }
503 }
504 
505 // File: contracts/ENSResolver.sol
506 
507 pragma solidity 0.4.24;
508 
509 contract ENSResolver {
510   function addr(bytes32 node) public view returns (address);
511 }
512 
513 // File: contracts/interfaces/ENSInterface.sol
514 
515 pragma solidity ^0.4.18;
516 
517 interface ENSInterface {
518 
519     // Logged when the owner of a node assigns a new owner to a subnode.
520     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
521 
522     // Logged when the owner of a node transfers ownership to a new account.
523     event Transfer(bytes32 indexed node, address owner);
524 
525     // Logged when the resolver for a node changes.
526     event NewResolver(bytes32 indexed node, address resolver);
527 
528     // Logged when the TTL of a node changes
529     event NewTTL(bytes32 indexed node, uint64 ttl);
530 
531 
532     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
533     function setResolver(bytes32 node, address resolver) external;
534     function setOwner(bytes32 node, address owner) external;
535     function setTTL(bytes32 node, uint64 ttl) external;
536     function owner(bytes32 node) external view returns (address);
537     function resolver(bytes32 node) external view returns (address);
538     function ttl(bytes32 node) external view returns (uint64);
539 
540 }
541 
542 // File: contracts/interfaces/LinkTokenInterface.sol
543 
544 pragma solidity 0.4.24;
545 
546 interface LinkTokenInterface {
547   function allowance(address owner, address spender) external returns (bool success);
548   function approve(address spender, uint256 value) external returns (bool success);
549   function balanceOf(address owner) external returns (uint256 balance);
550   function decimals() external returns (uint8 decimalPlaces);
551   function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
552   function increaseApproval(address spender, uint256 subtractedValue) external;
553   function name() external returns (string tokenName);
554   function symbol() external returns (string tokenSymbol);
555   function totalSupply() external returns (uint256 totalTokensIssued);
556   function transfer(address to, uint256 value) external returns (bool success);
557   function transferAndCall(address to, uint256 value, bytes data) external returns (bool success);
558   function transferFrom(address from, address to, uint256 value) external returns (bool success);
559 }
560 
561 // File: contracts/interfaces/ChainlinkRequestInterface.sol
562 
563 pragma solidity 0.4.24;
564 
565 interface ChainlinkRequestInterface {
566   function oracleRequest(
567     address sender,
568     uint256 payment,
569     bytes32 id,
570     address callbackAddress,
571     bytes4 callbackFunctionId,
572     uint256 nonce,
573     uint256 version,
574     bytes data
575   ) external;
576 
577   function cancelOracleRequest(
578     bytes32 requestId,
579     uint256 payment,
580     bytes4 callbackFunctionId,
581     uint256 expiration
582   ) external;
583 }
584 
585 // File: contracts/interfaces/PointerInterface.sol
586 
587 pragma solidity 0.4.24;
588 
589 interface PointerInterface {
590   function getAddress() external view returns (address);
591 }
592 
593 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
594 
595 pragma solidity ^0.4.24;
596 
597 
598 /**
599  * @title SafeMath
600  * @dev Math operations with safety checks that throw on error
601  */
602 library SafeMath {
603 
604   /**
605   * @dev Multiplies two numbers, throws on overflow.
606   */
607   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
608     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
609     // benefit is lost if 'b' is also tested.
610     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
611     if (_a == 0) {
612       return 0;
613     }
614 
615     c = _a * _b;
616     assert(c / _a == _b);
617     return c;
618   }
619 
620   /**
621   * @dev Integer division of two numbers, truncating the quotient.
622   */
623   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
624     // assert(_b > 0); // Solidity automatically throws when dividing by 0
625     // uint256 c = _a / _b;
626     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
627     return _a / _b;
628   }
629 
630   /**
631   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
632   */
633   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
634     assert(_b <= _a);
635     return _a - _b;
636   }
637 
638   /**
639   * @dev Adds two numbers, throws on overflow.
640   */
641   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
642     c = _a + _b;
643     assert(c >= _a);
644     return c;
645   }
646 }
647 
648 // File: contracts/ChainlinkClient.sol
649 
650 pragma solidity 0.4.24;
651 
652 
653 
654 
655 
656 
657 
658 
659 /**
660  * @title The ChainlinkClient contract
661  * @notice Contract writers can inherit this contract in order to create requests for the
662  * Chainlink network
663  */
664 contract ChainlinkClient {
665   using Chainlink for Chainlink.Request;
666   using SafeMath for uint256;
667 
668   uint256 constant internal LINK = 10**18;
669   uint256 constant private AMOUNT_OVERRIDE = 0;
670   address constant private SENDER_OVERRIDE = 0x0;
671   uint256 constant private ARGS_VERSION = 1;
672   bytes32 constant private ENS_TOKEN_SUBNAME = keccak256("link");
673   bytes32 constant private ENS_ORACLE_SUBNAME = keccak256("oracle");
674   address constant private LINK_TOKEN_POINTER = 0xC89bD4E1632D3A43CB03AAAd5262cbe4038Bc571;
675 
676   ENSInterface private ens;
677   bytes32 private ensNode;
678   LinkTokenInterface private link;
679   ChainlinkRequestInterface private oracle;
680   uint256 private requests = 1;
681   mapping(bytes32 => address) private pendingRequests;
682 
683   event ChainlinkRequested(bytes32 indexed id);
684   event ChainlinkFulfilled(bytes32 indexed id);
685   event ChainlinkCancelled(bytes32 indexed id);
686 
687   /**
688    * @notice Creates a request that can hold additional parameters
689    * @param _specId The Job Specification ID that the request will be created for
690    * @param _callbackAddress The callback address that the response will be sent to
691    * @param _callbackFunctionSignature The callback function signature to use for the callback address
692    * @return A Chainlink Request struct in memory
693    */
694   function buildChainlinkRequest(
695     bytes32 _specId,
696     address _callbackAddress,
697     bytes4 _callbackFunctionSignature
698   ) internal pure returns (Chainlink.Request memory) {
699     Chainlink.Request memory req;
700     return req.initialize(_specId, _callbackAddress, _callbackFunctionSignature);
701   }
702 
703   /**
704    * @notice Creates a Chainlink request to the stored oracle address
705    * @dev Calls `chainlinkRequestTo` with the stored oracle address
706    * @param _req The initialized Chainlink Request
707    * @param _payment The amount of LINK to send for the request
708    * @return The request ID
709    */
710   function sendChainlinkRequest(Chainlink.Request memory _req, uint256 _payment)
711     internal
712     returns (bytes32)
713   {
714     return sendChainlinkRequestTo(oracle, _req, _payment);
715   }
716 
717   /**
718    * @notice Creates a Chainlink request to the specified oracle address
719    * @dev Generates and stores a request ID, increments the local nonce, and uses `transferAndCall` to
720    * send LINK which creates a request on the target oracle contract.
721    * Emits ChainlinkRequested event.
722    * @param _oracle The address of the oracle for the request
723    * @param _req The initialized Chainlink Request
724    * @param _payment The amount of LINK to send for the request
725    * @return The request ID
726    */
727   function sendChainlinkRequestTo(address _oracle, Chainlink.Request memory _req, uint256 _payment)
728     internal
729     returns (bytes32 requestId)
730   {
731     requestId = keccak256(abi.encodePacked(this, requests));
732     _req.nonce = requests;
733     pendingRequests[requestId] = _oracle;
734     emit ChainlinkRequested(requestId);
735     require(link.transferAndCall(_oracle, _payment, encodeRequest(_req)), "unable to transferAndCall to oracle");
736     requests += 1;
737 
738     return requestId;
739   }
740 
741   /**
742    * @notice Allows a request to be cancelled if it has not been fulfilled
743    * @dev Requires keeping track of the expiration value emitted from the oracle contract.
744    * Deletes the request from the `pendingRequests` mapping.
745    * Emits ChainlinkCancelled event.
746    * @param _requestId The request ID
747    * @param _payment The amount of LINK sent for the request
748    * @param _callbackFunc The callback function specified for the request
749    * @param _expiration The time of the expiration for the request
750    */
751   function cancelChainlinkRequest(
752     bytes32 _requestId,
753     uint256 _payment,
754     bytes4 _callbackFunc,
755     uint256 _expiration
756   )
757     internal
758   {
759     ChainlinkRequestInterface requested = ChainlinkRequestInterface(pendingRequests[_requestId]);
760     delete pendingRequests[_requestId];
761     emit ChainlinkCancelled(_requestId);
762     requested.cancelOracleRequest(_requestId, _payment, _callbackFunc, _expiration);
763   }
764 
765   /**
766    * @notice Sets the stored oracle address
767    * @param _oracle The address of the oracle contract
768    */
769   function setChainlinkOracle(address _oracle) internal {
770     oracle = ChainlinkRequestInterface(_oracle);
771   }
772 
773   /**
774    * @notice Sets the LINK token address
775    * @param _link The address of the LINK token contract
776    */
777   function setChainlinkToken(address _link) internal {
778     link = LinkTokenInterface(_link);
779   }
780 
781   /**
782    * @notice Sets the Chainlink token address for the public
783    * network as given by the Pointer contract
784    */
785   function setPublicChainlinkToken() internal {
786     setChainlinkToken(PointerInterface(LINK_TOKEN_POINTER).getAddress());
787   }
788 
789   /**
790    * @notice Retrieves the stored address of the LINK token
791    * @return The address of the LINK token
792    */
793   function chainlinkTokenAddress()
794     internal
795     view
796     returns (address)
797   {
798     return address(link);
799   }
800 
801   /**
802    * @notice Retrieves the stored address of the oracle contract
803    * @return The address of the oracle contract
804    */
805   function chainlinkOracleAddress()
806     internal
807     view
808     returns (address)
809   {
810     return address(oracle);
811   }
812 
813   /**
814    * @notice Allows for a request which was created on another contract to be fulfilled
815    * on this contract
816    * @param _oracle The address of the oracle contract that will fulfill the request
817    * @param _requestId The request ID used for the response
818    */
819   function addChainlinkExternalRequest(address _oracle, bytes32 _requestId)
820     internal
821     notPendingRequest(_requestId)
822   {
823     pendingRequests[_requestId] = _oracle;
824   }
825 
826   /**
827    * @notice Sets the stored oracle and LINK token contracts with the addresses resolved by ENS
828    * @dev Accounts for subnodes having different resolvers
829    * @param _ens The address of the ENS contract
830    * @param _node The ENS node hash
831    */
832   function useChainlinkWithENS(address _ens, bytes32 _node)
833     internal
834   {
835     ens = ENSInterface(_ens);
836     ensNode = _node;
837     bytes32 linkSubnode = keccak256(abi.encodePacked(ensNode, ENS_TOKEN_SUBNAME));
838     ENSResolver resolver = ENSResolver(ens.resolver(linkSubnode));
839     setChainlinkToken(resolver.addr(linkSubnode));
840     updateChainlinkOracleWithENS();
841   }
842 
843   /**
844    * @notice Sets the stored oracle contract with the address resolved by ENS
845    * @dev This may be called on its own as long as `useChainlinkWithENS` has been called previously
846    */
847   function updateChainlinkOracleWithENS()
848     internal
849   {
850     bytes32 oracleSubnode = keccak256(abi.encodePacked(ensNode, ENS_ORACLE_SUBNAME));
851     ENSResolver resolver = ENSResolver(ens.resolver(oracleSubnode));
852     setChainlinkOracle(resolver.addr(oracleSubnode));
853   }
854 
855   /**
856    * @notice Encodes the request to be sent to the oracle contract
857    * @dev The Chainlink node expects values to be in order for the request to be picked up. Order of types
858    * will be validated in the oracle contract.
859    * @param _req The initialized Chainlink Request
860    * @return The bytes payload for the `transferAndCall` method
861    */
862   function encodeRequest(Chainlink.Request memory _req)
863     private
864     view
865     returns (bytes memory)
866   {
867     return abi.encodeWithSelector(
868       oracle.oracleRequest.selector,
869       SENDER_OVERRIDE, // Sender value - overridden by onTokenTransfer by the requesting contract's address
870       AMOUNT_OVERRIDE, // Amount value - overridden by onTokenTransfer by the actual amount of LINK sent
871       _req.id,
872       _req.callbackAddress,
873       _req.callbackFunctionId,
874       _req.nonce,
875       ARGS_VERSION,
876       _req.buf.buf);
877   }
878 
879   /**
880    * @notice Ensures that the fulfillment is valid for this contract
881    * @dev Use if the contract developer prefers methods instead of modifiers for validation
882    * @param _requestId The request ID for fulfillment
883    */
884   function validateChainlinkCallback(bytes32 _requestId)
885     internal
886     recordChainlinkFulfillment(_requestId)
887     // solium-disable-next-line no-empty-blocks
888   {}
889 
890   /**
891    * @dev Reverts if the sender is not the oracle of the request.
892    * Emits ChainlinkFulfilled event.
893    * @param _requestId The request ID for fulfillment
894    */
895   modifier recordChainlinkFulfillment(bytes32 _requestId) {
896     require(msg.sender == pendingRequests[_requestId], "Source must be the oracle of the request");
897     delete pendingRequests[_requestId];
898     emit ChainlinkFulfilled(_requestId);
899     _;
900   }
901 
902   /**
903    * @dev Reverts if the request is already pending
904    * @param _requestId The request ID for fulfillment
905    */
906   modifier notPendingRequest(bytes32 _requestId) {
907     require(pendingRequests[_requestId] == address(0), "Request is already pending");
908     _;
909   }
910 }
911 
912 // File: contracts/SignedSafeMath.sol
913 
914 pragma solidity 0.4.24;
915 
916 library SignedSafeMath {
917 
918   /**
919    * @dev Adds two int256s and makes sure the result doesn't overflow. Signed 
920    * integers aren't supported by the SafeMath library, thus this method
921    * @param _a The first number to be added
922    * @param _a The second number to be added
923    */
924   function add(int256 _a, int256 _b)
925     internal
926     pure
927     returns (int256)
928   {
929     // solium-disable-next-line zeppelin/no-arithmetic-operations
930     int256 c = _a + _b;
931     require((_b >= 0 && c >= _a) || (_b < 0 && c < _a), "SignedSafeMath: addition overflow");
932 
933     return c;
934   }
935 }
936 
937 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
938 
939 pragma solidity ^0.4.24;
940 
941 
942 /**
943  * @title Ownable
944  * @dev The Ownable contract has an owner address, and provides basic authorization control
945  * functions, this simplifies the implementation of "user permissions".
946  */
947 contract Ownable {
948   address public owner;
949 
950 
951   event OwnershipRenounced(address indexed previousOwner);
952   event OwnershipTransferred(
953     address indexed previousOwner,
954     address indexed newOwner
955   );
956 
957 
958   /**
959    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
960    * account.
961    */
962   constructor() public {
963     owner = msg.sender;
964   }
965 
966   /**
967    * @dev Throws if called by any account other than the owner.
968    */
969   modifier onlyOwner() {
970     require(msg.sender == owner);
971     _;
972   }
973 
974   /**
975    * @dev Allows the current owner to relinquish control of the contract.
976    * @notice Renouncing to ownership will leave the contract without an owner.
977    * It will not be possible to call the functions with the `onlyOwner`
978    * modifier anymore.
979    */
980   function renounceOwnership() public onlyOwner {
981     emit OwnershipRenounced(owner);
982     owner = address(0);
983   }
984 
985   /**
986    * @dev Allows the current owner to transfer control of the contract to a newOwner.
987    * @param _newOwner The address to transfer ownership to.
988    */
989   function transferOwnership(address _newOwner) public onlyOwner {
990     _transferOwnership(_newOwner);
991   }
992 
993   /**
994    * @dev Transfers control of the contract to a newOwner.
995    * @param _newOwner The address to transfer ownership to.
996    */
997   function _transferOwnership(address _newOwner) internal {
998     require(_newOwner != address(0));
999     emit OwnershipTransferred(owner, _newOwner);
1000     owner = _newOwner;
1001   }
1002 }
1003 
1004 // File: contracts/Aggregator.sol
1005 
1006 pragma solidity 0.4.24;
1007 
1008 
1009 
1010 
1011 /**
1012  * @title An example Chainlink contract with aggregation
1013  * @notice Requesters can use this contract as a framework for creating
1014  * requests to multiple Chainlink nodes and running aggregation
1015  * as the contract receives answers.
1016  */
1017 contract Aggregator is ChainlinkClient, Ownable {
1018   using SignedSafeMath for int256;
1019 
1020   struct Answer {
1021     uint128 minimumResponses;
1022     uint128 maxResponses;
1023     int256[] responses;
1024   }
1025 
1026   event ResponseReceived(int256 indexed response, uint256 indexed answerId, address indexed sender);
1027   event AnswerUpdated(int256 indexed current, uint256 indexed answerId);
1028 
1029   int256 public currentAnswer;
1030   uint256 public latestCompletedAnswer;
1031   uint256 public updatedHeight;
1032   uint128 public paymentAmount;
1033   uint128 public minimumResponses;
1034   bytes32[] public jobIds;
1035   address[] public oracles;
1036 
1037   uint256 private answerCounter = 1;
1038   mapping(address => bool) public authorizedRequesters;
1039   mapping(bytes32 => uint256) private requestAnswers;
1040   mapping(uint256 => Answer) private answers;
1041 
1042   uint256 constant private MAX_ORACLE_COUNT = 45;
1043 
1044   /**
1045    * @notice Deploy with the address of the LINK token and arrays of matching
1046    * length containing the addresses of the oracles and their corresponding
1047    * Job IDs.
1048    * @dev Sets the LinkToken address for the network, addresses of the oracles,
1049    * and jobIds in storage.
1050    * @param _link The address of the LINK token
1051    * @param _paymentAmount the amount of LINK to be sent to each oracle for each request
1052    * @param _minimumResponses the minimum number of responses
1053    * before an answer will be calculated
1054    * @param _oracles An array of oracle addresses
1055    * @param _jobIds An array of Job IDs
1056    */
1057   constructor(
1058     address _link,
1059     uint128 _paymentAmount,
1060     uint128 _minimumResponses,
1061     address[] _oracles,
1062     bytes32[] _jobIds
1063   )
1064     public
1065     Ownable()
1066   {
1067     setChainlinkToken(_link);
1068     updateRequestDetails(_paymentAmount, _minimumResponses, _oracles, _jobIds);
1069   }
1070 
1071   /**
1072    * @notice Creates a Chainlink request for each oracle in the oracles array.
1073    * @dev This example does not include request parameters. Reference any documentation
1074    * associated with the Job IDs used to determine the required parameters per-request.
1075    */
1076   function requestRateUpdate()
1077     external
1078     ensureAuthorizedRequester()
1079   {
1080     Chainlink.Request memory request;
1081     bytes32 requestId;
1082     uint256 oraclePayment = paymentAmount;
1083 
1084     for (uint i = 0; i < oracles.length; i++) {
1085       request = buildChainlinkRequest(jobIds[i], this, this.chainlinkCallback.selector);
1086       requestId = sendChainlinkRequestTo(oracles[i], request, oraclePayment);
1087       requestAnswers[requestId] = answerCounter;
1088     }
1089     answers[answerCounter].minimumResponses = minimumResponses;
1090     answers[answerCounter].maxResponses = uint128(oracles.length);
1091     answerCounter = answerCounter.add(1);
1092   }
1093 
1094   /**
1095    * @notice Receives the answer from the Chainlink node.
1096    * @dev This function can only be called by the oracle that received the request.
1097    * @param _clRequestId The Chainlink request ID associated with the answer
1098    * @param _response The answer provided by the Chainlink node
1099    */
1100   function chainlinkCallback(bytes32 _clRequestId, int256 _response)
1101     external
1102   {
1103     validateChainlinkCallback(_clRequestId);
1104 
1105     uint256 answerId = requestAnswers[_clRequestId];
1106     delete requestAnswers[_clRequestId];
1107 
1108     answers[answerId].responses.push(_response);
1109     emit ResponseReceived(_response, answerId, msg.sender);
1110     updateLatestAnswer(answerId);
1111     deleteAnswer(answerId);
1112   }
1113 
1114   /**
1115    * @notice Updates the arrays of oracles and jobIds with new values,
1116    * overwriting the old values.
1117    * @dev Arrays are validated to be equal length.
1118    * @param _paymentAmount the amount of LINK to be sent to each oracle for each request
1119    * @param _minimumResponses the minimum number of responses
1120    * before an answer will be calculated
1121    * @param _oracles An array of oracle addresses
1122    * @param _jobIds An array of Job IDs
1123    */
1124   function updateRequestDetails(
1125     uint128 _paymentAmount,
1126     uint128 _minimumResponses,
1127     address[] _oracles,
1128     bytes32[] _jobIds
1129   )
1130     public
1131     onlyOwner()
1132     validateAnswerRequirements(_minimumResponses, _oracles, _jobIds)
1133   {
1134     paymentAmount = _paymentAmount;
1135     minimumResponses = _minimumResponses;
1136     jobIds = _jobIds;
1137     oracles = _oracles;
1138   }
1139 
1140   /**
1141    * @notice Allows the owner of the contract to withdraw any LINK balance
1142    * available on the contract.
1143    * @dev The contract will need to have a LINK balance in order to create requests.
1144    * @param _recipient The address to receive the LINK tokens
1145    * @param _amount The amount of LINK to send from the contract
1146    */
1147   function transferLINK(address _recipient, uint256 _amount)
1148     public
1149     onlyOwner()
1150   {
1151     LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
1152     require(link.transfer(_recipient, _amount), "LINK transfer failed");
1153   }
1154 
1155   /**
1156    * @notice Called by the owner to permission other addresses to generate new
1157    * requests to oracles.
1158    * @param _requester the address whose permissions are being set
1159    * @param _allowed boolean that determines whether the requester is
1160    * permissioned or not
1161    */
1162   function setAuthorization(address _requester, bool _allowed)
1163     external
1164     onlyOwner()
1165   {
1166     authorizedRequesters[_requester] = _allowed;
1167   }
1168 
1169   /**
1170    * @notice Cancels an outstanding Chainlink request.
1171    * The oracle contract requires the request ID and additional metadata to
1172    * validate the cancellation. Only old answers can be cancelled.
1173    * @param _requestId is the identifier for the chainlink request being cancelled
1174    * @param _payment is the amount of LINK paid to the oracle for the request
1175    * @param _expiration is the time when the request expires
1176    */
1177   function cancelRequest(
1178     bytes32 _requestId,
1179     uint256 _payment,
1180     uint256 _expiration
1181   )
1182     external
1183     ensureAuthorizedRequester()
1184   {
1185     uint256 answerId = requestAnswers[_requestId];
1186     require(answerId < latestCompletedAnswer, "Cannot modify an in-progress answer");
1187 
1188     cancelChainlinkRequest(
1189       _requestId,
1190       _payment,
1191       this.chainlinkCallback.selector,
1192       _expiration
1193     );
1194 
1195     delete requestAnswers[_requestId];
1196     answers[answerId].responses.push(0);
1197     deleteAnswer(answerId);
1198   }
1199 
1200   /**
1201    * @notice Called by the owner to kill the contract. This transfers all LINK
1202    * balance and ETH balance (if there is any) to the owner.
1203    */
1204   function destroy()
1205     external
1206     onlyOwner()
1207   {
1208     LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
1209     transferLINK(owner, link.balanceOf(address(this)));
1210     selfdestruct(owner);
1211   }
1212 
1213   /**
1214    * @dev Performs aggregation of the answers received from the Chainlink nodes.
1215    * Assumes that at least half the oracles are honest and so can't contol the
1216    * middle of the ordered responses.
1217    * @param _answerId The answer ID associated with the group of requests
1218    */
1219   function updateLatestAnswer(uint256 _answerId)
1220     private
1221     ensureMinResponsesReceived(_answerId)
1222     ensureOnlyLatestAnswer(_answerId)
1223   {
1224     uint256 responseLength = answers[_answerId].responses.length;
1225     uint256 middleIndex = responseLength.div(2);
1226     if (responseLength % 2 == 0) {
1227       int256 median1 = quickselect(answers[_answerId].responses, middleIndex);
1228       int256 median2 = quickselect(answers[_answerId].responses, middleIndex.add(1)); // quickselect is 1 indexed
1229       // solium-disable-next-line zeppelin/no-arithmetic-operations
1230       currentAnswer = median1.add(median2) / 2; // signed integers are not supported by SafeMath
1231     } else {
1232       currentAnswer = quickselect(answers[_answerId].responses, middleIndex.add(1)); // quickselect is 1 indexed
1233     }
1234     latestCompletedAnswer = _answerId;
1235     updatedHeight = block.number;
1236     emit AnswerUpdated(currentAnswer, _answerId);
1237   }
1238 
1239   /**
1240    * @dev Returns the kth value of the ordered array
1241    * See: http://www.cs.yale.edu/homes/aspnes/pinewiki/QuickSelect.html
1242    * @param _a The list of elements to pull from
1243    * @param _k The index, 1 based, of the elements you want to pull from when ordered
1244    */
1245   function quickselect(int256[] memory _a, uint256 _k)
1246     private
1247     pure
1248     returns (int256)
1249   {
1250     int256[] memory a = _a;
1251     uint256 k = _k;
1252     uint256 aLen = a.length;
1253     int256[] memory a1 = new int256[](aLen);
1254     int256[] memory a2 = new int256[](aLen);
1255     uint256 a1Len;
1256     uint256 a2Len;
1257     int256 pivot;
1258     uint256 i;
1259 
1260     while (true) {
1261       pivot = a[aLen.div(2)];
1262       a1Len = 0;
1263       a2Len = 0;
1264       for (i = 0; i < aLen; i++) {
1265         if (a[i] < pivot) {
1266           a1[a1Len] = a[i];
1267           a1Len++;
1268         } else if (a[i] > pivot) {
1269           a2[a2Len] = a[i];
1270           a2Len++;
1271         }
1272       }
1273       if (k <= a1Len) {
1274         aLen = a1Len;
1275         (a, a1) = swap(a, a1);
1276       } else if (k > (aLen.sub(a2Len))) {
1277         k = k.sub(aLen.sub(a2Len));
1278         aLen = a2Len;
1279         (a, a2) = swap(a, a2);
1280       } else {
1281         return pivot;
1282       }
1283     }
1284   }
1285 
1286   /**
1287    * @dev Swaps the pointers to two uint256 arrays in memory
1288    * @param _a The pointer to the first in memory array
1289    * @param _b The pointer to the second in memory array
1290    */
1291   function swap(int256[] memory _a, int256[] memory _b)
1292     private
1293     pure
1294     returns(int256[] memory, int256[] memory)
1295   {
1296     return (_b, _a);
1297   }
1298 
1299   /**
1300    * @dev Cleans up the answer record if all responses have been received.
1301    * @param _answerId The identifier of the answer to be deleted
1302    */
1303   function deleteAnswer(uint256 _answerId)
1304     private
1305     ensureAllResponsesReceived(_answerId)
1306   {
1307     delete answers[_answerId];
1308   }
1309 
1310   /**
1311    * @dev Prevents taking an action if the minimum number of responses has not
1312    * been received for an answer.
1313    * @param _answerId The the identifier of the answer that keeps track of the responses.
1314    */
1315   modifier ensureMinResponsesReceived(uint256 _answerId) {
1316     if (answers[_answerId].responses.length >= answers[_answerId].minimumResponses) {
1317       _;
1318     }
1319   }
1320 
1321   /**
1322    * @dev Prevents taking an action if not all responses are received for an answer.
1323    * @param _answerId The the identifier of the answer that keeps track of the responses.
1324    */
1325   modifier ensureAllResponsesReceived(uint256 _answerId) {
1326     if (answers[_answerId].responses.length == answers[_answerId].maxResponses) {
1327       _;
1328     }
1329   }
1330 
1331   /**
1332    * @dev Prevents taking an action if a newer answer has been recorded.
1333    * @param _answerId The current answer's identifier.
1334    * Answer IDs are in ascending order.
1335    */
1336   modifier ensureOnlyLatestAnswer(uint256 _answerId) {
1337     if (latestCompletedAnswer <= _answerId) {
1338       _;
1339     }
1340   }
1341 
1342   /**
1343    * @dev Ensures corresponding number of oracles and jobs.
1344    * @param _oracles The list of oracles.
1345    * @param _jobIds The list of jobs.
1346    */
1347   modifier validateAnswerRequirements(
1348     uint256 _minimumResponses,
1349     address[] _oracles,
1350     bytes32[] _jobIds
1351   ) {
1352     require(_oracles.length <= MAX_ORACLE_COUNT, "cannot have more than 45 oracles");
1353     require(_oracles.length >= _minimumResponses, "must have at least as many oracles as responses");
1354     require(_oracles.length == _jobIds.length, "must have exactly as many oracles as job IDs");
1355     _;
1356   }
1357 
1358   /**
1359    * @dev Reverts if `msg.sender` is not authorized to make requests.
1360    */
1361   modifier ensureAuthorizedRequester() {
1362     require(authorizedRequesters[msg.sender] || msg.sender == owner, "Not an authorized address for creating requests");
1363     _;
1364   }
1365 
1366 }