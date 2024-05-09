1 pragma solidity ^0.4.23;
2 
3 // File: @ensdomains/dnssec-oracle/contracts/BytesUtils.sol
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
306 // File: @ensdomains/dnssec-oracle/contracts/DNSSEC.sol
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
322 // File: @ensdomains/buffer/contracts/Buffer.sol
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
359             mstore(0x40, add(ptr, capacity))
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
370     function fromBytes(bytes b) internal pure returns(buffer memory) {
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
412     function write(buffer memory buf, uint off, bytes data, uint len) internal pure returns(buffer memory) {
413         require(len <= data.length);
414 
415         if (off + len + buf.buf.length > buf.capacity) {
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
463     function append(buffer memory buf, bytes data, uint len) internal pure returns (buffer memory) {
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
474     function append(buffer memory buf, bytes data) internal pure returns (buffer memory) {
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
487         if (off > buf.capacity) {
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
529             resize(buf, max(buf.capacity, len) * 2);
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
594             resize(buf, max(buf.capacity, len + off) * 2);
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
611 }
612 
613 // File: @ensdomains/dnssec-oracle/contracts/RRUtils.sol
614 
615 /**
616 * @dev RRUtils is a library that provides utilities for parsing DNS resource records.
617 */
618 library RRUtils {
619     using BytesUtils for *;
620     using Buffer for *;
621 
622     /**
623     * @dev Returns the number of bytes in the DNS name at 'offset' in 'self'.
624     * @param self The byte array to read a name from.
625     * @param offset The offset to start reading at.
626     * @return The length of the DNS name at 'offset', in bytes.
627     */
628     function nameLength(bytes memory self, uint offset) internal pure returns(uint) {
629         uint idx = offset;
630         while (true) {
631             assert(idx < self.length);
632             uint labelLen = self.readUint8(idx);
633             idx += labelLen + 1;
634             if (labelLen == 0) {
635                 break;
636             }
637         }
638         return idx - offset;
639     }
640 
641     /**
642     * @dev Returns a DNS format name at the specified offset of self.
643     * @param self The byte array to read a name from.
644     * @param offset The offset to start reading at.
645     * @return The name.
646     */
647     function readName(bytes memory self, uint offset) internal pure returns(bytes memory ret) {
648         uint len = nameLength(self, offset);
649         return self.substring(offset, len);
650     }
651 
652     /**
653     * @dev Returns the number of labels in the DNS name at 'offset' in 'self'.
654     * @param self The byte array to read a name from.
655     * @param offset The offset to start reading at.
656     * @return The number of labels in the DNS name at 'offset', in bytes.
657     */
658     function labelCount(bytes memory self, uint offset) internal pure returns(uint) {
659         uint count = 0;
660         while (true) {
661             assert(offset < self.length);
662             uint labelLen = self.readUint8(offset);
663             offset += labelLen + 1;
664             if (labelLen == 0) {
665                 break;
666             }
667             count += 1;
668         }
669         return count;
670     }
671 
672     /**
673     * @dev An iterator over resource records.
674     */
675     struct RRIterator {
676         bytes data;
677         uint offset;
678         uint16 dnstype;
679         uint16 class;
680         uint32 ttl;
681         uint rdataOffset;
682         uint nextOffset;
683     }
684 
685     /**
686     * @dev Begins iterating over resource records.
687     * @param self The byte string to read from.
688     * @param offset The offset to start reading at.
689     * @return An iterator object.
690     */
691     function iterateRRs(bytes memory self, uint offset) internal pure returns (RRIterator memory ret) {
692         ret.data = self;
693         ret.nextOffset = offset;
694         next(ret);
695     }
696 
697     /**
698     * @dev Returns true iff there are more RRs to iterate.
699     * @param iter The iterator to check.
700     * @return True iff the iterator has finished.
701     */
702     function done(RRIterator memory iter) internal pure returns(bool) {
703         return iter.offset >= iter.data.length;
704     }
705 
706     /**
707     * @dev Moves the iterator to the next resource record.
708     * @param iter The iterator to advance.
709     */
710     function next(RRIterator memory iter) internal pure {
711         iter.offset = iter.nextOffset;
712         if (iter.offset >= iter.data.length) {
713             return;
714         }
715 
716         // Skip the name
717         uint off = iter.offset + nameLength(iter.data, iter.offset);
718 
719         // Read type, class, and ttl
720         iter.dnstype = iter.data.readUint16(off);
721         off += 2;
722         iter.class = iter.data.readUint16(off);
723         off += 2;
724         iter.ttl = iter.data.readUint32(off);
725         off += 4;
726 
727         // Read the rdata
728         uint rdataLength = iter.data.readUint16(off);
729         off += 2;
730         iter.rdataOffset = off;
731         iter.nextOffset = off + rdataLength;
732     }
733 
734     /**
735     * @dev Returns the name of the current record.
736     * @param iter The iterator.
737     * @return A new bytes object containing the owner name from the RR.
738     */
739     function name(RRIterator memory iter) internal pure returns(bytes memory) {
740         return iter.data.substring(iter.offset, nameLength(iter.data, iter.offset));
741     }
742 
743     /**
744     * @dev Returns the rdata portion of the current record.
745     * @param iter The iterator.
746     * @return A new bytes object containing the RR's RDATA.
747     */
748     function rdata(RRIterator memory iter) internal pure returns(bytes memory) {
749         return iter.data.substring(iter.rdataOffset, iter.nextOffset - iter.rdataOffset);
750     }
751 
752     /**
753     * @dev Checks if a given RR type exists in a type bitmap.
754     * @param self The byte string to read the type bitmap from.
755     * @param offset The offset to start reading at.
756     * @param rrtype The RR type to check for.
757     * @return True if the type is found in the bitmap, false otherwise.
758     */
759     function checkTypeBitmap(bytes memory self, uint offset, uint16 rrtype) internal pure returns (bool) {
760         uint8 typeWindow = uint8(rrtype >> 8);
761         uint8 windowByte = uint8((rrtype & 0xff) / 8);
762         uint8 windowBitmask = uint8(uint8(1) << (uint8(7) - uint8(rrtype & 0x7)));
763         for (uint off = offset; off < self.length;) {
764             uint8 window = self.readUint8(off);
765             uint8 len = self.readUint8(off + 1);
766             if (typeWindow < window) {
767                 // We've gone past our window; it's not here.
768                 return false;
769             } else if (typeWindow == window) {
770                 // Check this type bitmap
771                 if (len * 8 <= windowByte) {
772                     // Our type is past the end of the bitmap
773                     return false;
774                 }
775                 return (self.readUint8(off + windowByte + 2) & windowBitmask) != 0;
776             } else {
777                 // Skip this type bitmap
778                 off += len + 2;
779             }
780         }
781 
782         return false;
783     }
784 
785     function compareNames(bytes memory self, bytes memory other) internal pure returns (int) {
786         if (self.equals(other)) {
787             return 0;
788         }
789 
790         uint off;
791         uint otheroff;
792         uint prevoff;
793         uint otherprevoff;
794         uint counts = labelCount(self, 0);
795         uint othercounts = labelCount(other, 0);
796 
797         // Keep removing labels from the front of the name until both names are equal length
798         while (counts > othercounts) {
799             prevoff = off;
800             off = progress(self, off);
801             counts--;
802         }
803 
804         while (othercounts > counts) {
805             otherprevoff = otheroff;
806             otheroff = progress(other, otheroff);
807             othercounts--;
808         }
809 
810         // Compare the last nonequal labels to each other
811         while (counts > 0 && !self.equals(off, other, otheroff)) {
812             prevoff = off;
813             off = progress(self, off);
814             otherprevoff = otheroff;
815             otheroff = progress(other, otheroff);
816             counts -= 1;
817         }
818 
819         if (off == 0) {
820             return -1;
821         }
822         if(otheroff == 0) {
823             return 1;
824         }
825 
826         return self.compare(prevoff + 1, self.readUint8(prevoff), other, otherprevoff + 1, other.readUint8(otherprevoff));
827     }
828 
829     function progress(bytes memory body, uint off) internal pure returns(uint) {
830         return off + 1 + body.readUint8(off);
831     }
832 }
833 
834 // File: @ensdomains/ens/contracts/ENS.sol
835 
836 interface ENS {
837 
838     // Logged when the owner of a node assigns a new owner to a subnode.
839     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
840 
841     // Logged when the owner of a node transfers ownership to a new account.
842     event Transfer(bytes32 indexed node, address owner);
843 
844     // Logged when the resolver for a node changes.
845     event NewResolver(bytes32 indexed node, address resolver);
846 
847     // Logged when the TTL of a node changes
848     event NewTTL(bytes32 indexed node, uint64 ttl);
849 
850 
851     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public;
852     function setResolver(bytes32 node, address resolver) public;
853     function setOwner(bytes32 node, address owner) public;
854     function setTTL(bytes32 node, uint64 ttl) public;
855     function owner(bytes32 node) public view returns (address);
856     function resolver(bytes32 node) public view returns (address);
857     function ttl(bytes32 node) public view returns (uint64);
858 
859 }
860 
861 // File: @ensdomains/ens/contracts/ENSRegistry.sol
862 
863 /**
864  * The ENS registry contract.
865  */
866 contract ENSRegistry is ENS {
867     struct Record {
868         address owner;
869         address resolver;
870         uint64 ttl;
871     }
872 
873     mapping (bytes32 => Record) records;
874 
875     // Permits modifications only by the owner of the specified node.
876     modifier only_owner(bytes32 node) {
877         require(records[node].owner == msg.sender);
878         _;
879     }
880 
881     /**
882      * @dev Constructs a new ENS registrar.
883      */
884     function ENSRegistry() public {
885         records[0x0].owner = msg.sender;
886     }
887 
888     /**
889      * @dev Transfers ownership of a node to a new address. May only be called by the current owner of the node.
890      * @param node The node to transfer ownership of.
891      * @param owner The address of the new owner.
892      */
893     function setOwner(bytes32 node, address owner) public only_owner(node) {
894         Transfer(node, owner);
895         records[node].owner = owner;
896     }
897 
898     /**
899      * @dev Transfers ownership of a subnode keccak256(node, label) to a new address. May only be called by the owner of the parent node.
900      * @param node The parent node.
901      * @param label The hash of the label specifying the subnode.
902      * @param owner The address of the new owner.
903      */
904     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public only_owner(node) {
905         var subnode = keccak256(node, label);
906         NewOwner(node, label, owner);
907         records[subnode].owner = owner;
908     }
909 
910     /**
911      * @dev Sets the resolver address for the specified node.
912      * @param node The node to update.
913      * @param resolver The address of the resolver.
914      */
915     function setResolver(bytes32 node, address resolver) public only_owner(node) {
916         NewResolver(node, resolver);
917         records[node].resolver = resolver;
918     }
919 
920     /**
921      * @dev Sets the TTL for the specified node.
922      * @param node The node to update.
923      * @param ttl The TTL in seconds.
924      */
925     function setTTL(bytes32 node, uint64 ttl) public only_owner(node) {
926         NewTTL(node, ttl);
927         records[node].ttl = ttl;
928     }
929 
930     /**
931      * @dev Returns the address that owns the specified node.
932      * @param node The specified node.
933      * @return address of the owner.
934      */
935     function owner(bytes32 node) public view returns (address) {
936         return records[node].owner;
937     }
938 
939     /**
940      * @dev Returns the address of the resolver for the specified node.
941      * @param node The specified node.
942      * @return address of the resolver.
943      */
944     function resolver(bytes32 node) public view returns (address) {
945         return records[node].resolver;
946     }
947 
948     /**
949      * @dev Returns the TTL of a node, and any records associated with it.
950      * @param node The specified node.
951      * @return ttl of the node.
952      */
953     function ttl(bytes32 node) public view returns (uint64) {
954         return records[node].ttl;
955     }
956 
957 }
958 
959 // File: contracts/DNSRegistrar.sol
960 
961 /**
962  * @dev An ENS registrar that allows the owner of a DNS name to claim the
963  *      corresponding name in ENS.
964  */
965 contract DNSRegistrar {
966     using BytesUtils for bytes;
967     using RRUtils for *;
968     using Buffer for Buffer.buffer;
969 
970     uint16 constant CLASS_INET = 1;
971     uint16 constant TYPE_TXT = 16;
972 
973     DNSSEC public oracle;
974     ENS public ens;
975     bytes public rootDomain;
976     bytes32 public rootNode;
977 
978     event Claim(bytes32 indexed node, address indexed owner, bytes dnsname);
979 
980     constructor(DNSSEC _dnssec, ENS _ens, bytes _rootDomain, bytes32 _rootNode) public {
981         oracle = _dnssec;
982         ens = _ens;
983         rootDomain = _rootDomain;
984         rootNode = _rootNode;
985     }
986 
987     /**
988      * @dev Claims a name by proving ownership of its DNS equivalent.
989      * @param name The name to claim, in DNS wire format.
990      * @param proof A DNS RRSet proving ownership of the name. Must be verified
991      *        in the DNSSEC oracle before calling. This RRSET must contain a TXT
992      *        record for '_ens.' + name, with the value 'a=0x...'. Ownership of
993      *        the name will be transferred to the address specified in the TXT
994      *        record.
995      */
996     function claim(bytes name, bytes proof) public {
997         bytes32 labelHash = getLabelHash(name);
998 
999         address addr = getOwnerAddress(name, proof);
1000 
1001         ens.setSubnodeOwner(rootNode, labelHash, addr);
1002         emit Claim(keccak256(rootNode, labelHash), addr, name);
1003     }
1004 
1005     /**
1006      * @dev Submits proofs to the DNSSEC oracle, then claims a name using those proofs.
1007      * @param name The name to claim, in DNS wire format.
1008      * @param input The data to be passed to the Oracle's `submitProofs` function. The last
1009      *        proof must be the TXT record required by the registrar.
1010      * @param proof The proof record for the first element in input.
1011      */
1012     function proveAndClaim(bytes name, bytes input, bytes proof) public {
1013         proof = oracle.submitRRSets(input, proof);
1014         claim(name, proof);
1015     }
1016 
1017     function getLabelHash(bytes memory name) internal view returns(bytes32) {
1018         uint len = name.readUint8(0);
1019         // Check this name is a direct subdomain of the one we're responsible for
1020         require(name.equals(len + 1, rootDomain));
1021         return name.keccak(1, len);
1022     }
1023 
1024     function getOwnerAddress(bytes memory name, bytes memory proof) internal view returns(address) {
1025         // Add "_ens." to the front of the name.
1026         Buffer.buffer memory buf;
1027         buf.init(name.length + 5);
1028         buf.append("\x04_ens");
1029         buf.append(name);
1030         bytes20 hash;
1031         uint64 inserted;
1032         // Check the provided TXT record has been validated by the oracle
1033         (, inserted, hash) = oracle.rrdata(TYPE_TXT, buf.buf);
1034         if(hash == bytes20(0) && proof.length == 0) return 0;
1035 
1036         require(hash == bytes20(keccak256(proof)));
1037 
1038         for(RRUtils.RRIterator memory iter = proof.iterateRRs(0); !iter.done(); iter.next()) {
1039             require(inserted + iter.ttl >= now, "DNS record is stale; refresh or delete it before proceeding.");
1040 
1041             address addr = parseRR(proof, iter.rdataOffset);
1042             if(addr != 0) {
1043                 return addr;
1044             }
1045         }
1046 
1047         return 0;
1048     }
1049 
1050     function parseRR(bytes memory rdata, uint idx) internal pure returns(address) {
1051         while(idx < rdata.length) {
1052             uint len = rdata.readUint8(idx); idx += 1;
1053             address addr = parseString(rdata, idx, len);
1054             if(addr != 0) return addr;
1055             idx += len;
1056         }
1057 
1058         return 0;
1059     }
1060 
1061     function parseString(bytes memory str, uint idx, uint len) internal pure returns(address) {
1062         // TODO: More robust parsing that handles whitespace and multiple key/value pairs
1063         if(str.readUint32(idx) != 0x613d3078) return 0; // 0x613d3078 == 'a=0x'
1064         if(len < 44) return 0;
1065         return hexToAddress(str, idx + 4);
1066     }
1067 
1068     function hexToAddress(bytes memory str, uint idx) internal pure returns(address) {
1069         if(str.length - idx < 40) return 0;
1070         uint ret = 0;
1071         for(uint i = idx; i < idx + 40; i++) {
1072             ret <<= 4;
1073             uint x = str.readUint8(i);
1074             if(x >= 48 && x < 58) {
1075                 ret |= x - 48;
1076             } else if(x >= 65 && x < 71) {
1077                 ret |= x - 55;
1078             } else if(x >= 97 && x < 103) {
1079                 ret |= x - 87;
1080             } else {
1081                 return 0;
1082             }
1083         }
1084         return address(ret);
1085     }
1086 }