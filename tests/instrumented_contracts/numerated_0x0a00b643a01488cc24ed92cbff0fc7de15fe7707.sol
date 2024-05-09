1 pragma solidity ^0.4.25;
2 pragma experimental ABIEncoderV2;
3 
4 contract LibSignatureValidation {
5 
6   using LibBytes for bytes;
7 
8   function isValidSignature(bytes32 hash, address signerAddress, bytes memory signature) internal pure returns (bool) {
9     require(signature.length == 65, "LENGTH_65_REQUIRED");
10     uint8 v = uint8(signature[64]);
11     bytes32 r = signature.readBytes32(0);
12     bytes32 s = signature.readBytes32(32);
13     address recovered = ecrecover(hash, v, r, s);
14     return signerAddress == recovered;
15   }
16 }
17 
18 contract LibTransferRequest {
19 
20   // EIP191 header for EIP712 prefix
21   string constant internal EIP191_HEADER = "\x19\x01";
22   // EIP712 Domain Name value
23   string constant internal EIP712_DOMAIN_NAME = "Dola Core";
24   // EIP712 Domain Version value
25   string constant internal EIP712_DOMAIN_VERSION = "1";
26   // Hash of the EIP712 Domain Separator Schema
27   bytes32 public constant EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = keccak256(abi.encodePacked(
28     "EIP712Domain(",
29     "string name,",
30     "string version,",
31     "address verifyingContract",
32     ")"
33   ));
34 
35   // Hash of the EIP712 Domain Separator data
36   bytes32 public EIP712_DOMAIN_HASH;
37 
38   bytes32 constant internal EIP712_TRANSFER_REQUEST_TYPE_HASH = keccak256(abi.encodePacked(
39     "TransferRequest(",
40     "address senderAddress,",
41     "address receiverAddress,",
42     "uint256 value,",
43     "address relayerAddress,",
44     "uint256 relayerFee,",
45     "uint256 salt,",
46     ")"
47   ));
48 
49   struct TransferRequest {
50     address senderAddress;
51     address receiverAddress;
52     uint256 value;
53     address relayerAddress;
54     uint256 relayerFee;
55     uint256 salt;
56   }
57 
58   constructor() public {
59     EIP712_DOMAIN_HASH = keccak256(abi.encode(
60         EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
61         keccak256(bytes(EIP712_DOMAIN_NAME)),
62         keccak256(bytes(EIP712_DOMAIN_VERSION)),
63         address(this)
64       ));
65   }
66 
67   function hashTransferRequest(TransferRequest memory request) internal view returns (bytes32) {
68     bytes32 typeHash = EIP712_TRANSFER_REQUEST_TYPE_HASH;
69     bytes32 hashStruct;
70 
71     // assembly shorthand for:
72     // bytes32 hashStruct = keccak256(abi.encode(
73     //    EIP712_TRANSFER_REQUEST_TYPE_HASH,
74     //    request.senderAddress,
75     //    request.receiverAddress,
76     //    request.value,
77     //    request.relayerAddress,
78     //    request.relayerFee,
79     //    request.salt));
80     assembly {
81       // Back up select memory
82       let temp1 := mload(sub(request, 32))
83 
84       mstore(sub(request, 32), typeHash)
85       hashStruct := keccak256(sub(request, 32), 224)
86 
87       mstore(sub(request, 32), temp1)
88     }
89     return keccak256(abi.encodePacked(EIP191_HEADER, EIP712_DOMAIN_HASH, hashStruct));
90   }
91 
92 
93 
94 }
95 
96 contract DolaCore is LibTransferRequest, LibSignatureValidation {
97 
98   using LibBytes for bytes;
99 
100   address public TOKEN_ADDRESS;
101   mapping (address => mapping (address => uint256)) public requestEpoch;
102 
103   event TransferRequestFilled(address indexed from, address indexed to);
104 
105   constructor (address _tokenAddress) public LibTransferRequest() {
106     TOKEN_ADDRESS = _tokenAddress;
107   }
108 
109   function executeTransfer(TransferRequest memory request, bytes memory signature) public {
110     // make sure the request hasn't been sent already
111     require(requestEpoch[request.senderAddress][request.relayerAddress] <= request.salt, "REQUEST_INVALID");
112     // Validate the sender is allowed to execute this transfer
113     require(request.relayerAddress == msg.sender, "REQUEST_INVALID");
114     // Validate the sender's signature
115     bytes32 requestHash = hashTransferRequest(request);
116     require(isValidSignature(requestHash, request.senderAddress, signature), "INVALID_REQUEST_SIGNATURE");
117 
118     address tokenAddress = TOKEN_ADDRESS;
119     assembly {
120       mstore(32, 0x23b872dd00000000000000000000000000000000000000000000000000000000)
121       calldatacopy(36, 4, 96)
122       let success := call(
123         gas,            // forward all gas
124         tokenAddress,   // call address of token contract
125         0,              // don't send any ETH
126         32,              // pointer to start of input
127         100,            // length of input
128         0,            // write output to far position
129         32              // output size should be 32 bytes
130       )
131       success := and(success, or(
132           iszero(returndatasize),
133           and(
134             eq(returndatasize, 32),
135             gt(mload(0), 0)
136           )
137         ))
138       if iszero(success) {
139         mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
140         mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
141         mstore(64, 0x0000000f5452414e534645525f4641494c454400000000000000000000000000)
142         mstore(96, 0)
143         revert(0, 100)
144       }
145       calldatacopy(68, 100, 64)
146       success := call(
147         gas,            // forward all gas
148         tokenAddress,   // call address of token contract
149         0,              // don't send any ETH
150         32,              // pointer to start of input
151         100,            // length of input
152         0,            // write output over input
153         32              // output size should be 32 bytes
154       )
155       success := and(success, or(
156           iszero(returndatasize),
157           and(
158             eq(returndatasize, 32),
159             gt(mload(0), 0)
160           )
161         ))
162       if iszero(success) {
163         mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
164         mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
165         mstore(64, 0x0000000f5452414e534645525f4641494c454400000000000000000000000000)
166         mstore(96, 0)
167         revert(0, 100)
168       }
169     }
170 
171     requestEpoch[request.senderAddress][request.relayerAddress] = request.salt + 1;
172   }
173 }
174 
175 library LibBytes {
176 
177     using LibBytes for bytes;
178 
179     /// @dev Gets the memory address for a byte array.
180     /// @param input Byte array to lookup.
181     /// @return memoryAddress Memory address of byte array. This
182     ///         points to the header of the byte array which contains
183     ///         the length.
184     function rawAddress(bytes memory input)
185         internal
186         pure
187         returns (uint256 memoryAddress)
188     {
189         assembly {
190             memoryAddress := input
191         }
192         return memoryAddress;
193     }
194 
195     /// @dev Gets the memory address for the contents of a byte array.
196     /// @param input Byte array to lookup.
197     /// @return memoryAddress Memory address of the contents of the byte array.
198     function contentAddress(bytes memory input)
199         internal
200         pure
201         returns (uint256 memoryAddress)
202     {
203         assembly {
204             memoryAddress := add(input, 32)
205         }
206         return memoryAddress;
207     }
208 
209     /// @dev Copies `length` bytes from memory location `source` to `dest`.
210     /// @param dest memory address to copy bytes to.
211     /// @param source memory address to copy bytes from.
212     /// @param length number of bytes to copy.
213     function memCopy(
214         uint256 dest,
215         uint256 source,
216         uint256 length
217     )
218         internal
219         pure
220     {
221         if (length < 32) {
222             // Handle a partial word by reading destination and masking
223             // off the bits we are interested in.
224             // This correctly handles overlap, zero lengths and source == dest
225             assembly {
226                 let mask := sub(exp(256, sub(32, length)), 1)
227                 let s := and(mload(source), not(mask))
228                 let d := and(mload(dest), mask)
229                 mstore(dest, or(s, d))
230             }
231         } else {
232             // Skip the O(length) loop when source == dest.
233             if (source == dest) {
234                 return;
235             }
236 
237             // For large copies we copy whole words at a time. The final
238             // word is aligned to the end of the range (instead of after the
239             // previous) to handle partial words. So a copy will look like this:
240             //
241             //  ####
242             //      ####
243             //          ####
244             //            ####
245             //
246             // We handle overlap in the source and destination range by
247             // changing the copying direction. This prevents us from
248             // overwriting parts of source that we still need to copy.
249             //
250             // This correctly handles source == dest
251             //
252             if (source > dest) {
253                 assembly {
254                     // We subtract 32 from `sEnd` and `dEnd` because it
255                     // is easier to compare with in the loop, and these
256                     // are also the addresses we need for copying the
257                     // last bytes.
258                     length := sub(length, 32)
259                     let sEnd := add(source, length)
260                     let dEnd := add(dest, length)
261 
262                     // Remember the last 32 bytes of source
263                     // This needs to be done here and not after the loop
264                     // because we may have overwritten the last bytes in
265                     // source already due to overlap.
266                     let last := mload(sEnd)
267 
268                     // Copy whole words front to back
269                     // Note: the first check is always true,
270                     // this could have been a do-while loop.
271                     // solhint-disable-next-line no-empty-blocks
272                     for {} lt(source, sEnd) {} {
273                         mstore(dest, mload(source))
274                         source := add(source, 32)
275                         dest := add(dest, 32)
276                     }
277 
278                     // Write the last 32 bytes
279                     mstore(dEnd, last)
280                 }
281             } else {
282                 assembly {
283                     // We subtract 32 from `sEnd` and `dEnd` because those
284                     // are the starting points when copying a word at the end.
285                     length := sub(length, 32)
286                     let sEnd := add(source, length)
287                     let dEnd := add(dest, length)
288 
289                     // Remember the first 32 bytes of source
290                     // This needs to be done here and not after the loop
291                     // because we may have overwritten the first bytes in
292                     // source already due to overlap.
293                     let first := mload(source)
294 
295                     // Copy whole words back to front
296                     // We use a signed comparisson here to allow dEnd to become
297                     // negative (happens when source and dest < 32). Valid
298                     // addresses in local memory will never be larger than
299                     // 2**255, so they can be safely re-interpreted as signed.
300                     // Note: the first check is always true,
301                     // this could have been a do-while loop.
302                     // solhint-disable-next-line no-empty-blocks
303                     for {} slt(dest, dEnd) {} {
304                         mstore(dEnd, mload(sEnd))
305                         sEnd := sub(sEnd, 32)
306                         dEnd := sub(dEnd, 32)
307                     }
308 
309                     // Write the first 32 bytes
310                     mstore(dest, first)
311                 }
312             }
313         }
314     }
315 
316     /// @dev Returns a slices from a byte array.
317     /// @param b The byte array to take a slice from.
318     /// @param from The starting index for the slice (inclusive).
319     /// @param to The final index for the slice (exclusive).
320     /// @return result The slice containing bytes at indices [from, to)
321     function slice(
322         bytes memory b,
323         uint256 from,
324         uint256 to
325     )
326         internal
327         pure
328         returns (bytes memory result)
329     {
330         require(
331             from <= to,
332             "FROM_LESS_THAN_TO_REQUIRED"
333         );
334         require(
335             to < b.length,
336             "TO_LESS_THAN_LENGTH_REQUIRED"
337         );
338 
339         // Create a new bytes structure and copy contents
340         result = new bytes(to - from);
341         memCopy(
342             result.contentAddress(),
343             b.contentAddress() + from,
344             result.length);
345         return result;
346     }
347 
348     /// @dev Returns a slice from a byte array without preserving the input.
349     /// @param b The byte array to take a slice from. Will be destroyed in the process.
350     /// @param from The starting index for the slice (inclusive).
351     /// @param to The final index for the slice (exclusive).
352     /// @return result The slice containing bytes at indices [from, to)
353     /// @dev When `from == 0`, the original array will match the slice. In other cases its state will be corrupted.
354     function sliceDestructive(
355         bytes memory b,
356         uint256 from,
357         uint256 to
358     )
359         internal
360         pure
361         returns (bytes memory result)
362     {
363         require(
364             from <= to,
365             "FROM_LESS_THAN_TO_REQUIRED"
366         );
367         require(
368             to < b.length,
369             "TO_LESS_THAN_LENGTH_REQUIRED"
370         );
371 
372         // Create a new bytes structure around [from, to) in-place.
373         assembly {
374             result := add(b, from)
375             mstore(result, sub(to, from))
376         }
377         return result;
378     }
379 
380     /// @dev Pops the last byte off of a byte array by modifying its length.
381     /// @param b Byte array that will be modified.
382     /// @return The byte that was popped off.
383     function popLastByte(bytes memory b)
384         internal
385         pure
386         returns (bytes1 result)
387     {
388         require(
389             b.length > 0,
390             "GREATER_THAN_ZERO_LENGTH_REQUIRED"
391         );
392 
393         // Store last byte.
394         result = b[b.length - 1];
395 
396         assembly {
397             // Decrement length of byte array.
398             let newLen := sub(mload(b), 1)
399             mstore(b, newLen)
400         }
401         return result;
402     }
403 
404     /// @dev Pops the last 20 bytes off of a byte array by modifying its length.
405     /// @param b Byte array that will be modified.
406     /// @return The 20 byte address that was popped off.
407     function popLast20Bytes(bytes memory b)
408         internal
409         pure
410         returns (address result)
411     {
412         require(
413             b.length >= 20,
414             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
415         );
416 
417         // Store last 20 bytes.
418         result = readAddress(b, b.length - 20);
419 
420         assembly {
421             // Subtract 20 from byte array length.
422             let newLen := sub(mload(b), 20)
423             mstore(b, newLen)
424         }
425         return result;
426     }
427 
428     /// @dev Tests equality of two byte arrays.
429     /// @param lhs First byte array to compare.
430     /// @param rhs Second byte array to compare.
431     /// @return True if arrays are the same. False otherwise.
432     function equals(
433         bytes memory lhs,
434         bytes memory rhs
435     )
436         internal
437         pure
438         returns (bool equal)
439     {
440         // Keccak gas cost is 30 + numWords * 6. This is a cheap way to compare.
441         // We early exit on unequal lengths, but keccak would also correctly
442         // handle this.
443         return lhs.length == rhs.length && keccak256(lhs) == keccak256(rhs);
444     }
445 
446     /// @dev Reads an address from a position in a byte array.
447     /// @param b Byte array containing an address.
448     /// @param index Index in byte array of address.
449     /// @return address from byte array.
450     function readAddress(
451         bytes memory b,
452         uint256 index
453     )
454         internal
455         pure
456         returns (address result)
457     {
458         require(
459             b.length >= index + 20,  // 20 is length of address
460             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
461         );
462 
463         // Add offset to index:
464         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
465         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
466         index += 20;
467 
468         // Read address from array memory
469         assembly {
470             // 1. Add index to address of bytes array
471             // 2. Load 32-byte word from memory
472             // 3. Apply 20-byte mask to obtain address
473             result := and(mload(add(b, index)), 0xffffffffffffffffffffffffffffffffffffffff)
474         }
475         return result;
476     }
477 
478     /// @dev Writes an address into a specific position in a byte array.
479     /// @param b Byte array to insert address into.
480     /// @param index Index in byte array of address.
481     /// @param input Address to put into byte array.
482     function writeAddress(
483         bytes memory b,
484         uint256 index,
485         address input
486     )
487         internal
488         pure
489     {
490         require(
491             b.length >= index + 20,  // 20 is length of address
492             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
493         );
494 
495         // Add offset to index:
496         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
497         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
498         index += 20;
499 
500         // Store address into array memory
501         assembly {
502             // The address occupies 20 bytes and mstore stores 32 bytes.
503             // First fetch the 32-byte word where we'll be storing the address, then
504             // apply a mask so we have only the bytes in the word that the address will not occupy.
505             // Then combine these bytes with the address and store the 32 bytes back to memory with mstore.
506 
507             // 1. Add index to address of bytes array
508             // 2. Load 32-byte word from memory
509             // 3. Apply 12-byte mask to obtain extra bytes occupying word of memory where we'll store the address
510             let neighbors := and(
511                 mload(add(b, index)),
512                 0xffffffffffffffffffffffff0000000000000000000000000000000000000000
513             )
514 
515             // Make sure input address is clean.
516             // (Solidity does not guarantee this)
517             input := and(input, 0xffffffffffffffffffffffffffffffffffffffff)
518 
519             // Store the neighbors and address into memory
520             mstore(add(b, index), xor(input, neighbors))
521         }
522     }
523 
524     /// @dev Reads a bytes32 value from a position in a byte array.
525     /// @param b Byte array containing a bytes32 value.
526     /// @param index Index in byte array of bytes32 value.
527     /// @return bytes32 value from byte array.
528     function readBytes32(
529         bytes memory b,
530         uint256 index
531     )
532         internal
533         pure
534         returns (bytes32 result)
535     {
536         require(
537             b.length >= index + 32,
538             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
539         );
540 
541         // Arrays are prefixed by a 256 bit length parameter
542         index += 32;
543 
544         // Read the bytes32 from array memory
545         assembly {
546             result := mload(add(b, index))
547         }
548         return result;
549     }
550 
551     /// @dev Writes a bytes32 into a specific position in a byte array.
552     /// @param b Byte array to insert <input> into.
553     /// @param index Index in byte array of <input>.
554     /// @param input bytes32 to put into byte array.
555     function writeBytes32(
556         bytes memory b,
557         uint256 index,
558         bytes32 input
559     )
560         internal
561         pure
562     {
563         require(
564             b.length >= index + 32,
565             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
566         );
567 
568         // Arrays are prefixed by a 256 bit length parameter
569         index += 32;
570 
571         // Read the bytes32 from array memory
572         assembly {
573             mstore(add(b, index), input)
574         }
575     }
576 
577     /// @dev Reads a uint256 value from a position in a byte array.
578     /// @param b Byte array containing a uint256 value.
579     /// @param index Index in byte array of uint256 value.
580     /// @return uint256 value from byte array.
581     function readUint256(
582         bytes memory b,
583         uint256 index
584     )
585         internal
586         pure
587         returns (uint256 result)
588     {
589         return uint256(readBytes32(b, index));
590     }
591 
592     /// @dev Writes a uint256 into a specific position in a byte array.
593     /// @param b Byte array to insert <input> into.
594     /// @param index Index in byte array of <input>.
595     /// @param input uint256 to put into byte array.
596     function writeUint256(
597         bytes memory b,
598         uint256 index,
599         uint256 input
600     )
601         internal
602         pure
603     {
604         writeBytes32(b, index, bytes32(input));
605     }
606 
607     /// @dev Reads an unpadded bytes4 value from a position in a byte array.
608     /// @param b Byte array containing a bytes4 value.
609     /// @param index Index in byte array of bytes4 value.
610     /// @return bytes4 value from byte array.
611     function readBytes4(
612         bytes memory b,
613         uint256 index
614     )
615         internal
616         pure
617         returns (bytes4 result)
618     {
619         require(
620             b.length >= index + 4,
621             "GREATER_OR_EQUAL_TO_4_LENGTH_REQUIRED"
622         );
623         assembly {
624             result := mload(add(b, 32))
625             // Solidity does not require us to clean the trailing bytes.
626             // We do it anyway
627             result := and(result, 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)
628         }
629         return result;
630     }
631 
632     /// @dev Reads nested bytes from a specific position.
633     /// @dev NOTE: the returned value overlaps with the input value.
634     ///            Both should be treated as immutable.
635     /// @param b Byte array containing nested bytes.
636     /// @param index Index of nested bytes.
637     /// @return result Nested bytes.
638     function readBytesWithLength(
639         bytes memory b,
640         uint256 index
641     )
642         internal
643         pure
644         returns (bytes memory result)
645     {
646         // Read length of nested bytes
647         uint256 nestedBytesLength = readUint256(b, index);
648         index += 32;
649 
650         // Assert length of <b> is valid, given
651         // length of nested bytes
652         require(
653             b.length >= index + nestedBytesLength,
654             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
655         );
656 
657         // Return a pointer to the byte array as it exists inside `b`
658         assembly {
659             result := add(b, index)
660         }
661         return result;
662     }
663 
664     /// @dev Inserts bytes at a specific position in a byte array.
665     /// @param b Byte array to insert <input> into.
666     /// @param index Index in byte array of <input>.
667     /// @param input bytes to insert.
668     function writeBytesWithLength(
669         bytes memory b,
670         uint256 index,
671         bytes memory input
672     )
673         internal
674         pure
675     {
676         // Assert length of <b> is valid, given
677         // length of input
678         require(
679             b.length >= index + 32 + input.length,  // 32 bytes to store length
680             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
681         );
682 
683         // Copy <input> into <b>
684         memCopy(
685             b.contentAddress() + index,
686             input.rawAddress(), // includes length of <input>
687             input.length + 32   // +32 bytes to store <input> length
688         );
689     }
690 
691     /// @dev Performs a deep copy of a byte array onto another byte array of greater than or equal length.
692     /// @param dest Byte array that will be overwritten with source bytes.
693     /// @param source Byte array to copy onto dest bytes.
694     function deepCopyBytes(
695         bytes memory dest,
696         bytes memory source
697     )
698         internal
699         pure
700     {
701         uint256 sourceLen = source.length;
702         // Dest length must be >= source length, or some bytes would not be copied.
703         require(
704             dest.length >= sourceLen,
705             "GREATER_OR_EQUAL_TO_SOURCE_BYTES_LENGTH_REQUIRED"
706         );
707         memCopy(
708             dest.contentAddress(),
709             source.contentAddress(),
710             sourceLen
711         );
712     }
713 }