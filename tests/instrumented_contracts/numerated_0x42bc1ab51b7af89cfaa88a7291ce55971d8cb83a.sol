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
338     function fastSHA256(
339         bytes memory data
340         )
341         internal
342         view
343         returns (bytes32)
344     {
345         bytes32[] memory result = new bytes32[](1);
346         bool success;
347         assembly {
348              let ptr := add(data, 32)
349              success := staticcall(sub(gas(), 2000), 2, ptr, mload(data), add(result, 32), 32)
350         }
351         require(success, "SHA256_FAILED");
352         return result[0];
353     }
354 }
355 
356 // File: contracts/core/iface/IAgentRegistry.sol
357 
358 // Copyright 2017 Loopring Technology Limited.
359 
360 interface IAgent{}
361 
362 abstract contract IAgentRegistry
363 {
364     /// @dev Returns whether an agent address is an agent of an account owner
365     /// @param owner The account owner.
366     /// @param agent The agent address
367     /// @return True if the agent address is an agent for the account owner, else false
368     function isAgent(
369         address owner,
370         address agent
371         )
372         external
373         virtual
374         view
375         returns (bool);
376 
377     /// @dev Returns whether an agent address is an agent of all account owners
378     /// @param owners The account owners.
379     /// @param agent The agent address
380     /// @return True if the agent address is an agent for the account owner, else false
381     function isAgent(
382         address[] calldata owners,
383         address            agent
384         )
385         external
386         virtual
387         view
388         returns (bool);
389 
390     /// @dev Returns whether an agent address is a universal agent.
391     /// @param agent The agent address
392     /// @return True if the agent address is a universal agent, else false
393     function isUniversalAgent(address agent)
394         public
395         virtual
396         view
397         returns (bool);
398 }
399 
400 // File: contracts/lib/Ownable.sol
401 
402 // Copyright 2017 Loopring Technology Limited.
403 
404 
405 /// @title Ownable
406 /// @author Brecht Devos - <brecht@loopring.org>
407 /// @dev The Ownable contract has an owner address, and provides basic
408 ///      authorization control functions, this simplifies the implementation of
409 ///      "user permissions".
410 contract Ownable
411 {
412     address public owner;
413 
414     event OwnershipTransferred(
415         address indexed previousOwner,
416         address indexed newOwner
417     );
418 
419     /// @dev The Ownable constructor sets the original `owner` of the contract
420     ///      to the sender.
421     constructor()
422     {
423         owner = msg.sender;
424     }
425 
426     /// @dev Throws if called by any account other than the owner.
427     modifier onlyOwner()
428     {
429         require(msg.sender == owner, "UNAUTHORIZED");
430         _;
431     }
432 
433     /// @dev Allows the current owner to transfer control of the contract to a
434     ///      new owner.
435     /// @param newOwner The address to transfer ownership to.
436     function transferOwnership(
437         address newOwner
438         )
439         public
440         virtual
441         onlyOwner
442     {
443         require(newOwner != address(0), "ZERO_ADDRESS");
444         emit OwnershipTransferred(owner, newOwner);
445         owner = newOwner;
446     }
447 
448     function renounceOwnership()
449         public
450         onlyOwner
451     {
452         emit OwnershipTransferred(owner, address(0));
453         owner = address(0);
454     }
455 }
456 
457 // File: contracts/lib/Claimable.sol
458 
459 // Copyright 2017 Loopring Technology Limited.
460 
461 
462 
463 /// @title Claimable
464 /// @author Brecht Devos - <brecht@loopring.org>
465 /// @dev Extension for the Ownable contract, where the ownership needs
466 ///      to be claimed. This allows the new owner to accept the transfer.
467 contract Claimable is Ownable
468 {
469     address public pendingOwner;
470 
471     /// @dev Modifier throws if called by any account other than the pendingOwner.
472     modifier onlyPendingOwner() {
473         require(msg.sender == pendingOwner, "UNAUTHORIZED");
474         _;
475     }
476 
477     /// @dev Allows the current owner to set the pendingOwner address.
478     /// @param newOwner The address to transfer ownership to.
479     function transferOwnership(
480         address newOwner
481         )
482         public
483         override
484         onlyOwner
485     {
486         require(newOwner != address(0) && newOwner != owner, "INVALID_ADDRESS");
487         pendingOwner = newOwner;
488     }
489 
490     /// @dev Allows the pendingOwner address to finalize the transfer.
491     function claimOwnership()
492         public
493         onlyPendingOwner
494     {
495         emit OwnershipTransferred(owner, pendingOwner);
496         owner = pendingOwner;
497         pendingOwner = address(0);
498     }
499 }
500 
501 // File: contracts/core/iface/IBlockVerifier.sol
502 
503 // Copyright 2017 Loopring Technology Limited.
504 
505 
506 
507 /// @title IBlockVerifier
508 /// @author Brecht Devos - <brecht@loopring.org>
509 abstract contract IBlockVerifier is Claimable
510 {
511     // -- Events --
512 
513     event CircuitRegistered(
514         uint8  indexed blockType,
515         uint16         blockSize,
516         uint8          blockVersion
517     );
518 
519     event CircuitDisabled(
520         uint8  indexed blockType,
521         uint16         blockSize,
522         uint8          blockVersion
523     );
524 
525     // -- Public functions --
526 
527     /// @dev Sets the verifying key for the specified circuit.
528     ///      Every block permutation needs its own circuit and thus its own set of
529     ///      verification keys. Only a limited number of block sizes per block
530     ///      type are supported.
531     /// @param blockType The type of the block
532     /// @param blockSize The number of requests handled in the block
533     /// @param blockVersion The block version (i.e. which circuit version needs to be used)
534     /// @param vk The verification key
535     function registerCircuit(
536         uint8    blockType,
537         uint16   blockSize,
538         uint8    blockVersion,
539         uint[18] calldata vk
540         )
541         external
542         virtual;
543 
544     /// @dev Disables the use of the specified circuit.
545     /// @param blockType The type of the block
546     /// @param blockSize The number of requests handled in the block
547     /// @param blockVersion The block version (i.e. which circuit version needs to be used)
548     function disableCircuit(
549         uint8  blockType,
550         uint16 blockSize,
551         uint8  blockVersion
552         )
553         external
554         virtual;
555 
556     /// @dev Verifies blocks with the given public data and proofs.
557     ///      Verifying a block makes sure all requests handled in the block
558     ///      are correctly handled by the operator.
559     /// @param blockType The type of block
560     /// @param blockSize The number of requests handled in the block
561     /// @param blockVersion The block version (i.e. which circuit version needs to be used)
562     /// @param publicInputs The hash of all the public data of the blocks
563     /// @param proofs The ZK proofs proving that the blocks are correct
564     /// @return True if the block is valid, false otherwise
565     function verifyProofs(
566         uint8  blockType,
567         uint16 blockSize,
568         uint8  blockVersion,
569         uint[] calldata publicInputs,
570         uint[] calldata proofs
571         )
572         external
573         virtual
574         view
575         returns (bool);
576 
577     /// @dev Checks if a circuit with the specified parameters is registered.
578     /// @param blockType The type of the block
579     /// @param blockSize The number of requests handled in the block
580     /// @param blockVersion The block version (i.e. which circuit version needs to be used)
581     /// @return True if the circuit is registered, false otherwise
582     function isCircuitRegistered(
583         uint8  blockType,
584         uint16 blockSize,
585         uint8  blockVersion
586         )
587         external
588         virtual
589         view
590         returns (bool);
591 
592     /// @dev Checks if a circuit can still be used to commit new blocks.
593     /// @param blockType The type of the block
594     /// @param blockSize The number of requests handled in the block
595     /// @param blockVersion The block version (i.e. which circuit version needs to be used)
596     /// @return True if the circuit is enabled, false otherwise
597     function isCircuitEnabled(
598         uint8  blockType,
599         uint16 blockSize,
600         uint8  blockVersion
601         )
602         external
603         virtual
604         view
605         returns (bool);
606 }
607 
608 // File: contracts/core/iface/IDepositContract.sol
609 
610 // Copyright 2017 Loopring Technology Limited.
611 
612 
613 /// @title IDepositContract.
614 /// @dev   Contract storing and transferring funds for an exchange.
615 ///
616 ///        ERC1155 tokens can be supported by registering pseudo token addresses calculated
617 ///        as `address(keccak256(real_token_address, token_params))`. Then the custom
618 ///        deposit contract can look up the real token address and paramsters with the
619 ///        pseudo token address before doing the transfers.
620 /// @author Brecht Devos - <brecht@loopring.org>
621 interface IDepositContract
622 {
623     /// @dev Returns if a token is suppoprted by this contract.
624     function isTokenSupported(address token)
625         external
626         view
627         returns (bool);
628 
629     /// @dev Transfers tokens from a user to the exchange. This function will
630     ///      be called when a user deposits funds to the exchange.
631     ///      In a simple implementation the funds are simply stored inside the
632     ///      deposit contract directly. More advanced implementations may store the funds
633     ///      in some DeFi application to earn interest, so this function could directly
634     ///      call the necessary functions to store the funds there.
635     ///
636     ///      This function needs to throw when an error occurred!
637     ///
638     ///      This function can only be called by the exchange.
639     ///
640     /// @param from The address of the account that sends the tokens.
641     /// @param token The address of the token to transfer (`0x0` for ETH).
642     /// @param amount The amount of tokens to transfer.
643     /// @param extraData Opaque data that can be used by the contract to handle the deposit
644     /// @return amountReceived The amount to deposit to the user's account in the Merkle tree
645     function deposit(
646         address from,
647         address token,
648         uint96  amount,
649         bytes   calldata extraData
650         )
651         external
652         payable
653         returns (uint96 amountReceived);
654 
655     /// @dev Transfers tokens from the exchange to a user. This function will
656     ///      be called when a withdrawal is done for a user on the exchange.
657     ///      In the simplest implementation the funds are simply stored inside the
658     ///      deposit contract directly so this simply transfers the requested tokens back
659     ///      to the user. More advanced implementations may store the funds
660     ///      in some DeFi application to earn interest so the function would
661     ///      need to get those tokens back from the DeFi application first before they
662     ///      can be transferred to the user.
663     ///
664     ///      This function needs to throw when an error occurred!
665     ///
666     ///      This function can only be called by the exchange.
667     ///
668     /// @param from The address from which 'amount' tokens are transferred.
669     /// @param to The address to which 'amount' tokens are transferred.
670     /// @param token The address of the token to transfer (`0x0` for ETH).
671     /// @param amount The amount of tokens transferred.
672     /// @param extraData Opaque data that can be used by the contract to handle the withdrawal
673     function withdraw(
674         address from,
675         address to,
676         address token,
677         uint    amount,
678         bytes   calldata extraData
679         )
680         external
681         payable;
682 
683     /// @dev Transfers tokens (ETH not supported) for a user using the allowance set
684     ///      for the exchange. This way the approval can be used for all functionality (and
685     ///      extended functionality) of the exchange.
686     ///      Should NOT be used to deposit/withdraw user funds, `deposit`/`withdraw`
687     ///      should be used for that as they will contain specialised logic for those operations.
688     ///      This function can be called by the exchange to transfer onchain funds of users
689     ///      necessary for Agent functionality.
690     ///
691     ///      This function needs to throw when an error occurred!
692     ///
693     ///      This function can only be called by the exchange.
694     ///
695     /// @param from The address of the account that sends the tokens.
696     /// @param to The address to which 'amount' tokens are transferred.
697     /// @param token The address of the token to transfer (ETH is and cannot be suppported).
698     /// @param amount The amount of tokens transferred.
699     function transfer(
700         address from,
701         address to,
702         address token,
703         uint    amount
704         )
705         external
706         payable;
707 
708     /// @dev Checks if the given address is used for depositing ETH or not.
709     ///      Is used while depositing to send the correct ETH amount to the deposit contract.
710     ///
711     ///      Note that 0x0 is always registered for deposting ETH when the exchange is created!
712     ///      This function allows additional addresses to be used for depositing ETH, the deposit
713     ///      contract can implement different behaviour based on the address value.
714     ///
715     /// @param addr The address to check
716     /// @return True if the address is used for depositing ETH, else false.
717     function isETH(address addr)
718         external
719         view
720         returns (bool);
721 }
722 
723 // File: contracts/core/iface/ILoopringV3.sol
724 
725 // Copyright 2017 Loopring Technology Limited.
726 
727 
728 
729 /// @title ILoopringV3
730 /// @author Brecht Devos - <brecht@loopring.org>
731 /// @author Daniel Wang  - <daniel@loopring.org>
732 abstract contract ILoopringV3 is Claimable
733 {
734     // == Events ==
735     event ExchangeStakeDeposited(address exchangeAddr, uint amount);
736     event ExchangeStakeWithdrawn(address exchangeAddr, uint amount);
737     event ExchangeStakeBurned(address exchangeAddr, uint amount);
738     event SettingsUpdated(uint time);
739 
740     // == Public Variables ==
741     mapping (address => uint) internal exchangeStake;
742 
743     uint    public totalStake;
744     address public blockVerifierAddress;
745     uint    public forcedWithdrawalFee;
746     uint    public tokenRegistrationFeeLRCBase;
747     uint    public tokenRegistrationFeeLRCDelta;
748     uint8   public protocolTakerFeeBips;
749     uint8   public protocolMakerFeeBips;
750 
751     address payable public protocolFeeVault;
752 
753     // == Public Functions ==
754 
755     /// @dev Returns the LRC token address
756     /// @return the LRC token address
757     function lrcAddress()
758         external
759         view
760         virtual
761         returns (address);
762 
763     /// @dev Updates the global exchange settings.
764     ///      This function can only be called by the owner of this contract.
765     ///
766     ///      Warning: these new values will be used by existing and
767     ///      new Loopring exchanges.
768     function updateSettings(
769         address payable _protocolFeeVault,   // address(0) not allowed
770         address _blockVerifierAddress,       // address(0) not allowed
771         uint    _forcedWithdrawalFee
772         )
773         external
774         virtual;
775 
776     /// @dev Updates the global protocol fee settings.
777     ///      This function can only be called by the owner of this contract.
778     ///
779     ///      Warning: these new values will be used by existing and
780     ///      new Loopring exchanges.
781     function updateProtocolFeeSettings(
782         uint8 _protocolTakerFeeBips,
783         uint8 _protocolMakerFeeBips
784         )
785         external
786         virtual;
787 
788     /// @dev Gets the amount of staked LRC for an exchange.
789     /// @param exchangeAddr The address of the exchange
790     /// @return stakedLRC The amount of LRC
791     function getExchangeStake(
792         address exchangeAddr
793         )
794         public
795         virtual
796         view
797         returns (uint stakedLRC);
798 
799     /// @dev Burns a certain amount of staked LRC for a specific exchange.
800     ///      This function is meant to be called only from exchange contracts.
801     /// @return burnedLRC The amount of LRC burned. If the amount is greater than
802     ///         the staked amount, all staked LRC will be burned.
803     function burnExchangeStake(
804         uint amount
805         )
806         external
807         virtual
808         returns (uint burnedLRC);
809 
810     /// @dev Stakes more LRC for an exchange.
811     /// @param  exchangeAddr The address of the exchange
812     /// @param  amountLRC The amount of LRC to stake
813     /// @return stakedLRC The total amount of LRC staked for the exchange
814     function depositExchangeStake(
815         address exchangeAddr,
816         uint    amountLRC
817         )
818         external
819         virtual
820         returns (uint stakedLRC);
821 
822     /// @dev Withdraws a certain amount of staked LRC for an exchange to the given address.
823     ///      This function is meant to be called only from within exchange contracts.
824     /// @param  recipient The address to receive LRC
825     /// @param  requestedAmount The amount of LRC to withdraw
826     /// @return amountLRC The amount of LRC withdrawn
827     function withdrawExchangeStake(
828         address recipient,
829         uint    requestedAmount
830         )
831         external
832         virtual
833         returns (uint amountLRC);
834 
835     /// @dev Gets the protocol fee values for an exchange.
836     /// @return takerFeeBips The protocol taker fee
837     /// @return makerFeeBips The protocol maker fee
838     function getProtocolFeeValues(
839         )
840         public
841         virtual
842         view
843         returns (
844             uint8 takerFeeBips,
845             uint8 makerFeeBips
846         );
847 }
848 
849 // File: contracts/core/iface/ExchangeData.sol
850 
851 // Copyright 2017 Loopring Technology Limited.
852 
853 
854 
855 
856 
857 
858 /// @title ExchangeData
859 /// @dev All methods in this lib are internal, therefore, there is no need
860 ///      to deploy this library independently.
861 /// @author Daniel Wang  - <daniel@loopring.org>
862 /// @author Brecht Devos - <brecht@loopring.org>
863 library ExchangeData
864 {
865     // -- Enums --
866     enum TransactionType
867     {
868         NOOP,
869         DEPOSIT,
870         WITHDRAWAL,
871         TRANSFER,
872         SPOT_TRADE,
873         ACCOUNT_UPDATE,
874         AMM_UPDATE,
875         SIGNATURE_VERIFICATION
876     }
877 
878     // -- Structs --
879     struct Token
880     {
881         address token;
882     }
883 
884     struct ProtocolFeeData
885     {
886         uint32 syncedAt; // only valid before 2105 (85 years to go)
887         uint8  takerFeeBips;
888         uint8  makerFeeBips;
889         uint8  previousTakerFeeBips;
890         uint8  previousMakerFeeBips;
891     }
892 
893     // General auxiliary data for each conditional transaction
894     struct AuxiliaryData
895     {
896         uint  txIndex;
897         bool  approved;
898         bytes data;
899     }
900 
901     // This is the (virtual) block the owner  needs to submit onchain to maintain the
902     // per-exchange (virtual) blockchain.
903     struct Block
904     {
905         uint8      blockType;
906         uint16     blockSize;
907         uint8      blockVersion;
908         bytes      data;
909         uint256[8] proof;
910 
911         // Whether we should store the @BlockInfo for this block on-chain.
912         bool storeBlockInfoOnchain;
913 
914         // Block specific data that is only used to help process the block on-chain.
915         // It is not used as input for the circuits and it is not necessary for data-availability.
916         AuxiliaryData[] auxiliaryData;
917 
918         // Arbitrary data, mainly for off-chain data-availability, i.e.,
919         // the multihash of the IPFS file that contains the block data.
920         bytes offchainData;
921     }
922 
923     struct BlockInfo
924     {
925         // The time the block was submitted on-chain.
926         uint32  timestamp;
927         // The public data hash of the block (the 28 most significant bytes).
928         bytes28 blockDataHash;
929     }
930 
931     // Represents an onchain deposit request.
932     struct Deposit
933     {
934         uint96 amount;
935         uint64 timestamp;
936     }
937 
938     // A forced withdrawal request.
939     // If the actual owner of the account initiated the request (we don't know who the owner is
940     // at the time the request is being made) the full balance will be withdrawn.
941     struct ForcedWithdrawal
942     {
943         address owner;
944         uint64  timestamp;
945     }
946 
947     struct Constants
948     {
949         uint SNARK_SCALAR_FIELD;
950         uint MAX_OPEN_FORCED_REQUESTS;
951         uint MAX_AGE_FORCED_REQUEST_UNTIL_WITHDRAW_MODE;
952         uint TIMESTAMP_HALF_WINDOW_SIZE_IN_SECONDS;
953         uint MAX_NUM_ACCOUNTS;
954         uint MAX_NUM_TOKENS;
955         uint MIN_AGE_PROTOCOL_FEES_UNTIL_UPDATED;
956         uint MIN_TIME_IN_SHUTDOWN;
957         uint TX_DATA_AVAILABILITY_SIZE;
958         uint MAX_AGE_DEPOSIT_UNTIL_WITHDRAWABLE_UPPERBOUND;
959     }
960 
961     function SNARK_SCALAR_FIELD() internal pure returns (uint) {
962         // This is the prime number that is used for the alt_bn128 elliptic curve, see EIP-196.
963         return 21888242871839275222246405745257275088548364400416034343698204186575808495617;
964     }
965     function MAX_OPEN_FORCED_REQUESTS() internal pure returns (uint16) { return 4096; }
966     function MAX_AGE_FORCED_REQUEST_UNTIL_WITHDRAW_MODE() internal pure returns (uint32) { return 15 days; }
967     function TIMESTAMP_HALF_WINDOW_SIZE_IN_SECONDS() internal pure returns (uint32) { return 7 days; }
968     function MAX_NUM_ACCOUNTS() internal pure returns (uint) { return 2 ** 32; }
969     function MAX_NUM_TOKENS() internal pure returns (uint) { return 2 ** 16; }
970     function MIN_AGE_PROTOCOL_FEES_UNTIL_UPDATED() internal pure returns (uint32) { return 7 days; }
971     function MIN_TIME_IN_SHUTDOWN() internal pure returns (uint32) { return 30 days; }
972     // The amount of bytes each rollup transaction uses in the block data for data-availability.
973     // This is the maximum amount of bytes of all different transaction types.
974     function TX_DATA_AVAILABILITY_SIZE() internal pure returns (uint32) { return 68; }
975     function MAX_AGE_DEPOSIT_UNTIL_WITHDRAWABLE_UPPERBOUND() internal pure returns (uint32) { return 15 days; }
976     function ACCOUNTID_PROTOCOLFEE() internal pure returns (uint32) { return 0; }
977 
978     function TX_DATA_AVAILABILITY_SIZE_PART_1() internal pure returns (uint32) { return 29; }
979     function TX_DATA_AVAILABILITY_SIZE_PART_2() internal pure returns (uint32) { return 39; }
980 
981     struct AccountLeaf
982     {
983         uint32   accountID;
984         address  owner;
985         uint     pubKeyX;
986         uint     pubKeyY;
987         uint32   nonce;
988         uint     feeBipsAMM;
989     }
990 
991     struct BalanceLeaf
992     {
993         uint16   tokenID;
994         uint96   balance;
995         uint96   weightAMM;
996         uint     storageRoot;
997     }
998 
999     struct MerkleProof
1000     {
1001         ExchangeData.AccountLeaf accountLeaf;
1002         ExchangeData.BalanceLeaf balanceLeaf;
1003         uint[48]                 accountMerkleProof;
1004         uint[24]                 balanceMerkleProof;
1005     }
1006 
1007     struct BlockContext
1008     {
1009         bytes32 DOMAIN_SEPARATOR;
1010         uint32  timestamp;
1011     }
1012 
1013     // Represents the entire exchange state except the owner of the exchange.
1014     struct State
1015     {
1016         uint32  maxAgeDepositUntilWithdrawable;
1017         bytes32 DOMAIN_SEPARATOR;
1018 
1019         ILoopringV3      loopring;
1020         IBlockVerifier   blockVerifier;
1021         IAgentRegistry   agentRegistry;
1022         IDepositContract depositContract;
1023 
1024 
1025         // The merkle root of the offchain data stored in a Merkle tree. The Merkle tree
1026         // stores balances for users using an account model.
1027         bytes32 merkleRoot;
1028 
1029         // List of all blocks
1030         mapping(uint => BlockInfo) blocks;
1031         uint  numBlocks;
1032 
1033         // List of all tokens
1034         Token[] tokens;
1035 
1036         // A map from a token to its tokenID + 1
1037         mapping (address => uint16) tokenToTokenId;
1038 
1039         // A map from an accountID to a tokenID to if the balance is withdrawn
1040         mapping (uint32 => mapping (uint16 => bool)) withdrawnInWithdrawMode;
1041 
1042         // A map from an account to a token to the amount withdrawable for that account.
1043         // This is only used when the automatic distribution of the withdrawal failed.
1044         mapping (address => mapping (uint16 => uint)) amountWithdrawable;
1045 
1046         // A map from an account to a token to the forced withdrawal (always full balance)
1047         mapping (uint32 => mapping (uint16 => ForcedWithdrawal)) pendingForcedWithdrawals;
1048 
1049         // A map from an address to a token to a deposit
1050         mapping (address => mapping (uint16 => Deposit)) pendingDeposits;
1051 
1052         // A map from an account owner to an approved transaction hash to if the transaction is approved or not
1053         mapping (address => mapping (bytes32 => bool)) approvedTx;
1054 
1055         // A map from an account owner to a destination address to a tokenID to an amount to a storageID to a new recipient address
1056         mapping (address => mapping (address => mapping (uint16 => mapping (uint => mapping (uint32 => address))))) withdrawalRecipient;
1057 
1058 
1059         // Counter to keep track of how many of forced requests are open so we can limit the work that needs to be done by the owner
1060         uint32 numPendingForcedTransactions;
1061 
1062         // Cached data for the protocol fee
1063         ProtocolFeeData protocolFeeData;
1064 
1065         // Time when the exchange was shutdown
1066         uint shutdownModeStartTime;
1067 
1068         // Time when the exchange has entered withdrawal mode
1069         uint withdrawalModeStartTime;
1070 
1071         // Last time the protocol fee was withdrawn for a specific token
1072         mapping (address => uint) protocolFeeLastWithdrawnTime;
1073     }
1074 }
1075 
1076 // File: contracts/core/impl/libtransactions/BlockReader.sol
1077 
1078 // Copyright 2017 Loopring Technology Limited.
1079 
1080 
1081 
1082 /// @title BlockReader
1083 /// @author Brecht Devos - <brecht@loopring.org>
1084 /// @dev Utility library to read block data.
1085 library BlockReader {
1086     using BlockReader       for ExchangeData.Block;
1087     using BytesUtil         for bytes;
1088 
1089     uint public constant OFFSET_TO_TRANSACTIONS = 20 + 32 + 32 + 4 + 1 + 1 + 4 + 4;
1090 
1091     struct BlockHeader
1092     {
1093         address exchange;
1094         bytes32 merkleRootBefore;
1095         bytes32 merkleRootAfter;
1096         uint32  timestamp;
1097         uint8   protocolTakerFeeBips;
1098         uint8   protocolMakerFeeBips;
1099         uint32  numConditionalTransactions;
1100         uint32  operatorAccountID;
1101     }
1102 
1103     function readHeader(
1104         ExchangeData.Block memory _block
1105         )
1106         internal
1107         pure
1108         returns (BlockHeader memory header)
1109     {
1110         uint offset = 0;
1111         header.exchange = _block.data.toAddress(offset);
1112         offset += 20;
1113         header.merkleRootBefore = _block.data.toBytes32(offset);
1114         offset += 32;
1115         header.merkleRootAfter = _block.data.toBytes32(offset);
1116         offset += 32;
1117         header.timestamp = _block.data.toUint32(offset);
1118         offset += 4;
1119         header.protocolTakerFeeBips = _block.data.toUint8(offset);
1120         offset += 1;
1121         header.protocolMakerFeeBips = _block.data.toUint8(offset);
1122         offset += 1;
1123         header.numConditionalTransactions = _block.data.toUint32(offset);
1124         offset += 4;
1125         header.operatorAccountID = _block.data.toUint32(offset);
1126         offset += 4;
1127         assert(offset == OFFSET_TO_TRANSACTIONS);
1128     }
1129 
1130     function readTransactionData(
1131         ExchangeData.Block memory _block,
1132         uint txIdx
1133         )
1134         internal
1135         pure
1136         returns (bytes memory)
1137     {
1138         require(txIdx < _block.blockSize, "INVALID_TX_IDX");
1139 
1140         bytes memory data = _block.data;
1141 
1142         // The transaction was transformed to make it easier to compress.
1143         // Transform it back here.
1144         bytes memory txData = new bytes(ExchangeData.TX_DATA_AVAILABILITY_SIZE());
1145         // Part 1
1146         uint txDataOffset = OFFSET_TO_TRANSACTIONS +
1147             txIdx * ExchangeData.TX_DATA_AVAILABILITY_SIZE_PART_1();
1148         assembly {
1149             mstore(add(txData, 32), mload(add(data, add(txDataOffset, 32))))
1150         }
1151         // Part 2
1152         txDataOffset = OFFSET_TO_TRANSACTIONS +
1153             _block.blockSize * ExchangeData.TX_DATA_AVAILABILITY_SIZE_PART_1() +
1154             txIdx * ExchangeData.TX_DATA_AVAILABILITY_SIZE_PART_2();
1155         assembly {
1156             mstore(add(txData, 61 /*32 + 29*/), mload(add(data, add(txDataOffset, 32))))
1157             mstore(add(txData, 68            ), mload(add(data, add(txDataOffset, 39))))
1158         }
1159         return txData;
1160     }
1161 }
1162 
1163 // File: contracts/lib/EIP712.sol
1164 
1165 // Copyright 2017 Loopring Technology Limited.
1166 
1167 
1168 library EIP712
1169 {
1170     struct Domain {
1171         string  name;
1172         string  version;
1173         address verifyingContract;
1174     }
1175 
1176     bytes32 constant internal EIP712_DOMAIN_TYPEHASH = keccak256(
1177         "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1178     );
1179 
1180     string constant internal EIP191_HEADER = "\x19\x01";
1181 
1182     function hash(Domain memory domain)
1183         internal
1184         pure
1185         returns (bytes32)
1186     {
1187         uint _chainid;
1188         assembly { _chainid := chainid() }
1189 
1190         return keccak256(
1191             abi.encode(
1192                 EIP712_DOMAIN_TYPEHASH,
1193                 keccak256(bytes(domain.name)),
1194                 keccak256(bytes(domain.version)),
1195                 _chainid,
1196                 domain.verifyingContract
1197             )
1198         );
1199     }
1200 
1201     function hashPacked(
1202         bytes32 domainHash,
1203         bytes32 dataHash
1204         )
1205         internal
1206         pure
1207         returns (bytes32)
1208     {
1209         return keccak256(
1210             abi.encodePacked(
1211                 EIP191_HEADER,
1212                 domainHash,
1213                 dataHash
1214             )
1215         );
1216     }
1217 }
1218 
1219 // File: contracts/lib/MathUint.sol
1220 
1221 // Copyright 2017 Loopring Technology Limited.
1222 
1223 
1224 /// @title Utility Functions for uint
1225 /// @author Daniel Wang - <daniel@loopring.org>
1226 library MathUint
1227 {
1228     using MathUint for uint;
1229 
1230     function mul(
1231         uint a,
1232         uint b
1233         )
1234         internal
1235         pure
1236         returns (uint c)
1237     {
1238         c = a * b;
1239         require(a == 0 || c / a == b, "MUL_OVERFLOW");
1240     }
1241 
1242     function sub(
1243         uint a,
1244         uint b
1245         )
1246         internal
1247         pure
1248         returns (uint)
1249     {
1250         require(b <= a, "SUB_UNDERFLOW");
1251         return a - b;
1252     }
1253 
1254     function add(
1255         uint a,
1256         uint b
1257         )
1258         internal
1259         pure
1260         returns (uint c)
1261     {
1262         c = a + b;
1263         require(c >= a, "ADD_OVERFLOW");
1264     }
1265 
1266     function add64(
1267         uint64 a,
1268         uint64 b
1269         )
1270         internal
1271         pure
1272         returns (uint64 c)
1273     {
1274         c = a + b;
1275         require(c >= a, "ADD_OVERFLOW");
1276     }
1277 }
1278 
1279 // File: contracts/lib/AddressUtil.sol
1280 
1281 // Copyright 2017 Loopring Technology Limited.
1282 
1283 
1284 /// @title Utility Functions for addresses
1285 /// @author Daniel Wang - <daniel@loopring.org>
1286 /// @author Brecht Devos - <brecht@loopring.org>
1287 library AddressUtil
1288 {
1289     using AddressUtil for *;
1290 
1291     function isContract(
1292         address addr
1293         )
1294         internal
1295         view
1296         returns (bool)
1297     {
1298         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
1299         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
1300         // for accounts without code, i.e. `keccak256('')`
1301         bytes32 codehash;
1302         // solhint-disable-next-line no-inline-assembly
1303         assembly { codehash := extcodehash(addr) }
1304         return (codehash != 0x0 &&
1305                 codehash != 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470);
1306     }
1307 
1308     function toPayable(
1309         address addr
1310         )
1311         internal
1312         pure
1313         returns (address payable)
1314     {
1315         return payable(addr);
1316     }
1317 
1318     // Works like address.send but with a customizable gas limit
1319     // Make sure your code is safe for reentrancy when using this function!
1320     function sendETH(
1321         address to,
1322         uint    amount,
1323         uint    gasLimit
1324         )
1325         internal
1326         returns (bool success)
1327     {
1328         if (amount == 0) {
1329             return true;
1330         }
1331         address payable recipient = to.toPayable();
1332         /* solium-disable-next-line */
1333         (success, ) = recipient.call{value: amount, gas: gasLimit}("");
1334     }
1335 
1336     // Works like address.transfer but with a customizable gas limit
1337     // Make sure your code is safe for reentrancy when using this function!
1338     function sendETHAndVerify(
1339         address to,
1340         uint    amount,
1341         uint    gasLimit
1342         )
1343         internal
1344         returns (bool success)
1345     {
1346         success = to.sendETH(amount, gasLimit);
1347         require(success, "TRANSFER_FAILURE");
1348     }
1349 
1350     // Works like call but is slightly more efficient when data
1351     // needs to be copied from memory to do the call.
1352     function fastCall(
1353         address to,
1354         uint    gasLimit,
1355         uint    value,
1356         bytes   memory data
1357         )
1358         internal
1359         returns (bool success, bytes memory returnData)
1360     {
1361         if (to != address(0)) {
1362             assembly {
1363                 // Do the call
1364                 success := call(gasLimit, to, value, add(data, 32), mload(data), 0, 0)
1365                 // Copy the return data
1366                 let size := returndatasize()
1367                 returnData := mload(0x40)
1368                 mstore(returnData, size)
1369                 returndatacopy(add(returnData, 32), 0, size)
1370                 // Update free memory pointer
1371                 mstore(0x40, add(returnData, add(32, size)))
1372             }
1373         }
1374     }
1375 
1376     // Like fastCall, but throws when the call is unsuccessful.
1377     function fastCallAndVerify(
1378         address to,
1379         uint    gasLimit,
1380         uint    value,
1381         bytes   memory data
1382         )
1383         internal
1384         returns (bytes memory returnData)
1385     {
1386         bool success;
1387         (success, returnData) = fastCall(to, gasLimit, value, data);
1388         if (!success) {
1389             assembly {
1390                 revert(add(returnData, 32), mload(returnData))
1391             }
1392         }
1393     }
1394 }
1395 
1396 // File: contracts/lib/ERC1271.sol
1397 
1398 // Copyright 2017 Loopring Technology Limited.
1399 
1400 abstract contract ERC1271 {
1401     // bytes4(keccak256("isValidSignature(bytes32,bytes)")
1402     bytes4 constant internal ERC1271_MAGICVALUE = 0x1626ba7e;
1403 
1404     function isValidSignature(
1405         bytes32      _hash,
1406         bytes memory _signature)
1407         public
1408         view
1409         virtual
1410         returns (bytes4 magicValueB32);
1411 
1412 }
1413 
1414 // File: contracts/lib/SignatureUtil.sol
1415 
1416 // Copyright 2017 Loopring Technology Limited.
1417 
1418 
1419 
1420 
1421 
1422 
1423 /// @title SignatureUtil
1424 /// @author Daniel Wang - <daniel@loopring.org>
1425 /// @dev This method supports multihash standard. Each signature's last byte indicates
1426 ///      the signature's type.
1427 library SignatureUtil
1428 {
1429     using BytesUtil     for bytes;
1430     using MathUint      for uint;
1431     using AddressUtil   for address;
1432 
1433     enum SignatureType {
1434         ILLEGAL,
1435         INVALID,
1436         EIP_712,
1437         ETH_SIGN,
1438         WALLET   // deprecated
1439     }
1440 
1441     bytes4 constant internal ERC1271_MAGICVALUE = 0x1626ba7e;
1442 
1443     function verifySignatures(
1444         bytes32          signHash,
1445         address[] memory signers,
1446         bytes[]   memory signatures
1447         )
1448         internal
1449         view
1450         returns (bool)
1451     {
1452         require(signers.length == signatures.length, "BAD_SIGNATURE_DATA");
1453         address lastSigner;
1454         for (uint i = 0; i < signers.length; i++) {
1455             require(signers[i] > lastSigner, "INVALID_SIGNERS_ORDER");
1456             lastSigner = signers[i];
1457             if (!verifySignature(signHash, signers[i], signatures[i])) {
1458                 return false;
1459             }
1460         }
1461         return true;
1462     }
1463 
1464     function verifySignature(
1465         bytes32        signHash,
1466         address        signer,
1467         bytes   memory signature
1468         )
1469         internal
1470         view
1471         returns (bool)
1472     {
1473         if (signer == address(0)) {
1474             return false;
1475         }
1476 
1477         return signer.isContract()?
1478             verifyERC1271Signature(signHash, signer, signature):
1479             verifyEOASignature(signHash, signer, signature);
1480     }
1481 
1482     function recoverECDSASigner(
1483         bytes32      signHash,
1484         bytes memory signature
1485         )
1486         internal
1487         pure
1488         returns (address)
1489     {
1490         if (signature.length != 65) {
1491             return address(0);
1492         }
1493 
1494         bytes32 r;
1495         bytes32 s;
1496         uint8   v;
1497         // we jump 32 (0x20) as the first slot of bytes contains the length
1498         // we jump 65 (0x41) per signature
1499         // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
1500         assembly {
1501             r := mload(add(signature, 0x20))
1502             s := mload(add(signature, 0x40))
1503             v := and(mload(add(signature, 0x41)), 0xff)
1504         }
1505         // See https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/cryptography/ECDSA.sol
1506         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1507             return address(0);
1508         }
1509         if (v == 27 || v == 28) {
1510             return ecrecover(signHash, v, r, s);
1511         } else {
1512             return address(0);
1513         }
1514     }
1515 
1516     function verifyEOASignature(
1517         bytes32        signHash,
1518         address        signer,
1519         bytes   memory signature
1520         )
1521         private
1522         pure
1523         returns (bool success)
1524     {
1525         if (signer == address(0)) {
1526             return false;
1527         }
1528 
1529         uint signatureTypeOffset = signature.length.sub(1);
1530         SignatureType signatureType = SignatureType(signature.toUint8(signatureTypeOffset));
1531 
1532         // Strip off the last byte of the signature by updating the length
1533         assembly {
1534             mstore(signature, signatureTypeOffset)
1535         }
1536 
1537         if (signatureType == SignatureType.EIP_712) {
1538             success = (signer == recoverECDSASigner(signHash, signature));
1539         } else if (signatureType == SignatureType.ETH_SIGN) {
1540             bytes32 hash = keccak256(
1541                 abi.encodePacked("\x19Ethereum Signed Message:\n32", signHash)
1542             );
1543             success = (signer == recoverECDSASigner(hash, signature));
1544         } else {
1545             success = false;
1546         }
1547 
1548         // Restore the signature length
1549         assembly {
1550             mstore(signature, add(signatureTypeOffset, 1))
1551         }
1552 
1553         return success;
1554     }
1555 
1556     function verifyERC1271Signature(
1557         bytes32 signHash,
1558         address signer,
1559         bytes   memory signature
1560         )
1561         private
1562         view
1563         returns (bool)
1564     {
1565         bytes memory callData = abi.encodeWithSelector(
1566             ERC1271.isValidSignature.selector,
1567             signHash,
1568             signature
1569         );
1570         (bool success, bytes memory result) = signer.staticcall(callData);
1571         return (
1572             success &&
1573             result.length == 32 &&
1574             result.toBytes4(0) == ERC1271_MAGICVALUE
1575         );
1576     }
1577 }
1578 
1579 // File: contracts/core/impl/libexchange/ExchangeSignatures.sol
1580 
1581 // Copyright 2017 Loopring Technology Limited.
1582 
1583 
1584 
1585 
1586 /// @title ExchangeSignatures.
1587 /// @dev All methods in this lib are internal, therefore, there is no need
1588 ///      to deploy this library independently.
1589 /// @author Brecht Devos - <brecht@loopring.org>
1590 /// @author Daniel Wang  - <daniel@loopring.org>
1591 library ExchangeSignatures
1592 {
1593     using SignatureUtil for bytes32;
1594 
1595     function requireAuthorizedTx(
1596         ExchangeData.State storage S,
1597         address signer,
1598         bytes memory signature,
1599         bytes32 txHash
1600         )
1601         internal // inline call
1602     {
1603         require(signer != address(0), "INVALID_SIGNER");
1604         // Verify the signature if one is provided, otherwise fall back to an approved tx
1605         if (signature.length > 0) {
1606             require(txHash.verifySignature(signer, signature), "INVALID_SIGNATURE");
1607         } else {
1608             require(S.approvedTx[signer][txHash], "TX_NOT_APPROVED");
1609             delete S.approvedTx[signer][txHash];
1610         }
1611     }
1612 }
1613 
1614 // File: contracts/core/impl/libtransactions/AmmUpdateTransaction.sol
1615 
1616 // Copyright 2017 Loopring Technology Limited.
1617 
1618 
1619 
1620 
1621 
1622 
1623 
1624 
1625 /// @title AmmUpdateTransaction
1626 /// @author Brecht Devos - <brecht@loopring.org>
1627 library AmmUpdateTransaction
1628 {
1629     using BytesUtil            for bytes;
1630     using MathUint             for uint;
1631     using ExchangeSignatures   for ExchangeData.State;
1632 
1633     bytes32 constant public AMMUPDATE_TYPEHASH = keccak256(
1634         "AmmUpdate(address owner,uint32 accountID,uint16 tokenID,uint8 feeBips,uint96 tokenWeight,uint32 validUntil,uint32 nonce)"
1635     );
1636 
1637     struct AmmUpdate
1638     {
1639         address owner;
1640         uint32  accountID;
1641         uint16  tokenID;
1642         uint8   feeBips;
1643         uint96  tokenWeight;
1644         uint32  validUntil;
1645         uint32  nonce;
1646         uint96  balance;
1647     }
1648 
1649     // Auxiliary data for each AMM update
1650     struct AmmUpdateAuxiliaryData
1651     {
1652         bytes  signature;
1653         uint32 validUntil;
1654     }
1655 
1656     function process(
1657         ExchangeData.State        storage S,
1658         ExchangeData.BlockContext memory  ctx,
1659         bytes                     memory  data,
1660         uint                              offset,
1661         bytes                     memory  auxiliaryData
1662         )
1663         internal
1664     {
1665         // Read in the AMM update
1666         AmmUpdate memory update = readTx(data, offset);
1667         AmmUpdateAuxiliaryData memory auxData = abi.decode(auxiliaryData, (AmmUpdateAuxiliaryData));
1668 
1669         // Check validUntil
1670         require(ctx.timestamp < auxData.validUntil, "AMM_UPDATE_EXPIRED");
1671         update.validUntil = auxData.validUntil;
1672 
1673         // Calculate the tx hash
1674         bytes32 txHash = hashTx(ctx.DOMAIN_SEPARATOR, update);
1675 
1676         // Check the on-chain authorization
1677         S.requireAuthorizedTx(update.owner, auxData.signature, txHash);
1678     }
1679 
1680     function readTx(
1681         bytes memory data,
1682         uint         offset
1683         )
1684         internal
1685         pure
1686         returns (AmmUpdate memory update)
1687     {
1688         uint _offset = offset;
1689         // We don't use abi.decode for this because of the large amount of zero-padding
1690         // bytes the circuit would also have to hash.
1691         update.owner = data.toAddress(_offset);
1692         _offset += 20;
1693         update.accountID = data.toUint32(_offset);
1694         _offset += 4;
1695         update.tokenID = data.toUint16(_offset);
1696         _offset += 2;
1697         update.feeBips = data.toUint8(_offset);
1698         _offset += 1;
1699         update.tokenWeight = data.toUint96(_offset);
1700         _offset += 12;
1701         update.nonce = data.toUint32(_offset);
1702         _offset += 4;
1703         update.balance = data.toUint96(_offset);
1704         _offset += 12;
1705     }
1706 
1707     function hashTx(
1708         bytes32 DOMAIN_SEPARATOR,
1709         AmmUpdate memory update
1710         )
1711         internal
1712         pure
1713         returns (bytes32)
1714     {
1715         return EIP712.hashPacked(
1716             DOMAIN_SEPARATOR,
1717             keccak256(
1718                 abi.encode(
1719                     AMMUPDATE_TYPEHASH,
1720                     update.owner,
1721                     update.accountID,
1722                     update.tokenID,
1723                     update.feeBips,
1724                     update.tokenWeight,
1725                     update.validUntil,
1726                     update.nonce
1727                 )
1728             )
1729         );
1730     }
1731 }
1732 
1733 // File: contracts/lib/MathUint96.sol
1734 
1735 // Copyright 2017 Loopring Technology Limited.
1736 
1737 
1738 /// @title Utility Functions for uint
1739 /// @author Daniel Wang - <daniel@loopring.org>
1740 library MathUint96
1741 {
1742     function add(
1743         uint96 a,
1744         uint96 b
1745         )
1746         internal
1747         pure
1748         returns (uint96 c)
1749     {
1750         c = a + b;
1751         require(c >= a, "ADD_OVERFLOW");
1752     }
1753 
1754     function sub(
1755         uint96 a,
1756         uint96 b
1757         )
1758         internal
1759         pure
1760         returns (uint96 c)
1761     {
1762         require(b <= a, "SUB_UNDERFLOW");
1763         return a - b;
1764     }
1765 }
1766 
1767 // File: contracts/core/impl/libtransactions/DepositTransaction.sol
1768 
1769 // Copyright 2017 Loopring Technology Limited.
1770 
1771 
1772 
1773 
1774 
1775 
1776 
1777 /// @title DepositTransaction
1778 /// @author Brecht Devos - <brecht@loopring.org>
1779 library DepositTransaction
1780 {
1781     using BytesUtil   for bytes;
1782     using MathUint96  for uint96;
1783 
1784     struct Deposit
1785     {
1786         address to;
1787         uint32  toAccountID;
1788         uint16  tokenID;
1789         uint96  amount;
1790     }
1791 
1792     function process(
1793         ExchangeData.State        storage S,
1794         ExchangeData.BlockContext memory  /*ctx*/,
1795         bytes                     memory  data,
1796         uint                              offset,
1797         bytes                     memory  /*auxiliaryData*/
1798         )
1799         internal
1800     {
1801         // Read in the deposit
1802         Deposit memory deposit = readTx(data, offset);
1803         if (deposit.amount == 0) {
1804             return;
1805         }
1806 
1807         // Process the deposit
1808         ExchangeData.Deposit memory pendingDeposit = S.pendingDeposits[deposit.to][deposit.tokenID];
1809         // Make sure the deposit was actually done
1810         require(pendingDeposit.timestamp > 0, "DEPOSIT_DOESNT_EXIST");
1811 
1812         // Processing partial amounts of the deposited amount is allowed.
1813         // This is done to ensure the user can do multiple deposits after each other
1814         // without invalidating work done by the exchange owner for previous deposit amounts.
1815 
1816         require(pendingDeposit.amount >= deposit.amount, "INVALID_AMOUNT");
1817         pendingDeposit.amount = pendingDeposit.amount.sub(deposit.amount);
1818 
1819         // If the deposit was fully consumed, reset it so the storage is freed up
1820         // and the owner receives a gas refund.
1821         if (pendingDeposit.amount == 0) {
1822             delete S.pendingDeposits[deposit.to][deposit.tokenID];
1823         } else {
1824             S.pendingDeposits[deposit.to][deposit.tokenID] = pendingDeposit;
1825         }
1826     }
1827 
1828     function readTx(
1829         bytes memory data,
1830         uint         offset
1831         )
1832         internal
1833         pure
1834         returns (Deposit memory deposit)
1835     {
1836         uint _offset = offset;
1837         // We don't use abi.decode for this because of the large amount of zero-padding
1838         // bytes the circuit would also have to hash.
1839         deposit.to = data.toAddress(_offset);
1840         _offset += 20;
1841         deposit.toAccountID = data.toUint32(_offset);
1842         _offset += 4;
1843         deposit.tokenID = data.toUint16(_offset);
1844         _offset += 2;
1845         deposit.amount = data.toUint96(_offset);
1846         _offset += 12;
1847     }
1848 }
1849 
1850 // File: contracts/core/impl/libtransactions/SignatureVerificationTransaction.sol
1851 
1852 // Copyright 2017 Loopring Technology Limited.
1853 
1854 
1855 
1856 
1857 
1858 
1859 
1860 /// @title SignatureVerificationTransaction
1861 /// @author Brecht Devos - <brecht@loopring.org>
1862 library SignatureVerificationTransaction
1863 {
1864     using BytesUtil            for bytes;
1865     using MathUint             for uint;
1866 
1867     struct SignatureVerification
1868     {
1869         address owner;
1870         uint32  accountID;
1871         uint256 data;
1872     }
1873 
1874     function readTx(
1875         bytes memory data,
1876         uint         offset
1877         )
1878         internal
1879         pure
1880         returns (SignatureVerification memory verification)
1881     {
1882         uint _offset = offset;
1883         // We don't use abi.decode for this because of the large amount of zero-padding
1884         // bytes the circuit would also have to hash.
1885         verification.owner = data.toAddress(_offset);
1886         _offset += 20;
1887         verification.accountID = data.toUint32(_offset);
1888         _offset += 4;
1889         verification.data = data.toUint(_offset);
1890         _offset += 32;
1891     }
1892 }
1893 
1894 // File: contracts/thirdparty/SafeCast.sol
1895 
1896 // Taken from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/SafeCast.sol
1897 
1898 
1899 
1900 /**
1901  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
1902  * checks.
1903  *
1904  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
1905  * easily result in undesired exploitation or bugs, since developers usually
1906  * assume that overflows raise errors. `SafeCast` restores this intuition by
1907  * reverting the transaction when such an operation overflows.
1908  *
1909  * Using this library instead of the unchecked operations eliminates an entire
1910  * class of bugs, so it's recommended to use it always.
1911  *
1912  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
1913  * all math on `uint256` and `int256` and then downcasting.
1914  */
1915 library SafeCast {
1916 
1917     /**
1918      * @dev Returns the downcasted uint128 from uint256, reverting on
1919      * overflow (when the input is greater than largest uint128).
1920      *
1921      * Counterpart to Solidity's `uint128` operator.
1922      *
1923      * Requirements:
1924      *
1925      * - input must fit into 128 bits
1926      */
1927     function toUint128(uint256 value) internal pure returns (uint128) {
1928         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
1929         return uint128(value);
1930     }
1931 
1932     /**
1933      * @dev Returns the downcasted uint96 from uint256, reverting on
1934      * overflow (when the input is greater than largest uint96).
1935      *
1936      * Counterpart to Solidity's `uint96` operator.
1937      *
1938      * Requirements:
1939      *
1940      * - input must fit into 96 bits
1941      */
1942     function toUint96(uint256 value) internal pure returns (uint96) {
1943         require(value < 2**96, "SafeCast: value doesn\'t fit in 96 bits");
1944         return uint96(value);
1945     }
1946 
1947     /**
1948      * @dev Returns the downcasted uint64 from uint256, reverting on
1949      * overflow (when the input is greater than largest uint64).
1950      *
1951      * Counterpart to Solidity's `uint64` operator.
1952      *
1953      * Requirements:
1954      *
1955      * - input must fit into 64 bits
1956      */
1957     function toUint64(uint256 value) internal pure returns (uint64) {
1958         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
1959         return uint64(value);
1960     }
1961 
1962     /**
1963      * @dev Returns the downcasted uint32 from uint256, reverting on
1964      * overflow (when the input is greater than largest uint32).
1965      *
1966      * Counterpart to Solidity's `uint32` operator.
1967      *
1968      * Requirements:
1969      *
1970      * - input must fit into 32 bits
1971      */
1972     function toUint32(uint256 value) internal pure returns (uint32) {
1973         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
1974         return uint32(value);
1975     }
1976 
1977     /**
1978      * @dev Returns the downcasted uint40 from uint256, reverting on
1979      * overflow (when the input is greater than largest uint40).
1980      *
1981      * Counterpart to Solidity's `uint32` operator.
1982      *
1983      * Requirements:
1984      *
1985      * - input must fit into 40 bits
1986      */
1987     function toUint40(uint256 value) internal pure returns (uint40) {
1988         require(value < 2**40, "SafeCast: value doesn\'t fit in 40 bits");
1989         return uint40(value);
1990     }
1991 
1992     /**
1993      * @dev Returns the downcasted uint16 from uint256, reverting on
1994      * overflow (when the input is greater than largest uint16).
1995      *
1996      * Counterpart to Solidity's `uint16` operator.
1997      *
1998      * Requirements:
1999      *
2000      * - input must fit into 16 bits
2001      */
2002     function toUint16(uint256 value) internal pure returns (uint16) {
2003         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
2004         return uint16(value);
2005     }
2006 
2007     /**
2008      * @dev Returns the downcasted uint8 from uint256, reverting on
2009      * overflow (when the input is greater than largest uint8).
2010      *
2011      * Counterpart to Solidity's `uint8` operator.
2012      *
2013      * Requirements:
2014      *
2015      * - input must fit into 8 bits.
2016      */
2017     function toUint8(uint256 value) internal pure returns (uint8) {
2018         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
2019         return uint8(value);
2020     }
2021 
2022     /**
2023      * @dev Converts a signed int256 into an unsigned uint256.
2024      *
2025      * Requirements:
2026      *
2027      * - input must be greater than or equal to 0.
2028      */
2029     function toUint256(int256 value) internal pure returns (uint256) {
2030         require(value >= 0, "SafeCast: value must be positive");
2031         return uint256(value);
2032     }
2033 
2034     /**
2035      * @dev Returns the downcasted int128 from int256, reverting on
2036      * overflow (when the input is less than smallest int128 or
2037      * greater than largest int128).
2038      *
2039      * Counterpart to Solidity's `int128` operator.
2040      *
2041      * Requirements:
2042      *
2043      * - input must fit into 128 bits
2044      *
2045      * _Available since v3.1._
2046      */
2047     function toInt128(int256 value) internal pure returns (int128) {
2048         require(value >= -2**127 && value < 2**127, "SafeCast: value doesn\'t fit in 128 bits");
2049         return int128(value);
2050     }
2051 
2052     /**
2053      * @dev Returns the downcasted int64 from int256, reverting on
2054      * overflow (when the input is less than smallest int64 or
2055      * greater than largest int64).
2056      *
2057      * Counterpart to Solidity's `int64` operator.
2058      *
2059      * Requirements:
2060      *
2061      * - input must fit into 64 bits
2062      *
2063      * _Available since v3.1._
2064      */
2065     function toInt64(int256 value) internal pure returns (int64) {
2066         require(value >= -2**63 && value < 2**63, "SafeCast: value doesn\'t fit in 64 bits");
2067         return int64(value);
2068     }
2069 
2070     /**
2071      * @dev Returns the downcasted int32 from int256, reverting on
2072      * overflow (when the input is less than smallest int32 or
2073      * greater than largest int32).
2074      *
2075      * Counterpart to Solidity's `int32` operator.
2076      *
2077      * Requirements:
2078      *
2079      * - input must fit into 32 bits
2080      *
2081      * _Available since v3.1._
2082      */
2083     function toInt32(int256 value) internal pure returns (int32) {
2084         require(value >= -2**31 && value < 2**31, "SafeCast: value doesn\'t fit in 32 bits");
2085         return int32(value);
2086     }
2087 
2088     /**
2089      * @dev Returns the downcasted int16 from int256, reverting on
2090      * overflow (when the input is less than smallest int16 or
2091      * greater than largest int16).
2092      *
2093      * Counterpart to Solidity's `int16` operator.
2094      *
2095      * Requirements:
2096      *
2097      * - input must fit into 16 bits
2098      *
2099      * _Available since v3.1._
2100      */
2101     function toInt16(int256 value) internal pure returns (int16) {
2102         require(value >= -2**15 && value < 2**15, "SafeCast: value doesn\'t fit in 16 bits");
2103         return int16(value);
2104     }
2105 
2106     /**
2107      * @dev Returns the downcasted int8 from int256, reverting on
2108      * overflow (when the input is less than smallest int8 or
2109      * greater than largest int8).
2110      *
2111      * Counterpart to Solidity's `int8` operator.
2112      *
2113      * Requirements:
2114      *
2115      * - input must fit into 8 bits.
2116      *
2117      * _Available since v3.1._
2118      */
2119     function toInt8(int256 value) internal pure returns (int8) {
2120         require(value >= -2**7 && value < 2**7, "SafeCast: value doesn\'t fit in 8 bits");
2121         return int8(value);
2122     }
2123 
2124     /**
2125      * @dev Converts an unsigned uint256 into a signed int256.
2126      *
2127      * Requirements:
2128      *
2129      * - input must be less than or equal to maxInt256.
2130      */
2131     function toInt256(uint256 value) internal pure returns (int256) {
2132         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
2133         return int256(value);
2134     }
2135 }
2136 
2137 // File: contracts/lib/FloatUtil.sol
2138 
2139 // Copyright 2017 Loopring Technology Limited.
2140 
2141 
2142 
2143 
2144 /// @title Utility Functions for floats
2145 /// @author Brecht Devos - <brecht@loopring.org>
2146 library FloatUtil
2147 {
2148     using MathUint for uint;
2149     using SafeCast for uint;
2150 
2151     // Decodes a decimal float value that is encoded like `exponent | mantissa`.
2152     // Both exponent and mantissa are in base 10.
2153     // Decoding to an integer is as simple as `mantissa * (10 ** exponent)`
2154     // Will throw when the decoded value overflows an uint96
2155     /// @param f The float value with 5 bits for the exponent
2156     /// @param numBits The total number of bits (numBitsMantissa := numBits - numBitsExponent)
2157     /// @return value The decoded integer value.
2158     function decodeFloat(
2159         uint f,
2160         uint numBits
2161         )
2162         internal
2163         pure
2164         returns (uint96 value)
2165     {
2166         uint numBitsMantissa = numBits.sub(5);
2167         uint exponent = f >> numBitsMantissa;
2168         // log2(10**77) = 255.79 < 256
2169         require(exponent <= 77, "EXPONENT_TOO_LARGE");
2170         uint mantissa = f & ((1 << numBitsMantissa) - 1);
2171         value = mantissa.mul(10 ** exponent).toUint96();
2172     }
2173 }
2174 
2175 // File: contracts/core/impl/libtransactions/TransferTransaction.sol
2176 
2177 // Copyright 2017 Loopring Technology Limited.
2178 
2179 
2180 
2181 
2182 
2183 
2184 
2185 
2186 /// @title TransferTransaction
2187 /// @author Brecht Devos - <brecht@loopring.org>
2188 library TransferTransaction
2189 {
2190     using BytesUtil            for bytes;
2191     using FloatUtil            for uint;
2192     using MathUint             for uint;
2193     using ExchangeSignatures   for ExchangeData.State;
2194 
2195     bytes32 constant public TRANSFER_TYPEHASH = keccak256(
2196         "Transfer(address from,address to,uint16 tokenID,uint96 amount,uint16 feeTokenID,uint96 maxFee,uint32 validUntil,uint32 storageID)"
2197     );
2198 
2199     struct Transfer
2200     {
2201         uint32  fromAccountID;
2202         uint32  toAccountID;
2203         address from;
2204         address to;
2205         uint16  tokenID;
2206         uint96  amount;
2207         uint16  feeTokenID;
2208         uint96  maxFee;
2209         uint96  fee;
2210         uint32  validUntil;
2211         uint32  storageID;
2212     }
2213 
2214     // Auxiliary data for each transfer
2215     struct TransferAuxiliaryData
2216     {
2217         bytes  signature;
2218         uint96 maxFee;
2219         uint32 validUntil;
2220     }
2221 
2222     function process(
2223         ExchangeData.State        storage S,
2224         ExchangeData.BlockContext memory  ctx,
2225         bytes                     memory  data,
2226         uint                              offset,
2227         bytes                     memory  auxiliaryData
2228         )
2229         internal
2230     {
2231         // Read the transfer
2232         Transfer memory transfer = readTx(data, offset);
2233         TransferAuxiliaryData memory auxData = abi.decode(auxiliaryData, (TransferAuxiliaryData));
2234 
2235         // Fill in withdrawal data missing from DA
2236         transfer.validUntil = auxData.validUntil;
2237         transfer.maxFee = auxData.maxFee == 0 ? transfer.fee : auxData.maxFee;
2238         // Validate
2239         require(ctx.timestamp < transfer.validUntil, "TRANSFER_EXPIRED");
2240         require(transfer.fee <= transfer.maxFee, "TRANSFER_FEE_TOO_HIGH");
2241 
2242         // Calculate the tx hash
2243         bytes32 txHash = hashTx(ctx.DOMAIN_SEPARATOR, transfer);
2244 
2245         // Check the on-chain authorization
2246         S.requireAuthorizedTx(transfer.from, auxData.signature, txHash);
2247     }
2248 
2249     function readTx(
2250         bytes memory data,
2251         uint         offset
2252         )
2253         internal
2254         pure
2255         returns (Transfer memory transfer)
2256     {
2257         uint _offset = offset;
2258         // Check that this is a conditional transfer
2259         require(data.toUint8(_offset) == 1, "INVALID_AUXILIARYDATA_DATA");
2260         _offset += 1;
2261 
2262         // Extract the transfer data
2263         // We don't use abi.decode for this because of the large amount of zero-padding
2264         // bytes the circuit would also have to hash.
2265         transfer.fromAccountID = data.toUint32(_offset);
2266         _offset += 4;
2267         transfer.toAccountID = data.toUint32(_offset);
2268         _offset += 4;
2269         transfer.tokenID = data.toUint16(_offset);
2270         _offset += 2;
2271         transfer.amount = uint(data.toUint24(_offset)).decodeFloat(24);
2272         _offset += 3;
2273         transfer.feeTokenID = data.toUint16(_offset);
2274         _offset += 2;
2275         transfer.fee = uint(data.toUint16(_offset)).decodeFloat(16);
2276         _offset += 2;
2277         transfer.storageID = data.toUint32(_offset);
2278         _offset += 4;
2279         transfer.to = data.toAddress(_offset);
2280         _offset += 20;
2281         transfer.from = data.toAddress(_offset);
2282         _offset += 20;
2283     }
2284 
2285     function hashTx(
2286         bytes32 DOMAIN_SEPARATOR,
2287         Transfer memory transfer
2288         )
2289         internal
2290         pure
2291         returns (bytes32)
2292     {
2293         return EIP712.hashPacked(
2294             DOMAIN_SEPARATOR,
2295             keccak256(
2296                 abi.encode(
2297                     TRANSFER_TYPEHASH,
2298                     transfer.from,
2299                     transfer.to,
2300                     transfer.tokenID,
2301                     transfer.amount,
2302                     transfer.feeTokenID,
2303                     transfer.maxFee,
2304                     transfer.validUntil,
2305                     transfer.storageID
2306                 )
2307             )
2308         );
2309     }
2310 }
2311 
2312 // File: contracts/core/impl/libexchange/ExchangeMode.sol
2313 
2314 // Copyright 2017 Loopring Technology Limited.
2315 
2316 
2317 
2318 
2319 /// @title ExchangeMode.
2320 /// @dev All methods in this lib are internal, therefore, there is no need
2321 ///      to deploy this library independently.
2322 /// @author Brecht Devos - <brecht@loopring.org>
2323 /// @author Daniel Wang  - <daniel@loopring.org>
2324 library ExchangeMode
2325 {
2326     using MathUint  for uint;
2327 
2328     function isInWithdrawalMode(
2329         ExchangeData.State storage S
2330         )
2331         internal // inline call
2332         view
2333         returns (bool result)
2334     {
2335         result = S.withdrawalModeStartTime > 0;
2336     }
2337 
2338     function isShutdown(
2339         ExchangeData.State storage S
2340         )
2341         internal // inline call
2342         view
2343         returns (bool)
2344     {
2345         return S.shutdownModeStartTime > 0;
2346     }
2347 
2348     function getNumAvailableForcedSlots(
2349         ExchangeData.State storage S
2350         )
2351         internal
2352         view
2353         returns (uint)
2354     {
2355         return ExchangeData.MAX_OPEN_FORCED_REQUESTS() - S.numPendingForcedTransactions;
2356     }
2357 }
2358 
2359 // File: contracts/lib/Poseidon.sol
2360 
2361 // Copyright 2017 Loopring Technology Limited.
2362 
2363 
2364 /// @title Poseidon hash function
2365 ///        See: https://eprint.iacr.org/2019/458.pdf
2366 ///        Code auto-generated by generate_poseidon_EVM_code.py
2367 /// @author Brecht Devos - <brecht@loopring.org>
2368 library Poseidon
2369 {
2370     //
2371     // hash_t5f6p52
2372     //
2373 
2374     struct HashInputs5
2375     {
2376         uint t0;
2377         uint t1;
2378         uint t2;
2379         uint t3;
2380         uint t4;
2381     }
2382 
2383     function hash_t5f6p52_internal(
2384         uint t0,
2385         uint t1,
2386         uint t2,
2387         uint t3,
2388         uint t4,
2389         uint q
2390         )
2391         internal
2392         pure
2393         returns (uint)
2394     {
2395         assembly {
2396             function mix(_t0, _t1, _t2, _t3, _t4, _q) -> nt0, nt1, nt2, nt3, nt4 {
2397                 nt0 := mulmod(_t0, 4977258759536702998522229302103997878600602264560359702680165243908162277980, _q)
2398                 nt0 := addmod(nt0, mulmod(_t1, 19167410339349846567561662441069598364702008768579734801591448511131028229281, _q), _q)
2399                 nt0 := addmod(nt0, mulmod(_t2, 14183033936038168803360723133013092560869148726790180682363054735190196956789, _q), _q)
2400                 nt0 := addmod(nt0, mulmod(_t3, 9067734253445064890734144122526450279189023719890032859456830213166173619761, _q), _q)
2401                 nt0 := addmod(nt0, mulmod(_t4, 16378664841697311562845443097199265623838619398287411428110917414833007677155, _q), _q)
2402                 nt1 := mulmod(_t0, 107933704346764130067829474107909495889716688591997879426350582457782826785, _q)
2403                 nt1 := addmod(nt1, mulmod(_t1, 17034139127218860091985397764514160131253018178110701196935786874261236172431, _q), _q)
2404                 nt1 := addmod(nt1, mulmod(_t2, 2799255644797227968811798608332314218966179365168250111693473252876996230317, _q), _q)
2405                 nt1 := addmod(nt1, mulmod(_t3, 2482058150180648511543788012634934806465808146786082148795902594096349483974, _q), _q)
2406                 nt1 := addmod(nt1, mulmod(_t4, 16563522740626180338295201738437974404892092704059676533096069531044355099628, _q), _q)
2407                 nt2 := mulmod(_t0, 13596762909635538739079656925495736900379091964739248298531655823337482778123, _q)
2408                 nt2 := addmod(nt2, mulmod(_t1, 18985203040268814769637347880759846911264240088034262814847924884273017355969, _q), _q)
2409                 nt2 := addmod(nt2, mulmod(_t2, 8652975463545710606098548415650457376967119951977109072274595329619335974180, _q), _q)
2410                 nt2 := addmod(nt2, mulmod(_t3, 970943815872417895015626519859542525373809485973005165410533315057253476903, _q), _q)
2411                 nt2 := addmod(nt2, mulmod(_t4, 19406667490568134101658669326517700199745817783746545889094238643063688871948, _q), _q)
2412                 nt3 := mulmod(_t0, 2953507793609469112222895633455544691298656192015062835263784675891831794974, _q)
2413                 nt3 := addmod(nt3, mulmod(_t1, 19025623051770008118343718096455821045904242602531062247152770448380880817517, _q), _q)
2414                 nt3 := addmod(nt3, mulmod(_t2, 9077319817220936628089890431129759976815127354480867310384708941479362824016, _q), _q)
2415                 nt3 := addmod(nt3, mulmod(_t3, 4770370314098695913091200576539533727214143013236894216582648993741910829490, _q), _q)
2416                 nt3 := addmod(nt3, mulmod(_t4, 4298564056297802123194408918029088169104276109138370115401819933600955259473, _q), _q)
2417                 nt4 := mulmod(_t0, 8336710468787894148066071988103915091676109272951895469087957569358494947747, _q)
2418                 nt4 := addmod(nt4, mulmod(_t1, 16205238342129310687768799056463408647672389183328001070715567975181364448609, _q), _q)
2419                 nt4 := addmod(nt4, mulmod(_t2, 8303849270045876854140023508764676765932043944545416856530551331270859502246, _q), _q)
2420                 nt4 := addmod(nt4, mulmod(_t3, 20218246699596954048529384569730026273241102596326201163062133863539137060414, _q), _q)
2421                 nt4 := addmod(nt4, mulmod(_t4, 1712845821388089905746651754894206522004527237615042226559791118162382909269, _q), _q)
2422             }
2423 
2424             function ark(_t0, _t1, _t2, _t3, _t4, _q, c) -> nt0, nt1, nt2, nt3, nt4 {
2425                 nt0 := addmod(_t0, c, _q)
2426                 nt1 := addmod(_t1, c, _q)
2427                 nt2 := addmod(_t2, c, _q)
2428                 nt3 := addmod(_t3, c, _q)
2429                 nt4 := addmod(_t4, c, _q)
2430             }
2431 
2432             function sbox_full(_t0, _t1, _t2, _t3, _t4, _q) -> nt0, nt1, nt2, nt3, nt4 {
2433                 nt0 := mulmod(_t0, _t0, _q)
2434                 nt0 := mulmod(nt0, nt0, _q)
2435                 nt0 := mulmod(_t0, nt0, _q)
2436                 nt1 := mulmod(_t1, _t1, _q)
2437                 nt1 := mulmod(nt1, nt1, _q)
2438                 nt1 := mulmod(_t1, nt1, _q)
2439                 nt2 := mulmod(_t2, _t2, _q)
2440                 nt2 := mulmod(nt2, nt2, _q)
2441                 nt2 := mulmod(_t2, nt2, _q)
2442                 nt3 := mulmod(_t3, _t3, _q)
2443                 nt3 := mulmod(nt3, nt3, _q)
2444                 nt3 := mulmod(_t3, nt3, _q)
2445                 nt4 := mulmod(_t4, _t4, _q)
2446                 nt4 := mulmod(nt4, nt4, _q)
2447                 nt4 := mulmod(_t4, nt4, _q)
2448             }
2449 
2450             function sbox_partial(_t, _q) -> nt {
2451                 nt := mulmod(_t, _t, _q)
2452                 nt := mulmod(nt, nt, _q)
2453                 nt := mulmod(_t, nt, _q)
2454             }
2455 
2456             // round 0
2457             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 14397397413755236225575615486459253198602422701513067526754101844196324375522)
2458             t0, t1, t2, t3, t4 := sbox_full(t0, t1, t2, t3, t4, q)
2459             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2460             // round 1
2461             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 10405129301473404666785234951972711717481302463898292859783056520670200613128)
2462             t0, t1, t2, t3, t4 := sbox_full(t0, t1, t2, t3, t4, q)
2463             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2464             // round 2
2465             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 5179144822360023508491245509308555580251733042407187134628755730783052214509)
2466             t0, t1, t2, t3, t4 := sbox_full(t0, t1, t2, t3, t4, q)
2467             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2468             // round 3
2469             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 9132640374240188374542843306219594180154739721841249568925550236430986592615)
2470             t0 := sbox_partial(t0, q)
2471             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2472             // round 4
2473             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 20360807315276763881209958738450444293273549928693737723235350358403012458514)
2474             t0 := sbox_partial(t0, q)
2475             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2476             // round 5
2477             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 17933600965499023212689924809448543050840131883187652471064418452962948061619)
2478             t0 := sbox_partial(t0, q)
2479             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2480             // round 6
2481             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 3636213416533737411392076250708419981662897009810345015164671602334517041153)
2482             t0 := sbox_partial(t0, q)
2483             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2484             // round 7
2485             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 2008540005368330234524962342006691994500273283000229509835662097352946198608)
2486             t0 := sbox_partial(t0, q)
2487             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2488             // round 8
2489             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 16018407964853379535338740313053768402596521780991140819786560130595652651567)
2490             t0 := sbox_partial(t0, q)
2491             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2492             // round 9
2493             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 20653139667070586705378398435856186172195806027708437373983929336015162186471)
2494             t0 := sbox_partial(t0, q)
2495             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2496             // round 10
2497             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 17887713874711369695406927657694993484804203950786446055999405564652412116765)
2498             t0 := sbox_partial(t0, q)
2499             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2500             // round 11
2501             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 4852706232225925756777361208698488277369799648067343227630786518486608711772)
2502             t0 := sbox_partial(t0, q)
2503             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2504             // round 12
2505             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 8969172011633935669771678412400911310465619639756845342775631896478908389850)
2506             t0 := sbox_partial(t0, q)
2507             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2508             // round 13
2509             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 20570199545627577691240476121888846460936245025392381957866134167601058684375)
2510             t0 := sbox_partial(t0, q)
2511             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2512             // round 14
2513             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 16442329894745639881165035015179028112772410105963688121820543219662832524136)
2514             t0 := sbox_partial(t0, q)
2515             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2516             // round 15
2517             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 20060625627350485876280451423010593928172611031611836167979515653463693899374)
2518             t0 := sbox_partial(t0, q)
2519             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2520             // round 16
2521             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 16637282689940520290130302519163090147511023430395200895953984829546679599107)
2522             t0 := sbox_partial(t0, q)
2523             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2524             // round 17
2525             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 15599196921909732993082127725908821049411366914683565306060493533569088698214)
2526             t0 := sbox_partial(t0, q)
2527             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2528             // round 18
2529             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 16894591341213863947423904025624185991098788054337051624251730868231322135455)
2530             t0 := sbox_partial(t0, q)
2531             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2532             // round 19
2533             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 1197934381747032348421303489683932612752526046745577259575778515005162320212)
2534             t0 := sbox_partial(t0, q)
2535             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2536             // round 20
2537             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 6172482022646932735745595886795230725225293469762393889050804649558459236626)
2538             t0 := sbox_partial(t0, q)
2539             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2540             // round 21
2541             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 21004037394166516054140386756510609698837211370585899203851827276330669555417)
2542             t0 := sbox_partial(t0, q)
2543             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2544             // round 22
2545             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 15262034989144652068456967541137853724140836132717012646544737680069032573006)
2546             t0 := sbox_partial(t0, q)
2547             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2548             // round 23
2549             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 15017690682054366744270630371095785995296470601172793770224691982518041139766)
2550             t0 := sbox_partial(t0, q)
2551             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2552             // round 24
2553             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 15159744167842240513848638419303545693472533086570469712794583342699782519832)
2554             t0 := sbox_partial(t0, q)
2555             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2556             // round 25
2557             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 11178069035565459212220861899558526502477231302924961773582350246646450941231)
2558             t0 := sbox_partial(t0, q)
2559             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2560             // round 26
2561             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 21154888769130549957415912997229564077486639529994598560737238811887296922114)
2562             t0 := sbox_partial(t0, q)
2563             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2564             // round 27
2565             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 20162517328110570500010831422938033120419484532231241180224283481905744633719)
2566             t0 := sbox_partial(t0, q)
2567             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2568             // round 28
2569             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 2777362604871784250419758188173029886707024739806641263170345377816177052018)
2570             t0 := sbox_partial(t0, q)
2571             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2572             // round 29
2573             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 15732290486829619144634131656503993123618032247178179298922551820261215487562)
2574             t0 := sbox_partial(t0, q)
2575             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2576             // round 30
2577             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 6024433414579583476444635447152826813568595303270846875177844482142230009826)
2578             t0 := sbox_partial(t0, q)
2579             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2580             // round 31
2581             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 17677827682004946431939402157761289497221048154630238117709539216286149983245)
2582             t0 := sbox_partial(t0, q)
2583             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2584             // round 32
2585             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 10716307389353583413755237303156291454109852751296156900963208377067748518748)
2586             t0 := sbox_partial(t0, q)
2587             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2588             // round 33
2589             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 14925386988604173087143546225719076187055229908444910452781922028996524347508)
2590             t0 := sbox_partial(t0, q)
2591             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2592             // round 34
2593             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 8940878636401797005293482068100797531020505636124892198091491586778667442523)
2594             t0 := sbox_partial(t0, q)
2595             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2596             // round 35
2597             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 18911747154199663060505302806894425160044925686870165583944475880789706164410)
2598             t0 := sbox_partial(t0, q)
2599             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2600             // round 36
2601             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 8821532432394939099312235292271438180996556457308429936910969094255825456935)
2602             t0 := sbox_partial(t0, q)
2603             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2604             // round 37
2605             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 20632576502437623790366878538516326728436616723089049415538037018093616927643)
2606             t0 := sbox_partial(t0, q)
2607             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2608             // round 38
2609             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 71447649211767888770311304010816315780740050029903404046389165015534756512)
2610             t0 := sbox_partial(t0, q)
2611             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2612             // round 39
2613             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 2781996465394730190470582631099299305677291329609718650018200531245670229393)
2614             t0 := sbox_partial(t0, q)
2615             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2616             // round 40
2617             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 12441376330954323535872906380510501637773629931719508864016287320488688345525)
2618             t0 := sbox_partial(t0, q)
2619             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2620             // round 41
2621             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 2558302139544901035700544058046419714227464650146159803703499681139469546006)
2622             t0 := sbox_partial(t0, q)
2623             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2624             // round 42
2625             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 10087036781939179132584550273563255199577525914374285705149349445480649057058)
2626             t0 := sbox_partial(t0, q)
2627             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2628             // round 43
2629             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 4267692623754666261749551533667592242661271409704769363166965280715887854739)
2630             t0 := sbox_partial(t0, q)
2631             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2632             // round 44
2633             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 4945579503584457514844595640661884835097077318604083061152997449742124905548)
2634             t0 := sbox_partial(t0, q)
2635             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2636             // round 45
2637             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 17742335354489274412669987990603079185096280484072783973732137326144230832311)
2638             t0 := sbox_partial(t0, q)
2639             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2640             // round 46
2641             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 6266270088302506215402996795500854910256503071464802875821837403486057988208)
2642             t0 := sbox_partial(t0, q)
2643             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2644             // round 47
2645             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 2716062168542520412498610856550519519760063668165561277991771577403400784706)
2646             t0 := sbox_partial(t0, q)
2647             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2648             // round 48
2649             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 19118392018538203167410421493487769944462015419023083813301166096764262134232)
2650             t0 := sbox_partial(t0, q)
2651             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2652             // round 49
2653             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 9386595745626044000666050847309903206827901310677406022353307960932745699524)
2654             t0 := sbox_partial(t0, q)
2655             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2656             // round 50
2657             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 9121640807890366356465620448383131419933298563527245687958865317869840082266)
2658             t0 := sbox_partial(t0, q)
2659             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2660             // round 51
2661             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 3078975275808111706229899605611544294904276390490742680006005661017864583210)
2662             t0 := sbox_partial(t0, q)
2663             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2664             // round 52
2665             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 7157404299437167354719786626667769956233708887934477609633504801472827442743)
2666             t0 := sbox_partial(t0, q)
2667             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2668             // round 53
2669             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 14056248655941725362944552761799461694550787028230120190862133165195793034373)
2670             t0 := sbox_partial(t0, q)
2671             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2672             // round 54
2673             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 14124396743304355958915937804966111851843703158171757752158388556919187839849)
2674             t0 := sbox_partial(t0, q)
2675             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2676             // round 55
2677             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 11851254356749068692552943732920045260402277343008629727465773766468466181076)
2678             t0, t1, t2, t3, t4 := sbox_full(t0, t1, t2, t3, t4, q)
2679             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2680             // round 56
2681             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 9799099446406796696742256539758943483211846559715874347178722060519817626047)
2682             t0, t1, t2, t3, t4 := sbox_full(t0, t1, t2, t3, t4, q)
2683             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2684             // round 57
2685             t0, t1, t2, t3, t4 := ark(t0, t1, t2, t3, t4, q, 10156146186214948683880719664738535455146137901666656566575307300522957959544)
2686             t0, t1, t2, t3, t4 := sbox_full(t0, t1, t2, t3, t4, q)
2687             t0, t1, t2, t3, t4 := mix(t0, t1, t2, t3, t4, q)
2688         }
2689         return t0;
2690     }
2691 
2692     function hash_t5f6p52(HashInputs5 memory i, uint q) internal pure returns (uint)
2693     {
2694         // validate inputs
2695         require(i.t0 < q, "INVALID_INPUT");
2696         require(i.t1 < q, "INVALID_INPUT");
2697         require(i.t2 < q, "INVALID_INPUT");
2698         require(i.t3 < q, "INVALID_INPUT");
2699         require(i.t4 < q, "INVALID_INPUT");
2700 
2701         return hash_t5f6p52_internal(i.t0, i.t1, i.t2, i.t3, i.t4, q);
2702     }
2703 
2704 
2705     //
2706     // hash_t7f6p52
2707     //
2708 
2709     struct HashInputs7
2710     {
2711         uint t0;
2712         uint t1;
2713         uint t2;
2714         uint t3;
2715         uint t4;
2716         uint t5;
2717         uint t6;
2718     }
2719 
2720     function mix(HashInputs7 memory i, uint q) internal pure
2721     {
2722         HashInputs7 memory o;
2723         o.t0 = mulmod(i.t0, 14183033936038168803360723133013092560869148726790180682363054735190196956789, q);
2724         o.t0 = addmod(o.t0, mulmod(i.t1, 9067734253445064890734144122526450279189023719890032859456830213166173619761, q), q);
2725         o.t0 = addmod(o.t0, mulmod(i.t2, 16378664841697311562845443097199265623838619398287411428110917414833007677155, q), q);
2726         o.t0 = addmod(o.t0, mulmod(i.t3, 12968540216479938138647596899147650021419273189336843725176422194136033835172, q), q);
2727         o.t0 = addmod(o.t0, mulmod(i.t4, 3636162562566338420490575570584278737093584021456168183289112789616069756675, q), q);
2728         o.t0 = addmod(o.t0, mulmod(i.t5, 8949952361235797771659501126471156178804092479420606597426318793013844305422, q), q);
2729         o.t0 = addmod(o.t0, mulmod(i.t6, 13586657904816433080148729258697725609063090799921401830545410130405357110367, q), q);
2730         o.t1 = mulmod(i.t0, 2799255644797227968811798608332314218966179365168250111693473252876996230317, q);
2731         o.t1 = addmod(o.t1, mulmod(i.t1, 2482058150180648511543788012634934806465808146786082148795902594096349483974, q), q);
2732         o.t1 = addmod(o.t1, mulmod(i.t2, 16563522740626180338295201738437974404892092704059676533096069531044355099628, q), q);
2733         o.t1 = addmod(o.t1, mulmod(i.t3, 10468644849657689537028565510142839489302836569811003546969773105463051947124, q), q);
2734         o.t1 = addmod(o.t1, mulmod(i.t4, 3328913364598498171733622353010907641674136720305714432354138807013088636408, q), q);
2735         o.t1 = addmod(o.t1, mulmod(i.t5, 8642889650254799419576843603477253661899356105675006557919250564400804756641, q), q);
2736         o.t1 = addmod(o.t1, mulmod(i.t6, 14300697791556510113764686242794463641010174685800128469053974698256194076125, q), q);
2737         o.t2 = mulmod(i.t0, 8652975463545710606098548415650457376967119951977109072274595329619335974180, q);
2738         o.t2 = addmod(o.t2, mulmod(i.t1, 970943815872417895015626519859542525373809485973005165410533315057253476903, q), q);
2739         o.t2 = addmod(o.t2, mulmod(i.t2, 19406667490568134101658669326517700199745817783746545889094238643063688871948, q), q);
2740         o.t2 = addmod(o.t2, mulmod(i.t3, 17049854690034965250221386317058877242629221002521630573756355118745574274967, q), q);
2741         o.t2 = addmod(o.t2, mulmod(i.t4, 4964394613021008685803675656098849539153699842663541444414978877928878266244, q), q);
2742         o.t2 = addmod(o.t2, mulmod(i.t5, 15474947305445649466370538888925567099067120578851553103424183520405650587995, q), q);
2743         o.t2 = addmod(o.t2, mulmod(i.t6, 1016119095639665978105768933448186152078842964810837543326777554729232767846, q), q);
2744         o.t3 = mulmod(i.t0, 9077319817220936628089890431129759976815127354480867310384708941479362824016, q);
2745         o.t3 = addmod(o.t3, mulmod(i.t1, 4770370314098695913091200576539533727214143013236894216582648993741910829490, q), q);
2746         o.t3 = addmod(o.t3, mulmod(i.t2, 4298564056297802123194408918029088169104276109138370115401819933600955259473, q), q);
2747         o.t3 = addmod(o.t3, mulmod(i.t3, 6905514380186323693285869145872115273350947784558995755916362330070690839131, q), q);
2748         o.t3 = addmod(o.t3, mulmod(i.t4, 4783343257810358393326889022942241108539824540285247795235499223017138301952, q), q);
2749         o.t3 = addmod(o.t3, mulmod(i.t5, 1420772902128122367335354247676760257656541121773854204774788519230732373317, q), q);
2750         o.t3 = addmod(o.t3, mulmod(i.t6, 14172871439045259377975734198064051992755748777535789572469924335100006948373, q), q);
2751         o.t4 = mulmod(i.t0, 8303849270045876854140023508764676765932043944545416856530551331270859502246, q);
2752         o.t4 = addmod(o.t4, mulmod(i.t1, 20218246699596954048529384569730026273241102596326201163062133863539137060414, q), q);
2753         o.t4 = addmod(o.t4, mulmod(i.t2, 1712845821388089905746651754894206522004527237615042226559791118162382909269, q), q);
2754         o.t4 = addmod(o.t4, mulmod(i.t3, 13001155522144542028910638547179410124467185319212645031214919884423841839406, q), q);
2755         o.t4 = addmod(o.t4, mulmod(i.t4, 16037892369576300958623292723740289861626299352695838577330319504984091062115, q), q);
2756         o.t4 = addmod(o.t4, mulmod(i.t5, 19189494548480259335554606182055502469831573298885662881571444557262020106898, q), q);
2757         o.t4 = addmod(o.t4, mulmod(i.t6, 19032687447778391106390582750185144485341165205399984747451318330476859342654, q), q);
2758         o.t5 = mulmod(i.t0, 13272957914179340594010910867091459756043436017766464331915862093201960540910, q);
2759         o.t5 = addmod(o.t5, mulmod(i.t1, 9416416589114508529880440146952102328470363729880726115521103179442988482948, q), q);
2760         o.t5 = addmod(o.t5, mulmod(i.t2, 8035240799672199706102747147502951589635001418759394863664434079699838251138, q), q);
2761         o.t5 = addmod(o.t5, mulmod(i.t3, 21642389080762222565487157652540372010968704000567605990102641816691459811717, q), q);
2762         o.t5 = addmod(o.t5, mulmod(i.t4, 20261355950827657195644012399234591122288573679402601053407151083849785332516, q), q);
2763         o.t5 = addmod(o.t5, mulmod(i.t5, 14514189384576734449268559374569145463190040567900950075547616936149781403109, q), q);
2764         o.t5 = addmod(o.t5, mulmod(i.t6, 19038036134886073991945204537416211699632292792787812530208911676638479944765, q), q);
2765         o.t6 = mulmod(i.t0, 15627836782263662543041758927100784213807648787083018234961118439434298020664, q);
2766         o.t6 = addmod(o.t6, mulmod(i.t1, 5655785191024506056588710805596292231240948371113351452712848652644610823632, q), q);
2767         o.t6 = addmod(o.t6, mulmod(i.t2, 8265264721707292643644260517162050867559314081394556886644673791575065394002, q), q);
2768         o.t6 = addmod(o.t6, mulmod(i.t3, 17151144681903609082202835646026478898625761142991787335302962548605510241586, q), q);
2769         o.t6 = addmod(o.t6, mulmod(i.t4, 18731644709777529787185361516475509623264209648904603914668024590231177708831, q), q);
2770         o.t6 = addmod(o.t6, mulmod(i.t5, 20697789991623248954020701081488146717484139720322034504511115160686216223641, q), q);
2771         o.t6 = addmod(o.t6, mulmod(i.t6, 6200020095464686209289974437830528853749866001482481427982839122465470640886, q), q);
2772         i.t0 = o.t0;
2773         i.t1 = o.t1;
2774         i.t2 = o.t2;
2775         i.t3 = o.t3;
2776         i.t4 = o.t4;
2777         i.t5 = o.t5;
2778         i.t6 = o.t6;
2779     }
2780 
2781     function ark(HashInputs7 memory i, uint q, uint c) internal pure
2782     {
2783         HashInputs7 memory o;
2784         o.t0 = addmod(i.t0, c, q);
2785         o.t1 = addmod(i.t1, c, q);
2786         o.t2 = addmod(i.t2, c, q);
2787         o.t3 = addmod(i.t3, c, q);
2788         o.t4 = addmod(i.t4, c, q);
2789         o.t5 = addmod(i.t5, c, q);
2790         o.t6 = addmod(i.t6, c, q);
2791         i.t0 = o.t0;
2792         i.t1 = o.t1;
2793         i.t2 = o.t2;
2794         i.t3 = o.t3;
2795         i.t4 = o.t4;
2796         i.t5 = o.t5;
2797         i.t6 = o.t6;
2798     }
2799 
2800     function sbox_full(HashInputs7 memory i, uint q) internal pure
2801     {
2802         HashInputs7 memory o;
2803         o.t0 = mulmod(i.t0, i.t0, q);
2804         o.t0 = mulmod(o.t0, o.t0, q);
2805         o.t0 = mulmod(i.t0, o.t0, q);
2806         o.t1 = mulmod(i.t1, i.t1, q);
2807         o.t1 = mulmod(o.t1, o.t1, q);
2808         o.t1 = mulmod(i.t1, o.t1, q);
2809         o.t2 = mulmod(i.t2, i.t2, q);
2810         o.t2 = mulmod(o.t2, o.t2, q);
2811         o.t2 = mulmod(i.t2, o.t2, q);
2812         o.t3 = mulmod(i.t3, i.t3, q);
2813         o.t3 = mulmod(o.t3, o.t3, q);
2814         o.t3 = mulmod(i.t3, o.t3, q);
2815         o.t4 = mulmod(i.t4, i.t4, q);
2816         o.t4 = mulmod(o.t4, o.t4, q);
2817         o.t4 = mulmod(i.t4, o.t4, q);
2818         o.t5 = mulmod(i.t5, i.t5, q);
2819         o.t5 = mulmod(o.t5, o.t5, q);
2820         o.t5 = mulmod(i.t5, o.t5, q);
2821         o.t6 = mulmod(i.t6, i.t6, q);
2822         o.t6 = mulmod(o.t6, o.t6, q);
2823         o.t6 = mulmod(i.t6, o.t6, q);
2824         i.t0 = o.t0;
2825         i.t1 = o.t1;
2826         i.t2 = o.t2;
2827         i.t3 = o.t3;
2828         i.t4 = o.t4;
2829         i.t5 = o.t5;
2830         i.t6 = o.t6;
2831     }
2832 
2833     function sbox_partial(HashInputs7 memory i, uint q) internal pure
2834     {
2835         HashInputs7 memory o;
2836         o.t0 = mulmod(i.t0, i.t0, q);
2837         o.t0 = mulmod(o.t0, o.t0, q);
2838         o.t0 = mulmod(i.t0, o.t0, q);
2839         i.t0 = o.t0;
2840     }
2841 
2842     function hash_t7f6p52(HashInputs7 memory i, uint q) internal pure returns (uint)
2843     {
2844         // validate inputs
2845         require(i.t0 < q, "INVALID_INPUT");
2846         require(i.t1 < q, "INVALID_INPUT");
2847         require(i.t2 < q, "INVALID_INPUT");
2848         require(i.t3 < q, "INVALID_INPUT");
2849         require(i.t4 < q, "INVALID_INPUT");
2850         require(i.t5 < q, "INVALID_INPUT");
2851         require(i.t6 < q, "INVALID_INPUT");
2852 
2853         // round 0
2854         ark(i, q, 14397397413755236225575615486459253198602422701513067526754101844196324375522);
2855         sbox_full(i, q);
2856         mix(i, q);
2857         // round 1
2858         ark(i, q, 10405129301473404666785234951972711717481302463898292859783056520670200613128);
2859         sbox_full(i, q);
2860         mix(i, q);
2861         // round 2
2862         ark(i, q, 5179144822360023508491245509308555580251733042407187134628755730783052214509);
2863         sbox_full(i, q);
2864         mix(i, q);
2865         // round 3
2866         ark(i, q, 9132640374240188374542843306219594180154739721841249568925550236430986592615);
2867         sbox_partial(i, q);
2868         mix(i, q);
2869         // round 4
2870         ark(i, q, 20360807315276763881209958738450444293273549928693737723235350358403012458514);
2871         sbox_partial(i, q);
2872         mix(i, q);
2873         // round 5
2874         ark(i, q, 17933600965499023212689924809448543050840131883187652471064418452962948061619);
2875         sbox_partial(i, q);
2876         mix(i, q);
2877         // round 6
2878         ark(i, q, 3636213416533737411392076250708419981662897009810345015164671602334517041153);
2879         sbox_partial(i, q);
2880         mix(i, q);
2881         // round 7
2882         ark(i, q, 2008540005368330234524962342006691994500273283000229509835662097352946198608);
2883         sbox_partial(i, q);
2884         mix(i, q);
2885         // round 8
2886         ark(i, q, 16018407964853379535338740313053768402596521780991140819786560130595652651567);
2887         sbox_partial(i, q);
2888         mix(i, q);
2889         // round 9
2890         ark(i, q, 20653139667070586705378398435856186172195806027708437373983929336015162186471);
2891         sbox_partial(i, q);
2892         mix(i, q);
2893         // round 10
2894         ark(i, q, 17887713874711369695406927657694993484804203950786446055999405564652412116765);
2895         sbox_partial(i, q);
2896         mix(i, q);
2897         // round 11
2898         ark(i, q, 4852706232225925756777361208698488277369799648067343227630786518486608711772);
2899         sbox_partial(i, q);
2900         mix(i, q);
2901         // round 12
2902         ark(i, q, 8969172011633935669771678412400911310465619639756845342775631896478908389850);
2903         sbox_partial(i, q);
2904         mix(i, q);
2905         // round 13
2906         ark(i, q, 20570199545627577691240476121888846460936245025392381957866134167601058684375);
2907         sbox_partial(i, q);
2908         mix(i, q);
2909         // round 14
2910         ark(i, q, 16442329894745639881165035015179028112772410105963688121820543219662832524136);
2911         sbox_partial(i, q);
2912         mix(i, q);
2913         // round 15
2914         ark(i, q, 20060625627350485876280451423010593928172611031611836167979515653463693899374);
2915         sbox_partial(i, q);
2916         mix(i, q);
2917         // round 16
2918         ark(i, q, 16637282689940520290130302519163090147511023430395200895953984829546679599107);
2919         sbox_partial(i, q);
2920         mix(i, q);
2921         // round 17
2922         ark(i, q, 15599196921909732993082127725908821049411366914683565306060493533569088698214);
2923         sbox_partial(i, q);
2924         mix(i, q);
2925         // round 18
2926         ark(i, q, 16894591341213863947423904025624185991098788054337051624251730868231322135455);
2927         sbox_partial(i, q);
2928         mix(i, q);
2929         // round 19
2930         ark(i, q, 1197934381747032348421303489683932612752526046745577259575778515005162320212);
2931         sbox_partial(i, q);
2932         mix(i, q);
2933         // round 20
2934         ark(i, q, 6172482022646932735745595886795230725225293469762393889050804649558459236626);
2935         sbox_partial(i, q);
2936         mix(i, q);
2937         // round 21
2938         ark(i, q, 21004037394166516054140386756510609698837211370585899203851827276330669555417);
2939         sbox_partial(i, q);
2940         mix(i, q);
2941         // round 22
2942         ark(i, q, 15262034989144652068456967541137853724140836132717012646544737680069032573006);
2943         sbox_partial(i, q);
2944         mix(i, q);
2945         // round 23
2946         ark(i, q, 15017690682054366744270630371095785995296470601172793770224691982518041139766);
2947         sbox_partial(i, q);
2948         mix(i, q);
2949         // round 24
2950         ark(i, q, 15159744167842240513848638419303545693472533086570469712794583342699782519832);
2951         sbox_partial(i, q);
2952         mix(i, q);
2953         // round 25
2954         ark(i, q, 11178069035565459212220861899558526502477231302924961773582350246646450941231);
2955         sbox_partial(i, q);
2956         mix(i, q);
2957         // round 26
2958         ark(i, q, 21154888769130549957415912997229564077486639529994598560737238811887296922114);
2959         sbox_partial(i, q);
2960         mix(i, q);
2961         // round 27
2962         ark(i, q, 20162517328110570500010831422938033120419484532231241180224283481905744633719);
2963         sbox_partial(i, q);
2964         mix(i, q);
2965         // round 28
2966         ark(i, q, 2777362604871784250419758188173029886707024739806641263170345377816177052018);
2967         sbox_partial(i, q);
2968         mix(i, q);
2969         // round 29
2970         ark(i, q, 15732290486829619144634131656503993123618032247178179298922551820261215487562);
2971         sbox_partial(i, q);
2972         mix(i, q);
2973         // round 30
2974         ark(i, q, 6024433414579583476444635447152826813568595303270846875177844482142230009826);
2975         sbox_partial(i, q);
2976         mix(i, q);
2977         // round 31
2978         ark(i, q, 17677827682004946431939402157761289497221048154630238117709539216286149983245);
2979         sbox_partial(i, q);
2980         mix(i, q);
2981         // round 32
2982         ark(i, q, 10716307389353583413755237303156291454109852751296156900963208377067748518748);
2983         sbox_partial(i, q);
2984         mix(i, q);
2985         // round 33
2986         ark(i, q, 14925386988604173087143546225719076187055229908444910452781922028996524347508);
2987         sbox_partial(i, q);
2988         mix(i, q);
2989         // round 34
2990         ark(i, q, 8940878636401797005293482068100797531020505636124892198091491586778667442523);
2991         sbox_partial(i, q);
2992         mix(i, q);
2993         // round 35
2994         ark(i, q, 18911747154199663060505302806894425160044925686870165583944475880789706164410);
2995         sbox_partial(i, q);
2996         mix(i, q);
2997         // round 36
2998         ark(i, q, 8821532432394939099312235292271438180996556457308429936910969094255825456935);
2999         sbox_partial(i, q);
3000         mix(i, q);
3001         // round 37
3002         ark(i, q, 20632576502437623790366878538516326728436616723089049415538037018093616927643);
3003         sbox_partial(i, q);
3004         mix(i, q);
3005         // round 38
3006         ark(i, q, 71447649211767888770311304010816315780740050029903404046389165015534756512);
3007         sbox_partial(i, q);
3008         mix(i, q);
3009         // round 39
3010         ark(i, q, 2781996465394730190470582631099299305677291329609718650018200531245670229393);
3011         sbox_partial(i, q);
3012         mix(i, q);
3013         // round 40
3014         ark(i, q, 12441376330954323535872906380510501637773629931719508864016287320488688345525);
3015         sbox_partial(i, q);
3016         mix(i, q);
3017         // round 41
3018         ark(i, q, 2558302139544901035700544058046419714227464650146159803703499681139469546006);
3019         sbox_partial(i, q);
3020         mix(i, q);
3021         // round 42
3022         ark(i, q, 10087036781939179132584550273563255199577525914374285705149349445480649057058);
3023         sbox_partial(i, q);
3024         mix(i, q);
3025         // round 43
3026         ark(i, q, 4267692623754666261749551533667592242661271409704769363166965280715887854739);
3027         sbox_partial(i, q);
3028         mix(i, q);
3029         // round 44
3030         ark(i, q, 4945579503584457514844595640661884835097077318604083061152997449742124905548);
3031         sbox_partial(i, q);
3032         mix(i, q);
3033         // round 45
3034         ark(i, q, 17742335354489274412669987990603079185096280484072783973732137326144230832311);
3035         sbox_partial(i, q);
3036         mix(i, q);
3037         // round 46
3038         ark(i, q, 6266270088302506215402996795500854910256503071464802875821837403486057988208);
3039         sbox_partial(i, q);
3040         mix(i, q);
3041         // round 47
3042         ark(i, q, 2716062168542520412498610856550519519760063668165561277991771577403400784706);
3043         sbox_partial(i, q);
3044         mix(i, q);
3045         // round 48
3046         ark(i, q, 19118392018538203167410421493487769944462015419023083813301166096764262134232);
3047         sbox_partial(i, q);
3048         mix(i, q);
3049         // round 49
3050         ark(i, q, 9386595745626044000666050847309903206827901310677406022353307960932745699524);
3051         sbox_partial(i, q);
3052         mix(i, q);
3053         // round 50
3054         ark(i, q, 9121640807890366356465620448383131419933298563527245687958865317869840082266);
3055         sbox_partial(i, q);
3056         mix(i, q);
3057         // round 51
3058         ark(i, q, 3078975275808111706229899605611544294904276390490742680006005661017864583210);
3059         sbox_partial(i, q);
3060         mix(i, q);
3061         // round 52
3062         ark(i, q, 7157404299437167354719786626667769956233708887934477609633504801472827442743);
3063         sbox_partial(i, q);
3064         mix(i, q);
3065         // round 53
3066         ark(i, q, 14056248655941725362944552761799461694550787028230120190862133165195793034373);
3067         sbox_partial(i, q);
3068         mix(i, q);
3069         // round 54
3070         ark(i, q, 14124396743304355958915937804966111851843703158171757752158388556919187839849);
3071         sbox_partial(i, q);
3072         mix(i, q);
3073         // round 55
3074         ark(i, q, 11851254356749068692552943732920045260402277343008629727465773766468466181076);
3075         sbox_full(i, q);
3076         mix(i, q);
3077         // round 56
3078         ark(i, q, 9799099446406796696742256539758943483211846559715874347178722060519817626047);
3079         sbox_full(i, q);
3080         mix(i, q);
3081         // round 57
3082         ark(i, q, 10156146186214948683880719664738535455146137901666656566575307300522957959544);
3083         sbox_full(i, q);
3084         mix(i, q);
3085 
3086         return i.t0;
3087     }
3088 }
3089 
3090 // File: contracts/core/impl/libexchange/ExchangeBalances.sol
3091 
3092 // Copyright 2017 Loopring Technology Limited.
3093 
3094 
3095 
3096 
3097 
3098 /// @title ExchangeBalances.
3099 /// @author Daniel Wang  - <daniel@loopring.org>
3100 /// @author Brecht Devos - <brecht@loopring.org>
3101 library ExchangeBalances
3102 {
3103     using MathUint  for uint;
3104 
3105     function verifyAccountBalance(
3106         uint                              merkleRoot,
3107         ExchangeData.MerkleProof calldata merkleProof
3108         )
3109         public
3110         pure
3111     {
3112         require(
3113             isAccountBalanceCorrect(merkleRoot, merkleProof),
3114             "INVALID_MERKLE_TREE_DATA"
3115         );
3116     }
3117 
3118     function isAccountBalanceCorrect(
3119         uint                            merkleRoot,
3120         ExchangeData.MerkleProof memory merkleProof
3121         )
3122         public
3123         pure
3124         returns (bool)
3125     {
3126         // Calculate the Merkle root using the Merkle paths provided
3127         uint calculatedRoot = getBalancesRoot(
3128             merkleProof.balanceLeaf.tokenID,
3129             merkleProof.balanceLeaf.balance,
3130             merkleProof.balanceLeaf.weightAMM,
3131             merkleProof.balanceLeaf.storageRoot,
3132             merkleProof.balanceMerkleProof
3133         );
3134         calculatedRoot = getAccountInternalsRoot(
3135             merkleProof.accountLeaf.accountID,
3136             merkleProof.accountLeaf.owner,
3137             merkleProof.accountLeaf.pubKeyX,
3138             merkleProof.accountLeaf.pubKeyY,
3139             merkleProof.accountLeaf.nonce,
3140             merkleProof.accountLeaf.feeBipsAMM,
3141             calculatedRoot,
3142             merkleProof.accountMerkleProof
3143         );
3144         // Check against the expected Merkle root
3145         return (calculatedRoot == merkleRoot);
3146     }
3147 
3148     function getBalancesRoot(
3149         uint16   tokenID,
3150         uint     balance,
3151         uint     weightAMM,
3152         uint     storageRoot,
3153         uint[24] memory balanceMerkleProof
3154         )
3155         private
3156         pure
3157         returns (uint)
3158     {
3159         // Hash the balance leaf
3160         uint balanceItem = hashImpl(balance, weightAMM, storageRoot, 0);
3161         // Calculate the Merkle root of the balance quad Merkle tree
3162         uint _id = tokenID;
3163         for (uint depth = 0; depth < 8; depth++) {
3164             uint base = depth * 3;
3165             if (_id & 3 == 0) {
3166                 balanceItem = hashImpl(
3167                     balanceItem,
3168                     balanceMerkleProof[base],
3169                     balanceMerkleProof[base + 1],
3170                     balanceMerkleProof[base + 2]
3171                 );
3172             } else if (_id & 3 == 1) {
3173                 balanceItem = hashImpl(
3174                     balanceMerkleProof[base],
3175                     balanceItem,
3176                     balanceMerkleProof[base + 1],
3177                     balanceMerkleProof[base + 2]
3178                 );
3179             } else if (_id & 3 == 2) {
3180                 balanceItem = hashImpl(
3181                     balanceMerkleProof[base],
3182                     balanceMerkleProof[base + 1],
3183                     balanceItem,
3184                     balanceMerkleProof[base + 2]
3185                 );
3186             } else if (_id & 3 == 3) {
3187                 balanceItem = hashImpl(
3188                     balanceMerkleProof[base],
3189                     balanceMerkleProof[base + 1],
3190                     balanceMerkleProof[base + 2],
3191                     balanceItem
3192                 );
3193             }
3194             _id = _id >> 2;
3195         }
3196         return balanceItem;
3197     }
3198 
3199     function getAccountInternalsRoot(
3200         uint32   accountID,
3201         address  owner,
3202         uint     pubKeyX,
3203         uint     pubKeyY,
3204         uint     nonce,
3205         uint     feeBipsAMM,
3206         uint     balancesRoot,
3207         uint[48] memory accountMerkleProof
3208         )
3209         private
3210         pure
3211         returns (uint)
3212     {
3213         // Hash the account leaf
3214         uint accountItem = hashAccountLeaf(uint(owner), pubKeyX, pubKeyY, nonce, feeBipsAMM, balancesRoot);
3215         // Calculate the Merkle root of the account quad Merkle tree
3216         uint _id = accountID;
3217         for (uint depth = 0; depth < 16; depth++) {
3218             uint base = depth * 3;
3219             if (_id & 3 == 0) {
3220                 accountItem = hashImpl(
3221                     accountItem,
3222                     accountMerkleProof[base],
3223                     accountMerkleProof[base + 1],
3224                     accountMerkleProof[base + 2]
3225                 );
3226             } else if (_id & 3 == 1) {
3227                 accountItem = hashImpl(
3228                     accountMerkleProof[base],
3229                     accountItem,
3230                     accountMerkleProof[base + 1],
3231                     accountMerkleProof[base + 2]
3232                 );
3233             } else if (_id & 3 == 2) {
3234                 accountItem = hashImpl(
3235                     accountMerkleProof[base],
3236                     accountMerkleProof[base + 1],
3237                     accountItem,
3238                     accountMerkleProof[base + 2]
3239                 );
3240             } else if (_id & 3 == 3) {
3241                 accountItem = hashImpl(
3242                     accountMerkleProof[base],
3243                     accountMerkleProof[base + 1],
3244                     accountMerkleProof[base + 2],
3245                     accountItem
3246                 );
3247             }
3248             _id = _id >> 2;
3249         }
3250         return accountItem;
3251     }
3252 
3253     function hashAccountLeaf(
3254         uint t0,
3255         uint t1,
3256         uint t2,
3257         uint t3,
3258         uint t4,
3259         uint t5
3260         )
3261         public
3262         pure
3263         returns (uint)
3264     {
3265         Poseidon.HashInputs7 memory inputs = Poseidon.HashInputs7(t0, t1, t2, t3, t4, t5, 0);
3266         return Poseidon.hash_t7f6p52(inputs, ExchangeData.SNARK_SCALAR_FIELD());
3267     }
3268 
3269     function hashImpl(
3270         uint t0,
3271         uint t1,
3272         uint t2,
3273         uint t3
3274         )
3275         private
3276         pure
3277         returns (uint)
3278     {
3279         Poseidon.HashInputs5 memory inputs = Poseidon.HashInputs5(t0, t1, t2, t3, 0);
3280         return Poseidon.hash_t5f6p52(inputs, ExchangeData.SNARK_SCALAR_FIELD());
3281     }
3282 }
3283 
3284 // File: contracts/lib/ERC20SafeTransfer.sol
3285 
3286 // Copyright 2017 Loopring Technology Limited.
3287 
3288 
3289 /// @title ERC20 safe transfer
3290 /// @dev see https://github.com/sec-bit/badERC20Fix
3291 /// @author Brecht Devos - <brecht@loopring.org>
3292 library ERC20SafeTransfer
3293 {
3294     function safeTransferAndVerify(
3295         address token,
3296         address to,
3297         uint    value
3298         )
3299         internal
3300     {
3301         safeTransferWithGasLimitAndVerify(
3302             token,
3303             to,
3304             value,
3305             gasleft()
3306         );
3307     }
3308 
3309     function safeTransfer(
3310         address token,
3311         address to,
3312         uint    value
3313         )
3314         internal
3315         returns (bool)
3316     {
3317         return safeTransferWithGasLimit(
3318             token,
3319             to,
3320             value,
3321             gasleft()
3322         );
3323     }
3324 
3325     function safeTransferWithGasLimitAndVerify(
3326         address token,
3327         address to,
3328         uint    value,
3329         uint    gasLimit
3330         )
3331         internal
3332     {
3333         require(
3334             safeTransferWithGasLimit(token, to, value, gasLimit),
3335             "TRANSFER_FAILURE"
3336         );
3337     }
3338 
3339     function safeTransferWithGasLimit(
3340         address token,
3341         address to,
3342         uint    value,
3343         uint    gasLimit
3344         )
3345         internal
3346         returns (bool)
3347     {
3348         // A transfer is successful when 'call' is successful and depending on the token:
3349         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
3350         // - A single boolean is returned: this boolean needs to be true (non-zero)
3351 
3352         // bytes4(keccak256("transfer(address,uint256)")) = 0xa9059cbb
3353         bytes memory callData = abi.encodeWithSelector(
3354             bytes4(0xa9059cbb),
3355             to,
3356             value
3357         );
3358         (bool success, ) = token.call{gas: gasLimit}(callData);
3359         return checkReturnValue(success);
3360     }
3361 
3362     function safeTransferFromAndVerify(
3363         address token,
3364         address from,
3365         address to,
3366         uint    value
3367         )
3368         internal
3369     {
3370         safeTransferFromWithGasLimitAndVerify(
3371             token,
3372             from,
3373             to,
3374             value,
3375             gasleft()
3376         );
3377     }
3378 
3379     function safeTransferFrom(
3380         address token,
3381         address from,
3382         address to,
3383         uint    value
3384         )
3385         internal
3386         returns (bool)
3387     {
3388         return safeTransferFromWithGasLimit(
3389             token,
3390             from,
3391             to,
3392             value,
3393             gasleft()
3394         );
3395     }
3396 
3397     function safeTransferFromWithGasLimitAndVerify(
3398         address token,
3399         address from,
3400         address to,
3401         uint    value,
3402         uint    gasLimit
3403         )
3404         internal
3405     {
3406         bool result = safeTransferFromWithGasLimit(
3407             token,
3408             from,
3409             to,
3410             value,
3411             gasLimit
3412         );
3413         require(result, "TRANSFER_FAILURE");
3414     }
3415 
3416     function safeTransferFromWithGasLimit(
3417         address token,
3418         address from,
3419         address to,
3420         uint    value,
3421         uint    gasLimit
3422         )
3423         internal
3424         returns (bool)
3425     {
3426         // A transferFrom is successful when 'call' is successful and depending on the token:
3427         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
3428         // - A single boolean is returned: this boolean needs to be true (non-zero)
3429 
3430         // bytes4(keccak256("transferFrom(address,address,uint256)")) = 0x23b872dd
3431         bytes memory callData = abi.encodeWithSelector(
3432             bytes4(0x23b872dd),
3433             from,
3434             to,
3435             value
3436         );
3437         (bool success, ) = token.call{gas: gasLimit}(callData);
3438         return checkReturnValue(success);
3439     }
3440 
3441     function checkReturnValue(
3442         bool success
3443         )
3444         internal
3445         pure
3446         returns (bool)
3447     {
3448         // A transfer/transferFrom is successful when 'call' is successful and depending on the token:
3449         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
3450         // - A single boolean is returned: this boolean needs to be true (non-zero)
3451         if (success) {
3452             assembly {
3453                 switch returndatasize()
3454                 // Non-standard ERC20: nothing is returned so if 'call' was successful we assume the transfer succeeded
3455                 case 0 {
3456                     success := 1
3457                 }
3458                 // Standard ERC20: a single boolean value is returned which needs to be true
3459                 case 32 {
3460                     returndatacopy(0, 0, 32)
3461                     success := mload(0)
3462                 }
3463                 // None of the above: not successful
3464                 default {
3465                     success := 0
3466                 }
3467             }
3468         }
3469         return success;
3470     }
3471 }
3472 
3473 // File: contracts/core/impl/libexchange/ExchangeTokens.sol
3474 
3475 // Copyright 2017 Loopring Technology Limited.
3476 
3477 
3478 
3479 
3480 
3481 
3482 /// @title ExchangeTokens.
3483 /// @author Daniel Wang  - <daniel@loopring.org>
3484 /// @author Brecht Devos - <brecht@loopring.org>
3485 library ExchangeTokens
3486 {
3487     using MathUint          for uint;
3488     using ERC20SafeTransfer for address;
3489     using ExchangeMode      for ExchangeData.State;
3490 
3491     event TokenRegistered(
3492         address token,
3493         uint16  tokenId
3494     );
3495 
3496     function getTokenAddress(
3497         ExchangeData.State storage S,
3498         uint16 tokenID
3499         )
3500         public
3501         view
3502         returns (address)
3503     {
3504         require(tokenID < S.tokens.length, "INVALID_TOKEN_ID");
3505         return S.tokens[tokenID].token;
3506     }
3507 
3508     function registerToken(
3509         ExchangeData.State storage S,
3510         address tokenAddress
3511         )
3512         public
3513         returns (uint16 tokenID)
3514     {
3515         require(!S.isInWithdrawalMode(), "INVALID_MODE");
3516         require(S.tokenToTokenId[tokenAddress] == 0, "TOKEN_ALREADY_EXIST");
3517         require(S.tokens.length < ExchangeData.MAX_NUM_TOKENS(), "TOKEN_REGISTRY_FULL");
3518 
3519         // Check if the deposit contract supports the new token
3520         if (S.depositContract != IDepositContract(0)) {
3521             require(
3522                 S.depositContract.isTokenSupported(tokenAddress),
3523                 "UNSUPPORTED_TOKEN"
3524             );
3525         }
3526 
3527         // Assign a tokenID and store the token
3528         ExchangeData.Token memory token = ExchangeData.Token(
3529             tokenAddress
3530         );
3531         tokenID = uint16(S.tokens.length);
3532         S.tokens.push(token);
3533         S.tokenToTokenId[tokenAddress] = tokenID + 1;
3534 
3535         emit TokenRegistered(tokenAddress, tokenID);
3536     }
3537 
3538     function getTokenID(
3539         ExchangeData.State storage S,
3540         address tokenAddress
3541         )
3542         internal  // inline call
3543         view
3544         returns (uint16 tokenID)
3545     {
3546         tokenID = S.tokenToTokenId[tokenAddress];
3547         require(tokenID != 0, "TOKEN_NOT_FOUND");
3548         tokenID = tokenID - 1;
3549     }
3550 }
3551 
3552 // File: contracts/core/impl/libexchange/ExchangeWithdrawals.sol
3553 
3554 // Copyright 2017 Loopring Technology Limited.
3555 
3556 
3557 
3558 
3559 
3560 
3561 
3562 
3563 /// @title ExchangeWithdrawals.
3564 /// @author Brecht Devos - <brecht@loopring.org>
3565 /// @author Daniel Wang  - <daniel@loopring.org>
3566 library ExchangeWithdrawals
3567 {
3568     enum WithdrawalCategory
3569     {
3570         DISTRIBUTION,
3571         FROM_MERKLE_TREE,
3572         FROM_DEPOSIT_REQUEST,
3573         FROM_APPROVED_WITHDRAWAL
3574     }
3575 
3576     using AddressUtil       for address;
3577     using AddressUtil       for address payable;
3578     using BytesUtil         for bytes;
3579     using MathUint          for uint;
3580     using ExchangeBalances  for ExchangeData.State;
3581     using ExchangeMode      for ExchangeData.State;
3582     using ExchangeTokens    for ExchangeData.State;
3583 
3584     event ForcedWithdrawalRequested(
3585         address owner,
3586         address token,
3587         uint32  accountID
3588     );
3589 
3590     event WithdrawalCompleted(
3591         uint8   category,
3592         address from,
3593         address to,
3594         address token,
3595         uint    amount
3596     );
3597 
3598     event WithdrawalFailed(
3599         uint8   category,
3600         address from,
3601         address to,
3602         address token,
3603         uint    amount
3604     );
3605 
3606     function forceWithdraw(
3607         ExchangeData.State storage S,
3608         address owner,
3609         address token,
3610         uint32  accountID
3611         )
3612         public
3613     {
3614         require(!S.isInWithdrawalMode(), "INVALID_MODE");
3615         // Limit the amount of pending forced withdrawals so that the owner cannot be overwhelmed.
3616         require(S.getNumAvailableForcedSlots() > 0, "TOO_MANY_REQUESTS_OPEN");
3617         require(accountID < ExchangeData.MAX_NUM_ACCOUNTS(), "INVALID_ACCOUNTID");
3618 
3619         uint16 tokenID = S.getTokenID(token);
3620 
3621         // A user needs to pay a fixed ETH withdrawal fee, set by the protocol.
3622         uint withdrawalFeeETH = S.loopring.forcedWithdrawalFee();
3623 
3624         // Check ETH value sent, can be larger than the expected withdraw fee
3625         require(msg.value >= withdrawalFeeETH, "INSUFFICIENT_FEE");
3626 
3627         // Send surplus of ETH back to the sender
3628         uint feeSurplus = msg.value.sub(withdrawalFeeETH);
3629         if (feeSurplus > 0) {
3630             msg.sender.sendETHAndVerify(feeSurplus, gasleft());
3631         }
3632 
3633         // There can only be a single forced withdrawal per (account, token) pair.
3634         require(
3635             S.pendingForcedWithdrawals[accountID][tokenID].timestamp == 0,
3636             "WITHDRAWAL_ALREADY_PENDING"
3637         );
3638 
3639         // Store the forced withdrawal request data
3640         S.pendingForcedWithdrawals[accountID][tokenID] = ExchangeData.ForcedWithdrawal({
3641             owner: owner,
3642             timestamp: uint64(block.timestamp)
3643         });
3644 
3645         // Increment the number of pending forced transactions so we can keep count.
3646         S.numPendingForcedTransactions++;
3647 
3648         emit ForcedWithdrawalRequested(
3649             owner,
3650             token,
3651             accountID
3652         );
3653     }
3654 
3655     // We alow anyone to withdraw these funds for the account owner
3656     function withdrawFromMerkleTree(
3657         ExchangeData.State       storage S,
3658         ExchangeData.MerkleProof calldata merkleProof
3659         )
3660         public
3661     {
3662         require(S.isInWithdrawalMode(), "NOT_IN_WITHDRAW_MODE");
3663 
3664         address owner = merkleProof.accountLeaf.owner;
3665         uint32 accountID = merkleProof.accountLeaf.accountID;
3666         uint16 tokenID = merkleProof.balanceLeaf.tokenID;
3667         uint96 balance = merkleProof.balanceLeaf.balance;
3668 
3669         // Make sure the funds aren't withdrawn already.
3670         require(S.withdrawnInWithdrawMode[accountID][tokenID] == false, "WITHDRAWN_ALREADY");
3671 
3672         // Verify that the provided Merkle tree data is valid by using the Merkle proof.
3673         ExchangeBalances.verifyAccountBalance(
3674             uint(S.merkleRoot),
3675             merkleProof
3676         );
3677 
3678         // Make sure the balance can only be withdrawn once
3679         S.withdrawnInWithdrawMode[accountID][tokenID] = true;
3680 
3681         // Transfer the tokens to the account owner
3682         transferTokens(
3683             S,
3684             uint8(WithdrawalCategory.FROM_MERKLE_TREE),
3685             owner,
3686             owner,
3687             tokenID,
3688             balance,
3689             new bytes(0),
3690             gasleft(),
3691             false
3692         );
3693     }
3694 
3695     function withdrawFromDepositRequest(
3696         ExchangeData.State storage S,
3697         address owner,
3698         address token
3699         )
3700         public
3701     {
3702         uint16 tokenID = S.getTokenID(token);
3703         ExchangeData.Deposit storage deposit = S.pendingDeposits[owner][tokenID];
3704         require(deposit.timestamp != 0, "DEPOSIT_NOT_WITHDRAWABLE_YET");
3705 
3706         // Check if the deposit has indeed exceeded the time limit of if the exchange is in withdrawal mode
3707         require(
3708             block.timestamp >= deposit.timestamp + S.maxAgeDepositUntilWithdrawable ||
3709             S.isInWithdrawalMode(),
3710             "DEPOSIT_NOT_WITHDRAWABLE_YET"
3711         );
3712 
3713         uint amount = deposit.amount;
3714 
3715         // Reset the deposit request
3716         delete S.pendingDeposits[owner][tokenID];
3717 
3718         // Transfer the tokens
3719         transferTokens(
3720             S,
3721             uint8(WithdrawalCategory.FROM_DEPOSIT_REQUEST),
3722             owner,
3723             owner,
3724             tokenID,
3725             amount,
3726             new bytes(0),
3727             gasleft(),
3728             false
3729         );
3730     }
3731 
3732     function withdrawFromApprovedWithdrawals(
3733         ExchangeData.State storage S,
3734         address[] memory owners,
3735         address[] memory tokens
3736         )
3737         public
3738     {
3739         require(owners.length == tokens.length, "INVALID_INPUT_DATA");
3740         for (uint i = 0; i < owners.length; i++) {
3741             address owner = owners[i];
3742             uint16 tokenID = S.getTokenID(tokens[i]);
3743             uint amount = S.amountWithdrawable[owner][tokenID];
3744 
3745             // Make sure this amount can't be withdrawn again
3746             delete S.amountWithdrawable[owner][tokenID];
3747 
3748             // Transfer the tokens to the owner
3749             transferTokens(
3750                 S,
3751                 uint8(WithdrawalCategory.FROM_APPROVED_WITHDRAWAL),
3752                 owner,
3753                 owner,
3754                 tokenID,
3755                 amount,
3756                 new bytes(0),
3757                 gasleft(),
3758                 false
3759             );
3760         }
3761     }
3762 
3763     function distributeWithdrawal(
3764         ExchangeData.State storage S,
3765         address from,
3766         address to,
3767         uint16  tokenID,
3768         uint    amount,
3769         bytes   memory extraData,
3770         uint    gasLimit
3771         )
3772         public
3773     {
3774         // Try to transfer the tokens
3775         bool success = transferTokens(
3776             S,
3777             uint8(WithdrawalCategory.DISTRIBUTION),
3778             from,
3779             to,
3780             tokenID,
3781             amount,
3782             extraData,
3783             gasLimit,
3784             true
3785         );
3786         // If the transfer was successful there's nothing left to do.
3787         // However, if the transfer failed the tokens are still in the contract and can be
3788         // withdrawn later to `to` by anyone by using `withdrawFromApprovedWithdrawal.
3789         if (!success) {
3790             S.amountWithdrawable[to][tokenID] = S.amountWithdrawable[to][tokenID].add(amount);
3791         }
3792     }
3793 
3794     // == Internal and Private Functions ==
3795 
3796     // If allowFailure is true the transfer can fail because of a transfer error or
3797     // because the transfer uses more than `gasLimit` gas. The function
3798     // will return true when successful, false otherwise.
3799     // If allowFailure is false the transfer is guaranteed to succeed using
3800     // as much gas as needed, otherwise it throws. The function always returns true.
3801     function transferTokens(
3802         ExchangeData.State storage S,
3803         uint8   category,
3804         address from,
3805         address to,
3806         uint16  tokenID,
3807         uint    amount,
3808         bytes   memory extraData,
3809         uint    gasLimit,
3810         bool    allowFailure
3811         )
3812         private
3813         returns (bool success)
3814     {
3815         // Redirect withdrawals to address(0) to the protocol fee vault
3816         if (to == address(0)) {
3817             to = S.loopring.protocolFeeVault();
3818         }
3819         address token = S.getTokenAddress(tokenID);
3820 
3821         // Transfer the tokens from the deposit contract to the owner
3822         if (gasLimit > 0) {
3823             try S.depositContract.withdraw{gas: gasLimit}(from, to, token, amount, extraData) {
3824                 success = true;
3825             } catch {
3826                 success = false;
3827             }
3828         } else {
3829             success = false;
3830         }
3831 
3832         require(allowFailure || success, "TRANSFER_FAILURE");
3833 
3834         if (success) {
3835             emit WithdrawalCompleted(category, from, to, token, amount);
3836 
3837             // Keep track of when the protocol fees were last withdrawn
3838             // (only done to make this data easier available).
3839             if (from == address(0)) {
3840                 S.protocolFeeLastWithdrawnTime[token] = block.timestamp;
3841             }
3842         } else {
3843             emit WithdrawalFailed(category, from, to, token, amount);
3844         }
3845     }
3846 }
3847 
3848 // File: contracts/core/impl/libtransactions/WithdrawTransaction.sol
3849 
3850 // Copyright 2017 Loopring Technology Limited.
3851 
3852 
3853 
3854 
3855 
3856 
3857 
3858 
3859 
3860 
3861 
3862 /// @title WithdrawTransaction
3863 /// @author Brecht Devos - <brecht@loopring.org>
3864 /// @dev The following 4 types of withdrawals are supported:
3865 ///      - withdrawType = 0: offchain withdrawals with EdDSA signatures
3866 ///      - withdrawType = 1: offchain withdrawals with ECDSA signatures or onchain appprovals
3867 ///      - withdrawType = 2: onchain valid forced withdrawals (owner and accountID match), or
3868 ///                          offchain operator-initiated withdrawals for protocol fees or for
3869 ///                          users in shutdown mode
3870 ///      - withdrawType = 3: onchain invalid forced withdrawals (owner and accountID mismatch)
3871 library WithdrawTransaction
3872 {
3873     using BytesUtil            for bytes;
3874     using FloatUtil            for uint;
3875     using MathUint             for uint;
3876     using ExchangeMode         for ExchangeData.State;
3877     using ExchangeSignatures   for ExchangeData.State;
3878     using ExchangeWithdrawals  for ExchangeData.State;
3879 
3880     bytes32 constant public WITHDRAWAL_TYPEHASH = keccak256(
3881         "Withdrawal(address owner,uint32 accountID,uint16 tokenID,uint96 amount,uint16 feeTokenID,uint96 maxFee,address to,bytes extraData,uint256 minGas,uint32 validUntil,uint32 storageID)"
3882     );
3883 
3884     struct Withdrawal
3885     {
3886         uint    withdrawalType;
3887         address from;
3888         uint32  fromAccountID;
3889         uint16  tokenID;
3890         uint96  amount;
3891         uint16  feeTokenID;
3892         uint96  maxFee;
3893         uint96  fee;
3894         address to;
3895         bytes   extraData;
3896         uint    minGas;
3897         uint32  validUntil;
3898         uint32  storageID;
3899         bytes20 onchainDataHash;
3900     }
3901 
3902     // Auxiliary data for each withdrawal
3903     struct WithdrawalAuxiliaryData
3904     {
3905         bool  storeRecipient;
3906         uint  gasLimit;
3907         bytes signature;
3908 
3909         uint    minGas;
3910         address to;
3911         bytes   extraData;
3912         uint96  maxFee;
3913         uint32  validUntil;
3914     }
3915 
3916     function process(
3917         ExchangeData.State        storage S,
3918         ExchangeData.BlockContext memory  ctx,
3919         bytes                     memory  data,
3920         uint                              offset,
3921         bytes                     memory  auxiliaryData
3922         )
3923         internal
3924     {
3925         Withdrawal memory withdrawal = readTx(data, offset);
3926         WithdrawalAuxiliaryData memory auxData = abi.decode(auxiliaryData, (WithdrawalAuxiliaryData));
3927 
3928         // Validate the withdrawal data not directly part of the DA
3929         bytes20 onchainDataHash = hashOnchainData(
3930             auxData.minGas,
3931             auxData.to,
3932             auxData.extraData
3933         );
3934         // Only the 20 MSB are used, which is still 80-bit of security, which is more
3935         // than enough, especially when combined with validUntil.
3936         require(withdrawal.onchainDataHash == onchainDataHash, "INVALID_WITHDRAWAL_DATA");
3937 
3938         // Fill in withdrawal data missing from DA
3939         withdrawal.to = auxData.to;
3940         withdrawal.minGas = auxData.minGas;
3941         withdrawal.extraData = auxData.extraData;
3942         withdrawal.maxFee = auxData.maxFee == 0 ? withdrawal.fee : auxData.maxFee;
3943         withdrawal.validUntil = auxData.validUntil;
3944 
3945         // If the account has an owner, don't allow withdrawing to the zero address
3946         // (which will be the protocol fee vault contract).
3947         require(withdrawal.from == address(0) || withdrawal.to != address(0), "INVALID_WITHDRAWAL_RECIPIENT");
3948 
3949         if (withdrawal.withdrawalType == 0) {
3950             // Signature checked offchain, nothing to do
3951         } else if (withdrawal.withdrawalType == 1) {
3952             // Validate
3953             require(ctx.timestamp < withdrawal.validUntil, "WITHDRAWAL_EXPIRED");
3954             require(withdrawal.fee <= withdrawal.maxFee, "WITHDRAWAL_FEE_TOO_HIGH");
3955 
3956             // Check appproval onchain
3957             // Calculate the tx hash
3958             bytes32 txHash = hashTx(ctx.DOMAIN_SEPARATOR, withdrawal);
3959             // Check onchain authorization
3960             S.requireAuthorizedTx(withdrawal.from, auxData.signature, txHash);
3961         } else if (withdrawal.withdrawalType == 2 || withdrawal.withdrawalType == 3) {
3962             // Forced withdrawals cannot make use of certain features because the
3963             // necessary data is not authorized by the account owner.
3964             // For protocol fee withdrawals, `owner` and `to` are both address(0).
3965             require(withdrawal.from == withdrawal.to, "INVALID_WITHDRAWAL_ADDRESS");
3966 
3967             // Forced withdrawal fees are charged when the request is submitted.
3968             require(withdrawal.fee == 0, "FEE_NOT_ZERO");
3969 
3970             require(withdrawal.extraData.length == 0, "AUXILIARY_DATA_NOT_ALLOWED");
3971 
3972             ExchangeData.ForcedWithdrawal memory forcedWithdrawal =
3973                 S.pendingForcedWithdrawals[withdrawal.fromAccountID][withdrawal.tokenID];
3974 
3975             if (forcedWithdrawal.timestamp != 0) {
3976                 if (withdrawal.withdrawalType == 2) {
3977                     require(withdrawal.from == forcedWithdrawal.owner, "INCONSISENT_OWNER");
3978                 } else { //withdrawal.withdrawalType == 3
3979                     require(withdrawal.from != forcedWithdrawal.owner, "INCONSISENT_OWNER");
3980                     require(withdrawal.amount == 0, "UNAUTHORIZED_WITHDRAWAL");
3981                 }
3982 
3983                 // delete the withdrawal request and free a slot
3984                 delete S.pendingForcedWithdrawals[withdrawal.fromAccountID][withdrawal.tokenID];
3985                 S.numPendingForcedTransactions--;
3986             } else {
3987                 // Allow the owner to submit full withdrawals without authorization
3988                 // - when in shutdown mode
3989                 // - to withdraw protocol fees
3990                 require(
3991                     withdrawal.fromAccountID == ExchangeData.ACCOUNTID_PROTOCOLFEE() ||
3992                     S.isShutdown(),
3993                     "FULL_WITHDRAWAL_UNAUTHORIZED"
3994                 );
3995             }
3996         } else {
3997             revert("INVALID_WITHDRAWAL_TYPE");
3998         }
3999 
4000         // Check if there is a withdrawal recipient
4001         address recipient = S.withdrawalRecipient[withdrawal.from][withdrawal.to][withdrawal.tokenID][withdrawal.amount][withdrawal.storageID];
4002         if (recipient != address(0)) {
4003             // Auxiliary data is not supported
4004             require (withdrawal.extraData.length == 0, "AUXILIARY_DATA_NOT_ALLOWED");
4005 
4006             // Set the new recipient address
4007             withdrawal.to = recipient;
4008             // Allow any amount of gas to be used on this withdrawal (which allows the transfer to be skipped)
4009             withdrawal.minGas = 0;
4010 
4011             // Do NOT delete the recipient to prevent replay attack
4012             // delete S.withdrawalRecipient[withdrawal.owner][withdrawal.to][withdrawal.tokenID][withdrawal.amount][withdrawal.storageID];
4013         } else if (auxData.storeRecipient) {
4014             // Store the destination address to mark the withdrawal as done
4015             require(withdrawal.to != address(0), "INVALID_DESTINATION_ADDRESS");
4016             S.withdrawalRecipient[withdrawal.from][withdrawal.to][withdrawal.tokenID][withdrawal.amount][withdrawal.storageID] = withdrawal.to;
4017         }
4018 
4019         // Validate gas provided
4020         require(auxData.gasLimit >= withdrawal.minGas, "OUT_OF_GAS_FOR_WITHDRAWAL");
4021 
4022         // Try to transfer the tokens with the provided gas limit
4023         S.distributeWithdrawal(
4024             withdrawal.from,
4025             withdrawal.to,
4026             withdrawal.tokenID,
4027             withdrawal.amount,
4028             withdrawal.extraData,
4029             auxData.gasLimit
4030         );
4031     }
4032 
4033     function readTx(
4034         bytes memory data,
4035         uint         offset
4036         )
4037         internal
4038         pure
4039         returns (Withdrawal memory withdrawal)
4040     {
4041         uint _offset = offset;
4042         // Extract the transfer data
4043         // We don't use abi.decode for this because of the large amount of zero-padding
4044         // bytes the circuit would also have to hash.
4045         withdrawal.withdrawalType = data.toUint8(_offset);
4046         _offset += 1;
4047         withdrawal.from = data.toAddress(_offset);
4048         _offset += 20;
4049         withdrawal.fromAccountID = data.toUint32(_offset);
4050         _offset += 4;
4051         withdrawal.tokenID = data.toUint16(_offset);
4052         _offset += 2;
4053         withdrawal.amount = data.toUint96(_offset);
4054         _offset += 12;
4055         withdrawal.feeTokenID = data.toUint16(_offset);
4056         _offset += 2;
4057         withdrawal.fee = uint(data.toUint16(_offset)).decodeFloat(16);
4058         _offset += 2;
4059         withdrawal.storageID = data.toUint32(_offset);
4060         _offset += 4;
4061         withdrawal.onchainDataHash = data.toBytes20(_offset);
4062         _offset += 20;
4063     }
4064 
4065     function hashTx(
4066         bytes32 DOMAIN_SEPARATOR,
4067         Withdrawal memory withdrawal
4068         )
4069         internal
4070         pure
4071         returns (bytes32)
4072     {
4073         return EIP712.hashPacked(
4074             DOMAIN_SEPARATOR,
4075             keccak256(
4076                 abi.encode(
4077                     WITHDRAWAL_TYPEHASH,
4078                     withdrawal.from,
4079                     withdrawal.fromAccountID,
4080                     withdrawal.tokenID,
4081                     withdrawal.amount,
4082                     withdrawal.feeTokenID,
4083                     withdrawal.maxFee,
4084                     withdrawal.to,
4085                     keccak256(withdrawal.extraData),
4086                     withdrawal.minGas,
4087                     withdrawal.validUntil,
4088                     withdrawal.storageID
4089                 )
4090             )
4091         );
4092     }
4093 
4094     function hashOnchainData(
4095         uint    minGas,
4096         address to,
4097         bytes   memory extraData
4098         )
4099         internal
4100         pure
4101         returns (bytes20)
4102     {
4103         // Only the 20 MSB are used, which is still 80-bit of security, which is more
4104         // than enough, especially when combined with validUntil.
4105         return bytes20(keccak256(
4106             abi.encodePacked(
4107                 minGas,
4108                 to,
4109                 extraData
4110             )
4111         ));
4112     }
4113 }
4114 
4115 // File: contracts/aux/transactions/TransactionReader.sol
4116 
4117 // Copyright 2017 Loopring Technology Limited.
4118 
4119 
4120 
4121 
4122 
4123 
4124 
4125 /// @title TransactionReader
4126 /// @author Brecht Devos - <brecht@loopring.org>
4127 /// @dev Utility library to read transactions.
4128 library TransactionReader {
4129     using BlockReader       for ExchangeData.Block;
4130     using TransactionReader for ExchangeData.Block;
4131     using BytesUtil         for bytes;
4132 
4133     function readDeposit(
4134         ExchangeData.Block memory _block,
4135         uint txIdx
4136         )
4137         internal
4138         pure
4139         returns (DepositTransaction.Deposit memory)
4140     {
4141         bytes memory data = _block.readTx(txIdx, ExchangeData.TransactionType.DEPOSIT);
4142         return DepositTransaction.readTx(data, 1);
4143     }
4144 
4145     function readWithdrawal(
4146         ExchangeData.Block memory _block,
4147         uint txIdx
4148         )
4149         internal
4150         pure
4151         returns (WithdrawTransaction.Withdrawal memory)
4152     {
4153         bytes memory data = _block.readTx(txIdx, ExchangeData.TransactionType.WITHDRAWAL);
4154         return WithdrawTransaction.readTx(data, 1);
4155     }
4156 
4157     function readAmmUpdate(
4158         ExchangeData.Block memory _block,
4159         uint txIdx
4160         )
4161         internal
4162         pure
4163         returns (AmmUpdateTransaction.AmmUpdate memory)
4164     {
4165         bytes memory data = _block.readTx(txIdx, ExchangeData.TransactionType.AMM_UPDATE);
4166         return AmmUpdateTransaction.readTx(data, 1);
4167     }
4168 
4169     function readTransfer(
4170         ExchangeData.Block memory _block,
4171         uint txIdx
4172         )
4173         internal
4174         pure
4175         returns (TransferTransaction.Transfer memory)
4176     {
4177         bytes memory data = _block.readTx(txIdx, ExchangeData.TransactionType.TRANSFER);
4178         return TransferTransaction.readTx(data, 1);
4179     }
4180 
4181     function readSignatureVerification(
4182         ExchangeData.Block memory _block,
4183         uint txIdx
4184         )
4185         internal
4186         pure
4187         returns (SignatureVerificationTransaction.SignatureVerification memory)
4188     {
4189         bytes memory data = _block.readTx(txIdx, ExchangeData.TransactionType.SIGNATURE_VERIFICATION);
4190         return SignatureVerificationTransaction.readTx(data, 1);
4191     }
4192 
4193     function readTx(
4194         ExchangeData.Block memory _block,
4195         uint txIdx,
4196         ExchangeData.TransactionType txType
4197         )
4198         internal
4199         pure
4200         returns (bytes memory data)
4201     {
4202         data = _block.readTransactionData(txIdx);
4203         require(txType == ExchangeData.TransactionType(data.toUint8(0)), "UNEXPTECTED_TX_TYPE");
4204     }
4205 
4206     function createMinimalBlock(
4207         ExchangeData.Block memory _block,
4208         uint txIdx,
4209         uint16 numTransactions
4210         )
4211         internal
4212         pure
4213         returns (ExchangeData.Block memory)
4214     {
4215         ExchangeData.Block memory minimalBlock = ExchangeData.Block({
4216             blockType: _block.blockType,
4217             blockSize: numTransactions,
4218             blockVersion: _block.blockVersion,
4219             data: new bytes(0),
4220             proof: _block.proof,
4221             storeBlockInfoOnchain: _block.storeBlockInfoOnchain,
4222             auxiliaryData: new ExchangeData.AuxiliaryData[](0),
4223             offchainData: new bytes(0)
4224         });
4225 
4226         bytes memory header = _block.data.slice(0, BlockReader.OFFSET_TO_TRANSACTIONS);
4227 
4228         // Extract the data of the transactions we want
4229         // Part 1
4230         uint txDataOffset = BlockReader.OFFSET_TO_TRANSACTIONS +
4231             txIdx * ExchangeData.TX_DATA_AVAILABILITY_SIZE_PART_1();
4232         bytes memory dataPart1 = _block.data.slice(txDataOffset, numTransactions * ExchangeData.TX_DATA_AVAILABILITY_SIZE_PART_1());
4233         // Part 2
4234         txDataOffset = BlockReader.OFFSET_TO_TRANSACTIONS +
4235             _block.blockSize * ExchangeData.TX_DATA_AVAILABILITY_SIZE_PART_1() +
4236             txIdx * ExchangeData.TX_DATA_AVAILABILITY_SIZE_PART_2();
4237         bytes memory dataPart2 = _block.data.slice(txDataOffset, numTransactions * ExchangeData.TX_DATA_AVAILABILITY_SIZE_PART_2());
4238 
4239         // Set the data on the block in the standard format
4240         minimalBlock.data = header.concat(dataPart1).concat(dataPart2);
4241 
4242         return minimalBlock;
4243     }
4244 }
4245 
4246 // File: contracts/core/iface/IExchangeV3.sol
4247 
4248 // Copyright 2017 Loopring Technology Limited.
4249 
4250 
4251 
4252 
4253 /// @title IExchangeV3
4254 /// @dev Note that Claimable and RentrancyGuard are inherited here to
4255 ///      ensure all data members are declared on IExchangeV3 to make it
4256 ///      easy to support upgradability through proxies.
4257 ///
4258 ///      Subclasses of this contract must NOT define constructor to
4259 ///      initialize data.
4260 ///
4261 /// @author Brecht Devos - <brecht@loopring.org>
4262 /// @author Daniel Wang  - <daniel@loopring.org>
4263 abstract contract IExchangeV3 is Claimable
4264 {
4265     // -- Events --
4266 
4267     event ExchangeCloned(
4268         address exchangeAddress,
4269         address owner,
4270         bytes32 genesisMerkleRoot
4271     );
4272 
4273     event TokenRegistered(
4274         address token,
4275         uint16  tokenId
4276     );
4277 
4278     event Shutdown(
4279         uint timestamp
4280     );
4281 
4282     event WithdrawalModeActivated(
4283         uint timestamp
4284     );
4285 
4286     event BlockSubmitted(
4287         uint    indexed blockIdx,
4288         bytes32         merkleRoot,
4289         bytes32         publicDataHash
4290     );
4291 
4292     event DepositRequested(
4293         address from,
4294         address to,
4295         address token,
4296         uint16  tokenId,
4297         uint96  amount
4298     );
4299 
4300     event ForcedWithdrawalRequested(
4301         address owner,
4302         address token,
4303         uint32  accountID
4304     );
4305 
4306     event WithdrawalCompleted(
4307         uint8   category,
4308         address from,
4309         address to,
4310         address token,
4311         uint    amount
4312     );
4313 
4314     event WithdrawalFailed(
4315         uint8   category,
4316         address from,
4317         address to,
4318         address token,
4319         uint    amount
4320     );
4321 
4322     event ProtocolFeesUpdated(
4323         uint8 takerFeeBips,
4324         uint8 makerFeeBips,
4325         uint8 previousTakerFeeBips,
4326         uint8 previousMakerFeeBips
4327     );
4328 
4329     event TransactionApproved(
4330         address owner,
4331         bytes32 transactionHash
4332     );
4333 
4334 
4335     // -- Initialization --
4336     /// @dev Initializes this exchange. This method can only be called once.
4337     /// @param  loopring The LoopringV3 contract address.
4338     /// @param  owner The owner of this exchange.
4339     /// @param  genesisMerkleRoot The initial Merkle tree state.
4340     function initialize(
4341         address loopring,
4342         address owner,
4343         bytes32 genesisMerkleRoot
4344         )
4345         virtual
4346         external;
4347 
4348     /// @dev Initialized the agent registry contract used by the exchange.
4349     ///      Can only be called by the exchange owner once.
4350     /// @param agentRegistry The agent registry contract to be used
4351     function setAgentRegistry(address agentRegistry)
4352         external
4353         virtual;
4354 
4355     /// @dev Gets the agent registry contract used by the exchange.
4356     /// @return the agent registry contract
4357     function getAgentRegistry()
4358         external
4359         virtual
4360         view
4361         returns (IAgentRegistry);
4362 
4363     ///      Can only be called by the exchange owner once.
4364     /// @param depositContract The deposit contract to be used
4365     function setDepositContract(address depositContract)
4366         external
4367         virtual;
4368 
4369     /// @dev refresh the blockVerifier contract which maybe changed in loopringV3 contract.
4370     function refreshBlockVerifier()
4371         external
4372         virtual;
4373 
4374     /// @dev Gets the deposit contract used by the exchange.
4375     /// @return the deposit contract
4376     function getDepositContract()
4377         external
4378         virtual
4379         view
4380         returns (IDepositContract);
4381 
4382     // @dev Exchange owner withdraws fees from the exchange.
4383     // @param token Fee token address
4384     // @param feeRecipient Fee recipient address
4385     function withdrawExchangeFees(
4386         address token,
4387         address feeRecipient
4388         )
4389         external
4390         virtual;
4391 
4392     // -- Constants --
4393     /// @dev Returns a list of constants used by the exchange.
4394     /// @return constants The list of constants.
4395     function getConstants()
4396         external
4397         virtual
4398         pure
4399         returns(ExchangeData.Constants memory);
4400 
4401     // -- Mode --
4402     /// @dev Returns hether the exchange is in withdrawal mode.
4403     /// @return Returns true if the exchange is in withdrawal mode, else false.
4404     function isInWithdrawalMode()
4405         external
4406         virtual
4407         view
4408         returns (bool);
4409 
4410     /// @dev Returns whether the exchange is shutdown.
4411     /// @return Returns true if the exchange is shutdown, else false.
4412     function isShutdown()
4413         external
4414         virtual
4415         view
4416         returns (bool);
4417 
4418     // -- Tokens --
4419     /// @dev Registers an ERC20 token for a token id. Note that different exchanges may have
4420     ///      different ids for the same ERC20 token.
4421     ///
4422     ///      Please note that 1 is reserved for Ether (ETH), 2 is reserved for Wrapped Ether (ETH),
4423     ///      and 3 is reserved for Loopring Token (LRC).
4424     ///
4425     ///      This function is only callable by the exchange owner.
4426     ///
4427     /// @param  tokenAddress The token's address
4428     /// @return tokenID The token's ID in this exchanges.
4429     function registerToken(
4430         address tokenAddress
4431         )
4432         external
4433         virtual
4434         returns (uint16 tokenID);
4435 
4436     /// @dev Returns the id of a registered token.
4437     /// @param  tokenAddress The token's address
4438     /// @return tokenID The token's ID in this exchanges.
4439     function getTokenID(
4440         address tokenAddress
4441         )
4442         external
4443         virtual
4444         view
4445         returns (uint16 tokenID);
4446 
4447     /// @dev Returns the address of a registered token.
4448     /// @param  tokenID The token's ID in this exchanges.
4449     /// @return tokenAddress The token's address
4450     function getTokenAddress(
4451         uint16 tokenID
4452         )
4453         external
4454         virtual
4455         view
4456         returns (address tokenAddress);
4457 
4458     // -- Stakes --
4459     /// @dev Gets the amount of LRC the owner has staked onchain for this exchange.
4460     ///      The stake will be burned if the exchange does not fulfill its duty by
4461     ///      processing user requests in time. Please note that order matching may potentially
4462     ///      performed by another party and is not part of the exchange's duty.
4463     ///
4464     /// @return The amount of LRC staked
4465     function getExchangeStake()
4466         external
4467         virtual
4468         view
4469         returns (uint);
4470 
4471     /// @dev Withdraws the amount staked for this exchange.
4472     ///      This can only be done if the exchange has been correctly shutdown:
4473     ///      - The exchange owner has shutdown the exchange
4474     ///      - All deposit requests are processed
4475     ///      - All funds are returned to the users (merkle root is reset to initial state)
4476     ///
4477     ///      Can only be called by the exchange owner.
4478     ///
4479     /// @return amountLRC The amount of LRC withdrawn
4480     function withdrawExchangeStake(
4481         address recipient
4482         )
4483         external
4484         virtual
4485         returns (uint amountLRC);
4486 
4487     /// @dev Can by called by anyone to burn the stake of the exchange when certain
4488     ///      conditions are fulfilled.
4489     ///
4490     ///      Currently this will only burn the stake of the exchange if
4491     ///      the exchange is in withdrawal mode.
4492     function burnExchangeStake()
4493         external
4494         virtual;
4495 
4496     // -- Blocks --
4497 
4498     /// @dev Gets the current Merkle root of this exchange's virtual blockchain.
4499     /// @return The current Merkle root.
4500     function getMerkleRoot()
4501         external
4502         virtual
4503         view
4504         returns (bytes32);
4505 
4506     /// @dev Gets the height of this exchange's virtual blockchain. The block height for a
4507     ///      new exchange is 1.
4508     /// @return The virtual blockchain height which is the index of the last block.
4509     function getBlockHeight()
4510         external
4511         virtual
4512         view
4513         returns (uint);
4514 
4515     /// @dev Gets some minimal info of a previously submitted block that's kept onchain.
4516     ///      A DEX can use this function to implement a payment receipt verification
4517     ///      contract with a challange-response scheme.
4518     /// @param blockIdx The block index.
4519     function getBlockInfo(uint blockIdx)
4520         external
4521         virtual
4522         view
4523         returns (ExchangeData.BlockInfo memory);
4524 
4525     /// @dev Sumbits new blocks to the rollup blockchain.
4526     ///
4527     ///      This function can only be called by the exchange operator.
4528     ///
4529     /// @param blocks The blocks being submitted
4530     ///      - blockType: The type of the new block
4531     ///      - blockSize: The number of onchain or offchain requests/settlements
4532     ///        that have been processed in this block
4533     ///      - blockVersion: The circuit version to use for verifying the block
4534     ///      - storeBlockInfoOnchain: If the block info for this block needs to be stored on-chain
4535     ///      - data: The data for this block
4536     ///      - offchainData: Arbitrary data, mainly for off-chain data-availability, i.e.,
4537     ///        the multihash of the IPFS file that contains the block data.
4538     function submitBlocks(ExchangeData.Block[] calldata blocks)
4539         external
4540         virtual;
4541 
4542     /// @dev Gets the number of available forced request slots.
4543     /// @return The number of available slots.
4544     function getNumAvailableForcedSlots()
4545         external
4546         virtual
4547         view
4548         returns (uint);
4549 
4550     // -- Deposits --
4551 
4552     /// @dev Deposits Ether or ERC20 tokens to the specified account.
4553     ///
4554     ///      This function is only callable by an agent of 'from'.
4555     ///
4556     ///      A fee to the owner is paid in ETH to process the deposit.
4557     ///      The operator is not forced to do the deposit and the user can send
4558     ///      any fee amount.
4559     ///
4560     /// @param from The address that deposits the funds to the exchange
4561     /// @param to The account owner's address receiving the funds
4562     /// @param tokenAddress The address of the token, use `0x0` for Ether.
4563     /// @param amount The amount of tokens to deposit
4564     /// @param auxiliaryData Optional extra data used by the deposit contract
4565     function deposit(
4566         address from,
4567         address to,
4568         address tokenAddress,
4569         uint96  amount,
4570         bytes   calldata auxiliaryData
4571         )
4572         external
4573         virtual
4574         payable;
4575 
4576     /// @dev Gets the amount of tokens that may be added to the owner's account.
4577     /// @param owner The destination address for the amount deposited.
4578     /// @param tokenAddress The address of the token, use `0x0` for Ether.
4579     /// @return The amount of tokens pending.
4580     function getPendingDepositAmount(
4581         address owner,
4582         address tokenAddress
4583         )
4584         external
4585         virtual
4586         view
4587         returns (uint96);
4588 
4589     // -- Withdrawals --
4590     /// @dev Submits an onchain request to force withdraw Ether or ERC20 tokens.
4591     ///      This request always withdraws the full balance.
4592     ///
4593     ///      This function is only callable by an agent of the account.
4594     ///
4595     ///      The total fee in ETH that the user needs to pay is 'withdrawalFee'.
4596     ///      If the user sends too much ETH the surplus is sent back immediately.
4597     ///
4598     ///      Note that after such an operation, it will take the owner some
4599     ///      time (no more than MAX_AGE_FORCED_REQUEST_UNTIL_WITHDRAW_MODE) to process the request
4600     ///      and create the deposit to the offchain account.
4601     ///
4602     /// @param owner The expected owner of the account
4603     /// @param tokenAddress The address of the token, use `0x0` for Ether.
4604     /// @param accountID The address the account in the Merkle tree.
4605     function forceWithdraw(
4606         address owner,
4607         address tokenAddress,
4608         uint32  accountID
4609         )
4610         external
4611         virtual
4612         payable;
4613 
4614     /// @dev Checks if a forced withdrawal is pending for an account balance.
4615     /// @param  accountID The accountID of the account to check.
4616     /// @param  token The token address
4617     /// @return True if a request is pending, false otherwise
4618     function isForcedWithdrawalPending(
4619         uint32  accountID,
4620         address token
4621         )
4622         external
4623         virtual
4624         view
4625         returns (bool);
4626 
4627     /// @dev Submits an onchain request to withdraw Ether or ERC20 tokens from the
4628     ///      protocol fees account. The complete balance is always withdrawn.
4629     ///
4630     ///      Anyone can request a withdrawal of the protocol fees.
4631     ///
4632     ///      Note that after such an operation, it will take the owner some
4633     ///      time (no more than MAX_AGE_FORCED_REQUEST_UNTIL_WITHDRAW_MODE) to process the request
4634     ///      and create the deposit to the offchain account.
4635     ///
4636     /// @param tokenAddress The address of the token, use `0x0` for Ether.
4637     function withdrawProtocolFees(
4638         address tokenAddress
4639         )
4640         external
4641         virtual
4642         payable;
4643 
4644     /// @dev Gets the time the protocol fee for a token was last withdrawn.
4645     /// @param tokenAddress The address of the token, use `0x0` for Ether.
4646     /// @return The time the protocol fee was last withdrawn.
4647     function getProtocolFeeLastWithdrawnTime(
4648         address tokenAddress
4649         )
4650         external
4651         virtual
4652         view
4653         returns (uint);
4654 
4655     /// @dev Allows anyone to withdraw funds for a specified user using the balances stored
4656     ///      in the Merkle tree. The funds will be sent to the owner of the acount.
4657     ///
4658     ///      Can only be used in withdrawal mode (i.e. when the owner has stopped
4659     ///      committing blocks and is not able to commit any more blocks).
4660     ///
4661     ///      This will NOT modify the onchain merkle root! The merkle root stored
4662     ///      onchain will remain the same after the withdrawal. We store if the user
4663     ///      has withdrawn the balance in State.withdrawnInWithdrawMode.
4664     ///
4665     /// @param  merkleProof The Merkle inclusion proof
4666     function withdrawFromMerkleTree(
4667         ExchangeData.MerkleProof calldata merkleProof
4668         )
4669         external
4670         virtual;
4671 
4672     /// @dev Checks if the balance for the account was withdrawn with `withdrawFromMerkleTree`.
4673     /// @param  accountID The accountID of the balance to check.
4674     /// @param  token The token address
4675     /// @return True if it was already withdrawn, false otherwise
4676     function isWithdrawnInWithdrawalMode(
4677         uint32  accountID,
4678         address token
4679         )
4680         external
4681         virtual
4682         view
4683         returns (bool);
4684 
4685     /// @dev Allows withdrawing funds deposited to the contract in a deposit request when
4686     ///      it was never processed by the owner within the maximum time allowed.
4687     ///
4688     ///      Can be called by anyone. The deposited tokens will be sent back to
4689     ///      the owner of the account they were deposited in.
4690     ///
4691     /// @param  owner The address of the account the withdrawal was done for.
4692     /// @param  token The token address
4693     function withdrawFromDepositRequest(
4694         address owner,
4695         address token
4696         )
4697         external
4698         virtual;
4699 
4700     /// @dev Allows withdrawing funds after a withdrawal request (either onchain
4701     ///      or offchain) was submitted in a block by the operator.
4702     ///
4703     ///      Can be called by anyone. The withdrawn tokens will be sent to
4704     ///      the owner of the account they were withdrawn out.
4705     ///
4706     ///      Normally it is should not be needed for users to call this manually.
4707     ///      Funds from withdrawal requests will be sent to the account owner
4708     ///      immediately by the owner when the block is submitted.
4709     ///      The user will however need to call this manually if the transfer failed.
4710     ///
4711     ///      Tokens and owners must have the same size.
4712     ///
4713     /// @param  owners The addresses of the account the withdrawal was done for.
4714     /// @param  tokens The token addresses
4715     function withdrawFromApprovedWithdrawals(
4716         address[] calldata owners,
4717         address[] calldata tokens
4718         )
4719         external
4720         virtual;
4721 
4722     /// @dev Gets the amount that can be withdrawn immediately with `withdrawFromApprovedWithdrawals`.
4723     /// @param  owner The address of the account the withdrawal was done for.
4724     /// @param  token The token address
4725     /// @return The amount withdrawable
4726     function getAmountWithdrawable(
4727         address owner,
4728         address token
4729         )
4730         external
4731         virtual
4732         view
4733         returns (uint);
4734 
4735     /// @dev Notifies the exchange that the owner did not process a forced request.
4736     ///      If this is indeed the case, the exchange will enter withdrawal mode.
4737     ///
4738     ///      Can be called by anyone.
4739     ///
4740     /// @param  accountID The accountID the forced request was made for
4741     /// @param  token The token address of the the forced request
4742     function notifyForcedRequestTooOld(
4743         uint32  accountID,
4744         address token
4745         )
4746         external
4747         virtual;
4748 
4749     /// @dev Allows a withdrawal to be done to an adddresss that is different
4750     ///      than initialy specified in the withdrawal request. This can be used to
4751     ///      implement functionality like fast withdrawals.
4752     ///
4753     ///      This function can only be called by an agent.
4754     ///
4755     /// @param from The address of the account that does the withdrawal.
4756     /// @param to The address to which 'amount' tokens were going to be withdrawn.
4757     /// @param token The address of the token that is withdrawn ('0x0' for ETH).
4758     /// @param amount The amount of tokens that are going to be withdrawn.
4759     /// @param storageID The storageID of the withdrawal request.
4760     /// @param newRecipient The new recipient address of the withdrawal.
4761     function setWithdrawalRecipient(
4762         address from,
4763         address to,
4764         address token,
4765         uint96  amount,
4766         uint32  storageID,
4767         address newRecipient
4768         )
4769         external
4770         virtual;
4771 
4772     /// @dev Gets the withdrawal recipient.
4773     ///
4774     /// @param from The address of the account that does the withdrawal.
4775     /// @param to The address to which 'amount' tokens were going to be withdrawn.
4776     /// @param token The address of the token that is withdrawn ('0x0' for ETH).
4777     /// @param amount The amount of tokens that are going to be withdrawn.
4778     /// @param storageID The storageID of the withdrawal request.
4779     function getWithdrawalRecipient(
4780         address from,
4781         address to,
4782         address token,
4783         uint96  amount,
4784         uint32  storageID
4785         )
4786         external
4787         virtual
4788         view
4789         returns (address);
4790 
4791     /// @dev Allows an agent to transfer ERC-20 tokens for a user using the allowance
4792     ///      the user has set for the exchange. This way the user only needs to approve a single exchange contract
4793     ///      for all exchange/agent features, which allows for a more seamless user experience.
4794     ///
4795     ///      This function can only be called by an agent.
4796     ///
4797     /// @param from The address of the account that sends the tokens.
4798     /// @param to The address to which 'amount' tokens are transferred.
4799     /// @param token The address of the token to transfer (ETH is and cannot be suppported).
4800     /// @param amount The amount of tokens transferred.
4801     function onchainTransferFrom(
4802         address from,
4803         address to,
4804         address token,
4805         uint    amount
4806         )
4807         external
4808         virtual;
4809 
4810     /// @dev Allows an agent to approve a rollup tx.
4811     ///
4812     ///      This function can only be called by an agent.
4813     ///
4814     /// @param owner The owner of the account
4815     /// @param txHash The hash of the transaction
4816     function approveTransaction(
4817         address owner,
4818         bytes32 txHash
4819         )
4820         external
4821         virtual;
4822 
4823     /// @dev Allows an agent to approve multiple rollup txs.
4824     ///
4825     ///      This function can only be called by an agent.
4826     ///
4827     /// @param owners The account owners
4828     /// @param txHashes The hashes of the transactions
4829     function approveTransactions(
4830         address[] calldata owners,
4831         bytes32[] calldata txHashes
4832         )
4833         external
4834         virtual;
4835 
4836     /// @dev Checks if a rollup tx is approved using the tx's hash.
4837     ///
4838     /// @param owner The owner of the account that needs to authorize the tx
4839     /// @param txHash The hash of the transaction
4840     /// @return True if the tx is approved, else false
4841     function isTransactionApproved(
4842         address owner,
4843         bytes32 txHash
4844         )
4845         external
4846         virtual
4847         view
4848         returns (bool);
4849 
4850     // -- Admins --
4851     /// @dev Sets the max time deposits have to wait before becoming withdrawable.
4852     /// @param newValue The new value.
4853     /// @return  The old value.
4854     function setMaxAgeDepositUntilWithdrawable(
4855         uint32 newValue
4856         )
4857         external
4858         virtual
4859         returns (uint32);
4860 
4861     /// @dev Returns the max time deposits have to wait before becoming withdrawable.
4862     /// @return The value.
4863     function getMaxAgeDepositUntilWithdrawable()
4864         external
4865         virtual
4866         view
4867         returns (uint32);
4868 
4869     /// @dev Shuts down the exchange.
4870     ///      Once the exchange is shutdown all onchain requests are permanently disabled.
4871     ///      When all requirements are fulfilled the exchange owner can withdraw
4872     ///      the exchange stake with withdrawStake.
4873     ///
4874     ///      Note that the exchange can still enter the withdrawal mode after this function
4875     ///      has been invoked successfully. To prevent entering the withdrawal mode before the
4876     ///      the echange stake can be withdrawn, all withdrawal requests still need to be handled
4877     ///      for at least MIN_TIME_IN_SHUTDOWN seconds.
4878     ///
4879     ///      Can only be called by the exchange owner.
4880     ///
4881     /// @return success True if the exchange is shutdown, else False
4882     function shutdown()
4883         external
4884         virtual
4885         returns (bool success);
4886 
4887     /// @dev Gets the protocol fees for this exchange.
4888     /// @return syncedAt The timestamp the protocol fees were last updated
4889     /// @return takerFeeBips The protocol taker fee
4890     /// @return makerFeeBips The protocol maker fee
4891     /// @return previousTakerFeeBips The previous protocol taker fee
4892     /// @return previousMakerFeeBips The previous protocol maker fee
4893     function getProtocolFeeValues()
4894         external
4895         virtual
4896         view
4897         returns (
4898             uint32 syncedAt,
4899             uint8 takerFeeBips,
4900             uint8 makerFeeBips,
4901             uint8 previousTakerFeeBips,
4902             uint8 previousMakerFeeBips
4903         );
4904 
4905     /// @dev Gets the domain separator used in this exchange.
4906     function getDomainSeparator()
4907         external
4908         virtual
4909         view
4910         returns (bytes32);
4911 }
4912 
4913 // File: contracts/lib/ERC20.sol
4914 
4915 // Copyright 2017 Loopring Technology Limited.
4916 
4917 
4918 /// @title ERC20 Token Interface
4919 /// @dev see https://github.com/ethereum/EIPs/issues/20
4920 /// @author Daniel Wang - <daniel@loopring.org>
4921 abstract contract ERC20
4922 {
4923     function totalSupply()
4924         public
4925         virtual
4926         view
4927         returns (uint);
4928 
4929     function balanceOf(
4930         address who
4931         )
4932         public
4933         virtual
4934         view
4935         returns (uint);
4936 
4937     function allowance(
4938         address owner,
4939         address spender
4940         )
4941         public
4942         virtual
4943         view
4944         returns (uint);
4945 
4946     function transfer(
4947         address to,
4948         uint value
4949         )
4950         public
4951         virtual
4952         returns (bool);
4953 
4954     function transferFrom(
4955         address from,
4956         address to,
4957         uint    value
4958         )
4959         public
4960         virtual
4961         returns (bool);
4962 
4963     function approve(
4964         address spender,
4965         uint    value
4966         )
4967         public
4968         virtual
4969         returns (bool);
4970 }
4971 
4972 // File: contracts/lib/Drainable.sol
4973 
4974 // Copyright 2017 Loopring Technology Limited.
4975 
4976 
4977 
4978 
4979 
4980 /// @title Drainable
4981 /// @author Brecht Devos - <brecht@loopring.org>
4982 /// @dev Standard functionality to allow draining funds from a contract.
4983 abstract contract Drainable
4984 {
4985     using AddressUtil       for address;
4986     using ERC20SafeTransfer for address;
4987 
4988     event Drained(
4989         address to,
4990         address token,
4991         uint    amount
4992     );
4993 
4994     function drain(
4995         address to,
4996         address token
4997         )
4998         external
4999         returns (uint amount)
5000     {
5001         require(canDrain(msg.sender, token), "UNAUTHORIZED");
5002 
5003         if (token == address(0)) {
5004             amount = address(this).balance;
5005             to.sendETHAndVerify(amount, gasleft());   // ETH
5006         } else {
5007             amount = ERC20(token).balanceOf(address(this));
5008             token.safeTransferAndVerify(to, amount);  // ERC20 token
5009         }
5010 
5011         emit Drained(to, token, amount);
5012     }
5013 
5014     // Needs to return if the address is authorized to call drain.
5015     function canDrain(address drainer, address token)
5016         public
5017         virtual
5018         view
5019         returns (bool);
5020 }
5021 
5022 // File: contracts/aux/access/SelectorBasedAccessManager.sol
5023 
5024 // Copyright 2017 Loopring Technology Limited.
5025 
5026 
5027 
5028 
5029 
5030 /// @title  SelectorBasedAccessManager
5031 /// @author Daniel Wang - <daniel@loopring.org>
5032 contract SelectorBasedAccessManager is Claimable
5033 {
5034     using BytesUtil for bytes;
5035 
5036     event PermissionUpdate(
5037         address indexed user,
5038         bytes4  indexed selector,
5039         bool            allowed
5040     );
5041 
5042     address public immutable target;
5043     mapping(address => mapping(bytes4 => bool)) public permissions;
5044 
5045     modifier withAccess(bytes4 selector)
5046     {
5047         require(hasAccessTo(msg.sender, selector), "PERMISSION_DENIED");
5048         _;
5049     }
5050 
5051     constructor(address _target)
5052     {
5053         require(_target != address(0), "ZERO_ADDRESS");
5054         target = _target;
5055     }
5056 
5057     function grantAccess(
5058         address user,
5059         bytes4  selector,
5060         bool    granted
5061         )
5062         external
5063         onlyOwner
5064     {
5065         require(permissions[user][selector] != granted, "INVALID_VALUE");
5066         permissions[user][selector] = granted;
5067         emit PermissionUpdate(user, selector, granted);
5068     }
5069 
5070     receive() payable external {}
5071 
5072     fallback()
5073         payable
5074         external
5075     {
5076         transact(msg.data);
5077     }
5078 
5079     function transact(bytes memory data)
5080         payable
5081         public
5082         withAccess(data.toBytes4(0))
5083     {
5084         (bool success, bytes memory returnData) = target
5085             .call{value: msg.value}(data);
5086 
5087         if (!success) {
5088             assembly { revert(add(returnData, 32), mload(returnData)) }
5089         }
5090     }
5091 
5092     function hasAccessTo(address user, bytes4 selector)
5093         public
5094         view
5095         returns (bool)
5096     {
5097         return user == owner || permissions[user][selector];
5098     }
5099 }
5100 
5101 // File: contracts/amm/libamm/IAmmSharedConfig.sol
5102 
5103 // Copyright 2017 Loopring Technology Limited.
5104 
5105 interface IAmmSharedConfig
5106 {
5107     function maxForcedExitAge() external view returns (uint);
5108     function maxForcedExitCount() external view returns (uint);
5109     function forcedExitFee() external view returns (uint);
5110 }
5111 
5112 // File: contracts/amm/libamm/AmmData.sol
5113 
5114 // Copyright 2017 Loopring Technology Limited.
5115 
5116 
5117 
5118 
5119 
5120 /// @title AmmData
5121 library AmmData
5122 {
5123     function POOL_TOKEN_BASE() internal pure returns (uint) { return 100 * (10 ** 8); }
5124     function POOL_TOKEN_MINTED_SUPPLY() internal pure returns (uint) { return uint96(-1); }
5125 
5126     enum PoolTxType
5127     {
5128         NOOP,
5129         JOIN,
5130         EXIT
5131     }
5132 
5133     struct PoolConfig
5134     {
5135         address   sharedConfig;
5136         address   exchange;
5137         string    poolName;
5138         uint32    accountID;
5139         address[] tokens;
5140         uint96[]  weights;
5141         uint8     feeBips;
5142         string    tokenSymbol;
5143     }
5144 
5145     struct PoolJoin
5146     {
5147         address   owner;
5148         uint96[]  joinAmounts;
5149         uint32[]  joinStorageIDs;
5150         uint96    mintMinAmount;
5151         uint32    validUntil;
5152     }
5153 
5154     struct PoolExit
5155     {
5156         address   owner;
5157         uint96    burnAmount;
5158         uint32    burnStorageID; // for pool token withdrawal from user to the pool
5159         uint96[]  exitMinAmounts; // the amount to receive BEFORE paying the fee.
5160         uint96    fee;
5161         uint32    validUntil;
5162     }
5163 
5164     struct PoolTx
5165     {
5166         PoolTxType txType;
5167         bytes      data;
5168         bytes      signature;
5169     }
5170 
5171     struct Token
5172     {
5173         address addr;
5174         uint96  weight;
5175         uint16  tokenID;
5176     }
5177 
5178     struct Context
5179     {
5180         // functional parameters
5181         uint txIdx;
5182 
5183         // Exchange state variables
5184         IExchangeV3 exchange;
5185         bytes32     exchangeDomainSeparator;
5186 
5187         // AMM pool state variables
5188         bytes32 domainSeparator;
5189         uint32  accountID;
5190 
5191         uint16  poolTokenID;
5192         uint    totalSupply;
5193 
5194         Token[]  tokens;
5195         uint96[] tokenBalancesL2;
5196     }
5197 
5198     struct State {
5199         // Pool token state variables
5200         string poolName;
5201         string symbol;
5202         uint   _totalSupply;
5203 
5204         mapping(address => uint) balanceOf;
5205         mapping(address => mapping(address => uint)) allowance;
5206         mapping(address => uint) nonces;
5207 
5208         // AMM pool state variables
5209         IAmmSharedConfig sharedConfig;
5210 
5211         Token[]     tokens;
5212 
5213         // The order of the following variables important to minimize loads
5214         bytes32     exchangeDomainSeparator;
5215         bytes32     domainSeparator;
5216         IExchangeV3 exchange;
5217         uint32      accountID;
5218         uint16      poolTokenID;
5219         uint8       feeBips;
5220 
5221         address     exchangeOwner;
5222 
5223         uint64      shutdownTimestamp;
5224         uint16      forcedExitCount;
5225 
5226         // A map from a user to the forced exit.
5227         mapping (address => PoolExit) forcedExit;
5228         mapping (bytes32 => bool) approvedTx;
5229     }
5230 }
5231 
5232 // File: contracts/aux/access/IBlockReceiver.sol
5233 
5234 // Copyright 2017 Loopring Technology Limited.
5235 
5236 
5237 
5238 /// @title IBlockReceiver
5239 /// @author Brecht Devos - <brecht@loopring.org>
5240 abstract contract IBlockReceiver
5241 {
5242     function beforeBlockSubmission(
5243         ExchangeData.Block memory _block,
5244         bytes              memory data,
5245         uint                      txIdx,
5246         uint                      numTxs
5247         )
5248         external
5249         virtual;
5250 }
5251 
5252 // File: contracts/aux/access/LoopringIOExchangeOwner.sol
5253 
5254 // Copyright 2017 Loopring Technology Limited.
5255 
5256 
5257 
5258 
5259 
5260 
5261 
5262 
5263 
5264 
5265 
5266 
5267 
5268 contract LoopringIOExchangeOwner is SelectorBasedAccessManager, ERC1271, Drainable
5269 {
5270     using AddressUtil       for address;
5271     using AddressUtil       for address payable;
5272     using BytesUtil         for bytes;
5273     using MathUint          for uint;
5274     using SignatureUtil     for bytes32;
5275     using TransactionReader for ExchangeData.Block;
5276 
5277     bytes4 private constant SUBMITBLOCKS_SELECTOR  = IExchangeV3.submitBlocks.selector;
5278     bool   public  open;
5279 
5280     event SubmitBlocksAccessOpened(bool open);
5281 
5282     struct TxCallback
5283     {
5284         uint16 txIdx;
5285         uint16 numTxs;
5286         uint16 receiverIdx;
5287         bytes  data;
5288     }
5289 
5290     struct BlockCallback
5291     {
5292         uint16        blockIdx;
5293         TxCallback[]  txCallbacks;
5294     }
5295 
5296     struct CallbackConfig
5297     {
5298         BlockCallback[] blockCallbacks;
5299         address[]       receivers;
5300     }
5301 
5302     constructor(address _exchange)
5303         SelectorBasedAccessManager(_exchange)
5304     {
5305     }
5306 
5307     function openAccessToSubmitBlocks(bool _open)
5308         external
5309         onlyOwner
5310     {
5311         open = _open;
5312         emit SubmitBlocksAccessOpened(_open);
5313     }
5314 
5315     function isValidSignature(
5316         bytes32        signHash,
5317         bytes   memory signature
5318         )
5319         public
5320         view
5321         override
5322         returns (bytes4)
5323     {
5324         // Role system used a bit differently here.
5325         return hasAccessTo(
5326             signHash.recoverECDSASigner(signature),
5327             this.isValidSignature.selector
5328         ) ? ERC1271_MAGICVALUE : bytes4(0);
5329     }
5330 
5331     function canDrain(address drainer, address /* token */)
5332         public
5333         override
5334         view
5335         returns (bool)
5336     {
5337         return hasAccessTo(drainer, this.drain.selector);
5338     }
5339 
5340     function submitBlocksWithCallbacks(
5341         bool                     isDataCompressed,
5342         bytes           calldata data,
5343         CallbackConfig  calldata config
5344         )
5345         external
5346     {
5347         if (config.blockCallbacks.length > 0) {
5348             require(config.receivers.length > 0, "MISSING_RECEIVERS");
5349 
5350             // Make sure the receiver is authorized to approve transactions
5351             IAgentRegistry agentRegistry = IExchangeV3(target).getAgentRegistry();
5352             for (uint i = 0; i < config.receivers.length; i++) {
5353                 require(agentRegistry.isUniversalAgent(config.receivers[i]), "UNAUTHORIZED_RECEIVER");
5354             }
5355         }
5356 
5357         require(
5358             hasAccessTo(msg.sender, SUBMITBLOCKS_SELECTOR) || open,
5359             "PERMISSION_DENIED"
5360         );
5361         bytes memory decompressed = isDataCompressed ?
5362             ZeroDecompressor.decompress(data, 1):
5363             data;
5364 
5365         require(
5366             decompressed.toBytes4(0) == SUBMITBLOCKS_SELECTOR,
5367             "INVALID_DATA"
5368         );
5369 
5370         // Decode the blocks
5371         ExchangeData.Block[] memory blocks = _decodeBlocks(decompressed);
5372 
5373         // Process the callback logic.
5374         _beforeBlockSubmission(blocks, config);
5375 
5376         target.fastCallAndVerify(gasleft(), 0, decompressed);
5377     }
5378 
5379     function _beforeBlockSubmission(
5380         ExchangeData.Block[] memory   blocks,
5381         CallbackConfig       calldata config
5382         )
5383         private
5384     {
5385         // Allocate memory to verify transactions that are approved
5386         bool[][] memory preApprovedTxs = new bool[][](blocks.length);
5387         for (uint i = 0; i < blocks.length; i++) {
5388             preApprovedTxs[i] = new bool[](blocks[i].blockSize);
5389         }
5390 
5391         // Process transactions
5392         int lastBlockIdx = -1;
5393         for (uint i = 0; i < config.blockCallbacks.length; i++) {
5394             BlockCallback calldata blockCallback = config.blockCallbacks[i];
5395 
5396             uint16 blockIdx = blockCallback.blockIdx;
5397             require(blockIdx > lastBlockIdx, "BLOCK_INDEX_OUT_OF_ORDER");
5398             lastBlockIdx = int(blockIdx);
5399 
5400             require(blockIdx < blocks.length, "INVALID_BLOCKIDX");
5401             ExchangeData.Block memory _block = blocks[blockIdx];
5402 
5403             _processTxCallbacks(
5404                 _block,
5405                 blockCallback.txCallbacks,
5406                 config.receivers,
5407                 preApprovedTxs[blockIdx]
5408             );
5409         }
5410 
5411         // Verify the approved transactions data against the auxiliary data in the block
5412         for (uint i = 0; i < blocks.length; i++) {
5413             bool[] memory _preApprovedTxs = preApprovedTxs[i];
5414             ExchangeData.AuxiliaryData[] memory auxiliaryData = blocks[i].auxiliaryData;
5415             for(uint j = 0; j < auxiliaryData.length; j++) {
5416                 // Load the data from auxiliaryData, which is still encoded as calldata
5417                 uint txIdx;
5418                 bool approved;
5419                 assembly {
5420                     // Offset to auxiliaryData[j]
5421                     let auxOffset := mload(add(auxiliaryData, add(32, mul(32, j))))
5422                     // Load `txIdx` (pos 0) and `approved` (pos 1) in auxiliaryData[j]
5423                     txIdx := mload(add(add(32, auxiliaryData), auxOffset))
5424                     approved := mload(add(add(64, auxiliaryData), auxOffset))
5425                 }
5426                 // Check that the provided data matches the expected value
5427                 require(_preApprovedTxs[txIdx] == approved, "PRE_APPROVED_TX_MISMATCH");
5428             }
5429         }
5430     }
5431 
5432     function _processTxCallbacks(
5433         ExchangeData.Block memory _block,
5434         TxCallback[]       calldata txCallbacks,
5435         address[]          calldata receivers,
5436         bool[]             memory   preApprovedTxs
5437         )
5438         private
5439     {
5440         uint cursor = 0;
5441 
5442         for (uint i = 0; i < txCallbacks.length; i++) {
5443             TxCallback calldata txCallback = txCallbacks[i];
5444 
5445             uint txIdx = uint(txCallback.txIdx);
5446             require(txIdx >= cursor, "TX_INDEX_OUT_OF_ORDER");
5447 
5448             uint16 receiverIdx = txCallback.receiverIdx;
5449             require(receiverIdx < receivers.length, "INVALID_RECEIVER_INDEX");
5450 
5451             ExchangeData.Block memory minimalBlock = _block.createMinimalBlock(txIdx, txCallback.numTxs);
5452             IBlockReceiver(receivers[receiverIdx]).beforeBlockSubmission(
5453                 minimalBlock,
5454                 txCallback.data,
5455                 0,
5456                 txCallback.numTxs
5457             );
5458 
5459             // Now that the transactions have been verified, mark them as approved
5460             for (uint j = txIdx; j < txIdx + txCallback.numTxs; j++) {
5461                 preApprovedTxs[j] = true;
5462             }
5463 
5464             cursor = txIdx + txCallback.numTxs;
5465         }
5466     }
5467 
5468     function _decodeBlocks(bytes memory data)
5469         private
5470         pure
5471         returns (ExchangeData.Block[] memory)
5472     {
5473         // This copies the data (expensive) instead of just pointing to the correct address
5474         //bytes memory blockData;
5475         //assembly {
5476         //    blockData := add(data, 4)
5477         //}
5478         //ExchangeData.Block[] memory blocks = abi.decode(blockData, (ExchangeData.Block[]));
5479 
5480         // Points the block data to the data in the abi encoded data.
5481         // Only sets the data necessary in the callbacks!
5482         // 36 := 4 (function selector) + 32 (offset to blocks)
5483         uint numBlocks = data.toUint(36);
5484         ExchangeData.Block[] memory blocks = new ExchangeData.Block[](numBlocks);
5485         for (uint i = 0; i < numBlocks; i++) {
5486             ExchangeData.Block memory _block = blocks[i];
5487 
5488             // 68 := 36 (see above) + 32 (blocks length)
5489             uint blockOffset = 68 + data.toUint(68 + i*32);
5490 
5491             uint offset = blockOffset;
5492             //_block.blockType = uint8(data.toUint(offset));
5493             offset += 32;
5494             _block.blockSize = uint16(data.toUint(offset));
5495             offset += 32;
5496             //_block.blockVersion = uint8(data.toUint(offset));
5497             offset += 32;
5498             uint blockDataOffset = data.toUint(offset);
5499             offset += 32;
5500             // Skip over proof
5501             offset += 32 * 8;
5502             // Skip over storeBlockInfoOnchain
5503             offset += 32;
5504             uint auxiliaryDataOffset = data.toUint(offset);
5505             offset += 32;
5506 
5507             bytes memory blockData;
5508             assembly {
5509                 blockData := add(data, add(32, add(blockOffset, blockDataOffset)))
5510             }
5511             _block.data = blockData;
5512 
5513             ExchangeData.AuxiliaryData[] memory auxiliaryData;
5514             assembly {
5515                 auxiliaryData := add(data, add(32, add(blockOffset, auxiliaryDataOffset)))
5516             }
5517             // Still encoded as calldata!
5518             _block.auxiliaryData = auxiliaryData;
5519         }
5520         return blocks;
5521     }
5522 }