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
19     // Logged when an operator is added or removed.
20     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
21 
22     function setRecord(bytes32 node, address owner, address resolver, uint64 ttl) external;
23     function setSubnodeRecord(bytes32 node, bytes32 label, address owner, address resolver, uint64 ttl) external;
24     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external returns(bytes32);
25     function setResolver(bytes32 node, address resolver) external;
26     function setOwner(bytes32 node, address owner) external;
27     function setTTL(bytes32 node, uint64 ttl) external;
28     function setApprovalForAll(address operator, bool approved) external;
29     function owner(bytes32 node) external view returns (address);
30     function resolver(bytes32 node) external view returns (address);
31     function ttl(bytes32 node) external view returns (uint64);
32     function recordExists(bytes32 node) external view returns (bool);
33     function isApprovedForAll(address owner, address operator) external view returns (bool);
34 }
35 
36 // File: @ensdomains/resolver/contracts/ResolverBase.sol
37 
38 pragma solidity ^0.5.0;
39 
40 contract ResolverBase {
41     bytes4 private constant INTERFACE_META_ID = 0x01ffc9a7;
42 
43     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
44         return interfaceID == INTERFACE_META_ID;
45     }
46 
47     function isAuthorised(bytes32 node) internal view returns(bool);
48 
49     modifier authorised(bytes32 node) {
50         require(isAuthorised(node));
51         _;
52     }
53 
54     function bytesToAddress(bytes memory b) internal pure returns(address payable a) {
55         require(b.length == 20);
56         assembly {
57             a := div(mload(add(b, 32)), exp(256, 12))
58         }
59     }
60 
61     function addressToBytes(address a) internal pure returns(bytes memory b) {
62         b = new bytes(20);
63         assembly {
64             mstore(add(b, 32), mul(a, exp(256, 12)))
65         }
66     }
67 }
68 
69 // File: @ensdomains/resolver/contracts/profiles/ABIResolver.sol
70 
71 pragma solidity ^0.5.0;
72 
73 
74 contract ABIResolver is ResolverBase {
75     bytes4 constant private ABI_INTERFACE_ID = 0x2203ab56;
76 
77     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
78 
79     mapping(bytes32=>mapping(uint256=>bytes)) abis;
80 
81     /**
82      * Sets the ABI associated with an ENS node.
83      * Nodes may have one ABI of each content type. To remove an ABI, set it to
84      * the empty string.
85      * @param node The node to update.
86      * @param contentType The content type of the ABI
87      * @param data The ABI data.
88      */
89     function setABI(bytes32 node, uint256 contentType, bytes calldata data) external authorised(node) {
90         // Content types must be powers of 2
91         require(((contentType - 1) & contentType) == 0);
92 
93         abis[node][contentType] = data;
94         emit ABIChanged(node, contentType);
95     }
96 
97     /**
98      * Returns the ABI associated with an ENS node.
99      * Defined in EIP205.
100      * @param node The ENS node to query
101      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
102      * @return contentType The content type of the return value
103      * @return data The ABI data
104      */
105     function ABI(bytes32 node, uint256 contentTypes) external view returns (uint256, bytes memory) {
106         mapping(uint256=>bytes) storage abiset = abis[node];
107 
108         for (uint256 contentType = 1; contentType <= contentTypes; contentType <<= 1) {
109             if ((contentType & contentTypes) != 0 && abiset[contentType].length > 0) {
110                 return (contentType, abiset[contentType]);
111             }
112         }
113 
114         return (0, bytes(""));
115     }
116 
117     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
118         return interfaceID == ABI_INTERFACE_ID || super.supportsInterface(interfaceID);
119     }
120 }
121 
122 // File: @ensdomains/resolver/contracts/profiles/AddrResolver.sol
123 
124 pragma solidity ^0.5.0;
125 
126 
127 contract AddrResolver is ResolverBase {
128     bytes4 constant private ADDR_INTERFACE_ID = 0x3b3b57de;
129     bytes4 constant private ADDRESS_INTERFACE_ID = 0xf1cb7e06;
130     uint constant private COIN_TYPE_ETH = 60;
131 
132     event AddrChanged(bytes32 indexed node, address a);
133     event AddressChanged(bytes32 indexed node, uint coinType, bytes newAddress);
134 
135     mapping(bytes32=>mapping(uint=>bytes)) _addresses;
136 
137     /**
138      * Sets the address associated with an ENS node.
139      * May only be called by the owner of that node in the ENS registry.
140      * @param node The node to update.
141      * @param a The address to set.
142      */
143     function setAddr(bytes32 node, address a) external authorised(node) {
144         setAddr(node, COIN_TYPE_ETH, addressToBytes(a));
145     }
146 
147     /**
148      * Returns the address associated with an ENS node.
149      * @param node The ENS node to query.
150      * @return The associated address.
151      */
152     function addr(bytes32 node) public view returns (address payable) {
153         bytes memory a = addr(node, COIN_TYPE_ETH);
154         if(a.length == 0) {
155             return address(0);
156         }
157         return bytesToAddress(a);
158     }
159 
160     function setAddr(bytes32 node, uint coinType, bytes memory a) public authorised(node) {
161         emit AddressChanged(node, coinType, a);
162         if(coinType == COIN_TYPE_ETH) {
163             emit AddrChanged(node, bytesToAddress(a));
164         }
165         _addresses[node][coinType] = a;
166     }
167 
168     function addr(bytes32 node, uint coinType) public view returns(bytes memory) {
169         return _addresses[node][coinType];
170     }
171 
172     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
173         return interfaceID == ADDR_INTERFACE_ID || interfaceID == ADDRESS_INTERFACE_ID || super.supportsInterface(interfaceID);
174     }
175 }
176 
177 // File: @ensdomains/resolver/contracts/profiles/ContentHashResolver.sol
178 
179 pragma solidity ^0.5.0;
180 
181 
182 contract ContentHashResolver is ResolverBase {
183     bytes4 constant private CONTENT_HASH_INTERFACE_ID = 0xbc1c58d1;
184 
185     event ContenthashChanged(bytes32 indexed node, bytes hash);
186 
187     mapping(bytes32=>bytes) hashes;
188 
189     /**
190      * Sets the contenthash associated with an ENS node.
191      * May only be called by the owner of that node in the ENS registry.
192      * @param node The node to update.
193      * @param hash The contenthash to set
194      */
195     function setContenthash(bytes32 node, bytes calldata hash) external authorised(node) {
196         hashes[node] = hash;
197         emit ContenthashChanged(node, hash);
198     }
199 
200     /**
201      * Returns the contenthash associated with an ENS node.
202      * @param node The ENS node to query.
203      * @return The associated contenthash.
204      */
205     function contenthash(bytes32 node) external view returns (bytes memory) {
206         return hashes[node];
207     }
208 
209     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
210         return interfaceID == CONTENT_HASH_INTERFACE_ID || super.supportsInterface(interfaceID);
211     }
212 }
213 
214 // File: @ensdomains/dnssec-oracle/contracts/BytesUtils.sol
215 
216 pragma solidity >0.4.23;
217 
218 library BytesUtils {
219     /*
220     * @dev Returns the keccak-256 hash of a byte range.
221     * @param self The byte string to hash.
222     * @param offset The position to start hashing at.
223     * @param len The number of bytes to hash.
224     * @return The hash of the byte range.
225     */
226     function keccak(bytes memory self, uint offset, uint len) internal pure returns (bytes32 ret) {
227         require(offset + len <= self.length);
228         assembly {
229             ret := keccak256(add(add(self, 32), offset), len)
230         }
231     }
232 
233 
234     /*
235     * @dev Returns a positive number if `other` comes lexicographically after
236     *      `self`, a negative number if it comes before, or zero if the
237     *      contents of the two bytes are equal.
238     * @param self The first bytes to compare.
239     * @param other The second bytes to compare.
240     * @return The result of the comparison.
241     */
242     function compare(bytes memory self, bytes memory other) internal pure returns (int) {
243         return compare(self, 0, self.length, other, 0, other.length);
244     }
245 
246     /*
247     * @dev Returns a positive number if `other` comes lexicographically after
248     *      `self`, a negative number if it comes before, or zero if the
249     *      contents of the two bytes are equal. Comparison is done per-rune,
250     *      on unicode codepoints.
251     * @param self The first bytes to compare.
252     * @param offset The offset of self.
253     * @param len    The length of self.
254     * @param other The second bytes to compare.
255     * @param otheroffset The offset of the other string.
256     * @param otherlen    The length of the other string.
257     * @return The result of the comparison.
258     */
259     function compare(bytes memory self, uint offset, uint len, bytes memory other, uint otheroffset, uint otherlen) internal pure returns (int) {
260         uint shortest = len;
261         if (otherlen < len)
262         shortest = otherlen;
263 
264         uint selfptr;
265         uint otherptr;
266 
267         assembly {
268             selfptr := add(self, add(offset, 32))
269             otherptr := add(other, add(otheroffset, 32))
270         }
271         for (uint idx = 0; idx < shortest; idx += 32) {
272             uint a;
273             uint b;
274             assembly {
275                 a := mload(selfptr)
276                 b := mload(otherptr)
277             }
278             if (a != b) {
279                 // Mask out irrelevant bytes and check again
280                 uint mask;
281                 if (shortest > 32) {
282                     mask = uint256(- 1); // aka 0xffffff....
283                 } else {
284                     mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
285                 }
286                 uint diff = (a & mask) - (b & mask);
287                 if (diff != 0)
288                 return int(diff);
289             }
290             selfptr += 32;
291             otherptr += 32;
292         }
293 
294         return int(len) - int(otherlen);
295     }
296 
297     /*
298     * @dev Returns true if the two byte ranges are equal.
299     * @param self The first byte range to compare.
300     * @param offset The offset into the first byte range.
301     * @param other The second byte range to compare.
302     * @param otherOffset The offset into the second byte range.
303     * @param len The number of bytes to compare
304     * @return True if the byte ranges are equal, false otherwise.
305     */
306     function equals(bytes memory self, uint offset, bytes memory other, uint otherOffset, uint len) internal pure returns (bool) {
307         return keccak(self, offset, len) == keccak(other, otherOffset, len);
308     }
309 
310     /*
311     * @dev Returns true if the two byte ranges are equal with offsets.
312     * @param self The first byte range to compare.
313     * @param offset The offset into the first byte range.
314     * @param other The second byte range to compare.
315     * @param otherOffset The offset into the second byte range.
316     * @return True if the byte ranges are equal, false otherwise.
317     */
318     function equals(bytes memory self, uint offset, bytes memory other, uint otherOffset) internal pure returns (bool) {
319         return keccak(self, offset, self.length - offset) == keccak(other, otherOffset, other.length - otherOffset);
320     }
321 
322     /*
323     * @dev Compares a range of 'self' to all of 'other' and returns True iff
324     *      they are equal.
325     * @param self The first byte range to compare.
326     * @param offset The offset into the first byte range.
327     * @param other The second byte range to compare.
328     * @return True if the byte ranges are equal, false otherwise.
329     */
330     function equals(bytes memory self, uint offset, bytes memory other) internal pure returns (bool) {
331         return self.length >= offset + other.length && equals(self, offset, other, 0, other.length);
332     }
333 
334     /*
335     * @dev Returns true if the two byte ranges are equal.
336     * @param self The first byte range to compare.
337     * @param other The second byte range to compare.
338     * @return True if the byte ranges are equal, false otherwise.
339     */
340     function equals(bytes memory self, bytes memory other) internal pure returns(bool) {
341         return self.length == other.length && equals(self, 0, other, 0, self.length);
342     }
343 
344     /*
345     * @dev Returns the 8-bit number at the specified index of self.
346     * @param self The byte string.
347     * @param idx The index into the bytes
348     * @return The specified 8 bits of the string, interpreted as an integer.
349     */
350     function readUint8(bytes memory self, uint idx) internal pure returns (uint8 ret) {
351         return uint8(self[idx]);
352     }
353 
354     /*
355     * @dev Returns the 16-bit number at the specified index of self.
356     * @param self The byte string.
357     * @param idx The index into the bytes
358     * @return The specified 16 bits of the string, interpreted as an integer.
359     */
360     function readUint16(bytes memory self, uint idx) internal pure returns (uint16 ret) {
361         require(idx + 2 <= self.length);
362         assembly {
363             ret := and(mload(add(add(self, 2), idx)), 0xFFFF)
364         }
365     }
366 
367     /*
368     * @dev Returns the 32-bit number at the specified index of self.
369     * @param self The byte string.
370     * @param idx The index into the bytes
371     * @return The specified 32 bits of the string, interpreted as an integer.
372     */
373     function readUint32(bytes memory self, uint idx) internal pure returns (uint32 ret) {
374         require(idx + 4 <= self.length);
375         assembly {
376             ret := and(mload(add(add(self, 4), idx)), 0xFFFFFFFF)
377         }
378     }
379 
380     /*
381     * @dev Returns the 32 byte value at the specified index of self.
382     * @param self The byte string.
383     * @param idx The index into the bytes
384     * @return The specified 32 bytes of the string.
385     */
386     function readBytes32(bytes memory self, uint idx) internal pure returns (bytes32 ret) {
387         require(idx + 32 <= self.length);
388         assembly {
389             ret := mload(add(add(self, 32), idx))
390         }
391     }
392 
393     /*
394     * @dev Returns the 32 byte value at the specified index of self.
395     * @param self The byte string.
396     * @param idx The index into the bytes
397     * @return The specified 32 bytes of the string.
398     */
399     function readBytes20(bytes memory self, uint idx) internal pure returns (bytes20 ret) {
400         require(idx + 20 <= self.length);
401         assembly {
402             ret := and(mload(add(add(self, 32), idx)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000)
403         }
404     }
405 
406     /*
407     * @dev Returns the n byte value at the specified index of self.
408     * @param self The byte string.
409     * @param idx The index into the bytes.
410     * @param len The number of bytes.
411     * @return The specified 32 bytes of the string.
412     */
413     function readBytesN(bytes memory self, uint idx, uint len) internal pure returns (bytes32 ret) {
414         require(len <= 32);
415         require(idx + len <= self.length);
416         assembly {
417             let mask := not(sub(exp(256, sub(32, len)), 1))
418             ret := and(mload(add(add(self, 32), idx)),  mask)
419         }
420     }
421 
422     function memcpy(uint dest, uint src, uint len) private pure {
423         // Copy word-length chunks while possible
424         for (; len >= 32; len -= 32) {
425             assembly {
426                 mstore(dest, mload(src))
427             }
428             dest += 32;
429             src += 32;
430         }
431 
432         // Copy remaining bytes
433         uint mask = 256 ** (32 - len) - 1;
434         assembly {
435             let srcpart := and(mload(src), not(mask))
436             let destpart := and(mload(dest), mask)
437             mstore(dest, or(destpart, srcpart))
438         }
439     }
440 
441     /*
442     * @dev Copies a substring into a new byte string.
443     * @param self The byte string to copy from.
444     * @param offset The offset to start copying at.
445     * @param len The number of bytes to copy.
446     */
447     function substring(bytes memory self, uint offset, uint len) internal pure returns(bytes memory) {
448         require(offset + len <= self.length);
449 
450         bytes memory ret = new bytes(len);
451         uint dest;
452         uint src;
453 
454         assembly {
455             dest := add(ret, 32)
456             src := add(add(self, 32), offset)
457         }
458         memcpy(dest, src, len);
459 
460         return ret;
461     }
462 
463     // Maps characters from 0x30 to 0x7A to their base32 values.
464     // 0xFF represents invalid characters in that range.
465     bytes constant base32HexTable = hex'00010203040506070809FFFFFFFFFFFFFF0A0B0C0D0E0F101112131415161718191A1B1C1D1E1FFFFFFFFFFFFFFFFFFFFF0A0B0C0D0E0F101112131415161718191A1B1C1D1E1F';
466 
467     /**
468      * @dev Decodes unpadded base32 data of up to one word in length.
469      * @param self The data to decode.
470      * @param off Offset into the string to start at.
471      * @param len Number of characters to decode.
472      * @return The decoded data, left aligned.
473      */
474     function base32HexDecodeWord(bytes memory self, uint off, uint len) internal pure returns(bytes32) {
475         require(len <= 52);
476 
477         uint ret = 0;
478         uint8 decoded;
479         for(uint i = 0; i < len; i++) {
480             bytes1 char = self[off + i];
481             require(char >= 0x30 && char <= 0x7A);
482             decoded = uint8(base32HexTable[uint(uint8(char)) - 0x30]);
483             require(decoded <= 0x20);
484             if(i == len - 1) {
485                 break;
486             }
487             ret = (ret << 5) | decoded;
488         }
489 
490         uint bitlen = len * 5;
491         if(len % 8 == 0) {
492             // Multiple of 8 characters, no padding
493             ret = (ret << 5) | decoded;
494         } else if(len % 8 == 2) {
495             // Two extra characters - 1 byte
496             ret = (ret << 3) | (decoded >> 2);
497             bitlen -= 2;
498         } else if(len % 8 == 4) {
499             // Four extra characters - 2 bytes
500             ret = (ret << 1) | (decoded >> 4);
501             bitlen -= 4;
502         } else if(len % 8 == 5) {
503             // Five extra characters - 3 bytes
504             ret = (ret << 4) | (decoded >> 1);
505             bitlen -= 1;
506         } else if(len % 8 == 7) {
507             // Seven extra characters - 4 bytes
508             ret = (ret << 2) | (decoded >> 3);
509             bitlen -= 3;
510         } else {
511             revert();
512         }
513 
514         return bytes32(ret << (256 - bitlen));
515     }
516 }
517 
518 // File: @ensdomains/buffer/contracts/Buffer.sol
519 
520 pragma solidity >0.4.18;
521 
522 /**
523 * @dev A library for working with mutable byte buffers in Solidity.
524 *
525 * Byte buffers are mutable and expandable, and provide a variety of primitives
526 * for writing to them. At any time you can fetch a bytes object containing the
527 * current contents of the buffer. The bytes object should not be stored between
528 * operations, as it may change due to resizing of the buffer.
529 */
530 library Buffer {
531     /**
532     * @dev Represents a mutable buffer. Buffers have a current value (buf) and
533     *      a capacity. The capacity may be longer than the current value, in
534     *      which case it can be extended without the need to allocate more memory.
535     */
536     struct buffer {
537         bytes buf;
538         uint capacity;
539     }
540 
541     /**
542     * @dev Initializes a buffer with an initial capacity.
543     * @param buf The buffer to initialize.
544     * @param capacity The number of bytes of space to allocate the buffer.
545     * @return The buffer, for chaining.
546     */
547     function init(buffer memory buf, uint capacity) internal pure returns(buffer memory) {
548         if (capacity % 32 != 0) {
549             capacity += 32 - (capacity % 32);
550         }
551         // Allocate space for the buffer data
552         buf.capacity = capacity;
553         assembly {
554             let ptr := mload(0x40)
555             mstore(buf, ptr)
556             mstore(ptr, 0)
557             mstore(0x40, add(32, add(ptr, capacity)))
558         }
559         return buf;
560     }
561 
562     /**
563     * @dev Initializes a new buffer from an existing bytes object.
564     *      Changes to the buffer may mutate the original value.
565     * @param b The bytes object to initialize the buffer with.
566     * @return A new buffer.
567     */
568     function fromBytes(bytes memory b) internal pure returns(buffer memory) {
569         buffer memory buf;
570         buf.buf = b;
571         buf.capacity = b.length;
572         return buf;
573     }
574 
575     function resize(buffer memory buf, uint capacity) private pure {
576         bytes memory oldbuf = buf.buf;
577         init(buf, capacity);
578         append(buf, oldbuf);
579     }
580 
581     function max(uint a, uint b) private pure returns(uint) {
582         if (a > b) {
583             return a;
584         }
585         return b;
586     }
587 
588     /**
589     * @dev Sets buffer length to 0.
590     * @param buf The buffer to truncate.
591     * @return The original buffer, for chaining..
592     */
593     function truncate(buffer memory buf) internal pure returns (buffer memory) {
594         assembly {
595             let bufptr := mload(buf)
596             mstore(bufptr, 0)
597         }
598         return buf;
599     }
600 
601     /**
602     * @dev Writes a byte string to a buffer. Resizes if doing so would exceed
603     *      the capacity of the buffer.
604     * @param buf The buffer to append to.
605     * @param off The start offset to write to.
606     * @param data The data to append.
607     * @param len The number of bytes to copy.
608     * @return The original buffer, for chaining.
609     */
610     function write(buffer memory buf, uint off, bytes memory data, uint len) internal pure returns(buffer memory) {
611         require(len <= data.length);
612 
613         if (off + len > buf.capacity) {
614             resize(buf, max(buf.capacity, len + off) * 2);
615         }
616 
617         uint dest;
618         uint src;
619         assembly {
620             // Memory address of the buffer data
621             let bufptr := mload(buf)
622             // Length of existing buffer data
623             let buflen := mload(bufptr)
624             // Start address = buffer address + offset + sizeof(buffer length)
625             dest := add(add(bufptr, 32), off)
626             // Update buffer length if we're extending it
627             if gt(add(len, off), buflen) {
628                 mstore(bufptr, add(len, off))
629             }
630             src := add(data, 32)
631         }
632 
633         // Copy word-length chunks while possible
634         for (; len >= 32; len -= 32) {
635             assembly {
636                 mstore(dest, mload(src))
637             }
638             dest += 32;
639             src += 32;
640         }
641 
642         // Copy remaining bytes
643         uint mask = 256 ** (32 - len) - 1;
644         assembly {
645             let srcpart := and(mload(src), not(mask))
646             let destpart := and(mload(dest), mask)
647             mstore(dest, or(destpart, srcpart))
648         }
649 
650         return buf;
651     }
652 
653     /**
654     * @dev Appends a byte string to a buffer. Resizes if doing so would exceed
655     *      the capacity of the buffer.
656     * @param buf The buffer to append to.
657     * @param data The data to append.
658     * @param len The number of bytes to copy.
659     * @return The original buffer, for chaining.
660     */
661     function append(buffer memory buf, bytes memory data, uint len) internal pure returns (buffer memory) {
662         return write(buf, buf.buf.length, data, len);
663     }
664 
665     /**
666     * @dev Appends a byte string to a buffer. Resizes if doing so would exceed
667     *      the capacity of the buffer.
668     * @param buf The buffer to append to.
669     * @param data The data to append.
670     * @return The original buffer, for chaining.
671     */
672     function append(buffer memory buf, bytes memory data) internal pure returns (buffer memory) {
673         return write(buf, buf.buf.length, data, data.length);
674     }
675 
676     /**
677     * @dev Writes a byte to the buffer. Resizes if doing so would exceed the
678     *      capacity of the buffer.
679     * @param buf The buffer to append to.
680     * @param off The offset to write the byte at.
681     * @param data The data to append.
682     * @return The original buffer, for chaining.
683     */
684     function writeUint8(buffer memory buf, uint off, uint8 data) internal pure returns(buffer memory) {
685         if (off >= buf.capacity) {
686             resize(buf, buf.capacity * 2);
687         }
688 
689         assembly {
690             // Memory address of the buffer data
691             let bufptr := mload(buf)
692             // Length of existing buffer data
693             let buflen := mload(bufptr)
694             // Address = buffer address + sizeof(buffer length) + off
695             let dest := add(add(bufptr, off), 32)
696             mstore8(dest, data)
697             // Update buffer length if we extended it
698             if eq(off, buflen) {
699                 mstore(bufptr, add(buflen, 1))
700             }
701         }
702         return buf;
703     }
704 
705     /**
706     * @dev Appends a byte to the buffer. Resizes if doing so would exceed the
707     *      capacity of the buffer.
708     * @param buf The buffer to append to.
709     * @param data The data to append.
710     * @return The original buffer, for chaining.
711     */
712     function appendUint8(buffer memory buf, uint8 data) internal pure returns(buffer memory) {
713         return writeUint8(buf, buf.buf.length, data);
714     }
715 
716     /**
717     * @dev Writes up to 32 bytes to the buffer. Resizes if doing so would
718     *      exceed the capacity of the buffer.
719     * @param buf The buffer to append to.
720     * @param off The offset to write at.
721     * @param data The data to append.
722     * @param len The number of bytes to write (left-aligned).
723     * @return The original buffer, for chaining.
724     */
725     function write(buffer memory buf, uint off, bytes32 data, uint len) private pure returns(buffer memory) {
726         if (len + off > buf.capacity) {
727             resize(buf, (len + off) * 2);
728         }
729 
730         uint mask = 256 ** len - 1;
731         // Right-align data
732         data = data >> (8 * (32 - len));
733         assembly {
734             // Memory address of the buffer data
735             let bufptr := mload(buf)
736             // Address = buffer address + sizeof(buffer length) + off + len
737             let dest := add(add(bufptr, off), len)
738             mstore(dest, or(and(mload(dest), not(mask)), data))
739             // Update buffer length if we extended it
740             if gt(add(off, len), mload(bufptr)) {
741                 mstore(bufptr, add(off, len))
742             }
743         }
744         return buf;
745     }
746 
747     /**
748     * @dev Writes a bytes20 to the buffer. Resizes if doing so would exceed the
749     *      capacity of the buffer.
750     * @param buf The buffer to append to.
751     * @param off The offset to write at.
752     * @param data The data to append.
753     * @return The original buffer, for chaining.
754     */
755     function writeBytes20(buffer memory buf, uint off, bytes20 data) internal pure returns (buffer memory) {
756         return write(buf, off, bytes32(data), 20);
757     }
758 
759     /**
760     * @dev Appends a bytes20 to the buffer. Resizes if doing so would exceed
761     *      the capacity of the buffer.
762     * @param buf The buffer to append to.
763     * @param data The data to append.
764     * @return The original buffer, for chhaining.
765     */
766     function appendBytes20(buffer memory buf, bytes20 data) internal pure returns (buffer memory) {
767         return write(buf, buf.buf.length, bytes32(data), 20);
768     }
769 
770     /**
771     * @dev Appends a bytes32 to the buffer. Resizes if doing so would exceed
772     *      the capacity of the buffer.
773     * @param buf The buffer to append to.
774     * @param data The data to append.
775     * @return The original buffer, for chaining.
776     */
777     function appendBytes32(buffer memory buf, bytes32 data) internal pure returns (buffer memory) {
778         return write(buf, buf.buf.length, data, 32);
779     }
780 
781     /**
782     * @dev Writes an integer to the buffer. Resizes if doing so would exceed
783     *      the capacity of the buffer.
784     * @param buf The buffer to append to.
785     * @param off The offset to write at.
786     * @param data The data to append.
787     * @param len The number of bytes to write (right-aligned).
788     * @return The original buffer, for chaining.
789     */
790     function writeInt(buffer memory buf, uint off, uint data, uint len) private pure returns(buffer memory) {
791         if (len + off > buf.capacity) {
792             resize(buf, (len + off) * 2);
793         }
794 
795         uint mask = 256 ** len - 1;
796         assembly {
797             // Memory address of the buffer data
798             let bufptr := mload(buf)
799             // Address = buffer address + off + sizeof(buffer length) + len
800             let dest := add(add(bufptr, off), len)
801             mstore(dest, or(and(mload(dest), not(mask)), data))
802             // Update buffer length if we extended it
803             if gt(add(off, len), mload(bufptr)) {
804                 mstore(bufptr, add(off, len))
805             }
806         }
807         return buf;
808     }
809 
810     /**
811      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
812      * exceed the capacity of the buffer.
813      * @param buf The buffer to append to.
814      * @param data The data to append.
815      * @return The original buffer.
816      */
817     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
818         return writeInt(buf, buf.buf.length, data, len);
819     }
820 }
821 
822 // File: @ensdomains/dnssec-oracle/contracts/RRUtils.sol
823 
824 pragma solidity >0.4.23;
825 
826 
827 
828 /**
829 * @dev RRUtils is a library that provides utilities for parsing DNS resource records.
830 */
831 library RRUtils {
832     using BytesUtils for *;
833     using Buffer for *;
834 
835     /**
836     * @dev Returns the number of bytes in the DNS name at 'offset' in 'self'.
837     * @param self The byte array to read a name from.
838     * @param offset The offset to start reading at.
839     * @return The length of the DNS name at 'offset', in bytes.
840     */
841     function nameLength(bytes memory self, uint offset) internal pure returns(uint) {
842         uint idx = offset;
843         while (true) {
844             assert(idx < self.length);
845             uint labelLen = self.readUint8(idx);
846             idx += labelLen + 1;
847             if (labelLen == 0) {
848                 break;
849             }
850         }
851         return idx - offset;
852     }
853 
854     /**
855     * @dev Returns a DNS format name at the specified offset of self.
856     * @param self The byte array to read a name from.
857     * @param offset The offset to start reading at.
858     * @return The name.
859     */
860     function readName(bytes memory self, uint offset) internal pure returns(bytes memory ret) {
861         uint len = nameLength(self, offset);
862         return self.substring(offset, len);
863     }
864 
865     /**
866     * @dev Returns the number of labels in the DNS name at 'offset' in 'self'.
867     * @param self The byte array to read a name from.
868     * @param offset The offset to start reading at.
869     * @return The number of labels in the DNS name at 'offset', in bytes.
870     */
871     function labelCount(bytes memory self, uint offset) internal pure returns(uint) {
872         uint count = 0;
873         while (true) {
874             assert(offset < self.length);
875             uint labelLen = self.readUint8(offset);
876             offset += labelLen + 1;
877             if (labelLen == 0) {
878                 break;
879             }
880             count += 1;
881         }
882         return count;
883     }
884 
885     /**
886     * @dev An iterator over resource records.
887     */
888     struct RRIterator {
889         bytes data;
890         uint offset;
891         uint16 dnstype;
892         uint16 class;
893         uint32 ttl;
894         uint rdataOffset;
895         uint nextOffset;
896     }
897 
898     /**
899     * @dev Begins iterating over resource records.
900     * @param self The byte string to read from.
901     * @param offset The offset to start reading at.
902     * @return An iterator object.
903     */
904     function iterateRRs(bytes memory self, uint offset) internal pure returns (RRIterator memory ret) {
905         ret.data = self;
906         ret.nextOffset = offset;
907         next(ret);
908     }
909 
910     /**
911     * @dev Returns true iff there are more RRs to iterate.
912     * @param iter The iterator to check.
913     * @return True iff the iterator has finished.
914     */
915     function done(RRIterator memory iter) internal pure returns(bool) {
916         return iter.offset >= iter.data.length;
917     }
918 
919     /**
920     * @dev Moves the iterator to the next resource record.
921     * @param iter The iterator to advance.
922     */
923     function next(RRIterator memory iter) internal pure {
924         iter.offset = iter.nextOffset;
925         if (iter.offset >= iter.data.length) {
926             return;
927         }
928 
929         // Skip the name
930         uint off = iter.offset + nameLength(iter.data, iter.offset);
931 
932         // Read type, class, and ttl
933         iter.dnstype = iter.data.readUint16(off);
934         off += 2;
935         iter.class = iter.data.readUint16(off);
936         off += 2;
937         iter.ttl = iter.data.readUint32(off);
938         off += 4;
939 
940         // Read the rdata
941         uint rdataLength = iter.data.readUint16(off);
942         off += 2;
943         iter.rdataOffset = off;
944         iter.nextOffset = off + rdataLength;
945     }
946 
947     /**
948     * @dev Returns the name of the current record.
949     * @param iter The iterator.
950     * @return A new bytes object containing the owner name from the RR.
951     */
952     function name(RRIterator memory iter) internal pure returns(bytes memory) {
953         return iter.data.substring(iter.offset, nameLength(iter.data, iter.offset));
954     }
955 
956     /**
957     * @dev Returns the rdata portion of the current record.
958     * @param iter The iterator.
959     * @return A new bytes object containing the RR's RDATA.
960     */
961     function rdata(RRIterator memory iter) internal pure returns(bytes memory) {
962         return iter.data.substring(iter.rdataOffset, iter.nextOffset - iter.rdataOffset);
963     }
964 
965     /**
966     * @dev Checks if a given RR type exists in a type bitmap.
967     * @param self The byte string to read the type bitmap from.
968     * @param offset The offset to start reading at.
969     * @param rrtype The RR type to check for.
970     * @return True if the type is found in the bitmap, false otherwise.
971     */
972     function checkTypeBitmap(bytes memory self, uint offset, uint16 rrtype) internal pure returns (bool) {
973         uint8 typeWindow = uint8(rrtype >> 8);
974         uint8 windowByte = uint8((rrtype & 0xff) / 8);
975         uint8 windowBitmask = uint8(uint8(1) << (uint8(7) - uint8(rrtype & 0x7)));
976         for (uint off = offset; off < self.length;) {
977             uint8 window = self.readUint8(off);
978             uint8 len = self.readUint8(off + 1);
979             if (typeWindow < window) {
980                 // We've gone past our window; it's not here.
981                 return false;
982             } else if (typeWindow == window) {
983                 // Check this type bitmap
984                 if (len * 8 <= windowByte) {
985                     // Our type is past the end of the bitmap
986                     return false;
987                 }
988                 return (self.readUint8(off + windowByte + 2) & windowBitmask) != 0;
989             } else {
990                 // Skip this type bitmap
991                 off += len + 2;
992             }
993         }
994 
995         return false;
996     }
997 
998     function compareNames(bytes memory self, bytes memory other) internal pure returns (int) {
999         if (self.equals(other)) {
1000             return 0;
1001         }
1002 
1003         uint off;
1004         uint otheroff;
1005         uint prevoff;
1006         uint otherprevoff;
1007         uint counts = labelCount(self, 0);
1008         uint othercounts = labelCount(other, 0);
1009 
1010         // Keep removing labels from the front of the name until both names are equal length
1011         while (counts > othercounts) {
1012             prevoff = off;
1013             off = progress(self, off);
1014             counts--;
1015         }
1016 
1017         while (othercounts > counts) {
1018             otherprevoff = otheroff;
1019             otheroff = progress(other, otheroff);
1020             othercounts--;
1021         }
1022 
1023         // Compare the last nonequal labels to each other
1024         while (counts > 0 && !self.equals(off, other, otheroff)) {
1025             prevoff = off;
1026             off = progress(self, off);
1027             otherprevoff = otheroff;
1028             otheroff = progress(other, otheroff);
1029             counts -= 1;
1030         }
1031 
1032         if (off == 0) {
1033             return -1;
1034         }
1035         if(otheroff == 0) {
1036             return 1;
1037         }
1038 
1039         return self.compare(prevoff + 1, self.readUint8(prevoff), other, otherprevoff + 1, other.readUint8(otherprevoff));
1040     }
1041 
1042     function progress(bytes memory body, uint off) internal pure returns(uint) {
1043         return off + 1 + body.readUint8(off);
1044     }
1045 }
1046 
1047 // File: @ensdomains/resolver/contracts/profiles/DNSResolver.sol
1048 
1049 pragma solidity ^0.5.0;
1050 
1051 
1052 
1053 contract DNSResolver is ResolverBase {
1054     using RRUtils for *;
1055     using BytesUtils for bytes;
1056 
1057     bytes4 constant private DNS_RECORD_INTERFACE_ID = 0xa8fa5682;
1058 
1059     // DNSRecordChanged is emitted whenever a given node/name/resource's RRSET is updated.
1060     event DNSRecordChanged(bytes32 indexed node, bytes name, uint16 resource, bytes record);
1061     // DNSRecordDeleted is emitted whenever a given node/name/resource's RRSET is deleted.
1062     event DNSRecordDeleted(bytes32 indexed node, bytes name, uint16 resource);
1063     // DNSZoneCleared is emitted whenever a given node's zone information is cleared.
1064     event DNSZoneCleared(bytes32 indexed node);
1065 
1066     // Version the mapping for each zone.  This allows users who have lost
1067     // track of their entries to effectively delete an entire zone by bumping
1068     // the version number.
1069     // node => version
1070     mapping(bytes32=>uint256) private versions;
1071 
1072     // The records themselves.  Stored as binary RRSETs
1073     // node => version => name => resource => data
1074     mapping(bytes32=>mapping(uint256=>mapping(bytes32=>mapping(uint16=>bytes)))) private records;
1075 
1076     // Count of number of entries for a given name.  Required for DNS resolvers
1077     // when resolving wildcards.
1078     // node => version => name => number of records
1079     mapping(bytes32=>mapping(uint256=>mapping(bytes32=>uint16))) private nameEntriesCount;
1080 
1081     /**
1082      * Set one or more DNS records.  Records are supplied in wire-format.
1083      * Records with the same node/name/resource must be supplied one after the
1084      * other to ensure the data is updated correctly. For example, if the data
1085      * was supplied:
1086      *     a.example.com IN A 1.2.3.4
1087      *     a.example.com IN A 5.6.7.8
1088      *     www.example.com IN CNAME a.example.com.
1089      * then this would store the two A records for a.example.com correctly as a
1090      * single RRSET, however if the data was supplied:
1091      *     a.example.com IN A 1.2.3.4
1092      *     www.example.com IN CNAME a.example.com.
1093      *     a.example.com IN A 5.6.7.8
1094      * then this would store the first A record, the CNAME, then the second A
1095      * record which would overwrite the first.
1096      *
1097      * @param node the namehash of the node for which to set the records
1098      * @param data the DNS wire format records to set
1099      */
1100     function setDNSRecords(bytes32 node, bytes calldata data) external authorised(node) {
1101         uint16 resource = 0;
1102         uint256 offset = 0;
1103         bytes memory name;
1104         bytes memory value;
1105         bytes32 nameHash;
1106         // Iterate over the data to add the resource records
1107         for (RRUtils.RRIterator memory iter = data.iterateRRs(0); !iter.done(); iter.next()) {
1108             if (resource == 0) {
1109                 resource = iter.dnstype;
1110                 name = iter.name();
1111                 nameHash = keccak256(abi.encodePacked(name));
1112                 value = bytes(iter.rdata());
1113             } else {
1114                 bytes memory newName = iter.name();
1115                 if (resource != iter.dnstype || !name.equals(newName)) {
1116                     setDNSRRSet(node, name, resource, data, offset, iter.offset - offset, value.length == 0);
1117                     resource = iter.dnstype;
1118                     offset = iter.offset;
1119                     name = newName;
1120                     nameHash = keccak256(name);
1121                     value = bytes(iter.rdata());
1122                 }
1123             }
1124         }
1125         if (name.length > 0) {
1126             setDNSRRSet(node, name, resource, data, offset, data.length - offset, value.length == 0);
1127         }
1128     }
1129 
1130     /**
1131      * Obtain a DNS record.
1132      * @param node the namehash of the node for which to fetch the record
1133      * @param name the keccak-256 hash of the fully-qualified name for which to fetch the record
1134      * @param resource the ID of the resource as per https://en.wikipedia.org/wiki/List_of_DNS_record_types
1135      * @return the DNS record in wire format if present, otherwise empty
1136      */
1137     function dnsRecord(bytes32 node, bytes32 name, uint16 resource) public view returns (bytes memory) {
1138         return records[node][versions[node]][name][resource];
1139     }
1140 
1141     /**
1142      * Check if a given node has records.
1143      * @param node the namehash of the node for which to check the records
1144      * @param name the namehash of the node for which to check the records
1145      */
1146     function hasDNSRecords(bytes32 node, bytes32 name) public view returns (bool) {
1147         return (nameEntriesCount[node][versions[node]][name] != 0);
1148     }
1149 
1150     /**
1151      * Clear all information for a DNS zone.
1152      * @param node the namehash of the node for which to clear the zone
1153      */
1154     function clearDNSZone(bytes32 node) public authorised(node) {
1155         versions[node]++;
1156         emit DNSZoneCleared(node);
1157     }
1158 
1159     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
1160         return interfaceID == DNS_RECORD_INTERFACE_ID || super.supportsInterface(interfaceID);
1161     }
1162 
1163     function setDNSRRSet(
1164         bytes32 node,
1165         bytes memory name,
1166         uint16 resource,
1167         bytes memory data,
1168         uint256 offset,
1169         uint256 size,
1170         bool deleteRecord) private
1171     {
1172         uint256 version = versions[node];
1173         bytes32 nameHash = keccak256(name);
1174         bytes memory rrData = data.substring(offset, size);
1175         if (deleteRecord) {
1176             if (records[node][version][nameHash][resource].length != 0) {
1177                 nameEntriesCount[node][version][nameHash]--;
1178             }
1179             delete(records[node][version][nameHash][resource]);
1180             emit DNSRecordDeleted(node, name, resource);
1181         } else {
1182             if (records[node][version][nameHash][resource].length == 0) {
1183                 nameEntriesCount[node][version][nameHash]++;
1184             }
1185             records[node][version][nameHash][resource] = rrData;
1186             emit DNSRecordChanged(node, name, resource, rrData);
1187         }
1188     }
1189 }
1190 
1191 // File: @ensdomains/resolver/contracts/profiles/InterfaceResolver.sol
1192 
1193 pragma solidity ^0.5.0;
1194 
1195 
1196 
1197 contract InterfaceResolver is ResolverBase, AddrResolver {
1198     bytes4 constant private INTERFACE_INTERFACE_ID = bytes4(keccak256("interfaceImplementer(bytes32,bytes4)"));
1199     bytes4 private constant INTERFACE_META_ID = 0x01ffc9a7;
1200 
1201     event InterfaceChanged(bytes32 indexed node, bytes4 indexed interfaceID, address implementer);
1202 
1203     mapping(bytes32=>mapping(bytes4=>address)) interfaces;
1204 
1205     /**
1206      * Sets an interface associated with a name.
1207      * Setting the address to 0 restores the default behaviour of querying the contract at `addr()` for interface support.
1208      * @param node The node to update.
1209      * @param interfaceID The EIP 168 interface ID.
1210      * @param implementer The address of a contract that implements this interface for this node.
1211      */
1212     function setInterface(bytes32 node, bytes4 interfaceID, address implementer) external authorised(node) {
1213         interfaces[node][interfaceID] = implementer;
1214         emit InterfaceChanged(node, interfaceID, implementer);
1215     }
1216 
1217     /**
1218      * Returns the address of a contract that implements the specified interface for this name.
1219      * If an implementer has not been set for this interfaceID and name, the resolver will query
1220      * the contract at `addr()`. If `addr()` is set, a contract exists at that address, and that
1221      * contract implements EIP168 and returns `true` for the specified interfaceID, its address
1222      * will be returned.
1223      * @param node The ENS node to query.
1224      * @param interfaceID The EIP 168 interface ID to check for.
1225      * @return The address that implements this interface, or 0 if the interface is unsupported.
1226      */
1227     function interfaceImplementer(bytes32 node, bytes4 interfaceID) external view returns (address) {
1228         address implementer = interfaces[node][interfaceID];
1229         if(implementer != address(0)) {
1230             return implementer;
1231         }
1232 
1233         address a = addr(node);
1234         if(a == address(0)) {
1235             return address(0);
1236         }
1237 
1238         (bool success, bytes memory returnData) = a.staticcall(abi.encodeWithSignature("supportsInterface(bytes4)", INTERFACE_META_ID));
1239         if(!success || returnData.length < 32 || returnData[31] == 0) {
1240             // EIP 168 not supported by target
1241             return address(0);
1242         }
1243 
1244         (success, returnData) = a.staticcall(abi.encodeWithSignature("supportsInterface(bytes4)", interfaceID));
1245         if(!success || returnData.length < 32 || returnData[31] == 0) {
1246             // Specified interface not supported by target
1247             return address(0);
1248         }
1249 
1250         return a;
1251     }
1252 
1253     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
1254         return interfaceID == INTERFACE_INTERFACE_ID || super.supportsInterface(interfaceID);
1255     }
1256 }
1257 
1258 // File: @ensdomains/resolver/contracts/profiles/NameResolver.sol
1259 
1260 pragma solidity ^0.5.0;
1261 
1262 
1263 contract NameResolver is ResolverBase {
1264     bytes4 constant private NAME_INTERFACE_ID = 0x691f3431;
1265 
1266     event NameChanged(bytes32 indexed node, string name);
1267 
1268     mapping(bytes32=>string) names;
1269 
1270     /**
1271      * Sets the name associated with an ENS node, for reverse records.
1272      * May only be called by the owner of that node in the ENS registry.
1273      * @param node The node to update.
1274      * @param name The name to set.
1275      */
1276     function setName(bytes32 node, string calldata name) external authorised(node) {
1277         names[node] = name;
1278         emit NameChanged(node, name);
1279     }
1280 
1281     /**
1282      * Returns the name associated with an ENS node, for reverse records.
1283      * Defined in EIP181.
1284      * @param node The ENS node to query.
1285      * @return The associated name.
1286      */
1287     function name(bytes32 node) external view returns (string memory) {
1288         return names[node];
1289     }
1290 
1291     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
1292         return interfaceID == NAME_INTERFACE_ID || super.supportsInterface(interfaceID);
1293     }
1294 }
1295 
1296 // File: @ensdomains/resolver/contracts/profiles/PubkeyResolver.sol
1297 
1298 pragma solidity ^0.5.0;
1299 
1300 
1301 contract PubkeyResolver is ResolverBase {
1302     bytes4 constant private PUBKEY_INTERFACE_ID = 0xc8690233;
1303 
1304     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
1305 
1306     struct PublicKey {
1307         bytes32 x;
1308         bytes32 y;
1309     }
1310 
1311     mapping(bytes32=>PublicKey) pubkeys;
1312 
1313     /**
1314      * Sets the SECP256k1 public key associated with an ENS node.
1315      * @param node The ENS node to query
1316      * @param x the X coordinate of the curve point for the public key.
1317      * @param y the Y coordinate of the curve point for the public key.
1318      */
1319     function setPubkey(bytes32 node, bytes32 x, bytes32 y) external authorised(node) {
1320         pubkeys[node] = PublicKey(x, y);
1321         emit PubkeyChanged(node, x, y);
1322     }
1323 
1324     /**
1325      * Returns the SECP256k1 public key associated with an ENS node.
1326      * Defined in EIP 619.
1327      * @param node The ENS node to query
1328      * @return x, y the X and Y coordinates of the curve point for the public key.
1329      */
1330     function pubkey(bytes32 node) external view returns (bytes32 x, bytes32 y) {
1331         return (pubkeys[node].x, pubkeys[node].y);
1332     }
1333 
1334     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
1335         return interfaceID == PUBKEY_INTERFACE_ID || super.supportsInterface(interfaceID);
1336     }
1337 }
1338 
1339 // File: @ensdomains/resolver/contracts/profiles/TextResolver.sol
1340 
1341 pragma solidity ^0.5.0;
1342 
1343 
1344 contract TextResolver is ResolverBase {
1345     bytes4 constant private TEXT_INTERFACE_ID = 0x59d1d43c;
1346 
1347     event TextChanged(bytes32 indexed node, string indexed indexedKey, string key);
1348 
1349     mapping(bytes32=>mapping(string=>string)) texts;
1350 
1351     /**
1352      * Sets the text data associated with an ENS node and key.
1353      * May only be called by the owner of that node in the ENS registry.
1354      * @param node The node to update.
1355      * @param key The key to set.
1356      * @param value The text data value to set.
1357      */
1358     function setText(bytes32 node, string calldata key, string calldata value) external authorised(node) {
1359         texts[node][key] = value;
1360         emit TextChanged(node, key, key);
1361     }
1362 
1363     /**
1364      * Returns the text data associated with an ENS node and key.
1365      * @param node The ENS node to query.
1366      * @param key The text data key to query.
1367      * @return The associated text data.
1368      */
1369     function text(bytes32 node, string calldata key) external view returns (string memory) {
1370         return texts[node][key];
1371     }
1372 
1373     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
1374         return interfaceID == TEXT_INTERFACE_ID || super.supportsInterface(interfaceID);
1375     }
1376 }
1377 
1378 // File: @ensdomains/resolver/contracts/PublicResolver.sol
1379 
1380 pragma solidity ^0.5.0;
1381 
1382 
1383 
1384 
1385 
1386 
1387 
1388 
1389 
1390 
1391 /**
1392  * A simple resolver anyone can use; only allows the owner of a node to set its
1393  * address.
1394  */
1395 contract PublicResolver is ABIResolver, AddrResolver, ContentHashResolver, DNSResolver, InterfaceResolver, NameResolver, PubkeyResolver, TextResolver {
1396     ENS ens;
1397 
1398     /**
1399      * A mapping of authorisations. An address that is authorised for a name
1400      * may make any changes to the name that the owner could, but may not update
1401      * the set of authorisations.
1402      * (node, owner, caller) => isAuthorised
1403      */
1404     mapping(bytes32=>mapping(address=>mapping(address=>bool))) public authorisations;
1405 
1406     event AuthorisationChanged(bytes32 indexed node, address indexed owner, address indexed target, bool isAuthorised);
1407 
1408     constructor(ENS _ens) public {
1409         ens = _ens;
1410     }
1411 
1412     /**
1413      * @dev Sets or clears an authorisation.
1414      * Authorisations are specific to the caller. Any account can set an authorisation
1415      * for any name, but the authorisation that is checked will be that of the
1416      * current owner of a name. Thus, transferring a name effectively clears any
1417      * existing authorisations, and new authorisations can be set in advance of
1418      * an ownership transfer if desired.
1419      *
1420      * @param node The name to change the authorisation on.
1421      * @param target The address that is to be authorised or deauthorised.
1422      * @param isAuthorised True if the address should be authorised, or false if it should be deauthorised.
1423      */
1424     function setAuthorisation(bytes32 node, address target, bool isAuthorised) external {
1425         authorisations[node][msg.sender][target] = isAuthorised;
1426         emit AuthorisationChanged(node, msg.sender, target, isAuthorised);
1427     }
1428 
1429     function isAuthorised(bytes32 node) internal view returns(bool) {
1430         address owner = ens.owner(node);
1431         return owner == msg.sender || authorisations[node][owner][msg.sender];
1432     }
1433 }