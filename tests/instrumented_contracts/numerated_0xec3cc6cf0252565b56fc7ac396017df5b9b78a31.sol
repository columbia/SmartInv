1 // SPDX-License-Identifier: Apache-2.0
2 // Copyright 2017 Loopring Technology Limited.
3 pragma solidity ^0.7.0;
4 
5 interface IAgent{}
6 
7 interface IAgentRegistry
8 {
9     /// @dev Returns whether an agent address is an agent of an account owner
10     /// @param owner The account owner.
11     /// @param agent The agent address
12     /// @return True if the agent address is an agent for the account owner, else false
13     function isAgent(
14         address owner,
15         address agent
16         )
17         external
18         view
19         returns (bool);
20 
21     /// @dev Returns whether an agent address is an agent of all account owners
22     /// @param owners The account owners.
23     /// @param agent The agent address
24     /// @return True if the agent address is an agent for the account owner, else false
25     function isAgent(
26         address[] calldata owners,
27         address            agent
28         )
29         external
30         view
31         returns (bool);
32 }
33 
34 // Copyright 2017 Loopring Technology Limited.
35 
36 
37 
38 /// @title Ownable
39 /// @author Brecht Devos - <brecht@loopring.org>
40 /// @dev The Ownable contract has an owner address, and provides basic
41 ///      authorization control functions, this simplifies the implementation of
42 ///      "user permissions".
43 contract Ownable
44 {
45     address public owner;
46 
47     event OwnershipTransferred(
48         address indexed previousOwner,
49         address indexed newOwner
50     );
51 
52     /// @dev The Ownable constructor sets the original `owner` of the contract
53     ///      to the sender.
54     constructor()
55     {
56         owner = msg.sender;
57     }
58 
59     /// @dev Throws if called by any account other than the owner.
60     modifier onlyOwner()
61     {
62         require(msg.sender == owner, "UNAUTHORIZED");
63         _;
64     }
65 
66     /// @dev Allows the current owner to transfer control of the contract to a
67     ///      new owner.
68     /// @param newOwner The address to transfer ownership to.
69     function transferOwnership(
70         address newOwner
71         )
72         public
73         virtual
74         onlyOwner
75     {
76         require(newOwner != address(0), "ZERO_ADDRESS");
77         emit OwnershipTransferred(owner, newOwner);
78         owner = newOwner;
79     }
80 
81     function renounceOwnership()
82         public
83         onlyOwner
84     {
85         emit OwnershipTransferred(owner, address(0));
86         owner = address(0);
87     }
88 }
89 
90 // Copyright 2017 Loopring Technology Limited.
91 
92 
93 
94 
95 
96 /// @title Claimable
97 /// @author Brecht Devos - <brecht@loopring.org>
98 /// @dev Extension for the Ownable contract, where the ownership needs
99 ///      to be claimed. This allows the new owner to accept the transfer.
100 contract Claimable is Ownable
101 {
102     address public pendingOwner;
103 
104     /// @dev Modifier throws if called by any account other than the pendingOwner.
105     modifier onlyPendingOwner() {
106         require(msg.sender == pendingOwner, "UNAUTHORIZED");
107         _;
108     }
109 
110     /// @dev Allows the current owner to set the pendingOwner address.
111     /// @param newOwner The address to transfer ownership to.
112     function transferOwnership(
113         address newOwner
114         )
115         public
116         override
117         onlyOwner
118     {
119         require(newOwner != address(0) && newOwner != owner, "INVALID_ADDRESS");
120         pendingOwner = newOwner;
121     }
122 
123     /// @dev Allows the pendingOwner address to finalize the transfer.
124     function claimOwnership()
125         public
126         onlyPendingOwner
127     {
128         emit OwnershipTransferred(owner, pendingOwner);
129         owner = pendingOwner;
130         pendingOwner = address(0);
131     }
132 }
133 
134 // Copyright 2017 Loopring Technology Limited.
135 
136 
137 abstract contract ERC1271 {
138     // bytes4(keccak256("isValidSignature(bytes32,bytes)")
139     bytes4 constant internal ERC1271_MAGICVALUE = 0x1626ba7e;
140 
141     function isValidSignature(
142         bytes32      _hash,
143         bytes memory _signature)
144         public
145         view
146         virtual
147         returns (bytes4 magicValueB32);
148 
149 }
150 
151 // Copyright 2017 Loopring Technology Limited.
152 
153 
154 
155 /// @title Utility Functions for uint
156 /// @author Daniel Wang - <daniel@loopring.org>
157 library MathUint
158 {
159     using MathUint for uint;
160 
161     function mul(
162         uint a,
163         uint b
164         )
165         internal
166         pure
167         returns (uint c)
168     {
169         c = a * b;
170         require(a == 0 || c / a == b, "MUL_OVERFLOW");
171     }
172 
173     function sub(
174         uint a,
175         uint b
176         )
177         internal
178         pure
179         returns (uint)
180     {
181         require(b <= a, "SUB_UNDERFLOW");
182         return a - b;
183     }
184 
185     function add(
186         uint a,
187         uint b
188         )
189         internal
190         pure
191         returns (uint c)
192     {
193         c = a + b;
194         require(c >= a, "ADD_OVERFLOW");
195     }
196 
197     function add64(
198         uint64 a,
199         uint64 b
200         )
201         internal
202         pure
203         returns (uint64 c)
204     {
205         c = a + b;
206         require(c >= a, "ADD_OVERFLOW");
207     }
208 }
209 
210 // Copyright 2017 Loopring Technology Limited.
211 
212 pragma experimental ABIEncoderV2;
213 
214 
215 //Mainly taken from https://github.com/GNSPS/solidity-bytes-utils/blob/master/contracts/BytesLib.sol
216 
217 
218 library BytesUtil {
219 
220     function concat(
221         bytes memory _preBytes,
222         bytes memory _postBytes
223     )
224         internal
225         pure
226         returns (bytes memory)
227     {
228         bytes memory tempBytes;
229 
230         assembly {
231             // Get a location of some free memory and store it in tempBytes as
232             // Solidity does for memory variables.
233             tempBytes := mload(0x40)
234 
235             // Store the length of the first bytes array at the beginning of
236             // the memory for tempBytes.
237             let length := mload(_preBytes)
238             mstore(tempBytes, length)
239 
240             // Maintain a memory counter for the current write location in the
241             // temp bytes array by adding the 32 bytes for the array length to
242             // the starting location.
243             let mc := add(tempBytes, 0x20)
244             // Stop copying when the memory counter reaches the length of the
245             // first bytes array.
246             let end := add(mc, length)
247 
248             for {
249                 // Initialize a copy counter to the start of the _preBytes data,
250                 // 32 bytes into its memory.
251                 let cc := add(_preBytes, 0x20)
252             } lt(mc, end) {
253                 // Increase both counters by 32 bytes each iteration.
254                 mc := add(mc, 0x20)
255                 cc := add(cc, 0x20)
256             } {
257                 // Write the _preBytes data into the tempBytes memory 32 bytes
258                 // at a time.
259                 mstore(mc, mload(cc))
260             }
261 
262             // Add the length of _postBytes to the current length of tempBytes
263             // and store it as the new length in the first 32 bytes of the
264             // tempBytes memory.
265             length := mload(_postBytes)
266             mstore(tempBytes, add(length, mload(tempBytes)))
267 
268             // Move the memory counter back from a multiple of 0x20 to the
269             // actual end of the _preBytes data.
270             mc := end
271             // Stop copying when the memory counter reaches the new combined
272             // length of the arrays.
273             end := add(mc, length)
274 
275             for {
276                 let cc := add(_postBytes, 0x20)
277             } lt(mc, end) {
278                 mc := add(mc, 0x20)
279                 cc := add(cc, 0x20)
280             } {
281                 mstore(mc, mload(cc))
282             }
283 
284             // Update the free-memory pointer by padding our last write location
285             // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
286             // next 32 byte block, then round down to the nearest multiple of
287             // 32. If the sum of the length of the two arrays is zero then add
288             // one before rounding down to leave a blank 32 bytes (the length block with 0).
289             mstore(0x40, and(
290               add(add(end, iszero(add(length, mload(_preBytes)))), 31),
291               not(31) // Round down to the nearest 32 bytes.
292             ))
293         }
294 
295         return tempBytes;
296     }
297 
298     function slice(
299         bytes memory _bytes,
300         uint _start,
301         uint _length
302     )
303         internal
304         pure
305         returns (bytes memory)
306     {
307         require(_bytes.length >= (_start + _length));
308 
309         bytes memory tempBytes;
310 
311         assembly {
312             switch iszero(_length)
313             case 0 {
314                 // Get a location of some free memory and store it in tempBytes as
315                 // Solidity does for memory variables.
316                 tempBytes := mload(0x40)
317 
318                 // The first word of the slice result is potentially a partial
319                 // word read from the original array. To read it, we calculate
320                 // the length of that partial word and start copying that many
321                 // bytes into the array. The first word we copy will start with
322                 // data we don't care about, but the last `lengthmod` bytes will
323                 // land at the beginning of the contents of the new array. When
324                 // we're done copying, we overwrite the full first word with
325                 // the actual length of the slice.
326                 let lengthmod := and(_length, 31)
327 
328                 // The multiplication in the next line is necessary
329                 // because when slicing multiples of 32 bytes (lengthmod == 0)
330                 // the following copy loop was copying the origin's length
331                 // and then ending prematurely not copying everything it should.
332                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
333                 let end := add(mc, _length)
334 
335                 for {
336                     // The multiplication in the next line has the same exact purpose
337                     // as the one above.
338                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
339                 } lt(mc, end) {
340                     mc := add(mc, 0x20)
341                     cc := add(cc, 0x20)
342                 } {
343                     mstore(mc, mload(cc))
344                 }
345 
346                 mstore(tempBytes, _length)
347 
348                 //update free-memory pointer
349                 //allocating the array padded to 32 bytes like the compiler does now
350                 mstore(0x40, and(add(mc, 31), not(31)))
351             }
352             //if we want a zero-length slice let's just return a zero-length array
353             default {
354                 tempBytes := mload(0x40)
355 
356                 mstore(0x40, add(tempBytes, 0x20))
357             }
358         }
359 
360         return tempBytes;
361     }
362 
363     function toAddress(bytes memory _bytes, uint _start) internal  pure returns (address) {
364         require(_bytes.length >= (_start + 20));
365         address tempAddress;
366 
367         assembly {
368             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
369         }
370 
371         return tempAddress;
372     }
373 
374     function toUint8(bytes memory _bytes, uint _start) internal  pure returns (uint8) {
375         require(_bytes.length >= (_start + 1));
376         uint8 tempUint;
377 
378         assembly {
379             tempUint := mload(add(add(_bytes, 0x1), _start))
380         }
381 
382         return tempUint;
383     }
384 
385     function toUint16(bytes memory _bytes, uint _start) internal  pure returns (uint16) {
386         require(_bytes.length >= (_start + 2));
387         uint16 tempUint;
388 
389         assembly {
390             tempUint := mload(add(add(_bytes, 0x2), _start))
391         }
392 
393         return tempUint;
394     }
395 
396     function toUint24(bytes memory _bytes, uint _start) internal  pure returns (uint24) {
397         require(_bytes.length >= (_start + 3));
398         uint24 tempUint;
399 
400         assembly {
401             tempUint := mload(add(add(_bytes, 0x3), _start))
402         }
403 
404         return tempUint;
405     }
406 
407     function toUint32(bytes memory _bytes, uint _start) internal  pure returns (uint32) {
408         require(_bytes.length >= (_start + 4));
409         uint32 tempUint;
410 
411         assembly {
412             tempUint := mload(add(add(_bytes, 0x4), _start))
413         }
414 
415         return tempUint;
416     }
417 
418     function toUint64(bytes memory _bytes, uint _start) internal  pure returns (uint64) {
419         require(_bytes.length >= (_start + 8));
420         uint64 tempUint;
421 
422         assembly {
423             tempUint := mload(add(add(_bytes, 0x8), _start))
424         }
425 
426         return tempUint;
427     }
428 
429     function toUint96(bytes memory _bytes, uint _start) internal  pure returns (uint96) {
430         require(_bytes.length >= (_start + 12));
431         uint96 tempUint;
432 
433         assembly {
434             tempUint := mload(add(add(_bytes, 0xc), _start))
435         }
436 
437         return tempUint;
438     }
439 
440     function toUint128(bytes memory _bytes, uint _start) internal  pure returns (uint128) {
441         require(_bytes.length >= (_start + 16));
442         uint128 tempUint;
443 
444         assembly {
445             tempUint := mload(add(add(_bytes, 0x10), _start))
446         }
447 
448         return tempUint;
449     }
450 
451     function toUint(bytes memory _bytes, uint _start) internal  pure returns (uint256) {
452         require(_bytes.length >= (_start + 32));
453         uint256 tempUint;
454 
455         assembly {
456             tempUint := mload(add(add(_bytes, 0x20), _start))
457         }
458 
459         return tempUint;
460     }
461 
462     function toBytes4(bytes memory _bytes, uint _start) internal  pure returns (bytes4) {
463         require(_bytes.length >= (_start + 4));
464         bytes4 tempBytes4;
465 
466         assembly {
467             tempBytes4 := mload(add(add(_bytes, 0x20), _start))
468         }
469 
470         return tempBytes4;
471     }
472 
473     function toBytes20(bytes memory _bytes, uint _start) internal  pure returns (bytes20) {
474         require(_bytes.length >= (_start + 20));
475         bytes20 tempBytes20;
476 
477         assembly {
478             tempBytes20 := mload(add(add(_bytes, 0x20), _start))
479         }
480 
481         return tempBytes20;
482     }
483 
484     function toBytes32(bytes memory _bytes, uint _start) internal  pure returns (bytes32) {
485         require(_bytes.length >= (_start + 32));
486         bytes32 tempBytes32;
487 
488         assembly {
489             tempBytes32 := mload(add(add(_bytes, 0x20), _start))
490         }
491 
492         return tempBytes32;
493     }
494 
495     function fastSHA256(
496         bytes memory data
497         )
498         internal
499         view
500         returns (bytes32)
501     {
502         bytes32[] memory result = new bytes32[](1);
503         bool success;
504         assembly {
505              let ptr := add(data, 32)
506              success := staticcall(sub(gas(), 2000), 2, ptr, mload(data), add(result, 32), 32)
507         }
508         require(success, "SHA256_FAILED");
509         return result[0];
510     }
511 }
512 
513 // Copyright 2017 Loopring Technology Limited.
514 
515 
516 
517 /// @title Utility Functions for addresses
518 /// @author Daniel Wang - <daniel@loopring.org>
519 /// @author Brecht Devos - <brecht@loopring.org>
520 library AddressUtil
521 {
522     using AddressUtil for *;
523 
524     function isContract(
525         address addr
526         )
527         internal
528         view
529         returns (bool)
530     {
531         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
532         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
533         // for accounts without code, i.e. `keccak256('')`
534         bytes32 codehash;
535         // solhint-disable-next-line no-inline-assembly
536         assembly { codehash := extcodehash(addr) }
537         return (codehash != 0x0 &&
538                 codehash != 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470);
539     }
540 
541     function toPayable(
542         address addr
543         )
544         internal
545         pure
546         returns (address payable)
547     {
548         return payable(addr);
549     }
550 
551     // Works like address.send but with a customizable gas limit
552     // Make sure your code is safe for reentrancy when using this function!
553     function sendETH(
554         address to,
555         uint    amount,
556         uint    gasLimit
557         )
558         internal
559         returns (bool success)
560     {
561         if (amount == 0) {
562             return true;
563         }
564         address payable recipient = to.toPayable();
565         /* solium-disable-next-line */
566         (success, ) = recipient.call{value: amount, gas: gasLimit}("");
567     }
568 
569     // Works like address.transfer but with a customizable gas limit
570     // Make sure your code is safe for reentrancy when using this function!
571     function sendETHAndVerify(
572         address to,
573         uint    amount,
574         uint    gasLimit
575         )
576         internal
577         returns (bool success)
578     {
579         success = to.sendETH(amount, gasLimit);
580         require(success, "TRANSFER_FAILURE");
581     }
582 
583     // Works like call but is slightly more efficient when data
584     // needs to be copied from memory to do the call.
585     function fastCall(
586         address to,
587         uint    gasLimit,
588         uint    value,
589         bytes   memory data
590         )
591         internal
592         returns (bool success, bytes memory returnData)
593     {
594         if (to != address(0)) {
595             assembly {
596                 // Do the call
597                 success := call(gasLimit, to, value, add(data, 32), mload(data), 0, 0)
598                 // Copy the return data
599                 let size := returndatasize()
600                 returnData := mload(0x40)
601                 mstore(returnData, size)
602                 returndatacopy(add(returnData, 32), 0, size)
603                 // Update free memory pointer
604                 mstore(0x40, add(returnData, add(32, size)))
605             }
606         }
607     }
608 
609     // Like fastCall, but throws when the call is unsuccessful.
610     function fastCallAndVerify(
611         address to,
612         uint    gasLimit,
613         uint    value,
614         bytes   memory data
615         )
616         internal
617         returns (bytes memory returnData)
618     {
619         bool success;
620         (success, returnData) = fastCall(to, gasLimit, value, data);
621         if (!success) {
622             assembly {
623                 revert(add(returnData, 32), mload(returnData))
624             }
625         }
626     }
627 }
628 
629 
630 
631 
632 
633 /// @title SignatureUtil
634 /// @author Daniel Wang - <daniel@loopring.org>
635 /// @dev This method supports multihash standard. Each signature's last byte indicates
636 ///      the signature's type.
637 library SignatureUtil
638 {
639     using BytesUtil     for bytes;
640     using MathUint      for uint;
641     using AddressUtil   for address;
642 
643     enum SignatureType {
644         ILLEGAL,
645         INVALID,
646         EIP_712,
647         ETH_SIGN,
648         WALLET   // deprecated
649     }
650 
651     bytes4 constant internal ERC1271_MAGICVALUE = 0x1626ba7e;
652 
653     function verifySignatures(
654         bytes32          signHash,
655         address[] memory signers,
656         bytes[]   memory signatures
657         )
658         internal
659         view
660         returns (bool)
661     {
662         require(signers.length == signatures.length, "BAD_SIGNATURE_DATA");
663         address lastSigner;
664         for (uint i = 0; i < signers.length; i++) {
665             require(signers[i] > lastSigner, "INVALID_SIGNERS_ORDER");
666             lastSigner = signers[i];
667             if (!verifySignature(signHash, signers[i], signatures[i])) {
668                 return false;
669             }
670         }
671         return true;
672     }
673 
674     function verifySignature(
675         bytes32        signHash,
676         address        signer,
677         bytes   memory signature
678         )
679         internal
680         view
681         returns (bool)
682     {
683         if (signer == address(0)) {
684             return false;
685         }
686 
687         return signer.isContract()?
688             verifyERC1271Signature(signHash, signer, signature):
689             verifyEOASignature(signHash, signer, signature);
690     }
691 
692     function recoverECDSASigner(
693         bytes32      signHash,
694         bytes memory signature
695         )
696         internal
697         pure
698         returns (address)
699     {
700         if (signature.length != 65) {
701             return address(0);
702         }
703 
704         bytes32 r;
705         bytes32 s;
706         uint8   v;
707         // we jump 32 (0x20) as the first slot of bytes contains the length
708         // we jump 65 (0x41) per signature
709         // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
710         assembly {
711             r := mload(add(signature, 0x20))
712             s := mload(add(signature, 0x40))
713             v := and(mload(add(signature, 0x41)), 0xff)
714         }
715         // See https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/cryptography/ECDSA.sol
716         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
717             return address(0);
718         }
719         if (v == 27 || v == 28) {
720             return ecrecover(signHash, v, r, s);
721         } else {
722             return address(0);
723         }
724     }
725 
726     function verifyEOASignature(
727         bytes32        signHash,
728         address        signer,
729         bytes   memory signature
730         )
731         private
732         pure
733         returns (bool success)
734     {
735         if (signer == address(0)) {
736             return false;
737         }
738 
739         uint signatureTypeOffset = signature.length.sub(1);
740         SignatureType signatureType = SignatureType(signature.toUint8(signatureTypeOffset));
741 
742         // Strip off the last byte of the signature by updating the length
743         assembly {
744             mstore(signature, signatureTypeOffset)
745         }
746 
747         if (signatureType == SignatureType.EIP_712) {
748             success = (signer == recoverECDSASigner(signHash, signature));
749         } else if (signatureType == SignatureType.ETH_SIGN) {
750             bytes32 hash = keccak256(
751                 abi.encodePacked("\x19Ethereum Signed Message:\n32", signHash)
752             );
753             success = (signer == recoverECDSASigner(hash, signature));
754         } else {
755             success = false;
756         }
757 
758         // Restore the signature length
759         assembly {
760             mstore(signature, add(signatureTypeOffset, 1))
761         }
762 
763         return success;
764     }
765 
766     function verifyERC1271Signature(
767         bytes32 signHash,
768         address signer,
769         bytes   memory signature
770         )
771         private
772         view
773         returns (bool)
774     {
775         bytes memory callData = abi.encodeWithSelector(
776             ERC1271.isValidSignature.selector,
777             signHash,
778             signature
779         );
780         (bool success, bytes memory result) = signer.staticcall(callData);
781         return (
782             success &&
783             result.length == 32 &&
784             result.toBytes4(0) == ERC1271_MAGICVALUE
785         );
786     }
787 }
788 
789 // Copyright 2017 Loopring Technology Limited.
790 
791 
792 
793 
794 library EIP712
795 {
796     struct Domain {
797         string  name;
798         string  version;
799         address verifyingContract;
800     }
801 
802     bytes32 constant internal EIP712_DOMAIN_TYPEHASH = keccak256(
803         "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
804     );
805 
806     string constant internal EIP191_HEADER = "\x19\x01";
807 
808     function hash(Domain memory domain)
809         internal
810         pure
811         returns (bytes32)
812     {
813         uint _chainid;
814         assembly { _chainid := chainid() }
815 
816         return keccak256(
817             abi.encode(
818                 EIP712_DOMAIN_TYPEHASH,
819                 keccak256(bytes(domain.name)),
820                 keccak256(bytes(domain.version)),
821                 _chainid,
822                 domain.verifyingContract
823             )
824         );
825     }
826 
827     function hashPacked(
828         bytes32 domainHash,
829         bytes32 dataHash
830         )
831         internal
832         pure
833         returns (bytes32)
834     {
835         return keccak256(
836             abi.encodePacked(
837                 EIP191_HEADER,
838                 domainHash,
839                 dataHash
840             )
841         );
842     }
843 }
844 // Copyright 2017 Loopring Technology Limited.
845 
846 
847 
848 
849 
850 // Copyright 2017 Loopring Technology Limited.
851 
852 
853 
854 
855 
856 // Copyright 2017 Loopring Technology Limited.
857 
858 
859 
860 
861 
862 // Copyright 2017 Loopring Technology Limited.
863 
864 
865 
866 
867 
868 
869 /// @title IBlockVerifier
870 /// @author Brecht Devos - <brecht@loopring.org>
871 abstract contract IBlockVerifier is Claimable
872 {
873     // -- Events --
874 
875     event CircuitRegistered(
876         uint8  indexed blockType,
877         uint16         blockSize,
878         uint8          blockVersion
879     );
880 
881     event CircuitDisabled(
882         uint8  indexed blockType,
883         uint16         blockSize,
884         uint8          blockVersion
885     );
886 
887     // -- Public functions --
888 
889     /// @dev Sets the verifying key for the specified circuit.
890     ///      Every block permutation needs its own circuit and thus its own set of
891     ///      verification keys. Only a limited number of block sizes per block
892     ///      type are supported.
893     /// @param blockType The type of the block
894     /// @param blockSize The number of requests handled in the block
895     /// @param blockVersion The block version (i.e. which circuit version needs to be used)
896     /// @param vk The verification key
897     function registerCircuit(
898         uint8    blockType,
899         uint16   blockSize,
900         uint8    blockVersion,
901         uint[18] calldata vk
902         )
903         external
904         virtual;
905 
906     /// @dev Disables the use of the specified circuit.
907     ///      This will stop NEW blocks from using the given circuit, blocks that were already committed
908     ///      can still be verified.
909     /// @param blockType The type of the block
910     /// @param blockSize The number of requests handled in the block
911     /// @param blockVersion The block version (i.e. which circuit version needs to be used)
912     function disableCircuit(
913         uint8  blockType,
914         uint16 blockSize,
915         uint8  blockVersion
916         )
917         external
918         virtual;
919 
920     /// @dev Verifies blocks with the given public data and proofs.
921     ///      Verifying a block makes sure all requests handled in the block
922     ///      are correctly handled by the operator.
923     /// @param blockType The type of block
924     /// @param blockSize The number of requests handled in the block
925     /// @param blockVersion The block version (i.e. which circuit version needs to be used)
926     /// @param publicInputs The hash of all the public data of the blocks
927     /// @param proofs The ZK proofs proving that the blocks are correct
928     /// @return True if the block is valid, false otherwise
929     function verifyProofs(
930         uint8  blockType,
931         uint16 blockSize,
932         uint8  blockVersion,
933         uint[] calldata publicInputs,
934         uint[] calldata proofs
935         )
936         external
937         virtual
938         view
939         returns (bool);
940 
941     /// @dev Checks if a circuit with the specified parameters is registered.
942     /// @param blockType The type of the block
943     /// @param blockSize The number of requests handled in the block
944     /// @param blockVersion The block version (i.e. which circuit version needs to be used)
945     /// @return True if the circuit is registered, false otherwise
946     function isCircuitRegistered(
947         uint8  blockType,
948         uint16 blockSize,
949         uint8  blockVersion
950         )
951         external
952         virtual
953         view
954         returns (bool);
955 
956     /// @dev Checks if a circuit can still be used to commit new blocks.
957     /// @param blockType The type of the block
958     /// @param blockSize The number of requests handled in the block
959     /// @param blockVersion The block version (i.e. which circuit version needs to be used)
960     /// @return True if the circuit is enabled, false otherwise
961     function isCircuitEnabled(
962         uint8  blockType,
963         uint16 blockSize,
964         uint8  blockVersion
965         )
966         external
967         virtual
968         view
969         returns (bool);
970 }
971 
972 
973 // Copyright 2017 Loopring Technology Limited.
974 
975 
976 
977 /// @title IDepositContract.
978 /// @dev   Contract storing and transferring funds for an exchange.
979 ///
980 ///        ERC1155 tokens can be supported by registering pseudo token addresses calculated
981 ///        as `address(keccak256(real_token_address, token_params))`. Then the custom
982 ///        deposit contract can look up the real token address and paramsters with the
983 ///        pseudo token address before doing the transfers.
984 /// @author Brecht Devos - <brecht@loopring.org>
985 interface IDepositContract
986 {
987     /// @dev Returns if a token is suppoprted by this contract.
988     function isTokenSupported(address token)
989         external
990         view
991         returns (bool);
992 
993     /// @dev Transfers tokens from a user to the exchange. This function will
994     ///      be called when a user deposits funds to the exchange.
995     ///      In a simple implementation the funds are simply stored inside the
996     ///      deposit contract directly. More advanced implementations may store the funds
997     ///      in some DeFi application to earn interest, so this function could directly
998     ///      call the necessary functions to store the funds there.
999     ///
1000     ///      This function needs to throw when an error occurred!
1001     ///
1002     ///      This function can only be called by the exchange.
1003     ///
1004     /// @param from The address of the account that sends the tokens.
1005     /// @param token The address of the token to transfer (`0x0` for ETH).
1006     /// @param amount The amount of tokens to transfer.
1007     /// @param extraData Opaque data that can be used by the contract to handle the deposit
1008     /// @return amountReceived The amount to deposit to the user's account in the Merkle tree
1009     function deposit(
1010         address from,
1011         address token,
1012         uint96  amount,
1013         bytes   calldata extraData
1014         )
1015         external
1016         payable
1017         returns (uint96 amountReceived);
1018 
1019     /// @dev Transfers tokens from the exchange to a user. This function will
1020     ///      be called when a withdrawal is done for a user on the exchange.
1021     ///      In the simplest implementation the funds are simply stored inside the
1022     ///      deposit contract directly so this simply transfers the requested tokens back
1023     ///      to the user. More advanced implementations may store the funds
1024     ///      in some DeFi application to earn interest so the function would
1025     ///      need to get those tokens back from the DeFi application first before they
1026     ///      can be transferred to the user.
1027     ///
1028     ///      This function needs to throw when an error occurred!
1029     ///
1030     ///      This function can only be called by the exchange.
1031     ///
1032     /// @param from The address from which 'amount' tokens are transferred.
1033     /// @param to The address to which 'amount' tokens are transferred.
1034     /// @param token The address of the token to transfer (`0x0` for ETH).
1035     /// @param amount The amount of tokens transferred.
1036     /// @param extraData Opaque data that can be used by the contract to handle the withdrawal
1037     function withdraw(
1038         address from,
1039         address to,
1040         address token,
1041         uint    amount,
1042         bytes   calldata extraData
1043         )
1044         external
1045         payable;
1046 
1047     /// @dev Transfers tokens (ETH not supported) for a user using the allowance set
1048     ///      for the exchange. This way the approval can be used for all functionality (and
1049     ///      extended functionality) of the exchange.
1050     ///      Should NOT be used to deposit/withdraw user funds, `deposit`/`withdraw`
1051     ///      should be used for that as they will contain specialised logic for those operations.
1052     ///      This function can be called by the exchange to transfer onchain funds of users
1053     ///      necessary for Agent functionality.
1054     ///
1055     ///      This function needs to throw when an error occurred!
1056     ///
1057     ///      This function can only be called by the exchange.
1058     ///
1059     /// @param from The address of the account that sends the tokens.
1060     /// @param to The address to which 'amount' tokens are transferred.
1061     /// @param token The address of the token to transfer (ETH is and cannot be suppported).
1062     /// @param amount The amount of tokens transferred.
1063     function transfer(
1064         address from,
1065         address to,
1066         address token,
1067         uint    amount
1068         )
1069         external
1070         payable;
1071 
1072     /// @dev Checks if the given address is used for depositing ETH or not.
1073     ///      Is used while depositing to send the correct ETH amount to the deposit contract.
1074     ///
1075     ///      Note that 0x0 is always registered for deposting ETH when the exchange is created!
1076     ///      This function allows additional addresses to be used for depositing ETH, the deposit
1077     ///      contract can implement different behaviour based on the address value.
1078     ///
1079     /// @param addr The address to check
1080     /// @return True if the address is used for depositing ETH, else false.
1081     function isETH(address addr)
1082         external
1083         view
1084         returns (bool);
1085 }
1086 
1087 // Copyright 2017 Loopring Technology Limited.
1088 
1089 
1090 
1091 
1092 
1093 /// @title ILoopringV3
1094 /// @author Brecht Devos - <brecht@loopring.org>
1095 /// @author Daniel Wang  - <daniel@loopring.org>
1096 abstract contract ILoopringV3 is Claimable
1097 {
1098     // == Events ==
1099     event ExchangeStakeDeposited(address exchangeAddr, uint amount);
1100     event ExchangeStakeWithdrawn(address exchangeAddr, uint amount);
1101     event ExchangeStakeBurned(address exchangeAddr, uint amount);
1102     event SettingsUpdated(uint time);
1103 
1104     // == Public Variables ==
1105     mapping (address => uint) internal exchangeStake;
1106 
1107     address public lrcAddress;
1108     uint    public totalStake;
1109     address public blockVerifierAddress;
1110     uint    public forcedWithdrawalFee;
1111     uint    public tokenRegistrationFeeLRCBase;
1112     uint    public tokenRegistrationFeeLRCDelta;
1113     uint8   public protocolTakerFeeBips;
1114     uint8   public protocolMakerFeeBips;
1115 
1116     address payable public protocolFeeVault;
1117 
1118     // == Public Functions ==
1119     /// @dev Updates the global exchange settings.
1120     ///      This function can only be called by the owner of this contract.
1121     ///
1122     ///      Warning: these new values will be used by existing and
1123     ///      new Loopring exchanges.
1124     function updateSettings(
1125         address payable _protocolFeeVault,   // address(0) not allowed
1126         address _blockVerifierAddress,       // address(0) not allowed
1127         uint    _forcedWithdrawalFee
1128         )
1129         external
1130         virtual;
1131 
1132     /// @dev Updates the global protocol fee settings.
1133     ///      This function can only be called by the owner of this contract.
1134     ///
1135     ///      Warning: these new values will be used by existing and
1136     ///      new Loopring exchanges.
1137     function updateProtocolFeeSettings(
1138         uint8 _protocolTakerFeeBips,
1139         uint8 _protocolMakerFeeBips
1140         )
1141         external
1142         virtual;
1143 
1144     /// @dev Gets the amount of staked LRC for an exchange.
1145     /// @param exchangeAddr The address of the exchange
1146     /// @return stakedLRC The amount of LRC
1147     function getExchangeStake(
1148         address exchangeAddr
1149         )
1150         public
1151         virtual
1152         view
1153         returns (uint stakedLRC);
1154 
1155     /// @dev Burns a certain amount of staked LRC for a specific exchange.
1156     ///      This function is meant to be called only from exchange contracts.
1157     /// @return burnedLRC The amount of LRC burned. If the amount is greater than
1158     ///         the staked amount, all staked LRC will be burned.
1159     function burnExchangeStake(
1160         uint amount
1161         )
1162         external
1163         virtual
1164         returns (uint burnedLRC);
1165 
1166     /// @dev Stakes more LRC for an exchange.
1167     /// @param  exchangeAddr The address of the exchange
1168     /// @param  amountLRC The amount of LRC to stake
1169     /// @return stakedLRC The total amount of LRC staked for the exchange
1170     function depositExchangeStake(
1171         address exchangeAddr,
1172         uint    amountLRC
1173         )
1174         external
1175         virtual
1176         returns (uint stakedLRC);
1177 
1178     /// @dev Withdraws a certain amount of staked LRC for an exchange to the given address.
1179     ///      This function is meant to be called only from within exchange contracts.
1180     /// @param  recipient The address to receive LRC
1181     /// @param  requestedAmount The amount of LRC to withdraw
1182     /// @return amountLRC The amount of LRC withdrawn
1183     function withdrawExchangeStake(
1184         address recipient,
1185         uint    requestedAmount
1186         )
1187         external
1188         virtual
1189         returns (uint amountLRC);
1190 
1191     /// @dev Gets the protocol fee values for an exchange.
1192     /// @return takerFeeBips The protocol taker fee
1193     /// @return makerFeeBips The protocol maker fee
1194     function getProtocolFeeValues(
1195         )
1196         public
1197         virtual
1198         view
1199         returns (
1200             uint8 takerFeeBips,
1201             uint8 makerFeeBips
1202         );
1203 }
1204 
1205 
1206 
1207 /// @title ExchangeData
1208 /// @dev All methods in this lib are internal, therefore, there is no need
1209 ///      to deploy this library independently.
1210 /// @author Daniel Wang  - <daniel@loopring.org>
1211 /// @author Brecht Devos - <brecht@loopring.org>
1212 library ExchangeData
1213 {
1214     // -- Enums --
1215     enum TransactionType
1216     {
1217         NOOP,
1218         DEPOSIT,
1219         WITHDRAWAL,
1220         TRANSFER,
1221         SPOT_TRADE,
1222         ACCOUNT_UPDATE,
1223         AMM_UPDATE
1224     }
1225 
1226     // -- Structs --
1227     struct Token
1228     {
1229         address token;
1230     }
1231 
1232     struct ProtocolFeeData
1233     {
1234         uint32 syncedAt; // only valid before 2105 (85 years to go)
1235         uint8  takerFeeBips;
1236         uint8  makerFeeBips;
1237         uint8  previousTakerFeeBips;
1238         uint8  previousMakerFeeBips;
1239     }
1240 
1241     // General auxiliary data for each conditional transaction
1242     struct AuxiliaryData
1243     {
1244         uint  txIndex;
1245         bytes data;
1246     }
1247 
1248     // This is the (virtual) block the owner  needs to submit onchain to maintain the
1249     // per-exchange (virtual) blockchain.
1250     struct Block
1251     {
1252         uint8      blockType;
1253         uint16     blockSize;
1254         uint8      blockVersion;
1255         bytes      data;
1256         uint256[8] proof;
1257 
1258         // Whether we should store the @BlockInfo for this block on-chain.
1259         bool storeBlockInfoOnchain;
1260 
1261         // Block specific data that is only used to help process the block on-chain.
1262         // It is not used as input for the circuits and it is not necessary for data-availability.
1263         AuxiliaryData[] auxiliaryData;
1264 
1265         // Arbitrary data, mainly for off-chain data-availability, i.e.,
1266         // the multihash of the IPFS file that contains the block data.
1267         bytes offchainData;
1268     }
1269 
1270     struct BlockInfo
1271     {
1272         // The time the block was submitted on-chain.
1273         uint32  timestamp;
1274         // The public data hash of the block (the 28 most significant bytes).
1275         bytes28 blockDataHash;
1276     }
1277 
1278     // Represents an onchain deposit request.
1279     struct Deposit
1280     {
1281         uint96 amount;
1282         uint64 timestamp;
1283     }
1284 
1285     // A forced withdrawal request.
1286     // If the actual owner of the account initiated the request (we don't know who the owner is
1287     // at the time the request is being made) the full balance will be withdrawn.
1288     struct ForcedWithdrawal
1289     {
1290         address owner;
1291         uint64  timestamp;
1292     }
1293 
1294     struct Constants
1295     {
1296         uint SNARK_SCALAR_FIELD;
1297         uint MAX_OPEN_FORCED_REQUESTS;
1298         uint MAX_AGE_FORCED_REQUEST_UNTIL_WITHDRAW_MODE;
1299         uint TIMESTAMP_HALF_WINDOW_SIZE_IN_SECONDS;
1300         uint MAX_NUM_ACCOUNTS;
1301         uint MAX_NUM_TOKENS;
1302         uint MIN_AGE_PROTOCOL_FEES_UNTIL_UPDATED;
1303         uint MIN_TIME_IN_SHUTDOWN;
1304         uint TX_DATA_AVAILABILITY_SIZE;
1305         uint MAX_AGE_DEPOSIT_UNTIL_WITHDRAWABLE_UPPERBOUND;
1306     }
1307 
1308     function SNARK_SCALAR_FIELD() internal pure returns (uint) {
1309         // This is the prime number that is used for the alt_bn128 elliptic curve, see EIP-196.
1310         return 21888242871839275222246405745257275088548364400416034343698204186575808495617;
1311     }
1312     function MAX_OPEN_FORCED_REQUESTS() internal pure returns (uint16) { return 4096; }
1313     function MAX_AGE_FORCED_REQUEST_UNTIL_WITHDRAW_MODE() internal pure returns (uint32) { return 15 days; }
1314     function TIMESTAMP_HALF_WINDOW_SIZE_IN_SECONDS() internal pure returns (uint32) { return 7 days; }
1315     function MAX_NUM_ACCOUNTS() internal pure returns (uint) { return 2 ** 32; }
1316     function MAX_NUM_TOKENS() internal pure returns (uint) { return 2 ** 16; }
1317     function MIN_AGE_PROTOCOL_FEES_UNTIL_UPDATED() internal pure returns (uint32) { return 7 days; }
1318     function MIN_TIME_IN_SHUTDOWN() internal pure returns (uint32) { return 30 days; }
1319     // The amount of bytes each rollup transaction uses in the block data for data-availability.
1320     // This is the maximum amount of bytes of all different transaction types.
1321     function TX_DATA_AVAILABILITY_SIZE() internal pure returns (uint32) { return 68; }
1322     function MAX_AGE_DEPOSIT_UNTIL_WITHDRAWABLE_UPPERBOUND() internal pure returns (uint32) { return 15 days; }
1323     function ACCOUNTID_PROTOCOLFEE() internal pure returns (uint32) { return 0; }
1324 
1325     function TX_DATA_AVAILABILITY_SIZE_PART_1() internal pure returns (uint32) { return 29; }
1326     function TX_DATA_AVAILABILITY_SIZE_PART_2() internal pure returns (uint32) { return 39; }
1327 
1328     struct AccountLeaf
1329     {
1330         uint32   accountID;
1331         address  owner;
1332         uint     pubKeyX;
1333         uint     pubKeyY;
1334         uint32   nonce;
1335         uint     feeBipsAMM;
1336     }
1337 
1338     struct BalanceLeaf
1339     {
1340         uint16   tokenID;
1341         uint96   balance;
1342         uint96   weightAMM;
1343         uint     storageRoot;
1344     }
1345 
1346     struct MerkleProof
1347     {
1348         ExchangeData.AccountLeaf accountLeaf;
1349         ExchangeData.BalanceLeaf balanceLeaf;
1350         uint[48]                 accountMerkleProof;
1351         uint[24]                 balanceMerkleProof;
1352     }
1353 
1354     struct BlockContext
1355     {
1356         bytes32 DOMAIN_SEPARATOR;
1357         uint32  timestamp;
1358     }
1359 
1360     // Represents the entire exchange state except the owner of the exchange.
1361     struct State
1362     {
1363         uint32  maxAgeDepositUntilWithdrawable;
1364         bytes32 DOMAIN_SEPARATOR;
1365 
1366         ILoopringV3      loopring;
1367         IBlockVerifier   blockVerifier;
1368         IAgentRegistry   agentRegistry;
1369         IDepositContract depositContract;
1370 
1371 
1372         // The merkle root of the offchain data stored in a Merkle tree. The Merkle tree
1373         // stores balances for users using an account model.
1374         bytes32 merkleRoot;
1375 
1376         // List of all blocks
1377         mapping(uint => BlockInfo) blocks;
1378         uint  numBlocks;
1379 
1380         // List of all tokens
1381         Token[] tokens;
1382 
1383         // A map from a token to its tokenID + 1
1384         mapping (address => uint16) tokenToTokenId;
1385 
1386         // A map from an accountID to a tokenID to if the balance is withdrawn
1387         mapping (uint32 => mapping (uint16 => bool)) withdrawnInWithdrawMode;
1388 
1389         // A map from an account to a token to the amount withdrawable for that account.
1390         // This is only used when the automatic distribution of the withdrawal failed.
1391         mapping (address => mapping (uint16 => uint)) amountWithdrawable;
1392 
1393         // A map from an account to a token to the forced withdrawal (always full balance)
1394         mapping (uint32 => mapping (uint16 => ForcedWithdrawal)) pendingForcedWithdrawals;
1395 
1396         // A map from an address to a token to a deposit
1397         mapping (address => mapping (uint16 => Deposit)) pendingDeposits;
1398 
1399         // A map from an account owner to an approved transaction hash to if the transaction is approved or not
1400         mapping (address => mapping (bytes32 => bool)) approvedTx;
1401 
1402         // A map from an account owner to a destination address to a tokenID to an amount to a storageID to a new recipient address
1403         mapping (address => mapping (address => mapping (uint16 => mapping (uint => mapping (uint32 => address))))) withdrawalRecipient;
1404 
1405 
1406         // Counter to keep track of how many of forced requests are open so we can limit the work that needs to be done by the owner
1407         uint32 numPendingForcedTransactions;
1408 
1409         // Cached data for the protocol fee
1410         ProtocolFeeData protocolFeeData;
1411 
1412         // Time when the exchange was shutdown
1413         uint shutdownModeStartTime;
1414 
1415         // Time when the exchange has entered withdrawal mode
1416         uint withdrawalModeStartTime;
1417 
1418         // Last time the protocol fee was withdrawn for a specific token
1419         mapping (address => uint) protocolFeeLastWithdrawnTime;
1420     }
1421 }
1422 
1423 
1424 
1425 /// @title IExchangeV3
1426 /// @dev Note that Claimable and RentrancyGuard are inherited here to
1427 ///      ensure all data members are declared on IExchangeV3 to make it
1428 ///      easy to support upgradability through proxies.
1429 ///
1430 ///      Subclasses of this contract must NOT define constructor to
1431 ///      initialize data.
1432 ///
1433 /// @author Brecht Devos - <brecht@loopring.org>
1434 /// @author Daniel Wang  - <daniel@loopring.org>
1435 abstract contract IExchangeV3 is Claimable
1436 {
1437     // -- Events --
1438 
1439     event ExchangeCloned(
1440         address exchangeAddress,
1441         address owner,
1442         bytes32 genesisMerkleRoot
1443     );
1444 
1445     event TokenRegistered(
1446         address token,
1447         uint16  tokenId
1448     );
1449 
1450     event Shutdown(
1451         uint timestamp
1452     );
1453 
1454     event WithdrawalModeActivated(
1455         uint timestamp
1456     );
1457 
1458     event BlockSubmitted(
1459         uint    indexed blockIdx,
1460         bytes32         merkleRoot,
1461         bytes32         publicDataHash
1462     );
1463 
1464     event DepositRequested(
1465         address from,
1466         address to,
1467         address token,
1468         uint16  tokenId,
1469         uint96  amount
1470     );
1471 
1472     event ForcedWithdrawalRequested(
1473         address owner,
1474         address token,
1475         uint32  accountID
1476     );
1477 
1478     event WithdrawalCompleted(
1479         uint8   category,
1480         address from,
1481         address to,
1482         address token,
1483         uint    amount
1484     );
1485 
1486     event WithdrawalFailed(
1487         uint8   category,
1488         address from,
1489         address to,
1490         address token,
1491         uint    amount
1492     );
1493 
1494     event ProtocolFeesUpdated(
1495         uint8 takerFeeBips,
1496         uint8 makerFeeBips,
1497         uint8 previousTakerFeeBips,
1498         uint8 previousMakerFeeBips
1499     );
1500 
1501     event TransactionApproved(
1502         address owner,
1503         bytes32 transactionHash
1504     );
1505 
1506     // events from libraries
1507     /*event DepositProcessed(
1508         address to,
1509         uint32  toAccountId,
1510         uint16  token,
1511         uint    amount
1512     );*/
1513 
1514     /*event ForcedWithdrawalProcessed(
1515         uint32 fromAccountID,
1516         uint16 tokenID,
1517         uint   amount
1518     );*/
1519 
1520     /*event ConditionalTransferProcessed(
1521         address from,
1522         address to,
1523         uint16  token,
1524         uint    amount
1525     );*/
1526 
1527     /*event AccountUpdated(
1528         uint32 owner,
1529         uint   publicKey
1530     );*/
1531 
1532 
1533     // -- Initialization --
1534     /// @dev Initializes this exchange. This method can only be called once.
1535     /// @param  loopring The LoopringV3 contract address.
1536     /// @param  owner The owner of this exchange.
1537     /// @param  genesisMerkleRoot The initial Merkle tree state.
1538     function initialize(
1539         address loopring,
1540         address owner,
1541         bytes32 genesisMerkleRoot
1542         )
1543         virtual
1544         external;
1545 
1546     /// @dev Initialized the agent registry contract used by the exchange.
1547     ///      Can only be called by the exchange owner once.
1548     /// @param agentRegistry The agent registry contract to be used
1549     function setAgentRegistry(address agentRegistry)
1550         external
1551         virtual;
1552 
1553     /// @dev Gets the agent registry contract used by the exchange.
1554     /// @return the agent registry contract
1555     function getAgentRegistry()
1556         external
1557         virtual
1558         view
1559         returns (IAgentRegistry);
1560 
1561     ///      Can only be called by the exchange owner once.
1562     /// @param depositContract The deposit contract to be used
1563     function setDepositContract(address depositContract)
1564         external
1565         virtual;
1566 
1567     /// @dev Gets the deposit contract used by the exchange.
1568     /// @return the deposit contract
1569     function getDepositContract()
1570         external
1571         virtual
1572         view
1573         returns (IDepositContract);
1574 
1575     // @dev Exchange owner withdraws fees from the exchange.
1576     // @param token Fee token address
1577     // @param feeRecipient Fee recipient address
1578     function withdrawExchangeFees(
1579         address token,
1580         address feeRecipient
1581         )
1582         external
1583         virtual;
1584 
1585     // -- Constants --
1586     /// @dev Returns a list of constants used by the exchange.
1587     /// @return constants The list of constants.
1588     function getConstants()
1589         external
1590         virtual
1591         pure
1592         returns(ExchangeData.Constants memory);
1593 
1594     // -- Mode --
1595     /// @dev Returns hether the exchange is in withdrawal mode.
1596     /// @return Returns true if the exchange is in withdrawal mode, else false.
1597     function isInWithdrawalMode()
1598         external
1599         virtual
1600         view
1601         returns (bool);
1602 
1603     /// @dev Returns whether the exchange is shutdown.
1604     /// @return Returns true if the exchange is shutdown, else false.
1605     function isShutdown()
1606         external
1607         virtual
1608         view
1609         returns (bool);
1610 
1611     // -- Tokens --
1612     /// @dev Registers an ERC20 token for a token id. Note that different exchanges may have
1613     ///      different ids for the same ERC20 token.
1614     ///
1615     ///      Please note that 1 is reserved for Ether (ETH), 2 is reserved for Wrapped Ether (ETH),
1616     ///      and 3 is reserved for Loopring Token (LRC).
1617     ///
1618     ///      This function is only callable by the exchange owner.
1619     ///
1620     /// @param  tokenAddress The token's address
1621     /// @return tokenID The token's ID in this exchanges.
1622     function registerToken(
1623         address tokenAddress
1624         )
1625         external
1626         virtual
1627         returns (uint16 tokenID);
1628 
1629     /// @dev Returns the id of a registered token.
1630     /// @param  tokenAddress The token's address
1631     /// @return tokenID The token's ID in this exchanges.
1632     function getTokenID(
1633         address tokenAddress
1634         )
1635         external
1636         virtual
1637         view
1638         returns (uint16 tokenID);
1639 
1640     /// @dev Returns the address of a registered token.
1641     /// @param  tokenID The token's ID in this exchanges.
1642     /// @return tokenAddress The token's address
1643     function getTokenAddress(
1644         uint16 tokenID
1645         )
1646         external
1647         virtual
1648         view
1649         returns (address tokenAddress);
1650 
1651     // -- Stakes --
1652     /// @dev Gets the amount of LRC the owner has staked onchain for this exchange.
1653     ///      The stake will be burned if the exchange does not fulfill its duty by
1654     ///      processing user requests in time. Please note that order matching may potentially
1655     ///      performed by another party and is not part of the exchange's duty.
1656     ///
1657     /// @return The amount of LRC staked
1658     function getExchangeStake()
1659         external
1660         virtual
1661         view
1662         returns (uint);
1663 
1664     /// @dev Withdraws the amount staked for this exchange.
1665     ///      This can only be done if the exchange has been correctly shutdown:
1666     ///      - The exchange owner has shutdown the exchange
1667     ///      - All deposit requests are processed
1668     ///      - All funds are returned to the users (merkle root is reset to initial state)
1669     ///
1670     ///      Can only be called by the exchange owner.
1671     ///
1672     /// @return amountLRC The amount of LRC withdrawn
1673     function withdrawExchangeStake(
1674         address recipient
1675         )
1676         external
1677         virtual
1678         returns (uint amountLRC);
1679 
1680     /// @dev Can by called by anyone to burn the stake of the exchange when certain
1681     ///      conditions are fulfilled.
1682     ///
1683     ///      Currently this will only burn the stake of the exchange if
1684     ///      the exchange is in withdrawal mode.
1685     function burnExchangeStake()
1686         external
1687         virtual;
1688 
1689     // -- Blocks --
1690 
1691     /// @dev Gets the current Merkle root of this exchange's virtual blockchain.
1692     /// @return The current Merkle root.
1693     function getMerkleRoot()
1694         external
1695         virtual
1696         view
1697         returns (bytes32);
1698 
1699     /// @dev Gets the height of this exchange's virtual blockchain. The block height for a
1700     ///      new exchange is 1.
1701     /// @return The virtual blockchain height which is the index of the last block.
1702     function getBlockHeight()
1703         external
1704         virtual
1705         view
1706         returns (uint);
1707 
1708     /// @dev Gets some minimal info of a previously submitted block that's kept onchain.
1709     ///      A DEX can use this function to implement a payment receipt verification
1710     ///      contract with a challange-response scheme.
1711     /// @param blockIdx The block index.
1712     function getBlockInfo(uint blockIdx)
1713         external
1714         virtual
1715         view
1716         returns (ExchangeData.BlockInfo memory);
1717 
1718     /// @dev Sumbits new blocks to the rollup blockchain.
1719     ///
1720     ///      This function can only be called by the exchange operator.
1721     ///
1722     /// @param blocks The blocks being submitted
1723     ///      - blockType: The type of the new block
1724     ///      - blockSize: The number of onchain or offchain requests/settlements
1725     ///        that have been processed in this block
1726     ///      - blockVersion: The circuit version to use for verifying the block
1727     ///      - storeBlockInfoOnchain: If the block info for this block needs to be stored on-chain
1728     ///      - data: The data for this block
1729     ///      - offchainData: Arbitrary data, mainly for off-chain data-availability, i.e.,
1730     ///        the multihash of the IPFS file that contains the block data.
1731     function submitBlocks(ExchangeData.Block[] calldata blocks)
1732         external
1733         virtual;
1734 
1735     /// @dev Gets the number of available forced request slots.
1736     /// @return The number of available slots.
1737     function getNumAvailableForcedSlots()
1738         external
1739         virtual
1740         view
1741         returns (uint);
1742 
1743     // -- Deposits --
1744 
1745     /// @dev Deposits Ether or ERC20 tokens to the specified account.
1746     ///
1747     ///      This function is only callable by an agent of 'from'.
1748     ///
1749     ///      A fee to the owner is paid in ETH to process the deposit.
1750     ///      The operator is not forced to do the deposit and the user can send
1751     ///      any fee amount.
1752     ///
1753     /// @param from The address that deposits the funds to the exchange
1754     /// @param to The account owner's address receiving the funds
1755     /// @param tokenAddress The address of the token, use `0x0` for Ether.
1756     /// @param amount The amount of tokens to deposit
1757     /// @param auxiliaryData Optional extra data used by the deposit contract
1758     function deposit(
1759         address from,
1760         address to,
1761         address tokenAddress,
1762         uint96  amount,
1763         bytes   calldata auxiliaryData
1764         )
1765         external
1766         virtual
1767         payable;
1768 
1769     /// @dev Gets the amount of tokens that may be added to the owner's account.
1770     /// @param owner The destination address for the amount deposited.
1771     /// @param tokenAddress The address of the token, use `0x0` for Ether.
1772     /// @return The amount of tokens pending.
1773     function getPendingDepositAmount(
1774         address owner,
1775         address tokenAddress
1776         )
1777         external
1778         virtual
1779         view
1780         returns (uint96);
1781 
1782     // -- Withdrawals --
1783     /// @dev Submits an onchain request to force withdraw Ether or ERC20 tokens.
1784     ///      This request always withdraws the full balance.
1785     ///
1786     ///      This function is only callable by an agent of the account.
1787     ///
1788     ///      The total fee in ETH that the user needs to pay is 'withdrawalFee'.
1789     ///      If the user sends too much ETH the surplus is sent back immediately.
1790     ///
1791     ///      Note that after such an operation, it will take the owner some
1792     ///      time (no more than MAX_AGE_FORCED_REQUEST_UNTIL_WITHDRAW_MODE) to process the request
1793     ///      and create the deposit to the offchain account.
1794     ///
1795     /// @param owner The expected owner of the account
1796     /// @param tokenAddress The address of the token, use `0x0` for Ether.
1797     /// @param accountID The address the account in the Merkle tree.
1798     function forceWithdraw(
1799         address owner,
1800         address tokenAddress,
1801         uint32  accountID
1802         )
1803         external
1804         virtual
1805         payable;
1806 
1807     /// @dev Checks if a forced withdrawal is pending for an account balance.
1808     /// @param  accountID The accountID of the account to check.
1809     /// @param  token The token address
1810     /// @return True if a request is pending, false otherwise
1811     function isForcedWithdrawalPending(
1812         uint32  accountID,
1813         address token
1814         )
1815         external
1816         virtual
1817         view
1818         returns (bool);
1819 
1820     /// @dev Submits an onchain request to withdraw Ether or ERC20 tokens from the
1821     ///      protocol fees account. The complete balance is always withdrawn.
1822     ///
1823     ///      Anyone can request a withdrawal of the protocol fees.
1824     ///
1825     ///      Note that after such an operation, it will take the owner some
1826     ///      time (no more than MAX_AGE_FORCED_REQUEST_UNTIL_WITHDRAW_MODE) to process the request
1827     ///      and create the deposit to the offchain account.
1828     ///
1829     /// @param tokenAddress The address of the token, use `0x0` for Ether.
1830     function withdrawProtocolFees(
1831         address tokenAddress
1832         )
1833         external
1834         virtual
1835         payable;
1836 
1837     /// @dev Gets the time the protocol fee for a token was last withdrawn.
1838     /// @param tokenAddress The address of the token, use `0x0` for Ether.
1839     /// @return The time the protocol fee was last withdrawn.
1840     function getProtocolFeeLastWithdrawnTime(
1841         address tokenAddress
1842         )
1843         external
1844         virtual
1845         view
1846         returns (uint);
1847 
1848     /// @dev Allows anyone to withdraw funds for a specified user using the balances stored
1849     ///      in the Merkle tree. The funds will be sent to the owner of the acount.
1850     ///
1851     ///      Can only be used in withdrawal mode (i.e. when the owner has stopped
1852     ///      committing blocks and is not able to commit any more blocks).
1853     ///
1854     ///      This will NOT modify the onchain merkle root! The merkle root stored
1855     ///      onchain will remain the same after the withdrawal. We store if the user
1856     ///      has withdrawn the balance in State.withdrawnInWithdrawMode.
1857     ///
1858     /// @param  merkleProof The Merkle inclusion proof
1859     function withdrawFromMerkleTree(
1860         ExchangeData.MerkleProof calldata merkleProof
1861         )
1862         external
1863         virtual;
1864 
1865     /// @dev Checks if the balance for the account was withdrawn with `withdrawFromMerkleTree`.
1866     /// @param  accountID The accountID of the balance to check.
1867     /// @param  token The token address
1868     /// @return True if it was already withdrawn, false otherwise
1869     function isWithdrawnInWithdrawalMode(
1870         uint32  accountID,
1871         address token
1872         )
1873         external
1874         virtual
1875         view
1876         returns (bool);
1877 
1878     /// @dev Allows withdrawing funds deposited to the contract in a deposit request when
1879     ///      it was never processed by the owner within the maximum time allowed.
1880     ///
1881     ///      Can be called by anyone. The deposited tokens will be sent back to
1882     ///      the owner of the account they were deposited in.
1883     ///
1884     /// @param  owner The address of the account the withdrawal was done for.
1885     /// @param  token The token address
1886     function withdrawFromDepositRequest(
1887         address owner,
1888         address token
1889         )
1890         external
1891         virtual;
1892 
1893     /// @dev Allows withdrawing funds after a withdrawal request (either onchain
1894     ///      or offchain) was submitted in a block by the operator.
1895     ///
1896     ///      Can be called by anyone. The withdrawn tokens will be sent to
1897     ///      the owner of the account they were withdrawn out.
1898     ///
1899     ///      Normally it is should not be needed for users to call this manually.
1900     ///      Funds from withdrawal requests will be sent to the account owner
1901     ///      immediately by the owner when the block is submitted.
1902     ///      The user will however need to call this manually if the transfer failed.
1903     ///
1904     ///      Tokens and owners must have the same size.
1905     ///
1906     /// @param  owners The addresses of the account the withdrawal was done for.
1907     /// @param  tokens The token addresses
1908     function withdrawFromApprovedWithdrawals(
1909         address[] calldata owners,
1910         address[] calldata tokens
1911         )
1912         external
1913         virtual;
1914 
1915     /// @dev Gets the amount that can be withdrawn immediately with `withdrawFromApprovedWithdrawals`.
1916     /// @param  owner The address of the account the withdrawal was done for.
1917     /// @param  token The token address
1918     /// @return The amount withdrawable
1919     function getAmountWithdrawable(
1920         address owner,
1921         address token
1922         )
1923         external
1924         virtual
1925         view
1926         returns (uint);
1927 
1928     /// @dev Notifies the exchange that the owner did not process a forced request.
1929     ///      If this is indeed the case, the exchange will enter withdrawal mode.
1930     ///
1931     ///      Can be called by anyone.
1932     ///
1933     /// @param  accountID The accountID the forced request was made for
1934     /// @param  token The token address of the the forced request
1935     function notifyForcedRequestTooOld(
1936         uint32  accountID,
1937         address token
1938         )
1939         external
1940         virtual;
1941 
1942     /// @dev Allows a withdrawal to be done to an adddresss that is different
1943     ///      than initialy specified in the withdrawal request. This can be used to
1944     ///      implement functionality like fast withdrawals.
1945     ///
1946     ///      This function can only be called by an agent.
1947     ///
1948     /// @param from The address of the account that does the withdrawal.
1949     /// @param to The address to which 'amount' tokens were going to be withdrawn.
1950     /// @param token The address of the token that is withdrawn ('0x0' for ETH).
1951     /// @param amount The amount of tokens that are going to be withdrawn.
1952     /// @param storageID The storageID of the withdrawal request.
1953     /// @param newRecipient The new recipient address of the withdrawal.
1954     function setWithdrawalRecipient(
1955         address from,
1956         address to,
1957         address token,
1958         uint96  amount,
1959         uint32  storageID,
1960         address newRecipient
1961         )
1962         external
1963         virtual;
1964 
1965     /// @dev Gets the withdrawal recipient.
1966     ///
1967     /// @param from The address of the account that does the withdrawal.
1968     /// @param to The address to which 'amount' tokens were going to be withdrawn.
1969     /// @param token The address of the token that is withdrawn ('0x0' for ETH).
1970     /// @param amount The amount of tokens that are going to be withdrawn.
1971     /// @param storageID The storageID of the withdrawal request.
1972     function getWithdrawalRecipient(
1973         address from,
1974         address to,
1975         address token,
1976         uint96  amount,
1977         uint32  storageID
1978         )
1979         external
1980         virtual
1981         view
1982         returns (address);
1983 
1984     /// @dev Allows an agent to transfer ERC-20 tokens for a user using the allowance
1985     ///      the user has set for the exchange. This way the user only needs to approve a single exchange contract
1986     ///      for all exchange/agent features, which allows for a more seamless user experience.
1987     ///
1988     ///      This function can only be called by an agent.
1989     ///
1990     /// @param from The address of the account that sends the tokens.
1991     /// @param to The address to which 'amount' tokens are transferred.
1992     /// @param token The address of the token to transfer (ETH is and cannot be suppported).
1993     /// @param amount The amount of tokens transferred.
1994     function onchainTransferFrom(
1995         address from,
1996         address to,
1997         address token,
1998         uint    amount
1999         )
2000         external
2001         virtual;
2002 
2003     /// @dev Allows an agent to approve a rollup tx.
2004     ///
2005     ///      This function can only be called by an agent.
2006     ///
2007     /// @param owner The owner of the account
2008     /// @param txHash The hash of the transaction
2009     function approveTransaction(
2010         address owner,
2011         bytes32 txHash
2012         )
2013         external
2014         virtual;
2015 
2016     /// @dev Allows an agent to approve multiple rollup txs.
2017     ///
2018     ///      This function can only be called by an agent.
2019     ///
2020     /// @param owners The account owners
2021     /// @param txHashes The hashes of the transactions
2022     function approveTransactions(
2023         address[] calldata owners,
2024         bytes32[] calldata txHashes
2025         )
2026         external
2027         virtual;
2028 
2029     /// @dev Checks if a rollup tx is approved using the tx's hash.
2030     ///
2031     /// @param owner The owner of the account that needs to authorize the tx
2032     /// @param txHash The hash of the transaction
2033     /// @return True if the tx is approved, else false
2034     function isTransactionApproved(
2035         address owner,
2036         bytes32 txHash
2037         )
2038         external
2039         virtual
2040         view
2041         returns (bool);
2042 
2043     // -- Admins --
2044     /// @dev Sets the max time deposits have to wait before becoming withdrawable.
2045     /// @param newValue The new value.
2046     /// @return  The old value.
2047     function setMaxAgeDepositUntilWithdrawable(
2048         uint32 newValue
2049         )
2050         external
2051         virtual
2052         returns (uint32);
2053 
2054     /// @dev Returns the max time deposits have to wait before becoming withdrawable.
2055     /// @return The value.
2056     function getMaxAgeDepositUntilWithdrawable()
2057         external
2058         virtual
2059         view
2060         returns (uint32);
2061 
2062     /// @dev Shuts down the exchange.
2063     ///      Once the exchange is shutdown all onchain requests are permanently disabled.
2064     ///      When all requirements are fulfilled the exchange owner can withdraw
2065     ///      the exchange stake with withdrawStake.
2066     ///
2067     ///      Note that the exchange can still enter the withdrawal mode after this function
2068     ///      has been invoked successfully. To prevent entering the withdrawal mode before the
2069     ///      the echange stake can be withdrawn, all withdrawal requests still need to be handled
2070     ///      for at least MIN_TIME_IN_SHUTDOWN seconds.
2071     ///
2072     ///      Can only be called by the exchange owner.
2073     ///
2074     /// @return success True if the exchange is shutdown, else False
2075     function shutdown()
2076         external
2077         virtual
2078         returns (bool success);
2079 
2080     /// @dev Gets the protocol fees for this exchange.
2081     /// @return syncedAt The timestamp the protocol fees were last updated
2082     /// @return takerFeeBips The protocol taker fee
2083     /// @return makerFeeBips The protocol maker fee
2084     /// @return previousTakerFeeBips The previous protocol taker fee
2085     /// @return previousMakerFeeBips The previous protocol maker fee
2086     function getProtocolFeeValues()
2087         external
2088         virtual
2089         view
2090         returns (
2091             uint32 syncedAt,
2092             uint8 takerFeeBips,
2093             uint8 makerFeeBips,
2094             uint8 previousTakerFeeBips,
2095             uint8 previousMakerFeeBips
2096         );
2097 
2098     /// @dev Gets the domain separator used in this exchange.
2099     function getDomainSeparator()
2100         external
2101         virtual
2102         view
2103         returns (bytes32);
2104 }
2105 
2106 
2107 
2108 
2109 // Copyright 2017 Loopring Technology Limited.
2110 
2111 
2112 
2113 /// @title ERC20 safe transfer
2114 /// @dev see https://github.com/sec-bit/badERC20Fix
2115 /// @author Brecht Devos - <brecht@loopring.org>
2116 library ERC20SafeTransfer
2117 {
2118     function safeTransferAndVerify(
2119         address token,
2120         address to,
2121         uint    value
2122         )
2123         internal
2124     {
2125         safeTransferWithGasLimitAndVerify(
2126             token,
2127             to,
2128             value,
2129             gasleft()
2130         );
2131     }
2132 
2133     function safeTransfer(
2134         address token,
2135         address to,
2136         uint    value
2137         )
2138         internal
2139         returns (bool)
2140     {
2141         return safeTransferWithGasLimit(
2142             token,
2143             to,
2144             value,
2145             gasleft()
2146         );
2147     }
2148 
2149     function safeTransferWithGasLimitAndVerify(
2150         address token,
2151         address to,
2152         uint    value,
2153         uint    gasLimit
2154         )
2155         internal
2156     {
2157         require(
2158             safeTransferWithGasLimit(token, to, value, gasLimit),
2159             "TRANSFER_FAILURE"
2160         );
2161     }
2162 
2163     function safeTransferWithGasLimit(
2164         address token,
2165         address to,
2166         uint    value,
2167         uint    gasLimit
2168         )
2169         internal
2170         returns (bool)
2171     {
2172         // A transfer is successful when 'call' is successful and depending on the token:
2173         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
2174         // - A single boolean is returned: this boolean needs to be true (non-zero)
2175 
2176         // bytes4(keccak256("transfer(address,uint256)")) = 0xa9059cbb
2177         bytes memory callData = abi.encodeWithSelector(
2178             bytes4(0xa9059cbb),
2179             to,
2180             value
2181         );
2182         (bool success, ) = token.call{gas: gasLimit}(callData);
2183         return checkReturnValue(success);
2184     }
2185 
2186     function safeTransferFromAndVerify(
2187         address token,
2188         address from,
2189         address to,
2190         uint    value
2191         )
2192         internal
2193     {
2194         safeTransferFromWithGasLimitAndVerify(
2195             token,
2196             from,
2197             to,
2198             value,
2199             gasleft()
2200         );
2201     }
2202 
2203     function safeTransferFrom(
2204         address token,
2205         address from,
2206         address to,
2207         uint    value
2208         )
2209         internal
2210         returns (bool)
2211     {
2212         return safeTransferFromWithGasLimit(
2213             token,
2214             from,
2215             to,
2216             value,
2217             gasleft()
2218         );
2219     }
2220 
2221     function safeTransferFromWithGasLimitAndVerify(
2222         address token,
2223         address from,
2224         address to,
2225         uint    value,
2226         uint    gasLimit
2227         )
2228         internal
2229     {
2230         bool result = safeTransferFromWithGasLimit(
2231             token,
2232             from,
2233             to,
2234             value,
2235             gasLimit
2236         );
2237         require(result, "TRANSFER_FAILURE");
2238     }
2239 
2240     function safeTransferFromWithGasLimit(
2241         address token,
2242         address from,
2243         address to,
2244         uint    value,
2245         uint    gasLimit
2246         )
2247         internal
2248         returns (bool)
2249     {
2250         // A transferFrom is successful when 'call' is successful and depending on the token:
2251         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
2252         // - A single boolean is returned: this boolean needs to be true (non-zero)
2253 
2254         // bytes4(keccak256("transferFrom(address,address,uint256)")) = 0x23b872dd
2255         bytes memory callData = abi.encodeWithSelector(
2256             bytes4(0x23b872dd),
2257             from,
2258             to,
2259             value
2260         );
2261         (bool success, ) = token.call{gas: gasLimit}(callData);
2262         return checkReturnValue(success);
2263     }
2264 
2265     function checkReturnValue(
2266         bool success
2267         )
2268         internal
2269         pure
2270         returns (bool)
2271     {
2272         // A transfer/transferFrom is successful when 'call' is successful and depending on the token:
2273         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
2274         // - A single boolean is returned: this boolean needs to be true (non-zero)
2275         if (success) {
2276             assembly {
2277                 switch returndatasize()
2278                 // Non-standard ERC20: nothing is returned so if 'call' was successful we assume the transfer succeeded
2279                 case 0 {
2280                     success := 1
2281                 }
2282                 // Standard ERC20: a single boolean value is returned which needs to be true
2283                 case 32 {
2284                     returndatacopy(0, 0, 32)
2285                     success := mload(0)
2286                 }
2287                 // None of the above: not successful
2288                 default {
2289                     success := 0
2290                 }
2291             }
2292         }
2293         return success;
2294     }
2295 }
2296 
2297 
2298 // Copyright 2017 Loopring Technology Limited.
2299 
2300 
2301 
2302 /// @title ReentrancyGuard
2303 /// @author Brecht Devos - <brecht@loopring.org>
2304 /// @dev Exposes a modifier that guards a function against reentrancy
2305 ///      Changing the value of the same storage value multiple times in a transaction
2306 ///      is cheap (starting from Istanbul) so there is no need to minimize
2307 ///      the number of times the value is changed
2308 contract ReentrancyGuard
2309 {
2310     //The default value must be 0 in order to work behind a proxy.
2311     uint private _guardValue;
2312 
2313     // Use this modifier on a function to prevent reentrancy
2314     modifier nonReentrant()
2315     {
2316         // Check if the guard value has its original value
2317         require(_guardValue == 0, "REENTRANCY");
2318 
2319         // Set the value to something else
2320         _guardValue = 1;
2321 
2322         // Function body
2323         _;
2324 
2325         // Set the value back
2326         _guardValue = 0;
2327     }
2328 }
2329 
2330 
2331 
2332 /// @title Fast withdrawal agent implementation. With the help of liquidity providers (LPs),
2333 ///        exchange operators can convert any normal withdrawals into fast withdrawals.
2334 ///
2335 ///        Fast withdrawals are a way for the owner to provide instant withdrawals for
2336 ///        users with the help of a liquidity provider and conditional transfers.
2337 ///
2338 ///        A fast withdrawal requires the non-trustless cooperation of 2 parties:
2339 ///        - A liquidity provider which provides funds to users immediately onchain
2340 ///        - The operator which will make sure the user has sufficient funds offchain
2341 ///          so that the liquidity provider can be paid back.
2342 ///          The operator also needs to process those withdrawals so that the
2343 ///          liquidity provider receives its funds back.
2344 ///
2345 ///        We require the fast withdrawals to be executed by the liquidity provider (as msg.sender)
2346 ///        so that the liquidity provider can impose its own rules on how its funds are spent. This will
2347 ///        inevitably need to be done in close cooperation with the operator, or by the operator
2348 ///        itself using a smart contract where the liquidity provider enforces who, how
2349 ///        and even if their funds can be used to facilitate the fast withdrawals.
2350 ///
2351 ///        The liquidity provider can call `executeFastWithdrawals` to provide users
2352 ///        immediately with funds onchain. This allows the security of the funds to be handled
2353 ///        by any EOA or smart contract.
2354 ///
2355 ///        Users that want to make use of this functionality have to
2356 ///        authorize this contract as their agent.
2357 ///
2358 /// @author Brecht Devos - <brecht@loopring.org>
2359 /// @author Kongliang Zhong - <kongliang@loopring.org>
2360 /// @author Daniel Wang - <daniel@loopring.org>
2361 contract FastWithdrawalAgent is ReentrancyGuard, IAgent
2362 {
2363     using AddressUtil       for address;
2364     using AddressUtil       for address payable;
2365     using ERC20SafeTransfer for address;
2366     using MathUint          for uint;
2367 
2368     event Processed(
2369         address exchange,
2370         address from,
2371         address to,
2372         address token,
2373         uint96  amount,
2374         address provider,
2375         bool    success
2376     );
2377 
2378     struct Withdrawal
2379     {
2380         address exchange;
2381         address from;                   // The owner of the account
2382         address to;                     // The `to` address of the withdrawal
2383         address token;
2384         uint96  amount;
2385         uint32  storageID;
2386     }
2387 
2388     // This method needs to be called by any liquidity provider
2389     function executeFastWithdrawals(Withdrawal[] calldata withdrawals)
2390         public
2391         nonReentrant
2392         payable
2393     {
2394         // Do all fast withdrawals
2395         for (uint i = 0; i < withdrawals.length; i++) {
2396             executeInternal(withdrawals[i]);
2397         }
2398         // Return any ETH left into this contract
2399         // (can happen when more ETH is sent than needed for the fast withdrawals)
2400         msg.sender.sendETHAndVerify(address(this).balance, gasleft());
2401     }
2402 
2403     // -- Internal --
2404 
2405     function executeInternal(Withdrawal calldata withdrawal)
2406         internal
2407     {
2408         require(
2409             withdrawal.exchange != address(0) &&
2410             withdrawal.from != address(0) &&
2411             withdrawal.to != address(0) &&
2412             withdrawal.amount != 0,
2413             "INVALID_WITHDRAWAL"
2414         );
2415 
2416         // The liquidity provider always authorizes the fast withdrawal by being the direct caller
2417         address payable liquidityProvider = msg.sender;
2418 
2419         bool success;
2420         // Override the destination address of a withdrawal to the address of the liquidity provider
2421         try IExchangeV3(withdrawal.exchange).setWithdrawalRecipient(
2422             withdrawal.from,
2423             withdrawal.to,
2424             withdrawal.token,
2425             withdrawal.amount,
2426             withdrawal.storageID,
2427             liquidityProvider
2428         ) {
2429             // Transfer the tokens immediately to the requested address
2430             // using funds from the liquidity provider (`msg.sender`).
2431             transfer(
2432                 liquidityProvider,
2433                 withdrawal.to,
2434                 withdrawal.token,
2435                 withdrawal.amount
2436             );
2437             success = true;
2438         } catch {
2439             success = false;
2440         }
2441 
2442         emit Processed(
2443             withdrawal.exchange,
2444             withdrawal.from,
2445             withdrawal.to,
2446             withdrawal.token,
2447             withdrawal.amount,
2448             liquidityProvider,
2449             success
2450         );
2451     }
2452 
2453     function transfer(
2454         address from,
2455         address to,
2456         address token,
2457         uint    amount
2458         )
2459         internal
2460     {
2461         if (amount > 0) {
2462             if (token == address(0)) {
2463                 to.sendETHAndVerify(amount, gasleft()); // ETH
2464             } else {
2465                 token.safeTransferFromAndVerify(from, to, amount);  // ERC20 token
2466             }
2467         }
2468     }
2469 }