1 // File: @ensdomains/ens/contracts/ENS.sol
2 
3 pragma solidity >=0.4.24;
4 
5 interface ENS {
6 
7     // Logged when the owner of a node assigns a new owner to a subnode.
8     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
9 
10     // Logged when the owner of a node transfers ownership to a new account.
11     event Transfer(bytes32 indexed node, address owner);
12 
13     // Logged when the resolver for a node changes.
14     event NewResolver(bytes32 indexed node, address resolver);
15 
16     // Logged when the TTL of a node changes
17     event NewTTL(bytes32 indexed node, uint64 ttl);
18 
19 
20     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
21     function setResolver(bytes32 node, address resolver) external;
22     function setOwner(bytes32 node, address owner) external;
23     function setTTL(bytes32 node, uint64 ttl) external;
24     function owner(bytes32 node) external view returns (address);
25     function resolver(bytes32 node) external view returns (address);
26     function ttl(bytes32 node) external view returns (uint64);
27 
28 }
29 
30 // File: @ensdomains/ens/contracts/Deed.sol
31 
32 pragma solidity >=0.4.24;
33 
34 interface Deed {
35 
36     function setOwner(address payable newOwner) external;
37     function setRegistrar(address newRegistrar) external;
38     function setBalance(uint newValue, bool throwOnFailure) external;
39     function closeDeed(uint refundRatio) external;
40     function destroyDeed() external;
41 
42     function owner() external view returns (address);
43     function previousOwner() external view returns (address);
44     function value() external view returns (uint);
45     function creationDate() external view returns (uint);
46 
47 }
48 
49 // File: @ensdomains/ens/contracts/Registrar.sol
50 
51 pragma solidity >=0.4.24;
52 
53 
54 interface Registrar {
55 
56     enum Mode { Open, Auction, Owned, Forbidden, Reveal, NotYetAvailable }
57 
58     event AuctionStarted(bytes32 indexed hash, uint registrationDate);
59     event NewBid(bytes32 indexed hash, address indexed bidder, uint deposit);
60     event BidRevealed(bytes32 indexed hash, address indexed owner, uint value, uint8 status);
61     event HashRegistered(bytes32 indexed hash, address indexed owner, uint value, uint registrationDate);
62     event HashReleased(bytes32 indexed hash, uint value);
63     event HashInvalidated(bytes32 indexed hash, string indexed name, uint value, uint registrationDate);
64 
65     function state(bytes32 _hash) external view returns (Mode);
66     function startAuction(bytes32 _hash) external;
67     function startAuctions(bytes32[] calldata _hashes) external;
68     function newBid(bytes32 sealedBid) external payable;
69     function startAuctionsAndBid(bytes32[] calldata hashes, bytes32 sealedBid) external payable;
70     function unsealBid(bytes32 _hash, uint _value, bytes32 _salt) external;
71     function cancelBid(address bidder, bytes32 seal) external;
72     function finalizeAuction(bytes32 _hash) external;
73     function transfer(bytes32 _hash, address payable newOwner) external;
74     function releaseDeed(bytes32 _hash) external;
75     function invalidateName(string calldata unhashedName) external;
76     function eraseNode(bytes32[] calldata labels) external;
77     function transferRegistrars(bytes32 _hash) external;
78     function acceptRegistrarTransfer(bytes32 hash, Deed deed, uint registrationDate) external;
79     function entries(bytes32 _hash) external view returns (Mode, address, uint, uint, uint);
80 }
81 
82 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
83 
84 pragma solidity ^0.5.0;
85 
86 /**
87  * @title IERC165
88  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
89  */
90 interface IERC165 {
91     /**
92      * @notice Query if a contract implements an interface
93      * @param interfaceId The interface identifier, as specified in ERC-165
94      * @dev Interface identification is specified in ERC-165. This function
95      * uses less than 30,000 gas.
96      */
97     function supportsInterface(bytes4 interfaceId) external view returns (bool);
98 }
99 
100 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
101 
102 pragma solidity ^0.5.0;
103 
104 
105 /**
106  * @title ERC721 Non-Fungible Token Standard basic interface
107  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
108  */
109 contract IERC721 is IERC165 {
110     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
111     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
112     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
113 
114     function balanceOf(address owner) public view returns (uint256 balance);
115     function ownerOf(uint256 tokenId) public view returns (address owner);
116 
117     function approve(address to, uint256 tokenId) public;
118     function getApproved(uint256 tokenId) public view returns (address operator);
119 
120     function setApprovalForAll(address operator, bool _approved) public;
121     function isApprovedForAll(address owner, address operator) public view returns (bool);
122 
123     function transferFrom(address from, address to, uint256 tokenId) public;
124     function safeTransferFrom(address from, address to, uint256 tokenId) public;
125 
126     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
127 }
128 
129 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
130 
131 pragma solidity ^0.5.0;
132 
133 /**
134  * @title Ownable
135  * @dev The Ownable contract has an owner address, and provides basic authorization control
136  * functions, this simplifies the implementation of "user permissions".
137  */
138 contract Ownable {
139     address private _owner;
140 
141     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
142 
143     /**
144      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
145      * account.
146      */
147     constructor () internal {
148         _owner = msg.sender;
149         emit OwnershipTransferred(address(0), _owner);
150     }
151 
152     /**
153      * @return the address of the owner.
154      */
155     function owner() public view returns (address) {
156         return _owner;
157     }
158 
159     /**
160      * @dev Throws if called by any account other than the owner.
161      */
162     modifier onlyOwner() {
163         require(isOwner());
164         _;
165     }
166 
167     /**
168      * @return true if `msg.sender` is the owner of the contract.
169      */
170     function isOwner() public view returns (bool) {
171         return msg.sender == _owner;
172     }
173 
174     /**
175      * @dev Allows the current owner to relinquish control of the contract.
176      * @notice Renouncing to ownership will leave the contract without an owner.
177      * It will not be possible to call the functions with the `onlyOwner`
178      * modifier anymore.
179      */
180     function renounceOwnership() public onlyOwner {
181         emit OwnershipTransferred(_owner, address(0));
182         _owner = address(0);
183     }
184 
185     /**
186      * @dev Allows the current owner to transfer control of the contract to a newOwner.
187      * @param newOwner The address to transfer ownership to.
188      */
189     function transferOwnership(address newOwner) public onlyOwner {
190         _transferOwnership(newOwner);
191     }
192 
193     /**
194      * @dev Transfers control of the contract to a newOwner.
195      * @param newOwner The address to transfer ownership to.
196      */
197     function _transferOwnership(address newOwner) internal {
198         require(newOwner != address(0));
199         emit OwnershipTransferred(_owner, newOwner);
200         _owner = newOwner;
201     }
202 }
203 
204 // File: contracts/BaseRegistrar.sol
205 
206 pragma solidity >=0.4.24;
207 
208 
209 
210 
211 
212 contract BaseRegistrar is IERC721, Ownable {
213     uint constant public GRACE_PERIOD = 90 days;
214 
215     event ControllerAdded(address indexed controller);
216     event ControllerRemoved(address indexed controller);
217     event NameMigrated(uint256 indexed id, address indexed owner, uint expires);
218     event NameRegistered(uint256 indexed id, address indexed owner, uint expires);
219     event NameRenewed(uint256 indexed id, uint expires);
220 
221     // Expiration timestamp for migrated domains.
222     uint public transferPeriodEnds;
223 
224     // The ENS registry
225     ENS public ens;
226 
227     // The namehash of the TLD this registrar owns (eg, .eth)
228     bytes32 public baseNode;
229 
230     // The interim registrar
231     Registrar public previousRegistrar;
232 
233     // A map of addresses that are authorised to register and renew names.
234     mapping(address=>bool) public controllers;
235 
236     // Authorises a controller, who can register and renew domains.
237     function addController(address controller) external;
238 
239     // Revoke controller permission for an address.
240     function removeController(address controller) external;
241 
242     // Set the resolver for the TLD this registrar manages.
243     function setResolver(address resolver) external;
244 
245     // Returns the expiration timestamp of the specified label hash.
246     function nameExpires(uint256 id) external view returns(uint);
247 
248     // Returns true iff the specified name is available for registration.
249     function available(uint256 id) public view returns(bool);
250 
251     /**
252      * @dev Register a name.
253      */
254     function register(uint256 id, address owner, uint duration) external returns(uint);
255 
256     function renew(uint256 id, uint duration) external returns(uint);
257 
258     /**
259      * @dev Reclaim ownership of a name in ENS, if you own it in the registrar.
260      */
261     function reclaim(uint256 id, address owner) external;
262 
263     /**
264      * @dev Transfers a registration from the initial registrar.
265      * This function is called by the initial registrar when a user calls `transferRegistrars`.
266      */
267     function acceptRegistrarTransfer(bytes32 label, Deed deed, uint) external;
268 }
269 
270 // File: contracts/StringUtils.sol
271 
272 pragma solidity >=0.4.24;
273 
274 library StringUtils {
275     /**
276      * @dev Returns the length of a given string
277      *
278      * @param s The string to measure the length of
279      * @return The length of the input string
280      */
281     function strlen(string memory s) internal pure returns (uint) {
282         uint len;
283         uint i = 0;
284         uint bytelength = bytes(s).length;
285         for(len = 0; i < bytelength; len++) {
286             byte b = bytes(s)[i];
287             if(b < 0x80) {
288                 i += 1;
289             } else if (b < 0xE0) {
290                 i += 2;
291             } else if (b < 0xF0) {
292                 i += 3;
293             } else if (b < 0xF8) {
294                 i += 4;
295             } else if (b < 0xFC) {
296                 i += 5;
297             } else {
298                 i += 6;
299             }
300         }
301         return len;
302     }
303 }
304 
305 // File: contracts/PriceOracle.sol
306 
307 pragma solidity >=0.4.24;
308 
309 interface PriceOracle {
310     /**
311      * @dev Returns the price to register or renew a name.
312      * @param name The name being registered or renewed.
313      * @param expires When the name presently expires (0 if this is a new registration).
314      * @param duration How long the name is being registered or extended for, in seconds.
315      * @return The price of this renewal or registration, in wei.
316      */
317     function price(string calldata name, uint expires, uint duration) external view returns(uint);
318 }
319 
320 // File: @ensdomains/buffer/contracts/Buffer.sol
321 
322 pragma solidity >0.4.18;
323 
324 /**
325 * @dev A library for working with mutable byte buffers in Solidity.
326 *
327 * Byte buffers are mutable and expandable, and provide a variety of primitives
328 * for writing to them. At any time you can fetch a bytes object containing the
329 * current contents of the buffer. The bytes object should not be stored between
330 * operations, as it may change due to resizing of the buffer.
331 */
332 library Buffer {
333     /**
334     * @dev Represents a mutable buffer. Buffers have a current value (buf) and
335     *      a capacity. The capacity may be longer than the current value, in
336     *      which case it can be extended without the need to allocate more memory.
337     */
338     struct buffer {
339         bytes buf;
340         uint capacity;
341     }
342 
343     /**
344     * @dev Initializes a buffer with an initial capacity.
345     * @param buf The buffer to initialize.
346     * @param capacity The number of bytes of space to allocate the buffer.
347     * @return The buffer, for chaining.
348     */
349     function init(buffer memory buf, uint capacity) internal pure returns(buffer memory) {
350         if (capacity % 32 != 0) {
351             capacity += 32 - (capacity % 32);
352         }
353         // Allocate space for the buffer data
354         buf.capacity = capacity;
355         assembly {
356             let ptr := mload(0x40)
357             mstore(buf, ptr)
358             mstore(ptr, 0)
359             mstore(0x40, add(32, add(ptr, capacity)))
360         }
361         return buf;
362     }
363 
364     /**
365     * @dev Initializes a new buffer from an existing bytes object.
366     *      Changes to the buffer may mutate the original value.
367     * @param b The bytes object to initialize the buffer with.
368     * @return A new buffer.
369     */
370     function fromBytes(bytes memory b) internal pure returns(buffer memory) {
371         buffer memory buf;
372         buf.buf = b;
373         buf.capacity = b.length;
374         return buf;
375     }
376 
377     function resize(buffer memory buf, uint capacity) private pure {
378         bytes memory oldbuf = buf.buf;
379         init(buf, capacity);
380         append(buf, oldbuf);
381     }
382 
383     function max(uint a, uint b) private pure returns(uint) {
384         if (a > b) {
385             return a;
386         }
387         return b;
388     }
389 
390     /**
391     * @dev Sets buffer length to 0.
392     * @param buf The buffer to truncate.
393     * @return The original buffer, for chaining..
394     */
395     function truncate(buffer memory buf) internal pure returns (buffer memory) {
396         assembly {
397             let bufptr := mload(buf)
398             mstore(bufptr, 0)
399         }
400         return buf;
401     }
402 
403     /**
404     * @dev Writes a byte string to a buffer. Resizes if doing so would exceed
405     *      the capacity of the buffer.
406     * @param buf The buffer to append to.
407     * @param off The start offset to write to.
408     * @param data The data to append.
409     * @param len The number of bytes to copy.
410     * @return The original buffer, for chaining.
411     */
412     function write(buffer memory buf, uint off, bytes memory data, uint len) internal pure returns(buffer memory) {
413         require(len <= data.length);
414 
415         if (off + len > buf.capacity) {
416             resize(buf, max(buf.capacity, len + off) * 2);
417         }
418 
419         uint dest;
420         uint src;
421         assembly {
422             // Memory address of the buffer data
423             let bufptr := mload(buf)
424             // Length of existing buffer data
425             let buflen := mload(bufptr)
426             // Start address = buffer address + offset + sizeof(buffer length)
427             dest := add(add(bufptr, 32), off)
428             // Update buffer length if we're extending it
429             if gt(add(len, off), buflen) {
430                 mstore(bufptr, add(len, off))
431             }
432             src := add(data, 32)
433         }
434 
435         // Copy word-length chunks while possible
436         for (; len >= 32; len -= 32) {
437             assembly {
438                 mstore(dest, mload(src))
439             }
440             dest += 32;
441             src += 32;
442         }
443 
444         // Copy remaining bytes
445         uint mask = 256 ** (32 - len) - 1;
446         assembly {
447             let srcpart := and(mload(src), not(mask))
448             let destpart := and(mload(dest), mask)
449             mstore(dest, or(destpart, srcpart))
450         }
451 
452         return buf;
453     }
454 
455     /**
456     * @dev Appends a byte string to a buffer. Resizes if doing so would exceed
457     *      the capacity of the buffer.
458     * @param buf The buffer to append to.
459     * @param data The data to append.
460     * @param len The number of bytes to copy.
461     * @return The original buffer, for chaining.
462     */
463     function append(buffer memory buf, bytes memory data, uint len) internal pure returns (buffer memory) {
464         return write(buf, buf.buf.length, data, len);
465     }
466 
467     /**
468     * @dev Appends a byte string to a buffer. Resizes if doing so would exceed
469     *      the capacity of the buffer.
470     * @param buf The buffer to append to.
471     * @param data The data to append.
472     * @return The original buffer, for chaining.
473     */
474     function append(buffer memory buf, bytes memory data) internal pure returns (buffer memory) {
475         return write(buf, buf.buf.length, data, data.length);
476     }
477 
478     /**
479     * @dev Writes a byte to the buffer. Resizes if doing so would exceed the
480     *      capacity of the buffer.
481     * @param buf The buffer to append to.
482     * @param off The offset to write the byte at.
483     * @param data The data to append.
484     * @return The original buffer, for chaining.
485     */
486     function writeUint8(buffer memory buf, uint off, uint8 data) internal pure returns(buffer memory) {
487         if (off >= buf.capacity) {
488             resize(buf, buf.capacity * 2);
489         }
490 
491         assembly {
492             // Memory address of the buffer data
493             let bufptr := mload(buf)
494             // Length of existing buffer data
495             let buflen := mload(bufptr)
496             // Address = buffer address + sizeof(buffer length) + off
497             let dest := add(add(bufptr, off), 32)
498             mstore8(dest, data)
499             // Update buffer length if we extended it
500             if eq(off, buflen) {
501                 mstore(bufptr, add(buflen, 1))
502             }
503         }
504         return buf;
505     }
506 
507     /**
508     * @dev Appends a byte to the buffer. Resizes if doing so would exceed the
509     *      capacity of the buffer.
510     * @param buf The buffer to append to.
511     * @param data The data to append.
512     * @return The original buffer, for chaining.
513     */
514     function appendUint8(buffer memory buf, uint8 data) internal pure returns(buffer memory) {
515         return writeUint8(buf, buf.buf.length, data);
516     }
517 
518     /**
519     * @dev Writes up to 32 bytes to the buffer. Resizes if doing so would
520     *      exceed the capacity of the buffer.
521     * @param buf The buffer to append to.
522     * @param off The offset to write at.
523     * @param data The data to append.
524     * @param len The number of bytes to write (left-aligned).
525     * @return The original buffer, for chaining.
526     */
527     function write(buffer memory buf, uint off, bytes32 data, uint len) private pure returns(buffer memory) {
528         if (len + off > buf.capacity) {
529             resize(buf, (len + off) * 2);
530         }
531 
532         uint mask = 256 ** len - 1;
533         // Right-align data
534         data = data >> (8 * (32 - len));
535         assembly {
536             // Memory address of the buffer data
537             let bufptr := mload(buf)
538             // Address = buffer address + sizeof(buffer length) + off + len
539             let dest := add(add(bufptr, off), len)
540             mstore(dest, or(and(mload(dest), not(mask)), data))
541             // Update buffer length if we extended it
542             if gt(add(off, len), mload(bufptr)) {
543                 mstore(bufptr, add(off, len))
544             }
545         }
546         return buf;
547     }
548 
549     /**
550     * @dev Writes a bytes20 to the buffer. Resizes if doing so would exceed the
551     *      capacity of the buffer.
552     * @param buf The buffer to append to.
553     * @param off The offset to write at.
554     * @param data The data to append.
555     * @return The original buffer, for chaining.
556     */
557     function writeBytes20(buffer memory buf, uint off, bytes20 data) internal pure returns (buffer memory) {
558         return write(buf, off, bytes32(data), 20);
559     }
560 
561     /**
562     * @dev Appends a bytes20 to the buffer. Resizes if doing so would exceed
563     *      the capacity of the buffer.
564     * @param buf The buffer to append to.
565     * @param data The data to append.
566     * @return The original buffer, for chhaining.
567     */
568     function appendBytes20(buffer memory buf, bytes20 data) internal pure returns (buffer memory) {
569         return write(buf, buf.buf.length, bytes32(data), 20);
570     }
571 
572     /**
573     * @dev Appends a bytes32 to the buffer. Resizes if doing so would exceed
574     *      the capacity of the buffer.
575     * @param buf The buffer to append to.
576     * @param data The data to append.
577     * @return The original buffer, for chaining.
578     */
579     function appendBytes32(buffer memory buf, bytes32 data) internal pure returns (buffer memory) {
580         return write(buf, buf.buf.length, data, 32);
581     }
582 
583     /**
584     * @dev Writes an integer to the buffer. Resizes if doing so would exceed
585     *      the capacity of the buffer.
586     * @param buf The buffer to append to.
587     * @param off The offset to write at.
588     * @param data The data to append.
589     * @param len The number of bytes to write (right-aligned).
590     * @return The original buffer, for chaining.
591     */
592     function writeInt(buffer memory buf, uint off, uint data, uint len) private pure returns(buffer memory) {
593         if (len + off > buf.capacity) {
594             resize(buf, (len + off) * 2);
595         }
596 
597         uint mask = 256 ** len - 1;
598         assembly {
599             // Memory address of the buffer data
600             let bufptr := mload(buf)
601             // Address = buffer address + off + sizeof(buffer length) + len
602             let dest := add(add(bufptr, off), len)
603             mstore(dest, or(and(mload(dest), not(mask)), data))
604             // Update buffer length if we extended it
605             if gt(add(off, len), mload(bufptr)) {
606                 mstore(bufptr, add(off, len))
607             }
608         }
609         return buf;
610     }
611 
612     /**
613      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
614      * exceed the capacity of the buffer.
615      * @param buf The buffer to append to.
616      * @param data The data to append.
617      * @return The original buffer.
618      */
619     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
620         return writeInt(buf, buf.buf.length, data, len);
621     }
622 }
623 
624 // File: @ensdomains/dnssec-oracle/contracts/BytesUtils.sol
625 
626 pragma solidity >0.4.23;
627 
628 library BytesUtils {
629     /*
630     * @dev Returns the keccak-256 hash of a byte range.
631     * @param self The byte string to hash.
632     * @param offset The position to start hashing at.
633     * @param len The number of bytes to hash.
634     * @return The hash of the byte range.
635     */
636     function keccak(bytes memory self, uint offset, uint len) internal pure returns (bytes32 ret) {
637         require(offset + len <= self.length);
638         assembly {
639             ret := keccak256(add(add(self, 32), offset), len)
640         }
641     }
642 
643 
644     /*
645     * @dev Returns a positive number if `other` comes lexicographically after
646     *      `self`, a negative number if it comes before, or zero if the
647     *      contents of the two bytes are equal.
648     * @param self The first bytes to compare.
649     * @param other The second bytes to compare.
650     * @return The result of the comparison.
651     */
652     function compare(bytes memory self, bytes memory other) internal pure returns (int) {
653         return compare(self, 0, self.length, other, 0, other.length);
654     }
655 
656     /*
657     * @dev Returns a positive number if `other` comes lexicographically after
658     *      `self`, a negative number if it comes before, or zero if the
659     *      contents of the two bytes are equal. Comparison is done per-rune,
660     *      on unicode codepoints.
661     * @param self The first bytes to compare.
662     * @param offset The offset of self.
663     * @param len    The length of self.
664     * @param other The second bytes to compare.
665     * @param otheroffset The offset of the other string.
666     * @param otherlen    The length of the other string.
667     * @return The result of the comparison.
668     */
669     function compare(bytes memory self, uint offset, uint len, bytes memory other, uint otheroffset, uint otherlen) internal pure returns (int) {
670         uint shortest = len;
671         if (otherlen < len)
672         shortest = otherlen;
673 
674         uint selfptr;
675         uint otherptr;
676 
677         assembly {
678             selfptr := add(self, add(offset, 32))
679             otherptr := add(other, add(otheroffset, 32))
680         }
681         for (uint idx = 0; idx < shortest; idx += 32) {
682             uint a;
683             uint b;
684             assembly {
685                 a := mload(selfptr)
686                 b := mload(otherptr)
687             }
688             if (a != b) {
689                 // Mask out irrelevant bytes and check again
690                 uint mask;
691                 if (shortest > 32) {
692                     mask = uint256(- 1); // aka 0xffffff....
693                 } else {
694                     mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
695                 }
696                 uint diff = (a & mask) - (b & mask);
697                 if (diff != 0)
698                 return int(diff);
699             }
700             selfptr += 32;
701             otherptr += 32;
702         }
703 
704         return int(len) - int(otherlen);
705     }
706 
707     /*
708     * @dev Returns true if the two byte ranges are equal.
709     * @param self The first byte range to compare.
710     * @param offset The offset into the first byte range.
711     * @param other The second byte range to compare.
712     * @param otherOffset The offset into the second byte range.
713     * @param len The number of bytes to compare
714     * @return True if the byte ranges are equal, false otherwise.
715     */
716     function equals(bytes memory self, uint offset, bytes memory other, uint otherOffset, uint len) internal pure returns (bool) {
717         return keccak(self, offset, len) == keccak(other, otherOffset, len);
718     }
719 
720     /*
721     * @dev Returns true if the two byte ranges are equal with offsets.
722     * @param self The first byte range to compare.
723     * @param offset The offset into the first byte range.
724     * @param other The second byte range to compare.
725     * @param otherOffset The offset into the second byte range.
726     * @return True if the byte ranges are equal, false otherwise.
727     */
728     function equals(bytes memory self, uint offset, bytes memory other, uint otherOffset) internal pure returns (bool) {
729         return keccak(self, offset, self.length - offset) == keccak(other, otherOffset, other.length - otherOffset);
730     }
731 
732     /*
733     * @dev Compares a range of 'self' to all of 'other' and returns True iff
734     *      they are equal.
735     * @param self The first byte range to compare.
736     * @param offset The offset into the first byte range.
737     * @param other The second byte range to compare.
738     * @return True if the byte ranges are equal, false otherwise.
739     */
740     function equals(bytes memory self, uint offset, bytes memory other) internal pure returns (bool) {
741         return self.length >= offset + other.length && equals(self, offset, other, 0, other.length);
742     }
743 
744     /*
745     * @dev Returns true if the two byte ranges are equal.
746     * @param self The first byte range to compare.
747     * @param other The second byte range to compare.
748     * @return True if the byte ranges are equal, false otherwise.
749     */
750     function equals(bytes memory self, bytes memory other) internal pure returns(bool) {
751         return self.length == other.length && equals(self, 0, other, 0, self.length);
752     }
753 
754     /*
755     * @dev Returns the 8-bit number at the specified index of self.
756     * @param self The byte string.
757     * @param idx The index into the bytes
758     * @return The specified 8 bits of the string, interpreted as an integer.
759     */
760     function readUint8(bytes memory self, uint idx) internal pure returns (uint8 ret) {
761         return uint8(self[idx]);
762     }
763 
764     /*
765     * @dev Returns the 16-bit number at the specified index of self.
766     * @param self The byte string.
767     * @param idx The index into the bytes
768     * @return The specified 16 bits of the string, interpreted as an integer.
769     */
770     function readUint16(bytes memory self, uint idx) internal pure returns (uint16 ret) {
771         require(idx + 2 <= self.length);
772         assembly {
773             ret := and(mload(add(add(self, 2), idx)), 0xFFFF)
774         }
775     }
776 
777     /*
778     * @dev Returns the 32-bit number at the specified index of self.
779     * @param self The byte string.
780     * @param idx The index into the bytes
781     * @return The specified 32 bits of the string, interpreted as an integer.
782     */
783     function readUint32(bytes memory self, uint idx) internal pure returns (uint32 ret) {
784         require(idx + 4 <= self.length);
785         assembly {
786             ret := and(mload(add(add(self, 4), idx)), 0xFFFFFFFF)
787         }
788     }
789 
790     /*
791     * @dev Returns the 32 byte value at the specified index of self.
792     * @param self The byte string.
793     * @param idx The index into the bytes
794     * @return The specified 32 bytes of the string.
795     */
796     function readBytes32(bytes memory self, uint idx) internal pure returns (bytes32 ret) {
797         require(idx + 32 <= self.length);
798         assembly {
799             ret := mload(add(add(self, 32), idx))
800         }
801     }
802 
803     /*
804     * @dev Returns the 32 byte value at the specified index of self.
805     * @param self The byte string.
806     * @param idx The index into the bytes
807     * @return The specified 32 bytes of the string.
808     */
809     function readBytes20(bytes memory self, uint idx) internal pure returns (bytes20 ret) {
810         require(idx + 20 <= self.length);
811         assembly {
812             ret := and(mload(add(add(self, 32), idx)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000)
813         }
814     }
815 
816     /*
817     * @dev Returns the n byte value at the specified index of self.
818     * @param self The byte string.
819     * @param idx The index into the bytes.
820     * @param len The number of bytes.
821     * @return The specified 32 bytes of the string.
822     */
823     function readBytesN(bytes memory self, uint idx, uint len) internal pure returns (bytes32 ret) {
824         require(len <= 32);
825         require(idx + len <= self.length);
826         assembly {
827             let mask := not(sub(exp(256, sub(32, len)), 1))
828             ret := and(mload(add(add(self, 32), idx)),  mask)
829         }
830     }
831 
832     function memcpy(uint dest, uint src, uint len) private pure {
833         // Copy word-length chunks while possible
834         for (; len >= 32; len -= 32) {
835             assembly {
836                 mstore(dest, mload(src))
837             }
838             dest += 32;
839             src += 32;
840         }
841 
842         // Copy remaining bytes
843         uint mask = 256 ** (32 - len) - 1;
844         assembly {
845             let srcpart := and(mload(src), not(mask))
846             let destpart := and(mload(dest), mask)
847             mstore(dest, or(destpart, srcpart))
848         }
849     }
850 
851     /*
852     * @dev Copies a substring into a new byte string.
853     * @param self The byte string to copy from.
854     * @param offset The offset to start copying at.
855     * @param len The number of bytes to copy.
856     */
857     function substring(bytes memory self, uint offset, uint len) internal pure returns(bytes memory) {
858         require(offset + len <= self.length);
859 
860         bytes memory ret = new bytes(len);
861         uint dest;
862         uint src;
863 
864         assembly {
865             dest := add(ret, 32)
866             src := add(add(self, 32), offset)
867         }
868         memcpy(dest, src, len);
869 
870         return ret;
871     }
872 
873     // Maps characters from 0x30 to 0x7A to their base32 values.
874     // 0xFF represents invalid characters in that range.
875     bytes constant base32HexTable = hex'00010203040506070809FFFFFFFFFFFFFF0A0B0C0D0E0F101112131415161718191A1B1C1D1E1FFFFFFFFFFFFFFFFFFFFF0A0B0C0D0E0F101112131415161718191A1B1C1D1E1F';
876 
877     /**
878      * @dev Decodes unpadded base32 data of up to one word in length.
879      * @param self The data to decode.
880      * @param off Offset into the string to start at.
881      * @param len Number of characters to decode.
882      * @return The decoded data, left aligned.
883      */
884     function base32HexDecodeWord(bytes memory self, uint off, uint len) internal pure returns(bytes32) {
885         require(len <= 52);
886 
887         uint ret = 0;
888         uint8 decoded;
889         for(uint i = 0; i < len; i++) {
890             bytes1 char = self[off + i];
891             require(char >= 0x30 && char <= 0x7A);
892             decoded = uint8(base32HexTable[uint(uint8(char)) - 0x30]);
893             require(decoded <= 0x20);
894             if(i == len - 1) {
895                 break;
896             }
897             ret = (ret << 5) | decoded;
898         }
899 
900         uint bitlen = len * 5;
901         if(len % 8 == 0) {
902             // Multiple of 8 characters, no padding
903             ret = (ret << 5) | decoded;
904         } else if(len % 8 == 2) {
905             // Two extra characters - 1 byte
906             ret = (ret << 3) | (decoded >> 2);
907             bitlen -= 2;
908         } else if(len % 8 == 4) {
909             // Four extra characters - 2 bytes
910             ret = (ret << 1) | (decoded >> 4);
911             bitlen -= 4;
912         } else if(len % 8 == 5) {
913             // Five extra characters - 3 bytes
914             ret = (ret << 4) | (decoded >> 1);
915             bitlen -= 1;
916         } else if(len % 8 == 7) {
917             // Seven extra characters - 4 bytes
918             ret = (ret << 2) | (decoded >> 3);
919             bitlen -= 3;
920         } else {
921             revert();
922         }
923 
924         return bytes32(ret << (256 - bitlen));
925     }
926 }
927 
928 // File: openzeppelin-solidity/contracts/access/Roles.sol
929 
930 pragma solidity ^0.5.0;
931 
932 /**
933  * @title Roles
934  * @dev Library for managing addresses assigned to a Role.
935  */
936 library Roles {
937     struct Role {
938         mapping (address => bool) bearer;
939     }
940 
941     /**
942      * @dev give an account access to this role
943      */
944     function add(Role storage role, address account) internal {
945         require(account != address(0));
946         require(!has(role, account));
947 
948         role.bearer[account] = true;
949     }
950 
951     /**
952      * @dev remove an account's access to this role
953      */
954     function remove(Role storage role, address account) internal {
955         require(account != address(0));
956         require(has(role, account));
957 
958         role.bearer[account] = false;
959     }
960 
961     /**
962      * @dev check if an account has this role
963      * @return bool
964      */
965     function has(Role storage role, address account) internal view returns (bool) {
966         require(account != address(0));
967         return role.bearer[account];
968     }
969 }
970 
971 // File: contracts/ShortNameClaims.sol
972 
973 pragma solidity ^0.5.0;
974 
975 
976 
977 
978 
979 
980 
981 /**
982  * @dev ShortNameClaims is a contract that permits people to register claims
983  *      for short (3-6 character) ENS names ahead of the auction process.
984  *
985  *      Anyone with a DNS name registered before January 1, 2019, may use this
986  *      name to support a claim for a matching ENS name. In the event that
987  *      multiple claimants request the same name, the name will be assigned to
988  *      the oldest registered DNS name.
989  *
990  *      Claims may be submitted by calling `submitExactClaim`,
991  *      `submitCombinedClaim` or `submitPrefixClaim` as appropriate.
992  *
993  *      Claims require lodging a deposit equivalent to 365 days' registration of
994  *      the name. If the claim is approved, this deposit is spent, and the name
995  *      is registered for the claimant for 365 days. If the claim is declined,
996  *      the deposit will be returned.
997  */
998 contract ShortNameClaims {
999     using Roles for Roles.Role;
1000 
1001     uint constant public REGISTRATION_PERIOD = 31536000;
1002 
1003     using Buffer for Buffer.buffer;
1004     using BytesUtils for bytes;
1005     using StringUtils for string;
1006 
1007     enum Phase {
1008         OPEN,
1009         REVIEW,
1010         FINAL
1011     }
1012 
1013     enum Status {
1014         PENDING,
1015         APPROVED,
1016         DECLINED,
1017         WITHDRAWN
1018     }
1019 
1020     struct Claim {
1021         bytes32 labelHash;
1022         address claimant;
1023         uint paid;
1024         Status status;
1025     }
1026 
1027     Roles.Role owners;
1028     Roles.Role ratifiers;
1029 
1030     PriceOracle public priceOracle;
1031     BaseRegistrar public registrar;
1032     mapping(bytes32=>Claim) public claims;
1033     mapping(bytes32=>bool) approvedNames;
1034     uint public pendingClaims;
1035     uint public unresolvedClaims;
1036     Phase public phase;
1037 
1038     event ClaimSubmitted(string claimed, bytes dnsname, uint paid, address claimant, string email);
1039     event ClaimStatusChanged(bytes32 indexed claimId, Status status);
1040 
1041     constructor(PriceOracle _priceOracle, BaseRegistrar _registrar, address _ratifier) public {
1042         priceOracle = _priceOracle;
1043         registrar = _registrar;
1044         phase = Phase.OPEN;
1045 
1046         owners.add(msg.sender);
1047         ratifiers.add(_ratifier);
1048     }
1049 
1050     modifier onlyOwner() {
1051         require(owners.has(msg.sender), "Caller must be an owner");
1052         _;
1053     }
1054 
1055     modifier onlyRatifier() {
1056         require(ratifiers.has(msg.sender), "Caller must be a ratifier");
1057         _;
1058     }
1059 
1060     modifier inPhase(Phase p) {
1061         require(phase == p, "Not in required phase");
1062         _;
1063     }
1064 
1065     function addOwner(address owner) external onlyOwner {
1066         owners.add(owner);
1067     }
1068 
1069     function removeOwner(address owner) external onlyOwner {
1070         owners.remove(owner);
1071     }
1072 
1073     function addRatifier(address ratifier) external onlyRatifier {
1074         ratifiers.add(ratifier);
1075     }
1076 
1077     function removeRatifier(address ratifier) external onlyRatifier {
1078         ratifiers.remove(ratifier);
1079     }
1080 
1081     /**
1082      * @dev Computes the claim ID for a submitted claim, so it can be looked up
1083      *      using `claims`.
1084      * @param claimed The name being claimed (eg, 'foo')
1085      * @param dnsname The DNS-encoded name supporting the claim (eg, 'foo.test')
1086      * @param claimant The address making the claim.
1087      * @return The claim ID.
1088      */
1089     function computeClaimId(string memory claimed, bytes memory dnsname, address claimant, string memory email) public pure returns(bytes32) {
1090         return keccak256(abi.encodePacked(keccak256(bytes(claimed)), keccak256(dnsname), claimant, keccak256(bytes(email))));
1091     }
1092 
1093     /**
1094      * @dev Returns the cost associated with placing a claim.
1095      * @param claimed The name being claimed.
1096      * @return The cost in wei for this claim.
1097      */
1098     function getClaimCost(string memory claimed) public view returns(uint) {
1099         return priceOracle.price(claimed, 0, REGISTRATION_PERIOD);
1100     }
1101 
1102     /**
1103      * @dev Submits a claim for an exact match (eg, foo.test -> foo.eth).
1104      *      Claimants must provide an amount of ether equal to 365 days'
1105      *      registration cost; call `getClaimCost` to determine this amount.
1106      *      Claimants should supply a little extra in case of variation in price;
1107      *      any excess will be returned to the sender.
1108      * @param name The DNS-encoded name of the domain being used to support the
1109      *             claim.
1110      * @param claimant The address of the claimant.
1111      * @param email An email address for correspondence regarding the claim.
1112      */
1113     function submitExactClaim(bytes memory name, address claimant, string memory email) public payable {
1114         string memory claimed = getLabel(name, 0);
1115         handleClaim(claimed, name, claimant, email);
1116     }
1117 
1118     /**
1119      * @dev Submits a claim for match on name+tld (eg, foo.tv -> footv).
1120      *      Claimants must provide an amount of ether equal to 365 days'
1121      *      registration cost; call `getClaimCost` to determine this amount.
1122      *      Claimants should supply a little extra in case of variation in price;
1123      *      any excess will be returned to the sender.
1124      * @param name The DNS-encoded name of the domain being used to support the
1125      *             claim.
1126      * @param claimant The address of the claimant.
1127      * @param email An email address for correspondence regarding the claim.
1128      */
1129     function submitCombinedClaim(bytes memory name, address claimant, string memory email) public payable {
1130         bytes memory firstLabel = bytes(getLabel(name, 0));
1131         bytes memory secondLabel = bytes(getLabel(name, 1));
1132         Buffer.buffer memory buf;
1133         buf.init(firstLabel.length + secondLabel.length);
1134         buf.append(firstLabel);
1135         buf.append(secondLabel);
1136 
1137         handleClaim(string(buf.buf), name, claimant, email);
1138     }
1139 
1140     /**
1141      * @dev Submits a claim for prefix match (eg, fooeth.test -> foo.eth).
1142      *      Claimants must provide an amount of ether equal to 365 days'
1143      *      registration cost; call `getClaimCost` to determine this amount.
1144      *      Claimants should supply a little extra in case of variation in price;
1145      *      any excess will be returned to the sender.
1146      * @param name The DNS-encoded name of the domain being used to support the
1147      *             claim.
1148      * @param claimant The address of the claimant.
1149      * @param email An email address for correspondence regarding the claim.
1150      */
1151     function submitPrefixClaim(bytes memory name, address claimant, string memory email) public payable {
1152         bytes memory firstLabel = bytes(getLabel(name, 0));
1153         require(firstLabel.equals(firstLabel.length - 3, bytes("eth")));
1154         handleClaim(string(firstLabel.substring(0, firstLabel.length - 3)), name, claimant, email);
1155     }
1156 
1157     /**
1158      * @dev Closes the claim submission period.
1159      *      Callable only by the owner.
1160      */
1161     function closeClaims() external onlyOwner inPhase(Phase.OPEN) {
1162         phase = Phase.REVIEW;
1163     }
1164 
1165     /**
1166      * @dev Ratifies the current set of claims.
1167      *      Ratification freezes the claims and their resolutions, and permits
1168      *      them to be acted on.
1169      */
1170     function ratifyClaims() external onlyRatifier inPhase(Phase.REVIEW) {
1171         // Can't ratify until all claims have a resolution.
1172         require(pendingClaims == 0);
1173         phase = Phase.FINAL;
1174     }
1175 
1176     /**
1177      * @dev Cleans up the contract, after all claims are resolved.
1178      *      Callable only by the owner, and only in final state.
1179      */
1180     function destroy() external onlyOwner inPhase(Phase.FINAL) {
1181         require(unresolvedClaims == 0);
1182         selfdestruct(toPayable(msg.sender));
1183     }
1184 
1185     /**
1186      * @dev Sets the status of a claim to either APPROVED or DECLINED.
1187      *      Callable only during the review phase, and only by the owner or
1188      *      ratifier.
1189      * @param claimId The claim to set the status of.
1190      * @param approved True if the claim is approved, false if it is declined.
1191      */
1192     function setClaimStatus(bytes32 claimId, bool approved) public inPhase(Phase.REVIEW) {
1193         // Only callable by owner or ratifier
1194         require(owners.has(msg.sender) || ratifiers.has(msg.sender));
1195 
1196         Claim memory claim = claims[claimId];
1197         require(claim.paid > 0, "Claim not found");
1198 
1199         if(claim.status == Status.PENDING) {
1200           // Claim went from pending -> approved/declined; update counters
1201           pendingClaims--;
1202           unresolvedClaims++;
1203         } else if(claim.status == Status.APPROVED) {
1204           // Claim was previously approved; remove from approved map
1205           approvedNames[claim.labelHash] = false;
1206         }
1207 
1208         // Claim was just approved; check the name was not already used, and add
1209         // to approved map
1210         if(approved) {
1211           require(!approvedNames[claim.labelHash]);
1212           approvedNames[claim.labelHash] = true;
1213         }
1214 
1215         Status status = approved?Status.APPROVED:Status.DECLINED;
1216         claims[claimId].status = status;
1217         emit ClaimStatusChanged(claimId, status);
1218     }
1219 
1220     /**
1221      * @dev Sets the status of multiple claims. Callable only during the review
1222      *      phase, and only by the owner or ratifier.
1223      * @param approved A list of approved claim IDs.
1224      * @param declined A list of declined claim IDs.
1225      */
1226     function setClaimStatuses(bytes32[] calldata approved, bytes32[] calldata declined) external {
1227         for(uint i = 0; i < approved.length; i++) {
1228             setClaimStatus(approved[i], true);
1229         }
1230         for(uint i = 0; i < declined.length; i++) {
1231             setClaimStatus(declined[i], false);
1232         }
1233     }
1234 
1235     /**
1236      * @dev Resolves a claim. Callable by anyone, only in the final phase.
1237      *      Resolving a claim either registers the name or refunds the claimant.
1238      * @param claimId The claim ID to resolve.
1239      */
1240     function resolveClaim(bytes32 claimId) public inPhase(Phase.FINAL) {
1241         Claim memory claim = claims[claimId];
1242         require(claim.paid > 0, "Claim not found");
1243 
1244         if(claim.status == Status.APPROVED) {
1245             registrar.register(uint256(claim.labelHash), claim.claimant, REGISTRATION_PERIOD);
1246             toPayable(registrar.owner()).transfer(claim.paid);
1247         } else if(claim.status == Status.DECLINED) {
1248             toPayable(claim.claimant).transfer(claim.paid);
1249         } else {
1250             // It should not be possible to get to FINAL with claim IDs that are
1251             // not either APPROVED or DECLINED.
1252             assert(false);
1253         }
1254 
1255         unresolvedClaims--;
1256         delete claims[claimId];
1257     }
1258 
1259     /**
1260      * @dev Resolves multiple claims. Callable by anyone, only in the final phase.
1261      * @param claimIds A list of claim IDs to resolve.
1262      */
1263     function resolveClaims(bytes32[] calldata claimIds) external {
1264         for(uint i = 0; i < claimIds.length; i++) {
1265             resolveClaim(claimIds[i]);
1266         }
1267     }
1268 
1269     /**
1270      * @dev Withdraws a claim and refunds the claimant.
1271      *      Callable only by the claimant, at any time.
1272      * @param claimId The ID of the claim to withdraw.
1273      */
1274     function withdrawClaim(bytes32 claimId) external {
1275         Claim memory claim = claims[claimId];
1276 
1277         // Only callable by claimant
1278         require(msg.sender == claim.claimant);
1279 
1280         if(claim.status == Status.PENDING) {
1281             pendingClaims--;
1282         } else {
1283             unresolvedClaims--;
1284         }
1285 
1286         toPayable(claim.claimant).transfer(claim.paid);
1287         emit ClaimStatusChanged(claimId, Status.WITHDRAWN);
1288         delete claims[claimId];
1289     }
1290 
1291     function handleClaim(string memory claimed, bytes memory name, address claimant, string memory email) internal inPhase(Phase.OPEN) {
1292         uint len = claimed.strlen();
1293         require(len >= 3 && len <= 6);
1294 
1295         bytes32 claimId = computeClaimId(claimed, name, claimant, email);
1296         require(claims[claimId].paid == 0, "Claim already submitted");
1297 
1298         // Require that there are at most two labels (name.tld)
1299         require(bytes(getLabel(name, 2)).length == 0, "Name must be a 2LD");
1300 
1301         uint price = getClaimCost(claimed);
1302         require(msg.value >= price, "Insufficient funds for reservation");
1303         if(msg.value > price) {
1304             msg.sender.transfer(msg.value - price);
1305         }
1306 
1307         claims[claimId] = Claim(keccak256(bytes(claimed)), claimant, price, Status.PENDING);
1308         pendingClaims++;
1309         emit ClaimSubmitted(claimed, name, price, claimant, email);
1310     }
1311 
1312     function getLabel(bytes memory name, uint idx) internal pure returns(string memory) {
1313         // Skip the first `idx` labels
1314         uint offset = 0;
1315         for(uint i = 0; i < idx; i++) {
1316             if(offset >= name.length) return "";
1317             offset += name.readUint8(offset) + 1;
1318         }
1319 
1320         // Read the label we care about
1321         if(offset >= name.length) return '';
1322         uint len = name.readUint8(offset);
1323         return string(name.substring(offset + 1, len));
1324     }
1325 
1326     function toPayable(address addr) internal pure returns(address payable) {
1327         return address(uint160(addr));
1328     }
1329 }