1 pragma solidity ^0.4.23;
2 
3 // File: contracts/BytesUtils.sol
4 
5 library BytesUtils {
6     /*
7     * @dev Returns the keccak-256 hash of a byte range.
8     * @param self The byte string to hash.
9     * @param offset The position to start hashing at.
10     * @param len The number of bytes to hash.
11     * @return The hash of the byte range.
12     */
13     function keccak(bytes memory self, uint offset, uint len) internal pure returns (bytes32 ret) {
14         require(offset + len <= self.length);
15         assembly {
16             ret := sha3(add(add(self, 32), offset), len)
17         }
18     }
19 
20 
21     /*
22     * @dev Returns a positive number if `other` comes lexicographically after
23     *      `self`, a negative number if it comes before, or zero if the
24     *      contents of the two bytes are equal.
25     * @param self The first bytes to compare.
26     * @param other The second bytes to compare.
27     * @return The result of the comparison.
28     */
29     function compare(bytes memory self, bytes memory other) internal pure returns (int) {
30         return compare(self, 0, self.length, other, 0, other.length);
31     }
32 
33     /*
34     * @dev Returns a positive number if `other` comes lexicographically after
35     *      `self`, a negative number if it comes before, or zero if the
36     *      contents of the two bytes are equal. Comparison is done per-rune,
37     *      on unicode codepoints.
38     * @param self The first bytes to compare.
39     * @param offset The offset of self.
40     * @param len    The length of self.
41     * @param other The second bytes to compare.
42     * @param otheroffset The offset of the other string.
43     * @param otherlen    The length of the other string.
44     * @return The result of the comparison.
45     */
46     function compare(bytes memory self, uint offset, uint len, bytes memory other, uint otheroffset, uint otherlen) internal pure returns (int) {
47         uint shortest = len;
48         if (otherlen < len)
49         shortest = otherlen;
50 
51         uint selfptr;
52         uint otherptr;
53 
54         assembly {
55             selfptr := add(self, add(offset, 32))
56             otherptr := add(other, add(otheroffset, 32))
57         }
58         for (uint idx = 0; idx < shortest; idx += 32) {
59             uint a;
60             uint b;
61             assembly {
62                 a := mload(selfptr)
63                 b := mload(otherptr)
64             }
65             if (a != b) {
66                 // Mask out irrelevant bytes and check again
67                 uint mask;
68                 if (shortest > 32) {
69                     mask = uint256(- 1); // aka 0xffffff....
70                 } else {
71                     mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
72                 }
73                 uint diff = (a & mask) - (b & mask);
74                 if (diff != 0)
75                 return int(diff);
76             }
77             selfptr += 32;
78             otherptr += 32;
79         }
80 
81         return int(len) - int(otherlen);
82     }
83 
84     /*
85     * @dev Returns true if the two byte ranges are equal.
86     * @param self The first byte range to compare.
87     * @param offset The offset into the first byte range.
88     * @param other The second byte range to compare.
89     * @param otherOffset The offset into the second byte range.
90     * @param len The number of bytes to compare
91     * @return True if the byte ranges are equal, false otherwise.
92     */
93     function equals(bytes memory self, uint offset, bytes memory other, uint otherOffset, uint len) internal pure returns (bool) {
94         return keccak(self, offset, len) == keccak(other, otherOffset, len);
95     }
96 
97     /*
98     * @dev Returns true if the two byte ranges are equal with offsets.
99     * @param self The first byte range to compare.
100     * @param offset The offset into the first byte range.
101     * @param other The second byte range to compare.
102     * @param otherOffset The offset into the second byte range.
103     * @return True if the byte ranges are equal, false otherwise.
104     */
105     function equals(bytes memory self, uint offset, bytes memory other, uint otherOffset) internal pure returns (bool) {
106         return keccak(self, offset, self.length - offset) == keccak(other, otherOffset, other.length - otherOffset);
107     }
108 
109     /*
110     * @dev Compares a range of 'self' to all of 'other' and returns True iff
111     *      they are equal.
112     * @param self The first byte range to compare.
113     * @param offset The offset into the first byte range.
114     * @param other The second byte range to compare.
115     * @return True if the byte ranges are equal, false otherwise.
116     */
117     function equals(bytes memory self, uint offset, bytes memory other) internal pure returns (bool) {
118         return self.length >= offset + other.length && equals(self, offset, other, 0, other.length);
119     }
120 
121     /*
122     * @dev Returns true if the two byte ranges are equal.
123     * @param self The first byte range to compare.
124     * @param other The second byte range to compare.
125     * @return True if the byte ranges are equal, false otherwise.
126     */
127     function equals(bytes memory self, bytes memory other) internal pure returns(bool) {
128         return self.length == other.length && equals(self, 0, other, 0, self.length);
129     }
130 
131     /*
132     * @dev Returns the 8-bit number at the specified index of self.
133     * @param self The byte string.
134     * @param idx The index into the bytes
135     * @return The specified 8 bits of the string, interpreted as an integer.
136     */
137     function readUint8(bytes memory self, uint idx) internal pure returns (uint8 ret) {
138         require(idx + 1 <= self.length);
139         assembly {
140             ret := and(mload(add(add(self, 1), idx)), 0xFF)
141         }
142     }
143 
144     /*
145     * @dev Returns the 16-bit number at the specified index of self.
146     * @param self The byte string.
147     * @param idx The index into the bytes
148     * @return The specified 16 bits of the string, interpreted as an integer.
149     */
150     function readUint16(bytes memory self, uint idx) internal pure returns (uint16 ret) {
151         require(idx + 2 <= self.length);
152         assembly {
153             ret := and(mload(add(add(self, 2), idx)), 0xFFFF)
154         }
155     }
156 
157     /*
158     * @dev Returns the 32-bit number at the specified index of self.
159     * @param self The byte string.
160     * @param idx The index into the bytes
161     * @return The specified 32 bits of the string, interpreted as an integer.
162     */
163     function readUint32(bytes memory self, uint idx) internal pure returns (uint32 ret) {
164         require(idx + 4 <= self.length);
165         assembly {
166             ret := and(mload(add(add(self, 4), idx)), 0xFFFFFFFF)
167         }
168     }
169 
170     /*
171     * @dev Returns the 32 byte value at the specified index of self.
172     * @param self The byte string.
173     * @param idx The index into the bytes
174     * @return The specified 32 bytes of the string.
175     */
176     function readBytes32(bytes memory self, uint idx) internal pure returns (bytes32 ret) {
177         require(idx + 32 <= self.length);
178         assembly {
179             ret := mload(add(add(self, 32), idx))
180         }
181     }
182 
183     /*
184     * @dev Returns the 32 byte value at the specified index of self.
185     * @param self The byte string.
186     * @param idx The index into the bytes
187     * @return The specified 32 bytes of the string.
188     */
189     function readBytes20(bytes memory self, uint idx) internal pure returns (bytes20 ret) {
190         require(idx + 20 <= self.length);
191         assembly {
192             ret := and(mload(add(add(self, 32), idx)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000)
193         }
194     }
195 
196     /*
197     * @dev Returns the n byte value at the specified index of self.
198     * @param self The byte string.
199     * @param idx The index into the bytes.
200     * @param len The number of bytes.
201     * @return The specified 32 bytes of the string.
202     */
203     function readBytesN(bytes memory self, uint idx, uint len) internal pure returns (bytes20 ret) {
204         require(idx + len <= self.length);
205         assembly {
206             let mask := not(sub(exp(256, sub(32, len)), 1))
207             ret := and(mload(add(add(self, 32), idx)),  mask)
208         }
209     }
210 
211     function memcpy(uint dest, uint src, uint len) private pure {
212         // Copy word-length chunks while possible
213         for (; len >= 32; len -= 32) {
214             assembly {
215                 mstore(dest, mload(src))
216             }
217             dest += 32;
218             src += 32;
219         }
220 
221         // Copy remaining bytes
222         uint mask = 256 ** (32 - len) - 1;
223         assembly {
224             let srcpart := and(mload(src), not(mask))
225             let destpart := and(mload(dest), mask)
226             mstore(dest, or(destpart, srcpart))
227         }
228     }
229 
230     /*
231     * @dev Copies a substring into a new byte string.
232     * @param self The byte string to copy from.
233     * @param offset The offset to start copying at.
234     * @param len The number of bytes to copy.
235     */
236     function substring(bytes memory self, uint offset, uint len) internal pure returns(bytes) {
237         require(offset + len <= self.length);
238 
239         bytes memory ret = new bytes(len);
240         uint dest;
241         uint src;
242 
243         assembly {
244             dest := add(ret, 32)
245             src := add(add(self, 32), offset)
246         }
247         memcpy(dest, src, len);
248 
249         return ret;
250     }
251 
252     // Maps characters from 0x30 to 0x7A to their base32 values.
253     // 0xFF represents invalid characters in that range.
254     bytes constant base32HexTable = hex'00010203040506070809FFFFFFFFFFFFFF0A0B0C0D0E0F101112131415161718191A1B1C1D1E1FFFFFFFFFFFFFFFFFFFFF0A0B0C0D0E0F101112131415161718191A1B1C1D1E1F';
255 
256     /**
257      * @dev Decodes unpadded base32 data of up to one word in length.
258      * @param self The data to decode.
259      * @param off Offset into the string to start at.
260      * @param len Number of characters to decode.
261      * @return The decoded data, left aligned.
262      */
263     function base32HexDecodeWord(bytes memory self, uint off, uint len) internal pure returns(bytes32) {
264         require(len <= 52);
265 
266         uint ret = 0;
267         for(uint i = 0; i < len; i++) {
268             byte char = self[off + i];
269             require(char >= 0x30 && char <= 0x7A);
270             uint8 decoded = uint8(base32HexTable[uint(char) - 0x30]);
271             require(decoded <= 0x20);
272             if(i == len - 1) {
273                 break;
274             }
275             ret = (ret << 5) | decoded;
276         }
277 
278         uint bitlen = len * 5;
279         if(len % 8 == 0) {
280             // Multiple of 8 characters, no padding
281             ret = (ret << 5) | decoded;
282         } else if(len % 8 == 2) {
283             // Two extra characters - 1 byte
284             ret = (ret << 3) | (decoded >> 2);
285             bitlen -= 2;
286         } else if(len % 8 == 4) {
287             // Four extra characters - 2 bytes
288             ret = (ret << 1) | (decoded >> 4);
289             bitlen -= 4;
290         } else if(len % 8 == 5) {
291             // Five extra characters - 3 bytes
292             ret = (ret << 4) | (decoded >> 1);
293             bitlen -= 1;
294         } else if(len % 8 == 7) {
295             // Seven extra characters - 4 bytes
296             ret = (ret << 2) | (decoded >> 3);
297             bitlen -= 3;
298         } else {
299             revert();
300         }
301 
302         return bytes32(ret << (256 - bitlen));
303     }
304 }
305 
306 // File: contracts/DNSSEC.sol
307 
308 interface DNSSEC {
309 
310     event AlgorithmUpdated(uint8 id, address addr);
311     event DigestUpdated(uint8 id, address addr);
312     event NSEC3DigestUpdated(uint8 id, address addr);
313     event RRSetUpdated(bytes name, bytes rrset);
314 
315     function submitRRSets(bytes memory data, bytes memory proof) public returns (bytes);
316     function submitRRSet(bytes memory input, bytes memory sig, bytes memory proof) public returns(bytes memory rrs);
317     function deleteRRSet(uint16 deleteType, bytes deleteName, bytes memory nsec, bytes memory sig, bytes memory proof) public;
318     function rrdata(uint16 dnstype, bytes memory name) public view returns (uint32, uint64, bytes20);
319 
320 }
321 
322 // File: contracts/Owned.sol
323 
324 /**
325 * @dev Contract mixin for 'owned' contracts.
326 */
327 contract Owned {
328     address public owner;
329 
330     constructor() public {
331         owner = msg.sender;
332     }
333 
334     modifier owner_only() {
335         require(msg.sender == owner);
336         _;
337     }
338 
339     function setOwner(address newOwner) public owner_only {
340         owner = newOwner;
341     }
342 }
343 
344 // File: @ensdomains/buffer/contracts/Buffer.sol
345 
346 /**
347 * @dev A library for working with mutable byte buffers in Solidity.
348 *
349 * Byte buffers are mutable and expandable, and provide a variety of primitives
350 * for writing to them. At any time you can fetch a bytes object containing the
351 * current contents of the buffer. The bytes object should not be stored between
352 * operations, as it may change due to resizing of the buffer.
353 */
354 library Buffer {
355     /**
356     * @dev Represents a mutable buffer. Buffers have a current value (buf) and
357     *      a capacity. The capacity may be longer than the current value, in
358     *      which case it can be extended without the need to allocate more memory.
359     */
360     struct buffer {
361         bytes buf;
362         uint capacity;
363     }
364 
365     /**
366     * @dev Initializes a buffer with an initial capacity.
367     * @param buf The buffer to initialize.
368     * @param capacity The number of bytes of space to allocate the buffer.
369     * @return The buffer, for chaining.
370     */
371     function init(buffer memory buf, uint capacity) internal pure returns(buffer memory) {
372         if (capacity % 32 != 0) {
373             capacity += 32 - (capacity % 32);
374         }
375         // Allocate space for the buffer data
376         buf.capacity = capacity;
377         assembly {
378             let ptr := mload(0x40)
379             mstore(buf, ptr)
380             mstore(ptr, 0)
381             mstore(0x40, add(ptr, capacity))
382         }
383         return buf;
384     }
385 
386     /**
387     * @dev Initializes a new buffer from an existing bytes object.
388     *      Changes to the buffer may mutate the original value.
389     * @param b The bytes object to initialize the buffer with.
390     * @return A new buffer.
391     */
392     function fromBytes(bytes b) internal pure returns(buffer memory) {
393         buffer memory buf;
394         buf.buf = b;
395         buf.capacity = b.length;
396         return buf;
397     }
398 
399     function resize(buffer memory buf, uint capacity) private pure {
400         bytes memory oldbuf = buf.buf;
401         init(buf, capacity);
402         append(buf, oldbuf);
403     }
404 
405     function max(uint a, uint b) private pure returns(uint) {
406         if (a > b) {
407             return a;
408         }
409         return b;
410     }
411 
412     /**
413     * @dev Sets buffer length to 0.
414     * @param buf The buffer to truncate.
415     * @return The original buffer, for chaining..
416     */
417     function truncate(buffer memory buf) internal pure returns (buffer memory) {
418         assembly {
419             let bufptr := mload(buf)
420             mstore(bufptr, 0)
421         }
422         return buf;
423     }
424 
425     /**
426     * @dev Writes a byte string to a buffer. Resizes if doing so would exceed
427     *      the capacity of the buffer.
428     * @param buf The buffer to append to.
429     * @param off The start offset to write to.
430     * @param data The data to append.
431     * @param len The number of bytes to copy.
432     * @return The original buffer, for chaining.
433     */
434     function write(buffer memory buf, uint off, bytes data, uint len) internal pure returns(buffer memory) {
435         require(len <= data.length);
436 
437         if (off + len + buf.buf.length > buf.capacity) {
438             resize(buf, max(buf.capacity, len + off) * 2);
439         }
440 
441         uint dest;
442         uint src;
443         assembly {
444             // Memory address of the buffer data
445             let bufptr := mload(buf)
446             // Length of existing buffer data
447             let buflen := mload(bufptr)
448             // Start address = buffer address + offset + sizeof(buffer length)
449             dest := add(add(bufptr, 32), off)
450             // Update buffer length if we're extending it
451             if gt(add(len, off), buflen) {
452                 mstore(bufptr, add(len, off))
453             }
454             src := add(data, 32)
455         }
456 
457         // Copy word-length chunks while possible
458         for (; len >= 32; len -= 32) {
459             assembly {
460                 mstore(dest, mload(src))
461             }
462             dest += 32;
463             src += 32;
464         }
465 
466         // Copy remaining bytes
467         uint mask = 256 ** (32 - len) - 1;
468         assembly {
469             let srcpart := and(mload(src), not(mask))
470             let destpart := and(mload(dest), mask)
471             mstore(dest, or(destpart, srcpart))
472         }
473 
474         return buf;
475     }
476 
477     /**
478     * @dev Appends a byte string to a buffer. Resizes if doing so would exceed
479     *      the capacity of the buffer.
480     * @param buf The buffer to append to.
481     * @param data The data to append.
482     * @param len The number of bytes to copy.
483     * @return The original buffer, for chaining.
484     */
485     function append(buffer memory buf, bytes data, uint len) internal pure returns (buffer memory) {
486         return write(buf, buf.buf.length, data, len);
487     }
488 
489     /**
490     * @dev Appends a byte string to a buffer. Resizes if doing so would exceed
491     *      the capacity of the buffer.
492     * @param buf The buffer to append to.
493     * @param data The data to append.
494     * @return The original buffer, for chaining.
495     */
496     function append(buffer memory buf, bytes data) internal pure returns (buffer memory) {
497         return write(buf, buf.buf.length, data, data.length);
498     }
499 
500     /**
501     * @dev Writes a byte to the buffer. Resizes if doing so would exceed the
502     *      capacity of the buffer.
503     * @param buf The buffer to append to.
504     * @param off The offset to write the byte at.
505     * @param data The data to append.
506     * @return The original buffer, for chaining.
507     */
508     function writeUint8(buffer memory buf, uint off, uint8 data) internal pure returns(buffer memory) {
509         if (off > buf.capacity) {
510             resize(buf, buf.capacity * 2);
511         }
512 
513         assembly {
514             // Memory address of the buffer data
515             let bufptr := mload(buf)
516             // Length of existing buffer data
517             let buflen := mload(bufptr)
518             // Address = buffer address + sizeof(buffer length) + off
519             let dest := add(add(bufptr, off), 32)
520             mstore8(dest, data)
521             // Update buffer length if we extended it
522             if eq(off, buflen) {
523                 mstore(bufptr, add(buflen, 1))
524             }
525         }
526         return buf;
527     }
528 
529     /**
530     * @dev Appends a byte to the buffer. Resizes if doing so would exceed the
531     *      capacity of the buffer.
532     * @param buf The buffer to append to.
533     * @param data The data to append.
534     * @return The original buffer, for chaining.
535     */
536     function appendUint8(buffer memory buf, uint8 data) internal pure returns(buffer memory) {
537         return writeUint8(buf, buf.buf.length, data);
538     }
539 
540     /**
541     * @dev Writes up to 32 bytes to the buffer. Resizes if doing so would
542     *      exceed the capacity of the buffer.
543     * @param buf The buffer to append to.
544     * @param off The offset to write at.
545     * @param data The data to append.
546     * @param len The number of bytes to write (left-aligned).
547     * @return The original buffer, for chaining.
548     */
549     function write(buffer memory buf, uint off, bytes32 data, uint len) private pure returns(buffer memory) {
550         if (len + off > buf.capacity) {
551             resize(buf, max(buf.capacity, len) * 2);
552         }
553 
554         uint mask = 256 ** len - 1;
555         // Right-align data
556         data = data >> (8 * (32 - len));
557         assembly {
558             // Memory address of the buffer data
559             let bufptr := mload(buf)
560             // Address = buffer address + sizeof(buffer length) + off + len
561             let dest := add(add(bufptr, off), len)
562             mstore(dest, or(and(mload(dest), not(mask)), data))
563             // Update buffer length if we extended it
564             if gt(add(off, len), mload(bufptr)) {
565                 mstore(bufptr, add(off, len))
566             }
567         }
568         return buf;
569     }
570 
571     /**
572     * @dev Writes a bytes20 to the buffer. Resizes if doing so would exceed the
573     *      capacity of the buffer.
574     * @param buf The buffer to append to.
575     * @param off The offset to write at.
576     * @param data The data to append.
577     * @return The original buffer, for chaining.
578     */
579     function writeBytes20(buffer memory buf, uint off, bytes20 data) internal pure returns (buffer memory) {
580         return write(buf, off, bytes32(data), 20);
581     }
582 
583     /**
584     * @dev Appends a bytes20 to the buffer. Resizes if doing so would exceed
585     *      the capacity of the buffer.
586     * @param buf The buffer to append to.
587     * @param data The data to append.
588     * @return The original buffer, for chhaining.
589     */
590     function appendBytes20(buffer memory buf, bytes20 data) internal pure returns (buffer memory) {
591         return write(buf, buf.buf.length, bytes32(data), 20);
592     }
593 
594     /**
595     * @dev Appends a bytes32 to the buffer. Resizes if doing so would exceed
596     *      the capacity of the buffer.
597     * @param buf The buffer to append to.
598     * @param data The data to append.
599     * @return The original buffer, for chaining.
600     */
601     function appendBytes32(buffer memory buf, bytes32 data) internal pure returns (buffer memory) {
602         return write(buf, buf.buf.length, data, 32);
603     }
604 
605     /**
606     * @dev Writes an integer to the buffer. Resizes if doing so would exceed
607     *      the capacity of the buffer.
608     * @param buf The buffer to append to.
609     * @param off The offset to write at.
610     * @param data The data to append.
611     * @param len The number of bytes to write (right-aligned).
612     * @return The original buffer, for chaining.
613     */
614     function writeInt(buffer memory buf, uint off, uint data, uint len) private pure returns(buffer memory) {
615         if (len + off > buf.capacity) {
616             resize(buf, max(buf.capacity, len + off) * 2);
617         }
618 
619         uint mask = 256 ** len - 1;
620         assembly {
621             // Memory address of the buffer data
622             let bufptr := mload(buf)
623             // Address = buffer address + off + sizeof(buffer length) + len
624             let dest := add(add(bufptr, off), len)
625             mstore(dest, or(and(mload(dest), not(mask)), data))
626             // Update buffer length if we extended it
627             if gt(add(off, len), mload(bufptr)) {
628                 mstore(bufptr, add(off, len))
629             }
630         }
631         return buf;
632     }
633 }
634 
635 // File: contracts/RRUtils.sol
636 
637 /**
638 * @dev RRUtils is a library that provides utilities for parsing DNS resource records.
639 */
640 library RRUtils {
641     using BytesUtils for *;
642     using Buffer for *;
643 
644     /**
645     * @dev Returns the number of bytes in the DNS name at 'offset' in 'self'.
646     * @param self The byte array to read a name from.
647     * @param offset The offset to start reading at.
648     * @return The length of the DNS name at 'offset', in bytes.
649     */
650     function nameLength(bytes memory self, uint offset) internal pure returns(uint) {
651         uint idx = offset;
652         while (true) {
653             assert(idx < self.length);
654             uint labelLen = self.readUint8(idx);
655             idx += labelLen + 1;
656             if (labelLen == 0) {
657                 break;
658             }
659         }
660         return idx - offset;
661     }
662 
663     /**
664     * @dev Returns a DNS format name at the specified offset of self.
665     * @param self The byte array to read a name from.
666     * @param offset The offset to start reading at.
667     * @return The name.
668     */
669     function readName(bytes memory self, uint offset) internal pure returns(bytes memory ret) {
670         uint len = nameLength(self, offset);
671         return self.substring(offset, len);
672     }
673 
674     /**
675     * @dev Returns the number of labels in the DNS name at 'offset' in 'self'.
676     * @param self The byte array to read a name from.
677     * @param offset The offset to start reading at.
678     * @return The number of labels in the DNS name at 'offset', in bytes.
679     */
680     function labelCount(bytes memory self, uint offset) internal pure returns(uint) {
681         uint count = 0;
682         while (true) {
683             assert(offset < self.length);
684             uint labelLen = self.readUint8(offset);
685             offset += labelLen + 1;
686             if (labelLen == 0) {
687                 break;
688             }
689             count += 1;
690         }
691         return count;
692     }
693 
694     /**
695     * @dev An iterator over resource records.
696     */
697     struct RRIterator {
698         bytes data;
699         uint offset;
700         uint16 dnstype;
701         uint16 class;
702         uint32 ttl;
703         uint rdataOffset;
704         uint nextOffset;
705     }
706 
707     /**
708     * @dev Begins iterating over resource records.
709     * @param self The byte string to read from.
710     * @param offset The offset to start reading at.
711     * @return An iterator object.
712     */
713     function iterateRRs(bytes memory self, uint offset) internal pure returns (RRIterator memory ret) {
714         ret.data = self;
715         ret.nextOffset = offset;
716         next(ret);
717     }
718 
719     /**
720     * @dev Returns true iff there are more RRs to iterate.
721     * @param iter The iterator to check.
722     * @return True iff the iterator has finished.
723     */
724     function done(RRIterator memory iter) internal pure returns(bool) {
725         return iter.offset >= iter.data.length;
726     }
727 
728     /**
729     * @dev Moves the iterator to the next resource record.
730     * @param iter The iterator to advance.
731     */
732     function next(RRIterator memory iter) internal pure {
733         iter.offset = iter.nextOffset;
734         if (iter.offset >= iter.data.length) {
735             return;
736         }
737 
738         // Skip the name
739         uint off = iter.offset + nameLength(iter.data, iter.offset);
740 
741         // Read type, class, and ttl
742         iter.dnstype = iter.data.readUint16(off);
743         off += 2;
744         iter.class = iter.data.readUint16(off);
745         off += 2;
746         iter.ttl = iter.data.readUint32(off);
747         off += 4;
748 
749         // Read the rdata
750         uint rdataLength = iter.data.readUint16(off);
751         off += 2;
752         iter.rdataOffset = off;
753         iter.nextOffset = off + rdataLength;
754     }
755 
756     /**
757     * @dev Returns the name of the current record.
758     * @param iter The iterator.
759     * @return A new bytes object containing the owner name from the RR.
760     */
761     function name(RRIterator memory iter) internal pure returns(bytes memory) {
762         return iter.data.substring(iter.offset, nameLength(iter.data, iter.offset));
763     }
764 
765     /**
766     * @dev Returns the rdata portion of the current record.
767     * @param iter The iterator.
768     * @return A new bytes object containing the RR's RDATA.
769     */
770     function rdata(RRIterator memory iter) internal pure returns(bytes memory) {
771         return iter.data.substring(iter.rdataOffset, iter.nextOffset - iter.rdataOffset);
772     }
773 
774     /**
775     * @dev Checks if a given RR type exists in a type bitmap.
776     * @param self The byte string to read the type bitmap from.
777     * @param offset The offset to start reading at.
778     * @param rrtype The RR type to check for.
779     * @return True if the type is found in the bitmap, false otherwise.
780     */
781     function checkTypeBitmap(bytes memory self, uint offset, uint16 rrtype) internal pure returns (bool) {
782         uint8 typeWindow = uint8(rrtype >> 8);
783         uint8 windowByte = uint8((rrtype & 0xff) / 8);
784         uint8 windowBitmask = uint8(uint8(1) << (uint8(7) - uint8(rrtype & 0x7)));
785         for (uint off = offset; off < self.length;) {
786             uint8 window = self.readUint8(off);
787             uint8 len = self.readUint8(off + 1);
788             if (typeWindow < window) {
789                 // We've gone past our window; it's not here.
790                 return false;
791             } else if (typeWindow == window) {
792                 // Check this type bitmap
793                 if (len * 8 <= windowByte) {
794                     // Our type is past the end of the bitmap
795                     return false;
796                 }
797                 return (self.readUint8(off + windowByte + 2) & windowBitmask) != 0;
798             } else {
799                 // Skip this type bitmap
800                 off += len + 2;
801             }
802         }
803 
804         return false;
805     }
806 
807     function compareNames(bytes memory self, bytes memory other) internal pure returns (int) {
808         if (self.equals(other)) {
809             return 0;
810         }
811 
812         uint off;
813         uint otheroff;
814         uint prevoff;
815         uint otherprevoff;
816         uint counts = labelCount(self, 0);
817         uint othercounts = labelCount(other, 0);
818 
819         // Keep removing labels from the front of the name until both names are equal length
820         while (counts > othercounts) {
821             prevoff = off;
822             off = progress(self, off);
823             counts--;
824         }
825 
826         while (othercounts > counts) {
827             otherprevoff = otheroff;
828             otheroff = progress(other, otheroff);
829             othercounts--;
830         }
831 
832         // Compare the last nonequal labels to each other
833         while (counts > 0 && !self.equals(off, other, otheroff)) {
834             prevoff = off;
835             off = progress(self, off);
836             otherprevoff = otheroff;
837             otheroff = progress(other, otheroff);
838             counts -= 1;
839         }
840 
841         if (off == 0) {
842             return -1;
843         }
844         if(otheroff == 0) {
845             return 1;
846         }
847 
848         return self.compare(prevoff + 1, self.readUint8(prevoff), other, otherprevoff + 1, other.readUint8(otherprevoff));
849     }
850 
851     function progress(bytes memory body, uint off) internal pure returns(uint) {
852         return off + 1 + body.readUint8(off);
853     }
854 }
855 
856 // File: contracts/algorithms/Algorithm.sol
857 
858 /**
859 * @dev An interface for contracts implementing a DNSSEC (signing) algorithm.
860 */
861 interface Algorithm {
862     /**
863     * @dev Verifies a signature.
864     * @param key The public key to verify with.
865     * @param data The signed data to verify.
866     * @param signature The signature to verify.
867     * @return True iff the signature is valid.
868     */
869     function verify(bytes key, bytes data, bytes signature) external view returns (bool);
870 }
871 
872 // File: contracts/digests/Digest.sol
873 
874 /**
875 * @dev An interface for contracts implementing a DNSSEC digest.
876 */
877 interface Digest {
878     /**
879     * @dev Verifies a cryptographic hash.
880     * @param data The data to hash.
881     * @param hash The hash to compare to.
882     * @return True iff the hashed data matches the provided hash value.
883     */
884     function verify(bytes data, bytes hash) external pure returns (bool);
885 }
886 
887 // File: contracts/nsec3digests/NSEC3Digest.sol
888 
889 /**
890  * @dev Interface for contracts that implement NSEC3 digest algorithms.
891  */
892 interface NSEC3Digest {
893     /**
894      * @dev Performs an NSEC3 iterated hash.
895      * @param salt The salt value to use on each iteration.
896      * @param data The data to hash.
897      * @param iterations The number of iterations to perform.
898      * @return The result of the iterated hash operation.
899      */
900      function hash(bytes salt, bytes data, uint iterations) external pure returns (bytes32);
901 }
902 
903 // File: contracts/DNSSECImpl.sol
904 
905 /*
906  * @dev An oracle contract that verifies and stores DNSSEC-validated DNS records.
907  *
908  * TODO: Support for NSEC3 records
909  * TODO: Use 'serial number math' for inception/expiration
910  */
911 contract DNSSECImpl is DNSSEC, Owned {
912     using Buffer for Buffer.buffer;
913     using BytesUtils for bytes;
914     using RRUtils for *;
915 
916     uint16 constant DNSCLASS_IN = 1;
917 
918     uint16 constant DNSTYPE_DS = 43;
919     uint16 constant DNSTYPE_RRSIG = 46;
920     uint16 constant DNSTYPE_NSEC = 47;
921     uint16 constant DNSTYPE_DNSKEY = 48;
922     uint16 constant DNSTYPE_NSEC3 = 50;
923 
924     uint constant DS_KEY_TAG = 0;
925     uint constant DS_ALGORITHM = 2;
926     uint constant DS_DIGEST_TYPE = 3;
927     uint constant DS_DIGEST = 4;
928 
929     uint constant RRSIG_TYPE = 0;
930     uint constant RRSIG_ALGORITHM = 2;
931     uint constant RRSIG_LABELS = 3;
932     uint constant RRSIG_TTL = 4;
933     uint constant RRSIG_EXPIRATION = 8;
934     uint constant RRSIG_INCEPTION = 12;
935     uint constant RRSIG_KEY_TAG = 16;
936     uint constant RRSIG_SIGNER_NAME = 18;
937 
938     uint constant DNSKEY_FLAGS = 0;
939     uint constant DNSKEY_PROTOCOL = 2;
940     uint constant DNSKEY_ALGORITHM = 3;
941     uint constant DNSKEY_PUBKEY = 4;
942 
943     uint constant DNSKEY_FLAG_ZONEKEY = 0x100;
944 
945     uint constant NSEC3_HASH_ALGORITHM = 0;
946     uint constant NSEC3_FLAGS = 1;
947     uint constant NSEC3_ITERATIONS = 2;
948     uint constant NSEC3_SALT_LENGTH = 4;
949     uint constant NSEC3_SALT = 5;
950 
951     uint8 constant ALGORITHM_RSASHA256 = 8;
952 
953     uint8 constant DIGEST_ALGORITHM_SHA256 = 2;
954 
955     struct RRSet {
956         uint32 inception;
957         uint64 inserted;
958         bytes20 hash;
959     }
960 
961     // (name, type) => RRSet
962     mapping (bytes32 => mapping(uint16 => RRSet)) rrsets;
963 
964     bytes public anchors;
965 
966     mapping (uint8 => Algorithm) public algorithms;
967     mapping (uint8 => Digest) public digests;
968     mapping (uint8 => NSEC3Digest) public nsec3Digests;
969 
970     /**
971      * @dev Constructor.
972      * @param _anchors The binary format RR entries for the root DS records.
973      */
974     constructor(bytes _anchors) public {
975         // Insert the 'trust anchors' - the key hashes that start the chain
976         // of trust for all other records.
977         anchors = _anchors;
978         rrsets[keccak256(hex"00")][DNSTYPE_DS] = RRSet({
979             inception: uint32(0),
980             inserted: uint64(now),
981             hash: bytes20(keccak256(anchors))
982         });
983         emit RRSetUpdated(hex"00", anchors);
984     }
985 
986     /**
987      * @dev Sets the contract address for a signature verification algorithm.
988      *      Callable only by the owner.
989      * @param id The algorithm ID
990      * @param algo The address of the algorithm contract.
991      */
992     function setAlgorithm(uint8 id, Algorithm algo) public owner_only {
993         algorithms[id] = algo;
994         emit AlgorithmUpdated(id, algo);
995     }
996 
997     /**
998      * @dev Sets the contract address for a digest verification algorithm.
999      *      Callable only by the owner.
1000      * @param id The digest ID
1001      * @param digest The address of the digest contract.
1002      */
1003     function setDigest(uint8 id, Digest digest) public owner_only {
1004         digests[id] = digest;
1005         emit DigestUpdated(id, digest);
1006     }
1007 
1008     /**
1009      * @dev Sets the contract address for an NSEC3 digest algorithm.
1010      *      Callable only by the owner.
1011      * @param id The digest ID
1012      * @param digest The address of the digest contract.
1013      */
1014     function setNSEC3Digest(uint8 id, NSEC3Digest digest) public owner_only {
1015         nsec3Digests[id] = digest;
1016         emit NSEC3DigestUpdated(id, digest);
1017     }
1018 
1019     /**
1020      * @dev Submits multiple RRSets
1021      * @param data The data to submit, as a series of chunks. Each chunk is
1022      *        in the format <uint16 length><bytes input><uint16 length><bytes sig>
1023      * @param proof The DNSKEY or DS to validate the first signature against.
1024      * @return The last RRSET submitted.
1025      */
1026     function submitRRSets(bytes memory data, bytes memory proof) public returns (bytes) {
1027         uint offset = 0;
1028         while(offset < data.length) {
1029             bytes memory input = data.substring(offset + 2, data.readUint16(offset));
1030             offset += input.length + 2;
1031             bytes memory sig = data.substring(offset + 2, data.readUint16(offset));
1032             offset += sig.length + 2;
1033             proof = submitRRSet(input, sig, proof);
1034         }
1035         return proof;
1036     }
1037 
1038     /**
1039      * @dev Submits a signed set of RRs to the oracle.
1040      *
1041      * RRSETs are only accepted if they are signed with a key that is already
1042      * trusted, or if they are self-signed, and the signing key is identified by
1043      * a DS record that is already trusted.
1044      *
1045      * @param input The signed RR set. This is in the format described in section
1046      *        5.3.2 of RFC4035: The RRDATA section from the RRSIG without the signature
1047      *        data, followed by a series of canonicalised RR records that the signature
1048      *        applies to.
1049      * @param sig The signature data from the RRSIG record.
1050      * @param proof The DNSKEY or DS to validate the signature against. Must Already
1051      *        have been submitted and proved previously.
1052      */
1053     function submitRRSet(bytes memory input, bytes memory sig, bytes memory proof)
1054         public returns(bytes memory rrs)
1055     {
1056         bytes memory name;
1057         (name, rrs) = validateSignedSet(input, sig, proof);
1058 
1059         uint32 inception = input.readUint32(RRSIG_INCEPTION);
1060         uint16 typecovered = input.readUint16(RRSIG_TYPE);
1061 
1062         RRSet storage set = rrsets[keccak256(name)][typecovered];
1063         if (set.inserted > 0) {
1064             // To replace an existing rrset, the signature must be at least as new
1065             require(inception >= set.inception);
1066         }
1067         if (set.hash == keccak256(rrs)) {
1068             // Already inserted!
1069             return;
1070         }
1071 
1072         rrsets[keccak256(name)][typecovered] = RRSet({
1073             inception: inception,
1074             inserted: uint64(now),
1075             hash: bytes20(keccak256(rrs))
1076         });
1077         emit RRSetUpdated(name, rrs);
1078     }
1079 
1080     /**
1081      * @dev Deletes an RR from the oracle.
1082      *
1083      * @param deleteType The DNS record type to delete.
1084      * @param deleteName which you want to delete
1085      * @param nsec The signed NSEC RRset. This is in the format described in section
1086      *        5.3.2 of RFC4035: The RRDATA section from the RRSIG without the signature
1087      *        data, followed by a series of canonicalised RR records that the signature
1088      *        applies to.
1089      */
1090     function deleteRRSet(uint16 deleteType, bytes deleteName, bytes memory nsec, bytes memory sig, bytes memory proof) public {
1091         bytes memory nsecName;
1092         bytes memory rrs;
1093         (nsecName, rrs) = validateSignedSet(nsec, sig, proof);
1094 
1095         // Don't let someone use an old proof to delete a new name
1096         require(rrsets[keccak256(deleteName)][deleteType].inception <= nsec.readUint32(RRSIG_INCEPTION));
1097 
1098         for (RRUtils.RRIterator memory iter = rrs.iterateRRs(0); !iter.done(); iter.next()) {
1099             // We're dealing with three names here:
1100             //   - deleteName is the name the user wants us to delete
1101             //   - nsecName is the owner name of the NSEC record
1102             //   - nextName is the next name specified in the NSEC record
1103             //
1104             // And three cases:
1105             //   - deleteName equals nsecName, in which case we can delete the
1106             //     record if it's not in the type bitmap.
1107             //   - nextName comes after nsecName, in which case we can delete
1108             //     the record if deleteName comes between nextName and nsecName.
1109             //   - nextName comes before nsecName, in which case nextName is the
1110             //     zone apez, and deleteName must come after nsecName.
1111 
1112             if(iter.dnstype == DNSTYPE_NSEC) {
1113                 checkNsecName(iter, nsecName, deleteName, deleteType);
1114             } else if(iter.dnstype == DNSTYPE_NSEC3) {
1115                 checkNsec3Name(iter, nsecName, deleteName, deleteType);
1116             } else {
1117                 revert("Unrecognised record type");
1118             }
1119 
1120             delete rrsets[keccak256(deleteName)][deleteType];
1121             return;
1122         }
1123         // This should never reach.
1124         revert();
1125     }
1126 
1127     function checkNsecName(RRUtils.RRIterator memory iter, bytes memory nsecName, bytes memory deleteName, uint16 deleteType) private pure {
1128         uint rdataOffset = iter.rdataOffset;
1129         uint nextNameLength = iter.data.nameLength(rdataOffset);
1130         uint rDataLength = iter.nextOffset - iter.rdataOffset;
1131 
1132         // We assume that there is always typed bitmap after the next domain name
1133         require(rDataLength > nextNameLength);
1134 
1135         int compareResult = deleteName.compareNames(nsecName);
1136         if(compareResult == 0) {
1137             // Name to delete is on the same label as the NSEC record
1138             require(!iter.data.checkTypeBitmap(rdataOffset + nextNameLength, deleteType));
1139         } else {
1140             // First check if the NSEC next name comes after the NSEC name.
1141             bytes memory nextName = iter.data.substring(rdataOffset,nextNameLength);
1142             // deleteName must come after nsecName
1143             require(compareResult > 0);
1144             if(nsecName.compareNames(nextName) < 0) {
1145                 // deleteName must also come before nextName
1146                 require(deleteName.compareNames(nextName) < 0);
1147             }
1148         }
1149     }
1150 
1151     function checkNsec3Name(RRUtils.RRIterator memory iter, bytes memory nsecName, bytes memory deleteName, uint16 deleteType) private view {
1152         uint16 iterations = iter.data.readUint16(iter.rdataOffset + NSEC3_ITERATIONS);
1153         uint8 saltLength = iter.data.readUint8(iter.rdataOffset + NSEC3_SALT_LENGTH);
1154         bytes memory salt = iter.data.substring(iter.rdataOffset + NSEC3_SALT, saltLength);
1155         bytes32 deleteNameHash = nsec3Digests[iter.data.readUint8(iter.rdataOffset)].hash(salt, deleteName, iterations);
1156 
1157         uint8 nextLength = iter.data.readUint8(iter.rdataOffset + NSEC3_SALT + saltLength);
1158         require(nextLength <= 32);
1159         bytes32 nextNameHash = iter.data.readBytesN(iter.rdataOffset + NSEC3_SALT + saltLength + 1, nextLength);
1160 
1161         bytes32 nsecNameHash = nsecName.base32HexDecodeWord(1, uint(nsecName.readUint8(0)));
1162 
1163         if(deleteNameHash == nsecNameHash) {
1164             // Name to delete is on the same label as the NSEC record
1165             require(!iter.data.checkTypeBitmap(iter.rdataOffset + NSEC3_SALT + saltLength + 1 + nextLength, deleteType));
1166         } else {
1167             // deleteName must come after nsecName
1168             require(deleteNameHash > nsecNameHash);
1169             // Check if the NSEC next name comes after the NSEC name.
1170             if(nextNameHash > nsecNameHash) {
1171                 // deleteName must come also come before nextName
1172                 require(deleteNameHash < nextNameHash);
1173             }
1174         }
1175     }
1176 
1177     /**
1178      * @dev Returns data about the RRs (if any) known to this oracle with the provided type and name.
1179      * @param dnstype The DNS record type to query.
1180      * @param name The name to query, in DNS label-sequence format.
1181      * @return inception The unix timestamp at which the signature for this RRSET was created.
1182      * @return inserted The unix timestamp at which this RRSET was inserted into the oracle.
1183      * @return hash The hash of the RRset that was inserted.
1184      */
1185     function rrdata(uint16 dnstype, bytes memory name) public view returns (uint32, uint64, bytes20) {
1186         RRSet storage result = rrsets[keccak256(name)][dnstype];
1187         return (result.inception, result.inserted, result.hash);
1188     }
1189 
1190     /**
1191      * @dev Submits a signed set of RRs to the oracle.
1192      *
1193      * RRSETs are only accepted if they are signed with a key that is already
1194      * trusted, or if they are self-signed, and the signing key is identified by
1195      * a DS record that is already trusted.
1196      *
1197      * @param input The signed RR set. This is in the format described in section
1198      *        5.3.2 of RFC4035: The RRDATA section from the RRSIG without the signature
1199      *        data, followed by a series of canonicalised RR records that the signature
1200      *        applies to.
1201      * @param sig The signature data from the RRSIG record.
1202      * @param proof The DNSKEY or DS to validate the signature against. Must Already
1203      *        have been submitted and proved previously.
1204      */
1205     function validateSignedSet(bytes memory input, bytes memory sig, bytes memory proof) internal view returns(bytes memory name, bytes memory rrs) {
1206         require(validProof(input.readName(RRSIG_SIGNER_NAME), proof));
1207 
1208         uint32 inception = input.readUint32(RRSIG_INCEPTION);
1209         uint32 expiration = input.readUint32(RRSIG_EXPIRATION);
1210         uint16 typecovered = input.readUint16(RRSIG_TYPE);
1211         uint8 labels = input.readUint8(RRSIG_LABELS);
1212 
1213         // Extract the RR data
1214         uint rrdataOffset = input.nameLength(RRSIG_SIGNER_NAME) + 18;
1215         rrs = input.substring(rrdataOffset, input.length - rrdataOffset);
1216 
1217         // Do some basic checks on the RRs and extract the name
1218         name = validateRRs(rrs, typecovered);
1219         require(name.labelCount(0) == labels);
1220 
1221         // TODO: Check inception and expiration using mod2^32 math
1222 
1223         // o  The validator's notion of the current time MUST be less than or
1224         //    equal to the time listed in the RRSIG RR's Expiration field.
1225         require(expiration > now);
1226 
1227         // o  The validator's notion of the current time MUST be greater than or
1228         //    equal to the time listed in the RRSIG RR's Inception field.
1229         require(inception < now);
1230 
1231         // Validate the signature
1232         verifySignature(name, input, sig, proof);
1233 
1234         return (name, rrs);
1235     }
1236 
1237     function validProof(bytes name, bytes memory proof) internal view returns(bool) {
1238         uint16 dnstype = proof.readUint16(proof.nameLength(0));
1239         return rrsets[keccak256(name)][dnstype].hash == bytes20(keccak256(proof));
1240     }
1241 
1242     /**
1243      * @dev Validates a set of RRs.
1244      * @param data The RR data.
1245      * @param typecovered The type covered by the RRSIG record.
1246      */
1247     function validateRRs(bytes memory data, uint16 typecovered) internal pure returns (bytes memory name) {
1248         // Iterate over all the RRs
1249         for (RRUtils.RRIterator memory iter = data.iterateRRs(0); !iter.done(); iter.next()) {
1250             // We only support class IN (Internet)
1251             require(iter.class == DNSCLASS_IN);
1252 
1253             if(name.length == 0) {
1254                 name = iter.name();
1255             } else {
1256                 // Name must be the same on all RRs
1257                 require(name.length == data.nameLength(iter.offset));
1258                 require(name.equals(0, data, iter.offset, name.length));
1259             }
1260 
1261             // o  The RRSIG RR's Type Covered field MUST equal the RRset's type.
1262             require(iter.dnstype == typecovered);
1263         }
1264     }
1265 
1266     /**
1267      * @dev Performs signature verification.
1268      *
1269      * Throws or reverts if unable to verify the record.
1270      *
1271      * @param name The name of the RRSIG record, in DNS label-sequence format.
1272      * @param data The original data to verify.
1273      * @param sig The signature data.
1274      */
1275     function verifySignature(bytes name, bytes memory data, bytes memory sig, bytes memory proof) internal view {
1276         uint signerNameLength = data.nameLength(RRSIG_SIGNER_NAME);
1277 
1278         // o  The RRSIG RR's Signer's Name field MUST be the name of the zone
1279         //    that contains the RRset.
1280         require(signerNameLength <= name.length);
1281         require(data.equals(RRSIG_SIGNER_NAME, name, name.length - signerNameLength, signerNameLength));
1282 
1283         // Set the return offset to point at the first RR
1284         uint offset = 18 + signerNameLength;
1285 
1286         // Check the proof
1287         uint16 dnstype = proof.readUint16(proof.nameLength(0));
1288         if (dnstype == DNSTYPE_DS) {
1289             require(verifyWithDS(data, sig, offset, proof));
1290         } else if (dnstype == DNSTYPE_DNSKEY) {
1291             require(verifyWithKnownKey(data, sig, proof));
1292         } else {
1293             revert("Unsupported proof record type");
1294         }
1295     }
1296 
1297     /**
1298      * @dev Attempts to verify a signed RRSET against an already known public key.
1299      * @param data The original data to verify.
1300      * @param sig The signature data.
1301      * @return True if the RRSET could be verified, false otherwise.
1302      */
1303     function verifyWithKnownKey(bytes memory data, bytes memory sig, bytes memory proof) internal view returns(bool) {
1304         uint signerNameLength = data.nameLength(RRSIG_SIGNER_NAME);
1305 
1306         // Extract algorithm and keytag
1307         uint8 algorithm = data.readUint8(RRSIG_ALGORITHM);
1308         uint16 keytag = data.readUint16(RRSIG_KEY_TAG);
1309 
1310         for (RRUtils.RRIterator memory iter = proof.iterateRRs(0); !iter.done(); iter.next()) {
1311             // Check the DNSKEY's owner name matches the signer name on the RRSIG
1312             require(proof.nameLength(0) == signerNameLength);
1313             require(proof.equals(0, data, RRSIG_SIGNER_NAME, signerNameLength));
1314             if (verifySignatureWithKey(iter.rdata(), algorithm, keytag, data, sig)) {
1315                 return true;
1316             }
1317         }
1318 
1319         return false;
1320     }
1321 
1322     /**
1323      * @dev Attempts to verify a signed RRSET against an already known public key.
1324      * @param data The original data to verify.
1325      * @param sig The signature data.
1326      * @param offset The offset from the start of the data to the first RR.
1327      * @return True if the RRSET could be verified, false otherwise.
1328      */
1329     function verifyWithDS(bytes memory data, bytes memory sig, uint offset, bytes memory proof) internal view returns(bool) {
1330         // Extract algorithm and keytag
1331         uint8 algorithm = data.readUint8(RRSIG_ALGORITHM);
1332         uint16 keytag = data.readUint16(RRSIG_KEY_TAG);
1333 
1334         // Perhaps it's self-signed and verified by a DS record?
1335         for (RRUtils.RRIterator memory iter = data.iterateRRs(offset); !iter.done(); iter.next()) {
1336             if (iter.dnstype != DNSTYPE_DNSKEY) {
1337                 return false;
1338             }
1339 
1340             bytes memory keyrdata = iter.rdata();
1341             if (verifySignatureWithKey(keyrdata, algorithm, keytag, data, sig)) {
1342                 // It's self-signed - look for a DS record to verify it.
1343                 return verifyKeyWithDS(iter.name(), keyrdata, keytag, algorithm, proof);
1344             }
1345         }
1346 
1347         return false;
1348     }
1349 
1350     /**
1351      * @dev Attempts to verify some data using a provided key and a signature.
1352      * @param keyrdata The RDATA section of the key to use.
1353      * @param algorithm The algorithm ID of the key and signature.
1354      * @param keytag The keytag from the signature.
1355      * @param data The data to verify.
1356      * @param sig The signature to use.
1357      * @return True iff the key verifies the signature.
1358      */
1359     function verifySignatureWithKey(bytes memory keyrdata, uint8 algorithm, uint16 keytag, bytes data, bytes sig) internal view returns (bool) {
1360         if (algorithms[algorithm] == address(0)) {
1361             return false;
1362         }
1363         // TODO: Check key isn't expired, unless updating key itself
1364 
1365         // o The RRSIG RR's Signer's Name, Algorithm, and Key Tag fields MUST
1366         //   match the owner name, algorithm, and key tag for some DNSKEY RR in
1367         //   the zone's apex DNSKEY RRset.
1368         if (keyrdata.readUint8(DNSKEY_PROTOCOL) != 3) {
1369             return false;
1370         }
1371         if (keyrdata.readUint8(DNSKEY_ALGORITHM) != algorithm) {
1372             return false;
1373         }
1374         uint16 computedkeytag = computeKeytag(keyrdata);
1375         if (computedkeytag != keytag) {
1376             return false;
1377         }
1378 
1379         // o The matching DNSKEY RR MUST be present in the zone's apex DNSKEY
1380         //   RRset, and MUST have the Zone Flag bit (DNSKEY RDATA Flag bit 7)
1381         //   set.
1382         if (keyrdata.readUint16(DNSKEY_FLAGS) & DNSKEY_FLAG_ZONEKEY == 0) {
1383             return false;
1384         }
1385 
1386         return algorithms[algorithm].verify(keyrdata, data, sig);
1387     }
1388 
1389     /**
1390      * @dev Attempts to verify a key using DS records.
1391      * @param keyname The DNS name of the key, in DNS label-sequence format.
1392      * @param keyrdata The RDATA section of the key.
1393      * @param keytag The keytag of the key.
1394      * @param algorithm The algorithm ID of the key.
1395      * @return True if a DS record verifies this key.
1396      */
1397     function verifyKeyWithDS(bytes memory keyname, bytes memory keyrdata, uint16 keytag, uint8 algorithm, bytes memory data)
1398         internal view returns (bool)
1399     {
1400         for (RRUtils.RRIterator memory iter = data.iterateRRs(0); !iter.done(); iter.next()) {
1401             if (data.readUint16(iter.rdataOffset + DS_KEY_TAG) != keytag) {
1402                 continue;
1403             }
1404             if (data.readUint8(iter.rdataOffset + DS_ALGORITHM) != algorithm) {
1405                 continue;
1406             }
1407 
1408             uint8 digesttype = data.readUint8(iter.rdataOffset + DS_DIGEST_TYPE);
1409             Buffer.buffer memory buf;
1410             buf.init(keyname.length + keyrdata.length);
1411             buf.append(keyname);
1412             buf.append(keyrdata);
1413             if (verifyDSHash(digesttype, buf.buf, data.substring(iter.rdataOffset, iter.nextOffset - iter.rdataOffset))) {
1414                 return true;
1415             }
1416         }
1417         return false;
1418     }
1419 
1420     /**
1421      * @dev Attempts to verify a DS record's hash value against some data.
1422      * @param digesttype The digest ID from the DS record.
1423      * @param data The data to digest.
1424      * @param digest The digest data to check against.
1425      * @return True iff the digest matches.
1426      */
1427     function verifyDSHash(uint8 digesttype, bytes data, bytes digest) internal view returns (bool) {
1428         if (digests[digesttype] == address(0)) {
1429             return false;
1430         }
1431         return digests[digesttype].verify(data, digest.substring(4, digest.length - 4));
1432     }
1433 
1434     /**
1435      * @dev Computes the keytag for a chunk of data.
1436      * @param data The data to compute a keytag for.
1437      * @return The computed key tag.
1438      */
1439     function computeKeytag(bytes memory data) internal pure returns (uint16) {
1440         uint ac;
1441         for (uint i = 0; i < data.length; i += 2) {
1442             ac += data.readUint16(i);
1443         }
1444         ac += (ac >> 16) & 0xFFFF;
1445         return uint16(ac & 0xFFFF);
1446     }
1447 }