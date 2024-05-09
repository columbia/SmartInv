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
378 // File: chainlink/contracts/Chainlink.sol
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
505 // File: chainlink/contracts/ENSResolver.sol
506 
507 pragma solidity 0.4.24;
508 
509 contract ENSResolver {
510   function addr(bytes32 node) public view returns (address);
511 }
512 
513 // File: chainlink/contracts/interfaces/ENSInterface.sol
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
542 // File: chainlink/contracts/interfaces/LinkTokenInterface.sol
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
561 // File: chainlink/contracts/interfaces/ChainlinkRequestInterface.sol
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
585 // File: chainlink/contracts/interfaces/PointerInterface.sol
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
648 // File: chainlink/contracts/ChainlinkClient.sol
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
912 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
913 
914 pragma solidity ^0.4.24;
915 
916 
917 /**
918  * @title Ownable
919  * @dev The Ownable contract has an owner address, and provides basic authorization control
920  * functions, this simplifies the implementation of "user permissions".
921  */
922 contract Ownable {
923   address public owner;
924 
925 
926   event OwnershipRenounced(address indexed previousOwner);
927   event OwnershipTransferred(
928     address indexed previousOwner,
929     address indexed newOwner
930   );
931 
932 
933   /**
934    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
935    * account.
936    */
937   constructor() public {
938     owner = msg.sender;
939   }
940 
941   /**
942    * @dev Throws if called by any account other than the owner.
943    */
944   modifier onlyOwner() {
945     require(msg.sender == owner);
946     _;
947   }
948 
949   /**
950    * @dev Allows the current owner to relinquish control of the contract.
951    * @notice Renouncing to ownership will leave the contract without an owner.
952    * It will not be possible to call the functions with the `onlyOwner`
953    * modifier anymore.
954    */
955   function renounceOwnership() public onlyOwner {
956     emit OwnershipRenounced(owner);
957     owner = address(0);
958   }
959 
960   /**
961    * @dev Allows the current owner to transfer control of the contract to a newOwner.
962    * @param _newOwner The address to transfer ownership to.
963    */
964   function transferOwnership(address _newOwner) public onlyOwner {
965     _transferOwnership(_newOwner);
966   }
967 
968   /**
969    * @dev Transfers control of the contract to a newOwner.
970    * @param _newOwner The address to transfer ownership to.
971    */
972   function _transferOwnership(address _newOwner) internal {
973     require(_newOwner != address(0));
974     emit OwnershipTransferred(owner, _newOwner);
975     owner = _newOwner;
976   }
977 }
978 
979 // File: contracts/AmpleforthInterface.sol
980 
981 pragma solidity 0.4.24;
982 
983 interface AmpleforthInterface {
984   function pushReport(uint256 payload) external;
985   function purgeReports() external;
986 }
987 
988 // File: contracts/AmpleforthConsumer.sol
989 
990 pragma solidity 0.4.24;
991 
992 
993 
994 
995 /**
996  * @title AmpleforthConsumer is a contract which requests data from
997  * the Chainlink network
998  * @dev This contract is designed to work on multiple networks, including
999  * local test networks
1000  */
1001 contract AmpleforthConsumer is ChainlinkClient, Ownable {
1002   bytes32 public id;
1003   uint256 public payment;
1004   int256 public currentAnswer;
1005   uint256 public updatedHeight;
1006   AmpleforthInterface public ample;
1007   mapping(address => bool) public authorizedRequesters;
1008 
1009   /**
1010    * @notice Deploy the contract with a specified address for the LINK
1011    * and Oracle contract addresses
1012    * @dev Sets the storage for the specified addresses
1013    * @param _link The address of the LINK token contract
1014    * @param _oracle The Oracle contract address to send the request to
1015    * @param _ample The Ampleforth contract to call
1016    * @param _id The bytes32 JobID to be executed
1017    * @param _payment The payment to send to the oracle
1018    */
1019   constructor(
1020     address _link,
1021     address _oracle,
1022     address _ample,
1023     bytes32 _id,
1024     uint256 _payment
1025   ) public {
1026     if (_link == address(0)) {
1027       setPublicChainlinkToken();
1028     } else {
1029       setChainlinkToken(_link);
1030     }
1031     _updateRequestDetails(_ample, _oracle, _id, _payment);
1032   }
1033 
1034   function updateRequestDetails(
1035     address _ample,
1036     address _oracle,
1037     bytes32 _id,
1038     uint256 _payment
1039   )
1040     external
1041     onlyOwner()
1042   {
1043     _updateRequestDetails(_ample, _oracle, _id, _payment);
1044   }
1045 
1046   function _updateRequestDetails(
1047     address _ample,
1048     address _oracle,
1049     bytes32 _id,
1050     uint256 _payment
1051   ) private {
1052     require(_ample != address(0) && _oracle != address(0), "Cannot use zero address");
1053     require(!authorizedRequesters[_oracle], "Requester cannot be oracle");
1054     setChainlinkOracle(_oracle);
1055     id = _id;
1056     payment = _payment;
1057     ample = AmpleforthInterface(_ample);
1058   }
1059 
1060   /*
1061    * @notice Creates a request to the stored Oracle contract address
1062    */
1063   function requestPushReport()
1064     external
1065     ensureAuthorizedRequester()
1066     returns (bytes32 requestId)
1067   {
1068     Chainlink.Request memory req = buildChainlinkRequest(id, this, this.fulfillPushReport.selector);
1069     requestId = sendChainlinkRequest(req, payment);
1070   }
1071 
1072   /**
1073    * @notice Calls the Ampleforth contract's pushReport method with the response
1074    * from the oracle
1075    * @param _requestId The ID that was generated for the request
1076    * @param _data The answer provided by the oracle
1077    */
1078   function fulfillPushReport(bytes32 _requestId, int256 _data)
1079     external
1080     recordChainlinkFulfillment(_requestId)
1081   {
1082     currentAnswer = _data;
1083     updatedHeight = block.number;
1084     AmpleforthInterface(ample).pushReport(uint256(_data));
1085   }
1086 
1087   /**
1088    * @notice Calls Ampleforth contract's purge function
1089    */
1090   function purgeReports()
1091     external
1092     onlyOwner()
1093   {
1094     AmpleforthInterface(ample).purgeReports();
1095   }
1096 
1097   /**
1098    * @notice Called by the owner to permission other addresses to generate new
1099    * requests to oracles.
1100    * @param _requester the address whose permissions are being set
1101    * @param _allowed boolean that determines whether the requester is
1102    * permissioned or not
1103    */
1104   function setAuthorization(address _requester, bool _allowed)
1105     public
1106     onlyOwner()
1107   {
1108     require(_requester != getChainlinkOracle(), "Requester cannot be oracle");
1109     authorizedRequesters[_requester] = _allowed;
1110   }
1111 
1112   /**
1113    * @notice Returns the address of the LINK token
1114    * @dev This is the public implementation for chainlinkTokenAddress, which is
1115    * an internal method of the ChainlinkClient contract
1116    */
1117   function getChainlinkToken() public view returns (address) {
1118     return chainlinkTokenAddress();
1119   }
1120 
1121   /**
1122    * @notice Returns the address of the stored oracle contract address
1123    */
1124   function getChainlinkOracle() public view returns (address) {
1125     return chainlinkOracleAddress();
1126   }
1127 
1128   /**
1129    * @notice Allows the owner to withdraw any LINK balance on the contract
1130    */
1131   function withdrawLink() public onlyOwner() {
1132     LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
1133     require(link.transfer(msg.sender, link.balanceOf(address(this))), "Unable to transfer");
1134   }
1135 
1136   /**
1137    * @notice Call this method if no response is received within 5 minutes
1138    * @param _requestId The ID that was generated for the request to cancel
1139    * @param _payment The payment specified for the request to cancel
1140    * @param _callbackFunctionId The bytes4 callback function ID specified for
1141    * the request to cancel
1142    * @param _expiration The expiration generated for the request to cancel
1143    */
1144   function cancelRequest(
1145     bytes32 _requestId,
1146     uint256 _payment,
1147     bytes4 _callbackFunctionId,
1148     uint256 _expiration
1149   )
1150     public
1151     onlyOwner()
1152   {
1153     cancelChainlinkRequest(_requestId, _payment, _callbackFunctionId, _expiration);
1154   }
1155 
1156   /**
1157    * @dev Reverts if `msg.sender` is not authorized to make requests.
1158    */
1159   modifier ensureAuthorizedRequester() {
1160     require(authorizedRequesters[msg.sender] || msg.sender == owner, "Unauthorized to create requests");
1161     _;
1162   }
1163 }