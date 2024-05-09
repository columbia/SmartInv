1 // SPDX-License-Identifier: Apache-2.0
2 pragma solidity ^0.7.0;
3 pragma experimental ABIEncoderV2;
4 // File: contracts/aux/compression/ZeroDecompressor.sol
5 
6 // Copyright 2017 Loopring Technology Limited.
7 
8 
9 /// @title ZeroDecompressor
10 /// @author Brecht Devos - <brecht@loopring.org>
11 /// @dev Easy decompressor that compresses runs of zeros.
12 /// The format is very simple. Each entry consists of
13 /// (uint16 numDataBytes, uint16 numZeroBytes) which will
14 /// copy `numDataBytes` data bytes from `data` and will
15 /// add an additional `numZeroBytes` after it.
16 library ZeroDecompressor
17 {
18     function decompress(
19         bytes calldata /*data*/,
20         uint  parameterIdx
21         )
22         internal
23         pure
24         returns (bytes memory)
25     {
26         bytes memory uncompressed;
27         uint offsetPos = 4 + 32 * parameterIdx;
28         assembly {
29             uncompressed := mload(0x40)
30             let ptr := add(uncompressed, 32)
31             let offset := add(4, calldataload(offsetPos))
32             let pos := add(offset, 4)
33             let dataLength := add(calldataload(offset), pos)
34             let tupple := 0
35             let numDataBytes := 0
36             let numZeroBytes := 0
37 
38             for {} lt(pos, dataLength) {} {
39                 tupple := and(calldataload(pos), 0xFFFFFFFF)
40                 numDataBytes := shr(16, tupple)
41                 numZeroBytes := and(tupple, 0xFFFF)
42                 calldatacopy(ptr, add(32, pos), numDataBytes)
43                 pos := add(pos, add(4, numDataBytes))
44                 ptr := add(ptr, add(numDataBytes, numZeroBytes))
45             }
46 
47             // Store data length
48             mstore(uncompressed, sub(sub(ptr, uncompressed), 32))
49 
50             // Update free memory pointer
51             mstore(0x40, add(ptr, 0x20))
52         }
53         return uncompressed;
54     }
55 }
56 
57 // File: contracts/thirdparty/BytesUtil.sol
58 
59 //Mainly taken from https://github.com/GNSPS/solidity-bytes-utils/blob/master/contracts/BytesLib.sol
60 
61 library BytesUtil {
62 
63     function concat(
64         bytes memory _preBytes,
65         bytes memory _postBytes
66     )
67         internal
68         pure
69         returns (bytes memory)
70     {
71         bytes memory tempBytes;
72 
73         assembly {
74             // Get a location of some free memory and store it in tempBytes as
75             // Solidity does for memory variables.
76             tempBytes := mload(0x40)
77 
78             // Store the length of the first bytes array at the beginning of
79             // the memory for tempBytes.
80             let length := mload(_preBytes)
81             mstore(tempBytes, length)
82 
83             // Maintain a memory counter for the current write location in the
84             // temp bytes array by adding the 32 bytes for the array length to
85             // the starting location.
86             let mc := add(tempBytes, 0x20)
87             // Stop copying when the memory counter reaches the length of the
88             // first bytes array.
89             let end := add(mc, length)
90 
91             for {
92                 // Initialize a copy counter to the start of the _preBytes data,
93                 // 32 bytes into its memory.
94                 let cc := add(_preBytes, 0x20)
95             } lt(mc, end) {
96                 // Increase both counters by 32 bytes each iteration.
97                 mc := add(mc, 0x20)
98                 cc := add(cc, 0x20)
99             } {
100                 // Write the _preBytes data into the tempBytes memory 32 bytes
101                 // at a time.
102                 mstore(mc, mload(cc))
103             }
104 
105             // Add the length of _postBytes to the current length of tempBytes
106             // and store it as the new length in the first 32 bytes of the
107             // tempBytes memory.
108             length := mload(_postBytes)
109             mstore(tempBytes, add(length, mload(tempBytes)))
110 
111             // Move the memory counter back from a multiple of 0x20 to the
112             // actual end of the _preBytes data.
113             mc := end
114             // Stop copying when the memory counter reaches the new combined
115             // length of the arrays.
116             end := add(mc, length)
117 
118             for {
119                 let cc := add(_postBytes, 0x20)
120             } lt(mc, end) {
121                 mc := add(mc, 0x20)
122                 cc := add(cc, 0x20)
123             } {
124                 mstore(mc, mload(cc))
125             }
126 
127             // Update the free-memory pointer by padding our last write location
128             // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
129             // next 32 byte block, then round down to the nearest multiple of
130             // 32. If the sum of the length of the two arrays is zero then add
131             // one before rounding down to leave a blank 32 bytes (the length block with 0).
132             mstore(0x40, and(
133               add(add(end, iszero(add(length, mload(_preBytes)))), 31),
134               not(31) // Round down to the nearest 32 bytes.
135             ))
136         }
137 
138         return tempBytes;
139     }
140 
141     function slice(
142         bytes memory _bytes,
143         uint _start,
144         uint _length
145     )
146         internal
147         pure
148         returns (bytes memory)
149     {
150         require(_bytes.length >= (_start + _length));
151 
152         bytes memory tempBytes;
153 
154         assembly {
155             switch iszero(_length)
156             case 0 {
157                 // Get a location of some free memory and store it in tempBytes as
158                 // Solidity does for memory variables.
159                 tempBytes := mload(0x40)
160 
161                 // The first word of the slice result is potentially a partial
162                 // word read from the original array. To read it, we calculate
163                 // the length of that partial word and start copying that many
164                 // bytes into the array. The first word we copy will start with
165                 // data we don't care about, but the last `lengthmod` bytes will
166                 // land at the beginning of the contents of the new array. When
167                 // we're done copying, we overwrite the full first word with
168                 // the actual length of the slice.
169                 let lengthmod := and(_length, 31)
170 
171                 // The multiplication in the next line is necessary
172                 // because when slicing multiples of 32 bytes (lengthmod == 0)
173                 // the following copy loop was copying the origin's length
174                 // and then ending prematurely not copying everything it should.
175                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
176                 let end := add(mc, _length)
177 
178                 for {
179                     // The multiplication in the next line has the same exact purpose
180                     // as the one above.
181                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
182                 } lt(mc, end) {
183                     mc := add(mc, 0x20)
184                     cc := add(cc, 0x20)
185                 } {
186                     mstore(mc, mload(cc))
187                 }
188 
189                 mstore(tempBytes, _length)
190 
191                 //update free-memory pointer
192                 //allocating the array padded to 32 bytes like the compiler does now
193                 mstore(0x40, and(add(mc, 31), not(31)))
194             }
195             //if we want a zero-length slice let's just return a zero-length array
196             default {
197                 tempBytes := mload(0x40)
198 
199                 mstore(0x40, add(tempBytes, 0x20))
200             }
201         }
202 
203         return tempBytes;
204     }
205 
206     function toAddress(bytes memory _bytes, uint _start) internal  pure returns (address) {
207         require(_bytes.length >= (_start + 20));
208         address tempAddress;
209 
210         assembly {
211             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
212         }
213 
214         return tempAddress;
215     }
216 
217     function toUint8(bytes memory _bytes, uint _start) internal  pure returns (uint8) {
218         require(_bytes.length >= (_start + 1));
219         uint8 tempUint;
220 
221         assembly {
222             tempUint := mload(add(add(_bytes, 0x1), _start))
223         }
224 
225         return tempUint;
226     }
227 
228     function toUint16(bytes memory _bytes, uint _start) internal  pure returns (uint16) {
229         require(_bytes.length >= (_start + 2));
230         uint16 tempUint;
231 
232         assembly {
233             tempUint := mload(add(add(_bytes, 0x2), _start))
234         }
235 
236         return tempUint;
237     }
238 
239     function toUint24(bytes memory _bytes, uint _start) internal  pure returns (uint24) {
240         require(_bytes.length >= (_start + 3));
241         uint24 tempUint;
242 
243         assembly {
244             tempUint := mload(add(add(_bytes, 0x3), _start))
245         }
246 
247         return tempUint;
248     }
249 
250     function toUint32(bytes memory _bytes, uint _start) internal  pure returns (uint32) {
251         require(_bytes.length >= (_start + 4));
252         uint32 tempUint;
253 
254         assembly {
255             tempUint := mload(add(add(_bytes, 0x4), _start))
256         }
257 
258         return tempUint;
259     }
260 
261     function toUint64(bytes memory _bytes, uint _start) internal  pure returns (uint64) {
262         require(_bytes.length >= (_start + 8));
263         uint64 tempUint;
264 
265         assembly {
266             tempUint := mload(add(add(_bytes, 0x8), _start))
267         }
268 
269         return tempUint;
270     }
271 
272     function toUint96(bytes memory _bytes, uint _start) internal  pure returns (uint96) {
273         require(_bytes.length >= (_start + 12));
274         uint96 tempUint;
275 
276         assembly {
277             tempUint := mload(add(add(_bytes, 0xc), _start))
278         }
279 
280         return tempUint;
281     }
282 
283     function toUint128(bytes memory _bytes, uint _start) internal  pure returns (uint128) {
284         require(_bytes.length >= (_start + 16));
285         uint128 tempUint;
286 
287         assembly {
288             tempUint := mload(add(add(_bytes, 0x10), _start))
289         }
290 
291         return tempUint;
292     }
293 
294     function toUint(bytes memory _bytes, uint _start) internal  pure returns (uint256) {
295         require(_bytes.length >= (_start + 32));
296         uint256 tempUint;
297 
298         assembly {
299             tempUint := mload(add(add(_bytes, 0x20), _start))
300         }
301 
302         return tempUint;
303     }
304 
305     function toBytes4(bytes memory _bytes, uint _start) internal  pure returns (bytes4) {
306         require(_bytes.length >= (_start + 4));
307         bytes4 tempBytes4;
308 
309         assembly {
310             tempBytes4 := mload(add(add(_bytes, 0x20), _start))
311         }
312 
313         return tempBytes4;
314     }
315 
316     function toBytes20(bytes memory _bytes, uint _start) internal  pure returns (bytes20) {
317         require(_bytes.length >= (_start + 20));
318         bytes20 tempBytes20;
319 
320         assembly {
321             tempBytes20 := mload(add(add(_bytes, 0x20), _start))
322         }
323 
324         return tempBytes20;
325     }
326 
327     function toBytes32(bytes memory _bytes, uint _start) internal  pure returns (bytes32) {
328         require(_bytes.length >= (_start + 32));
329         bytes32 tempBytes32;
330 
331         assembly {
332             tempBytes32 := mload(add(add(_bytes, 0x20), _start))
333         }
334 
335         return tempBytes32;
336     }
337 
338 
339     function toAddressUnsafe(bytes memory _bytes, uint _start) internal  pure returns (address) {
340         address tempAddress;
341 
342         assembly {
343             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
344         }
345 
346         return tempAddress;
347     }
348 
349     function toUint8Unsafe(bytes memory _bytes, uint _start) internal  pure returns (uint8) {
350         uint8 tempUint;
351 
352         assembly {
353             tempUint := mload(add(add(_bytes, 0x1), _start))
354         }
355 
356         return tempUint;
357     }
358 
359     function toUint16Unsafe(bytes memory _bytes, uint _start) internal  pure returns (uint16) {
360         uint16 tempUint;
361 
362         assembly {
363             tempUint := mload(add(add(_bytes, 0x2), _start))
364         }
365 
366         return tempUint;
367     }
368 
369     function toUint24Unsafe(bytes memory _bytes, uint _start) internal  pure returns (uint24) {
370         uint24 tempUint;
371 
372         assembly {
373             tempUint := mload(add(add(_bytes, 0x3), _start))
374         }
375 
376         return tempUint;
377     }
378 
379     function toUint32Unsafe(bytes memory _bytes, uint _start) internal  pure returns (uint32) {
380         uint32 tempUint;
381 
382         assembly {
383             tempUint := mload(add(add(_bytes, 0x4), _start))
384         }
385 
386         return tempUint;
387     }
388 
389     function toUint64Unsafe(bytes memory _bytes, uint _start) internal  pure returns (uint64) {
390         uint64 tempUint;
391 
392         assembly {
393             tempUint := mload(add(add(_bytes, 0x8), _start))
394         }
395 
396         return tempUint;
397     }
398 
399     function toUint96Unsafe(bytes memory _bytes, uint _start) internal  pure returns (uint96) {
400         uint96 tempUint;
401 
402         assembly {
403             tempUint := mload(add(add(_bytes, 0xc), _start))
404         }
405 
406         return tempUint;
407     }
408 
409     function toUint128Unsafe(bytes memory _bytes, uint _start) internal  pure returns (uint128) {
410         uint128 tempUint;
411 
412         assembly {
413             tempUint := mload(add(add(_bytes, 0x10), _start))
414         }
415 
416         return tempUint;
417     }
418 
419     function toUintUnsafe(bytes memory _bytes, uint _start) internal  pure returns (uint256) {
420         uint256 tempUint;
421 
422         assembly {
423             tempUint := mload(add(add(_bytes, 0x20), _start))
424         }
425 
426         return tempUint;
427     }
428 
429     function toBytes4Unsafe(bytes memory _bytes, uint _start) internal  pure returns (bytes4) {
430         bytes4 tempBytes4;
431 
432         assembly {
433             tempBytes4 := mload(add(add(_bytes, 0x20), _start))
434         }
435 
436         return tempBytes4;
437     }
438 
439     function toBytes20Unsafe(bytes memory _bytes, uint _start) internal  pure returns (bytes20) {
440         bytes20 tempBytes20;
441 
442         assembly {
443             tempBytes20 := mload(add(add(_bytes, 0x20), _start))
444         }
445 
446         return tempBytes20;
447     }
448 
449     function toBytes32Unsafe(bytes memory _bytes, uint _start) internal  pure returns (bytes32) {
450         bytes32 tempBytes32;
451 
452         assembly {
453             tempBytes32 := mload(add(add(_bytes, 0x20), _start))
454         }
455 
456         return tempBytes32;
457     }
458 
459 
460     function fastSHA256(
461         bytes memory data
462         )
463         internal
464         view
465         returns (bytes32)
466     {
467         bytes32[] memory result = new bytes32[](1);
468         bool success;
469         assembly {
470              let ptr := add(data, 32)
471              success := staticcall(sub(gas(), 2000), 2, ptr, mload(data), add(result, 32), 32)
472         }
473         require(success, "SHA256_FAILED");
474         return result[0];
475     }
476 }
477 
478 // File: contracts/core/iface/IAgentRegistry.sol
479 
480 // Copyright 2017 Loopring Technology Limited.
481 
482 interface IAgent{}
483 
484 abstract contract IAgentRegistry
485 {
486     /// @dev Returns whether an agent address is an agent of an account owner
487     /// @param owner The account owner.
488     /// @param agent The agent address
489     /// @return True if the agent address is an agent for the account owner, else false
490     function isAgent(
491         address owner,
492         address agent
493         )
494         external
495         virtual
496         view
497         returns (bool);
498 
499     /// @dev Returns whether an agent address is an agent of all account owners
500     /// @param owners The account owners.
501     /// @param agent The agent address
502     /// @return True if the agent address is an agent for the account owner, else false
503     function isAgent(
504         address[] calldata owners,
505         address            agent
506         )
507         external
508         virtual
509         view
510         returns (bool);
511 
512     /// @dev Returns whether an agent address is a universal agent.
513     /// @param agent The agent address
514     /// @return True if the agent address is a universal agent, else false
515     function isUniversalAgent(address agent)
516         public
517         virtual
518         view
519         returns (bool);
520 }
521 
522 // File: contracts/lib/Ownable.sol
523 
524 // Copyright 2017 Loopring Technology Limited.
525 
526 
527 /// @title Ownable
528 /// @author Brecht Devos - <brecht@loopring.org>
529 /// @dev The Ownable contract has an owner address, and provides basic
530 ///      authorization control functions, this simplifies the implementation of
531 ///      "user permissions".
532 contract Ownable
533 {
534     address public owner;
535 
536     event OwnershipTransferred(
537         address indexed previousOwner,
538         address indexed newOwner
539     );
540 
541     /// @dev The Ownable constructor sets the original `owner` of the contract
542     ///      to the sender.
543     constructor()
544     {
545         owner = msg.sender;
546     }
547 
548     /// @dev Throws if called by any account other than the owner.
549     modifier onlyOwner()
550     {
551         require(msg.sender == owner, "UNAUTHORIZED");
552         _;
553     }
554 
555     /// @dev Allows the current owner to transfer control of the contract to a
556     ///      new owner.
557     /// @param newOwner The address to transfer ownership to.
558     function transferOwnership(
559         address newOwner
560         )
561         public
562         virtual
563         onlyOwner
564     {
565         require(newOwner != address(0), "ZERO_ADDRESS");
566         emit OwnershipTransferred(owner, newOwner);
567         owner = newOwner;
568     }
569 
570     function renounceOwnership()
571         public
572         onlyOwner
573     {
574         emit OwnershipTransferred(owner, address(0));
575         owner = address(0);
576     }
577 }
578 
579 // File: contracts/lib/Claimable.sol
580 
581 // Copyright 2017 Loopring Technology Limited.
582 
583 
584 
585 /// @title Claimable
586 /// @author Brecht Devos - <brecht@loopring.org>
587 /// @dev Extension for the Ownable contract, where the ownership needs
588 ///      to be claimed. This allows the new owner to accept the transfer.
589 contract Claimable is Ownable
590 {
591     address public pendingOwner;
592 
593     /// @dev Modifier throws if called by any account other than the pendingOwner.
594     modifier onlyPendingOwner() {
595         require(msg.sender == pendingOwner, "UNAUTHORIZED");
596         _;
597     }
598 
599     /// @dev Allows the current owner to set the pendingOwner address.
600     /// @param newOwner The address to transfer ownership to.
601     function transferOwnership(
602         address newOwner
603         )
604         public
605         override
606         onlyOwner
607     {
608         require(newOwner != address(0) && newOwner != owner, "INVALID_ADDRESS");
609         pendingOwner = newOwner;
610     }
611 
612     /// @dev Allows the pendingOwner address to finalize the transfer.
613     function claimOwnership()
614         public
615         onlyPendingOwner
616     {
617         emit OwnershipTransferred(owner, pendingOwner);
618         owner = pendingOwner;
619         pendingOwner = address(0);
620     }
621 }
622 
623 // File: contracts/core/iface/IBlockVerifier.sol
624 
625 // Copyright 2017 Loopring Technology Limited.
626 
627 
628 
629 /// @title IBlockVerifier
630 /// @author Brecht Devos - <brecht@loopring.org>
631 abstract contract IBlockVerifier is Claimable
632 {
633     // -- Events --
634 
635     event CircuitRegistered(
636         uint8  indexed blockType,
637         uint16         blockSize,
638         uint8          blockVersion
639     );
640 
641     event CircuitDisabled(
642         uint8  indexed blockType,
643         uint16         blockSize,
644         uint8          blockVersion
645     );
646 
647     // -- Public functions --
648 
649     /// @dev Sets the verifying key for the specified circuit.
650     ///      Every block permutation needs its own circuit and thus its own set of
651     ///      verification keys. Only a limited number of block sizes per block
652     ///      type are supported.
653     /// @param blockType The type of the block
654     /// @param blockSize The number of requests handled in the block
655     /// @param blockVersion The block version (i.e. which circuit version needs to be used)
656     /// @param vk The verification key
657     function registerCircuit(
658         uint8    blockType,
659         uint16   blockSize,
660         uint8    blockVersion,
661         uint[18] calldata vk
662         )
663         external
664         virtual;
665 
666     /// @dev Disables the use of the specified circuit.
667     /// @param blockType The type of the block
668     /// @param blockSize The number of requests handled in the block
669     /// @param blockVersion The block version (i.e. which circuit version needs to be used)
670     function disableCircuit(
671         uint8  blockType,
672         uint16 blockSize,
673         uint8  blockVersion
674         )
675         external
676         virtual;
677 
678     /// @dev Verifies blocks with the given public data and proofs.
679     ///      Verifying a block makes sure all requests handled in the block
680     ///      are correctly handled by the operator.
681     /// @param blockType The type of block
682     /// @param blockSize The number of requests handled in the block
683     /// @param blockVersion The block version (i.e. which circuit version needs to be used)
684     /// @param publicInputs The hash of all the public data of the blocks
685     /// @param proofs The ZK proofs proving that the blocks are correct
686     /// @return True if the block is valid, false otherwise
687     function verifyProofs(
688         uint8  blockType,
689         uint16 blockSize,
690         uint8  blockVersion,
691         uint[] calldata publicInputs,
692         uint[] calldata proofs
693         )
694         external
695         virtual
696         view
697         returns (bool);
698 
699     /// @dev Checks if a circuit with the specified parameters is registered.
700     /// @param blockType The type of the block
701     /// @param blockSize The number of requests handled in the block
702     /// @param blockVersion The block version (i.e. which circuit version needs to be used)
703     /// @return True if the circuit is registered, false otherwise
704     function isCircuitRegistered(
705         uint8  blockType,
706         uint16 blockSize,
707         uint8  blockVersion
708         )
709         external
710         virtual
711         view
712         returns (bool);
713 
714     /// @dev Checks if a circuit can still be used to commit new blocks.
715     /// @param blockType The type of the block
716     /// @param blockSize The number of requests handled in the block
717     /// @param blockVersion The block version (i.e. which circuit version needs to be used)
718     /// @return True if the circuit is enabled, false otherwise
719     function isCircuitEnabled(
720         uint8  blockType,
721         uint16 blockSize,
722         uint8  blockVersion
723         )
724         external
725         virtual
726         view
727         returns (bool);
728 }
729 
730 // File: contracts/core/iface/IDepositContract.sol
731 
732 // Copyright 2017 Loopring Technology Limited.
733 
734 
735 /// @title IDepositContract.
736 /// @dev   Contract storing and transferring funds for an exchange.
737 ///
738 ///        ERC1155 tokens can be supported by registering pseudo token addresses calculated
739 ///        as `address(keccak256(real_token_address, token_params))`. Then the custom
740 ///        deposit contract can look up the real token address and paramsters with the
741 ///        pseudo token address before doing the transfers.
742 /// @author Brecht Devos - <brecht@loopring.org>
743 interface IDepositContract
744 {
745     /// @dev Returns if a token is suppoprted by this contract.
746     function isTokenSupported(address token)
747         external
748         view
749         returns (bool);
750 
751     /// @dev Transfers tokens from a user to the exchange. This function will
752     ///      be called when a user deposits funds to the exchange.
753     ///      In a simple implementation the funds are simply stored inside the
754     ///      deposit contract directly. More advanced implementations may store the funds
755     ///      in some DeFi application to earn interest, so this function could directly
756     ///      call the necessary functions to store the funds there.
757     ///
758     ///      This function needs to throw when an error occurred!
759     ///
760     ///      This function can only be called by the exchange.
761     ///
762     /// @param from The address of the account that sends the tokens.
763     /// @param token The address of the token to transfer (`0x0` for ETH).
764     /// @param amount The amount of tokens to transfer.
765     /// @param extraData Opaque data that can be used by the contract to handle the deposit
766     /// @return amountReceived The amount to deposit to the user's account in the Merkle tree
767     function deposit(
768         address from,
769         address token,
770         uint96  amount,
771         bytes   calldata extraData
772         )
773         external
774         payable
775         returns (uint96 amountReceived);
776 
777     /// @dev Transfers tokens from the exchange to a user. This function will
778     ///      be called when a withdrawal is done for a user on the exchange.
779     ///      In the simplest implementation the funds are simply stored inside the
780     ///      deposit contract directly so this simply transfers the requested tokens back
781     ///      to the user. More advanced implementations may store the funds
782     ///      in some DeFi application to earn interest so the function would
783     ///      need to get those tokens back from the DeFi application first before they
784     ///      can be transferred to the user.
785     ///
786     ///      This function needs to throw when an error occurred!
787     ///
788     ///      This function can only be called by the exchange.
789     ///
790     /// @param from The address from which 'amount' tokens are transferred.
791     /// @param to The address to which 'amount' tokens are transferred.
792     /// @param token The address of the token to transfer (`0x0` for ETH).
793     /// @param amount The amount of tokens transferred.
794     /// @param extraData Opaque data that can be used by the contract to handle the withdrawal
795     function withdraw(
796         address from,
797         address to,
798         address token,
799         uint    amount,
800         bytes   calldata extraData
801         )
802         external
803         payable;
804 
805     /// @dev Transfers tokens (ETH not supported) for a user using the allowance set
806     ///      for the exchange. This way the approval can be used for all functionality (and
807     ///      extended functionality) of the exchange.
808     ///      Should NOT be used to deposit/withdraw user funds, `deposit`/`withdraw`
809     ///      should be used for that as they will contain specialised logic for those operations.
810     ///      This function can be called by the exchange to transfer onchain funds of users
811     ///      necessary for Agent functionality.
812     ///
813     ///      This function needs to throw when an error occurred!
814     ///
815     ///      This function can only be called by the exchange.
816     ///
817     /// @param from The address of the account that sends the tokens.
818     /// @param to The address to which 'amount' tokens are transferred.
819     /// @param token The address of the token to transfer (ETH is and cannot be suppported).
820     /// @param amount The amount of tokens transferred.
821     function transfer(
822         address from,
823         address to,
824         address token,
825         uint    amount
826         )
827         external
828         payable;
829 
830     /// @dev Checks if the given address is used for depositing ETH or not.
831     ///      Is used while depositing to send the correct ETH amount to the deposit contract.
832     ///
833     ///      Note that 0x0 is always registered for deposting ETH when the exchange is created!
834     ///      This function allows additional addresses to be used for depositing ETH, the deposit
835     ///      contract can implement different behaviour based on the address value.
836     ///
837     /// @param addr The address to check
838     /// @return True if the address is used for depositing ETH, else false.
839     function isETH(address addr)
840         external
841         view
842         returns (bool);
843 }
844 
845 // File: contracts/core/iface/ILoopringV3.sol
846 
847 // Copyright 2017 Loopring Technology Limited.
848 
849 
850 
851 /// @title ILoopringV3
852 /// @author Brecht Devos - <brecht@loopring.org>
853 /// @author Daniel Wang  - <daniel@loopring.org>
854 abstract contract ILoopringV3 is Claimable
855 {
856     // == Events ==
857     event ExchangeStakeDeposited(address exchangeAddr, uint amount);
858     event ExchangeStakeWithdrawn(address exchangeAddr, uint amount);
859     event ExchangeStakeBurned(address exchangeAddr, uint amount);
860     event SettingsUpdated(uint time);
861 
862     // == Public Variables ==
863     mapping (address => uint) internal exchangeStake;
864 
865     uint    public totalStake;
866     address public blockVerifierAddress;
867     uint    public forcedWithdrawalFee;
868     uint    public tokenRegistrationFeeLRCBase;
869     uint    public tokenRegistrationFeeLRCDelta;
870     uint8   public protocolTakerFeeBips;
871     uint8   public protocolMakerFeeBips;
872 
873     address payable public protocolFeeVault;
874 
875     // == Public Functions ==
876 
877     /// @dev Returns the LRC token address
878     /// @return the LRC token address
879     function lrcAddress()
880         external
881         view
882         virtual
883         returns (address);
884 
885     /// @dev Updates the global exchange settings.
886     ///      This function can only be called by the owner of this contract.
887     ///
888     ///      Warning: these new values will be used by existing and
889     ///      new Loopring exchanges.
890     function updateSettings(
891         address payable _protocolFeeVault,   // address(0) not allowed
892         address _blockVerifierAddress,       // address(0) not allowed
893         uint    _forcedWithdrawalFee
894         )
895         external
896         virtual;
897 
898     /// @dev Updates the global protocol fee settings.
899     ///      This function can only be called by the owner of this contract.
900     ///
901     ///      Warning: these new values will be used by existing and
902     ///      new Loopring exchanges.
903     function updateProtocolFeeSettings(
904         uint8 _protocolTakerFeeBips,
905         uint8 _protocolMakerFeeBips
906         )
907         external
908         virtual;
909 
910     /// @dev Gets the amount of staked LRC for an exchange.
911     /// @param exchangeAddr The address of the exchange
912     /// @return stakedLRC The amount of LRC
913     function getExchangeStake(
914         address exchangeAddr
915         )
916         public
917         virtual
918         view
919         returns (uint stakedLRC);
920 
921     /// @dev Burns a certain amount of staked LRC for a specific exchange.
922     ///      This function is meant to be called only from exchange contracts.
923     /// @return burnedLRC The amount of LRC burned. If the amount is greater than
924     ///         the staked amount, all staked LRC will be burned.
925     function burnExchangeStake(
926         uint amount
927         )
928         external
929         virtual
930         returns (uint burnedLRC);
931 
932     /// @dev Stakes more LRC for an exchange.
933     /// @param  exchangeAddr The address of the exchange
934     /// @param  amountLRC The amount of LRC to stake
935     /// @return stakedLRC The total amount of LRC staked for the exchange
936     function depositExchangeStake(
937         address exchangeAddr,
938         uint    amountLRC
939         )
940         external
941         virtual
942         returns (uint stakedLRC);
943 
944     /// @dev Withdraws a certain amount of staked LRC for an exchange to the given address.
945     ///      This function is meant to be called only from within exchange contracts.
946     /// @param  recipient The address to receive LRC
947     /// @param  requestedAmount The amount of LRC to withdraw
948     /// @return amountLRC The amount of LRC withdrawn
949     function withdrawExchangeStake(
950         address recipient,
951         uint    requestedAmount
952         )
953         external
954         virtual
955         returns (uint amountLRC);
956 
957     /// @dev Gets the protocol fee values for an exchange.
958     /// @return takerFeeBips The protocol taker fee
959     /// @return makerFeeBips The protocol maker fee
960     function getProtocolFeeValues(
961         )
962         public
963         virtual
964         view
965         returns (
966             uint8 takerFeeBips,
967             uint8 makerFeeBips
968         );
969 }
970 
971 // File: contracts/core/iface/ExchangeData.sol
972 
973 // Copyright 2017 Loopring Technology Limited.
974 
975 
976 
977 
978 
979 
980 /// @title ExchangeData
981 /// @dev All methods in this lib are internal, therefore, there is no need
982 ///      to deploy this library independently.
983 /// @author Daniel Wang  - <daniel@loopring.org>
984 /// @author Brecht Devos - <brecht@loopring.org>
985 library ExchangeData
986 {
987     // -- Enums --
988     enum TransactionType
989     {
990         NOOP,
991         DEPOSIT,
992         WITHDRAWAL,
993         TRANSFER,
994         SPOT_TRADE,
995         ACCOUNT_UPDATE,
996         AMM_UPDATE,
997         SIGNATURE_VERIFICATION
998     }
999 
1000     // -- Structs --
1001     struct Token
1002     {
1003         address token;
1004     }
1005 
1006     struct ProtocolFeeData
1007     {
1008         uint32 syncedAt; // only valid before 2105 (85 years to go)
1009         uint8  takerFeeBips;
1010         uint8  makerFeeBips;
1011         uint8  previousTakerFeeBips;
1012         uint8  previousMakerFeeBips;
1013     }
1014 
1015     // General auxiliary data for each conditional transaction
1016     struct AuxiliaryData
1017     {
1018         uint  txIndex;
1019         bool  approved;
1020         bytes data;
1021     }
1022 
1023     // This is the (virtual) block the owner  needs to submit onchain to maintain the
1024     // per-exchange (virtual) blockchain.
1025     struct Block
1026     {
1027         uint8      blockType;
1028         uint16     blockSize;
1029         uint8      blockVersion;
1030         bytes      data;
1031         uint256[8] proof;
1032 
1033         // Whether we should store the @BlockInfo for this block on-chain.
1034         bool storeBlockInfoOnchain;
1035 
1036         // Block specific data that is only used to help process the block on-chain.
1037         // It is not used as input for the circuits and it is not necessary for data-availability.
1038         // This bytes array contains the abi encoded AuxiliaryData[] data.
1039         bytes auxiliaryData;
1040 
1041         // Arbitrary data, mainly for off-chain data-availability, i.e.,
1042         // the multihash of the IPFS file that contains the block data.
1043         bytes offchainData;
1044     }
1045 
1046     struct BlockInfo
1047     {
1048         // The time the block was submitted on-chain.
1049         uint32  timestamp;
1050         // The public data hash of the block (the 28 most significant bytes).
1051         bytes28 blockDataHash;
1052     }
1053 
1054     // Represents an onchain deposit request.
1055     struct Deposit
1056     {
1057         uint96 amount;
1058         uint64 timestamp;
1059     }
1060 
1061     // A forced withdrawal request.
1062     // If the actual owner of the account initiated the request (we don't know who the owner is
1063     // at the time the request is being made) the full balance will be withdrawn.
1064     struct ForcedWithdrawal
1065     {
1066         address owner;
1067         uint64  timestamp;
1068     }
1069 
1070     struct Constants
1071     {
1072         uint SNARK_SCALAR_FIELD;
1073         uint MAX_OPEN_FORCED_REQUESTS;
1074         uint MAX_AGE_FORCED_REQUEST_UNTIL_WITHDRAW_MODE;
1075         uint TIMESTAMP_HALF_WINDOW_SIZE_IN_SECONDS;
1076         uint MAX_NUM_ACCOUNTS;
1077         uint MAX_NUM_TOKENS;
1078         uint MIN_AGE_PROTOCOL_FEES_UNTIL_UPDATED;
1079         uint MIN_TIME_IN_SHUTDOWN;
1080         uint TX_DATA_AVAILABILITY_SIZE;
1081         uint MAX_AGE_DEPOSIT_UNTIL_WITHDRAWABLE_UPPERBOUND;
1082     }
1083 
1084     // This is the prime number that is used for the alt_bn128 elliptic curve, see EIP-196.
1085     uint public constant SNARK_SCALAR_FIELD = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
1086 
1087     uint public constant MAX_OPEN_FORCED_REQUESTS = 4096;
1088     uint public constant MAX_AGE_FORCED_REQUEST_UNTIL_WITHDRAW_MODE = 15 days;
1089     uint public constant TIMESTAMP_HALF_WINDOW_SIZE_IN_SECONDS = 7 days;
1090     uint public constant MAX_NUM_ACCOUNTS = 2 ** 32;
1091     uint public constant MAX_NUM_TOKENS = 2 ** 16;
1092     uint public constant MIN_AGE_PROTOCOL_FEES_UNTIL_UPDATED = 7 days;
1093     uint public constant MIN_TIME_IN_SHUTDOWN = 30 days;
1094     // The amount of bytes each rollup transaction uses in the block data for data-availability.
1095     // This is the maximum amount of bytes of all different transaction types.
1096     uint32 public constant MAX_AGE_DEPOSIT_UNTIL_WITHDRAWABLE_UPPERBOUND = 15 days;
1097     uint32 public constant ACCOUNTID_PROTOCOLFEE = 0;
1098 
1099     uint public constant TX_DATA_AVAILABILITY_SIZE = 68;
1100     uint public constant TX_DATA_AVAILABILITY_SIZE_PART_1 = 29;
1101     uint public constant TX_DATA_AVAILABILITY_SIZE_PART_2 = 39;
1102 
1103     struct AccountLeaf
1104     {
1105         uint32   accountID;
1106         address  owner;
1107         uint     pubKeyX;
1108         uint     pubKeyY;
1109         uint32   nonce;
1110         uint     feeBipsAMM;
1111     }
1112 
1113     struct BalanceLeaf
1114     {
1115         uint16   tokenID;
1116         uint96   balance;
1117         uint96   weightAMM;
1118         uint     storageRoot;
1119     }
1120 
1121     struct MerkleProof
1122     {
1123         ExchangeData.AccountLeaf accountLeaf;
1124         ExchangeData.BalanceLeaf balanceLeaf;
1125         uint[48]                 accountMerkleProof;
1126         uint[24]                 balanceMerkleProof;
1127     }
1128 
1129     struct BlockContext
1130     {
1131         bytes32 DOMAIN_SEPARATOR;
1132         uint32  timestamp;
1133     }
1134 
1135     // Represents the entire exchange state except the owner of the exchange.
1136     struct State
1137     {
1138         uint32  maxAgeDepositUntilWithdrawable;
1139         bytes32 DOMAIN_SEPARATOR;
1140 
1141         ILoopringV3      loopring;
1142         IBlockVerifier   blockVerifier;
1143         IAgentRegistry   agentRegistry;
1144         IDepositContract depositContract;
1145 
1146 
1147         // The merkle root of the offchain data stored in a Merkle tree. The Merkle tree
1148         // stores balances for users using an account model.
1149         bytes32 merkleRoot;
1150 
1151         // List of all blocks
1152         mapping(uint => BlockInfo) blocks;
1153         uint  numBlocks;
1154 
1155         // List of all tokens
1156         Token[] tokens;
1157 
1158         // A map from a token to its tokenID + 1
1159         mapping (address => uint16) tokenToTokenId;
1160 
1161         // A map from an accountID to a tokenID to if the balance is withdrawn
1162         mapping (uint32 => mapping (uint16 => bool)) withdrawnInWithdrawMode;
1163 
1164         // A map from an account to a token to the amount withdrawable for that account.
1165         // This is only used when the automatic distribution of the withdrawal failed.
1166         mapping (address => mapping (uint16 => uint)) amountWithdrawable;
1167 
1168         // A map from an account to a token to the forced withdrawal (always full balance)
1169         mapping (uint32 => mapping (uint16 => ForcedWithdrawal)) pendingForcedWithdrawals;
1170 
1171         // A map from an address to a token to a deposit
1172         mapping (address => mapping (uint16 => Deposit)) pendingDeposits;
1173 
1174         // A map from an account owner to an approved transaction hash to if the transaction is approved or not
1175         mapping (address => mapping (bytes32 => bool)) approvedTx;
1176 
1177         // A map from an account owner to a destination address to a tokenID to an amount to a storageID to a new recipient address
1178         mapping (address => mapping (address => mapping (uint16 => mapping (uint => mapping (uint32 => address))))) withdrawalRecipient;
1179 
1180 
1181         // Counter to keep track of how many of forced requests are open so we can limit the work that needs to be done by the owner
1182         uint32 numPendingForcedTransactions;
1183 
1184         // Cached data for the protocol fee
1185         ProtocolFeeData protocolFeeData;
1186 
1187         // Time when the exchange was shutdown
1188         uint shutdownModeStartTime;
1189 
1190         // Time when the exchange has entered withdrawal mode
1191         uint withdrawalModeStartTime;
1192 
1193         // Last time the protocol fee was withdrawn for a specific token
1194         mapping (address => uint) protocolFeeLastWithdrawnTime;
1195     }
1196 }
1197 
1198 // File: contracts/core/impl/libtransactions/BlockReader.sol
1199 
1200 // Copyright 2017 Loopring Technology Limited.
1201 
1202 
1203 
1204 /// @title BlockReader
1205 /// @author Brecht Devos - <brecht@loopring.org>
1206 /// @dev Utility library to read block data.
1207 library BlockReader {
1208     using BlockReader       for ExchangeData.Block;
1209     using BytesUtil         for bytes;
1210 
1211     uint public constant OFFSET_TO_TRANSACTIONS = 20 + 32 + 32 + 4 + 1 + 1 + 4 + 4;
1212 
1213     struct BlockHeader
1214     {
1215         address exchange;
1216         bytes32 merkleRootBefore;
1217         bytes32 merkleRootAfter;
1218         uint32  timestamp;
1219         uint8   protocolTakerFeeBips;
1220         uint8   protocolMakerFeeBips;
1221         uint32  numConditionalTransactions;
1222         uint32  operatorAccountID;
1223     }
1224 
1225     function readHeader(
1226         bytes memory _blockData
1227         )
1228         internal
1229         pure
1230         returns (BlockHeader memory header)
1231     {
1232         uint offset = 0;
1233         header.exchange = _blockData.toAddress(offset);
1234         offset += 20;
1235         header.merkleRootBefore = _blockData.toBytes32(offset);
1236         offset += 32;
1237         header.merkleRootAfter = _blockData.toBytes32(offset);
1238         offset += 32;
1239         header.timestamp = _blockData.toUint32(offset);
1240         offset += 4;
1241         header.protocolTakerFeeBips = _blockData.toUint8(offset);
1242         offset += 1;
1243         header.protocolMakerFeeBips = _blockData.toUint8(offset);
1244         offset += 1;
1245         header.numConditionalTransactions = _blockData.toUint32(offset);
1246         offset += 4;
1247         header.operatorAccountID = _blockData.toUint32(offset);
1248         offset += 4;
1249         assert(offset == OFFSET_TO_TRANSACTIONS);
1250     }
1251 
1252     function readTransactionData(
1253         bytes memory data,
1254         uint txIdx,
1255         uint blockSize,
1256         bytes memory txData
1257         )
1258         internal
1259         pure
1260     {
1261         require(txIdx < blockSize, "INVALID_TX_IDX");
1262 
1263         // The transaction was transformed to make it easier to compress.
1264         // Transform it back here.
1265         // Part 1
1266         uint txDataOffset = OFFSET_TO_TRANSACTIONS +
1267             txIdx * ExchangeData.TX_DATA_AVAILABILITY_SIZE_PART_1;
1268         assembly {
1269             mstore(add(txData, 32), mload(add(data, add(txDataOffset, 32))))
1270         }
1271         // Part 2
1272         txDataOffset = OFFSET_TO_TRANSACTIONS +
1273             blockSize * ExchangeData.TX_DATA_AVAILABILITY_SIZE_PART_1 +
1274             txIdx * ExchangeData.TX_DATA_AVAILABILITY_SIZE_PART_2;
1275         assembly {
1276             mstore(add(txData, 61 /*32 + 29*/), mload(add(data, add(txDataOffset, 32))))
1277             mstore(add(txData, 68            ), mload(add(data, add(txDataOffset, 39))))
1278         }
1279     }
1280 }
1281 
1282 // File: contracts/lib/EIP712.sol
1283 
1284 // Copyright 2017 Loopring Technology Limited.
1285 
1286 
1287 library EIP712
1288 {
1289     struct Domain {
1290         string  name;
1291         string  version;
1292         address verifyingContract;
1293     }
1294 
1295     bytes32 constant internal EIP712_DOMAIN_TYPEHASH = keccak256(
1296         "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1297     );
1298 
1299     string constant internal EIP191_HEADER = "\x19\x01";
1300 
1301     function hash(Domain memory domain)
1302         internal
1303         pure
1304         returns (bytes32)
1305     {
1306         uint _chainid;
1307         assembly { _chainid := chainid() }
1308 
1309         return keccak256(
1310             abi.encode(
1311                 EIP712_DOMAIN_TYPEHASH,
1312                 keccak256(bytes(domain.name)),
1313                 keccak256(bytes(domain.version)),
1314                 _chainid,
1315                 domain.verifyingContract
1316             )
1317         );
1318     }
1319 
1320     function hashPacked(
1321         bytes32 domainHash,
1322         bytes32 dataHash
1323         )
1324         internal
1325         pure
1326         returns (bytes32)
1327     {
1328         return keccak256(
1329             abi.encodePacked(
1330                 EIP191_HEADER,
1331                 domainHash,
1332                 dataHash
1333             )
1334         );
1335     }
1336 }
1337 
1338 // File: contracts/lib/MathUint.sol
1339 
1340 // Copyright 2017 Loopring Technology Limited.
1341 
1342 
1343 /// @title Utility Functions for uint
1344 /// @author Daniel Wang - <daniel@loopring.org>
1345 library MathUint
1346 {
1347     using MathUint for uint;
1348 
1349     function mul(
1350         uint a,
1351         uint b
1352         )
1353         internal
1354         pure
1355         returns (uint c)
1356     {
1357         c = a * b;
1358         require(a == 0 || c / a == b, "MUL_OVERFLOW");
1359     }
1360 
1361     function sub(
1362         uint a,
1363         uint b
1364         )
1365         internal
1366         pure
1367         returns (uint)
1368     {
1369         require(b <= a, "SUB_UNDERFLOW");
1370         return a - b;
1371     }
1372 
1373     function add(
1374         uint a,
1375         uint b
1376         )
1377         internal
1378         pure
1379         returns (uint c)
1380     {
1381         c = a + b;
1382         require(c >= a, "ADD_OVERFLOW");
1383     }
1384 
1385     function add64(
1386         uint64 a,
1387         uint64 b
1388         )
1389         internal
1390         pure
1391         returns (uint64 c)
1392     {
1393         c = a + b;
1394         require(c >= a, "ADD_OVERFLOW");
1395     }
1396 }
1397 
1398 // File: contracts/lib/AddressUtil.sol
1399 
1400 // Copyright 2017 Loopring Technology Limited.
1401 
1402 
1403 /// @title Utility Functions for addresses
1404 /// @author Daniel Wang - <daniel@loopring.org>
1405 /// @author Brecht Devos - <brecht@loopring.org>
1406 library AddressUtil
1407 {
1408     using AddressUtil for *;
1409 
1410     function isContract(
1411         address addr
1412         )
1413         internal
1414         view
1415         returns (bool)
1416     {
1417         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
1418         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
1419         // for accounts without code, i.e. `keccak256('')`
1420         bytes32 codehash;
1421         // solhint-disable-next-line no-inline-assembly
1422         assembly { codehash := extcodehash(addr) }
1423         return (codehash != 0x0 &&
1424                 codehash != 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470);
1425     }
1426 
1427     function toPayable(
1428         address addr
1429         )
1430         internal
1431         pure
1432         returns (address payable)
1433     {
1434         return payable(addr);
1435     }
1436 
1437     // Works like address.send but with a customizable gas limit
1438     // Make sure your code is safe for reentrancy when using this function!
1439     function sendETH(
1440         address to,
1441         uint    amount,
1442         uint    gasLimit
1443         )
1444         internal
1445         returns (bool success)
1446     {
1447         if (amount == 0) {
1448             return true;
1449         }
1450         address payable recipient = to.toPayable();
1451         /* solium-disable-next-line */
1452         (success, ) = recipient.call{value: amount, gas: gasLimit}("");
1453     }
1454 
1455     // Works like address.transfer but with a customizable gas limit
1456     // Make sure your code is safe for reentrancy when using this function!
1457     function sendETHAndVerify(
1458         address to,
1459         uint    amount,
1460         uint    gasLimit
1461         )
1462         internal
1463         returns (bool success)
1464     {
1465         success = to.sendETH(amount, gasLimit);
1466         require(success, "TRANSFER_FAILURE");
1467     }
1468 
1469     // Works like call but is slightly more efficient when data
1470     // needs to be copied from memory to do the call.
1471     function fastCall(
1472         address to,
1473         uint    gasLimit,
1474         uint    value,
1475         bytes   memory data
1476         )
1477         internal
1478         returns (bool success, bytes memory returnData)
1479     {
1480         if (to != address(0)) {
1481             assembly {
1482                 // Do the call
1483                 success := call(gasLimit, to, value, add(data, 32), mload(data), 0, 0)
1484                 // Copy the return data
1485                 let size := returndatasize()
1486                 returnData := mload(0x40)
1487                 mstore(returnData, size)
1488                 returndatacopy(add(returnData, 32), 0, size)
1489                 // Update free memory pointer
1490                 mstore(0x40, add(returnData, add(32, size)))
1491             }
1492         }
1493     }
1494 
1495     // Like fastCall, but throws when the call is unsuccessful.
1496     function fastCallAndVerify(
1497         address to,
1498         uint    gasLimit,
1499         uint    value,
1500         bytes   memory data
1501         )
1502         internal
1503         returns (bytes memory returnData)
1504     {
1505         bool success;
1506         (success, returnData) = fastCall(to, gasLimit, value, data);
1507         if (!success) {
1508             assembly {
1509                 revert(add(returnData, 32), mload(returnData))
1510             }
1511         }
1512     }
1513 }
1514 
1515 // File: contracts/lib/ERC1271.sol
1516 
1517 // Copyright 2017 Loopring Technology Limited.
1518 
1519 abstract contract ERC1271 {
1520     // bytes4(keccak256("isValidSignature(bytes32,bytes)")
1521     bytes4 constant internal ERC1271_MAGICVALUE = 0x1626ba7e;
1522 
1523     function isValidSignature(
1524         bytes32      _hash,
1525         bytes memory _signature)
1526         public
1527         view
1528         virtual
1529         returns (bytes4 magicValueB32);
1530 
1531 }
1532 
1533 // File: contracts/lib/SignatureUtil.sol
1534 
1535 // Copyright 2017 Loopring Technology Limited.
1536 
1537 
1538 
1539 
1540 
1541 
1542 /// @title SignatureUtil
1543 /// @author Daniel Wang - <daniel@loopring.org>
1544 /// @dev This method supports multihash standard. Each signature's last byte indicates
1545 ///      the signature's type.
1546 library SignatureUtil
1547 {
1548     using BytesUtil     for bytes;
1549     using MathUint      for uint;
1550     using AddressUtil   for address;
1551 
1552     enum SignatureType {
1553         ILLEGAL,
1554         INVALID,
1555         EIP_712,
1556         ETH_SIGN,
1557         WALLET   // deprecated
1558     }
1559 
1560     bytes4 constant internal ERC1271_MAGICVALUE = 0x1626ba7e;
1561 
1562     function verifySignatures(
1563         bytes32          signHash,
1564         address[] memory signers,
1565         bytes[]   memory signatures
1566         )
1567         internal
1568         view
1569         returns (bool)
1570     {
1571         require(signers.length == signatures.length, "BAD_SIGNATURE_DATA");
1572         address lastSigner;
1573         for (uint i = 0; i < signers.length; i++) {
1574             require(signers[i] > lastSigner, "INVALID_SIGNERS_ORDER");
1575             lastSigner = signers[i];
1576             if (!verifySignature(signHash, signers[i], signatures[i])) {
1577                 return false;
1578             }
1579         }
1580         return true;
1581     }
1582 
1583     function verifySignature(
1584         bytes32        signHash,
1585         address        signer,
1586         bytes   memory signature
1587         )
1588         internal
1589         view
1590         returns (bool)
1591     {
1592         if (signer == address(0)) {
1593             return false;
1594         }
1595 
1596         return signer.isContract()?
1597             verifyERC1271Signature(signHash, signer, signature):
1598             verifyEOASignature(signHash, signer, signature);
1599     }
1600 
1601     function recoverECDSASigner(
1602         bytes32      signHash,
1603         bytes memory signature
1604         )
1605         internal
1606         pure
1607         returns (address)
1608     {
1609         if (signature.length != 65) {
1610             return address(0);
1611         }
1612 
1613         bytes32 r;
1614         bytes32 s;
1615         uint8   v;
1616         // we jump 32 (0x20) as the first slot of bytes contains the length
1617         // we jump 65 (0x41) per signature
1618         // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
1619         assembly {
1620             r := mload(add(signature, 0x20))
1621             s := mload(add(signature, 0x40))
1622             v := and(mload(add(signature, 0x41)), 0xff)
1623         }
1624         // See https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/cryptography/ECDSA.sol
1625         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1626             return address(0);
1627         }
1628         if (v == 27 || v == 28) {
1629             return ecrecover(signHash, v, r, s);
1630         } else {
1631             return address(0);
1632         }
1633     }
1634 
1635     function verifyEOASignature(
1636         bytes32        signHash,
1637         address        signer,
1638         bytes   memory signature
1639         )
1640         private
1641         pure
1642         returns (bool success)
1643     {
1644         if (signer == address(0)) {
1645             return false;
1646         }
1647 
1648         uint signatureTypeOffset = signature.length.sub(1);
1649         SignatureType signatureType = SignatureType(signature.toUint8(signatureTypeOffset));
1650 
1651         // Strip off the last byte of the signature by updating the length
1652         assembly {
1653             mstore(signature, signatureTypeOffset)
1654         }
1655 
1656         if (signatureType == SignatureType.EIP_712) {
1657             success = (signer == recoverECDSASigner(signHash, signature));
1658         } else if (signatureType == SignatureType.ETH_SIGN) {
1659             bytes32 hash = keccak256(
1660                 abi.encodePacked("\x19Ethereum Signed Message:\n32", signHash)
1661             );
1662             success = (signer == recoverECDSASigner(hash, signature));
1663         } else {
1664             success = false;
1665         }
1666 
1667         // Restore the signature length
1668         assembly {
1669             mstore(signature, add(signatureTypeOffset, 1))
1670         }
1671 
1672         return success;
1673     }
1674 
1675     function verifyERC1271Signature(
1676         bytes32 signHash,
1677         address signer,
1678         bytes   memory signature
1679         )
1680         private
1681         view
1682         returns (bool)
1683     {
1684         bytes memory callData = abi.encodeWithSelector(
1685             ERC1271.isValidSignature.selector,
1686             signHash,
1687             signature
1688         );
1689         (bool success, bytes memory result) = signer.staticcall(callData);
1690         return (
1691             success &&
1692             result.length == 32 &&
1693             result.toBytes4(0) == ERC1271_MAGICVALUE
1694         );
1695     }
1696 }
1697 
1698 // File: contracts/core/impl/libexchange/ExchangeSignatures.sol
1699 
1700 // Copyright 2017 Loopring Technology Limited.
1701 
1702 
1703 
1704 
1705 /// @title ExchangeSignatures.
1706 /// @dev All methods in this lib are internal, therefore, there is no need
1707 ///      to deploy this library independently.
1708 /// @author Brecht Devos - <brecht@loopring.org>
1709 /// @author Daniel Wang  - <daniel@loopring.org>
1710 library ExchangeSignatures
1711 {
1712     using SignatureUtil for bytes32;
1713 
1714     function requireAuthorizedTx(
1715         ExchangeData.State storage S,
1716         address signer,
1717         bytes memory signature,
1718         bytes32 txHash
1719         )
1720         internal // inline call
1721     {
1722         require(signer != address(0), "INVALID_SIGNER");
1723         // Verify the signature if one is provided, otherwise fall back to an approved tx
1724         if (signature.length > 0) {
1725             require(txHash.verifySignature(signer, signature), "INVALID_SIGNATURE");
1726         } else {
1727             require(S.approvedTx[signer][txHash], "TX_NOT_APPROVED");
1728             delete S.approvedTx[signer][txHash];
1729         }
1730     }
1731 }
1732 
1733 // File: contracts/core/impl/libtransactions/AmmUpdateTransaction.sol
1734 
1735 // Copyright 2017 Loopring Technology Limited.
1736 
1737 
1738 
1739 
1740 
1741 
1742 
1743 
1744 /// @title AmmUpdateTransaction
1745 /// @author Brecht Devos - <brecht@loopring.org>
1746 library AmmUpdateTransaction
1747 {
1748     using BytesUtil            for bytes;
1749     using MathUint             for uint;
1750     using ExchangeSignatures   for ExchangeData.State;
1751 
1752     bytes32 constant public AMMUPDATE_TYPEHASH = keccak256(
1753         "AmmUpdate(address owner,uint32 accountID,uint16 tokenID,uint8 feeBips,uint96 tokenWeight,uint32 validUntil,uint32 nonce)"
1754     );
1755 
1756     struct AmmUpdate
1757     {
1758         address owner;
1759         uint32  accountID;
1760         uint16  tokenID;
1761         uint8   feeBips;
1762         uint96  tokenWeight;
1763         uint32  validUntil;
1764         uint32  nonce;
1765         uint96  balance;
1766     }
1767 
1768     // Auxiliary data for each AMM update
1769     struct AmmUpdateAuxiliaryData
1770     {
1771         bytes  signature;
1772         uint32 validUntil;
1773     }
1774 
1775     function process(
1776         ExchangeData.State        storage S,
1777         ExchangeData.BlockContext memory  ctx,
1778         bytes                     memory  data,
1779         uint                              offset,
1780         bytes                     memory  auxiliaryData
1781         )
1782         internal
1783     {
1784         // Read in the AMM update
1785         AmmUpdate memory update;
1786         readTx(data, offset, update);
1787         AmmUpdateAuxiliaryData memory auxData = abi.decode(auxiliaryData, (AmmUpdateAuxiliaryData));
1788 
1789         // Check validUntil
1790         require(ctx.timestamp < auxData.validUntil, "AMM_UPDATE_EXPIRED");
1791         update.validUntil = auxData.validUntil;
1792 
1793         // Calculate the tx hash
1794         bytes32 txHash = hashTx(ctx.DOMAIN_SEPARATOR, update);
1795 
1796         // Check the on-chain authorization
1797         S.requireAuthorizedTx(update.owner, auxData.signature, txHash);
1798     }
1799 
1800     function readTx(
1801         bytes memory data,
1802         uint         offset,
1803         AmmUpdate memory update
1804         )
1805         internal
1806         pure
1807     {
1808         uint _offset = offset;
1809 
1810         require(data.toUint8Unsafe(_offset) == uint8(ExchangeData.TransactionType.AMM_UPDATE), "INVALID_TX_TYPE");
1811         _offset += 1;
1812 
1813         // We don't use abi.decode for this because of the large amount of zero-padding
1814         // bytes the circuit would also have to hash.
1815         update.owner = data.toAddressUnsafe(_offset);
1816         _offset += 20;
1817         update.accountID = data.toUint32Unsafe(_offset);
1818         _offset += 4;
1819         update.tokenID = data.toUint16Unsafe(_offset);
1820         _offset += 2;
1821         update.feeBips = data.toUint8Unsafe(_offset);
1822         _offset += 1;
1823         update.tokenWeight = data.toUint96Unsafe(_offset);
1824         _offset += 12;
1825         update.nonce = data.toUint32Unsafe(_offset);
1826         _offset += 4;
1827         update.balance = data.toUint96Unsafe(_offset);
1828         _offset += 12;
1829     }
1830 
1831     function hashTx(
1832         bytes32 DOMAIN_SEPARATOR,
1833         AmmUpdate memory update
1834         )
1835         internal
1836         pure
1837         returns (bytes32)
1838     {
1839         return EIP712.hashPacked(
1840             DOMAIN_SEPARATOR,
1841             keccak256(
1842                 abi.encode(
1843                     AMMUPDATE_TYPEHASH,
1844                     update.owner,
1845                     update.accountID,
1846                     update.tokenID,
1847                     update.feeBips,
1848                     update.tokenWeight,
1849                     update.validUntil,
1850                     update.nonce
1851                 )
1852             )
1853         );
1854     }
1855 }
1856 
1857 // File: contracts/lib/MathUint96.sol
1858 
1859 // Copyright 2017 Loopring Technology Limited.
1860 
1861 
1862 /// @title Utility Functions for uint
1863 /// @author Daniel Wang - <daniel@loopring.org>
1864 library MathUint96
1865 {
1866     function add(
1867         uint96 a,
1868         uint96 b
1869         )
1870         internal
1871         pure
1872         returns (uint96 c)
1873     {
1874         c = a + b;
1875         require(c >= a, "ADD_OVERFLOW");
1876     }
1877 
1878     function sub(
1879         uint96 a,
1880         uint96 b
1881         )
1882         internal
1883         pure
1884         returns (uint96 c)
1885     {
1886         require(b <= a, "SUB_UNDERFLOW");
1887         return a - b;
1888     }
1889 }
1890 
1891 // File: contracts/core/impl/libtransactions/DepositTransaction.sol
1892 
1893 // Copyright 2017 Loopring Technology Limited.
1894 
1895 
1896 
1897 
1898 
1899 
1900 
1901 /// @title DepositTransaction
1902 /// @author Brecht Devos - <brecht@loopring.org>
1903 library DepositTransaction
1904 {
1905     using BytesUtil   for bytes;
1906     using MathUint96  for uint96;
1907 
1908     struct Deposit
1909     {
1910         address to;
1911         uint32  toAccountID;
1912         uint16  tokenID;
1913         uint96  amount;
1914     }
1915 
1916     function process(
1917         ExchangeData.State        storage S,
1918         ExchangeData.BlockContext memory  /*ctx*/,
1919         bytes                     memory  data,
1920         uint                              offset,
1921         bytes                     memory  /*auxiliaryData*/
1922         )
1923         internal
1924     {
1925         // Read in the deposit
1926         Deposit memory deposit;
1927         readTx(data, offset, deposit);
1928         if (deposit.amount == 0) {
1929             return;
1930         }
1931 
1932         // Process the deposit
1933         ExchangeData.Deposit memory pendingDeposit = S.pendingDeposits[deposit.to][deposit.tokenID];
1934         // Make sure the deposit was actually done
1935         require(pendingDeposit.timestamp > 0, "DEPOSIT_DOESNT_EXIST");
1936 
1937         // Processing partial amounts of the deposited amount is allowed.
1938         // This is done to ensure the user can do multiple deposits after each other
1939         // without invalidating work done by the exchange owner for previous deposit amounts.
1940 
1941         require(pendingDeposit.amount >= deposit.amount, "INVALID_AMOUNT");
1942         pendingDeposit.amount = pendingDeposit.amount.sub(deposit.amount);
1943 
1944         // If the deposit was fully consumed, reset it so the storage is freed up
1945         // and the owner receives a gas refund.
1946         if (pendingDeposit.amount == 0) {
1947             delete S.pendingDeposits[deposit.to][deposit.tokenID];
1948         } else {
1949             S.pendingDeposits[deposit.to][deposit.tokenID] = pendingDeposit;
1950         }
1951     }
1952 
1953     function readTx(
1954         bytes   memory data,
1955         uint           offset,
1956         Deposit memory deposit
1957         )
1958         internal
1959         pure
1960     {
1961         uint _offset = offset;
1962 
1963         require(data.toUint8Unsafe(_offset) == uint8(ExchangeData.TransactionType.DEPOSIT), "INVALID_TX_TYPE");
1964         _offset += 1;
1965 
1966         // We don't use abi.decode for this because of the large amount of zero-padding
1967         // bytes the circuit would also have to hash.
1968         deposit.to = data.toAddressUnsafe(_offset);
1969         _offset += 20;
1970         deposit.toAccountID = data.toUint32Unsafe(_offset);
1971         _offset += 4;
1972         deposit.tokenID = data.toUint16Unsafe(_offset);
1973         _offset += 2;
1974         deposit.amount = data.toUint96Unsafe(_offset);
1975         _offset += 12;
1976     }
1977 }
1978 
1979 // File: contracts/core/impl/libtransactions/SignatureVerificationTransaction.sol
1980 
1981 // Copyright 2017 Loopring Technology Limited.
1982 
1983 
1984 
1985 
1986 
1987 
1988 
1989 /// @title SignatureVerificationTransaction
1990 /// @author Brecht Devos - <brecht@loopring.org>
1991 library SignatureVerificationTransaction
1992 {
1993     using BytesUtil            for bytes;
1994     using MathUint             for uint;
1995 
1996     struct SignatureVerification
1997     {
1998         address owner;
1999         uint32  accountID;
2000         uint256 data;
2001     }
2002 
2003     function readTx(
2004         bytes memory data,
2005         uint         offset,
2006         SignatureVerification memory verification
2007         )
2008         internal
2009         pure
2010     {
2011         uint _offset = offset;
2012 
2013         require(data.toUint8Unsafe(_offset) == uint8(ExchangeData.TransactionType.SIGNATURE_VERIFICATION), "INVALID_TX_TYPE");
2014         _offset += 1;
2015 
2016         // We don't use abi.decode for this because of the large amount of zero-padding
2017         // bytes the circuit would also have to hash.
2018         verification.owner = data.toAddressUnsafe(_offset);
2019         _offset += 20;
2020         verification.accountID = data.toUint32Unsafe(_offset);
2021         _offset += 4;
2022         verification.data = data.toUintUnsafe(_offset);
2023         _offset += 32;
2024     }
2025 }
2026 
2027 // File: contracts/thirdparty/SafeCast.sol
2028 
2029 // Taken from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/SafeCast.sol
2030 
2031 
2032 
2033 /**
2034  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
2035  * checks.
2036  *
2037  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
2038  * easily result in undesired exploitation or bugs, since developers usually
2039  * assume that overflows raise errors. `SafeCast` restores this intuition by
2040  * reverting the transaction when such an operation overflows.
2041  *
2042  * Using this library instead of the unchecked operations eliminates an entire
2043  * class of bugs, so it's recommended to use it always.
2044  *
2045  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
2046  * all math on `uint256` and `int256` and then downcasting.
2047  */
2048 library SafeCast {
2049 
2050     /**
2051      * @dev Returns the downcasted uint128 from uint256, reverting on
2052      * overflow (when the input is greater than largest uint128).
2053      *
2054      * Counterpart to Solidity's `uint128` operator.
2055      *
2056      * Requirements:
2057      *
2058      * - input must fit into 128 bits
2059      */
2060     function toUint128(uint256 value) internal pure returns (uint128) {
2061         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
2062         return uint128(value);
2063     }
2064 
2065     /**
2066      * @dev Returns the downcasted uint96 from uint256, reverting on
2067      * overflow (when the input is greater than largest uint96).
2068      *
2069      * Counterpart to Solidity's `uint96` operator.
2070      *
2071      * Requirements:
2072      *
2073      * - input must fit into 96 bits
2074      */
2075     function toUint96(uint256 value) internal pure returns (uint96) {
2076         require(value < 2**96, "SafeCast: value doesn\'t fit in 96 bits");
2077         return uint96(value);
2078     }
2079 
2080     /**
2081      * @dev Returns the downcasted uint64 from uint256, reverting on
2082      * overflow (when the input is greater than largest uint64).
2083      *
2084      * Counterpart to Solidity's `uint64` operator.
2085      *
2086      * Requirements:
2087      *
2088      * - input must fit into 64 bits
2089      */
2090     function toUint64(uint256 value) internal pure returns (uint64) {
2091         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
2092         return uint64(value);
2093     }
2094 
2095     /**
2096      * @dev Returns the downcasted uint32 from uint256, reverting on
2097      * overflow (when the input is greater than largest uint32).
2098      *
2099      * Counterpart to Solidity's `uint32` operator.
2100      *
2101      * Requirements:
2102      *
2103      * - input must fit into 32 bits
2104      */
2105     function toUint32(uint256 value) internal pure returns (uint32) {
2106         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
2107         return uint32(value);
2108     }
2109 
2110     /**
2111      * @dev Returns the downcasted uint40 from uint256, reverting on
2112      * overflow (when the input is greater than largest uint40).
2113      *
2114      * Counterpart to Solidity's `uint32` operator.
2115      *
2116      * Requirements:
2117      *
2118      * - input must fit into 40 bits
2119      */
2120     function toUint40(uint256 value) internal pure returns (uint40) {
2121         require(value < 2**40, "SafeCast: value doesn\'t fit in 40 bits");
2122         return uint40(value);
2123     }
2124 
2125     /**
2126      * @dev Returns the downcasted uint16 from uint256, reverting on
2127      * overflow (when the input is greater than largest uint16).
2128      *
2129      * Counterpart to Solidity's `uint16` operator.
2130      *
2131      * Requirements:
2132      *
2133      * - input must fit into 16 bits
2134      */
2135     function toUint16(uint256 value) internal pure returns (uint16) {
2136         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
2137         return uint16(value);
2138     }
2139 
2140     /**
2141      * @dev Returns the downcasted uint8 from uint256, reverting on
2142      * overflow (when the input is greater than largest uint8).
2143      *
2144      * Counterpart to Solidity's `uint8` operator.
2145      *
2146      * Requirements:
2147      *
2148      * - input must fit into 8 bits.
2149      */
2150     function toUint8(uint256 value) internal pure returns (uint8) {
2151         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
2152         return uint8(value);
2153     }
2154 
2155     /**
2156      * @dev Converts a signed int256 into an unsigned uint256.
2157      *
2158      * Requirements:
2159      *
2160      * - input must be greater than or equal to 0.
2161      */
2162     function toUint256(int256 value) internal pure returns (uint256) {
2163         require(value >= 0, "SafeCast: value must be positive");
2164         return uint256(value);
2165     }
2166 
2167     /**
2168      * @dev Returns the downcasted int128 from int256, reverting on
2169      * overflow (when the input is less than smallest int128 or
2170      * greater than largest int128).
2171      *
2172      * Counterpart to Solidity's `int128` operator.
2173      *
2174      * Requirements:
2175      *
2176      * - input must fit into 128 bits
2177      *
2178      * _Available since v3.1._
2179      */
2180     function toInt128(int256 value) internal pure returns (int128) {
2181         require(value >= -2**127 && value < 2**127, "SafeCast: value doesn\'t fit in 128 bits");
2182         return int128(value);
2183     }
2184 
2185     /**
2186      * @dev Returns the downcasted int64 from int256, reverting on
2187      * overflow (when the input is less than smallest int64 or
2188      * greater than largest int64).
2189      *
2190      * Counterpart to Solidity's `int64` operator.
2191      *
2192      * Requirements:
2193      *
2194      * - input must fit into 64 bits
2195      *
2196      * _Available since v3.1._
2197      */
2198     function toInt64(int256 value) internal pure returns (int64) {
2199         require(value >= -2**63 && value < 2**63, "SafeCast: value doesn\'t fit in 64 bits");
2200         return int64(value);
2201     }
2202 
2203     /**
2204      * @dev Returns the downcasted int32 from int256, reverting on
2205      * overflow (when the input is less than smallest int32 or
2206      * greater than largest int32).
2207      *
2208      * Counterpart to Solidity's `int32` operator.
2209      *
2210      * Requirements:
2211      *
2212      * - input must fit into 32 bits
2213      *
2214      * _Available since v3.1._
2215      */
2216     function toInt32(int256 value) internal pure returns (int32) {
2217         require(value >= -2**31 && value < 2**31, "SafeCast: value doesn\'t fit in 32 bits");
2218         return int32(value);
2219     }
2220 
2221     /**
2222      * @dev Returns the downcasted int16 from int256, reverting on
2223      * overflow (when the input is less than smallest int16 or
2224      * greater than largest int16).
2225      *
2226      * Counterpart to Solidity's `int16` operator.
2227      *
2228      * Requirements:
2229      *
2230      * - input must fit into 16 bits
2231      *
2232      * _Available since v3.1._
2233      */
2234     function toInt16(int256 value) internal pure returns (int16) {
2235         require(value >= -2**15 && value < 2**15, "SafeCast: value doesn\'t fit in 16 bits");
2236         return int16(value);
2237     }
2238 
2239     /**
2240      * @dev Returns the downcasted int8 from int256, reverting on
2241      * overflow (when the input is less than smallest int8 or
2242      * greater than largest int8).
2243      *
2244      * Counterpart to Solidity's `int8` operator.
2245      *
2246      * Requirements:
2247      *
2248      * - input must fit into 8 bits.
2249      *
2250      * _Available since v3.1._
2251      */
2252     function toInt8(int256 value) internal pure returns (int8) {
2253         require(value >= -2**7 && value < 2**7, "SafeCast: value doesn\'t fit in 8 bits");
2254         return int8(value);
2255     }
2256 
2257     /**
2258      * @dev Converts an unsigned uint256 into a signed int256.
2259      *
2260      * Requirements:
2261      *
2262      * - input must be less than or equal to maxInt256.
2263      */
2264     function toInt256(uint256 value) internal pure returns (int256) {
2265         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
2266         return int256(value);
2267     }
2268 }
2269 
2270 // File: contracts/lib/FloatUtil.sol
2271 
2272 // Copyright 2017 Loopring Technology Limited.
2273 
2274 
2275 
2276 
2277 /// @title Utility Functions for floats
2278 /// @author Brecht Devos - <brecht@loopring.org>
2279 library FloatUtil
2280 {
2281     using MathUint for uint;
2282     using SafeCast for uint;
2283 
2284     // Decodes a decimal float value that is encoded like `exponent | mantissa`.
2285     // Both exponent and mantissa are in base 10.
2286     // Decoding to an integer is as simple as `mantissa * (10 ** exponent)`
2287     // Will throw when the decoded value overflows an uint96
2288     /// @param f The float value with 5 bits for the exponent
2289     /// @param numBits The total number of bits (numBitsMantissa := numBits - numBitsExponent)
2290     /// @return value The decoded integer value.
2291     function decodeFloat(
2292         uint f,
2293         uint numBits
2294         )
2295         internal
2296         pure
2297         returns (uint96 value)
2298     {
2299         if (f == 0) {
2300             return 0;
2301         }
2302         uint numBitsMantissa = numBits.sub(5);
2303         uint exponent = f >> numBitsMantissa;
2304         // log2(10**77) = 255.79 < 256
2305         require(exponent <= 77, "EXPONENT_TOO_LARGE");
2306         uint mantissa = f & ((1 << numBitsMantissa) - 1);
2307         value = mantissa.mul(10 ** exponent).toUint96();
2308     }
2309 
2310     // Decodes a decimal float value that is encoded like `exponent | mantissa`.
2311     // Both exponent and mantissa are in base 10.
2312     // Decoding to an integer is as simple as `mantissa * (10 ** exponent)`
2313     // Will throw when the decoded value overflows an uint96
2314     /// @param f The float value with 5 bits exponent, 11 bits mantissa
2315     /// @return value The decoded integer value.
2316     function decodeFloat16(
2317         uint16 f
2318         )
2319         internal
2320         pure
2321         returns (uint96)
2322     {
2323         uint value = ((uint(f) & 2047) * (10 ** (uint(f) >> 11)));
2324         require(value < 2**96, "SafeCast: value doesn\'t fit in 96 bits");
2325         return uint96(value);
2326     }
2327 
2328     // Decodes a decimal float value that is encoded like `exponent | mantissa`.
2329     // Both exponent and mantissa are in base 10.
2330     // Decoding to an integer is as simple as `mantissa * (10 ** exponent)`
2331     // Will throw when the decoded value overflows an uint96
2332     /// @param f The float value with 5 bits exponent, 19 bits mantissa
2333     /// @return value The decoded integer value.
2334     function decodeFloat24(
2335         uint24 f
2336         )
2337         internal
2338         pure
2339         returns (uint96)
2340     {
2341         uint value = ((uint(f) & 524287) * (10 ** (uint(f) >> 19)));
2342         require(value < 2**96, "SafeCast: value doesn\'t fit in 96 bits");
2343         return uint96(value);
2344     }
2345 }
2346 
2347 // File: contracts/core/impl/libtransactions/TransferTransaction.sol
2348 
2349 // Copyright 2017 Loopring Technology Limited.
2350 
2351 
2352 
2353 
2354 
2355 
2356 
2357 
2358 /// @title TransferTransaction
2359 /// @author Brecht Devos - <brecht@loopring.org>
2360 library TransferTransaction
2361 {
2362     using BytesUtil            for bytes;
2363     using FloatUtil            for uint24;
2364     using FloatUtil            for uint16;
2365     using MathUint             for uint;
2366     using ExchangeSignatures   for ExchangeData.State;
2367 
2368     bytes32 constant public TRANSFER_TYPEHASH = keccak256(
2369         "Transfer(address from,address to,uint16 tokenID,uint96 amount,uint16 feeTokenID,uint96 maxFee,uint32 validUntil,uint32 storageID)"
2370     );
2371 
2372     struct Transfer
2373     {
2374         uint32  fromAccountID;
2375         uint32  toAccountID;
2376         address from;
2377         address to;
2378         uint16  tokenID;
2379         uint96  amount;
2380         uint16  feeTokenID;
2381         uint96  maxFee;
2382         uint96  fee;
2383         uint32  validUntil;
2384         uint32  storageID;
2385     }
2386 
2387     // Auxiliary data for each transfer
2388     struct TransferAuxiliaryData
2389     {
2390         bytes  signature;
2391         uint96 maxFee;
2392         uint32 validUntil;
2393     }
2394 
2395     function process(
2396         ExchangeData.State        storage S,
2397         ExchangeData.BlockContext memory  ctx,
2398         bytes                     memory  data,
2399         uint                              offset,
2400         bytes                     memory  auxiliaryData
2401         )
2402         internal
2403     {
2404         // Read the transfer
2405         Transfer memory transfer;
2406         readTx(data, offset, transfer);
2407         TransferAuxiliaryData memory auxData = abi.decode(auxiliaryData, (TransferAuxiliaryData));
2408 
2409         // Fill in withdrawal data missing from DA
2410         transfer.validUntil = auxData.validUntil;
2411         transfer.maxFee = auxData.maxFee == 0 ? transfer.fee : auxData.maxFee;
2412         // Validate
2413         require(ctx.timestamp < transfer.validUntil, "TRANSFER_EXPIRED");
2414         require(transfer.fee <= transfer.maxFee, "TRANSFER_FEE_TOO_HIGH");
2415 
2416         // Calculate the tx hash
2417         bytes32 txHash = hashTx(ctx.DOMAIN_SEPARATOR, transfer);
2418 
2419         // Check the on-chain authorization
2420         S.requireAuthorizedTx(transfer.from, auxData.signature, txHash);
2421     }
2422 
2423     function readTx(
2424         bytes memory data,
2425         uint         offset,
2426         Transfer memory transfer
2427         )
2428         internal
2429         pure
2430     {
2431         uint _offset = offset;
2432 
2433         require(data.toUint8Unsafe(_offset) == uint8(ExchangeData.TransactionType.TRANSFER), "INVALID_TX_TYPE");
2434         _offset += 1;
2435 
2436         // Check that this is a conditional transfer
2437         require(data.toUint8Unsafe(_offset) == 1, "INVALID_AUXILIARYDATA_DATA");
2438         _offset += 1;
2439 
2440         // Extract the transfer data
2441         // We don't use abi.decode for this because of the large amount of zero-padding
2442         // bytes the circuit would also have to hash.
2443         transfer.fromAccountID = data.toUint32Unsafe(_offset);
2444         _offset += 4;
2445         transfer.toAccountID = data.toUint32Unsafe(_offset);
2446         _offset += 4;
2447         transfer.tokenID = data.toUint16Unsafe(_offset);
2448         _offset += 2;
2449         transfer.amount = data.toUint24Unsafe(_offset).decodeFloat24();
2450         _offset += 3;
2451         transfer.feeTokenID = data.toUint16Unsafe(_offset);
2452         _offset += 2;
2453         transfer.fee = data.toUint16Unsafe(_offset).decodeFloat16();
2454         _offset += 2;
2455         transfer.storageID = data.toUint32Unsafe(_offset);
2456         _offset += 4;
2457         transfer.to = data.toAddressUnsafe(_offset);
2458         _offset += 20;
2459         transfer.from = data.toAddressUnsafe(_offset);
2460         _offset += 20;
2461     }
2462 
2463     function hashTx(
2464         bytes32 DOMAIN_SEPARATOR,
2465         Transfer memory transfer
2466         )
2467         internal
2468         pure
2469         returns (bytes32)
2470     {
2471         return EIP712.hashPacked(
2472             DOMAIN_SEPARATOR,
2473             keccak256(
2474                 abi.encode(
2475                     TRANSFER_TYPEHASH,
2476                     transfer.from,
2477                     transfer.to,
2478                     transfer.tokenID,
2479                     transfer.amount,
2480                     transfer.feeTokenID,
2481                     transfer.maxFee,
2482                     transfer.validUntil,
2483                     transfer.storageID
2484                 )
2485             )
2486         );
2487     }
2488 }
2489 
2490 // File: contracts/core/impl/libexchange/ExchangeMode.sol
2491 
2492 // Copyright 2017 Loopring Technology Limited.
2493 
2494 
2495 
2496 
2497 /// @title ExchangeMode.
2498 /// @dev All methods in this lib are internal, therefore, there is no need
2499 ///      to deploy this library independently.
2500 /// @author Brecht Devos - <brecht@loopring.org>
2501 /// @author Daniel Wang  - <daniel@loopring.org>
2502 library ExchangeMode
2503 {
2504     using MathUint  for uint;
2505 
2506     function isInWithdrawalMode(
2507         ExchangeData.State storage S
2508         )
2509         internal // inline call
2510         view
2511         returns (bool result)
2512     {
2513         result = S.withdrawalModeStartTime > 0;
2514     }
2515 
2516     function isShutdown(
2517         ExchangeData.State storage S
2518         )
2519         internal // inline call
2520         view
2521         returns (bool)
2522     {
2523         return S.shutdownModeStartTime > 0;
2524     }
2525 
2526     function getNumAvailableForcedSlots(
2527         ExchangeData.State storage S
2528         )
2529         internal
2530         view
2531         returns (uint)
2532     {
2533         return ExchangeData.MAX_OPEN_FORCED_REQUESTS - S.numPendingForcedTransactions;
2534     }
2535 }
2536 
2537 // File: contracts/lib/Poseidon.sol
2538 
2539 // Copyright 2017 Loopring Technology Limited.
2540 
2541 
2542 /// @title Poseidon hash function
2543 ///        See: https://eprint.iacr.org/2019/458.pdf
2544 ///        Code auto-generated by generate_poseidon_EVM_code.py
2545 /// @author Brecht Devos - <brecht@loopring.org>
2546 library Poseidon
2547 {
2548     //
2549     // hash_t5f6p52
2550     //
2551 
2552     struct HashInputs5
2553     {
2554         uint t0;
2555         uint t1;
2556         uint t2;
2557         uint t3;
2558         uint t4;
2559     }
2560 
2561     function hash_t5f6p52_internal(
2562         uint t0,
2563         uint t1,
2564         uint t2,
2565         uint t3,
2566         uint t4,
2567         uint q
2568         )
2569         internal
2570         pure
2571         returns (uint)
2572     {
2573         assembly {
2574             function mix(_t0, _t1, _t2, _t3, _t4, _q) -> nt0, nt1, nt2, nt3, nt4 {
2575                 nt0 := mulmod(_t0, 4977258759536702998522229302103997878600602264560359702680165243908162277980, _q)
2576                 nt0 := addmod(nt0, mulmod(_t1, 19167410339349846567561662441069598364702008768579734801591448511131028229281, _q), _q)
2577                 nt0 := addmod(nt0, mulmod(_t2, 14183033936038168803360723133013092560869148726790180682363054735190196956789, _q), _q)
2578                 nt0 := addmod(nt0, mulmod(_t3, 9067734253445064890734144122526450279189023719890032859456830213166173619761, _q), _q)
2579                 nt0 := addmod(nt0, mulmod(_t4, 16378664841697311562845443097199265623838619398287411428110917414833007677155, _q), _q)
2580                 nt1 := mulmod(_t0, 107933704346764130067829474107909495889716688591997879426350582457782826785, _q)
2581                 nt1 := addmod(nt1, mulmod(_t1, 17034139127218860091985397764514160131253018178110701196935786874261236172431, _q), _q)
2582                 nt1 := addmod(nt1, mulmod(_t2, 2799255644797227968811798608332314218966179365168250111693473252876996230317, _q), _q)
2583                 nt1 := addmod(nt1, mulmod(_t3, 2482058150180648511543788012634934806465808146786082148795902594096349483974, _q), _q)
2584                 nt1 := addmod(nt1, mulmod(_t4, 16563522740626180338295201738437974404892092704059676533096069531044355099628, _q), _q)
2585                 nt2 := mulmod(_t0, 13596762909635538739079656925495736900379091964739248298531655823337482778123, _q)
2586                 nt2 := addmod(nt2, mulmod(_t1, 18985203040268814769637347880759846911264240088034262814847924884273017355969, _q), _q)
2587                 nt2 := addmod(nt2, mulmod(_t2, 8652975463545710606098548415650457376967119951977109072274595329619335974180, _q), _q)
2588                 nt2 := addmod(nt2, mulmod(_t3, 970943815872417895015626519859542525373809485973005165410533315057253476903, _q), _q)
2589                 nt2 := addmod(nt2, mulmod(_t4, 19406667490568134101658669326517700199745817783746545889094238643063688871948, _q), _q)
2590                 nt3 := mulmod(_t0, 2953507793609469112222895633455544691298656192015062835263784675891831794974, _q)
2591                 nt3 := addmod(nt3, mulmod(_t1, 19025623051770008118343718096455821045904242602531062247152770448380880817517, _q), _q)
2592                 nt3 := addmod(nt3, mulmod(_t2, 9077319817220936628089890431129759976815127354480867310384708941479362824016, _q), _q)
2593                 nt3 := addmod(nt3, mulmod(_t3, 4770370314098695913091200576539533727214143013236894216582648993741910829490, _q), _q)
2594                 nt3 := addmod(nt3, mulmod(_t4, 4298564056297802123194408918029088169104276109138370115401819933600955259473, _q), _q)
2595                 nt4 := mulmod(_t0, 8336710468787894148066071988103915091676109272951895469087957569358494947747, _q)
2596                 nt4 := addmod(nt4, mulmod(_t1, 16205238342129310687768799056463408647672389183328001070715567975181364448609, _q), _q)
2597                 nt4 := addmod(nt4, mulmod(_t2, 8303849270045876854140023508764676765932043944545416856530551331270859502246, _q), _q)
2598                 nt4 := addmod(nt4, mulmod(_t3, 20218246699596954048529384569730026273241102596326201163062133863539137060414, _q), _q)
2599                 nt4 := addmod(nt4, mulmod(_t4, 1712845821388089905746651754894206522004527237615042226559791118162382909269, _q), _q)
2600             }
2601 
2602             function ark(_t0, _t1, _t2, _t3, _t4, _q, c) -> nt0, nt1, nt2, nt3, nt4 {
2603                 nt0 := addmod(_t0, c, _q)
2604                 nt1 := addmod(_t1, c, _q)
2605                 nt2 := addmod(_t2, c, _q)
2606                 nt3 := addmod(_t3, c, _q)
2607                 nt4 := addmod(_t4, c, _q)
2608             }
2609 
2610             function sbox_full(_t0, _t1, _t2, _t3, _t4, _q) -> nt0, nt1, nt2, nt3, nt4 {
2611                 nt0 := mulmod(_t0, _t0, _q)
2612                 nt0 := mulmod(nt0, nt0, _q)
2613                 nt0 := mulmod(_t0, nt0, _q)
2614                 nt1 := mulmod(_t1, _t1, _q)
2615                 nt1 := mulmod(nt1, nt1, _q)
2616                 nt1 := mulmod(_t1, nt1, _q)
2617                 nt2 := mulmod(_t2, _t2, _q)
2618                 nt2 := mulmod(nt2, nt2, _q)
2619                 nt2 := mulmod(_t2, nt2, _q)
2620                 nt3 := mulmod(_t3, _t3, _q)
2621                 nt3 := mulmod(nt3, nt3, _q)
2622                 nt3 := mulmod(_t3, nt3, _q)
2623                 nt4 := mulmod(_t4, _t4, _q)
2624                 nt4 := mulmod(nt4, nt4, _q)
2625                 nt4 := mulmod(_t4, nt4, _q)
2626             }
2627 
2628             function sbox_partial(_t, _q) -> nt {
2629                 nt := mulmod(_t, _t, _q)
2630                 nt := mulmod(nt, nt, _q)
2631                 nt := mulmod(_t, nt, _q)
2632             }
2633 
2634             // round 0
2635             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 14397397413755236225575615486459253198602422701513067526754101844196324375522)
2636             t0, t1, t2, t3, t4 := sbox_full(t0, t1, t2, t3, t4, q)
2637             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2638             // round 1
2639             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 10405129301473404666785234951972711717481302463898292859783056520670200613128)
2640             t0, t1, t2, t3, t4 := sbox_full(t0, t1, t2, t3, t4, q)
2641             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2642             // round 2
2643             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 5179144822360023508491245509308555580251733042407187134628755730783052214509)
2644             t0, t1, t2, t3, t4 := sbox_full(t0, t1, t2, t3, t4, q)
2645             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2646             // round 3
2647             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 9132640374240188374542843306219594180154739721841249568925550236430986592615)
2648             t0 := sbox_partial(t0, q)
2649             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2650             // round 4
2651             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 20360807315276763881209958738450444293273549928693737723235350358403012458514)
2652             t0 := sbox_partial(t0, q)
2653             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2654             // round 5
2655             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 17933600965499023212689924809448543050840131883187652471064418452962948061619)
2656             t0 := sbox_partial(t0, q)
2657             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2658             // round 6
2659             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 3636213416533737411392076250708419981662897009810345015164671602334517041153)
2660             t0 := sbox_partial(t0, q)
2661             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2662             // round 7
2663             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 2008540005368330234524962342006691994500273283000229509835662097352946198608)
2664             t0 := sbox_partial(t0, q)
2665             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2666             // round 8
2667             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 16018407964853379535338740313053768402596521780991140819786560130595652651567)
2668             t0 := sbox_partial(t0, q)
2669             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2670             // round 9
2671             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 20653139667070586705378398435856186172195806027708437373983929336015162186471)
2672             t0 := sbox_partial(t0, q)
2673             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2674             // round 10
2675             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 17887713874711369695406927657694993484804203950786446055999405564652412116765)
2676             t0 := sbox_partial(t0, q)
2677             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2678             // round 11
2679             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 4852706232225925756777361208698488277369799648067343227630786518486608711772)
2680             t0 := sbox_partial(t0, q)
2681             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2682             // round 12
2683             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 8969172011633935669771678412400911310465619639756845342775631896478908389850)
2684             t0 := sbox_partial(t0, q)
2685             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2686             // round 13
2687             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 20570199545627577691240476121888846460936245025392381957866134167601058684375)
2688             t0 := sbox_partial(t0, q)
2689             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2690             // round 14
2691             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 16442329894745639881165035015179028112772410105963688121820543219662832524136)
2692             t0 := sbox_partial(t0, q)
2693             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2694             // round 15
2695             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 20060625627350485876280451423010593928172611031611836167979515653463693899374)
2696             t0 := sbox_partial(t0, q)
2697             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2698             // round 16
2699             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 16637282689940520290130302519163090147511023430395200895953984829546679599107)
2700             t0 := sbox_partial(t0, q)
2701             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2702             // round 17
2703             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 15599196921909732993082127725908821049411366914683565306060493533569088698214)
2704             t0 := sbox_partial(t0, q)
2705             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2706             // round 18
2707             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 16894591341213863947423904025624185991098788054337051624251730868231322135455)
2708             t0 := sbox_partial(t0, q)
2709             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2710             // round 19
2711             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 1197934381747032348421303489683932612752526046745577259575778515005162320212)
2712             t0 := sbox_partial(t0, q)
2713             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2714             // round 20
2715             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 6172482022646932735745595886795230725225293469762393889050804649558459236626)
2716             t0 := sbox_partial(t0, q)
2717             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2718             // round 21
2719             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 21004037394166516054140386756510609698837211370585899203851827276330669555417)
2720             t0 := sbox_partial(t0, q)
2721             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2722             // round 22
2723             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 15262034989144652068456967541137853724140836132717012646544737680069032573006)
2724             t0 := sbox_partial(t0, q)
2725             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2726             // round 23
2727             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 15017690682054366744270630371095785995296470601172793770224691982518041139766)
2728             t0 := sbox_partial(t0, q)
2729             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2730             // round 24
2731             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 15159744167842240513848638419303545693472533086570469712794583342699782519832)
2732             t0 := sbox_partial(t0, q)
2733             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2734             // round 25
2735             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 11178069035565459212220861899558526502477231302924961773582350246646450941231)
2736             t0 := sbox_partial(t0, q)
2737             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2738             // round 26
2739             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 21154888769130549957415912997229564077486639529994598560737238811887296922114)
2740             t0 := sbox_partial(t0, q)
2741             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2742             // round 27
2743             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 20162517328110570500010831422938033120419484532231241180224283481905744633719)
2744             t0 := sbox_partial(t0, q)
2745             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2746             // round 28
2747             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 2777362604871784250419758188173029886707024739806641263170345377816177052018)
2748             t0 := sbox_partial(t0, q)
2749             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2750             // round 29
2751             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 15732290486829619144634131656503993123618032247178179298922551820261215487562)
2752             t0 := sbox_partial(t0, q)
2753             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2754             // round 30
2755             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 6024433414579583476444635447152826813568595303270846875177844482142230009826)
2756             t0 := sbox_partial(t0, q)
2757             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2758             // round 31
2759             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 17677827682004946431939402157761289497221048154630238117709539216286149983245)
2760             t0 := sbox_partial(t0, q)
2761             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2762             // round 32
2763             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 10716307389353583413755237303156291454109852751296156900963208377067748518748)
2764             t0 := sbox_partial(t0, q)
2765             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2766             // round 33
2767             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 14925386988604173087143546225719076187055229908444910452781922028996524347508)
2768             t0 := sbox_partial(t0, q)
2769             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2770             // round 34
2771             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 8940878636401797005293482068100797531020505636124892198091491586778667442523)
2772             t0 := sbox_partial(t0, q)
2773             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2774             // round 35
2775             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 18911747154199663060505302806894425160044925686870165583944475880789706164410)
2776             t0 := sbox_partial(t0, q)
2777             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2778             // round 36
2779             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 8821532432394939099312235292271438180996556457308429936910969094255825456935)
2780             t0 := sbox_partial(t0, q)
2781             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2782             // round 37
2783             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 20632576502437623790366878538516326728436616723089049415538037018093616927643)
2784             t0 := sbox_partial(t0, q)
2785             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2786             // round 38
2787             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 71447649211767888770311304010816315780740050029903404046389165015534756512)
2788             t0 := sbox_partial(t0, q)
2789             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2790             // round 39
2791             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 2781996465394730190470582631099299305677291329609718650018200531245670229393)
2792             t0 := sbox_partial(t0, q)
2793             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2794             // round 40
2795             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 12441376330954323535872906380510501637773629931719508864016287320488688345525)
2796             t0 := sbox_partial(t0, q)
2797             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2798             // round 41
2799             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 2558302139544901035700544058046419714227464650146159803703499681139469546006)
2800             t0 := sbox_partial(t0, q)
2801             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2802             // round 42
2803             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 10087036781939179132584550273563255199577525914374285705149349445480649057058)
2804             t0 := sbox_partial(t0, q)
2805             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2806             // round 43
2807             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 4267692623754666261749551533667592242661271409704769363166965280715887854739)
2808             t0 := sbox_partial(t0, q)
2809             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2810             // round 44
2811             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 4945579503584457514844595640661884835097077318604083061152997449742124905548)
2812             t0 := sbox_partial(t0, q)
2813             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2814             // round 45
2815             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 17742335354489274412669987990603079185096280484072783973732137326144230832311)
2816             t0 := sbox_partial(t0, q)
2817             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2818             // round 46
2819             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 6266270088302506215402996795500854910256503071464802875821837403486057988208)
2820             t0 := sbox_partial(t0, q)
2821             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2822             // round 47
2823             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 2716062168542520412498610856550519519760063668165561277991771577403400784706)
2824             t0 := sbox_partial(t0, q)
2825             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2826             // round 48
2827             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 19118392018538203167410421493487769944462015419023083813301166096764262134232)
2828             t0 := sbox_partial(t0, q)
2829             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2830             // round 49
2831             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 9386595745626044000666050847309903206827901310677406022353307960932745699524)
2832             t0 := sbox_partial(t0, q)
2833             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2834             // round 50
2835             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 9121640807890366356465620448383131419933298563527245687958865317869840082266)
2836             t0 := sbox_partial(t0, q)
2837             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2838             // round 51
2839             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 3078975275808111706229899605611544294904276390490742680006005661017864583210)
2840             t0 := sbox_partial(t0, q)
2841             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2842             // round 52
2843             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 7157404299437167354719786626667769956233708887934477609633504801472827442743)
2844             t0 := sbox_partial(t0, q)
2845             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2846             // round 53
2847             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 14056248655941725362944552761799461694550787028230120190862133165195793034373)
2848             t0 := sbox_partial(t0, q)
2849             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2850             // round 54
2851             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 14124396743304355958915937804966111851843703158171757752158388556919187839849)
2852             t0 := sbox_partial(t0, q)
2853             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2854             // round 55
2855             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 11851254356749068692552943732920045260402277343008629727465773766468466181076)
2856             t0, t1, t2, t3, t4 := sbox_full(t0, t1, t2, t3, t4, q)
2857             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2858             // round 56
2859             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 9799099446406796696742256539758943483211846559715874347178722060519817626047)
2860             t0, t1, t2, t3, t4 := sbox_full(t0, t1, t2, t3, t4, q)
2861             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2862             // round 57
2863             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 10156146186214948683880719664738535455146137901666656566575307300522957959544)
2864             t0, t1, t2, t3, t4 := sbox_full(t0, t1, t2, t3, t4, q)
2865             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2866         }
2867         return t0;
2868     }
2869 
2870     function hash_t5f6p52(HashInputs5 memory i, uint q) internal pure returns (uint)
2871     {
2872         // validate inputs
2873         require(i.t0 < q, "INVALID_INPUT");
2874         require(i.t1 < q, "INVALID_INPUT");
2875         require(i.t2 < q, "INVALID_INPUT");
2876         require(i.t3 < q, "INVALID_INPUT");
2877         require(i.t4 < q, "INVALID_INPUT");
2878 
2879         return hash_t5f6p52_internal(i.t0, i.t1, i.t2, i.t3, i.t4, q);
2880     }
2881 
2882 
2883     //
2884     // hash_t7f6p52
2885     //
2886 
2887     struct HashInputs7
2888     {
2889         uint t0;
2890         uint t1;
2891         uint t2;
2892         uint t3;
2893         uint t4;
2894         uint t5;
2895         uint t6;
2896     }
2897 
2898     function mix(HashInputs7 memory i, uint q) internal pure
2899     {
2900         HashInputs7 memory o;
2901         o.t0 = mulmod(i.t0, 14183033936038168803360723133013092560869148726790180682363054735190196956789, q);
2902         o.t0 = addmod(o.t0, mulmod(i.t1, 9067734253445064890734144122526450279189023719890032859456830213166173619761, q), q);
2903         o.t0 = addmod(o.t0, mulmod(i.t2, 16378664841697311562845443097199265623838619398287411428110917414833007677155, q), q);
2904         o.t0 = addmod(o.t0, mulmod(i.t3, 12968540216479938138647596899147650021419273189336843725176422194136033835172, q), q);
2905         o.t0 = addmod(o.t0, mulmod(i.t4, 3636162562566338420490575570584278737093584021456168183289112789616069756675, q), q);
2906         o.t0 = addmod(o.t0, mulmod(i.t5, 8949952361235797771659501126471156178804092479420606597426318793013844305422, q), q);
2907         o.t0 = addmod(o.t0, mulmod(i.t6, 13586657904816433080148729258697725609063090799921401830545410130405357110367, q), q);
2908         o.t1 = mulmod(i.t0, 2799255644797227968811798608332314218966179365168250111693473252876996230317, q);
2909         o.t1 = addmod(o.t1, mulmod(i.t1, 2482058150180648511543788012634934806465808146786082148795902594096349483974, q), q);
2910         o.t1 = addmod(o.t1, mulmod(i.t2, 16563522740626180338295201738437974404892092704059676533096069531044355099628, q), q);
2911         o.t1 = addmod(o.t1, mulmod(i.t3, 10468644849657689537028565510142839489302836569811003546969773105463051947124, q), q);
2912         o.t1 = addmod(o.t1, mulmod(i.t4, 3328913364598498171733622353010907641674136720305714432354138807013088636408, q), q);
2913         o.t1 = addmod(o.t1, mulmod(i.t5, 8642889650254799419576843603477253661899356105675006557919250564400804756641, q), q);
2914         o.t1 = addmod(o.t1, mulmod(i.t6, 14300697791556510113764686242794463641010174685800128469053974698256194076125, q), q);
2915         o.t2 = mulmod(i.t0, 8652975463545710606098548415650457376967119951977109072274595329619335974180, q);
2916         o.t2 = addmod(o.t2, mulmod(i.t1, 970943815872417895015626519859542525373809485973005165410533315057253476903, q), q);
2917         o.t2 = addmod(o.t2, mulmod(i.t2, 19406667490568134101658669326517700199745817783746545889094238643063688871948, q), q);
2918         o.t2 = addmod(o.t2, mulmod(i.t3, 17049854690034965250221386317058877242629221002521630573756355118745574274967, q), q);
2919         o.t2 = addmod(o.t2, mulmod(i.t4, 4964394613021008685803675656098849539153699842663541444414978877928878266244, q), q);
2920         o.t2 = addmod(o.t2, mulmod(i.t5, 15474947305445649466370538888925567099067120578851553103424183520405650587995, q), q);
2921         o.t2 = addmod(o.t2, mulmod(i.t6, 1016119095639665978105768933448186152078842964810837543326777554729232767846, q), q);
2922         o.t3 = mulmod(i.t0, 9077319817220936628089890431129759976815127354480867310384708941479362824016, q);
2923         o.t3 = addmod(o.t3, mulmod(i.t1, 4770370314098695913091200576539533727214143013236894216582648993741910829490, q), q);
2924         o.t3 = addmod(o.t3, mulmod(i.t2, 4298564056297802123194408918029088169104276109138370115401819933600955259473, q), q);
2925         o.t3 = addmod(o.t3, mulmod(i.t3, 6905514380186323693285869145872115273350947784558995755916362330070690839131, q), q);
2926         o.t3 = addmod(o.t3, mulmod(i.t4, 4783343257810358393326889022942241108539824540285247795235499223017138301952, q), q);
2927         o.t3 = addmod(o.t3, mulmod(i.t5, 1420772902128122367335354247676760257656541121773854204774788519230732373317, q), q);
2928         o.t3 = addmod(o.t3, mulmod(i.t6, 14172871439045259377975734198064051992755748777535789572469924335100006948373, q), q);
2929         o.t4 = mulmod(i.t0, 8303849270045876854140023508764676765932043944545416856530551331270859502246, q);
2930         o.t4 = addmod(o.t4, mulmod(i.t1, 20218246699596954048529384569730026273241102596326201163062133863539137060414, q), q);
2931         o.t4 = addmod(o.t4, mulmod(i.t2, 1712845821388089905746651754894206522004527237615042226559791118162382909269, q), q);
2932         o.t4 = addmod(o.t4, mulmod(i.t3, 13001155522144542028910638547179410124467185319212645031214919884423841839406, q), q);
2933         o.t4 = addmod(o.t4, mulmod(i.t4, 16037892369576300958623292723740289861626299352695838577330319504984091062115, q), q);
2934         o.t4 = addmod(o.t4, mulmod(i.t5, 19189494548480259335554606182055502469831573298885662881571444557262020106898, q), q);
2935         o.t4 = addmod(o.t4, mulmod(i.t6, 19032687447778391106390582750185144485341165205399984747451318330476859342654, q), q);
2936         o.t5 = mulmod(i.t0, 13272957914179340594010910867091459756043436017766464331915862093201960540910, q);
2937         o.t5 = addmod(o.t5, mulmod(i.t1, 9416416589114508529880440146952102328470363729880726115521103179442988482948, q), q);
2938         o.t5 = addmod(o.t5, mulmod(i.t2, 8035240799672199706102747147502951589635001418759394863664434079699838251138, q), q);
2939         o.t5 = addmod(o.t5, mulmod(i.t3, 21642389080762222565487157652540372010968704000567605990102641816691459811717, q), q);
2940         o.t5 = addmod(o.t5, mulmod(i.t4, 20261355950827657195644012399234591122288573679402601053407151083849785332516, q), q);
2941         o.t5 = addmod(o.t5, mulmod(i.t5, 14514189384576734449268559374569145463190040567900950075547616936149781403109, q), q);
2942         o.t5 = addmod(o.t5, mulmod(i.t6, 19038036134886073991945204537416211699632292792787812530208911676638479944765, q), q);
2943         o.t6 = mulmod(i.t0, 15627836782263662543041758927100784213807648787083018234961118439434298020664, q);
2944         o.t6 = addmod(o.t6, mulmod(i.t1, 5655785191024506056588710805596292231240948371113351452712848652644610823632, q), q);
2945         o.t6 = addmod(o.t6, mulmod(i.t2, 8265264721707292643644260517162050867559314081394556886644673791575065394002, q), q);
2946         o.t6 = addmod(o.t6, mulmod(i.t3, 17151144681903609082202835646026478898625761142991787335302962548605510241586, q), q);
2947         o.t6 = addmod(o.t6, mulmod(i.t4, 18731644709777529787185361516475509623264209648904603914668024590231177708831, q), q);
2948         o.t6 = addmod(o.t6, mulmod(i.t5, 20697789991623248954020701081488146717484139720322034504511115160686216223641, q), q);
2949         o.t6 = addmod(o.t6, mulmod(i.t6, 6200020095464686209289974437830528853749866001482481427982839122465470640886, q), q);
2950         i.t0 = o.t0;
2951         i.t1 = o.t1;
2952         i.t2 = o.t2;
2953         i.t3 = o.t3;
2954         i.t4 = o.t4;
2955         i.t5 = o.t5;
2956         i.t6 = o.t6;
2957     }
2958 
2959     function ark(HashInputs7 memory i, uint q, uint c) internal pure
2960     {
2961         HashInputs7 memory o;
2962         o.t0 = addmod(i.t0, c, q);
2963         o.t1 = addmod(i.t1, c, q);
2964         o.t2 = addmod(i.t2, c, q);
2965         o.t3 = addmod(i.t3, c, q);
2966         o.t4 = addmod(i.t4, c, q);
2967         o.t5 = addmod(i.t5, c, q);
2968         o.t6 = addmod(i.t6, c, q);
2969         i.t0 = o.t0;
2970         i.t1 = o.t1;
2971         i.t2 = o.t2;
2972         i.t3 = o.t3;
2973         i.t4 = o.t4;
2974         i.t5 = o.t5;
2975         i.t6 = o.t6;
2976     }
2977 
2978     function sbox_full(HashInputs7 memory i, uint q) internal pure
2979     {
2980         HashInputs7 memory o;
2981         o.t0 = mulmod(i.t0, i.t0, q);
2982         o.t0 = mulmod(o.t0, o.t0, q);
2983         o.t0 = mulmod(i.t0, o.t0, q);
2984         o.t1 = mulmod(i.t1, i.t1, q);
2985         o.t1 = mulmod(o.t1, o.t1, q);
2986         o.t1 = mulmod(i.t1, o.t1, q);
2987         o.t2 = mulmod(i.t2, i.t2, q);
2988         o.t2 = mulmod(o.t2, o.t2, q);
2989         o.t2 = mulmod(i.t2, o.t2, q);
2990         o.t3 = mulmod(i.t3, i.t3, q);
2991         o.t3 = mulmod(o.t3, o.t3, q);
2992         o.t3 = mulmod(i.t3, o.t3, q);
2993         o.t4 = mulmod(i.t4, i.t4, q);
2994         o.t4 = mulmod(o.t4, o.t4, q);
2995         o.t4 = mulmod(i.t4, o.t4, q);
2996         o.t5 = mulmod(i.t5, i.t5, q);
2997         o.t5 = mulmod(o.t5, o.t5, q);
2998         o.t5 = mulmod(i.t5, o.t5, q);
2999         o.t6 = mulmod(i.t6, i.t6, q);
3000         o.t6 = mulmod(o.t6, o.t6, q);
3001         o.t6 = mulmod(i.t6, o.t6, q);
3002         i.t0 = o.t0;
3003         i.t1 = o.t1;
3004         i.t2 = o.t2;
3005         i.t3 = o.t3;
3006         i.t4 = o.t4;
3007         i.t5 = o.t5;
3008         i.t6 = o.t6;
3009     }
3010 
3011     function sbox_partial(HashInputs7 memory i, uint q) internal pure
3012     {
3013         HashInputs7 memory o;
3014         o.t0 = mulmod(i.t0, i.t0, q);
3015         o.t0 = mulmod(o.t0, o.t0, q);
3016         o.t0 = mulmod(i.t0, o.t0, q);
3017         i.t0 = o.t0;
3018     }
3019 
3020     function hash_t7f6p52(HashInputs7 memory i, uint q) internal pure returns (uint)
3021     {
3022         // validate inputs
3023         require(i.t0 < q, "INVALID_INPUT");
3024         require(i.t1 < q, "INVALID_INPUT");
3025         require(i.t2 < q, "INVALID_INPUT");
3026         require(i.t3 < q, "INVALID_INPUT");
3027         require(i.t4 < q, "INVALID_INPUT");
3028         require(i.t5 < q, "INVALID_INPUT");
3029         require(i.t6 < q, "INVALID_INPUT");
3030 
3031         // round 0
3032         ark(i, q, 14397397413755236225575615486459253198602422701513067526754101844196324375522);
3033         sbox_full(i, q);
3034         mix(i, q);
3035         // round 1
3036         ark(i, q, 10405129301473404666785234951972711717481302463898292859783056520670200613128);
3037         sbox_full(i, q);
3038         mix(i, q);
3039         // round 2
3040         ark(i, q, 5179144822360023508491245509308555580251733042407187134628755730783052214509);
3041         sbox_full(i, q);
3042         mix(i, q);
3043         // round 3
3044         ark(i, q, 9132640374240188374542843306219594180154739721841249568925550236430986592615);
3045         sbox_partial(i, q);
3046         mix(i, q);
3047         // round 4
3048         ark(i, q, 20360807315276763881209958738450444293273549928693737723235350358403012458514);
3049         sbox_partial(i, q);
3050         mix(i, q);
3051         // round 5
3052         ark(i, q, 17933600965499023212689924809448543050840131883187652471064418452962948061619);
3053         sbox_partial(i, q);
3054         mix(i, q);
3055         // round 6
3056         ark(i, q, 3636213416533737411392076250708419981662897009810345015164671602334517041153);
3057         sbox_partial(i, q);
3058         mix(i, q);
3059         // round 7
3060         ark(i, q, 2008540005368330234524962342006691994500273283000229509835662097352946198608);
3061         sbox_partial(i, q);
3062         mix(i, q);
3063         // round 8
3064         ark(i, q, 16018407964853379535338740313053768402596521780991140819786560130595652651567);
3065         sbox_partial(i, q);
3066         mix(i, q);
3067         // round 9
3068         ark(i, q, 20653139667070586705378398435856186172195806027708437373983929336015162186471);
3069         sbox_partial(i, q);
3070         mix(i, q);
3071         // round 10
3072         ark(i, q, 17887713874711369695406927657694993484804203950786446055999405564652412116765);
3073         sbox_partial(i, q);
3074         mix(i, q);
3075         // round 11
3076         ark(i, q, 4852706232225925756777361208698488277369799648067343227630786518486608711772);
3077         sbox_partial(i, q);
3078         mix(i, q);
3079         // round 12
3080         ark(i, q, 8969172011633935669771678412400911310465619639756845342775631896478908389850);
3081         sbox_partial(i, q);
3082         mix(i, q);
3083         // round 13
3084         ark(i, q, 20570199545627577691240476121888846460936245025392381957866134167601058684375);
3085         sbox_partial(i, q);
3086         mix(i, q);
3087         // round 14
3088         ark(i, q, 16442329894745639881165035015179028112772410105963688121820543219662832524136);
3089         sbox_partial(i, q);
3090         mix(i, q);
3091         // round 15
3092         ark(i, q, 20060625627350485876280451423010593928172611031611836167979515653463693899374);
3093         sbox_partial(i, q);
3094         mix(i, q);
3095         // round 16
3096         ark(i, q, 16637282689940520290130302519163090147511023430395200895953984829546679599107);
3097         sbox_partial(i, q);
3098         mix(i, q);
3099         // round 17
3100         ark(i, q, 15599196921909732993082127725908821049411366914683565306060493533569088698214);
3101         sbox_partial(i, q);
3102         mix(i, q);
3103         // round 18
3104         ark(i, q, 16894591341213863947423904025624185991098788054337051624251730868231322135455);
3105         sbox_partial(i, q);
3106         mix(i, q);
3107         // round 19
3108         ark(i, q, 1197934381747032348421303489683932612752526046745577259575778515005162320212);
3109         sbox_partial(i, q);
3110         mix(i, q);
3111         // round 20
3112         ark(i, q, 6172482022646932735745595886795230725225293469762393889050804649558459236626);
3113         sbox_partial(i, q);
3114         mix(i, q);
3115         // round 21
3116         ark(i, q, 21004037394166516054140386756510609698837211370585899203851827276330669555417);
3117         sbox_partial(i, q);
3118         mix(i, q);
3119         // round 22
3120         ark(i, q, 15262034989144652068456967541137853724140836132717012646544737680069032573006);
3121         sbox_partial(i, q);
3122         mix(i, q);
3123         // round 23
3124         ark(i, q, 15017690682054366744270630371095785995296470601172793770224691982518041139766);
3125         sbox_partial(i, q);
3126         mix(i, q);
3127         // round 24
3128         ark(i, q, 15159744167842240513848638419303545693472533086570469712794583342699782519832);
3129         sbox_partial(i, q);
3130         mix(i, q);
3131         // round 25
3132         ark(i, q, 11178069035565459212220861899558526502477231302924961773582350246646450941231);
3133         sbox_partial(i, q);
3134         mix(i, q);
3135         // round 26
3136         ark(i, q, 21154888769130549957415912997229564077486639529994598560737238811887296922114);
3137         sbox_partial(i, q);
3138         mix(i, q);
3139         // round 27
3140         ark(i, q, 20162517328110570500010831422938033120419484532231241180224283481905744633719);
3141         sbox_partial(i, q);
3142         mix(i, q);
3143         // round 28
3144         ark(i, q, 2777362604871784250419758188173029886707024739806641263170345377816177052018);
3145         sbox_partial(i, q);
3146         mix(i, q);
3147         // round 29
3148         ark(i, q, 15732290486829619144634131656503993123618032247178179298922551820261215487562);
3149         sbox_partial(i, q);
3150         mix(i, q);
3151         // round 30
3152         ark(i, q, 6024433414579583476444635447152826813568595303270846875177844482142230009826);
3153         sbox_partial(i, q);
3154         mix(i, q);
3155         // round 31
3156         ark(i, q, 17677827682004946431939402157761289497221048154630238117709539216286149983245);
3157         sbox_partial(i, q);
3158         mix(i, q);
3159         // round 32
3160         ark(i, q, 10716307389353583413755237303156291454109852751296156900963208377067748518748);
3161         sbox_partial(i, q);
3162         mix(i, q);
3163         // round 33
3164         ark(i, q, 14925386988604173087143546225719076187055229908444910452781922028996524347508);
3165         sbox_partial(i, q);
3166         mix(i, q);
3167         // round 34
3168         ark(i, q, 8940878636401797005293482068100797531020505636124892198091491586778667442523);
3169         sbox_partial(i, q);
3170         mix(i, q);
3171         // round 35
3172         ark(i, q, 18911747154199663060505302806894425160044925686870165583944475880789706164410);
3173         sbox_partial(i, q);
3174         mix(i, q);
3175         // round 36
3176         ark(i, q, 8821532432394939099312235292271438180996556457308429936910969094255825456935);
3177         sbox_partial(i, q);
3178         mix(i, q);
3179         // round 37
3180         ark(i, q, 20632576502437623790366878538516326728436616723089049415538037018093616927643);
3181         sbox_partial(i, q);
3182         mix(i, q);
3183         // round 38
3184         ark(i, q, 71447649211767888770311304010816315780740050029903404046389165015534756512);
3185         sbox_partial(i, q);
3186         mix(i, q);
3187         // round 39
3188         ark(i, q, 2781996465394730190470582631099299305677291329609718650018200531245670229393);
3189         sbox_partial(i, q);
3190         mix(i, q);
3191         // round 40
3192         ark(i, q, 12441376330954323535872906380510501637773629931719508864016287320488688345525);
3193         sbox_partial(i, q);
3194         mix(i, q);
3195         // round 41
3196         ark(i, q, 2558302139544901035700544058046419714227464650146159803703499681139469546006);
3197         sbox_partial(i, q);
3198         mix(i, q);
3199         // round 42
3200         ark(i, q, 10087036781939179132584550273563255199577525914374285705149349445480649057058);
3201         sbox_partial(i, q);
3202         mix(i, q);
3203         // round 43
3204         ark(i, q, 4267692623754666261749551533667592242661271409704769363166965280715887854739);
3205         sbox_partial(i, q);
3206         mix(i, q);
3207         // round 44
3208         ark(i, q, 4945579503584457514844595640661884835097077318604083061152997449742124905548);
3209         sbox_partial(i, q);
3210         mix(i, q);
3211         // round 45
3212         ark(i, q, 17742335354489274412669987990603079185096280484072783973732137326144230832311);
3213         sbox_partial(i, q);
3214         mix(i, q);
3215         // round 46
3216         ark(i, q, 6266270088302506215402996795500854910256503071464802875821837403486057988208);
3217         sbox_partial(i, q);
3218         mix(i, q);
3219         // round 47
3220         ark(i, q, 2716062168542520412498610856550519519760063668165561277991771577403400784706);
3221         sbox_partial(i, q);
3222         mix(i, q);
3223         // round 48
3224         ark(i, q, 19118392018538203167410421493487769944462015419023083813301166096764262134232);
3225         sbox_partial(i, q);
3226         mix(i, q);
3227         // round 49
3228         ark(i, q, 9386595745626044000666050847309903206827901310677406022353307960932745699524);
3229         sbox_partial(i, q);
3230         mix(i, q);
3231         // round 50
3232         ark(i, q, 9121640807890366356465620448383131419933298563527245687958865317869840082266);
3233         sbox_partial(i, q);
3234         mix(i, q);
3235         // round 51
3236         ark(i, q, 3078975275808111706229899605611544294904276390490742680006005661017864583210);
3237         sbox_partial(i, q);
3238         mix(i, q);
3239         // round 52
3240         ark(i, q, 7157404299437167354719786626667769956233708887934477609633504801472827442743);
3241         sbox_partial(i, q);
3242         mix(i, q);
3243         // round 53
3244         ark(i, q, 14056248655941725362944552761799461694550787028230120190862133165195793034373);
3245         sbox_partial(i, q);
3246         mix(i, q);
3247         // round 54
3248         ark(i, q, 14124396743304355958915937804966111851843703158171757752158388556919187839849);
3249         sbox_partial(i, q);
3250         mix(i, q);
3251         // round 55
3252         ark(i, q, 11851254356749068692552943732920045260402277343008629727465773766468466181076);
3253         sbox_full(i, q);
3254         mix(i, q);
3255         // round 56
3256         ark(i, q, 9799099446406796696742256539758943483211846559715874347178722060519817626047);
3257         sbox_full(i, q);
3258         mix(i, q);
3259         // round 57
3260         ark(i, q, 10156146186214948683880719664738535455146137901666656566575307300522957959544);
3261         sbox_full(i, q);
3262         mix(i, q);
3263 
3264         return i.t0;
3265     }
3266 }
3267 
3268 
3269 // File: contracts/core/impl/libexchange/ExchangeBalances.sol
3270 
3271 // Copyright 2017 Loopring Technology Limited.
3272 
3273 
3274 
3275 
3276 
3277 /// @title ExchangeBalances.
3278 /// @author Daniel Wang  - <daniel@loopring.org>
3279 /// @author Brecht Devos - <brecht@loopring.org>
3280 library ExchangeBalances
3281 {
3282     using MathUint  for uint;
3283 
3284     function verifyAccountBalance(
3285         uint                              merkleRoot,
3286         ExchangeData.MerkleProof calldata merkleProof
3287         )
3288         public
3289         pure
3290     {
3291         require(
3292             isAccountBalanceCorrect(merkleRoot, merkleProof),
3293             "INVALID_MERKLE_TREE_DATA"
3294         );
3295     }
3296 
3297     function isAccountBalanceCorrect(
3298         uint                            merkleRoot,
3299         ExchangeData.MerkleProof memory merkleProof
3300         )
3301         public
3302         pure
3303         returns (bool)
3304     {
3305         // Calculate the Merkle root using the Merkle paths provided
3306         uint calculatedRoot = getBalancesRoot(
3307             merkleProof.balanceLeaf.tokenID,
3308             merkleProof.balanceLeaf.balance,
3309             merkleProof.balanceLeaf.weightAMM,
3310             merkleProof.balanceLeaf.storageRoot,
3311             merkleProof.balanceMerkleProof
3312         );
3313         calculatedRoot = getAccountInternalsRoot(
3314             merkleProof.accountLeaf.accountID,
3315             merkleProof.accountLeaf.owner,
3316             merkleProof.accountLeaf.pubKeyX,
3317             merkleProof.accountLeaf.pubKeyY,
3318             merkleProof.accountLeaf.nonce,
3319             merkleProof.accountLeaf.feeBipsAMM,
3320             calculatedRoot,
3321             merkleProof.accountMerkleProof
3322         );
3323         // Check against the expected Merkle root
3324         return (calculatedRoot == merkleRoot);
3325     }
3326 
3327     function getBalancesRoot(
3328         uint16   tokenID,
3329         uint     balance,
3330         uint     weightAMM,
3331         uint     storageRoot,
3332         uint[24] memory balanceMerkleProof
3333         )
3334         private
3335         pure
3336         returns (uint)
3337     {
3338         // Hash the balance leaf
3339         uint balanceItem = hashImpl(balance, weightAMM, storageRoot, 0);
3340         // Calculate the Merkle root of the balance quad Merkle tree
3341         uint _id = tokenID;
3342         for (uint depth = 0; depth < 8; depth++) {
3343             uint base = depth * 3;
3344             if (_id & 3 == 0) {
3345                 balanceItem = hashImpl(
3346                     balanceItem,
3347                     balanceMerkleProof[base],
3348                     balanceMerkleProof[base + 1],
3349                     balanceMerkleProof[base + 2]
3350                 );
3351             } else if (_id & 3 == 1) {
3352                 balanceItem = hashImpl(
3353                     balanceMerkleProof[base],
3354                     balanceItem,
3355                     balanceMerkleProof[base + 1],
3356                     balanceMerkleProof[base + 2]
3357                 );
3358             } else if (_id & 3 == 2) {
3359                 balanceItem = hashImpl(
3360                     balanceMerkleProof[base],
3361                     balanceMerkleProof[base + 1],
3362                     balanceItem,
3363                     balanceMerkleProof[base + 2]
3364                 );
3365             } else if (_id & 3 == 3) {
3366                 balanceItem = hashImpl(
3367                     balanceMerkleProof[base],
3368                     balanceMerkleProof[base + 1],
3369                     balanceMerkleProof[base + 2],
3370                     balanceItem
3371                 );
3372             }
3373             _id = _id >> 2;
3374         }
3375         return balanceItem;
3376     }
3377 
3378     function getAccountInternalsRoot(
3379         uint32   accountID,
3380         address  owner,
3381         uint     pubKeyX,
3382         uint     pubKeyY,
3383         uint     nonce,
3384         uint     feeBipsAMM,
3385         uint     balancesRoot,
3386         uint[48] memory accountMerkleProof
3387         )
3388         private
3389         pure
3390         returns (uint)
3391     {
3392         // Hash the account leaf
3393         uint accountItem = hashAccountLeaf(uint(owner), pubKeyX, pubKeyY, nonce, feeBipsAMM, balancesRoot);
3394         // Calculate the Merkle root of the account quad Merkle tree
3395         uint _id = accountID;
3396         for (uint depth = 0; depth < 16; depth++) {
3397             uint base = depth * 3;
3398             if (_id & 3 == 0) {
3399                 accountItem = hashImpl(
3400                     accountItem,
3401                     accountMerkleProof[base],
3402                     accountMerkleProof[base + 1],
3403                     accountMerkleProof[base + 2]
3404                 );
3405             } else if (_id & 3 == 1) {
3406                 accountItem = hashImpl(
3407                     accountMerkleProof[base],
3408                     accountItem,
3409                     accountMerkleProof[base + 1],
3410                     accountMerkleProof[base + 2]
3411                 );
3412             } else if (_id & 3 == 2) {
3413                 accountItem = hashImpl(
3414                     accountMerkleProof[base],
3415                     accountMerkleProof[base + 1],
3416                     accountItem,
3417                     accountMerkleProof[base + 2]
3418                 );
3419             } else if (_id & 3 == 3) {
3420                 accountItem = hashImpl(
3421                     accountMerkleProof[base],
3422                     accountMerkleProof[base + 1],
3423                     accountMerkleProof[base + 2],
3424                     accountItem
3425                 );
3426             }
3427             _id = _id >> 2;
3428         }
3429         return accountItem;
3430     }
3431 
3432     function hashAccountLeaf(
3433         uint t0,
3434         uint t1,
3435         uint t2,
3436         uint t3,
3437         uint t4,
3438         uint t5
3439         )
3440         public
3441         pure
3442         returns (uint)
3443     {
3444         Poseidon.HashInputs7 memory inputs = Poseidon.HashInputs7(t0, t1, t2, t3, t4, t5, 0);
3445         return Poseidon.hash_t7f6p52(inputs, ExchangeData.SNARK_SCALAR_FIELD);
3446     }
3447 
3448     function hashImpl(
3449         uint t0,
3450         uint t1,
3451         uint t2,
3452         uint t3
3453         )
3454         private
3455         pure
3456         returns (uint)
3457     {
3458         Poseidon.HashInputs5 memory inputs = Poseidon.HashInputs5(t0, t1, t2, t3, 0);
3459         return Poseidon.hash_t5f6p52(inputs, ExchangeData.SNARK_SCALAR_FIELD);
3460     }
3461 }
3462 
3463 // File: contracts/lib/ERC20SafeTransfer.sol
3464 
3465 // Copyright 2017 Loopring Technology Limited.
3466 
3467 
3468 /// @title ERC20 safe transfer
3469 /// @dev see https://github.com/sec-bit/badERC20Fix
3470 /// @author Brecht Devos - <brecht@loopring.org>
3471 library ERC20SafeTransfer
3472 {
3473     function safeTransferAndVerify(
3474         address token,
3475         address to,
3476         uint    value
3477         )
3478         internal
3479     {
3480         safeTransferWithGasLimitAndVerify(
3481             token,
3482             to,
3483             value,
3484             gasleft()
3485         );
3486     }
3487 
3488     function safeTransfer(
3489         address token,
3490         address to,
3491         uint    value
3492         )
3493         internal
3494         returns (bool)
3495     {
3496         return safeTransferWithGasLimit(
3497             token,
3498             to,
3499             value,
3500             gasleft()
3501         );
3502     }
3503 
3504     function safeTransferWithGasLimitAndVerify(
3505         address token,
3506         address to,
3507         uint    value,
3508         uint    gasLimit
3509         )
3510         internal
3511     {
3512         require(
3513             safeTransferWithGasLimit(token, to, value, gasLimit),
3514             "TRANSFER_FAILURE"
3515         );
3516     }
3517 
3518     function safeTransferWithGasLimit(
3519         address token,
3520         address to,
3521         uint    value,
3522         uint    gasLimit
3523         )
3524         internal
3525         returns (bool)
3526     {
3527         // A transfer is successful when 'call' is successful and depending on the token:
3528         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
3529         // - A single boolean is returned: this boolean needs to be true (non-zero)
3530 
3531         // bytes4(keccak256("transfer(address,uint256)")) = 0xa9059cbb
3532         bytes memory callData = abi.encodeWithSelector(
3533             bytes4(0xa9059cbb),
3534             to,
3535             value
3536         );
3537         (bool success, ) = token.call{gas: gasLimit}(callData);
3538         return checkReturnValue(success);
3539     }
3540 
3541     function safeTransferFromAndVerify(
3542         address token,
3543         address from,
3544         address to,
3545         uint    value
3546         )
3547         internal
3548     {
3549         safeTransferFromWithGasLimitAndVerify(
3550             token,
3551             from,
3552             to,
3553             value,
3554             gasleft()
3555         );
3556     }
3557 
3558     function safeTransferFrom(
3559         address token,
3560         address from,
3561         address to,
3562         uint    value
3563         )
3564         internal
3565         returns (bool)
3566     {
3567         return safeTransferFromWithGasLimit(
3568             token,
3569             from,
3570             to,
3571             value,
3572             gasleft()
3573         );
3574     }
3575 
3576     function safeTransferFromWithGasLimitAndVerify(
3577         address token,
3578         address from,
3579         address to,
3580         uint    value,
3581         uint    gasLimit
3582         )
3583         internal
3584     {
3585         bool result = safeTransferFromWithGasLimit(
3586             token,
3587             from,
3588             to,
3589             value,
3590             gasLimit
3591         );
3592         require(result, "TRANSFER_FAILURE");
3593     }
3594 
3595     function safeTransferFromWithGasLimit(
3596         address token,
3597         address from,
3598         address to,
3599         uint    value,
3600         uint    gasLimit
3601         )
3602         internal
3603         returns (bool)
3604     {
3605         // A transferFrom is successful when 'call' is successful and depending on the token:
3606         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
3607         // - A single boolean is returned: this boolean needs to be true (non-zero)
3608 
3609         // bytes4(keccak256("transferFrom(address,address,uint256)")) = 0x23b872dd
3610         bytes memory callData = abi.encodeWithSelector(
3611             bytes4(0x23b872dd),
3612             from,
3613             to,
3614             value
3615         );
3616         (bool success, ) = token.call{gas: gasLimit}(callData);
3617         return checkReturnValue(success);
3618     }
3619 
3620     function checkReturnValue(
3621         bool success
3622         )
3623         internal
3624         pure
3625         returns (bool)
3626     {
3627         // A transfer/transferFrom is successful when 'call' is successful and depending on the token:
3628         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
3629         // - A single boolean is returned: this boolean needs to be true (non-zero)
3630         if (success) {
3631             assembly {
3632                 switch returndatasize()
3633                 // Non-standard ERC20: nothing is returned so if 'call' was successful we assume the transfer succeeded
3634                 case 0 {
3635                     success := 1
3636                 }
3637                 // Standard ERC20: a single boolean value is returned which needs to be true
3638                 case 32 {
3639                     returndatacopy(0, 0, 32)
3640                     success := mload(0)
3641                 }
3642                 // None of the above: not successful
3643                 default {
3644                     success := 0
3645                 }
3646             }
3647         }
3648         return success;
3649     }
3650 }
3651 
3652 // File: contracts/core/impl/libexchange/ExchangeTokens.sol
3653 
3654 // Copyright 2017 Loopring Technology Limited.
3655 
3656 
3657 
3658 
3659 
3660 
3661 /// @title ExchangeTokens.
3662 /// @author Daniel Wang  - <daniel@loopring.org>
3663 /// @author Brecht Devos - <brecht@loopring.org>
3664 library ExchangeTokens
3665 {
3666     using MathUint          for uint;
3667     using ERC20SafeTransfer for address;
3668     using ExchangeMode      for ExchangeData.State;
3669 
3670     event TokenRegistered(
3671         address token,
3672         uint16  tokenId
3673     );
3674 
3675     function getTokenAddress(
3676         ExchangeData.State storage S,
3677         uint16 tokenID
3678         )
3679         public
3680         view
3681         returns (address)
3682     {
3683         require(tokenID < S.tokens.length, "INVALID_TOKEN_ID");
3684         return S.tokens[tokenID].token;
3685     }
3686 
3687     function registerToken(
3688         ExchangeData.State storage S,
3689         address tokenAddress
3690         )
3691         public
3692         returns (uint16 tokenID)
3693     {
3694         require(!S.isInWithdrawalMode(), "INVALID_MODE");
3695         require(S.tokenToTokenId[tokenAddress] == 0, "TOKEN_ALREADY_EXIST");
3696         require(S.tokens.length < ExchangeData.MAX_NUM_TOKENS, "TOKEN_REGISTRY_FULL");
3697 
3698         // Check if the deposit contract supports the new token
3699         if (S.depositContract != IDepositContract(0)) {
3700             require(
3701                 S.depositContract.isTokenSupported(tokenAddress),
3702                 "UNSUPPORTED_TOKEN"
3703             );
3704         }
3705 
3706         // Assign a tokenID and store the token
3707         ExchangeData.Token memory token = ExchangeData.Token(
3708             tokenAddress
3709         );
3710         tokenID = uint16(S.tokens.length);
3711         S.tokens.push(token);
3712         S.tokenToTokenId[tokenAddress] = tokenID + 1;
3713 
3714         emit TokenRegistered(tokenAddress, tokenID);
3715     }
3716 
3717     function getTokenID(
3718         ExchangeData.State storage S,
3719         address tokenAddress
3720         )
3721         internal  // inline call
3722         view
3723         returns (uint16 tokenID)
3724     {
3725         tokenID = S.tokenToTokenId[tokenAddress];
3726         require(tokenID != 0, "TOKEN_NOT_FOUND");
3727         tokenID = tokenID - 1;
3728     }
3729 }
3730 
3731 // File: contracts/core/impl/libexchange/ExchangeWithdrawals.sol
3732 
3733 // Copyright 2017 Loopring Technology Limited.
3734 
3735 
3736 
3737 
3738 
3739 
3740 
3741 
3742 /// @title ExchangeWithdrawals.
3743 /// @author Brecht Devos - <brecht@loopring.org>
3744 /// @author Daniel Wang  - <daniel@loopring.org>
3745 library ExchangeWithdrawals
3746 {
3747     enum WithdrawalCategory
3748     {
3749         DISTRIBUTION,
3750         FROM_MERKLE_TREE,
3751         FROM_DEPOSIT_REQUEST,
3752         FROM_APPROVED_WITHDRAWAL
3753     }
3754 
3755     using AddressUtil       for address;
3756     using AddressUtil       for address payable;
3757     using BytesUtil         for bytes;
3758     using MathUint          for uint;
3759     using ExchangeBalances  for ExchangeData.State;
3760     using ExchangeMode      for ExchangeData.State;
3761     using ExchangeTokens    for ExchangeData.State;
3762 
3763     event ForcedWithdrawalRequested(
3764         address owner,
3765         address token,
3766         uint32  accountID
3767     );
3768 
3769     event WithdrawalCompleted(
3770         uint8   category,
3771         address from,
3772         address to,
3773         address token,
3774         uint    amount
3775     );
3776 
3777     event WithdrawalFailed(
3778         uint8   category,
3779         address from,
3780         address to,
3781         address token,
3782         uint    amount
3783     );
3784 
3785     function forceWithdraw(
3786         ExchangeData.State storage S,
3787         address owner,
3788         address token,
3789         uint32  accountID
3790         )
3791         public
3792     {
3793         require(!S.isInWithdrawalMode(), "INVALID_MODE");
3794         // Limit the amount of pending forced withdrawals so that the owner cannot be overwhelmed.
3795         require(S.getNumAvailableForcedSlots() > 0, "TOO_MANY_REQUESTS_OPEN");
3796         require(accountID < ExchangeData.MAX_NUM_ACCOUNTS, "INVALID_ACCOUNTID");
3797 
3798         uint16 tokenID = S.getTokenID(token);
3799 
3800         // A user needs to pay a fixed ETH withdrawal fee, set by the protocol.
3801         uint withdrawalFeeETH = S.loopring.forcedWithdrawalFee();
3802 
3803         // Check ETH value sent, can be larger than the expected withdraw fee
3804         require(msg.value >= withdrawalFeeETH, "INSUFFICIENT_FEE");
3805 
3806         // Send surplus of ETH back to the sender
3807         uint feeSurplus = msg.value.sub(withdrawalFeeETH);
3808         if (feeSurplus > 0) {
3809             msg.sender.sendETHAndVerify(feeSurplus, gasleft());
3810         }
3811 
3812         // There can only be a single forced withdrawal per (account, token) pair.
3813         require(
3814             S.pendingForcedWithdrawals[accountID][tokenID].timestamp == 0,
3815             "WITHDRAWAL_ALREADY_PENDING"
3816         );
3817 
3818         // Store the forced withdrawal request data
3819         S.pendingForcedWithdrawals[accountID][tokenID] = ExchangeData.ForcedWithdrawal({
3820             owner: owner,
3821             timestamp: uint64(block.timestamp)
3822         });
3823 
3824         // Increment the number of pending forced transactions so we can keep count.
3825         S.numPendingForcedTransactions++;
3826 
3827         emit ForcedWithdrawalRequested(
3828             owner,
3829             token,
3830             accountID
3831         );
3832     }
3833 
3834     // We alow anyone to withdraw these funds for the account owner
3835     function withdrawFromMerkleTree(
3836         ExchangeData.State       storage S,
3837         ExchangeData.MerkleProof calldata merkleProof
3838         )
3839         public
3840     {
3841         require(S.isInWithdrawalMode(), "NOT_IN_WITHDRAW_MODE");
3842 
3843         address owner = merkleProof.accountLeaf.owner;
3844         uint32 accountID = merkleProof.accountLeaf.accountID;
3845         uint16 tokenID = merkleProof.balanceLeaf.tokenID;
3846         uint96 balance = merkleProof.balanceLeaf.balance;
3847 
3848         // Make sure the funds aren't withdrawn already.
3849         require(S.withdrawnInWithdrawMode[accountID][tokenID] == false, "WITHDRAWN_ALREADY");
3850 
3851         // Verify that the provided Merkle tree data is valid by using the Merkle proof.
3852         ExchangeBalances.verifyAccountBalance(
3853             uint(S.merkleRoot),
3854             merkleProof
3855         );
3856 
3857         // Make sure the balance can only be withdrawn once
3858         S.withdrawnInWithdrawMode[accountID][tokenID] = true;
3859 
3860         // Transfer the tokens to the account owner
3861         transferTokens(
3862             S,
3863             uint8(WithdrawalCategory.FROM_MERKLE_TREE),
3864             owner,
3865             owner,
3866             tokenID,
3867             balance,
3868             new bytes(0),
3869             gasleft(),
3870             false
3871         );
3872     }
3873 
3874     function withdrawFromDepositRequest(
3875         ExchangeData.State storage S,
3876         address owner,
3877         address token
3878         )
3879         public
3880     {
3881         uint16 tokenID = S.getTokenID(token);
3882         ExchangeData.Deposit storage deposit = S.pendingDeposits[owner][tokenID];
3883         require(deposit.timestamp != 0, "DEPOSIT_NOT_WITHDRAWABLE_YET");
3884 
3885         // Check if the deposit has indeed exceeded the time limit of if the exchange is in withdrawal mode
3886         require(
3887             block.timestamp >= deposit.timestamp + S.maxAgeDepositUntilWithdrawable ||
3888             S.isInWithdrawalMode(),
3889             "DEPOSIT_NOT_WITHDRAWABLE_YET"
3890         );
3891 
3892         uint amount = deposit.amount;
3893 
3894         // Reset the deposit request
3895         delete S.pendingDeposits[owner][tokenID];
3896 
3897         // Transfer the tokens
3898         transferTokens(
3899             S,
3900             uint8(WithdrawalCategory.FROM_DEPOSIT_REQUEST),
3901             owner,
3902             owner,
3903             tokenID,
3904             amount,
3905             new bytes(0),
3906             gasleft(),
3907             false
3908         );
3909     }
3910 
3911     function withdrawFromApprovedWithdrawals(
3912         ExchangeData.State storage S,
3913         address[] memory owners,
3914         address[] memory tokens
3915         )
3916         public
3917     {
3918         require(owners.length == tokens.length, "INVALID_INPUT_DATA");
3919         for (uint i = 0; i < owners.length; i++) {
3920             address owner = owners[i];
3921             uint16 tokenID = S.getTokenID(tokens[i]);
3922             uint amount = S.amountWithdrawable[owner][tokenID];
3923 
3924             // Make sure this amount can't be withdrawn again
3925             delete S.amountWithdrawable[owner][tokenID];
3926 
3927             // Transfer the tokens to the owner
3928             transferTokens(
3929                 S,
3930                 uint8(WithdrawalCategory.FROM_APPROVED_WITHDRAWAL),
3931                 owner,
3932                 owner,
3933                 tokenID,
3934                 amount,
3935                 new bytes(0),
3936                 gasleft(),
3937                 false
3938             );
3939         }
3940     }
3941 
3942     function distributeWithdrawal(
3943         ExchangeData.State storage S,
3944         address from,
3945         address to,
3946         uint16  tokenID,
3947         uint    amount,
3948         bytes   memory extraData,
3949         uint    gasLimit
3950         )
3951         public
3952     {
3953         // Try to transfer the tokens
3954         bool success = transferTokens(
3955             S,
3956             uint8(WithdrawalCategory.DISTRIBUTION),
3957             from,
3958             to,
3959             tokenID,
3960             amount,
3961             extraData,
3962             gasLimit,
3963             true
3964         );
3965         // If the transfer was successful there's nothing left to do.
3966         // However, if the transfer failed the tokens are still in the contract and can be
3967         // withdrawn later to `to` by anyone by using `withdrawFromApprovedWithdrawal.
3968         if (!success) {
3969             S.amountWithdrawable[to][tokenID] = S.amountWithdrawable[to][tokenID].add(amount);
3970         }
3971     }
3972 
3973     // == Internal and Private Functions ==
3974 
3975     // If allowFailure is true the transfer can fail because of a transfer error or
3976     // because the transfer uses more than `gasLimit` gas. The function
3977     // will return true when successful, false otherwise.
3978     // If allowFailure is false the transfer is guaranteed to succeed using
3979     // as much gas as needed, otherwise it throws. The function always returns true.
3980     function transferTokens(
3981         ExchangeData.State storage S,
3982         uint8   category,
3983         address from,
3984         address to,
3985         uint16  tokenID,
3986         uint    amount,
3987         bytes   memory extraData,
3988         uint    gasLimit,
3989         bool    allowFailure
3990         )
3991         private
3992         returns (bool success)
3993     {
3994         // Redirect withdrawals to address(0) to the protocol fee vault
3995         if (to == address(0)) {
3996             to = S.loopring.protocolFeeVault();
3997         }
3998         address token = S.getTokenAddress(tokenID);
3999 
4000         // Transfer the tokens from the deposit contract to the owner
4001         if (gasLimit > 0) {
4002             try S.depositContract.withdraw{gas: gasLimit}(from, to, token, amount, extraData) {
4003                 success = true;
4004             } catch {
4005                 success = false;
4006             }
4007         } else {
4008             success = false;
4009         }
4010 
4011         require(allowFailure || success, "TRANSFER_FAILURE");
4012 
4013         if (success) {
4014             emit WithdrawalCompleted(category, from, to, token, amount);
4015 
4016             // Keep track of when the protocol fees were last withdrawn
4017             // (only done to make this data easier available).
4018             if (from == address(0)) {
4019                 S.protocolFeeLastWithdrawnTime[token] = block.timestamp;
4020             }
4021         } else {
4022             emit WithdrawalFailed(category, from, to, token, amount);
4023         }
4024     }
4025 }
4026 
4027 // File: contracts/core/impl/libtransactions/WithdrawTransaction.sol
4028 
4029 // Copyright 2017 Loopring Technology Limited.
4030 
4031 
4032 
4033 
4034 
4035 
4036 
4037 
4038 
4039 
4040 
4041 /// @title WithdrawTransaction
4042 /// @author Brecht Devos - <brecht@loopring.org>
4043 /// @dev The following 4 types of withdrawals are supported:
4044 ///      - withdrawType = 0: offchain withdrawals with EdDSA signatures
4045 ///      - withdrawType = 1: offchain withdrawals with ECDSA signatures or onchain appprovals
4046 ///      - withdrawType = 2: onchain valid forced withdrawals (owner and accountID match), or
4047 ///                          offchain operator-initiated withdrawals for protocol fees or for
4048 ///                          users in shutdown mode
4049 ///      - withdrawType = 3: onchain invalid forced withdrawals (owner and accountID mismatch)
4050 library WithdrawTransaction
4051 {
4052     using BytesUtil            for bytes;
4053     using FloatUtil            for uint16;
4054     using MathUint             for uint;
4055     using ExchangeMode         for ExchangeData.State;
4056     using ExchangeSignatures   for ExchangeData.State;
4057     using ExchangeWithdrawals  for ExchangeData.State;
4058 
4059     bytes32 constant public WITHDRAWAL_TYPEHASH = keccak256(
4060         "Withdrawal(address owner,uint32 accountID,uint16 tokenID,uint96 amount,uint16 feeTokenID,uint96 maxFee,address to,bytes extraData,uint256 minGas,uint32 validUntil,uint32 storageID)"
4061     );
4062 
4063     struct Withdrawal
4064     {
4065         uint    withdrawalType;
4066         address from;
4067         uint32  fromAccountID;
4068         uint16  tokenID;
4069         uint96  amount;
4070         uint16  feeTokenID;
4071         uint96  maxFee;
4072         uint96  fee;
4073         address to;
4074         bytes   extraData;
4075         uint    minGas;
4076         uint32  validUntil;
4077         uint32  storageID;
4078         bytes20 onchainDataHash;
4079     }
4080 
4081     // Auxiliary data for each withdrawal
4082     struct WithdrawalAuxiliaryData
4083     {
4084         bool  storeRecipient;
4085         uint  gasLimit;
4086         bytes signature;
4087 
4088         uint    minGas;
4089         address to;
4090         bytes   extraData;
4091         uint96  maxFee;
4092         uint32  validUntil;
4093     }
4094 
4095     function process(
4096         ExchangeData.State        storage S,
4097         ExchangeData.BlockContext memory  ctx,
4098         bytes                     memory  data,
4099         uint                              offset,
4100         bytes                     memory  auxiliaryData
4101         )
4102         internal
4103     {
4104         Withdrawal memory withdrawal;
4105         readTx(data, offset, withdrawal);
4106         WithdrawalAuxiliaryData memory auxData = abi.decode(auxiliaryData, (WithdrawalAuxiliaryData));
4107 
4108         // Validate the withdrawal data not directly part of the DA
4109         bytes20 onchainDataHash = hashOnchainData(
4110             auxData.minGas,
4111             auxData.to,
4112             auxData.extraData
4113         );
4114         // Only the 20 MSB are used, which is still 80-bit of security, which is more
4115         // than enough, especially when combined with validUntil.
4116         require(withdrawal.onchainDataHash == onchainDataHash, "INVALID_WITHDRAWAL_DATA");
4117 
4118         // Fill in withdrawal data missing from DA
4119         withdrawal.to = auxData.to;
4120         withdrawal.minGas = auxData.minGas;
4121         withdrawal.extraData = auxData.extraData;
4122         withdrawal.maxFee = auxData.maxFee == 0 ? withdrawal.fee : auxData.maxFee;
4123         withdrawal.validUntil = auxData.validUntil;
4124 
4125         // If the account has an owner, don't allow withdrawing to the zero address
4126         // (which will be the protocol fee vault contract).
4127         require(withdrawal.from == address(0) || withdrawal.to != address(0), "INVALID_WITHDRAWAL_RECIPIENT");
4128 
4129         if (withdrawal.withdrawalType == 0) {
4130             // Signature checked offchain, nothing to do
4131         } else if (withdrawal.withdrawalType == 1) {
4132             // Validate
4133             require(ctx.timestamp < withdrawal.validUntil, "WITHDRAWAL_EXPIRED");
4134             require(withdrawal.fee <= withdrawal.maxFee, "WITHDRAWAL_FEE_TOO_HIGH");
4135 
4136             // Check appproval onchain
4137             // Calculate the tx hash
4138             bytes32 txHash = hashTx(ctx.DOMAIN_SEPARATOR, withdrawal);
4139             // Check onchain authorization
4140             S.requireAuthorizedTx(withdrawal.from, auxData.signature, txHash);
4141         } else if (withdrawal.withdrawalType == 2 || withdrawal.withdrawalType == 3) {
4142             // Forced withdrawals cannot make use of certain features because the
4143             // necessary data is not authorized by the account owner.
4144             // For protocol fee withdrawals, `owner` and `to` are both address(0).
4145             require(withdrawal.from == withdrawal.to, "INVALID_WITHDRAWAL_ADDRESS");
4146 
4147             // Forced withdrawal fees are charged when the request is submitted.
4148             require(withdrawal.fee == 0, "FEE_NOT_ZERO");
4149 
4150             require(withdrawal.extraData.length == 0, "AUXILIARY_DATA_NOT_ALLOWED");
4151 
4152             ExchangeData.ForcedWithdrawal memory forcedWithdrawal =
4153                 S.pendingForcedWithdrawals[withdrawal.fromAccountID][withdrawal.tokenID];
4154 
4155             if (forcedWithdrawal.timestamp != 0) {
4156                 if (withdrawal.withdrawalType == 2) {
4157                     require(withdrawal.from == forcedWithdrawal.owner, "INCONSISENT_OWNER");
4158                 } else { //withdrawal.withdrawalType == 3
4159                     require(withdrawal.from != forcedWithdrawal.owner, "INCONSISENT_OWNER");
4160                     require(withdrawal.amount == 0, "UNAUTHORIZED_WITHDRAWAL");
4161                 }
4162 
4163                 // delete the withdrawal request and free a slot
4164                 delete S.pendingForcedWithdrawals[withdrawal.fromAccountID][withdrawal.tokenID];
4165                 S.numPendingForcedTransactions--;
4166             } else {
4167                 // Allow the owner to submit full withdrawals without authorization
4168                 // - when in shutdown mode
4169                 // - to withdraw protocol fees
4170                 require(
4171                     withdrawal.fromAccountID == ExchangeData.ACCOUNTID_PROTOCOLFEE ||
4172                     S.isShutdown(),
4173                     "FULL_WITHDRAWAL_UNAUTHORIZED"
4174                 );
4175             }
4176         } else {
4177             revert("INVALID_WITHDRAWAL_TYPE");
4178         }
4179 
4180         // Check if there is a withdrawal recipient
4181         address recipient = S.withdrawalRecipient[withdrawal.from][withdrawal.to][withdrawal.tokenID][withdrawal.amount][withdrawal.storageID];
4182         if (recipient != address(0)) {
4183             // Auxiliary data is not supported
4184             require (withdrawal.extraData.length == 0, "AUXILIARY_DATA_NOT_ALLOWED");
4185 
4186             // Set the new recipient address
4187             withdrawal.to = recipient;
4188             // Allow any amount of gas to be used on this withdrawal (which allows the transfer to be skipped)
4189             withdrawal.minGas = 0;
4190 
4191             // Do NOT delete the recipient to prevent replay attack
4192             // delete S.withdrawalRecipient[withdrawal.owner][withdrawal.to][withdrawal.tokenID][withdrawal.amount][withdrawal.storageID];
4193         } else if (auxData.storeRecipient) {
4194             // Store the destination address to mark the withdrawal as done
4195             require(withdrawal.to != address(0), "INVALID_DESTINATION_ADDRESS");
4196             S.withdrawalRecipient[withdrawal.from][withdrawal.to][withdrawal.tokenID][withdrawal.amount][withdrawal.storageID] = withdrawal.to;
4197         }
4198 
4199         // Validate gas provided
4200         require(auxData.gasLimit >= withdrawal.minGas, "OUT_OF_GAS_FOR_WITHDRAWAL");
4201 
4202         // Try to transfer the tokens with the provided gas limit
4203         S.distributeWithdrawal(
4204             withdrawal.from,
4205             withdrawal.to,
4206             withdrawal.tokenID,
4207             withdrawal.amount,
4208             withdrawal.extraData,
4209             auxData.gasLimit
4210         );
4211     }
4212 
4213     function readTx(
4214         bytes      memory data,
4215         uint              offset,
4216         Withdrawal memory withdrawal
4217         )
4218         internal
4219         pure
4220     {
4221         uint _offset = offset;
4222 
4223         require(data.toUint8Unsafe(_offset) == uint8(ExchangeData.TransactionType.WITHDRAWAL), "INVALID_TX_TYPE");
4224         _offset += 1;
4225 
4226         // Extract the transfer data
4227         // We don't use abi.decode for this because of the large amount of zero-padding
4228         // bytes the circuit would also have to hash.
4229         withdrawal.withdrawalType = data.toUint8Unsafe(_offset);
4230         _offset += 1;
4231         withdrawal.from = data.toAddressUnsafe(_offset);
4232         _offset += 20;
4233         withdrawal.fromAccountID = data.toUint32Unsafe(_offset);
4234         _offset += 4;
4235         withdrawal.tokenID = data.toUint16Unsafe(_offset);
4236         _offset += 2;
4237         withdrawal.amount = data.toUint96Unsafe(_offset);
4238         _offset += 12;
4239         withdrawal.feeTokenID = data.toUint16Unsafe(_offset);
4240         _offset += 2;
4241         withdrawal.fee = data.toUint16Unsafe(_offset).decodeFloat16();
4242         _offset += 2;
4243         withdrawal.storageID = data.toUint32Unsafe(_offset);
4244         _offset += 4;
4245         withdrawal.onchainDataHash = data.toBytes20Unsafe(_offset);
4246         _offset += 20;
4247     }
4248 
4249     function hashTx(
4250         bytes32 DOMAIN_SEPARATOR,
4251         Withdrawal memory withdrawal
4252         )
4253         internal
4254         pure
4255         returns (bytes32)
4256     {
4257         return EIP712.hashPacked(
4258             DOMAIN_SEPARATOR,
4259             keccak256(
4260                 abi.encode(
4261                     WITHDRAWAL_TYPEHASH,
4262                     withdrawal.from,
4263                     withdrawal.fromAccountID,
4264                     withdrawal.tokenID,
4265                     withdrawal.amount,
4266                     withdrawal.feeTokenID,
4267                     withdrawal.maxFee,
4268                     withdrawal.to,
4269                     keccak256(withdrawal.extraData),
4270                     withdrawal.minGas,
4271                     withdrawal.validUntil,
4272                     withdrawal.storageID
4273                 )
4274             )
4275         );
4276     }
4277 
4278     function hashOnchainData(
4279         uint    minGas,
4280         address to,
4281         bytes   memory extraData
4282         )
4283         internal
4284         pure
4285         returns (bytes20)
4286     {
4287         // Only the 20 MSB are used, which is still 80-bit of security, which is more
4288         // than enough, especially when combined with validUntil.
4289         return bytes20(keccak256(
4290             abi.encodePacked(
4291                 minGas,
4292                 to,
4293                 extraData
4294             )
4295         ));
4296     }
4297 }
4298 
4299 // File: contracts/aux/transactions/TransactionReader.sol
4300 
4301 // Copyright 2017 Loopring Technology Limited.
4302 
4303 
4304 
4305 
4306 
4307 
4308 
4309 /// @title TransactionReader
4310 /// @author Brecht Devos - <brecht@loopring.org>
4311 /// @dev Utility library to read transactions.
4312 library TransactionReader {
4313     using BlockReader       for bytes;
4314     using TransactionReader for ExchangeData.Block;
4315     using BytesUtil         for bytes;
4316 
4317     function readDeposit(
4318         ExchangeData.Block memory _block,
4319         uint txIdx,
4320         bytes memory txData
4321         )
4322         internal
4323         pure
4324         returns (DepositTransaction.Deposit memory deposit)
4325     {
4326         _block.readTx(txIdx, txData);
4327         DepositTransaction.readTx(txData, 0, deposit);
4328     }
4329 
4330     function readWithdrawal(
4331         ExchangeData.Block memory _block,
4332         uint txIdx,
4333         bytes memory txData
4334         )
4335         internal
4336         pure
4337         returns (WithdrawTransaction.Withdrawal memory withdrawal)
4338     {
4339         _block.readTx(txIdx, txData);
4340         WithdrawTransaction.readTx(txData, 0, withdrawal);
4341     }
4342 
4343     function readAmmUpdate(
4344         ExchangeData.Block memory _block,
4345         uint txIdx,
4346         bytes memory txData
4347         )
4348         internal
4349         pure
4350         returns (AmmUpdateTransaction.AmmUpdate memory ammUpdate)
4351     {
4352         _block.readTx(txIdx, txData);
4353         AmmUpdateTransaction.readTx(txData, 0, ammUpdate);
4354     }
4355 
4356     function readTransfer(
4357         ExchangeData.Block memory _block,
4358         uint txIdx,
4359         bytes memory txData
4360         )
4361         internal
4362         pure
4363         returns (TransferTransaction.Transfer memory transfer)
4364     {
4365         _block.readTx(txIdx, txData);
4366         TransferTransaction.readTx(txData, 0, transfer);
4367     }
4368 
4369     function readSignatureVerification(
4370         ExchangeData.Block memory _block,
4371         uint txIdx,
4372         bytes memory txData
4373         )
4374         internal
4375         pure
4376         returns (SignatureVerificationTransaction.SignatureVerification memory verification)
4377     {
4378         _block.readTx(txIdx, txData);
4379         SignatureVerificationTransaction.readTx(txData, 0, verification);
4380     }
4381 
4382     function readTx(
4383         ExchangeData.Block memory _block,
4384         uint txIdx,
4385         bytes memory txData
4386         )
4387         internal
4388         pure
4389     {
4390         _block.data.readTransactionData(txIdx, _block.blockSize, txData);
4391     }
4392 
4393     function readTxs(
4394         ExchangeData.Block memory _block,
4395         uint                      txIdx,
4396         uint16                    numTransactions,
4397         bytes              memory txsData
4398         )
4399         internal
4400         pure
4401     {
4402         bytes memory txData = txsData;
4403         uint TX_DATA_AVAILABILITY_SIZE = ExchangeData.TX_DATA_AVAILABILITY_SIZE;
4404         for (uint i = 0; i < numTransactions; i++) {
4405             _block.data.readTransactionData(txIdx + i, _block.blockSize, txData);
4406             assembly {
4407                 txData := add(txData, TX_DATA_AVAILABILITY_SIZE)
4408             }
4409         }
4410     }
4411 }
4412 
4413 // File: contracts/core/iface/IExchangeV3.sol
4414 
4415 // Copyright 2017 Loopring Technology Limited.
4416 
4417 
4418 
4419 
4420 /// @title IExchangeV3
4421 /// @dev Note that Claimable and RentrancyGuard are inherited here to
4422 ///      ensure all data members are declared on IExchangeV3 to make it
4423 ///      easy to support upgradability through proxies.
4424 ///
4425 ///      Subclasses of this contract must NOT define constructor to
4426 ///      initialize data.
4427 ///
4428 /// @author Brecht Devos - <brecht@loopring.org>
4429 /// @author Daniel Wang  - <daniel@loopring.org>
4430 abstract contract IExchangeV3 is Claimable
4431 {
4432     // -- Events --
4433 
4434     event ExchangeCloned(
4435         address exchangeAddress,
4436         address owner,
4437         bytes32 genesisMerkleRoot
4438     );
4439 
4440     event TokenRegistered(
4441         address token,
4442         uint16  tokenId
4443     );
4444 
4445     event Shutdown(
4446         uint timestamp
4447     );
4448 
4449     event WithdrawalModeActivated(
4450         uint timestamp
4451     );
4452 
4453     event BlockSubmitted(
4454         uint    indexed blockIdx,
4455         bytes32         merkleRoot,
4456         bytes32         publicDataHash
4457     );
4458 
4459     event DepositRequested(
4460         address from,
4461         address to,
4462         address token,
4463         uint16  tokenId,
4464         uint96  amount
4465     );
4466 
4467     event ForcedWithdrawalRequested(
4468         address owner,
4469         address token,
4470         uint32  accountID
4471     );
4472 
4473     event WithdrawalCompleted(
4474         uint8   category,
4475         address from,
4476         address to,
4477         address token,
4478         uint    amount
4479     );
4480 
4481     event WithdrawalFailed(
4482         uint8   category,
4483         address from,
4484         address to,
4485         address token,
4486         uint    amount
4487     );
4488 
4489     event ProtocolFeesUpdated(
4490         uint8 takerFeeBips,
4491         uint8 makerFeeBips,
4492         uint8 previousTakerFeeBips,
4493         uint8 previousMakerFeeBips
4494     );
4495 
4496     event TransactionApproved(
4497         address owner,
4498         bytes32 transactionHash
4499     );
4500 
4501 
4502     // -- Initialization --
4503     /// @dev Initializes this exchange. This method can only be called once.
4504     /// @param  loopring The LoopringV3 contract address.
4505     /// @param  owner The owner of this exchange.
4506     /// @param  genesisMerkleRoot The initial Merkle tree state.
4507     function initialize(
4508         address loopring,
4509         address owner,
4510         bytes32 genesisMerkleRoot
4511         )
4512         virtual
4513         external;
4514 
4515     /// @dev Initialized the agent registry contract used by the exchange.
4516     ///      Can only be called by the exchange owner once.
4517     /// @param agentRegistry The agent registry contract to be used
4518     function setAgentRegistry(address agentRegistry)
4519         external
4520         virtual;
4521 
4522     /// @dev Gets the agent registry contract used by the exchange.
4523     /// @return the agent registry contract
4524     function getAgentRegistry()
4525         external
4526         virtual
4527         view
4528         returns (IAgentRegistry);
4529 
4530     ///      Can only be called by the exchange owner once.
4531     /// @param depositContract The deposit contract to be used
4532     function setDepositContract(address depositContract)
4533         external
4534         virtual;
4535 
4536     /// @dev refresh the blockVerifier contract which maybe changed in loopringV3 contract.
4537     function refreshBlockVerifier()
4538         external
4539         virtual;
4540 
4541     /// @dev Gets the deposit contract used by the exchange.
4542     /// @return the deposit contract
4543     function getDepositContract()
4544         external
4545         virtual
4546         view
4547         returns (IDepositContract);
4548 
4549     // @dev Exchange owner withdraws fees from the exchange.
4550     // @param token Fee token address
4551     // @param feeRecipient Fee recipient address
4552     function withdrawExchangeFees(
4553         address token,
4554         address feeRecipient
4555         )
4556         external
4557         virtual;
4558 
4559     // -- Constants --
4560     /// @dev Returns a list of constants used by the exchange.
4561     /// @return constants The list of constants.
4562     function getConstants()
4563         external
4564         virtual
4565         pure
4566         returns(ExchangeData.Constants memory);
4567 
4568     // -- Mode --
4569     /// @dev Returns hether the exchange is in withdrawal mode.
4570     /// @return Returns true if the exchange is in withdrawal mode, else false.
4571     function isInWithdrawalMode()
4572         external
4573         virtual
4574         view
4575         returns (bool);
4576 
4577     /// @dev Returns whether the exchange is shutdown.
4578     /// @return Returns true if the exchange is shutdown, else false.
4579     function isShutdown()
4580         external
4581         virtual
4582         view
4583         returns (bool);
4584 
4585     // -- Tokens --
4586     /// @dev Registers an ERC20 token for a token id. Note that different exchanges may have
4587     ///      different ids for the same ERC20 token.
4588     ///
4589     ///      Please note that 1 is reserved for Ether (ETH), 2 is reserved for Wrapped Ether (ETH),
4590     ///      and 3 is reserved for Loopring Token (LRC).
4591     ///
4592     ///      This function is only callable by the exchange owner.
4593     ///
4594     /// @param  tokenAddress The token's address
4595     /// @return tokenID The token's ID in this exchanges.
4596     function registerToken(
4597         address tokenAddress
4598         )
4599         external
4600         virtual
4601         returns (uint16 tokenID);
4602 
4603     /// @dev Returns the id of a registered token.
4604     /// @param  tokenAddress The token's address
4605     /// @return tokenID The token's ID in this exchanges.
4606     function getTokenID(
4607         address tokenAddress
4608         )
4609         external
4610         virtual
4611         view
4612         returns (uint16 tokenID);
4613 
4614     /// @dev Returns the address of a registered token.
4615     /// @param  tokenID The token's ID in this exchanges.
4616     /// @return tokenAddress The token's address
4617     function getTokenAddress(
4618         uint16 tokenID
4619         )
4620         external
4621         virtual
4622         view
4623         returns (address tokenAddress);
4624 
4625     // -- Stakes --
4626     /// @dev Gets the amount of LRC the owner has staked onchain for this exchange.
4627     ///      The stake will be burned if the exchange does not fulfill its duty by
4628     ///      processing user requests in time. Please note that order matching may potentially
4629     ///      performed by another party and is not part of the exchange's duty.
4630     ///
4631     /// @return The amount of LRC staked
4632     function getExchangeStake()
4633         external
4634         virtual
4635         view
4636         returns (uint);
4637 
4638     /// @dev Withdraws the amount staked for this exchange.
4639     ///      This can only be done if the exchange has been correctly shutdown:
4640     ///      - The exchange owner has shutdown the exchange
4641     ///      - All deposit requests are processed
4642     ///      - All funds are returned to the users (merkle root is reset to initial state)
4643     ///
4644     ///      Can only be called by the exchange owner.
4645     ///
4646     /// @return amountLRC The amount of LRC withdrawn
4647     function withdrawExchangeStake(
4648         address recipient
4649         )
4650         external
4651         virtual
4652         returns (uint amountLRC);
4653 
4654     /// @dev Can by called by anyone to burn the stake of the exchange when certain
4655     ///      conditions are fulfilled.
4656     ///
4657     ///      Currently this will only burn the stake of the exchange if
4658     ///      the exchange is in withdrawal mode.
4659     function burnExchangeStake()
4660         external
4661         virtual;
4662 
4663     // -- Blocks --
4664 
4665     /// @dev Gets the current Merkle root of this exchange's virtual blockchain.
4666     /// @return The current Merkle root.
4667     function getMerkleRoot()
4668         external
4669         virtual
4670         view
4671         returns (bytes32);
4672 
4673     /// @dev Gets the height of this exchange's virtual blockchain. The block height for a
4674     ///      new exchange is 1.
4675     /// @return The virtual blockchain height which is the index of the last block.
4676     function getBlockHeight()
4677         external
4678         virtual
4679         view
4680         returns (uint);
4681 
4682     /// @dev Gets some minimal info of a previously submitted block that's kept onchain.
4683     ///      A DEX can use this function to implement a payment receipt verification
4684     ///      contract with a challange-response scheme.
4685     /// @param blockIdx The block index.
4686     function getBlockInfo(uint blockIdx)
4687         external
4688         virtual
4689         view
4690         returns (ExchangeData.BlockInfo memory);
4691 
4692     /// @dev Sumbits new blocks to the rollup blockchain.
4693     ///
4694     ///      This function can only be called by the exchange operator.
4695     ///
4696     /// @param blocks The blocks being submitted
4697     ///      - blockType: The type of the new block
4698     ///      - blockSize: The number of onchain or offchain requests/settlements
4699     ///        that have been processed in this block
4700     ///      - blockVersion: The circuit version to use for verifying the block
4701     ///      - storeBlockInfoOnchain: If the block info for this block needs to be stored on-chain
4702     ///      - data: The data for this block
4703     ///      - offchainData: Arbitrary data, mainly for off-chain data-availability, i.e.,
4704     ///        the multihash of the IPFS file that contains the block data.
4705     function submitBlocks(ExchangeData.Block[] calldata blocks)
4706         external
4707         virtual;
4708 
4709     /// @dev Gets the number of available forced request slots.
4710     /// @return The number of available slots.
4711     function getNumAvailableForcedSlots()
4712         external
4713         virtual
4714         view
4715         returns (uint);
4716 
4717     // -- Deposits --
4718 
4719     /// @dev Deposits Ether or ERC20 tokens to the specified account.
4720     ///
4721     ///      This function is only callable by an agent of 'from'.
4722     ///
4723     ///      A fee to the owner is paid in ETH to process the deposit.
4724     ///      The operator is not forced to do the deposit and the user can send
4725     ///      any fee amount.
4726     ///
4727     /// @param from The address that deposits the funds to the exchange
4728     /// @param to The account owner's address receiving the funds
4729     /// @param tokenAddress The address of the token, use `0x0` for Ether.
4730     /// @param amount The amount of tokens to deposit
4731     /// @param auxiliaryData Optional extra data used by the deposit contract
4732     function deposit(
4733         address from,
4734         address to,
4735         address tokenAddress,
4736         uint96  amount,
4737         bytes   calldata auxiliaryData
4738         )
4739         external
4740         virtual
4741         payable;
4742 
4743     /// @dev Gets the amount of tokens that may be added to the owner's account.
4744     /// @param owner The destination address for the amount deposited.
4745     /// @param tokenAddress The address of the token, use `0x0` for Ether.
4746     /// @return The amount of tokens pending.
4747     function getPendingDepositAmount(
4748         address owner,
4749         address tokenAddress
4750         )
4751         external
4752         virtual
4753         view
4754         returns (uint96);
4755 
4756     // -- Withdrawals --
4757     /// @dev Submits an onchain request to force withdraw Ether or ERC20 tokens.
4758     ///      This request always withdraws the full balance.
4759     ///
4760     ///      This function is only callable by an agent of the account.
4761     ///
4762     ///      The total fee in ETH that the user needs to pay is 'withdrawalFee'.
4763     ///      If the user sends too much ETH the surplus is sent back immediately.
4764     ///
4765     ///      Note that after such an operation, it will take the owner some
4766     ///      time (no more than MAX_AGE_FORCED_REQUEST_UNTIL_WITHDRAW_MODE) to process the request
4767     ///      and create the deposit to the offchain account.
4768     ///
4769     /// @param owner The expected owner of the account
4770     /// @param tokenAddress The address of the token, use `0x0` for Ether.
4771     /// @param accountID The address the account in the Merkle tree.
4772     function forceWithdraw(
4773         address owner,
4774         address tokenAddress,
4775         uint32  accountID
4776         )
4777         external
4778         virtual
4779         payable;
4780 
4781     /// @dev Checks if a forced withdrawal is pending for an account balance.
4782     /// @param  accountID The accountID of the account to check.
4783     /// @param  token The token address
4784     /// @return True if a request is pending, false otherwise
4785     function isForcedWithdrawalPending(
4786         uint32  accountID,
4787         address token
4788         )
4789         external
4790         virtual
4791         view
4792         returns (bool);
4793 
4794     /// @dev Submits an onchain request to withdraw Ether or ERC20 tokens from the
4795     ///      protocol fees account. The complete balance is always withdrawn.
4796     ///
4797     ///      Anyone can request a withdrawal of the protocol fees.
4798     ///
4799     ///      Note that after such an operation, it will take the owner some
4800     ///      time (no more than MAX_AGE_FORCED_REQUEST_UNTIL_WITHDRAW_MODE) to process the request
4801     ///      and create the deposit to the offchain account.
4802     ///
4803     /// @param tokenAddress The address of the token, use `0x0` for Ether.
4804     function withdrawProtocolFees(
4805         address tokenAddress
4806         )
4807         external
4808         virtual
4809         payable;
4810 
4811     /// @dev Gets the time the protocol fee for a token was last withdrawn.
4812     /// @param tokenAddress The address of the token, use `0x0` for Ether.
4813     /// @return The time the protocol fee was last withdrawn.
4814     function getProtocolFeeLastWithdrawnTime(
4815         address tokenAddress
4816         )
4817         external
4818         virtual
4819         view
4820         returns (uint);
4821 
4822     /// @dev Allows anyone to withdraw funds for a specified user using the balances stored
4823     ///      in the Merkle tree. The funds will be sent to the owner of the acount.
4824     ///
4825     ///      Can only be used in withdrawal mode (i.e. when the owner has stopped
4826     ///      committing blocks and is not able to commit any more blocks).
4827     ///
4828     ///      This will NOT modify the onchain merkle root! The merkle root stored
4829     ///      onchain will remain the same after the withdrawal. We store if the user
4830     ///      has withdrawn the balance in State.withdrawnInWithdrawMode.
4831     ///
4832     /// @param  merkleProof The Merkle inclusion proof
4833     function withdrawFromMerkleTree(
4834         ExchangeData.MerkleProof calldata merkleProof
4835         )
4836         external
4837         virtual;
4838 
4839     /// @dev Checks if the balance for the account was withdrawn with `withdrawFromMerkleTree`.
4840     /// @param  accountID The accountID of the balance to check.
4841     /// @param  token The token address
4842     /// @return True if it was already withdrawn, false otherwise
4843     function isWithdrawnInWithdrawalMode(
4844         uint32  accountID,
4845         address token
4846         )
4847         external
4848         virtual
4849         view
4850         returns (bool);
4851 
4852     /// @dev Allows withdrawing funds deposited to the contract in a deposit request when
4853     ///      it was never processed by the owner within the maximum time allowed.
4854     ///
4855     ///      Can be called by anyone. The deposited tokens will be sent back to
4856     ///      the owner of the account they were deposited in.
4857     ///
4858     /// @param  owner The address of the account the withdrawal was done for.
4859     /// @param  token The token address
4860     function withdrawFromDepositRequest(
4861         address owner,
4862         address token
4863         )
4864         external
4865         virtual;
4866 
4867     /// @dev Allows withdrawing funds after a withdrawal request (either onchain
4868     ///      or offchain) was submitted in a block by the operator.
4869     ///
4870     ///      Can be called by anyone. The withdrawn tokens will be sent to
4871     ///      the owner of the account they were withdrawn out.
4872     ///
4873     ///      Normally it is should not be needed for users to call this manually.
4874     ///      Funds from withdrawal requests will be sent to the account owner
4875     ///      immediately by the owner when the block is submitted.
4876     ///      The user will however need to call this manually if the transfer failed.
4877     ///
4878     ///      Tokens and owners must have the same size.
4879     ///
4880     /// @param  owners The addresses of the account the withdrawal was done for.
4881     /// @param  tokens The token addresses
4882     function withdrawFromApprovedWithdrawals(
4883         address[] calldata owners,
4884         address[] calldata tokens
4885         )
4886         external
4887         virtual;
4888 
4889     /// @dev Gets the amount that can be withdrawn immediately with `withdrawFromApprovedWithdrawals`.
4890     /// @param  owner The address of the account the withdrawal was done for.
4891     /// @param  token The token address
4892     /// @return The amount withdrawable
4893     function getAmountWithdrawable(
4894         address owner,
4895         address token
4896         )
4897         external
4898         virtual
4899         view
4900         returns (uint);
4901 
4902     /// @dev Notifies the exchange that the owner did not process a forced request.
4903     ///      If this is indeed the case, the exchange will enter withdrawal mode.
4904     ///
4905     ///      Can be called by anyone.
4906     ///
4907     /// @param  accountID The accountID the forced request was made for
4908     /// @param  token The token address of the the forced request
4909     function notifyForcedRequestTooOld(
4910         uint32  accountID,
4911         address token
4912         )
4913         external
4914         virtual;
4915 
4916     /// @dev Allows a withdrawal to be done to an adddresss that is different
4917     ///      than initialy specified in the withdrawal request. This can be used to
4918     ///      implement functionality like fast withdrawals.
4919     ///
4920     ///      This function can only be called by an agent.
4921     ///
4922     /// @param from The address of the account that does the withdrawal.
4923     /// @param to The address to which 'amount' tokens were going to be withdrawn.
4924     /// @param token The address of the token that is withdrawn ('0x0' for ETH).
4925     /// @param amount The amount of tokens that are going to be withdrawn.
4926     /// @param storageID The storageID of the withdrawal request.
4927     /// @param newRecipient The new recipient address of the withdrawal.
4928     function setWithdrawalRecipient(
4929         address from,
4930         address to,
4931         address token,
4932         uint96  amount,
4933         uint32  storageID,
4934         address newRecipient
4935         )
4936         external
4937         virtual;
4938 
4939     /// @dev Gets the withdrawal recipient.
4940     ///
4941     /// @param from The address of the account that does the withdrawal.
4942     /// @param to The address to which 'amount' tokens were going to be withdrawn.
4943     /// @param token The address of the token that is withdrawn ('0x0' for ETH).
4944     /// @param amount The amount of tokens that are going to be withdrawn.
4945     /// @param storageID The storageID of the withdrawal request.
4946     function getWithdrawalRecipient(
4947         address from,
4948         address to,
4949         address token,
4950         uint96  amount,
4951         uint32  storageID
4952         )
4953         external
4954         virtual
4955         view
4956         returns (address);
4957 
4958     /// @dev Allows an agent to transfer ERC-20 tokens for a user using the allowance
4959     ///      the user has set for the exchange. This way the user only needs to approve a single exchange contract
4960     ///      for all exchange/agent features, which allows for a more seamless user experience.
4961     ///
4962     ///      This function can only be called by an agent.
4963     ///
4964     /// @param from The address of the account that sends the tokens.
4965     /// @param to The address to which 'amount' tokens are transferred.
4966     /// @param token The address of the token to transfer (ETH is and cannot be suppported).
4967     /// @param amount The amount of tokens transferred.
4968     function onchainTransferFrom(
4969         address from,
4970         address to,
4971         address token,
4972         uint    amount
4973         )
4974         external
4975         virtual;
4976 
4977     /// @dev Allows an agent to approve a rollup tx.
4978     ///
4979     ///      This function can only be called by an agent.
4980     ///
4981     /// @param owner The owner of the account
4982     /// @param txHash The hash of the transaction
4983     function approveTransaction(
4984         address owner,
4985         bytes32 txHash
4986         )
4987         external
4988         virtual;
4989 
4990     /// @dev Allows an agent to approve multiple rollup txs.
4991     ///
4992     ///      This function can only be called by an agent.
4993     ///
4994     /// @param owners The account owners
4995     /// @param txHashes The hashes of the transactions
4996     function approveTransactions(
4997         address[] calldata owners,
4998         bytes32[] calldata txHashes
4999         )
5000         external
5001         virtual;
5002 
5003     /// @dev Checks if a rollup tx is approved using the tx's hash.
5004     ///
5005     /// @param owner The owner of the account that needs to authorize the tx
5006     /// @param txHash The hash of the transaction
5007     /// @return True if the tx is approved, else false
5008     function isTransactionApproved(
5009         address owner,
5010         bytes32 txHash
5011         )
5012         external
5013         virtual
5014         view
5015         returns (bool);
5016 
5017     // -- Admins --
5018     /// @dev Sets the max time deposits have to wait before becoming withdrawable.
5019     /// @param newValue The new value.
5020     /// @return  The old value.
5021     function setMaxAgeDepositUntilWithdrawable(
5022         uint32 newValue
5023         )
5024         external
5025         virtual
5026         returns (uint32);
5027 
5028     /// @dev Returns the max time deposits have to wait before becoming withdrawable.
5029     /// @return The value.
5030     function getMaxAgeDepositUntilWithdrawable()
5031         external
5032         virtual
5033         view
5034         returns (uint32);
5035 
5036     /// @dev Shuts down the exchange.
5037     ///      Once the exchange is shutdown all onchain requests are permanently disabled.
5038     ///      When all requirements are fulfilled the exchange owner can withdraw
5039     ///      the exchange stake with withdrawStake.
5040     ///
5041     ///      Note that the exchange can still enter the withdrawal mode after this function
5042     ///      has been invoked successfully. To prevent entering the withdrawal mode before the
5043     ///      the echange stake can be withdrawn, all withdrawal requests still need to be handled
5044     ///      for at least MIN_TIME_IN_SHUTDOWN seconds.
5045     ///
5046     ///      Can only be called by the exchange owner.
5047     ///
5048     /// @return success True if the exchange is shutdown, else False
5049     function shutdown()
5050         external
5051         virtual
5052         returns (bool success);
5053 
5054     /// @dev Gets the protocol fees for this exchange.
5055     /// @return syncedAt The timestamp the protocol fees were last updated
5056     /// @return takerFeeBips The protocol taker fee
5057     /// @return makerFeeBips The protocol maker fee
5058     /// @return previousTakerFeeBips The previous protocol taker fee
5059     /// @return previousMakerFeeBips The previous protocol maker fee
5060     function getProtocolFeeValues()
5061         external
5062         virtual
5063         view
5064         returns (
5065             uint32 syncedAt,
5066             uint8 takerFeeBips,
5067             uint8 makerFeeBips,
5068             uint8 previousTakerFeeBips,
5069             uint8 previousMakerFeeBips
5070         );
5071 
5072     /// @dev Gets the domain separator used in this exchange.
5073     function getDomainSeparator()
5074         external
5075         virtual
5076         view
5077         returns (bytes32);
5078 
5079     /// @dev set amm pool feeBips value.
5080     function setAmmFeeBips(uint8 _feeBips)
5081         external
5082         virtual;
5083 
5084     /// @dev get amm pool feeBips value.
5085     function getAmmFeeBips()
5086         external
5087         virtual
5088         view
5089         returns (uint8);
5090 }
5091 
5092 // File: contracts/lib/ERC20.sol
5093 
5094 // Copyright 2017 Loopring Technology Limited.
5095 
5096 
5097 /// @title ERC20 Token Interface
5098 /// @dev see https://github.com/ethereum/EIPs/issues/20
5099 /// @author Daniel Wang - <daniel@loopring.org>
5100 abstract contract ERC20
5101 {
5102     function totalSupply()
5103         public
5104         virtual
5105         view
5106         returns (uint);
5107 
5108     function balanceOf(
5109         address who
5110         )
5111         public
5112         virtual
5113         view
5114         returns (uint);
5115 
5116     function allowance(
5117         address owner,
5118         address spender
5119         )
5120         public
5121         virtual
5122         view
5123         returns (uint);
5124 
5125     function transfer(
5126         address to,
5127         uint value
5128         )
5129         public
5130         virtual
5131         returns (bool);
5132 
5133     function transferFrom(
5134         address from,
5135         address to,
5136         uint    value
5137         )
5138         public
5139         virtual
5140         returns (bool);
5141 
5142     function approve(
5143         address spender,
5144         uint    value
5145         )
5146         public
5147         virtual
5148         returns (bool);
5149 }
5150 
5151 // File: contracts/lib/Drainable.sol
5152 
5153 // Copyright 2017 Loopring Technology Limited.
5154 
5155 
5156 
5157 
5158 
5159 /// @title Drainable
5160 /// @author Brecht Devos - <brecht@loopring.org>
5161 /// @dev Standard functionality to allow draining funds from a contract.
5162 abstract contract Drainable
5163 {
5164     using AddressUtil       for address;
5165     using ERC20SafeTransfer for address;
5166 
5167     event Drained(
5168         address to,
5169         address token,
5170         uint    amount
5171     );
5172 
5173     function drain(
5174         address to,
5175         address token
5176         )
5177         public
5178         returns (uint amount)
5179     {
5180         require(canDrain(msg.sender, token), "UNAUTHORIZED");
5181 
5182         if (token == address(0)) {
5183             amount = address(this).balance;
5184             to.sendETHAndVerify(amount, gasleft());   // ETH
5185         } else {
5186             amount = ERC20(token).balanceOf(address(this));
5187             token.safeTransferAndVerify(to, amount);  // ERC20 token
5188         }
5189 
5190         emit Drained(to, token, amount);
5191     }
5192 
5193     // Needs to return if the address is authorized to call drain.
5194     function canDrain(address drainer, address token)
5195         public
5196         virtual
5197         view
5198         returns (bool);
5199 }
5200 
5201 // File: contracts/aux/access/SelectorBasedAccessManager.sol
5202 
5203 // Copyright 2017 Loopring Technology Limited.
5204 
5205 
5206 
5207 
5208 
5209 /// @title  SelectorBasedAccessManager
5210 /// @author Daniel Wang - <daniel@loopring.org>
5211 contract SelectorBasedAccessManager is Claimable
5212 {
5213     using BytesUtil for bytes;
5214 
5215     event PermissionUpdate(
5216         address indexed user,
5217         bytes4  indexed selector,
5218         bool            allowed
5219     );
5220 
5221     address public immutable target;
5222     mapping(address => mapping(bytes4 => bool)) public permissions;
5223 
5224     modifier withAccess(bytes4 selector)
5225     {
5226         require(hasAccessTo(msg.sender, selector), "PERMISSION_DENIED");
5227         _;
5228     }
5229 
5230     constructor(address _target)
5231     {
5232         require(_target != address(0), "ZERO_ADDRESS");
5233         target = _target;
5234     }
5235 
5236     function grantAccess(
5237         address user,
5238         bytes4  selector,
5239         bool    granted
5240         )
5241         external
5242         onlyOwner
5243     {
5244         require(permissions[user][selector] != granted, "INVALID_VALUE");
5245         permissions[user][selector] = granted;
5246         emit PermissionUpdate(user, selector, granted);
5247     }
5248 
5249     receive() payable external {}
5250 
5251     fallback()
5252         payable
5253         external
5254     {
5255         transact(msg.data);
5256     }
5257 
5258     function transact(bytes memory data)
5259         payable
5260         public
5261         withAccess(data.toBytes4(0))
5262     {
5263         (bool success, bytes memory returnData) = target
5264             .call{value: msg.value}(data);
5265 
5266         if (!success) {
5267             assembly { revert(add(returnData, 32), mload(returnData)) }
5268         }
5269     }
5270 
5271     function hasAccessTo(address user, bytes4 selector)
5272         public
5273         view
5274         returns (bool)
5275     {
5276         return user == owner || permissions[user][selector];
5277     }
5278 }
5279 
5280 // File: contracts/amm/libamm/IAmmSharedConfig.sol
5281 
5282 // Copyright 2017 Loopring Technology Limited.
5283 
5284 interface IAmmSharedConfig
5285 {
5286     function maxForcedExitAge() external view returns (uint);
5287     function maxForcedExitCount() external view returns (uint);
5288     function forcedExitFee() external view returns (uint);
5289 }
5290 
5291 // File: contracts/amm/libamm/AmmData.sol
5292 
5293 // Copyright 2017 Loopring Technology Limited.
5294 
5295 
5296 
5297 
5298 
5299 /// @title AmmData
5300 library AmmData
5301 {
5302     uint public constant POOL_TOKEN_BASE = 100 * (10 ** 8);
5303     uint public constant POOL_TOKEN_MINTED_SUPPLY = uint96(-1);
5304 
5305     enum PoolTxType
5306     {
5307         NOOP,
5308         JOIN,
5309         EXIT
5310     }
5311 
5312     struct PoolConfig
5313     {
5314         address   sharedConfig;
5315         address   exchange;
5316         string    poolName;
5317         uint32    accountID;
5318         address[] tokens;
5319         uint96[]  weights;
5320         uint8     feeBips;
5321         string    tokenSymbol;
5322     }
5323 
5324     struct PoolJoin
5325     {
5326         address   owner;
5327         uint96[]  joinAmounts;
5328         uint32[]  joinStorageIDs;
5329         uint96    mintMinAmount;
5330         uint96    fee;
5331         uint32    validUntil;
5332     }
5333 
5334     struct PoolExit
5335     {
5336         address   owner;
5337         uint96    burnAmount;
5338         uint32    burnStorageID; // for pool token withdrawal from user to the pool
5339         uint96[]  exitMinAmounts; // the amount to receive BEFORE paying the fee.
5340         uint96    fee;
5341         uint32    validUntil;
5342     }
5343 
5344     struct PoolTx
5345     {
5346         PoolTxType txType;
5347         bytes      data;
5348         bytes      signature;
5349     }
5350 
5351     struct Token
5352     {
5353         address addr;
5354         uint96  weight;
5355         uint16  tokenID;
5356     }
5357 
5358     struct Context
5359     {
5360         // functional parameters
5361         uint txIdx;
5362 
5363         // AMM pool state variables
5364         bytes32 domainSeparator;
5365         uint32  accountID;
5366 
5367         uint16  poolTokenID;
5368         uint8   feeBips;
5369         uint    totalSupply;
5370 
5371         Token[]  tokens;
5372         uint96[] tokenBalancesL2;
5373     }
5374 
5375     struct State {
5376         // Pool token state variables
5377         string poolName;
5378         string symbol;
5379         uint   _totalSupply;
5380 
5381         mapping(address => uint) balanceOf;
5382         mapping(address => mapping(address => uint)) allowance;
5383         mapping(address => uint) nonces;
5384 
5385         // AMM pool state variables
5386         IAmmSharedConfig sharedConfig;
5387 
5388         Token[]     tokens;
5389 
5390         // The order of the following variables important to minimize loads
5391         bytes32     exchangeDomainSeparator;
5392         bytes32     domainSeparator;
5393         IExchangeV3 exchange;
5394         uint32      accountID;
5395         uint16      poolTokenID;
5396         uint8       feeBips;
5397 
5398         address     exchangeOwner;
5399 
5400         uint64      shutdownTimestamp;
5401         uint16      forcedExitCount;
5402 
5403         // A map from a user to the forced exit.
5404         mapping (address => PoolExit) forcedExit;
5405         mapping (bytes32 => bool) approvedTx;
5406     }
5407 }
5408 
5409 // File: contracts/aux/access/IBlockReceiver.sol
5410 
5411 // Copyright 2017 Loopring Technology Limited.
5412 
5413 
5414 
5415 /// @title IBlockReceiver
5416 /// @author Brecht Devos - <brecht@loopring.org>
5417 abstract contract IBlockReceiver
5418 {
5419     function beforeBlockSubmission(
5420         bytes              calldata txsData,
5421         bytes              calldata callbackData
5422         )
5423         external
5424         virtual;
5425 }
5426 
5427 // File: contracts/aux/access/LoopringIOExchangeOwner.sol
5428 
5429 // Copyright 2017 Loopring Technology Limited.
5430 
5431 
5432 
5433 
5434 
5435 
5436 
5437 
5438 
5439 
5440 
5441 
5442 
5443 contract LoopringIOExchangeOwner is SelectorBasedAccessManager, ERC1271, Drainable
5444 {
5445     using AddressUtil       for address;
5446     using AddressUtil       for address payable;
5447     using BytesUtil         for bytes;
5448     using MathUint          for uint;
5449     using SignatureUtil     for bytes32;
5450     using TransactionReader for ExchangeData.Block;
5451 
5452     bytes4    private constant SUBMITBLOCKS_SELECTOR = IExchangeV3.submitBlocks.selector;
5453     bool      public  open;
5454 
5455     event SubmitBlocksAccessOpened(bool open);
5456 
5457     struct TxCallback
5458     {
5459         uint16 txIdx;
5460         uint16 numTxs;
5461         uint16 receiverIdx;
5462         bytes  data;
5463     }
5464 
5465     struct BlockCallback
5466     {
5467         uint16        blockIdx;
5468         TxCallback[]  txCallbacks;
5469     }
5470 
5471     struct CallbackConfig
5472     {
5473         BlockCallback[] blockCallbacks;
5474         address[]       receivers;
5475     }
5476 
5477     constructor(
5478         address _exchange
5479         )
5480         SelectorBasedAccessManager(_exchange)
5481     {
5482     }
5483 
5484     function openAccessToSubmitBlocks(bool _open)
5485         external
5486         onlyOwner
5487     {
5488         open = _open;
5489         emit SubmitBlocksAccessOpened(_open);
5490     }
5491 
5492     function isValidSignature(
5493         bytes32        signHash,
5494         bytes   memory signature
5495         )
5496         public
5497         view
5498         override
5499         returns (bytes4)
5500     {
5501         // Role system used a bit differently here.
5502         return hasAccessTo(
5503             signHash.recoverECDSASigner(signature),
5504             this.isValidSignature.selector
5505         ) ? ERC1271_MAGICVALUE : bytes4(0);
5506     }
5507 
5508     function canDrain(address drainer, address /* token */)
5509         public
5510         override
5511         view
5512         returns (bool)
5513     {
5514         return hasAccessTo(drainer, this.drain.selector);
5515     }
5516 
5517     function submitBlocksWithCallbacks(
5518         bool                     isDataCompressed,
5519         bytes           calldata data,
5520         CallbackConfig  calldata config
5521         )
5522         external
5523     {
5524         if (config.blockCallbacks.length > 0) {
5525             require(config.receivers.length > 0, "MISSING_RECEIVERS");
5526 
5527             // Make sure the receiver is authorized to approve transactions
5528             IAgentRegistry agentRegistry = IExchangeV3(target).getAgentRegistry();
5529             for (uint i = 0; i < config.receivers.length; i++) {
5530                 require(agentRegistry.isUniversalAgent(config.receivers[i]), "UNAUTHORIZED_RECEIVER");
5531             }
5532         }
5533 
5534         require(
5535             hasAccessTo(msg.sender, SUBMITBLOCKS_SELECTOR) || open,
5536             "PERMISSION_DENIED"
5537         );
5538         bytes memory decompressed = isDataCompressed ?
5539             ZeroDecompressor.decompress(data, 1):
5540             data;
5541 
5542         require(
5543             decompressed.toBytes4(0) == SUBMITBLOCKS_SELECTOR,
5544             "INVALID_DATA"
5545         );
5546 
5547         // Decode the blocks
5548         ExchangeData.Block[] memory blocks = _decodeBlocks(decompressed);
5549 
5550         // Process the callback logic.
5551         _beforeBlockSubmission(blocks, config);
5552 
5553         target.fastCallAndVerify(gasleft(), 0, decompressed);
5554     }
5555 
5556     function _beforeBlockSubmission(
5557         ExchangeData.Block[] memory   blocks,
5558         CallbackConfig       calldata config
5559         )
5560         private
5561     {
5562         // Allocate memory to verify transactions that are approved
5563         bool[][] memory preApprovedTxs = new bool[][](blocks.length);
5564         for (uint i = 0; i < blocks.length; i++) {
5565             preApprovedTxs[i] = new bool[](blocks[i].blockSize);
5566         }
5567 
5568         // Process transactions
5569         int lastBlockIdx = -1;
5570         for (uint i = 0; i < config.blockCallbacks.length; i++) {
5571             BlockCallback calldata blockCallback = config.blockCallbacks[i];
5572 
5573             uint16 blockIdx = blockCallback.blockIdx;
5574             require(blockIdx > lastBlockIdx, "BLOCK_INDEX_OUT_OF_ORDER");
5575             lastBlockIdx = int(blockIdx);
5576 
5577             require(blockIdx < blocks.length, "INVALID_BLOCKIDX");
5578             ExchangeData.Block memory _block = blocks[blockIdx];
5579 
5580             _processTxCallbacks(
5581                 _block,
5582                 blockCallback.txCallbacks,
5583                 config.receivers,
5584                 preApprovedTxs[blockIdx]
5585             );
5586         }
5587 
5588         // Verify the approved transactions data against the auxiliary data in the block
5589         for (uint i = 0; i < blocks.length; i++) {
5590             bool[] memory _preApprovedTxs = preApprovedTxs[i];
5591             ExchangeData.AuxiliaryData[] memory auxiliaryData;
5592             bytes memory blockAuxData = blocks[i].auxiliaryData;
5593             assembly {
5594                 auxiliaryData := add(blockAuxData, 64)
5595             }
5596 
5597             for(uint j = 0; j < auxiliaryData.length; j++) {
5598                 // Load the data from auxiliaryData, which is still encoded as calldata
5599                 uint txIdx;
5600                 bool approved;
5601                 assembly {
5602                     // Offset to auxiliaryData[j]
5603                     let auxOffset := mload(add(auxiliaryData, add(32, mul(32, j))))
5604                     // Load `txIdx` (pos 0) and `approved` (pos 1) in auxiliaryData[j]
5605                     txIdx := mload(add(add(32, auxiliaryData), auxOffset))
5606                     approved := mload(add(add(64, auxiliaryData), auxOffset))
5607                 }
5608                 // Check that the provided data matches the expected value
5609                 require(_preApprovedTxs[txIdx] == approved, "PRE_APPROVED_TX_MISMATCH");
5610             }
5611         }
5612     }
5613 
5614     function _processTxCallbacks(
5615         ExchangeData.Block memory _block,
5616         TxCallback[]       calldata txCallbacks,
5617         address[]          calldata receivers,
5618         bool[]             memory   preApprovedTxs
5619         )
5620         private
5621     {
5622         if (txCallbacks.length == 0) {
5623             return;
5624         }
5625 
5626         uint cursor = 0;
5627 
5628         // Reuse the data when possible to save on some memory alloc gas
5629         bytes memory txsData = new bytes(txCallbacks[0].numTxs * ExchangeData.TX_DATA_AVAILABILITY_SIZE);
5630         for (uint i = 0; i < txCallbacks.length; i++) {
5631             TxCallback calldata txCallback = txCallbacks[i];
5632 
5633             uint txIdx = uint(txCallback.txIdx);
5634             require(txIdx >= cursor, "TX_INDEX_OUT_OF_ORDER");
5635 
5636             require(txCallback.receiverIdx < receivers.length, "INVALID_RECEIVER_INDEX");
5637 
5638             uint txsDataLength = ExchangeData.TX_DATA_AVAILABILITY_SIZE*txCallback.numTxs;
5639             if (txsData.length != txsDataLength) {
5640                 txsData = new bytes(txsDataLength);
5641             }
5642             _block.readTxs(txIdx, txCallback.numTxs, txsData);
5643             IBlockReceiver(receivers[txCallback.receiverIdx]).beforeBlockSubmission(
5644                 txsData,
5645                 txCallback.data
5646             );
5647 
5648             // Now that the transactions have been verified, mark them as approved
5649             for (uint j = txIdx; j < txIdx + txCallback.numTxs; j++) {
5650                 preApprovedTxs[j] = true;
5651             }
5652 
5653             cursor = txIdx + txCallback.numTxs;
5654         }
5655     }
5656 
5657     function _decodeBlocks(bytes memory data)
5658         private
5659         pure
5660         returns (ExchangeData.Block[] memory)
5661     {
5662         // This copies the data (expensive) instead of just pointing to the correct address
5663         //bytes memory blockData;
5664         //assembly {
5665         //    blockData := add(data, 4)
5666         //}
5667         //ExchangeData.Block[] memory blocks = abi.decode(blockData, (ExchangeData.Block[]));
5668 
5669         // Points the block data to the data in the abi encoded data.
5670         // Only sets the data necessary in the callbacks!
5671         // 36 := 4 (function selector) + 32 (offset to blocks)
5672         uint numBlocks = data.toUint(36);
5673         ExchangeData.Block[] memory blocks = new ExchangeData.Block[](numBlocks);
5674         for (uint i = 0; i < numBlocks; i++) {
5675             ExchangeData.Block memory _block = blocks[i];
5676 
5677             // 68 := 36 (see above) + 32 (blocks length)
5678             uint blockOffset = 68 + data.toUint(68 + i*32);
5679 
5680             uint offset = blockOffset;
5681             //_block.blockType = uint8(data.toUint(offset));
5682             offset += 32;
5683             _block.blockSize = uint16(data.toUint(offset));
5684             offset += 32;
5685             //_block.blockVersion = uint8(data.toUint(offset));
5686             offset += 32;
5687             uint blockDataOffset = data.toUint(offset);
5688             offset += 32;
5689             // Skip over proof
5690             offset += 32 * 8;
5691             // Skip over storeBlockInfoOnchain
5692             offset += 32;
5693             uint auxiliaryDataOffset = data.toUint(offset);
5694             offset += 32;
5695 
5696             bytes memory blockData;
5697             assembly {
5698                 blockData := add(data, add(32, add(blockOffset, blockDataOffset)))
5699             }
5700             _block.data = blockData;
5701 
5702             bytes memory auxiliaryData;
5703             assembly {
5704                 auxiliaryData := add(data, add(32, add(blockOffset, auxiliaryDataOffset)))
5705             }
5706             // Encoded as calldata!
5707             _block.auxiliaryData = auxiliaryData;
5708         }
5709         return blocks;
5710     }
5711 }